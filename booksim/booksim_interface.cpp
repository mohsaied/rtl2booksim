#include <iostream>
#include <list>
#include <queue>
#include <cstdio>
#include <cerrno>
#include "assert.h"
#include "netstream/socketstream.h"
#include "netstream/messages.h"

#include "dpi.h"

using namespace std;

/*****************SOCKET STREAM**************************/

int SocketStream::listen()
{
	const char *socket_path = "./socket";
    // Create a socket
	if ( (so = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
		cout << "Error creating socket." << endl;
		return -1;
	}

	memset(&addr, 0, sizeof(addr));
	addr.sun_family = AF_UNIX;
	strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path)-1);

	// Bind it to the listening port
	unlink(socket_path);
	if (bind(so, (struct sockaddr*)&addr, sizeof(addr)) != 0) {
		 cout << "Error binding socket." << endl;
		 return -1;
	}
	// Listen for connections
	if (::listen(so, NS_MAX_PENDING) != 0) {
		 cout << "Error listening on socket." << endl;
		 return -1;
	}
	bIsAlive = true;

#ifdef NS_DEBUG
	cout << "Listening on socket" << endl;
#endif

	return 0;
}

// accept a new connection
SocketStream* SocketStream::accept()
{
	struct sockaddr_un clientaddr;
	socklen_t clientaddrlen = sizeof clientaddr;
	int clientsock = ::accept(so, (struct sockaddr*)&clientaddr, &clientaddrlen);
	if ( clientsock < 0 ){
    	cout << "Error accepting a connection";
    	return NULL;
	}
	// prevent small packets from getting stuck in OS queues
	//int on = 1;
	//setsockopt (so, SOL_TCP, TCP_NODELAY, &on, sizeof (on));

	return new SocketStream(clientsock, (struct sockaddr*)&clientaddr, clientaddrlen);
}

int SocketStream::connect()
{
	const char *socket_path = "./socket";
	// Create a socket.
	if ( (so = socket(AF_UNIX, SOCK_STREAM, 0)) < 0 ){
		cout << "Error creating socket." << endl;
		return -1;
	}
	memset(&addr, 0, sizeof(addr));
	addr.sun_family = AF_UNIX;
	strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path)-1);

    // Connect to the server.
	if ( ::connect(so, (struct sockaddr*)&addr, sizeof(addr)) != 0) {
    	cout << "Connection failed." << endl;
        return -1;
	}

    // prevent small packets from getting stuck in OS queues
    //int on = 1;
    //setsockopt (so, SOL_TCP, TCP_NODELAY, &on, sizeof (on));

	bIsAlive = true;

#ifdef NS_DEBUG
	cout << "Connected to host" << endl;
#endif

	return 0;
}

// read from the socket
int SocketStream::get(void *data, int number)
{

    int remaining = number;
    int received = 0;
    char *dataRemaining = (char*) data;

    errno = 0;
    while (remaining > 0 && (errno == 0 || errno == EINTR))
    {
        received = recv(so, dataRemaining, remaining, 0); // MSG_WAITALL
        if (received > 0)
        {
            dataRemaining += received;
            remaining -= received;
        }
    }

    return number - remaining;
}

// write to socket
int SocketStream::put(const void *data, int number)
{
    // MSG_NOSIGNAL prevents SIGPIPE signal from being generated on failed send
    return send(so, data, number, MSG_NOSIGNAL);
}

/**********************************************************/

/*******************MESSAGE********************************/

SocketStream& operator<<(SocketStream& os, StreamMessage& msg)
{
#ifdef NS_DEBUG_EXTRA
    std::cout << "<MessageSend> Sending message: " << msg.type << ", size: " << msg.size << std::endl;
#endif

    // cork the connection
    int flag = 1;
    setsockopt (os.so, SOL_TCP, TCP_CORK, &flag, sizeof (flag));

    os.put(&(msg.size), sizeof(int));
    os.put(&msg, msg.size);

    // uncork the connection
    flag = 0;
    setsockopt (os.so, SOL_TCP, TCP_CORK, &flag, sizeof (flag));

    // os.flush();

    return os;
}

SocketStream& operator>>(SocketStream& is, StreamMessage*& msg)
{
#ifdef NS_DEBUG_EXTRA
    std::cout << "<MessageRecv> Waiting for message" << std::endl;
#endif

    int msgSize = -1;
    int gotBytes = is.get(&msgSize, sizeof(int));

    if (gotBytes != sizeof(int))
        return is;

    assert(msgSize > 0);

    msg = (StreamMessage*) malloc(msgSize);
    is.get(msg, msgSize);


#ifdef NS_DEBUG_EXTRA
    std::cout << "<MessageRecv> Got message: " << msg->type << std::endl;
#endif

    return is;
}

SocketStream& operator>>(SocketStream& is, StreamMessage& msg)
{
#ifdef NS_DEBUG_EXTRA
    std::cout << "<MessageRecvSync> Waiting for message" << std::endl;
#endif

    int msgSize = -1;
    int gotBytes = is.get(&msgSize, sizeof(int));

    if (gotBytes != sizeof(int))
        return is;
	//cout << msgSize << " - " << msg.size << endl;
    assert(msgSize == msg.size);
    is.get(&msg, msgSize);

#ifdef NS_DEBUG_EXTRA
    std::cout << "<MessageRecvSync> Got message: " << msg.type << std::endl;
#endif

    return is;
}

void StreamMessage::destroy(StreamMessage* msg)
{
    assert (msg != NULL);
    free(msg);
}

/**********************************************************/

/**********************Interface***************************/

SocketStream m_channel;

static unsigned long long cycle;

queue<InjectReqFlit> flit_queue;

void connectSocket() {
  // connect to network simulator
  assert(m_channel.connect() == 0);
  
  // send request to initialize
  InitializeReqMsg req;
  InitializeResMsg res;
  m_channel << req >> res;

}

void exitSocket() {
  // Notify network we are quitting
  QuitReqMsg req;
  QuitResMsg res;
  m_channel << req >> res;
}

//send flit over socket
void sendFlit(InjectReqFlit& req) {

  InjectResMsg res;
  m_channel << req >> res;
}

/*
 * Adds a flit to the flit queue
 * 'type' is supposed to say whether we're a head/tail/body
*/
void queueFlit(int pid, int fid, int source, int destination, int vc, int head, int tail) {
  InjectReqFlit flit;
  flit.pid = pid;
  flit.fid = fid; //flit id is its number in this packet
  flit.source = source;     // do we need source and 
  flit.dest = destination;  // destination for flits?
  flit.cl = 0;
  flit.network = 0;
  flit.msgType = 0;
  flit.coType = 0;
  flit.address = 0;
  flit.head = head;
  flit.tail = tail;
  flit.vc = vc;

  flit_queue.push(flit);
}


void nextCycle(int speedup) {

  for (int i=0; i<speedup; i++) {
    StepReqMsg req;
    StepResMsg res;
    m_channel << req >> res;
    //cout << "Step " << i << endl;
  }

}

void inject() {

  //inject all flits in our queue
  while (!flit_queue.empty()) {
    sendFlit(flit_queue.front());
    //cout << "Sent flit " << flit_queue.front().fid << "(" << flit_queue.front().pid << ")" << " from " << flit_queue.front().source << " to " << flit_queue.front().dest << endl;
    flit_queue.pop();
  }

}

// returns 1 if flits are left, else 0
int eject(int* id, int* vc) {
  
  EjectReqFlit req; //The request to the network
  EjectResFlit res; //The response from the network

  int hasRequests = 0;

  m_channel << req >> res;

  //return the flit id
  *id = res.fid;
  *vc = res.vc;
  
  //if (res.pid >= 0)
    //cout << "Received flit " << res.fid << "(" << res.pid << ") from " << res.source << " to " << res.dest << endl;

  //Check if there are more messages from the network
  if (res.remainingRequests) hasRequests = 1;

  return hasRequests;
  
}

int receive_credit(int node, int vc){
	
	CreditUpReqMsg req;
	CreditUpResMsg res;

	req.node = node;
	req.subnet = 0;
	req.vc = vc;

	m_channel << req >> res;

	return (int)res.credit;
}

void send_credit(int node, int vc, int credit)
{
	CreditDownReqMsg req;
	CreditDownResMsg res;

	req.node = node;
	req.subnet = 0; //we dont support subnets (yet)
	req.vc = vc;
	req.credit = credit;

	m_channel << req >> res;
}


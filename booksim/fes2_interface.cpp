/*
 * FeS2Interface1.cpp
 *
 *  Created on: Apr 10, 2010
 *      Author: robert
 *  
 *  Modified on: Aug 19, 2014
 *	Author: mohamed
 */

#include <sstream>

#include "fes2_interface.hpp"

FeS2Interface::FeS2Interface( const Configuration &config,
		const vector<Network *> & net) {

  	//of.open("/home/andrew/booksim2-master/src/fes2.out");
  	of.open("fes2.out");

	_trace_mode = config.GetInt("trace_mode");

	if (_trace_mode == 1) {
		_trace = new TraceGenerator();

		string trace_file_name;
		trace_file_name = config.GetStr("trace_file");

		if (!_trace->openTraceFile( trace_file_name )) {
			cerr << "Trace file cannot be opened: " << trace_file_name << endl;
		}
	}

	_channel = NULL;

	_sources = net[0]->NumNodes( );
	_dests   = net[0]->NumNodes( );

	_duplicate_networks = config.GetInt("subnets");

	_concentrate = config.GetInt("fes2_concentrate") ? true : false;

	_host = config.GetStr( "fes2_host");
	_port = config.GetInt("fes2_port");

	_vcs = config.GetInt("num_vcs");
	_subnets = config.GetInt("subnets");
	_nodes = _sources;
	
	vector<int> mapping = config.GetIntArray("fes2_mapping");
	for(unsigned int i = 0; i < mapping.size(); i++) {
		_node_map[i] = mapping[i];
	}

	//initialize _request_buffer_flit
	_request_buffer_flit = new queue<FeS2RequestFlit *> * [_duplicate_networks];
	for(int i=0; i < _duplicate_networks; i++){
		_request_buffer_flit[i] = new queue<FeS2RequestFlit *> [_sources];
	}

	//resize the _credits_* nested vectors
	_credits_from_noc_to_rtl.resize(_nodes);
	_credits_from_rtl_to_noc.resize(_nodes);
	for(int i = 0; i < _nodes; i++){
		_credits_from_noc_to_rtl[i].resize(_subnets);
		_credits_from_rtl_to_noc[i].resize(_subnets);
	}
	for(int i = 0; i < _nodes; i++)
		for(int j = 0; j < _subnets; j++){
			_credits_from_noc_to_rtl[i][j].resize(_vcs);
			_credits_from_rtl_to_noc[i][j].resize(_vcs);
	}

	//initialize current credits (we start with no credits buffered)
	for(int i = 0; i < _nodes; i++)
		for(int j = 0; j < _subnets; j++)
			for(int k = 0; k < _vcs; k++){
				_credits_from_noc_to_rtl[i][j][k] = false;
				_credits_from_rtl_to_noc[i][j][k] = false;
			}
}

FeS2Interface::~FeS2Interface() {
	if (_trace_mode == 1) {
		_trace->closeTraceFile();
	}

	//delete flit queues in deconstructor
	for ( int n = 0; n < _duplicate_networks; n++ ){
		delete [] _request_buffer_flit[n];
	}
	delete [] _request_buffer_flit;
}

int FeS2Interface::Init() {
	// Start listening for incoming connections

	// TODO Configurable host/port
	// if (_listenSocket.listen(_host.c_str(), _port) < 0)

	// constants available in both BookSim and FeS2
	if (_listenSocket.listen() < 0) {
		return -1;
	}

	// Wait for FeS2 to connect
	_channel = _listenSocket.accept();
#ifdef NS_DEBUG
	cout << "FeS2 instance connected" << endl;
#endif
	// Initialize client
	InitializeReqMsg req;
	InitializeResMsg res;
	*_channel >> req << res;

	return 0;
}

int FeS2Interface::Step() {
	bool process_more = true;
	StreamMessage *msg = NULL;

	while (process_more && _channel && _channel->isAlive())
	{
		// read message
		*_channel >> (StreamMessage*&) msg;


		switch(msg->type)
		{
		case STEP_REQ:
		{
			// acknowledge the receipt of step request
			// we're actually doing a little bit of work in parallel
			StepResMsg res;
			*_channel << res;

			// fall-through and perform one step of BookSim loop
			process_more = false;

			break;
		}	
		case INJECT_REQ_FLIT:
		{
			//type-cast received message into InjectReqFlit
			InjectReqFlit* req = (InjectReqFlit*) msg;
			
			//create a flit and store in local queue
			FeS2RequestFlit* rf = new FeS2RequestFlit();
			rf->cl = req->cl;
			rf->dest = req->dest;
			rf->pid = req->pid;
			rf->fid = req->fid;
			rf->head = req->head;
			rf->body = req->body;
			rf->tail = req->tail;
			rf->network = req->network;
			rf->source = req->source;
			rf->miss_pred = req->miss_pred;
			rf->vc = req->vc;

			if (_trace_mode == 1) {
				//_trace->writeTraceItem(GetSimTime(), rp->source, rp->dest,
				//		rp->size, req->address, rp->network);
				stringstream str;

				str << rf->pid << " (" << rf->fid << ") " << GetSimTime() << " " << rf->source << " "
						<< rf->dest << " " << req->msgType
						<< " " << req->coType << " " << req->address;

				_trace->writeTrace(str.str());
			}

			of << "Enqueued flit " << rf->pid << " (" << rf->fid << ") " << " from " << rf->source << " to " << rf->dest << endl;

			EnqueueFeS2RequestFlit(rf);

			// acknowledge receipt of packet to FeS2
			InjectResMsg res;
			*_channel << res;

			break;
		}
		case EJECT_REQ_FLIT:
		{
			//EjectReqFlit* req = (EjectReqFlit*) msg;
			EjectResFlit res;
			// create packet to store in local queue
			FeS2ReplyFlit* rf = DequeueFeS2ReplyFlit();

			if (rf != NULL)
			{
				res.source = rf->source;
				res.dest = rf->dest;
				res.network = rf->network;
				res.pid = rf->pid;
				res.fid = rf->fid;
				res.cl = rf->cl;
				res.miss_pred = rf->miss_pred;
				res.head = rf->head;
				res.tail = rf->tail;
				res.body = rf->body;
				res.vc = rf->vc;
				
				// free up reply packet
				free(rf);
				rf = NULL;
			}
			else
			{
				res.pid = -1;
				res.fid = -1;
			}

			res.remainingRequests = getFeS2ReplyQueueSize();

			*_channel << res;

			break;
		}
		case CREDITS_UP_REQ:
		{
			CreditUpReqMsg* req = (CreditUpReqMsg*) msg;
			CreditUpResMsg res;
			
			//do we have a credit to send back for this node,subnet,vc?
			bool current_credit = DequeueCreditFromNoc(req->node,req->subnet,req->vc);

#ifdef DEBUG_CREDITS
			if(current_credit)
				cout << GetSimTime() << "| sending credit to RTL on node " << req->node << " and vc " << req->vc << endl;
#endif

			res.credit = current_credit;

			*_channel << res;

			break;
		}
		case CREDITS_DOWN_REQ:
		{
			CreditDownReqMsg* req = (CreditDownReqMsg*) msg;
			CreditDownResMsg res;
			
			//do we have a credit to send back for this node,subnet,vc?
			bool current_credit = req->credit;
			
			EnqueueCreditFromRtl(req->node,req->subnet,req->vc,current_credit);

#ifdef DEBUG_CREDITS
			if(current_credit)
				cout << GetSimTime() << "| sending credit to NoC on node " << req->node << " and vc " << req->vc << endl;
#endif
			
			*_channel << res;

			break;
		}
		case QUIT_REQ:
		{
			// acknowledge quit
			QuitResMsg res;
			*_channel << res;
			
			cout << "*** Received Quit Message ***" << endl;

			return 1; // signal that we're done

			break;
		}
		default:
		{
			cout << "<FeS2Interface::Step> Unknown message type: "
					<< msg->type << endl;
			break;
		}
		} // end switch

		// done processing message, destroy it
		StreamMessage::destroy(msg);
	}

	return 0;
}

void FeS2Interface::EnqueueCreditFromRtl(int node, int subnet, int vc, bool credit){
	//we must read the credits every cycle or this assertion fails
	assert(!_credits_from_rtl_to_noc[node][subnet][vc]);
	_credits_from_rtl_to_noc[node][subnet][vc] = credit;
}

bool FeS2Interface::DequeueCreditFromRtl(int node, int subnet, int vc){
	bool credit = _credits_from_rtl_to_noc[node][subnet][vc];
	if(credit)
		_credits_from_rtl_to_noc[node][subnet][vc] = false;
	return credit;
}

void FeS2Interface::EnqueueCreditFromNoc(int node, int subnet, int vc){
	//we must read the credits every cycle or this assertion fails
	assert(!_credits_from_noc_to_rtl[node][subnet][vc]);
	_credits_from_noc_to_rtl[node][subnet][vc] = true;
}

bool FeS2Interface::DequeueCreditFromNoc(int node, int subnet, int vc){
	bool credit = _credits_from_noc_to_rtl[node][subnet][vc];
	if(credit)
		_credits_from_noc_to_rtl[node][subnet][vc] = false;
	return credit;
}

int FeS2Interface::EnqueueFeS2RequestFlit(FeS2RequestFlit *flit) {
	//The mapping of FeS2 devices to BookSim nodes is done here

	// We always need to store the original destination send it to the correct
	// FeS2 queue
	_original_destinations[flit->pid] = flit->dest;

	//_node_map is based off of the configuration file. See "fes2_mapping"
	//packet->source 	= _node_map[packet->source];
	//packet->dest 	= _node_map[packet->dest];

	// special case: single network
	if (_duplicate_networks == 1) {
		_request_buffer_flit[0][flit->source].push(flit);
	} else {
		assert (flit->network < _duplicate_networks);
		_request_buffer_flit[flit->network][flit->source].push(flit);
	}
	return 0;
}

FeS2RequestFlit *FeS2Interface::DequeueFeS2RequestFlit(int source,
		int network, int cl) {
	FeS2RequestFlit *flit = NULL;

	if (!_request_buffer_flit[network][source].empty()) {
		flit = _request_buffer_flit[network][source].front();
		if (flit->cl == cl) {
			_request_buffer_flit[network][source].pop();
		} else {
			flit = 0;
		}
	}

	return flit;
}

int FeS2Interface::EnqueueFeS2ReplyFlit(FeS2ReplyFlit *flit) {

	assert(_original_destinations.find(flit->pid) !=
			_original_destinations.end());

	if (_concentrate) {
		assert(_original_destinations.find(flit->pid) !=
				_original_destinations.end());
		assert(_original_destinations[flit->pid]/2 == flit->dest);
		flit->source *= 2;
	}

	flit->dest = _original_destinations[flit->pid];
	if(flit->tail)
		_original_destinations.erase(flit->pid);

	_reply_buffer_flit.push(flit);

	return 0;
}

FeS2ReplyFlit *FeS2Interface::DequeueFeS2ReplyFlit() {
	FeS2ReplyFlit *flit = NULL;

	if (!_reply_buffer_flit.empty()) {
		flit = _reply_buffer_flit.front();
		_reply_buffer_flit.pop();
	}

	return flit;
}

int FeS2Interface::GenerateTestPackets() {
	return 0;
}

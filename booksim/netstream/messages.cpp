/* 
Copyright (c) 2014, Mario Badr
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/*
 * message.cpp
 *
 *  Created on: Dec 13, 2009
 *      Author: sam
 */

#include "messages.h"
#include <cassert>
#include <cstdlib>

using namespace std;

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


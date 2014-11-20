/* 
Copyright (c) 2014, Mario Badr
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/*
 * socketstream.h
 *
 *  Created on: Dec 14, 2009
 *      Author: sam
 */

#ifndef SOCKETSTREAM_H_
#define SOCKETSTREAM_H_

#include <iostream>

#include <unistd.h>
#include <sys/types.h>
#include <sys/un.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/tcp.h>

#include <cstring>

#define NS_DEBUG
#define NS_MAX_PENDING 1

using namespace std;

class SocketStream
{
public:
	int so; // the socket
	struct sockaddr_un addr;
	bool bIsAlive;

public:

	SocketStream() : so(-1), bIsAlive(false)
	{
	}

	// create from an existing socket
	SocketStream(int sock) : so(sock), bIsAlive(true)
	{
	}

	~SocketStream()
	{
		if (so != -1)
		{
			close(so);
		}
	}

	SocketStream(int sock, struct sockaddr *in_addr, socklen_t in_addrlen)
	{
		so = sock;
		bIsAlive = true;
		memcpy(&addr, in_addr, in_addrlen);
	}

	int listen();

	SocketStream* accept();

	int connect();

    // read from the socket
    int get(void *data, int number);

    // write to socket
    int put(const void *data, int number);

	bool isAlive()
	{
		return bIsAlive;
	}

};

#endif /* SOCKETSTREAM_H_ */

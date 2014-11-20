/*
 * messages.h
 *
 *  Created on: Dec 13, 2009
 *      Author: sam
 */

#ifndef MESSAGES_H_
#define MESSAGES_H_

#include "socketstream.h"
#include <stdint.h>

#define INVALID_MESSAGE -1
#define INITIALIZE_REQ  0
#define INITIALIZE_RES  1
#define STEP_REQ	2
#define STEP_RES  	3
#define INJECT_REQ_FLIT	4
#define INJECT_REQ 10
#define INJECT_RES  	5
#define EJECT_REQ_FLIT 6
#define EJECT_RES_FLIT 7
#define CREDITS_UP_REQ 	11
#define CREDITS_UP_RES 	12
#define CREDITS_DOWN_REQ 13
#define CREDITS_DOWN_RES 14
#define QUIT_REQ  	8
#define QUIT_RES  	9

struct StreamMessage
{
    int size;
    int type;
    StreamMessage() :
        size(-1), type(INVALID_MESSAGE)
    {
    }

    /*
     * Message sending function.
     */
    friend SocketStream& operator<<(SocketStream& os, StreamMessage& msg);

    /*
     * Message receiving function. Use this function if you don't know the message type in advance
     * NOTE: must destroy msg using Message::destroy(Message*)
     */
    friend SocketStream& operator>>(SocketStream& is, StreamMessage*& msg);

    /*
     * Message receiving function. Use this function if you know the message type in advance
     */
    friend SocketStream& operator>>(SocketStream& is, StreamMessage& msg);

    static void destroy(StreamMessage* msg);
};

struct InitializeReqMsg: StreamMessage
{
    InitializeReqMsg()
    {
        size = sizeof(InitializeReqMsg);
        type = INITIALIZE_REQ;
    }
};

struct InitializeResMsg: StreamMessage
{
    InitializeResMsg()
    {
        size = sizeof(InitializeResMsg);
        type = INITIALIZE_RES;
    }
};

struct StepReqMsg: StreamMessage
{
	StepReqMsg()
    {
        size = sizeof(StepReqMsg);
        type = STEP_REQ;
    }
};

struct StepResMsg: StreamMessage
{
	StepResMsg()
    {
        size = sizeof(StepResMsg);
        type = STEP_RES;
    }
};

struct InjectReqFlit: StreamMessage
{
	InjectReqFlit()
    {
        size = sizeof(InjectReqFlit);
        type = INJECT_REQ_FLIT;
    }
	int source;
	int dest;
	int pid;
	int fid;
	bool head;
	bool body; 
	bool tail;
	int network;
	int cl;
	int miss_pred;
	int msgType;
	int coType;
	unsigned long long address;
	int vc;
};


struct InjectReqMsg: StreamMessage
{
	InjectReqMsg()
	{
	    size = sizeof(InjectReqMsg);
	    type = INJECT_REQ;
	}
	int source;
	int dest;
	int id;
	int packetSize;
	int network;
	int cl;
	int miss_pred;
	int msgType;
	int coType;
	unsigned long long address;
};

struct InjectResMsg: StreamMessage
{
	InjectResMsg()
    {
        size = sizeof(InjectResMsg);
        type = INJECT_RES;
    }
};

struct EjectReqFlit: StreamMessage
{
	EjectReqFlit()
    {
        size = sizeof(EjectReqFlit);
        type = EJECT_REQ_FLIT;
    }
};

struct EjectResFlit: StreamMessage
{
	EjectResFlit()
    {
        size = sizeof(EjectResFlit);
        type = EJECT_RES_FLIT;
    }
	int pid;
	int fid;
	bool head;
	bool body;
	bool tail;
	int remainingRequests;
	int source;
	int dest;
	int packetSize;
	int network;
	int cl;
	int miss_pred;
	int vc;

};

struct CreditUpReqMsg: StreamMessage
{
	CreditUpReqMsg()
    {
        size = sizeof(CreditUpReqMsg);
        type = CREDITS_UP_REQ;
    }
	int node;
	int subnet;
	int vc;
};

struct CreditUpResMsg: StreamMessage
{
	CreditUpResMsg()
    {
        size = sizeof(CreditUpResMsg);
        type = CREDITS_UP_RES;
    }
	bool credit;
};


struct CreditDownReqMsg: StreamMessage
{
	CreditDownReqMsg()
    {
        size = sizeof(CreditDownReqMsg);
        type = CREDITS_DOWN_REQ;
    }
	int node;
	int subnet;
	int vc;
	bool credit;
};

struct CreditDownResMsg: StreamMessage
{
	CreditDownResMsg()
    {
        size = sizeof(CreditDownResMsg);
        type = CREDITS_DOWN_RES;
    }
};

struct QuitReqMsg: StreamMessage
{
	QuitReqMsg()
    {
        size = sizeof(QuitReqMsg);
        type = QUIT_REQ;
    }
};

struct QuitResMsg: StreamMessage
{
	QuitResMsg()
    {
        size = sizeof(QuitResMsg);
        type = QUIT_RES;
    }
};

#endif /* MESSAGES_H_ */

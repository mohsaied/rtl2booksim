/*
 * fes2_interface.hpp
 *
 *  Created on: Apr 10, 2010
 *      Author: robert
 */

#ifndef FES2_INTERFACE_HPP_
#define FES2_INTERFACE_HPP_

//#define FES2_INTERFACE_ACTIVE

#include "module.hpp"
#include "config_utils.hpp"
#include "network.hpp"
#include "netstream/socketstream.h"
#include "netstream/messages.h"
#include "trace_generator.hpp"


#include <queue>
#include <map>
#include <vector>
#include <fstream>


struct FeS2RequestFlit {
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
	int vc;
};

struct FeS2ReplyFlit {
	int source;
	int dest;
	int pid;
	int fid;
	bool head;
	bool tail;
	bool body;
	int network;
	int cl;
	int miss_pred;
	int vc;
};


class FeS2Interface {

private:
	queue<FeS2RequestFlit *> **_request_buffer_flit;
	queue<FeS2ReplyFlit *> _reply_buffer_flit;

	map<int, int> _original_destinations;

	TraceGenerator *_trace;

	int _trace_mode;

	int _sources;
	int _dests;

	int _duplicate_networks;

	bool _concentrate;

	SocketStream _listenSocket;
	SocketStream *_channel;
	string _host;
	int _port;

	map<int, int> _node_map;

  	ofstream of;

	//3d vector to hold credits from NoC to module
	vector< vector< vector <bool > > > _credits_from_noc_to_rtl;

	//3d vector to hold credits from modules to NoC
	vector< vector< vector <bool > > > _credits_from_rtl_to_noc;
	
	int _vcs;
	int _subnets;
	int _nodes;

public:
	FeS2Interface( const Configuration &config, const vector<Network *> & net );
	~FeS2Interface();

	int Init();
	int Step();

	int EnqueueFeS2RequestFlit(FeS2RequestFlit *flit);
	FeS2RequestFlit *DequeueFeS2RequestFlit(int source, int network, int cl);

	int getFeS2ReplyQueueSize() { return _reply_buffer_flit.size(); }
	int EnqueueFeS2ReplyFlit(FeS2ReplyFlit *flit);
	FeS2ReplyFlit *DequeueFeS2ReplyFlit();


	void EnqueueCreditFromNoc(int node, int subnet, int vc);
	bool DequeueCreditFromNoc(int node, int subnet, int vc);
	
	void EnqueueCreditFromRtl(int node, int subnet, int vc, bool credit);
	bool DequeueCreditFromRtl(int node, int subnet, int vc);

	int GenerateTestPackets();

};

#endif /* FES2_INTERFACE_HPP_ */

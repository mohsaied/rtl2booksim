/*
 * trace_generator.cpp
 *
 *  Created on: Aug 9, 2010
 *      Author: Robert
 */

#include "trace_generator.hpp"

TraceGenerator::TraceGenerator() {
	_last_line[0] = 0;
}

TraceGenerator::~TraceGenerator() {
}


int TraceGenerator::openTraceFile(const string& filename) {
	_trace_file.open (filename.c_str(), fstream::out);
	return _trace_file.is_open();
}

void TraceGenerator::closeTraceFile() {
	if (_trace_file.is_open()) {
		_trace_file.close();
	}

}


int TraceGenerator::writeTraceItem(int timestamp, int src, int dest, int size,
		unsigned long long address, int network) {

	if (_trace_file.is_open()) {
		_trace_file << timestamp << " " << src << " " << dest << " " << size
				<< " " << hex << address << dec << "\n";

		return 0;
	}

	return 1;
}

int TraceGenerator::writeTrace(string str) {

	if(_trace_file.is_open()) {
		_trace_file << str << endl;

		return 0;
	}

	return 1;
}


int TraceGenerator::readTraceItem(int timestamp, int* src, int* dest,
		int* size) {

	int current_timestamp = 0;
	char line[256];

	if (_trace_file.is_open()) {
		if (_last_line[0] == 0) {
			_trace_file.getline (_last_line, 256);
		}


		if (_trace_file.eof()) {

			return 2; //EOF
		}

		sscanf (_last_line, "%d %d %d %d", &current_timestamp, src, dest, size);

		if (current_timestamp == timestamp) {
			//found a trace entry for given timestamp
			_last_line[0] = 0;
			return 1;
		}
	}

	return 0; // could not find a trace entry for given timestamp
}

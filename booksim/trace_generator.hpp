/*
 * trace_generator.hpp
 *
 *  Created on: Aug 9, 2010
 *      Author: Robert
 */

#ifndef TRACE_GENERATOR_HPP_
#define TRACE_GENERATOR_HPP_

#include <iostream>
#include <fstream>
#include "module.hpp"
#include <stdio.h>
#include <stdint.h>
#include <string>

class TraceGenerator {
public:
	TraceGenerator();
	~TraceGenerator();

	int openTraceFile(const string& filename);
	void closeTraceFile();
	int writeTraceItem(int timestamp, int src, int dest, int size,
			unsigned long long address, int network);
	int readTraceItem(int timestamp, int* src, int* dest, int* size);

	int writeTrace(std::string str);

protected:

	fstream _trace_file;
	char _last_line[256];

};

#endif /* TRACE_GENERATOR_HPP_ */

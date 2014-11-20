// $Id$

/*
 Copyright (c) 2007-2012, Trustees of The Leland Stanford Junior University
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <iostream>
#include <vector>
#include <cassert>
#include <limits>
#include "random_utils.hpp"
#include "injection.hpp"

using namespace std;

InjectionProcess::InjectionProcess(int nodes, double rate)
  : _nodes(nodes), _rate(rate)
{
  if(nodes <= 0) {
    cout << "Error: Number of nodes must be greater than zero." << endl;
    exit(-1);
  }
  if((rate < 0.0) || (rate > 1.0)) {
    cout << "Error: Injection process must have load between 0.0 and 1.0."
	 << endl;
    exit(-1);
  }
}

void InjectionProcess::reset()
{

}

InjectionProcess * InjectionProcess::New(string const & inject, int nodes, 
					 double load, 
					 Configuration const * const config,
					 string injection_nodes_str)
{
  string process_name;
  string param_str;
  size_t left = inject.find_first_of('(');
  if(left == string::npos) {
    process_name = inject;
  } else {
    process_name = inject.substr(0, left);
    size_t right = inject.find_last_of(')');
    if(right == string::npos) {
      param_str = inject.substr(left+1);
    } else {
      param_str = inject.substr(left+1, right-left-1);
    }
  }
  vector<string> params = tokenize_str(param_str);

  InjectionProcess * result = NULL;
  if(process_name == "bernoulli") {
    result = new BernoulliInjectionProcess(nodes, load, injection_nodes_str);
  } else if (process_name == "self_similar") {

    result = new SelfSimilarInjectionProcess(nodes, load);

  }  else if(process_name == "on_off") {
    bool missing_params = false;
    double alpha = numeric_limits<double>::quiet_NaN();
    if(params.size() < 1) {
      if(config) {
	alpha = config->GetFloat("burst_alpha");
      } else {
	missing_params = true;
      }
    } else {
      alpha = atof(params[0].c_str());
    }
    double beta = numeric_limits<double>::quiet_NaN();
    if(params.size() < 2) {
      if(config) {
	beta = config->GetFloat("burst_beta");
      } else {
	missing_params = true;
      }
    } else {
      beta = atof(params[1].c_str());
    }
    double r1 = numeric_limits<double>::quiet_NaN();
    if(params.size() < 3) {
      r1 = config ? config->GetFloat("burst_r1") : -1.0;
    } else {
      r1 = atof(params[2].c_str());
    }
    if(missing_params) {
      cout << "Missing parameters for injection process: " << inject << endl;
      exit(-1);
    }
    if((alpha < 0.0 && beta < 0.0) || 
       (alpha < 0.0 && r1 < 0.0) || 
       (beta < 0.0 && r1 < 0.0) || 
       (alpha >= 0.0 && beta >= 0.0 && r1 >= 0.0)) {
      cout << "Invalid parameters for injection process: " << inject << endl;
      exit(-1);
    }
    vector<int> initial(nodes);
    if(params.size() > 3) {
      initial = tokenize_int(params[2]);
      initial.resize(nodes, initial.back());
    } else {
      for(int n = 0; n < nodes; ++n) {
	initial[n] = RandomInt(1);
      }
    }
    result = new OnOffInjectionProcess(nodes, load, alpha, beta, r1, initial);
  } else {
    cout << "Invalid injection process: " << inject << endl;
    exit(-1);
  }
  return result;
}

//=============================================================

BernoulliInjectionProcess::BernoulliInjectionProcess(int nodes, double rate, string injection_nodes_str)
  : InjectionProcess(nodes, rate)
{
  if(injection_nodes_str.empty()) {
    for (int i=0; i<nodes; i++) _injection_nodes.push_back(i);
  } else {
    _injection_nodes = tokenize_int(injection_nodes_str);
  }
}

bool BernoulliInjectionProcess::test(int source)
{
  assert((source >= 0) && (source < _nodes));

  /*
  if (source == 4 ||
      source == 5 ||
      source == 6 ||
      source == 7) {
    return (RandomFloat() < _rate);
  }
  else
    return 0;
  */

  /*
  if (source == 1 ||
      source == 3 ||
      source == 4 ||
      source == 6 ||
      source == 15 ||
      source == 31 ||
      source == 39 ||
      source == 55 ||
      source == 62 ||
      source == 60 ||
      source == 59 ||
      source == 57 ||
      source == 48 ||
      source == 32 ||
      source == 24 ||
      source == 8) {
    return (RandomFloat() < _rate);
  }
  else
    return 0;
  */

  
  // diamond
  /*
  if (source == 3 ||
      source == 4 ||
      source == 13 ||
      source == 22 ||
      source == 31 ||
      source == 39 ||
      source == 46 ||
      source == 53 ||
      source == 60 ||
      source == 59 ||
      source == 50 ||
      source == 41 ||
      source == 32 ||
      source == 24 ||
      source == 17 ||
      source == 10) {
    return (RandomFloat() < _rate);
  }
  else
    return 0;
  */

  
  // 4x4 dense mesh
  /*
  if (source == 18 ||
      source == 19 ||
      source == 20 ||
      source == 21 ||
      source == 26 ||
      source == 27 ||
      source == 28 ||
      source == 29 ||
      source == 34 ||
      source == 35 ||
      source == 36 ||
      source == 37 ||
      source == 42 ||
      source == 43 ||
      source == 44 ||
      source == 45) 
    {
      return (RandomFloat() < _rate);
    }
  else
    return 0;
  */


  //return (source <= 7 || source >= 56) ? (RandomFloat() < _rate) : 0;
  //return (source >= 24 && source <= 39) ? (RandomFloat() < _rate) : 0;

  //return (source <= 3 || source >= 12) ? (RandomFloat() < _rate) : 0;
  //return (source >= 4 && source <= 11) ? (RandomFloat() < _rate) : 0;

  //int d[16] = {18,19,20,21,26,27,28,29,34,35,36,37,42,43,44,45};

  /*
  for (int i=0; i<16; i++) {
    if (source == d[i]) return RandomFloat() < _rate;
  }
  return 0;
  */

  vector<int>::iterator it;

  for (it = _injection_nodes.begin(); it != _injection_nodes.end(); ++it) {
    if (source == (*it)) return RandomFloat() < _rate;
  }
  return 0;

  //return RandomFloat() < _rate;
}

//=============================================================

OnOffInjectionProcess::OnOffInjectionProcess(int nodes, double rate, 
					     double alpha, double beta, 
					     double r1, vector<int> initial)
  : InjectionProcess(nodes, rate), 
    _alpha(alpha), _beta(beta), _r1(r1), _initial(initial)
{
  assert(alpha <= 1.0);
  assert(beta <= 1.0);
  assert(r1 <= 1.0);
  if(alpha < 0.0) {
    assert(beta >= 0.0);
    assert(r1 >= 0.0);
    _alpha = beta * rate / (r1 - rate);
  } else if(beta < 0.0) {
    assert(alpha >= 0.0);
    assert(r1 >= 0.0);
    _beta = alpha * (r1 - rate) / rate;
  } else {
    assert(r1 < 0.0);
    _r1 = rate * (alpha + beta) / alpha;
  }
  reset();
}

void OnOffInjectionProcess::reset()
{
  _state = _initial;
}

bool OnOffInjectionProcess::test(int source)
{
  assert((source >= 0) && (source < _nodes));

  // // advance state
  // _state[source] = 
  //   _state[source] ? (RandomFloat() >= _beta) : (RandomFloat() < _alpha);

  // // generate packet
  // return _state[source] && (RandomFloat() < _r1);

  /*
  // diamond
  if (source == 3 ||
      source == 4 ||
      source == 13 ||
      source == 22 ||
      source == 31 ||
      source == 39 ||
      source == 46 ||
      source == 53 ||
      source == 60 ||
      source == 59 ||
      source == 50 ||
      source == 41 ||
      source == 32 ||
      source == 24 ||
      source == 17 ||
      source == 10) {
    // advance state
    _state[source] = 
      _state[source] ? (RandomFloat() >= _beta) : (RandomFloat() < _alpha);
    
    // generate packet
    return _state[source] && (RandomFloat() < _r1);
    
  }
  else
    return 0;
  */

  if (source <= 7 || source >= 56) {
    // advance state
    _state[source] = 
      _state[source] ? (RandomFloat() >= _beta) : (RandomFloat() < _alpha);
    
    // generate packet
    return _state[source] && (RandomFloat() < _r1);
  }
  else
    return 0;

}

//=============================================================

SelfSimilarInjectionProcess::SelfSimilarInjectionProcess(int nodes, double rate)
  : InjectionProcess(nodes, rate)
{

}

bool SelfSimilarInjectionProcess::test(int source)
{
  assert((source >= 0) && (source < _nodes));

  

  return 0;
}

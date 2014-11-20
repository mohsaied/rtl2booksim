/*
 * function : connect booksim noc to verilog
 * authors  : Andrew Bitar and Mohamed S. Abdelfattah
 * date     : 15-AUG-2014
 */


module rtl_interface #
(
	parameter WIDTH = 128, 
	parameter N = 16,
	parameter NUM_VC = 2,
	parameter STORAGE = 16,
	parameter NUM_CYCLES = 100000,
	parameter CLOCK_SPEEDUP = 1,
	parameter VERBOSE = 1
)
(
	input clk,
	input reset,
	
	//data
	input [WIDTH-1:0] i_flit_in [0:N-1],
	output logic [WIDTH-1:0] o_flit_out [0:N-1],
	
	//credits -- should binary encode this
	//but leave parallel for now
	//it's not like we'll use so many VCs
	//and it's equivalent for 2 VCs
	input  [NUM_VC-1:0] credits_to_noc [0:N-1],
	output logic [NUM_VC-1:0] credits_to_rtl [0:N-1]
);

import "DPI-C" function void connectSocket();
import "DPI-C" function void exitSocket();
import "DPI-C" function void nextCycle(input int speedup);
import "DPI-C" function void inject();
import "DPI-C" function void queueFlit(input int pid, input int fid, input int source, input int destination, input int vc, input int head, input int tail);
import "DPI-C" function int  eject(output int id, output int vc);
import "DPI-C" function int  receive_credit(input int node, input int vc);
import "DPI-C" function void send_credit(input int node, input int vc, input int credit);

//local parameters
localparam ADDRESS_WIDTH = $clog2(N);
localparam VC_ADDRESS_WIDTH = $clog2(NUM_VC);
localparam VALID_POS = WIDTH-1;
localparam HEAD_POS = WIDTH-2;
localparam TAIL_POS = WIDTH-3;
localparam VC_POS = WIDTH-4;
localparam DEST_POS = WIDTH-4-VC_ADDRESS_WIDTH;

longint unsigned p_id [0:N-1];
longint unsigned next_p_id;
longint unsigned f_id;
int     unsigned head;
int     unsigned tail;
int     unsigned valid;
int     unsigned src;
int     unsigned dest;
int              assigned_vc;
int     unsigned i;
int     unsigned j;
int     unsigned k;
longint unsigned cycle_count;

int unsigned received_id;
int unsigned received_vc;
int unsigned flits_left;
int unsigned out_port; 

typedef struct    {
	bit 		valid; 
	longint		unsigned p_id;
	longint		unsigned f_id;
	int 		unsigned dest;
	logic [WIDTH-1:0] data;
} data_entry;

data_entry data_set [0:2**STORAGE-1];

logic [4:0] dest_table [0:N-1];

//connect socket at the begining
initial begin
	next_p_id = 0;
	for(i=0;i<N;i++)
		p_id[i] = 0;
	f_id = 0;
	cycle_count = 0;
	connectSocket();
end

//exit socket at the end
final begin
	exitSocket();
end


//main routine: inject packets, receive flits and check
always @(posedge clk or posedge reset) begin

	if (reset) begin
		f_id = 0;
		cycle_count = 0;
		exitSocket();
		connectSocket();
	end else begin
		
		//--------------------------------------
		// generate flits to inject this cycle   
		//--------------------------------------
		
		for (i=0; i<N; i=i+1) begin    

			//extract valid, head and tail bits
			valid = i_flit_in[i][VALID_POS];
			
			if (valid) begin
				src = i;
				head  = i_flit_in[i][HEAD_POS];
				tail  = i_flit_in[i][TAIL_POS];
				assigned_vc = i_flit_in[i][VC_POS -: VC_ADDRESS_WIDTH];
				
				//extract destination if we are the head
				//and store it in a table
				//otherwise lookup that table for body/tail
				if (head) begin
					dest = i_flit_in[i][DEST_POS -: ADDRESS_WIDTH];
					dest_table[i] = dest;
				end else begin
					dest = dest_table[i];
				end
				
				//need find next packet id
				if(head)
				begin
					p_id[i] = next_p_id;
					next_p_id = next_p_id+1;
				end

				//insert this flit into the network
				queueFlit(p_id[i],f_id,src,dest,assigned_vc,head,tail);

				if (VERBOSE == 1)
					$display("Sending flit %d (%d) head = %d, tail = %d, from node %d on VC %d to node %d, (cycle = %d)",f_id,p_id[i],head,tail,i,assigned_vc,dest,cycle_count);
				
				// Store data
				for (j=0; j<2**STORAGE; j=j+1) begin
					if (data_set[j].valid == 1'b0) begin
						data_set[j].p_id = p_id[i];
						data_set[j].f_id = f_id;
						data_set[j].valid = 1'b1;
						data_set[j].dest = dest;
						data_set[j].data = i_flit_in[i];
						break;
					end
				end

				//increment flit counter
				f_id = f_id + 1;
			end
		end

		//inject queued flits
		inject();

		//--------------------------------------
		// inject any credits coming from rtl
		//--------------------------------------

		//loop over all ports and VCs
		for(i=0; i<N; i=i+1) begin
			for(j=0; j<NUM_VC; j++) begin
				//send credits from rtl to NoC
				send_credit(i,j,credits_to_noc[i][j]);
				if(credits_to_noc[i][j])
					if (VERBOSE == 1)
						$display("Sending Credit to NoC node %d, vc %d (cycle = %d)",i,j,cycle_count);
			end
		end

		//--------------------------------------
		// eject any credits coming from noc
		//--------------------------------------
		
		//loop over all ports and VCs
		for(i=0; i<N; i=i+1) begin
			for(j=0; j<NUM_VC; j++) begin
				//send credits back to the rtl from each vc
				credits_to_rtl[i][j] = receive_credit(i,j);
				if(credits_to_rtl[i][j]) begin
				       if (VERBOSE == 1)
					     $display("Received credit in node %d, vc %d (cycle = %d)",i,j,cycle_count);
				end
			end
		end

		//--------------------------------------
		// eject received flits
		//--------------------------------------
	
		//reset output valids to invalid (0)
		for (k=0; k<N; k=k+1) begin
			o_flit_out[k] = 0;
		end


		flits_left = 1;
		while (flits_left == 1) begin
			flits_left = eject(received_id,received_vc);

			if (received_id >= 0) begin

				// find data in data_set
				for (j=0; j<2**STORAGE; j=j+1) begin

					if (data_set[j].valid == 1'b1) begin

						if (data_set[j].f_id == received_id) begin
							
							dest = data_set[j].dest;

							// determine out port
							for (k=0; k<N; k=k+1) begin

								if (k == dest) begin
									out_port = k;
									break;
								end

							end

						        if (VERBOSE == 1)
							     $display("Received flit %d at node %d, vc %d (cycle = %d)",received_id,out_port,received_vc,cycle_count);

							// remove data from data_set
							data_set[j].valid = 1'b0;

							// send flit data to destination port
							o_flit_out[out_port] = data_set[j].data;

							//update the output data vc 
							o_flit_out[out_port][VC_POS -: VC_ADDRESS_WIDTH] = received_vc;


							break;

						end
					end
				end
			end
		end

		// proceed to next cycle
		nextCycle(CLOCK_SPEEDUP);

		// check to see if simulation is over
		cycle_count = cycle_count + 1;
		//if (cycle_count > NUM_CYCLES)
		//	$finish;
	end

end

endmodule

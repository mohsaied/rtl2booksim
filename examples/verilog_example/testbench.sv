/* 
 * function : testbench to 
 * author   : Mohamed S. Abdelfattah
 * date     : 3-SEPT-2014
 */

`timescale 1ns/1ps

module testbench();
parameter WIDTH_NOC    = 128;
parameter WIDTH_RTL    = 512;
parameter N            = 16;
parameter NUM_VC       = 2;
parameter DEPTH_PER_VC = 16;

//clocks and reset
logic         clk_noc;
logic         rst;
logic [N-1:0] clk_rtl;
logic [N-1:0] clk_int;
	
//from rtl modules to noc
logic [WIDTH_RTL-1:0] i_packets_in [0:N-1];
logic                 i_valids_in  [0:N-1];
logic                 i_readys_out [0:N-1];

//from noc to rtl modules
logic [WIDTH_RTL-1:0] o_packets_out [0:N-1];	
logic                 o_valids_out  [0:N-1];	
logic                 o_readys_in   [0:N-1];


//local parameters
localparam ADDRESS_WIDTH = $clog2(N);
localparam VC_ADDRESS_WIDTH = $clog2(NUM_VC);
 
//parameter WIDTH_DATA = 16; // 1 flit
//parameter WIDTH_DATA = 160; // 2 flits
//parameter WIDTH_DATA = 260; // 3 flits
//parameter WIDTH_DATA = 400; //4 flits

parameter WIDTH_DATA = 400;


localparam N_INPUTS = 1000;
localparam DEST_NODE = 15;
localparam SEED = 32'hBAADF00D;


//vars
int i;
int cycle_count;

//dut
fabric_interface 
#(.DEPTH_PER_VC(DEPTH_PER_VC))
dut ( .* );

//1 pkt input interface
logic [WIDTH_DATA-1:0]    pkt_data_in;
logic                     pkt_valid_in;
logic [ADDRESS_WIDTH-1:0] pkt_dest_in;
logic                     pkt_ready_out;


//instantiate a packetizer and a depacketizer to make things easy
packetizer
#(
	.ADDRESS_WIDTH(ADDRESS_WIDTH),
	.VC_ADDRESS_WIDTH(VC_ADDRESS_WIDTH),
	.WIDTH_IN(WIDTH_DATA),
	.WIDTH_OUT(WIDTH_RTL)
)
pkt_inst
(
	.i_data_in(pkt_data_in),
	.i_valid_in(pkt_valid_in),
	.i_dest_in(pkt_dest_in),
	.i_ready_out(pkt_ready_out),

	.o_data_out(i_packets_in[0]),
	.o_valid_out(i_valids_in[0]),
	.o_ready_in(i_readys_out[0])
);


//1 pkt output interface
logic [WIDTH_DATA-1:0] pkt_data_out;
logic                  pkt_valid_out;
logic                  pkt_ready_in;

depacketizer
#(
	.ADDRESS_WIDTH(ADDRESS_WIDTH),
	.VC_ADDRESS_WIDTH(VC_ADDRESS_WIDTH),
	.WIDTH_PKT(WIDTH_RTL),
	.WIDTH_DATA(WIDTH_DATA)
)
depkt_inst
(
	.i_packet_in(o_packets_out[DEST_NODE]),
	.i_valid_in(o_valids_out[DEST_NODE]),
	.i_ready_out(o_readys_in[DEST_NODE]),

	.o_data_out(pkt_data_out),
	.o_valid_out(pkt_valid_out),
	.o_ready_in(pkt_ready_in)
);

//one module clk is connected to all the nodes
logic clk_rtls;
logic clk_ints;

generate
genvar iclk;
for(iclk=0;iclk<N;iclk++)
begin:clocks
assign clk_rtl[iclk] = clk_rtls;
assign clk_int[iclk] = clk_ints;
end
endgenerate


// generate clocks
initial clk_noc = 1'b1;
initial clk_ints = 1'b1;
initial clk_rtls = 1'b1;
always #1.25 clk_noc = ~clk_noc;
always #1.25 clk_ints = ~clk_ints; 
always #5    clk_rtls = ~clk_rtls; 

initial rst = 1;

initial pkt_data_in = 0;
initial pkt_valid_in = 0;
initial pkt_dest_in = 0;


int packet_count = 0;

//-------------------------------------------------------------------------
// Testbench
//-------------------------------------------------------------------------

initial cycle_count = 0;
always @ (posedge clk_rtls)
	cycle_count = cycle_count + 1;

int first_cycle;
initial first_cycle = -1;

int first_rec_cycle;
initial first_rec_cycle = -1;

initial pkt_ready_in = 1;

// Producer Process: Sequential testbench code to initialize the circuit and
// send input values to it
reg [WIDTH_DATA-1:0] prod_rand = SEED;
integer prod_i;
initial begin
	// Set valid low until we're ready to give the circuit inputs
	pkt_valid_in = 1'b0;
	
	// Toggle the rst for a cycle
	rst = 1'b1;
	#10;
	rst = 1'b0;
	
	// Generate N_INPUTS random inputs and deliver to circuit
	for (prod_i = 0; prod_i < N_INPUTS; prod_i = prod_i + 1) begin
		// Wait for circuit to be ready
		@(posedge clk_rtls);
		while (!pkt_ready_out) begin
			pkt_valid_in = 1'b0;		
			@(posedge clk_rtls);
		end
			
		if(first_cycle == -1)
			first_cycle = cycle_count;

		// Generate a random number and give it to the circuit
		pkt_data_in = prod_rand[WIDTH_DATA-1:0];
		//pkt_data_in = prod_rand[4:0];
		pkt_dest_in = DEST_NODE;
		prod_rand = $random(prod_rand);
		pkt_valid_in = 1'b1;
	end
end

always @ (negedge clk_rtls)
	pkt_ready_in <= $urandom_range(0,9) <= 9 ? 1 : 0;

// Consumer process: Sequential testbench code to receive output
// from the circuit and verify it. Also stops the simulation when
// all outputs are delivered.
reg [WIDTH_DATA-1:0] cns_rand = SEED;
reg [WIDTH_DATA-1:0] cns_x;
reg [WIDTH_DATA-1:0] good_y;
reg fail = 1'b0;
integer cns_i;
int num_fail;
real tot;
initial begin
	num_fail = 0;
	tot = 0;
	// We generate the same numbers as the producer process
	// by using the same random seed sequence
	for (cns_i = 0; cns_i < N_INPUTS; cns_i = cns_i + 1) begin
		// Wait for a valid output
		@(posedge clk_rtls);
		while (!pkt_valid_out) begin
			@(posedge clk_rtls);
		end
		

		// Use our copy of X to calculate the correct Y
		cns_x = cns_rand[WIDTH_DATA-1:0];
		//cns_x = cns_rand[4:0];
		cns_rand = $random(cns_rand);
		good_y = cns_x;
				
		if(first_rec_cycle == -1)
			first_rec_cycle = cycle_count;

	
		tot = tot + 1;

		// Display and compare the answer to the known good value
		if (good_y != pkt_data_out) begin
			$display("FAIL X: %d Expected Y: %d Got Y: %d", cns_x, good_y, pkt_data_out);
			fail = 1'b1;
			num_fail = num_fail +1;
		end
		else begin
			$display("SUCCESS X: %d Expected Y: %d Got Y: %d", cns_x, good_y, pkt_data_out);
		end
	end
	
	$display("%s", fail? "SOME TESTS FAILED" : "ALL TESTS PASSED");
	$display("%d failed out of %d total tests",num_fail,tot);
	$display("Total number of cycles = %d (%d) for %d total inputs -- xput = %f ops/cycle",cycle_count-first_cycle,cycle_count-first_rec_cycle,tot,tot/(cycle_count-first_cycle+1));
	//$stop(0);
	$finish(0);
end


endmodule


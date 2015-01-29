/* 
 * function : test rtl interface 
 * author   : Mohamed S. Abdelfattah
 * date     : 3-SEPT-2014
 */

`timescale 1ns/1ps

module testbench();

parameter WIDTH = 128;
parameter N = 16;
parameter NUM_VC = 2;
parameter NUM_CYCLES = 100000;
parameter VERBOSE = 1;
	
logic clk;
logic reset;
	
//data
reg [WIDTH-1:0] i_flit_in [0:N-1];
reg [WIDTH-1:0] o_flit_out [0:N-1];
	
//credits 
reg [NUM_VC-1:0] credits_to_noc [0:N-1];
reg [NUM_VC-1:0] credits_to_rtl [0:N-1];

//local parameters
localparam ADDRESS_WIDTH = $clog2(N);
localparam VC_ADDRESS_WIDTH = $clog2(NUM_VC);
localparam VALID_POS = WIDTH-1;
localparam HEAD_POS = WIDTH-2;
localparam TAIL_POS = WIDTH-3;
localparam VC_POS = WIDTH-4;
localparam DEST_POS = WIDTH-4-VC_ADDRESS_WIDTH;
localparam DATA_POS = WIDTH-4-VC_ADDRESS_WIDTH-ADDRESS_WIDTH;


localparam N_INPUTS = 1000;
localparam DEST_NODE = 15;
localparam SEED = 32'hBAADF00D;

//vars
int i;
int cycle_count;

//dut
rtl_interface #() dut ( .* );


// generate clocks
initial clk = 1'b1;
always #1.25 clk = ~clk;

initial reset = 1;

int packet_count = 0;

//-------------------------------------------------------------------------
// Testbench
//-------------------------------------------------------------------------

reg [WIDTH-1:0] flit_in;
reg [WIDTH-1:0] flit_out;

reg [NUM_VC-1:0] credit_in;

assign credits_to_noc[15] = credit_in;

//inject at node 0 
assign i_flit_in[0] = flit_in;
//eject at node 15
assign flit_out = o_flit_out[15];

initial cycle_count = 0;
always @ (posedge clk)
	cycle_count = cycle_count + 1;

int first_cycle;
initial first_cycle = -1;

int first_rec_cycle;
initial first_rec_cycle = -1;


// Producer Process: Sequential testbench code to initialize the circuit and
// send input values to it
reg [WIDTH-1:0] prod_rand = SEED;
integer prod_i;
initial begin
	// Set valid low until we're ready to give the circuit inputs
	flit_in[0] = 1'b0;
	
	// Toggle the rst for a cycle
	reset = 1'b1;
	#10;
	reset = 1'b0;
	
	// Generate N_INPUTS random inputs and deliver to circuit
	for (prod_i = 0; prod_i < N_INPUTS; prod_i = prod_i + 1) begin
		@(posedge clk);
			
		if(first_cycle == -1)
			first_cycle = cycle_count;

		// Generate a random number and give it to the circuit
		flit_in = prod_rand[WIDTH-1:0];
        flit_in[VALID_POS] = 1'b1; //valid
        flit_in[HEAD_POS] = 1'b1; //HEAD
        flit_in[TAIL_POS] = 1'b1; //TAIL
        flit_in[VC_POS-:VC_ADDRESS_WIDTH] = 1'b1; //VC
		flit_in[DEST_POS-:ADDRESS_WIDTH] = DEST_NODE; //destination node
		
        prod_rand = $random(prod_rand);
	end
end


// Consumer process: Sequential testbench code to receive output
// from the circuit and verify it. Also stops the simulation when
// all outputs are delivered.
reg [WIDTH-1:0] cns_rand = SEED;
reg [WIDTH-1:0] cns_x;
reg [WIDTH-1:0] good_y;
reg fail = 1'b0;
integer cns_i;
int num_fail;
real tot;
initial begin
	num_fail = 0;
	tot = 0;
	// We generate the same numbers as the producer process
	// by using the same random seed sequence
	for (cns_i = 0; cns_i < N_INPUTS*5; cns_i = cns_i + 1) begin
		// Wait for a valid output
		@(posedge clk);
		while (reset == 1 || flit_out[VALID_POS]!=1) begin
            credit_in = 0;
			@(posedge clk);
		end
	
        //send a credit back
        if(reset==0)
            credit_in[0] = 0;

		// Use our copy of X to calculate the correct Y
		cns_x = cns_rand[WIDTH-1:0];
		cns_rand = $random(cns_rand);
		good_y = cns_x;
				
		if(first_rec_cycle == -1)
			first_rec_cycle = cycle_count;

	
		tot = tot + 1;

		// Display and compare the answer to the known good value
		if (good_y[DATA_POS:0] != flit_out[DATA_POS:0]) begin
			$display("FAIL X: %d Expected Y: %d Got Y: %d", cns_x, good_y, flit_out[DATA_POS:0]);
			fail = 1'b1;
			num_fail = num_fail +1;
		end
		else begin
			$display("SUCCESS X: %d Expected Y: %d Got Y: %d", cns_x, good_y, flit_out);
		end
	end
	
	$display("%s", fail? "SOME TESTS FAILED" : "ALL TESTS PASSED");
	$display("%d failed out of %d total tests",num_fail,tot);
	$display("Total number of cycles = %d (%d) for %d total inputs -- xput = %f ops/cycle",cycle_count-first_cycle,cycle_count-first_rec_cycle,tot,tot/(cycle_count-first_cycle+1));
	//$stop(0);
	$finish(0);
end


endmodule


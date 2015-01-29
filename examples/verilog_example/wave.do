onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/WIDTH
add wave -noupdate /testbench/N
add wave -noupdate /testbench/NUM_VC
add wave -noupdate /testbench/NUM_CYCLES
add wave -noupdate /testbench/VERBOSE
add wave -noupdate /testbench/ADDRESS_WIDTH
add wave -noupdate /testbench/VC_ADDRESS_WIDTH
add wave -noupdate /testbench/VALID_POS
add wave -noupdate /testbench/HEAD_POS
add wave -noupdate /testbench/TAIL_POS
add wave -noupdate /testbench/VC_POS
add wave -noupdate /testbench/DEST_POS
add wave -noupdate /testbench/DATA_POS
add wave -noupdate /testbench/N_INPUTS
add wave -noupdate /testbench/DEST_NODE
add wave -noupdate /testbench/SEED
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/i_flit_in
add wave -noupdate /testbench/o_flit_out
add wave -noupdate /testbench/credits_to_noc
add wave -noupdate /testbench/credits_to_rtl
add wave -noupdate /testbench/i
add wave -noupdate /testbench/cycle_count
add wave -noupdate /testbench/packet_count
add wave -noupdate /testbench/flit_in
add wave -noupdate /testbench/flit_out
add wave -noupdate /testbench/credit_in
add wave -noupdate /testbench/first_cycle
add wave -noupdate /testbench/first_rec_cycle
add wave -noupdate /testbench/prod_rand
add wave -noupdate /testbench/prod_i
add wave -noupdate /testbench/cns_rand
add wave -noupdate /testbench/cns_x
add wave -noupdate /testbench/good_y
add wave -noupdate /testbench/fail
add wave -noupdate /testbench/cns_i
add wave -noupdate /testbench/num_fail
add wave -noupdate /testbench/tot
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9008 ps} {198448 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/cycle_count
add wave -noupdate /testbench/clk_noc
add wave -noupdate /testbench/clk_ints
add wave -noupdate /testbench/clk_rtls
add wave -noupdate -radix unsigned /testbench/pkt_data_in
add wave -noupdate /testbench/pkt_valid_in
add wave -noupdate /testbench/pkt_dest_in
add wave -noupdate /testbench/pkt_ready_out
add wave -noupdate /testbench/fail
add wave -noupdate -radix unsigned /testbench/good_y
add wave -noupdate -radix unsigned /testbench/pkt_data_out
add wave -noupdate /testbench/pkt_valid_out
add wave -noupdate /testbench/pkt_ready_in
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/clk_rtl}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/clk_int}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/clk_noc}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/rst}
add wave -noupdate -expand -group fpin -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/rtl_packet_in}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/rtl_valid_in}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/rtl_ready_out}
add wave -noupdate -expand -group fpin -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/noc_flit_out}
add wave -noupdate -expand -group fpin -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/noc_credits_in}
add wave -noupdate -expand -group fpin -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/t_a_data}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/t_a_valid}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/t_a_ready}
add wave -noupdate -expand -group fpin -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/a_n_data}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/a_n_read_en}
add wave -noupdate -expand -group fpin {/testbench/dut/fps[0]/fpin_inst/a_n_ready}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/clk_slow}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/clk_fast}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/rst}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/i_data_in}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/i_valid_in}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/i_ready_out}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/o_data_out}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/o_valid_out}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/o_ready_in}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/count}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/data_buffer}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/data_buffer_valid}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/overflow_buffer}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/overflow_buffer_valid}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/synchronizer}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/sync_start}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/synchronized}
add wave -noupdate -group fpin_tdm -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/tdm_inst/mux_data}
add wave -noupdate -group fpin_tdm {/testbench/dut/fps[0]/fpin_inst/tdm_inst/ready}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/WIDTH}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/DEPTH}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/write_clk}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/read_clk}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/rst}
add wave -noupdate -group fpin_afifo -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/i_data_in}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/i_write_en}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/i_ready_out}
add wave -noupdate -group fpin_afifo -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/o_data_out}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/o_read_en}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/o_ready_out}
add wave -noupdate -group fpin_afifo -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/overflow_buffer}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/overflow_buffer_valid}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/read_overflow}
add wave -noupdate -group fpin_afifo -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/fifo_data_in}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/fifo_full}
add wave -noupdate -group fpin_afifo {/testbench/dut/fps[0]/fpin_inst/afifo_elastic_inst/fifo_empty}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/clk}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/rst}
add wave -noupdate -group fpin_noc_writer -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/i_data_in}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/i_ready_in}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/i_read_en}
add wave -noupdate -group fpin_noc_writer -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/o_flit_out}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/o_credits_in}
add wave -noupdate -group fpin_noc_writer -radix hexadecimal {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/credit_count}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/current_vc}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/valid_out}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/vc_available}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/possible_data_received}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/i}
add wave -noupdate -group fpin_noc_writer {/testbench/dut/fps[0]/fpin_inst/noc_writer_inst/vc_available_reg}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/clk_noc}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/clk_rtl}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/clk_int}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/rst}
add wave -noupdate -expand -group fpout -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_flit_in}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/noc_credits_out}
add wave -noupdate -expand -group fpout -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/rtl_packet_out}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/rtl_valid_out}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/rtl_ready_in}
add wave -noupdate -expand -group fpout -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/n_a_data}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/n_a_write}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/n_a_ready}
add wave -noupdate -expand -group fpout -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/a_d_data}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/a_d_read}
add wave -noupdate -expand -group fpout {/testbench/dut/fps[1]/fpout_inst/a_d_ready}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/clk}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/rst}
add wave -noupdate -group fpout_noc_reader -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/i_flit_in}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/i_credits_out}
add wave -noupdate -group fpout_noc_reader -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/o_data_out}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/o_write_en}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/o_ready_in}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/valid}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_write_vc}
add wave -noupdate -group fpout_noc_reader -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_data_in}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_write_en}
add wave -noupdate -group fpout_noc_reader -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_data_out}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_en}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_empty}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_almost_empty}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_next_is_tail}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/i}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_vc}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/past_fifo_read_vc}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/vc_changed}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/state}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_vc_reg}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_vc_reg2}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_en_reg}
add wave -noupdate -group fpout_noc_reader {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/fifo_read_en_reg2}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/clk}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/clear}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/i_data_in}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/i_write_en}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/i_full_out}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/o_data_out}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/o_read_en}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/o_empty_out}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/o_almost_empty_out}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/o_next_is_tail}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal -childformat {{{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[15]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[14]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[13]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[12]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[11]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[10]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[9]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[8]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[7]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[6]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[5]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[4]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[3]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[2]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[1]} -radix hexadecimal} {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[0]} -radix hexadecimal}} -expand -subitemconfig {{/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[15]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[14]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[13]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[12]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[11]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[10]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[9]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[8]} {-radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[7]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[6]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[5]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[4]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[3]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[2]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[1]} {-height 13 -radix hexadecimal} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory[0]} {-height 13 -radix hexadecimal}} {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/memory}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/next_read_addr}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/after_next_read_addr}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/next_write_addr}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/next_read_en}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/next_write_en}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/equal_address}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/set_status}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/rst_status}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/preset_full}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/preset_empty}
add wave -noupdate -group fpout_noc_reader_fifo {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/status}
add wave -noupdate -group fpout_noc_reader_fifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/noc_reader_inst/ivcs[0]/fifo_buffer/number_of_words}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/write_clk}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/read_clk}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/rst}
add wave -noupdate -group fpout_afifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/afifo_inst/i_data_in}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/i_write_en}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/i_ready_out}
add wave -noupdate -group fpout_afifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/afifo_inst/o_data_out}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/o_read_en}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/o_ready_out}
add wave -noupdate -group fpout_afifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/afifo_inst/overflow_buffer}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/overflow_buffer_valid}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/read_overflow}
add wave -noupdate -group fpout_afifo -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/afifo_inst/fifo_data_in}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/fifo_full}
add wave -noupdate -group fpout_afifo {/testbench/dut/fps[1]/fpout_inst/afifo_inst/fifo_empty}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/clk_slow}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/clk_fast}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/rst}
add wave -noupdate -group fpout_demux -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/demux_inst/i_data_in}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/i_read_en}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/i_empty_in}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/o_valid_out}
add wave -noupdate -group fpout_demux -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/demux_inst/o_data_out}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/o_ready_in}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/tail}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/count}
add wave -noupdate -group fpout_demux -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/demux_inst/output_buffer}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/output_full}
add wave -noupdate -group fpout_demux -divider packet
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/valid_out_packet}
add wave -noupdate -group fpout_demux -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/demux_inst/packet_buffer}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/packet_full}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/packet_busy}
add wave -noupdate -group fpout_demux -divider overflow
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/valid_out_overflow}
add wave -noupdate -group fpout_demux -radix hexadecimal {/testbench/dut/fps[1]/fpout_inst/demux_inst/overflow_buffer}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/overflow_full}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/overflow_busy}
add wave -noupdate -group fpout_demux -divider other
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/tail_stall}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/valid_i_data}
add wave -noupdate -group fpout_demux {/testbench/dut/fps[1]/fpout_inst/demux_inst/state}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {20000 ps} 0} {{Cursor 3} {35000 ps} 0} {{Cursor 4} {51460 ps} 0} {{Cursor 5} {80000 ps} 0}
quietly wave cursor active 4
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
WaveRestoreZoom {9008 ps} {90269 ps}

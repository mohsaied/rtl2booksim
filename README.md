# RTL2Booksim 

"Connect RTL designs to a flexible NoC simulator"

This tool allows connecting C/C++ simulators, or RTL (Verilog) designs to Booksim (Booksim is a widely-used cycle-accurate NoC simulator developed at stanford and is also available on GitHub).
Simply put, RTL2Booksim allows you to use an NoC in your verilog design without actually having to write the verilog for it, instead we use  Booksim to try out many different NoC variants without extra design effort.

To get started, look at the examples.

1. cpp_example: Calls functions like "send_flit" and "send_credit" to demonstrate how you can write a simple cpp simulator that communicates with Booksim.
2. verilog_example: Instantiates "rtl_interface.sv" which is basically a verilog wrapper for the Booksim NoC. You can then connect your design modules to different routers through rtl_interface.

In both examples there is a shell script called "quickscript" which contains the necessary steps to properly compile and run each example.

For more information please visit http://www.eecg.utoronto.ca/~mohamed/rtl2booksim

and contact mohamed@eecg.utoronto.ca


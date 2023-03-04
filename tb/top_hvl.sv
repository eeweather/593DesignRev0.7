/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*/

module top_hvl;
	import uvm_pkg::*;
	import tinyalu_pkg::*;

	initial begin
		$timeformat(-9,0,"ns",6);
		run_test(); //test name will be passed with vsim +UVM_TESTNAME=<name>
	end

endmodule: top_hvl
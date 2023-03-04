/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   coverage_collector collects functional coverage numbers based on the
*   covergroup cg. the report_phase prints the percentage.
*/
 
class coverage_collector extends uvm_subscriber #(item_base);
	`uvm_component_utils(coverage_collector)

	item_base tx;
	covergroup cg; //TODO
	endgroup :cg
	

function new(string name, uvm_component parent);
	super.new(name, parent);
	cg = new();
endfunction

virtual function void write(input item_base t);
	this.tx = t;
	cg.sample();
endfunction: write

virtual function void report_phase(uvm_phase phase);
	`uvm_info("COVERAGE", $sformatf("\n\nFunctional coverage = %2.2f%%\n", cg.get_coverage()), UVM_NONE)
endfunction: report_phase

endclass : coverage_collector
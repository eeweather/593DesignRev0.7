/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Driver gets a sequence_item from the sequencer, and places it onto the
*   virtual interface to wiggle the pins of the DUT
*/
 
class driver extends uvm_driver #(item_base);
	`uvm_component_utils(driver)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction


virtual processor_if vif;

virtual task run_phase(uvm_phase phase);
	item_base inst;

	vif.reset_alu();
	
	forever begin
		//get the next item from the sequencer (through the port) and send it to the DUT using the virtual interface
		seq_item_port.get_next_item(inst);		
		vif.send_instruction(inst.inst);
		seq_item_port.item_done();

	end
endtask: run_phase

endclass: driver

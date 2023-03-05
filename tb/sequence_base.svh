/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Base sequence for generating sequence item(s) 
*/

class sequence_base extends uvm_sequence #(item_base);
	`uvm_object_utils(sequence_base)

	function new(string name="sequence_base");
		super.new(name);
	endfunction

	agent_config agent_cfg;
	
	item_base tx;	

	task init_start(input uvm_sequencer #(item_base) sqr, input agent_config agent_cfg);
		this.agent_cfg = agent_cfg;
		this.start(sqr);
	endtask: init_start

	//the body task is where transactions (or sequence items, or whatever) are created, randomized, and started/finished
	task body();
	
		repeat (10) begin
			tx = item_base::type_id::create("tx");
			start_item(tx);
			if(!tx.randomize()) `uvm_fatal(get_type_name(), "tx.randomize failed")
			finish_item(tx);
		end
	endtask: body

endclass: sequence_base
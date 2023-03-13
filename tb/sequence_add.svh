/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   ALU sequence for generating ALU sequences 
*/

class sequence_add extends sequence_base;// #(item_base);
	`uvm_object_utils(sequence_add)

    item_base tx;

	function new(string name="sequence_add");
		super.new(name);
	endfunction

	task init_start(input uvm_sequencer #(item_base) sqr);
		this.start(sqr);
	endtask: init_start


	item_alu alu;
	item_load load;
	item_store store;

	//generate a sequence of ALU transactions
	task body();

        all_add_ops(10);
	
	endtask: body

	//all adds all the time. Input: Repeat Val = # of adds you wanna do
	task all_add_ops(int repeat_val);
		alu = item_alu::type_id::create("alu");
		store = item_store::type_id::create("store");
		load = item_load::type_id::create("load");
		
        for (int i = 0; i < repeat_val; i++) begin			
			get_alu_op(0, op_add);					
		end
		
	endtask

endclass: sequence_add


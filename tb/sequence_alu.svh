/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   ALU sequence for generating ALU sequences 
*/

class sequence_alu extends uvm_sequence #(item_base);
	`uvm_object_utils(sequence_alu)

    item_base tx;

	function new(string name="sequence_alu");
		super.new(name);
	endfunction

	agent_config agent_cfg;

	task init_start(input uvm_sequencer #(item_base) sqr, input agent_config agent_cfg);
		this.agent_cfg = agent_cfg;
		this.start(sqr);
	endtask: init_start

	//the body task is where transactions (or sequence items, or whatever) are created, randomized, and started/finished
	task body();
		
		alu_opcode_t opcode; 
		alu_opcode_t orOp;	
		orOp = op_or;
		opcode = opcode.first();

		tx = item_alu::type_id::create("tx");
		
		//iterate thru ALU opcodes add thru spec2
		for (int i = 1; i < 8; i++) begin
			start_item(tx);
			if(!tx.randomize()) `uvm_fatal(get_type_name(), "tx.randomize failed");	 //randomize instruction
			tx.inst[15:12] = opcode.next();	//but modify opcode to iterate through all ALU ops		
			tx.addr = i;							
			finish_item(tx);
			//`uvm_info("ALU SEQ", $sformatf("Opcode = %b", opcode) , UVM_MEDIUM);
		end

		//get that OR op in there too
		start_item(tx);
		if(!tx.randomize()) `uvm_fatal(get_type_name(), "tx.randomize failed");
		tx.inst[15:12] = orOp;
		finish_item(tx);
	
	endtask: body

endclass: sequence_alu
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

	item_base tx;	
	item_alu alu;
	item_load load;
	item_store store;


	task init_start(input uvm_sequencer #(item_base) sqr);
		this.start(sqr);
	endtask: init_start

	//the body task is where transactions (or sequence items, or whatever) are created, randomized, and started/finished
	task body();

		repeat(3) basic_transfer();
	endtask : body

	task basic_transfer();
		tx = item_base::type_id::create("tx");
		alu = item_alu::type_id::create("alu");
		load = item_load::type_id::create("load");
		store = item_store::type_id::create("store");
		repeat(2) begin
			if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed")
			start_item(load);
			finish_item(load);
		end
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		start_item(alu);
		finish_item(alu);

		if(!store.randomize()) `uvm_fatal(get_type_name(), "store.randomize failed")
		start_item(store);
		finish_item(store);

	endtask : basic_transfer

	/**********************HELPER TASKS*******************************************************/
	 
	 //performs 2 load ops on random addresses
	 task load_data();
		load = item_load::type_id::create("load");
		repeat(2) begin
			if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed")
			start_item(load);
			finish_item(load);
			end
	endtask

	//store data to specific address, or defaults to random addr
	 task store_data(logic [13:0] addr = 'x);
		store = item_store::type_id::create("store");
		if(addr === 'x) 
			addr = $urandom();
		if(!store.randomize()) `uvm_fatal(get_type_name(), "store.randomize failed")
		store.inst[14:1] = addr;
		start_item(store);
		finish_item(store);
	endtask

	/*create a full tx (load/load/op/store). 
	set random to 0 and provide and opcode to recieve a specific op, 
	otherwise it'll randomize opcodes */
	 task get_alu_tx(bit random = 1, alu_opcode_t op = op_nop);
		alu = item_alu::type_id::create("alu");
		load_data();
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		if(random != 1) begin
			alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = op;
		end		
		start_item(alu);
		finish_item(alu);
		store_data();
	endtask

	//get just an ALU operation without the load/store, can specify op randomize
	task get_alu(bit random = 1, alu_opcode_t op = op_nop);
		alu = item_alu::type_id::create("alu");
		if(!alu.randomize()) `uvm_fatal(get_type_name(), "alu.randomize failed")
		if(random != 1) begin
			alu.inst[INSTR_WIDTH-1:INSTR_WIDTH-4] = op;
		end		
		start_item(alu);
		finish_item(alu);
	endtask

	//get a single load operation, can specify addr
	task load_addr(logic [13:0] addr = 'x);
		load = item_load::type_id::create("load");
		if(addr === 'x) 
			addr = $urandom();
		if(!load.randomize()) `uvm_fatal(get_type_name(), "load.randomize failed")
		load.inst[14:1] = addr;
		start_item(load);
		finish_item(load);	
	endtask


endclass: sequence_base

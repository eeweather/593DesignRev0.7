/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test_alu for testing alu sequence
*/


class test_alu extends test_base;
	`uvm_component_utils(test_alu)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		
		sequence_alu alu_0;
		sequence_alu alu_1;
		sequence_alu alu_2;
		sequence_alu alu_3;
		alu_0 = new("alu_0");
		alu_1 = new("alu_1");
		alu_2 = new("alu_2");
		alu_3 = new("alu_3");

		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 10);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***ALU TEST***\n\n\n", UVM_NONE)

		//create the sequence 
		alu_0 = sequence_alu::type_id::create("alu_0");
		alu_1 = sequence_alu::type_id::create("alu_1");
		alu_2 = sequence_alu::type_id::create("alu_2");
		alu_3 = sequence_alu::type_id::create("alu_3");
		alu_0.init_start(envt.agt_0.sqr);
		alu_1.init_start(envt.agt_1.sqr);
		alu_2.init_start(envt.agt_2.sqr);
		alu_3.init_start(envt.agt_3.sqr);

		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_alu

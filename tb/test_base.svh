/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test_base creates the configs, sets the number of items to test, creates
*   the environment, then creates and runs the base sequence.
*/


class test_base extends uvm_test;
	`uvm_component_utils(test_base)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	env envt;
	env_config env_cfg;
	agent_config agent_cfg;

	virtual function void build_phase(uvm_phase phase);

		//create configuration objects
		env_cfg = env_config::type_id::create("env_cfg");
		agent_cfg = agent_config::type_id::create("agent_cfg");

		//active agent!
		agent_cfg.active = UVM_ACTIVE;
		env_cfg.agent_cfg = agent_cfg;

		//prints the number of items, 1 by default, set on command line
		void'(uvm_config_db#(uvm_bitstream_t)::get(this, "", "num_items", agent_cfg.num_items));
		`uvm_info(get_type_name(), $sformatf("num_items=%d.", agent_cfg.num_items), UVM_LOW)

		agent_cfg.monitor_verbosity = UVM_LOW;

		agent_cfg.enable_coverage = 1;

		//get the vif (tinycpu_bfm) from the config database
		if (!uvm_config_db #(virtual tinycpu_bfm)::get(this, "", "vif", agent_cfg.vif)) `uvm_fatal(get_type_name(), "Failed to get vif from uvm_config_db")
		
		//put the env_config in the config database and create env
		uvm_config_db #(env_config)::set(this, "envt", "env_cfg", env_cfg);
		envt = env::type_id::create("envt",this);

	endfunction: build_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		//this eoe phase prints some useful information before running, check it out!
		uvm_factory factory;
		factory = uvm_factory::get();

		`uvm_info("PRINT", "factory.print(1);", UVM_LOW)
		factory.print(1);

		`uvm_info("PRINT", "uvm_top.print_topology();", UVM_LOW)
		uvm_top.print_topology();

		`uvm_info("PRINT", "print_config();", UVM_LOW)
		print_config();
	endfunction: end_of_elaboration_phase

	virtual task run_phase(uvm_phase phase);
		
		sequence_base seq;

		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 10);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***BASE TEST***\n\n\n", UVM_NONE)


		//create the sequence and call it's initial start task (sequence_base.svh)
		seq = sequence_base::type_id::create("seq");
		seq.init_start(envt.agt.sqr, agent_cfg);

		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_base
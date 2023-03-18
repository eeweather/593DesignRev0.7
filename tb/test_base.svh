/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   test_base creates the env config, the environment, then creates and runs the base sequence.
*/


class test_base extends uvm_test;
	`uvm_component_utils(test_base)

	function new(string name, uvm_component parent);
		super.new (name, parent);
	endfunction

	env envt;
	env_config env_cfg;
virtual processor_if vif_0, vif_1, vif_2, vif_3;

	virtual function void build_phase(uvm_phase phase);

		//create configuration objects
		envt = env::type_id::create("envt",this);
		env_cfg = env_config::type_id::create("env_cfg");
		//put the env_config in the config database and create env
		uvm_config_db #(env_config)::set(this, "envt", "env_cfg", env_cfg);

		if (!uvm_config_db #(virtual processor_if)::get(this, "", "vif_0", vif_0)) `uvm_fatal(get_type_name(), "Failed to get vif_0 from uvm_config_db")
		if (!uvm_config_db #(virtual processor_if)::get(this, "", "vif_1", vif_1)) `uvm_fatal(get_type_name(), "Failed to get vif_1 from uvm_config_db")
		if (!uvm_config_db #(virtual processor_if)::get(this, "", "vif_2", vif_2)) `uvm_fatal(get_type_name(), "Failed to get vif_2 from uvm_config_db")
		if (!uvm_config_db #(virtual processor_if)::get(this, "", "vif_3", vif_3)) `uvm_fatal(get_type_name(), "Failed to get vif_3 from uvm_config_db")
		

	endfunction: build_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);

		//this eoe phase prints some useful information before running, check it out!
		uvm_factory factory;
		factory = uvm_factory::get();

		//assign the virtual interface gotten by the build phase to
		//the monitors and drivers, future work would put this in
		//a loop to allow for dynamically creating more agents
		envt.agt_0.drv.vif = vif_0;
		envt.agt_0.mon.vif = vif_0;
		envt.agt_1.drv.vif = vif_1;
		envt.agt_1.mon.vif = vif_1;
		envt.agt_2.drv.vif = vif_2;
		envt.agt_2.mon.vif = vif_2;
		envt.agt_3.drv.vif = vif_3;
		envt.agt_3.mon.vif = vif_3;
		
		
		`uvm_info("PRINT", "factory.print(1);", UVM_LOW)
		factory.print(1);

		`uvm_info("PRINT", "uvm_top.print_topology();", UVM_LOW)
		uvm_top.print_topology();

		`uvm_info("PRINT", "print_config();", UVM_LOW)
		print_config();
	endfunction: end_of_elaboration_phase

	virtual task run_phase(uvm_phase phase);
		
		sequence_base base_0;
		sequence_base base_1;
		sequence_base base_2;
		sequence_base base_3;
		//set_drain_time gives the test a period of time after stimulus is
		//finished to be processed
		phase.phase_done.set_drain_time(this, 1000);

		phase.raise_objection(this, get_full_name());
		`uvm_info("TEST", "\n\n\n ***BASE TEST***\n\n\n", UVM_NONE)


		//create the sequence and call it's initial start task (sequence_base.svh)
		base_0 = sequence_base::type_id::create("base_0");
		base_1 = sequence_base::type_id::create("base_1");
		base_2 = sequence_base::type_id::create("base_2");
		base_3 = sequence_base::type_id::create("base_3");
		fork
			base_0.init_start(envt.agt_0.sqr);
			base_1.init_start(envt.agt_1.sqr);
			base_2.init_start(envt.agt_2.sqr);
			base_3.init_start(envt.agt_3.sqr);
		join
		phase.drop_objection(this, get_full_name());
	endtask: run_phase

endclass: test_base

/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Evironment creates agent, connects configs, creates scoreboard, and connects ports to
*   scoreboard.
*/

class env extends uvm_env;
	`uvm_component_utils(env)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

agent agt_0;
agent agt_1;
agent agt_2;
agent agt_3;
virtual processor_if vif_0;
virtual processor_if vif_1;
virtual processor_if vif_2;
virtual processor_if vif_3;


scoreboard scb;
env_config env_cfg;
coverage_collector cov;

virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	//future work should put this into a loop, to dynamically set number of agents
	agt_0 = agent::type_id::create("agt_0", this);
	agt_1 = agent::type_id::create("agt_1", this);
	agt_2 = agent::type_id::create("agt_2", this);
	agt_3 = agent::type_id::create("agt_3", this);
	
	//no environment_config is fatal
	if (!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) `uvm_fatal(get_type_name(), "env_cfg not found in uvm_config_db")
		
	//if you want a scoreboard, create it!
	if(env_cfg.enable_scoreboard) scb = scoreboard::type_id::create("scb", this);
	cov = coverage_collector::type_id::create("cov", this);

endfunction: build_phase

virtual function void connect_phase(uvm_phase phase);
	
	//future work should put this into a loop, to dynamically set number of agents

	//connect the dut interfacing ports to the scoreboard, if it enabled
	if (env_cfg.enable_scoreboard) begin
		agt_0.dut_out_tx_port.connect(scb.dut_out_export_0);
		agt_1.dut_out_tx_port.connect(scb.dut_out_export_1);
		agt_2.dut_out_tx_port.connect(scb.dut_out_export_2);
		agt_3.dut_out_tx_port.connect(scb.dut_out_export_3);
	end
	//connect monitors to coverage_collector
	agt_0.mon.dut_out_tx_port.connect(cov.analysis_export);
	agt_1.mon.dut_out_tx_port.connect(cov.analysis_export);
	agt_2.mon.dut_out_tx_port.connect(cov.analysis_export);
	agt_3.mon.dut_out_tx_port.connect(cov.analysis_export);

endfunction: connect_phase

endclass: env 

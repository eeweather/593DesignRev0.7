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

agent agt;
scoreboard scb;
env_config env_cfg;

virtual function void build_phase(uvm_phase phase);
	agt = agent::type_id::create("agt", this);
	
	//no environment_config is a sad day for us all
	if (!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg)) `uvm_fatal(get_type_name(), "env_cfg not found in uvm_config_db")

	//set the agent_config from the config database as the agent_config in the env_config class
	uvm_config_db #(agent_config)::set(this,"agt*", "agent_cfg", env_cfg.agent_cfg);

	//if you want a scoreboard, create it!
	if(env_cfg.enable_scoreboard) scb = scoreboard::type_id::create("scb", this);


endfunction: build_phase

virtual function void connect_phase(uvm_phase phase);
	
	//connect the dut interfacing ports to the scoreboard, if it exists
	if (env_cfg.enable_scoreboard) begin
		agt.dut_in_tx_port.connect(scb.dut_in_export);
		agt.dut_out_tx_port.connect(scb.dut_out_export);
	end
endfunction: connect_phase

endclass: env 
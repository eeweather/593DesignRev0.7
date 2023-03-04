/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   UVM agent creates the following components: a monitor, a driver and
*   sequencer for an active agent, a coverage_collector if it is requested. It
*   also connects ports and gives the sequencer to the agent_config
*/
 
class agent extends uvm_agent;
	`uvm_component_utils(agent)

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

uvm_analysis_port #(item_base) dut_in_tx_port;
uvm_analysis_port #(item_base) dut_out_tx_port;

uvm_sequencer #(item_base) sqr;
driver drv;
monitor mon;
coverage_collector cov;
agent_config agent_cfg;

virtual function void build_phase(uvm_phase phase);

	//create ports for interfacing with DUT
	dut_in_tx_port = new("dut_in_tx_port", this);
	dut_out_tx_port = new("dut_out_tx_port", this);
	
	//if the agent_config does not exist, make a scene
	if(!uvm_config_db #(agent_config)::get(this, "", "agent_cfg", agent_cfg)) `uvm_fatal(get_type_name(), "no agent_cfg in uvm_config_db")
	
	mon = monitor::type_id::create("mon", this);

	//if the agent is active, create a sequencer and a driver
	if (agent_cfg.active == UVM_ACTIVE) begin
		sqr = new("sqr", this);
		drv = driver::type_id::create("drv",this);
	end
	
	//pass the newly created sequencer, if there is one, to the agent_config
	agent_cfg.sqr = this.sqr;

	//if you want coverage, better make a coverage collector!
	if(agent_cfg.enable_coverage) cov= coverage_collector::type_id::create("cov", this);

endfunction: build_phase

virtual function void connect_phase(uvm_phase phase);

	//connect the DUT interfacing ports to the monitor
	mon.dut_in_tx_port.connect(dut_in_tx_port);
	mon.dut_out_tx_port.connect(dut_out_tx_port);

	//if active agent, connect driver to sequencer
	if (agent_cfg.active == UVM_ACTIVE) drv.seq_item_port.connect(sqr.seq_item_export);

	//if you want coverage, better connect the monitor to the coverage_collector!
	if (agent_cfg.enable_coverage) mon.dut_in_tx_port.connect(cov.analysis_export);

endfunction: connect_phase

endclass: agent //this line ends the agent clas
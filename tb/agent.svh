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

uvm_analysis_port #(item_base) dut_out_tx_port;

uvm_active_passive_enum  	active			= UVM_ACTIVE;
virtual processor_if	 	vif;

uvm_sequencer #(item_base) sqr;
driver drv;
monitor mon;

virtual function void build_phase(uvm_phase phase);

	//create port for interfacing with DUT
	dut_out_tx_port = new("dut_out_tx_port", this);
	
	mon = monitor::type_id::create("mon", this);

	//if the agent is active, create a sequencer and a driver
	if (active == UVM_ACTIVE) begin
		sqr = new("sqr", this);
		drv = driver::type_id::create("drv",this);
	end
	
endfunction: build_phase

virtual function void connect_phase(uvm_phase phase);

	//connect the DUT interfacing port to the monitor
	mon.dut_out_tx_port.connect(dut_out_tx_port);

	//if active agent, connect driver to sequencer
	if (active == UVM_ACTIVE) drv.seq_item_port.connect(sqr.seq_item_export);

endfunction: connect_phase

endclass: agent //this line ends the agent class :)

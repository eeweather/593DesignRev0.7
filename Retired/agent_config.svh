/*UVM TX agent configuration (agent_config.svh)
 * Daniel Keller, 2021, Siemens EDA
 * Description: 
 *		Agent configuration for calculator UVM TB 
 *		
 */

class agent_config extends uvm_object;
	`uvm_object_utils(agent_config)

function new(string name="agent_config");
	super.new(name);
endfunction

uvm_active_passive_enum  	active			= UVM_PASSIVE;
//dk3/8 int			 	monitor_verbosity	= UVM_DEBUG;
bit			 	enable_coverage		= 1;
int			 	num_items		= 1;
uvm_sequencer #(item_base) 	sqr;
virtual processor_if	 	vif_0;
virtual processor_if	 	vif_1;
virtual processor_if	 	vif_2;
virtual processor_if	 	vif_3;

endclass: agent_config

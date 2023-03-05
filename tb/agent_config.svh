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
int			 	monitor_verbosity	= UVM_DEBUG;
bit			 	enable_coverage		= 1;
int			 	num_items		= 1;
uvm_sequencer #(item_base) 	sqr;
virtual tinyalu_bfm	 	vif;

endclass: agent_config

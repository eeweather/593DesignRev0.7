/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Environment config enables the scoreboard and has an agent_config. While
*   not useful at this moment, this file is nice to have as the environment
*   grows more complex
*/

class env_config extends uvm_object;
	`uvm_object_utils(env_config);

function new(string name="env_config");
	super.new(name);
endfunction

//TODO: move some of the static stuff from agent into here :)
bit enable_scoreboard = 1;

endclass: env_config

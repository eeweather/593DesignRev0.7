/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Environment config enables the scoreboard and is created for future
*   features. While not useful at this moment, this file is nice to have as the environment
*   grows more comples
*/

class env_config extends uvm_object;
	`uvm_object_utils(env_config);

function new(string name="env_config");
	super.new(name);
endfunction

//this is where some agent enums for active/passive would go, as well as
//turning off coverage would go for future implementations that require it
bit enable_scoreboard = 1;

endclass: env_config

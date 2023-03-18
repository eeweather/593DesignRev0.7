/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   item store constrains to store operation with valid address
*/

class item_store extends item_base;
    `uvm_object_utils(item_store);

    function new(string name="item_store");
	    super.new(name);
    endfunction
    
    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint load_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store;}
    constraint temp_valid_address {inst[14:1] < MAX_ADDR;}

 
endclass : item_store

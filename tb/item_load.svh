/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   item load parameterized to load op and only valid addresses
*/
class item_load extends item_base;
    `uvm_object_utils(item_load);

    function new(string name="item_load");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint load_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load;}
    constraint temp_valid_address {inst[14:1] < MAX_ADDR;}
 
endclass : item_load

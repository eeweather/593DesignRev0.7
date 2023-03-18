/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   item alu based on item_base constrains the opcode to only valid ops
*/

class item_alu extends item_base;
    `uvm_object_utils(item_alu);

    function new(string name="item_alu");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint alu_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] inside {[op_add:op_sp2], op_shl, op_shr};}
    
 
endclass : item_alu

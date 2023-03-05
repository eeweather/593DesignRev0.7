/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   single cycle ALU sequence item 
*/


class item_single extends item_base;
    `uvm_object_utils(item_alu);

    function new(string name="item_single");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid single cycle alu operations
    constraint single_cycle {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] inside {[op_add:op_xor], op_shl, op_shr};}
    
 
endclass : item_single

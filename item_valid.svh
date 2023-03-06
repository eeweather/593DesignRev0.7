/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   return only 'legal' opcodes
*/


class item_valid extends item_base;
    `uvm_object_utils(item_alu);

    function new(string name="item_valid");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the 'legal/valid' operations 
    constraint valid_op {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] inside {[op_nop:op_shr], op_nop1};}
    
 
endclass : item_valid

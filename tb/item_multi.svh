/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*  multi cycle ALU sequence item.
*/


class item_multi extends item_base;
    `uvm_object_utils(item_multi);

    function new(string name="item_multi");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid mu;ti cycle alu operations
    constraint multi_cycle {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] inside {[op_mul:op_sp2]};}
    
 
endclass : item_multi

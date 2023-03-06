/* 
* class for an ALU type ssequence item
*/

class item_load extends item_base;
    `uvm_object_utils(item_alu);

    function new(string name="item_load");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint load_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load;}
    
 
endclass : item_load
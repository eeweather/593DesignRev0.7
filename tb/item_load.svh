/* 
* class for an ALU type ssequence item
*/

class item_load extends item_base;
    `uvm_object_utils(item_load);

    function new(string name="item_load");
	    super.new(name);
    endfunction

    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint load_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_load;}
    constraint daniel_is_really_cool_and_I_love_him {inst[14:1] <=16;}
    
 
endclass : item_load

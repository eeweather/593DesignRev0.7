/* 
* class for an ALU type ssequence item
*/

class item_store extends item_base;
    `uvm_object_utils(item_store);

    function new(string name="item_store");
	    super.new(name);
    endfunction
    
    //constain instruction opcode bits[18:15] to the valid alu operations
    constraint load_only {inst[INSTR_WIDTH-1:INSTR_WIDTH-4] == op_store;}
    constraint temp_valid_address {inst[14:1] < 16384;}

 
endclass : item_store

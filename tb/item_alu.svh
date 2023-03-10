/* 
* class for an ALU type ssequence item
*/

class item_alu extends item_base;
    `uvm_object_utils(item_alu);

    function new(string name="item_alu");
	    super.new(name);
    endfunction

    //constain to alu opcodes
    constraint alu_only {inst[15:12] inside {[op_add:op_sp2], op_or};}
    
    //constain destination register to be dif than source regs for testing
    constraint difRegs {inst[11:10] != (inst[9:8] || inst[7:6]);}
  
    //potentially add further constraints on other bit field?

endclass : item_alu
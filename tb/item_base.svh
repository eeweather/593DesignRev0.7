/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   base sequence item containing relevent signals  and methods for
*   manipulating them.
*/

 class item_base extends uvm_sequence_item;
	`uvm_object_utils(item_base)

	function new(string name="tx_item");
		super.new(name);
	endfunction

	//a randomized 19 bit instruction
	rand instruction_t inst;
	

	//the following virtual functions must be overwritten from uvm_sequence_items and do what their names suggest
	virtual function void do_copy(uvm_object rhs);
		item_base tx_rhs;
		if (!$cast(tx_rhs, rhs)) `uvm_fatal(get_type_name(), "Illegal rhs");

		super.do_copy(rhs);
		this.inst = tx_rhs.inst;
	endfunction : do_copy

	virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		item_base tx_rhs;
		if (!$cast(tx_rhs, rhs)) `uvm_fatal(get_type_name(), "Illegal rhs")

		return(super.do_compare(rhs, comparer) &&
			(this.inst === tx_rhs.inst));

	endfunction: do_compare


	virtual function string convert2string();
		string s = super.convert2string();
		$sformat(s, "\n inst: %0b", inst);
		return s;
	endfunction

	virtual function void do_print(uvm_printer printer);
		printer.m_string = convert2string();
	endfunction: do_print

	virtual function void do_pack(uvm_packer packer);
		return;
	endfunction: do_pack

	virtual function void do_unpack(uvm_packer packer);
		return;
	endfunction: do_unpack

	virtual function void do_record(uvm_recorder recorder);
		return;
	endfunction: do_record

endclass: item_base





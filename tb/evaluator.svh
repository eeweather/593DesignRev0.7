/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Evaluator is used to collect and store expected transactions and actual
*   transactions, compares them, and reports how many were successful/unsuccessful.
*/

class evaluator extends uvm_component;
	`uvm_component_utils(evaluator)

	static bit test;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	//ports for expected value(s) and actual value(s). uvm_tlm_analysis_fifo stores transactions
	uvm_analysis_export #(item_base) expected_export;
	uvm_tlm_analysis_fifo #(item_base) expected_fifo;

	uvm_analysis_export #(item_base) actual_export;
	uvm_tlm_analysis_fifo #(item_base) actual_fifo;

	int match, mismatch;

	virtual function void build_phase(uvm_phase phase);

		//creates ports and FIFOs
		expected_fifo = new("expected_fifo", this);
		expected_export = new("expected_export", this);
		actual_fifo = new("actual_fifo", this);
		actual_export = new("actual_export", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		//connect ports to respective FIFOs
		expected_export.connect(expected_fifo.analysis_export);
		actual_export.connect(actual_fifo.analysis_export);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		item_base expected_tx;
		item_base actual_tx;
		forever begin

			//get the next expected transaction and actual transaction
			expected_fifo.get(expected_tx);
			actual_fifo.get(actual_tx);
			
			//if they match, party, if not, crash and burn
			if(actual_tx.compare(expected_tx)) match++;
			else begin
				`uvm_error("Evaluator", $sformatf("exp: %d does not match act: %d", expected_tx.inst, actual_tx.inst))
				mismatch++;
			end
		end
	endtask: run_phase

	virtual function void report_phase(uvm_phase phase);
		//hey evaluator, how many matches and mismatches did I have?
		`uvm_info("Evaluator", $sformatf("Passed=%0d, Failed =%0d", match, mismatch), UVM_LOW)
	endfunction: report_phase

endclass: evaluator
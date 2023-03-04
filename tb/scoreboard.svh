/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*
*   Scoreboard creates the predictor and evaluator and connects the ports for
*   the aformentioned components. 
*/


class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	uvm_analysis_export #(item_base) dut_in_export;
	uvm_analysis_export #(item_base) dut_out_export;
	predictor pred;
	evaluator eval;


	virtual function void build_phase(uvm_phase phase);
		//create ports, predictor, and evaluator
		dut_in_export = new("dut_in_export", this);
		dut_out_export = new("dut_out_export", this);
		pred = predictor::type_id::create("pred", this);
		eval = evaluator::type_id::create("eval", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		//connect predictor to DUT interfacing input port and evaluator port
		dut_in_export.connect(pred.analysis_export);
		pred.expected_port.connect(eval.expected_export);
		//connect evaluator to DUT interfacing output port
		dut_out_export.connect(eval.actual_export);
	endfunction: connect_phase

endclass: scoreboard
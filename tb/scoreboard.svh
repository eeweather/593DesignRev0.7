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

//	uvm_analysis_export #(item_base) dut_in_export;
	uvm_analysis_export #(item_base) dut_out_export_0;
	uvm_analysis_export #(item_base) dut_out_export_1;
	uvm_analysis_export #(item_base) dut_out_export_2;
	uvm_analysis_export #(item_base) dut_out_export_3;
	predictor pred_0, pred_1, pred_2, pred_3;
	evaluator eval_0, eval_1, eval_2, eval_3;


	virtual function void build_phase(uvm_phase phase);
		//create ports, predictor, and evaluator
//		dut_in_export = new("dut_in_export", this);
		dut_out_export_0 = new("dut_out_export_0", this);
		dut_out_export_1 = new("dut_out_export_1", this);
		dut_out_export_2 = new("dut_out_export_2", this);
		dut_out_export_3 = new("dut_out_export_3", this);
		pred_0 = predictor::type_id::create("pred_0", this);
		pred_1 = predictor::type_id::create("pred_1", this);
		pred_2 = predictor::type_id::create("pred_2", this);
		pred_3 = predictor::type_id::create("pred_3", this);
		eval_0 = evaluator::type_id::create("eval_0", this);
		eval_1 = evaluator::type_id::create("eval_1", this);
		eval_2 = evaluator::type_id::create("eval_2", this);
		eval_3 = evaluator::type_id::create("eval_3", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		//connect predictor to DUT interfacing input port and evaluator port
//		dut_in_export.connect(pred.analysis_export);
		dut_out_export_0.connect(pred_0.analysis_export);
		dut_out_export_1.connect(pred_1.analysis_export);
		dut_out_export_2.connect(pred_2.analysis_export);
		dut_out_export_3.connect(pred_3.analysis_export);
		pred_0.expected_port.connect(eval_0.expected_export);
		pred_1.expected_port.connect(eval_1.expected_export);
		pred_2.expected_port.connect(eval_2.expected_export);
		pred_3.expected_port.connect(eval_3.expected_export);
		//connect evaluator to DUT interfacing output port
		dut_out_export_0.connect(eval_0.actual_export);
		dut_out_export_1.connect(eval_1.actual_export);
		dut_out_export_2.connect(eval_2.actual_export);
		dut_out_export_3.connect(eval_3.actual_export);
	endfunction: connect_phase

	virtual function void report_phase(uvm_phase phase);
		int match = eval_0.get_matches() + eval_1.get_matches() + eval_2.get_matches() + eval_3.get_matches();
		int mismatch = eval_0.get_mismatches() + eval_1.get_mismatches() + eval_2.get_mismatches() + eval_3.get_mismatches();
	
		`uvm_info(get_type_name(), $sformatf("TOTAL: Passed=%0d, Failed =%0d", match, mismatch), UVM_LOW)
	endfunction: report_phase
endclass: scoreboard

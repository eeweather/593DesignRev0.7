/*
//  ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
//  Modified Scoreboard to include DPI-C predictor function
//
*/

import "DPI-C" function shortint predictor(byte unsigned a, byte unsigned b, operation_t op_set);

class scoreboard extends uvm_subscriber #(result_transaction);
   `uvm_component_utils(scoreboard);


   uvm_tlm_analysis_fifo #(sequence_item) cmd_f;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new


   function void build_phase(uvm_phase phase);
      cmd_f = new ("cmd_f", this);
   endfunction : build_phase

   function void write(result_transaction t);
      string data_str;
      sequence_item cmd;
      result_transaction predicted;

      predicted = new("predicted");

      do
        if (!cmd_f.try_get(cmd))
          $fatal(1, "Missing command in self checker");
      while ((cmd.op == no_op) || (cmd.op == rst_op));

      //Call c predictor function
      predicted.result = predictor(cmd.A, cmd.B, cmd.op);
      
      data_str = {                    cmd.convert2string(), 
                  " ==>  Actual "  ,    t.convert2string(), 
                  "/Predicted ",predicted.convert2string()};

      if (!predicted.compare(t))
        `uvm_error("SELF CHECKER", {"FAIL: ",data_str})
      else
        `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)

   endfunction : write
endclass : scoreboard







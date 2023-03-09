module top_hdl;
import uvm_pkg::*;
import tinyalu_pkg::*;
`include "uvm_macros.svh"


   //one interface per processor
   processor_if vif_0();
   processor_if vif_1();
   processor_if vif_2();
   processor_if vif_3();

   alumifiu_dut PROC0 (
	   .instr(vif_0.instr),
	   .clk(vif_0.clk),
	   .reset_n(vif_0.reset_n),
	   .done(vif_0.done),
	   .A(vif_0.A),
	   .B(vif_0.B),
	   .result(vif_0.result),
	   .datatomem(vif_0.datatomem),
	   .datafrommem(vif_0.datafrommem),
	   .read_req(vif_0.read_req),
	   .write_req(vif_0.write_req),
	   .addrout(vif_0.addrout),
	   .mem_resp(vif_0.mem_resp),
	   .cs(vif_0.cs)
   );

   
   alumifiu_dut PROC1 (
	   .instr(vif_1.instr),
	   .clk(vif_1.clk),
	   .reset_n(vif_1.reset_n),
	   .done(vif_1.done),
	   .A(vif_1.A),
	   .B(vif_1.B),
	   .result(vif_1.result),
	   .datatomem(vif_1.datatomem),
	   .datafrommem(vif_1.datafrommem),
	   .read_req(vif_1.read_req),
	   .write_req(vif_1.write_req),
	   .addrout(vif_1.addrout),
	   .mem_resp(vif_1.mem_resp),
	   .cs(vif_1.cs)
   );
   
   alumifiu_dut PROC2 (
	   .instr(vif_2.instr),
	   .clk(vif_2.clk),
	   .reset_n(vif_2.reset_n),
	   .done(vif_2.done),
	   .A(vif_2.A),
	   .B(vif_2.B),
	   .result(vif_2.result),
	   .datatomem(vif_2.datatomem),
	   .datafrommem(vif_2.datafrommem),
	   .read_req(vif_2.read_req),
	   .write_req(vif_2.write_req),
	   .addrout(vif_2.addrout),
	   .mem_resp(vif_2.mem_resp),
	   .cs(vif_2.cs)
   );
   
   alumifiu_dut PROC3 (
	   .instr(vif_3.instr),
	   .clk(vif_3.clk),
	   .reset_n(vif_3.reset_n),
	   .done(vif_3.done),
	   .A(vif_3.A),
	   .B(vif_3.B),
	   .result(vif_3.result),
	   .datatomem(vif_3.datatomem),
	   .datafrommem(vif_3.datafrommem),
	   .read_req(vif_3.read_req),
	   .write_req(vif_3.write_req),
	   .addrout(vif_3.addrout),
	   .mem_resp(vif_3.mem_resp),
	   .cs(vif_3.cs)
   );

    memory_subsystem MSS (
        .clk(vif_0.clk),                 
        .reset_n(vif_0.reset_n),              
        .mem_write_data_0(vif_0.datatomem),   
        .mem_write_data_1(vif_1.datatomem),   
        .mem_write_data_2(vif_2.datatomem),   
        .mem_write_data_3(vif_3.datatomem),   
        .processor_req_0(vif_0.cs),                     	
        .processor_req_1(vif_1.cs),                     	
        .processor_req_2(vif_2.cs),                     	
        .processor_req_3(vif_3.cs),                     	
        .mem_read_req_0(vif_0.read_req), 
        .mem_read_req_1(vif_1.read_req), 
        .mem_read_req_2(vif_2.read_req), 
        .mem_read_req_3(vif_3.read_req), 
        .mem_write_req_0(vif_0.write_req),  
        .mem_write_req_1(vif_1.write_req),  
        .mem_write_req_2(vif_2.write_req),  
        .mem_write_req_3(vif_3.write_req),  
        .addr_0(vif_0.addrout),
        .addr_1(vif_1.addrout),
        .addr_2(vif_2.addrout),
        .addr_3(vif_3.addrout),
        .mem_read_data_0(vif_0.datafrommem),   
        .mem_read_data_1(vif_1.datafrommem),   
        .mem_read_data_2(vif_2.datafrommem),   
        .mem_read_data_3(vif_3.datafrommem),   
        .processor_resp_0(vif_0.mem_resp),
        .processor_resp_1(vif_1.mem_resp),
        .processor_resp_2(vif_2.mem_resp),
        .processor_resp_3(vif_3.mem_resp)
);



   initial begin
	   uvm_config_db #(virtual processor_if)::set(null, "*", "vif_0", vif_0);
	   uvm_config_db #(virtual processor_if)::set(null, "*", "vif_1", vif_1);
	   uvm_config_db #(virtual processor_if)::set(null, "*", "vif_2", vif_2);
	   uvm_config_db #(virtual processor_if)::set(null, "*", "vif_3", vif_3);
   end

endmodule : top_hdl

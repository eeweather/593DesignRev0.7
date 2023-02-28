//NOTE: this is not yet fully tested. While there are no compilation errors,
//there will be errors with multiple continuous drivers of op, result, and
//addrout. All three are modified by multiple subcomponents.
//TODO: resolve

module top_hdl();
import tinyalu_pkg::*;

   //testbench signals, placed in top for fun, but will be inputs to top_hdl at some point
   bit         		clk;
   bit         		reset_n;

   memory_if m_if();
   //one interface per processor
   processor_if proc_if_0 (m_if.clk, m_if.reset_n);
   processor_if proc_if_1 (m_if.clk, m_if.reset_n);
   processor_if proc_if_2 (m_if.clk, m_if.reset_n);
   processor_if proc_if_3 (m_if.clk, m_if.reset_n);

   memory_subsystem MEM (.clk(m_if.clk), .reset_n(m_if.reset_n), .mem_write_data(m_if.mem_write_data), .processor_req_0(proc_if_0.processor_req), 
	   		 .processor_req_1(proc_if_1.processor_req), .processor_req_2(proc_if_2.processor_req), .processor_req_3(proc_if_3.processor_req), 
			 .mem_read_req(m_if.mem_read_req), .mem_write_req(m_if.mem_write_req), .addr(proc_if_0.addrout), 
			 .mem_read_data(m_if.mem_read_data), .processor_resp_0(proc_if_0.processor_resp), .processor_resp_1(proc_if_1.processor_resp),
			 .processor_resp_2(proc_if_2.processor_resp), .processor_resp_3(proc_if_3.processor_resp));

   ALU593 ALU0 		(.clk(m_if.clk), .reset_n(m_if.reset_n), .A(proc_if_0.A), .B(proc_if_0.B), .op(proc_if_0.op), .start(proc_if_0.start), .done(proc_if_0.done), 
	        	 .result(proc_if_0.result), .error(proc_if_0.error));


   memInerf MI0 	(.clk(m_if.clk), .reset_n(m_if.reset_n), .store(proc_if_0.store), .load(proc_if_0.load), .mem_resp(proc_if_0.processor_req), 
	                 .result(proc_if_0.IU_result), .addr(proc_if_0.addr), .datatofrommem(proc_if_0.datatofrommem), .mem_done(proc_if_0.mem_done), 
			 .datatoinst(proc_if_0.datatoinst), .write_req(m_if.mem_write_req), .read_req(m_if.mem_read_req), .addrout(proc_if_0.addrout));
 
   instructionUnit IU0 	(.clk(clk), .reset_n(reset_n), .mem_done(proc_if_0.mem_done), .alu_done(proc_if_0.alu_done), .data(proc_if_0.datatoinst), 
	                 .alu_result(proc_if_0.alu_result), .start(proc_if_0.IU_start), .A(proc_if_0.IU_A), .B(proc_if_0.IU_B), .op(proc_if_0.op), 
			 .Addr(proc_if_0.addr), .result(proc_if_0.IU_result), .store(proc_if_0.store), .load(proc_if_0.load));
   
   //TODO: just for fun, remove for testing
   initial begin
      m_if.clk = 0;
      forever begin
         #10 m_if.clk = ~clk;
      end
   end

   initial begin
      m_if.reset_n = 1;
      #50 m_if.reset_n = 0;
   end

endmodule : top_hdl

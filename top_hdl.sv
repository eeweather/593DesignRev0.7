//NOTE: this has not been tested yet for validity. Many errors are assumed. First a basic test will need to be created for just 1/4 of the system, TODO tomorrow

module top_hdl();
import tinyalu_pkg::*;

   //TODO: move signals to if/bfm. this will allows for one set of each signal
   //and then four instances of the interface to clean a lot of the
   //_0, _1, etc. out of the top
   
   bit         		clk;
   bit         		reset_n;

   //ALU signals 
   byte unsigned        A_0, A_1, A_2, A_3;
   byte unsigned        B_0, B_1, B_2, B_3;
   alu_opcode_t  	op_0, op_1, op_2, op_3;
   bit           	start_0, start_1, start_2, start_3;
   bit           	done_0, done_1, done_2, done_3;
   logic [15:0]  	result_0, result_1, result_2, result_3;
   alu_opcode_t  	op_set_0, op_set_1, op_set_2, op_set_3;
   bit 			error_0, error_1, error_2, error_3;
            
   //memory signals
   logic [15:0] mem_write_data; 
   logic processor_req_0, processor_req_1, processor_req_2, processor_req_3;
   logic mem_read_req, mem_read_req_0, mem_read_req_1, mem_read_req_2, mem_read_req_3;
   logic mem_write_req, mem_write_req_0, mem_write_req_1, mem_write_req_2, mem_write_req_3;  
   logic [13:0] addr;
   logic [15:0] mem_read_data;
   logic processor_resp_0, processor_resp_1, processor_resp_2, processor_resp_3;

   //memory interface signals
   logic store_0, store_1, store_2, store_3;
   logic load_0, load_1, load_2, load_3;
   logic [15:0] datatofrommem_0, datatofrommem_1, datatofrommem_2, datatofrommem_3;
   logic mem_done_0, mem_done_1, mem_done_2, mem_done_3;
   logic [7:0] datatoinst_0, datatoinst_1, datatoinst_2, datatoinst_3;
   logic write_req;
   logic read_req;
   logic [13:0] addrout;

   //IU signals
   logic alu_done;
   logic [7:0] data;
   logic [15:0] alu_result;

   assign {op_3, op_2, op_1, op_0} = {op_set_3, op_set_2, op_set_1, op_set_0};

   //TODO: only one processor can access memory at a time, update with logic
   //for processor_req for multiple accesses at a time
   assign mem_read_req = mem_read_req_0 || mem_read_req_1 || mem_read_req_2 || mem_read_req_3;
   assign mem_write_req = mem_write_req_0 || mem_write_req_1 || mem_write_req_2 || mem_write_req_3;

   assign datatofrommem_0 = (load_0 && processor_req_0) ? mem_read_data : 16'hz;
   assign datatofrommem_1 = (load_1 && processor_req_0) ? mem_read_data : 16'hz;
   assign datatofrommem_2 = (load_2 && processor_req_0) ? mem_read_data : 16'hz;
   assign datatofrommem_3 = (load_3 && processor_req_0) ? mem_read_data : 16'hz;

   assign mem_write_data = (store_0 && processor_req_0) ? datatofrommem_0 : 
	   		   (store_1 && processor_req_1) ? datatofrommem_1 :
	   		   (store_2 && processor_req_2) ? datatofrommem_2 :
	   		   (store_3 && processor_req_3) ? datatofrommem_3 : 16'hz;


   ALU593 ALU1 (.clk(clk), .reset_n(reset_n), .A(A_0), .B(B_0), .op(op_0), .start(start_0), .done(done_0), .result(result_0), .error(error_0));

   memory_subsystem MEM (.clk(clk), .reset_n(reset_n), .mem_write_data(mem_write_data), .processor_req_0(processor_req_0), 
	   		 .processor_1_req(processor_req_1), .processor_req_2(processor_req_2), .processor_req_3(processor_req_3), 
			 .mem_read_req(mem_read_req), .mem_write_req(mem_write_req), .addr(addrout), .mem_read_data(mem_read_data), 
			 .processor_resp_0(processor_resp_0), .processor_resp_1(processor_resp_1), .processor_resp_2(processor_resp_2),
			 .processor_resp_3(processor_resp_3));

   memInerf MI0 (.clk(clk), .reset_n(reset_n), .store(store_0), .load(load_0), .mem_resp(processor_req_0), .result(result_0), .addr(addr),
        	 .datatofrommem(datatofrommem_0), .mem_done(mem_done_0), .datatoinst(datatoinst_0), .write_req(mem_write_req_0),
        	 .read_req(mem_read_req_0), .addrout(addrout));
    
   instructionUnit IU1 (.clk(clk), .reset_n(reset_n), .mem_done(mem_done_0), .alu_done(alu_done_0), .data(datatoinst_0), .alu_result(alu_result_0),
	                .start(start_0), .A(A_0), .B(B_0), .op(op_0), .Addr(addrout), .result(result_0), .store(store_0), .load(load_0));


   //TODO: just for fun, remove for testing
   initial begin
      clk = 0;
      forever begin
         #10;
         clk = ~clk;
      end
   end

endmodule : top_hdl

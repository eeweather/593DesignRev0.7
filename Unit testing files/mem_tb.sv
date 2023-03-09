//NOTE: this is not yet fully tested. While there are no compilation errors,
//there will be errors with multiple continuous drivers of op, result, and
//addrout. All three are modified by multiple subcomponents.
//TODO: resolve

module mem_tb();
import tinyalu_pkg::*;

   //testbench signals, placed in top for fun, but will be inputs to top_hdl at some point

   parameter NUM_TESTS = 1000;

   logic [NUM_TESTS-1:0] [13:0] addr_array;
   logic [NUM_TESTS-1:0] [15:0] data_array;

   logic[15:0] read_data;



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
   

		 
   initial begin
      m_if.clk = 0;
      forever begin
         #10 m_if.clk = ~m_if.clk;
      end
   end

   initial begin
      m_if.reset_n = 1;
      #50 m_if.reset_n = 0;
	
      proc_if_0.processor_req = 0;
      proc_if_1.processor_req = 0;
      proc_if_2.processor_req = 0;
      proc_if_3.processor_req = 0;
      
      
      for(int i=0; i < NUM_TESTS; i++) write($random(), $urandom_range(3), $urandom_range(4000), i);

      #100;
      
      for(int j=0; j < NUM_TESTS; j++) begin
	 read($urandom_range(3), addr_array[j], read_data);
	 if(read_data != data_array[j]) $error("wrote %d to addr %d, read back %d", data_array[j], addr_array[j], read_data);
      end
      #300 $stop();
   end


task read(input int which_proc, logic [13:0] addr, output [15:0] data);
begin
        proc_if_0.addrout = addr;
        m_if.mem_read_req = 1;
	case(which_proc)
		0: proc_if_0.processor_req = 1;
		1: proc_if_1.processor_req = 1;
		2: proc_if_2.processor_req = 1;
		3: proc_if_3.processor_req = 1;
		default: $error ("invalid proc read");
	endcase
	#10 data = m_if.mem_read_data;
	#10 m_if.mem_read_req = 0;
	proc_if_0.processor_req = 0;
	proc_if_1.processor_req = 0;
	proc_if_2.processor_req = 0;
	proc_if_3.processor_req = 0;
end
endtask


task write(input logic [15:0] data, int which_proc, logic [13:0] addr, int i);
begin
	#10 m_if.mem_write_data = data;
	proc_if_0.addrout = addr;
	m_if.mem_write_req = 1;
	case (which_proc)
		0: proc_if_0.processor_req = 1;
		1: proc_if_1.processor_req = 1;
		2: proc_if_2.processor_req = 1;
		3: proc_if_3.processor_req = 1;
		default: $error ("invalid proc write");
	endcase
	#20 m_if.mem_write_req = 0;
	proc_if_0.processor_req = 0;
	proc_if_1.processor_req = 0;
	proc_if_2.processor_req = 0;
	proc_if_3.processor_req = 0;

	for(int overwrite = 0; overwrite < NUM_TESTS; overwrite ++) begin
		if(addr_array[overwrite] == addr) data_array[overwrite] = data;
	end
        addr_array[i] = addr;
	data_array[i] = data;


end
endtask


endmodule : mem_tb

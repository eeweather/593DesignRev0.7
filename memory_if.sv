interface memory_if();
import tinyalu_pkg::*;

   //system signals
   bit clk;
   bit reset_n;

   logic [15:0] mem_write_data; 
   logic mem_read_req;
   logic mem_write_req;
   logic [15:0] mem_read_data;

   task system_reset();
      reset_n = 1'b0;
      @(negedge clk);
      @(negedge clk);
      reset_n = 1'b1;
   endtask : system_reset

endinterface : memory_if

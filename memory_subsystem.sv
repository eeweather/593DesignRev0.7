// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>
//
//
// Memory subystem, at write request or ready request, reads in data or write out
// data from correct processor. Processors are prioritized by number, 0 first, 3 last.
// Loads are processed before stores
// All actions take a max of two cycles, allowing all requests to process in the 
// 10 cycle mem time.
// grant given to processor at its turn.
//

module memory_subsystem
#(
   parameter MEM_SIZE = 16*1024,  // 16KB
   parameter DATA_SIZE = 2       
   //parameter BLOCK_SIZE = 2  
)(
   input logic clk,                 
   input logic reset_n,               
   input logic [DATA_SIZE*8-1:0] mem_write_data_0, mem_write_data_1, mem_write_data_2, mem_write_data_3,  
   input logic processor_req_0,
   input logic processor_req_1,   
   input logic processor_req_2,  	
   input logic processor_req_3,
   input logic mem_read_req_0, mem_read_req_1, mem_read_req_2, mem_read_req_3, 
   input logic mem_write_req_0, mem_write_req_1, mem_write_req_2, mem_write_req_3,
   input logic [13:0] addr_0, addr_1, addr_2, addr_3,

   output logic [DATA_SIZE*8-1:0] mem_read_data_0, mem_read_data_1, mem_read_data_2, mem_read_data_3,
   output logic processor_resp_0,
   output logic processor_resp_1,
   output logic processor_resp_2,
   output logic processor_resp_3 
);

// Coherency state type
typedef enum bit [1:0] {
   I = 2'b00, //Invalid
   M = 2'b01, //Modified
   S = 2'b10  //Shared
} coherency_t;

// Memory array
logic [DATA_SIZE*8-1:0] memory [MEM_SIZE];
logic [1:0] memory_coherency [MEM_SIZE];


//req and resp arrays for easier control
logic [3:0] current_proc_req;
logic [3:0] current_proc_resp;
logic [DATA_SIZE*8-1:0] mem_write_data;
logic mem_read_req;
logic mem_write_req;
logic [13:0] addr;
logic [DATA_SIZE*8-1:0] mem_read_data;
reg [3:0] requestor=0, grant;



assign current_proc_req = {processor_req_3, processor_req_2, processor_req_1, processor_req_0};

assign mem_read_data = (!reset_n)? '0: (mem_read_req)? memory[addr]: '0;

always_comb begin
   if(current_proc_req[0] && mem_read_req_0) begin
      addr = addr_0;
      grant = 0;
      mem_write_data = mem_write_data_0;
      mem_read_req = mem_read_req_0;
      if(mem_write_req_0) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[1] && mem_read_req_1) begin
      addr = addr_1;
      grant = 1;
      mem_write_data = mem_write_data_1;
      mem_read_req = mem_read_req_1;
      if(mem_write_req_1) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[2] && mem_read_req_2) begin
	addr = addr_2;
      grant = 2;
      mem_write_data = mem_write_data_2;
	mem_read_req = mem_read_req_2;
      if(mem_write_req_2) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[3] && mem_read_req_3) begin
      addr = addr_3;
      grant = 3;
      mem_write_data = mem_write_data_3;
      mem_read_req = mem_read_req_3;
      if(mem_write_req_3) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[0] && mem_write_req_0) begin
      addr = addr_0;
      grant = 0;
      mem_write_data = mem_write_data_0;
      mem_read_req = mem_read_req_0;
      if(mem_write_req_0) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[1] && mem_write_req_1) begin
      addr = addr_1;
      grant = 1;
      mem_write_data = mem_write_data_1;
      mem_read_req = mem_read_req_1;
      if(mem_write_req_1) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[2] && mem_write_req_2) begin
	addr = addr_2;
      grant = 2;
      mem_write_data = mem_write_data_2;
	mem_read_req = mem_read_req_2;
      if(mem_write_req_2) memory[addr] = mem_write_data;
   end
   else if(current_proc_req[3] && mem_write_req_3) begin
      addr = addr_3;
      grant = 3;
      mem_write_data = mem_write_data_3;
      mem_read_req = mem_read_req_3;
      if(mem_write_req_3) memory[addr] = mem_write_data;
   end
   else begin
      addr = '0;
      mem_read_req = 0;
      mem_write_req = 0;
      grant = 4;
   end

end

always @(negedge clk) begin
    case (grant)
	      0: begin
		mem_read_data_0 = mem_read_data;
            processor_resp_0 <= 1;
            processor_resp_1 <= 0;
            processor_resp_2 <= 0;
            processor_resp_3 <= 0;
	      end
	      1: begin
		mem_read_data_1 = mem_read_data;
            processor_resp_1 <= 1;
            processor_resp_0 <= 0;
            processor_resp_2 <= 0;
            processor_resp_3 <= 0;
	      end
	      2: begin
		mem_read_data_2 = mem_read_data;
            processor_resp_2 <= 1;
            processor_resp_0 <= 0;
            processor_resp_1 <= 0;
            processor_resp_3 <= 0;
	      end
	      3: begin
		mem_read_data_3 = mem_read_data;
            processor_resp_3 <= 1;
            processor_resp_0 <= 0;
            processor_resp_1 <= 0;
            processor_resp_2 <= 0;
	      end
            4: begin
            processor_resp_0 <= 0;
            processor_resp_1 <= 0;
            processor_resp_2 <= 0;
            processor_resp_3 <= 0;
            end
      endcase
end

always @(posedge clk) begin
   if (!reset_n) initialize_memory();
end

task initialize_memory();
int i;
begin
      for (i=0; i<$size(memory); i++) begin
              memory[i] <= i+1;
	      memory_coherency[i] <= I;
      end
end
endtask

endmodule : memory_subsystem

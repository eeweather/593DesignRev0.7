module memory_subsystem
#(
   parameter MEM_SIZE = 16*1024,  // 16KB
   parameter DATA_SIZE = 2,       
   parameter BLOCK_SIZE = 2,     
   parameter NUM_PROCESSORS = 4  
)(
   input logic clk,                 
   input logic reset_n,               
   input logic [DATA_SIZE*8-1:0] mem_write_data,   
   input logic processor_req_0,                     	
   input logic processor_req_1,   
   input logic processor_req_2,  	
   input logic processor_req_3,
   input logic mem_read_req, 
   input logic mem_write_req,  
   input logic [13:0] addr,

   output logic [DATA_SIZE*8-1:0] mem_read_data,   
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
logic [DATA_SIZE*8-1:0] memory [0:MEM_SIZE/BLOCK_SIZE-1];
logic [1:0] memory_coherency [0:MEM_SIZE/BLOCK_SIZE-1];


//req and resp arrays for easier control
logic [3:0] current_proc_req;
logic [3:0] current_proc_resp;

assign current_proc_req = {processor_req_3, processor_req_2, processor_req_1, processor_req_0};

assign {processor_resp_3, processor_resp_2, processor_resp_1, processor_resp_0} = current_proc_resp;

//arbitration interstitial signals
reg [3:0] requestor=0, grant;

//rr arbitration
always @(posedge clk) begin
   if(current_proc_req != 4'b0000) begin
      grant = current_proc_req[requestor];
      requestor = (requestor + 1) % 4;
   end else grant = 0;
end

//memory write/read functionality
always @(posedge clk) begin
   //reset
   if (reset_n) initialize_memory();
   //write
   else if (mem_write_req) begin
      memory[addr] = mem_write_data;
      memory_coherency[addr] = M;
      current_proc_resp = current_proc_req;
      //UNIT TEST DEBUG MESSAGE VV
      //$display("write: memory[%0d] = %d \tmem_write_data = %d \tmemory_coherency[%0d] = %b \t requestor = %b grant = %b \tcurrent_proc_req = %b", addr, memory[addr], mem_write_data, addr, memory_coherency[addr], requestor, grant, current_proc_req);
   //read
   end else if (mem_read_req) begin
      //TODO: determine what to do for reads of M memory and when to update
	      mem_read_data = memory[addr];
	      current_proc_resp = current_proc_req;
     //UNIT TEST DEBUG MESSAGE VV 
     //$display("read: memory[%0d] = %d \tmem_read_data = %d \tmemory_coherency[%0d] = %b \t requestor = %b grant = %b \tcurrent_proc_req = %b", addr, memory[addr], mem_read_data, addr, memory_coherency[addr], requestor, grant, current_proc_req);
   end
end

task initialize_memory;
begin
      for (int i=0; i<$size(memory); i++) begin
         memory[i] = '0;
	 memory_coherency[i] = I;
      end
end
endtask

endmodule : memory_subsystem

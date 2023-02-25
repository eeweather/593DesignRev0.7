module memory_subsystem
#(
   parameter MEM_SIZE = 16*1024,  // 16K bytes
   parameter DATA_SIZE = 2,       
   parameter BLOCK_SIZE = 2,     
   parameter LATENCY = 10,        // 10 cycle latency
   parameter NUM_PROCESSORS = 4  
)(
   input logic clk,                 
   input logic reset,               
   input logic [DATA_SIZE*8-1:0] mem_write_data,   
   input logic processor_0_req,                     	
   input logic processor_1_req,   
   input logic processor_2_req,  	
   input logic processor_3_req,
   input logic mem_read_req, 
   input logic mem_write_req,  
   input logic [13:0] addr,

   output logic [DATA_SIZE*8-1:0] mem_read_data,   
   output logic [DATA_SIZE*8-1:0] processor_0_resp,
   output logic [DATA_SIZE*8-1:0] processor_1_resp,
   output logic [DATA_SIZE*8-1:0] processor_2_resp,
   output logic [DATA_SIZE*8-1:0] processor_3_resp 
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
logic [3:0] [DATA_SIZE*8-1:0] current_proc_resp;

assign current_proc_req[0] = processor_0_req;
assign current_proc_req[1] = processor_1_req;
assign current_proc_req[2] = processor_2_req;
assign current_proc_req[3] = processor_3_req;

assign processor_0_resp = current_proc_resp[0];
assign processor_1_resp = current_proc_resp[1];
assign processor_2_resp = current_proc_resp[2];
assign processor_3_resp = current_proc_resp[3];

//arbitration interstitial signals
reg [3:0] requestor, grant;

//rr arbitration
always @(posedge clk) begin
   if(current_proc_req != 4'b0000) begin
      grant <= current_proc_req[requestor];
      requestor <= (requestor + 1) % 4;
   end else grant <= 0;
end

//memory write/read functionality
always @(posedge clk) begin
   //reset
   if (reset) begin
      for (int i=0; i<$size(memory); i++) begin
         memory[i] = '0;
	 memory_coherency[i] = I;
      end
   //write
   end else if (current_proc_req == 4'b0000 && mem_write_req) begin
      #LATENCY memory[addr] <= mem_write_data;
      memory_coherency[addr] <= M;
   //read
   end else if (current_proc_req == 4'b0000 && mem_read_req) begin
      //TODO: determine what to do for reads of M memory and when to update
      if (memory_coherency[addr] == M) current_proc_resp[grant] = 'x; //no read if bad data
      else #LATENCY current_proc_resp[grant] <= memory[addr];
   end
end

endmodule : memory_subsystem

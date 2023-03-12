module memory_subsystem
#(
   parameter MEM_SIZE = 100, //16*1024,  // 16KB
   parameter DATA_SIZE = 2,       
   parameter BLOCK_SIZE = 2  
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
logic [DATA_SIZE*8-1:0] memory [MEM_SIZE/BLOCK_SIZE];
logic [1:0] memory_coherency [MEM_SIZE/BLOCK_SIZE];


//req and resp arrays for easier control
logic [3:0] current_proc_req;
logic [3:0] current_proc_resp;
logic [DATA_SIZE*8-1:0] mem_write_data;
logic mem_read_req;
logic mem_write_req;
logic [13:0] addr;
logic [DATA_SIZE*8-1:0] mem_read_data;



assign current_proc_req = {processor_req_3, processor_req_2, processor_req_1, processor_req_0};

//assign {processor_resp_3, processor_resp_2, processor_resp_1, processor_resp_0} = current_proc_resp;

//arbitration interstitial signals
reg [3:0] requestor=0, grant;

//rr arbitration
always @(posedge clk) begin
   if(current_proc_req[0]) begin
      mem_read_req <= mem_read_req_0;
      mem_write_req <= mem_write_req_0;
      addr <= addr_0;
      grant <= 0;
   end
   else if(current_proc_req[1]) begin
      mem_read_req <= mem_read_req_1;
      mem_write_req <= mem_write_req_1;
      addr <= addr_1;
      grant <= 1;
   end
   else if(current_proc_req[2]) begin
	mem_read_req <= mem_read_req_2;
	mem_write_req <= mem_write_req_2;
	addr <= addr_2;
      grant <= 2;
   end
   else if(current_proc_req[3]) begin
      mem_read_req <= mem_read_req_3;
      mem_write_req <= mem_write_req_3;
      addr <= addr_3;
      grant <= 3;
   end
   else begin
      mem_read_req <= 0;
      mem_write_req <= 0;
      addr <= '0;
      grant <= 4;
   end


   //if(current_proc_req != 4'b0000) begin
      
      
      
      // grant <= current_proc_req[requestor];
      // requestor <= (requestor + 1) % 4;
     

      // case (grant)
	//       0: begin
	// 	//mem_write_data = mem_write_data_0;
	// 	mem_read_req <= mem_read_req_0;
	// 	mem_write_req <= mem_write_req_0;
	// 	addr <= addr_0;
	// 	//mem_read_data_0 = mem_read_data;
	//       end
	//       1: begin
	// 	//mem_write_data = mem_write_data_1;
	// 	mem_read_req <= mem_read_req_1;
	// 	mem_write_req <= mem_write_req_1;
	// 	addr <= addr_1;
	// 	//mem_read_data_1 = mem_read_data;
	//       end
	//       2: begin
	// 	//mem_write_data = mem_write_data_2;
	// 	mem_read_req <= mem_read_req_2;
	// 	mem_write_req <= mem_write_req_2;
	// 	addr <= addr_2;
	// 	//mem_read_data_2 = mem_read_data;
	//       end
	//       3: begin
	// 	//mem_write_data = mem_write_data_3;
	// 	mem_read_req <= mem_read_req_3;
	// 	mem_write_req <= mem_write_req_3;
	// 	addr <= addr_3;
	// 	//mem_read_data_3 = mem_read_data;
	//       end
      // endcase
   //end else grant <= 0;
end

always @(negedge clk) begin
    case (grant)
	      0: begin
		mem_write_data = mem_write_data_0;
		mem_read_data_0 = mem_read_data;
            @(posedge clk);
            processor_resp_0 <= 1;
            processor_resp_1 <= 0;
            processor_resp_2 <= 0;
            processor_resp_3 <= 0;
	      end
	      1: begin
		mem_write_data = mem_write_data_1;
		mem_read_data_1 = mem_read_data;
            @(posedge clk);
            processor_resp_1 <= 1;
            processor_resp_0 <= 0;
            processor_resp_2 <= 0;
            processor_resp_3 <= 0;
	      end
	      2: begin
		mem_write_data = mem_write_data_2;
		mem_read_data_2 = mem_read_data;
            @(posedge clk);
            processor_resp_2 <= 1;
            processor_resp_0 <= 0;
            processor_resp_1 <= 0;
            processor_resp_3 <= 0;
	      end
	      3: begin
		mem_write_data = mem_write_data_3;
		mem_read_data_3 = mem_read_data;
            @(posedge clk);
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

//memory write/read functionality
always @(posedge clk) begin
   //reset
   if (!reset_n) initialize_memory();
   //write
   else if (mem_write_req) begin
      memory[addr] <= mem_write_data;
      memory_coherency[addr] <= M;
 //     current_proc_resp <= current_proc_req;
      //UNIT TEST DEBUG MESSAGE VV
      //$display("write: memory[%0d] = %d \tmem_write_data = %d \tmemory_coherency[%0d] = %b \t requestor = %b grant = %b \tcurrent_proc_req = %b", addr, memory[addr], mem_write_data, addr, memory_coherency[addr], requestor, grant, current_proc_req);
   //read
   end else if (mem_read_req) begin
      //TODO: determine what to do for reads of M memory and when to update
	      mem_read_data <= memory[addr];
//	      current_proc_resp <= current_proc_req;
     //UNIT TEST DEBUG MESSAGE VV 
     //$display("read: memory[%0d] = %d \tmem_read_data = %d \tmemory_coherency[%0d] = %b \t requestor = %b grant = %b \tcurrent_proc_req = %b", addr, memory[addr], mem_read_data, addr, memory_coherency[addr], requestor, grant, current_proc_req);
   end
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

/*
// ECE593 Project 2023wi
//  Victoria Van Gaasbeck <vvan@pdx.edu>
//  Julia Filipchuk <bfilipc2@pdx.edu>
//  Emily Weatherford <ew22@pdx.edu>
//  Daniel Keller <dk27@pdx.edu>

Memory Interface Unit: 
o  16 KBytes system memory interface 
o  8 Bytes data size 
o  Makes read/ write request to memory 
 Read request: Asserts request, waits for read data. Removes request upon 
receiving response.  
  Write request: asserts request with write data, removes request upon receiving 
response. 

*/

module memInerf (
    input logic clk, reset_n,//from top
    input logic store, load, //from inst unit
    input logic mem_resp, //from mss
    input logic [15:0] result, //from inst unit
    input logic [13:0] addr, // from inst unit
    input logic [15:0] datafrommem, //from mss
    output logic [15:0] datatomem, // to mss
    output logic mem_done, // to instunit
    output logic [7:0] datatoinst, // to instunit
    output logic write_req, read_req, // to  mss
    output logic cs, // chip select to mss
    output logic [13:0] addrout // to mss
);

logic [3:0] counter;

assign cs = (write_req || read_req);
assign addrout = (!reset_n)? 0 : addr;

//handle store data
assign datatomem = (store)? result: 0;


always @(posedge clk) begin
    //if reset reset
    if (!reset_n) begin
        mem_done<=0;
        write_req <= 0;
        read_req <=0;
        datatoinst <= 0;
        counter <= 0;
    end
    // load signal comes in, set counter
    else if (load) begin
	    mem_done <=0;
	if (counter>9) begin
	    counter<=0;
        mem_done <=1; 
	end
        counter++;
        if (mem_resp) begin
            //when mem_resp goes high, put data on datatofrommem onto datatoinst
            datatoinst <= datafrommem[7:0];
            //end with read_req low
            read_req <= 0;
        end
    end
    // store signal comes in, set counter
    else if (store) begin
	    mem_done<=0;
	if (counter>9) begin
	    counter<=0;
        mem_done<=1;
	end
        counter++;
        // when mem_resp set write req low, store data handled in assign above
        if (mem_resp) begin
            write_req<=0;
        end
    end 
    else begin
        mem_done<=0;
    end     
end

always @(negedge clk) begin
    if (load) begin
        if (counter == 1) begin
        read_req<=1;
	end    
    end
    if (store) begin
        if (counter == 1) begin
        write_req<=1;
	end    
    end
end

endmodule : memInerf

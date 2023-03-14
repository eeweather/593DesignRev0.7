/*
--Inputs:
o Reset
o Clk
o Result[15:0];
o Store;
o Load;
o Addr[13:0]
o Mem_resp;
-- Inout:
o DATA[15:0]; // Writes use 15:0/ reads use 7:0
-- Output:
o Done; NOT on drawing
o Data[7:0]
o Write_req; to SMM
o READ_REQ; to SMM
o ADDROUT[13:0]; to SMM 

Purpose of Module

Consists of a memory interface that is connected to a system memory. 
o  The processor should fetch data from the system memory of size 16 KBytes. 
o  The data size should be 2 Bytes. Max operand size is 8 bits. 

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
assign datatomem = (store)? result: 0;


//assign datatofrommem = (!reset_n)? '0 : 16'bz;
//assign datatofrommem = (store)? result: 16'hz;

always @(posedge clk) begin
    //if reset reset
    if (!reset_n) begin
        //TODO:  what needs to be reset
        mem_done<=0;
        //addrout<= 0;
        write_req <= 0;
        read_req <=0;
        datatoinst <= 0;
        counter <= 0;
        //datatomem <= 0;
    end
    // load signal comes in
    else if (load) begin
	    mem_done <=0;
	if (counter>9) begin
	    counter<=0;
        mem_done <=1; 
	end
        // read addr, put on addrout
	//mem_done <=0;
        //addrout<=addr;
        //set read_req
        counter++;
	
        if (mem_resp) begin
            //when mem_resp goes high, put data on datatofrommem onto datatoinst
            // JBFIL: Add read of either byte based on lower address bits.
            //datatoinst <= addr[0] ? datafrommem[15:8] : datafrommem[7:0];
            datatoinst <= datafrommem[7:0];
            //end with read_req and raise mem_done
            read_req <= 0;
        end
    end
    // store signal comes in
    else if (store) begin
	    mem_done<=0;
	if (counter>9) begin
	    counter<=0;
        mem_done<=1;
	end
        counter++;
        // read addr onto addrout
        // put result onto datatofrommem
        //set write_req
	//mem_done <=0;
        //addrout<=addr;
        //datatomem<=result;
	// if (counter == 1) begin
    //     write_req<=1;
	// end
        // when mem_resp goes high raise mem_done and lower all else
        if (mem_resp) begin
            write_req<=0;
        end
    end 
    else begin
        mem_done<=0;
        //write_req<=0;
        //read_req<=0;
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

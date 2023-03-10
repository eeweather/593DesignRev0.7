
interface core_if ();
   logic [7:0] A, B;
   logic [3:0] op;
   logic start;

   logic [15:0] alu_result;
   logic alu_done, error;

   logic [15:0] result;
   logic [13:0] addrout;
   logic load, store;

   logic [7:0] data;
   logic mem_done;
endinterface

interface mem_bus_if ();
    logic grant[4];
    logic req[4];

    tri [13:0] addr;   //address to main memory
    tri [15:0] result; //results to be sent to main memory - connect to mem interface unit
    tri store, load;   //issue store/load signal to mem interface unit

    logic mem_done;          //memory interface done done signal
    logic [7:0] data;           //receives data from Memory Interface unit

endinterface

interface all_bfm ();
   parameter PROCS = 4;
   parameter INSTR_MAX = 1000;

   logic clk; // Global Driving Clock Signal
   logic reset_n; // Global reset_n signal

   string insFilenames[PROCS];
   logic [18:0] insArrays[PROCS][INSTR_MAX];
   logic [18:0] iu_instr[PROCS];
   logic        iu_done[PROCS]; // Signaled


   task reset();
      reset_n = 0;
      @(negedge clk);
      @(negedge clk);
      reset_n = 1;
   endtask : reset

   task load_instructions(input int proc, input string filename);
      int fd;

      begin
         if (proc < 0 || proc >= PROCS) $fatal(0, "Processor %d count is too large.", proc);
         fd = $fopen(filename, "r");
         if (!fd) $fatal(0, "File '%s' not found.", filename);
         insFilenames[proc] = filename;

         for(int i = 0; i < INSTR_MAX; i++) begin
            if (1 != $fscanf(fd,"%b", insArrays[proc][i])) begin
               $info("Loaded %d instructions from '%s'", i, filename);
               break;
            end
         end

         $fclose(fd);
      end
   endtask

   task send_op(input int proc, input logic [7:0] iA, iB, input logic [3:0] iop, output [15:0] alu_result);
      begin
         //alu.op = iop;
         //alu.A = iA;
         //alu.B = iB;
         //alu.start = 1'b1;

         //@(posedge clk);
         //#0.1;

         //do
         //   @(negedge clk);
         //while (alu.done == 0 && alu.error == 0);
      end
   endtask : send_op

   task send_instruction(input int proc, input int idx);
      begin
         if (proc < 0 || proc >= PROCS) $fatal(0, "Processor %d count is too large.", proc);
         if (idx < 0 || idx >= INSTR_MAX) $fatal(0, "Processor %d count is too large.", proc);
         
         // Assign instruction to selected proc.
         iu_instr[proc] = insArrays[proc][idx];
         @(posedge clk);

         // Await done signal.
         do
            @(negedge clk);
         while (!iu_done[proc]);
      end
   endtask

endinterface

// Instructions are accepted when not no_op on next positive clock edge.
module all_dut #(PROCS = 4, DATA_SIZE = 2) (input logic clk, reset_n, input logic [18:0] instr[PROCS], output logic done[PROCS]);
/* MemIinf Implementation
   logic mem_done;
   reg store, load;
   reg [15:0] result;
   reg [13:0] addr;
   reg [7:0] datatoinst;

   logic [13:0] addrout;
   logic [15:0] datatomem;
   logic write_req, read_req, preload;

   logic [7:0] datafrommem;
   logic mem_resp;

   // Instance of system memory
   sram_single_port sram_0 (
      .addr(addrout),
      .datafrommif(datatomem),
      .re(read_req), .we(write_req), .preload(preload),

      .datatomif(datafrommem),
      .mem_resp(mem_resp),

      .clk(clk), .reset_n(reset_n)
   );
   genvar i; generate
      for (i = 0; i < PROCS; i = i + 1) begin : core
         memInerf mem_i (
            // Inputs from IU
            .addr(proc_if_i.addrout),
            .result(proc_if_i.result),
            .load(proc_if_i.load), .store(proc_if_i.store),

            // Outputs from IU
            .mem_done(proc_if_i.mem_done),
            .datatoinst(proc_if_i.data),

            // Inputs to system memory
            .addrout(addrout),
            .datatomem(datatomem),
            .read_req(read_req), .write_req(write_req),

            // Outputs from system memory
            .datafrommem(datafrommem),
            .mem_resp(mem_resp),

            .clk(clk), .reset_n(reset_n)
         );
      end
   endgenerate
*/
   
   logic [DATA_SIZE*8-1:0] mem_write_data;
   logic [DATA_SIZE*8-1:0] mem_read_data;
   logic mem_read_req, mem_write_req;
   //logic [13:0] addr,

   // Utilize generate to instantiate structure for all 4 processor cores.
   genvar i; generate
      for (i = 0; i < PROCS; i = i + 1) begin : core
         processor_if proc_if_i (clk, reset_n);

         ALU593 alu_i(
            .A(proc_if_i.A), .B(proc_if_i.B), .op(proc_if_i.op),
            .start(proc_if_i.start),

            .done(proc_if_i.alu_done), .error(proc_if_i.error),
            .result(proc_if_i.alu_result),

            .clk(clk), .reset_n(reset_n)
         );

         instructionUnit iu_i (
            .instr(instr[i]),

            // Inputs to ALU
            .A(proc_if_i.A), .B(proc_if_i.B), .op(proc_if_i.op),
            .start(proc_if_i.start),
            // Outputs from ALU
            .alu_done(proc_if_i.alu_done), //.error() NOT USED
            .alu_result(proc_if_i.alu_result),

            // Inputs to memory controllerj
            .addr(proc_if_i.addr),
            .result(proc_if_i.result),
            .load(proc_if_i.load), .store(proc_if_i.store), 

            // Outputs from memory controller
            .mem_done(proc_if_i.mem_done),
            .data(proc_if_i.data),

            .done(done[i]), // Output from IU

            .clk(clk), .reset_n(reset_n)
         );

         memInerf mem_i (
            // Inputs from IU
            .addr(proc_if_i.addr),
            .result(proc_if_i.result),
            .load(proc_if_i.load), .store(proc_if_i.store),

            // Outputs from IU
            .mem_done(proc_if_i.mem_done),
            .datatoinst(proc_if_i.data),

            // Inputs to system memory
            .addrout(proc_if_i.addrout),
            .datatomem(proc_if_i.datatomem),
            .read_req(proc_if_i.read_req), .write_req(proc_if_i.write_req),

            // Outputs from system memory
            .datafrommem(proc_if_i.datafrommem),
            .mem_resp(proc_if_i.mem_resp),

            .clk(clk), .reset_n(reset_n)
         );
      end

      logic processor_req[PROCS];

      memory_subsystem mem_0 (
         .processor_req_0(core[0].proc_if_i.read_req), // TODO: Needs to be single req.
         .processor_req_1(core[1].proc_if_i.read_req),
         .processor_req_2(core[2].proc_if_i.read_req),
         .processor_req_3(core[3].proc_if_i.read_req),

         .processor_resp_0(core[0].proc_if_i.mem_resp),
         .processor_resp_1(core[1].proc_if_i.mem_resp),
         .processor_resp_2(core[2].proc_if_i.mem_resp),
         .processor_resp_3(core[3].proc_if_i.mem_resp),

         .addr(core[0].proc_if_i.addr),
         .mem_write_data(core[0].proc_if_i.datatomem),
         .mem_read_req(core[0].proc_if_i.read_req), .mem_write_req(core[0].proc_if_i.write_req),

         .mem_read_data(core[0].proc_if_i.datafrommem),

         .clk(clk), .reset_n(reset_n)
      );
   endgenerate


      


   

endmodule

module all_top;

   all_bfm bfm();

   all_dut DUT(
      .instr(bfm.iu_instr),
      .done(bfm.iu_done),

      .clk(bfm.clk), .reset_n(bfm.reset_n)
   );

   initial begin
      $dumpfile("waves.vcd");
      $dumpvars(0, all_top, bfm);

      // Generate Clock
      bfm.clk = 0;
      forever #0.5 bfm.clk = !bfm.clk;
   end

   initial begin
      bfm.reset();
      bfm.load_instructions(0, "test.txt");

      #10;
      
      $stop();
   end
   

   tinyalu_bfm       bfmX();
   initial begin
      //uvm_config_db #(virtual tinyalu_bfm)::set(null, "*", "bfm", bfmX);
   end

endmodule

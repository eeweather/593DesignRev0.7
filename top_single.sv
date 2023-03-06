/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
module top_single;
   import uvm_pkg::*;
   import   tinyalu_pkg::*;
`include "uvm_macros.svh"
   
   tinyalu_bfm       vif();
   alumifiu_dut DUT (.instr(vif.instr), .clk(vif.clk), .reset_n(vif.reset_n), .done(vif.done), .A(vif.A), .B(vif.B));


initial begin
   uvm_config_db #(virtual tinyalu_bfm)::set(null, "*", "vif", vif);

end


initial begin
        $dumpfile("top_single.vcd");
        $dumpvars(0, vif, DUT);

        #10000;
        $finish();

        
    end

endmodule : top_single

     
   

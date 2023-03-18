
#vdel -lib jwork -verbose -all

vlog -quiet -work jwork -timescale 1ns/100ps tinyalu_pkg.sv bfm_singleinstr.sv
vlog -quiet -work jwork -timescale 1ns/100ps processor_if.sv ALU593.sv instructionUnit_single.sv
vlog -quiet -work jwork -timescale 1ns/100ps MemIntUnit.sv memory_subsystem.sv
vlog -quiet -work jwork -timescale 1ns/100ps all_bfm.sv
#vlog -quiet -work jwork -timescale 1ns/100ps tb/*.sv

vopt -quiet -work jwork all_top -o all_top_opt -debug +designfile +cover=bcesf -coverexcludedefault

vsim -quiet -lib jwork -voptargs=+acc=npr all_top_opt



#vsim +UVM_TESTNAME=test_base -c -coverage -do " -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_DEBUG

coverage save -onexit coverage.ucdb
run -all
quit
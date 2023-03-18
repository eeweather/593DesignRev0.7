COMMON_VSIM_ARGS += -sv_lib c


all: build test_base

build:  
	vlog tb/c_predictor.c -dpicpppath /usr/bin/gcc -ccflags "-c -Werror-implicit-function-declaration -O2"
	vlog tinyalu_pkg.sv processor_if.sv
	vlog ALU593.sv instructionUnit_single.sv memIntUnit.sv memory_subsystem.sv ALUMIFIU_dut.sv
	vlog tb/top_hvl.sv top_hdl.sv   
	vopt top_hvl top_hdl -o top_opt -debug +designfile +cover=bcesf -coverexcludedefault

test_add: 
	vsim +UVM_TESTNAME=test_add -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_LOW -dpicpppath /usr/bin/gcc

test_alu: 
	vsim +UVM_TESTNAME=test_alu -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_LOW -dpicpppath /usr/bin/gcc

test_base: 
	vsim +UVM_TESTNAME=test_base -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_LOW -dpicpppath /usr/bin/gcc

test_load: 
	vsim +UVM_TESTNAME=test_load -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_LOW -dpicpppath /usr/bin/gcc

test_full: 
	vsim +UVM_TESTNAME=test_full -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_LOW -dpicpppath /usr/bin/gcc

COMMON_VSIM_ARGS += -sv_lib c


all: comp opt psim

#comp:  
#	vlog tinyalu_pkg.sv bfm_singleinstr.sv
#	vlog ALU593.sv instructionUnit_single.sv MemIntUnit.sv dummyMem.sv memory_subsystem.sv ALUMIFIU_dut.sv
#	vlog tb/top_hvl.sv top_single.sv

comp:  
	vlog tb/c_predictor.c -dpicpppath /usr/bin/gcc -ccflags "-c -Werror-implicit-function-declaration -O2"
	vlog tinyalu_pkg.sv processor_if.sv
	vlog ALU593.sv instructionUnit_single.sv memIntUnit.sv memory_subsystem.sv ALUMIFIU_dut.sv
	vlog tb/top_hvl.sv top_hdl.sv
opt:    
	vopt top_hvl top_hdl -o top_opt -debug +designfile +cover=bcesf -coverexcludedefault

psim: comp opt
	vsim +UVM_TESTNAME=test_base -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1 -sv_seed 10 +UVM_VERBOSITY=UVM_DEBUG -dpicpppath /usr/bin/gcc
lsim: comp opt
	vsim +UVM_TESTNAME=test_base top_opt +uvm_set_config_int=uvm_test_top,num_items,1 -dpicpppath /usr/bin/gcc

lvis: comp opt
	vsim +UVM_TESTNAME=test_base -coverage top_opt -qwavedb=signal+memory -visualizer="+designfile+design.bin" -dpicpppath /usr/bin/gcc

vcov: 
	visualizer -viewcov coverage.ucdb

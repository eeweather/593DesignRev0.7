all: comp opt psim

comp:  
	vlog tinyalu_pkg.sv bfm_singleinstr.sv
	vlog ALU593.sv instructionUnit_single.sv MemIntUnit.sv dummyMem.sv 
	vlog tb/top_hvl.sv

opt:    
	vopt top_hvl top_single -o top_opt +debug -designfile +cover=bcesf -coverexcludedefault

psim:
	vsim +UVM_TESTNAME=test_base -c -coverage -do "coverage save -onexit coverage.ucdb; run -all; quit" top_opt -qwavedb=+signal+memory +uvm_set_config_int=uvm_test_top,num_items,1
lsim: comp opt
	vsim +UVM_TESTNAME=test_base top_opt +uvm_set_config_int=uvm_test_top,num_items,1


all: comp opt psim

comp:  
	vlog tinyalu_pkg.sv processor_if.sv memory_if.sv
	vlog ALU593.sv instructionUnit.sv MemIntUnit.sv memory_subsystem.sv 
	vlog top_hdl.sv tb.sv

opt:    
	vopt tb -o tb_opt +debug -designfile +cover=bcesf -coverexcludedefault

psim:
	vsim -c tb_opt -do "run 10000; q -f" -qwavedb=+signal+memory+transaction


if [file exists "work"] {vdel -all}
vlib work

# SystemVerilog DUT
vlog tinyalu_dut/tinyalu.sv

vlog -f tb.f
vlog tb_classes/predictor.c -dpicpppath /usr/bin/gcc -ccflags "-c -Werror-implicit-function-declaration -O2"
vopt top -o top_optimized  +acc +cover=sbfec+tinyalu(rtl).

vsim top_optimized -dpicpppath /usr/bin/gcc -coverage +UVM_TESTNAME=parallel_test -voptargs=+acc
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value parallel_test
coverage save parallel_test.ucdb

vcover report tinyalu.ucdb -cvg -details

quit

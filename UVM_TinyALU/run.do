
if [file exists "work"] {vdel -all}
vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
#vcom -f dut.f

#gcc -c -fPIC tb_classes/predictor.c
#gee-c-fpic /tb_classes/predictor.c
#gcc-shared-olibc.so filename.o
#command-sv_lib libc

# SystemVerilog DUT
vlog tinyalu_dut/tinyalu.sv

vlog -f tb.f
#vlog /tb_classes/predictor.c -dpicpppath /usr/bin/gcc -ccflags "-c -Werror-implicit-function-declaration -O2"
vopt top -o top_optimized  +acc +cover=sbfec+tinyalu(rtl).

vsim top_optimized -coverage +UVM_TESTNAME=fibonacci_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
coverage attribute -name TESTNAME -value fibonacci_test
coverage save fibonacci_test.ucdb

#vsim top_optimized -coverage +UVM_TESTNAME=parallel_test 
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
#coverage attribute -name TESTNAME -value parallel_test
#coverage save parallel_test.ucdb

#vsim top_optimized -coverage +UVM_TESTNAME=full_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
#coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
#coverage attribute -name TESTNAME -value full_test
#coverage save full_test.ucdb

#vcover merge  tinyalu.ucdb fibonacci_test.ucdb parallel_test.ucdb full_test.ucdb
#vcover report tinyalu.ucdb -cvg -details

quit

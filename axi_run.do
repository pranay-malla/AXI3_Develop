vlog axi_run.sv +incdir+C:/questasim64_10.7c/verilog_src/uvm-1.1d/src
vsim work.axi_top +OUTSTANDING=1 +UVM_TESTNAME=incr_overlap_multiple_write_multiple_read_test -sv_lib C:/questasim64_10.7c/uvm-1.1d/win64/uvm_dpi -voptargs="+acc"
add wave -position insertpoint sim:/axi_top/inf/*
run -all 
 
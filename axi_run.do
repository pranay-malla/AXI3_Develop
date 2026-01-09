vlog testbench.sv +incdir+C:/questasim64_10.7c/verilog_src/uvm-1.1c/src
vsim work.axi_top -sv_lib C:/questasim64_10.7c/uvm-1.1c/win64/uvm_dpi -voptargs="+acc"
add wave -position insertpoint sim:/axi_top/inf/*
run -all 

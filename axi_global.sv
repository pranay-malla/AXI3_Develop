uvm_factory factory = uvm_factory::get();

`define UVM_OBJ \
function new(string name =""); \
	super.new(name);\
endfunction


`define UVM_COMP \
function new(string name ="",uvm_component parent); \
	super.new(name,parent);\
endfunction

parameter DATA_BUS_WIDTH = 32;

typedef enum logic[1:0] {OKAY=2'b00, EX_OKAY=2'b01, SLVERR = 2'b10, DECERR = 2'b11} RESP_TYPE;

typedef enum logic[1:0] {FIXED=2'b00, INCR = 2'b01, WRAP=2'b10, RESERVED= 2'b11} BURST_TYPE;

typedef enum logic[1:0] {WRITE_ONLY=2'b00, READ_ONLY=2'b01, WRITE_THEN_READ=2'b10, WRITE_PARALLEL_READ=2'b11} TRANS_TYPE;


uvm_factory factory = uvm_factory::get();

`define UVM_COMP\
function new(string name ="", uvm_component parent);\
  super.new(name, parent);\
endfunction

`define UVM_OBJ\
function new(string name ="");\
  super.new(name);\
endfunction

parameter DATA_BUSWIDTH = 32;

typedef enum logic [1:0]{ 
  FIXED    = 2'b00,
  INCR     = 2'b01,
  WRAP     = 2'b10,
  RESERVED = 2'b11 }  burst_type;


typedef enum logic [1:0]{
  OKAY   = 2'b00,
  EXOKAY = 2'b01,
  SLVERR = 2'b10,
  DECERR = 2'b11 } response_type;

typedef enum logic [1:0]{
  WRITE_ONLY          = 2'b00,
  READ_ONLY           = 2'b01,
  WRITE_THEN_READ     = 2'b10,
  WRITE_PARALLEL_READ = 2'b11 } trans_type;
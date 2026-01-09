class axi_seq_item extends uvm_sequence_item;
  
  rand trans_type TRANS_TYPE;
  rand int k;
 

  
  //1) Write Address Channel
  rand bit [3:0] AWID;
  rand bit [31:0] AWADDR;
  rand bit [2:0] AWSIZE;
  rand bit [3:0] AWLEN;
  rand burst_type AWBURST;
  rand bit [1:0] AWLOCK;
  rand bit [2:0] AWPROT;
  rand bit [3:0] AWCACHE;
  
  //2)Write Data Channel
  rand bit [3:0] WID;
  rand bit WREADY;
  rand bit WVALID;
  rand bit [DATA_BUSWIDTH-1:0] WDATA[$];
  rand bit WLAST;
  rand bit [(DATA_BUSWIDTH/8)-1:0] WSTRB[$];
  
  //3)Write Resposne Channel
  bit [3:0] BID;
  response_type BRESP;
  
  //4) Read Address Channel
  rand bit [3:0] ARID;
  rand bit [31:0] ARADDR;
  rand bit [2:0] ARSIZE;
  rand bit [3:0] ARLEN;
  rand burst_type ARBURST;
  rand bit [1:0] ARLOCK;
  rand bit [2:0] ARPROT;
  rand bit [3:0] ARCACHE; 
  
  //5)Read Data Channel
  bit [3:0] RID;
  response_type RRESP;
  bit [DATA_BUSWIDTH-1:0] RDATA[$];
  bit RLAST;  
  
  
  `uvm_object_utils_begin(axi_seq_item)
  `uvm_field_enum(trans_type,TRANS_TYPE,UVM_ALL_ON)
  `uvm_field_int(AWID   , UVM_ALL_ON) 
  `uvm_field_int(AWADDR , UVM_ALL_ON) 
  `uvm_field_int(AWLEN  , UVM_ALL_ON)  
  `uvm_field_int(AWSIZE , UVM_ALL_ON)  
  `uvm_field_enum(burst_type, AWBURST, UVM_ALL_ON) 
  `uvm_field_int(AWLOCK , UVM_ALL_ON) 
  `uvm_field_int(AWPROT , UVM_ALL_ON) 
  `uvm_field_int(AWCACHE, UVM_ALL_ON) 
  
  `uvm_field_int(WID    , UVM_ALL_ON) 
  `uvm_field_queue_int(WDATA  , UVM_ALL_ON)
  `uvm_field_queue_int(WSTRB , UVM_ALL_ON) 
  `uvm_field_int(WLAST  , UVM_ALL_ON)
  
  `uvm_field_int(BID    , UVM_ALL_ON)  
  `uvm_field_enum(response_type, BRESP, UVM_ALL_ON)
  
  `uvm_field_int(ARID   , UVM_ALL_ON)
  `uvm_field_int(ARADDR , UVM_ALL_ON)
  `uvm_field_int(ARLEN  , UVM_ALL_ON)
  `uvm_field_int(ARSIZE , UVM_ALL_ON)
  `uvm_field_enum(burst_type, ARBURST, UVM_ALL_ON)
  `uvm_field_int(ARLOCK , UVM_ALL_ON)
  `uvm_field_int(ARPROT , UVM_ALL_ON)
  `uvm_field_int(ARCACHE, UVM_ALL_ON)
 
  `uvm_field_int(RID    , UVM_ALL_ON)
  `uvm_field_queue_int(RDATA  , UVM_ALL_ON)
  `uvm_field_enum(response_type, RRESP, UVM_ALL_ON)
  `uvm_field_int(RLAST  , UVM_ALL_ON)  
  `uvm_object_utils_end
  
  `UVM_OBJ
  
  constraint data_len{
    WDATA.size() == AWLEN+1;
    WSTRB.size() == AWLEN+1;
    AWID == WID;
  }
  
  constraint wstrb_len{
    k == AWADDR % 2**AWSIZE;
    
    foreach(WSTRB[i]){
      
      if(i == 0){
        foreach(WSTRB[i][j]){
          if(j>=k)
            WSTRB[i][j] == 1;
          else
            WSTRB[i][j] == 0;
        
        }
      }
      else
        WSTRB[i] == {DATA_BUSWIDTH/8{1'b1}};      
    
    } 
  
  }
  
endclass

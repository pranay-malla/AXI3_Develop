interface axi_interface(input logic aclk,aresetn);
 
	
  //Write Address Channel
  logic [3:0]awid;
  logic awvalid;
  logic awready;
  logic [31:0] awaddr;
  logic [2:0] awsize;
  logic [3:0] awlen;
  logic [1:0] awburst;
  logic [1:0] awlock;
  logic [2:0] awprot;
  logic [3:0] awcache;
  
  //Write Data Channel
  logic [3:0] wid;
  logic wvalid;
  logic wready;
  logic [DATA_BUSWIDTH-1:0] wdata;
  logic [(DATA_BUSWIDTH/8)-1:0] wstrb;
  logic wlast;
  
  //Write Response Channel
  logic [3:0] bid;
  logic bvalid;
  logic bready;
  logic [1:0] bresp;
 
  //Read Address Channel
  logic [3:0]arid;
  logic arvalid;
  logic arready;
  logic [31:0] araddr;
  logic [2:0] arsize;
  logic [3:0] arlen;
  logic [1:0] arburst;
  logic [1:0] arlock;
  logic [2:0] arprot;
  logic [3:0] arcache;
  
  //Read Data Channel
  logic [3:0]rid;
  logic rvalid;
  logic rready;
  logic [DATA_BUSWIDTH-1:0] rdata;
  logic rlast;
  logic [1:0] rresp;
  
  clocking drv_cb @(posedge aclk);
	  default input #0 output #0;
    //Write Address Channel
    output awid;
    output awvalid;
    output awaddr;
    output awsize;
    output awlen;
    output awburst;
    output awlock;
    output awprot;
    output awcache;
    input awready;
    
    //Write Data Channel
    output wid;
    output wvalid;
    output wdata;
    output wstrb;
    output wlast;
    input wready;
    
    //Write Resposne Channel
    input bid;
    input bvalid;
    input bresp;
    output bready;
    
    //Read Address Channel
    output arid;
    output arvalid;
    output araddr;
    output arsize;
    output arlen;
    output arburst;
    output arlock;
    output arprot;
    output arcache;
    input arready;
    
    //Read Data Channel
    input rid;
    input rvalid;
    input rdata;
    input rlast;
    input rresp;
    output rready;
    
  endclocking
  
  
  
  clocking resp_cb @(posedge aclk);
     //Write Address Channel
    input awid;
    input awvalid;
    input awaddr;
    input awsize;
    input awlen;
    input awburst;
    input awlock;
    input awprot;
    input awcache;
    output awready;
    
    //Write Data Channel
    input wid;
    input wvalid;
    input wdata;
    input wstrb;
    input wlast;
    output wready;
    
    //Write Resposne Channel
    output bid;
    output bvalid;
    output bresp;
    input bready;
    
    //Read Address Channel
    input arid;
    input arvalid;
    input araddr;
    input arsize;
    input arlen;
    input arburst;
    input arlock;
    input arprot;
    input arcache;
    output arready;
    
    //Read Data Channel
    output rid;
    output rvalid;
    output rdata;
    output rlast;
    output rresp;
    input rready;   
    
  endclocking
  
  clocking mon_cb @(posedge aclk);
      //Write Address Channel
    input awid;
    input awvalid;
    input awaddr;
    input awsize;
    input awlen;
    input awburst;
    input awlock;
    input awprot;
    input awcache;
    input awready;
    
    //Write Data Channel
    input wid;
    input wvalid;
    input wdata;
    input wstrb;
    input wlast;
    input wready;
    
    //Write Resposne Channel
    input bid;
    input bvalid;
    input bresp;
    input bready;
    
    //Read Address Channel
    input arid;
    input arvalid;
    input araddr;
    input arsize;
    input arlen;
    input arburst;
    input arlock;
    input arprot;
    input arcache;
    input arready;
    
    //Read Data Channel
    input rid;
    input rvalid;
    input rdata;
    input rlast;
    input rresp;
    output rready;
  endclocking
  
  modport drv_mod(clocking drv_cb, input aclk,aresetn);
    modport mon_mod(clocking mon_cb, input aclk,aresetn);
      modport resp_mod(clocking resp_cb, input aclk,aresetn);
        
endinterface

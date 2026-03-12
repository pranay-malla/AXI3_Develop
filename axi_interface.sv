interface axi_interface(input logic aclk, input logic arstn);

	//1) Write Address Channel
	logic awvalid;
	logic awready;
	logic [3:0] awid;
	logic [31:0] awaddr;
	logic [2:0] awsize;
	logic [3:0] awlen;
	logic [1:0] awburst;
	logic [1:0] awlock;
	logic [2:0] awprot;
	logic [3:0] awcache;


	//2) Write Data Channel
	logic wvalid;
	logic wready;
	logic [3:0] wid;
	logic [DATA_BUS_WIDTH-1:0] wdata;
	logic wlast;
	logic [(DATA_BUS_WIDTH/8)-1:0] wstrb;

	//3) Write Response Channel
	logic bvalid;
	logic bready;
	logic [3:0] bid;
	logic [1:0] bresp;

	//4) Read Address Channel
	logic arvalid;
	logic arready;
	logic [3:0] arid;
	logic [31:0]araddr;
	logic [2:0] arsize;
	logic [3:0] arlen;
	logic [1:0] arburst;
	logic [1:0] arlock;
	logic [2:0] arprot;
	logic [3:0] arcache;


	//5) Read Data Channel
	logic rvalid;
	logic rready;
	logic [3:0] rid;
	logic [DATA_BUS_WIDTH-1:0] rdata;
	logic rlast;
	logic [1:0] rresp;


	clocking drv_cb @(posedge aclk);
		default input #0 output #0;
		//Write Address Channel
		input  awready;
		output awvalid;
		output awid;
		output awaddr;
		output awburst;
		output awsize;
		output awlen;
		output awlock;
		output awprot;
		output awcache;

		//Write Data Channel
		input  wready;
		output wvalid;
		output wid;
		output wdata;
		output wstrb;
		output wlast;

		//Write Response Channel
		output bready;
		input  bvalid;
		input  bid;
		input  bresp;

		//Read Address Channel
		input  arready;
		output arvalid;
		output arid;
		output araddr;
		output arburst;
		output arsize;
		output arlen;
		output arlock;
		output arprot;
		output arcache;

		//Read Data Channel
		output rready;
		input  rvalid;
		input  rid;
		input  rdata;
		input  rresp;
		input  rlast;
	endclocking


	clocking mon_cb @(posedge aclk);
		default input #0 output #0;
		//Write Address Channel
		input  awready;
		input  awvalid;
		input  awid;
		input  awaddr;
		input  awburst;
		input  awsize;
		input  awlen;
		input  awlock;
		input  awprot;
		input  awcache;

		//Write Data Channel
		input  wready;
		input  wvalid;
		input  wid;
		input  wdata;
		input  wstrb;
		input  wlast;

		//Write Response Channel
		input  bready;
		input  bvalid;
		input  bid;
		input  bresp;

		//Read Address Channel
		input  arready;
		input  arvalid;
		input  arid;
		input  araddr;
		input  arburst;
		input  arsize;
		input  arlen;
		input  arlock;
		input  arprot;
		input  arcache;

		//Read Data Channel
		input  rready;
		input  rvalid;
		input  rid;
		input  rdata;
		input  rresp;
		input  rlast;
	endclocking



	clocking resp_cb @(posedge aclk);
		default input #0 output #0;
		//Write Address Channel
		output  awready;
		input  awvalid;
		input  awid;
		input  awaddr;
		input  awburst;
		input  awsize;
		input  awlen;
		input  awlock;
		input  awprot;
		input  awcache;

		//Write Data Channel
		output  wready;
		input   wvalid;
		input   wid;
		input   wdata;
		input   wstrb;
		input   wlast;

		//Write Response Channel
		input   bready;
		output  bvalid;
		output  bid;
		output  bresp;

		//Read Address Channel
		output  arready;
		input   arvalid;
		input   arid;
		input   araddr;
		input   arburst;
		input   arsize;
		input   arlen;
		input   arlock;
		input   arprot;
		input   arcache;

		//Read Data Channel
		input  rready;
		output rvalid;
		output rid;
		output rdata;
		output rresp;
		output rlast;
	endclocking

	modport drv_mod(clocking drv_cb, input aclk, arstn);
	modport mon_mod(clocking mon_cb, input aclk, arstn);
	modport resp_mod(clocking resp_cb, input aclk, arstn);

endinterface

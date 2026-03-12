class axi_seq_item extends uvm_sequence_item;

	rand bit overlap,wstrb_flag;
	rand bit addr_overlap, data_overlap;
	rand bit read_overlap, rd_data_overlap;
	rand bit narrow;

	rand TRANS_TYPE trans_type;

	//Write Address Channel
	rand bit [3:0] awid;
	rand BURST_TYPE awburst;
	rand bit [31:0]awaddr;
	rand bit [2:0] awsize;
	rand bit [3:0] awlen;
	rand bit [1:0] awlock;
	rand bit [2:0] awprot;
	rand bit [3:0] awcache;

	//Write Data Channel
	rand bit [3:0] wid;
	rand bit [DATA_BUS_WIDTH-1:0] wdata[$];
	rand bit wlast;
	rand bit [(DATA_BUS_WIDTH/8)-1:0] wstrb[$];

	//Write Response Channel
	RESP_TYPE bresp;
	bit [3:0] bid;

	//Read Address Channel
	rand bit [3:0] arid;
	rand BURST_TYPE arburst;
	rand bit [31:0]araddr;
	rand bit [2:0] arsize;
	rand bit [3:0] arlen;
	rand bit [1:0] arlock;
	rand bit [2:0] arprot;
	rand bit [3:0] arcache;

	//Read Data Channel
	bit [3:0] rid;
	bit [DATA_BUS_WIDTH-1:0] rdata;
	RESP_TYPE rresp;
	bit rlast;

	`uvm_object_utils_begin(axi_seq_item)
		`uvm_field_enum(TRANS_TYPE, trans_type, UVM_ALL_ON)
		`uvm_field_int(awid, UVM_ALL_ON)
		`uvm_field_enum(BURST_TYPE, awburst ,UVM_ALL_ON)
		`uvm_field_int(awaddr, UVM_ALL_ON)
		`uvm_field_int(awsize, UVM_ALL_ON)
		`uvm_field_int(awlen, UVM_ALL_ON)
		`uvm_field_int(awlock, UVM_ALL_ON)
		`uvm_field_int(awprot, UVM_ALL_ON)
		`uvm_field_int(awcache, UVM_ALL_ON)
		`uvm_field_int(wid, UVM_ALL_ON)
		`uvm_field_queue_int(wdata, UVM_ALL_ON)
		`uvm_field_int(wlast, UVM_ALL_ON)
		`uvm_field_queue_int(wstrb, UVM_ALL_ON)
		`uvm_field_int(bid, UVM_ALL_ON)
		`uvm_field_enum(RESP_TYPE, bresp,UVM_ALL_ON)
		`uvm_field_int(arid, UVM_ALL_ON)
		`uvm_field_enum(BURST_TYPE, arburst,UVM_ALL_ON)
		`uvm_field_int(araddr, UVM_ALL_ON)
		`uvm_field_int(arsize, UVM_ALL_ON)
		`uvm_field_int(arlen, UVM_ALL_ON)	
		`uvm_field_int(arlock, UVM_ALL_ON)
		`uvm_field_int(arprot, UVM_ALL_ON)
		`uvm_field_int(arcache, UVM_ALL_ON)
		`uvm_field_int(rid, UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_ALL_ON)
		`uvm_field_int(rlast, UVM_ALL_ON)
		`uvm_field_enum(RESP_TYPE,rresp, UVM_ALL_ON) 
	`uvm_object_utils_end

	`UVM_OBJ

	constraint id_cons {
		awid == wid;
		wdata.size() == awlen+1;
		wstrb.size() == awlen+1;
		}
	

	function void post_randomize();

		int bus_bytes;
		int offset;
		int lane;
		int active;
		int k;


		k = awaddr %(1<<awsize);
		bus_bytes = DATA_BUS_WIDTH/8;
		offset = awaddr % bus_bytes;


		if((1<<awsize) < bus_bytes)
			narrow = 1;
		else
			narrow = 0;


		if(!narrow)
			foreach(wstrb[i])
				foreach(wstrb[i][j])
					if(i==0)
						if(j>=k)
							wstrb[i][j] = 1'b1;
						else
							wstrb[i][j] = 1'b0;
					else
						wstrb[i][j] = {(DATA_BUS_WIDTH/8){'b1}};


		else begin
					
			
			foreach(wstrb[i]) begin
				foreach(wstrb[i][j])
					
					wstrb[i][j] = 1'b0;

				if(i==0) begin
					lane = offset;
					active = (1<<awsize) - k;
				end
				else begin
					lane = ((awaddr - k) + i*(1<<awsize))% bus_bytes;
					active = (1<<awsize);
				end

		
				for(int b=0; b<active;b++)
					wstrb[i][lane+b] = 1'b1;
				end
		
		end
							
	endfunction	
	
endclass

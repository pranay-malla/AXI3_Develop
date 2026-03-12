class axi_responder extends uvm_component;
	`uvm_component_utils(axi_responder)

	virtual axi_interface.resp_mod inf;
	axi_seq_item wr_tx[int];
	axi_seq_item rd_tx[int];

	bit aw_bit[int];
	bit w_bit [int];
	bit rd_bit[int];

	bit r_bit;
	logic outstand;

	axi_seq_item wr_temp, rd_temp;

	int awid_idx, wid_idx, rdid_idx;


	reg [7:0] mem [1023]; 

	`UVM_COMP
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual axi_interface)::get(this,"","RESPONDER",inf))
			`uvm_error("RESPONDER","Unable to get the Interface handle!")
		if(!uvm_config_db#(logic)::get(this,"","OUT_STANDING",outstand))
			`uvm_fatal("RESPONDER","Unable to get the Outstanding value")
	endfunction

	extern task main_phase(uvm_phase phase);
	extern task write_address_channel();
	extern task write_data_channel();
	extern task write_response_channel();
	extern task read_address_channel();
	extern task read_data_channel();
endclass


task axi_responder :: main_phase(uvm_phase phase);
	super.main_phase(phase);
	fork
		forever begin
			@(inf.resp_cb);
			write_address_channel();
		end

		forever begin
			@(inf.resp_cb);
			write_data_channel();
		end

		forever begin
			@(inf.resp_cb);
			write_response_channel();
		end

		forever begin
			@(inf.resp_cb);
			read_address_channel();
		end

		forever begin
			@(inf.resp_cb);
			read_data_channel();
		end
	join
endtask


task axi_responder :: write_address_channel();

	if(inf.resp_cb.awvalid && !inf.resp_cb.awready)
		inf.resp_cb.awready <= 1;
	else
		inf.resp_cb.awready <= 0;

	if(inf.resp_cb.awvalid && inf.resp_cb.awready) begin
		wr_tx[inf.resp_cb.awid] = new();
		wr_tx[inf.resp_cb.awid].awid    = inf.resp_cb.awid;
		wr_tx[inf.resp_cb.awid].awaddr  = inf.resp_cb.awaddr;
		wr_tx[inf.resp_cb.awid].awsize  = inf.resp_cb.awsize;
		wr_tx[inf.resp_cb.awid].awlen   = inf.resp_cb.awlen;
		wr_tx[inf.resp_cb.awid].awburst = BURST_TYPE'(inf.resp_cb.awburst);
		wr_tx[inf.resp_cb.awid].awlock  = inf.resp_cb.awlock;
		wr_tx[inf.resp_cb.awid].awprot  = inf.resp_cb.awprot;
		wr_tx[inf.resp_cb.awid].awcache = inf.resp_cb.awcache;
		aw_bit[inf.resp_cb.awid] = 1;
		inf.resp_cb.wready <= 1;

	end
endtask

task axi_responder :: write_data_channel();
	inf.resp_cb.wready <= 1;

	if(inf.resp_cb.wvalid && inf.resp_cb.wready) begin

		wr_temp = wr_tx[inf.resp_cb.wid];

		if(wr_temp.awburst == INCR) begin

			wr_temp.awaddr = wr_temp.awaddr - (wr_temp.awaddr%(2**wr_temp.awsize));

			for(int i =0; i <= wr_temp.awlen; i++) begin
				foreach(inf.resp_cb.wstrb [j]) begin
					if(inf.resp_cb.wstrb[j] == 1)
						mem[wr_temp.awaddr + j] = inf.resp_cb.wdata[8*j +: 8];
					else 
						mem[wr_temp.awaddr +j] = 0;
				end

				if(i == wr_temp.awlen) begin
					w_bit[inf.resp_cb.wid] = 1;
					inf.resp_cb.wready <= 0;
				end
				@(inf.resp_cb);

				wr_temp.awaddr = wr_temp.awaddr + (DATA_BUS_WIDTH/8);
			end

		end

		else if(wr_temp.awburst == WRAP) begin


		end

		else if(wr_temp.awburst == FIXED) begin


		end


	end
	

endtask

task axi_responder :: write_response_channel();

	if(outstand) begin
		repeat($urandom_range(8,10)) @(inf.resp_cb);

		while(!aw_bit.num()==0 && !w_bit.num()==0) begin

			aw_bit.first(awid_idx);
			w_bit.first(wid_idx);

			if(aw_bit[awid_idx] && w_bit[wid_idx] && (awid_idx == wid_idx))
				inf.resp_cb.bvalid <= 1;
			
			else
				inf.resp_cb.bvalid <= 0;


			if(inf.resp_cb.bvalid && inf.resp_cb.bready) begin
				inf.resp_cb.bresp <= bit'(OKAY);
				inf.resp_cb.bid   <= wid_idx;
				@(inf.resp_cb);
				inf.resp_cb.bresp <= 'dx;
				inf.resp_cb.bid   <= 'dx;
				inf.resp_cb.bvalid<= 'dx;
				aw_bit.delete(awid_idx);
				w_bit.delete(wid_idx);
			end
			@(inf.resp_cb);

		end
	end

	else begin	
		if(aw_bit.num() >0 && w_bit.num() > 0) begin
			aw_bit.first(awid_idx);
			w_bit.first(wid_idx);

		if(aw_bit[awid_idx] && w_bit[wid_idx] && (awid_idx == wid_idx))
			inf.resp_cb.bvalid <= 1;
			
		else
			inf.resp_cb.bvalid <= 0;

		end

		if(inf.resp_cb.bvalid && inf.resp_cb.bready) begin
			inf.resp_cb.bresp <= bit'(OKAY);
			inf.resp_cb.bid   <= wid_idx;
			@(inf.resp_cb);
			inf.resp_cb.bresp <= 'dx;
			inf.resp_cb.bid   <= 'dx;
			inf.resp_cb.bvalid<= 'dx;
			aw_bit.delete(awid_idx);
			w_bit.delete(wid_idx);
		end
	end


endtask


task axi_responder :: read_address_channel();
	if(inf.resp_cb.arvalid && !inf.resp_cb.arready)
		inf.resp_cb.arready <= 1;
	else
		inf.resp_cb.arready <= 0;

	if(inf.resp_cb.arvalid && inf.resp_cb.arready) begin
		rd_tx[inf.resp_cb.arid] = new();
		rd_tx[inf.resp_cb.arid].arid    = inf.resp_cb.arid;
		rd_tx[inf.resp_cb.arid].araddr  = inf.resp_cb.araddr;
		rd_tx[inf.resp_cb.arid].arsize  = inf.resp_cb.arsize;
		rd_tx[inf.resp_cb.arid].arlen   = inf.resp_cb.arlen;
		rd_tx[inf.resp_cb.arid].arburst = BURST_TYPE'(inf.resp_cb.arburst);
		rd_tx[inf.resp_cb.arid].arlock  = inf.resp_cb.arlock;
		rd_tx[inf.resp_cb.arid].arprot  = inf.resp_cb.arprot;
		rd_tx[inf.resp_cb.arid].arcache = inf.resp_cb.arcache;
		rd_bit[inf.resp_cb.arid] = 1;
	end


endtask


task axi_responder :: read_data_channel();

	if(rd_bit.num()>0) begin
		rd_bit.first(rdid_idx);
		rd_temp = rd_tx[rdid_idx];
		r_bit = rd_bit[rdid_idx];

	end

	if(r_bit && inf.resp_cb.rready) begin

		if(rd_temp.arburst == INCR) begin

			rd_temp.araddr = rd_temp.araddr - (rd_temp.araddr%(2**rd_temp.arsize));
			
			for(int i=0; i<= rd_temp.arlen; i++) begin
				for(int j=0; j < (DATA_BUS_WIDTH/8); j++) begin
					inf.resp_cb.rdata[8*j +: 8] <= mem[rd_temp.araddr + j];
				end

				inf.resp_cb.rvalid <= 1'b1;
				inf.resp_cb.rid <= rdid_idx;
				inf.resp_cb.rresp<= bit'(OKAY);

				if(i == rd_temp.arlen)
					inf.resp_cb.rlast <= 1;
				else
					inf.resp_cb.rlast <= 0;

				rd_temp.araddr = rd_temp.araddr + (DATA_BUS_WIDTH/8);
				@(inf.resp_cb); 
			end
			inf.resp_cb.rid   <= 'dx;
			inf.resp_cb.rdata <= 'dx;
			inf.resp_cb.rresp <= 'dx;
			inf.resp_cb.rlast <= 'dx;
			inf.resp_cb.rvalid<= 1'b0; 

			rd_bit.delete(rdid_idx); 
		

		end 

		else if(rd_temp.arburst == WRAP) begin


		end


		else if(rd_temp.arburst == FIXED) begin


		end
	end 

endtask

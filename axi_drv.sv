class axi_driver extends uvm_driver#(axi_seq_item);
	`uvm_component_utils(axi_driver)

	virtual axi_interface.drv_mod inf;
	axi_seq_item wr_qu[$];
        axi_seq_item rd_qu[$];	

	`UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual axi_interface)::get(this,"","drv_inf",inf))
			`uvm_error("DRIVER","Unable to get the Interface handle!")
	endfunction

	extern task main_phase(uvm_phase phase);
	extern task drive_txn(axi_seq_item req);
	extern task write_address_channel(axi_seq_item req);
	extern task write_data_channel(axi_seq_item req);
	extern task write_response_channel(axi_seq_item req);
	extern task read_address_channel(axi_seq_item req);
	extern task read_data_channel(axi_seq_item req);

endclass

task axi_driver ::  main_phase(uvm_phase phase);
	super.main_phase(phase);

	forever begin
		wait(inf.arstn == 1'b1);
		@(inf.drv_cb);
		seq_item_port.get_next_item(req);
		drive_txn(req);
		seq_item_port.item_done;
	end
endtask


task axi_driver :: drive_txn(axi_seq_item req);

	if(req.overlap == 1'b1) begin
		if(req.trans_type == WRITE_ONLY) fork
			if(req.addr_overlap == 1) begin
				wr_qu.push_back(req);
				write_address_channel(req);
			end

			if(req.data_overlap == 1) begin
				req = wr_qu.pop_front();
				write_data_channel(req);
				write_response_channel(req);

			end

		join

		if(req.trans_type == READ_ONLY) fork
			if(req.read_overlap == 1) begin
				rd_qu.push_back(req);
				read_address_channel(req);
			end

			if(req.rd_data_overlap == 1) begin
				req = rd_qu.pop_front();
				read_data_channel(req);
			end


		join
	end

	else begin

		if(req.trans_type == WRITE_ONLY) begin
			write_address_channel(req);
			write_data_channel(req);
			write_response_channel(req);
		end

		else if(req.trans_type == READ_ONLY) begin
			read_address_channel(req);
			read_data_channel(req);
		end

		else if(req.trans_type == WRITE_THEN_READ) begin
			write_address_channel(req);
			write_data_channel(req);
			write_response_channel(req);
			read_address_channel(req);
			read_data_channel(req);
		end

		else if(req.trans_type == WRITE_PARALLEL_READ) fork
			begin
				write_address_channel(req);
				write_data_channel(req);
				write_response_channel(req);
			end
	
			begin
				read_address_channel(req);
				read_data_channel(req);
			end

		join
	end

endtask


task axi_driver :: write_address_channel(axi_seq_item req);
	inf.drv_cb.awvalid <= 1'b1;
	inf.drv_cb.awid    <= req.awid;
	inf.drv_cb.awaddr  <= req.awaddr;
	inf.drv_cb.awsize  <= req.awsize;
	inf.drv_cb.awlen   <= req.awlen;
	inf.drv_cb.awburst <= bit'(req.awburst);
	inf.drv_cb.awlock  <= req.awlock;
	inf.drv_cb.awprot  <= req.awprot;
	inf.drv_cb.awcache <= req.awcache;
	wait(inf.drv_cb.awready == 1)
	inf.drv_cb.awvalid <= 1'b0;
	inf.drv_cb.awid    <= 'dx;
	inf.drv_cb.awaddr  <= 'dx;
	inf.drv_cb.awsize  <= 'dx;
	inf.drv_cb.awlen   <= 'dx;
	inf.drv_cb.awburst <= 'dx;
	inf.drv_cb.awlock  <= 'dx;
	inf.drv_cb.awprot  <= 'dx;
	inf.drv_cb.awcache <= 'dx;


endtask


task axi_driver :: write_data_channel(axi_seq_item req);
	for(int i=0;i<= req.awlen; i++) begin
		inf.drv_cb.wvalid<= 1'b1;
		inf.drv_cb.wid   <= req.wid;
		inf.drv_cb.wdata <= req.wdata.pop_front();
		inf.drv_cb.wstrb <= req.wstrb.pop_front();
		if(i == req.awlen) begin
			inf.drv_cb.wlast <= 1;
		end
		else
			inf.drv_cb.wlast <= 0;
		@(inf.drv_cb);
	end
	wait(inf.drv_cb.wready == 1)
	inf.drv_cb.wvalid <= 1'b0;
	inf.drv_cb.wid    <= 'dx;
	inf.drv_cb.wdata  <= 'dx;
	inf.drv_cb.wstrb  <= 'dx;
	inf.drv_cb.wlast  <= 'dx;

endtask


task axi_driver :: write_response_channel(axi_seq_item req);
	inf.drv_cb.bready <= 1;
	//wait(inf.drv_cb.bvalid == 1);
	//inf.drv_cb.bready <= 0;

endtask


task axi_driver :: read_address_channel(axi_seq_item req);
	inf.drv_cb.arvalid <= 1'b1;
	inf.drv_cb.arid    <= req.arid;
	inf.drv_cb.araddr  <= req.araddr;
	inf.drv_cb.arsize  <= req.arsize;
	inf.drv_cb.arlen   <= req.arlen;
	inf.drv_cb.arburst <= bit'(req.arburst);
	inf.drv_cb.arlock  <= req.arlock;
	inf.drv_cb.arprot  <= req.arprot;
	inf.drv_cb.arcache <= req.arcache;
	wait(inf.drv_cb.arready == 1)
	inf.drv_cb.arvalid <= 1'b0;
	inf.drv_cb.arid    <= 'dx;
	inf.drv_cb.araddr  <= 'dx;
	inf.drv_cb.arsize  <= 'dx;
	inf.drv_cb.arlen   <= 'dx;
	inf.drv_cb.arburst <= 'dx;
	inf.drv_cb.arlock  <= 'dx;
	inf.drv_cb.arprot  <= 'dx;
	inf.drv_cb.arcache <= 'dx;
endtask


task axi_driver :: read_data_channel(axi_seq_item req);
	inf.drv_cb.rready  <= 1'b1;
	wait(inf.drv_cb.rvalid && inf.drv_cb.rlast);
	inf.drv_cb.rready  <= 1'b0;


endtask

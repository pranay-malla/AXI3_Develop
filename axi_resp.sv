class axi_resp extends uvm_component;
  
  `uvm_component_utils(axi_resp)
  virtual axi_interface.resp_mod resp_inf;
  
   axi_seq_item wr_tx[int];  // Assosiative array to store WRITE ADDRESS CHANNEL Signals
   axi_seq_item ar_tx[int];  // Assosiative array to store READ ADDRESS CHANNEL Signals
   axi_seq_item wr_tmp_data,rd_tmp_data;
   bit wr_addr_flag [int];
   bit ar_addr_flag [int];
   bit wr_data_flag [int];
   int aw_id_idx, wr_id_idx,rd_id_idx;
   bit aw_bit, wr_bit,rd_bit;
   reg [7:0] wr_mem [1000];  // Memory of width:8 and depth:1024
   int wdata_in_bytes,rdata_in_bytes;        // To calcuate the next beat awaddress of a Transaction 

  `UVM_COMP
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_interface)::get(this,"","RESP_INF",resp_inf))
      `uvm_fatal("INTERFACE_CONFIG_DB","unable to retrive the Responder interface config_db")
  endfunction

  task main_phase(uvm_phase phase);
	  super.main_phase(phase);
	  fork
		  forever begin
			  @(resp_inf.resp_cb);
			  reset_data();
		  end
		  forever begin
			  @(resp_inf.resp_cb);
			  write_address_channel();
		  end
		  forever begin
			  @(resp_inf.resp_cb);
			  write_data_channel();
		  end
		  forever begin
			  @(resp_inf.resp_cb);
			  write_response_channel();
		  end
		  forever begin
			  @(resp_inf.resp_cb);
			  read_address_channel();
		  end
		  forever begin
			  @(resp_inf.resp_cb);
			  read_data_channel();
		  end
	  join
  endtask

  extern task reset_data();
  extern task write_address_channel();
  extern task write_data_channel();
  extern task write_response_channel();
  extern task read_address_channel();
  extern task read_data_channel();

endclass

task axi_resp::reset_data();

	if(!resp_inf.resp_mod.aresetn) begin
		resp_inf.resp_cb.awready <= 1'b0;
		resp_inf.resp_cb.wready  <= 1'b0;
		resp_inf.resp_cb.bid     <= 'dx;
		resp_inf.resp_cb.bvalid  <= 1'b0;
		resp_inf.resp_cb.bresp   <= 'dx;
		resp_inf.resp_cb.arready <= 1'b0;
		resp_inf.resp_cb.rvalid  <= 1'b0;
		resp_inf.resp_cb.rid     <= 'dx;
		resp_inf.resp_cb.rlast   <= 'dx;
		resp_inf.resp_cb.rresp   <= 'dx;
		resp_inf.resp_cb.rdata   <= 'dx;

	end
endtask

task axi_resp::write_address_channel();
	if(resp_inf.resp_cb.awvalid && !resp_inf.resp_cb.awready)
		resp_inf.resp_cb.awready <= 1'b1;
	else 
		resp_inf.resp_cb.awready <= 1'b0;

	if(resp_inf.resp_cb.awvalid && resp_inf.resp_cb.awready) begin
		wr_tx[resp_inf.resp_cb.awid] = new();
		wr_tx[resp_inf.resp_cb.awid].AWID    = resp_inf.resp_cb.awid;
		wr_tx[resp_inf.resp_cb.awid].AWADDR  = resp_inf.resp_cb.awaddr;
		wr_tx[resp_inf.resp_cb.awid].AWLEN   = resp_inf.resp_cb.awlen;
		wr_tx[resp_inf.resp_cb.awid].AWSIZE  = resp_inf.resp_cb.awsize;
		wr_tx[resp_inf.resp_cb.awid].AWBURST = burst_type'(resp_inf.resp_cb.awburst);
		wr_tx[resp_inf.resp_cb.awid].AWLOCK  = resp_inf.resp_cb.awlock;
		wr_tx[resp_inf.resp_cb.awid].AWPROT  = resp_inf.resp_cb.awprot;
		wr_tx[resp_inf.resp_cb.awid].AWCACHE = resp_inf.resp_cb.awcache;
		wr_addr_flag[resp_inf.resp_cb.awid] = 1'b1;

	end
endtask

task axi_resp::write_data_channel();

	resp_inf.resp_cb.wready <= 1'b1;
	 
	if(resp_inf.resp_cb.wvalid && resp_inf.resp_cb.wready) begin

		wr_tmp_data = wr_tx[resp_inf.resp_cb.wid];

		if(wr_tmp_data.AWBURST == FIXED) begin

		end

		else if(wr_tmp_data.AWBURST == INCR) begin

			wr_tmp_data.AWADDR = wr_tmp_data.AWADDR - (wr_tmp_data.AWADDR%(2**wr_tmp_data.AWSIZE)); // unaligned to aligned
			wdata_in_bytes = $size(resp_inf.resp_cb.wdata)/8;

			for(int i=0; i<= wr_tmp_data.AWLEN;i++) begin
				foreach(resp_inf.resp_cb.wstrb[j]) begin
					if(resp_inf.resp_cb.wstrb[j] == 1)
						wr_mem[wr_tmp_data.AWADDR+j] = resp_inf.resp_cb.wdata[8*j +: 8];
					else
						wr_mem[wr_tmp_data.AWADDR+j] = 0;

					$display($time," :WRITE BEATS count: %0d----and AWADDR:%h----::> Value_LHS:%h------Value_RHS:%h----",j,wr_tmp_data.AWADDR+j,wr_mem[wr_tmp_data.AWADDR + j],resp_inf.resp_cb.wdata[8*j +: 8]);

				end

				
				if(i == wr_tmp_data.AWLEN)
					wr_data_flag [resp_inf.resp_cb.wid] = 1;
								
				@(resp_inf.resp_cb);
				wr_tmp_data.AWADDR =wr_tmp_data.AWADDR + wdata_in_bytes;
				
			end
	 	        resp_inf.resp_cb.wready <= 1'b0;

		end

		else if(wr_tmp_data.AWBURST == WRAP) begin

		end

		else
			`uvm_error("RESPODER_ERROR","Invalid AWBURST type found!")

		
	end
endtask

task axi_resp::write_response_channel();

	if(wr_data_flag.num() >0 && wr_addr_flag.num()>0) begin
		wr_data_flag.first(wr_id_idx);
		wr_addr_flag.first(aw_id_idx);

		wr_bit = wr_data_flag[wr_id_idx];
		aw_bit = wr_addr_flag[aw_id_idx];
		//$display($time,"wr_bit:%0b aw_bit:%0b :: wr_id_idx:%0d aw_id_idx:%0d",wr_bit,aw_bit,wr_id_idx,aw_id_idx);

		if(aw_bit && wr_bit && (wr_id_idx == aw_id_idx)) begin
			resp_inf.resp_cb.bvalid <= 1'b1;
			resp_inf.resp_cb.bid   <= wr_id_idx;
			resp_inf.resp_cb.bresp <= bit'(OKAY);
			@(resp_inf.resp_cb);
		end
		else 
		        resp_inf.resp_cb.bvalid <= 1'b0;
	end
	
	if(resp_inf.resp_cb.bvalid && resp_inf.resp_cb.bready) begin
		//resp_inf.resp_cb.bid   <= wr_id_idx;
		//resp_inf.resp_cb.bresp <= bit'(OKAY);
		//@(resp_inf.resp_cb);
		resp_inf.resp_cb.bid   <= 'dx;
		resp_inf.resp_cb.bresp <= 'dx;
		resp_inf.resp_cb.bvalid<= 0;
		wr_data_flag.delete(wr_id_idx);
		wr_addr_flag.delete(aw_id_idx);
		
	end
endtask


task axi_resp::read_address_channel();
	if(resp_inf.resp_cb.arvalid && !resp_inf.resp_cb.arready)
		resp_inf.resp_cb.arready <= 1'b1;
	else
		resp_inf.resp_cb.arready <= 1'b0;

	if(resp_inf.resp_cb.arvalid && resp_inf.resp_cb.arready) begin
		ar_tx[resp_inf.resp_cb.arid] = new();
		ar_tx[resp_inf.resp_cb.arid].ARID    = resp_inf.resp_cb.arid;
		ar_tx[resp_inf.resp_cb.arid].ARADDR  = resp_inf.resp_cb.araddr;
		ar_tx[resp_inf.resp_cb.arid].ARLEN   = resp_inf.resp_cb.arlen;
		ar_tx[resp_inf.resp_cb.arid].ARSIZE  = resp_inf.resp_cb.arsize;
		ar_tx[resp_inf.resp_cb.arid].ARBURST = burst_type'(resp_inf.resp_cb.arburst);
		ar_tx[resp_inf.resp_cb.arid].ARLOCK  = resp_inf.resp_cb.arlock;
		ar_tx[resp_inf.resp_cb.arid].ARPROT  = resp_inf.resp_cb.arprot;
		ar_tx[resp_inf.resp_cb.arid].ARCACHE = resp_inf.resp_cb.arcache;
		ar_addr_flag[resp_inf.resp_cb.arid] = 1'b1;
	end
endtask

task axi_resp::read_data_channel();

	if(ar_addr_flag.num()>0) begin
		ar_addr_flag.first(rd_id_idx);
		rd_bit = ar_addr_flag[rd_id_idx];

		/*if(rd_bit ==1) begin
		       @(resp_inf.resp_cb);
			resp_inf.resp_cb.rvalid <= 1;

		end
		else 
			resp_inf.resp_cb.rvalid <= 0;*/

		if(rd_bit && resp_inf.resp_cb.rready) begin
			if(ar_tx[rd_id_idx].ARBURST == FIXED) begin

			end

			else if(ar_tx[rd_id_idx].ARBURST == INCR) begin

				ar_tx[rd_id_idx].ARADDR = ar_tx[rd_id_idx].ARADDR - (ar_tx[rd_id_idx].ARADDR % 2**ar_tx[rd_id_idx].ARSIZE);

				rdata_in_bytes = $size(DATA_BUSWIDTH)/8;

				for(int i =0; i<= ar_tx[rd_id_idx].ARLEN; i++) begin
					for(int j = 0; j< (2**ar_tx[rd_id_idx].ARSIZE); j++)
						resp_inf.resp_cb.rdata[8*j +: 8] <= wr_mem[ar_tx[rd_id_idx].ARADDR+j];
					resp_inf.resp_cb.rid <= rd_id_idx;
					resp_inf.resp_cb.rresp <= bit'(OKAY);
					if(i == ar_tx[rd_id_idx].ARLEN) 
						resp_inf.resp_cb.rlast <= 1;
					else
						resp_inf.resp_cb.rlast <= 0;
					resp_inf.resp_cb.rvalid <= 1;
					
					ar_tx[rd_id_idx].ARADDR = ar_tx[rd_id_idx].ARADDR + rdata_in_bytes;

					@(resp_inf.resp_cb);		
				end
				resp_inf.resp_cb.rvalid <= 0;
				resp_inf.resp_cb.rdata <= 'dx;
				resp_inf.resp_cb.rlast <= 'dx;
				resp_inf.resp_cb.rid   <= 'dx;
				resp_inf.resp_cb.rresp <= 'dx;
				ar_addr_flag.delete(rd_id_idx);

			end

			else if(ar_tx[rd_id_idx].ARBURST == WRAP) begin

			end

			else 
				`uvm_error("RESPONDER_ARBUSRT","unable to find the ARBURST type")
		end
	end
endtask

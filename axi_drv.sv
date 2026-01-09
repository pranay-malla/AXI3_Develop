class axi_drv extends uvm_driver#(axi_seq_item);
	`uvm_component_utils(axi_drv)
  
  virtual axi_interface.drv_mod drv_inf;
  
  `UVM_COMP
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_interface)::get(this,"","DRV_INF",drv_inf))
      `uvm_fatal("INTERFACE_CONFIG_DB","unable to retrive the Driver interface config_db")
  endfunction
      
  task main_phase(uvm_phase phase); 
    super.main_phase(phase);
    forever begin
      wait(drv_inf.drv_mod.aresetn == 1'b1);
      @(drv_inf.drv_cb);
      seq_item_port.get_next_item(req);
      drive_txn(req);
      seq_item_port.item_done;
    end
  endtask
    
    extern task drive_txn(axi_seq_item txn);
    extern task write_address_channel(axi_seq_item txn);
    extern task write_data_channel(axi_seq_item txn);
    extern task write_response_channel(axi_seq_item txn);
    extern task read_address_channel(axi_seq_item txn);
    extern task read_data_channel(axi_seq_item txn);
    
    
endclass
    
   task axi_drv::drive_txn(axi_seq_item txn);
     if(txn.TRANS_TYPE == WRITE_ONLY) begin
       write_address_channel(txn);
       write_data_channel(txn);
       write_response_channel(txn);
     end
     
     else if(txn.TRANS_TYPE == READ_ONLY) begin
       read_address_channel(txn);
       read_data_channel(txn);
     end
     
     else if(txn.TRANS_TYPE == WRITE_THEN_READ) begin
       write_address_channel(txn);
       write_data_channel(txn);
       write_response_channel(txn);
       read_address_channel(txn);
       read_data_channel(txn);
     end
     
     else if(txn.TRANS_TYPE == WRITE_PARALLEL_READ) begin
       
       fork
       begin
       write_address_channel(txn);
       write_data_channel(txn);
       write_response_channel(txn);
       end
       
       begin
       read_address_channel(txn);
       read_data_channel(txn);
       end
       join
     end
        
        
   endtask

      
   task axi_drv::write_address_channel(axi_seq_item txn);
     drv_inf.drv_cb.awid <= txn.AWID;
     drv_inf.drv_cb.awaddr <= txn.AWADDR;
     drv_inf.drv_cb.awlen <= txn.AWLEN;
     drv_inf.drv_cb.awsize <= txn.AWSIZE;
     drv_inf.drv_cb.awburst <= txn.AWBURST;
     drv_inf.drv_cb.awlock <= txn.AWLOCK;
     drv_inf.drv_cb.awprot <= txn.AWPROT;
     drv_inf.drv_cb.awcache <= txn.AWCACHE;
     drv_inf.drv_cb.awvalid <= 1'b1;
     wait(drv_inf.drv_cb.awready == 1);
     drv_inf.drv_cb.awid <= 'dx;
     drv_inf.drv_cb.awaddr <= 'dx;
     drv_inf.drv_cb.awlen <= 'dx;
     drv_inf.drv_cb.awsize <= 'dx;
     drv_inf.drv_cb.awburst <= 'dx;
     drv_inf.drv_cb.awlock <= 'dx;
     drv_inf.drv_cb.awprot <= 'dx;
     drv_inf.drv_cb.awcache <= 'dx;
     drv_inf.drv_cb.awvalid <= 1'b0;
     
   endtask
      
   task axi_drv::write_data_channel(axi_seq_item txn);
     for(int i=0; i<= txn.AWLEN;i++) begin
       drv_inf.drv_cb.wid <= txn.WID;
       drv_inf.drv_cb.wdata <= txn.WDATA.pop_front();
       drv_inf.drv_cb.wstrb <= txn.WSTRB.pop_front();
       if(i == txn.AWLEN)
         drv_inf.drv_cb.wlast <= 1;
       else
         drv_inf.drv_cb.wlast <= 0;
       drv_inf.drv_cb.wvalid <= 1'b1;
       drv_inf.drv_cb.bready <= 1'b1;
       @(drv_inf.drv_cb);
       wait(drv_inf.drv_cb.wready == 1); 
     end
     drv_inf.drv_cb.wid <= 'dx;
     drv_inf.drv_cb.wdata <= 'dx;
     drv_inf.drv_cb.wlast <= 0;
     drv_inf.drv_cb.wstrb <= 'dx;
     drv_inf.drv_cb.wvalid <= 1'b0;
   endtask
      
   task axi_drv::write_response_channel(axi_seq_item txn);
     drv_inf.drv_cb.bready <= 1'b1;
     wait(drv_inf.drv_cb.bvalid);
     drv_inf.drv_cb.bready <= 1'b0;
     
   endtask
      
   task axi_drv::read_address_channel(axi_seq_item txn);
     drv_inf.drv_cb.arid <= txn.ARID;
     drv_inf.drv_cb.araddr <= txn.ARADDR;
     drv_inf.drv_cb.arlen <= txn.ARLEN;
     drv_inf.drv_cb.arsize <= txn.ARSIZE;
     drv_inf.drv_cb.arburst <= txn.ARBURST;
     drv_inf.drv_cb.arlock <= txn.ARLOCK;
     drv_inf.drv_cb.arprot <= txn.ARPROT;
     drv_inf.drv_cb.arcache <= txn.ARCACHE;
     drv_inf.drv_cb.arvalid <= 1'b1;
     wait(drv_inf.drv_cb.arready == 1);
     drv_inf.drv_cb.rready <= 1;
     drv_inf.drv_cb.arid <= 'dx;
     drv_inf.drv_cb.araddr <= 'dx;
     drv_inf.drv_cb.arlen <= 'dx;
     drv_inf.drv_cb.arsize <= 'dx;
     drv_inf.drv_cb.arburst <= 'dx;
     drv_inf.drv_cb.arlock <= 'dx;
     drv_inf.drv_cb.arprot <= 'dx;
     drv_inf.drv_cb.arcache <= 'dx;
     drv_inf.drv_cb.arvalid <= 1'b0;

   endtask
      
      
   task axi_drv::read_data_channel(axi_seq_item txn);
     drv_inf.drv_cb.rready <= 1;
     wait(drv_inf.drv_cb.rlast && drv_inf.drv_cb.rvalid);
     drv_inf.drv_cb.rready <= 0;
   endtask
   
         
      

class axi_mon extends uvm_monitor;
	`uvm_component_utils(axi_mon)

  uvm_analysis_port#(axi_seq_item) ap_mon;
  virtual axi_interface.mon_mod mon_inf;

  `UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap_mon = new("ap_mon",this);
      if(!uvm_config_db#(virtual axi_interface)::get(this,"","MON_INF",mon_inf))
        `uvm_fatal("INTERFACE_CONFIG_DB","unable to retrive the Monitor interface config_db")
	endfunction
endclass

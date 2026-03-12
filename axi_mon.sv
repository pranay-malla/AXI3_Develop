class axi_monitor extends uvm_monitor;
	`uvm_component_utils(axi_monitor)

	virtual axi_interface.mon_mod inf;

	 uvm_analysis_port#(axi_seq_item) mon_ap;

	`UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
				
		if(!uvm_config_db#(virtual axi_interface)::get(this,"","MONITOR",inf))
			`uvm_error("MONITOR","Unable to get the Interface handle!")
		
		mon_ap = new("mon_ap",this);

		
	endfunction

endclass

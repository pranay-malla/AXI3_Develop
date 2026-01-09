class axi_agent extends uvm_agent;

	`uvm_component_utils(axi_agent)
	axi_sqr sqr;
	axi_drv drv;
	axi_mon mon;
	axi_resp resp;

  `UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","AGENT",is_active))
			`uvm_fatal("UVM_CONFIG_DB_ERROR","Unable to retrive the AGENT config")

		if(is_active == UVM_ACTIVE) begin
			sqr = axi_sqr::type_id::create("sqr",this);
			drv = axi_drv::type_id::create("drv",this);
			mon = axi_mon::type_id::create("mon",this);
		end
		else

			resp = axi_resp::type_id::create("resp",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass

class axi_agent extends uvm_agent;
	`uvm_component_utils(axi_agent)

	
	axi_sqcr sqr;
	axi_driver drv;
	axi_monitor mon;
	axi_responder resp;

	`UVM_COMP


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","AGENT",is_active))
			`uvm_error("UVM_AGENT","unable to get the ACTIVE_PASSIVE Agent")

		if(is_active == UVM_ACTIVE) begin
			sqr = axi_sqcr :: type_id :: create("sqr",this);
			drv = axi_driver :: type_id :: create("drv",this);
			mon = axi_monitor :: type_id :: create("mon",this);
		end

		else
			resp = axi_responder :: type_id :: create("resp",this);
			

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction

endclass

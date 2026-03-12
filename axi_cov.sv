class axi_cov extends uvm_subscriber#(axi_seq_item);
	`uvm_component_utils(axi_cov)


	`UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	
	function void write(axi_seq_item t);

	endfunction
endclass

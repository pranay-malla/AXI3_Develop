class axi_sco extends uvm_scoreboard;
	`uvm_component_utils(axi_sco)
  uvm_analysis_imp#(axi_seq_item,axi_sco)	ai_sco;

  `UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      ai_sco = new("ai_sco",this);
	endfunction
  
  function void write(axi_seq_item t);
    
  endfunction

endclass

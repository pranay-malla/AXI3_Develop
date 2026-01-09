class axi_env extends uvm_env;

	`uvm_component_utils(axi_env)

	axi_agent m_agent, s_agent;
	axi_sco		sco;
	axi_cov		cov;

   `UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_agent = axi_agent:: type_id:: create("m_agent",this);
		s_agent = axi_agent:: type_id:: create("s_agent",this);
		sco = axi_sco:: type_id:: create("sco",this);
		cov = axi_cov:: type_id:: create("cov",this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
     	m_agent.mon.ap_mon.connect(sco.ai_sco);
		m_agent.mon.ap_mon.connect(cov.analysis_export);
	endfunction

endclass

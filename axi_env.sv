class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)

	`UVM_COMP

	axi_agent m_agt;
        axi_agent s_agt;
	axi_sco sco;
	axi_cov cov;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		m_agt = axi_agent :: type_id :: create("m_agt",this);
		s_agt = axi_agent :: type_id :: create("s_agt",this);
		sco = axi_sco :: type_id :: create("sco",this);
		cov = axi_cov :: type_id :: create("cov",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_agt.mon.mon_ap.connect(sco.sco_imp);
		m_agt.mon.mon_ap.connect(cov.analysis_export);		
	endfunction

endclass

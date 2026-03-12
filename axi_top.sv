module axi_top;

	bit clk, rst;
	bit outstanding;

	axi_interface inf(.aclk(clk),.arstn(rst));

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	initial begin
		rst = 1'b0;
		repeat(2) @(posedge clk);
		rst = 1'b1;
	end

	initial begin
		$value$plusargs("OUTSTANDING=%b",outstanding);
		$display("Outstanding=%b", outstanding);
		uvm_config_db#(bit)::set(null,"uvm_test_top.env.s_agt.resp","OUT_STANDING",outstanding);
		uvm_config_db#(uvm_active_passive_enum)::set(null,"uvm_test_top.env.m_agt","AGENT",UVM_ACTIVE);
		uvm_config_db#(uvm_active_passive_enum)::set(null,"uvm_test_top.env.s_agt","AGENT",UVM_PASSIVE);
		
		uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.m_agt.drv","drv_inf",inf.drv_mod);
		uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.m_agt.mon","MONITOR",inf.mon_mod);
		uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.s_agt.resp","RESPONDER",inf.resp_mod);
		run_test("");
	end
endmodule

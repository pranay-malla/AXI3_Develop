module axi_top;
  
  bit aclk;
  bit aresetn;
  
  axi_interface inf(.aclk(aclk),.aresetn(aresetn));  
  
  initial begin
    aclk = 1'b0;
    forever #5 aclk = ~aclk;
  end

  
  initial begin
    aresetn = 1'b0;
    repeat(2) @(posedge aclk);
    aresetn = 1'b1;
  end
  
initial begin
  //ACTIVE_PASSIVE_AGENT
  uvm_config_db#(uvm_active_passive_enum)::set(null,"uvm_test_top.env.m_agent","AGENT",UVM_ACTIVE);
  uvm_config_db#(uvm_active_passive_enum)::set(null,"uvm_test_top.env.s_agent","AGENT",UVM_PASSIVE);

  //INTERFACE
  uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.m_agent.drv","DRV_INF",inf.drv_mod);
  uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.m_agent.mon","MON_INF",inf.mon_mod);
  uvm_config_db#(virtual axi_interface)::set(null,"uvm_test_top.env.s_agent.resp","RESP_INF",inf.resp_mod);
	run_test("axi_incr_multiple_write_parallel_read_test");
end
  
endmodule

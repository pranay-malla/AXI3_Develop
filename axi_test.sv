class axi_base_test extends uvm_test;

	`uvm_component_utils(axi_base_test)
  
   	axi_env env;
  
    `UVM_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = axi_env :: type_id :: create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
       		factory.print();
		uvm_top.print_topology();
	endfunction
  



endclass

class axi_incr_single_write_test extends axi_base_test;

	`uvm_component_utils(axi_incr_single_write_test)

	axi_incr_single_write_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_single_write_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass

class axi_incr_multiple_write_test extends axi_base_test;

	`uvm_component_utils(axi_incr_multiple_write_test)

	axi_incr_multiple_write_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_multiple_write_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass



class axi_incr_single_write_read_test extends axi_base_test;

	`uvm_component_utils(axi_incr_single_write_read_test)

	axi_incr_single_write_read_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_single_write_read_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass

class axi_incr_multiple_write_read_test extends axi_base_test;

	`uvm_component_utils(axi_incr_multiple_write_read_test)

	axi_incr_multiple_write_read_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_multiple_write_read_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass

class axi_incr_multiple_write_then_read_test extends axi_base_test;

	`uvm_component_utils(axi_incr_multiple_write_then_read_test)

	axi_incr_multiple_write_then_read_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_multiple_write_then_read_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass

class axi_incr_multiple_write_parallel_read_test extends axi_base_test;

	`uvm_component_utils(axi_incr_multiple_write_parallel_read_test)

	axi_incr_multiple_write_parallel_read_seq	seq;

	`UVM_COMP

  	task main_phase(uvm_phase phase);
     		seq = axi_incr_multiple_write_parallel_read_seq :: type_id :: create("seq");
    		super.run_phase(phase);
   		phase.raise_objection(this);
    		seq.start(env.m_agent.sqr);
    		phase.drop_objection(this);
    		phase.phase_done.set_drain_time(this,100);
  	endtask


endclass

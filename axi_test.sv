class axi_base_test extends uvm_test;
	`uvm_component_utils(axi_base_test)

	`UVM_COMP

	axi_env env;
	axi_base_seq seq;

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

class incr_single_write_test extends axi_base_test;           // TEST_CASE ==> 01
	`uvm_component_utils(incr_single_write_test)

	`UVM_COMP

	incr_single_write_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_single_write_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass


class incr_multiple_write_test extends axi_base_test;           // TEST_CASE ==> 02
	`uvm_component_utils(incr_multiple_write_test)

	`UVM_COMP

	incr_multiple_write_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_multiple_write_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_single_write_single_read_test extends axi_base_test;   // TEST_CASE ==> 03
	`uvm_component_utils(incr_single_write_single_read_test)

	`UVM_COMP

	incr_single_write_single_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_single_write_single_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_single_write_then_read_test extends axi_base_test;    // TEST_CASE ==> 04
	`uvm_component_utils(incr_single_write_then_read_test)

	`UVM_COMP

	incr_single_write_then_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_single_write_then_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_single_write_parallel_read_test extends axi_base_test;  // TEST_CASE ==> 05
	`uvm_component_utils(incr_single_write_parallel_read_test)

	`UVM_COMP

	incr_single_write_parallel_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_single_write_parallel_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_multiple_write_multiple_read_test extends axi_base_test;  // TEST_CASE ==> 06
	`uvm_component_utils(incr_multiple_write_multiple_read_test)

	`UVM_COMP

	incr_multiple_write_multiple_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_multiple_write_multiple_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass


class incr_overlap_multiple_write_test extends axi_base_test;  // TEST_CASE ==> 07
	`uvm_component_utils(incr_overlap_multiple_write_test)

	`UVM_COMP

	incr_overlap_multiple_write_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_overlap_multiple_write_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_overlap_multiple_write_multiple_read_test extends axi_base_test;  // TEST_CASE ==> 08
	`uvm_component_utils(incr_overlap_multiple_write_multiple_read_test)

	`UVM_COMP

	incr_overlap_multiple_write_multiple_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_overlap_multiple_write_multiple_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass



class incr_narrow_overlap_multiple_write_multiple_read_test extends axi_base_test;  // TEST_CASE ==> 09
	`uvm_component_utils(incr_narrow_overlap_multiple_write_multiple_read_test)

	`UVM_COMP

	incr_narrow_overlap_multiple_write_multiple_read_seq seq;

	task main_phase(uvm_phase phase);
		super.main_phase(phase);
		seq = incr_narrow_overlap_multiple_write_multiple_read_seq :: type_id ::create("seq");
		phase.raise_objection(this);
		seq.start(env.m_agt.sqr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,100);
	endtask

endclass

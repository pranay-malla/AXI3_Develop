class axi_base_seq extends uvm_sequence#(axi_seq_item);

	`uvm_object_utils(axi_base_seq)

	`UVM_OBJ


endclass

class incr_single_write_seq extends axi_base_seq;            // sequence ==> 01
	`uvm_object_utils(incr_single_write_seq)

	`UVM_OBJ

	task body();
		
		`uvm_do_with(req,{req.awaddr == 10; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap == 0;});
	endtask
endclass

class incr_multiple_write_seq extends axi_base_seq;          // Sequence ==> 02
	`uvm_object_utils(incr_multiple_write_seq)

	`UVM_OBJ

	task body();

		`uvm_do_with(req,{req.awaddr == 14; req.awsize == 1; req.awlen==5; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap == 0;});

		`uvm_do_with(req,{req.awaddr == 27; req.awsize == 2; req.awlen==5; req.awburst == INCR; req.awid == 3; req.trans_type == WRITE_ONLY;req.overlap == 0;});
		`uvm_do_with(req,{req.awaddr == 56; req.awsize == 0; req.awlen==5; req.awburst == INCR; req.awid == 7; req.trans_type == WRITE_ONLY;req.overlap == 0;});
	endtask

endclass


class incr_single_write_single_read_seq extends axi_base_seq; // Sequence ==> 03
	`uvm_object_utils(incr_single_write_single_read_seq)

	`UVM_OBJ

	task body();
		`uvm_do_with(req,{req.awaddr == 10; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap == 0;});

		`uvm_do_with(req,{req.araddr == 10; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 1; req.trans_type == READ_ONLY;req.overlap == 0;});

	endtask
endclass


class incr_single_write_then_read_seq extends axi_base_seq;   // Sequence ==> 04
	`uvm_object_utils(incr_single_write_then_read_seq)

	`UVM_OBJ

	task body();

		`uvm_do_with(req,{req.awaddr == 15; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 4; 
				  req.araddr == 15; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 4; 
				  req.trans_type == WRITE_THEN_READ;});

	endtask


endclass


class incr_single_write_parallel_read_seq extends axi_base_seq; // Sequence ==> 05
	`uvm_object_utils(incr_single_write_parallel_read_seq)
	`UVM_OBJ

	task body();
		
		`uvm_do_with(req,{req.awaddr == 10; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap == 0;});
		`uvm_do_with(req,{req.awaddr == 27; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 3; 
				  req.araddr == 10; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 1; 
				  req.trans_type == WRITE_PARALLEL_READ;req.overlap ==0;});

	endtask
endclass



class incr_multiple_write_multiple_read_seq extends axi_base_seq; // Sequence ==> 06
	`uvm_object_utils(incr_multiple_write_multiple_read_seq)

	`UVM_OBJ

	task body();

		`uvm_do_with(req,{req.awaddr == 10; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap ==0;});

		`uvm_do_with(req,{req.awaddr == 27; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 3; req.trans_type == WRITE_ONLY;req.overlap ==0;});
		`uvm_do_with(req,{req.awaddr == 49; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 5; req.trans_type == WRITE_ONLY;req.overlap ==0;});

		`uvm_do_with(req,{req.araddr == 10; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 1; req.trans_type == READ_ONLY;req.overlap ==0;});
		`uvm_do_with(req,{req.araddr == 27; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 3; req.trans_type == READ_ONLY;req.overlap ==0;});
		`uvm_do_with(req,{req.araddr == 49; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 5; req.trans_type == READ_ONLY;req.overlap ==0;});

	endtask

endclass


class incr_overlap_multiple_write_seq extends axi_base_seq;  // Sequence ==> 07
	`uvm_object_utils(incr_overlap_multiple_write_seq)

	`UVM_OBJ

	task body();
		`uvm_do_with(req,{req.awaddr == 14; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY;req.overlap ==1; req.addr_overlap == 1; req.data_overlap == 0;});
		`uvm_do_with(req,{req.awaddr == 35; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 3; req.trans_type == WRITE_ONLY;req.overlap ==1;req.addr_overlap == 1; req.data_overlap == 1;});
		`uvm_do_with(req,{req.awaddr == 65; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 5; req.trans_type == WRITE_ONLY;req.overlap ==1;req.addr_overlap == 1; req.data_overlap == 1;});
		`uvm_do_with(req,{req.awaddr == 85; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 7; req.trans_type == WRITE_ONLY;req.overlap ==1;req.addr_overlap == 0; req.data_overlap == 1;});

	endtask

endclass



class incr_overlap_multiple_write_multiple_read_seq extends axi_base_seq;  // Sequence ==> 08
	`uvm_object_utils(incr_overlap_multiple_write_multiple_read_seq)

	`UVM_OBJ

	task body();
		`uvm_do_with(req,{req.awaddr == 10; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 1; req.trans_type == WRITE_ONLY; req.overlap ==1; req.addr_overlap == 1; req.data_overlap == 0;});

		`uvm_do_with(req,{req.awaddr == 35; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 3; req.trans_type == WRITE_ONLY; req.overlap ==1; req.addr_overlap == 1; req.data_overlap == 1;});

		`uvm_do_with(req,{req.awaddr == 65; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 5; req.trans_type == WRITE_ONLY; req.overlap ==1; req.addr_overlap == 1; req.data_overlap == 1;});
 
		`uvm_do_with(req,{req.awaddr == 85; req.awsize == 2; req.awlen==3; req.awburst == INCR; req.awid == 7; req.trans_type == WRITE_ONLY; req.overlap ==1; req.addr_overlap == 0; req.data_overlap == 1;});


		`uvm_do_with(req,{req.araddr == 10; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 1; req.trans_type == READ_ONLY;req.overlap ==1; req.read_overlap == 1; req.rd_data_overlap == 0;});
	
		`uvm_do_with(req,{req.araddr == 35; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 3; req.trans_type == READ_ONLY; req.overlap ==1;req.read_overlap == 1; req.rd_data_overlap == 1;});

		`uvm_do_with(req,{req.araddr == 65; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 5; req.trans_type == READ_ONLY;req.overlap ==1; req.read_overlap == 1; req.rd_data_overlap == 1;});

		`uvm_do_with(req,{req.araddr == 85; req.arsize == 2; req.arlen==3; req.arburst == INCR; req.arid == 7; req.trans_type == READ_ONLY;req.overlap ==1; req.read_overlap == 0; req.rd_data_overlap == 1;});

	endtask

endclass


class incr_narrow_overlap_multiple_write_multiple_read_seq extends axi_base_seq;// Sequence ==> 09
	`uvm_object_utils(incr_narrow_overlap_multiple_write_multiple_read_seq)

	`UVM_OBJ

	task body();
		
	endtask

endclass

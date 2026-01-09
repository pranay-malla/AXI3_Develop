class axi_base_seq extends uvm_sequence#(axi_seq_item);
	`uvm_object_utils(axi_base_seq)

	`UVM_OBJ
	
endclass

class axi_incr_single_write_seq extends axi_base_seq;

	`uvm_object_utils(axi_incr_single_write_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 3; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      
	endtask

endclass

class axi_incr_multiple_write_seq extends axi_base_seq;

	`uvm_object_utils(axi_incr_multiple_write_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 3; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      		`uvm_do_with(req,{req.AWADDR == 32'd4; req.AWID == 4'h3; req.AWLEN == 4; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      		`uvm_do_with(req,{req.AWADDR == 32'd11; req.AWID == 4'h5; req.AWLEN == 5; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      
	endtask

endclass


class axi_incr_single_write_read_seq extends axi_base_seq;
	`uvm_object_utils(axi_incr_single_write_read_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 4; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      		`uvm_do_with(req,{req.ARADDR == 32'd2; req.ARID == 4'h1; req.ARLEN == 4; req.ARSIZE == 2; req.ARBURST == INCR ; req.TRANS_TYPE == READ_ONLY ;});
      
	endtask

endclass

class axi_incr_multiple_write_read_seq extends axi_base_seq;
	`uvm_object_utils(axi_incr_multiple_write_read_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 3; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      		`uvm_do_with(req,{req.AWADDR == 32'd30; req.AWID == 4'h5; req.AWLEN == 4; req.AWSIZE == 2; req.AWBURST == INCR ; req.TRANS_TYPE == WRITE_ONLY;});
      		`uvm_do_with(req,{req.ARADDR == 32'd2; req.ARID == 4'h1; req.ARLEN == 3; req.ARSIZE == 2; req.ARBURST == INCR ; req.TRANS_TYPE == READ_ONLY ;});
      		`uvm_do_with(req,{req.ARADDR == 32'd30; req.ARID == 4'h5; req.ARLEN == 4; req.ARSIZE == 2; req.ARBURST == INCR ; req.TRANS_TYPE == READ_ONLY ;});
      
	endtask

endclass


class axi_incr_multiple_write_then_read_seq extends axi_base_seq;
	`uvm_object_utils(axi_incr_multiple_write_then_read_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 3; req.AWSIZE == 2; req.AWBURST == INCR ; 
				  req.ARADDR == 32'd2; req.ARID == 4'h1; req.ARLEN == 3; req.ARSIZE == 2; req.ARBURST == INCR ;
				  req.TRANS_TYPE == WRITE_THEN_READ;});

      		`uvm_do_with(req,{req.AWADDR == 32'd30; req.AWID == 4'h5; req.AWLEN == 4; req.AWSIZE == 2; req.AWBURST == INCR ;
	       		          req.ARADDR == 32'd30; req.ARID == 4'h5; req.ARLEN == 4; req.ARSIZE == 2; req.ARBURST == INCR ;
			  	  req.TRANS_TYPE == WRITE_THEN_READ;});
       	endtask

endclass

class axi_incr_multiple_write_parallel_read_seq extends axi_base_seq;
	`uvm_object_utils(axi_incr_multiple_write_parallel_read_seq)

	`UVM_OBJ

	task body();
      		`uvm_do_with(req,{req.AWADDR == 32'd2; req.AWID == 4'h1; req.AWLEN == 3; req.AWSIZE == 2; req.AWBURST == INCR ; 
				 				  req.TRANS_TYPE == WRITE_ONLY;});

      		`uvm_do_with(req,{req.AWADDR == 32'd30; req.AWID == 4'h5; req.AWLEN == 4; req.AWSIZE == 2; req.AWBURST == INCR ;
				  req.ARADDR == 32'd02; req.ARID == 4'h1; req.ARLEN == 3; req.ARSIZE == 2; req.ARBURST == INCR ;
				  req.TRANS_TYPE == WRITE_PARALLEL_READ;});

	       	`uvm_do_with(req,{req.AWADDR == 32'd60; req.AWID == 4'h7; req.AWLEN == 6; req.AWSIZE == 2; req.AWBURST == INCR ; 
			          req.ARADDR == 32'd30; req.ARID == 4'h5; req.ARLEN == 4; req.ARSIZE == 2; req.ARBURST == INCR ;
			  	  req.TRANS_TYPE == WRITE_PARALLEL_READ;});


		`uvm_do_with(req,{req.ARADDR == 32'd60; req.ARID == 4'h7; req.ARLEN == 6; req.ARSIZE == 2; req.ARBURST == INCR ; 
				  req.TRANS_TYPE == READ_ONLY;});

       	endtask

endclass





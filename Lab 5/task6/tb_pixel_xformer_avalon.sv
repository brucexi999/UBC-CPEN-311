module tb_pixel_xformer_avalon();

	logic clk, reset_n, slave_write, waitrequest, master_write;
	logic [3:0] slave_address;
	logic [31:0] slave_writedata, master_address, master_writedata; 

	pixel_xformer_avalon dut (
	.clk (clk),
	.reset_n (reset_n),
	.slave_address (slave_address),
	.slave_write (slave_write),
	.slave_writedata (slave_writedata),
	.waitrequest (waitrequest),
	.master_address (master_address),
	.master_write (master_write),
	.master_writedata (master_writedata)
	); 
	
	initial begin
		clk = 0;
		forever begin
			#5; clk = ~clk; 
		end
	end
	
	initial begin
		reset_n = 0; #5;
		reset_n = 1; #5;
		waitrequest = 1; 
		slave_write = 1; slave_address = 1; slave_writedata = 46334; #5;
		slave_write = 1; slave_address = 2; slave_writedata = 32'b11111111111111110100101100000010; #5;
		slave_write = 1; slave_address = 3; slave_writedata = 4318822; #5;
		slave_write = 1; slave_address = 4; slave_writedata = 46334; #5;
		slave_write = 1; slave_address = 5; slave_writedata = 46334; #5;
		slave_write = 1; slave_address = 6; slave_writedata = 32'b11111111110110010000000000000000; #5;
		slave_write = 1; slave_address = 0; slave_writedata = {13'b0, 3'b111, 8'b01010011, 1'b0, 7'b0000001}; #50;
		waitrequest = 0; #20; 
		waitrequest = 1; #50; 
		waitrequest = 0; #20;
		$stop;
	end
	
endmodule: tb_pixel_xformer_avalon

module tb_counter();

	logic clk, reset_n, read;
	logic [3:0] address; 
	logic [31:0] readdata;
	
	counter dut (
	.clk (clk),
	.reset_n (reset_n),
	.address (address),
	.read (read),
	.readdata (readdata)
	);
	
	initial begin
		clk = 1;
		forever #5 clk = ~clk;
	end
	
	initial begin
		reset_n = 0; #5;
		reset_n = 1; #5; 
		#10;
		read = 1; address = 4'b0; 
		#20;
		read = 0; 
		#20;
		read = 1; address = 4'b0100;
		#20
		$stop;
	end
	
endmodule: tb_counter

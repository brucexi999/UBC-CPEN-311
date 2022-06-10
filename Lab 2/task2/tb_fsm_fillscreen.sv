module tb_fsm_fillscreen ();

`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

reg err;
reg clk;
reg rst_n;
reg x_done;
reg y_done;
reg start;
wire x_load;
wire y_load;
wire x_count;
wire y_count;
wire done;

fsm_fillscreen DUT (
.clk (clk),
.rst_n (rst_n),
.x_done (x_done),
.y_done (y_done),
.start (start),
.x_load (x_load),
.y_load (y_load),
.x_count (x_count),
.y_count (y_count),
.done (done)
);

task check;
	input [1:0] expected_state;
	input expected_x_load;
	input expected_y_load;
	input expected_x_count;
	input expected_y_count;
	input expected_done;

begin
	if (tb_fsm_fillscreen.DUT.present_state !== expected_state) begin
		$display ("ERROR, state is %b, expected %b", tb_fsm_fillscreen.DUT.present_state, expected_state);
		err = 1'b1;
	end
	
	if (x_load !== expected_x_load) begin
		$display ("ERROR, x_load is %b, expected %b", x_load, expected_x_load);
		err = 1'b1;
	end

	if (y_load !== expected_y_load) begin
		$display ("ERROR, y_load is %b, expected %b", y_load, expected_y_load);
		err = 1'b1;
	end
	
	if (x_count !== expected_x_count) begin
		$display ("ERROR, x_count is %b, expected %b", x_count, expected_x_count);
		err = 1'b1;
	end
	
	if (y_count !== expected_y_count) begin
		$display ("ERROR, y_count is %b, expected %b", y_count, expected_y_count);
		err = 1'b1;
	end
	
	if (done !== expected_done) begin
		$display ("ERROR, done is %b, expected %b", done, expected_done);
		err = 1'b1;
	end
end
endtask


initial begin
	clk = 0; #5;
	forever begin
		clk = 1; #5;
		clk = 0; #5;
	end
end

initial begin
	rst_n = 0; x_done = 0; y_done = 0; start = 0; #10;
	
	$display("checking S0");
	check(`S0, 0,0,0,0,0);
	rst_n = 1; 
	
	$display("checking S0->S0");
	#10;
	check(`S0, 1,1,0,0,0);
	
	$display("checking S0->S2");
	start = 1; #10;
	check(`S2, 0,0,0,1,0);
	
	$display("checking S2->S2");
	#10;
	check(`S2, 0,0,0,1,0);
	
	$display("checking S2->S1");
	y_done = 1; x_done = 0; #10;
	check(`S1, 0,1,1,0,0);
	
	$display("checking S1->S2");
	y_done = 0; #10;
	check(`S2, 0,0,0,1,0);
	
	$display("checking S2->S3");
	y_done = 1; x_done = 1; #10;
	check(`S3, 0,0,0,0,1);
	
	$stop;
end
endmodule 
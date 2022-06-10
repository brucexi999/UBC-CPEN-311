`timescale 1ns/1ns

module tb_task5();

reg  sim_CLOCK_50;
reg [3:0] sim_KEY;

wire [9:0] sim_LEDR;
wire [6:0] sim_HEX0;
wire [6:0] sim_HEX1;
wire [6:0] sim_HEX2;
wire [6:0] sim_HEX3;
wire [6:0] sim_HEX4;
wire [6:0] sim_HEX5;

task5 DUT (
.CLOCK_50 (sim_CLOCK_50),
.KEY (sim_KEY),
.LEDR (sim_LEDR),
.HEX0 (sim_HEX0),
.HEX1 (sim_HEX1),
.HEX2 (sim_HEX2),
.HEX3 (sim_HEX3),
.HEX4 (sim_HEX4),
.HEX5 (sim_HEX5)
);

initial begin
	sim_CLOCK_50 = 0; #5;
	forever begin
		sim_CLOCK_50 = 1; #5;
		sim_CLOCK_50 = 0; #5;
	end
end

initial begin
	sim_KEY[0] = 0; #10;
	forever begin
		sim_KEY[0] = 1; #10;
		sim_KEY[0] = 0; #10;
	end
end

initial begin 
	sim_KEY[3] = 1; #10;
	sim_KEY[3] = 0; #10;
	sim_KEY[3] = 1; #500;
	
	$stop;
end 
						
endmodule


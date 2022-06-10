`timescale 1ps / 1ps

module tb_rtl_task2();

logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;
task2 DUT (
.CLOCK_50 (CLOCK_50),
.KEY (KEY),
.SW (SW)
);

initial begin
	CLOCK_50 = 0; #5;
	forever begin
		CLOCK_50 = 1; #5;
		CLOCK_50 = 0; #5;
	end
end

initial begin
KEY[3] = 1; #5;
KEY[3] = 0; #10;
KEY[3] = 1; SW = 10'b1100111100; #36000;

$stop;
end
endmodule: tb_rtl_task2

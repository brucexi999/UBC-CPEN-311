`timescale 1ps / 1ps

module tb_sound ();

logic CLOCK_50, CLOCK2_50;
logic [3:0] KEY;

sound DUT(
.CLOCK_50 (CLOCK_50),
.CLOCK2_50 (CLOCK2_50),
.KEY (KEY)
); 

initial begin
CLOCK_50 = 0; #5;
	forever begin
	CLOCK_50 = 1; #5;
	CLOCK_50 = 0; #5;
	end
end

initial begin
CLOCK2_50 = 0; #5;
	forever begin
	CLOCK2_50 = 1; #5;
	CLOCK2_50 = 0; #5;
	end
end

initial begin
KEY[3] = 0; #15;
KEY[3] = 1; #5000000;
$stop;
end

endmodule
`timescale 1ps / 1ps

module tb_rtl_task3();

logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;

task3 DUT (
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
$readmemh("test2.memh", DUT.CT.altsyncram_component.m_default.altsyncram_inst.mem_data);
KEY[3] = 1; #5;
KEY[3] = 0; #10;
KEY[3] = 1; SW = 10'b0000011000; #50000;

$stop;
end

endmodule: tb_rtl_task3

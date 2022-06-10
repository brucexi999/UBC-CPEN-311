`timescale 1 ps / 1 ps

module tb_syn_task1();
logic CLOCK_50;
logic [3:0] KEY;

task1 DUT (
.CLOCK_50 (CLOCK_50),
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
KEY[3] = 1; #5;
KEY[3] = 0; #10;
KEY[3] = 1; #2600;
//$display (tb_rtl_task1.DUT.s.altsyncram_component.m_default.altsyncram_inst.mem_data);

$stop;
end

endmodule: tb_syn_task1

`timescale 1ps / 1ps
module tb_pixel_xform_system();
    logic clk, rst_n;
	logic [7:0] vga_b, vga_g, vga_r; 
	logic vga_clk, vga_hs, vga_vs; 
    initial begin
        clk <= 1'b1;
        forever #5 clk <= ~clk;
    end

    initial begin
        //$monitor("[%d] LEDS: %08b", $time, leds);
        rst_n <= 1'b0;
        #5;
        //switches <= 0;
        //#20;
        rst_n <= 1'b1;
        #50000;
        $stop;
    end

    pixel_xform_system dut(
	.clk_clk(clk), 
	.resetn_reset_n(rst_n), 
	.vga_b (vga_b),
	.vga_clk (vga_clk),
	.vga_g (vga_g),
	.vga_hs (vga_hs),
	.vga_r (vga_r),
	.vga_vs (vga_vs)
	);

endmodule: tb_pixel_xform_system

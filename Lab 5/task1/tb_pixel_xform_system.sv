`timescale 1ps / 1ps
module tb_pixel_xform_system();
    logic clk, rst_n;
    logic [7:0] switches;
    logic [7:0] leds;

    initial begin
        clk <= 1'b1;
        forever #5 clk <= ~clk;
    end

    initial begin
        $monitor("[%d] LEDS: %08b", $time, leds);
        rst_n <= 1'b0;
        #5;
        switches <= 0;
        #20;
        rst_n <= 1'b1;
        #100000;
        $stop;
    end

    pixel_xform_system dut(.clk_clk(clk), .resetn_reset_n(rst_n), .switches_export(switches), .leds_export(leds));

endmodule: tb_pixel_xform_system

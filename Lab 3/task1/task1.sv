`timescale 1ps / 1ps


module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

	logic en, rdy, wren, done;
	logic [7:0] addr, wrdata, q; 


    init INIT (
	.clk (CLOCK_50),
	.rst_n (KEY[3]),
	.en (en),
	.rdy (rdy),
	.addr (addr),
	.wrdata (wrdata),
	.wren (wren)
	);

    s_mem s(
	.address (addr),
	.clock (CLOCK_50),
	.data (wrdata),
	.wren (wren),
	.q (q)
	);

	always@(posedge CLOCK_50 or negedge KEY[3]) begin 
		if (~KEY[3]) begin
			done <= 0;
			en <= 0;
		end
		else if (rdy && ~done) begin //Only initialize the S array once. That's the function of the done signal. 
			en <= 1;
			done <= 1;
		end
		else if (done) begin 
			en <= 0;
		end
	end

endmodule: task1

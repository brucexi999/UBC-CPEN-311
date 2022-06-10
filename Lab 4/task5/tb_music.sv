`timescale 1ps / 1ps

module tb_music();

logic CLOCK_50, CLOCK2_50;
logic [3:0] KEY;

music DUT (
.CLOCK_50 (CLOCK_50),
.CLOCK2_50 (CLOCK2_50),
.KEY (KEY)
);

initial begin
CLOCK_50 = 0; #0.5;
	forever begin
	CLOCK_50 = 1; #0.5;
	CLOCK_50 = 0; #0.5;
	end
end

initial begin
CLOCK2_50 = 0; #0.5;
	forever begin
	CLOCK2_50 = 1; #0.5;
	CLOCK2_50 = 0; #0.5;
	end
end

initial begin
KEY[3] = 0; #15;
KEY[3] = 1; #50000;
$stop;
end

endmodule: tb_music

module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);

logic present_state, next_state;
reg [31:0] mem [22:0]; 


`define S0 1'b0
`define S1 1'b1

always @ (posedge clk_clk or negedge reset_reset_n) begin
	if (~reset_reset_n) begin
		present_state = `S0;
		next_state = `S0;
		flash_mem_waitrequest = 0;
		flash_mem_readdatavalid = 0;
	    flash_mem_readdata = 32'bz;
	end

	else begin
		
		case (present_state)
		`S0: if (flash_mem_read)
				next_state = `S1;
			 else
				next_state = `S0;
		`S1: if (~flash_mem_read)
				next_state = `S0;
			 else 
				next_state = `S1;
		endcase
		
		present_state = next_state;
		
		case (present_state)
		`S0: begin
			 flash_mem_waitrequest = 1;
			 flash_mem_readdatavalid = 0;
			 flash_mem_readdata = 32'bz;
			 end
		
		`S1: begin
			 flash_mem_waitrequest = 0;
			 flash_mem_readdatavalid = 1;
			 flash_mem_readdata = mem [flash_mem_address]; 
			 end
			 
		endcase 
	
	end
	
end

assign mem [0] = 'he364c6c8;
assign mem [1] = 'hc545c3c3;
assign mem [2] = 'hc704ca46;

endmodule: flash


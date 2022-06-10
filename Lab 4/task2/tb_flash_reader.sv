`timescale 1ps / 1ps

module tb_flash_reader();

logic CLOCK_50;
logic [3:0] KEY;
flash_reader DUT (
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
KEY[3] = 0; #15;
KEY[3] = 1; #50000;
$stop;
end

endmodule: tb_flash_reader

module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);

logic present_state, next_state;
integer i;
reg [31:0] mem [22:0]; 


`define S0 1'b0
`define S1 1'b1

always @ (posedge clk_clk or negedge reset_reset_n) begin
	if (~reset_reset_n) begin
		present_state = `S0;
		next_state = `S0;
		flash_mem_waitrequest = 1;
		flash_mem_readdatavalid = 0;
	    flash_mem_readdata = 32'bz;
	end

	else begin
		i = 0;
		
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
			 flash_mem_waitrequest = 0;
			 flash_mem_readdatavalid = 0;
			 flash_mem_readdata = 32'bz;
			 end
		
		`S1: begin
			 flash_mem_waitrequest = 1;
			 flash_mem_readdatavalid = 1;
			 flash_mem_readdata = mem [flash_mem_address]; 
			 end
			 
		endcase 
	
	end
	
end
endmodule: flash

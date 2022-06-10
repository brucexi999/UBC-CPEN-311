`timescale 1ps / 1ps

module flash_reader(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
                    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
                    output logic [9:0] LEDR);

// You may use the SW/HEX/LEDR ports for debugging. DO NOT delete or rename any ports or signals.

logic clk, rst_n;

assign clk = CLOCK_50;
assign rst_n = KEY[3];

logic flash_mem_read, flash_mem_waitrequest, flash_mem_readdatavalid;
logic [22:0] flash_mem_address;
logic [31:0] flash_mem_readdata;
logic [3:0] flash_mem_byteenable;

logic [8:0] s_address, address, new_address, ram_addr, new_ram_addr;
logic [15:0] wrdata;
logic [31:0] transmem;
logic wren, en_transmem, en_address, en_ram_addr;
integer present_state, next_state;

flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

s_mem samples(
.address (s_address[7:0]),
.clock (clk),
.data (wrdata),
.wren (wren),
.q ()
);

assign flash_mem_byteenable = 4'b1111;

//Flash address counter-------------------------
always_ff @ (posedge clk or negedge rst_n) begin
if (~rst_n)
	address <= 0;
else if (en_address)
	address <= new_address;
end

always_comb begin
new_address = address + 1;
end
//----------------------------------------

//RAM address counter-------------------------
always_ff @ (posedge clk or negedge rst_n) begin
if (~rst_n)
	ram_addr <= 0;
else if (en_ram_addr)
	ram_addr <= new_ram_addr;
end

always_comb begin
new_ram_addr = ram_addr + 1;
end
//----------------------------------------

//Transient memory------------------------
always_ff @ (posedge clk or negedge rst_n) begin
if (~rst_n)
	transmem <= 0;
else if (en_transmem)
	transmem <= flash_mem_readdata;
end
//----------------------------------------

//The state machine-----------------------
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define SD 4'b0111
`define SDD 4'b1000

always @ (posedge clk or negedge rst_n) begin
if (~rst_n) begin
	present_state = `S0;
	next_state = `S0;
	end
	
else begin
		case (present_state)
		`S0: if (~flash_mem_waitrequest)
				next_state = `S1;
			 else 
				next_state = `S0;
		`S1: if (flash_mem_readdatavalid)
				next_state = `S2;
			 else
				next_state = `S1;
		`S2: next_state = `SD;
		`SD: next_state = `S3;
		`S3: next_state = `SDD;
		`SDD: next_state = `S6;
		`S6: next_state = `S4;
		`S4: next_state = `S5;
		`S5: if (address <= 127)
				next_state = `S1;
			 else 
				next_state = `S5; 
		endcase
		
		present_state = next_state; 
		
		case (present_state)
		`S0: begin
			 flash_mem_read = 0;
			 flash_mem_address =  23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 0;
			 end
			 
		`S1: begin
			 flash_mem_read = 1;
			 flash_mem_address = address;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz; 
			 en_transmem = 0;
			 end
			 
		`S2: begin
			 flash_mem_read = 1;
			 flash_mem_address = address;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 1;
			 end
			 
		`SD: begin
			 flash_mem_read = 0;
			 flash_mem_address =  23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 0;
			 end
			 
		`S3: begin
			 flash_mem_read = 0;
			 flash_mem_address = 23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 1;
			 s_address = ram_addr;
			 wren = 1;
			 wrdata = transmem[15:0];
			 en_transmem = 0;
			 end
			 
		`SDD: begin
			 flash_mem_read = 0;
			 flash_mem_address =  23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 0;
			 end	
			 
		`S6: begin
			 flash_mem_read = 0;
			 flash_mem_address = 23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = ram_addr;
			 wren = 1;
			 wrdata = transmem[31:16];
			 en_transmem = 0;
			 end
			 
		`S4: begin
			 flash_mem_read = 0;
			 flash_mem_address =  23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 1;
			 en_ram_addr = 1; 
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 0;
			 end
		
		`S5: begin
			 flash_mem_read = 0;
			 flash_mem_address =  23'bzzzzzzzzzzzzzzzzzzzzzzz;
			 en_address = 0;
			 en_ram_addr = 0;
			 s_address = 9'bzzzzzzzzz;
			 wren = 0;
			 wrdata = 16'bz;
			 en_transmem = 0;
			 end
		
		endcase
	
	end

end
//----------------------------------------

endmodule: flash_reader
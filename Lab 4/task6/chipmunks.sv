module chipmunks(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
                 input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT,
                 inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
                 output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
                 output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
                 output [9:0] LEDR);
			
// signals that are used to communicate with the audio core
// DO NOT alter these -- we will use them to test your design

reg read_ready, write_ready, write_s;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

// signals that are used to communicate with the flash core
// DO NOT alter these -- we will use them to test your design

reg flash_mem_read;
reg flash_mem_waitrequest;
reg [22:0] flash_mem_address;
reg [31:0] flash_mem_readdata;
reg flash_mem_readdatavalid;
reg [3:0] flash_mem_byteenable;
reg rst_n, clk;

// DO NOT alter the instance names or port names below -- we will use them to test your design

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);
flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

assign reset = ~(KEY[3]);
assign read_s = 1'b0;
assign rst_n = KEY[3];
assign clk = CLOCK_50;
assign flash_mem_byteenable = 4'b1111;

//Some signals used in the state machine
integer addr_cnt; // address counter 
logic signed [15:0] trans_mem_1; //transient memory = flash_mem_readdata[15:0]
logic signed [15:0] trans_mem_2; //transient memory = flash_mem_readdata[31:16]
logic first_half_done, second_half_done, second_write_done; //goes high depending on which half of the transient memory has been sent to codec. 
//logic en_trans_mem; //enable signal of the transient memory. 
//logic en_addr_cnt //enable signal of the address counter.
//------------------------------------ 

//The state machine including all 3 modes-------------------
typedef enum {
state_init,
state_read,
state_load_trans_mem,
state_wait_until_ready,
state_write_first_half,
state_wait_for_accepted,
state_wait_second_ready,
state_write_second_half,
state_upadte_addr_cnt1,
state_upadte_addr_cnt2,
state_wait_flash,
state_wait_second_write
} state_type;

state_type state;

always_ff @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state <= state_init;
		write_s <= 0;
		addr_cnt <= 0;
		//en_trans_mem <=0;
		first_half_done <= 0;
		second_half_done <= 0;
		second_write_done <= 0;
		flash_mem_read <= 0;
	end
	
	else begin
		case (state)
			state_init: begin
				write_s <= 0;
				addr_cnt <= 0;
				//en_trans_mem <=0;
				first_half_done <= 0;
				second_half_done <= 0;
				second_write_done <= 0;
				flash_mem_read <= 0;
				if (~flash_mem_waitrequest)
					state <= state_read;
				else 
					state <= state_init;
				end
			
			state_read: begin
				flash_mem_read <= 1;
				flash_mem_address <= addr_cnt;
				if (flash_mem_readdatavalid)
					state <= state_load_trans_mem;
				else 
					state <= state_read; 
				end
			
			state_load_trans_mem: begin
				trans_mem_1 <= flash_mem_readdata[15:0];
				trans_mem_2 <= flash_mem_readdata[31:16];
				state <= state_wait_until_ready;
				end
				
			state_wait_until_ready: begin
				first_half_done <= 0;
				second_half_done <= 0;
				if (write_ready)
					state <= state_write_first_half;
				else 
					state <= state_wait_until_ready;
				end
			
			state_write_first_half: begin
				write_s <= 1;
				writedata_left <= trans_mem_1 / 64;
				writedata_right <= trans_mem_1 / 64;
				first_half_done <= 1;
				state <= state_wait_for_accepted;
				end
			
			state_wait_for_accepted: begin
				if (~write_ready && first_half_done && ~second_half_done)
					state <= state_wait_second_ready;
				else if (~write_ready && first_half_done && second_half_done) begin
					if (SW[1:0] == 2'b00) begin
						state <= state_upadte_addr_cnt1;
						end
					else if (SW[1:0] == 2'b01) begin
						state <= state_upadte_addr_cnt2;
						end
					else if (SW[1:0] == 2'b10 && ~second_write_done) begin
						state <= state_wait_second_write;
						end
					else if (SW[1:0] == 2'b10 && second_write_done) begin
						state <= state_upadte_addr_cnt1;
						end
					end
				end
			
			state_wait_second_ready: begin
				write_s <= 0; 
				if (write_ready)
					state <= state_write_second_half;
				end
				
			state_write_second_half: begin
				write_s <=1;
				writedata_left <= trans_mem_2 / 64;
				writedata_right <= trans_mem_2 / 64;
				second_half_done <= 1;
				state <= state_wait_for_accepted;
				end
				
			state_upadte_addr_cnt1: begin
				write_s <=0; 
				addr_cnt <= addr_cnt + 1;
				if (addr_cnt == 1048576)
					addr_cnt <= 0;
				state <= state_wait_flash;
				end
			
			state_upadte_addr_cnt2: begin
				write_s <=0; 
				addr_cnt <= addr_cnt + 2;
				if (addr_cnt == 1048576)
					addr_cnt <= 0;
				state <= state_wait_flash;
				end
			
			state_wait_second_write: begin
				write_s <= 0;
				second_write_done <= 1;
				first_half_done <= 0;
				second_half_done <= 0;
				if (write_ready)
					state <= state_write_first_half;
				end
			
			state_wait_flash: begin
				second_write_done <= 0;
				if (~flash_mem_waitrequest)
					state <= state_read;
				end
			
			default: 
				state <= state_init;
			
			
		endcase
	end
end
//------------------------------------

endmodule: chipmunks

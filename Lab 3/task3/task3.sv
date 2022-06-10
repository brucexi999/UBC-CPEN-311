`timescale 1ps / 1ps

module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    logic en, rdy, pt_wren;
	logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata;

    ct_mem CT(
	.address (ct_addr),
	.clock (CLOCK_50),
	.q (ct_rddata)
	);
	
    pt_mem PT(
	.address (pt_addr),
	.clock (CLOCK_50),
	.data (pt_wrdata),
	.wren (pt_wren),
	.q (pt_rddata)
	);
	
    arc4 ARC4(
	.clk (CLOCK_50),
	.rst_n (KEY[3]),
	.en (en),
	.rdy (rdy),
	.key ({14'b00000000000000, SW}),
	.ct_addr (ct_addr),
	.ct_rddata (ct_rddata),
	.pt_addr (pt_addr),
	.pt_rddata (pt_rddata),
	.pt_wrdata (pt_wrdata),
	.pt_wren (pt_wren)
	);

    //Control unit of rdy and en-----------
	typedef enum {
	state_initial,
	state_en,
	state_wait_done
	} state_type;
	
	state_type state; 
	
	always_ff @ (posedge CLOCK_50 or negedge KEY[3] ) begin
		if (~KEY[3]) begin
			state <= state_initial;
			en <= 0;
		end
		
		else begin
			case (state) 
				state_initial:
				begin
					en <= 0;
					state <= state_en;
				end
				
				state_en:
				begin
					en <= 1;
					state <= state_wait_done;
				end
				
				state_wait_done:
				begin
					en <= 0; 
				end
				
			endcase
		end
	end
	
endmodule: task3

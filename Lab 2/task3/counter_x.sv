module counter_x 
(
input logic clk,
input logic rst_n,
input logic load,
input logic count,
output logic done,
output logic [7:0] Q
);

logic [7:0] D;
logic [7:0] init;
assign init = 0;

always_ff @ (posedge clk, negedge rst_n) begin
	if (rst_n == 0)
		Q <= 0;
	else if (load == 1)
		Q <= init;
	else if (count == 1)
		Q <= D; 
end 

always_comb begin
if (Q < 159)
	D = Q + 1;
else
	D = Q;
end 

always_comb begin
if (Q == 159)
	done = 1;
else done = 0;
end 

endmodule
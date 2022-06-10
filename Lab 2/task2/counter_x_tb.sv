module counter_x_tb ();
logic [7:0] init;
logic clk;
logic rst_n;
logic load;
logic count;
logic done;
logic [7:0] Q;

counter_x DUT (
.clk (clk),
.rst_n (rst_n),
.load (load),
.count (count),
.done (done),
.Q (Q)
);

initial begin
	clk = 0; #5;
	forever begin
		clk = 1; #5;
		clk = 0; #5;
	end
end

initial begin
rst_n = 0; #15;
rst_n = 1;
load = 1; #10;
load = 0;
count = 1; #200;
load = 1; #20;
$stop;

end


endmodule
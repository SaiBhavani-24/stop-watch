module clockdivider(
		input CLK_50_MHz,
		input reset_n,
		output reg CLK_100Hz = 0,
		output reg  tick_100Hz   // 1-cycle pulse every 10 ms
);
   localparam integer HALF = 250_000 - 1;  // 50e6 / (2*100)
	reg [17:0] count_reg = 0;
	always @(posedge CLK_50_MHz) begin
	if (!reset_n)begin
		count_reg  <= 18'b0;
		CLK_100Hz <= 1'b0;
		tick_100Hz <= 1'b0;
	end else begin
		tick_100Hz <= 1'b0;          // default each cycle
		if(count_reg < 249999) begin
			count_reg <= count_reg + 18'b1;
		end else begin 
			count_reg <= 18'd0;
			CLK_100Hz <= ~CLK_100Hz;
			tick_100Hz <= 1'b1;      // single pulse @ 100 Hz
		end
	end
end
endmodule	

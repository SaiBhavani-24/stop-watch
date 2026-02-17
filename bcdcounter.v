module bcd_counter (
    input  wire       clk_en_pulse, // one pulse per increment (your ms_clk / tenths_in / ones_in)
    input  wire       reset_n,      // active-low reset (KEY[1])
    output reg  [3:0] bcd,          // BCD digit 0..9
    output reg        carry         // 1-pulse strobe on wrap
);
    always @(posedge clk_en_pulse or negedge reset_n) begin
        if (!reset_n) begin
            bcd   <= 4'd0;
            carry <= 1'b0;
        end else begin
            if (bcd == 4'd9) begin
                bcd   <= 4'd0;
                carry <= 1'b1;      // pulse once when 9 -> 0
            end else begin
                bcd   <= bcd + 4'd1;
                carry <= 1'b0;      // keep it low otherwise (no extra driver elsewhere)
            end
        end
    end
endmodule

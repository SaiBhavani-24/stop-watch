module seven_segment_decoder(
    input  [3:0] bcd,
    output reg [0:6] HEX   // ONLY 7 bits, a..g
);

    always @* begin
        case (bcd)
            4'd0: HEX = 7'b0000001;
            4'd1: HEX = 7'b1001111;
            4'd2: HEX = 7'b0010010;
            4'd3: HEX = 7'b0000110;
            4'd4: HEX = 7'b1001100;
            4'd5: HEX = 7'b0100100;
            4'd6: HEX = 7'b0100000;
            4'd7: HEX = 7'b0001111;
            4'd8: HEX = 7'b0000000;
            4'd9: HEX = 7'b0001100;
            default: HEX = 7'b1111111; // blank
        endcase
    end

endmodule

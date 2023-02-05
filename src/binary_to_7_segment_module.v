//File Title: Binary to 7 Segment
//GOWIN Version: 1.9.8.01

module bin_to_7_seg(
    input clk,
    input rstn,
    
    input [3:0] bin,
    
    output reg [6:0] out
    );

//Binary to 7 segment - out
//------------------------------------------------------------------------------------------------------------------------------//
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            out[0] <= 0;
            out[1] <= 0;
            out[2] <= 0;
            out[3] <= 0;
            out[4] <= 0;
            out[5] <= 0;
            out[6] <= 1;
        end
        else begin
            case(bin)
                4'b0000://0
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 1;
                    end
                4'b0001://1
                    begin
                        out[0] <= 1;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 1;
                    end
                4'b0010://2
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 1;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 1;
                        out[6] <= 0;
                    end
                4'b0011://3
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 0;
                    end
                4'b0100://4
                    begin
                        out[0] <= 1;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0101://5
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 1;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0110://6
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0111://7
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 1;
                    end
                4'b1000://8
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1001://9
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1010://A
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1011://b
                    begin
                        out[0] <= 1;
                        out[1] <= 1;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1100://C
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 1;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 1;
                    end
                4'b1101://d
                    begin
                        out[0] <= 1;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 1;
                        out[6] <= 0;
                    end
                4'b1110://E
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 1;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1111://F
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 1;
                        out[3] <= 1;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                default:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 1;
                    end
            endcase
        end
    end
//------------------------------------------------------------------------------------------------------------------------------//
endmodule
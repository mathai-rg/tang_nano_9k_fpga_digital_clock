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
                4'b0000:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 1;
                    end
                4'b0001:
                    begin
                        out[0] <= 1;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 1;
                    end
                4'b0010:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 1;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 1;
                        out[6] <= 0;
                    end
                4'b0011:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 0;
                    end
                4'b0100:
                    begin
                        out[0] <= 1;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0101:
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 1;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0110:
                    begin
                        out[0] <= 0;
                        out[1] <= 1;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b0111:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
                        out[5] <= 1;
                        out[6] <= 1;
                    end
                4'b1000:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 0;
                        out[4] <= 0;
                        out[5] <= 0;
                        out[6] <= 0;
                    end
                4'b1001:
                    begin
                        out[0] <= 0;
                        out[1] <= 0;
                        out[2] <= 0;
                        out[3] <= 1;
                        out[4] <= 1;
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
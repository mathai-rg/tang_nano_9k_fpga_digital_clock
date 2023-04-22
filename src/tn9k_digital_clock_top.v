//File Title: Digital Design - Digital Clock
//GOWIN Version: 1.9.8.01
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9C


//module defenition
module digital_clock(
    input reset_n,              //reset_n in
    input sys_clk,              //clk input
    input mode,                 //mode pin
    input set,                  //set pin

    output reg SA,              //7 segment pin A
    output reg SB,              //7 segment pin B
    output reg SC,              //7 segment pin C
    output reg SD,              //7 segment pin D
    output reg SE,              //7 segment pin E
    output reg SF,              //7 segment pin F
    output reg SG,              //7 segment pin G

    output S0,              //select segment 0
    output S1,              //select segment 1
    output S2,              //select segment 2
    output S3               //select segment 3
);




//mode counter
reg [1:0] mod_pos;
always @ (negedge mode or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        mod_pos <= 2'b00;
    end
    else begin
        if(mod_pos == 2'b10) begin
            mod_pos <= 2'b00;
        end
        else begin
            mod_pos <= mod_pos + 2'b01;
        end
    end
end


//clock mode FSM
localparam MODE_CLOCK = 2'b00, MODE_MIN = 2'b01, MODE_HR = 2'b10;
reg [1:0] state;

always @(posedge sys_clk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        state <= MODE_CLOCK;
    end
    else begin
        case(mod_pos)
            MODE_CLOCK: begin
                state <= MODE_CLOCK;
            end
            MODE_MIN: begin
                state <= MODE_MIN;
            end
            MODE_HR: begin
                state <= MODE_HR;
            end
            default: begin
                state <= MODE_CLOCK;
            end
        endcase
    end
end


//set input handling
wire set_min, set_hr;

assign set_min = ((state == MODE_MIN)? set: 0);
assign set_hr = ((state == MODE_HR)? set:0);


//27MHz clock divider to 1000Hz
reg [15:0] clk_div_27K;
reg clk_reg_1K;
localparam DIV_27K = 16'd2; //16'd13499 for 1KHz output clock
wire clk_1K;

always @(posedge sys_clk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        clk_div_27K <= 16'b0;
        clk_reg_1K <= 1'b0;
    end
    else if(clk_div_27K == DIV_27K) begin
        clk_div_27K <= 16'b0;
        clk_reg_1K <= clk_reg_1K + 1'b1;
    end
    else begin
        clk_div_27K <= clk_div_27K + 1'b1;
    end
end

assign clk_1K = clk_reg_1K;


//segment selector
reg [3:0] segment;
localparam SEG0 = 2'b00, SEG1 = 2'b01, SEG2 = 2'b10, SEG3 = 2'b11;

always @(posedge clk_1K or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        segment <= 4'b0001;
    end
    else begin
        segment <= {segment[2:0],segment[3]};
    end
end

assign S0 = segment[0];
assign S1 = segment[1];
assign S2 = segment[2];
assign S3 = segment[3];


//

endmodule
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

assign set_min = ((state == MODE_MIN)? set: 1);
assign set_hr = ((state == MODE_HR)? set: 1);


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


//27MHz clock divider to 1Hz
reg [23:0] clk_div_27M;
reg clk_reg_1H;
localparam DIV_27M = 24'd9; //24'd‭13499999 for 1Hz output clock
wire clk_1H;

always @(posedge sys_clk or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        clk_div_27M <= 24'b0;
        clk_reg_1H <= 1'b0;
    end
    else if(clk_div_27M == DIV_27M) begin
        clk_div_27M <= 24'b0;
        clk_reg_1H <= clk_reg_1H + 1'b1;
    end
    else begin
        clk_div_27M <= clk_div_27M + 1'b1;
    end
end

assign clk_1H = clk_reg_1H;


//seconds counter
reg [6:0] sec_count;
reg min_tick_reg;
wire min_tick_out;
localparam SEC_MOD = 7'd9; //7'd59 for 1 tick every 60 seconds

always @(posedge clk_1H or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        sec_count <= 7'b0;
        min_tick_reg <= 1'b0;
    end
    else if(sec_count == SEC_MOD) begin
        sec_count <= 7'b0;
        min_tick_reg <= 1'b1;
    end
    else begin
        sec_count <= sec_count + 1'b1;
        min_tick_reg <= 1'b0;
    end
end

assign min_tick_out = min_tick_reg;


//minutes counter
reg [6:0] min_count;
reg hr_tick_reg;
wire hr_tick_out;
localparam MIN_MOD = 7'd9; //7'd59 for tick every 60 minutes
wire min_tick;

assign min_tick = (min_tick_out ^ set_min);

always @(posedge min_tick or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        min_count <= 7'b0;
        hr_tick_reg <= 1'b0;
    end
    else if(min_count == MIN_MOD) begin
        min_count <= 7'b0;
        hr_tick_reg <= 1'b1;
    end
    else begin
        min_count <= min_count + 1'b1;
        hr_tick_reg <= 1'b0;
    end
end

assign hr_tick_out = hr_tick_reg;


//hours counter
reg [5:0] hr_count;
localparam HR_MOD = 6'd23; //6'd23 for mod 24 counter
wire hr_tick;

assign hr_tick = (hr_tick_out ^ set_hr);

always @(posedge hr_tick or negedge reset_n) begin
    if(reset_n == 1'b0) begin
        hr_count <= 7'b0;
    end
    else if(hr_count == HR_MOD) begin
        hr_count <= 7'b0;
    end
    else begin
        hr_count <= hr_count + 1'b1;
    end
end



endmodule
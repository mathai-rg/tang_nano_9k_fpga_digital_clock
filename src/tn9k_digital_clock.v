//File Title: Digital Design - Digital Clock
//GOWIN Version: 1.9.8.01
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9C


//module defenition
module digital_clock(
    input sys_clk,              //clk input
    input sys_rst_n,            //system reset

    output reg SA,              //7 segment pin A
    output reg SB,              //7 segment pin B
    output reg SC,              //7 segment pin C
    output reg SD,              //7 segment pin D
    output reg SE,              //7 segment pin E
    output reg SF,              //7 segment pin F
    output reg SG,              //7 segment pin G

    output reg S0,              //select segment 0
    output reg S1,              //select segment 1
    output reg S2,              //select segment 2
    output reg S3               //select segment 3
);



//------------------------------------------------------------------------------------------------------------------------------//
reg [25:0] seconds_tick;        //counter for 1Hz clock source                                                                  //
                                                                                                                                //
reg [3:0]  seconds_0;           //counts seconds unit place                                                                     //

`ifdef SECONDS_DIS
wire [6:0]  sec_0_b27;                                                                                                          //
`endif

reg [3:0]  seconds_1;                                                                                                           //

`ifdef SECONDS_DIS
wire [6:0]  sec_1_b27;           //counts seconds tens place                                                                    //
`endif

                                                                                                                                //
reg [3:0]  minutes_0;                                                                                                           //
wire [6:0]  min_0_b27;           //counts minutes unit place                                                                    //
reg [3:0]  minutes_1;                                                                                                           //
wire [6:0]  min_1_b27;           //counts minutes tens place                                                                    //
                                                                                                                                //
reg [3:0]  hours_0;             //counts hours unit place                                                                       //
wire [6:0]  hrs_0_b27;                                                                                                          //
reg [3:0]  hours_1;             //counts hours tens place                                                                       //
wire [6:0]  hrs_1_b27;                                                                                                          //
                                                                                                                                //
reg [25:0] dis_sel_clk;         //counter for 1000Hz display select clock                                                       //
reg [1:0]  dis_sel;             //register for 2 bit counter                                                                    //
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
//parameter TIME_PERIOD = 26'd9;       //for testbench purposes
parameter TIME_PERIOD = 26'd269999;   //for 100Hz clock tick
//parameter TIME_PERIOD = 26'd2699999;  //for 10Hz clock tick
//parameter TIME_PERIOD = 26'd26999999; //for 1Hz clock tick
//parameter MUX_RATE = 26'd3;       //for testbench purposes
parameter MUX_RATE = 26'd26999;       //for 1000Hz display mux rate

//`define SECONDS_DIS; to enable seconds 7 segment outputs
//------------------------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //1Hz generator
    if(!sys_rst_n)
        seconds_tick <= 26'd0;                                               //reset handling of 1Hz generator
    else if(seconds_tick == TIME_PERIOD) begin
        seconds_tick <= 26'd0;
    end
    else
        seconds_tick <= seconds_tick + 1'd1;                                 //1Hz generate from 27MHz
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //seconds_counter
    if(!sys_rst_n) begin
        seconds_0 <= 4'd0;                                             //reset handling of seconds_counter
        seconds_1 <= 4'd0;
    end
    else if(seconds_tick == TIME_PERIOD) begin
        if(seconds_1 == 4'd5 && seconds_0 == 4'd9) begin
            seconds_0 <= 4'd0;
            seconds_1 <= 4'd0;
        end
        else if(seconds_0 == 4'd9) begin
            seconds_0 <= 4'd0;
            seconds_1 <= seconds_1 + 1'd1;
        end
        else begin
            seconds_0 <= seconds_0 + 1'd1;
        end
    end
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //minutes_counter
    if(!sys_rst_n) begin
        minutes_0 <= 4'd0;                                             //reset handling of minutes counter
        minutes_1 <= 4'd0;
    end
    else if(seconds_1 == 4'd5 && seconds_0 == 4'd9 && seconds_tick == TIME_PERIOD) begin
        if(minutes_1 == 4'd5 && minutes_0 == 4'd9) begin
            minutes_0 <= 4'd0;                                         //reset minutes_counter each 60 minutes
            minutes_1 <= 4'd0;
        end
        else if(minutes_0 == 4'd9) begin
            minutes_0 <= 4'd0;
            minutes_1 <= minutes_1 + 1'd1;
        end
        else begin
            minutes_0 <= minutes_0 +1'd1;                        //increment minutes_counter
        end
    end
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //hours_counter
    if(!sys_rst_n) begin
        hours_0 <= 4'd0;                                               //reset handling of hours counter
        hours_1 <= 4'd0;
    end
    else if(minutes_1 == 4'd5 && minutes_0 == 4'd9 && seconds_1 == 4'd5 && seconds_0 == 4'd9 && seconds_tick == TIME_PERIOD) begin
        if(hours_1 == 4'd2 && hours_0 == 4'd4) begin
            hours_0 <= 4'd0;                                           //reset hours_counter each 24 hours
            hours_1 <= 4'd0;
        end
        else if(hours_0 == 4'd9) begin
            hours_0 <= 4'd0;
            hours_1 <= hours_1 + 1'd1;
        end
        else begin
            hours_0 <= hours_0 +1'd1;                            //increment hours_counter
        end
    end
end
//------------------------------------------------------------------------------------------------------------------------------//




//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //1000Hz generator for display select clock
    if(!sys_rst_n)
        dis_sel_clk <= 26'd0;                                                //reset handling of 1000Hz generator
    else
        if(dis_sel_clk == MUX_RATE)
            dis_sel_clk <= 26'd0;                                            //1000Hz generate from 27MHz
        else
            dis_sel_clk <= dis_sel_clk +1'd1;
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //2 bit counter
    if(!sys_rst_n)
        dis_sel <= 2'd0;                                                     //reset handling of display select register
    else
        if(dis_sel_clk == MUX_RATE)
            dis_sel <= dis_sel + 1'd1;                                       //counting through 4 segments
end
//------------------------------------------------------------------------------------------------------------------------------//

//dis_sel used create 2 to 4 decoder
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        S0 <= 1;
        S1 <= 1;
        S2 <= 1;
        S3 <= 1;
    end
    else begin
        case(dis_sel)
            2'b00:
                begin
                    S0 <= 1;
                    S1 <= 0;
                    S2 <= 0;
                    S3 <= 0;
                end
            2'b01:
                begin
                    S0 <= 0;
                    S1 <= 1;
                    S2 <= 0;
                    S3 <= 0;
                end
            2'b10:
                begin
                    S0 <= 0;
                    S1 <= 0;
                    S2 <= 1;
                    S3 <= 0;
                end
            2'b11:
                begin
                    S0 <= 0;
                    S1 <= 0;
                    S2 <= 0;
                    S3 <= 1;
                end
            default:
                begin
                    S0 <= 1;
                    S1 <= 0;
                    S2 <= 0;
                    S3 <= 0;
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//

//display data mux
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        SA <= 0;
        SB <= 0;
        SC <= 0;
        SD <= 0;
        SE <= 0;
        SF <= 0;
        SG <= 1;
    end
    else begin
        case(dis_sel)
            2'b00:
                begin
                    SA <= min_0_b27[0];
                    SB <= min_0_b27[1];
                    SC <= min_0_b27[2];
                    SD <= min_0_b27[3];
                    SE <= min_0_b27[4];
                    SF <= min_0_b27[5];
                    SG <= min_0_b27[6];
                end
            2'b01:
                begin
                    SA <= min_1_b27[0];
                    SB <= min_1_b27[1];
                    SC <= min_1_b27[2];
                    SD <= min_1_b27[3];
                    SE <= min_1_b27[4];
                    SF <= min_1_b27[5];
                    SG <= min_1_b27[6];
                end
            2'b10:
                begin
                    SA <= hrs_0_b27[0];
                    SB <= hrs_0_b27[1];
                    SC <= hrs_0_b27[2];
                    SD <= hrs_0_b27[3];
                    SE <= hrs_0_b27[4];
                    SF <= hrs_0_b27[5];
                    SG <= hrs_0_b27[6];
                end
            2'b11:
                begin
                    SA <= hrs_1_b27[0];
                    SB <= hrs_1_b27[1];
                    SC <= hrs_1_b27[2];
                    SD <= hrs_1_b27[3];
                    SE <= hrs_1_b27[4];
                    SF <= hrs_1_b27[5];
                    SG <= hrs_1_b27[6];
                end
            default:
                begin
                    SA <= min_0_b27[0];
                    SB <= min_0_b27[1];
                    SC <= min_0_b27[2];
                    SD <= min_0_b27[3];
                    SE <= min_0_b27[4];
                    SF <= min_0_b27[5];
                    SG <= min_0_b27[6];
                end
        endcase
    end
end


`ifdef SECONDS_DIS
//seconds 0 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg s07s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(seconds_0),
    .out(sec_0_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//

//seconds 1 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg s17s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(seconds_1),
    .out(sec_1_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//
`endif

//minutes 0 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg m07s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(minutes_0),
    .out(min_0_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//

//minutes 1 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg m17s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(minutes_1),
    .out(min_1_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//

//hours 0 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg h07s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(hours_0),
    .out(hrs_0_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//

//hours 1 7 segment decoder
//------------------------------------------------------------------------------------------------------------------------------//
bin_to_7_seg h17s(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    .bin(hours_1),
    .out(hrs_1_b27)
);
//------------------------------------------------------------------------------------------------------------------------------//

endmodule
//File Title: Digital Design - Digital Clock
//GOWIN Version: 1.9.8.01
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9C


//module defenition
module segment(
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
reg [6:0]  sec_0_b27;                                                                                                           //
reg [3:0]  seconds_1;                                                                                                           //
reg [6:0]  sec_1_b27;           //counts seconds tens place                                                                     //
                                                                                                                                //
reg [3:0]  minutes_0;                                                                                                           //
reg [6:0]  min_0_b27;           //counts minutes unit place                                                                     //
reg [3:0]  minutes_1;                                                                                                           //
reg [6:0]  min_1_b27;           //counts minutes tens place                                                                     //
                                                                                                                                //
reg [3:0]  hours_0;             //counts hours unit place                                                                       //
reg [6:0]  hrs_0_b27;                                                                                                           //
reg [3:0]  hours_1;             //counts hours tens place                                                                       //
reg [6:0]  hrs_1_b27;                                                                                                           //
                                                                                                                                //
reg [25:0] dis_sel_clk;         //counter for 1000Hz display select clock                                                       //
reg [1:0]  dis_sel;             //register for 2 bit counter                                                                    //
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
//parameter TIME_PERIOD = 26'd27;       //for testbench purposes
//parameter TIME_PERIOD = 26'd269999;   //for 100Hz clock tick
//parameter TIME_PERIOD = 26'd2699999;  //for 10Hz clock tick
parameter TIME_PERIOD = 26'd26999999; //for 1Hz clock tick
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
    else if(minutes_1 == 4'd5 && minutes_0 == 4'd9 && seconds_tick == TIME_PERIOD) begin
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
        if(dis_sel_clk == 26'd26999)
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
        if(dis_sel_clk == 26'd26999)
            dis_sel <= dis_sel + 1'd1;                                       //counting through 4 segments
end
//------------------------------------------------------------------------------------------------------------------------------//

//dis_sel
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
                    SA <= sec_0_b27[0];
                    SB <= sec_0_b27[1];
                    SC <= sec_0_b27[2];
                    SD <= sec_0_b27[3];
                    SE <= sec_0_b27[4];
                    SF <= sec_0_b27[5];
                    SG <= sec_0_b27[6];
                end
            2'b01:
                begin
                    SA <= sec_1_b27[0];
                    SB <= sec_1_b27[1];
                    SC <= sec_1_b27[2];
                    SD <= sec_1_b27[3];
                    SE <= sec_1_b27[4];
                    SF <= sec_1_b27[5];
                    SG <= sec_1_b27[6];
                end
            2'b10:
                begin
                    SA <= min_0_b27[0];
                    SB <= min_0_b27[1];
                    SC <= min_0_b27[2];
                    SD <= min_0_b27[3];
                    SE <= min_0_b27[4];
                    SF <= min_0_b27[5];
                    SG <= min_0_b27[6];
                end
            2'b11:
                begin
                    SA <= min_1_b27[0];
                    SB <= min_1_b27[1];
                    SC <= min_1_b27[2];
                    SD <= min_1_b27[3];
                    SE <= min_1_b27[4];
                    SF <= min_1_b27[5];
                    SG <= min_1_b27[6];
                end
            default:
                begin
                    SA <= sec_0_b27[0];
                    SB <= sec_0_b27[1];
                    SC <= sec_0_b27[2];
                    SD <= sec_0_b27[3];
                    SE <= sec_0_b27[4];
                    SF <= sec_0_b27[5];
                    SG <= sec_0_b27[6];
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//



//Binary to 7 segment - sec_0_b27
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        sec_0_b27[0] <= 0;
        sec_0_b27[1] <= 0;
        sec_0_b27[2] <= 0;
        sec_0_b27[3] <= 0;
        sec_0_b27[4] <= 0;
        sec_0_b27[5] <= 0;
        sec_0_b27[6] <= 1;
    end
    else begin
        case(seconds_0)
            4'b0000:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 0;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 1;
                end
            4'b0001:
                begin
                    sec_0_b27[0] <= 1;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 1;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 1;
                    sec_0_b27[6] <= 1;
                end
            4'b0010:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 1;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 0;
                    sec_0_b27[5] <= 1;
                    sec_0_b27[6] <= 0;
                end
            4'b0011:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 1;
                    sec_0_b27[6] <= 0;
                end
            4'b0100:
                begin
                    sec_0_b27[0] <= 1;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 1;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 0;
                end
            4'b0101:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 1;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 0;
                end
            4'b0110:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 1;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 0;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 0;
                end
            4'b0111:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 1;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 1;
                    sec_0_b27[6] <= 1;
                end
            4'b1000:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 0;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 0;
                end
            4'b1001:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 1;
                    sec_0_b27[4] <= 1;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 0;
                end
            default:
                begin
                    sec_0_b27[0] <= 0;
                    sec_0_b27[1] <= 0;
                    sec_0_b27[2] <= 0;
                    sec_0_b27[3] <= 0;
                    sec_0_b27[4] <= 0;
                    sec_0_b27[5] <= 0;
                    sec_0_b27[6] <= 1;
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//


//Binary to 7 segment - sec_1_b27
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        sec_1_b27[0] <= 0;
        sec_1_b27[1] <= 0;
        sec_1_b27[2] <= 0;
        sec_1_b27[3] <= 0;
        sec_1_b27[4] <= 0;
        sec_1_b27[5] <= 0;
        sec_1_b27[6] <= 1;
    end
    else begin
        case(seconds_1)
            4'b0000:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 0;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 1;
                end
            4'b0001:
                begin
                    sec_1_b27[0] <= 1;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 1;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 1;
                    sec_1_b27[6] <= 1;
                end
            4'b0010:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 1;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 0;
                    sec_1_b27[5] <= 1;
                    sec_1_b27[6] <= 0;
                end
            4'b0011:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 1;
                    sec_1_b27[6] <= 0;
                end
            4'b0100:
                begin
                    sec_1_b27[0] <= 1;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 1;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 0;
                end
            4'b0101:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 1;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 0;
                end
            4'b0110:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 1;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 0;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 0;
                end
            4'b0111:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 1;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 1;
                    sec_1_b27[6] <= 1;
                end
            4'b1000:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 0;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 0;
                end
            4'b1001:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 1;
                    sec_1_b27[4] <= 1;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 0;
                end
            default:
                begin
                    sec_1_b27[0] <= 0;
                    sec_1_b27[1] <= 0;
                    sec_1_b27[2] <= 0;
                    sec_1_b27[3] <= 0;
                    sec_1_b27[4] <= 0;
                    sec_1_b27[5] <= 0;
                    sec_1_b27[6] <= 1;
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//


//Binary to 7 segment - min_0_b27
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        min_0_b27[0] <= 0;
        min_0_b27[1] <= 0;
        min_0_b27[2] <= 0;
        min_0_b27[3] <= 0;
        min_0_b27[4] <= 0;
        min_0_b27[5] <= 0;
        min_0_b27[6] <= 1;
    end
    else begin
        case(minutes_0)
            4'b0000:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 0;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 1;
                end
            4'b0001:
                begin
                    min_0_b27[0] <= 1;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 1;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 1;
                    min_0_b27[6] <= 1;
                end
            4'b0010:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 1;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 0;
                    min_0_b27[5] <= 1;
                    min_0_b27[6] <= 0;
                end
            4'b0011:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 1;
                    min_0_b27[6] <= 0;
                end
            4'b0100:
                begin
                    min_0_b27[0] <= 1;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 1;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 0;
                end
            4'b0101:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 1;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 0;
                end
            4'b0110:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 1;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 0;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 0;
                end
            4'b0111:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 1;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 1;
                    min_0_b27[6] <= 1;
                end
            4'b1000:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 0;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 0;
                end
            4'b1001:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 1;
                    min_0_b27[4] <= 1;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 0;
                end
            default:
                begin
                    min_0_b27[0] <= 0;
                    min_0_b27[1] <= 0;
                    min_0_b27[2] <= 0;
                    min_0_b27[3] <= 0;
                    min_0_b27[4] <= 0;
                    min_0_b27[5] <= 0;
                    min_0_b27[6] <= 1;
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//


//Binary to 7 segment - min_1_b27
//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        min_1_b27[0] <= 0;
        min_1_b27[1] <= 0;
        min_1_b27[2] <= 0;
        min_1_b27[3] <= 0;
        min_1_b27[4] <= 0;
        min_1_b27[5] <= 0;
        min_1_b27[6] <= 1;
    end
    else begin
        case(minutes_1)
            4'b0000:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 0;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 1;
                end
            4'b0001:
                begin
                    min_1_b27[0] <= 1;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 1;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 1;
                    min_1_b27[6] <= 1;
                end
            4'b0010:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 1;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 0;
                    min_1_b27[5] <= 1;
                    min_1_b27[6] <= 0;
                end
            4'b0011:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 1;
                    min_1_b27[6] <= 0;
                end
            4'b0100:
                begin
                    min_1_b27[0] <= 1;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 1;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 0;
                end
            4'b0101:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 1;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 0;
                end
            4'b0110:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 1;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 0;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 0;
                end
            4'b0111:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 1;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 1;
                    min_1_b27[6] <= 1;
                end
            4'b1000:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 0;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 0;
                end
            4'b1001:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 1;
                    min_1_b27[4] <= 1;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 0;
                end
            default:
                begin
                    min_1_b27[0] <= 0;
                    min_1_b27[1] <= 0;
                    min_1_b27[2] <= 0;
                    min_1_b27[3] <= 0;
                    min_1_b27[4] <= 0;
                    min_1_b27[5] <= 0;
                    min_1_b27[6] <= 1;
                end
        endcase
    end
end
//------------------------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------------------------//


endmodule
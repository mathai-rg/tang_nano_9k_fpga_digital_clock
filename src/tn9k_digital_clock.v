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
reg [6:0]  seconds_counter;     //counts seconds                                                                                //
reg [6:0]  minutes_counter;     //counts minutes                                                                                //
reg [5:0]  hours_counter;       //counts hours                                                                                  //
                                                                                                                                //
reg [25:0] dis_sel_clk;         //counter for 1000Hz display select clock                                                       //
reg [1:0]  dis_sel;             //register for 2 bit counter                                                                    //
//------------------------------------------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //1Hz generator
    if(!sys_rst_n)
        seconds_tick <= 26'd0;                                               //reset handling of 1Hz generator
    else
        seconds_tick <= seconds_tick + 1'd1;                                 //1Hz generate from 27MHz
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //seconds_counter
    if(!sys_rst_n)
        seconds_counter <= 7'd0;                                             //reset handling of seconds_counter
    else if(seconds_tick == 26'd26999999)
        if(seconds_counter == 7'd60)
            seconds_counter <= 7'd0;                                         //reset seconds_counter each 60 seconds
        else
            seconds_counter <= seconds_counter + 1'd1;                       //increment seconds_counter
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //minutes_counter
    if(!sys_rst_n)
        minutes_counter <= 7'd0;                                             //reset handling of minutes counter
    else if(seconds_counter == 7'd60)
        if(minutes_counter == 7'd60)
            minutes_counter <= 7'd0;                                         //reset minutes_counter each 60 minutes
        else
            minutes_counter <= minutes_counter +1'd1;                        //increment minutes_counter
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //hours_counter
    if(!sys_rst_n)
        hours_counter <= 6'd0;                                               //reset handling of hours counter
    else if(minutes_counter == 7'd60)
        if(hours_counter == 6'd24)
            hours_counter <= 6'd0;                                           //reset hours_counter each 24 hours
        else
            hours_counter <= hours_counter +1'd1;                            //increment hours_counter
end
//------------------------------------------------------------------------------------------------------------------------------//




//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //1000Hz generator for display select clock
    if(!sys_rst_n)
        dis_sel_clk <= 26'd0;                                                //reset handling of 1000Hz generator
    else
        if(dis_sel_clk == 26'd26999)
            dis_sel_clk <= 26'd0;                                            //1Hz generate from 27MHz
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

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        S0 <= 1;
        S1 <= 0;
        S2 <= 0;
        S3 <= 0;
    end
    else
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
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always begin

    SA <= 0;
    SB <= 0;
    SC <= 0;
    SD <= 0;
    SE <= 0;
    SF <= 0;
    SG <= 0;

end
endmodule
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
reg [3:0]  seconds_0;           //counts seconds unit place                                                                     //
reg [2:0]  seconds_1;           //counts seconds tens place                                                                     //
reg [3:0]  minutes_0;           //counts minutes unit place                                                                     //
reg [2:0]  minutes_1;           //counts minutes tens place                                                                     //
reg [3:0]  hours_0;             //counts hours unit place                                                                       //
reg [1:0]  hours_1;             //counts hours unit place                                                                       //
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
    if(!sys_rst_n) begin
        seconds_0 <= 4'd0;                                             //reset handling of seconds_counter
        seconds_1 <= 3'd0;
    end
    else if(seconds_tick == 26'd26999999) begin
        if(seconds_0 == 4'd10) begin
            seconds_0 <= 4'd0;                                         //reset seconds_0 each 10 seconds
            seconds_1 <= seconds_1 + 1'd1;
        end
        else begin
            seconds_0 <= seconds_0 + 1'd1;                       //increment seconds_counter
        end
        if(seconds_1 == 3'd6) begin
            seconds_1 <= 3'd0;
        end
    end

end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //minutes_counter
    if(!sys_rst_n) begin
        minutes_0 <= 4'd0;                                             //reset handling of minutes counter
        minutes_1 <= 3'd0;
    end
    else if(seconds_1 == 3'd6) begin
        if(minutes_0 == 4'd10) begin
            minutes_0 <= 4'd0;                                         //reset minutes_counter each 60 minutes
            minutes_1 <= minutes_1 +1'd1;
        end
        else begin
            minutes_0 <= minutes_0 +1'd1;                        //increment minutes_counter
        end
        if(minutes_1 == 3'd6) begin
            minutes_1 <= 3'd0;
        end
    end
end
//------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------//
always @(posedge sys_clk or negedge sys_rst_n) begin                         //hours_counter
    if(!sys_rst_n) begin
        hours_0 <= 4'd0;                                               //reset handling of hours counter
        hours_1 <= 2'd0;
    end
    else if(minutes_1 == 3'd6) begin
        if(hours_0 == 4'd10) begin
            hours_0 <= 4'd0;                                           //reset hours_counter each 24 hours
            hours_1 <= hours_1 + 1'd1;
        end
        else begin
            hours_0 <= hours_0 +1'd1;                            //increment hours_counter
        end
        if(hours_1 == 2'd3) begin
            hours_1 <= 2'd0;
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

//------------------------------------------------------------------------------------------------------------------------------//
//always @(posedge sys_clk or negedge sys_rst_n) begin
//    if(!sys_rst_n) begin
//        SA <= 0;
//        SB <= 0;
//        SC <= 0;
//        SD <= 0;
//        SE <= 0;
//        SF <= 0;
//        SG <= 1;
//    end
//    else begin
//        case(seconds_0)
//            4'b0000:
//                begin
//                    SA <= 0;
//                    SB <= 0;
//                    SC <= 0;
//                    SD <= 0;
//                    SE <= 0;
//                    SF <= 0;
//                    SG <= 1;
//                end
//            4'b0001:
//                begin
//                    SA <= 1;
//                    SB <= 0;
//                    SC <= 0;
//                    SD <= 1;
//                    SE <= 1;
//                    SF <= 1;
//                    SG <= 1;
//                end
//            4'b0010:
//                begin
//                    SA <= 0;
//                    SB <= 0;
//                    SC <= 1;
//                    SD <= 0;
//                    SE <= 0;
//                    SF <= 1;
//                    SG <= 0;
//                end
//            default:
//                begin
//                    SA <= 0;
//                    SB <= 0;
//                    SC <= 0;
//                    SD <= 0;
//                    SE <= 0;
//                    SF <= 0;
//                    SG <= 1;
//                end
//        endcase
//    end
//end
//------------------------------------------------------------------------------------------------------------------------------//

//test
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
                    SA <= 0;
                    SB <= 0;
                    SC <= 0;
                    SD <= 0;
                    SE <= 0;
                    SF <= 0;
                    SG <= 1;
                end
            2'b01:
                begin
                    SA <= 1;
                    SB <= 0;
                    SC <= 0;
                    SD <= 1;
                    SE <= 1;
                    SF <= 1;
                    SG <= 1;
                end
            2'b10:
                begin
                    SA <= 0;
                    SB <= 0;
                    SC <= 1;
                    SD <= 0;
                    SE <= 0;
                    SF <= 1;
                    SG <= 0;
                end
            2'b11:
                begin
                    SA <= 0;
                    SB <= 0;
                    SC <= 0;
                    SD <= 0;
                    SE <= 1;
                    SF <= 1;
                    SG <= 0;
                end
            default:
                begin
                    SA <= 0;
                    SB <= 0;
                    SC <= 0;
                    SD <= 0;
                    SE <= 0;
                    SF <= 0;
                    SG <= 1;
                end
        endcase
    end
end

//------------------------------------------------------------------------------------------------------------------------------//


endmodule
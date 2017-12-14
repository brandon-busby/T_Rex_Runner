`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2017 09:54:38 PM
// Design Name: 
// Module Name: Debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debouncer #(parameter FREQ = 1, WIDTH = 1) (output reg [WIDTH-1:0] Btn_Out, input Clk, [WIDTH-1:0] Btn_In);
    parameter PERIOD = FREQ/10;
    parameter WAIT_BTN_CHANGE = 0;
    parameter WAIT_BTN_SETTLE = 1;
    reg [$clog2(PERIOD+1)-1:0] Timer, Timer_next;
    reg State, State_next;
    reg [WIDTH-1:0] Btn_prev;
    

    
    always @ (posedge Clk) begin
        Timer <= Timer_next;
        State <= State_next;
        Btn_prev <= Btn_In;
    end
    
    always @ (*) begin
        case (State)
            WAIT_BTN_CHANGE: begin
                if (Btn_In == Btn_prev) begin
                    Timer_next <= 0;
                    State_next <= WAIT_BTN_CHANGE;
                    Btn_Out <= Btn_prev;
                end
                else begin
                    Timer_next <= 1;
                    State_next <= WAIT_BTN_SETTLE;
                    Btn_Out <= Btn_Out;
                end
            end
            WAIT_BTN_SETTLE: begin
                if (Timer >= PERIOD) begin
                    Timer_next <= 0;
                    State_next <= WAIT_BTN_CHANGE;
                    Btn_Out <= Btn_In;
                end
                else begin
                    Timer_next <= Timer + 1;
                    State_next <= WAIT_BTN_SETTLE;
                    Btn_Out <= Btn_Out;
                end
            end
        endcase
    end
    
endmodule

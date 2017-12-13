`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2017 08:53:29 PM
// Design Name: 
// Module Name: Primary_Controller
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


module Primary_Controller(output reg Rst, input UsrInput, GameOver, Clk);
    // State Parameters
    parameter WAIT = 2;
    parameter RESET = 1;
    parameter PLAYING_GAME = 2;
    parameter GAME_OVER = 3;
    
    // State registers
    reg [1:0] State, State_Next;
    
    // Combinational Logic
    always @ (*) begin
        case (State)
        WAIT: begin
            Rst <= 1;
            if (UsrInput) State_Next <= RESET;
            else State_Next <= WAIT;
        end
        RESET: begin
            Rst <= 1;
            if (GameOver) State_Next <= RESET;
            else State_Next <= PLAYING_GAME;
        end
        PLAYING_GAME: begin
            Rst <= 0;
            if (GameOver) State_Next <= GAME_OVER;
            else State_Next <= PLAYING_GAME;
        end
        GAME_OVER: begin
            Rst <= 0;
            if (UsrInput) State_Next <= RESET;
            else State_Next <= GAME_OVER;
        end
        endcase
    end
    
    // State flip-flop Logic
    always @ (posedge Clk) begin
        State <= State_Next;
    end
endmodule

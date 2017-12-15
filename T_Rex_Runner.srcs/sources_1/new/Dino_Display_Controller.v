`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2017 07:09:16 PM
// Design Name: 
// Module Name: Dino_Display_Controller
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


module Dino_Display_Controller(output reg [3:0] Dino_ROM, input Ref_Tick, Gnd, GameOver, Duck);
    parameter JUMP_DISPLAY = 0;
    parameter WALK_FRONT = 1;
    parameter WALK_BACK = 2;
    parameter DUCK_FRONT = 3;
    parameter DUCK_BACK = 4;
    
    // State Registers
    reg [3:0] State, State_Next;
    reg [4:0] Count, Count_Next;
    
    // Combinational Logic
    always @ (*) begin
        Count_Next <= (Count == 30) ? 0 : Count + 1;
        if (GameOver) begin
            Dino_ROM <= State + 4;
            State_Next <= State;
        end
        else begin
            Dino_ROM <= State;
            case (State)
            JUMP_DISPLAY: begin
                if (Gnd) begin
                    if (Duck) State_Next <= DUCK_BACK;
                    else State_Next <= WALK_BACK;
                end
                else
                    State_Next <= JUMP_DISPLAY;
            end
            WALK_FRONT: begin
                if (~Gnd) State_Next <= JUMP_DISPLAY;
                else if (Duck) State_Next <= DUCK_FRONT;
                else if (Count == 20) State_Next <= WALK_BACK;
                else State_Next <= WALK_FRONT;
            end
            WALK_BACK: begin
                if (~Gnd) State_Next <= JUMP_DISPLAY;
                else if (Duck) State_Next <= DUCK_BACK;
                else if (Count == 20) State_Next <= WALK_FRONT;
                else State_Next <= WALK_BACK;
            end
            DUCK_FRONT: begin
                if (~Gnd) State_Next <= JUMP_DISPLAY;
                else if (~Duck) State_Next <= WALK_FRONT;
                else if (Count == 20) State_Next <= DUCK_BACK;
                else State_Next <= DUCK_FRONT;
            end
            DUCK_BACK: begin
                if (~Gnd) State_Next <= JUMP_DISPLAY;
                else if (~Duck) State_Next <= WALK_BACK;
                else if (Count == 20) State_Next <= DUCK_FRONT;
                else State_Next <= DUCK_BACK;
            end
            default: begin
                State_Next <= JUMP_DISPLAY;
            end
            endcase
        end
    end
    
    // State Register
    always @ (posedge Ref_Tick) begin
        State <= State_Next;
        Count <= Count_Next;
    end
endmodule

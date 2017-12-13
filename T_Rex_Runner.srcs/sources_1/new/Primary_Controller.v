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


module Primary_Controller(output reg GameOver, Duck, output reg [9:0] Player_Y, Map_Shift, input Clk, Ref_Tick, Jmp, Dwn, Collision, Bound_Lower, Bount_Upper);
    // State definitions
    parameter STARTUP = 0;
    parameter WAIT = 1;
    parameter GAME_OVER = 2;
    parameter TICK = 3;
    parameter SCROLL_MAP = 4;
    parameter INIT_JMP = 5;
    parameter AIR = 6;
    parameter RISE = 7;
    parameter FALL = 8;
    
    // Datapath Constants
    parameter VELOCITY_CONSTANT = 5; // Dummy value
    parameter BOUNDARY_BUFFER = 5; // Dummy value
    parameter UPPER_BOUNDARY = 200; // Dummy value
    parameter LOWER_BOUNDARY = 0; // Dummy value
    
    // State registers
    reg [4:0] State, State_Next;
    
    // Local Datapath Storage
    wire [9:0] Delta_Y;
    
    // Controller to Datapath Signals
    reg Rst, Rising, Gnd;
    
    // Datapath to Controller Signals
    wire LowerBoundReached, UpperBoundReached;
    
    // Combinational Logic
    always @ (*) begin
        case (State)
        STARTUP: begin
            Rst <= 1;
            Rising <= 0;
            Gnd <= 1;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= WAIT;
        end
        WAIT: begin
            Rst <= 1;
            Rising <= 0;
            Gnd <= 1;
            GameOver <= GameOver;
            Duck <= 0;
            State_Next <= (Jmp | Dwn) ? TICK : WAIT;
        end
        GAME_OVER: begin
            Rst <= 0;
            Rising <= Rising;
            Gnd <= Gnd;
            GameOver <= 1;
            Duck <= Duck;
            State_Next <= WAIT;
        end
        TICK: begin
            Rst <= 0;
            Rising <= Rising;
            Gnd <= Gnd;
            GameOver <= 0;
            Duck <= Dwn & Gnd & ~Jmp;
            if (~Ref_Tick)
                State_Next <= TICK;
            else if (Collision)
                State_Next <= GAME_OVER;
            else if (~Gnd)
                State_Next <= AIR;
            else if (Jmp & ~Duck)
                State_Next <= INIT_JMP;
            else
                State_Next <= SCROLL_MAP;
        end
        SCROLL_MAP: begin
            Rst <= 0;
            Rising <= Rising;
            Gnd <= Gnd;
            GameOver <= 0;
            Duck <= Duck;
            State_Next <= TICK;
        end
        INIT_JMP: begin
            Rst <= 0;
            Rising <= 1;
            Gnd <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= AIR;
        end
        AIR: begin
            Rst <= 0;
            Rising <= Rising;
            Gnd <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= Rising ? RISE : FALL;
        end
        RISE: begin
            Rst <= 0;
            Rising <= ~UpperBoundReached;
            Gnd <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= SCROLL_MAP;
        end
        FALL: begin
            Rst <= 0;
            Rising <= 0;
            Gnd <= LowerBoundReached;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= SCROLL_MAP;
        end
        default: begin
            State_Next <= STARTUP;
        end
        endcase
    end
    
    // State flip-flop Logic
    always @ (posedge Clk) begin
        State <= State_Next;
    end
    
    // Datapath
    assign LowerBoundReached = (Player_Y < LOWER_BOUNDARY);
    assign UpperBoundReached = (Player_Y > UPPER_BOUNDARY);
    assign Delta_Y = VELOCITY_CONSTANT*(UPPER_BOUNDARY + BOUNDARY_BUFFER - Player_Y);
    
    always @ (posedge Clk) begin
        if (Rst)
            Player_Y <= 0;
        else if (Rising)
            Player_Y <= Player_Y + Delta_Y;
        else
            Player_Y <= Player_Y - Delta_Y;
    end
    
endmodule

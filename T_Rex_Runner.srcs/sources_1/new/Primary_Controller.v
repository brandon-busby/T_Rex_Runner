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


module Primary_Controller(output InFall, reg GameOver, Duck, output reg [9:0] Player_Y, Map_Shift, input Clk, Controller_Rst, Ref_Tick, Jmp, Dwn, Collision);
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
    parameter WAIT_BTN_UP = 9;
    
    parameter UPPER_BOUNDARY = 180;
    parameter LOWER_BOUNDARY = 380;
    
    parameter DELTA_Y = 5;
    
    assign InFall = (State == FALL);
    
    // State registers
    reg [4:0] State, State_Next;
    
    // Local Datapath Storage
    
    // Controller to Datapath Signals
    reg Rst, Rising, Gnd, Rising_Next, Gnd_Next;
    
    // Datapath to Controller Signals
    wire LowerBoundReached, UpperBoundReached;
    
    // Combinational Logic
    always @ (*) begin
        case (State)
        STARTUP: begin
            Rst <= 1;
            Rising_Next <= 0;
            Gnd_Next <= 1;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= WAIT;
        end
        WAIT: begin
            Rst <= 1;
            Rising_Next <= 0;
            Gnd_Next <= 1;
            GameOver <= GameOver;
            Duck <= 0;
            State_Next <= (Jmp | Dwn) ? WAIT_BTN_UP : WAIT;
        end
        GAME_OVER: begin
            Rst <= 0;
            Rising_Next <= Rising;
            Gnd_Next <= Gnd;
            GameOver <= 1;
            Duck <= Duck;
            State_Next <= WAIT;
        end
        TICK: begin
            Rst <= 0;
            Rising_Next <= UpperBoundReached ? 0 : Rising;
            Gnd_Next <= Gnd;
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
            Rising_Next <= Rising;
            Gnd_Next <= Gnd;
            GameOver <= 0;
            Duck <= Duck;
            State_Next <= TICK;
        end
        INIT_JMP: begin
            Rst <= 0;
            Rising_Next <= 1;
            Gnd_Next <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= AIR;
        end
        AIR: begin
            Rst <= 0;
            Rising_Next <= Rising;
            Gnd_Next <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= Rising ? RISE : FALL;
        end
        RISE: begin
            Rst <= 0;
            Rising_Next <= ~UpperBoundReached;
            Gnd_Next <= 0;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= SCROLL_MAP;
        end
        FALL: begin
            Rst <= 0;
            Rising_Next <= 0;
            Gnd_Next <= LowerBoundReached;
            GameOver <= 0;
            Duck <= 0;
            State_Next <= SCROLL_MAP;
        end
        WAIT_BTN_UP: begin
            Rst <= 1;
            Rising_Next <= 0;
            Gnd_Next <= 1;
            GameOver <= GameOver;
            Duck <= 0;
            State_Next <= (Jmp | Dwn) ? WAIT_BTN_UP : TICK;
        end
        default: begin
            State_Next <= STARTUP;
        end
        endcase
    end
    
    // State flip-flop Logic
    always @ (posedge Clk) begin
        Rising <= Rising_Next;
        Gnd <= Gnd_Next;
        if (Controller_Rst)
            State <= STARTUP;
        else
            State <= State_Next;
    end
    
    // Datapath
    assign LowerBoundReached = (Player_Y > LOWER_BOUNDARY);
    assign UpperBoundReached = (Player_Y < UPPER_BOUNDARY);
    // assign Delta_Y = 6; //(Player_Y - UPPER_BOUNDARY - BOUNDARY_BUFFER) >> VELOCITY_CONSTANT;
    
    always @ (negedge Clk) begin
        if (Rst) begin
            Player_Y <= LOWER_BOUNDARY;
        end
        else begin
            case (State)
            RISE: begin
                Player_Y <= Player_Y - DELTA_Y;
            end
            FALL: begin
                if (LowerBoundReached)
                    Player_Y <= LOWER_BOUNDARY;
                else
                    Player_Y <= Player_Y + DELTA_Y;
            end
            default: begin
                Player_Y <= Player_Y;
            end
            endcase
        end
    end
    
endmodule

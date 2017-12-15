`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2017 11:40:57 AM
// Design Name: 
// Module Name: Wrapper
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


module Wrapper(output VGA_HS, VGA_VS, [3:0] VGA_R, VGA_G, VGA_B, input CLK100MHZ, Rst, Jmp, Dwn);
    parameter SYS_CLK_FREQ = 100000000;
    
    wire [11:0] RGB;
    wire Gnd, GameOver, Duck, Collision, Ref_Tick, Video_On;
    wire [9:0] Player_Y, Map_Shift, Pixel_X, Pixel_Y;
    wire Rst_Safe, Jmp_Safe, Dwn_Safe;
    wire [4:0] State;
    
    assign {VGA_R, VGA_G, VGA_B} = RGB;
    
    // module Debouncer #(parameter FREQ = 1, WIDTH = 1) (output reg [WIDTH-1:0] Btn_Out, input Clk, [WIDTH-1:0] Btn_In);
    Debouncer #(SYS_CLK_FREQ, 3) Sanitize_Inputs({Rst_Safe, Jmp_Safe, Dwn_Safe}, CLK100MHZ, {Rst, Jmp, Dwn});
    
    // module Primary_Controller(output reg Gnd, GameOver, Duck, Collision, output reg [9:0] Player_Y, Map_Shift, input Clk, Controller_Rst, Ref_Tick, Jmp, Dwn);
    Primary_Controller PrimaryController(Gnd, GameOver, Duck, Collision, Player_Y, Map_Shift, CLK100MHZ, Rst_Safe, Ref_Tick, Jmp_Safe, Dwn_Safe);
    // module Pixel_Generation(input [9:0] pixel_x, pixel_y, player_y, input sysClk, videoOn, refTick, Gnd, GameOver, Duck, Collision, output reg [11:0] RGB);
    Pixel_Generation PixelGeneration(Pixel_X, Pixel_Y, Player_Y, CLK100MHZ, Video_On, Ref_Tick, Gnd, GameOver, Duck, Collision, RGB);
    // module VGA_Controller(input clk, rst, output reg h_sync, v_sync, output video_on, output reg [9:0] pixel_x, pixel_y, output ref_tick);
    VGA_Controller VGAController(CLK100MHZ, Rst_Safe, VGA_HS, VGA_VS, Video_On, Pixel_X, Pixel_Y, Ref_Tick);
endmodule

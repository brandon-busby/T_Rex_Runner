`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2017 11:06:17 PM
// Design Name: 
// Module Name: VGA_Top
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


module VGA_Top(input clk, rst, input [1:0] btn, output HS, VS, output [11:0] RGB);
// signal declarations
wire [9:0] pixel_x, pixel_y;
wire video_on;
wire clk_60Hz;

// module vga_sync( input clk, rst, output reg h_sync, v_sync, output video_on, output reg [9:0] pixel_x, pixel_y);
VGA_Controller VSYNC(clk, rst, HS, VS, video_on, pixel_x, pixel_y, clk_60Hz);
// module pixel_generation(input clk, input clk_60Hz, input rst, input [1:0] btn, input video_on, input [9:0] pixel_x, pixel_y, output reg [11:0] RGB);
Pixel_Generation PGEN(clk, clk_60Hz, rst, btn, video_on, pixel_x, pixel_y, RGB);

endmodule

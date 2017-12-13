`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2017 08:41:08 PM
// Design Name: 
// Module Name: VGA_Controller
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


module VGA_Controller(output HS, VS, [11:0] Color_Out, input [9:0] HCount, VCount, [11:0] Color_In);
    wire InDisplayArea;
    assign InDisplayArea = (144 <= HCount) & (HCount <= 783) & (35 <= VCount) & (VCount <= 514);
    assign HS = (HCount <= 95);
    assign VS = (VCount <= 1);
    // module Mux #(parameter WIDTH = 1) (output [WIDTH-1:0] F, input S, [WIDTH-1:0] A0, A1);
    Mux #(.WIDTH(12)) DisplayMux(.F(Color_Out), .S(InDisplayArea), .A0(0), .A1(Color_In));
endmodule

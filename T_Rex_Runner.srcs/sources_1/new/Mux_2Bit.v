`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2017 08:38:55 PM
// Design Name: 
// Module Name: Mux_2Bit
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


module Mux_2Bit #(parameter WIDTH = 1) (output [WIDTH-1:0] F, input S, [WIDTH-1:0] A0, A1);
    assign F = S ? A1 : A0;
endmodule

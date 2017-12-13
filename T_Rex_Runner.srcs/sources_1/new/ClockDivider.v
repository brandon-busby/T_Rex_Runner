`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2017 08:36:30 PM
// Design Name: 
// Module Name: ClockDivider
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


module ClockDivider #(parameter DIV = 2) (output reg Clk_Out, input Clk_In, Rst);
    wire [$clog2(DIV)-1:0] Val;
    // module Counter #(parameter MAX_VAL = 1) (output reg [$clog2(MAX_VAL+1)-1:0] Val, input Clk, En, Rst);
    Counter #(.MAX_VAL(DIV-1)) Divider_Counter(.Val(Val), .Clk(Clk_In), .En(1), .Rst(Rst));
    always @ (posedge Clk_In) begin
        if (Val == 0  || Val == DIV/2)
            Clk_Out <= ~Clk_Out;
    end
endmodule

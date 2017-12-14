`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2017 11:07:35 PM
// Design Name: 
// Module Name: Pixel_Generation
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


module Pixel_Generation(input [9:0] pixel_x, pixel_y, player_y, input sysClk, videoOn, refTick, InFall, output reg [11:0] RGB);

// Need to make system clk input to module
// Want to show '0'

localparam digitSizeX = 16;
localparam digitLeft = 200;
localparam digitRight = digitLeft + digitSizeX - 1;
localparam digitSizeY = 16;
localparam digitRGB = 12'h000;


wire [9:0] digitBottom;
wire digitROMOn;
wire digitOn;
wire digitBit;
reg [7:0] digitAddr;
wire [3:0] digitCol;
wire [15:0] digitRowData;
//wire [9:0] digitLeftAdj;


reg [3:0] digitMSB, letterMSB;
reg [5:0] count;

dROM digitROM(sysClk, digitROMOn, digitAddr, digitRowData);
//letterROM lROM(sysClk, letterROMOn, letterAddr, letterRowData);

//assign digitLeftAdj = pixel_x - digitLeft;
assign digitBottom = player_y + digitSizeY - 1;
assign digitROMOn = ((pixel_x >= digitLeft) && (pixel_x <= digitRight)) && ((pixel_y >= player_y) && (pixel_y <= digitBottom));
assign digitCol = pixel_x[3:0] - digitLeft[3:0]; 
assign digitBit = digitRowData[~digitCol];
assign digitOn = digitROMOn & digitBit;


always @ (posedge sysClk)
begin
    digitAddr[3:0] = pixel_y[3:0] - player_y[3:0];
    digitAddr[7:4] <= 0;
end

always @ (*)
begin
    if (~videoOn)
    begin
        RGB <= 12'h000;
    end
    
    else
    begin
        if (digitOn || pixel_y == 180 || pixel_y == 380)
        begin
            RGB <= digitRGB;
        end
        
        else
        begin
            RGB <= InFall ? 12'hF00 : ~digitRGB;
        end
    end
end

endmodule

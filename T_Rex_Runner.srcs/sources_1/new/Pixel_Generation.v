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


module Pixel_Generation(input [9:0] pixel_x, pixel_y, player_y, input sysClk, videoOn, refTick, Gnd, GameOver, Duck, Collision, output reg [11:0] RGB);

// Need to make system clk input to module
// Want to show '0'

//dROM digitROM(sysClk, digitROMOn, digitAddr, digitRowData);
//letterROM lROM(sysClk, letterROMOn, letterAddr, letterRowData);
//obstacleRom obstacleROMa();

/******************************* Dino display logic ***************************************/
localparam dinoStretch = 2;
localparam dinoSizeX = 16 * (2**dinoStretch);
localparam dinoLeft = 200;
localparam dinoRight = dinoLeft + dinoSizeX - 1;
localparam dinoSizeY = 16 * (2**dinoStretch);

wire [9:0] dinoBottom, dinoLeftAdj, dinoTopAdj, dinoStepCount;
wire [3:0] dinoCol, dinoMSB;
wire [15:0] dinoRowData;
wire dinoROMOn, dinoOn, dinoBit;

reg [7:0] dinoAddr;

dinoROM dinoROMa(sysClk, dinoROMOn, dinoAddr, dinoRowData);

assign dinoLeftAdj = pixel_x - dinoLeft;
assign dinoTopAdj = pixel_y - player_y;
assign dinoBottom = player_y + dinoSizeY - 1;
assign dinoROMOn = ((pixel_x >= dinoLeft) && (pixel_x <= dinoRight) && ((pixel_y >= player_y)) && (pixel_y <= dinoBottom));
assign dinoCol = dinoLeftAdj[dinoStretch + 3 : dinoStretch];
assign dinoBit = dinoRowData[~dinoCol];
assign dinoOn = dinoROMOn & dinoBit;

// module Counter #(parameter MAX_VAL = 1) (output reg [$clog2(MAX_VAL+1)-1:0] Val, input Clk, En, Rst);
Counter #(30) Step_Counter(dinoStepCount, refTick, 1, 0);

// module Dino_Display_Controller(output reg [3:0] Dino_ROM, input Ref_Tick, Gnd, GameOver, Duck);
Dino_Display_Controller DDC(dinoMSB, refTick, Gnd, GameOver, Duck);

always @ (*)
begin
    dinoAddr[7:4] <= dinoMSB;
    dinoAddr[3:0] <= dinoTopAdj[dinoStretch+3:dinoStretch];
end

/*************************** End dino display logic ***************************************/

// Obstacle display logic
wire [9:0] obstacleBottom, obstacleLeftAdj, obstacleTopAdj;
wire obstacleROMOn, obstacleOn, obstacleBit;
wire [3:0] obstacleCol, obstacleMSB;
wire [15:0] obstacleRowData;
wire [7:0] obstacleAddr;

always @ (*) RGB <= {12{videoOn&~dinoOn}};

endmodule

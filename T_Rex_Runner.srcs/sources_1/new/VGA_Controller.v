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


module VGA_Controller(input clk, rst, output reg h_sync, v_sync, output video_on, output reg [9:0] pixel_x, pixel_y, output ref_tick);

// Constant Declarations for VGA 640x480 display
// Horizontal Parameters -- 640 + 48 + 16 + 96 = 800
localparam H_DISP = 640;    // horizontal display area
localparam H_BP = 48;       // horizontal back porch (left border)
localparam H_FP = 16;       // horizontal front porch (right border)
localparam H_RE = 96;       // horizontal retrace
// Vertical Parameters -- 480 + 33 + 10 + 2 = 525
localparam V_DISP = 480;    // vertical display area
localparam V_BP = 33;       // vertical back porch (top border)
localparam V_FP = 10;       // vertical front porch (bottom border)
localparam V_RE = 2;        // vertical retrace

reg pixel_clk;
reg [1:0] pixel_counter;

wire h_end, v_end;

// pixel clock divider
always @ (posedge clk, posedge rst) begin
    if (rst) begin
        pixel_clk <= 0;
        pixel_counter <= 0;
    end
    else begin
        pixel_counter <= pixel_counter + 1;
        if (pixel_counter == 1 || pixel_counter == 3) begin
            pixel_clk <= ~pixel_clk;
        end
    end
end

// horizontal sync counter
//assign h_end = pixel_x >= (H_DISP + H_BP + H_FP + H_RE - 1);
always @ (posedge pixel_clk, posedge rst) begin
    if (rst) begin
        pixel_x <= 0;
    end
    else begin
        pixel_x <= pixel_x + 1;
        if (pixel_x >= 799) begin
            pixel_x <= 0; 
        end        
    end
end

// horizontal sync pulse
always @ (*) begin
    if (pixel_x >= 0 && pixel_x <= 95) begin
        h_sync <= 1;
    end
    else begin
        h_sync <= 0;
    end
end

// vertical sync counter
//assign v_end = pixel_y >= (V_DISP + V_BP + V_FP + V_RE - 1);
always @ (posedge pixel_clk, posedge rst) begin
    if (rst) begin
        pixel_y <= 0;
    end
    else begin
        if (pixel_x >= 799) begin
            pixel_y <= pixel_y + 1;
            if (pixel_y >= 524) begin
                pixel_y <= 0; 
            end
        end
    end
end

// vertical sync pulse
always @ (*) begin
    if (pixel_y >= 0 && pixel_y <= 1) begin
        v_sync <= 1;
    end
    else begin
        v_sync <= 0;
    end
end

// video display region
assign video_on = ((pixel_x >= 144 && pixel_x < 784) && 
                  (pixel_y >= 35 && pixel_y < 515));

// 60Hz Clock
assign ref_tick = (pixel_y == 524) && (pixel_x == 799);

endmodule

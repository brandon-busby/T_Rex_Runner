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


module Pixel_Generation(input clk, input ref_tick, input rst, input [1:0] btn, input video_on, input [9:0] pixel_x, pixel_y, output reg [11:0] RGB);

// Graphic Object Design Examples - PONG Objects


// 1. Define the edges of your objects
	
	// Round Ball Image (Stored in 16x16 ROM)	
	// Similar to a rectangular object, as the stored image info will be rectangular
	localparam BALL_X_SIZE = 16;
	wire [9:0] ball_x_l, ball_x_r;
	reg [9:0] ball_x;
	localparam BALL_X_V = 2;
	reg ball_x_dir;
	
	localparam BALL_Y_SIZE = 16;
	wire [9:0] ball_y_t, ball_y_b;
	reg [9:0] ball_y;
	localparam BALL_Y_V = 2;
	reg ball_y_dir;
	
	
	// Paddle	
	localparam PAD_X_SIZE = 10;
	localparam PAD_X_L = 680;
	localparam PAD_X_R = PAD_X_L + PAD_X_SIZE - 1;
	
	localparam PAD_Y_SIZE = 75;
	wire [9:0] pad_y_t, pad_y_b;
	reg [9:0] pad_y;
	localparam PAD_Y_V = 4;
	
	
// 1a. Design object movements

	assign ball_x_l = ball_x;
	assign ball_x_r = ball_x_l + BALL_X_SIZE - 1;
	assign ball_y_t = ball_y;
	assign ball_y_b = ball_y_t + BALL_Y_SIZE - 1;
	
	// 2. Calculate the region when pixel_x and pixel_y are inside of the object
        // If ball_on == 1, we want to draw ball
        wire ball_rom_on;
        wire ball_on;
        wire ball_bit;
        wire [3:0] ball_rom_addr;
        wire [3:0] ball_col;
        wire [15:0] ball_row_data;
    
        // Instantiate a copy of our 16x16 ball ROM 
        ball_ROM bROM (clk, ball_rom_on, ball_rom_addr, ball_row_data);
        
        assign ball_rom_on = (((pixel_x >= ball_x_l) && (pixel_x <= ball_x_r)) &&
                               ((pixel_y >= ball_y_t) && (pixel_y <= ball_y_b)));
       
        assign ball_rom_addr = pixel_y[3:0] - ball_y_t[3:0];
        assign ball_col = pixel_x[3:0] - ball_x_l[3:0];
        assign ball_bit = ball_row_data[~ball_col];
        assign ball_on = ball_rom_on & ball_bit;
                           
        wire pad_on;
        assign pad_on = (((pixel_x >= PAD_X_L) && (pixel_x <= PAD_X_R)) &&
                           ((pixel_y >= pad_y_t) && (pixel_y <= pad_y_b)));
                           
        wire bp_coll;
        assign bp_coll = (((ball_x_r + BALL_X_V >= PAD_X_L) && (ball_x_l - BALL_X_V <= PAD_X_R)) &&
                          ((ball_y_b  + BALL_Y_V >= pad_y_t) && (ball_y_t - BALL_Y_V <= pad_y_b)));

	always @(posedge ref_tick, posedge rst) begin
		if (rst) begin
		    ball_y_dir <= 1;
		    ball_y <= 515/2 - BALL_Y_SIZE/2;
		    ball_x_dir <= 1;
		    ball_x <= 464 - BALL_X_SIZE/2;
	    end
		else begin
			// Bottom Wall or Top of Paddle
			if ((ball_y_dir & (ball_y_b < (515 - BALL_Y_V))) &
			   !(ball_y_dir & ball_y_b >= (pad_y_t - BALL_Y_V) & bp_coll)) begin
				ball_y <= ball_y + BALL_Y_V;
			end
			else if ((ball_y_dir & (ball_y_b >= (515 - BALL_Y_V))) |
					 (ball_y_dir & ball_y_b >= (pad_y_t - BALL_Y_V) & bp_coll))  begin
				ball_y_dir <= 0;
				ball_y <= ball_y - BALL_Y_V;
			end
		 
			// Top Wall or Bottom of Paddle
			if ((!ball_y_dir & (ball_y_t > (35 + BALL_Y_V))) &
			   !(!ball_y_dir & ball_y_t <= (pad_y_b + BALL_Y_V) & bp_coll)) begin
				ball_y <= ball_y - BALL_Y_V;
			end
			else if ((!ball_y_dir & (ball_y_t <= (35 + BALL_Y_V))) |
					 (!ball_y_dir & ball_y_t <= (pad_y_b + BALL_Y_V) & bp_coll))  begin
				ball_y_dir <= 1;
				ball_y <= ball_y + BALL_Y_V;
			end
			
			// Right Wall or Left of Paddle
			if ((ball_x_dir & (ball_x_r < (784 - BALL_X_V))) &
			   !(ball_x_dir & ball_x_r >= (PAD_X_L - BALL_X_V) & bp_coll)) begin
				ball_x <= ball_x + BALL_X_V;
			end
			else if ((ball_x_dir & (ball_x_r >= (784 - BALL_X_V))) |
					 (ball_x_dir & ball_x_r >= (PAD_X_L - BALL_X_V) & bp_coll)) begin
				ball_x_dir <= 0;
				ball_x <= ball_x - BALL_X_V;
			end
			
			// Left Wall or Right of Paddle
			if ((!ball_x_dir & (ball_x_l > (144 + BALL_X_V))) &
			   !(!ball_x_dir & ball_x_l <= (PAD_X_R + BALL_X_V) & bp_coll)) begin
				ball_x <= ball_x - BALL_X_V;
			end
			else if ((!ball_x_dir & (ball_x_l <= (144 + BALL_X_V))) |
					 (!ball_x_dir & ball_x_l <= (PAD_X_R + BALL_X_V) & bp_coll)) begin
				ball_x_dir <= 1;
				ball_x <= ball_x + BALL_X_V;
			end
		end
	end
 	
	
	assign pad_y_t = pad_y;
	assign pad_y_b = pad_y_t + PAD_Y_SIZE - 1;
	
	always @(posedge ref_tick, posedge rst) begin
		if (rst) begin
		    pad_y <= 515/2 - PAD_Y_SIZE/2;
		end
		else begin
			if (btn[1] & (pad_y_b < (515 - PAD_Y_V))) begin
				pad_y <= pad_y + PAD_Y_V;
			end
			else if (btn[0] & (pad_y_t > (35 + PAD_Y_V))) begin
				pad_y <= pad_y - PAD_Y_V;
			end
		end
	end	
	
					   
					   
// 3. Display the object when in its boundaries
	// BALL_RGB == RGB color assigned to object
	localparam BALL_RGB = 12'h0FF;
	localparam PAD_RGB = 12'h000;
	
	// selection mux
	always @ (*) begin
		if (~video_on) begin			// Are we in bounds of video display?
			RGB <= 12'h000;				// If not, set RGB to 0.
		end
		else begin
			if (pad_on) begin 		    // Are we in bounds of paddle?
				RGB <= PAD_RGB;		    // If so, display it's color
			end
			else if (ball_on) begin 		    // Are we in bounds of ball?
				RGB <= BALL_RGB;		// If so, display it's color
			end
			else begin					// No objects but in viewable display area
				RGB <= 12'hFFF;			// Display default background color
			end
		end
	end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:10 11/05/2014 
// Design Name: 
// Module Name:    LCD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LCD(
	input clk,
	input reset,
	output rs,
//	input rw,
	output en,
	output [7:0]data,
	input [31:0]echo_cnt
    );
	wire [39:0] bcd1;
	wire [39:0] bcd2;
	
	wire [39:0] bcd3;
	wire [39:0] bcd4;
	
	wire [39:0] bcd5;
	wire [39:0] bcd6;
	
	wire [7:0]data_buffer2[0:10];

	reg		[8:0]	lcd_cnt;
	wire		[7:0]	lcd_state;
	reg		[7:0]	lcd_db;

	parameter 	[7:0]		LCD_BLANK 	= 8'b00100000;
	parameter 	[7:0]		LCD_DASH 	= 8'b00101101;
	parameter	[7:0]	 	LCD_COLON	= 8'b00111010;
	parameter	[7:0]	 	LCD_PERIODE	= 8'b00101110;
	parameter	[7:0]	 	LCD_EQUAL	= 8'b00111101;
	parameter	[7:0]	 	LCD_0			= 8'b00110000;
	parameter	[7:0]	 	LCD_1			= 8'b00110001;
	parameter	[7:0]	 	LCD_2			= 8'b00110010;
	parameter	[7:0]	 	LCD_3			= 8'b00110011;
	parameter	[7:0]	 	LCD_4			= 8'b00110100;
	parameter	[7:0]	 	LCD_5			= 8'b00110101;
	parameter	[7:0]	 	LCD_6			= 8'b00110110;
	parameter	[7:0]	 	LCD_7			= 8'b00110111;
	parameter	[7:0]	 	LCD_8			= 8'b00111000;
	parameter	[7:0]	 	LCD_9			= 8'b00111001;
	parameter	[7:0]	 	LCD_A			= 8'b01000001;
	parameter	[7:0]	 	LCD_B			= 8'b01000010;
	parameter	[7:0]	 	LCD_C			= 8'b01000011;
	parameter	[7:0]	 	LCD_D			= 8'b01000100;
	parameter	[7:0]	 	LCD_E			= 8'b01000101;
	parameter	[7:0]	 	LCD_F			= 8'b01000110;
	parameter	[7:0]	 	LCD_G			= 8'b01000111;
	parameter	[7:0]	 	LCD_H			= 8'b01001000;
	parameter	[7:0]	 	LCD_I			= 8'b01001001;
	parameter	[7:0]	 	LCD_J			= 8'b01001010;
	parameter	[7:0]	 	LCD_K			= 8'b01001011;
	parameter	[7:0]	 	LCD_L			= 8'b01001100;
	parameter	[7:0]	 	LCD_M			= 8'b01001101;
	parameter	[7:0]	 	LCD_N			= 8'b01001110;
	parameter	[7:0]	 	LCD_O			= 8'b01001111;
	parameter	[7:0]	 	LCD_P			= 8'b01010000;
	parameter	[7:0]	 	LCD_Q			= 8'b01010001;
	parameter	[7:0]	 	LCD_R			= 8'b01010010;
	parameter	[7:0]	 	LCD_S			= 8'b01010011;
	parameter	[7:0]	 	LCD_T			= 8'b01010100;
	parameter	[7:0]	 	LCD_U			= 8'b01010101;
	parameter	[7:0]	 	LCD_V			= 8'b01010110;
	parameter	[7:0]	 	LCD_W			= 8'b01010111;
	parameter	[7:0]	 	LCD_X			= 8'b01011000;
	parameter	[7:0]	 	LCD_Y			= 8'b01011001;
	parameter	[7:0]	 	LCD_Z			= 8'b01011010;
	parameter	[7:0]	 	LCD_UNDER	= 8'b01011111;
	parameter	[7:0]	 	LCD_S_a		= 8'b01100001;
	parameter	[7:0]	 	LCD_S_b		= 8'b01100010;
	parameter	[7:0]	 	LCD_S_c		= 8'b01100011;
	parameter	[7:0]	 	LCD_S_d		= 8'b01100100;
	parameter	[7:0]	 	LCD_S_e		= 8'b01100101;
	parameter	[7:0]	 	LCD_S_f		= 8'b01100110;
	parameter	[7:0]	 	LCD_S_g		= 8'b01100111;
	parameter	[7:0]	 	LCD_S_h		= 8'b01101000;
	parameter	[7:0]	 	LCD_S_i		= 8'b01101001;
	parameter	[7:0]	 	LCD_S_j		= 8'b01101010;
	parameter	[7:0]	 	LCD_S_k		= 8'b01101011;
	parameter	[7:0]	 	LCD_S_l		= 8'b01101100;
	parameter	[7:0]	 	LCD_S_m		= 8'b01101101;
	parameter	[7:0]	 	LCD_S_n		= 8'b01101110;
	parameter	[7:0]	 	LCD_S_o		= 8'b01101111;
	parameter	[7:0]	 	LCD_S_p		= 8'b01110000;
	parameter	[7:0]	 	LCD_S_q		= 8'b01110001;
	parameter	[7:0]	 	LCD_S_r		= 8'b01110010;
	parameter	[7:0]	 	LCD_S_s		= 8'b01110011;
	parameter	[7:0]	 	LCD_S_t		= 8'b01110100;
	parameter	[7:0]	 	LCD_S_u		= 8'b01110101;
	parameter	[7:0]	 	LCD_S_v		= 8'b01110110;
	parameter	[7:0]	 	LCD_S_w		= 8'b01110111;
	parameter	[7:0]	 	LCD_S_x		= 8'b01111000;
	parameter	[7:0]	 	LCD_S_y		= 8'b01111001;
	parameter	[7:0]	 	LCD_S_z		= 8'b01111010;
	reg [31:0]cnt_hz=0;
	wire tick;
	always@(posedge clk)
	begin
		if(cnt_hz==32'd50000)
		begin
		cnt_hz <= 32'd0;
		end 
		else cnt_hz <= cnt_hz+ 1'b1;
	end 
	assign tick = (cnt_hz==32'd50000)? 1'b1: 1'b0;
	always @(posedge clk or posedge reset)
	begin
		if(reset == 1'b1)
		begin
			lcd_cnt <= 0; 
		end 
		else if(tick ==1'b1)
		begin
		   if (lcd_cnt == 9'b001111010)
				lcd_cnt <= 9'b000110100;
			else
				lcd_cnt <= lcd_cnt + 1;
		end 
		 
	end
//	always @(posedge clk or posedge reset)
//	begin
//		if(reset == 1'b1)
//		begin
//			lcd_cnt <= 0; 
//		end 
//		else if(clk_1khz)
//		begin
//			if (lcd_cnt == 9'b001111010)
//			lcd_cnt <= 9'b000110100;
//			else
//			lcd_cnt <= lcd_cnt + 1;
//		end 
//	end
	
	assign lcd_state = lcd_cnt[8:1];
	
	always @*
	begin
		case (lcd_state)
			// rw=0, rs=0
			8'h00	:	lcd_db = 8'b00111000;  // function set(8bit interface, 5*7 dot) -15ms delay
			8'h0A	:	lcd_db = 8'b00111000;	// function set(8bit interface, 5*7 dot) -4.1ms delay
			8'h12	:	lcd_db = 8'b00111000;	// function set(8bit interface, 5*7 dot) -100us delay
			
			8'h16	:	lcd_db = 8'b00111000;	// function set(8bit interface, 5*7 dot)
			8'h17	:	lcd_db = 8'b00001100;	// display on
			8'h18	:	lcd_db = 8'b00000001;	// clear display
			8'h19	:	lcd_db = 8'b00000110;	// entry mode set(increment address, no shift)
			
			// rw=0, rs=0
			8'h1A :	lcd_db = 8'b10000000;
			// rw=0, rs=1
			8'h1B	:	lcd_db = LCD_BLANK;
			8'h1C	:	lcd_db = LCD_BLANK;
			8'h1D	:	lcd_db = LCD_BLANK;
			8'h1E	:	lcd_db = LCD_L;			// [
			8'h1F	:	lcd_db = LCD_K;
			8'h20	:	lcd_db = LCD_E;
			8'h21	:	lcd_db = LCD_M;
			8'h22	:	lcd_db = LCD_B;
			8'h23	:	lcd_db = LCD_E;
			8'h24	:	lcd_db = LCD_D;
			8'h25	:	lcd_db = LCD_D;
			8'h26	:	lcd_db = LCD_E;
			8'h27	:	lcd_db = LCD_D;			// ]
			8'h28	:	lcd_db = LCD_BLANK;
			8'h29	:	lcd_db = LCD_BLANK;
			8'h2A	:	lcd_db = LCD_BLANK;
			
			// rw=0, rs=0
			8'h2B :	lcd_db = 8'b11000000;
			// rw=0, rs=1
//			8'h2C	: 	lcd_db = LCD_BLANK;
//			8'h2D	: 	lcd_db = LCD_BLANK;
//			8'h2E	: 	lcd_db = LCD_BLANK;
//			8'h2F	: 	lcd_db = LCD_C;
//			8'h30	: 	lcd_db = LCD_L;
//			8'h31	: 	lcd_db = LCD_C;
//			8'h32	: 	lcd_db = LCD_D;
//			8'h33	: 	lcd_db = LCD_BLANK;
//			8'h34	: 	lcd_db = LCD_T;
//			8'h35	: 	lcd_db = LCD_E;
//			8'h36	: 	lcd_db = LCD_S;
//			8'h37	: 	lcd_db = LCD_T;
//			8'h38	: 	lcd_db = LCD_BLANK;
//			8'h39	: 	lcd_db = LCD_BLANK;
//			8'h3A	: 	lcd_db = LCD_BLANK;
//			8'h3B	: 	lcd_db = LCD_BLANK;

			8'h2C	: 	lcd_db = LCD_D;
			8'h2D	: 	lcd_db = LCD_S_i;
			8'h2E	: 	lcd_db = LCD_S_s;
			8'h2F	: 	lcd_db = LCD_S_t;
			8'h30	: 	lcd_db = LCD_COLON;
			8'h31	: 	lcd_db = data_buffer2[1];
			8'h32	: 	lcd_db = data_buffer2[2];
			8'h33	: 	lcd_db = data_buffer2[3];
			8'h34	: 	lcd_db = data_buffer2[4];
			8'h35	: 	lcd_db = data_buffer2[5];
			8'h36	: 	lcd_db = data_buffer2[6];
			8'h37	: 	lcd_db = data_buffer2[7];
			8'h38	: 	lcd_db = data_buffer2[8];
			8'h39	: 	lcd_db = data_buffer2[9];
			8'h3A	: 	lcd_db = data_buffer2[10];
			8'h3B	: 	lcd_db = LCD_BLANK;
			default	:	lcd_db = 0;
		endcase
	end

	assign rs = ((lcd_state >= 8'h00 & lcd_state < 8'h1B) | lcd_state == 8'h2B) ? 0 : 1;
	assign en = !lcd_cnt[0];
	assign data = lcd_db;
	

function [7:0] ascii;
  input [4:0] hex;
  integer i;
  begin
		ascii = 0;
		if(hex <= 9)
			 ascii = hex + 8'h30; //10이하인 경우 + 0X30
		else
			 ascii = hex + 8'd55; // 이상인 경우에는 + 0X37
  end	
endfunction	
assign data_buffer2[0] = 8'd0;
assign data_buffer2[1] = ascii(bcd1[39:36]);
assign data_buffer2[2] = ascii(bcd1[35:32]);
assign data_buffer2[3] = ascii(bcd1[31:28]);
assign data_buffer2[4] = ascii(bcd1[27:24]);
assign data_buffer2[5] = ascii(bcd1[23:20]);
assign data_buffer2[6] = ascii(bcd1[19:16]);
assign data_buffer2[7] = ascii(bcd1[15:12]);
assign data_buffer2[8] = ascii(bcd1[11:8]);
assign data_buffer2[9] = ascii(bcd1[7:4]);
assign data_buffer2[10] = ascii(bcd1[3:0]);

hextobcd hextobcd0
(
	.hex(echo_cnt),
   .bcdout(bcd1)
);

endmodule

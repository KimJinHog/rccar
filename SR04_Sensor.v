`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:02 12/16/2014 
// Design Name: 
// Module Name:    SR04_Sensor 
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
module SR04_Sensor(
	input clk,   
	input reset,	 
	output reg UltraSonic_OutPulse,
	input UltraSonic_InPulse,
	output reg [31:0]echo_cnt
    );

//assign UltraSonic_OutPulse = 1'b1;
reg [3:0]trigger_state = 4'd5;
reg [31:0]trigger_cnt = 0;
reg [31:0]timeout_cnt = 0;
reg [31:0]reset_cnt = 0;
//reg [31:0]echo_cnt = 0;
always@(posedge clk)
begin
		case(trigger_state)
		5:
		begin
			if(reset_cnt == 32'd50000)
			begin
				trigger_state <= 4'd0;
				trigger_cnt <= 32'd0;
				UltraSonic_OutPulse <= 1'b0;
			end
			else reset_cnt <= reset_cnt + 1'b1;
		end
		0:
			begin
			trigger_state <= 4'd1;
			UltraSonic_OutPulse <= 1'b1;
			end 
		1:
			begin
				if(trigger_cnt >= 32'd500)
				begin
					UltraSonic_OutPulse <= 1'b0;
					trigger_cnt <= 32'd0;
					trigger_state <= 4'd3;
				end 
				else trigger_cnt <= trigger_cnt + 1'b1;
			end
//		2:
//		begin
//				if(trigger_cnt >= 32'd5000000)
//				begin
//					trigger_state <= 4'd3;
//					trigger_cnt <= 32'd0;
//				end 
//				else trigger_cnt <= trigger_cnt + 1'b1;
//		end
		3:
		begin
			if(tick_r)
			begin
				trigger_state <= 4'd4;
			end 
			else if(trigger_cnt >= 32'd100000000)
				begin
					trigger_state <= 4'd0;
					trigger_cnt <= 32'd0;
				end 
			else trigger_cnt <= trigger_cnt + 1'b1;
			 
		end 
		4:
		begin
			if(trigger_cnt >= 32'd1000000)
				begin
					trigger_state <= 4'd0;
					trigger_cnt <= 32'd0;
				end 
			else trigger_cnt <= trigger_cnt + 1'b1;
		end 
		endcase 
end

reg [3:0]echo_state = 4'd3;
reg [31:0]echo_trigger_cnt = 0;
reg [31:0]reset2_cnt = 0;
always@(posedge clk)
begin
		case(echo_state)
		3:
		begin
			if(reset2_cnt == 32'd50000)
			begin
				echo_state <= 4'd0;
				echo_trigger_cnt <= 31'd0;
			end
			else reset2_cnt <= reset2_cnt + 1'b1;
		end 
		0:
			begin
				if(UltraSonic_InPulse)
				begin
					echo_state <= 4'd1;
				end 
			end
		1:
		begin
				if(!UltraSonic_InPulse)
			begin
				echo_state <= 4'd2;
				echo_cnt <= echo_trigger_cnt;
			end 
			else echo_trigger_cnt <= echo_trigger_cnt + 1'b1;
		end 
		2:
		begin
			echo_state <= 4'd0;
			echo_trigger_cnt <= 32'd0;
		end 
		endcase 
end	
wire tick;
reg tick_r=0;
assign tick = (echo_state== 4'd2)? 1'b1: 1'b0;
always@(posedge clk)
begin
if(reset)
tick_r <= 1'b0;
else 
tick_r <= tick;
end 

endmodule

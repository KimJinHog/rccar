`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:24 04/06/2022 
// Design Name: 
// Module Name:    DcMotor 
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
module DcMotor(
    input osc,
	 //input [31:0]echo_cnt,//
    output DCMotor_CCW_SIG,
    output DCMotor_CW_SIG
    );
reg [31:0] stop_cnt = 0;
reg DCMotor_CCW_SIG_r;
reg DCMotor_CW_SIG_r;
reg [27:0] cnt = 0;
reg [27:0] cnt1 = 0;
wire stop_flag;

reg [1:0]reset_cnt = 0;
reg reset = 1'b1;
always@(posedge osc)
begin
	if(reset==1'b1)
	begin
	reset_cnt <= reset_cnt + 1'b1;
	end 
   if(reset_cnt==2)
	begin
	reset <= 1'b0;
	end
end 

always@(posedge osc)
begin
	if(reset == 1'b1)
	begin
		DCMotor_CCW_SIG_r <=1'b1;
		DCMotor_CW_SIG_r <=1'b0;
	end

	else cnt <= cnt + 1'b1;
end 



assign stop_flag = (cnt1>32'd1000)? 1'b0: 1'b1; 
assign DCMotor_CCW_SIG=DCMotor_CCW_SIG_r&stop_flag;
assign DCMotor_CW_SIG=DCMotor_CW_SIG_r&stop_flag;

endmodule

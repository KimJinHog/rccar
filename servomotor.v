`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:55 05/05/2022 
// Design Name: 
// Module Name:    servomotor 
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
module servomotor(
	input osc,
	input [31:0]echo_cnt,
	output reg SERVOMotor_PWM_SIG
    );
reg [3:0]state2=0;
reg [31:0] cnt = 0;
reg [31:0] cnt2 = 0;
reg [31:0] cnt3 = 0;
reg [31:0] cnt4 = 0;
reg [27:0] cnt_time = 0;
reg h1 = 0;
reg h2 = 0;
wire stop_flag;
wire ontime_tick;
reg offtime_tick;
reg [1:0]reset_cnt = 0;
reg reset = 1'b1;
parameter T0 = 0, T1 = 1, T2 = 2;
parameter S0 = 0, S1 = 1, S2 = 2;
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

always@(posedge osc or posedge reset)
begin
	if(reset == 1'b1)
	begin
		cnt_time <= 32'd0;
		state2 <= T0;
	end
	else if(cnt_time == 28'd25000000000000000) //20ms 
	begin
		cnt_time <= 28'd0;
			if(echo_cnt<32'd350000)
			begin
			state2<=T1;
		 
			cnt2 <= cnt2 + 1'b1;
			cnt3 <= cnt3 + 1'b1;
			cnt4 <= cnt4 + 1'b1;
			h1<=1;
			end
			else  //echo cnt >>>>
				begin
				if(h1==0&&h2==0)
					begin
					state2<=T0;
					end
				else if(h1==1&&h2==0)
					begin
					state2<=T2;
					cnt2<= cnt2 - 1'b1;
					cnt3 <= cnt3 - 1'b1;
						if(cnt2==0&&cnt3==0)
							begin
							h1<=1;
							h2<=1;
							end
					end
				else if(h1==1&&h2==1)
					begin
					state2<=T1;
					cnt4<= cnt4 - 1'b1;
						if(cnt4==0)
							begin
							h1<=0;
							h2<=0;
							end		
					end
				end
	end 
	else cnt_time <= cnt_time + 1'b1;
end 



always@(posedge osc or posedge reset)
begin
	if(reset == 1'b1)
	begin
		cnt <= 32'd0;
	end
	else if(cnt == 32'd1000000) //20ms 
	begin
		cnt <= 32'd0; 
	end 
	else cnt <= cnt + 1'b1;
end 



assign ontime_tick = (cnt == 32'd0)? 1'b1:1'b0;
//assign offtime_tick = (cnt == 32'd100000)? 1'b1:1'b0;
always@(*)
begin
	case(state2)
	T0:
	begin
		if(cnt == 32'd30500) //2.3ms     default 각도 12시
		begin
			offtime_tick = 1;
		end 
		else offtime_tick = 0;
	end
	T1:
	begin
		if(cnt == 32'd24500)//0.65ms  32500  방향각도   5시
		begin
			offtime_tick = 1;
		end 
		else offtime_tick = 0;
	end
	T2:
	begin
		if(cnt == 32'd37000)//
		begin
			offtime_tick = 1;
		end 
		else offtime_tick = 0;
	end
	
	
	default offtime_tick = 0;
	endcase

end 

reg[2:0]state=0;
always@(posedge osc)
begin
if(reset)
begin
	SERVOMotor_PWM_SIG <= 1'b0;
	state <= 3'd0;
end
else 
begin
	case(state)
	S0:begin
			 SERVOMotor_PWM_SIG <= 1'b0;
			 state <= S1;
	end 
	S1:
	begin 
			if(ontime_tick)
			begin
				SERVOMotor_PWM_SIG <= 1'b1;
				state <= S2;
			end 
	end 
	S2: begin
			if(offtime_tick)
				
			begin
				SERVOMotor_PWM_SIG <= 1'b0;
				state <= S1;
			end 
	end 
	endcase
end 
end 





endmodule

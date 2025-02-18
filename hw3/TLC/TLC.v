`include "Traffic_time.v"
`include "Counter.v"
module TLC(clk, reset, HG, HY, HL, HR, VG, VY, VL, VR);
input	clk, reset;
output 	HG, HY, HL, HR, VG, VY, VL, VR;
wire	[5:0] count;
reg	[2:0] state;
reg	[2:0] next_state;
reg	reset_counter;
wire	en, sel;

assign en = 1;
assign sel = 0;

Counter Counter_1(.clk(clk), .reset(reset_counter), .en(en), .sel(sel), .out(count));

parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
assign HG = (state==S0);
assign HY = (state==S1);
assign HL = (state==S2);
assign HR = ((state==S3)||(state==S4)||(state==S5));
assign VG = (state==S3);
assign VY = (state==S4);
assign VL = (state==S5);
assign VR = ((state==S0)||(state==S1)||(state==S2));

initial begin 
	state = S0;
	next_state = S0;
	reset_counter = 1;
end

always @ (posedge clk or posedge reset)
	if(reset)
	begin
		state <= S0;
		reset_counter <= 1;
	end
	else
	begin
		state <= next_state;
		reset_counter <= 0;
	end

always @ (posedge clk)
	case(state)
	S0:
	if(count == `G_TIME)
	begin
		next_state = S1;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	S1:
	if(count == `Y_TIME)
	begin
		next_state = S2;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	S2:
	if(count == `L_TIME)
	begin
		next_state = S3;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	S3:
	if(count == `G_TIME)
	begin
		next_state = S4;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	S4:
	if(count == `Y_TIME)
	begin
		next_state = S5;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	S5:
	if(count == `L_TIME)
	begin
		next_state = S0;
		reset_counter = 1;
	end
	else
	begin
		reset_counter = 0;
	end
	endcase
endmodule
module TLC
(
    input reset, clk,
    output reg Horizontal_Green, Horizontal_Yellow, Horizontal_Left, Horizontal_Red, Vertical_Green, Vertical_Yellow, Vertical_Left, Vertical_Red
); 

    parameter Idle = 3'b000, HG_st = 3'b001, HY_st = 3'b010, HL_st = 3'b011, VG_st = 3'b100, VY_st = 3'b101, VL_st = 3'b110;
    parameter Green_time = 5'd30, Yellow_time = 5'd05, Left_time = 5'd10;
    reg [2:0] state, nx_state;
    reg [4:0] count; 

// next_state logic
always @(state or count) 
begin 
    case (state) 
    Idle: nx_state = HG_st;
    HG_st:
	begin 
        if (count == Green_time)
            nx_state = HY_st;
        else 
            nx_state = HG_st;
        end
    HY_st:
	begin 
        if (count == Yellow_time)
            nx_state = HL_st;
        else 
            nx_state = HY_st;
        end
    HL_st:
	begin 
        if (count == Left_time)
            nx_state = VG_st;
        else 
            nx_state = HL_st;
        end
    VG_st:
	begin 
        if (count == Green_time)
            nx_state = VY_st;
        else 
            nx_state = VG_st;
        end
    VY_st:
	begin 
        if (count == Yellow_time)
            nx_state = VL_st;
        else 
            nx_state = VY_st;
        end
    VL_st:
	begin 
        if (count == Left_time)
            nx_state = HG_st;
        else 
            nx_state = VL_st;
        end
    default: nx_state = HG_st;
    endcase 
end 

// state reg
always @ (posedge clk or posedge reset)
begin
    if (reset) 
        state <= Idle; 
    else 
        state <= nx_state; 
end

 // count
always @ (posedge clk or posedge reset) begin 
    if (reset) 
        count <=  5'h00; 
    else if (((state == HG_st) & (count == Green_time)) | ((state == HY_st) & (count == Yellow_time)) | ((state == HL_st) & (count == Left_time)) | 
((state == VG_st) & (count == Green_time)) | ((state == VY_st) & (count == Yellow_time)) | ((state == VL_st) & (count == Left_time))) 
        count <=  5'h00; 
    else 
        count <= count + 1'b1; 
end 


//output logic
always @(state) begin
    case(state)
    Idle:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd0;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd0;
    end
    HG_st:
    begin
	Horizontal_Green = 1'd1;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd0;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd1;
    end
    HY_st:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd1;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd0;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd1;
    end
    HL_st:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd1;
	Horizontal_Red = 1'd0;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd1;
    end
    VG_st:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd1;
	Vertical_Green = 1'd1;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd0;
    end
    VY_st:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd1;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd1;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd0;
    end
    VL_st:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd1;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd1;
	Vertical_Red = 1'd0;
    end
    default:
    begin
	Horizontal_Green = 1'd0;
	Horizontal_Yellow = 1'd0;
	Horizontal_Left = 1'd0;
	Horizontal_Red = 1'd0;
	Vertical_Green = 1'd0;
	Vertical_Yellow = 1'd0;
	Vertical_Left = 1'd0;
	Vertical_Red = 1'd0;
    end
    endcase
end

endmodule
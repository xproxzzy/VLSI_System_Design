module AS(Out, In_1, In_2, Sel);
input        [29:0] In_1;
input        [29:0] In_2;
input        Sel;
output reg   [30:0] Out;
wire         [30:0] Sel_31;
wire         [29:0] c;
wire         [30:0] In_1_31;
wire         [30:0] In_2_31;

assign In_1_31[29:0] = In_1[29:0];
assign In_1_31[30] = In_1[29];
assign In_2_31[29:0] = In_2[29:0];
assign In_2_31[30] = In_2[29];

always @(*) begin
	if(Sel == 0)
		Out=In_1_31+In_2_31;
	else
		Out=In_1_31-In_2_31;
end
  
endmodule
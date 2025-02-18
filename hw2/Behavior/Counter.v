module Counter(clk, reset, en, sel, out);
input        clk, reset, en, sel;
output reg   [5:0] out;

always @(posedge clk)
begin
	if(reset)
	begin
		out <= 0;
	end
	else if(en)
	begin
		if(sel)
		begin
			if(out==0)
			begin
				out <= out;
			end
			else
			begin
				out <= out - 1;
			end
		end
		else
		begin
			if(out==32)
			begin
				out <= out;
			end
			else
			begin
				out <= out + 1;
			end;
		end
	end
	else
	begin
		out <= out;
	end
end
  
endmodule
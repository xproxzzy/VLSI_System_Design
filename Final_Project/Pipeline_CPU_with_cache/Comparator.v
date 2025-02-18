
module Comparator(Tag1,Tag2,Match);


input [5:0] Tag1,Tag2;
output Match;

reg Match;

always @(*) begin
  if(Tag1==Tag2)
    Match=1'b1;
  else 
    Match=1'b0;
end

endmodule 

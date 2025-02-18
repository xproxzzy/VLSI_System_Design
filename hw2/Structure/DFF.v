`include "D_latch.v"
module DFF(clk, D, Q);
input        clk;
input        D;
output       Q;
wire         Q1;

D_latch D_latch_1(.E(~clk), .D(D), .Q(Q1));
D_latch D_latch_2(.E(clk), .D(Q1), .Q(Q));

endmodule
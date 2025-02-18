module D_latch(E, D, Q);
input        E;
input        D;
output       Q;
wire	     w1, w2, w3;

nand (w1, D, E);
nand (w2, E, ~D);
nand (Q, w1, w3);
nand (w3, Q, w2);

endmodule
`include "DFF.v"
module Counter(clk, reset, en, sel, out);
input	clk, reset, en, sel;
output 	[5:0] out;
wire	[63:0] min;
wire	[5:0] next_out;
wire	[2:0] a;
wire	[4:0] b;
wire	[4:0] c;
wire	[4:0] d;
wire	[4:0] e;
wire	[4:0] f;

and (min[0], ~out[5], ~out[4], ~out[3], ~out[2], ~out[1], ~out[0]);
and (min[1], ~out[5], ~out[4], ~out[3], ~out[2], ~out[1], out[0]);
and (min[2], ~out[5], ~out[4], ~out[3], ~out[2], out[1], ~out[0]);
and (min[3], ~out[5], ~out[4], ~out[3], ~out[2], out[1], out[0]);
and (min[4], ~out[5], ~out[4], ~out[3], out[2], ~out[1], ~out[0]);
and (min[5], ~out[5], ~out[4], ~out[3], out[2], ~out[1], out[0]);
and (min[6], ~out[5], ~out[4], ~out[3], out[2], out[1], ~out[0]);
and (min[7], ~out[5], ~out[4], ~out[3], out[2], out[1], out[0]);
and (min[8], ~out[5], ~out[4], out[3], ~out[2], ~out[1], ~out[0]);
and (min[9], ~out[5], ~out[4], out[3], ~out[2], ~out[1], out[0]);
and (min[10], ~out[5], ~out[4], out[3], ~out[2], out[1], ~out[0]);
and (min[11], ~out[5], ~out[4], out[3], ~out[2], out[1], out[0]);
and (min[12], ~out[5], ~out[4], out[3], out[2], ~out[1], ~out[0]);
and (min[13], ~out[5], ~out[4], out[3], out[2], ~out[1], out[0]);
and (min[14], ~out[5], ~out[4], out[3], out[2], out[1], ~out[0]);
and (min[15], ~out[5], ~out[4], out[3], out[2], out[1], out[0]);
and (min[16], ~out[5], out[4], ~out[3], ~out[2], ~out[1], ~out[0]);
and (min[17], ~out[5], out[4], ~out[3], ~out[2], ~out[1], out[0]);
and (min[18], ~out[5], out[4], ~out[3], ~out[2], out[1], ~out[0]);
and (min[19], ~out[5], out[4], ~out[3], ~out[2], out[1], out[0]);
and (min[20], ~out[5], out[4], ~out[3], out[2], ~out[1], ~out[0]);
and (min[21], ~out[5], out[4], ~out[3], out[2], ~out[1], out[0]);
and (min[22], ~out[5], out[4], ~out[3], out[2], out[1], ~out[0]);
and (min[23], ~out[5], out[4], ~out[3], out[2], out[1], out[0]);
and (min[24], ~out[5], out[4], out[3], ~out[2], ~out[1], ~out[0]);
and (min[25], ~out[5], out[4], out[3], ~out[2], ~out[1], out[0]);
and (min[26], ~out[5], out[4], out[3], ~out[2], out[1], ~out[0]);
and (min[27], ~out[5], out[4], out[3], ~out[2], out[1], out[0]);
and (min[28], ~out[5], out[4], out[3], out[2], ~out[1], ~out[0]);
and (min[29], ~out[5], out[4], out[3], out[2], ~out[1], out[0]);
and (min[30], ~out[5], out[4], out[3], out[2], out[1], ~out[0]);
and (min[31], ~out[5], out[4], out[3], out[2], out[1], out[0]);
and (min[32], out[5], ~out[4], ~out[3], ~out[2], ~out[1], ~out[0]);

//next_out[5] a
or (a[0], min[31], min[32]);
and (a[1], ~reset, en, ~sel, a[0]);
and (a[2], ~reset, ~en, out[5]);
or (next_out[5], a[1], a[2]);

//next_out[4] b
or (b[0], min[15], min[16], min[17], min[18], min[19], min[20], min[21], min[22], min[23], min[24], min[25], min[26], min[27], min[28], min[29], min[30]);
or (b[1], min[17], min[18], min[19], min[20], min[21], min[22], min[23], min[24], min[25], min[26], min[27], min[28], min[29], min[30], min[31], min[32]);
and (b[2], ~reset, en, ~sel, b[0]);
and (b[3], ~reset, en, sel, b[1]);
and (b[4], ~reset, ~en, out[4]);
or (next_out[4], b[2], b[3], b[4]);

//next_out[3] c
or (c[0], min[7], min[8], min[9], min[10], min[11], min[12], min[13], min[14], min[23], min[24], min[25], min[26], min[27], min[28], min[29], min[30]);
or (c[1], min[9], min[10], min[11], min[12], min[13], min[14], min[15], min[16], min[25], min[26], min[27], min[28], min[29], min[30], min[31], min[32]);
and (c[2], ~reset, en, ~sel, c[0]);
and (c[3], ~reset, en, sel, c[1]);
and (c[4], ~reset, ~en, out[3]);
or (next_out[3], c[2], c[3], c[4]);

//next_out[2] d
or (d[0], min[3], min[4], min[5], min[6], min[11], min[12], min[13], min[14], min[19], min[20], min[21], min[22], min[27], min[28], min[29], min[30]);
or (d[1], min[5], min[6], min[7], min[8], min[13], min[14], min[15], min[16], min[21], min[22], min[23], min[24], min[29], min[30], min[31], min[32]);
and (d[2], ~reset, en, ~sel, d[0]);
and (d[3], ~reset, en, sel, d[1]);
and (d[4], ~reset, ~en, out[2]);
or (next_out[2], d[2], d[3], d[4]);

//next_out[1] e
or (e[0], min[1], min[2], min[5], min[6], min[9], min[10], min[13], min[14], min[17], min[18], min[21], min[22], min[25], min[26], min[29], min[30]);
or (e[1], min[3], min[4], min[7], min[8], min[11], min[12], min[15], min[16], min[19], min[20], min[23], min[24], min[27], min[28], min[31], min[32]);
and (e[2], ~reset, en, ~sel, e[0]);
and (e[3], ~reset, en, sel, e[1]);
and (e[4], ~reset, ~en, out[1]);
or (next_out[1], e[2], e[3], e[4]);

//next_out[0] f
or (f[0], min[0], min[2], min[4], min[6], min[8], min[10], min[12], min[14], min[16], min[18], min[20], min[22], min[24], min[26], min[28], min[30]);
or (f[1], min[2], min[4], min[6], min[8], min[10], min[12], min[14], min[16], min[18], min[20], min[22], min[24], min[26], min[28], min[30], min[32]);
and (f[2], ~reset, en, ~sel, f[0]);
and (f[3], ~reset, en, sel, f[1]);
and (f[4], ~reset, ~en, out[0]);
or (next_out[0], f[2], f[3], f[4]);

DFF DFF_5(.clk(clk), .D(next_out[5]), .Q(out[5]));
DFF DFF_4(.clk(clk), .D(next_out[4]), .Q(out[4]));
DFF DFF_3(.clk(clk), .D(next_out[3]), .Q(out[3]));
DFF DFF_2(.clk(clk), .D(next_out[2]), .Q(out[2]));
DFF DFF_1(.clk(clk), .D(next_out[1]), .Q(out[1]));
DFF DFF_0(.clk(clk), .D(next_out[0]), .Q(out[0]));

endmodule
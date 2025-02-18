`timescale 1ns/1ps
`include "Memory.v"

`ifdef syn
	`include "CPU_syn.v"
	`include "tsmc18.v"
`else
	`include "CPU.v"
`endif

module  testbench;
parameter clk_duty = 20;

reg clk, rst;

always #clk_duty clk = ~clk;

wire m_rw_;
wire [11:0] pc, m_addr;
wire [31:0] ir, write_data, read_data;

Memory MEM(.clk(clk), .pc(pc), .ir(ir), .write_data(write_data), .read_data(read_data), .m_addr(m_addr), .m_rw_(m_rw_));
CPU CPU(.clk(clk), .rst(rst), .pc(pc), .ir(ir), .halt(halt), .write_data(write_data), .read_data(read_data), .m_addr(m_addr), .m_rw_(m_rw_));

`ifdef syn
	initial $sdf_annotate ("CPU_syn.sdf", CPU);
`endif

initial begin
    $readmemb("./data.prog",MEM.DataMEM);
end
initial begin
    $readmemb("./sisc.prog",MEM.InstructionMEM);
end

initial
begin
	clk = 1'b0;
	rst = 1'b1;
end

initial #100 rst = 1'b0;

always @(*)
begin
if (halt) begin 
        $display("Halt ... ");
        #1
	$finish ;
end
end

initial begin
	$dumpfile("CPU.fsdb");
	$dumpvars;
end

//initial begin
//	$fsdbDumpfile("CPU.fsdb");
//	$fsdbDumpvars;
//end

endmodule
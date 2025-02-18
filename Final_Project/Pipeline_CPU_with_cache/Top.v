`include "Adder.v"
`include "ALU.v"
`include "Controller.v"
`include "Decoder.v"
`include "Imme_Ext.v"
`include "JB_Unit.v"
`include "LD_Filter.v"
`include "Mux2.v"
`include "Mux3.v"
`include "Reg_D.v"
`include "Reg_E.v"
`include "Reg_M.v"
`include "Reg_PC.v"
`include "Reg_W.v"
`include "RegFile.v"
`include "Cache.v"
//`include "SRAM.v"
//`include "SROM.v"

module Top (
    input clk,
    input rst,
    output halt,
    output M_dm_w_en,
    output pc_15_0,
    input inst,
    input CData,
    output SysAddress,
    output SysStrobe,
    output SysRW,
    output SysData
);
    wire [31:0] next_pc;
    wire [31:0] pc;
    wire [31:0] adder_out;
    wire [31:0] inst;
    wire [31:0] D_pc;
    wire [31:0] D_inst;
    wire [4:0] opcode_in;
    wire [2:0] func3_in;
    wire func7_in;
    wire [4:0] rs1_index;
    wire [4:0] rs2_index;
    wire [4:0] rd_index;
    wire [31:0] D_sext_imme;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] a0_data;
    wire [31:0] D_rs1_data;
    wire [31:0] D_rs2_data;
    wire [31:0] E_pc;
    wire [31:0] E_rs1_data;
    wire [31:0] E_rs2_data;
    wire [31:0] E_sext_imme;
    wire [31:0] newest_rs1_data;
    wire [31:0] newest_rs2_data;
    wire [31:0] mux2_1_out;
    wire [31:0] mux2_2_out;
    wire [31:0] mux2_3_out;
    wire [31:0] E_alu_out;
    wire [31:0] jb_pc;
    wire [31:0] M_alu_out;
    wire [31:0] M_rs2_data;
    wire [31:0] M_ld_data;
    wire [31:0] W_alu_out;
    wire [31:0] W_ld_data;
    wire [31:0] ld_data_f;
    wire [31:0] wb_data;
    wire stall;
    wire next_pc_sel;
    wire D_rs1_data_sel;
    wire D_rs2_data_sel;
    wire [1:0] E_rs1_data_sel;
    wire [1:0] E_rs2_data_sel;
    wire E_jb_op1_sel;
    wire E_alu_op1_sel;
    wire E_alu_op2_sel;
    wire [4:0] E_opcode;
    wire [2:0] E_func3;
    wire E_func7;
    wire [3:0] M_dm_w_en;
    wire W_wb_en;
    wire [4:0] W_rd_index;
    wire [2:0] W_func3;
    wire W_wb_data_sel;
    wire [15:0] M_alu_out_15_0;
    wire [15:0] pc_15_0;
    wire stop;
    wire PReady;
    wire PRW;
    wire Pstrobe;
    wire [31:0] SysData;
    wire [31:0] CData;
    wire [15:0] SysAddress;
    wire SysStrobe;
    wire SysRW;

    assign M_alu_out_15_0 = M_alu_out[15:0];
    assign pc_15_0 = pc[15:0];

    Reg_PC regpc (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .stop(stop),
        .next_pc(next_pc),
        .current_pc(pc)
    );

    Adder adder (
        .operand  (pc),
        .adder_out(adder_out)
    );

    Mux2 mux2_0 (
        .sel(next_pc_sel),
        .operand1(jb_pc),
        .operand0(adder_out),
        .mux_out(next_pc)
    );

    /*SROM im (
        .clk(clk),
        .address(pc[15:0]),
        .read_data(inst)
    );

    SRAM dm (
        .clk(clk),
        .w_en(M_dm_w_en),
        .address(M_alu_out[15:0]),
        .write_data(M_rs2_data),
        .read_data(M_ld_data)
    );*/

    Decoder decoder (
        .inst(D_inst),
        .dc_out_opcode(opcode_in),
        .dc_out_func3(func3_in),
        .dc_out_func7(func7_in),
        .dc_out_rs1_index(rs1_index),
        .dc_out_rs2_index(rs2_index),
        .dc_out_rd_index(rd_index)
    );

    Imme_Ext immext (
        .inst(D_inst),
        .imm_ext_out(D_sext_imme)
    );

    RegFile regfile (
        .clk(clk),
        .rst(rst),
        .wb_en(W_wb_en),
        .wb_data(wb_data),
        .rd_index(W_rd_index),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rs1_data_out(rs1_data),
        .rs2_data_out(rs2_data),
        .a0_data(a0_data)
    );

    Controller controller (
        .clk(clk),
        .rst(rst),
        .opcode_in(opcode_in),
        .func3_in(func3_in),
        .rd_index(rd_index),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .func7_in(func7_in),
        .alu_out(E_alu_out),
        .a0_data(a0_data),
        .stall(stall),
        .stop(stop),
        .PReady(PReady),
        .next_pc_sel(next_pc_sel),
        .D_rs1_data_sel(D_rs1_data_sel),
        .D_rs2_data_sel(D_rs2_data_sel),
        .E_rs1_data_sel(E_rs1_data_sel),
        .E_rs2_data_sel(E_rs2_data_sel),
        .E_jb_op1_sel(E_jb_op1_sel),
        .E_alu_op1_sel(E_alu_op1_sel),
        .E_alu_op2_sel(E_alu_op2_sel),
        .E_opcode(E_opcode),
        .E_func3(E_func3),
        .E_func7(E_func7),
        .M_dm_w_en(M_dm_w_en),
        .W_wb_en(W_wb_en),
        .W_rd_index(W_rd_index),
        .W_func3(W_func3),
        .W_wb_data_sel(W_wb_data_sel),
        .halt(halt),
        .PRW(PRW),
        .Pstrobe(Pstrobe)
    );

    Mux2 mux2_1 (
        .sel(E_alu_op1_sel),
        .operand1(newest_rs1_data),
        .operand0(E_pc),
        .mux_out(mux2_1_out)
    );

    Mux2 mux2_2 (
        .sel(E_alu_op2_sel),
        .operand1(newest_rs2_data),
        .operand0(E_sext_imme),
        .mux_out(mux2_2_out)
    );

    Mux2 mux2_3 (
        .sel(E_jb_op1_sel),
        .operand1(newest_rs1_data),
        .operand0(E_pc),
        .mux_out(mux2_3_out)
    );

    Mux2 mux2_4 (
        .sel(W_wb_data_sel),
        .operand1(W_alu_out),
        .operand0(ld_data_f),
        .mux_out(wb_data)
    );

    Mux2 mux2_5 (
        .sel(D_rs1_data_sel),
        .operand1(wb_data),
        .operand0(rs1_data),
        .mux_out(D_rs1_data)
    );

    Mux2 mux2_6 (
        .sel(D_rs2_data_sel),
        .operand1(wb_data),
        .operand0(rs2_data),
        .mux_out(D_rs2_data)
    );

    ALU alu (
        .opcode(E_opcode),
        .func3(E_func3),
        .func7(E_func7),
        .operand1(mux2_1_out),
        .operand2(mux2_2_out),
        .alu_out(E_alu_out)
    );

    JB_Unit jbunit (
        .operand1(mux2_3_out),
        .operand2(E_sext_imme),
        .jb_out  (jb_pc)
    );

    LD_Filter ldfilter (
        .func3(W_func3),
        .ld_data(W_ld_data),
        .ld_data_f(ld_data_f)
    );

    Mux3 mux3_1 (
        .sel(E_rs1_data_sel),
        .operand0(wb_data),
        .operand1(M_alu_out),
        .operand2(E_rs1_data),
        .mux_out(newest_rs1_data)
    );

    Mux3 mux3_2 (
        .sel(E_rs2_data_sel),
        .operand0(wb_data),
        .operand1(M_alu_out),
        .operand2(E_rs2_data),
        .mux_out(newest_rs2_data)
    );

    Reg_D regd (
        .clk(clk),
        .rst(rst),
        .stop(stop),
        .stall(stall),
        .jb(next_pc_sel),
        .next_pc(pc),
        .next_inst(inst),
        .current_pc(D_pc),
        .current_inst(D_inst)
    );

    Reg_E rege (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .jb(next_pc_sel),
        .stop(stop),
        .PReady(PReady),
        .next_pc(D_pc),
        .next_rs1_data(D_rs1_data),
        .next_rs2_data(D_rs2_data),
        .next_sext_imm(D_sext_imme),
        .current_pc(E_pc),
        .current_rs1_data(E_rs1_data),
        .current_rs2_data(E_rs2_data),
        .current_sext_imm(E_sext_imme)
    );

    Reg_M regm (
        .clk(clk),
        .rst(rst),
        .stop(stop),
        .stall(stall),
        .PReady(PReady),
        .next_alu_out(E_alu_out),
        .next_rs2_data(newest_rs2_data),
        .current_alu_out(M_alu_out),
        .current_rs2_data(M_rs2_data)
    );

    Reg_W regw (
        .clk(clk),
        .rst(rst),
        .stop(stop),
        .stall(stall),
        .PReady(PReady),
        .next_alu_out(M_alu_out),
        .next_ld_data(M_ld_data),
        .current_alu_out(W_alu_out),
        .current_ld_data(W_ld_data)
    );
    
    cache c1(
             .Pstrobe(Pstrobe), .PAddress(M_alu_out_15_0),
             .PData(M_rs2_data), .PRW(PRW), .PReady(PReady),
             .SysStrobe(SysStrobe), .SysAddress(SysAddress),
             .SysData(SysData), .SysRW(SysRW),
             .reset(rst), .clk(clk),
             .OutData(M_ld_data),
             .CData(CData)
    );

endmodule

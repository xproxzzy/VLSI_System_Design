module Controller (
    input clk,
    input rst,
    input [4:0] opcode_in,
    input [2:0] func3_in,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    input func7_in,
    input [31:0] alu_out,
    input [31:0] a0_data,
    output reg stall,
    output reg next_pc_sel,
    output reg D_rs1_data_sel,
    output reg D_rs2_data_sel,
    output reg [1:0] E_rs1_data_sel,
    output reg [1:0] E_rs2_data_sel,
    output reg E_jb_op1_sel,
    output reg E_alu_op1_sel,
    output reg E_alu_op2_sel,
    output reg [4:0] E_opcode,
    output reg [2:0] E_func3,
    output reg E_func7,
    output reg [3:0] M_dm_w_en,
    output reg W_wb_en,
    output reg [4:0] W_rd_index,
    output reg [2:0] W_func3,
    output reg W_wb_data_sel,
    output reg halt
);

    `define LUI 5'b01101
    `define AUIPC 5'b00101
    `define JAL 5'b11011
    `define JALR 5'b11001
    `define BRANCH 5'b11000
    `define LOAD 5'b00000
    `define STORE 5'b01000
    `define OP_IMM 5'b00100
    `define OP 5'b01100
    `define ECALL 5'b11100

    reg [4:0] E_op;
    reg [2:0] E_f3;
    reg [4:0] E_rd;
    reg [4:0] E_rs1;
    reg [4:0] E_rs2;
    reg E_f7;
    reg [31:0] E_a0_data;
    reg [4:0] M_op;
    reg [2:0] M_f3;
    reg [4:0] M_rd;
    reg [31:0] M_a0_data;
    reg [4:0] W_op;
    reg [2:0] W_f3;
    reg [4:0] W_rd;
    reg [31:0] W_a0_data;



    always @(posedge clk or posedge rst) begin
        if (rst) begin
            E_op        <= 5'b0;
            E_f3        <= 3'b0;
            E_rd        <= 5'b0;
            E_rs1       <= 5'b0;
            E_rs2       <= 5'b0;
            E_f7        <= 1'b0;
            E_a0_data   <= 32'b0;
            M_op        <= 5'b0;
            M_f3        <= 3'b0;
            M_rd        <= 5'b0;
            M_a0_data   <= 32'b0;
            W_op        <= 5'b0;
            W_f3        <= 3'b0;
            W_rd        <= 5'b0;
            W_a0_data   <= 32'b0;
        end else if (stall) begin
            E_op        <= `OP_IMM; // `OP_IMM
            E_f3        <= 3'b000;
            E_rd        <= 5'b00000;
            E_rs1       <= 5'b00000;
            E_rs2       <= 5'b00000;
            E_f7        <= 1'b0;
            E_a0_data   <= 32'b0;
            M_op        <= E_op;
            M_f3        <= E_f3;
            M_rd        <= E_rd;
            M_a0_data   <= E_a0_data;
            W_op        <= M_op;
            W_f3        <= M_f3;
            W_rd        <= M_rd;
            W_a0_data   <= M_a0_data;
        end else if (next_pc_sel) begin
            E_op        <= `OP_IMM; // `OP_IMM
            E_f3        <= 3'b000;
            E_rd        <= 5'b00000;
            E_rs1       <= 5'b00000;
            E_rs2       <= 5'b00000;
            E_f7        <= 1'b0;
            E_a0_data   <= 32'b0;
            M_op        <= E_op;
            M_f3        <= E_f3;
            M_rd        <= E_rd;
            M_a0_data   <= E_a0_data;
            W_op        <= M_op;
            W_f3        <= M_f3;
            W_rd        <= M_rd;
            W_a0_data   <= M_a0_data;
        end else begin
            E_op        <= opcode_in;
            E_f3        <= func3_in;
            E_rd        <= rd_index;
            E_rs1       <= rs1_index;
            E_rs2       <= rs2_index;
            E_f7        <= func7_in;
            E_a0_data   <= a0_data;
            M_op        <= E_op;
            M_f3        <= E_f3;
            M_rd        <= E_rd;
            M_a0_data   <= E_a0_data;
            W_op        <= M_op;
            W_f3        <= M_f3;
            W_rd        <= M_rd;
            W_a0_data   <= M_a0_data;
        end
    end

    reg is_D_use_rs1;
    reg is_D_use_rs2;
    reg is_DE_overlap;
    reg is_D_rs1_E_rd_overlap;
    reg is_D_rs2_E_rd_overlap;

    always @(*) begin
        if ((opcode_in == `LUI) | (opcode_in == `AUIPC) | (opcode_in == `JAL)) begin
            is_D_use_rs1 = 1'b0;
        end else begin
            is_D_use_rs1 = 1'b1;
        end
    end

    always @(*) begin
        if ((opcode_in == `BRANCH) | (opcode_in == `STORE) | (opcode_in == `OP)) begin
            is_D_use_rs2 = 1'b1;
        end else begin
            is_D_use_rs2 = 1'b0;
        end
    end

    always @(*) begin
        is_D_rs1_E_rd_overlap = (is_D_use_rs1 & (rs1_index == E_rd) & (E_rd != 0));
        is_D_rs2_E_rd_overlap = (is_D_use_rs2 & (rs2_index == E_rd) & (E_rd != 0));
        is_DE_overlap = (is_D_rs1_E_rd_overlap | is_D_rs2_E_rd_overlap);
        stall = ((E_op == `LOAD) & is_DE_overlap);
    end

    always @(*) begin
        if (E_op == `JAL) begin
            next_pc_sel = 1'b1;
        end else if (E_op == `JALR) begin
            next_pc_sel = 1'b1;
        end else if (E_op == `BRANCH) begin
            if (alu_out[0] == 1) begin
                next_pc_sel = 1'b1;
            end else begin
                next_pc_sel = 1'b0;
            end
        end else begin
            next_pc_sel = 1'b0;
        end
    end

    reg is_D_rs1_W_rd_overlap;
    reg is_D_rs2_W_rd_overlap;
    reg is_W_use_rd;

    always @(*) begin
        if ((W_op == `BRANCH) | (W_op == `STORE)) begin
            is_W_use_rd = 1'b0;
        end else begin
            is_W_use_rd = 1'b1;
        end
    end

    always @(*) begin
        is_D_rs1_W_rd_overlap = is_D_use_rs1 & is_W_use_rd & (rs1_index == W_rd) & (W_rd != 0);
        is_D_rs2_W_rd_overlap = is_D_use_rs2 & is_W_use_rd & (rs2_index == W_rd) & (W_rd != 0);
    end

    always @(*) begin
        if (is_D_rs1_W_rd_overlap) begin
            D_rs1_data_sel = 1'd1;
        end else begin
            D_rs1_data_sel = 1'd0;
        end
    end

    always @(*) begin
        if (is_D_rs2_W_rd_overlap) begin
            D_rs2_data_sel = 1'd1;
        end else begin
            D_rs2_data_sel = 1'd0;
        end
    end

    reg is_E_rs1_W_rd_overlap;
    reg is_E_rs1_M_rd_overlap;
    reg is_E_rs2_W_rd_overlap;
    reg is_E_rs2_M_rd_overlap;
    reg is_E_use_rs1;
    reg is_E_use_rs2;
    reg is_M_use_rd;

    always @(*) begin
        if ((E_op == `LUI) | (E_op == `AUIPC) | (E_op == `JAL)) begin
            is_E_use_rs1 = 1'b0;
        end else begin
            is_E_use_rs1 = 1'b1;
        end
    end

    always @(*) begin
        if ((E_op == `BRANCH) | (E_op == `STORE) | (E_op == `OP)) begin
            is_E_use_rs2 = 1'b1;
        end else begin
            is_E_use_rs2 = 1'b0;
        end
    end

    always @(*) begin
        if ((M_op == `BRANCH) | (M_op == `STORE)) begin
            is_M_use_rd = 1'b0;
        end else begin
            is_M_use_rd = 1'b1;
        end
    end

    always @(*) begin
        is_E_rs1_W_rd_overlap = is_E_use_rs1 & is_W_use_rd & (E_rs1 == W_rd) & (W_rd != 0);
        is_E_rs1_M_rd_overlap = is_E_use_rs1 & is_M_use_rd & (E_rs1 == M_rd) & (M_rd != 0);
        is_E_rs2_W_rd_overlap = is_E_use_rs2 & is_W_use_rd & (E_rs2 == W_rd) & (W_rd != 0);
        is_E_rs2_M_rd_overlap = is_E_use_rs2 & is_M_use_rd & (E_rs2 == M_rd) & (M_rd != 0);
    end

    always @(*) begin
        if (is_E_rs1_M_rd_overlap) begin
            E_rs1_data_sel = 2'd1;
        end else begin
            if (is_E_rs1_W_rd_overlap) begin
                E_rs1_data_sel = 2'd0;
            end else begin
                E_rs1_data_sel = 2'd2;
            end
        end
    end

    always @(*) begin
        if (is_E_rs2_M_rd_overlap) begin
            E_rs2_data_sel = 2'd1;
        end else begin
            if (is_E_rs2_W_rd_overlap) begin
                E_rs2_data_sel = 2'd0;
            end else begin
                E_rs2_data_sel = 2'd2;
            end
        end
    end

    always @(*) begin
        E_opcode = E_op;
        E_func3  = E_f3;
        E_func7  = E_f7;
    end

    always @(*) begin
        case (E_op)
            `OP:
            begin
                E_alu_op1_sel = 1'b1;
                E_alu_op2_sel = 1'b1;
            end
            `OP_IMM:
            begin
                E_alu_op1_sel = 1'b1;
                E_alu_op2_sel = 1'b0;
            end
            `LUI:
            begin
                E_alu_op2_sel = 1'b0;
            end
            `AUIPC:
            begin
                E_alu_op1_sel = 1'b0;
                E_alu_op2_sel = 1'b0;
            end
            `LOAD:
            begin
                E_alu_op1_sel = 1'b1;
                E_alu_op2_sel = 1'b0;
            end
            `STORE:
            begin
                E_alu_op1_sel = 1'b1;
                E_alu_op2_sel = 1'b0;
            end
            `JAL:
            begin
                E_alu_op1_sel = 1'b0;
                E_jb_op1_sel  = 1'b0;
            end
            `JALR:
            begin
                E_alu_op1_sel = 1'b0;
                E_jb_op1_sel  = 1'b1;
            end
            `BRANCH:
            begin
                E_alu_op1_sel = 1'b1;
                E_alu_op2_sel = 1'b1;
                E_jb_op1_sel  = 1'b0;
            end
            default: begin
                E_alu_op1_sel = 1'b0;
                E_alu_op2_sel = 1'b0;
                E_jb_op1_sel  = 1'b0;
            end
        endcase
    end

    always @(*) begin
        if (M_op == `STORE) begin
            case (M_f3)
                3'b000:  M_dm_w_en = 4'b0001;
                3'b001:  M_dm_w_en = 4'b0011;
                3'b010:  M_dm_w_en = 4'b1111;
                default: M_dm_w_en = 4'b0000;
            endcase
        end else begin
            M_dm_w_en = 4'b0000;
        end
    end

    always @(*) begin
        W_func3 = W_f3;
        W_rd_index = W_rd;
    end

    always @(*) begin
        if (W_op == `LOAD) begin
            W_wb_data_sel = 1'b0;
        end else begin
            W_wb_data_sel = 1'b1;
        end
    end

    always @(*) begin
        if (W_op == `STORE) begin
            W_wb_en = 1'b0;
        end else if (W_op == `BRANCH) begin
            W_wb_en = 1'b0;
        end else begin
            W_wb_en = 1'b1;
        end
    end



    always @(*)begin
            if (rst) halt = 1'b0;
        else if (W_op == `ECALL && a0_data == 0 ) begin   //(W_op == `ECALL && W_a0_data == 0)
            halt = 1'b1;
        end
    end
endmodule

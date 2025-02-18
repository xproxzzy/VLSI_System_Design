module RegFile (
    input clk,
    input rst,
    input wb_en,
    input [31:0] wb_data,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] a0_data
);
    reg [31:0] registers[0:31];
	wire [31:0] a1;
	assign a1 = registers[11];
    always @(*) begin
        rs1_data_out = registers[rs1_index];
        rs2_data_out = registers[rs2_index];
        a0_data = registers[10];
    end


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0][31:0]  <= 32'b0;
            registers[1][31:0]  <= 32'b0;
            registers[2][31:0]  <= 32'h10000;
            registers[3][31:0]  <= 32'b0;
            registers[4][31:0]  <= 32'b0;
            registers[5][31:0]  <= 32'b0;
            registers[6][31:0]  <= 32'b0;
            registers[7][31:0]  <= 32'b0;
            registers[8][31:0]  <= 32'b0;
            registers[9][31:0]  <= 32'b0;
            registers[10][31:0] <= 32'b0;
            registers[11][31:0] <= 32'b0;
            registers[12][31:0] <= 32'b0;
            registers[13][31:0] <= 32'b0;
            registers[14][31:0] <= 32'b0;
            registers[15][31:0] <= 32'b0;
            registers[16][31:0] <= 32'b0;
            registers[17][31:0] <= 32'b0;
            registers[18][31:0] <= 32'b0;
            registers[19][31:0] <= 32'b0;
            registers[20][31:0] <= 32'b0;
            registers[21][31:0] <= 32'b0;
            registers[22][31:0] <= 32'b0;
            registers[23][31:0] <= 32'b0;
            registers[24][31:0] <= 32'b0;
            registers[25][31:0] <= 32'b0;
            registers[26][31:0] <= 32'b0;
            registers[27][31:0] <= 32'b0;
            registers[28][31:0] <= 32'b0;
            registers[29][31:0] <= 32'b0;
            registers[30][31:0] <= 32'b0;
            registers[31][31:0] <= 32'b0;
        end else begin
            if (wb_en) begin
                if (rd_index != 0) registers[rd_index][31:0] <= wb_data[31:0];
                else registers[rd_index][31:0] <= 32'b0;
            end
        end
    end
endmodule

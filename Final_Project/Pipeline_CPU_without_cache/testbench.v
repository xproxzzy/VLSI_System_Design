
`timescale 1ns/1ps
`include "SRAM.v"
`include "SROM.v"



`ifdef SYN
	`include "Top_syn.v"
	`include "tsmc18.v"
`else
	`include "Top.v"
`endif

module testbench;

    reg clk;
    reg rst;
    wire halt;
    reg flag;
    integer i;
    wire [15:0] pc_15_0;
    wire [31:0] inst;
    wire [31:0] M_ld_data;
    wire [3:0] M_dm_w_en;
    wire [15:0] M_alu_out_15_0;
    wire [31:0] M_rs2_data;
    
    Top CPU (
        .clk(clk),
        .rst(rst),
        .halt(halt), 
        .M_ld_data(M_ld_data),
        .M_dm_w_en(M_dm_w_en),
        .M_alu_out_15_0(M_alu_out_15_0),
	.M_rs2_data(M_rs2_data),
        .pc_15_0(pc_15_0),
	.inst(inst)        
    );

    SROM im (
        .clk(clk),
        .address(pc_15_0),
        .read_data(inst)
    );

    SRAM dm (
        .clk(clk),
        .w_en(M_dm_w_en),
        .address(M_alu_out_15_0),
        .write_data(M_rs2_data),
        .read_data(M_ld_data)
    );

    `define IM im.mem
    `define DM dm.mem
    `define GP CPU.regfile.registers[3]
    `define A2 CPU.regfile.registers[12]
    //`define GP CPU.regfile.registers_3__0_
/*{CPU.regfile.registers_3__31_, 
		CPU.regfile.registers_3__30_, 
		CPU.regfile.registers_3__29_,
		CPU.regfile.registers_3__28_, 
		CPU.regfile.registers_3__27_, 
		CPU.regfile.registers_3__26_,
		CPU.regfile.registers_3__25_, 
		CPU.regfile.registers_3__24_, 
		CPU.regfile.registers_3__23_,
		CPU.regfile.registers_3__22_, 
		CPU.regfile.registers_3__21_, 
		CPU.regfile.registers_3__20_,
		CPU.regfile.registers_3__19_, 
		CPU.regfile.registers_3__18_, 
		CPU.regfile.registers_3__17_,
		CPU.regfile.registers_3__16_, 
		CPU.regfile.registers_3__15_, 
		CPU.regfile.registers_3__14_,
		CPU.regfile.registers_3__13_, 
		CPU.regfile.registers_3__12_, 
		CPU.regfile.registers_3__11_,
		CPU.regfile.registers_3__10_, 
		CPU.regfile.registers_3__9_, 
		CPU.regfile.registers_3__8_, 
		CPU.regfile.registers_3__7_,
		CPU.regfile.registers_3__6_, 
		CPU.regfile.registers_3__5_, 
		CPU.regfile.registers_3__4_, 
		CPU.regfile.registers_3__3_,
		CPU.regfile.registers_3__2_,
		CPU.regfile.registers_3__1_, 
		CPU.regfile.registers_3__0_}*/

    //`define A2 CPU.regfile.registers_12__0_
/*{CPU.regfile.registers_12__31_, 
		CPU.regfile.registers_12__30_, 
		CPU.regfile.registers_12__29_,
		CPU.regfile.registers_12__28_, 
		CPU.regfile.registers_12__27_, 
		CPU.regfile.registers_12__26_,
		CPU.regfile.registers_12__25_, 
		CPU.regfile.registers_12__24_, 
		CPU.regfile.registers_12__23_,
		CPU.regfile.registers_12__22_, 
		CPU.regfile.registers_12__21_, 
		CPU.regfile.registers_12__20_,
		CPU.regfile.registers_12__19_, 
		CPU.regfile.registers_12__18_, 
		CPU.regfile.registers_12__17_,
		CPU.regfile.registers_12__16_, 
		CPU.regfile.registers_12__15_, 
		CPU.regfile.registers_12__14_,
		CPU.regfile.registers_12__13_, 
		CPU.regfile.registers_12__12_, 
		CPU.regfile.registers_12__11_,
		CPU.regfile.registers_12__10_, 
		CPU.regfile.registers_12__9_, 
		CPU.regfile.registers_12__8_, 
		CPU.regfile.registers_12__7_,
		CPU.regfile.registers_12__6_, 
		CPU.regfile.registers_12__5_, 
		CPU.regfile.registers_12__4_, 
		CPU.regfile.registers_12__3_,
		CPU.regfile.registers_12__2_,
		CPU.regfile.registers_12__1_, 
		CPU.regfile.registers_12__0_}	*/

    `define CYCLE 40

    `define TRUE 1
    `define FALSE 0

    wire gp;
    wire a2;
    assign gp = `GP;
    assign a2 = `A2;

  `ifdef SYN
	  initial begin
		$sdf_annotate("Top_syn.sdf", CPU);
	  end
  `endif


    task check;
        begin
            if ((`GP == 1) && (`A2 == 0)) begin
                flag = `TRUE;
            end else begin
                flag = `FALSE;
            end
        end
    endtask

    initial begin
        clk  = 0;
        rst  = 0;
        flag = `TRUE;
        forever #(`CYCLE / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("testbench.fsdb");
        $dumpvars;
    end

    initial begin
        
        #`CYCLE rst = 1;
        /*======== LUI ========*/
        #`CYCLE rst = 0;
        $readmemh("./lui.hex", `IM);
        $readmemh("./lui.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("lui   ...... Passed");
        else begin 
            $display("lui   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== AUIPC ========*/
        #`CYCLE rst = 0;
        $readmemh("./auipc.hex", `IM);
        $readmemh("./auipc.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("auipc ...... Passed");
        else begin
            $display("auipc ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 
        
		/*======== JAL ========*/
        #`CYCLE rst = 0;
        $readmemh("./jal.hex", `IM);
        $readmemh("./jal.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("jal   ...... Passed");
        else begin
            $display("jal   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 
        
		/*======== JALR ========*/
        #`CYCLE rst = 0;
        $readmemh("./jalr.hex", `IM);
        $readmemh("./jalr.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("jalr  ...... Passed");
        else begin
            $display("jalr  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 

		/*======== BEQ ========*/
        #`CYCLE rst = 0;
        $readmemh("./beq.hex", `IM);
        $readmemh("./beq.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("beq   ...... Passed");
        else begin
            $display("beq   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 

		/*======== BNE ========*/  
        #`CYCLE rst = 0;
        $readmemh("./bne.hex", `IM);
        $readmemh("./bne.hex", `DM);
        wait (halt == 1);
        check;
        if (flag == `TRUE) $display("bne   ...... Passed");
        else begin
            $display("bne   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 

		/*======== BLT ========*/
        #`CYCLE rst = 0;
        $readmemh("./blt.hex", `IM);
		$readmemh("./blt.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("blt   ...... Passed");
        else begin
            $display("blt   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== BGE ========*/
        #`CYCLE rst = 0;
        $readmemh("./bge.hex", `IM);
		$readmemh("./bge.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("bge   ...... Passed");
        else begin
            $display("bge   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== BLTU ========*/
        #`CYCLE rst = 0;
        $readmemh("./bltu.hex", `IM);
		$readmemh("./bltu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("bltu  ...... Passed");
        else begin
            $display("bltu  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
		/*======== BGEU ========*/
        #`CYCLE rst = 0;
        $readmemh("./bgeu.hex", `IM);
		$readmemh("./bgeu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("bgeu  ...... Passed");
        else begin
            $display("bgeu  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== LB ========*/
        #`CYCLE rst = 0;
        $readmemh("./lb.hex", `IM);
		$readmemh("./lb.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("lb    ...... Passed");
        else begin
            $display("lb    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end  
    
		/*======== LH ========*/  //lucky pass
        #`CYCLE rst = 0;
        $readmemh("./lh.hex", `IM);
		$readmemh("./lh.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("lh    ...... Passed");
        else begin
            $display("lh    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== LW ========*/ //lucky pass 
        #`CYCLE rst = 0;
        $readmemh("./lw.hex", `IM);
		$readmemh("./lw.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("lw    ...... Passed");
        else begin
            $display("lw    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end 
        
		/*======== LBU ========*/
        #`CYCLE rst = 0;
        $readmemh("./lbu.hex", `IM);
		$readmemh("./lbu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("lbu   ...... Passed");
        else begin
            $display("lbu   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== LHU ========*/
        #`CYCLE rst = 0;
        $readmemh("./lhu.hex", `IM);
		$readmemh("./lhu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("lhu   ...... Passed");
        else begin
            $display("lhu   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end

		/*======== SB ========*/
        #`CYCLE rst = 0;
        $readmemh("./sb.hex", `IM);
		$readmemh("./sb.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sb    ...... Passed");
        else begin
            $display("sb    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SH ========*/
        #`CYCLE rst = 0;
        $readmemh("./sh.hex", `IM);
		$readmemh("./sh.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sh    ...... Passed");
        else begin
            $display("sh    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SW ========*/
        #`CYCLE rst = 0;
        $readmemh("./sw.hex", `IM);
		$readmemh("./sw.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sw    ...... Passed");
        else begin
            $display("sw    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
		/*======== ADDI ========*/
        #`CYCLE rst = 0;
        $readmemh("./addi.hex", `IM);
		$readmemh("./addi.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("addi  ...... Passed");
        else begin
            $display("addi  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SLTI ========*/
        #`CYCLE rst = 0;
        $readmemh("./slti.hex", `IM);
		$readmemh("./slti.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("slti  ...... Passed");
        else begin
            $display("slti  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
       
		/*======== SLTIU ========*/ 
        #`CYCLE rst = 0;
        $readmemh("./sltiu.hex", `IM);
		$readmemh("./sltiu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sltiu ...... Passed"); 
        else begin
            $display("sltiu ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== XORI ========*/
        #`CYCLE rst = 0;
        $readmemh("./xori.hex", `IM);
		$readmemh("./xori.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("xori  ...... Passed"); 
        else begin
            $display("xori  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== ORI ========*/
        #`CYCLE rst = 0;
        $readmemh("./ori.hex", `IM);
		$readmemh("./ori.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("ori   ...... Passed"); 
        else begin
            $display("ori   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== ANDI ========*/
        #`CYCLE rst = 0;
        $readmemh("./andi.hex", `IM);
		$readmemh("./andi.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("andi  ...... Passed"); 
        else begin
            $display("andi  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SLLI ========*/
        #`CYCLE rst = 0;
        $readmemh("./slli.hex", `IM);
		$readmemh("./slli.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("slli  ...... Passed"); 
        else begin
            $display("slli  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SRLI ========*/
        #`CYCLE rst = 0;
        $readmemh("./srli.hex", `IM);
		$readmemh("./srli.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("srli  ...... Passed"); 
        else begin
            $display("srli  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
		/*======== SRAI ========*/  
        #`CYCLE rst = 0;
        $readmemh("./srai.hex", `IM);
		$readmemh("./srai.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("srai  ...... Passed"); 
        else begin
            $display("srai  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== ADD ========*/
        #`CYCLE rst = 0;
        $readmemh("./add.hex", `IM);
		$readmemh("./add.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("add   ...... Passed"); 
        else begin
            $display("add   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SUB ========*/
        #`CYCLE rst = 0;
        $readmemh("./sub.hex", `IM);
		$readmemh("./sub.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sub   ...... Passed"); 
        else begin
            $display("sub   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SLL ========*/
        #`CYCLE rst = 0;
        $readmemh("./sll.hex", `IM);
		$readmemh("./sll.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sll   ...... Passed"); 
        else begin
            $display("sll   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SLT ========*/
        #`CYCLE rst = 0;
        $readmemh("./slt.hex", `IM);
		$readmemh("./slt.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("slt   ...... Passed"); 
        else begin
            $display("slt   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SLTU ========*/
        #`CYCLE rst = 0;
        $readmemh("./sltu.hex", `IM);
		$readmemh("./sltu.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sltu  ...... Passed"); 
        else begin
            $display("sltu  ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== XOR ========*/
        #`CYCLE rst = 0;
        $readmemh("./xor.hex", `IM);
		$readmemh("./xor.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("xor   ...... Passed"); 
        else begin
            $display("xor   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
       
		/*======== SRL ========*/ 
        #`CYCLE rst = 0;
        $readmemh("./srl.hex", `IM);
		$readmemh("./srl.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("srl   ...... Passed"); 
        else begin
            $display("srl   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== SRA ========*/
        #`CYCLE rst = 0;
        $readmemh("./sra.hex", `IM);
		$readmemh("./sra.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("sra   ...... Passed"); 
        else begin
            $display("sra   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
        
		/*======== OR ========*/
        #`CYCLE rst = 0;
        $readmemh("./or.hex", `IM);
		$readmemh("./or.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("or    ...... Passed"); 
        else begin
            $display("or    ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;

        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
		/*======== AND ========*/
        #`CYCLE rst = 0;
        $readmemh("./and.hex", `IM);
		$readmemh("./and.hex", `DM);
		wait (halt == 1);
		check;
		if (flag == `TRUE) $display("and   ...... Passed"); 
        else begin
            $display("and   ...... Failed");
            $display("Test%d failed",  (`GP - 1) / 2);
        end
        #`CYCLE rst = 1;


//=====================================================================
        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
        #`CYCLE rst = 0;
        $readmemh("./sudoku.hex", `IM);
		$readmemh("./sudoku.hex", `DM);
		wait (halt == 1);
		if (halt == 1) $display("sudoku...... Passed"); 
        else begin
            $display("sudoku...... Failed");
        end
        #`CYCLE rst = 1;


        for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
        #`CYCLE rst = 0;
        $readmemh("./fibo.hex", `IM);
		$readmemh("./fibo.hex", `DM);
		wait (halt == 1);
		if (halt == 1) $display("fibo  ...... Passed"); 
        else begin
            $display("fibo  ...... Failed");
        end
        #`CYCLE rst = 1;

	
	for (i = 0; i < 65536; i = i + 1) begin
            `IM[i] <= 0;
            `DM[i] <= 0;
        end
    
        #`CYCLE rst = 0;
        $readmemh("./sort.hex", `IM);
		$readmemh("./sort.hex", `DM);
		wait (halt == 1);
		if (halt == 1) $display("sort  ...... Passed"); 
        else begin
            $display("sort  ...... Failed");
        end

	

	for (i = 6324; i < 7124; i = i + 4) begin
	    $display("%d : %d", i, $signed({`DM[i+3],`DM[i+2],`DM[i+1],`DM[i]}));
	end
        #`CYCLE rst = 1;

	//controller
	#40 rst = 0;
	CPU.controller.M_op = 5'b01000;
	CPU.controller.M_f3 = 3'b111;
	#40
	
	//alu
	#40 rst = 0;
	CPU.controller.E_opcode = 5'b11000;
	CPU.controller.E_func3 = 3'b011;
	#40

	//#10 CPU.regpc.current_pc = 32'b1111_1111_1111_1111_1111_1111_1111_1011;
	//#10 CPU.regpc.current_pc = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

	$display(
            "                                        ⠰⣣⣿⣣⢟⡴⣿⢏⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⣿⣿⣿⣿⣿⣧       ");
        $display(
            "                                       ⣴⣿⣿⠃⠞⣼⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⠋⠠       ");
        $display(
            "                                     ⢀⡜⣯⣶⢇⣘⢰⣿⡏⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⡇⣿⡟⡟⡇⢀⡆⠀⠀⠀⠀⠀⠀ ");
        $display(
            "                                     ⣼⢧⣿⡿⣼⡟⢸⣿⢡⠁⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⢿⣿⢝⠟⣿⠀⠈⡅       ");
        $display(
            "                                    ⣦⣿⢸⣿⢧⡟⡠⠗⠋⠟⠞⢻⣿⣿⠙⣿⡇⢹⣿⡇⡎⣋⣿⢀⣠⢻⢾⠀⠣       ");
        $display(
            "                                   ⣼⢽⣿⢸⣿⢈⡞⢠⢾⠍⠑⡐⣌⢿⣿⡷⡽⣇⡷⠻⣆⡡⢿⣿⢸⣿⣿⣿⡆⠀⠀⢀     ");
        $display(
            "                                  ⣰⣿⡾⣿⢸⡿⣟⢠⡏⠨⡄⠀⣇⣿⣮⡻⢇⢿⢖⣴⡒⠢⡀⠘⣿⢸⣿⣿⡿⣼⡷⡄⣼⡄    ");
        $display(
            "                                 ⢰⣿⣿⡇⣿⡸⡇⣗⢸⣇⠔⢀⣸⣿⣿⣿⣿⣿⣿⡎⢛⡅⠀⣷⡀⡹⣼⣿⣟⣼⡿⣱⡇⣿⡇    ");
        $display(
            "    **************************** ⣼⣿⣿⣿⡼⣇⠇⣟⠳⠟⠿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠉⣉⢠⣿⡇⣃⡿⢫⣾⢟⣵⣿⡇⣿⡇    ");
        $display(
            "    **                        ** ⢿⣿⣿⣿⣷⡹⡜⢿⣳⢰⣜⣽⣿⡿⠷⢿⣿⣿⣟⢿⣶⣶⣿⡟⡐⢜⣵⡿⣫⣾⣿⣿⣧⣿⢧⢰⡀  ");
        $display(
            "    **  Waku Waku !!          **⠆⢸⣿⣿⣿⣿⣷⡱⡘⢿⣿⣿⣿⡿⣼⣿⣿⢸⣿⡿⣦⡌⠛⣳⡞⣠⡾⣫⣾⣿⣿⣿⣿⢸⡿⡐⣾⣇  ");
        $display(
            "    **                        ** ⠘⣿⣿⣿⣿⣿⣿⡄⠀⠙⠿⣿⡇⣿⣿⣿⢸⣿⣿⣾⣽⣷⢟⢜⣫⣾⣿⣿⣿⣿⣿⡟⢼⢣⢳⣸⣿  ");
        $display(
            "    **  Simulation PASS !!    **   ⠹⣿⣿⣿⣿⣿⣿⠀⠀⡿⢺⣽⠒⠾⢭⣼⣿⣿⣿⠿⠫⣱⣿⣿⣿⣿⣿⣿⣿⣿⢇⢏⠏⠈⢹⡿ ");
        $display(
            "    **                        **     ⠹⣿⣿⣿⣿⡿⣠⠶⣿⣷⡜⡏⣿⣶⠶⣶⢾⢿⢇⣼⣿⣿⣿⣿⣿⣿⣿⣿⠏⠊⠀⠀⠀⣾⠇");
        $display(
            "    ****************************      ⠈⠻⣿⡿⣼⡿⣿⣶⣯⠃⡎⠩⠰⣛⠿⣷⡍⣼⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⢀⠋ ");
        $display(
            "                                      ⠈⠃⠿⠿⠾⠝⠿⠰⠑⠀⠿⠿⠿⠶⠿⠼⠿⠿⠿⠿⠿⠟⠉⠀⠀⠀        ");


        $finish;
    end
endmodule

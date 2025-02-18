/* ========================== 
*   Model of RISC without pipeline. 
*   risc.v 
* 
*  Useful for instruction set simulation. 
*  Three main tasks -fetch, execute, write. */ 
module CPU (clk, rst, pc, ir, halt, write_data, read_data, m_addr, m_rw_); 
/* 
* Declarations, functions , and tasks 
*/ 
// Declare parameters 
parameter  CYCLE=10 ; // Cycle Time 
parameter  WIDTH=32 ; // Width of data paths 
parameter  ADDRSIZE = 12 ; // Size of address field 
parameter  MEMSIZE = (1<<ADDRSIZE); // Size of memory 
parameter  MAXREGS = 16 ; // Maximum # of registers 
parameter  SBITS = 5 ; // Status register bits
// input output
input	   clk, rst;
input	   [WIDTH-1:0] ir, read_data;
output reg halt, m_rw_;
output reg [WIDTH-1:0] write_data;
output reg [ADDRSIZE-1:0] pc, m_addr;
// Declare Registers and Memory 
reg [WIDTH-1:0] RFILE[0:MAXREGS-1],   // Register File 
src1, src2;                       // Alu operation registers 
reg[WIDTH:0] result, tmp;     // ALU result register 
reg[SBITS-1:0] psr;          // Processor Status Register 
reg[ADDRSIZE-1:0] next_pc ;    // Program counter 
reg               dir;                   // rotate direction 
integer           i;                    // useful for interactive debugging 
// Define Instruction fields 
`define OPCODE ir[31:28] 
`define SRC ir[23:12]
`define DST ir[11:0] 
`define SRCTYPE ir[27] // source type, 0=reg (mem for LD), 1=imm 
`define DSTTYPE ir[26] // destination type, 0=reg, 1=imm 
`define CCODE ir[27:24] 
`define SRCNT ir[23:12] // Shift/rotate count -= left, +=right 
// Operand Types 
`define REGTYPE 0 
`define IMMTYPE 1 
// Define opcodes for each instruction 
`define NOP     4'b0000 
`define BRA     4'b0001 
`define LD      4'b0010 
`define STR     4'b0011 
`define ADD     4'b0100 
`define MUL     4'b0101 
`define CMP     4'b0110 
`define SHF     4'b0111 
`define ROT     4'b1000 
`define ADDONE  4'b1001 
`define ADDTWO  4'b1010 
`define HLT     4'b1011 
// Define Condition Code fields
`define CARRY psr[0] 
`define EVEN   psr[1] 
`define PARITY psr[2] 
`define ZERO   psr[3] 
`define NEG    psr[4] 
// Define Condition Codes 
`define CCC 4'd1   // Result has carry 
`define CCE 4'd2   // Result is even 
`define CCP 4'd3   // Result is odd parity 
`define CCZ 4'd4   // Result is Zero 
`define CCN 4'd5   // Result is Negative 
`define CCA 4'd0   // Always 
`define RIGHT  1'b0 // Rotate/Shift Right 
`define LEFT   1'b1 // Rotate/Shift Left 

// Main Tasks -fetch, execute, write_result 
always @(posedge clk)// Fetch the instruction and increment PC. 
begin 
    if(rst)
        pc <= 12'd0;
    else
        pc <= next_pc;
end

//next_pc
always @(ir or psr or pc) // Decode and execute the instruction. 
begin
    if ((((`CCODE == `CCC)&&(`CARRY == 1'b1))
        ||((`CCODE == `CCE)&&(`EVEN == 1'b1))
        ||((`CCODE == `CCP)&&(`PARITY == 1'b1))
        ||((`CCODE == `CCZ)&&(`ZERO == 1'b1))
        ||((`CCODE == `CCN)&&(`NEG == 1'b1))
        ||(`CCODE == `CCA))
        &&(`OPCODE == `BRA)) 
        next_pc = `DST;
    else
        next_pc = pc + 12'd1;
end

always @(ir or read_data) // Decode and execute the instruction. 
begin 
    case(`OPCODE) 
    `NOP : ;
    `BRA : ; 
    `LD : begin  
        if (`SRCTYPE) begin
	    result = `SRC ; 
	    m_rw_ = 1'b0;
	end
        else begin
	    m_addr = `SRC;
	    result = read_data; 
	    m_rw_ = 1'b0;
	end
	tmp = {1'b0,RFILE[`DST]};
        `CARRY  = tmp[WIDTH]; 
        `EVEN   = ~tmp[0]; 
        `PARITY =  ^tmp ; 
        `ZERO   = ~(|tmp) ; 
        `NEG    = tmp[WIDTH-1];
    end 
    `STR : begin 
        if (`SRCTYPE) begin
	    m_addr = `DST;
	    write_data = `SRC;
	    m_rw_ = 1'b1;
	end
        else begin
	    m_addr = `DST;
	    write_data = RFILE[`SRC] ;
	    m_rw_ = 1'b1;
	end
        if (`SRCTYPE)
        begin
	    tmp = {21'b0,`SRC};
            `CARRY  = tmp[WIDTH]; 
            `EVEN   = ~tmp[0]; 
            `PARITY =  ^tmp ; 
            `ZERO   = ~(|tmp) ; 
            `NEG    = tmp[WIDTH-1]; 
        end
        else 
        begin
	    tmp = {1'b0,RFILE[`SRC]};
            `CARRY  = tmp[WIDTH]; 
            `EVEN   = ~tmp[0]; 
            `PARITY =  ^tmp ; 
            `ZERO   = ~(|tmp) ; 
            `NEG    = tmp[WIDTH-1]; 
        end
    end 
    `ADD :  begin
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type
        if (`DSTTYPE == `REGTYPE) begin 
        src2 = RFILE[`DST]; 
        end
        result = src1 + src2;
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end
    `MUL : begin 
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type 
        if (`DSTTYPE == `REGTYPE) begin 
        src2 = RFILE[`DST]; 
        end
        result = src1 * src2 ; 
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end 
    `CMP : begin 
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type 
        result = ~src1 ; 
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end 
    `SHF : begin 
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type 
        if (`DSTTYPE == `REGTYPE) begin 
        src2 = RFILE[`DST]; 
        end
        i = src1[ADDRSIZE-1:0] ; 
        result = (i>=0) ? (src2 >> i) : (src2 << -i) ; 
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end
    `ROT : begin 
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type 
        if (`DSTTYPE == `REGTYPE) begin 
        src2 = RFILE[`DST]; 
        end
        dir = (src1[ADDRSIZE-1] >=0)? `RIGHT : `LEFT ; 
        i = ( src1[ADDRSIZE-1] >=0)? src1 : -src1[ADDRSIZE-1:0] ;
        if (dir == `RIGHT) begin
            if(i > 0)
            begin
                result = src2 >> i ;
		src2 = src2 << WIDTH-i ;
		result = result | src2 ;
            end
            else result = src2;
        end 
        else begin
            if(i > 0)
            begin
                result = src2 << i ;
		src2 = src2 >> WIDTH-i ;
		result = result | src2 ;
            end
            else result = src2;
        end 
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end 
    `ADDONE :  begin
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type
        result = src1 + 32'd1;
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end
    `ADDTWO :  begin
        if (`SRCTYPE == `REGTYPE) src1 = RFILE[`SRC] ; 
        else src1 = `SRC ;   // immediate type
        result = src1 + 32'd2;
	if(`DSTTYPE != `REGTYPE) begin
	    m_addr = `DST;
	    write_data = result[WIDTH-1:0];
	    m_rw_ = 1'b1;
	end
	else m_rw_ = 1'b0;
        `CARRY  = result[WIDTH]; 
        `EVEN   = ~result[0]; 
        `PARITY =  ^result ; 
        `ZERO   = ~(|result) ; 
        `NEG    = result[WIDTH-1]; 
    end
    `HLT : begin 
	halt = 1'b1;
    end 
    default : ;
    endcase 
end

// Write the result in register file or memory. 
always @(posedge clk)
begin 
    if (((`OPCODE >= `ADD) && (`OPCODE < `HLT)) || (`OPCODE == `LD)) begin 
        if(`DSTTYPE == `REGTYPE) RFILE[`DST] <= result[WIDTH-1:0] ; 
    end 
end
endmodule
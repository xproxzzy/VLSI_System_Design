module Memory (clk, pc, ir, write_data, read_data, m_addr, m_rw_); 

parameter 	WORDS = 4095, 
		ACCESS_TIME = 5;
parameter  ADDRSIZE = 12 ; // Size of address field 
parameter  WIDTH=32 ; // Width of data paths 
parameter  MEMSIZE = (1<<ADDRSIZE); // Size of memory
input clk, m_rw_;
input [ADDRSIZE-1:0] pc, m_addr;
input [WIDTH-1:0] write_data;
output reg [WIDTH-1:0] ir, read_data;

reg [WIDTH-1:0] DataMEM[0:MEMSIZE-1];    //  MEMORY 
reg [WIDTH-1:0] InstructionMEM[0:MEMSIZE-1];    //  MEMORY 

//Read Instruction
always @ (*)
begin
	ir = InstructionMEM[pc];
end

//Read
always @ (*)
begin
	read_data = DataMEM[m_addr];
end

//Write
always @ (posedge clk)
begin
	if(m_rw_ == 1) DataMEM[m_addr[11:0]] <= write_data;
end

initial begin
    #6181
	$display("DataMEM[0]=%b",DataMEM[0]);
	$display("DataMEM[1]=%b",DataMEM[1]);
	$display("DataMEM[2]=%b",DataMEM[2]);
	$display("DataMEM[3]=%b",DataMEM[3]);
	$display("DataMEM[4]=%b",DataMEM[4]);
	$display("DataMEM[5]=%b",DataMEM[5]);
	$display("DataMEM[6]=%b",DataMEM[6]);
end 
endmodule
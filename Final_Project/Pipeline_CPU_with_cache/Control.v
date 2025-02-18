
`include "WaitStateCtr.v"

module Control(
  Pstrobe,PRW,PReady,
  Match,Valid,Write,
  CacheDataSel,
  PDataSel,
  SysDataOE,PDataOE,
  SysStrobe,SysRW,
  reset,clk
); 

input Pstrobe,PRW;
input Match,Valid;
input reset,clk;

output PReady;
output Write;
output CacheDataSel,PDataSel;
output SysDataOE,PDataOE;
output SysStrobe,SysRW;

assign SysRW = PRW;
 
`define READ 1'b1
`define WRITE 1'b0

`define State_IDLE        4'b0000 //0
`define State_READ        4'b0001 //1
`define State_READMISS    4'b0010 //2
`define State_READSYS     4'b0011 //3
`define State_READDATA    4'b0100 //4
`define State_WRITE       4'b0101 //5
`define State_WRITEHIT    4'b0110 //6
`define State_WRITEMISS   4'b0111 //7
`define State_WRITESYS    4'b1000 //8
`define State_WRITEDATA   4'b1001 //9
`define State_WRITESYS_HIT 4'b1010 //10
`define State_WRITEREADY  4'b1011  //11


reg PReadyEnable;
reg SysStrobe;
reg SysDataOE;
reg Write;
reg Ready;
reg CacheDataSel, PDataSel;
reg PDataOE;
reg [3:0] state,next_state;
reg [9:0] vector;

wire WaitStateCtrCarry;
reg LoadWaitStateCtr;

WaitStateCtr WaitStateCtr(
.Load (LoadWaitStateCtr),
.Carry (WaitStateCtrCarry),
.clk (clk)
);

wire PReady;  
assign PReady=(PReadyEnable && Match && Valid) || Ready;


always @ (posedge clk) begin 
  if(reset)
    state<=`State_IDLE;
  else
    state<=next_state;
end

always @(*) begin

case (state)
  `State_IDLE: begin
                vector=10'b0000000000;
                if (Pstrobe && PRW == `READ)
                  next_state = `State_READ;
                else if (Pstrobe && PRW == `WRITE)
                  next_state = `State_WRITE;
                else next_state = `State_IDLE;
              end
  `State_READ : begin
                  vector=10'b0100000010;
                  if (Match && Valid)
                    next_state = `State_IDLE;
                  else next_state = `State_READMISS;
                end
  `State_READMISS : begin
                       vector=10'b1000110010;
                       next_state = `State_READSYS;
                    end
  `State_READSYS : begin
                     vector=10'b0000010010;
                     if(WaitStateCtrCarry) 
                       next_state = `State_READDATA;
                     else next_state = `State_READSYS;
                    end
  `State_READDATA : begin
                      vector=10'b0011011110;
                      next_state = `State_IDLE;
                    end
  `State_WRITE : begin
                   vector=10'b0000000000;
                   if (Match && Valid)
                     next_state = `State_WRITEHIT;
                   else
                     next_state = `State_WRITEMISS;
                 end
  `State_WRITEHIT : begin
                      vector=10'b1001101101;
                      next_state = `State_WRITESYS_HIT;
                    end
  `State_WRITESYS_HIT: begin
                         vector=10'b0000100001;
                         if(WaitStateCtrCarry)
                           next_state=`State_WRITEREADY;
                         else
                           next_state=`State_WRITESYS_HIT;
                       end
  `State_WRITEREADY: begin
                       vector=10'b0011000000;
                       next_state = `State_IDLE; 
                     end
  
  `State_WRITEMISS : begin
                      vector=10'b1000100001;
                      next_state = `State_WRITESYS;
                     end
  `State_WRITESYS : begin
                      vector=10'b0000000001;
                      if (WaitStateCtrCarry)
                        next_state = `State_WRITEDATA;
                      else next_state =`State_WRITESYS;
                    end
  `State_WRITEDATA : begin
                       vector=10'b0011001101;
                       next_state = `State_IDLE;
                     end
  default: begin
             vector=10'b0000000000;
             next_state =`State_IDLE;
           end
endcase
 
 
 LoadWaitStateCtr=vector[9];
 PReadyEnable=vector[8];
 Ready=vector[7];
 Write=vector[6];
 SysStrobe=vector[5];
 CacheDataSel=vector[3];
 PDataSel=vector[2]; //error
 PDataOE=vector[1];
 SysDataOE=vector[0];

end




endmodule















  

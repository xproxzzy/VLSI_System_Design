
`include "TagRam.v"
`include "ValidRam.v"
`include "DataRam.v"
`include "DataMux.v"
`include "Comparator.v"
`include "Control.v"

module cache(
Pstrobe, PAddress,
PData, PRW, PReady,
SysStrobe, SysAddress,
SysData, SysRW,
reset, clk,
OutData,
CData
);

`define READ 1'b1
`define WRITE 1'b0
`define CACHESIZE 1024
`define ADDR 15:0
`define ADDRWIDTH 16
`define INDEX 9:0
`define TAG 15:10
`define DATA 31:0
`define DATAWIDTH 32
`define PRESENT 1'b1
`define ABSENT !`PRESENT

input Pstrobe;
input [`ADDR] PAddress;
input [`DATA] PData;
input PRW;
output PReady;
output SysStrobe;
output [`ADDR] SysAddress;
output [`DATA] SysData;
output SysRW;
input reset;
input clk;
output [`DATA] OutData;
input [`DATA] CData;

wire PDataOE;
wire SysDataOE;
wire [`DATA] PDataOut;
wire [`DATA] PData;

wire [`DATA] SysData;
wire [`ADDR] SysAddress;
wire [`TAG] TagRamTag;

wire Write;
wire Valid;
wire CacheDataSelect;
wire PDataSelect;
wire Match;


assign OutData =PDataOE ? PDataOut : `DATAWIDTH'b0;
assign SysData= SysDataOE ? PData : `DATAWIDTH'b0;
assign  SysAddress = PAddress;


TagRam TagRam(
	.Address (PAddress[`INDEX]),
	.TagIn (PAddress[`TAG]),
	.TagOut (TagRamTag[`TAG]),
	.Write (Write),
	.clk (clk)
);

ValidRam ValidRam(
	.Address (PAddress[`INDEX]),
	.ValidOut (Valid),
	.Write (Write),
	.reset (reset),
	.clk (clk)
);

wire[`DATA] DataRamDataOut;
wire[`DATA] DataRamDataIn;

DataMux CacheDataInputMux(
	.sel (CacheDataSelect),
	.Data1 (CData),
	.Data0 (PData),
	.Out (DataRamDataIn) 
);

DataMux PDatatMux(
	.sel (PDataSelect),
	.Data1 (CData),
	.Data0 (DataRamDataOut),
	.Out (PDataOut) 
);


DataRam DataRam(
	.Address (PAddress[`INDEX]),
	.DataIn (DataRamDataIn),
	.DataOut (DataRamDataOut),
	.Write (Write),
	.clk (clk)
);

Comparator Comparator(
	.Tag1 (PAddress[`TAG]),
	.Tag2 (TagRamTag),
	.Match (Match)
);

Control control(
	.Pstrobe (Pstrobe),
	.PRW (PRW),
	.PReady (PReady),
	.Match (Match),
	.Valid (Valid),
	.CacheDataSel (CacheDataSelect),
	.PDataSel (PDataSelect),
	.SysDataOE (SysDataOE),
	.Write(Write),
	.PDataOE (PDataOE),
	.SysStrobe (SysStrobe),
	.SysRW (SysRW),
	.reset (reset),
	.clk (clk) 
);
endmodule









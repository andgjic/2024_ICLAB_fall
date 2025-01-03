//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2018 Fall
//   Lab01-Practice		: +, -, x calculator
//   Author     		: Po-Yu, Huang (hpy35269@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : TESETBED.v
//   Module Name : TESETBED
//   Release version : V1.0 (Release Date: 2018-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`timescale 1ns/10ps
`include "PATTERN.v"
`ifdef RTL
  `include "CORE.v"
`endif
`ifdef GATE
  `include "CORE_SYN.v"
`endif
	  		  	
module TESTBED;

wire	[2:0]  in_n0;
wire	[2:0]  in_n1;
wire	opt;
wire    [3:0]  out_n; 


initial begin
  `ifdef RTL
    $fsdbDumpfile("CORE.fsdb");
    $fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("CORE_SYN.sdf", My_CORE);
    $fsdbDumpfile("CORE_SYN.fsdb");
    $fsdbDumpvars(0,"+mda");
    $fsdbDumpvars();    
  `endif


end

  CORE  My_CORE(
	in_n0,
	in_n1,
	opt,
	out_n);
	
  PATTERN My_PATTERN(
	in_n0,
	in_n1,
	opt,
	out_n);
  
 
endmodule

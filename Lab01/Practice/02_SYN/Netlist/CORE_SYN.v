/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Fri Feb 23 23:47:27 2024
/////////////////////////////////////////////////////////////


module CORE ( in_n0, in_n1, opt, out_n );
  input [2:0] in_n0;
  input [2:0] in_n1;
  output [3:0] out_n;
  input opt;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36;

  NOR2XL U23 ( .A(opt), .B(n27), .Y(n34) );
  NOR2X1 U24 ( .A(in_n0[0]), .B(n23), .Y(n25) );
  INVXL U25 ( .A(in_n1[1]), .Y(n20) );
  INVXL U26 ( .A(in_n1[0]), .Y(n23) );
  AND2XL U27 ( .A(in_n0[0]), .B(in_n1[0]), .Y(n26) );
  INVXL U28 ( .A(opt), .Y(n32) );
  AOI22XL U29 ( .A0(opt), .A1(n25), .B0(n26), .B1(n32), .Y(n19) );
  MXI2XL U30 ( .A(in_n1[1]), .B(n20), .S0(n19), .Y(n21) );
  XOR2XL U31 ( .A(in_n0[1]), .B(n21), .Y(out_n[1]) );
  INVXL U32 ( .A(n25), .Y(n22) );
  OAI2BB1XL U33 ( .A0N(in_n0[0]), .A1N(n23), .B0(n22), .Y(out_n[0]) );
  INVXL U34 ( .A(in_n0[2]), .Y(n29) );
  OAI2BB1XL U35 ( .A0N(in_n1[1]), .A1N(n25), .B0(in_n0[1]), .Y(n24) );
  OAI211XL U36 ( .A0(in_n1[1]), .A1(n25), .B0(opt), .C0(n24), .Y(n36) );
  AOI222XL U37 ( .A0(in_n0[1]), .A1(in_n1[1]), .B0(in_n0[1]), .B1(n26), .C0(
        in_n1[1]), .C1(n26), .Y(n27) );
  NOR2BXL U38 ( .AN(n36), .B(n34), .Y(n31) );
  XOR2XL U39 ( .A(n31), .B(in_n1[2]), .Y(n28) );
  MXI2XL U40 ( .A(in_n0[2]), .B(n29), .S0(n28), .Y(out_n[2]) );
  NAND2XL U41 ( .A(in_n0[2]), .B(n32), .Y(n30) );
  OAI211XL U42 ( .A0(in_n0[2]), .A1(n32), .B0(n31), .C0(n30), .Y(n33) );
  AOI22XL U43 ( .A0(n34), .A1(in_n0[2]), .B0(in_n1[2]), .B1(n33), .Y(n35) );
  OAI21XL U44 ( .A0(in_n0[2]), .A1(n36), .B0(n35), .Y(out_n[3]) );
endmodule


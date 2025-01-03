/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Sun Sep 22 20:30:32 2024
/////////////////////////////////////////////////////////////


module BB ( clk, rst_n, in_valid, inning, half, action, out_valid, score_A, 
        score_B, result );
  input [1:0] inning;
  input [2:0] action;
  output [7:0] score_A;
  output [7:0] score_B;
  output [1:0] result;
  input clk, rst_n, in_valid, half;
  output out_valid;
  wire   in_valid_delay, N159, N160, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n155, n156, n157, n158, n1590, n1600,
         n161, n162, n163, n164, n165, n166, n167, n168, n169, n170, n171,
         n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n207;
  wire   [2:0] base;
  wire   [1:0] out;
  wire   [2:0] score_hold;

  DFFRHQXL out_reg_0_ ( .D(n92), .CK(clk), .RN(n111), .Q(out[0]) );
  DFFRHQXL out_reg_1_ ( .D(n91), .CK(clk), .RN(n111), .Q(out[1]) );
  DFFRHQXL base_reg_0_ ( .D(n90), .CK(clk), .RN(n111), .Q(base[0]) );
  DFFRHQXL base_reg_1_ ( .D(n89), .CK(clk), .RN(n111), .Q(base[1]) );
  DFFRHQXL base_reg_2_ ( .D(n88), .CK(clk), .RN(n111), .Q(base[2]) );
  DFFRHQXL score_hold_reg_0_ ( .D(n80), .CK(clk), .RN(n111), .Q(score_hold[0])
         );
  DFFRHQXL score_hold_reg_1_ ( .D(n79), .CK(clk), .RN(n111), .Q(score_hold[1])
         );
  DFFRHQXL score_hold_reg_2_ ( .D(n78), .CK(clk), .RN(n111), .Q(score_hold[2])
         );
  DFFSX1 in_valid_delay_reg ( .D(n206), .CK(clk), .SN(n111), .QN(
        in_valid_delay) );
  DFFRHQXL score_reg_0__3_ ( .D(n84), .CK(clk), .RN(n111), .Q(score_A[3]) );
  DFFRHQXL score_reg_1__0_ ( .D(n83), .CK(clk), .RN(n111), .Q(score_B[0]) );
  DFFRHQXL out_valid_reg ( .D(n207), .CK(clk), .RN(n111), .Q(out_valid) );
  DFFRHQXL result_reg_1_ ( .D(N160), .CK(clk), .RN(n111), .Q(result[1]) );
  DFFRHQXL result_reg_0_ ( .D(N159), .CK(clk), .RN(n111), .Q(result[0]) );
  DFFRHQXL score_reg_0__0_ ( .D(n87), .CK(clk), .RN(n111), .Q(score_A[0]) );
  DFFRHQXL score_reg_1__1_ ( .D(n82), .CK(clk), .RN(n111), .Q(score_B[1]) );
  DFFRHQXL score_reg_0__2_ ( .D(n85), .CK(clk), .RN(n111), .Q(score_A[2]) );
  DFFRHQXL score_reg_0__1_ ( .D(n86), .CK(clk), .RN(n111), .Q(score_A[1]) );
  DFFRHQXL score_reg_1__2_ ( .D(n81), .CK(clk), .RN(n111), .Q(score_B[2]) );
  NOR2XL U107 ( .A(n125), .B(n182), .Y(n135) );
  NOR2XL U108 ( .A(action[1]), .B(n183), .Y(n124) );
  NOR2XL U109 ( .A(n1600), .B(n161), .Y(n1590) );
  NOR2XL U110 ( .A(n116), .B(n117), .Y(n115) );
  NOR2XL U111 ( .A(score_B[2]), .B(n201), .Y(n170) );
  NOR2XL U112 ( .A(score_A[1]), .B(n204), .Y(n175) );
  NOR2XL U113 ( .A(in_valid), .B(n115), .Y(n195) );
  NOR2X1 U114 ( .A(n115), .B(n206), .Y(n177) );
  NOR2X1 U115 ( .A(n205), .B(n207), .Y(n167) );
  NOR2X1 U116 ( .A(n151), .B(n207), .Y(n202) );
  NOR2X1 U117 ( .A(action[0]), .B(out[1]), .Y(n125) );
  NOR2X1 U118 ( .A(n126), .B(n179), .Y(n120) );
  NOR2X1 U119 ( .A(half), .B(n206), .Y(n205) );
  NOR2X1 U120 ( .A(action[2]), .B(n126), .Y(n186) );
  BUFXL U121 ( .A(rst_n), .Y(n111) );
  INVXL U122 ( .A(1'b1), .Y(score_B[3]) );
  INVXL U124 ( .A(1'b1), .Y(score_B[4]) );
  INVXL U126 ( .A(1'b1), .Y(score_B[5]) );
  INVXL U128 ( .A(1'b1), .Y(score_B[6]) );
  INVXL U130 ( .A(1'b1), .Y(score_B[7]) );
  INVXL U132 ( .A(1'b1), .Y(score_A[4]) );
  INVXL U134 ( .A(1'b1), .Y(score_A[5]) );
  INVXL U136 ( .A(1'b1), .Y(score_A[6]) );
  INVXL U138 ( .A(1'b1), .Y(score_A[7]) );
  AOI22XL U140 ( .A0(n186), .A1(n125), .B0(n184), .B1(n124), .Y(n133) );
  NAND2XL U141 ( .A(n123), .B(action[2]), .Y(n131) );
  INVXL U142 ( .A(n131), .Y(n134) );
  OAI211XL U143 ( .A0(n133), .A1(n189), .B0(n132), .C0(n131), .Y(n145) );
  AOI22XL U144 ( .A0(base[0]), .A1(n135), .B0(base[2]), .B1(n130), .Y(n132) );
  AOI32XL U145 ( .A0(n129), .A1(n128), .A2(n127), .B0(out[1]), .B1(n128), .Y(
        n130) );
  OAI2BB1XL U146 ( .A0N(base[0]), .A1N(out[0]), .B0(action[2]), .Y(n129) );
  NAND2XL U147 ( .A(n134), .B(base[2]), .Y(n146) );
  ADDFXL U148 ( .A(n144), .B(n143), .CI(n142), .CO(n156), .S(n147) );
  AOI22XL U149 ( .A0(half), .A1(score_B[0]), .B0(score_A[0]), .B1(n153), .Y(
        n144) );
  AOI22XL U150 ( .A0(n134), .A1(base[1]), .B0(base[2]), .B1(n135), .Y(n143) );
  NOR2X1 U151 ( .A(action[0]), .B(action[1]), .Y(n123) );
  NOR2X1 U152 ( .A(action[2]), .B(n187), .Y(n184) );
  OAI211XL U153 ( .A0(action[0]), .A1(n190), .B0(action[2]), .C0(n181), .Y(
        n114) );
  NAND2XL U154 ( .A(n207), .B(n168), .Y(n174) );
  NAND2XL U155 ( .A(n125), .B(n120), .Y(n188) );
  OAI22XL U156 ( .A0(n167), .A1(n203), .B0(n165), .B1(n141), .Y(n83) );
  MXI2XL U157 ( .A(score_hold[0]), .B(n198), .S0(n163), .Y(n141) );
  NAND2XL U158 ( .A(action[0]), .B(n182), .Y(n127) );
  AOI32XL U159 ( .A0(base[0]), .A1(n126), .A2(base[1]), .B0(action[2]), .B1(
        n126), .Y(n128) );
  AOI22XL U160 ( .A0(half), .A1(score_B[2]), .B0(score_A[2]), .B1(n153), .Y(
        n1600) );
  INVXL U161 ( .A(action[2]), .Y(n179) );
  NAND2XL U162 ( .A(half), .B(in_valid), .Y(n165) );
  AOI21XL U163 ( .A0(n161), .A1(n1600), .B0(n1590), .Y(n200) );
  ADDFXL U164 ( .A(n156), .B(n155), .CI(n154), .CO(n161), .S(n149) );
  AOI22XL U165 ( .A0(half), .A1(score_B[1]), .B0(score_A[1]), .B1(n153), .Y(
        n155) );
  OAI2BB1XL U166 ( .A0N(n147), .A1N(n146), .B0(n145), .Y(n154) );
  NAND4XL U167 ( .A(inning[0]), .B(inning[1]), .C(n140), .D(n168), .Y(n163) );
  AOI22XL U168 ( .A0(n139), .A1(n138), .B0(score_A[2]), .B1(n162), .Y(n140) );
  INVXL U169 ( .A(n165), .Y(n151) );
  NAND2XL U170 ( .A(n146), .B(n145), .Y(n137) );
  INVXL U171 ( .A(n186), .Y(n182) );
  INVXL U172 ( .A(action[1]), .Y(n126) );
  INVXL U173 ( .A(action[0]), .Y(n183) );
  NOR2BXL U174 ( .AN(n124), .B(n184), .Y(n194) );
  NOR2X1 U175 ( .A(action[1]), .B(action[2]), .Y(n185) );
  AOI31XL U176 ( .A0(n120), .A1(action[0]), .A2(n177), .B0(n195), .Y(n178) );
  AOI211XL U177 ( .A0(out[1]), .A1(n123), .B0(n184), .C0(n113), .Y(n116) );
  OAI22XL U178 ( .A0(n190), .A1(n188), .B0(n114), .B1(n112), .Y(n113) );
  MXI2XL U179 ( .A(n119), .B(out[0]), .S0(n114), .Y(n117) );
  INVXL U180 ( .A(n177), .Y(n196) );
  INVXL U181 ( .A(n195), .Y(n118) );
  OAI22XL U182 ( .A0(n158), .A1(n157), .B0(n202), .B1(n168), .Y(n84) );
  OAI2BB2XL U183 ( .B0(score_A[3]), .B1(n1590), .A0N(score_A[3]), .A1N(n1590), 
        .Y(n157) );
  OAI22XL U184 ( .A0(n167), .A1(n166), .B0(n165), .B1(n164), .Y(n81) );
  AOI2BB2XL U185 ( .B0(n200), .B1(n163), .A0N(n163), .A1N(n162), .Y(n164) );
  OAI22XL U186 ( .A0(n202), .A1(n148), .B0(n149), .B1(n158), .Y(n86) );
  OAI2BB2XL U187 ( .B0(n202), .B1(n201), .A0N(n205), .A1N(n200), .Y(n85) );
  OAI21XL U188 ( .A0(n167), .A1(n204), .B0(n152), .Y(n82) );
  OAI211XL U189 ( .A0(score_hold[1]), .A1(n163), .B0(n151), .C0(n150), .Y(n152) );
  NAND2XL U190 ( .A(n149), .B(n163), .Y(n150) );
  OAI2BB2XL U191 ( .B0(n202), .B1(n199), .A0N(n205), .A1N(n198), .Y(n87) );
  AOI211XL U192 ( .A0(n172), .A1(n169), .B0(n170), .C0(n174), .Y(N159) );
  NOR4BXL U193 ( .AN(n176), .B(n175), .C(n174), .D(n173), .Y(N160) );
  OAI211XL U194 ( .A0(score_B[0]), .A1(n199), .B0(n172), .C0(n171), .Y(n173)
         );
  AND2XL U195 ( .A(in_valid_delay), .B(n206), .Y(n207) );
  AOI22XL U196 ( .A0(n205), .A1(n166), .B0(n162), .B1(n158), .Y(n78) );
  AOI2BB2XL U197 ( .B0(n205), .B1(n204), .A0N(score_hold[1]), .A1N(n205), .Y(
        n79) );
  AOI2BB2XL U198 ( .B0(n205), .B1(n203), .A0N(score_hold[0]), .A1N(n205), .Y(
        n80) );
  OAI2BB2XL U199 ( .B0(n197), .B1(n196), .A0N(base[2]), .A1N(n195), .Y(n88) );
  AOI211XL U200 ( .A0(base[1]), .A1(n194), .B0(n193), .C0(n192), .Y(n197) );
  OAI22XL U201 ( .A0(n183), .A1(n182), .B0(n181), .B1(n180), .Y(n193) );
  OAI22XL U202 ( .A0(n191), .A1(n190), .B0(n189), .B1(n188), .Y(n192) );
  OAI22XL U203 ( .A0(n178), .A1(n189), .B0(n122), .B1(n196), .Y(n89) );
  AOI22XL U204 ( .A0(n194), .A1(base[0]), .B0(n183), .B1(n121), .Y(n122) );
  AOI31XL U205 ( .A0(n126), .A1(n190), .A2(n189), .B0(action[2]), .Y(n121) );
  OAI2BB2XL U206 ( .B0(n178), .B1(n190), .A0N(n185), .A1N(n177), .Y(n90) );
  OAI22XL U207 ( .A0(n116), .A1(n196), .B0(n187), .B1(n118), .Y(n91) );
  OAI22XL U208 ( .A0(n119), .A1(n118), .B0(n117), .B1(n196), .Y(n92) );
  INVXL U209 ( .A(half), .Y(n153) );
  XOR2XL U210 ( .A(n137), .B(n147), .Y(n198) );
  INVXL U211 ( .A(in_valid), .Y(n206) );
  INVXL U212 ( .A(score_B[2]), .Y(n166) );
  INVXL U213 ( .A(score_hold[2]), .Y(n162) );
  INVXL U214 ( .A(n205), .Y(n158) );
  INVXL U215 ( .A(out[1]), .Y(n187) );
  INVXL U216 ( .A(base[0]), .Y(n190) );
  INVXL U217 ( .A(n123), .Y(n181) );
  INVXL U218 ( .A(out[0]), .Y(n119) );
  AOI22XL U219 ( .A0(out[0]), .A1(n187), .B0(out[1]), .B1(n119), .Y(n112) );
  INVXL U220 ( .A(base[1]), .Y(n189) );
  INVXL U221 ( .A(score_B[0]), .Y(n203) );
  INVXL U222 ( .A(n133), .Y(n136) );
  AOI222XL U223 ( .A0(n136), .A1(base[2]), .B0(base[1]), .B1(n135), .C0(n134), 
        .C1(base[0]), .Y(n142) );
  INVXL U224 ( .A(score_A[2]), .Y(n201) );
  INVXL U225 ( .A(score_A[1]), .Y(n148) );
  AOI22XL U226 ( .A0(score_hold[2]), .A1(n201), .B0(score_hold[1]), .B1(n148), 
        .Y(n139) );
  INVXL U227 ( .A(score_A[0]), .Y(n199) );
  OAI211XL U228 ( .A0(score_hold[1]), .A1(n148), .B0(score_hold[0]), .C0(n199), 
        .Y(n138) );
  INVXL U229 ( .A(score_A[3]), .Y(n168) );
  INVXL U230 ( .A(score_B[1]), .Y(n204) );
  NAND2XL U231 ( .A(score_B[2]), .B(n201), .Y(n172) );
  NAND2XL U232 ( .A(score_A[1]), .B(n204), .Y(n176) );
  AOI31XL U233 ( .A0(score_B[0]), .A1(n199), .A2(n176), .B0(n175), .Y(n169) );
  AOI21XL U234 ( .A0(score_B[0]), .A1(n199), .B0(n170), .Y(n171) );
  NAND2XL U235 ( .A(base[2]), .B(n179), .Y(n180) );
  AOI222XL U236 ( .A0(n187), .A1(n186), .B0(base[1]), .B1(n185), .C0(action[0]), .C1(n184), .Y(n191) );
endmodule


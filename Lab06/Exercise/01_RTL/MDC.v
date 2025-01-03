//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/9
//		Version		: v1.0
//   	File Name   : MDC.v
//   	Module Name : MDC
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "HAMMING_IP.v"      // remind to open
//synopsys translate_on

module MDC(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_data, 
	in_mode,
    // Output signals
    out_valid, 
	out_data
);

input clk, rst_n, in_valid;
input [8:0] in_mode;
input [14:0] in_data;

output reg out_valid;
output reg [206:0] out_data;
//==================================================================
// parameter & integer
//==================================================================
parameter s_IDLE          = 3'd0; 
parameter s_START         = 3'd1; 
parameter s_OUT           = 3'd2; 
parameter s_FOUR_STEP1    = 3'd3; 
parameter s_FOUR_STEP2    = 3'd4; 
parameter s_FOUR_STEP3    = 3'd5; 
parameter s_FOUR_STEP4    = 3'd6; 

//==================================================================
// reg & wire
//==================================================================
reg  [2:0] c_s,n_s;

// input store
wire signed[10:0]data_decode;
reg  signed[10:0]data_reg;
wire [4:0] mode_decode;
reg  [4:0] mode;
// counter
reg  [4:0] in_cnt;                              // 0~16
reg  [4:0] in_cnt_delay;                        // 0~16
reg  [3:0] cnt_2_2;                             // 0~8
reg  [1:0] cnt_3_3;                             // 0~3
reg  [1:0] spec_cnt;                            // 0~3
// store result
reg  signed [10:0] in_map      [15:0];          // store input data
reg  signed [22:0] result2_2   [8:0];           // 11*11 an minus => 23-bit for 2*2 result
reg  signed [22:0] special     [3:0];           // for column single space determinant 
reg  signed [34:0] result3_3   [3:0];           // 23*11=34-bit, 34+34+23=35-bit for 3*3 result
wire signed [47:0] result_4_4_reg;              // 48-bit                 
reg  signed [47:0] result_4_4;                  // 48-bit  
// 2*2
wire signed [10:0] in_1, in_2, in_3, in_4;
wire signed [22:0] det1, det2;
// 3*3
reg  signed [10:0] mult1_1, mult2_1, mult3_1;
reg  signed [22:0] mult1_2, mult2_2, mult3_2;
wire signed [33:0] mult1, mult2, mult3;         // 23*11 => 34-bit
wire signed [34:0] subt;                        // 35-bit
wire signed [34:0] add_result;                  // 35-bit
// 4*4
wire signed [45:0] mult_4_4;                    // 35*11 => 46-bit
reg [1:0] idx_4_1, idx_4_2; 
// valid signal
wire result2_2_valid;
wire result3_3_valid;
wire special_valid;
// get direct index
reg [3:0] idx_2_2;
reg [1:0] idx_spec;
// mode
wire mode_2_2, mode_3_3, mode_4_4;

//=================================================================================================
//                                         Call Soft_IP
//=================================================================================================
HAMMING_IP #(11) decode1 (.IN_code(in_data), .OUT_code(data_decode));
HAMMING_IP #(5)  decode2 (.IN_code(in_mode), .OUT_code(mode_decode));
// assign data_decode = in_data;
//=================================================================================================
//                                              FSM
//=================================================================================================
always @(*)
begin
    case(c_s)
        s_IDLE:                                                      //state 0
            n_s = in_valid ? s_START : s_IDLE;
        s_START:                                                     //state 1
            n_s = (in_cnt_delay[4]) ? (mode_4_4 ? s_FOUR_STEP1 : s_OUT) : s_START; 
        s_OUT:                                                       //state 2
            n_s = s_IDLE;
        s_FOUR_STEP1:                                                //state 3
            n_s = s_FOUR_STEP2;
        s_FOUR_STEP2:
            n_s = s_FOUR_STEP3;
        s_FOUR_STEP3:
            n_s = s_FOUR_STEP4;
        s_FOUR_STEP4:
            n_s = s_OUT;
        default:
            n_s = s_IDLE;
    endcase
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        c_s <= s_IDLE;
    else
        c_s <= n_s;
end

//=================================================================================================
//                                          Counter
//=================================================================================================
// in_cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_valid)
        in_cnt <= in_cnt + 1;
    else 
        in_cnt <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        in_cnt_delay <= 0; 
    else
        in_cnt_delay <= in_cnt; 
end
// cnt_2_2
assign result2_2_valid = (in_cnt_delay == 5 || in_cnt_delay == 6 || in_cnt_delay == 7 || in_cnt_delay == 9 || in_cnt_delay == 10 || in_cnt_delay == 11 ||
                          in_cnt_delay == 13 || in_cnt_delay == 14 || in_cnt_delay == 15) ? 1 : 0;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_2_2 <= 0;
    else if(result2_2_valid)
        cnt_2_2 <= cnt_2_2 + 1;
    else if(n_s == s_IDLE)
        cnt_2_2 <= 0;
end
// spec_cnt
assign special_valid   = (in_cnt_delay == 10 || in_cnt_delay == 11 || in_cnt_delay == 14 || in_cnt_delay == 15) ? 1 : 0;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)  
        spec_cnt <= 0;
    else if(special_valid)
        spec_cnt <= spec_cnt + 1;
end
// cnt_3_3
assign result3_3_valid = (in_cnt_delay == 11 || in_cnt_delay == 12 || in_cnt_delay == 15 || in_cnt_delay == 16) ? 1 : 0;  
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_3_3 <= 0;
    else if(result3_3_valid)
        cnt_3_3 <= cnt_3_3 + 1;
end

//=================================================================================================
//                                        Input store
//=================================================================================================
always @(posedge clk) begin
    data_reg <= data_decode; 
end
always @(posedge clk) begin
    if(in_valid && in_cnt == 0)
        mode <= mode_decode;
end
//=================================================================================================
//                                  Computation register storage
//=================================================================================================
// for input store
always @(posedge clk) begin
    if(n_s == s_START) 
        in_map[in_cnt_delay] <= data_reg;
end
// for 2*2 result
always @(posedge clk) begin 
    result2_2[cnt_2_2] <= det1;
end
// for special reg
always @(posedge clk) begin
    if(n_s == s_START || n_s == s_FOUR_STEP1)
        special[spec_cnt] <= det2; 
end
// for 3*3 result
always @(posedge clk) begin
    if(result3_3_valid)
        result3_3[cnt_3_3] <= add_result;
    else if(n_s == s_FOUR_STEP2)
        result3_3[0] <= add_result;
    else if(n_s == s_FOUR_STEP3)
        result3_3[1] <= add_result;
end
// for 4*4 result
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        result_4_4 <= 0;
    else if(idx_4_2 == 3 || idx_4_2 == 2 || idx_4_1 == 1) 
        result_4_4 <= result_4_4_reg;
    else if(n_s == s_IDLE)
        result_4_4 <= 0;
end

//=================================================================================================
//                                     Combination circuit
//=================================================================================================
// mode selection
assign mode_2_2 = (mode == 5'b00100) ? 1 : 0;
assign mode_3_3 = (mode == 5'b00110) ? 1 : 0;
assign mode_4_4 = (mode == 5'b10110) ? 1 : 0;
// assign mode_2_2 = 0;
// assign mode_3_3 = 0;
// assign mode_4_4 = 1;

// ===============  hardware sharing for 2*2 determinant ===================

assign in_1 = (n_s == s_FOUR_STEP1) ? in_map[8]  : data_reg;
assign in_2 = (n_s == s_FOUR_STEP1) ? in_map[15] : in_map[in_cnt_delay-6];
assign in_3 = (n_s == s_FOUR_STEP1) ? in_map[11] : in_map[in_cnt_delay-4];
assign in_4 = (n_s == s_FOUR_STEP1) ? in_map[12] : in_map[in_cnt_delay-2];

// ======== 2*2 stage calculation =========
DET deter1 (.in1(data_reg), .in2(in_map[in_cnt_delay-5]), .in3(in_map[in_cnt_delay-4]), .in4(in_map[in_cnt_delay-1]), 
            .out(det1));

DET deter2 (.in1(in_1), .in2(in_2), .in3(in_3), .in4(in_4), 
            .out(det2));

// ===============  hardware sharing for 3*3 determinant ===================
// get result2_2 index
always @(*) begin
    case(in_cnt_delay)
    11: idx_2_2 = 4;
    12: idx_2_2 = 5;
    15: idx_2_2 = 7;
    16: idx_2_2 = 8;
    default: idx_2_2 = 0;
    endcase
end
// get special index
always @(*) begin
    case(in_cnt_delay)
    11: idx_spec = 0;
    12: idx_spec = 1;
    15: idx_spec = 2;
    16: idx_spec = 3;
    default: idx_spec = 0;
    endcase
end

// mult1_1, mult2_1, mult3_1
always @(*) begin
    if(n_s == s_FOUR_STEP2 || n_s == s_FOUR_STEP3) 
        mult1_1 = in_map[4];
    else
        mult1_1 = in_map[in_cnt_delay-11];
end
always @(*) begin
    if(n_s == s_FOUR_STEP2)
        mult3_1 = in_map[6];
    else if(n_s == s_FOUR_STEP3)
        mult3_1 = in_map[5];
    else
        mult3_1 = in_map[in_cnt_delay-10];
end
always @(*) begin
    if(n_s == s_FOUR_STEP2 || n_s == s_FOUR_STEP3)
        mult2_1 = in_map[7];
    else
        mult2_1 = in_map[in_cnt_delay-9];
end
// mult1_2, mult2_2, mult3_2
always @(*) begin
    if(n_s == s_FOUR_STEP2)
        mult1_2 = result2_2[8];
    else if(n_s == s_FOUR_STEP3)
        mult1_2 = special[3];
    else
        mult1_2 = result2_2[idx_2_2];
end
always @(*) begin
    if(n_s == s_FOUR_STEP2 || n_s == s_FOUR_STEP3)
        mult3_2 = special[0];
    else
        mult3_2 = special[idx_spec];
end
always @(*) begin
    if(n_s == s_FOUR_STEP2)
        mult2_2 = special[2];
    else if(n_s == s_FOUR_STEP3)
        mult2_2 = result2_2[6];
    else
        mult2_2 = result2_2[idx_2_2-1];
end

// ======== 3*3 stage calculation =========
// ex: in_map[0] * result2_2[4]
assign mult1 = mult1_1 * mult1_2;           //in_cnt = 11,12,15,16
// ex: in_map[2] * result2_2[3]
assign mult2 = mult2_1 * mult2_2;           //in_cnt = 11,12,15,16
// ex: in_map[1] * special[0]
assign mult3 = mult3_1 * mult3_2;           //in_cnt = 11,12,15,16
assign subt  = mult1 - mult3;
assign add_result = subt + mult2;

// ======== 4*4 stage calculation =========
// get index to add from STEP2 => 4*4mode latency from 8->6
always @(*) begin
    if(n_s == s_FOUR_STEP2)
        idx_4_1 = 0;
    else if(n_s == s_FOUR_STEP3)
        idx_4_1 = 3;
    else if(c_s == s_FOUR_STEP4)
        idx_4_1 = 2;
    else if(n_s == s_FOUR_STEP4)
        idx_4_1 = 1;
    else
        idx_4_1 = 0;
end
always @(*) begin
    if(n_s == s_FOUR_STEP2)
        idx_4_2 = 3;
    else if(n_s == s_FOUR_STEP3)
        idx_4_2 = 2;
    else if(c_s == s_FOUR_STEP4)
        idx_4_2 = 1;
    else if(n_s == s_FOUR_STEP4)
        idx_4_2 = 0;
    else
        idx_4_2 = 0;
end 

// assign mult_4_4 = in_map[in_cnt] * result3_3[cnt_4_4];
// assign result_4_4_reg = (in_cnt == 0 || in_cnt == 2) ? result_4_4 + mult_4_4 : result_4_4 - mult_4_4; 
assign mult_4_4 = in_map[idx_4_1] * result3_3[idx_4_2];
assign result_4_4_reg = (idx_4_1 == 0 || idx_4_1 == 2) ? result_4_4 + mult_4_4 : result_4_4 - mult_4_4; 


//=================================================================================================
//                                            Output
//=================================================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_valid <= 0;
    else if(n_s == s_OUT && mode_2_2)
        out_valid <= 1;
    else if(c_s == s_OUT && mode_3_3)
        out_valid <= 1;
    else if(n_s == s_OUT && mode_4_4) 
        out_valid <= 1;
    else    
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_data <= 0;
    else if(n_s == s_OUT && mode_2_2)
        out_data <= {result2_2[0], result2_2[1], result2_2[2], result2_2[3], result2_2[4], result2_2[5], result2_2[6], result2_2[7], result2_2[8]};
    else if(c_s == s_OUT && mode_3_3)
        out_data <= {3'b0, {{16{result3_3[0][34]}},result3_3[0]},  {{16{result3_3[1][34]}},result3_3[1]}, {{16{result3_3[2][34]}},result3_3[2]}, {{16{result3_3[3][34]}},result3_3[3]}};
    else if(n_s == s_OUT && mode_4_4)
        out_data <= {{159{result_4_4_reg[47]}},result_4_4_reg};
    else
        out_data <= 0;
end
endmodule

//=================================================================================================
//                                   2*2 Determinant module
//=================================================================================================
module DET (in1, in2, in3, in4, out);
input  signed   [10:0] in1, in2, in3, in4;
output signed   [22:0] out;
wire signed     [21:0] mul1, mul2;

assign mul1 = in1 * in2;
assign mul2 = in3 * in4; 
assign out  = mul1 - mul2;
endmodule 
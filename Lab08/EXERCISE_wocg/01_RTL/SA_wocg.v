/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: SA_wocg.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: Yen-Ning Tung, NYCU AIG
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Spring IC Lab / Exersise Lab08 / SA_wocg
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

module SA(
	// Input signals
	clk,
	rst_n,
	in_valid,
	T,
	in_data,
	w_Q,
	w_K,
	w_V,
	// Output signals
	out_valid,
	out_data
);

input clk;
input rst_n;
input in_valid;
input [3:0] T;
input signed [7:0] in_data;
input signed [7:0] w_Q;
input signed [7:0] w_K;
input signed [7:0] w_V;

output reg out_valid;
output reg signed [63:0] out_data;

// parameter & integer
parameter s_IDLE          = 3'd0; 
parameter s_READ          = 3'd1;
parameter s_CAL_M1        = 3'd2;
parameter s_OUT           = 3'd7;

integer i, j;
// reg & wire
reg  [2:0] c_s,n_s;

reg  [3:0] T_mode;

reg signed [7:0] mat_in [0:7][0:7];
reg signed [7:0] mat_wQV  [0:7][0:7];
reg signed [7:0] mat_wK  [0:7][0:7];
reg signed [18:0] mat_Q  [0:7][0:7];
reg signed [18:0] mat_K  [0:7][0:7];
reg signed [18:0] mat_V  [0:7][0:7];
reg signed [40:0] mat_S  [0:7][0:7];        //A = Q*KT

reg  [5:0] in_cnt;
reg  [2:0] cnt_row;
reg  [2:0] cnt_col;
reg  [2:0] cnt_rowA;
reg  [2:0] cnt_colA;
reg  [1:0] cnt_read;
reg  [5:0] cnt_out;
reg  [2:0] cnt_rowS;
reg  [2:0] cnt_colS;

wire signed [7:0] mat_weight1, mat_weight2, mat_weight3, mat_weight4, mat_weight5, mat_weight6, mat_weight7, mat_weight8;
wire signed [18:0] qkv_gen;             //19-bit

wire signed [40:0] mul1_1, mul1_2, mul1_3, mul1_4, mul1_5, mul1_6, mul1_7, mul1_8;      // 40-bit
wire signed [40:0] matmul_1;             //40-bit
wire signed [40:0] scale;
wire [40:0] matmul_relu;
wire signed[62:0] matmul_2;       // 63-bit

reg [5:0] out_cycle;
//=================================================================================================
//                                            FSM
//=================================================================================================
always @(*)
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            n_s = in_valid ? s_READ : s_IDLE;
        s_READ:                                                //state 1
            n_s = (in_cnt==0 && cnt_read == 3) ? s_CAL_M1 : s_READ;
        s_CAL_M1:
            n_s = (in_cnt == 63) ? s_OUT : s_CAL_M1;
        s_OUT:
            n_s = (cnt_out == out_cycle) ? s_IDLE : s_OUT;
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
//                                            Counter  
//=================================================================================================
// ----- input counter -----
// in_cnt
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(n_s == s_READ || n_s == s_CAL_M1)
        in_cnt <= in_cnt + 1;
    else
        in_cnt <= 0;
end
// cnt_read
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_read <= 0;
    else if(cnt_col==7 && cnt_row==7)
        cnt_read <= cnt_read + 1;
    else if(c_s == s_IDLE)
        cnt_read <= 0;
end
// cnt_row
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_row <= 0;
    else if(cnt_col == 7 && cnt_row == T_mode-1 && c_s == s_OUT)
        cnt_row <= 0;
    else if(cnt_col == 7)
        cnt_row <= cnt_row + 1;
end
// cnt_col
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_col <= 0;
    else if(n_s == s_READ || n_s == s_CAL_M1 || c_s == s_OUT)
        cnt_col <= cnt_col + 1;
    else
        cnt_col <= 0;
end
// ----- calculation counter -----
// cnt_rowA
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_rowA <= 0;
    else if (cnt_rowA == T_mode-1 && cnt_colA == T_mode-1)
        cnt_rowA <= 0;
    else if(n_s == s_CAL_M1 && cnt_colA == T_mode-1)
        cnt_rowA <= cnt_rowA + 1;
    
end
// cnt_colA
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_colA <= 0;
    else if(cnt_colA == T_mode-1)
        cnt_colA <= 0;
    else if(n_s == s_CAL_M1)
        cnt_colA <= cnt_colA + 1;
end
// ----- output counter -----
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_out <= 0;
    else if(c_s == s_OUT)
        cnt_out <= cnt_out + 1;
    else
        cnt_out <= 0;
end
//=================================================================================================
//                                      MatMul_2 => P = S*V
//=================================================================================================
// cnt_rowS 
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_rowS <= 0;
    else if(cnt_colS == 7 && cnt_rowS == T_mode-1 && c_s == s_OUT)
        cnt_rowS <= 0;
    else if(cnt_colS == 7)
        cnt_rowS <= cnt_rowS + 1;
end
// cnt_colS
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_colS <= 0;
    else if(n_s == s_IDLE) 
        cnt_colS <= 0;
    else
        cnt_colS <= cnt_colS + 1;
end

assign matmul_2 = mat_S[cnt_rowS][0] * mat_V[0][cnt_colS] + mat_S[cnt_rowS][1] * mat_V[1][cnt_colS] + mat_S[cnt_rowS][2] * mat_V[2][cnt_colS]
                 +mat_S[cnt_rowS][3] * mat_V[3][cnt_colS] + mat_S[cnt_rowS][4] * mat_V[4][cnt_colS] + mat_S[cnt_rowS][5] * mat_V[5][cnt_colS]
                 +mat_S[cnt_rowS][6] * mat_V[6][cnt_colS] + mat_S[cnt_rowS][7] * mat_V[7][cnt_colS];

//=================================================================================================
//                                      MatMul_1 => A=Q*KT
//=================================================================================================

assign matmul_1 = mat_Q[cnt_rowA][0] * mat_K[cnt_colA][0] + mat_Q[cnt_rowA][1] * mat_K[cnt_colA][1] + mat_Q[cnt_rowA][2] * mat_K[cnt_colA][2]
                 +mat_Q[cnt_rowA][3] * mat_K[cnt_colA][3] + mat_Q[cnt_rowA][4] * mat_K[cnt_colA][4] + mat_Q[cnt_rowA][5] * mat_K[cnt_colA][5]
                 +mat_Q[cnt_rowA][6] * mat_K[cnt_colA][6] + mat_Q[cnt_rowA][7] * mat_K[cnt_colA][7];
assign scale = matmul_1/3;
assign matmul_relu = scale[40] ? 0 : scale;

// do V and A = Q*KT             
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<8;i=i+1) begin
            for(j=0;j<8;j=j+1)
                mat_S[i][j] <= 0;
        end
    end
    else
        mat_S[cnt_rowA][cnt_colA] <= matmul_relu;
end



//=================================================================================================
//                                            QKV generation
//=================================================================================================
assign mat_weight1 = (cnt_read == 1) ? mat_wQV[0][cnt_col] : ((cnt_read == 2) ? mat_wK[0][cnt_col] : mat_wQV[0][cnt_col]);
assign mat_weight2 = (cnt_read == 1) ? mat_wQV[1][cnt_col] : ((cnt_read == 2) ? mat_wK[1][cnt_col] : mat_wQV[1][cnt_col]);
assign mat_weight3 = (cnt_read == 1) ? mat_wQV[2][cnt_col] : ((cnt_read == 2) ? mat_wK[2][cnt_col] : mat_wQV[2][cnt_col]);
assign mat_weight4 = (cnt_read == 1) ? mat_wQV[3][cnt_col] : ((cnt_read == 2) ? mat_wK[3][cnt_col] : mat_wQV[3][cnt_col]);
assign mat_weight5 = (cnt_read == 1) ? mat_wQV[4][cnt_col] : ((cnt_read == 2) ? mat_wK[4][cnt_col] : mat_wQV[4][cnt_col]);
assign mat_weight6 = (cnt_read == 1) ? mat_wQV[5][cnt_col] : ((cnt_read == 2) ? mat_wK[5][cnt_col] : mat_wQV[5][cnt_col]);
assign mat_weight7 = (cnt_read == 1) ? mat_wQV[6][cnt_col] : ((cnt_read == 2) ? mat_wK[6][cnt_col] : mat_wQV[6][cnt_col]);
assign mat_weight8 = (cnt_read == 1) ? mat_wQV[7][cnt_col] : ((cnt_read == 2) ? mat_wK[7][cnt_col] : mat_wQV[7][cnt_col]);


assign qkv_gen = mat_in[cnt_row][0] * mat_weight1 + mat_in[cnt_row][1] * mat_weight2 + mat_in[cnt_row][2] * mat_weight3
                +mat_in[cnt_row][3] * mat_weight4 + mat_in[cnt_row][4] * mat_weight5 + mat_in[cnt_row][5] * mat_weight6
                +mat_in[cnt_row][6] * mat_weight7 + mat_in[cnt_row][7] * mat_weight8;

// read K, do Q                
always @(posedge clk)
begin
    if(cnt_read == 1)
    begin
        if(T_mode==1 && in_cnt < 8)
            mat_Q[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==4 && in_cnt < 32)
            mat_Q[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==8)
            mat_Q[cnt_row][cnt_col] <= qkv_gen;
        else
            mat_Q[cnt_row][cnt_col] <= 0;
    end   
end
// read V, do K             
always @(posedge clk)
begin
    if(cnt_read == 2)
    begin
        if(T_mode==1 && in_cnt < 8)
            mat_K[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==4 && in_cnt < 32)
            mat_K[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==8)
            mat_K[cnt_row][cnt_col] <= qkv_gen;
        else
            mat_K[cnt_row][cnt_col] <= 0;
    end   
end
// do V and A = Q*KT             
always @(posedge clk)
begin
    if(cnt_read == 3)
    begin
        if(T_mode==1 && in_cnt < 8)
            mat_V[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==4 && in_cnt < 32)
            mat_V[cnt_row][cnt_col] <= qkv_gen;
        else if(T_mode==8)
            mat_V[cnt_row][cnt_col] <= qkv_gen;
        else
            mat_V[cnt_row][cnt_col] <= 0;
    end   
end
//=================================================================================================
//                                            Input  
//=================================================================================================
// input data
always @(posedge clk)
begin
    if(in_valid && cnt_read == 0)
        mat_in[cnt_row][cnt_col] <= in_data;
end
// input w_QV
always @(posedge clk)
begin
    if(in_valid && cnt_read == 0)
        mat_wQV[cnt_row][cnt_col] <= w_Q;
    else if(in_valid && cnt_read == 2)
        mat_wQV[cnt_row][cnt_col] <= w_V; 
end
// input w_K
always @(posedge clk)
begin
    if(in_valid && cnt_read == 1)
        mat_wK[cnt_row][cnt_col] <= w_K;
end
// // input w_V
// always @(posedge clk)
// begin
//     if(in_valid && cnt_read == 2)
//         mat_wQV[cnt_row][cnt_col] <= w_V; 
// end

// T mode
always @(posedge clk)
begin
    if(in_valid && in_cnt == 0 && cnt_read==0)
        T_mode <= T;
end




//=================================================================================================
//                                            Output 
//=================================================================================================
always @(*) begin
    case(T_mode)
    1: out_cycle = 7;
    4: out_cycle = 31;
    8: out_cycle = 63;
    default: out_cycle = 0;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if(c_s == s_OUT)
        out_valid <= 1;
    else
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_data <= 0;
    else if(c_s == s_OUT)  
        out_data <= matmul_2;
    else
        out_data <= 0;
end




endmodule

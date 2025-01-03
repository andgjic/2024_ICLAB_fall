//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network
//   Author     		: Tsun-Yen Chen
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CNN(
           //Input Port
           clk,
           rst_n,
           in_valid,
           Img,
           Kernel_ch1,
           Kernel_ch2,
           Weight,
           Opt,

           //Output Port
           out_valid,
           out
       );


//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;
parameter IEEE_one = 32'h3F800000;

parameter s_IDLE    = 3'd0;
parameter s_IN      = 3'd1;
parameter s_CONV    = 3'd2;
parameter s_MAXPOOL = 3'd3;
parameter s_SOFTMAX = 3'd4;
parameter s_OUT     = 3'd7;

input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel_ch1, Kernel_ch2, Weight;
input Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
integer i;
reg  [2:0] c_s,n_s;
reg  [5:0] cnt, in_cnt;
reg  option;
reg  [inst_sig_width+inst_exp_width:0] img_map       [0:24];       //5*5
reg  [inst_sig_width+inst_exp_width:0] kernel_1      [0:11];       //12 個
reg  [inst_sig_width+inst_exp_width:0] kernel_2      [0:11];       //12 個
reg  [inst_sig_width+inst_exp_width:0] conv_ch1      [0:35];       //6*6
reg  [inst_sig_width+inst_exp_width:0] conv_ch2      [0:35];       //6*6
reg  [inst_sig_width+inst_exp_width:0] maxpool       [0:7];        //4*4 *2
reg  [inst_sig_width+inst_exp_width:0] activation    [0:7];        //4*4 *2
wire [inst_sig_width+inst_exp_width:0] maxpool_reg   [0:8];        //3*3
reg  [inst_sig_width+inst_exp_width:0] fc_weight     [0:23];       //24 個weight
reg  [inst_sig_width+inst_exp_width:0] fully_connect [0:2];        //3

reg  [31:0] mult0, mult1, mult2, mult3;                             // convolution window
reg  [1:0] channel;                                                 // record convolution channel status
reg  ker_flag, weight_flag;                                         // control kernel, weight input's flag
reg  [4:0] maxpool_id;                                              // get address from convolution for maxpooling

wire [31:0] pe_out_1, pe_out_2;                                     // Convolution stage temp
wire [31:0] psum_1, psum_2;                                         // Convolution stage temp
wire [31:0] max1_1, max1_2, max1_3, max1_4;                         // Maxpooling stage temp
wire [31:0] max2_1, max2_2, max3, max4, maxpool_result;             // Maxpooling stage temp
wire [31:0] fprod_1, fprod_2, fprod_3, fsum_1, fsum_2, fsum_3;      // Fully_connected stage temp
wire [31:0] exp_in1, exp_in2, exp_out1, exp_out2, exp_out3;         // Activation & Softmax stage temp
wire [31:0] exp_add1, exp_add_one, exp_sub1;                        // Activation & Softmax stage temp
wire [31:0] div_up, div_down, div_out;                              // Activation & Softmax stage temp
wire [31:0] act_up, act_down;                                       // Activation & Softmax stage temp(Activation -> division)
wire [31:0] exp_add2;                                               // Activation & Softmax stage temp(Softmax    -> division)
reg  [31:0] soft_up;                                                // Activation & Softmax stage temp(Softmax    -> division)

 
//=================================================================================================
//
//                                        Counter control
//
//=================================================================================================
// counter for input address
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_cnt == 24 || !in_valid)
        in_cnt <= 0;
    else if(n_s == s_CONV || n_s == s_IN)
        in_cnt <= in_cnt + 1;
end


// counter for convolution address)
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 0;
    else if(cnt == 35)
        cnt <= 0;
    else if(n_s == s_CONV)
        cnt <= cnt + 1;
end

//=================================================================================================
//
//                                            Output
//
//=================================================================================================
// 3 cycles to do decide softmax's Numerator
reg [1:0] cnt_out;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_out <= 0;
    else if(n_s == s_IDLE)
        cnt_out <= 0;
    else if(c_s == s_OUT)
        cnt_out <= cnt_out + 1;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if (c_s == s_OUT)
        out_valid <= 1;
    else
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out <= 0;
    else if (c_s == s_OUT)
        out <= div_out;
    else
        out <= 0;
end

//=================================================================================================
//
//                                      Fully connected
//
//=================================================================================================
// input : activation
// output: fully_connect
// reg [31:0] fully_connect_1, fully_connect_2, fully_connect_3;
reg [3:0] cnt_mp;
reg [3:0] cnt_fc;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_fc <= 0;
    else if(n_s == s_IDLE)
        cnt_fc <= 0;
    else if(cnt_mp > 2)
        cnt_fc <= cnt_fc + 1;
end


wire [31:0] activation_in;
assign activation_in = (cnt_mp > 2) ? activation[0] : 0;

wire [31:0] fc_weight_in1, fc_weight_in2, fc_weight_in3;
reg  [31:0] fc_weight_tmp1, fc_weight_tmp2, fc_weight_tmp3;
// assign fc_weight_in1 = fc_weight[cnt_fc   ];
// assign fc_weight_in2 = fc_weight[cnt_fc+8 ];
// assign fc_weight_in3 = fc_weight[cnt_fc+16];
 
assign fc_weight_in1 = fc_weight_tmp1;
assign fc_weight_in2 = fc_weight_tmp2;
assign fc_weight_in3 = fc_weight_tmp3;
// get fc_weight using fc_cnt
always @(*)
begin
    case(cnt_fc)
        0:
            fc_weight_tmp1 = fc_weight[0];
        1:
            fc_weight_tmp1 = fc_weight[1];
        2:
            fc_weight_tmp1 = fc_weight[2];
        3:
            fc_weight_tmp1 = fc_weight[3];
        4:
            fc_weight_tmp1 = fc_weight[4];
        5:
            fc_weight_tmp1 = fc_weight[5];
        6:
            fc_weight_tmp1 = fc_weight[6];
        7:
            fc_weight_tmp1 = fc_weight[7];
        default:
            fc_weight_tmp1 = fc_weight[0];
    endcase
end
always @(*)
begin
    case(cnt_fc)
        0:
            fc_weight_tmp2 = fc_weight[8];
        1:
            fc_weight_tmp2 = fc_weight[9];
        2:
            fc_weight_tmp2 = fc_weight[10];
        3:
            fc_weight_tmp2 = fc_weight[11];
        4:
            fc_weight_tmp2 = fc_weight[12];
        5:
            fc_weight_tmp2 = fc_weight[13];
        6:
            fc_weight_tmp2 = fc_weight[14];
        7:
            fc_weight_tmp2 = fc_weight[15];
        default:
            fc_weight_tmp2 = fc_weight[8];
    endcase
end
always @(*)
begin
    case(cnt_fc)
        0:
            fc_weight_tmp3 = fc_weight[16];
        1:
            fc_weight_tmp3 = fc_weight[17];
        2:
            fc_weight_tmp3 = fc_weight[18];
        3:
            fc_weight_tmp3 = fc_weight[19];
        4:
            fc_weight_tmp3 = fc_weight[20];
        5:
            fc_weight_tmp3 = fc_weight[21];
        6:
            fc_weight_tmp3 = fc_weight[22];
        7:
            fc_weight_tmp3 = fc_weight[23];
        default:
            fc_weight_tmp3 = fc_weight[16];
    endcase
end

// DWIP: 3 multiplier, 3 adder --------------------------------------------------------------------
// DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_mult1(.a(activation_in), .b(fc_weight_in1), .rnd(3'b0), .z(fprod_1));
// DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_mult2(.a(activation_in), .b(fc_weight_in2), .rnd(3'b0), .z(fprod_2));
// DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_mult3(.a(activation_in), .b(fc_weight_in3), .rnd(3'b0), .z(fprod_3));
DW_fp_add  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_add1  (.a(fully_connect[0]), .b(fprod_1), .rnd(3'b0), .z(fsum_1));
DW_fp_add  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_add2  (.a(fully_connect[1]), .b(fprod_2), .rnd(3'b0), .z(fsum_2));
DW_fp_add  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) fc_add3  (.a(fully_connect[2]), .b(fprod_3), .rnd(3'b0), .z(fsum_3));
// ------------------------------------------------------------------------------------------------

// assign fprod_1 = activation[cnt] * fc_weight[cnt] ;
// assign fprod_2 = activation[cnt] * fc_weight[cnt+8] ;
// assign fprod_3 = activation[cnt] * fc_weight[cnt+16] ;
// assign fsum_1  = fully_connect[0] + fprod_1;
// assign fsum_2  = fully_connect[1] + fprod_2;
// assign fsum_3  = fully_connect[2] + fprod_3;

 
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        fully_connect[0] <= 0;
        fully_connect[1] <= 0;
        fully_connect[2] <= 0;
    end
    else if((c_s == s_MAXPOOL || c_s == s_SOFTMAX) && cnt_fc < 8)
    begin
        fully_connect[0] <= fsum_1;
        fully_connect[1] <= fsum_2;
        fully_connect[2] <= fsum_3;
    end
    else if(n_s == s_IDLE)
    begin
        fully_connect[0] <= 0;
        fully_connect[1] <= 0;
        fully_connect[2] <= 0;
    end
end


//=================================================================================================
//
//                                    Activation & Softmax
//
//=================================================================================================
// input : maxpool、fully_connect
// output: activation

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_mp <= 0;
    else if(n_s == s_IDLE)
        cnt_mp <= 0;
    else if(n_s == s_MAXPOOL)   
        cnt_mp <= cnt_mp + 1;
end

wire [31:0] maxpool_in;
reg  [31:0] maxpool_tmp;
assign maxpool_in = maxpool[0];

assign exp_in1 = (n_s == s_MAXPOOL) ? maxpool_in : fully_connect[0];
assign exp_in2 = (n_s == s_MAXPOOL) ? {~maxpool_in[31], maxpool_in[30:0]} : fully_connect[1];

reg [31:0] exp_out1_pip, exp_out2_pip, exp_out3_pip;
always @(posedge clk )
begin
    exp_out1_pip <= exp_out1;
    exp_out2_pip <= exp_out2;
    exp_out3_pip <= exp_out3;
end

// DWIP: 3 exponential, 3 adder, 1 subtractor -----------------------------------------------------
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) exp_1 (.a(exp_in1), .z(exp_out1));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) exp_2 (.a(exp_in2), .z(exp_out2));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) exp_3 (.a(fully_connect[2]), .z(exp_out3));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)   add_1 (.a(exp_out1_pip), .b(exp_out2_pip), .rnd(3'b0), .z(exp_add1));
DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)   sub_1 (.a(exp_out1_pip), .b(exp_out2_pip), .rnd(3'b0), .z(exp_sub1));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)   add_2 (.a(IEEE_one), .b(exp_out2_pip), .rnd(3'b0), .z(exp_add_one));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)   add_3 (.a(exp_add1), .b(exp_out3_pip), .rnd(3'b0), .z(exp_add2));
// ------------------------------------------------------------------------------------------------
always @(*)
begin
    case(cnt_out)
        0:
            soft_up = exp_out1_pip;
        1:
            soft_up = exp_out2_pip;
        2:
            soft_up = exp_out3_pip;
        default:
            soft_up = 0;
    endcase
end

assign act_up   = option ? exp_sub1 : IEEE_one;
assign act_down = option ? exp_add1 : exp_add_one;
assign div_up   = (c_s == s_OUT) ? soft_up : act_up;
assign div_down = (c_s == s_OUT) ? exp_add2 : act_down;

DW_fp_div #(23,8,0,0) div_1 (.a(div_up), .b(div_down), .rnd(3'b0), .z(div_out));
// assign div_out = exp_in1;   //測試用



// always @(posedge clk)
// begin
//     if(c_s == s_MAXPOOL && cnt_mp > 1)
//     begin
//         case(cnt_mp)                            //改過
//         2:  activation[0] <= div_out;
//         3:  activation[1] <= div_out;
//         4:  activation[2] <= div_out;
//         5:  activation[3] <= div_out;
//         6:  activation[4] <= div_out;
//         7:  activation[5] <= div_out;
//         8:  activation[6] <= div_out;
//         9:  activation[7] <= div_out;
//         endcase
//         // activation[cnt-1] <= div_out;
//     end
// end

//shift to store activation result
always @(posedge clk)
begin
    if(c_s == s_MAXPOOL && cnt_mp > 1)
    begin                          
        activation[0] <= div_out;
        activation[1] <= activation[0];
        activation[2] <= activation[1];
        activation[3] <= activation[2];
        activation[4] <= activation[3];
        activation[5] <= activation[4];
        activation[6] <= activation[5];
        activation[7] <= activation[6];
        // activation[cnt-1] <= div_out;
    end
end



//=================================================================================================
//
//                                       Maxpooling
//
//=================================================================================================
// input: conv_ch1、conv_ch2
// output: maxpool

// delay one cycle for convolution last partial sum, then change n_s to maxpool state
reg maxpool_flag;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        maxpool_flag <= 0;
    else if(channel == 2 && cnt == 35)
        maxpool_flag <= 1;
    else
        maxpool_flag <= 0;
end

// DWIP: 8 comparator -----------------------------------------------------------------------------
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp0 (.a(maxpool_reg[0]), .b(maxpool_reg[1]), .zctr(1'b0), .z1(max1_1));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp1 (.a(maxpool_reg[2]), .b(maxpool_reg[3]), .zctr(1'b0), .z1(max1_2));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp2 (.a(maxpool_reg[4]), .b(maxpool_reg[5]), .zctr(1'b0), .z1(max1_3));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp3 (.a(maxpool_reg[6]), .b(maxpool_reg[7]), .zctr(1'b0), .z1(max1_4));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp4 (.a(max1_1), .b(max1_2), .zctr(1'b0), .z1(max2_1));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp5 (.a(max1_3), .b(max1_4), .zctr(1'b0), .z1(max2_2));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp6 (.a(max2_1), .b(max2_2), .zctr(1'b0), .z1(max3));
DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mp7 (.a(maxpool_reg[8]), .b(max3), .zctr(1'b0), .z1(maxpool_result));
// ------------------------------------------------------------------------------------------------

// assign max1_1  = (maxpool_reg[0] > maxpool_reg[1]) ? maxpool_reg[0] : maxpool_reg[1];
// assign max1_2  = (maxpool_reg[2] > maxpool_reg[3]) ? maxpool_reg[2] : maxpool_reg[3];
// assign max1_3  = (maxpool_reg[4] > maxpool_reg[5]) ? maxpool_reg[4] : maxpool_reg[5];
// assign max1_4  = (maxpool_reg[6] > maxpool_reg[7]) ? maxpool_reg[6] : maxpool_reg[7];
// assign max2_1  = (max1_1 > max1_2) ? max1_1 : max1_2;
// assign max2_2  = (max1_3 > max1_4) ? max1_3 : max1_4;
// assign max3    = (max2_1 > max2_2) ? max2_1 : max2_2;

// shift to store maxpool result
always @(posedge clk)
begin
    // maxpool[cnt]  <= (maxpool_reg[8] > max3) ? maxpool_reg[8] : max3;
    // maxpool[cnt]  <= maxpool_result;
    if(n_s == s_MAXPOOL && cnt_mp < 8)
    begin
        maxpool[0]  <= maxpool_result;
        maxpool[1]  <= maxpool[0];
        maxpool[2]  <= maxpool[1];
        maxpool[3]  <= maxpool[2]; 
        maxpool[4]  <= maxpool[3];
        maxpool[5]  <= maxpool[4];
        maxpool[6]  <= maxpool[5];
        maxpool[7]  <= maxpool[6];
        // maxpool[cnt_mp]  <= maxpool_result;
    end
end
 

always @(*)
begin
    case(cnt_mp)
        0,4:
            maxpool_id = 0;
        1,5:
            maxpool_id = 3;
        2,6:
            maxpool_id = 18;
        3,7:
            maxpool_id = 21;
        default:
            maxpool_id = 0;
    endcase
end
assign maxpool_reg[0] = (cnt_mp < 4) ? conv_ch1[maxpool_id   ] : conv_ch2[maxpool_id   ];       
assign maxpool_reg[1] = (cnt_mp < 4) ? conv_ch1[maxpool_id+1 ] : conv_ch2[maxpool_id+1 ];       
assign maxpool_reg[2] = (cnt_mp < 4) ? conv_ch1[maxpool_id+2 ] : conv_ch2[maxpool_id+2 ];       
assign maxpool_reg[3] = (cnt_mp < 4) ? conv_ch1[maxpool_id+6 ] : conv_ch2[maxpool_id+6 ];       
assign maxpool_reg[4] = (cnt_mp < 4) ? conv_ch1[maxpool_id+7 ] : conv_ch2[maxpool_id+7 ];       
assign maxpool_reg[5] = (cnt_mp < 4) ? conv_ch1[maxpool_id+8 ] : conv_ch2[maxpool_id+8 ];       
assign maxpool_reg[6] = (cnt_mp < 4) ? conv_ch1[maxpool_id+12] : conv_ch2[maxpool_id+12];       
assign maxpool_reg[7] = (cnt_mp < 4) ? conv_ch1[maxpool_id+13] : conv_ch2[maxpool_id+13];       
assign maxpool_reg[8] = (cnt_mp < 4) ? conv_ch1[maxpool_id+14] : conv_ch2[maxpool_id+14];       

//=================================================================================================
//
//                                        Convolution
//
//=================================================================================================
// output: conv_ch1
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        channel <= 0;
    else if(c_s == s_CONV && cnt == 0)
        channel <= channel + 1;
    else if(n_s == s_IDLE)
        channel <= 0;
end


// padding method
always @(posedge clk)
begin
    // row 0
    if(n_s == s_CONV && cnt == 0)
    begin
        mult0 <= option ? img_map[0] : 0;
        mult1 <= option ? img_map[0] : 0;
        mult2 <= option ? img_map[0] : 0;
        mult3 <= img_map[0];
    end
    else if(n_s == s_CONV && cnt < 5)
    begin
        mult0 <= option ? img_map[cnt-1] : 0;
        mult1 <= option ? img_map[cnt] : 0;
        mult2 <= img_map[cnt-1];
        mult3 <= img_map[cnt];
    end
    else if(n_s == s_CONV && cnt == 5)
    begin
        mult0 <= option ? img_map[4] : 0;
        mult1 <= option ? img_map[4] : 0;
        mult2 <= img_map[4];
        mult3 <= option ? img_map[4] : 0;
    end
    //row 1
    else if(n_s == s_CONV && cnt == 6)
    begin
        mult0 <= option ? img_map[0] : 0;
        mult1 <= img_map[0];
        mult2 <= option ? img_map[5] : 0;
        mult3 <= img_map[5];
    end
    else if(n_s == s_CONV && cnt < 11)
    begin
        mult0 <= img_map[cnt-7];
        mult1 <= img_map[cnt-6];
        mult2 <= img_map[cnt-2];
        mult3 <= img_map[cnt-1];
    end
    else if(n_s == s_CONV && cnt == 11)
    begin
        mult0 <= img_map[4];
        mult1 <= option ? img_map[4] : 0;
        mult2 <= img_map[9];
        mult3 <= option ? img_map[9] : 0;
    end
    // row 2
    else if(n_s == s_CONV && cnt == 12)
    begin
        mult0 <= option ? img_map[5] : 0;
        mult1 <= img_map[5];
        mult2 <= option ? img_map[10] : 0;
        mult3 <= img_map[10];
    end
    else if(n_s == s_CONV && cnt < 17)
    begin
        mult0 <= img_map[cnt-8];
        mult1 <= img_map[cnt-7];
        mult2 <= img_map[cnt-3];
        mult3 <= img_map[cnt-2];
    end
    else if(n_s == s_CONV && cnt == 17)
    begin
        mult0 <= img_map[9];
        mult1 <= option ? img_map[9] : 0;
        mult2 <= img_map[14];
        mult3 <= option ? img_map[14] : 0;
    end
    // row 3
    else if(n_s == s_CONV && cnt == 18)
    begin
        mult0 <= option ? img_map[10] : 0;
        mult1 <= img_map[10];
        mult2 <= option ? img_map[15] : 0;
        mult3 <= img_map[15];
    end
    else if(n_s == s_CONV && cnt < 23)
    begin
        mult0 <= img_map[cnt-9];
        mult1 <= img_map[cnt-8];
        mult2 <= img_map[cnt-4];
        mult3 <= img_map[cnt-3];
    end
    else if(n_s == s_CONV && cnt == 23)
    begin
        mult0 <= img_map[14];
        mult1 <= option ? img_map[14] : 0;
        mult2 <= img_map[19];
        mult3 <= option ? img_map[19] : 0;
    end
    // row 4
    else if(n_s == s_CONV && cnt == 24)
    begin
        mult0 <= option ? img_map[15] : 0;
        mult1 <= img_map[15];
        mult2 <= option ? img_map[20] : 0;
        mult3 <= img_map[20];
    end
    else if(n_s == s_CONV && cnt < 29)
    begin
        mult0 <= img_map[cnt-10];
        mult1 <= img_map[cnt-9];
        mult2 <= img_map[cnt-5];
        mult3 <= img_map[cnt-4];
    end
    else if(n_s == s_CONV && cnt == 29)
    begin
        mult0 <= img_map[19];
        mult1 <= option ? img_map[19] : 0;
        mult2 <= img_map[24];
        mult3 <= option ? img_map[24] : 0;
    end
    // row 5
    else if(n_s == s_CONV && cnt == 30)
    begin
        mult0 <= option ? img_map[20] : 0;
        mult1 <= img_map[20];
        mult2 <= option ? img_map[20] : 0;
        mult3 <= option ? img_map[20] : 0;
    end
    else if(n_s == s_CONV && cnt < 35)
    begin
        mult0 <= img_map[cnt-11];
        mult1 <= img_map[cnt-10];
        mult2 <= option ? img_map[cnt-11] : 0;
        mult3 <= option ? img_map[cnt-10] : 0;
    end
    else if(n_s == s_CONV && cnt == 35)
    begin
        mult0 <= img_map[24];
        mult1 <= option ? img_map[24] : 0;
        mult2 <= option ? img_map[24] : 0;
        mult3 <= option ? img_map[24] : 0;
    end

    else
    begin
        mult0 <= 0;
        mult1 <= 0;
        mult2 <= 0;
        mult3 <= 0;
    end
end

// convolution store
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<36;i=i+1)
        begin
            conv_ch1[i] <= 0;
            conv_ch2[i] <= 0;
        end
    end
    else if(c_s == s_CONV && cnt != 0)
    begin
        conv_ch1[cnt-1] <= psum_1;
        conv_ch2[cnt-1] <= psum_2;
    end
    else if(c_s == s_CONV && cnt == 0)      // last convolution did't store problem 
    begin
        conv_ch1[35] <= psum_1;     
        conv_ch2[35] <= psum_2;
    end
    else if(n_s == s_IDLE)
    begin
        for(i=0;i<36;i=i+1)
        begin
            conv_ch1[i] <= 0;
            conv_ch2[i] <= 0;
        end
    end
end

wire [31:0] conv_ch1_in, conv_ch2_in;
assign conv_ch1_in = (c_s == s_CONV && cnt == 0) ? conv_ch1[35] : conv_ch1[cnt-1];
assign conv_ch2_in = (c_s == s_CONV && cnt == 0) ? conv_ch2[35] : conv_ch2[cnt-1];

// partial sum add
// DWIP: 2 adder ----------------------------------------------------------------------------------
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) Partial_sum1 ( .a(pe_out_1), .b(conv_ch1_in), .rnd(3'b0), .z(psum_1));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) Partial_sum2 ( .a(pe_out_2), .b(conv_ch2_in), .rnd(3'b0), .z(psum_2));
// ------------------------------------------------------------------------------------------------

// assign psum_1 = pe_out_1 + conv_ch1[cnt-1];
// assign psum_2 = pe_out_2 + conv_ch2[cnt-1];

reg [31:0] kernel_1_1, kernel_1_2, kernel_1_3, kernel_1_4;
reg [31:0] kernel_2_1, kernel_2_2, kernel_2_3, kernel_2_4;

// assign kernel_1_1 = kernel_1[(channel << 2) + 0];
// assign kernel_1_2 = kernel_1[(channel << 2) + 1];
// assign kernel_1_3 = kernel_1[(channel << 2) + 2];
// assign kernel_1_4 = kernel_1[(channel << 2) + 3];

// assign kernel_2_1 = kernel_2[(channel << 2) + 0];
// assign kernel_2_2 = kernel_2[(channel << 2) + 1];
// assign kernel_2_3 = kernel_2[(channel << 2) + 2];
// assign kernel_2_4 = kernel_2[(channel << 2) + 3];

always @(*)
begin
    case(channel)
        0:
            kernel_1_1 = kernel_1[0];
        1:
            kernel_1_1 = kernel_1[4];
        2:
            kernel_1_1 = kernel_1[8];
        default:
            kernel_1_1 = 0;
    endcase
    case(channel)
        0:
            kernel_1_2 = kernel_1[1];
        1:
            kernel_1_2 = kernel_1[5];
        2:
            kernel_1_2 = kernel_1[9];
        default:
            kernel_1_2 = 0;
    endcase
    case(channel)
        0:
            kernel_1_3 = kernel_1[2];
        1:
            kernel_1_3 = kernel_1[6];
        2:
            kernel_1_3 = kernel_1[10];
        default:
            kernel_1_3 = 0;
    endcase
    case(channel)
        0:
            kernel_1_4 = kernel_1[3];
        1:
            kernel_1_4 = kernel_1[7];
        2:
            kernel_1_4 = kernel_1[11];
        default:
            kernel_1_4 = 0;
    endcase
end
 
always @(*)
begin
    case(channel)
        0:
            kernel_2_1 = kernel_2[0];
        1:
            kernel_2_1 = kernel_2[4];
        2:
            kernel_2_1 = kernel_2[8];
        default:
            kernel_2_1 = 0;
    endcase
    case(channel)
        0:
            kernel_2_2 = kernel_2[1];
        1:
            kernel_2_2 = kernel_2[5];
        2:
            kernel_2_2 = kernel_2[9];
        default:
            kernel_2_2 = 0;
    endcase
    case(channel)
        0:
            kernel_2_3 = kernel_2[2];
        1:
            kernel_2_3 = kernel_2[6];
        2:
            kernel_2_3 = kernel_2[10];
        default:
            kernel_2_3 = 0;
    endcase
    case(channel)
        0:
            kernel_2_4 = kernel_2[3];
        1:
            kernel_2_4 = kernel_2[7];
        2:
            kernel_2_4 = kernel_2[11];
        default:
            kernel_2_4 = 0;
    endcase
end 

wire [31:0] pe_in1_1, pe_in1_2, pe_in1_3;
wire [31:0] pe_in2_1, pe_in2_2, pe_in2_3;

assign pe_in1_1 = (c_s == s_CONV) ? mult0 : activation_in;
assign pe_in1_2 = (c_s == s_CONV) ? mult1 : activation_in;
assign pe_in1_3 = (c_s == s_CONV) ? mult2 : activation_in;
assign pe_in2_1 = (c_s == s_CONV) ? kernel_1_1 : fc_weight_in1;
assign pe_in2_2 = (c_s == s_CONV) ? kernel_1_2 : fc_weight_in2;
assign pe_in2_3 = (c_s == s_CONV) ? kernel_1_3 : fc_weight_in3;

PE PE1(.clk(clk), .mode(1'b0),
       .img1(pe_in1_1), .ker1(pe_in2_1), .out1(fprod_1),
       .img2(pe_in1_2), .ker2(pe_in2_2), .out2(fprod_2),
       .img3(pe_in1_3), .ker3(pe_in2_3), .out3(fprod_3),
       .img4(mult3), .ker4(kernel_1_4),
       .sum_out(pe_out_1));

PE PE2(.clk(clk), .mode(1'b0),
       .img1(mult0), .ker1(kernel_2_1), .out1(),
       .img2(mult1), .ker2(kernel_2_2), .out2(),
       .img3(mult2), .ker3(kernel_2_3), .out3(),
       .img4(mult3), .ker4(kernel_2_4), 
       .sum_out(pe_out_2));

// -------- display ---------
// always @(posedge clk)
// begin
//     if(cnt == 36 && c_s == s_CONV)
//     begin
//         for(i=0;i<36;i=i+6)
//             $display("row %2d = %2d %2d %2d %2d %2d %2d", i/6, conv_ch1[i], conv_ch1[i+1], conv_ch1[i+2], conv_ch1[i+3], conv_ch1[i+4], conv_ch1[i+5]);
//         $display("Finish convolution one conv_ch1 channel!");

//         for(i=0;i<36;i=i+6)
//             $display("row %2d = %2d %2d %2d %2d %2d %2d", i/6, conv_ch2[i], conv_ch2[i+1], conv_ch2[i+2], conv_ch2[i+3], conv_ch2[i+4], conv_ch2[i+5]);
//         $display("Finish convolution one conv_ch2 channel!");
//     end
// end



//=================================================================================================
//
//                                        Input data store
//
//=================================================================================================
// image input
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<25;i=i+1)
            img_map[i] <= 0;
    end
    else if(in_valid)
        img_map[in_cnt] <= Img; 
    else if(n_s == s_IDLE)
    begin
        for(i=0;i<25;i=i+1)
            img_map[i] <= 0;
    end
end
// kernel stop input flag
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ker_flag <= 1;          // start input set 1
    else if(in_cnt == 12)       // Finish kernel input set 0
        ker_flag <= 0;
    else if(n_s == s_IDLE)
        ker_flag <= 1;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<12;i=i+1)
        begin
            kernel_1[i] <= 0;
            kernel_2[i] <= 0;
        end
    end
    else if(in_valid && ker_flag)
    begin
        kernel_1[in_cnt] <= Kernel_ch1;
        kernel_2[in_cnt] <= Kernel_ch2;
    end
end

// weight stop input flag
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        weight_flag <= 1;
    else if(in_cnt == 23)       // start input set 1
        weight_flag <= 0;       // Finish Weight input set 0
    else if(n_s == s_IDLE)
        weight_flag <= 1;
end
// fully connected weight
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<24;i=i+1)
            fc_weight[i] <= 0;
    end
    else if(in_valid && weight_flag)
    begin
        fc_weight[23] <= Weight;
        fc_weight[22] <= fc_weight[23];
        fc_weight[21] <= fc_weight[22];
        fc_weight[20] <= fc_weight[21];
        fc_weight[19] <= fc_weight[20];
        fc_weight[18] <= fc_weight[19];
        fc_weight[17] <= fc_weight[18];
        fc_weight[16] <= fc_weight[17];
        fc_weight[15] <= fc_weight[16];
        fc_weight[14] <= fc_weight[15];
        fc_weight[13] <= fc_weight[14];
        fc_weight[12] <= fc_weight[13];
        fc_weight[11] <= fc_weight[12];
        fc_weight[10] <= fc_weight[11];
        fc_weight[9 ] <= fc_weight[10];
        fc_weight[8 ] <= fc_weight[9 ];
        fc_weight[7 ] <= fc_weight[8 ];
        fc_weight[6 ] <= fc_weight[7 ];
        fc_weight[5 ] <= fc_weight[6 ];
        fc_weight[4 ] <= fc_weight[5 ];
        fc_weight[3 ] <= fc_weight[4 ];
        fc_weight[2 ] <= fc_weight[3 ];
        fc_weight[1 ] <= fc_weight[2 ];
        fc_weight[0 ] <= fc_weight[1 ];
        // fc_weight[in_cnt] <= Weight;
    end
end

// Activation & Padding option
// 0 : Sigmoid & {Zero}
// 1 : tanh & {Replication}
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        option <= 0;
    else if(n_s == s_IN && in_cnt == 0)
        option <= Opt;
end


//=================================================================================================
//
//                                              FSM
//
//=================================================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        c_s <= s_IDLE;
    else
        c_s <= n_s;
end

always @(*)
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            n_s = in_valid ? s_IN : s_IDLE;
        s_IN:
            n_s = (in_cnt == 3) ? s_CONV : s_IN;
        s_CONV:                                                       //state 1
            n_s = (maxpool_flag) ? s_MAXPOOL : s_CONV;
        s_MAXPOOL:
            n_s = (cnt_mp == 10) ? s_SOFTMAX : s_MAXPOOL;
        s_SOFTMAX:
            n_s = s_OUT;
        s_OUT:
            n_s = (cnt_out == 2) ? s_IDLE : s_OUT;
        default:
            n_s = s_IDLE;
    endcase
end


endmodule



    //=================================================================================================
    //
    //                                              Module PE
    //
    //=================================================================================================

    module PE
    #(
        parameter inst_sig_width = 23,
        parameter inst_exp_width = 8,
        parameter inst_ieee_compliance = 0,
        parameter inst_arch_type = 0
    )
    (
        input wire [inst_sig_width+inst_exp_width:0] img1 ,
        input wire [inst_sig_width+inst_exp_width:0] ker1 ,
        input wire [inst_sig_width+inst_exp_width:0] img2 ,
        input wire [inst_sig_width+inst_exp_width:0] ker2 ,
        input wire [inst_sig_width+inst_exp_width:0] img3 ,
        input wire [inst_sig_width+inst_exp_width:0] ker3 ,
        input wire [inst_sig_width+inst_exp_width:0] img4 ,
        input wire [inst_sig_width+inst_exp_width:0] ker4 ,
        input clk ,
        input mode,     //output port behavior     => mode0: multiplier, mode1: adder
                        //input for adder behavior => mode0: do PE, mode1: do adder

        output wire [inst_sig_width+inst_exp_width:0] sum_out,
        output wire [inst_sig_width+inst_exp_width:0] out1,
        output wire [inst_sig_width+inst_exp_width:0] out2,
        output wire [inst_sig_width+inst_exp_width:0] out3
    );
// wire [inst_sig_width+inst_exp_width:0] prod1, prod2, prod3, prod4;
wire [inst_sig_width+inst_exp_width:0] prod1, prod2, prod3, prod4;
wire [inst_sig_width+inst_exp_width:0] sum1, sum2, sum3;
wire [inst_sig_width+inst_exp_width:0] add_in1_1, add_in1_2, add_in1_3;
wire [inst_sig_width+inst_exp_width:0] add_in2_1, add_in2_2, add_in2_3;

// output select
assign out1 = prod1;
assign out2 = prod2;
assign out3 = prod3;
assign sum_out = sum3;
// // input select
// assign add_in1_1 = mode ? img1 : prod1;
// assign add_in1_2 = mode ? img2 : prod3;
// assign add_in1_3 = mode ? img3 : sum1 ;
// assign add_in2_1 = mode ? ker1 : prod2;
// assign add_in2_2 = mode ? ker2 : prod4;
// assign add_in2_3 = mode ? ker3 : sum2 ;
  

// DWIP: 4 multiplier, 3 adder -------------------------------------------------------------------
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
           U1_mult ( .a(img1), .b(ker1), .rnd(3'b0), .z(prod1), .status( ) );

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
           U2_mult ( .a(img2), .b(ker2), .rnd(3'b0), .z(prod2), .status( ) );

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
           U3_mult ( .a(img3), .b(ker3), .rnd(3'b0), .z(prod3), .status( ) );

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
           U4_mult ( .a(img4), .b(ker4), .rnd(3'b0), .z(prod4), .status( ) );

// adder tree
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          U1_add ( .a(prod1), .b(prod2), .rnd(3'b0),/*.op(1'b0),*/ .z(sum1), .status() );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          U2_add ( .a(prod3), .b(prod4), .rnd(3'b0),/*.op(1'b0),*/ .z(sum2), .status() );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          U3_add ( .a(sum1), .b(sum2), .rnd(3'b0),/*.op(1'b0),*/ .z(sum3), .status() );
 
// 4 sum adder
// DW_fp_sum4 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) 
//           U1_sum (.a(prod1), .b(prod2), .c(prod3), .d(prod4), .rnd(3'b0), .z(sum3), .status() );
// ------------------------------------------------------------------------------------------------

// ========== Testing ============
// assign prod1 = img1 * ker1;
// assign prod2 = img2 * ker2;
// assign prod3 = img3 * ker3;
// assign prod4 = img4 * ker4;
// assign sum1 = prod1 + prod2;
// assign sum2 = prod3 + prod4;
// assign sum3 = sum1 + sum2;

endmodule

module ISP(
    // --- Input Signals ---
    input clk,
    input rst_n,
    input in_valid,
    input [3:0] in_pic_no,
    input [1:0] in_mode,
    input [1:0] in_ratio_mode,

    // --- Output Signals ---
    output reg out_valid,
    output reg [7:0] out_data,
    
    // ----- DRAM Signals -----
    // ==================================
    // <<<< AXI write address channel >>>>
    // ==================================
    // src master
    output     [3:0]  awid_s_inf,
    output reg [31:0] awaddr_s_inf,
    output reg [2:0]  awsize_s_inf,
    output reg [1:0]  awburst_s_inf,
    output reg [7:0]  awlen_s_inf,
    output reg        awvalid_s_inf,
    // src slave
    input             awready_s_inf,
    // -----------------------------
    // ==================================
    // <<<<< AXI write data channel >>>>>
    // ==================================
    // src master
    output reg [127:0]  wdata_s_inf,
    output reg          wlast_s_inf,
    output reg          wvalid_s_inf,
    // src slave
    input               wready_s_inf,
    
    // ==================================
    // <<< AXI write response channel >>>
    // ==================================
    // src slave
    input [3:0]    bid_s_inf,
    input [1:0]    bresp_s_inf,
    input          bvalid_s_inf,
    // src master 
    output reg     bready_s_inf,
    // -----------------------------
    
    // ==================================
    // <<<< AXI read address channel >>>>
    // ==================================
    // src master
    output      [3:0]   arid_s_inf, 
    output reg  [31:0]  araddr_s_inf,
    output reg  [7:0]   arlen_s_inf,
    output reg  [2:0]   arsize_s_inf,
    output reg  [1:0]   arburst_s_inf,
    output reg     arvalid_s_inf,
    // src slave
    input          arready_s_inf,
    // -----------------------------

    // ==================================
    // <<<<< AXI read data channel >>>>>
    // ==================================
    // slave
    input [3:0]    rid_s_inf,
    input [127:0]  rdata_s_inf,
    input [1:0]    rresp_s_inf,
    input          rlast_s_inf,
    input          rvalid_s_inf,
    // master
    output reg     rready_s_inf
    
);
//==================================================================
// parameter & integer
//==================================================================
parameter s_IDLE          = 3'd0; 
parameter s_WAIT_DRAM     = 3'd1;
parameter s_DRAM_READ     = 3'd2;
parameter s_DRAM_WRITE    = 3'd3;
parameter s_EXPOSE_SKIP   = 3'd4;
parameter s_PREOUT        = 3'd6;
parameter s_OUT           = 3'd7; 

integer i,j;
//==================================================================
// reg & wire
//==================================================================\
// --- FSM ---
reg  [2:0] c_s,n_s;
// --- Input ---
reg  [3:0]  pic_no;
reg  [1:0]  camera_mode;
reg  [1:0]  ratio;
reg  [31:0] pic_addr;
reg  [31:0] pic_addr_hold;

// --- counter ---
reg  [7:0] cnt_dram_w;
reg  [5:0] cnt_dram_w2;
reg  [5:0] cnt_dram_r;
reg  [1:0] pic_channel;
reg  [1:0] pic_channel_w;

// --- Auto focus ---
reg  [31:0] dram_data;
reg  [23:0] focus_map [11:0];
reg  fifo_valid1, fifo_valid2;
// col difference
wire signed [8:0] col_diff1, col_diff2, col_diff3, col_diff4, col_diff5;
wire [7:0]  col_diff1_abs, col_diff2_abs, col_diff3_abs, col_diff4_abs, col_diff5_abs;
wire [9:0]  col_sum1;
wire [10:0] col_sum2;
reg  [8:0]  sumc_2_2;
reg  [11:0] sumc_4_4;
reg  [13:0] sumc_6_6;
wire col_22_valid;
wire col_44_valid;
wire col_66_valid;
// row difference
wire signed [8:0] row_diff1, row_diff2, row_diff3, row_diff4, row_diff5, row_diff6;
wire [7:0]  row_diff1_abs, row_diff2_abs, row_diff3_abs, row_diff4_abs, row_diff5_abs, row_diff6_abs;
wire [8:0]  row_sum1;
wire [9:0]  row_sum2;
wire [10:0] row_sum3;
reg  [8:0]  sumr_2_2;
reg  [11:0] sumr_4_4;
reg  [13:0] sumr_6_6;
wire row_22_valid;
wire row_44_valid;
wire row_66_valid;
// contrast
reg [9:0]  contrast_2_2;
reg [12:0] contrast_4_4;
reg [14:0] contrast_6_6;
// find max
wire [12:0] cmp1;
wire [14:0] max_contrast;
reg  [1:0]  max_contrast_idx;

// --- Auto exposure ---
reg  [127:0] exposure;
reg  [383:0] expose_fifo; 
reg  [127:0] gray_reg;
reg  [17:0]  gray_sum;
wire [12:0]  gray_add;
wire [7:0]   gray_avg;
reg  wvalid_delay1;
reg  wvalid_delay2;
reg  [15:0]  pic_expose_valid;
reg  [15:0]  expose_skip_valid;
reg  [7:0]  gray_avg_store [15:0];

// --- Focus + exposure hybrid ---
reg  [31:0] gray_reg_focus;
reg  [31:0] expose_data;
reg  focus_valid1,focus_valid2;
wire _col_22_valid;
wire _col_44_valid;
wire _col_66_valid;
wire _row_22_valid;
wire _row_44_valid;
wire _row_66_valid;
reg  [15:0] skip_focus_valid;
reg  [1:0]  max_contrast_idx_store [15:0];



wire [7:0] pic_max;
wire [7:0] pic_min;
reg  [7:0] max_r;
reg  [7:0] max_g;
reg  [7:0] max_b;
reg  [7:0] min_r;
reg  [7:0] min_g;
reg  [7:0] min_b;

reg  [7:0] max_avg;
reg  [7:0] min_avg;
wire [7:0] wb_result;

reg  [15:0]  white_balance_valid;
wire [127:0] sort_in;
wire wb_valid;
wire [1:0] wb_pic_channel;
reg  [7:0] wb_result_store [15:0];
//=================================================================================================
//                         FFFFFFFFFF       SSSSSS       MM      MM
//                         FF             SS             MMM    MMM
//                         FFFFFFFFFF      SSSSSSS       MM M  M MM
//                         FF                     SS     MM  MM  MM
//                         FF              SSSSSSS       MM      MM
//=================================================================================================
always @(*) 
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            if(in_valid) begin
                if((in_mode[0] && (!pic_expose_valid[in_pic_no] || (expose_skip_valid[in_pic_no] && in_ratio_mode == 2))) || (in_mode == 0 && skip_focus_valid[in_pic_no]) || (in_mode[1] && !white_balance_valid[in_pic_no]))  
                    n_s = s_EXPOSE_SKIP;
                else
                    n_s = s_WAIT_DRAM;
            end
            else
                n_s = s_IDLE;               
        s_WAIT_DRAM:                                                //state 1
            n_s = rvalid_s_inf ? s_DRAM_READ : s_WAIT_DRAM;
        s_DRAM_READ:                                                //state 2
            if(rvalid_s_inf)
                n_s = s_DRAM_READ;
            else if(camera_mode == 1)
                n_s = s_DRAM_WRITE;
            else 
                n_s = s_PREOUT;
        s_DRAM_WRITE:                                               //state 3
            n_s = wlast_s_inf ? s_PREOUT : s_DRAM_WRITE;               
        s_EXPOSE_SKIP:                                              //state 4
            n_s = s_OUT;
        s_PREOUT:                                                   //state 6
            n_s = s_OUT;
        s_OUT:                                                      //state 7
            n_s = s_IDLE;
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
//                            SSSSSS   RRRRRRRR        AAA      MM      MM
//                          SS         RR      RR     AA AA     MMM    MMM
//                           SSSSSSS   RRRRRRRRR     AA   AA    MM M  M MM
//                                  SS RR   RRR     AAAAAAAAA   MM  MM  MM
//                           SSSSSSS   RR     RRR  AA       AA  MM      MM
//=================================================================================================
// Without using SRAM Version

//=================================================================================================
//                        DDDDDDD    RRRRRRRR        AAA      MM      MM
//                        DD    DD   RR      RR     AA AA     MMM    MMM
//                        DD     DD  RRRRRRRRR     AA   AA    MM M  M MM
//                        DD    DD   RR   RRR     AAAAAAAAA   MM  MM  MM
//                        DDDDDDD    RR     RRR  AA       AA  MM      MM
//=================================================================================================
// picture channel
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pic_channel <= 0;
    else if(cnt_dram_r == 63 && pic_channel != 2)
        pic_channel <= pic_channel + 1;
    else if(c_s == s_IDLE)
        pic_channel <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pic_channel_w <= 0;
    else if(cnt_dram_w2 == 63 && pic_channel_w != 2)
        pic_channel_w <= pic_channel_w + 1;
    else if(c_s == s_IDLE)
        pic_channel_w <= 0;
end

// read DRAM counter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_dram_r <= 0;
    else if(rvalid_s_inf)
        cnt_dram_r <= cnt_dram_r + 1;
    else if(c_s == s_IDLE && in_mode == 0) 
        cnt_dram_r <= 26;
    else if(c_s == s_IDLE)
        cnt_dram_r <= 0;
end

//=================================================================================================
//         MM      MM      OOOOOO      DDDDDDD      EEEEEEEEEE    00000000 
//         MMM    MMM    OO      OO    DD     DD    EE            00    00
//         MM M  M MM   OO        OO   DD      DD   EEEEEEEEEE    00    00  (Auto focus mode)  
//         MM  MM  MM    OO      OO    DD      DD   EE            00    00
//         MM      MM      OOOOOO      DDDDDDDD     EEEEEEEEEE    00000000     
//=================================================================================================
// get dram data and send to do graycsale
always @(*) begin
    if(fifo_valid1)
        dram_data = {rdata_s_inf[127:120], rdata_s_inf[119:112], rdata_s_inf[111:104]}; 
    else if(fifo_valid2)
        dram_data = {rdata_s_inf[23:16], rdata_s_inf[15:8], rdata_s_inf[7:0]};
    else
        dram_data = 0;
end

// 6*6 8-bit register for auto focus
always @(posedge clk)
begin
    if(!camera_mode[0] && (fifo_valid1 || fifo_valid2)) begin  // do while mode0
        if (pic_channel == 0) begin
            for(i=0;i<12;i=i+1)
                focus_map[i+1] <= focus_map[i];
            focus_map[0] <= {gray_reg[7:0], gray_reg[15:8], gray_reg[23:16]};
        end
        else begin
            for(i=0;i<12;i=i+1)
                focus_map[i+1] <= focus_map[i];
            focus_map[0] <= {gray_reg[7:0] + focus_map[11][23:16], gray_reg[15:8] + focus_map[11][15:8], gray_reg[23:16] + focus_map[11][7:0]};
        end
    end
    else if(focus_valid1 || focus_valid2) begin             // do while mode1
        if (pic_channel_w == 0) begin
            for(i=0;i<12;i=i+1)
                focus_map[i+1] <= focus_map[i];
            focus_map[0] <= {gray_reg_focus[7:0], gray_reg_focus[15:8], gray_reg_focus[23:16]};
        end
        else begin
            for(i=0;i<12;i=i+1)
                focus_map[i+1] <= focus_map[i];
            focus_map[0] <= {gray_reg_focus[7:0] + focus_map[11][23:16], gray_reg_focus[15:8] + focus_map[11][15:8], gray_reg_focus[23:16] + focus_map[11][7:0]};
        end
    end
end

// push focus FIFO valid signal
always @(*) begin
    case(cnt_dram_r)
    26,28,30,32,34,36:
        fifo_valid1 = 1;
    default:
        fifo_valid1 = 0;
    endcase
end
always @(*) begin
    case(cnt_dram_r)
    27,29,31,33,35,37:
        fifo_valid2 = 1;
    default:
        fifo_valid2 = 0;
    endcase
end
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv do focus while exposure vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
always @(*) begin
    if(focus_valid1)
        expose_data = {exposure[127:120], exposure[119:112], exposure[111:104]}; 
    else if(focus_valid2)
        expose_data = {exposure[23:16], exposure[15:8], exposure[7:0]};
    else
        expose_data = 0;
end
// push focus FIFO valid signal
always @(*) begin
    case(cnt_dram_w2)
    25,27,29,31,33,35:
        focus_valid1 = 1;
    default:
        focus_valid1 = 0;
    endcase
end
always @(*) begin
    case(cnt_dram_w2)
    26,28,30,32,34,36:
        focus_valid2 = 1;
    default:
        focus_valid2 = 0;
    endcase
end
// grayscale focus
always @(*) begin
    case(pic_channel)
    0,2:
    begin
        gray_reg_focus[7:0]   =  expose_data[7:0]   >> 2;
        gray_reg_focus[15:8]  =  expose_data[15:8]  >> 2;
        gray_reg_focus[23:16] =  expose_data[23:16] >> 2;
        gray_reg_focus[31:24] =  expose_data[31:24] >> 2;
    end
    1: 
    begin
        gray_reg_focus[7:0]   =  expose_data[7:0]   >> 1;
        gray_reg_focus[15:8]  =  expose_data[15:8]  >> 1;
        gray_reg_focus[23:16] =  expose_data[23:16] >> 1;
        gray_reg_focus[31:24] =  expose_data[31:24] >> 1;
    end
    default: gray_reg_focus = 0;
    endcase
end

//
// ---------- Skip focus detection ----------
//
// 1: skip auto focus
// 0: remain do auto focus
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        skip_focus_valid <= 16'b0; 
    else if(camera_mode[0] && ratio != 2)
    begin
        skip_focus_valid[pic_no] <= 1;        
    end   
end

//
// ---------- col difference ----------
//
assign col_diff1 = focus_map[0][7:0]   - focus_map[0][15:8];
assign col_diff2 = focus_map[0][15:8]  - focus_map[0][23:16];
assign col_diff3 = focus_map[0][23:16] - focus_map[1][7:0];               
assign col_diff4 = focus_map[1][7:0]   - focus_map[1][15:8];
assign col_diff5 = focus_map[1][15:8]  - focus_map[1][23:16];
// col difference absolute value
assign col_diff1_abs = col_diff1[8] ? ~col_diff1 + 1 : col_diff1;
assign col_diff2_abs = col_diff2[8] ? ~col_diff2 + 1 : col_diff2;
assign col_diff3_abs = col_diff3[8] ? ~col_diff3 + 1 : col_diff3;       // 2*2 wanted
assign col_diff4_abs = col_diff4[8] ? ~col_diff4 + 1 : col_diff4;
assign col_diff5_abs = col_diff5[8] ? ~col_diff5 + 1 : col_diff5;
// column sum
assign col_sum1 = col_diff2_abs + col_diff3_abs + col_diff4_abs;        // 4*4 wanted
assign col_sum2 = col_sum1  + col_diff1_abs + col_diff5_abs;            // 6*6 wanted

assign col_22_valid = (!camera_mode[0] && pic_channel[1] && (cnt_dram_r == 32 || cnt_dram_r == 34)) ? 1 : 0; 
assign col_44_valid = (!camera_mode[0] && pic_channel[1] && (cnt_dram_r == 30 || cnt_dram_r == 32 || cnt_dram_r == 34 || cnt_dram_r == 36)) ? 1 : 0; 
assign col_66_valid = (!camera_mode[0] && pic_channel[1] && (cnt_dram_r == 28 || cnt_dram_r == 30 || cnt_dram_r == 32 || cnt_dram_r == 34 || cnt_dram_r == 36 || cnt_dram_r == 38)) ? 1 : 0; 
assign _col_22_valid = (camera_mode[0] && pic_channel_w[1] && (cnt_dram_w2 == 31 || cnt_dram_w2 == 33)) ? 1 : 0; 
assign _col_44_valid = (camera_mode[0] && pic_channel_w[1] && (cnt_dram_w2 == 29 || cnt_dram_w2 == 31 || cnt_dram_w2 == 33 || cnt_dram_w2 == 35)) ? 1 : 0; 
assign _col_66_valid = (camera_mode[0] && pic_channel_w[1] && (cnt_dram_w2 == 27 || cnt_dram_w2 == 29 || cnt_dram_w2 == 31 || cnt_dram_w2 == 33 || cnt_dram_w2 == 35 || cnt_dram_w2 == 37)) ? 1 : 0; 

// sum of 2*2 column difference
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sumc_2_2 <= 0;
    else if(col_22_valid || _col_22_valid)
        sumc_2_2 <= sumc_2_2 + col_diff3_abs;
    else if(c_s == s_IDLE)
        sumc_2_2 <= 0;
end
// sum of 4*4 column difference
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sumc_4_4 <= 0;
    else if(col_44_valid || _col_44_valid)
        sumc_4_4 <= sumc_4_4 + col_sum1;
    else if(c_s == s_IDLE)
        sumc_4_4 <= 0;
end
// sum of 6*6 column difference
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sumc_6_6 <= 0;
    else if(col_66_valid || _col_66_valid)
        sumc_6_6 <= sumc_6_6 + col_sum2;
    else if(c_s == s_IDLE)
        sumc_6_6 <= 0;
end

//
// ---------- row difference ----------
//
assign row_diff1 = focus_map[0][7:0]   - focus_map[2][7:0];
assign row_diff2 = focus_map[0][15:8]  - focus_map[2][15:8];
assign row_diff3 = focus_map[0][23:16] - focus_map[2][23:16];               
assign row_diff4 = focus_map[1][7:0]   - focus_map[3][7:0];
assign row_diff5 = focus_map[1][15:8]  - focus_map[3][15:8];
assign row_diff6 = focus_map[1][23:16] - focus_map[3][23:16]; 
// row difference absolute value
assign row_diff1_abs = row_diff1[8] ? ~row_diff1 + 1 : row_diff1;
assign row_diff2_abs = row_diff2[8] ? ~row_diff2 + 1 : row_diff2;
assign row_diff3_abs = row_diff3[8] ? ~row_diff3 + 1 : row_diff3;       
assign row_diff4_abs = row_diff4[8] ? ~row_diff4 + 1 : row_diff4;
assign row_diff5_abs = row_diff5[8] ? ~row_diff5 + 1 : row_diff5;
assign row_diff6_abs = row_diff6[8] ? ~row_diff6 + 1 : row_diff6;
// row sum
assign row_sum1 = row_diff3_abs + row_diff4_abs;                    // 2*2 wanted
assign row_sum2 = row_sum1 + row_diff2_abs + row_diff5_abs;         // 4*4 wanted
assign row_sum3 = row_sum2 + row_diff1_abs + row_diff6_abs;         // 6*6 wanted

assign row_22_valid =  (!camera_mode[0] && pic_channel[1] && cnt_dram_r == 34) ? 1 : 0; 
assign row_44_valid =  (!camera_mode[0] && pic_channel[1] && (cnt_dram_r == 32 || cnt_dram_r == 34 || cnt_dram_r == 36)) ? 1 : 0; 
assign row_66_valid =  (!camera_mode[0] && pic_channel[1] && (cnt_dram_r == 30 || cnt_dram_r == 32 || cnt_dram_r == 34 || cnt_dram_r == 36 || cnt_dram_r == 38)) ? 1 : 0; 
assign _row_22_valid =  (camera_mode[0] && pic_channel_w[1] && cnt_dram_w2 == 33) ? 1 : 0; 
assign _row_44_valid =  (camera_mode[0] && pic_channel_w[1] && (cnt_dram_w2 == 31 || cnt_dram_w2 == 33 || cnt_dram_w2 == 35)) ? 1 : 0; 
assign _row_66_valid =  (camera_mode[0] && pic_channel_w[1] && (cnt_dram_w2 == 29 || cnt_dram_w2 == 31 || cnt_dram_w2 == 33 || cnt_dram_w2 == 35 || cnt_dram_w2 == 37)) ? 1 : 0; 

// sum of 2*2 row difference
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
        sumr_2_2 <= 0;
    else if(row_22_valid || _row_22_valid)
        sumr_2_2 <= sumr_2_2 + row_sum1;
    else if(c_s == s_IDLE)
        sumr_2_2 <= 0;
end
// sum of 4*4 row difference
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sumr_4_4 <= 0;
    else if(row_44_valid || _row_44_valid)
        sumr_4_4 <= sumr_4_4 + row_sum2;
    else if(c_s == s_IDLE)
        sumr_4_4 <= 0;
end
// sum of 6*6 row difference
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sumr_6_6 <= 0;
    else if(row_66_valid || _row_66_valid) 
        sumr_6_6 <= sumr_6_6 + row_sum3;
    else if(c_s == s_IDLE)
        sumr_6_6 <= 0;
end
// 
// ---------- contrast ----------
//
// assign contrast_2_2 = (sumc_2_2 + sumr_2_2) >> 2;           // div4  -> >>2
// assign contrast_4_4 = (sumc_4_4 + sumr_4_4) >> 4;           // div16 -> >>4
// assign contrast_6_6 = ((sumc_6_6 + sumr_6_6) >> 2)/9;       // div36 -> >>2 -> div9
always @(posedge clk) begin
    contrast_2_2 <= (sumc_2_2 + sumr_2_2) >> 2;           // div4  -> >>2
    contrast_4_4 <= (sumc_4_4 + sumr_4_4) >> 4;           // div16 -> >>4
    contrast_6_6 <= ((sumc_6_6 + sumr_6_6) >> 2)/9;       // div36 -> >>2 -> div9
end


assign cmp1 = (contrast_2_2 > contrast_4_4) ? contrast_2_2 : contrast_4_4;
assign max_contrast = (cmp1 > contrast_6_6) ? cmp1         : contrast_6_6;

always @(*) begin
    if(max_contrast == contrast_2_2)
        max_contrast_idx = 0;
    else if(max_contrast == contrast_4_4)
        max_contrast_idx = 1;
    else
        max_contrast_idx = 2;
end

// store max_contrast_idx for pre-calculate auto focus
always @(posedge clk)
begin
    if(n_s == s_DRAM_READ && camera_mode[0]) 
        max_contrast_idx_store[pic_no] <= max_contrast_idx;
end
//=================================================================================================
//         MM      MM      OOOOOO      DDDDDDD      EEEEEEEEEE       11      
//         MMM    MMM    OO      OO    DD     DD    EE            11 11
//         MM M  M MM   OO        OO   DD      DD   EEEEEEEEEE       11      (Auto exposure mode)  
//         MM  MM  MM    OO      OO    DD      DD   EE               11
//         MM      MM      OOOOOO      DDDDDDDD     EEEEEEEEEE    11111111        
//=================================================================================================
// register store for write DRAM
always @(posedge clk) begin
    if(rvalid_s_inf || wready_s_inf)
        expose_fifo <= {expose_fifo[255:0], rdata_s_inf}; 
end


// auto exposure
always @(*) begin
    case(ratio)
    0: 
    begin
        exposure[7:0]     = expose_fifo[263:256] >> 2;  
        exposure[15:8]    = expose_fifo[271:264] >> 2;  
        exposure[23:16]   = expose_fifo[279:272] >> 2;  
        exposure[31:24]   = expose_fifo[287:280] >> 2;  
        exposure[39:32]   = expose_fifo[295:288] >> 2;  
        exposure[47:40]   = expose_fifo[303:296] >> 2;  
        exposure[55:48]   = expose_fifo[311:304] >> 2;  
        exposure[63:56]   = expose_fifo[319:312] >> 2;  
        exposure[71:64]   = expose_fifo[327:320] >> 2;  
        exposure[79:72]   = expose_fifo[335:328] >> 2;  
        exposure[87:80]   = expose_fifo[343:336] >> 2;  
        exposure[95:88]   = expose_fifo[351:344] >> 2;  
        exposure[103:96]  = expose_fifo[359:352] >> 2;  
        exposure[111:104] = expose_fifo[367:360] >> 2;  
        exposure[119:112] = expose_fifo[375:368] >> 2;  
        exposure[127:120] = expose_fifo[383:376] >> 2;  
    end
    1:
    begin
        exposure[7:0]     = expose_fifo[263:256] >> 1;
        exposure[15:8]    = expose_fifo[271:264] >> 1;
        exposure[23:16]   = expose_fifo[279:272] >> 1;
        exposure[31:24]   = expose_fifo[287:280] >> 1;
        exposure[39:32]   = expose_fifo[295:288] >> 1;
        exposure[47:40]   = expose_fifo[303:296] >> 1;
        exposure[55:48]   = expose_fifo[311:304] >> 1;
        exposure[63:56]   = expose_fifo[319:312] >> 1;
        exposure[71:64]   = expose_fifo[327:320] >> 1;
        exposure[79:72]   = expose_fifo[335:328] >> 1;
        exposure[87:80]   = expose_fifo[343:336] >> 1;
        exposure[95:88]   = expose_fifo[351:344] >> 1;
        exposure[103:96]  = expose_fifo[359:352] >> 1;
        exposure[111:104] = expose_fifo[367:360] >> 1;
        exposure[119:112] = expose_fifo[375:368] >> 1;
        exposure[127:120] = expose_fifo[383:376] >> 1;
    end
    2: exposure = expose_fifo[383:256];
    3: 
    begin
        exposure[7:0]     = (expose_fifo[263])  ? 8'd255 : expose_fifo[263:256] << 1;
        exposure[15:8]    = (expose_fifo[271])  ? 8'd255 : expose_fifo[271:264] << 1;
        exposure[23:16]   = (expose_fifo[279])  ? 8'd255 : expose_fifo[279:272] << 1;
        exposure[31:24]   = (expose_fifo[287])  ? 8'd255 : expose_fifo[287:280] << 1;
        exposure[39:32]   = (expose_fifo[295])  ? 8'd255 : expose_fifo[295:288] << 1;
        exposure[47:40]   = (expose_fifo[303])  ? 8'd255 : expose_fifo[303:296] << 1;
        exposure[55:48]   = (expose_fifo[311])  ? 8'd255 : expose_fifo[311:304] << 1;
        exposure[63:56]   = (expose_fifo[319])  ? 8'd255 : expose_fifo[319:312] << 1;
        exposure[71:64]   = (expose_fifo[327])  ? 8'd255 : expose_fifo[327:320] << 1;
        exposure[79:72]   = (expose_fifo[335])  ? 8'd255 : expose_fifo[335:328] << 1;
        exposure[87:80]   = (expose_fifo[343])  ? 8'd255 : expose_fifo[343:336] << 1;
        exposure[95:88]   = (expose_fifo[351])  ? 8'd255 : expose_fifo[351:344] << 1;
        exposure[103:96]  = (expose_fifo[359])  ? 8'd255 : expose_fifo[359:352] << 1;
        exposure[111:104] = (expose_fifo[367])  ? 8'd255 : expose_fifo[367:360] << 1;
        exposure[119:112] = (expose_fifo[375])  ? 8'd255 : expose_fifo[375:368] << 1;
        exposure[127:120] = (expose_fifo[383])  ? 8'd255 : expose_fifo[383:376] << 1;
    end
    default: exposure = 0;
    endcase
end

// grayscale
always @(*) begin
    case(pic_channel)
    0,2:
    begin
        gray_reg[7:0]     = camera_mode[0] ? exposure[7:0]   >> 2 : dram_data[7:0]   >> 2;
        gray_reg[15:8]    = camera_mode[0] ? exposure[15:8]  >> 2 : dram_data[15:8]  >> 2;
        gray_reg[23:16]   = camera_mode[0] ? exposure[23:16] >> 2 : dram_data[23:16] >> 2;
        gray_reg[31:24]   = camera_mode[0] ? exposure[31:24] >> 2 : dram_data[31:24] >> 2;
        gray_reg[39:32]   = exposure[39:32]   >> 2;
        gray_reg[47:40]   = exposure[47:40]   >> 2;
        gray_reg[55:48]   = exposure[55:48]   >> 2;
        gray_reg[63:56]   = exposure[63:56]   >> 2;
        gray_reg[71:64]   = exposure[71:64]   >> 2;
        gray_reg[79:72]   = exposure[79:72]   >> 2;
        gray_reg[87:80]   = exposure[87:80]   >> 2;
        gray_reg[95:88]   = exposure[95:88]   >> 2;
        gray_reg[103:96]  = exposure[103:96]  >> 2;
        gray_reg[111:104] = exposure[111:104] >> 2;
        gray_reg[119:112] = exposure[119:112] >> 2;
        gray_reg[127:120] = exposure[127:120] >> 2;
    end
    1: 
    begin
        gray_reg[7:0]     = camera_mode[0] ? exposure[7:0]   >> 1 : dram_data[7:0]   >> 1;
        gray_reg[15:8]    = camera_mode[0] ? exposure[15:8]  >> 1 : dram_data[15:8]  >> 1;
        gray_reg[23:16]   = camera_mode[0] ? exposure[23:16] >> 1 : dram_data[23:16] >> 1;
        gray_reg[31:24]   = camera_mode[0] ? exposure[31:24] >> 1 : dram_data[31:24] >> 1;
        gray_reg[39:32]   = exposure[39:32]   >> 1;
        gray_reg[47:40]   = exposure[47:40]   >> 1;
        gray_reg[55:48]   = exposure[55:48]   >> 1;
        gray_reg[63:56]   = exposure[63:56]   >> 1;
        gray_reg[71:64]   = exposure[71:64]   >> 1;
        gray_reg[79:72]   = exposure[79:72]   >> 1;
        gray_reg[87:80]   = exposure[87:80]   >> 1;
        gray_reg[95:88]   = exposure[95:88]   >> 1;
        gray_reg[103:96]  = exposure[103:96]  >> 1;
        gray_reg[111:104] = exposure[111:104] >> 1;
        gray_reg[119:112] = exposure[119:112] >> 1;
        gray_reg[127:120] = exposure[127:120] >> 1;
    end
    default: gray_reg = 0;
    endcase
end



// grayscale value sum (same channel)
assign gray_add = gray_reg[7:0] + gray_reg[15:8] + gray_reg[23:16] + gray_reg[31:24] + 
                  gray_reg[39:32] + gray_reg[47:40] + gray_reg[55:48] + gray_reg[63:56] + 
                  gray_reg[71:64] + gray_reg[79:72] + gray_reg[87:80] + gray_reg[95:88] + 
                  gray_reg[103:96]+ gray_reg[111:104] + gray_reg[119:112] + gray_reg[127:120];

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        gray_sum <= 0;
    else if(wvalid_delay2)          // ...important!
        gray_sum <= gray_sum + gray_add;
    else if(c_s == s_IDLE)
        gray_sum <= 0;
        
end
assign gray_avg = gray_sum >> 10;

// picture zero detection
// 1: keep auto exposure
// 0: picture all zero skip to output 
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pic_expose_valid <= 16'b1111111111111111; 
    else if(n_s == s_DRAM_READ && camera_mode == 1)
    begin
        if(exposure == 0)
            pic_expose_valid[pic_no] <= 0;     
        else
            pic_expose_valid[pic_no] <= 1;    
    end   
end

// store gray_avg to skip when ratio = 2
always @(posedge clk)
begin
    if(c_s == s_DRAM_WRITE) 
        gray_avg_store[pic_no] <= gray_avg;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        expose_skip_valid <= 16'b0; 
    else if(camera_mode == 1)
        expose_skip_valid[pic_no] <= 1;      
end

//=================================================================================================
//         MM      MM      OOOOOO      DDDDDDD      EEEEEEEEEE    222222222   
//         MMM    MMM    OO      OO    DD     DD    EE                   22
//         MM M  M MM   OO        OO   DD      DD   EEEEEEEEEE    222222222   (Auto white balance mode)  
//         MM  MM  MM    OO      OO    DD      DD   EE            22
//         MM      MM      OOOOOO      DDDDDDDD     EEEEEEEEEE    222222222        
//=================================================================================================

// picture white balance detection
// 1: keep read DRAM to white balance
// 0: output the result while doing exposure also do white balance at the same time  
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        white_balance_valid <= 16'b1111111111111111; 
    else if(n_s == s_DRAM_READ && camera_mode == 1)
    begin
        white_balance_valid[pic_no] <= 0; 
    end   
end
// do white balance while exposure
assign sort_in        = (camera_mode[0]) ? wdata_s_inf : rdata_s_inf;
assign wb_valid       = (camera_mode[0]) ? wready_s_inf : rvalid_s_inf;
assign wb_pic_channel = (camera_mode[0]) ? pic_channel_w : pic_channel;
always @(posedge clk)
begin
    if(wlast_s_inf)
        wb_result_store[pic_no] <= wb_result;
end
// ---------------
// origin version1
// ---------------

SORT16_2 sorting(.clk(clk), .IN(sort_in), .Omax(pic_max), .Omin(pic_min));

// Maximum of each channel
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        max_r <= 0;
    else if(wb_valid && wb_pic_channel == 0)               
        max_r <= (pic_max > max_r) ? pic_max : max_r;
    else if(c_s == s_IDLE)
        max_r <= 0;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        max_g <= 0;
    else if(wb_valid && wb_pic_channel == 1)               
        max_g <= (pic_max > max_g) ? pic_max : max_g;
    else if(c_s == s_IDLE)
        max_g <= 0;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        max_b <= 0;
    else if(wb_valid && wb_pic_channel == 2)               
        max_b <= (pic_max > max_b) ? pic_max : max_b;
    else if(c_s == s_IDLE)
        max_b <= 0;
end

// Minimum of each channel
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        min_r <= 255;
    else if(wb_valid && wb_pic_channel == 0)               
        min_r <= (pic_min < min_r) ? pic_min : min_r;
    else if(c_s == s_IDLE)
        min_r <= 255;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        min_g <= 255;
    else if(wb_valid && wb_pic_channel == 1)               
        min_g <= (pic_min < min_g) ? pic_min : min_g;
    else if(c_s == s_IDLE)
        min_g <= 255;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        min_b <= 255;
    else if(wb_valid && wb_pic_channel == 2)               
        min_b <= (pic_min < min_b) ? pic_min : min_b;
    else if(c_s == s_IDLE)
        min_b <= 255;
end

// get picture average of min_max
always @(posedge clk)
begin
    max_avg = (max_r + max_g + max_b)/3;
    min_avg = (min_r + min_g + min_b)/3;
end
assign wb_result = (max_avg + min_avg) >> 1;

// always @(posedge clk)
// begin
//     if(c_s == s_DRAM_READ && rvalid_s_inf) begin
//         $display("input 16 value: %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d",rdata_s_inf[7:0]   ,rdata_s_inf[15:8]  ,rdata_s_inf[23:16] ,rdata_s_inf[31:24] ,rdata_s_inf[39:32] ,rdata_s_inf[47:40] ,rdata_s_inf[55:48] ,rdata_s_inf[63:56] ,rdata_s_inf[71:64] ,rdata_s_inf[79:72] ,rdata_s_inf[87:80] ,rdata_s_inf[95:88] ,rdata_s_inf[103:96],rdata_s_inf[111:104],rdata_s_inf[119:112],rdata_s_inf[127:120]);
//         $display("pic max = %3d", pic_max);
//         $display("pic min = %3d", pic_min);
//         $finish;
//     end
// end 


//=================================================================================================                     
//                               AAA           XX   XX       IIIIIIIIII
//                              AA AA           XX XX            II
//                             AA   AA           XXX             II
//                            AAAAAAAAA         XX XX            II
//                           AA       AA       XX   XX       IIIIIIIIII
//=================================================================================================

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< AXI READ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// ==========================================
//                 AXI control
// ==========================================

// ==========================================
//                 AR channel
// ==========================================
// * arvalid
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        arvalid_s_inf <= 0;
    else if(in_valid && n_s == s_WAIT_DRAM)               // in_valid -> n_s == s_waitdram
        arvalid_s_inf <= 1;
    else if(arready_s_inf)
        arvalid_s_inf <= 0;
end

// * araddr
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        araddr_s_inf <= 0;
    else if(in_valid)
        araddr_s_inf <= pic_addr;
end
// ==========================================
//                 R channel
// ==========================================
// * rready
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        rready_s_inf <= 0;
    else 
        rready_s_inf <= 1;
end

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< AXI Write >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (only in mode 1)
// ==========================================
//                 AXI control
// ==========================================

// write counter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_dram_w <= 0;
    else if(c_s == s_IDLE)
        cnt_dram_w <= 0;
    else if(wready_s_inf)
        cnt_dram_w <= cnt_dram_w + 1;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_dram_w2 <= 0;
    else if(c_s == s_IDLE)
        cnt_dram_w2 <= 0;
    else if(wready_s_inf)
        cnt_dram_w2 <= cnt_dram_w2 + 1;
end

// ==========================================
//                 AW channel 
// ==========================================
// * awvalid
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        awvalid_s_inf <= 0;
    else if(arready_s_inf && camera_mode == 1)            // write request when rvalid in mode1
        awvalid_s_inf <= 1;
    else if(awready_s_inf)
        awvalid_s_inf <= 0;
end
// * awaddr
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        awaddr_s_inf <= 0;
    else if(arready_s_inf && camera_mode == 1)
        awaddr_s_inf <= pic_addr_hold;
end
// ==========================================
//                 W channel 
// ==========================================
// * wvalid
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        wvalid_s_inf <= 0;
    else if(rvalid_s_inf && camera_mode == 1 || cnt_dram_w == 188 || cnt_dram_w == 189 || cnt_dram_w == 190)        
        wvalid_s_inf <= 1;
    else
        wvalid_s_inf <= 0;
    
end
always @(posedge clk)
begin             
    wvalid_delay1 <= wvalid_s_inf;
    wvalid_delay2 <= wvalid_delay1;
end

// * wdata
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        wdata_s_inf <= 0;                  
    else if(wvalid_delay2)
        wdata_s_inf <= exposure;   
    else
        wdata_s_inf <= 0;                  
end


// * wlast
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)      
        wlast_s_inf <= 0;
    else if(cnt_dram_w == awlen_s_inf-1)        
        wlast_s_inf <= 1;    
    else
        wlast_s_inf <= 0;
end
// ==========================================
//                 B channel 
// ==========================================
// ==========================================
//                AXI default 
// ==========================================
assign awid_s_inf     =  4'b0;
assign arid_s_inf     =  4'b0; 
// read length
always @(*) begin
    if(!rst_n)
        arlen_s_inf   = 0;
    else if(camera_mode)
        arlen_s_inf   = 8'd191;       // 64*3 -1
    else
        arlen_s_inf   = 8'd140;       // 64*2+38-26 -1

end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        awsize_s_inf  <= 0;
        arsize_s_inf  <= 0;
        awburst_s_inf  <= 0;
        arburst_s_inf  <= 0;
        // arlen_s_inf   <= 0;
        awlen_s_inf   <= 0;
        bready_s_inf  <= 0;
    end
    else
    begin
        awsize_s_inf  <= 3'b100;       // 1 transfer 16 bytes
        arsize_s_inf  <= 3'b100;       // 1 transfer 16 bytes
        awburst_s_inf  <= 2'b01;       // INCR mode
        arburst_s_inf  <= 2'b01;       // INCR mode
        // arlen_s_inf   <= 8'd191;       // 64*3 -1
        awlen_s_inf   <= 8'd191;       // 64*3 -1
        bready_s_inf  <= 1'b1;
    end
end


//=================================================================================================
//                                            Output  
//=================================================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if(n_s == s_OUT)
        out_valid <= 1;
    else
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_data <= 0;
    else if(n_s == s_OUT)
    begin
        if(camera_mode == 1) begin
            if(ratio == 2)
                out_data <= gray_avg_store[pic_no];
            else
                out_data <= gray_avg;
        end
            
        else if(camera_mode == 2) begin
            if(white_balance_valid[pic_no])
                out_data <= wb_result;
            else
                out_data <= wb_result_store[pic_no];
        end
        else if(skip_focus_valid[pic_no])
            out_data <= max_contrast_idx_store[pic_no];
        else
            out_data <= max_contrast_idx;
    end
    else 
        out_data <= 0;
end

//=================================================================================================
//                                            Input  
//=================================================================================================
// pic number
always @(posedge clk) begin     
    if(in_valid)
        pic_no <= in_pic_no;  
end
// camera mode (0: auto focus, 1: auto exposure)
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        camera_mode <= 0;
    else if(in_valid)
        camera_mode <= in_mode;  
end
// ratio for exposure (0: 0.25x, 1: 0.5x, 2: 1x, 3: 2x)
always @(posedge clk) begin
    if(in_valid)
        ratio <= in_ratio_mode;
end
// pic_address hold
always @(posedge clk) begin
    if(in_valid)
        pic_addr_hold <= pic_addr;
end

// picture starting address
always @(*) begin
    if(in_mode != 0) begin
        case(in_pic_no)     // exposure 、 Average min_max read all
        0:  pic_addr = 32'h10000;    // 32'h10000
        1:  pic_addr = 32'h10C00;    // 32'h10000 + 3072*1
        2:  pic_addr = 32'h11800;    // 32'h10000 + 3072*2
        3:  pic_addr = 32'h12400;    // 32'h10000 + 3072*3
        4:  pic_addr = 32'h13000;    // 32'h10000 + 3072*4
        5:  pic_addr = 32'h13C00;    // 32'h10000 + 3072*5
        6:  pic_addr = 32'h14800;    // 32'h10000 + 3072*6
        7:  pic_addr = 32'h15400;    // 32'h10000 + 3072*7
        8:  pic_addr = 32'h16000;    // 32'h10000 + 3072*8
        9:  pic_addr = 32'h16C00;    // 32'h10000 + 3072*9
        10: pic_addr = 32'h17800;    // 32'h10000 + 3072*10
        11: pic_addr = 32'h18400;    // 32'h10000 + 3072*11
        12: pic_addr = 32'h19000;    // 32'h10000 + 3072*12
        13: pic_addr = 32'h19C00;    // 32'h10000 + 3072*13
        14: pic_addr = 32'h1A800;    // 32'h10000 + 3072*14
        15: pic_addr = 32'h1B400;    // 32'h10000 + 3072*15
        default: pic_addr = 0;
        endcase
    end
    else begin
        case(in_pic_no)     // focus read from middle
        0:  pic_addr = 32'h10000 + 416;    // 32'h10000           + 26cycle * 16
        1:  pic_addr = 32'h10C00 + 416;    // 32'h10000 + 3072*1  + 26cycle * 16
        2:  pic_addr = 32'h11800 + 416;    // 32'h10000 + 3072*2  + 26cycle * 16
        3:  pic_addr = 32'h12400 + 416;    // 32'h10000 + 3072*3  + 26cycle * 16
        4:  pic_addr = 32'h13000 + 416;    // 32'h10000 + 3072*4  + 26cycle * 16
        5:  pic_addr = 32'h13C00 + 416;    // 32'h10000 + 3072*5  + 26cycle * 16
        6:  pic_addr = 32'h14800 + 416;    // 32'h10000 + 3072*6  + 26cycle * 16
        7:  pic_addr = 32'h15400 + 416;    // 32'h10000 + 3072*7  + 26cycle * 16
        8:  pic_addr = 32'h16000 + 416;    // 32'h10000 + 3072*8  + 26cycle * 16
        9:  pic_addr = 32'h16C00 + 416;    // 32'h10000 + 3072*9  + 26cycle * 16
        10: pic_addr = 32'h17800 + 416;    // 32'h10000 + 3072*10 + 26cycle * 16
        11: pic_addr = 32'h18400 + 416;    // 32'h10000 + 3072*11 + 26cycle * 16
        12: pic_addr = 32'h19000 + 416;    // 32'h10000 + 3072*12 + 26cycle * 16
        13: pic_addr = 32'h19C00 + 416;    // 32'h10000 + 3072*13 + 26cycle * 16
        14: pic_addr = 32'h1A800 + 416;    // 32'h10000 + 3072*14 + 26cycle * 16
        15: pic_addr = 32'h1B400 + 416;    // 32'h10000 + 3072*15 + 26cycle * 16
        default: pic_addr = 0;
        endcase
    end  
end 


endmodule


module SORT16_2(clk, IN, Omax, Omin);
input clk;
input [127:0] IN;
output [7:0] Omax, Omin;


wire [7:0] I [15:0];
wire [7:0] max_temp_1[7:0];
wire [7:0] max_temp_2 [3:0];
// wire [7:0] max_temp_3 [1:0];
reg [7:0] max_temp_3 [1:0];

assign I[0]  = IN[7:0];
assign I[1]  = IN[15:8];
assign I[2]  = IN[23:16];
assign I[3]  = IN[31:24];
assign I[4]  = IN[39:32];
assign I[5]  = IN[47:40];
assign I[6]  = IN[55:48];
assign I[7]  = IN[63:56];
assign I[8]  = IN[71:64];
assign I[9]  = IN[79:72];
assign I[10] = IN[87:80];
assign I[11] = IN[95:88];
assign I[12] = IN[103:96];
assign I[13] = IN[111:104];
assign I[14] = IN[119:112];
assign I[15] = IN[127:120];

// --- find max --- 
// first
assign max_temp_1[0] = (I[0] > I[1]) ? I[0] : I[1];
assign max_temp_1[1] = (I[2] > I[3]) ? I[2] : I[3];
assign max_temp_1[2] = (I[4] > I[5]) ? I[4] : I[5];
assign max_temp_1[3] = (I[6] > I[7]) ? I[6] : I[7];
assign max_temp_1[4] = (I[8] > I[9]) ? I[8] : I[9];
assign max_temp_1[5] = (I[10] > I[11]) ? I[10] : I[11];
assign max_temp_1[6] = (I[12] > I[13]) ? I[12] : I[13];
assign max_temp_1[7] = (I[14] > I[15]) ? I[14] : I[15];

// second
assign max_temp_2[0] = (max_temp_1[0] > max_temp_1[1]) ? max_temp_1[0] : max_temp_1[1];
assign max_temp_2[1] = (max_temp_1[2] > max_temp_1[3]) ? max_temp_1[2] : max_temp_1[3];
assign max_temp_2[2] = (max_temp_1[4] > max_temp_1[5]) ? max_temp_1[4] : max_temp_1[5];
assign max_temp_2[3] = (max_temp_1[6] > max_temp_1[7]) ? max_temp_1[6] : max_temp_1[7];

// third
// assign max_temp_3[0] = (max_temp_2[0] > max_temp_2[1]) ? max_temp_2[0] : max_temp_2[1];
// assign max_temp_3[1] = (max_temp_2[2] > max_temp_2[3]) ? max_temp_2[2] : max_temp_2[3];
always @(posedge clk) begin
    max_temp_3[0] <= (max_temp_2[0] > max_temp_2[1]) ? max_temp_2[0] : max_temp_2[1];
    max_temp_3[1] <= (max_temp_2[2] > max_temp_2[3]) ? max_temp_2[2] : max_temp_2[3];
end


// last
assign Omax = (max_temp_3[0] > max_temp_3[1]) ? max_temp_3[0] : max_temp_3[1];

// --- find min ---
// first
wire [7:0] min_temp_1 [7:0];
assign min_temp_1[0] = (I[0] < I[1]) ? I[0] : I[1];
assign min_temp_1[1] = (I[2] < I[3]) ? I[2] : I[3];
assign min_temp_1[2] = (I[4] < I[5]) ? I[4] : I[5];
assign min_temp_1[3] = (I[6] < I[7]) ? I[6] : I[7];
assign min_temp_1[4] = (I[8] < I[9]) ? I[8] : I[9];
assign min_temp_1[5] = (I[10] < I[11]) ? I[10] : I[11];
assign min_temp_1[6] = (I[12] < I[13]) ? I[12] : I[13];
assign min_temp_1[7] = (I[14] < I[15]) ? I[14] : I[15];

// second
wire [7:0] min_temp_2 [3:0];
assign min_temp_2[0] = (min_temp_1[0] < min_temp_1[1]) ? min_temp_1[0] : min_temp_1[1];
assign min_temp_2[1] = (min_temp_1[2] < min_temp_1[3]) ? min_temp_1[2] : min_temp_1[3];
assign min_temp_2[2] = (min_temp_1[4] < min_temp_1[5]) ? min_temp_1[4] : min_temp_1[5];
assign min_temp_2[3] = (min_temp_1[6] < min_temp_1[7]) ? min_temp_1[6] : min_temp_1[7];

// third
// wire [7:0] min_temp_3 [1:0];
reg [7:0] min_temp_3 [1:0];
// assign min_temp_3[0] = (min_temp_2[0] < min_temp_2[1]) ? min_temp_2[0] : min_temp_2[1];
// assign min_temp_3[1] = (min_temp_2[2] < min_temp_2[3]) ? min_temp_2[2] : min_temp_2[3];
always @(posedge clk) begin
    min_temp_3[0] <= (min_temp_2[0] < min_temp_2[1]) ? min_temp_2[0] : min_temp_2[1];
    min_temp_3[1] <= (min_temp_2[2] < min_temp_2[3]) ? min_temp_2[2] : min_temp_2[3];
end


// forth
assign Omin = (min_temp_3[0] < min_temp_3[1]) ? min_temp_3[0] : min_temp_3[1];
endmodule



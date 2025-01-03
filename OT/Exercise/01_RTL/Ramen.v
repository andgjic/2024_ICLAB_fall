module Ramen(
    // Input Registers
    input clk, 
    input rst_n, 
    input in_valid,
    input selling,
    input portion, 
    input [1:0] ramen_type,

    // Output Signals
    output reg out_valid_order,
    output reg success,

    output reg out_valid_tot,
    output reg [27:0] sold_num,
    output reg [14:0] total_gain
);


//==============================================//
//             Parameter and Integer            //
//==============================================//

// ramen_type
parameter TONKOTSU = 0;
parameter TONKOTSU_SOY = 1;
parameter MISO = 2;
parameter MISO_SOY = 3;

// initial ingredient
parameter NOODLE_INIT = 12000;
parameter BROTH_INIT = 41000;
parameter TONKOTSU_SOUP_INIT =  9000;
parameter MISO_INIT = 1000;
parameter SOY_SAUSE_INIT = 1500;

// FSM
parameter s_IDLE          = 3'd0;  
parameter s_IN            = 3'd1; 
parameter s_OUT_STATUS    = 3'd2;
parameter s_OUT           = 3'd3;


integer i,j;
//==============================================//
//                 reg declaration              //
//==============================================// 
reg  [2:0] c_s,n_s;

reg  [5:0] cnt, in_cnt;

reg  port;
reg  [1:0] ramen;

reg  [13:0] noodle;
reg  [15:0] broth;
reg  [14:0] tonk_soup;
reg  [9:0]  miso;
reg  [10:0] soy_sause;

reg  [27:0] sold_number;

wire  [7:0] noodle_p;
reg   [9:0] broth_p;
reg   [7:0] tonk_soup_p;
reg   [6:0] soy_sause_p;
reg   [5:0] miso_p;

wire noodle_valid;
wire broth_valid;
wire tonk_soup_valid;
wire miso_valid;
wire soy_sause_valid;
wire success_valid;

wire start_flag;

// check success
assign noodle_valid =       (noodle     >= noodle_p)    ? 1 : 0;
assign broth_valid =        (broth      >= broth_p)     ? 1 : 0;
assign tonk_soup_valid =    (tonk_soup  >= tonk_soup_p) ? 1 : 0;
assign miso_valid =         (miso       >= miso_p)? 1 : 0;
assign soy_sause_valid =    (soy_sause  >= soy_sause_p)      ? 1 : 0;
assign success_valid = noodle_valid && broth_valid && tonk_soup_valid && soy_sause_valid && miso_valid;


wire  [13:0] noodle_b;
wire  [15:0] broth_b;
wire  [14:0] tonk_soup_b;
wire  [9:0]  miso_b;
wire  [10:0] soy_sause_b;

assign noodle_b     = (n_s == s_OUT_STATUS && success_valid) ? noodle - noodle_p         : noodle   ;
assign broth_b      = (n_s == s_OUT_STATUS && success_valid) ? broth  - broth_p          : broth    ;
assign tonk_soup_b  = (n_s == s_OUT_STATUS && success_valid) ? tonk_soup - tonk_soup_p   : tonk_soup;
assign miso_b       = (n_s == s_OUT_STATUS && success_valid) ? miso      - miso_p        : miso     ;
assign soy_sause_b  = (n_s == s_OUT_STATUS && success_valid) ? soy_sause - soy_sause_p   : soy_sause;

reg [6:0]  tonk_cnt;
reg [6:0]  tonksoy_cnt;
reg [6:0]  miso_cnt;
reg [6:0]  misosoy_cnt;

wire [6:0]  tonk_cnt_reg;
wire [6:0]  tonksoy_cnt_reg;
wire [6:0]  miso_cnt_reg;
wire [6:0]  misosoy_cnt_reg;

assign tonk_cnt_reg     = tonk_cnt + 1 ;
assign tonksoy_cnt_reg  = tonksoy_cnt + 1 ;
assign miso_cnt_reg     = miso_cnt + 1;
assign misosoy_cnt_reg  = misosoy_cnt + 1;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        tonk_cnt  <=  0;
    else if(c_s == s_OUT)
        tonk_cnt  <=  0;
    else if(ramen == 0 && success)
        tonk_cnt  <=  tonk_cnt_reg;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        tonksoy_cnt  <=  0;
    else if(c_s == s_OUT)
        tonksoy_cnt  <=  0;
    else if (ramen == 1 && success)
        tonksoy_cnt  <=  tonksoy_cnt_reg;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        miso_cnt  <=  0;
    else if(c_s == s_OUT)
        miso_cnt  <=  0;
    else if(ramen == 2 && success)
        miso_cnt  <=  miso_cnt_reg;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        misosoy_cnt  <=  0;
    else if(c_s == s_OUT)
        misosoy_cnt  <=  0;
    else if(ramen == 3 && success)
        misosoy_cnt  <=  misosoy_cnt_reg;
end





//=================================================================================================
//                                            Input  
//=================================================================================================
reg selling_delay;
always @(posedge clk) begin
    selling_delay <= selling;  
end

assign start_flag = selling && ~selling_delay;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        noodle <= 0;  
        broth  <= 0;
        tonk_soup <= 0;
        miso <= 0;
        soy_sause <= 0;
    end
    else if(start_flag || n_s == s_OUT)
    begin
        noodle <= NOODLE_INIT;  
        broth  <= BROTH_INIT;
        tonk_soup <= TONKOTSU_SOUP_INIT;
        miso <= MISO_INIT;
        soy_sause <= SOY_SAUSE_INIT;
    end
    else if(n_s == s_OUT_STATUS)
    begin
        noodle <= noodle_b;  
        broth  <= broth_b;
        tonk_soup <= tonk_soup_b;
        miso <= miso_b;
        soy_sause <= soy_sause_b;
    end
end



always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ramen <= 0;
    else if(in_valid && in_cnt == 0)
        ramen <= ramen_type;  
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        port <= 0;
    else if(in_valid && in_cnt == 1)
        port <= portion;  
end
//=================================================================================================
//                                        Counter control
//=================================================================================================
// input counter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_valid)
        in_cnt <= in_cnt + 1;
    else
        in_cnt <= 0;
end

//=================================================================================================
//                                            FSM
//=================================================================================================
always @(*)
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            n_s = in_valid ? s_IN : s_IDLE;
        s_IN:                                                    //state 1
            n_s = in_valid ? s_IN : s_OUT_STATUS;
        s_OUT_STATUS:
            n_s = selling ? s_IDLE : s_OUT;
        s_OUT:
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
//                                        Counter control
//=================================================================================================




//=================================================================================================
//                                            Output  
//=================================================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid_order <= 0;
    else if(n_s == s_OUT_STATUS)
        out_valid_order <= 1;
    else
        out_valid_order <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        success <= 0;
    else if(n_s == s_OUT_STATUS && success_valid)
        success <= 1;
    else
        success <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid_tot <= 0;
    else if(n_s == s_OUT)
        out_valid_tot <= 1;
    else
        out_valid_tot <= 0;
end

always @(*)
begin
    if(!rst_n)
        sold_num = 0;
    else if(c_s == s_OUT)
        sold_num = {tonk_cnt,tonksoy_cnt,miso_cnt, misosoy_cnt};
    else 
        sold_num = 0;
end

always @(*)
begin
    if(!rst_n)
        total_gain = 0;
    else if(c_s == s_OUT)
        total_gain = tonk_cnt*200 + tonksoy_cnt*250 + miso_cnt*200 + misosoy_cnt*250;
    else
        total_gain = 0;
end

//=================================================================================================
//                                            BUY  
//=================================================================================================
assign noodle_p = port ? 150 : 100;
// 
always @(*) begin
    if(port)
    begin
        case(ramen)
        0: broth_p = 500;
        1: broth_p = 500;
        2: broth_p = 650;
        3: broth_p = 500;
        default: broth_p = 0;
        endcase
    end
    else
    begin
        case(ramen)
        0: broth_p = 300;
        1: broth_p = 300;
        2: broth_p = 400;
        3: broth_p = 300;
        default: broth_p = 0;
        endcase
    end
end
// 
always @(*) begin
    if(port)
    begin
        case(ramen)
        0: tonk_soup_p = 200;
        1: tonk_soup_p = 150;
        2: tonk_soup_p = 0;
        3: tonk_soup_p = 100;
        default: tonk_soup_p = 0;
        endcase
    end
    else
    begin
        case(ramen)
        0: tonk_soup_p = 150;
        1: tonk_soup_p = 100;
        2: tonk_soup_p = 0;
        3: tonk_soup_p = 70;
        default: tonk_soup_p = 0;
        endcase
    end
end
// 
always @(*) begin
    if(port)
    begin
        case(ramen)
        0: soy_sause_p = 0;
        1: soy_sause_p = 50;
        2: soy_sause_p = 0;
        3: soy_sause_p = 25;
        default: soy_sause_p = 0;
        endcase
    end
    else
    begin
        case(ramen)
        0: soy_sause_p = 0;
        1: soy_sause_p = 30;
        2: soy_sause_p = 0;
        3: soy_sause_p = 15;
        default: soy_sause_p = 0;
        endcase
    end
end
// 
always @(*) begin
    if(port)
    begin
        case(ramen)
        0: miso_p = 0;
        1: miso_p = 0;
        2: miso_p = 50;
        3: miso_p = 25;
        default: miso_p = 0;
        endcase
    end
    else
    begin
        case(ramen)
        0: miso_p = 0;
        1: miso_p = 0;
        2: miso_p = 30;
        3: miso_p = 15;
        default: miso_p = 0;
        endcase
    end
end


endmodule





//=================================================================================================
//
//                                         CLK1 Module
//
//=================================================================================================
module CLK_1_MODULE (
    clk,
    rst_n,
    in_valid,
	in_row,
    in_kernel,
    out_idle,
    handshake_sready,
    handshake_din,

    flag_handshake_to_clk1,
    flag_clk1_to_handshake,

	fifo_empty,
    fifo_rdata,
    fifo_rinc,
    out_valid,
    out_data,

    flag_clk1_to_fifo,
    flag_fifo_to_clk1
);
//========================================
// communicate with PATTERN
//========================================
input clk;
input rst_n;
input in_valid;
input [17:0] in_row;
input [11:0] in_kernel;
output reg out_valid;
output reg [7:0] out_data;
//========================================
// communicate with Handshake synchronizer
//========================================
input out_idle;
output reg handshake_sready;
output reg [29:0] handshake_din;
// You can use the the custom flag ports for your design
input  flag_handshake_to_clk1;
output flag_clk1_to_handshake;
//========================================
// communicate with FIFO synchronizer
//========================================
input fifo_empty;
input [7:0] fifo_rdata;
output fifo_rinc;
// You can use the the custom flag ports for your design
output flag_clk1_to_fifo;
input flag_fifo_to_clk1;
//----------------------------------------
// parameter & integer
parameter s_IDLE          = 3'd0; 
parameter s_SENDCLK2     = 3'd1;
parameter s_WAIT_FIFO    = 3'd2;
parameter s_OUT         = 3'd3;
// reg & wire
reg  [2:0] c_s,n_s;

reg  [2:0] in_cnt;
reg  [2:0] cnt_handshake;
reg  [29:0] in_data [5:0];       // {in_row, in_kernel}
reg  [7:0] cnt_outnum;
reg  start_hand_flag;
reg  in_valid_hold;

reg fifo_empty_delay1;
reg fifo_empty_delay2;

//=================================================================================================
//                                            Input  
//=================================================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_valid_hold <= 0;
    else if(in_valid)
        in_valid_hold <= 1;
end

// ---------------- From PATTERN -------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_valid)
        in_cnt <= in_cnt + 1;
    else if(n_s == s_IDLE)
        in_cnt <= 0;
end
always @(posedge clk) begin     
    in_data[in_cnt] <= {in_row, in_kernel};  
end



//=================================================================================================
//                                            Output 
//=================================================================================================
// ------------ To FIFO synchronizer -------------
assign fifo_rinc = (~fifo_empty && c_s == s_OUT) ? 1 : 0; 

//* fifo_empty
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        fifo_empty_delay1 <= 0;
    else
        fifo_empty_delay1 <= fifo_empty;
end
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        fifo_empty_delay2 <= 0;
    else
        fifo_empty_delay2 <= fifo_empty_delay1; 
end



// ---------- To Handshake synchronizer ----------

always @(*)
begin
    if(c_s == s_WAIT_FIFO)
        handshake_sready = 0; 
    else 
    begin
        if(in_valid_hold && out_idle && c_s == s_SENDCLK2) 
            handshake_sready = 1;
        else 
            handshake_sready = 0;
    end
end
// couter send which data to handshake
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
        cnt_handshake <= 0;
    else if(handshake_sready)
        cnt_handshake <= cnt_handshake + 1;
    else if(c_s == s_IDLE)
        cnt_handshake <= 0;
end
// handshake_din
always @(posedge clk)
begin
    if(handshake_sready)
        handshake_din <= in_data[cnt_handshake];
end


// ---------------- To PATTERN -------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_outnum <= 0;
    else if(c_s == s_OUT && ~fifo_empty_delay2)
        cnt_outnum <= cnt_outnum + 1;
    else if(c_s == s_IDLE)  
        cnt_outnum <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if(c_s == s_OUT && ~fifo_empty_delay2 && cnt_outnum != 150)
        out_valid <= 1;
    else
        out_valid <= 0;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_data <= 0;
    else if(c_s == s_OUT && ~fifo_empty_delay2 && cnt_outnum != 150)
        out_data <= fifo_rdata;
    else   
        out_data <= 0;
end

//=================================================================================================
//                                            FSM
//=================================================================================================
always @(*)
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            n_s = in_valid ? s_SENDCLK2 : s_IDLE;
        s_SENDCLK2:                                                //state 1
            n_s = (cnt_handshake == 6) ? s_WAIT_FIFO : s_SENDCLK2;
        s_WAIT_FIFO:
            n_s = s_OUT;
        s_OUT:
            n_s = (cnt_outnum == 150) ? s_IDLE : s_OUT; 
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

endmodule





//=================================================================================================
//
//                                         CLK2 Module
//
//=================================================================================================
module CLK_2_MODULE (
    clk,
    rst_n,
    in_valid,
    fifo_full,
    in_data,
    out_valid,
    out_data,
    busy,

    flag_handshake_to_clk2,
    flag_clk2_to_handshake,

    flag_fifo_to_clk2,
    flag_clk2_to_fifo
);

input clk;
input rst_n;
input in_valid;
input fifo_full;
input [29:0] in_data;
output reg out_valid;
output reg [7:0] out_data;
output reg busy;

// You can use the the custom flag ports for your design
input  flag_handshake_to_clk2;
output flag_clk2_to_handshake;

input  flag_fifo_to_clk2;
output flag_clk2_to_fifo;
//----------------------------------------
// parameter & integer
parameter s_IDLE         = 3'd0; 
parameter s_INPUT        = 3'd1;
parameter s_CONV         = 3'd2;

// reg & wire
reg  [2:0] c_s,n_s;

reg  [2:0] in_cnt;
reg  [2:0] cnt_row;
reg  [4:0] cnt_col;
wire  [4:0] cnt_col_reg;
reg  [4:0] cnt_conv;
reg  [2:0] cnt_kernel;


reg  [2:0] image_row [5:0][5:0];
reg  [2:0] kernel    [5:0][3:0];

wire [7:0] conv_buffer;

reg  [7:0] conv_buffer1 [25:0];
reg  [7:0] conv_buffer2 [25:0];
reg  [7:0] conv_buffer3 [25:0];
reg  [7:0] conv_buffer4 [25:0];
reg  [7:0] conv_buffer5 [25:0];
reg  [7:0] conv_buffer6 [25:0];





//=================================================================================================
//                                            FSM
//=================================================================================================
always @(*)
begin
    case(c_s)
        s_IDLE:                                                     //state 0
            n_s = in_valid ? s_INPUT : s_IDLE;
        s_INPUT:                                                //state 1
            n_s = (in_cnt == 6) ? s_CONV : s_INPUT;
        s_CONV:
            n_s = (cnt_kernel == 6) ? s_IDLE : s_CONV;
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
//                                            Output  
//=================================================================================================
// ------------- To FIFO synchronizer ------------
// always @(posedge clk or negedge rst_n)
// begin
//     if(!rst_n)
//         out_valid <= 0;
//     else if(c_s == s_CONV && !fifo_full)
//         out_valid <= 1;
//     else
//         out_valid <= 0;
// end
always @(*)
begin
    if(!rst_n)
        out_valid = 0;
    else if(c_s == s_CONV && !fifo_full)
        out_valid = 1;
    else
        out_valid = 0;
end

// always @(posedge clk or negedge rst_n)
// begin
//     if(!rst_n)
//         out_data <= 0;
//     else if(c_s == s_CONV && !fifo_full)  
//         out_data <= conv_buffer;
// end

always @(*)
begin
    if(!rst_n)
        out_data = 0;
    else if(c_s == s_CONV && !fifo_full)  
        out_data = conv_buffer;
    else
        out_data = 0;
end


// ---------- To Handshake synchronizer ----------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        busy <= 0;
    else
        busy <= 0;
end

//=================================================================================================
//                                         Convolution  
//=================================================================================================
// column index
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_col <= 0;
    else if(cnt_col == 4 && !fifo_full)
        cnt_col <= 0;
    else if(c_s == s_CONV && !fifo_full)
        cnt_col <= cnt_col + 1; 
    else if(c_s == s_IDLE)
        cnt_col <= 0; 
end
// row index
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_row <= 0; 
    else if(cnt_row == 4 && cnt_col == 4 && !fifo_full)
        cnt_row <= 0; 
    else if(cnt_col == 4 && !fifo_full)
        cnt_row <= cnt_row + 1;   
    
    
end

// kernel counter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_kernel <= 0;
    else if(cnt_row == 4 && cnt_col == 4 && !fifo_full)
        cnt_kernel <= cnt_kernel + 1;   
    else if(c_s == s_IDLE)
        cnt_kernel <= 0; 
end


// convolution computation
assign conv_buffer = image_row[cnt_row][cnt_col] * kernel[cnt_kernel][0] + image_row[cnt_row][cnt_col+1] * kernel[cnt_kernel][1] + image_row[cnt_row+1][cnt_col] * kernel[cnt_kernel][2] + image_row[cnt_row+1][cnt_col+1] * kernel[cnt_kernel][3];

always @(posedge clk)
begin
    conv_buffer1[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[0][0] + image_row[cnt_row][cnt_col+1] * kernel[0][1] + image_row[cnt_row+1][cnt_col] * kernel[0][2] + image_row[cnt_row+1][cnt_col+1] * kernel[0][3];
    conv_buffer2[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[1][0] + image_row[cnt_row][cnt_col+1] * kernel[1][1] + image_row[cnt_row+1][cnt_col] * kernel[1][2] + image_row[cnt_row+1][cnt_col+1] * kernel[1][3];
    conv_buffer3[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[2][0] + image_row[cnt_row][cnt_col+1] * kernel[2][1] + image_row[cnt_row+1][cnt_col] * kernel[2][2] + image_row[cnt_row+1][cnt_col+1] * kernel[2][3];
    conv_buffer4[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[3][0] + image_row[cnt_row][cnt_col+1] * kernel[3][1] + image_row[cnt_row+1][cnt_col] * kernel[3][2] + image_row[cnt_row+1][cnt_col+1] * kernel[3][3];
    conv_buffer5[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[4][0] + image_row[cnt_row][cnt_col+1] * kernel[4][1] + image_row[cnt_row+1][cnt_col] * kernel[4][2] + image_row[cnt_row+1][cnt_col+1] * kernel[4][3];
    conv_buffer6[cnt_conv] <= image_row[cnt_row][cnt_col] * kernel[5][0] + image_row[cnt_row][cnt_col+1] * kernel[5][1] + image_row[cnt_row+1][cnt_col] * kernel[5][2] + image_row[cnt_row+1][cnt_col+1] * kernel[5][3];
end


//=================================================================================================
//                                            Input  
//=================================================================================================
// ---------------- From PATTERN -------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_valid)
        in_cnt <= in_cnt + 1;
    else if(c_s == s_IDLE)
        in_cnt <= 0;
end
always @(posedge clk) begin     
    if(in_valid)
        {image_row[in_cnt][5],image_row[in_cnt][4], image_row[in_cnt][3], image_row[in_cnt][2], image_row[in_cnt][1], image_row[in_cnt][0],
         kernel[in_cnt][3],   kernel[in_cnt][2],    kernel[in_cnt][1],    kernel[in_cnt][0]} <= in_data;   
end
endmodule
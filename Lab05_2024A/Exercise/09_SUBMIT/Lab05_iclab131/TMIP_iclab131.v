module TMIP(
           // input signals
           clk,
           rst_n,
           in_valid,
           in_valid2,

           image,
           template,
           image_size,
           action,

           // output signals
           out_valid,
           out_value
       );

input            clk, rst_n;
input            in_valid, in_valid2;

input      [7:0] image;
input      [7:0] template;
input      [1:0] image_size;
input      [2:0] action;

output reg       out_valid;
output reg       out_value;

//==================================================================
// parameter & integer
//==================================================================
parameter s_IDLE          = 3'd0; 
parameter s_SRAM_WRITE    = 3'd1;
parameter s_WAIT_ACTION   = 3'd2;
parameter s_SRAM_READ     = 3'd3;
parameter s_READ_DELAY    = 3'd4;
parameter s_CAL           = 3'd5;
parameter s_ACTION_DONE   = 3'd6;
parameter s_OUT           = 3'd7;

//==================================================================
// reg & wire
//==================================================================
reg  [2:0] c_s,n_s;
// counter
reg  [1:0] in_cnt;
reg  [3:0] temp_cnt;
reg  [3:0] set_cnt;
reg  [2:0] act_cnt;
reg  [8:0] cal_cnt, cal_cycle;
reg  [7:0] addr, addr_end;
reg  [4:0] out_cnt;                  // 計數20 cycles

// input process and store
reg  [23:0] rgb_value;
wire web;
wire [7:0] gray_max, max_tmp, gray_avg, gray_weight;
wire [7:0] gray_max_out, gray_avg_out, gray_weight_out;
reg  [7:0] template_store [0:8];
reg  [7:0] img_size;
reg  [7:0] img_size_hold;
wire [7:0] img_size_half;
reg  [7:0] in_data;
reg  [2:0] act [0:7];

// main process 
reg  [7:0] img [0:15][0:15];
reg  [3:0] row;
reg  [3:0] col;
reg  [3:0] i_row;
reg  [3:0] i_col;

wire [7:0]cmp_in[8:0];
wire [7:0]cmp_out, median_out;
reg  [2:0]act_ptr;

reg  [7:0] A67_shift[31:0];
wire [4:0] A67_ptr;

reg  [7:0] win [0:8];
wire [19:0] CC_out;

// flag
reg read_valid;
reg act_delay1, act_delay2;
wire act_flag;
reg  in_valid2_delay;
wire in_valid2_flag;
wire pad_mode;
integer i,j;
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
            n_s = in_valid ? s_SRAM_WRITE : s_IDLE;
        s_SRAM_WRITE:                                               //state 1
            n_s = !in_valid ? s_WAIT_ACTION : s_SRAM_WRITE;
        s_WAIT_ACTION:                                              //state 2
            n_s = in_valid2 ? s_SRAM_READ : s_WAIT_ACTION;
        s_SRAM_READ:                                                //state 3
            n_s = (addr == addr_end) ? s_READ_DELAY : s_SRAM_READ;
        s_READ_DELAY:                                               //state 4
            n_s = act_delay2 ? ((act[1] != 7) ? s_CAL :s_OUT) : s_READ_DELAY;   
        s_CAL:                                                      //state 5
            n_s = (cal_cnt == cal_cycle) ? s_ACTION_DONE : s_CAL;
        s_ACTION_DONE:                                              //state 6
            n_s = (act[act_ptr] == 7) ? s_OUT : s_CAL;
        s_OUT:                                                      //state 7
            n_s = (cal_cnt == cal_cycle) ? ((set_cnt != 8) ? s_WAIT_ACTION : s_IDLE) : s_OUT;
        default:
            n_s = s_IDLE;
    endcase
end


//=================================================================================================
//
//                                        Important control
//
//=================================================================================================
// memory address
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        addr <= 0;
    else if(c_s == s_SRAM_WRITE && in_cnt == 0)
        addr <= addr + 1;
    else if(c_s == s_SRAM_READ)
    begin
        if(addr == addr_end)
            addr <= 0;
        else
            addr <= addr + 1;
    end
    else if(c_s == s_WAIT_ACTION || c_s == s_IDLE)
        addr <= 0;
end
always @(*)
begin
    case(img_size)
        4:
            addr_end = 15;
        8:
            addr_end = 63;
        16:
            addr_end = 255;
        default:
            addr_end = 0;
    endcase
end

// start read SRAM
always @(*)
begin
    if(c_s == s_SRAM_READ && addr > 1 || c_s == s_READ_DELAY)
        read_valid = 1;
    else
        read_valid = 0; 
end

// ---------------- for result position ---------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        row <= 0;
    else if(read_valid && col == img_size-1)
    begin
        if(row == img_size-1)
            row <= 0;
        else
            row <= row + 1;
    end

    else if(c_s == s_CAL && act[act_ptr] == 3'd3 && col == (img_size_half)-1) // maxpool
    begin
        if(row < (img_size_half)-1)
            row <= row + 1;
        else
            row <= 0;
    end
    else if(c_s == s_CAL && act[act_ptr] == 3'd6 && col == img_size-1) // image filter
    begin
        if(row < img_size-1)
            row <= row + 1;
        else
            row <= 0;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        col <= 0;
    else if(read_valid)                             // read from SRAM
    begin
        if(col == img_size-1)
            col <= 0;
        else
            col <= col + 1;
    end
    else if(c_s == s_CAL && act[act_ptr] == 3'd3)   // maxpool
    begin
        if(col < (img_size_half)-1 && n_s != s_ACTION_DONE)
            col <= col + 1;
        else
            col <= 0;
    end
    else if(c_s == s_CAL && act[act_ptr] == 3'd6 && cal_cnt > A67_ptr)   // image filter
    begin
        if(col < img_size-1 && n_s != s_ACTION_DONE)
            col <= col + 1;
        else
            col <= 0;
    end

end

// ---------------- for calculate position ---------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        i_row <= 0;
    else if(c_s == s_CAL && i_col == img_size-2 && act[act_ptr] == 3'd3)    // maxpool
        i_row <= i_row + 2;
    else if(c_s == s_CAL && i_col == img_size-1 && act[act_ptr] == 3'd6)    // image filter
        i_row <= i_row + 1;
    else if(c_s == s_OUT && i_col == img_size-1 && out_cnt == 1)           // cross correlation
        i_row <= i_row + 1;
    else if(n_s == s_ACTION_DONE || n_s == s_WAIT_ACTION)
        i_row <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        i_col <= 0;
    else if(c_s == s_CAL && act[act_ptr] == 3'd3)   // maxpool
    begin
        if(i_col < img_size-2 && n_s != s_ACTION_DONE)
            i_col <= i_col + 2;
        else
            i_col <= 0;
    end
    else if(c_s == s_CAL && act[act_ptr] == 3'd6)   // image filter
    begin
        if(i_col < (img_size-1) && n_s != s_ACTION_DONE)
            i_col <= i_col + 1;
        else
            i_col <= 0;
    end
    else if(c_s == s_OUT && out_cnt == 1)          // cross correlation 
    begin
        if(i_col < (img_size-1) && n_s != s_ACTION_DONE)
            i_col <= i_col + 1;
        else
            i_col <= 0;
    end


end
// calculation cycle counter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cal_cnt <= 0;
    else if(c_s == s_CAL)
        cal_cnt <= cal_cnt + 1;
    else if(c_s == s_OUT && out_cnt == 1)
        cal_cnt <= cal_cnt + 1;
    else if(c_s == s_ACTION_DONE || c_s == s_WAIT_ACTION)
        cal_cnt <= 0;
end
 
//=================================================================================================
//
//                                      Action7: Cross correlation
//
//=================================================================================================
// output bit number for serial output from MSB
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_cnt <= 19;
    else if(c_s == s_OUT)
    begin
        if(out_cnt == 0)
            out_cnt <= 19;
        else
            out_cnt <= out_cnt - 1;
    end
    else if(c_s == s_WAIT_ACTION)
        out_cnt <= 19;
end
// do template matching (convolution)
CC PE(.clk(clk), 
      .img0(win[0]), .img1(win[1]), .img2(win[2]), .img3(win[3]), .img4(win[4]),
      .img5(win[5]), .img6(win[6]), .img7(win[7]), .img8(win[8]),
      .ker0(template_store[0]), .ker1(template_store[1]), .ker2(template_store[2]), .ker3(template_store[3]),
      .ker4(template_store[4]), .ker5(template_store[5]), .ker6(template_store[6]), .ker7(template_store[7]),
      .ker8(template_store[8]), .out(CC_out));

// out_valid
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if(c_s == s_OUT)
        out_valid <= 1;
    else
        out_valid <= 0;
end
// out_value
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_value <= 0;
    else if(c_s == s_OUT)
        out_value <= CC_out[out_cnt];
    else
        out_value <= 0;
end


//=================================================================================================
//
//                                      Action6: Image filter
//
//=================================================================================================

assign A67_ptr = (img_size << 1) - 1;
// 32 8-bit shift register wait to store back img
always @(posedge clk)
begin
    if(c_s == s_CAL && act[act_ptr] == 3'd6)
    begin
        A67_shift[0] <= median_out;
        for(i=0;i<31;i=i+1)
            A67_shift[i+1] <= A67_shift[i];  
    end
end


// pad_mode = 1 : replication
// pad_mode = 2 : zero padding
assign pad_mode = (act[act_ptr] == 3'd6) ? 1 : 0;
// Window selection
always @(*)
begin
    if(i_row == 0 && i_col == 0)                                   // left-up
    begin
        win[0] = pad_mode ? img[i_row][i_col] : 0;
        win[1] = pad_mode ? img[i_row][i_col] : 0;
        win[2] = pad_mode ? img[i_row][i_col+1] : 0;
        win[3] = pad_mode ? img[i_row][i_col] : 0;
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = pad_mode ? img[i_row+1][i_col] : 0;
        win[7] = img[i_row+1][i_col];
        win[8] = img[i_row+1][i_col+1];
    end
    else if(i_row == 0 && i_col == img_size-1)                     // right-up
    begin
        win[0] = pad_mode ? img[i_row][i_col-1] : 0;
        win[1] = pad_mode ? img[i_row][i_col] : 0;
        win[2] = pad_mode ? img[i_row][i_col] : 0;
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = pad_mode ? img[i_row][i_col] : 0;
        win[6] = img[i_row+1][i_col-1];
        win[7] = img[i_row+1][i_col];
        win[8] = pad_mode ? img[i_row+1][i_col] : 0;
    end
    else if(i_row == img_size-1 && i_col == 0)                     // left-down
    begin
        win[0] = pad_mode ? img[i_row-1][i_col] : 0;
        win[1] = img[i_row-1][i_col];
        win[2] = img[i_row-1][i_col+1];
        win[3] = pad_mode ? img[i_row][i_col] : 0;
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = pad_mode ? img[i_row][i_col] : 0;
        win[7] = pad_mode ? img[i_row][i_col] : 0;
        win[8] = pad_mode ? img[i_row][i_col+1] : 0;
    end
    else if(i_row == img_size-1 && i_col == img_size-1)            // right down
    begin
        win[0] = img[i_row-1][i_col-1];
        win[1] = img[i_row-1][i_col];
        win[2] = pad_mode ? img[i_row-1][i_col] : 0;
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = pad_mode ? img[i_row][i_col] : 0;
        win[6] = pad_mode ? img[i_row][i_col-1] : 0;
        win[7] = pad_mode ? img[i_row][i_col] : 0;
        win[8] = pad_mode ? img[i_row][i_col] : 0;
    end
    else if(i_row == 0)                                             // first row
    begin
        win[0] = pad_mode ? img[i_row][i_col-1] : 0;
        win[1] = pad_mode ? img[i_row][i_col] : 0;
        win[2] = pad_mode ? img[i_row][i_col+1] : 0;
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = img[i_row+1][i_col-1];
        win[7] = img[i_row+1][i_col];
        win[8] = img[i_row+1][i_col+1];
    end
    else if(i_row == img_size-1)                                    // last row
    begin
        win[0] = img[i_row-1][i_col-1];
        win[1] = img[i_row-1][i_col];
        win[2] = img[i_row-1][i_col+1];
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = pad_mode ? img[i_row][i_col-1] : 0;
        win[7] = pad_mode ? img[i_row][i_col] : 0;
        win[8] = pad_mode ? img[i_row][i_col+1] : 0;
    end
    else if(i_col == 0)                                             // first column
    begin
        win[0] = pad_mode ? img[i_row-1][i_col] : 0;
        win[1] = img[i_row-1][i_col];
        win[2] = img[i_row-1][i_col+1];
        win[3] = pad_mode ? img[i_row][i_col] : 0;
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = pad_mode ? img[i_row+1][i_col] : 0;
        win[7] = img[i_row+1][i_col];
        win[8] = img[i_row+1][i_col+1];
    end
    else if(i_col == img_size-1)                                    // last column
    begin
        win[0] = img[i_row-1][i_col-1];
        win[1] = img[i_row-1][i_col];
        win[2] = pad_mode ? img[i_row-1][i_col] : 0;
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = pad_mode ? img[i_row][i_col] : 0;
        win[6] = img[i_row+1][i_col-1];
        win[7] = img[i_row+1][i_col];
        win[8] = pad_mode ? img[i_row+1][i_col] : 0;
    end
    else
    begin                                                            // others
        win[0] = img[i_row-1][i_col-1];
        win[1] = img[i_row-1][i_col];
        win[2] = img[i_row-1][i_col+1];
        win[3] = img[i_row][i_col-1];
        win[4] = img[i_row][i_col];
        win[5] = img[i_row][i_col+1];
        win[6] = img[i_row+1][i_col-1];
        win[7] = img[i_row+1][i_col];
        win[8] = img[i_row+1][i_col+1];
    end
end



//=================================================================================================
//
//                                      Calculate action stage
//
//=================================================================================================


// sorting for maximum and median
SORT maxpool(.I0(cmp_in[0]), .I1(cmp_in[1]), .I2(cmp_in[2]), .I3(cmp_in[3]), .I4(cmp_in[4]),
             .I5(cmp_in[5]), .I6(cmp_in[6]), .I7(cmp_in[7]), .I8(cmp_in[8]), .Omax(cmp_out), .Omed(median_out));

assign cmp_in[0] = (act[act_ptr] == 3'd6) ? win[0] : img[i_row][i_col];
assign cmp_in[1] = (act[act_ptr] == 3'd6) ? win[1] : img[i_row][i_col+1];
assign cmp_in[2] = (act[act_ptr] == 3'd6) ? win[2] : img[i_row+1][i_col];
assign cmp_in[3] = (act[act_ptr] == 3'd6) ? win[3] : img[i_row+1][i_col+1];
assign cmp_in[4] = (act[act_ptr] == 3'd6) ? win[4] : 8'b0;
assign cmp_in[5] = (act[act_ptr] == 3'd6) ? win[5] : 8'b0;
assign cmp_in[6] = (act[act_ptr] == 3'd6) ? win[6] : 8'b0; 
assign cmp_in[7] = (act[act_ptr] == 3'd6) ? win[7] : 8'b0;
assign cmp_in[8] = (act[act_ptr] == 3'd6) ? win[8] : 8'b0;


// record which action now
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        act_ptr <= 1;
    else if(n_s == s_ACTION_DONE)
        act_ptr <= act_ptr + 1;
    else if(n_s == s_WAIT_ACTION)
        act_ptr <= 1;
end

// set every action and size to execute exact cycles
always @(*)
begin
    case(act[act_ptr])
        3:
        begin
            if(img_size == 16)
                cal_cycle = 64;     // 64 cycles
            else if(img_size == 8)
                cal_cycle = 16;     // 16 cycles
            else
                cal_cycle = 0;      // 4*4 no maxpool
        end
        4:
            cal_cycle = 0;
        5:
            cal_cycle = 0;
        6:
        begin
            if(img_size == 16)
                cal_cycle = 288;    // 16*16 -> 256 + 32
            else if(img_size == 8)
                cal_cycle = 80;     // 8*8   -> 64 + 16
            else
                cal_cycle = 24;     // 4*4   -> 16 + 8
        end
        7:
        begin
            if(img_size == 16)
                cal_cycle = 256;    // 16*16 -> 256
            else if(img_size == 8)
                cal_cycle = 64;     // 8*8   -> 64
            else
                cal_cycle = 16;     // 4*4   -> 16
        end
        default:
            cal_cycle = 0;
    endcase
end


//=================================================================================================
//
//                                   READ SRAM to 16*16 img register
//
//=================================================================================================
// for read_valid 2 cycles delay
assign act_flag = (addr == addr_end) ? 1 : 0;
always @(posedge clk)
begin
    act_delay1 <= act_flag;
    act_delay2 <= act_delay1;
end

//=========================================== main image storage ====================================================
always @(posedge clk)
begin
    if(read_valid)
        img[row][col] <= in_data;
    else if(c_s == s_CAL && n_s != s_ACTION_DONE && act[act_ptr] == 3'd3 && img_size != 4)   // maxpool
        img[row][col] <= cmp_out;
    else if(c_s == s_CAL && act[act_ptr] == 3'd4)                                            // negative
    begin
        for(i=0;i<img_size;i=i+1)
        begin
            for(j=0;j<img_size;j=j+1)
                img[i][j] <= ~img[i][j];
        end
    end
    else if(c_s == s_CAL && act[act_ptr] == 3'd5)                                            // horizontal flip
    begin
        if(img_size == 4)
        begin
            for(i=0;i<4;i=i+1)
            begin
                {img[i][0],img[i][1],img[i][2],img[i][3]} <= {img[i][3],img[i][2],img[i][1],img[i][0]};
                {img[i][3],img[i][2],img[i][1],img[i][0]} <= {img[i][0],img[i][1],img[i][2],img[i][3]};
            end
        end
        else if(img_size == 8)
        begin
            for(i=0;i<8;i=i+1)
            begin
                {img[i][0],img[i][1],img[i][2],img[i][3],img[i][4],img[i][5],img[i][6],img[i][7]} <= {img[i][7],img[i][6],img[i][5],img[i][4],img[i][3],img[i][2],img[i][1],img[i][0]};
                {img[i][7],img[i][6],img[i][5],img[i][4],img[i][3],img[i][2],img[i][1],img[i][0]} <= {img[i][0],img[i][1],img[i][2],img[i][3],img[i][4],img[i][5],img[i][6],img[i][7]};
            end
        end
        else if(img_size == 16)
        begin
            for(i=0;i<16;i=i+1)
            begin
                {img[i][0],img[i][1],img[i][2] ,img[i][3] ,img[i][4] ,img[i][5] ,img[i][6] ,img[i][7],
                 img[i][8],img[i][9],img[i][10],img[i][11],img[i][12],img[i][13],img[i][14],img[i][15]} <= {img[i][15],img[i][14],img[i][13],img[i][12],img[i][11],img[i][10],img[i][9],img[i][8],
                         img[i][7], img[i][6] ,img[i][5] ,img[i][4] ,img[i][3] ,img[i][2] ,img[i][1],img[i][0]};

                {img[i][15],img[i][14],img[i][13],img[i][12],img[i][11],img[i][10],img[i][9],img[i][8],
                 img[i][7], img[i][6] ,img[i][5] ,img[i][4] ,img[i][3] ,img[i][2] ,img[i][1],img[i][0]} <= {img[i][0],img[i][1],img[i][2] ,img[i][3] ,img[i][4] ,img[i][5] ,img[i][6] ,img[i][7],
                         img[i][8],img[i][9],img[i][10],img[i][11],img[i][12],img[i][13],img[i][14],img[i][15]};
            end
        end
    end
    else if(c_s == s_CAL && n_s != s_ACTION_DONE && act[act_ptr] == 3'd6)                    // image filter
    begin
        if(cal_cnt > A67_ptr)
        begin
            img[row][col] <= A67_shift[A67_ptr];
        end
    end
end

// ---------------------------------------------- display ----------------------------------------------------
// always @(negedge read_valid)
// begin
//     for(i=0;i<16;i=i+1)
//         $display("row %2d: %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d", i, img[i][0], img[i][1], img[i][2], img[i][3], img[i][4], img[i][5], img[i][6], img[i][7], img[i][8], img[i][9], img[i][10], img[i][11], img[i][12], img[i][13], img[i][14], img[i][15]);
//     $display("=============================================================================");
// end
// always @(posedge clk)
// begin
//     if(n_s == s_ACTION_DONE && act_ptr < 7)
//     begin
//         for(i=0;i<16;i=i+1)
//             $display("row %2d: %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d", i, img[i][0], img[i][1], img[i][2], img[i][3], img[i][4], img[i][5], img[i][6], img[i][7], img[i][8], img[i][9], img[i][10], img[i][11], img[i][12], img[i][13], img[i][14], img[i][15]);
//         $display("=============================================================================");
//     end
// end



always @(*)
begin
    case(act[0])
        0:
            in_data = gray_max_out;
        1:
            in_data = gray_avg_out;
        2:
            in_data = gray_weight_out;
        default:
            in_data = 0;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        act_cnt <= 0;
    else if(in_valid2)
        act_cnt <= act_cnt + 1;
    else if(n_s == s_WAIT_ACTION)
        act_cnt <= 0;
end
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
    begin
        for(i=0;i<8;i=i+1)
            act[i] <= 0; 
    end    
    else if(in_valid2)
        act[act_cnt] <= action; 
    else if(c_s == s_WAIT_ACTION)
    begin
        for(i=0;i<8;i=i+1)
            act[i] <= 0; 
    end
end

// set range 1~8
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        set_cnt <= 0;
    else if(c_s == s_WAIT_ACTION && n_s == s_SRAM_READ)     
        set_cnt <= set_cnt + 1;
    else if(n_s == s_IDLE)
        set_cnt <= 0;
end

//=================================================================================================
//
//                                        Input data store
//
//=================================================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_cnt <= 0;
    else if(in_valid && in_cnt != 2)
        in_cnt <= in_cnt + 1;
    else
        in_cnt <= 0;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        temp_cnt <= 0;
    else if(in_valid && addr < 3)
        temp_cnt <= temp_cnt + 1;
    else if(n_s == s_IDLE)
        temp_cnt <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rgb_value <= 0;
    else if(in_valid)
        rgb_value <= {image, rgb_value[23:8]};
end

assign max_tmp = (rgb_value[23:16] > rgb_value[15:8]) ? rgb_value[23:16] : rgb_value[15:8];
assign gray_max = (max_tmp > rgb_value[7:0]) ? max_tmp : rgb_value[7:0];
assign gray_avg = (rgb_value[23:16] + rgb_value[15:8] + rgb_value[7:0]) / 3;
assign gray_weight = (rgb_value[23:16] >> 2) + (rgb_value[15:8] >> 1) + (rgb_value[7:0] >> 2);

// write enable control
assign web = (c_s == s_SRAM_WRITE) ? 0 : 1;

// 3 SPRAM
SRAM_image m0(.A(addr), .DI(gray_max),    .DO(gray_max_out),    .CK(clk), .WEB(web));
SRAM_image m1(.A(addr), .DI(gray_avg),    .DO(gray_avg_out),    .CK(clk), .WEB(web));
SRAM_image m2(.A(addr), .DI(gray_weight), .DO(gray_weight_out), .CK(clk), .WEB(web));



// control image size
assign img_size_half = (img_size == 4) ? img_size : img_size >> 1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        img_size_hold <= 0;
    else if(c_s == s_IDLE && in_valid)
        img_size_hold <= 4 << image_size;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        img_size <= 0;
    else if(c_s == s_WAIT_ACTION)
        img_size <= img_size_hold;
    else if(n_s == s_ACTION_DONE && act[act_ptr] == 3'd3)       // finish maxpool -> img size/2
        img_size <= img_size_half;
end
// store template
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<9;i=i+1)
            template_store[i] <= 0;
    end   
    else if(in_valid && temp_cnt < 9)
        template_store[temp_cnt] <= template;
end


endmodule

//=================================================================================================
//
//                                    Cross correlation module
//
//=================================================================================================
module CC (clk,img0, img1, img2, img3, img4, img5, img6, img7, img8,
            ker0, ker1, ker2, ker3, ker4, ker5, ker6, ker7, ker8, out);
input clk;
input   [7:0] img0, img1, img2, img3, img4, img5, img6, img7, img8;
input   [7:0] ker0, ker1, ker2, ker3, ker4, ker5, ker6, ker7, ker8;
output  [19:0] out;

reg [15:0] mul [0:8];

always @(posedge clk) begin
    mul[0] <= img0 * ker0;
    mul[1] <= img1 * ker1;
    mul[2] <= img2 * ker2;
    mul[3] <= img3 * ker3;
    mul[4] <= img4 * ker4;
    mul[5] <= img5 * ker5;
    mul[6] <= img6 * ker6;
    mul[7] <= img7 * ker7;
    mul[8] <= img8 * ker8;
end

// assign mul[0] = img0 * ker0;
// assign mul[1] = img1 * ker1;
// assign mul[2] = img2 * ker2;
// assign mul[3] = img3 * ker3;
// assign mul[4] = img4 * ker4;
// assign mul[5] = img5 * ker5;
// assign mul[6] = img6 * ker6;
// assign mul[7] = img7 * ker7;
// assign mul[8] = img8 * ker8;

assign out = mul[0] + mul[1] + mul[2] + mul[3] + mul[4] + mul[5] + mul[6] + mul[7] + mul[8];


endmodule


//=================================================================================================
//
//                                          Memory module
//
//=================================================================================================

// 16 * 16 * 8 SPSRAM
module SRAM_image(A, DI, DO, CK, WEB);
input [7:0] A;
input [7:0] DI;
input CK, WEB;
output reg [7:0] DO;

wire [7:0] DO_reg;

MEM_gray_max U0(
                 .A0(A[0]), .A1(A[1]), .A2(A[2]), .A3(A[3]),
                 .A4(A[4]), .A5(A[5]), .A6(A[6]), .A7(A[7]),
                 .DI0(DI[0]), .DI1(DI[1]), .DI2(DI[2]), .DI3(DI[3]),
                 .DI4(DI[4]), .DI5(DI[5]), .DI6(DI[6]), .DI7(DI[7]),
                 .DO0(DO_reg[0]), .DO1(DO_reg[1]), .DO2(DO_reg[2]), .DO3(DO_reg[3]),
                 .DO4(DO_reg[4]), .DO5(DO_reg[5]), .DO6(DO_reg[6]), .DO7(DO_reg[7]),
                 .CK(CK), .WEB(WEB), .OE(1'b1), .CS(1'b1)
             );

always @(posedge CK)
begin
    DO <= DO_reg;
end

endmodule

//=================================================================================================
//
//                                          Sorting module
//
//=================================================================================================
module SORT(I0,I1,I2,I3,I4,I5,I6,I7,I8,Omax,Omed);
input [7:0] I0,I1,I2,I3,I4,I5,I6,I7,I8;
output [7:0] Omax, Omed;

reg [7:0] sort [8:0];


wire f8_7, f8_6, f8_5, f8_4, f8_3, f8_2, f8_1, f8_0;
wire f7_8, f7_6, f7_5, f7_4, f7_3, f7_2, f7_1, f7_0;
wire f6_8, f6_7, f6_5, f6_4, f6_3, f6_2, f6_1, f6_0;
wire f5_8, f5_7, f5_6, f5_4, f5_3, f5_2, f5_1, f5_0;
wire f4_8, f4_7, f4_6, f4_5, f4_3, f4_2, f4_1, f4_0;
wire f3_8, f3_7, f3_6, f3_5, f3_4, f3_2, f3_1, f3_0;
wire f2_8, f2_7, f2_6, f2_5, f2_4, f2_3, f2_1, f2_0;
wire f1_8, f1_7, f1_6, f1_5, f1_4, f1_3, f1_2, f1_0;
wire f0_8, f0_7, f0_6, f0_5, f0_4, f0_3, f0_2, f0_1;

wire [3:0] addr_8, addr_7, addr_6, addr_5, addr_4, addr_3, addr_2, addr_1, addr_0;
//sorting
//--- first ---
assign f8_7 = (I8 > I7) ? 1'd1 : 1'd0;
assign f8_6 = (I8 > I6) ? 1'd1 : 1'd0;
assign f8_5 = (I8 > I5) ? 1'd1 : 1'd0;
assign f8_4 = (I8 > I4) ? 1'd1 : 1'd0;
assign f8_3 = (I8 > I3) ? 1'd1 : 1'd0;
assign f8_2 = (I8 > I2) ? 1'd1 : 1'd0;
assign f8_1 = (I8 > I1) ? 1'd1 : 1'd0;
assign f8_0 = (I8 > I0) ? 1'd1 : 1'd0;
assign addr_8 = f8_7 + f8_0 + f8_1 + f8_2 + f8_3 + f8_4 + f8_5 + f8_6;
//--- first ---
assign f7_8 = ~f8_7;
assign f7_6 = (I7 > I6) ? 1'd1 : 1'd0;
assign f7_5 = (I7 > I5) ? 1'd1 : 1'd0;
assign f7_4 = (I7 > I4) ? 1'd1 : 1'd0;
assign f7_3 = (I7 > I3) ? 1'd1 : 1'd0;
assign f7_2 = (I7 > I2) ? 1'd1 : 1'd0;
assign f7_1 = (I7 > I1) ? 1'd1 : 1'd0;
assign f7_0 = (I7 > I0) ? 1'd1 : 1'd0;
assign addr_7 = f7_8 + f7_0 + f7_1 + f7_2 + f7_3 + f7_4 + f7_5 + f7_6;
//--- second ---
assign f6_8 = ~f8_6;
assign f6_7 = ~f7_6;
assign f6_5 = (I6 > I5) ? 1'd1 : 1'd0;
assign f6_4 = (I6 > I4) ? 1'd1 : 1'd0;
assign f6_3 = (I6 > I3) ? 1'd1 : 1'd0;
assign f6_2 = (I6 > I2) ? 1'd1 : 1'd0;
assign f6_1 = (I6 > I1) ? 1'd1 : 1'd0;
assign f6_0 = (I6 > I0) ? 1'd1 : 1'd0;
assign addr_6 = f6_8 + f6_7 + f6_5 + f6_4 + f6_3 + f6_2 + f6_1 + f6_0;
//--- Third ---
assign f5_8 = ~f8_5;
assign f5_7 = ~f7_5;
assign f5_6 = ~f6_5;
assign f5_4 = (I5 > I4) ? 1'd1 : 1'd0;
assign f5_3 = (I5 > I3) ? 1'd1 : 1'd0;
assign f5_2 = (I5 > I2) ? 1'd1 : 1'd0;
assign f5_1 = (I5 > I1) ? 1'd1 : 1'd0;
assign f5_0 = (I5 > I0) ? 1'd1 : 1'd0;
assign addr_5 = f5_8 + f5_7 + f5_6 + f5_4 + f5_3 + f5_2 + f5_1 + f5_0;
//--- Forth ---
assign f4_8 = ~f8_4;
assign f4_7 = ~f7_4;
assign f4_6 = ~f6_4;
assign f4_5 = ~f5_4;
assign f4_3 = (I4 > I3) ? 1'd1 : 1'd0;
assign f4_2 = (I4 > I2) ? 1'd1 : 1'd0;
assign f4_1 = (I4 > I1) ? 1'd1 : 1'd0;
assign f4_0 = (I4 > I0) ? 1'd1 : 1'd0;
assign addr_4 = f4_8 + f4_7 + f4_6 + f4_5 + f4_3 + f4_2 + f4_1 + f4_0;
//--- Fifth ---
assign f3_8 = ~f8_3;
assign f3_7 = ~f7_3;
assign f3_6 = ~f6_3;
assign f3_5 = ~f5_3;
assign f3_4 = ~f4_3;
assign f3_2 = (I3 > I2) ? 1'd1 : 1'd0;
assign f3_1 = (I3 > I1) ? 1'd1 : 1'd0;
assign f3_0 = (I3 > I0) ? 1'd1 : 1'd0;
assign addr_3 = f3_8 + f3_7 + f3_6 + f3_5 + f3_4 + f3_2 + f3_1 + f3_0;
//--- Sixth ---
assign f2_8 = ~f8_2;
assign f2_7 = ~f7_2;
assign f2_6 = ~f6_2;
assign f2_5 = ~f5_2;
assign f2_4 = ~f4_2;
assign f2_3 = ~f3_2;
assign f2_1 = (I2 > I1) ? 1'd1 : 1'd0;
assign f2_0 = (I2 > I0) ? 1'd1 : 1'd0;
assign addr_2 = f2_8 + f2_7 + f2_6 + f2_5 + f2_4 + f2_3 + f2_1 + f2_0;
//--- Seven ---
assign f1_8 = ~f8_1;
assign f1_7 = ~f7_1;
assign f1_6 = ~f6_1;
assign f1_5 = ~f5_1;
assign f1_4 = ~f4_1;
assign f1_3 = ~f3_1;
assign f1_2 = ~f2_1;
assign f1_0 = (I1 > I0) ? 1'd1 : 1'd0;
assign addr_1 = f1_8 + f1_7 + f1_6 + f1_5 + f1_4 + f1_3 + f1_2 + f1_0;
//--- Eight ---
assign f0_8 = ~f8_0;
assign f0_7 = ~f7_0;
assign f0_6 = ~f6_0;
assign f0_5 = ~f5_0;
assign f0_4 = ~f4_0;
assign f0_3 = ~f3_0;
assign f0_2 = ~f2_0;
assign f0_1 = ~f1_0;
assign addr_0 = f0_8 + f0_7 + f0_6 + f0_5 + f0_4 + f0_3 + f0_2 + f0_1;

always @(*)
begin
    //cancel Latch
    sort[8] = 0;
    sort[7] = 0;
    sort[6] = 0;
    sort[5] = 0;
    sort[4] = 0;
    sort[3] = 0;
    sort[2] = 0;
    sort[1] = 0;
    sort[0] = 0;
    sort[addr_8] = I8;
    sort[addr_7] = I7;
    sort[addr_6] = I6;
    sort[addr_5] = I5;
    sort[addr_4] = I4;
    sort[addr_3] = I3;
    sort[addr_2] = I2;
    sort[addr_1] = I1;
    sort[addr_0] = I0;
end
assign Omax = sort[8];
assign Omed = sort[4];

endmodule

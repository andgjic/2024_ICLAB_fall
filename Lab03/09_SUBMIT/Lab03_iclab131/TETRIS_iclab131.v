/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: TETRIS
// FILE NAME: TETRIS.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Tsun-Yen Chen, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / TETRIS
// MODIFICATION HISTORY:
// Date                 Description
//
/**************************************************************************/
module TETRIS (
           //INPUT
           rst_n,
           clk,
           in_valid,
           tetrominoes,
           position,
           //OUTPUT
           tetris_valid,
           score_valid,
           fail,
           score,
           tetris
       );

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input				rst_n, clk, in_valid;
input		[2:0]	tetrominoes;
input		[2:0]	position;
output reg			tetris_valid, score_valid, fail;
output reg	[3:0]	score;
output reg 	[71:0]	tetris;


//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter s_IDLE    = 3'b000;
parameter s_START   = 3'b001;
parameter s_DEL     = 3'b010;
parameter s_DONE    = 3'b011;
parameter s_FINISH  = 3'b100;


//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [3:0] i;
reg [2:0] c_s,n_s;
reg [5:0] map [13:0];
reg [2:0] tet, pos;
reg [3:0] idx;
reg [3:0] score_hold;
reg [4:0] game_cnt;
reg [3:0] row_ptr;

wire [3:0] score_reg;
// wire [3:0] score_cnt;
wire over;
wire score_f;
// wire del_f;
wire check0, check1, check2, check3, check4, check5, check6, check7, check8, check9, check10, check11;



//====================================================================
//                             FSM
//====================================================================
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
            n_s = in_valid ? s_START : s_IDLE;
        s_START:                                                    //state 1
            n_s = s_DONE;
        s_DEL:                                                      //state 2
            n_s = score_f ? s_DEL : s_IDLE;
        s_DONE:                                                     //state 3
            n_s = score_f ? s_DEL : (over ? s_FINISH : s_IDLE);
        s_FINISH:                                                   //state 4
            n_s = s_IDLE;
        default:
            n_s = s_IDLE;
    endcase
end


//====================================================================
//                            Design
//====================================================================

// ================================================================== Delete block and score ============================================================================
// check 1 game 16 rounds
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        game_cnt <= 0;
    else if(in_valid)
        game_cnt <= game_cnt + 1;
    else if(n_s == s_FINISH || (c_s == s_IDLE && game_cnt[4]) || (n_s == s_IDLE && over)) 
        game_cnt <= 0;
end 

// check map overflow
assign over = (map[12] != 0) ? 1 : 0;

// check scoring
assign score_f = (check0 || check1 || check2 || check3 || check4 || check5 || check6 || check7 || check8 || check9 || check10 || check11) ? 1 : 0;
assign check0  = (map[0]  == 6'b111111) ? 1 : 0;
assign check1  = (map[1]  == 6'b111111) ? 1 : 0;
assign check2  = (map[2]  == 6'b111111) ? 1 : 0;
assign check3  = (map[3]  == 6'b111111) ? 1 : 0;
assign check4  = (map[4]  == 6'b111111) ? 1 : 0;
assign check5  = (map[5]  == 6'b111111) ? 1 : 0;
assign check6  = (map[6]  == 6'b111111) ? 1 : 0;
assign check7  = (map[7]  == 6'b111111) ? 1 : 0;
assign check8  = (map[8]  == 6'b111111) ? 1 : 0;
assign check9  = (map[9]  == 6'b111111) ? 1 : 0;
assign check10 = (map[10] == 6'b111111) ? 1 : 0;
assign check11 = (map[11] == 6'b111111) ? 1 : 0;
 
// scoring row pointer
always @(*)
begin
    if(check0)
        row_ptr = 0;
    else if(check1)
        row_ptr = 1;
    else if(check2)
        row_ptr = 2;
    else if(check3)
        row_ptr = 3;
    else if(check4)
        row_ptr = 4;
    else if(check5)
        row_ptr = 5;
    else if(check6)
        row_ptr = 6;
    else if(check7)
        row_ptr = 7;
    else if(check8)
        row_ptr = 8;
    else if(check9)
        row_ptr = 9;
    else if(check10)
        row_ptr = 10;
    else if(check11)
        row_ptr = 11;
    else
        row_ptr = 15;
end
 

// count score
assign score_reg = score_hold + score_f;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        score_hold <= 0;
    else if (n_s == s_DEL)
        score_hold <= score_reg;
    else if(n_s == s_FINISH || (c_s == s_DONE && game_cnt[4]) || (c_s == s_DEL && game_cnt[4]) || (n_s == s_IDLE && over))  //可能Done結束或DEL結束
        score_hold <= 0;
end



// ================================================================== Block placing ============================================================================
// map setting
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<14;i=i+1)
            map[i] <= 0;
    end
    else if(c_s == s_START)
    begin
        case(tet)
            0:
            begin
                map[idx][pos]     <= 1;
                map[idx][pos+1]   <= 1;
                map[idx+1][pos]   <= 1;
                map[idx+1][pos+1] <= 1;
            end
            1:
            begin
                map[idx]  [pos] <= 1;
                map[idx+1][pos] <= 1;
                map[idx+2][pos] <= 1;
                map[idx+3][pos] <= 1;
            end
            2:
            begin
                map[idx][pos]   <= 1;
                map[idx][pos+1] <= 1;
                map[idx][pos+2] <= 1;
                map[idx][pos+3] <= 1;
            end
            3:
            begin
                map[idx][pos]     <= 1;
                map[idx][pos+1]   <= 1;
                map[idx-1][pos+1] <= 1;
                map[idx-2][pos+1] <= 1;
            end
            4:
            begin
                map[idx][pos]     <= 1;
                map[idx+1][pos]   <= 1;
                map[idx+1][pos+1] <= 1;
                map[idx+1][pos+2] <= 1;
            end
            5:
            begin
                map[idx][pos]   <= 1;
                map[idx][pos+1] <= 1;
                map[idx+1][pos] <= 1;
                map[idx+2][pos] <= 1;
            end
            6:
            begin
                map[idx][pos]     <= 1;
                map[idx+1][pos]   <= 1;
                map[idx][pos+1]   <= 1;
                map[idx-1][pos+1] <= 1;
            end
            7:
            begin
                map[idx][pos]     <= 1;
                map[idx][pos+1]   <= 1;
                map[idx+1][pos+1] <= 1;
                map[idx+1][pos+2] <= 1;
            end
        endcase
    end

    else if(c_s == s_FINISH || (c_s == s_IDLE && game_cnt[4]) || (n_s == s_IDLE && over))
    begin
        for(i=0;i<14;i=i+1)
            map[i] <= 0;
    end

    else if(n_s == s_DEL)
    begin
        if(row_ptr == 0)
        begin
            for(i=0;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 1)
        begin
            for(i=1;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 2)
        begin
            for(i=2;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 3)
        begin
            for(i=3;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 4)
        begin
            for(i=4;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 5)
        begin
            for(i=5;i<12;i=i+1)
                map[i] <= map[i+1];
        end
        else if(row_ptr == 6)
        begin
            map[6]  <= map[7];
            map[7]  <= map[8];
            map[8]  <= map[9];
            map[9]  <= map[10];
            map[10] <= map[11];
            map[11] <= map[12];
        end
        else if(row_ptr == 7)
        begin
            map[7]  <= map[8];
            map[8]  <= map[9];
            map[9]  <= map[10];
            map[10] <= map[11];
            map[11] <= map[12];
        end
        else if(row_ptr == 8)
        begin
            map[8]  <= map[9];
            map[9]  <= map[10];
            map[10] <= map[11];
            map[11] <= map[12];
        end
        else if(row_ptr == 9)
        begin
            map[9]  <= map[10];
            map[10] <= map[11];
            map[11] <= map[12];
            map[12] <= map[13];
        end
        else if(row_ptr == 10)
        begin
            map[10] <= map[11];
            map[11] <= map[12];
            map[12] <= map[13];
        end
        else if(row_ptr == 11)
        begin
            map[11] <= map[12];
            map[12] <= map[13];
        end
    end   
end


// decide placing index
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        idx <= 0;
    else if(n_s == s_START)
    case(tetrominoes)
        0:
        begin
            if(map[11][position] || map[11][position+1])
                idx <= 12;
            else if(map[10][position] || map[10][position+1])
                idx <= 11;
            else if(map[9][position] || map[9][position+1])
                idx <= 10;
            else if(map[8][position] || map[8][position+1])
                idx <= 9;
            else if(map[7][position] || map[7][position+1])
                idx <= 8;
            else if(map[6][position] || map[6][position+1])
                idx <= 7;
            else if(map[5][position] || map[5][position+1])
                idx <= 6;
            else if(map[4][position] || map[4][position+1])
                idx <= 5;
            else if(map[3][position] || map[3][position+1])
                idx <= 4;
            else if(map[2][position] || map[2][position+1])
                idx <= 3;
            else if(map[1][position] || map[1][position+1])
                idx <= 2;
            else if(map[0][position] || map[0][position+1])
                idx <= 1;
            else
                idx <= 0;
        end
        1:
        begin
            if(map[11][position])
                idx <= 12;
            else if(map[10][position])
                idx <= 11;
            else if(map[9][position])
                idx <= 10;
            else if(map[8][position])
                idx <= 9;
            else if(map[7][position])
                idx <= 8;
            else if(map[6][position])
                idx <= 7;
            else if(map[5][position])
                idx <= 6;
            else if(map[4][position])
                idx <= 5;
            else if(map[3][position])
                idx <= 4;
            else if(map[2][position])
                idx <= 3;
            else if(map[1][position])
                idx <= 2;
            else if(map[0][position])
                idx <= 1;
            else
                idx <= 0;
        end
        2:
        begin
            if(map[11][position] || map[11][position+1] || map[11][position+2] || map[11][position+3])
                idx <= 12;
            else if(map[10][position] || map[10][position+1] || map[10][position+2] || map[10][position+3])
                idx <= 11;
            else if(map[9][position] || map[9][position+1] || map[9][position+2] || map[9][position+3])
                idx <= 10;
            else if(map[8][position] || map[8][position+1] || map[8][position+2] || map[8][position+3])
                idx <= 9;
            else if(map[7][position] || map[7][position+1] || map[7][position+2] || map[7][position+3])
                idx <= 8;
            else if(map[6][position] || map[6][position+1] || map[6][position+2] || map[6][position+3])
                idx <= 7;
            else if(map[5][position] || map[5][position+1] || map[5][position+2] || map[5][position+3])
                idx <= 6;
            else if(map[4][position] || map[4][position+1] || map[4][position+2] || map[4][position+3])
                idx <= 5;
            else if(map[3][position] || map[3][position+1] || map[3][position+2] || map[3][position+3])
                idx <= 4;
            else if(map[2][position] || map[2][position+1] || map[2][position+2] || map[2][position+3])
                idx <= 3;
            else if(map[1][position] || map[1][position+1] || map[1][position+2] || map[1][position+3])
                idx <= 2;
            else if(map[0][position] || map[0][position+1] || map[0][position+2] || map[0][position+3])
                idx <= 1;
            else
                idx <= 0;
        end
        3:
        begin
            if(map[13][position] || map[11][position+1])
                idx <= 14;
            else if(map[12][position] || map[10][position+1])
                idx <= 13;
            else if(map[11][position] || map[9][position+1])
                idx <= 12;
            else if(map[10][position] || map[8][position+1])
                idx <= 11;
            else if(map[9][position] || map[7][position+1])
                idx <= 10;
            else if(map[8][position] || map[6][position+1])
                idx <= 9;
            else if(map[7][position] || map[5][position+1])
                idx <= 8;
            else if(map[6][position] || map[4][position+1])
                idx <= 7;
            else if(map[5][position] || map[3][position+1])
                idx <= 6;
            else if(map[4][position] || map[2][position+1])
                idx <= 5;
            else if(map[3][position] || map[1][position+1])
                idx <= 4;
            else if(map[2][position] || map[0][position+1])
                idx <= 3;
            else
                idx <= 2;
        end
        4:
        begin
            if(map[11][position] || map[12][position+1] || map[12][position+2])
                idx <= 12;
            else if(map[10][position] || map[11][position+1] || map[11][position+2])
                idx <= 11;
            else if(map[9][position] || map[10][position+1] || map[10][position+2])
                idx <= 10;
            else if(map[8][position] || map[9][position+1] || map[9][position+2])
                idx <= 9;
            else if(map[7][position] || map[8][position+1] || map[8][position+2])
                idx <= 8;
            else if(map[6][position] || map[7][position+1] || map[7][position+2])
                idx <= 7;
            else if(map[5][position] || map[6][position+1] || map[6][position+2])
                idx <= 6;
            else if(map[4][position] || map[5][position+1] || map[5][position+2])
                idx <= 5;
            else if(map[3][position] || map[4][position+1] || map[4][position+2])
                idx <= 4;
            else if(map[2][position] || map[3][position+1] || map[3][position+2])
                idx <= 3;
            else if(map[1][position] || map[2][position+1] || map[2][position+2])
                idx <= 2;
            else if(map[0][position] || map[1][position+1] || map[1][position+2])
                idx <= 1;
            else
                idx <= 0;
        end
        5:
        begin
            if(map[11][position] || map[11][position+1])
                idx <= 12;
            else if(map[10][position] || map[10][position+1])
                idx <= 11;
            else if(map[9][position] || map[9][position+1])
                idx <= 10;
            else if(map[8][position] || map[8][position+1])
                idx <= 9;
            else if(map[7][position] || map[7][position+1])
                idx <= 8;
            else if(map[6][position] || map[6][position+1])
                idx <= 7;
            else if(map[5][position] || map[5][position+1])
                idx <= 6;
            else if(map[4][position] || map[4][position+1])
                idx <= 5;
            else if(map[3][position] || map[3][position+1])
                idx <= 4;
            else if(map[2][position] || map[2][position+1])
                idx <= 3;
            else if(map[1][position] || map[1][position+1])
                idx <= 2;
            else if(map[0][position] || map[0][position+1])
                idx <= 1;
            else
                idx <= 0;
        end
        6:
        begin
            if(map[11][position] || map[11][position+1] || map[10][position+1])
                idx <= 12;
            else if(map[10][position] || map[10][position+1] || map[9][position+1])
                idx <= 11;
            else if(map[9][position] || map[9][position+1] || map[8][position+1])
                idx <= 10;
            else if(map[8][position] || map[8][position+1] || map[7][position+1])
                idx <= 9;
            else if(map[7][position] || map[7][position+1] || map[6][position+1])
                idx <= 8;
            else if(map[6][position] || map[6][position+1] || map[5][position+1])
                idx <= 7;
            else if(map[5][position] || map[5][position+1] || map[4][position+1])
                idx <= 6;
            else if(map[4][position] || map[4][position+1] || map[3][position+1])
                idx <= 5;
            else if(map[3][position] || map[3][position+1] || map[2][position+1])
                idx <= 4;
            else if(map[2][position] || map[2][position+1] || map[1][position+1])
                idx <= 3;
            else if(map[1][position] || map[1][position+1] || map[0][position+1])
                idx <= 2;
            else
                idx <= 1;
        end
        7:
        begin
            if(map[11][position] || map[11][position+1] || map[12][position+2])
                idx <= 12;
            else if(map[10][position] || map[10][position+1] || map[11][position+2])
                idx <= 11;
            else if(map[9][position] || map[9][position+1] || map[10][position+2])
                idx <= 10;
            else if(map[8][position] || map[8][position+1] || map[9][position+2])
                idx <= 9;
            else if(map[7][position] || map[7][position+1] || map[8][position+2])
                idx <= 8;
            else if(map[6][position] || map[6][position+1] || map[7][position+2])
                idx <= 7;
            else if(map[5][position] || map[5][position+1] || map[6][position+2])
                idx <= 6;
            else if(map[4][position] || map[4][position+1] || map[5][position+2])
                idx <= 5;
            else if(map[3][position] || map[3][position+1] || map[4][position+2])
                idx <= 4;
            else if(map[2][position] || map[2][position+1] || map[3][position+2])
                idx <= 3;
            else if(map[1][position] || map[1][position+1] || map[2][position+2])
                idx <= 2;
            else if(map[0][position] || map[0][position+1] || map[1][position+2])
                idx <= 1;
            else
                idx <= 0;
        end
    endcase
end


// hold tetrominoes and position value
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tet <= 0;
    else if(n_s == s_START)
        tet <= tetrominoes;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pos <= 0;
    else if(n_s == s_START)
        pos <= position;
end

// --------------------------------------------- debug ------------------------------------------------
// always @(posedge score_valid or posedge over)
// begin
//     $display("tetris = %d, position = %d", tet, pos);
//     for(i=12; i>=0; i=i-1)
//         $display("map row %d = %b", i,{map[i][0],map[i][1],map[i][2],map[i][3],map[i][4],map[i][5]});
// end


// ================================================================ Output signal and data ============================================================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        score <= 0;
    else if(c_s == s_DONE && n_s != s_DEL)
        score <= score_reg;
    else if(c_s == s_DEL && n_s == s_IDLE)
        score <= score_reg;
    else
        score <= 0;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        score_valid <= 0;
    else if(c_s == s_DONE && n_s != s_DEL)
        score_valid <= 1;
    else if(c_s == s_DEL && n_s == s_IDLE)
        score_valid <= 1;
    else
        score_valid <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fail <= 0;
    else if(n_s == s_FINISH || (c_s == s_DEL && over))
        fail <= 1;
    else
        fail <= 0;

end


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tetris <= 0;
    else if(c_s == s_DONE && n_s != s_DEL && game_cnt[4])
        tetris <= {map[11],map[10],map[9],map[8],map[7],map[6],map[5],map[4],map[3],map[2],map[1],map[0]};
    else if(c_s == s_DEL && n_s == s_IDLE && game_cnt[4])
        tetris <= {map[11],map[10],map[9],map[8],map[7],map[6],map[5],map[4],map[3],map[2],map[1],map[0]};
    else if(n_s == s_FINISH || (c_s == s_DEL && over))
        tetris <= {map[11],map[10],map[9],map[8],map[7],map[6],map[5],map[4],map[3],map[2],map[1],map[0]};
    else
        tetris <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tetris_valid <= 0;
    else if(c_s == s_DONE && n_s != s_DEL && game_cnt[4])
        tetris_valid <= 1;
    else if(c_s == s_DEL && n_s == s_IDLE && game_cnt[4])
        tetris_valid <= 1;
    else if(n_s == s_FINISH || (c_s == s_DEL && over))
        tetris_valid <= 1;
    else
        tetris_valid <= 0;
end



endmodule

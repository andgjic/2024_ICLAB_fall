

/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: PATTERN
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Tsun-Yen Chen, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
//
/**************************************************************************/
`define PAT_NUM 1000
`ifdef RTL
    `define CYCLE_TIME 4.4
`endif
`ifdef GATE
    `define CYCLE_TIME 4.4
`endif

module PATTERN(
           //OUTPUT
           rst_n,
           clk,
           in_valid,
           tetrominoes,
           position,
           //INPUT
           tetris_valid,
           score_valid,
           fail,
           score,
           tetris
       );

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
output reg			rst_n, clk, in_valid;
output reg	[2:0]	tetrominoes;
output reg  [2:0]	position;

input 				tetris_valid, score_valid, fail;
input 		[3:0]	score;
input		[71:0]	tetris;

`protect128
//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer patnum = `PAT_NUM;
integer i, j, i_pat, a, patcount, gamecnt;
integer total_latency, latency;
integer f_in;
integer instruction;
integer t, p;
integer idx;
integer fail_golden;
integer score_golden;
integer out_cycle;


//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [5:0] map [13:0];
reg [71:0] map_golden;
reg score_valid_d1; //delay of score_valid
reg tetris_valid_d1; //delay of tetris_valid

//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
/* Define clock cycle */
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;


//Check SPEC-5
always @(negedge clk)
begin
    if (score_valid == 1'b0 && (score != 4'b0 || fail != 1'b0 || tetris_valid != 1'b0))
    begin
        $display("                    SPEC-5 FAIL                   ");
        $display("score_valid = %d, score = %d, fail = %d, tetris_valid = %d",score_valid,score,fail,tetris_valid);
        $finish; 
    end
    if (tetris_valid == 1'b0 && tetris != 72'b0)
    begin
        $display("                    SPEC-5 FAIL                   ");
        $finish;
    end
end

//Check SPEC-8
always @(posedge clk)
begin
    score_valid_d1 <= score_valid;
    tetris_valid_d1 <= tetris_valid;
end
always @(negedge clk)
begin
    if (score_valid == 1'b1 && score_valid_d1 == 1'b1)
    begin
        $display("                    SPEC-8 FAIL                   ");
        @(posedge clk)
        @(posedge clk)
        @(posedge clk)
        $finish;
    end
    if (tetris_valid == 1'b1 && tetris_valid_d1 == 1'b1)
    begin
        $display("                    SPEC-8 FAIL                   ");
        $finish;
    end
end


//---------------------------------------------------------------------
//  Main simulation
//---------------------------------------------------------------------
initial
begin
    // Open input files
    f_in  = $fopen("../00_TESTBED/input.txt", "r");
    if (f_in == 0)
    begin
        $display("Failed to open input.txt");
        $finish;
    end

    reset_task;

    a = $fscanf(f_in, "%d", patnum);    //read 1000
    // Iterate through each pattern
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1)
    begin
        gamecnt = 0;
        a = $fscanf(f_in, "%d", patcount);
        map_reset_task;
        for (instruction = 0; instruction < 16; instruction = instruction + 1)
        begin
            input_task;
            check_map_task;
            check_fail_task;
            wait_score_valid_task;


            if(fail_golden == 1)
                break;
            gamecnt = gamecnt + 1;
        end
        skip_task;
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mExecution Cycle: %3d\033[m", i_pat, total_latency);
    end



    // All patterns passed
    YOU_PASS_task;

end

//---------------------------------------------------------------------
//  Task function
//---------------------------------------------------------------------

task check_fail_task;
    begin
        if(map[12] != 6'b0)
            fail_golden = 1;
        else
            fail_golden = 0;
    end
endtask

task check_ans_task;
    begin
        map_golden[71:66] = map[11];
        map_golden[65:60] = map[10];
        map_golden[59:54] = map[9];
        map_golden[53:48] = map[8];
        map_golden[47:42] = map[7];
        map_golden[41:36] = map[6];
        map_golden[35:30] = map[5];
        map_golden[29:24] = map[4];
        map_golden[23:18] = map[3];
        map_golden[17:12] = map[2];
        map_golden[11:6]  = map[1];
        map_golden[5:0]   = map[0];

        //check spec-7
        if (tetris_valid)
        begin
            if(tetris != map_golden)
            begin
                $display("                    SPEC-7 FAIL                   ");
                $display("tetris = %d, tetris_golden = %d", tetris, map_golden);
                $finish;
            end
        end
        else
        begin
            $display("                    SPEC-7 FAIL                   ");
            $finish;
        end 

        // display design tetris map
        // $display("Tetris = %b",tetris[71:66]);
        // $display("Tetris = %b",tetris[65:60]);
        // $display("Tetris = %b",tetris[59:54]);
        // $display("Tetris = %b",tetris[53:48]);
        // $display("Tetris = %b",tetris[47:42]);
        // $display("Tetris = %b",tetris[41:36]);
        // $display("Tetris = %b",tetris[35:30]);
        // $display("Tetris = %b",tetris[29:24]);
        // $display("Tetris = %b",tetris[23:18]);
        // $display("Tetris = %b",tetris[17:12]);
        // $display("Tetris = %b",tetris[11:6] );
        // $display("Tetris = %b",tetris[5:0]  );

    end
endtask


//check map task
task check_map_task;
    begin
        for(i=0;i<12;i=i+1)
        begin
            if(map[i]==6'b111111)
            begin
                score_golden = score_golden + 1;
                for(j=i;j<13;j=j+1)
                    map[j] = map[j+1];
                // map[12] = 0;
                i=i-1;
            end
        end
    end
endtask

// calculate _task
task calculate_task;
    begin
        case(tetrominoes)
            0:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1 || map[i][position+1]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx][position+1] = 1;
                map[idx+1][position] = 1;
                map[idx+1][position+1] = 1;
            end
            1:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx]  [position] = 1;
                map[idx+1][position] = 1;
                map[idx+2][position] = 1;
                map[idx+3][position] = 1;

            end
            2:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1 || map[i][position+1]==1 || map[i][position+2]==1 || map[i][position+3]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx][position+1] = 1;
                map[idx][position+2] = 1;
                map[idx][position+3] = 1;

            end
            3:
            begin
                idx = 2;
                for(i=13; i>=2; i=i-1)
                begin
                    if(map[i][position]==1 || map[i-2][position+1]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx][position+1] = 1;
                map[idx-1][position+1] = 1;
                map[idx-2][position+1] = 1;


            end
            4:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1 || map[i+1][position+1]==1 || map[i+1][position+2]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx+1][position] = 1;
                map[idx+1][position+1] = 1;
                map[idx+1][position+2] = 1;

            end
            5:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1 || map[i][position+1]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx][position+1] = 1;
                map[idx+1][position] = 1;
                map[idx+2][position] = 1;

            end
            6:
            begin
                idx = 1;
                for(i=11; i>=1; i=i-1)
                begin
                    if(map[i][position]==1 || map[i][position+1]==1 || map[i-1][position+1]==1 )
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx+1][position] = 1;
                map[idx][position+1] = 1;
                map[idx-1][position+1] = 1;

            end

            7:
            begin
                idx = 0;
                for(i=11; i>=0; i=i-1)
                begin
                    if(map[i][position]==1 || map[i][position+1]==1 || map[i+1][position+2]==1)
                    begin
                        idx = i+1;
                        break;
                    end
                end

                map[idx][position] = 1;
                map[idx][position+1] = 1;
                map[idx+1][position+1] = 1;
                map[idx+1][position+2] = 1;

            end

        endcase
        // for(i=12; i>=0; i=i-1)
        //     $display("map row %d = %b", i,map[i]);
        // $display("next instruction");
    end
endtask


// map reset task
task map_reset_task;
    begin
        score_golden = 0;
        fail_golden = 0;
        for(i = 0; i<=13; i=i+1)
            map[i] = 0;
    end
endtask

// input task
task input_task;
    begin
        @(negedge clk);
        a = $fscanf(f_in, "%d %d", tetrominoes, position);
        // $display("tetrominoes = %d, position = %d", tetrominoes, position);
        in_valid = 1'b1;
        calculate_task;

        @(negedge clk);

        // Reset signals after processing
        in_valid = 1'b0;
        tetrominoes = 3'bx;
        position = 3'bx;

    end
endtask

// skip task
task skip_task;
    begin
        // $display("cnt = %d", gamecnt);
        for(i=gamecnt+1; i<16; i=i+1)
        begin
            a = $fscanf(f_in, "%d %d", t, p);
        end
    end
endtask

// Task to wait until out_valid is high
task wait_score_valid_task;
    begin
        out_cycle = 0;
        latency = 1;
        while (score_valid !== 1'b1)
        begin
            latency = latency + 1;
            if (latency == 1000)
            begin
                // $display("********************************************************");
                // $display("                          FAIL!                           ");
                // $display("*  The execution latency exceeded 100 cycles at %8t   *", $time);
                // $display("********************************************************");
                $display("                    SPEC-6 FAIL                   ");
                repeat (2) @(negedge clk);
                $finish;
            end
            @(negedge clk);
        end



        // check spec-7
        if(score !== score_golden)
        begin
            $display("                    SPEC-7 FAIL                   ");
            $display("score = %d, score_golden = %d", score, score_golden);
            $finish;
        end
        if(fail !== fail_golden)
        begin
            $display("                    SPEC-7 FAIL                   ");
            $display("fail = %d, fail_golden = %d", fail, fail_golden);
            $finish;
        end

        latency = latency + 1;
        total_latency = total_latency + latency;
    end
endtask

// reset task (SPEC-4)
task reset_task;
    begin
        rst_n = 1'b1;
        in_valid = 1'b0;
        tetrominoes = 3'bxxx;
        position = 3'bxxx;
        total_latency = 0;

        force clk = 0;

        // Apply reset
        #CYCLE;
        rst_n = 1'b0;
        #CYCLE;
        rst_n = 1'b1;

        // Check initial conditions
        if (tetris_valid !== 1'b0 || score_valid !== 1'b0 || fail !== 1'b0 || score !== 4'b0 || tetris !== 72'b0)
        begin
            // $display("************************************************************");
            // $display("                          FAIL!                           ");
            // $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
            // $display("************************************************************");
            $display("                    SPEC-4 FAIL                   ");
            $finish;
        end
        #CYCLE;
        release clk;

        repeat (10) @(negedge clk);
    end
endtask


// Task to indicate all patterns have passed
task YOU_PASS_task;
    begin
        $display("                  Congratulations!               ");
        $display("              execution cycles = %7d", total_latency);
        $display("              clock period = %4fns", CYCLE);

        repeat (2) @(negedge clk);
        $finish;
    end
endtask



`endprotect128
endmodule
    // for spec check
    // $display("                    SPEC-4 FAIL                   ");
    // $display("                    SPEC-5 FAIL                   ");
    // $display("                    SPEC-6 FAIL                   ");
    // $display("                    SPEC-7 FAIL                   ");
    // $display("                    SPEC-8 FAIL                   ");
    // for successful design
    // $display("                  Congratulations!               ");
    // $display("              execution cycles = %7d", total_latency);
    // $display("              clock period = %4fns", CYCLE);

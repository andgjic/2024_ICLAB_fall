`ifdef RTL
    `define CYCLE_TIME 8.2
`endif
`ifdef GATE
    `define CYCLE_TIME 8.2 
`endif

`define TOTAL_PATNUM 300
`define CORNER_PATNUM 100

module PATTERN(
    // Output signals
    clk,
	rst_n,
	in_valid,
    in_data, 
	in_mode,
    // Input signals
    out_valid, 
	out_data
);
//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output reg clk, rst_n, in_valid;
output reg [8:0] in_mode;
output reg [14:0] in_data;

input out_valid;
input [206:0] out_data;
//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;
initial	clk = 0;
//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer TOTAL_PATNUM = `TOTAL_PATNUM;
integer CORNER_PATNUM = `CORNER_PATNUM;
parameter IP_BIT = 11;
parameter [8:0] in_mode_array [0:2] = {9'b010101000, 9'b100001100, 9'b011001100};
parameter DECODED_2x2 = 5'b00100;
parameter DECODED_3x3 = 5'b00110;
parameter DECODED_4x4 = 5'b10110;
integer patcount;
integer latency, total_latency;
integer pos;
integer file;
integer corner_case_idx;
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg [IP_BIT-1:0] random_code;
reg encoding [1:IP_BIT+4];
reg [IP_BIT+4-1:0] encoded_code;
reg [IP_BIT-1:0] decoded_code;

reg [4:0] golden_mode;
reg signed [10:0] golden_matrix [0:3][0:3];

reg signed [22:0] golden_2x2 [0:8];
reg signed [50:0] golden_3x3 [0:3];
reg signed [206:0] golden_4x4;

reg [206:0] golden_ans;

wire signed [22:0] your_2x2 [0:8];
wire signed [50:0] your_3x3 [0:3];
wire signed [206:0] your_4x4;
//---------------------------------------------------------------------
//   ALWAYS
//---------------------------------------------------------------------
assign your_2x2[0] = out_data[206:184]; assign your_2x2[1] = out_data[183:161]; assign your_2x2[2] = out_data[160:138];
assign your_2x2[3] = out_data[137:115]; assign your_2x2[4] = out_data[114:92];  assign your_2x2[5] = out_data[91:69];
assign your_2x2[6] = out_data[68:46];   assign your_2x2[7] = out_data[45:23];   assign your_2x2[8] = out_data[22:0];

assign your_3x3[0] = out_data[203:153]; assign your_3x3[1] = out_data[152:102];
assign your_3x3[2] = out_data[101:51];  assign your_3x3[3] = out_data[50:0];

assign your_4x4 = out_data;

always @(*) begin
    if (in_valid && out_valid) begin
        print_fail_usagi;
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("************************************************************");
        $finish;            
    end    
end
// always @(negedge clk) begin
//     if (!out_valid && out_data !== 0) begin
//         print_fail_usagi;
//         $display("************************************************************");  
//         $display("                          FAIL!                           ");    
//         $display("*   The out_data should be zero when out_valid is low.   *");
//         $display("************************************************************");
//         $finish;
//     end
// end
//---------------------------------------------------------------------
//   INITIAL
//---------------------------------------------------------------------
initial begin
    reset_task;
    file = $fopen("../00_TESTBED/debug.txt", "w");
	for(patcount = 0; patcount < TOTAL_PATNUM; patcount++) begin
        input_task;

        write_input_to_file;
        wait_out_valid_task;

		check_ans;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mExecution Cycle: %3d\033[0;33m", patcount, latency);
	end
	print_pass_usagi;
    repeat(3) @(negedge clk);
    $finish;
end
//---------------------------------------------------------------------
//   TASK
//---------------------------------------------------------------------
task reset_task; begin 
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_data = 15'bx;
    in_mode = 9'bx;
    total_latency = 0;

    force clk = 0;

    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    
    // Check initial conditions
    if (out_valid !== 1'b0 || out_data !== 'b0) begin
        print_fail_usagi;
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask

task input_task; begin
    repeat($urandom_range(2,4)) @(negedge clk);	
    in_valid = 1'b1;

    for(integer i = 0; i < 16; i++) begin
        // data
        encode_task;
        golden_matrix[i / 4][i % 4] = random_code;
        in_data = encoded_code;

        // mode
        if(i == 0) begin
            pos = $urandom_range(0,2);
            in_mode = in_mode_array[pos];
            case (pos)
                0: golden_mode = DECODED_2x2;
                1: golden_mode = DECODED_3x3;
                default: golden_mode = DECODED_4x4;
            endcase
        end
        else in_mode = 'bx;

        @(negedge clk);
    end
    in_data = 15'bx;
    in_mode = 9'bx;
    in_valid = 1'b0;
end endtask

task encode_task; begin
    // -1024, 1023 or 1022
    corner_case_idx = $urandom_range(0,2);
    for (integer i = 0; i < IP_BIT; i++) begin
        if (patcount < CORNER_PATNUM) case (corner_case_idx)
            // -1024
            0: random_code[i] = i == IP_BIT-1;
            // 1023
            1: random_code[i] = i != IP_BIT-1;
            // 1022
            default: random_code[i] = i != 0 && i != IP_BIT - 1;
        endcase
        else random_code[i] = $urandom_range(0,1);
    end

    // if (patcount < CORNER_PATNUM)
    //     $display("Corner input: %b", random_code);


    for (integer i = 1; i <= IP_BIT + 4; i++)
        encoding[i] = 0;
    
    for (integer i = 1; i <= IP_BIT; i++) begin
        if (i == 1)
            encoding[3] = random_code[IP_BIT - i];
        else if (i <= 4)
            encoding[i + 3] = random_code[IP_BIT - i];
        else encoding[i + 4] = random_code[IP_BIT - i];
    end

    encoding[1] = 0; encoding[2] = 0;
    encoding[4] = 0; encoding[8] = 0;

    for (integer i = 1; i <= IP_BIT + 4; i++) begin
        if (i == 1 || i == 2 || i == 4 || i == 8)
            continue;
        if (i[0])
            encoding[1] = encoding[1] ^ encoding[i];
        if (i[1])
            encoding[2] = encoding[2] ^ encoding[i];
        if (i[2])
            encoding[4] = encoding[4] ^ encoding[i];
        if (i[3])
            encoding[8] = encoding[8] ^ encoding[i];
    end

    for (integer i = 1; i <= IP_BIT + 4; i++) begin
        encoded_code[IP_BIT + 4 - i] = encoding[i];
    end
    
    pos = $urandom_range(0, 2*IP_BIT + 7);

    if (pos < IP_BIT + 4) begin
        encoded_code[pos] = ~encoded_code[pos];
    end
end endtask

task wait_out_valid_task; begin
    latency = 0;
    while (out_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == 1000) begin
            print_fail_usagi;
            $display("********************************************************");     
            $display("                          FAIL!                           ");
            $display("*  The execution latency exceeded 1000 cycles at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask

task gen_ans; begin
    golden_2x2[0] = golden_matrix[0][0] * golden_matrix[1][1] - golden_matrix[0][1] * golden_matrix[1][0];
    golden_2x2[1] = golden_matrix[0][1] * golden_matrix[1][2] - golden_matrix[0][2] * golden_matrix[1][1];
    golden_2x2[2] = golden_matrix[0][2] * golden_matrix[1][3] - golden_matrix[0][3] * golden_matrix[1][2];
    golden_2x2[3] = golden_matrix[1][0] * golden_matrix[2][1] - golden_matrix[1][1] * golden_matrix[2][0];
    golden_2x2[4] = golden_matrix[1][1] * golden_matrix[2][2] - golden_matrix[1][2] * golden_matrix[2][1];
    golden_2x2[5] = golden_matrix[1][2] * golden_matrix[2][3] - golden_matrix[1][3] * golden_matrix[2][2];
    golden_2x2[6] = golden_matrix[2][0] * golden_matrix[3][1] - golden_matrix[2][1] * golden_matrix[3][0];
    golden_2x2[7] = golden_matrix[2][1] * golden_matrix[3][2] - golden_matrix[2][2] * golden_matrix[3][1];
    golden_2x2[8] = golden_matrix[2][2] * golden_matrix[3][3] - golden_matrix[2][3] * golden_matrix[3][2];

    golden_3x3[0] = golden_matrix[0][0] * golden_matrix[1][1] * golden_matrix[2][2]
                + golden_matrix[0][1] * golden_matrix[1][2] * golden_matrix[2][0]
                + golden_matrix[0][2] * golden_matrix[1][0] * golden_matrix[2][1]
                - golden_matrix[0][2] * golden_matrix[1][1] * golden_matrix[2][0]
                - golden_matrix[1][2] * golden_matrix[2][1] * golden_matrix[0][0]
                - golden_matrix[0][1] * golden_matrix[1][0] * golden_matrix[2][2];
    
    golden_3x3[1] = golden_matrix[0][1] * golden_matrix[1][2] * golden_matrix[2][3]
                + golden_matrix[0][2] * golden_matrix[1][3] * golden_matrix[2][1]
                + golden_matrix[0][3] * golden_matrix[1][1] * golden_matrix[2][2]
                - golden_matrix[0][3] * golden_matrix[1][2] * golden_matrix[2][1]
                - golden_matrix[1][3] * golden_matrix[2][2] * golden_matrix[0][1]
                - golden_matrix[0][2] * golden_matrix[1][1] * golden_matrix[2][3];
    
    golden_3x3[2] = golden_matrix[1][0] * golden_matrix[2][1] * golden_matrix[3][2]
                + golden_matrix[1][1] * golden_matrix[2][2] * golden_matrix[3][0]
                + golden_matrix[1][2] * golden_matrix[2][0] * golden_matrix[3][1]
                - golden_matrix[1][2] * golden_matrix[2][1] * golden_matrix[3][0]
                - golden_matrix[2][2] * golden_matrix[3][1] * golden_matrix[1][0]
                - golden_matrix[1][1] * golden_matrix[2][0] * golden_matrix[3][2];

    golden_3x3[3] = golden_matrix[1][1] * golden_matrix[2][2] * golden_matrix[3][3]
                + golden_matrix[1][2] * golden_matrix[2][3] * golden_matrix[3][1]
                + golden_matrix[1][3] * golden_matrix[2][1] * golden_matrix[3][2]
                - golden_matrix[1][3] * golden_matrix[2][2] * golden_matrix[3][1]
                - golden_matrix[2][3] * golden_matrix[3][2] * golden_matrix[1][1]
                - golden_matrix[1][2] * golden_matrix[2][1] * golden_matrix[3][3];
    
    golden_4x4 = golden_matrix[0][0] * golden_3x3[3]
            - golden_matrix[0][1] * (
                golden_matrix[1][0] * golden_matrix[2][2] * golden_matrix[3][3]
                + golden_matrix[1][2] * golden_matrix[2][3] * golden_matrix[3][0]
                + golden_matrix[1][3] * golden_matrix[2][0] * golden_matrix[3][2]
                - golden_matrix[1][3] * golden_matrix[2][2] * golden_matrix[3][0]
                - golden_matrix[1][2] * golden_matrix[2][0] * golden_matrix[3][3]
                - golden_matrix[1][0] * golden_matrix[2][3] * golden_matrix[3][2] )
            + golden_matrix[0][2] * (
                golden_matrix[1][0] * golden_matrix[2][1] * golden_matrix[3][3]
                + golden_matrix[1][1] * golden_matrix[2][3] * golden_matrix[3][0]
                + golden_matrix[1][3] * golden_matrix[2][0] * golden_matrix[3][1]
                - golden_matrix[1][3] * golden_matrix[2][1] * golden_matrix[3][0]
                - golden_matrix[1][1] * golden_matrix[2][0] * golden_matrix[3][3]
                - golden_matrix[1][0] * golden_matrix[2][3] * golden_matrix[3][1] )
             - golden_matrix[0][3] * golden_3x3[2];

    case (golden_mode)
        DECODED_2x2: begin
            golden_ans = { golden_2x2[0], golden_2x2[1], golden_2x2[2],
                            golden_2x2[3], golden_2x2[4], golden_2x2[5],
                            golden_2x2[6], golden_2x2[7], golden_2x2[8] };
        end
        DECODED_3x3: begin
            golden_ans = {3'b0, golden_3x3[0], golden_3x3[1], golden_3x3[2], golden_3x3[3]};
        end
        default: golden_ans = golden_4x4;
    endcase
end endtask

task check_ans; begin
    gen_ans;
    write_output_to_file;

    if (out_data !== golden_ans) begin
        print_fail_usagi;
        if (golden_mode == DECODED_2x2) begin
            $display("********************************************************"); 
            $display ("Golden 2nd order determinants:");
            $display ("%d\t%d\t%d", golden_2x2[0], golden_2x2[1], golden_2x2[2]);
            $display ("%d\t%d\t%d", golden_2x2[3], golden_2x2[4], golden_2x2[5]);
            $display ("%d\t%d\t%d", golden_2x2[6], golden_2x2[7], golden_2x2[8]);
            $display ("Your 2nd order determinants:");
            $display ("%d\t%d\t%d", your_2x2[0], your_2x2[1], your_2x2[2]);
            $display ("%d\t%d\t%d", your_2x2[3], your_2x2[4], your_2x2[5]);
            $display ("%d\t%d\t%d", your_2x2[6], your_2x2[7], your_2x2[8]);
            $display("********************************************************"); 
        end
        else if (golden_mode == DECODED_3x3) begin
            $display("********************************************************"); 
            $display ("Golden 3rd order determinants:");
            $display ("%d\t%d", golden_3x3[0], golden_3x3[1]);
            $display ("%d\t%d", golden_3x3[2], golden_3x3[3]);
            $display ("Your 3rd order determinants:");
            $display ("%d\t%d", your_3x3[0], your_3x3[1]);
            $display ("%d\t%d", your_3x3[2], your_3x3[3]);
            $display("********************************************************"); 
        end 
        else begin
            $display("********************************************************"); 
            $display ("Golden 4th order Determinant:");
            $display ("%d", golden_4x4);
            $display ("Your 4th order Determinant:");
            $display ("%d", your_4x4);
            $display("********************************************************"); 
        end
        repeat (9) @(negedge clk);
        $finish;
    end
    
    @(negedge clk);
        
    // Check if the number of outputs matches the expected count
    if(out_valid) begin
        print_fail_usagi;
        $display("************************************************************");  
        $display("                            FAIL!                           ");
        $display("             Expected one cycle of valid output             ");
        $display("************************************************************");
        repeat(9) @(negedge clk);
        $finish;
    end
end endtask



task write_input_to_file; begin
    $fwrite(file, "=========  PATTERN NO.%4d  =========\n", patcount);
    $fwrite(file, "=========  in_mode = %5b  =========\n", golden_mode);
    $fwrite(file, "=============  in_data  =============\n");
    for(integer i = 0; i < 4; i = i + 1) begin
        for(integer j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%7d ", golden_matrix[i][j]);
        end
        $fwrite(file, "\n");
    end
end endtask

task write_output_to_file; begin
    $fwrite(file, "==============  2 * 2  ==============\n");
    for(integer i = 0; i < 9; i = i + 1) begin
        $fwrite(file, "%10d ", golden_2x2[i]);
        if(i % 3 == 2)begin
            $fwrite(file, "\n");
        end
    end
    $fwrite(file, "==============  3 * 3  ==============\n");
    for(integer i = 0; i < 4; i = i + 1) begin
        $fwrite(file, "%15d ", golden_3x3[i]);
        if(i % 2 == 1)begin
            $fwrite(file, "\n");
        end
    end
    $fwrite(file, "==============  4 * 4  ==============\n");
    $fwrite(file, "     %20d\n", golden_4x4);
    $fwrite(file, "==========  Golden Answer  ==========\n");
    $fwrite(file, "%h\n", golden_ans);
    $fwrite(file, "\n\n");
end endtask

task print_pass_usagi; begin
    $display("\033[37m                                  .$&X.      x$$x              \033[32m      :BBQvi.");
    $display("\033[37m                                .&&;.X&$  :&&$+X&&x            \033[32m     BBBBBBBBQi");
    $display("\033[37m                               +&&    &&.:&$    .&&            \033[32m    :BBBP :7BBBB.");
    $display("\033[37m                              :&&     &&X&&      $&;           \033[32m    BBBB     BBBB");
    $display("\033[37m                              &&;..   &&&&+.     +&+           \033[32m   iBBBv     BBBB       vBr");
    $display("\033[37m                             ;&&...   X&&&...    +&.           \033[32m   BBBBBKrirBBBB.     :BBBBBB:");
    $display("\033[37m                             x&$..    $&&X...    +&            \033[32m  rBBBBBBBBBBBR.    .BBBM:BBB");
    $display("\033[37m                             X&;...   &&&....    &&            \033[32m  BBBB   .::.      EBBBi :BBU");
    $display("\033[37m                             $&...    &&&....    &&            \033[32m MBBBr           vBBBu   BBB.");
    $display("\033[37m                             $&....   &&&...     &$            \033[32m i7PB          iBBBBB.  iBBB");
    $display("\033[37m                             $&....   &&& ..    .&x                        \033[32m  vBBBBPBBBBPBBB7       .7QBB5i");
    $display("\033[37m                             $&....   &&& ..    x&+                        \033[32m :RBBB.  .rBBBBB.      rBBBBBBBB7");
    $display("\033[37m                             X&;...   x&&....   &&;                        \033[32m    .       BBBB       BBBB  :BBBB");
    $display("\033[37m                             x&X...    &&....   &&:                        \033[32m           rBBBr       BBBB    BBBU");
    $display("\033[37m                             :&$...    &&+...   &&:                        \033[32m           vBBB        .BBBB   :7i.");
    $display("\033[37m                              &&;...   &&$...   &&:                        \033[32m             .7  BBB7   iBBBg");
    $display("\033[37m                               && ...  X&&...   &&;                                         \033[32mdBBB.   5BBBr");
    $display("\033[37m                               .&&;..  ;&&x.    $&;.$&$x;                                   \033[32m ZBBBr  EBBBv     YBBBBQi");
    $display("\033[37m                               ;&&&+   .+xx;    ..  :+x&&&&&&&x                             \033[32m  iBBBBBBBBD     BBBBBBBBB.");
    $display("\033[37m                        +&&&&&&X;..             .          .X&&&&&x                         \033[32m    :LBBBr      vBBBi  5BBB");
    $display("\033[37m                    $&&&+..                                    .:$&&&&.                     \033[32m          ...   :BBB:   BBBu");
    $display("\033[37m                 $&&$.                                             .X&&&&.                  \033[32m         .BBBi   BBBB   iMBu");
    $display("\033[37m              ;&&&:                                               .   .$&&&                x\033[32m          BBBX   :BBBr");
    $display("\033[37m            x&&x.      .+&&&&&.                .x&$x+:                  .$&&X         $+  &x  ;&X   \033[32m  .BBBv  :BBBQ");
    $display("\033[37m          .&&;       .&&&:                      .:x$&&&&X                 .&&&        ;&     +&.    \033[32m   .BBBBBBBBB:");
    $display("\033[37m         $&&       .&&$.                             ..&&&$                 x&& x&&&X+.          X&x\033[32m     rBBBBB1.");
    $display("\033[37m        &&X       ;&&:                                   $&&x                $&x   .;x&&&&:                       ");
    $display("\033[37m      .&&;       ;&x                                      .&&&                &&:       .$&&$    ;&&.             ");
    $display("\033[37m      &&;       .&X                                         &&&.              :&$          $&&x                   ");
    $display("\033[37m     x&X       .X& .                                         &&&.              .            ;&&&  &&:             ");
    $display("\033[37m     &&         $x                                            &&.                            .&&&                 ");
    $display("\033[37m    :&&                                                       ;:                              :&&X                ");
    $display("\033[37m    x&X                 :&&&&&;                ;$&&X:                                          :&&.               ");
    $display("\033[37m    X&x .              :&&&  $&X              &&&  X&$                                          X&&               ");
    $display("\033[37m    x&X                x&&&&&&&$             :&&&&$&&&                                          .&&.              ");
    $display("\033[37m    .&&    \033[38;2;255;192;203m      ....\033[37m  .&&X:;&&+              &&&++;&&                                          .&&               ");
    $display("\033[37m     &&    \033[38;2;255;192;203m  .$&.x+..:\033[37m  ..+Xx.                 :&&&&+\033[38;2;255;192;203m  .;......    \033[37m                             .&&");
    $display("\033[37m     x&x   \033[38;2;255;192;203m .x&:;&x:&X&&.\033[37m              .             \033[38;2;255;192;203m .&X:&&.&&.:&.\033[37m                             :&&");
    $display("\033[37m     .&&:  \033[38;2;255;192;203m  x;.+X..+.;:.\033[37m         ..  &&.            \033[38;2;255;192;203m &X.;&:+&$ &&.\033[37m                             x&;");
    $display("\033[37m      :&&. \033[38;2;255;192;203m    .......   \033[37m         x&&&&&$++&$        \033[38;2;255;192;203m .... ......: \033[37m                             && ");
    $display("\033[37m       ;&&                          X&  .x.              \033[38;2;255;192;203m .... \033[37m                               .&&;                ");
    $display("\033[37m        .&&x                        .&&$X                                          ..         .x&&&               ");
    $display("\033[37m          x&&x..                                                                 :&&&&&+         +&X              ");
    $display("\033[37m            ;&&&:                                                                     x&&$XX;::x&&X               ");
    $display("\033[37m               &&&&&:.                                                              .X&x    +xx:                  ");
    $display("\033[37m                  ;&&&&&&&&$+.                                  :+x&$$X$&&&&&&&&&&&&&$                            ");
    $display("\033[37m                       .+X$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$X+xXXXxxxx+;.                                   ");
    $display("\033[32m                                    Congratulations!");
    $display("\033[32m                                    total latency = %d \033[37m",total_latency);
// light pink blush: \033[38;2;255;192;203m
// character: 125 pixels
// contrast: 180%
end endtask

task print_fail_usagi; begin                                                                                                                         
    $display("\033[37m                                                                         x&&&&X  +&&&&&&+                                    ");
    $display("\033[37m                                                                      .&&&&$$&&&&&&+ .&&&&                                   ");
    $display("\033[37m                                                                     X&&&;   &&&&$     X&&&                                  ");
    $display("\033[31m i:..::::::i.      :::::         ::::    .:::.        \033[37m              &&&X.    &&&&..    .&&&;                                 ");
    $display("\033[31m BBBBBBBBBBBi     iBBBBBL       .BBBB    7BBB7        \033[37m             &&&X .   .&&&; .    .&&&;                                 ");
    $display("\033[31m BBBB.::::ir.     BBB:BBB.      .BBBv    iBBB:        \033[37m            X&&&...   +&&&. .    ;&&&:                                 ");
    $display("\033[31m BBBQ            :BBY iBB7       BBB7    :BBB:        \033[37m           ;&&&; ..  .&&&X  .    x&&&.                                 ");
    $display("\033[31m BBBB            BBB. .BBB.      BBB7    :BBB:        \033[37m           &&&$  ..  ;&&&+  .   .&&&$                                  ");
    $display("\033[31m BBBB:r7vvj:    :BBB   gBBs      BBB7    :BBB:        \033[37m          .&&&;  ..  $&&&. ..   ;&&&;                                  ");
    $display("\033[31m BBBBBBBBBB7    BBB:   .BBB.     BBB7    :BBB:        \033[37m          ;&&&:  .  .&&&x ..    X&&&                                   ");
    $display("\033[31m BBBB    ..    iBBBBBBBBBBBP     BBB7    :BBB:        \033[37m          +&&&.  .  +&&&: ..   .&&&x                                   ");
    $display("\033[31m BBBB          BBBBi7vviQBBB.    BBB7    :BBB.        \033[37m          +&&&.     $&&X. ..   X&&&.                                   ");
    $display("\033[31m BBBB         rBBB.      BBBQ   .BBBv    iBBB2ir777L7 \033[37m          +&&&.    :&&&:...   :&&&X                                    ");
    $display("\033[31m.BBBB        :BBBB       BBBB7  .BBBB    7BBBBBBBBBBB \033[37m          ;&&&.    x&&$       X&&&.                                    ");
    $display("\033[31m . ..        ....         ...:   ....    ..   ....... \033[37m          .&&&.   .&&&&+.    :&&&X                                     ");
    $display("\033[37m                                                        :+X&&.   X&X     X&&&X.    &&&&                                      ");
    $display("\033[37m                                                    ;$&&&&&&&:                     :Xx  ;&&&&&&$;                            ");
    $display("\033[37m                                                .$&&&&&X;.                                 ;x&&&&&&+   $&&&X:                ");
    $display("\033[37m                                              ;&&&&&x.                                         :$&&&&;  ;x&&&&&:             ");
    $display("\033[37m                                            :&&&&&.      .;X$$:                   ....            ;&&&&+    .x&&&x           ");
    $display("\033[37m                                           $&&&x.     .$&&&&&&x.                ;&&&&&&&$;          :&&&&;      $&&X         ");
    $display("\033[37m                                         :&&&&.     .$&&&;.                        ..;&&&&&$.         x&&&x      :&&&.       ");
    $display("\033[37m                                        .&&&&      :&&&.                                ;&&&&:         +&&&x       $&&+      ");
    $display("\033[37m                                        $&&$.     :&&X                                   .$&&&:         ;&&&+       &&&x     ");
    $display("\033[37m                                       x&&&.     .&&x                                   .  &&&&.         $&&&:      .&&&+    ");
    $display("\033[37m                                      :&&&:       ;+.      .:;:..              :&&&&&x     :&&&.         ;&&&x       +&&&    ");
    $display("\033[37m                                      X&&$               .&&&&&&&&.           X&&& .&&&+     .           .&&&$       :&&&;   ");
    $display("\033[37m                                      &&&;               $&&& +&&&X           $&&&&&&&&x                  $&&&:       &&&&   ");
    $display("\033[37m                                     +&&&.               X&&&&&&&&;           +&&&&x&&&.             .    x&&&;       x&&&:  ");
    $display("\033[37m                                     &&&X  \033[38;2;255;192;203m      ....   \033[37m .X&&&&&&;             .x&&&&X.\033[38;2;255;192;203m  ......    \033[37m  ..   ;&&&:       +&&&+  ");
    $display("\033[37m                                     X&&X  \033[38;2;255;192;203m  .  ;&$. .. \033[37m                .              \033[38;2;255;192;203m x&&:   ..  \033[37m       +&&&.       ;&&&+  ");
    $display("\033[37m         x&&&&&&&&&&&&&&&&&X         +&&$  \033[38;2;255;192;203m .. .&&&:&&&: . \033[37m        .:..&&&;          \033[38;2;255;192;203m .+&&&.x&&: . \033[37m       x&&&        :&&&X  ");
    $display("\033[37m      :;  xxxx;   .;;;.  .$&&.       :&&&. \033[38;2;255;192;203m  . .XX.x&&;  . \033[37m       .&&&&&&&&&X;       \033[38;2;255;192;203m ..&&:.$&&&.. \033[37m      .&&&X        ;&&&x  ");
    $display("\033[37m   ;&&&&:                  x&&:       $&&$ \033[38;2;255;192;203m        .:.. .  \033[37m         +&&&;x&&&x.      \033[38;2;255;192;203m .      .:.   \033[37m      ;&&&.        ;&&&;  ");
    $display("\033[37m :&&&&&&$        .+$&&&$Xx+X&&&.       &&&X\033[38;2;255;192;203m    ........    \033[37m         .&&&+            \033[38;2;255;192;203m    .......   \033[37m     .&&&x         X&&&   ");
    $display("\033[37m &&$   +&&&&&&&&&&&&&&&&&&&&&&&;       .&&&&.                        ;&&&&.                             X&&&          &&&$   ");
    $display("\033[37m &&x:&x  $&&&&&&X.          x&&         .&&&&+                         .:.                             X&&&          .&&&;   ");
    $display("\033[37m.&&$:&&+ :&&;x&&            $&&           :&&&&;                                                     ;&&&X           x&&&    ");
    $display("\033[37m X&&&:   .&&; &&+           ;&&;             $&&$.                                                  ;&&&             &&&+    ");
    $display("\033[37m  :&&&&$$&&&&$&&&            $&&.            ;&&+                                                    .&&;           x&&&.    ");
    $display("\033[37m     x&&&&&&&&&&&;           x&&&+           $&&.     .                                   ;&&+       .&&X          :&&&+     ");
    $display("\033[37m               +&&. .+x$&&&&&&&X:            &&&.   .&&$                                 x&&X  .&$   .&&X         +&&&;      ");
    $display("\033[37m                &&&&&&&&&&&X:                &&&.   .&&;                                .&&&+ ;&&&.  ;&&&+        &&$        ");
    $display("\033[37m                 ;+:                         +&&$. +&&X                                  $&&&&&&&;   X&&&&X                  ");
    $display("\033[37m                                              :&&&&&&&+.                                 .+&&&&;    :&&&&&&.   :&$           ");
    $display("\033[37m                                                     &&&;                                          .&&&&&&&    X&&+          ");
    $display("\033[37m                                                     .&&&:                                        .&&&&&&&     &&&&          ");
    $display("\033[37m                                                      :&&&;                                      ;&&&&&&&x    x&&&x          ");
    $display("\033[37m                                                   :&x  &&&$.                                   x&&&&&&&.    $&&&&$          ");
    $display("\033[37m                                                  +&&X    x&&&&;                              x&&&&&&&x    .&&&&&&&          ");
    $display("\033[37m                                                  &&&       x&&+    +$;      ..        ..;X&&&&&&&&x.     x&&&&&&&X          ");
    $display("\033[37m                                                  $&&       .&&&   :&&&.   .$&&:&&&&&&&&&&&&&$;          &&&&X &&&;          ");
    $display("\033[37m                                                  :&&&:      +&&&;;&&&&    X&&. x&&&&&$X:             .$&&&&: ;&&&           ");
    $display("\033[37m                                                   ;&&&$      .$&&&&&&&$:X&&$                       :&&&&&:  :&&&:           ");
    $display("\033[37m                                                    .&&&&&;          X&&&&X.                     +&&&&&X    +&&&.            ");
    $display("\033[37m                                                      .$&&&&&+                               x&&&&&&+      ;&&&.             ");
    $display("\033[37m                                                         :&&&&&&&&$+.            .;+xX$&&&&&&&&&X:        +&&&:              ");
    $display("\033[37m                                                           $&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&x:           +&&&&.               ");
    $display("\033[37m                                                             x&&&&;+X&&&&&&&&&&&$x.                  :$&&&&:                 ");
    $display("\033[37m                                                               &&&&$:                             .X&&&&x                    ");
    $display("\033[37m                                                                .&&&&&&&&&&+                   X&&&&&$.                      ");
    $display("\033[37m                                                                      .;&&&&&                  $&&&+                         ");
    $display("\033[37m                                                                         &&&&+.             :x&&&&:                          ");
    $display("\033[37m                                                                          X&&&&&&&&&&&&&&&&&&&&$                             ");
    $display("\033[37m                                                                             .;xX$&&&&&$$x+:                                 ");
// light pink blush: \033[38;2;255;192;203m
// character: 125 pixels
// contrast: 185%
end endtask

endmodule

/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: TSUN-YEN CHEN
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Fall IC Lab / Exersise Lab08 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
`define CYCLE_TIME 50
`define PAT_NUM 10
`define MODE 8

module PATTERN(
	// Output signals
	clk,
	rst_n,
	in_valid,
	T,
	in_data,
	w_Q,
	w_K,
	w_V,

	// Input signals
	out_valid,
	out_data
);

output reg clk;
output reg rst_n;
output reg in_valid;
output reg [3:0] T;
output reg signed [7:0] in_data;
output reg signed [7:0] w_Q;
output reg signed [7:0] w_K;
output reg signed [7:0] w_V;

input out_valid;
input signed [63:0] out_data;


















reg[9*8:1]  reset_color       = "\033[1;0m";
reg[10*8:1] txt_black_prefix  = "\033[1;30m";
reg[10*8:1] txt_red_prefix    = "\033[1;31m";
reg[10*8:1] txt_green_prefix  = "\033[1;32m";
reg[10*8:1] txt_yellow_prefix = "\033[1;33m";
reg[10*8:1] txt_blue_prefix   = "\033[1;34m";

reg[10*8:1] bkg_black_prefix  = "\033[40;1m";
reg[10*8:1] bkg_red_prefix    = "\033[41;1m";
reg[10*8:1] bkg_green_prefix  = "\033[42;1m";
reg[10*8:1] bkg_yellow_prefix = "\033[43;1m";
reg[10*8:1] bkg_blue_prefix   = "\033[44;1m";
reg[10*8:1] bkg_white_prefix  = "\033[47;1m";
//================================================================
// Clock
//================================================================
real CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk; //clock

//================================================================
// parameters & integer
//================================================================
integer i,j,k;

integer patnum = `PAT_NUM;
integer i_pat;
integer latency;
integer total_latency;

integer count_input, delay_2to4, out_num, delay_1to4;
integer debug;
integer T_mode = `MODE;
parameter integer in_T[3] = {1, 4, 8};
integer in_T_type;
//================================================================
// reg & wire
//================================================================
reg signed [7:0] mat_in  [0:7][0:7];
reg signed [7:0] mat_wQ  [0:7][0:7];
reg signed [7:0] mat_wK  [0:7][0:7];
reg signed [7:0] mat_wV  [0:7][0:7];
reg signed [18:0] mat_Q  [0:7][0:7];
reg signed [18:0] mat_K  [0:7][0:7];
reg signed [18:0] mat_V  [0:7][0:7];
reg signed [40:0] mat_A  [0:7][0:7];       
reg signed [40:0] mat_scale  [0:7][0:7];        
reg signed [40:0] mat_S  [0:7][0:7];        
reg signed [63:0] mat_P  [0:7][0:7];        


//================================================================
// Initial
//================================================================
initial begin
    // Initialize signals
    reset_task;

    // Iterate through each pattern
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) 
    begin
        input_task;
        cal_task;
        display_task;
        wait_out_valid_task;
        check_ans_task;
        $display("%0sPASS PATTERN NO.%4d %0sCycles: %3d%0s",txt_blue_prefix, i_pat, txt_green_prefix, latency, reset_color);

    end
    YOU_PASS_task;
    
    $finish;
end 

//================================================================
// Tasks
//================================================================
// check answer task
task check_ans_task; begin
    for(i=0;i<T_mode*8;i=i+1) begin
        if(out_data !== mat_P[i/8][i%8])begin
            $display("ans_wrong");
            $display("golden_ans:%d",mat_P[i/8][i%8]);
            $display("your_ans:  %d",out_data);
            $finish;
        end
        @(negedge clk);
    end

end endtask

// calculate answer task
task cal_task; begin
    // cal QKV
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<8;j=j+1)
            mat_Q[i][j] =  mat_in[i][0] * mat_wQ[0][j] + mat_in[i][1] * mat_wQ[1][j] + mat_in[i][2] * mat_wQ[2][j]
                          +mat_in[i][3] * mat_wQ[3][j] + mat_in[i][4] * mat_wQ[4][j] + mat_in[i][5] * mat_wQ[5][j]
                          +mat_in[i][6] * mat_wQ[6][j] + mat_in[i][7] * mat_wQ[7][j];
    end
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<8;j=j+1)
            mat_K[i][j] =  mat_in[i][0] * mat_wK[0][j] + mat_in[i][1] * mat_wK[1][j] + mat_in[i][2] * mat_wK[2][j]
                          +mat_in[i][3] * mat_wK[3][j] + mat_in[i][4] * mat_wK[4][j] + mat_in[i][5] * mat_wK[5][j]
                          +mat_in[i][6] * mat_wK[6][j] + mat_in[i][7] * mat_wK[7][j];
    end
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<8;j=j+1)
            mat_V[i][j] =  mat_in[i][0] * mat_wV[0][j] + mat_in[i][1] * mat_wV[1][j] + mat_in[i][2] * mat_wV[2][j]
                          +mat_in[i][3] * mat_wV[3][j] + mat_in[i][4] * mat_wV[4][j] + mat_in[i][5] * mat_wV[5][j]
                          +mat_in[i][6] * mat_wV[6][j] + mat_in[i][7] * mat_wV[7][j];
    end
    // cal A=Q*KT
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            mat_A[i][j] =  mat_Q[i][0] * mat_K[j][0] + mat_Q[i][1] * mat_K[j][1] + mat_Q[i][2] * mat_K[j][2]
                          +mat_Q[i][3] * mat_K[j][3] + mat_Q[i][4] * mat_K[j][4] + mat_Q[i][5] * mat_K[j][5]
                          +mat_Q[i][6] * mat_K[j][6] + mat_Q[i][7] * mat_K[j][7];
    end
    // cal scale
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            mat_scale[i][j] =  mat_A[i][j] / 3;
    end
    // cal ReLu
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            mat_S[i][j] =  mat_scale[i][j][40] ? 0 : mat_scale[i][j];
    end
    // cal P=S*V
    for(i=0;i<T_mode;i=i+1) begin
        if(T_mode == 1) begin
            for(j=0;j<8;j=j+1)
                mat_P[i][j] =  mat_S[i][0] * mat_V[0][j];                        
        end
        else if(T_mode == 4) begin
            for(j=0;j<8;j=j+1)
                mat_P[i][j] =  mat_S[i][0] * mat_V[0][j] + mat_S[i][1] * mat_V[1][j] + mat_S[i][2] * mat_V[2][j]
                              +mat_S[i][3] * mat_V[3][j];
        end
        else begin
            for(j=0;j<8;j=j+1)
                mat_P[i][j] =  mat_S[i][0] * mat_V[0][j] + mat_S[i][1] * mat_V[1][j] + mat_S[i][2] * mat_V[2][j]
                              +mat_S[i][3] * mat_V[3][j] + mat_S[i][4] * mat_V[4][j] + mat_S[i][5] * mat_V[5][j]
                              +mat_S[i][6] * mat_V[6][j] + mat_S[i][7] * mat_V[7][j];
        end
        
    end

end endtask

// display task
task display_task; begin
    // ----- input -----
	// write input data
    debug = $fopen("debug.txt", "w");
    $fwrite(debug, "[PAT NO. %4d]\n\n", i_pat);

    $fwrite(debug, "input data: %1d * %1d\n", T_mode, 8);
    for(i=0;i<T_mode;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_in[i][0], mat_in[i][1], mat_in[i][2], mat_in[i][3], mat_in[i][4], mat_in[i][5], mat_in[i][6], mat_in[i][7]);

    $fwrite(debug, "Matrix Q weight: %1d * %1d\n", 8, 8); 
    for(i=0;i<8;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_wQ[i][0], mat_wQ[i][1], mat_wQ[i][2], mat_wQ[i][3], mat_wQ[i][4], mat_wQ[i][5], mat_wQ[i][6], mat_wQ[i][7]);

    $fwrite(debug, "Matrix K weight: %1d * %1d\n", 8, 8); 
    for(i=0;i<8;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_wK[i][0], mat_wK[i][1], mat_wK[i][2], mat_wK[i][3], mat_wK[i][4], mat_wK[i][5], mat_wK[i][6], mat_wK[i][7]);

    $fwrite(debug, "Matrix V weight: %1d * %1d\n", 8, 8); 
    for(i=0;i<8;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_wV[i][0], mat_wV[i][1], mat_wV[i][2], mat_wV[i][3], mat_wV[i][4], mat_wV[i][5], mat_wV[i][6], mat_wV[i][7]);   
   
    // write calculation data
    $fwrite(debug, "---------- QKV Generation ----------\n"); 
    $fwrite(debug, "Matrix Q: %1d * %1d\n", 8, 8); 
    for(i=0;i<T_mode;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_Q[i][0], mat_Q[i][1], mat_Q[i][2], mat_Q[i][3], mat_Q[i][4], mat_Q[i][5], mat_Q[i][6], mat_Q[i][7]);
    $fwrite(debug, "Matrix K: %1d * %1d\n", 8, 8); 
    for(i=0;i<T_mode;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_K[i][0], mat_K[i][1], mat_K[i][2], mat_K[i][3], mat_K[i][4], mat_K[i][5], mat_K[i][6], mat_K[i][7]);
    $fwrite(debug, "Matrix V: %1d * %1d\n", 8, 8); 
    for(i=0;i<T_mode;i=i+1)
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_V[i][0], mat_V[i][1], mat_V[i][2], mat_V[i][3], mat_V[i][4], mat_V[i][5], mat_V[i][6], mat_V[i][7]);

    $fwrite(debug, "---------- MatMul1 ----------\n"); 
    $fwrite(debug, "Matrix A: %1d * %1d\n", T_mode, T_mode); 
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            $fwrite(debug, "%d ", mat_A[i][j]);
        $fwrite(debug, "\n");
    end

    $fwrite(debug, "---------- Scaling ----------\n"); 
    $fwrite(debug, "Matrix A after scaling: %1d * %1d\n", T_mode, T_mode); 
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            $fwrite(debug, "%d ", mat_scale[i][j]);
        $fwrite(debug, "\n");
    end

    $fwrite(debug, "---------- ReLU ----------\n"); 
    $fwrite(debug, "Matrix S: %1d * %1d\n", T_mode, T_mode); 
    for(i=0;i<T_mode;i=i+1) begin
        for(j=0;j<T_mode;j=j+1)
            $fwrite(debug, "%d ", mat_S[i][j]);
        $fwrite(debug, "\n");
    end

    $fwrite(debug, "---------- Golden answer ----------\n"); 
    $fwrite(debug, "Matrix P: %1d * %1d\n", T_mode, 8); 
    for(i=0;i<T_mode;i=i+1) 
        $fwrite(debug, "%d %d %d %d %d %d %d %d\n", mat_P[i][0], mat_P[i][1], mat_P[i][2], mat_P[i][3], mat_P[i][4], mat_P[i][5], mat_P[i][6], mat_P[i][7]);

end endtask

// ============= input task =============
task input_task; begin
	delay_1to4 = $urandom() % 4 + 1;		
    repeat (delay_1to4) @(negedge clk);////delay for 1-4

    
    in_valid = 1;
    in_T_type = $urandom()%3;
    T = in_T[in_T_type]; 
    T_mode = in_T[in_T_type];


    // indata, Q
    for(i=0;i<64;i=i+1)
    begin
        if(T_mode==8)
            in_data = $random() % 128 + 1;
        else if(T_mode==4 && i<32)
            in_data = $random() % 128 + 1;
        else if(T_mode==1 && i<8)
            in_data = $random() % 128 + 1;
        else
            in_data = 'bx;

        w_Q = $random() % 5 + 1;

        // store input
        mat_in[i/8][i%8] = in_data;
        mat_wQ[i/8][i%8] = w_Q;

        @(negedge clk);   
        T = 'bx;
    end
    w_Q = 'bx;
    in_data = 15'bx;

    // K
    for(i=0;i<64;i=i+1)
    begin
        w_K = $random() % 128 + 1;
        // store input
        mat_wK[i/8][i%8] = w_K;
        @(negedge clk);   
    end
    w_K = 'bx;
    // V
    for(i=0;i<64;i=i+1)
    begin
        w_V = $random() % 128 + 1;
        // store input
        mat_wV[i/8][i%8] = w_V;
        @(negedge clk);   
    end
    w_V = 'bx;

    in_valid = 0;
end endtask


task wait_out_valid_task; begin
    //while (out_valid !== 1'b1) begin
	latency = 0;
	while(out_valid !== 1'b1)begin
        latency = latency + 1;
        if (latency == 1000) begin
            $display("********************************************************");     
			//$display("                    SPEC-6 FAIL                   ");
            $display("*  The execution latency exceeded 2000 cycles at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask


task reset_task; begin 
    rst_n = 1'b1;
    in_valid = 1'b0;

    T = 'bx;
    in_data = 'bx;
    w_Q = 'bx;
    w_K = 'bx;
    w_V = 'bx;

    total_latency = 0;

    force clk = 0;
    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    in_valid = 1'b0;
    #CYCLE; rst_n = 1'b1;
    
    // Check initial conditions
    if (out_valid !== 1'b0 || out_data !== 1'd0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask


task YOU_PASS_task; begin
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

endmodule
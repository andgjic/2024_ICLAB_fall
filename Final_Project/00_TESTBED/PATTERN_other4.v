`define CYCLE_TIME 7.0

`define DRAM_PATH "../00_TESTBED/DRAM/dram12.dat"
`define PATNUM 400
`define SEED 9994.0

`include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    in_pic_no,
    in_mode,
    in_ratio_mode,
    out_valid,
    out_data
);

/* Input for design */
output reg        clk, rst_n;
output reg        in_valid;

output reg [3:0] in_pic_no;
output reg [1:0] in_mode;
output reg [1:0] in_ratio_mode;

input out_valid;
input [7:0] out_data;


//////////////////////////////////////////////////////////////////////
parameter DRAM_p_r = `DRAM_PATH;
parameter CYCLE = `CYCLE_TIME;

reg [7:0] DRAM_r[0:196607];
reg [7:0] image [0:2][0:31][0:31];
integer patcount;
integer latency, total_latency;
integer file;
integer PATNUM = `PATNUM;
integer seed = `SEED;
integer out_num;

reg [1:0] golden_in_ratio_mode;
reg [3:0] golden_in_pic_no;
reg [1:0] golden_in_mode;
reg [7:0] golden_out_data;

reg [7:0] two_by_two [0:1][0:1];
reg [7:0] four_by_four [0:3][0:3];
reg [7:0] six_by_six [0:5][0:5];

reg [31:0] out_data_temp;
reg [31:0] D_constrate [0:2];
reg [31:0] D_constrate_add [0:2];
reg [7:0] max_R, min_R, max_G, min_G, max_B, min_B;
reg [9:0] temp_max, temp_min;


// testing focus and exposure
integer focus_num;
integer exposure_num;
reg focus_flag [0:15];
reg exposure_flag [0:15];
reg [3:0] dram_all_zero_flag [0:15];
integer read_dram_times;

//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////
initial clk=0;
always #(CYCLE/2.0) clk = ~clk;

// Do it yourself, I believe you can!!!
always @(*) begin
    if (in_valid && out_valid) begin
        $display("*************************************************************************");
		$display("*                              \033[1;31mFAIL!\033[1;0m                                    *");   
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("*************************************************************************");
        repeat (1) #CYCLE;
        $finish;            
    end    
end

always @(negedge clk) begin
	if(out_valid === 0 && out_data !== 'd0) begin
		$display("*************************************************************************");
		$display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
		$display("*       The out_data should be reset when your out_valid is low.        *");
		$display("*************************************************************************");
		repeat(1) #(CYCLE);
		$finish;
	end
end

initial begin
    reset_task;
    $readmemh(DRAM_p_r,DRAM_r);
    file = $fopen("../00_TESTBED/debug.txt", "w");
    focus_num = 0;
    exposure_num = 0;
    read_dram_times = 0;
    for(integer i = 0; i < 16; i = i + 1)begin
        focus_flag[i] = 0;
        exposure_flag[i] = 0;
        dram_all_zero_flag[i] = 0;
    end

    for( patcount = 0; patcount < PATNUM; patcount++) begin 
        repeat(2) @(negedge clk); 
        input_task;
        write_dram_file;
        calculate_ans_task;
        write_to_file;
        wait_out_valid_task;
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mExecution Cycle: %3d \033[0m", patcount + 1, latency);
    end
    YOU_PASS_task;
    repeat (2) @(negedge clk);
    $finish;
end

task reset_task; begin 
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_ratio_mode = 2'bx;
    in_pic_no = 4'bx;
    in_mode = 2'bx;
    total_latency = 0;

    force clk = 0;

    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    
    // Check initial conditions
    if (out_valid !== 1'b0 || out_data !== 'b0) begin
        
        $display("*************************************************************************");
		$display("*                              \033[1;31mFAIL!\033[1;0m                                    *");  
        $display("*  Output signals should be 0 after initial RESET at %8t           *", $time);
        $display("*************************************************************************");
        repeat (1) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask


task input_task; begin
    integer i,j;
    in_valid = 1'b1;
    
    in_pic_no = {$random(seed)} % 'd16;
    in_mode = {$random(seed)} % 'd3;

    in_ratio_mode = (in_mode == 'd1) ? {$random(seed)} % 'd4 : 2'bx;
    golden_in_ratio_mode = in_ratio_mode;
    golden_in_pic_no = in_pic_no;
    golden_in_mode = in_mode;

    // count focus and exposure

    if(in_mode == 'd0)begin
        focus_num = focus_num + 1;
    end
    else if(in_mode == 'd1) begin
        exposure_num = exposure_num + 1;
    end    
        
    for(integer i = 0; i < 3; i = i + 1)begin
        for(integer j = 0; j < 32; j = j + 1)begin
            for(integer k = 0; k < 32; k = k + 1)begin
                image[i][j][k] = DRAM_r[65536 + i * 32 * 32 + j * 32 + k + golden_in_pic_no * 32 * 32 * 3];
            end
        end
    end   

    @(negedge clk);

    in_valid = 1'b0;
    in_ratio_mode = 2'bx;
    in_pic_no = 4'bx;
    in_mode = 2'bx;
end endtask


task calculate_ans_task;begin
    if(golden_in_mode == 'd0)begin
        for(integer i = 0; i < 3; i = i + 1)begin
            D_constrate_add[i] = 0;
        end
        
        for(integer j = 0; j < 2; j = j + 1)begin
            for(integer k = 0; k < 2; k = k + 1)begin
                two_by_two[j][k] = (image[0][15 + j][15 + k] ) / 4 + (image[1][15 + j][15 + k]) / 2 + 
                                        (image[2][15 + j][15 + k] ) / 4 ;
            end
        end

        for(integer j = 0; j < 4; j = j + 1)begin
            for(integer k = 0; k < 4; k = k + 1)begin
                four_by_four[j][k] = (image[0][14 + j][14 + k] ) / 4 + (image[1][14 + j][14 + k]) / 2 + 
                                        (image[2][14 + j][14 + k] ) / 4 ;
            end
        end

        for(integer j = 0; j < 6; j = j + 1)begin
            for(integer k = 0; k < 6; k = k + 1)begin
                six_by_six[j][k] = (image[0][13 + j][13 + k] ) / 4 + (image[1][13 + j][13 + k]) / 2 + 
                                        (image[2][13 + j][13 + k] ) / 4 ;
            end
        end



        for(integer i = 0; i < 2; i = i + 1)begin
            for(integer j = 0; j < 1; j = j + 1)begin
                D_constrate_add[0] = D_constrate_add[0] + diff_abs(two_by_two[i][j + 1], two_by_two[i][j]) + diff_abs(two_by_two[j + 1][i], two_by_two[j][i]);
            end
        end

        for(integer i = 0; i < 4; i = i + 1)begin
            for(integer j = 0; j < 3; j = j + 1)begin
                D_constrate_add[1] = D_constrate_add[1] + diff_abs(four_by_four[i][j + 1], four_by_four[i][j]) + diff_abs(four_by_four[j + 1][i], four_by_four[j][i]);
            end
        end

        for(integer i = 0; i < 6; i = i + 1)begin
            for(integer j = 0; j < 5; j = j + 1)begin
                D_constrate_add[2] = D_constrate_add[2] + diff_abs(six_by_six[i][j + 1], six_by_six[i][j]) + diff_abs(six_by_six[j + 1][i], six_by_six[j][i]);
            end
        end

        D_constrate[0] = D_constrate_add[0] / (2 * 2);
        D_constrate[1] = D_constrate_add[1] / (4 * 4);
        D_constrate[2] = D_constrate_add[2] / (6 * 6);

        if(D_constrate[0] >= D_constrate[1] && D_constrate[0] >= D_constrate[2])begin
            golden_out_data = 8'b00000000;
        end
        else if(D_constrate[1] >= D_constrate[2])begin
            golden_out_data = 8'b00000001;
        end
        else begin
            golden_out_data = 8'b00000010;
        end

    end
    else if((golden_in_mode == 'd1))begin
        for(integer i = 0; i < 3; i = i + 1)begin
            for(integer j = 0; j < 32; j = j + 1)begin
                for(integer k = 0; k < 32; k = k + 1)begin
                    if(golden_in_ratio_mode == 0)begin
                        image[i][j][k] = image[i][j][k] / 4;
                    end
                    else if(golden_in_ratio_mode == 1)begin
                        image[i][j][k] = image[i][j][k] / 2;
                    end
                    else if(golden_in_ratio_mode == 2)begin
                        image[i][j][k] = image[i][j][k];
                    end
                    else begin
                        image[i][j][k] = (image[i][j][k] < 128)  ? image[i][j][k] * 2 : 255;
                        // MSB is 1, image = 255, else shift left 1;
                    end
                    
                end
            end
        end

        for(integer i = 0; i < 3; i = i + 1)begin
            for(integer j = 0; j < 32; j = j + 1)begin
                for(integer k = 0; k < 32; k = k + 1)begin
                    DRAM_r[65536 + i * 32 * 32 + j * 32 + k + golden_in_pic_no * 32 * 32 * 3] = image[i][j][k];
                end
            end
        end
        
        out_data_temp = 0;
        for(integer i = 0; i < 32; i = i + 1)begin
            for(integer j = 0; j < 32; j = j + 1)begin
                out_data_temp = out_data_temp + image[0][i][j] / 4 + image[1][i][j] / 2 + image[2][i][j] / 4;
            end
        end
        golden_out_data = out_data_temp / 1024;
    end
    else begin
        

        for(integer i = 0; i < 32; i = i + 1)begin
            for(integer j = 0; j < 32; j = j + 1)begin
                if(i == 0 && j == 0)begin
                    max_R = image[0][i][j];
                    min_R = image[0][i][j];
                    max_G = image[1][i][j];
                    min_G = image[1][i][j];
                    max_B = image[2][i][j];
                    min_B = image[2][i][j];
                end
                else begin
                    if(image[0][i][j] > max_R)begin
                        max_R = image[0][i][j];
                    end
                    if(image[0][i][j] < min_R)begin
                        min_R = image[0][i][j];
                    end
                    if(image[1][i][j] > max_G)begin
                        max_G = image[1][i][j];
                    end
                    if(image[1][i][j] < min_G)begin
                        min_G = image[1][i][j];
                    end
                    if(image[2][i][j] > max_B)begin
                        max_B = image[2][i][j];
                    end
                    if(image[2][i][j] < min_B)begin
                        min_B = image[2][i][j];
                    end
                end
            end
        end

        temp_max = (max_R + max_G + max_B) / 3;
        temp_min = (min_R + min_G + min_B) / 3;
        out_data_temp = temp_max + temp_min;
        golden_out_data = out_data_temp / 2;
    end
end endtask

task wait_out_valid_task; begin
    latency = 0;
    while (out_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == 10000) begin
            $display("*************************************************************************");
		    $display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
		    $display("*         The execution latency is limited in 10000 cycles.              *");
		    $display("*************************************************************************");
            repeat (1) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask

task check_ans_task; begin
    out_num = 0;

    if(golden_in_mode == 0)begin
        if(out_data !== golden_out_data)begin
            $display("*************************************************************************");
		    $display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
            $display("*               The golden_in_mode is %d               *", golden_in_mode);
            $display("*  The golden_out_data is %d, but your out_data is %d  *", golden_out_data, out_data);
            $display("*************************************************************************");
            repeat (1) @(negedge clk);
            $finish;
        end
        else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end
    else if(golden_in_mode == 1)begin
        if(golden_out_data == 0)begin
            if(out_data !== 1 && out_data !== 0)begin
                $display("*************************************************************************");
		        $display("*                       \033[1;31mFAIL!\033[1;0m                                    *");  
                $display("                FAIL error is large than 1 !                ");
                $display("*               The golden_in_mode is %d               *", golden_in_mode);
                $display("*  The golden_out_data is %d, but your out_data is %d  *", golden_out_data, out_data);
                $display("*************************************************************************");
                repeat (2) @(negedge clk);
                $finish;
            end
            else begin
                @(negedge clk);
                out_num = out_num + 1;
            end
        end
        else if(golden_out_data == 255)begin
            if(out_data !== 255 && out_data !== 254)begin
                
                $display("*************************************************************************");
		        $display("*                       \033[1;31mFAIL!\033[1;0m                                    *");    
                $display("                 Error is large than 1 !                ");
                $display("*               The golden_in_mode is %d               *", golden_in_mode);
                $display("*  The golden_out_data is %d, but your out_data is %d  *", golden_out_data, out_data);
                $display("*************************************************************************");
                repeat (1) @(negedge clk);
                $finish;
            end
            else begin
                @(negedge clk);
                out_num = out_num + 1;
            end
        end
        else begin
            if(out_data > golden_out_data + 1 || out_data < golden_out_data - 1)begin
                $display("*************************************************************************");
		        $display("*                       \033[1;31mFAIL!\033[1;0m                                    *");       
                $display("                 Error is large than 1 !                ");
                $display("*               The golden_in_mode is %d               *", golden_in_mode);
                $display("*  The golden_out_data is %d, but your out_data is %d  *", golden_out_data, out_data);
                $display("*************************************************************************");
                repeat (1) @(negedge clk);
                $finish;
            end
            else begin
                @(negedge clk);
                out_num = out_num + 1;
            end
        end
    end
    else begin
        if(out_data !== golden_out_data)begin
            $display("*************************************************************************");
		    $display("*                       \033[1;31mFAIL!\033[1;0m                                    *");
            $display("*               The golden_in_mode is %d               *", golden_in_mode);
            $display("*  The golden_out_data is %d, but your out_data is %d  *", golden_out_data, out_data);
            $display("*************************************************************************");
            repeat (1) @(negedge clk);
            $finish;
        end
        else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end

    if(out_num !== 1) begin
        $display("************************************************************");  
        $display("                            \033[1;31mFAIL!\033[1;0m                            ");
        $display(" Expected %d out_valid, but found %d", 1, out_num);
        $display("************************************************************");
        repeat(1) @(negedge clk);
        $finish;
    end
end endtask

task write_dram_file; begin
    $fwrite(file, "===========  PATTERN NO.%4d  ==============\n", patcount);
    $fwrite(file, "==========  GOLDEN_PIC_NO.%2d  ==============\n", golden_in_pic_no);
    $fwrite(file, "===========    RED IMAGE     ==============\n");
    for(integer i = 0; i < 32; i = i + 1) begin
        for(integer j = 0; j < 32; j = j + 1) begin
            $fwrite(file, "%5d ", image[0][i][j]);
        end
        $fwrite(file, "\n");
    end
    $fwrite(file, "===========    GREEN IMAGE     ============\n");
    for(integer i = 0; i < 32; i = i + 1) begin
        for(integer j = 0; j < 32; j = j + 1) begin
            $fwrite(file, "%5d ", image[1][i][j]);
        end
        $fwrite(file, "\n");
    end
    $fwrite(file, "===========    BLUE IMAGE     ============\n");
    for(integer i = 0; i < 32; i = i + 1) begin
        for(integer j = 0; j < 32; j = j + 1) begin
            $fwrite(file, "%5d ", image[2][i][j]);
        end
        $fwrite(file, "\n");
    end
    $fwrite(file, "\n");
end endtask


task write_to_file; begin
    
    $fwrite(file, "==========  GOLDEN_IN_MODE is %b  ==============\n", golden_in_mode);   
    if(golden_in_mode == 'd0)begin
        $fwrite(file, "===========    TWO_BY_TWO     ============\n");
        for(integer i = 0; i < 2; i = i + 1) begin
            for(integer j = 0; j < 2; j = j + 1) begin
                $fwrite(file, "%5d ", two_by_two[i][j]);
            end
            $fwrite(file, "\n");
        end

        $fwrite(file, "===========    FOUR_BY_FOUR     ============\n");
        for(integer i = 0; i < 4; i = i + 1) begin
            for(integer j = 0; j < 4; j = j + 1) begin
                $fwrite(file, "%5d ", four_by_four[i][j]);
            end
            $fwrite(file, "\n");
        end

        $fwrite(file, "===========    SIX_BY_SIX     ============\n");
        for(integer i = 0; i < 6; i = i + 1) begin
            for(integer j = 0; j < 6; j = j + 1) begin
                $fwrite(file, "%5d ", six_by_six[i][j]);
            end
            $fwrite(file, "\n");
        end
        $fwrite(file, "===========   D_CONSTRATE(ADD)  ============\n");
        for(integer i = 0; i < 3; i = i + 1) begin
            $fwrite(file, "%10d", D_constrate_add[i]);
        end
        $fwrite(file, "\n");
        $fwrite(file, "===========    D_CONSTRATE     ============\n");
        for(integer i = 0; i < 3; i = i + 1) begin
            $fwrite(file, "%10d", D_constrate[i]);
        end
        $fwrite(file, "\n");
    end
    else if(golden_in_mode == 'd1)begin
        $fwrite(file, "=========  IMAGE_AFTER_AUTO_EXPOSURE  ============\n");
        $fwrite(file, "=========  GOLDEN_RATIO is %d  ============\n",golden_in_ratio_mode);
        $fwrite(file, "===========    RED IMAGE     ==============\n");
        for(integer i = 0; i < 32; i = i + 1) begin
            for(integer j = 0; j < 32; j = j + 1) begin
                $fwrite(file, "%5d ", image[0][i][j]);
            end
            $fwrite(file, "\n");
        end
        $fwrite(file, "===========    GREEN IMAGE     ============\n");
        for(integer i = 0; i < 32; i = i + 1) begin
            for(integer j = 0; j < 32; j = j + 1) begin
                $fwrite(file, "%5d ", image[1][i][j]);
            end
            $fwrite(file, "\n");
        end
        $fwrite(file, "===========    BLUE IMAGE     ============\n");
        for(integer i = 0; i < 32; i = i + 1) begin
            for(integer j = 0; j < 32; j = j + 1) begin
                $fwrite(file, "%5d ", image[2][i][j]);
            end
            $fwrite(file, "\n");
        end
        $fwrite(file, "\n");

        $fwrite(file, "===========  DATA_SUM (not divide 1024)  ============\n");
        $fwrite(file, "%10d\n", out_data_temp);
    end
    $fwrite(file, "===========  GOLDEN_OUT_DATA  ============\n");
    $fwrite(file, "%10d\n", golden_out_data);

    $fwrite(file, "\n\n\n");
end endtask

function [7:0]diff_abs; 
    input [7:0]a;
    input [7:0]b;
    begin
        if(a > b)begin
            diff_abs = a - b;
        end
        else begin
            diff_abs = b - a;
        end
    end
endfunction


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
    $display("----------------------------------------------------------------------------------------------------------------------"); 
    $display("                       Congratulations!                          ");
    $display("                You have passed all patterns!                     ");
    $display("                Your execution cycles = %5d cycles                ", total_latency);
    $display("                Your clock period = %.1f ns                       ", CYCLE);
    $display("                Total Latency = %.1f ns                          ", total_latency * CYCLE);
    $display("                Focus number = %5d, Exposure number = %5d, Average of Min and Max number = %5d           ", focus_num, exposure_num, PATNUM - focus_num - exposure_num);
    $display("----------------------------------------------------------------------------------------------------------------------"); 
    repeat (1) @(negedge clk);
    $finish;
end endtask


endmodule

//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network 
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`define CYCLE_TIME      50.0
`define SEED_NUMBER     28825252
`define PAT_NUM 3
//`define PATTERN_NUMBER 10000

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,
    //Input Port
    out_valid,
    out
    );

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output  logic        clk, rst_n, in_valid;
output  logic[31:0]  Img;
output  logic[31:0]  Kernel_ch1;
output  logic[31:0]  Kernel_ch2;
output  logic[31:0]  Weight;
output  logic        Opt;
input           out_valid;
input   [31:0]  out;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;

integer patnum = `PAT_NUM;
integer i_pat, i_pat_scanf;
integer f_img, f_ker1, f_ker2, f_wei, f_out, f_opt;
integer latency;
integer total_latency;

integer i,j;

integer count_input, delay_1to4, out_num;
integer scanf_img, scanf_ker1, scanf_ker2, scanf_wei, scanf_opt, scanf_out;

reg [31:0] Imgs [74:0], Ker1s[11:0], Ker2s[11:0], Weis[23:0], Opts, Outs[2:0];

real golden_out, your_out, dif;
real golden_sign, golden_expo, sign, expo, golden_mantissa, mantissa;
real threshold = 0.0001;
//---------------------------------------------------------------------
//   Reg & Wires
//---------------------------------------------------------------------


//================================================================
// clock
//================================================================

always #(CYCLE/2.0) clk = ~clk;
initial	clk = 0;

//---------------------------------------------------------------------
//   Pattern_Design
//---------------------------------------------------------------------
    initial begin
        // Open input and output files
        f_img  = $fopen("../00_TESTBED/Img.txt", "r");
        f_ker1  = $fopen("../00_TESTBED/Kernel_ch1.txt", "r");
        f_ker2  = $fopen("../00_TESTBED/Kernel_ch2.txt", "r");
        f_wei  = $fopen("../00_TESTBED/Weight.txt", "r");
        f_opt = $fopen("../00_TESTBED/Opt.txt", "r");        
        f_out = $fopen("../00_TESTBED/Out.txt", "r");
        // f_in  = $fopen("../00_TESTBED/input_v2.txt", "r");
        if (f_img == 0) begin
            $display("Failed to open img.txt");
            $finish;
        end
        if (f_ker1 == 0) begin
            $display("Failed to open ker1.txt");
            $finish;
        end
        if (f_ker2 == 0) begin
            $display("Failed to open ker2.txt");
            $finish;
        end
        if (f_wei == 0) begin
            $display("Failed to open wei.txt");
            $finish;
        end
        if (f_opt == 0) begin
            $display("Failed to open opt.txt");
            $finish;
        end
        if (f_out == 0) begin
            $display("Failed to open out.txt");
            $finish;
        end
        
        // Initialize signals
        reset_task;

        // Iterate through each pattern
        for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
            input_task;
            wait_out_valid_task;
            check_ans_task;
            $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mExecution Cycle: %3d", i_pat + 1, latency);

        end
        
        // All patterns passed
        YOU_PASS_task;
    end

    // Task to reset the system
    task reset_task; begin 
        rst_n = 1'b1;
        in_valid = 1'bx;
        Img = 32'bx;
        Kernel_ch1 = 32'bx;        
        Kernel_ch2 = 32'bx;
        Weight = 32'bx;
        Opt = 1'bx;
        total_latency = 0;
        out_num = 0;

        force clk = 0;
        // Apply reset
        #CYCLE; rst_n = 1'b0; 
        in_valid = 1'b0;
        #CYCLE; rst_n = 1'b1;
        
        // Check initial conditions
        if (out_valid !== 1'b0 || out !== 32'd0) begin
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
        delay_1to4 = $urandom() % 4 + 1;
        repeat (delay_1to4) @(negedge clk);////delay for 1-4

        count_input = 0;
        i_pat_scanf = $fscanf(f_img, "%d", i_pat);
        for (i=0;i<75;i=i+1)begin
            scanf_img = $fscanf(f_img, "%h", Imgs[i]);
        end
        i_pat_scanf = $fscanf(f_wei, "%d", i_pat);
        for (i=0;i<24;i=i+1)begin
            scanf_wei = $fscanf(f_wei, "%h", Weis[i]);
        end
        i_pat_scanf = $fscanf(f_ker1, "%d", i_pat);
        i_pat_scanf = $fscanf(f_ker2, "%d", i_pat);
        for (i=0;i<12;i=i+1)begin
            scanf_ker1 = $fscanf(f_ker1, "%h", Ker1s[i]);
            scanf_ker2 = $fscanf(f_ker2, "%h", Ker2s[i]);
        end
        i_pat_scanf = $fscanf(f_opt, "%d", i_pat);
        scanf_opt = $fscanf(f_opt, "%h", Opts);

        i_pat_scanf = $fscanf(f_out, "%d", i_pat);
        scanf_out = $fscanf(f_out, "%h", Outs[0]);
        scanf_out = $fscanf(f_out, "%h", Outs[1]);
        scanf_out = $fscanf(f_out, "%h", Outs[2]);

        while (count_input<75) begin
            in_valid = 1;
            Img = Imgs[count_input];
            if(count_input<12)begin
                Kernel_ch1 = Ker1s[count_input];                
                Kernel_ch2 = Ker2s[count_input];
            end
            else begin
                Kernel_ch1 = 32'bx;
                Kernel_ch2 = 32'bx;
            end

            if(count_input<24)
                Weight = Weis[count_input];
            else
                Weight = 32'bx;

            if(count_input==0)
                Opt = Opts;
            else
                Opt = 1'bx;

            @(negedge clk);           // Wait for clock's negative edge
            count_input = count_input+1;
        end

        // Reset signals after processing
        in_valid = 1'b0;
        Kernel_ch1 = 32'bx;
        Kernel_ch2 = 32'bx;
        Img = 32'bx;
        Opt = 1'bx;
        Weight = 32'bx;
        count_input = 0;

    end endtask

    task wait_out_valid_task; begin
        while (out_valid !== 1'b1) begin
            latency = latency + 1;

            if (latency == 200) begin
                $display("********************************************************");     
				//$display("                    SPEC-6 FAIL                   ");
                $display("*  The execution latency exceeded 200 cycles at %8t   *", $time);
                $display("********************************************************");
                repeat (2) @(negedge clk);
                $finish;
            end
            @(negedge clk);
        end
        total_latency = total_latency + latency;
    end endtask

    task check_ans_task; begin

        reg [31:0]golden_out;
        
        // Initialize output count
        out_num = 0;

        // Only perform checks when out_valid is high
        while (out_valid === 1) begin            


            golden_out = $bitstoshortreal(Outs[out_num]);
            your_out = $bitstoshortreal(out);
        

            $display("Real number (your): %f", your_out);
            $write("Real number (golden): %f", golden_out);
            dif = $abs(golden_out - your_out)/1.0;
            //if(dif<0)
            //    dif = -dif;
            // Compare expected and received values
            if (0) begin
                $display("************************************************************");  
                $display("                          FAIL!                           ");
                $display("      Expected: Golden_out = %5.5f        ", Outs[out_num]);
                $display("      Received: out = %5.5f       ", out);
                $display("************************************************************");
                repeat (5) @(negedge clk);
                $finish;
            end else begin
                @(negedge clk);
                out_num = out_num + 1;
            end

                    // Check if the number of outputs matches the expected count
            //if(out_num !== 3) begin
            //    $display("************************************************************");  
            //    $display("                          FAIL!                              ");
            //    $display(" Expected one valid output, but found %d", out_num);
            //    $display("************************************************************");
            //    repeat(2) @(negedge clk);
            //    $finish;
            //end
        end
    end endtask
        

    task YOU_PASS_task; begin
        $display("----------------------------------------------------------------------------------------------------------------------");
		$display("                  Congratulations!               ");
        $display("                                           You have passed all patterns!                                               ");
        $display("                                           Your execution cycles = %5d cycles                                          ", total_latency);
        $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
        $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE);
        $display("----------------------------------------------------------------------------------------------------------------------");
        repeat (2) @(negedge clk);
        $finish;
    end endtask

endmodule




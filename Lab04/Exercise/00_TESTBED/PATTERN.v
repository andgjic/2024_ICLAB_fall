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

`define CYCLE_TIME 25.9
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER 10000

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

//---------------------------------------------------------------------
//   Reg & Wires
//---------------------------------------------------------------------
integer i,j;


//================================================================
// clock
//================================================================

always #(CYCLE/2.0) clk = ~clk;

//---------------------------------------------------------------------
//   Pattern_Design
//---------------------------------------------------------------------
initial
begin

    reset_task;
    input_task;
    for(i=0;i<80;i=i+1)
        @(negedge clk);
    $finish;
end

// input task
task input_task;
    begin
        @(negedge clk);
        in_valid = 1'b1;
        Opt = 1'b1;

        for (j=0;j<3;j=j+1)
        begin
            for(i=0; i<25; i=i+1)
            begin
                if(i<5)
                    Img = i%5 + 1;
                else if(i<10)
                    Img = i%5 + 2;
                else if(i<15)
                    Img = i%5 + 3;
                else if(i<20)
                    Img = i%5 + 4;
                else if(i<25)
                    Img = i%5 + 5;


                if(i<12 && j==0)
                begin
                    if(i<4)
                    begin
                        Kernel_ch1 = i%2 + 1;
                        Kernel_ch2 = i%2 + 4;
                    end
                    else if(i<8)
                    begin
                        Kernel_ch1 = i%2 + 2;
                        Kernel_ch2 = i%2 + 5;
                    end
                    else if(i<12)
                    begin
                        Kernel_ch1 = i%2 + 3;
                        Kernel_ch2 = i%2 + 6;
                    end
                end
                else
                begin
                    Kernel_ch1 = 32'bx;
                    Kernel_ch2 = 32'bx;
                end

                // Weight
                if(i<8 && j==0)
                    Weight = i%8 + 1;
                else if(i<16 && j==0)
                    Weight = i%8 + 2;
                else if(i<25 && j==0)
                    Weight = i%8 + 3;
 

                @(negedge clk);
                Opt = 1'bx;

                // $display("----- Input No.%2d -----", i+1);
                // $display("Image = %2d      ", Img);
                // $display("Kernel_ch1 = %2d     ", Kernel_ch1);
                // $display("Kernel_ch1 = %2d     ", Kernel_ch2);
            end
            Weight = 32'bx;

        end





        // Reset signals after processing
        in_valid = 1'b0;


    end
endtask


// reset task (SPEC-4)
task reset_task;
    begin
        rst_n = 1'b1;
        in_valid = 1'b0;
        Opt = 1'bx;
        Img = 32'bx;
        Kernel_ch1 = 32'bx;
        Kernel_ch2 = 32'bx;
        Weight = 32'bx;

        force clk = 0;

        // Apply reset
        #CYCLE;
        rst_n = 1'b0;
        #CYCLE;
        rst_n = 1'b1;

        release clk;

        repeat (2) @(negedge clk);
    end
endtask





endmodule

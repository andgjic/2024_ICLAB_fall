`define CYCLE_TIME 5.9
`define PAT_NUM 3

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

// ========================================
// clock
// ========================================
real CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk; //clock
// ========================================
// Input & Output
// ========================================
output reg        clk, rst_n;
output reg        in_valid;

output reg [3:0] in_pic_no;
output reg       in_mode;
output reg [1:0] in_ratio_mode;

input out_valid;
input [7:0] out_data;

// ========================================
// Integer
// ========================================
integer i,j,k;

integer patnum = `PAT_NUM;
integer i_pat;
integer latency;
integer total_latency;
integer delay_1to4;

// ==================================================
//                      Initial
// ==================================================
initial begin
    // Initialize signals
    reset_task;

    // Iterate through each pattern
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1)  
    begin
        input_task;
        wait_out_valid_task;
    end

    $finish;
end 


// ==================================================
//                      Tasks
// ==================================================

// >>>>>>>> input task <<<<<<<<
task input_task; begin
    // create delay
	delay_1to4 = $urandom() % 4 + 1;		
    repeat (delay_1to4) @(negedge clk);////delay for 1-4

    // Start to input
    in_valid = 1;

    in_pic_no = $urandom() % 15 + 1;
    // $display("in_pic_no = %d",in_pic_no);
    // in_pic_no = 2;        

    in_ratio_mode = $urandom() % 4 + 1;
    // in_ratio_mode = 3;
    in_mode = $urandom() % 2;
    // in_mode = 0;
    @(negedge clk);   

    // Input finished
    in_valid = 0;
    in_pic_no = 'bx;
    in_mode = 'bx;
    in_ratio_mode = 'bx;

end endtask

// >>>>>>>> wait out_valid task <<<<<<<<
task wait_out_valid_task; begin
	latency = 0;
	while(out_valid !== 1'b1)begin
        latency = latency + 1;
        if (latency == 1000) begin
            $display("********************************************************");     
            $display("*  The execution latency exceeded 2000 cycles at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask

// >>>>>>>> reset task <<<<<<<<
task reset_task; begin 
    rst_n       = 1'b1;
    in_valid    = 1'b0;
    total_latency = 0;

    // input before reset
    in_mode = 'bx;
    in_pic_no = 'bx;

    force clk = 0;
    // Apply reset
    #CYCLE; rst_n = 1'b0; 
    #CYCLE; rst_n = 1'b1;
    
    // Check initial conditions
    if (out_valid !== 1'b0 || out_data !== 'd0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask




// >>>>>>>> Pass task <<<<<<<<
// task YOU_PASS_task; begin
// $display("----------------------------------------------------------------------------------------------------------------------");
// $display("                  Congratulations!               ");
// $display("                                           You have passed all patterns!                                               ");
// $display("                                           Your execution cycles = %5d cycles                                          ", total_latency);
// $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
// $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE);
// $display("----------------------------------------------------------------------------------------------------------------------");
// repeat (2) @(negedge clk);
// $finish;
// end endtask

// ==================================================
//                      Others
// ==================================================
/* Check for invalid overlap */
always @(*) begin
    if (in_valid && out_valid) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  The out_valid signal cannot overlap with in_valid.   *");
        $display("************************************************************");
        repeat (5) #CYCLE;
        $finish;            
    end    
end
endmodule

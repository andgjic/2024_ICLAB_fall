`ifdef RTL
    `define CYCLE_TIME 8.2
`endif
`ifdef GATE
    `define CYCLE_TIME 8.2
`endif


`define PAT_NUM 5
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

// ========================================
// clock
// ========================================
real CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk; //clock
// ========================================
// Input & Output
// ========================================
output reg clk, rst_n, in_valid;
output reg [8:0] in_mode;
output reg [14:0] in_data;

input out_valid;
input [206:0] out_data;


integer i,j,k;

integer patnum = `PAT_NUM;
integer i_pat;
integer latency;
integer total_latency;

integer count_input, delay_2to4, out_num, delay_1to4;
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

task input_task; begin
	delay_1to4 = $urandom() % 4 + 1;		
    repeat (delay_1to4) @(negedge clk);////delay for 1-4

    in_valid = 1;
    for(i=0;i<16;i=i+1)
    begin
        in_data = $urandom() % 9 + 1;
        @(negedge clk);   
    end
    in_valid = 0;
    in_data = 15'bx;

end endtask

task reset_task; begin 
    rst_n = 1'b1;
    in_valid = 1'bx;

    in_mode = 9'bx;
    in_data = 15'bx;
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

endmodule
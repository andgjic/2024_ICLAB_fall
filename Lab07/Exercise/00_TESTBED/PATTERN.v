// `ifdef RTL
// 	`define CYCLE_TIME_clk1 47.1
// 	`define CYCLE_TIME_clk2 10.1
// `endif
// `ifdef GATE
// 	`define CYCLE_TIME_clk1 47.1
// 	`define CYCLE_TIME_clk2 10.1
// `endif

// slow -> fast
// `define CYCLE_TIME_clk1 47.1
// `define CYCLE_TIME_clk2 10.1

// fast -> slow
`define CYCLE_TIME_clk1 4.1
`define CYCLE_TIME_clk2 10.1

`define PAT_NUM 1

module PATTERN(
	clk1,
	clk2,
	rst_n,
	in_valid,
	in_row,
	in_kernel,
	out_valid,
	out_data
);

output reg clk1, clk2;
output reg rst_n;
output reg in_valid;
output reg [17:0] in_row;
output reg [11:0] in_kernel;

input out_valid;
input [7:0] out_data;

//================================================================
// clock
//================================================================
real CYCLE_clk1 = `CYCLE_TIME_clk1;
real CYCLE_clk2 = `CYCLE_TIME_clk2;
always	#(CYCLE_clk1/2.0) clk1 = ~clk1;
always	#(CYCLE_clk2/2.0) clk2 = ~clk2;

//================================================================
// parameters & integer
//================================================================
integer i,j,k;

integer patnum = `PAT_NUM;
integer i_pat;
integer latency;
integer total_latency;
integer delay_1to4;

integer row_value;
integer kernel_value;

//================================================================
// wire & registers 
//================================================================



//================================================================
// initial
//================================================================
initial begin
    // Initialize signals
    reset_task;

    // Iterate through each pattern
    for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1)  
    begin
        input_task;
        wait_out_valid_task;
    end
    for(i=0;i<1000;i=i+1)
		@(negedge clk1);
    $finish;
end 

//================================================================
// task
//================================================================
// >>>>>>>> input task <<<<<<<<
task input_task; begin
    // create delay
	delay_1to4 = $urandom() % 4 + 1;		
    repeat (delay_1to4) @(negedge clk1);////delay for 1-4


	// Start to input
	in_valid = 1;
	for (i=0;i<6;i=i+1)
	begin
		in_row    = {3'd6, 3'd5, 3'd4, 3'd3, 3'd2, 3'd1};
		in_kernel = {3'd4, 3'd3, 3'd2, 3'd1};
		// in_row    = {$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1};
		// in_kernel = {$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1,$urandom() % 7 + 1}; 
    	@(negedge clk1);   
	end
    
    // Input finished
    in_valid = 0;
    in_row = 'bx;
    in_kernel = 'bx;

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
            repeat (2) @(negedge clk1);
            $finish;
        end
        @(negedge clk1);
    end
    total_latency = total_latency + latency;
end endtask

// >>>>>>>> reset task <<<<<<<<
task reset_task; begin 
    rst_n       = 1'b1;
    in_valid    = 1'b0;
    total_latency = 0;

    // input before reset
    in_row = 'bx;
    in_kernel = 'bx;

    force clk1 = 0;
    force clk2 = 0;
    // Apply reset
    #CYCLE_clk1; rst_n = 1'b0; 
    #CYCLE_clk1; rst_n = 1'b1;
    
    // Check initial conditions
    if (out_valid !== 1'b0 || out_data !== 'd0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE_clk1;
        $finish;
    end
    #CYCLE_clk1; release clk1; release clk2;
end endtask

endmodule
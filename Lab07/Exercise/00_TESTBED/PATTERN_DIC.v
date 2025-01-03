`ifdef RTL
	`define CYCLE_TIME_clk1 4.1 
	`define CYCLE_TIME_clk2 10.1
`endif
`ifdef GATE
	`define CYCLE_TIME_clk1 47.1
	`define CYCLE_TIME_clk2 10.1
`endif

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
// parameters & integer
//================================================================
integer i,j, k,i_pat, i_answer;
integer latency, total_latency;
integer total_pattern = 1000;
integer SEED = 9527;
integer out_num;

//================================================================
// wire & registers 
//================================================================
reg [2:0] matrix [0:5][0:5];
reg [2:0] kernel [0:5][0:1][0:1];
reg [7:0] golden_ans[0:5][0:4][0:4];

//================================================================
// clock
//================================================================
real CYCLE_clk1 = `CYCLE_TIME_clk1;
real CYCLE_clk2 = `CYCLE_TIME_clk2;

always	#(CYCLE_clk1/2.0) clk1 = ~clk1;
initial	clk1 = 0;
always	#(CYCLE_clk2/2.0) clk2 = ~clk2;
initial	clk2 = 0;

//================================================================
// initial
//================================================================
initial begin
	//reset signal
	reset_task; 
    repeat (4) @(negedge clk1);

	total_latency = 0;

	for (i_pat = 0; i_pat < total_pattern; i_pat = i_pat + 1) begin
		repeat({$random(SEED)} % 3 + 1)@(negedge clk1);
        input_task;
        latency = 0;
		for(i_answer = 0; i_answer < 150; i_answer = i_answer + 1) begin
			wait_out_valid_task;
        	check_ans_task;
		end
		total_latency = total_latency + latency;
        $display("\033[1;34mPASS PATTERN \033[1;32mNO.%4d  Cycles = %4d\033[m", i_pat,latency);
    end

	YOU_PASS_task;

end

//================================================================
// task
//================================================================
always @(negedge clk1) begin
	if(out_valid === 0 && out_data !== 'd0) begin
		$display("*************************************************************************");
		$display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
		$display("*       The out_data should be reset when your out_valid is low.        *");
		$display("*************************************************************************");
		repeat(1) #(CYCLE_clk1);
		$finish;
	end
end

task reset_task; begin
	rst_n = 1'b1;
	in_valid = 1'b0;
	in_row = 'bx;
	in_kernel = 'bx;

	force clk1 = 0;
	force clk2 = 0;

	// Apply reset
    #CYCLE_clk1; rst_n = 1'b0; 
    repeat(2) #(CYCLE_clk1); rst_n = 1'b1;

	// Check initial conditions
    if (out_valid !== 'd0 || out_data !== 'd0) begin
        $display("************************************************************");  
        $display("                           \033[1;31mFAIL!\033[1;0m                             ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (1) #CYCLE_clk1;
        $finish;
    end

	#CYCLE_clk1; release clk1; 
	#0 release clk2;
	
end endtask

task input_task; begin
    random_input;

    in_valid = 1;

	for(i = 0; i < 6; i = i + 1)begin
		in_row = {matrix[i][5], matrix[i][4], matrix[i][3], matrix[i][2], matrix[i][1], matrix[i][0]};
		in_kernel = {kernel[i][1][1], kernel[i][1][0], kernel[i][0][1], kernel[i][0][0]};
		@(negedge clk1);
		if(out_valid !== 0 || out_data !== 'd0) begin
			$display("*************************************************************************");
			$display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
			$display("*       Output signal out_valid and out_data should be zero when in_valid is high.        *");
			$display("*************************************************************************");
			repeat(1) #(CYCLE_clk1);
			$finish;
		end
    end

    in_valid = 0;
	in_row = 'bx;
	in_kernel = 'bx;

    cal_ans;
end
endtask

task wait_out_valid_task; begin
	while (out_valid !== 1'b1) begin
		latency = latency + 1;
		if(latency == 5000)begin
            $display("*************************************************************************");
		    $display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
		    $display("*         The execution latency is limited in 5000 cycles.              *");
		    $display("*************************************************************************");
		    repeat(1) @(negedge clk1);
		    $finish;
        end
		@(negedge clk1);
	end
end
endtask

task check_ans_task; begin 
    if(out_valid === 1) begin
	    if (out_data !== golden_ans[i_answer/25][(i_answer%25)/5][(i_answer%5)]) begin

            $display("************************************************************");  
            $display("                          \033[1;31mFAIL!\033[1;0m                              ");
			$display(" NO. data = %d", i_answer);
            $display(" Expected: data = %d", golden_ans[i_answer/25][(i_answer%25)/5][(i_answer%5)]);
            $display(" Received: data = %d", out_data);
            $display("************************************************************");
            repeat (1) @(negedge clk1);
            $finish;
        end
        else begin
			latency = latency + 1;
            @(negedge clk1);
        end
    end

    /* if(out_num !== 1) begin
            $display("************************************************************");  
            $display("                            \033[1;31mFAIL!\033[1;0m                            ");
            $display(" Expected one out_valid, but found %d", out_num);
            $display("************************************************************");
            repeat(2) @(negedge clk1);
            $finish;
    end */

end endtask

task random_input; 
    integer idx,idy,idz;
begin
    for(idy = 0; idy < 6; idy = idy + 1) begin
        for(idx = 0; idx < 6; idx = idx + 1)begin
            matrix[idy][idx] = {$random(SEED)} % 7;
        end
    end
	for (idz = 0; idz < 6; idz = idz + 1) begin
		for(idy = 0; idy < 2; idy = idy + 1) begin
        	for(idx = 0; idx < 2; idx = idx + 1)begin
        	    kernel[idz][idy][idx] = {$random(SEED)} % 7;
        	end
    	end
	end
	
end
endtask

task cal_ans; 
begin
	for (i = 0; i < 6; i = i + 1) begin
		for (j = 0; j < 5; j = j + 1) begin
			for (k = 0; k < 5; k = k + 1) begin
				golden_ans[i][j][k] = matrix[j][k] * kernel[i][0][0] + matrix[j][k + 1] * kernel[i][0][1] + matrix[j + 1][k] * kernel[i][1][0] + matrix[j + 1][k + 1] * kernel[i][1][1];
			end
		end
	end
end
endtask

task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  \033[0;32mCongratulations!\033[m                                                     ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your execution cycles = %7d cycles                                          ", total_latency);
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE_clk1);
    $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE_clk1);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk1);
    $finish;
end endtask


endmodule
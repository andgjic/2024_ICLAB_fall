`ifdef RTL
    `define CYCLE_TIME 8.2
`endif
`ifdef GATE
    `define CYCLE_TIME 8.2
`endif

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
// Input & Output
// ========================================
output reg clk, rst_n, in_valid;
output reg [8:0] in_mode;
output reg [14:0] in_data;

input out_valid;
input [206:0] out_data;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer i,j, i_pat;
integer total_latency, latency;
integer total_pattern = 5000;
integer SEED = 9527;
integer out_num;

//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg error_data_or_not;
reg signed [10:0] correct_data[0:15];
reg [3:0] error_data_idx;
reg [3:0] encoding_data[0:11];
reg [3:0] a[0:15];

reg error_mode_or_not;
reg [4:0] correct_mode;
reg [3:0] error_mode_idx;
reg [3:0] encoding_mode[0:9];
reg [3:0] b[0:15];

reg [1:0] mode;
reg [206:0] correct_answer;
//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------
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
	//reset signal
	reset_task; 
    repeat (4) @(negedge clk);
	i_pat = 0;
	total_latency = 0;

	for (i_pat = 0; i_pat < total_pattern; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
		total_latency = total_latency + latency;
        $display("\033[1;34mPASS PATTERN \033[1;32mNO.%4d  Cycles = %4d\033[m", i_pat,latency);
    end

	YOU_PASS_task;

end

task reset_task; begin
	rst_n = 1'b1;
	in_valid = 1'b0;
	in_mode = 'bx;
	in_data = 'bx;

	force clk = 0;

	// Apply reset
    #CYCLE; rst_n = 1'b0; 
    repeat(1) #(CYCLE); rst_n = 1'b1;

	// Check initial conditions
    if (out_valid !== 'd0 || out_data !== 'd0) begin
        $display("************************************************************");  
        $display("                           \033[1;31mFAIL!\033[1;0m                             ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (1) #CYCLE;
        $finish;
    end

	#CYCLE; release clk;
end endtask

task input_task; begin
    random_input;

    in_valid = 1;
    in_mode = encode_mode();
	in_data = encode_data(0);
    @(negedge clk)
    in_mode = 'dx;

    for(i = 1; i < 16; i = i + 1)begin
        in_data = encode_data(i);
        @(negedge clk);
    end
    in_valid = 0;
	in_data = 'dx;

    cal_ans;
end
endtask

task wait_out_valid_task; begin
	latency = 0;
	while (out_valid !== 1'b1) begin
		latency = latency + 1;
		if(latency == 1000)begin
            $display("*************************************************************************");
		    $display("*                              \033[1;31mFAIL!\033[1;0m                                    *");
		    $display("*         The execution latency is limited in 1000 cycles.              *");
		    $display("*************************************************************************");
		    repeat(1) @(negedge clk);
		    $finish;
        end

		@(negedge clk);
	end
	
end
endtask

task check_ans_task; begin 
    out_num = 0;
    while(out_valid === 1) begin
	    if (out_data !== correct_answer) begin
            if(mode == 0) begin
                $display("************************************************************");  
                $display("                          \033[1;31mFAIL!\033[1;0m                              ");
                $display(" Expected: data = %23b_%23b_%23b_%23b_%23b_%23b_%23b_%23b_%23b", correct_answer[206:184],correct_answer[183:161],correct_answer[160:138],correct_answer[137:115],correct_answer[114:92],correct_answer[91:69],correct_answer[68:46],correct_answer[45:23],correct_answer[22:0]);
                $display(" Received: data = %23b_%23b_%23b_%23b_%23b_%23b_%23b_%23b_%23b", out_data[206:184],out_data[183:161],out_data[160:138],out_data[137:115],out_data[114:92],out_data[91:69],out_data[68:46],out_data[45:23],out_data[22:0]);
                $display("************************************************************");
                repeat (1) @(negedge clk);
                $finish;
            end
            else if(mode == 1) begin

                $display("************************************************************");  
                $display("                          \033[1;31mFAIL!\033[1;0m                              ");
                $display(" Expected: data = %3b_%51b_%51b_%51b_%51b", correct_answer[206:204],correct_answer[203:153],correct_answer[152:102],correct_answer[101:51],correct_answer[50:0]);
                $display(" Received: data = %3b_%51b_%51b_%51b_%51b", out_data[206:204],out_data[203:153],out_data[152:102],out_data[101:51],out_data[50:0]);
                $display("************************************************************");
                repeat (1) @(negedge clk);
                $finish;
            end
            else begin
                $display("************************************************************");  
                $display("                          \033[1;31mFAIL!\033[1;0m                              ");
                $display(" Expected: data = %b", correct_answer);
                $display(" Received: data = %b", out_data);
                $display("************************************************************");
                repeat (1) @(negedge clk);
                $finish;
            end
        end
        else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end

    if(out_num !== 1) begin
            $display("************************************************************");  
            $display("                            \033[1;31mFAIL!\033[1;0m                            ");
            $display(" Expected one out_valid, but found %d", out_num);
            $display("************************************************************");
            repeat(2) @(negedge clk);
            $finish;
    end

    repeat({$random(SEED)} % 3 + 1)@(negedge clk);
end endtask

task random_input; 
    integer idx,idy;
    
begin
    for(idy = 0; idy < 16; idy = idy + 1) begin
        for(idx = 0; idx < 11; idx = idx + 1)begin
            correct_data[idy][idx] = {$random(SEED)} % 2;
        end
    end
    mode = {$random(SEED)} % 3;
    if(mode == 0)
        correct_mode = 'b00100;
    else if(mode == 1)
        correct_mode = 'b00110;
    else
        correct_mode = 'b10110;
    
    
end
endtask

function [14:0] encode_data; 
    input integer in_count;
    integer idx;
    reg [3:0] value;
begin
    encode_data = 'd0;
    error_data_or_not = {$random(SEED)} % 2;
    error_data_idx = {$random(SEED)} % (15);


    encoding_data[0] = 4'b0;
    encoding_data[1] = correct_data[in_count][11 - 1] ? {encoding_data[0][3]^1'b0 , encoding_data[0][2]^1'b0, encoding_data[0][1]^1'b1, encoding_data[0][0]^1'b1} : encoding_data[0];
    encoding_data[2] = correct_data[in_count][11 - 1 - 1] ? {encoding_data[1][3]^1'b0 , encoding_data[1][2]^1'b1, encoding_data[1][1]^1'b0, encoding_data[1][0]^1'b1} : encoding_data[1];
    encoding_data[3] = correct_data[in_count][11 - 1 - 2] ? {encoding_data[2][3]^1'b0 , encoding_data[2][2]^1'b1, encoding_data[2][1]^1'b1, encoding_data[2][0]^1'b0} : encoding_data[2];
    encoding_data[4] = correct_data[in_count][11 - 1 - 3] ? {encoding_data[3][3]^1'b0 , encoding_data[3][2]^1'b1, encoding_data[3][1]^1'b1, encoding_data[3][0]^1'b1} : encoding_data[3];


    for(idx = 5; idx <= 11; idx = idx + 1) begin
        value = (idx + 4);
        encoding_data[idx] = correct_data[in_count][11 - 1 - idx + 1] ? {encoding_data[idx-1][3]^value[3] , encoding_data[idx-1][2]^value[2], encoding_data[idx-1][1]^value[1], encoding_data[idx-1][0]^value[0]}  : encoding_data[idx-1];
    end

    encode_data[11 + 4 - 1] = encoding_data[11][0];
    encode_data[11 + 4 - 2] = encoding_data[11][1];
    encode_data[11 + 4 - 3] = correct_data[in_count][11 - 1];
    encode_data[11 + 4 - 4] = encoding_data[11][2];
    encode_data[11 + 4 - 5] = correct_data[in_count][11 - 2];
    encode_data[11 + 4 - 6] = correct_data[in_count][11 - 3];
    encode_data[11 + 4 - 7] = correct_data[in_count][11 - 4];
    encode_data[11 + 4 - 8] = encoding_data[11][3];

    for(idx = 9; idx <= 11 + 4; idx = idx + 1) begin
        encode_data[11 + 4 - idx] = correct_data[in_count][11 + 4 - idx];
    end
    
    encode_data[error_data_idx] = error_data_or_not ? ~encode_data[error_data_idx] : encode_data[error_data_idx];

end endfunction

function [8:0] encode_mode; 
    integer idx;
    reg [3:0] value;
begin
    encode_mode = 'd0;

    error_mode_or_not = {$random(SEED)} % 2;
    error_mode_idx = {$random(SEED)} % (9);

    encoding_mode[0] = 4'b0;
    encoding_mode[1] = correct_mode[5 - 1] ? {encoding_mode[0][3]^1'b0 , encoding_mode[0][2]^1'b0, encoding_mode[0][1]^1'b1, encoding_mode[0][0]^1'b1} : encoding_mode[0];
    encoding_mode[2] = correct_mode[5 - 1 - 1] ? {encoding_mode[1][3]^1'b0 , encoding_mode[1][2]^1'b1, encoding_mode[1][1]^1'b0, encoding_mode[1][0]^1'b1} : encoding_mode[1];
    encoding_mode[3] = correct_mode[5 - 1 - 2] ? {encoding_mode[2][3]^1'b0 , encoding_mode[2][2]^1'b1, encoding_mode[2][1]^1'b1, encoding_mode[2][0]^1'b0} : encoding_mode[2];
    encoding_mode[4] = correct_mode[5 - 1 - 3] ? {encoding_mode[3][3]^1'b0 , encoding_mode[3][2]^1'b1, encoding_mode[3][1]^1'b1, encoding_mode[3][0]^1'b1} : encoding_mode[3];


    for(idx = 5; idx <= 5; idx = idx + 1) begin
        value = (idx + 4);
        encoding_mode[idx] = correct_mode[5 - 1 - idx + 1] ? {encoding_mode[idx-1][3]^value[3] , encoding_mode[idx-1][2]^value[2], encoding_mode[idx-1][1]^value[1], encoding_mode[idx-1][0]^value[0]}  : encoding_mode[idx-1];
    end

    encode_mode[5 + 4 - 1] = encoding_mode[5][0];
    encode_mode[5 + 4 - 2] = encoding_mode[5][1];
    encode_mode[5 + 4 - 3] = correct_mode[5 - 1];
    encode_mode[5 + 4 - 4] = encoding_mode[5][2];
    encode_mode[5 + 4 - 5] = correct_mode[5 - 2];
    encode_mode[5 + 4 - 6] = correct_mode[5 - 3];
    encode_mode[5 + 4 - 7] = correct_mode[5 - 4];
    encode_mode[5 + 4 - 8] = encoding_mode[5][3];

    for(idx = 9; idx <= 5 + 4; idx = idx + 1) begin
        encode_mode[5 + 4 - idx] = correct_mode[5 + 4 - idx];
    end
    
    encode_mode[error_mode_idx] = error_mode_or_not ? ~encode_mode[error_mode_idx] : encode_mode[error_mode_idx];

end endfunction

task cal_ans; 
    correct_answer = 'd0;
    if(mode == 0) begin
        correct_answer[206:184] = correct_data[0]*correct_data[5] - correct_data[1]*correct_data[4];
        correct_answer[183:161] = correct_data[1]*correct_data[6] - correct_data[2]*correct_data[5];
        correct_answer[160:138] = correct_data[2]*correct_data[7] - correct_data[3]*correct_data[6];
        correct_answer[137:115] = correct_data[4]*correct_data[9] - correct_data[5]*correct_data[8];
        correct_answer[114:92] = correct_data[5]*correct_data[10] - correct_data[6]*correct_data[9];
        correct_answer[91:69] = correct_data[6]*correct_data[11] - correct_data[7]*correct_data[10];
        correct_answer[68:46] = correct_data[8]*correct_data[13] - correct_data[9]*correct_data[12];
        correct_answer[45:23] = correct_data[9]*correct_data[14] - correct_data[10]*correct_data[13];
        correct_answer[22:0] = correct_data[10]*correct_data[15] - correct_data[11]*correct_data[14];
    end
    else if(mode == 1)begin
        correct_answer[206:204] = 'd0;
        correct_answer[203:153] = correct_data[0]*correct_data[5]*correct_data[10] + correct_data[1]*correct_data[6]*correct_data[8] + correct_data[2]*correct_data[4]*correct_data[9] 
                                    - correct_data[2]*correct_data[5]*correct_data[8] - correct_data[1]*correct_data[4]*correct_data[10] - correct_data[0]*correct_data[6]*correct_data[9];
        correct_answer[152:102] = correct_data[1]*correct_data[6]*correct_data[11] + correct_data[2]*correct_data[7]*correct_data[9] + correct_data[3]*correct_data[5]*correct_data[10] 
                                    - correct_data[3]*correct_data[6]*correct_data[9] - correct_data[1]*correct_data[7]*correct_data[10] - correct_data[2]*correct_data[5]*correct_data[11];
        correct_answer[101:51] = correct_data[4]*correct_data[9]*correct_data[14] + correct_data[5]*correct_data[10]*correct_data[12] + correct_data[6]*correct_data[8]*correct_data[13] 
                                    - correct_data[6]*correct_data[9]*correct_data[12] - correct_data[4]*correct_data[10]*correct_data[13] - correct_data[5]*correct_data[8]*correct_data[14];
        correct_answer[50:0] = correct_data[5]*correct_data[10]*correct_data[15] + correct_data[6]*correct_data[11]*correct_data[13] + correct_data[7]*correct_data[9]*correct_data[14] 
                                    - correct_data[7]*correct_data[10]*correct_data[13] - correct_data[6]*correct_data[9]*correct_data[15] - correct_data[5]*correct_data[11]*correct_data[14];
    end
    else begin
        correct_answer = correct_data[0] * (correct_data[5]*correct_data[10]*correct_data[15] + correct_data[6]*correct_data[11]*correct_data[13] + correct_data[7]*correct_data[9]*correct_data[14] 
                                    - correct_data[7]*correct_data[10]*correct_data[13] - correct_data[6]*correct_data[9]*correct_data[15] - correct_data[5]*correct_data[11]*correct_data[14]) 

                            - correct_data[1] * (correct_data[4]*correct_data[10]*correct_data[15] + correct_data[6]*correct_data[11]*correct_data[12] + correct_data[7]*correct_data[8]*correct_data[14] 
                                    - correct_data[7]*correct_data[10]*correct_data[12] - correct_data[4]*correct_data[11]*correct_data[14] - correct_data[6]*correct_data[8]*correct_data[15]) 

                            + correct_data[2] * (correct_data[4]*correct_data[9]*correct_data[15] + correct_data[5]*correct_data[11]*correct_data[12] + correct_data[7]*correct_data[8]*correct_data[13] 
                                    - correct_data[7]*correct_data[9]*correct_data[12] - correct_data[4]*correct_data[11]*correct_data[13] - correct_data[5]*correct_data[8]*correct_data[15]) 

                            -correct_data[3] * (correct_data[4]*correct_data[9]*correct_data[14] + correct_data[5]*correct_data[10]*correct_data[12] + correct_data[6]*correct_data[8]*correct_data[13] 
                                    - correct_data[6]*correct_data[9]*correct_data[12] - correct_data[4]*correct_data[10]*correct_data[13] - correct_data[5]*correct_data[8]*correct_data[14]);
    end
begin 


end
endtask

task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  \033[0;32mCongratulations!\033[m                                                     ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your execution cycles = %7d cycles                                          ", total_latency);
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
    $display("                                           Total Latency = %.1f ns                                                    ", total_latency * CYCLE);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk);
    $finish;
end endtask



endmodule
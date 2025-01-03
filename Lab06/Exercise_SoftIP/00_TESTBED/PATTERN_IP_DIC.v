`ifdef RTL
    `define CYCLE_TIME 20.0
`endif
`ifdef GATE
    `define CYCLE_TIME 20.0
`endif

module PATTERN #(parameter IP_BIT = 8)(
    //Output Port
    IN_code,
    //Input Port
	OUT_code
);
// ========================================
// Input & Output
// ========================================
output reg [IP_BIT+4-1:0] IN_code;

input [IP_BIT-1:0] OUT_code;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter pat_total = 1000;
integer SEED = 1234;
integer i_pat;
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg error_or_not;
reg clk;
reg [IP_BIT-1:0] correct_data;
reg [3:0] error_idx;
reg [3:0] encoding[0:IP_BIT];
reg [3:0] a[0:15];

//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------

initial begin
    clk = 0;
    IN_code = 'dx;
    repeat(2) @(negedge clk);

	for (i_pat = 0; i_pat < pat_total; i_pat = i_pat + 1) begin
        input_task;
        @(negedge clk);
        check_ans_task;
        repeat(1) @(negedge clk);
        $display("\033[1;34mPASS PATTERN \033[1;32mNO.%4d\033[m", i_pat);
    end

	YOU_PASS_task;
end

task input_task; begin
    random_input;
	encode_data;
end
endtask

task random_input; 
    integer idx;
begin
    error_or_not = {$random(SEED)} % 2;

    for(idx = 0; idx < IP_BIT; idx = idx + 1)begin
        correct_data[idx] = {$random(SEED)} % 2;
    end
    error_idx = {$random(SEED)} % (IP_BIT + 4);

end
endtask


task check_ans_task; begin 
	if (OUT_code !== correct_data) begin
        $display("************************************************************");  
        $display("                         FAIL                               ");
        $display(" Expected: data = %b", correct_data);
        $display(" Received: data = %b", OUT_code);
        $display("************************************************************");
        repeat (2) @(negedge clk);
        $finish;
    end
end endtask

task encode_data; 
    integer idx;
    reg [3:0] value;
begin
    encoding[0] = 4'b0;
    encoding[1] = correct_data[IP_BIT - 1] ? {encoding[0][3]^1'b0 , encoding[0][2]^1'b0, encoding[0][1]^1'b1, encoding[0][0]^1'b1} : encoding[0];
    encoding[2] = correct_data[IP_BIT - 1 - 1] ? {encoding[1][3]^1'b0 , encoding[1][2]^1'b1, encoding[1][1]^1'b0, encoding[1][0]^1'b1} : encoding[1];
    encoding[3] = correct_data[IP_BIT - 1 - 2] ? {encoding[2][3]^1'b0 , encoding[2][2]^1'b1, encoding[2][1]^1'b1, encoding[2][0]^1'b0} : encoding[2];
    encoding[4] = correct_data[IP_BIT - 1 - 3] ? {encoding[3][3]^1'b0 , encoding[3][2]^1'b1, encoding[3][1]^1'b1, encoding[3][0]^1'b1} : encoding[3];


    for(idx = 5; idx <= IP_BIT; idx = idx + 1) begin
        value = (idx + 4);
        encoding[idx] = correct_data[IP_BIT - 1 - idx + 1] ? {encoding[idx-1][3]^value[3] , encoding[idx-1][2]^value[2], encoding[idx-1][1]^value[1], encoding[idx-1][0]^value[0]}  : encoding[idx-1];
    end

    IN_code[IP_BIT + 4 - 1] = encoding[IP_BIT][0];
    IN_code[IP_BIT + 4 - 2] = encoding[IP_BIT][1];
    IN_code[IP_BIT + 4 - 3] = correct_data[IP_BIT - 1];
    IN_code[IP_BIT + 4 - 4] = encoding[IP_BIT][2];
    IN_code[IP_BIT + 4 - 5] = correct_data[IP_BIT - 2];
    IN_code[IP_BIT + 4 - 6] = correct_data[IP_BIT - 3];
    IN_code[IP_BIT + 4 - 7] = correct_data[IP_BIT - 4];
    IN_code[IP_BIT + 4 - 8] = encoding[IP_BIT][3];

    for(idx = 9; idx <= IP_BIT + 4; idx = idx + 1) begin
        IN_code[IP_BIT + 4 - idx] = correct_data[IP_BIT + 4 - idx];
    end
    
    IN_code[error_idx] = error_or_not ? ~IN_code[error_idx] : IN_code[error_idx];

end endtask



task YOU_PASS_task; begin
    $display("----------------------------------------------------------------------------------------------------------------------");
    $display("                                                  \033[0;32mCongratulations!\033[m                                                     ");
    $display("                                           You have passed all patterns!                                               ");
    $display("                                           Your clock period = %.1f ns                                                 ", CYCLE);
    $display("----------------------------------------------------------------------------------------------------------------------");
    repeat (2) @(negedge clk);
    $finish;
end endtask

endmodule
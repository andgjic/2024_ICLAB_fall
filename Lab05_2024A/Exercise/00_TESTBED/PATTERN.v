`ifdef RTL
    `define CYCLE_TIME 6.9
`endif
`ifdef GATE
    `define CYCLE_TIME 6.9
`endif
`ifdef POST
    `define CYCLE_TIME 6.9
`endif

`define SEED     28825252
`define PAT_NUM 5
`define ACT_NUM 8 /////2-to-8
`define IMG_SIZE 2 /////0,1,2

module PATTERN(
    // Output signals
    clk,
	rst_n,
	
	in_valid,
	in_valid2,
	
    image,
	template,
	image_size,
	action,

    // Input signals
	out_valid,
	out_value
);

// ========================================
// I/O declaration
// ========================================
// Output
output reg       clk, rst_n;
output reg       in_valid;
output reg       in_valid2;

output reg [7:0] image;
output reg [7:0] template;
output reg [1:0] image_size;
output reg [2:0] action;

// Input
input out_valid;
input out_value;

// ========================================
// clock
// ========================================
real CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk; //clock

// ========================================
// integer & parameter
// ========================================
parameter SIZE_FOUR = 4;
parameter SIZE_EIGHT = 8;
parameter SIZE_SIXTEEN = 16;
parameter SIZE_TEMPLETE = 3;

parameter RGB_WIDTH = 24;
parameter R_WIDTH = 8;
parameter G_WIDTH = 8;
parameter B_WIDTH = 8;


integer i,j,k;
integer pat_num = `PAT_NUM;
integer i_pat, i_action;

integer width,input_cycles;

integer latency;
integer total_latency;

integer count_input, delay_2to4, out_num, delay_1to4;
// ========================================
// wire & reg
// ========================================
reg [7:0] input_r[15:0][15:0],input_g[15:0][15:0],input_b[15:0][15:0];

reg [7:0]templete_reg[2:0][2:0];
integer action_num;
reg [2:0]actions[7:0];

reg [19:0]golden_out_value;
reg [1:0]image_size_reg;
//================================================================
// design
//================================================================

    initial begin

        
        // Initialize signals
        reset_task;
		i_pat = 0;
        // Iterate through each pattern
        //for (i_pat = 0; i_pat < patnum; i_pat = i_pat + 1) begin
		while (i_pat < pat_num )begin
            input_image_task;

			while(i_action < 8)begin
				input_action_task;
				wait_out_valid_task;
            	//check_ans_task;
				$display("\033[0;34mPASS PATTERN NO.%4d, action_set NO.%d \033[m \033[0;32m", i_pat + 1, i_action, latency);
			end
		end
        
        // All patterns passed
        YOU_PASS_task;
    end



	task input_image_task; begin
        delay_2to4 = $urandom() % 3 + 2;
        repeat (delay_2to4) @(negedge clk);////delay for 2-4

        count_input = 0;
		image_size_reg = `IMG_SIZE;//$urandom()%3;//////////
		if(image_size_reg==0)begin
			width = 4;
		end
		else if(image_size_reg==1)begin
			width = 8;
		end
		else begin//if(image_size_reg==2)
			width = 16;
		end

		input_cycles = width*width*3;
///////////////random input////////////////////////////////////////
		for(i=0;i<width;i=i+1)begin
			for(j=0;j<width;j=j+1)begin
				input_r[i][j] = $urandom()%256;
				input_g[i][j] = $urandom()%256;
				input_b[i][j] = $urandom()%256;
			end
		end

		for(i=0;i<3;i=i+1)begin
			for(j=0;j<3;j=j+1)begin
				templete_reg[i][j] = $urandom()%256;
			end
		end

        while (count_input < input_cycles) begin
            in_valid = 1;

			if(count_input == 0)
				image_size = image_size_reg;
			else
				image_size = 2'bx;
            
			/*if(count_input < input_cycles/3)
				image = input_r[count_input/width][count_input%width];
			else if(count_input < input_cycles*2/3)
				image = input_g[(count_input-input_cycles/3)/width][(count_inputinput_cycles/3)%width];
			else
				image = input_b[(count_input-input_cycles*2/3)/width][(count_inputinput_cycles*2/3)%width];

			if(count_input < 9)
				template = templete_r[count_input/3][count_input%3];
			else if(count_input <18)			
				template = templete_r[(count_input-9)/3][(count_input-9)%3];
			else if(count_input < 27)
				template = templete_r[(count_input-18)/3][(count_input-18)%3];
			else
				template = 8'bx;
				*/
			
			image = $urandom() % 256;
			if(count_input < 9)
				template = $urandom() % 256;
			else
				template = 8'bx;

            @(negedge clk);           // Wait for clock's negative edge
            count_input = count_input+1;
        end

		image_size = 1'bx;
		in_valid = 1'b0;
		image = 8'bx;
		template = 8'bx;
		count_input = 0;

    end endtask

	task input_action_task; begin
		delay_1to4 = $urandom() % 4 + 1;		
        count_input = 0;
        repeat (delay_1to4) @(negedge clk);////delay for 1-4
		
		//action_num = $urandom() % 7 + 2;
		action_num = `ACT_NUM;

		while(count_input<action_num)begin
			in_valid2 = 1'b1;
			if(count_input== 0)
				action = $urandom() % 3;
			else if(count_input == action_num-1)
				action = 7;
			else
				action = $urandom() % 4+3;

			@(negedge clk);           // Wait for clock's negative edge
            count_input = count_input+1;
		end

        // Reset signals after processing
        //in_valid = 1'b0;
		in_valid2 = 1'b0;
		action = 2'bx;
        count_input = 0;
    end endtask

	task wait_out_valid_task; begin
        //while (out_valid !== 1'b1) begin

		latency = 0;
		while(latency != 2000)begin
            latency = latency + 1;

            if (latency == 2000) begin
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
        in_valid = 1'bx;
		in_valid2 = 1'bx;
        image = 8'bx;
		template = 8'bx;
		image_size = 2'bx;
		action = 3'bx;
        total_latency = 0;
        out_num = 0;
		i_action = 0;

        force clk = 0;
        // Apply reset
        #CYCLE; rst_n = 1'b0; 
        in_valid = 1'b0;
		in_valid2 = 1'b0;
        #CYCLE; rst_n = 1'b1;
        
        // Check initial conditions
        if (out_valid !== 1'b0 || out_value !== 1'd0) begin
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




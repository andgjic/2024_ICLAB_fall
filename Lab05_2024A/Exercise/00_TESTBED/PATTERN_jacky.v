`ifdef RTL
    `define CYCLE_TIME 12.0
`endif
`ifdef GATE
    `define CYCLE_TIME 12.0
`endif
`ifdef POST
    `define CYCLE_TIME 20.0
`endif

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
integer pat_read, ans_read, file;
integer PAT_NUM;
integer total_latency, latency;
integer out_val_clk_times;
integer i_pat,i,j;
integer input_matrix_size;
integer idx_count;
integer golden_size;

integer SEED = 12345;
// ========================================
// wire & reg
// ========================================
reg [7:0] input_img_buf[0:15][0:15][0:2];
reg [7:0] input_template_buf[0:2][0:2];

//================================================================
// initial
//================================================================
initial begin
  pat_read = $fopen("../00_TESTBED/input.txt", "r");
  ans_read = $fopen("../00_TESTBED/output.txt", "r");
  reset_signal_task;

  i_pat = 0;
  total_latency = 0;
  idx_count = 0;
  file = $fscanf(pat_read, "%d\n", PAT_NUM);
  repeat({$random(SEED)} % 3 + 2)@(negedge clk);

  for (i_pat = 0; i_pat < PAT_NUM; i_pat = i_pat + 1) begin
    input_task_1;
    
    // 8 groups of actions
    for(idx_count = 0; idx_count < 8; idx_count = idx_count + 1)
    begin
	  input_task_2;
    latency = 0;
	  wait_out_valid_task;
      check_ans_task;
    end

    total_latency = total_latency + latency;
    $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %4d,\033[m",i_pat , latency);
  end
  $fclose(pat_read);

  YOU_PASS_task;
end

initial begin
  while(1) begin
    if((out_valid === 0) && (out_valid !== 0))
    begin
      $display("***********************************************************************");
      $display("*  Error                                                              *");
      $display("*  The out_data should be reset when out_valid is low.                *");
      $display("***********************************************************************");
      repeat(2)@(negedge clk);
      $finish;
    end
    if((in_valid === 1) && (out_valid === 1))
    begin
      $display("***********************************************************************");
      $display("*  Error                                                              *");
      $display("*  The out_valid cannot overlap with in_valid.                        *");
      $display("***********************************************************************");
      repeat(2)@(negedge clk);
      $finish;
    end
    @(negedge clk);
  end
end

//================================================================
// task
//================================================================
task reset_signal_task;
begin
  rst_n    = 1;
  in_valid = 1'b0;
  in_valid2 = 1'b0;
  force clk= 0;
  #(0.5 * CYCLE);
  rst_n = 0;

  image = 8'bx;
  template = 8'bx;
  image_size = 2'bx;
  action = 3'bx;

  #(10 * CYCLE);
  if( (out_valid !== 0) || (out_value !== 0) )
  begin
    $display("***********************************************************************");
    $display("*  Error                                                              *");
    $display("*  Output signal should reset after initial RESET                     *");
    $display("***********************************************************************");
    $finish;
  end
  #(CYCLE);  rst_n=1;
  #(CYCLE);  release clk;
end
endtask
reg[1:0] img_size_idx_buf;
integer template_cnt;
integer action_cnt;

integer image_shape_w;
task input_task_1;
begin
  // Read in the matrix size
  file = $fscanf(pat_read, "%d\n",img_size_idx_buf);

  case(img_size_idx_buf)
  'd0: image_shape_w = 4;
  'd1: image_shape_w = 8;
  'd2: image_shape_w = 16;
  endcase

  // buffered the rgb img
  	for(i = 0; i<image_shape_w ; i=i+1)
  		for(j = 0; j < image_shape_w; j=j+1)
  			for(integer ch = 0;ch < 3;ch=ch+1)
  	      		file = $fscanf(pat_read, "%d", input_img_buf[i][j][ch]);

  // buffer the template
  for(i = 0; i < 3; i=i+1)
  	for(j = 0; j < 3; j=j+1)
        file  = $fscanf(pat_read, "%d", input_template_buf[i][j]);

  // Set pattern signal
  
  template_cnt = 0;

  in_valid = 1'b1;
  image_size = img_size_idx_buf;

  // Sends matrix
  for(i = 0; i < image_shape_w; i=i+1)
    for(j = 0; j < image_shape_w; j=j+1)
		for(integer ch = 0;ch < 3;ch=ch+1)
    	begin
    	  image = input_img_buf[i][j][ch];

		  if(template_cnt < 9)
		  begin
    	  	template = input_template_buf[template_cnt/3][template_cnt%3];
		  end
		  else
		  begin
		  	template = 8'bx;
		  end

		  template_cnt = template_cnt + 1;

    	  @(negedge clk);
    	  image_size = 'bx;
    	end

  // Clear in_valid and matrix
  in_valid = 1'b0;
  image   = 'bx;

  // Delays
  repeat({$random(SEED)} % 3 + 2)@(negedge clk);
end
endtask

task input_task_2;
begin
	// starts reading different actions
	in_valid2 = 1'b1;
	// Reads the number of actions
	file = $fscanf(pat_read,"%d",action_cnt);
	for(i = 0; i < action_cnt; i = i+1)
	begin
	  $fscanf(pat_read,"%d",action);
	  @(negedge clk);
	end
	in_valid2 = 1'b0;
	action = 3'bx;
end
endtask

task wait_out_valid_task;
begin
  
  while(out_valid !== 1) begin
    latency = latency + 1;
    if(latency >= 5000)
    begin
      $display("***********************************************************************");
      $display("*  Error                                                              *");
      $display("*  The execution latency are over  5000 cycles.                      *");
      $display("***********************************************************************");
      repeat(2)@(negedge clk);
      $finish;
    end
    @(negedge clk);
  end
  total_latency = total_latency + latency;
end
endtask

reg[19:0] golden_word;


task check_ans_task;
begin
  file = $fscanf(ans_read,"%d",golden_size);

  for(i=0; i<golden_size ; i=i+1)
  begin
    file = $fscanf(ans_read,"%b",golden_word);

    for(j=0 ; j < 20; j=j+1)
    begin
      if(out_valid !== 1)
      begin
        $display("***********************************************************************");
        $display("*  Error                                                              *");
        $display("*  Out valid should be 1 when outputing the data                      *");
        $display("*  Current index of output matrix %d , bit of output matrix %d *",i,j   );
        $display("***********************************************************************");
        repeat(2)@(negedge clk);
        $finish;
      end

      if(out_value !== golden_word[19-j])
      begin
         $display("***********************************************************************");
         $display("*  Error                                                              *");
         $display("*  The out_data should be correct when out_valid is high              *");
         $display("*  Golden       : 0b%20b                    *",golden_word);
         $display("*  Golden       : %5d                      *",golden_word);
         $display("*  Golden       : 0b%20b                   *",golden_word);
         $display("***********************************************************************");
         repeat(2)@(negedge clk);
         $finish;
      end
      @(negedge clk);
    end
  end


  if(out_valid !== 0  || out_value !== 0)
      begin
          $display("***********************************************************************");
          $display("*  Error                                                              *");
          $display("*  Output signal should reset after outputting the data               *");
          $display("***********************************************************************");
          repeat(2)@(negedge clk);
          $finish;
  end
  repeat({$random(SEED)} % 3 + 1)@(negedge clk);
end
endtask


task YOU_PASS_task; begin
  $display("***********************************************************************");
  $display("*                           \033[0;32mCongratulations!\033[m                          *");
  $display("*  Your execution cycles = %18d   cycles                *", total_latency);
  $display("*  Your clock period     = %20.1f ns                    *", CYCLE);
  $display("*  Total Latency         = %20.1f ns                    *", total_latency*CYCLE);
  $display("***********************************************************************");
  $finish;
end endtask


endmodule

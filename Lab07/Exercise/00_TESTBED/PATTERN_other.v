`ifdef RTL
	`define CYCLE_TIME_clk1 7.1
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
parameter PAT_NUM=1000;

//================================================================
// wire & registers 
//================================================================
reg [2:0] _row_map[5:0][5:0];
reg [2:0] _ker_map[5:0][1:0][1:0];

reg [7:0] _golden_ans[5:0][4:0][4:0];
reg [7:0] _your_ans  [5:0][4:0][4:0];

reg [10:0] cnt;

integer SEED;
//================================================================
// clock
//================================================================
always	#(`CYCLE_TIME_clk1/2.0) clk1 = ~clk1;
initial	clk1 = 0;
always	#(`CYCLE_TIME_clk2/2.0) clk2 = ~clk2;
initial	clk2 = 0;

//================================================================
// initial
//================================================================
integer i,j,k,debug,i_pat,total_latency;
integer delay1to3, ans_indx;
always @(posedge clk1) begin
    if(out_valid===0)begin
        if(out_data!==0)begin
            $display("out should be 0 when out_valid is low");
            $finish;
        end
    end
end

always @(*) begin
    if(out_valid===1 && in_valid===1)begin
        $display("in_valid out_valid overlap");
        $finish;
    end
end

initial begin
    reset_signal_task;
	
    for (i_pat = 1; i_pat <= PAT_NUM; i_pat = i_pat + 1) begin
		gen_data_task;
        input_task;
        // $finish;
        check_ans_task;
        
        $display("PASS PATTERN NO.%4d", i_pat);
		// $finish;
    end
    $display("congratulation");
    $finish;
end

task display_data; begin

	$display("golden_ans");
	ans_indx = 0;
	while(ans_indx <= cnt)begin
		if(ans_indx==24 || ans_indx==49 || ans_indx==74 || ans_indx==99 || ans_indx==124)begin
			
			$write("%4d", _golden_ans[ans_indx/25][ans_indx/5][ans_indx%5]);
			$display();
		end
		else if(ans_indx%5==0)begin
			$display();
			$write("%4d", _golden_ans[ans_indx/25][(ans_indx%25)/5][ans_indx%5]);
		end
		else
			$write("%4d", _golden_ans[ans_indx/25][(ans_indx%25)/5][ans_indx%5]);

		ans_indx = ans_indx+1;
	end

	$display("\n your_ans");
	ans_indx = 0;
	while(ans_indx <= cnt)begin
		if(ans_indx==24 || ans_indx==49 || ans_indx==74 || ans_indx==99 || ans_indx==124)begin
			$write("%4d", _your_ans[ans_indx/25][(ans_indx%25)/5][ans_indx%5]);
			$display();
		end
		else if(ans_indx%5==0)begin
			$display();
			$write("%4d", _your_ans[ans_indx/25][(ans_indx%25)/5][ans_indx%5]);
		end
		else
			$write("%4d", _your_ans[ans_indx/25][(ans_indx%25)/5][ans_indx%5]);

		ans_indx = ans_indx+1;
	end

	$display();
end endtask


task gen_data_task;begin
	for(i=0;i<6;i=i+1)begin
		for(j=0;j<6;j=j+1)begin
			_row_map[i][j] = $urandom();
		end
	end

	for(i=0;i<6;i=i+1)begin
		for(j=0;j<2;j=j+1)begin
			for(k=0;k<2;k=k+1)begin
				_ker_map[i][j][k] = $urandom();
			end
		end
	end

	for(i=0;i<6;i=i+1)begin
		for(j=0;j<5;j=j+1)begin
			for(k=0;k<5;k=k+1)begin
				_golden_ans[i][j][k] = _row_map[j][k]*_ker_map[i][0][0] + _row_map[j][k+1]*_ker_map[i][0][1] + _row_map[j+1][k]*_ker_map[i][1][0] + _row_map[j+1][k+1]*_ker_map[i][1][1];
			end
		end
	end

	//$display("gen_data_finish!!");
	//@(negedge clk1);
    //$finish;
end endtask
reg [2:0]map_idx;
reg [2:0]row_idx, col_idx;
task check_ans_task;begin
	cnt=0;
	total_latency=0;
    while(cnt<150)begin
		while(out_valid!==1)begin
			if(out_data!==0)begin
				$display("out should be zero when out_valid is zero");
				$finish;
			end
			@(negedge clk1);
			if(total_latency>=2000)begin
                //display_data;
                $display("latency exceed 2000 cycles");
                $finish;
            end
			total_latency=total_latency+1;
            // $display("%d",total_latency);
			
		end
        
        if(out_valid===1)begin
			map_idx = cnt/25;
			row_idx = (cnt%25)/5;
        	_your_ans[cnt/25][(cnt%25)/5][cnt%5] = out_data;
			if(_your_ans[cnt/25][(cnt%25)/5][cnt%5] !== _golden_ans[cnt/25][(cnt%25)/5][cnt%5])begin
				display_data;
				$display("ans_wrong");
				$display("golden_ans:%d",_golden_ans[cnt/25][(cnt%25)/5][cnt%5]);
				$display("your_ans:  %d",out_data);
        		$finish;
			end
			//else if(map_idx>0)begin
			//	$display("cnt=%d",cnt);
			//	$display("golden_ans:%d",_golden_ans[cnt/25][cnt/5][cnt%5]);
			//	$display("your_ans:  %d",_your_ans[map_idx][cnt/5][cnt%5]);
			//end
        end
        @(negedge clk1);

        if(total_latency>=2000)begin
                $display("latency exceed 2000 cycles");
          $finish;
        end
		total_latency=total_latency+1;
        // $display("%d",total_latency);
		cnt=cnt+1;
        
    end

	if(out_valid===1 || out_data!==0)begin
      $display("out_valid exceed 150 cycles");
      $finish;
    end
end
endtask

task input_task; begin    
    in_kernel='dx;
    in_row = 'dx;
    in_valid=0;

	delay1to3 = $urandom()%3+1;
	repeat(delay1to3) @(negedge clk1);

	in_valid=1;
    for(i=0;i<6;i=i+1)begin
		in_kernel = {_ker_map[i][1][1], _ker_map[i][1][0], _ker_map[i][0][1], _ker_map[i][0][0]};
		in_row    = {_row_map[i][5], _row_map[i][4], _row_map[i][3], _row_map[i][2], _row_map[i][1], _row_map[i][0]};
        @(negedge clk1);
    end
    in_kernel = 'dx;
    in_row    = 'dx;
    in_valid  = 0;

	//$display("input_finish!!");
	//@(negedge clk1);
    //$finish;
end endtask 


task reset_signal_task; begin

    force clk1 = 0;
    force clk2 = 0;
    rst_n = 1;

    in_valid = 'dx;
    in_kernel = 'dx;
    in_row = 'dx;

    // tot_lat = 0;

    #(`CYCLE_TIME_clk1/2.0) rst_n = 0;
	
    in_valid = 0;
    #(`CYCLE_TIME_clk1/2.0) rst_n = 1;
    if (out_valid !== 0 || out_data !== 0) begin
        $display("                                           `:::::`                                                       ");
        $display("                                          .+-----++                                                      ");
        $display("                .--.`                    o:------/o                                                      ");
        $display("              /+:--:o/                   //-------y.          -//:::-        `.`                         ");
        $display("            `/:------y:                  `o:--::::s/..``    `/:-----s-    .:/:::+:                       ");
        $display("            +:-------:y                `.-:+///::-::::://:-.o-------:o  `/:------s-                      ");
        $display("            y---------y-        ..--:::::------------------+/-------/+ `+:-------/s                      ");
        $display("           `s---------/s       +:/++/----------------------/+-------s.`o:--------/s                      ");
        $display("           .s----------y-      o-:----:---------------------/------o: +:---------o:                      ");
        $display("           `y----------:y      /:----:/-------/o+----------------:+- //----------y`                      ");
        $display("            y-----------o/ `.--+--/:-/+--------:+o--------------:o: :+----------/o                       ");
        $display("            s:----------:y/-::::::my-/:----------/---------------+:-o-----------y.                       ");
        $display("            -o----------s/-:hmmdy/o+/:---------------------------++o-----------/o                        ");
        $display("             s:--------/o--hMMMMMh---------:ho-------------------yo-----------:s`                        ");
        $display("             :o--------s/--hMMMMNs---------:hs------------------+s------------s-                         ");
        $display("              y:-------o+--oyhyo/-----------------------------:o+------------o-                          ");
        $display("              -o-------:y--/s--------------------------------/o:------------o/                           ");
        $display("               +/-------o+--++-----------:+/---------------:o/-------------+/                            ");
        $display("               `o:-------s:--/+:-------/o+-:------------::+d:-------------o/                             ");
        $display("                `o-------:s:---ohsoosyhh+----------:/+ooyhhh-------------o:                              ");
        $display("                 .o-------/d/--:h++ohy/---------:osyyyyhhyyd-----------:o-                               ");
        $display("                 .dy::/+syhhh+-::/::---------/osyyysyhhysssd+---------/o`                                ");
        $display("                  /shhyyyymhyys://-------:/oyyysyhyydysssssyho-------od:                                 ");
        $display("                    `:hhysymmhyhs/:://+osyyssssydyydyssssssssyyo+//+ymo`                                 ");
        $display("                      `+hyydyhdyyyyyyyyyyssssshhsshyssssssssssssyyyo:`                                   ");
        $display("                        -shdssyyyyyhhhhhyssssyyssshssssssssssssyy+.    Output signal should be 0         ");
        $display("                         `hysssyyyysssssssssssssssyssssssssssshh+                                        ");
        $display("                        :yysssssssssssssssssssssssssssssssssyhysh-     after the reset signal is asserted");
        $display("                      .yyhhdo++oosyyyyssssssssssssssssssssssyyssyh/                                      ");
        $display("                      .dhyh/--------/+oyyyssssssssssssssssssssssssy:   at %4d ps                         ", $time*1000);
        $display("                       .+h/-------------:/osyyysssssssssssssssyyh/.                                      ");
        $display("                        :+------------------::+oossyyyyyyyysso+/s-                                       ");
        $display("                       `s--------------------------::::::::-----:o                                       ");
        $display("                       +:----------------------------------------y`                                      ");
        repeat(2) #(`CYCLE_TIME_clk1);
        $finish;
    end
    #(`CYCLE_TIME_clk1/2.0) release clk1;
    release clk2;
    @(negedge clk1);
	//SEED = 9487;
end endtask
endmodule

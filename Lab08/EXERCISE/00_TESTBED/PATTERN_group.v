/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: SA
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: Nov 06, 2024
// AUTHOR: Yen-Ning Tung, NYCU AIG
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Fall IC Lab / Exersise Lab08 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

`define CYCLE_TIME   50
`define PATTERN_NUMBER   1000
`define SEED_NUMBER     28825252


module PATTERN(
    // Output signals
    clk,
    rst_n,
    cg_en,
    in_valid,
    T,
    in_data,
    w_Q,
    w_K,
    w_V,

    // Input signals
    out_valid,
    out_data
);

output reg clk;
output reg rst_n;
output reg cg_en;
output reg in_valid;
output reg [3:0] T;
output reg signed [7:0] in_data;
output reg signed [7:0] w_Q;
output reg signed [7:0] w_K;
output reg signed [7:0] w_V;

input out_valid;
input signed [63:0] out_data;

//================================================================
// parameters & integer
//================================================================
real CYCLE = `CYCLE_TIME;
real PATNUM = `PATTERN_NUMBER;
real seed = `SEED_NUMBER;
integer latency,total_latency;
integer i_pat, a,b,c;
integer i,j,k;
integer debug;

//================================================================
// Clock
//================================================================
initial clk = 0;
always #(CYCLE/2) clk = ~clk;



//================================================================
// Wire & Reg Declaration
//================================================================
reg [1:0] in_T_type;
parameter integer in_T[3] = {1, 4, 8};

integer input_times;
integer indata_times;
integer cnt;
reg signed [7:0] indata[0:7][0:7];
reg signed [7:0] in_w_Q[0:7][0:7];
reg signed [7:0] in_w_K[0:7][0:7];
reg signed [7:0] in_w_V[0:7][0:7];

reg signed [63:0] Q[0:7][0:7]; 
reg signed [63:0] K[0:7][0:7]; 
reg signed [63:0] V[0:7][0:7]; 

reg signed [63:0] A[0:7][0:7]; 


reg signed [63:0] outdata[0:7][0:7];


reg[9*8:1]  reset_color       = "\033[1;0m";
reg[10*8:1] txt_black_prefix  = "\033[1;30m";
reg[10*8:1] txt_red_prefix    = "\033[1;31m";
reg[10*8:1] txt_green_prefix  = "\033[1;32m";
reg[10*8:1] txt_yellow_prefix = "\033[1;33m";
reg[10*8:1] txt_blue_prefix   = "\033[1;34m";

reg[10*8:1] bkg_black_prefix  = "\033[40;1m";
reg[10*8:1] bkg_red_prefix    = "\033[41;1m";
reg[10*8:1] bkg_green_prefix  = "\033[42;1m";
reg[10*8:1] bkg_yellow_prefix = "\033[43;1m";
reg[10*8:1] bkg_blue_prefix   = "\033[44;1m";
reg[10*8:1] bkg_white_prefix  = "\033[47;1m";



//================================================================
// Task
//================================================================

initial begin
	total_latency = 0;
    reset_task;
    cg_en = 1;
	for(i_pat = 0; i_pat < PATNUM; i_pat = i_pat + 1) begin
		input_task;
		cal_task;
        check_ans_task;
        $display("%0sPASS PATTERN NO.%4d %0sCycles: %3d%0s",txt_blue_prefix, i_pat, txt_green_prefix, latency, reset_color);
        total_latency = total_latency + latency;
	end
	PASS_task;
end


task reset_task; begin
	for(i = 0; i < 8; i = i + 1) begin
		for(j = 0; j < 8; j = j + 1) begin
			Q[i][j] = 0;
			K[i][j] = 0;
			A[i][j] = 0;
			V[i][j] = 0;
		end
	end
    in_valid = 0;
	T = 'bx;
    in_data = 'bx;
    w_K = 'bx;
    w_Q = 'bx;
    w_V = 'bx;
	rst_n = 1;
    force clk = 0;
    #(CYCLE / 2.0); rst_n = 0;
    #(CYCLE / 2.0); rst_n = 1;
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
        repeat(5) #(CYCLE);
        $finish;
    end
    #(CYCLE / 2.0) release clk;
     @(negedge clk);
end
endtask
 

task input_task;begin
    
	in_T_type = $urandom()%3;
	indata_times = 8*in_T[in_T_type];

	for(i = 0; i < indata_times; i = i + 1) begin
		indata[i/8][i%8] = $random(seed)%256 - 128;
	end

	for(i = 0; i < 64; i = i + 1) begin
		in_w_Q[i/8][i%8] = $random(seed)%256 - 128;
		in_w_K[i/8][i%8] = $random(seed)%256 - 128;
		in_w_V[i/8][i%8] = $random(seed)%256 - 128;
	end

	input_times = 192;

    //repeat($random(seed)%4) @(negedge clk);

    for(i = 0; i < input_times; i = i + 1)begin
        in_valid = 1;

		if(i == 0) T = in_T[in_T_type];
		else T = 'bx;

        if(i < indata_times)  in_data = indata[i/8][i%8];
		else in_data = 'bx;

		if(i < 64)  w_Q = in_w_Q[(i)/8][(i)%8];
		else w_Q = 'bx;

		if((i >= 64) && (i < (64 + 64)))  w_K = in_w_K[(i-64)/8][(i-64)%8];
		else w_K = 'bx;	

		if((i >= (64 + 64)) && (i < (64 + 128)))  w_V = in_w_V[(i-64-64)/8][(i-64-64)%8];
		else w_V = 'bx;	

        @(negedge clk);
    end
    
    in_valid = 0;
	T = 'bx;
    in_data = 'bx;
    w_Q = 'bx;
	w_K = 'bx;
	w_V = 'bx;
end endtask

task display_data; begin
	debug = $fopen("../00_TESTBED/debug.txt", "w");
	$fwrite(debug, "[PAT NO. %4d]\n\n", i_pat);

	$fwrite(debug, "in_data: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", indata[i][0], indata[i][1], indata[i][2], indata[i][3], indata[i][4], indata[i][5], indata[i][6], indata[i][7]);
	end

	$fwrite(debug, "\nwQ: \n");
	for(i = 0; i < 8; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", in_w_Q[i][0], in_w_Q[i][1], in_w_Q[i][2], in_w_Q[i][3], in_w_Q[i][4], in_w_Q[i][5], in_w_Q[i][6], in_w_Q[i][7]);
	end

	$fwrite(debug, "\nwK: \n");
	for(i = 0; i < 8; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", in_w_K[i][0], in_w_K[i][1], in_w_K[i][2], in_w_K[i][3], in_w_K[i][4], in_w_K[i][5], in_w_K[i][6], in_w_K[i][7]);
	end

	$fwrite(debug, "\nwV: \n");
	for(i = 0; i < 8; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", in_w_V[i][0], in_w_V[i][1], in_w_V[i][2], in_w_V[i][3], in_w_V[i][4], in_w_V[i][5], in_w_V[i][6], in_w_V[i][7]);
	end
	

	$fwrite(debug, "\nQ: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", Q[i][0], Q[i][1], Q[i][2], Q[i][3], Q[i][4], Q[i][5], Q[i][6], Q[i][7]);
	end

	$fwrite(debug, "\nK: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", K[i][0], K[i][1], K[i][2], K[i][3], K[i][4], K[i][5], K[i][6], K[i][7]);
	end

	$fwrite(debug, "\nV: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", V[i][0], V[i][1], V[i][2], V[i][3], V[i][4], V[i][5], V[i][6], V[i][7]);
	end

	$fwrite(debug, "\nA: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		for(j = 0; j < in_T[in_T_type]; j = j + 1)begin
			$fwrite(debug, "%d ", A[i][j]);
		end
		$fwrite(debug, "\n");
	end


	$fwrite(debug, "\nP: \n");
	for(i = 0; i < in_T[in_T_type]; i = i + 1)begin
		$fwrite(debug, "%d %d %d %d %d %d %d %d\n", outdata[i][0], outdata[i][1], outdata[i][2], outdata[i][3], outdata[i][4], outdata[i][5], outdata[i][6], outdata[i][7]);
	end
end
endtask


task check_ans_task;begin
    cnt = 0;
	latency = 0;
    while(cnt < indata_times)begin
		while(out_valid !== 1)begin
			if(out_data !== 0)begin
				$display("out should be zero");
				$finish;
			end
			@(negedge clk);
			if(latency >= 2000)begin
                display_data;
                $display("cycle exceed 2000");
                $finish;
            end
			latency = latency + 1;		
		end
        
        if(out_valid === 1)begin
            if(out_data !== outdata[cnt/8][cnt%8])begin
				display_data;
                $display("        ⣀⣤⣤⣀");
                $display("⠀⠀⠀⠀⣠⠟⠁⠀⠀⠀⠀⠙⣆");
                $display("⠀⠀⠀⣴⠁⠀⠀⠀⠀⠀⠀⠀⠀⢷     \033[1;32m ================================================  \033[1;0m");
                $display("⠀⠀⠀⡇⠀⠀⡴⠀⠀⡴⠀⠀⠀⠀⡆    \033[1;31m The %dth output is not correct!!! \033[1;0m", cnt);
                $display("⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇    \033[1;32m Gold output is %lld \033[1;0m",outdata[cnt/8][cnt%8]);
                $display("⠀⠀⠀⢿⠀⠀⣤⣀⣀⣤⠀⠀⠀⣼     \033[1;32m ================================================  \033[1;0m");
                $display("⠀⠀⠀⠀⠳⣀⠀⠀⠀⠀⠀⢀⡴      ");
                $display("⠀⠀⠀⠀⠀⠈⠛⠶⡆⠀⠀⢿⠀⠀⠀⠀⣀⣀⣀⣀⣀");
                $display("⠀⠀⠀⠀⠀⠀⠀⣴⣴⠛⠃⠀⢻⠀⠀⠸⡀⠀⠀⠀⢀⠇");
                $display("⠀⠀⠀⠀⣠⣴⡿⠋⠀⠀⠀⠀⠀⣇⠀⠀⡇⠀⠀⠀⢸");
                $display("⠀⣴⠟⠛⠉⠀⠀⣠⣶⠋⠀⠀⠀⢹⠀⠀⡇⠀⠀⠀⢸");
                $display("⢠⠃⣶⠶⣺⡿⠿⠶⠾⣦⡀⠀⠀⠀⣇⠀⡇⠀⠀⠀⢸");
                $display("⠘⠳⠾⣯⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⡇⠀⠀⠀⢸");
                $display("⠀⠀⠀⣿⠀⠀⢸⣀⠀⠀⠀⠀⠀⠀⡾⠀⡇⠀⠀⠀⢸");
                $display("⠀⠀⠀⣿⠀⠀⣿⣰⠾⠿⠿⠿⠿⠿⠶⢦⣷⣤⣤⣤⠞");
                $display("⠀⠀⠀⡟⠀⢠⠃⣇⠀⠀⠀⠀    ⠀⠀⠀⠀⠀⢠⠃");
                $display("⠀⣠⡶⠃⠀⣿⡄⠈⢲⠀\033[0;31m|Your output|\033[1;0m ⡟");
                $display("⢠⣿⣿⣿⣿⣿⣿⠀⡏ \033[0;31m|is   %lld  |\033[1;0m⣸",out_data);
                $display("⠀⠀⣿⣿⠀⠀⢿⣿⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠃");
                $display("⠀⠙⠁⠀⠀⠘⠋⠛⠒⠒⠒⠒⠒⠒⠒⠒⠒⠋ ");

          		$finish;
		    end
        end
        @(negedge clk);
		cnt = cnt + 1;
    end

	if(out_valid === 1||out_data !== 0)begin
      $display("out_valid exceed %d", indata_times);
      $finish;
    end

end
endtask


always@(negedge clk) begin
	if(out_valid === 0 && out_data !== 0) begin
		$display("Error: out_data should be 0 when out_valid is 0");
		$finish;
	end
end

always @(*) begin
    if(out_valid === 1 && in_valid === 1)begin
        $display("in_valid out_valid overlap");
        $finish;
    end
end

task PASS_task; begin
    $display("\033[1;33m                `oo+oy+`                            \033[1;35m Congratulation!!! \033[1;0m                                   ");
    $display("\033[1;33m               /h/----+y        `+++++:             \033[1;35m PASS This Lab........Maybe \033[1;0m                          ");
    $display("\033[1;33m             .y------:m/+ydoo+:y:---:+o             \033[1;35m Total Latency : %-10d\033[1;0m                                ", total_latency);
    $display("\033[1;33m              o+------/y--::::::+oso+:/y                                                                                     ");
    $display("\033[1;33m              s/-----:/:----------:+ooy+-                                                                                    ");
    $display("\033[1;33m             /o----------------/yhyo/::/o+/:-.`                                                                              ");
    $display("\033[1;33m            `ys----------------:::--------:::+yyo+                                                                           ");
    $display("\033[1;33m            .d/:-------------------:--------/--/hos/                                                                         ");
    $display("\033[1;33m            y/-------------------::ds------:s:/-:sy-                                                                         ");
    $display("\033[1;33m           +y--------------------::os:-----:ssm/o+`                                                                          ");
    $display("\033[1;33m          `d:-----------------------:-----/+o++yNNmms                                                                        ");
    $display("\033[1;33m           /y-----------------------------------hMMMMN.                                                                      ");
    $display("\033[1;33m           o+---------------------://:----------:odmdy/+.                                                                    ");
    $display("\033[1;33m           o+---------------------::y:------------::+o-/h                                                                    ");
    $display("\033[1;33m           :y-----------------------+s:------------/h:-:d                                                                    ");
    $display("\033[1;33m           `m/-----------------------+y/---------:oy:--/y                                                                    ");
    $display("\033[1;33m            /h------------------------:os++/:::/+o/:--:h-                                                                    ");
    $display("\033[1;33m         `:+ym--------------------------://++++o/:---:h/                                                                     ");
    $display("\033[1;31m        `hhhhhoooo++oo+/:\033[1;33m--------------------:oo----\033[1;31m+dd+                                                 ");
    $display("\033[1;31m         shyyyhhhhhhhhhhhso/:\033[1;33m---------------:+/---\033[1;31m/ydyyhs:`                                              ");
    $display("\033[1;31m         .mhyyyyyyhhhdddhhhhhs+:\033[1;33m----------------\033[1;31m:sdmhyyyyyyo:                                            ");
    $display("\033[1;31m        `hhdhhyyyyhhhhhddddhyyyyyo++/:\033[1;33m--------\033[1;31m:odmyhmhhyyyyhy                                            ");
    $display("\033[1;31m        -dyyhhyyyyyyhdhyhhddhhyyyyyhhhs+/::\033[1;33m-\033[1;31m:ohdmhdhhhdmdhdmy:                                           ");
    $display("\033[1;31m         hhdhyyyyyyyyyddyyyyhdddhhyyyyyhhhyyhdhdyyhyys+ossyhssy:-`                                                           ");
    $display("\033[1;31m         `Ndyyyyyyyyyyymdyyyyyyyhddddhhhyhhhhhhhhy+/:\033[1;33m-------::/+o++++-`                                            ");
    $display("\033[1;31m          dyyyyyyyyyyyyhNyydyyyyyyyyyyhhhhyyhhy+/\033[1;33m------------------:/ooo:`                                         ");
    $display("\033[1;31m         :myyyyyyyyyyyyyNyhmhhhyyyyyhdhyyyhho/\033[1;33m-------------------------:+o/`                                       ");
    $display("\033[1;31m        /dyyyyyyyyyyyyyyddmmhyyyyyyhhyyyhh+:\033[1;33m-----------------------------:+s-                                      ");
    $display("\033[1;31m      +dyyyyyyyyyyyyyyydmyyyyyyyyyyyyyds:\033[1;33m---------------------------------:s+                                      ");
    $display("\033[1;31m      -ddhhyyyyyyyyyyyyyddyyyyyyyyyyyhd+\033[1;33m------------------------------------:oo              `-++o+:.`             ");
    $display("\033[1;31m       `/dhshdhyyyyyyyyyhdyyyyyyyyyydh:\033[1;33m---------------------------------------s/            -o/://:/+s             ");
    $display("\033[1;31m         os-:/oyhhhhyyyydhyyyyyyyyyds:\033[1;33m----------------------------------------:h:--.`      `y:------+os            ");
    $display("\033[1;33m         h+-----\033[1;31m:/+oosshdyyyyyyyyhds\033[1;33m-------------------------------------------+h//o+s+-.` :o-------s/y  ");
    $display("\033[1;33m         m:------------\033[1;31mdyyyyyyyyymo\033[1;33m--------------------------------------------oh----:://++oo------:s/d  ");
    $display("\033[1;33m        `N/-----------+\033[1;31mmyyyyyyyydo\033[1;33m---------------------------------------------sy---------:/s------+o/d  ");
    $display("\033[1;33m        .m-----------:d\033[1;31mhhyyyyyyd+\033[1;33m----------------------------------------------y+-----------+:-----oo/h  ");
    $display("\033[1;33m        +s-----------+N\033[1;31mhmyyyyhd/\033[1;33m----------------------------------------------:h:-----------::-----+o/m  ");
    $display("\033[1;33m        h/----------:d/\033[1;31mmmhyyhh:\033[1;33m-----------------------------------------------oo-------------------+o/h  ");
    $display("\033[1;33m       `y-----------so /\033[1;31mNhydh:\033[1;33m-----------------------------------------------/h:-------------------:soo  ");
    $display("\033[1;33m    `.:+o:---------+h   \033[1;31mmddhhh/:\033[1;33m---------------:/osssssoo+/::---------------+d+//++///::+++//::::::/y+`  ");
    $display("\033[1;33m   -s+/::/--------+d.   \033[1;31mohso+/+y/:\033[1;33m-----------:yo+/:-----:/oooo/:----------:+s//::-.....--:://////+/:`    ");
    $display("\033[1;33m   s/------------/y`           `/oo:--------:y/-------------:/oo+:------:/s:                                                 ");
    $display("\033[1;33m   o+:--------::++`              `:so/:-----s+-----------------:oy+:--:+s/``````                                             ");
    $display("\033[1;33m    :+o++///+oo/.                   .+o+::--os-------------------:oy+oo:`/o+++++o-                                           ");
    $display("\033[1;33m       .---.`                          -+oo/:yo:-------------------:oy-:h/:---:+oyo                                          ");
    $display("\033[1;33m                                          `:+omy/---------------------+h:----:y+//so                                         ");
    $display("\033[1;33m                                              `-ys:-------------------+s-----+s///om                                         ");
    $display("\033[1;33m                                                 -os+::---------------/y-----ho///om                                         ");
    $display("\033[1;33m                                                    -+oo//:-----------:h-----h+///+d                                         ");
    $display("\033[1;33m                                                       `-oyy+:---------s:----s/////y                                         ");
    $display("\033[1;33m                                                           `-/o+::-----:+----oo///+s                                         ");
    $display("\033[1;33m                                                               ./+o+::-------:y///s:                                         ");
    $display("\033[1;33m                                                                   ./+oo/-----oo/+h                                          ");
    $display("\033[1;33m                                                                       `://++++syo`                                          ");
    $display("\033[1;0m"); 
    repeat(5) @(negedge clk);
    $finish;
end endtask

task cal_task;begin
	for(i = 0; i < in_T[in_T_type]; i = i + 1) begin
		for(j = 0; j < 8; j = j + 1) begin
			Q[i][j] = indata[i][0]*in_w_Q[0][j] + indata[i][1]*in_w_Q[1][j] + indata[i][2]*in_w_Q[2][j] + indata[i][3]*in_w_Q[3][j] + indata[i][4]*in_w_Q[4][j] + indata[i][5]*in_w_Q[5][j] + indata[i][6]*in_w_Q[6][j] + indata[i][7]*in_w_Q[7][j];
			K[i][j] = indata[i][0]*in_w_K[0][j] + indata[i][1]*in_w_K[1][j] + indata[i][2]*in_w_K[2][j] + indata[i][3]*in_w_K[3][j] + indata[i][4]*in_w_K[4][j] + indata[i][5]*in_w_K[5][j] + indata[i][6]*in_w_K[6][j] + indata[i][7]*in_w_K[7][j];
			V[i][j] = indata[i][0]*in_w_V[0][j] + indata[i][1]*in_w_V[1][j] + indata[i][2]*in_w_V[2][j] + indata[i][3]*in_w_V[3][j] + indata[i][4]*in_w_V[4][j] + indata[i][5]*in_w_V[5][j] + indata[i][6]*in_w_V[6][j] + indata[i][7]*in_w_V[7][j];
		end
	end
	for(i = 0; i < in_T[in_T_type]; i = i + 1) begin
		for(j = 0; j < in_T[in_T_type]; j = j + 1) begin
			A[i][j] = (Q[i][0]*K[j][0] + Q[i][1]*K[j][1] + Q[i][2]*K[j][2] + Q[i][3]*K[j][3] + Q[i][4]*K[j][4] + Q[i][5]*K[j][5] + Q[i][6]*K[j][6] + Q[i][7]*K[j][7])/3;
			A[i][j] = (A[i][j] > 0) ? A[i][j] : 0;
		end
	end
	for(i = 0; i < in_T[in_T_type]; i = i + 1) begin
		for(j = 0; j < 8; j = j + 1) begin
			outdata[i][j] = A[i][0]*V[0][j] + ((in_T_type == 0) ? 0 : (A[i][1]*V[1][j])) + ((in_T_type == 0) ? 0 : (A[i][2]*V[2][j])) + ((in_T_type == 0) ? 0 : (A[i][3]*V[3][j])) + ((in_T_type != 2) ? 0 : (A[i][4]*V[4][j])) + ((in_T_type != 2) ? 0 : (A[i][5]*V[5][j])) + ((in_T_type != 2) ? 0 : (A[i][6]*V[6][j])) + ((in_T_type != 2) ? 0 : (A[i][7]*V[7][j]));
		end
	end
end
endtask


endmodule
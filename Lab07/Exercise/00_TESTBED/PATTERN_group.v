`ifdef RTL
	`define CYCLE_TIME_clk1 47.1  
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
// wire & registers 
//================================================================
reg [10:0] cnt;
reg [2:0] row[0:5][0:5];
reg [2:0] kernel[0:5][0:3];

reg [7:0] ans[0:149];

//================================================================
// clock
//================================================================
always #(`CYCLE_TIME_clk1/2.0) clk1 = ~clk1;
initial	clk1 = 0;
always #(`CYCLE_TIME_clk2/2.0) clk2 = ~clk2;
initial	clk2 = 0;


//================================================================
// parameters & integer
//================================================================

parameter PAT_NUM=10000;


integer i,j,k,debug,i_pat,latency, total_latency;



//================================================================
// task
//================================================================

always @(posedge clk1) begin
    if(out_valid===0)begin
        if(out_data!==0)begin
            $display("out should be 0 when out_valid is low");
            $finish;
        end
    end
end

always @(*) begin
    if(out_valid===1&&in_valid===1)begin
        $display("in_valid out_valid overlap");
            $finish;
    end
end

initial begin

    reset_signal_task;

    i_pat = 0;
    total_latency = 0;


	
    for (i_pat = 1; i_pat <= PAT_NUM; i_pat = i_pat + 1) begin
 
        input_task;

        cal_task;

        check_ans_task;
        
        $display("%0sPASS PATTERN NO.%4d %0sCycles: %3d%0s",txt_blue_prefix, i_pat, txt_green_prefix, latency, reset_color);
        total_latency = total_latency + latency;
    end
    pass_task;
    $finish;

end


task display_data; begin
	debug = $fopen("../00_TESTBED/debug.txt", "w");
	$fwrite(debug, "[PAT NO. %4d]\n\n", i_pat);
	$fwrite(debug, "in_row: \n");
	for(i=0;i<6;i=i+1)begin
		$fwrite(debug, "%d %d %d %d %d %d\n", row[i][0], row[i][1], row[i][2], row[i][3], row[i][4], row[i][5]);
	end

	$fwrite(debug, "\nin_kernel: \n");
	for(i=0;i<6;i=i+1)begin
		$fwrite(debug, "%d %d \n%d %d\n\n", kernel[i][0], kernel[i][1], kernel[i][2], kernel[i][3]);
	end
	$fwrite(debug, "\n");
	$fwrite(debug, "ans\n");
	for(i=0;i<6;i=i+1)begin
		for(j=0;j<5;j=j+1)begin
			for(k=0;k<5;k++) begin
			$fwrite(debug, "%d ", ans[i*25+j*5+k]);
			end
			$fwrite(debug, "\n");
		end
		$fwrite(debug, "\n\n");
	end
end
endtask



task check_ans_task;begin
    cnt=0;
	latency=0;
    while(cnt<150)begin
		while(out_valid!==1)begin
			if(out_data!==0)begin
				$display("out should be zero");
				$finish;
			end
			@(negedge clk1);
			if(latency>=5000)begin
                display_data;
                $display("cycle exceed 5000");
                $finish;
            end
			latency=latency+1;		
		end
        
        if(out_valid===1)begin
            if(out_data!==ans[cnt])begin
				display_data;
                $display("        ⣀⣤⣤⣀");
                $display("⠀⠀⠀⠀⣠⠟⠁⠀⠀⠀⠀⠙⣆");
                $display("⠀⠀⠀⣴⠁⠀⠀⠀⠀⠀⠀⠀⠀⢷     \033[1;32m ================================================  \033[1;0m");
                $display("⠀⠀⠀⡇⠀⠀⡴⠀⠀⡴⠀⠀⠀⠀⡆    \033[1;31m The %dth output is not correct!!! \033[1;0m", cnt);
                $display("⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇    \033[1;32m Gold output is %1d \033[1;0m",ans[cnt]);
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
                $display("⢠⣿⣿⣿⣿⣿⣿⠀⡏ \033[0;31m|is   %4d  |\033[1;0m⣸",out_data);
                $display("⠀⠀⣿⣿⠀⠀⢿⣿⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠃");
                $display("⠀⠙⠁⠀⠀⠘⠋⠛⠒⠒⠒⠒⠒⠒⠒⠒⠒⠋ ");

          		$finish;
		    end
        end
        @(negedge clk1);
		latency=latency+1;
		cnt=cnt+1;
    end

	if(out_valid===1||out_data!==0)begin
      $display("out_valid exceed 150");
      $finish;
    end

end
endtask

task cal_task;begin
	for(i=0;i<6;i++) begin
		for(j=0;j<5;j++) begin
			for(k=0;k<5;k++) begin
				ans[i*25+j*5+k]=row[j][k]*kernel[i][0]+row[j][k+1]*kernel[i][1]+row[j+1][k]*kernel[i][2]+row[j+1][k+1]*kernel[i][3];
			end
		end
	end
end
endtask

task input_task; begin
    
    in_row ='dx;
    in_kernel = 'dx;
    in_valid=0;
    for(i=0;i<6;i=i+1)begin
        in_valid=1;
		in_row[17:15]=$urandom_range(0, 7);
		in_row[14:12]=$urandom_range(0, 7);
		in_row[11:9]=$urandom_range(0, 7);
		in_row[8:6]=$urandom_range(0, 7);
		in_row[5:3]=$urandom_range(0, 7);
		in_row[2:0]=$urandom_range(0, 7);
		in_kernel[11:9]=$urandom_range(0, 7);
		in_kernel[8:6]=$urandom_range(0, 7);
		in_kernel[5:3]=$urandom_range(0, 7);
		in_kernel[2:0]=$urandom_range(0, 7);
		row[i][0]=in_row[2:0];
		row[i][1]=in_row[5:3];
		row[i][2]=in_row[8:6];
		row[i][3]=in_row[11:9];
		row[i][4]=in_row[14:12];
		row[i][5]=in_row[17:15];
		kernel[i][0]=in_kernel[2:0];
		kernel[i][1]=in_kernel[5:3];
		kernel[i][2]=in_kernel[8:6];
		kernel[i][3]=in_kernel[11:9];


        @(negedge clk1);


    end
    in_valid=0;

    in_row='dx;
    in_kernel='dx;

end endtask 


task reset_signal_task; begin

    force clk1 = 0;
    force clk2 = 0;
    rst_n = 1;

    in_valid = 'd0;
    in_row = 'dx;
    in_kernel = 'dx;

    // tot_lat = 0;

    #(`CYCLE_TIME_clk1/2.0) rst_n = 0;
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
        repeat(5) #(`CYCLE_TIME_clk1);
        $finish;
    end
    #(`CYCLE_TIME_clk1/2.0) release clk1;
     release clk2;
     @(negedge clk1);
end endtask

task pass_task; begin
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
    repeat(5) @(negedge clk1);
    $finish;
end endtask

endmodule
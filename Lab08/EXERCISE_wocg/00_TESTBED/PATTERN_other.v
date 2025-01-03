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
`define CYCLE_TIME 50
`define PATNUM 10
`define SIMPLE 5

module PATTERN(
	// Output signals
	clk,
	rst_n,
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
output reg in_valid;
output reg [3:0] T;
output reg signed [7:0] in_data;
output reg signed [7:0] w_Q;
output reg signed [7:0] w_K;
output reg signed [7:0] w_V;

input out_valid;
input signed [63:0] out_data;


parameter PAT_NUM    = `PATNUM;
parameter SIMPLE_CASE= `SIMPLE;


//================================================================
// Clock
//================================================================
always	#(`CYCLE_TIME/2.0) clk = ~clk;
initial	clk = 0;

//================================================================
// parameters & integer
//================================================================
integer i,j,k,debug,i_pat,total_latency, latency;
integer delay1to3, ans_indx;
integer CYCLE=`CYCLE_TIME;
//================================================================
// Wire & Reg Declaration
//================================================================
reg signed [7:0]_data[7:0][7:0], _WQ[7:0][7:0], _WK[7:0][7:0], _WV[7:0][7:0];
reg signed [18:0] _Q[7:0][7:0], _K[7:0][7:0], _V[7:0][7:0], _K_T[7:0][7:0];
reg [3:0]_T;
reg signed [39:0]_QK[7:0][7:0], _SOFTMAX[7:0][7:0];

reg signed [56:0]_GOLDEN_ANS[7:0][7:0];


always @(posedge clk) begin
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
		
		wait_out_valid_task;
        check_ans_task;
        
        $display("PASS PATTERN NO.%4d", i_pat);
    end
    $display("Congratulations");
    $finish;
end

task gen_data_task;begin

	_T = $urandom()%3;
	if(_T==0)
		_T = 1;
	else if(_T==1)
		_T = 4;
	else
		_T = 8;

	if(i_pat < SIMPLE_CASE)begin
	$display ("_T = %d\n in_data is:\n", _T);
	for(i=0;i< _T ;i=i+1)begin
		for(j=0;j< 8 ;j=j+1)begin
			if(i_pat < SIMPLE_CASE)
				_data[i][j] = $random()%5;
			else
				_data[i][j] = $urandom();
			$write("%5d ", _data[i][j]);
		end
		$display();
	end

	$display ("wQ is:\n");
	for(i=0;i<8;i=i+1)begin
		for(j=0;j<8;j=j+1)begin
			if(i_pat < SIMPLE_CASE)
				_WQ[i][j] = $random()%5;
			else
				_WQ[i][j] = $urandom();
			$write("%5d ", _WQ[i][j]);
		end
		$display();
	end

	$display ("wK is:\n");
	for(i=0;i<8;i=i+1)begin
		for(j=0;j<8;j=j+1)begin
			if(i_pat < SIMPLE_CASE)
				_WK[i][j] = $random()%5;
			else
				_WK[i][j] = $urandom();
			$write("%5d ", _WK[i][j]);
		end
		$display();
	end

	$display ("wV is:\n");
	for(i=0;i<8;i=i+1)begin
		for(j=0;j<8;j=j+1)begin
			if(i_pat < SIMPLE_CASE)
				_WV[i][j] = $random()%5;
			else
				_WV[i][j] = $urandom();
			$write("%5d ", _WV[i][j]);
		end
		$display();
	end
	end

	//$display("MatMulti1: \n");
	//for(i=0;i<_T;i=i+1)begin
	//	for(j=0;j<8;j=j+1)begin
	//		_Q[i][j] = _data[i][];
	//		$write("%5d ", _WV[i][j]);
	//	end
	//	$display();
	//end

	// Initialize result matrix to zero
	for (i = 0; i < 8; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			_Q[i][j] = 0;
		end
	end
	$display("_Q: \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			for (k = 0; k < 8; k = k + 1) begin
				_Q[i][j] = _Q[i][j] + _data[i][k] * _WQ[k][j];
			end
			$write("%7d ", _Q[i][j]);
		end		
		$display();
	end
	// Initialize result matrix to zero
	for (i = 0; i < 8; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			_K[i][j] = 0;
		end
	end
	$display("_K: \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			for (k = 0; k < 8; k = k + 1) begin
				_K[i][j] = _K[i][j] + _data[i][k] * _WK[k][j];
			end
			$write("%7d ", _K[i][j]);
		end		
		$display();
	end
	
	// Initialize result matrix to zero
	for (i = 0; i < 8; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			_V[i][j] = 0;
		end
	end
	$display("_V: \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			for (k = 0; k < 8; k = k + 1) begin
				_V[i][j] = _V[i][j] + _data[i][k] * _WV[k][j];
			end
			$write("%7d ", _V[i][j]);
		end		
		$display();
	end
	

	$display("_K_T : \n");
	for(i=0;i<8;i=i+1)begin
		for(j=0;j<_T;j=j+1)begin
			_K_T[i][j] = _K[j][i];			
			$write("%7d ", _K_T[i][j]);
		end
		$display();
	end

	// Initialize result matrix to zero
	for (i = 0; i < 8; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			_QK[i][j] = 0;
		end
	end
	$display("_QKt: \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < _T; j = j + 1) begin
			for (k = 0; k < 8; k = k + 1) begin
				_QK[i][j] = _QK[i][j] + _Q[i][k] * _K_T[k][j];
			end
			$write("%15d ", _QK[i][j]);
		end		
		$display();
	end


	$display("_SOFTMAX: \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < _T; j = j + 1) begin
			for (k = 0; k < 8; k = k + 1) begin
				if(_QK[i][j]>0)
					_SOFTMAX[i][j] = _QK[i][j] / $signed(3'b011);
				else
					_SOFTMAX[i][j] = 40'd0;
			end
			$write("%15d ", _SOFTMAX[i][j]);
		end		
		$display();
	end

	// Initialize result matrix to zero
	for (i = 0; i < 8; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			_GOLDEN_ANS[i][j] = 0;
		end
	end
	$display("_GOLDEN_ANS : \n");
	// Perform matrix multiplication
	for (i = 0; i < _T; i = i + 1) begin
		for (j = 0; j < 8; j = j + 1) begin
			for (k = 0; k < _T; k = k + 1) begin
				_GOLDEN_ANS[i][j] = _GOLDEN_ANS[i][j] + _SOFTMAX[i][k] * _V[k][j];;
			end
			$write("%15d ", _GOLDEN_ANS[i][j]);
		end		
		$display();
	end


end endtask

task input_task; begin    
	delay1to3 = $urandom()%4+2;
	repeat(delay1to3) @(negedge clk);

	in_valid=1;
    for(i=0;i<192;i=i+1)begin
		if(i==0)
			T = _T;
		else
			T = 'dx;

		if(i<_T*8)
			in_data = _data[i/8][i%8];
		else
			in_data = 'dx;

		
		if(i<64)
			w_Q = _WQ[i/8][i%8];
		else
			w_Q = 'dx;

		if(i>=64 && i<128)
			w_K = _WK[(i-64)/8][(i-64)%8];
		else
			w_K = 'dx;
		
		if(i>=128)
			w_V = _WV[(i-128)/8][(i-128)%8];
		else
			w_V = 'dx;
		@(negedge clk);
    end

    in_valid  = 0;

	//$display("input_finish!!");
	//@(negedge clk1);
    //$finish;
	//repeat(300) @(negedge clk);
end endtask 

task wait_out_valid_task; begin
	//while (out_valid !== 1'b1) begin

	latency = 0;
	while (out_valid !== 1'b1) begin
            latency = latency + 1;

            if (latency == 2000) begin
                $display("********************************************************");     
				//$display("                    SPEC-6 FAIL                   ");
                $display("*  The execution latency exceeded 200 cycles at %8t   *", $time);
                $display("********************************************************");
                repeat (2) @(negedge clk);
                $finish;
            end
            @(negedge clk);
        end
        total_latency = total_latency + latency;
end endtask

task check_ans_task; begin
	ans_indx = 0;

	while(ans_indx < _T*8 && out_valid===1)begin
		if(out_data !== _GOLDEN_ANS[ans_indx/8][ans_indx%8])begin
			$display("ans_wrong");
			$display("golden_ans:%17d",_GOLDEN_ANS[ans_indx/8][ans_indx%8]);
			$display("your_ans:  %17d",out_data);
        	$finish;
		end
		
        @(negedge clk);
		ans_indx = ans_indx+1;
	end

end endtask


task reset_signal_task; begin

    force clk = 0;
    rst_n = 1;

    in_valid = 'dx;
    T = 'dx;
    in_data = 'dx;
	w_Q = 'dx;
	w_K = 'dx;
	w_V = 'dx;
    // cg_en = 0;

    #(CYCLE/2.0) 
	rst_n = 0;
	
    in_valid = 0;
    #(CYCLE) 
	rst_n = 1;
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
        repeat(2) #(CYCLE);
        $finish;
    end
    #(CYCLE) release clk;
    @(negedge clk);
end endtask

endmodule

// `include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype.sv"

`define CYCLE_TIME 5.5
`define PATNUM 1000 

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;

//======================================
//      PARAMETERS & VARIABLES
//======================================
//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Can be modified by user
integer TOTAL_PATNUM = `PATNUM; 
// -------------------------------------
// [Mode]
//      0 : generate dram.dat
//      1 : validate design
integer PATTERN_MODE = 1;
//      0 : close debug
//      1 : open debug
integer DEBUG_MODE = 0;
// -------------------------------------
integer   SEED = 5487;
parameter DRAMDAT_TO_GENERATED = "../00_TESTBED/DRAM/dram.dat";
parameter DRAMDAT_FROM_DRAM = "../00_TESTBED/DRAM/dram.dat"; 
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


//================================================================
// Clock
//================================================================
real CYCLE = `CYCLE_TIME;

//================================================================
// parameters & integer
//================================================================
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
parameter MAX_CYCLE=1000;
// ---------------------------------------------------------------
integer i,j,k;

integer i_pat;
integer latency;
integer total_latency;

integer count_input, delay_2to4, out_num, delay_1to4;
integer hold_or_not;
integer debug;
integer operation;

parameter integer MODE[3] = {Insensitive,Normal,Sensitive};

// cal_update_task
integer _day;
integer _month;
integer _index_A;
integer _index_B;
integer _index_C;
integer _index_D;
logic signed [11:0] _var_IA;
logic signed [11:0] _var_IB;
logic signed [11:0] _var_IC;
logic signed [11:0] _var_ID;
integer _var_A;
integer _var_B;
integer _var_C;
integer _var_D;
logic _warn_flag;
// cal_index_check_task
integer _g_A;
integer _g_B;
integer _g_C;
integer _g_D;
integer _n0;
integer _n1;
integer _n2;
integer _result;
//================================================================
// wire & registers 
//================================================================
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 107FF ~ 10000
// generate DRAM
logic [11:0] index_A;
logic [11:0] index_B;
logic [11:0] index_C;
logic [11:0] index_D;
// output
logic complete;

// for pattern golden calculation
Action action;
Formula_Type formula;
Mode mode;
Date month_day;
Data_No data_number;
Index [0:3] index_ABCD;
Warn_Msg warning;


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
// Initial
//================================================================
initial begin
    case(PATTERN_MODE)
        'd0: generate_dram_task;
        'd1: validation_task;
        default: begin
            $display("[ERROR] [PARAMETER] Mode isn't valid...");
            $finish;
        end
    endcase
end 
//================================================================
// Tasks
//================================================================
// ===============================================================
//                       Validation task 
// ===============================================================
task validation_task;begin
    // Load DRAM data
    load_dram_task;

    // Initialize signals
    reset_task;
    // Iterate through each pattern
    for (i_pat = 0; i_pat < TOTAL_PATNUM; i_pat = i_pat + 1) 
    begin
        operation = $urandom() % 3;
        // operation = Index_Check;  
        input_task;
        cal_task;

        if(DEBUG_MODE)
            display_task;
        wait_out_valid_task;
        check_ans_task;
        $display("%0sPASS PATTERN NO.%4d %0sCycles: %3d | %0sDRAM address: %3d, MODE: %s %0s",txt_blue_prefix, i_pat, txt_green_prefix, latency, txt_yellow_prefix,data_number, action, reset_color);
    end 
 
    YOU_PASS_task;

    $finish; 

end endtask

// ===============================================================
//                      Calculate task 
// ===============================================================
task cal_task; begin
    if(operation == 0)
        cal_index_check_task;
    else if(operation == 1)
        cal_update_task;
    else
        cal_check_validate_date_task;
    
    // output
    if(warning == No_Warn)
        complete = 1;
    else
        complete = 0;
end endtask

// ----- calculate update task -----
task cal_update_task; begin
    // 1. get dram efficient data 
    _day     = golden_DRAM [65536+data_number*8];       // Early trading date (DRAM)
    _month   = golden_DRAM [65536+data_number*8 + 4];  
    _index_D = {golden_DRAM [65536+data_number*8 + 2][3:0], golden_DRAM [65536+data_number*8 + 1]};
    _index_C = {golden_DRAM [65536+data_number*8 + 3], golden_DRAM [65536+data_number*8 + 2][7:4]};
    _index_B = {golden_DRAM [65536+data_number*8 + 6][3:0], golden_DRAM [65536+data_number*8 + 5]};
    _index_A = {golden_DRAM [65536+data_number*8 + 7], golden_DRAM [65536+data_number*8 + 6][7:4]};

    // 2. change range from 0~4095 -> -2048~2047
    // index_ABCD range(-2048~2047)
    _var_IA = index_ABCD[0];
    _var_IB = index_ABCD[1];
    _var_IC = index_ABCD[2];
    _var_ID = index_ABCD[3];
    // do index variation
    _warn_flag = 0;
    // variation A
    _var_A = _index_A + _var_IA;
    if(_var_A > 4095) begin
        _var_A = 4095;
        _warn_flag = 1;
    end
    else if(_var_A < 0) begin
        _var_A = 0;
        _warn_flag = 1;
    end
    // variation B
    _var_B = _index_B + _var_IB;
    if(_var_B > 4095) begin
        _var_B = 4095;
        _warn_flag = 1;
    end
    else if(_var_B < 0) begin
        _var_B = 0;
        _warn_flag = 1;
    end
    // variation C  
    _var_C = _index_C + _var_IC;
    if(_var_C > 4095) begin
        _var_C = 4095;
        _warn_flag = 1;
    end
    else if(_var_C < 0) begin
        _var_C = 0;
        _warn_flag = 1;
    end
    // variation D
    _var_D = _index_D + _var_ID;
    if(_var_D > 4095) begin
        _var_D = 4095;
        _warn_flag = 1;
    end
    else if(_var_D < 0) begin
        _var_D = 0;
        _warn_flag = 1;
    end
    
    // 3. store back to dram
    golden_DRAM [65536+data_number*8]     = month_day.D;       
    golden_DRAM [65536+data_number*8 + 4] = month_day.M;  

    golden_DRAM [65536+data_number*8 + 1] = _var_D[7:0];                        // indexD
    golden_DRAM [65536+data_number*8 + 2] = {_var_C[3:0], _var_D[11:8]};        // indexDC
    golden_DRAM [65536+data_number*8 + 3] = _var_C[11:4];                       // indexC
    golden_DRAM [65536+data_number*8 + 5] = _var_B[7:0];                        // indexB
    golden_DRAM [65536+data_number*8 + 6] = {_var_A[3:0], _var_B[11:8]};        // indexBA
    golden_DRAM [65536+data_number*8 + 7] = _var_A[11:4];                       // indexA

    // 4. Date warning check (today date < dram date ... date warn)
    if(_warn_flag)
        warning = Data_Warn;
    else
        warning = No_Warn;
end endtask

// ----- calculate Index check task -----
task cal_check_validate_date_task; begin 
    // get dram efficient data 
    _day     = golden_DRAM [65536+data_number*8];       // Early trading date (DRAM)
    _month   = golden_DRAM [65536+data_number*8 + 4];  
    // Date warning check (today date < dram date ... date warn)
    if(month_day.M < _month)
        warning = Date_Warn; 
    else if(month_day.M == _month && month_day.D < _day)
        warning = Date_Warn;
    else
        warning = No_Warn; 
end endtask

// ----- calculate Index check task -----
task cal_index_check_task; begin
    // range : golden_DRAM [((65536+data_number*8)+7):(65536+data_number*8)];  
    // get dram efficient data
    _day     = golden_DRAM [65536+data_number*8];       // Early trading date (DRAM)
    _month   = golden_DRAM [65536+data_number*8 + 4];  
    _index_D = {golden_DRAM [65536+data_number*8 + 2][3:0], golden_DRAM [65536+data_number*8 + 1]};
    _index_C = {golden_DRAM [65536+data_number*8 + 3], golden_DRAM [65536+data_number*8 + 2][7:4]};
    _index_B = {golden_DRAM [65536+data_number*8 + 6][3:0], golden_DRAM [65536+data_number*8 + 5]};
    _index_A = {golden_DRAM [65536+data_number*8 + 7], golden_DRAM [65536+data_number*8 + 6][7:4]};

    // G(A) = |I(A) - T(A)| : get absolute difference
    // index_ABCD range(0~4095)
    _g_A     = (_index_A > index_ABCD[0]) ? _index_A - index_ABCD[0] : index_ABCD[0] - _index_A;
    _g_B     = (_index_B > index_ABCD[1]) ? _index_B - index_ABCD[1] : index_ABCD[1] - _index_B;
    _g_C     = (_index_C > index_ABCD[2]) ? _index_C - index_ABCD[2] : index_ABCD[2] - _index_C;
    _g_D     = (_index_D > index_ABCD[3]) ? _index_D - index_ABCD[3] : index_ABCD[3] - _index_D;

    // formula calculation
    case(formula)
    Formula_A : _result = (_index_A+_index_B+_index_C+_index_D) / 4;
    Formula_B : _result = sort(_index_A,_index_B,_index_C,_index_D,3) - sort(_index_A,_index_B,_index_C,_index_D,0);
    Formula_C : _result = sort(_index_A,_index_B,_index_C,_index_D,0);
    Formula_D : _result = (_index_A >= 2047) + (_index_B >= 2047) + (_index_C >= 2047) + (_index_D >= 2047);
    Formula_E : _result = (_index_A >= index_ABCD[0]) + (_index_B >= index_ABCD[1]) + (_index_C >= index_ABCD[2]) + (_index_D >= index_ABCD[3]);
    Formula_F : _result = (_g_A + _g_B + _g_C + _g_D - sort(_g_A, _g_B, _g_C, _g_D,3))/3;
    Formula_G : _result = sort(_g_A, _g_B, _g_C, _g_D,0)/2 + sort(_g_A, _g_B, _g_C, _g_D,1)/4 + sort(_g_A, _g_B, _g_C, _g_D,2)/4; 
    Formula_H : _result = (_g_A + _g_B + _g_C + _g_D)/4;
    default: _result = 0;
    endcase


    // Date warning check (today date < dram date ... date warn)
    if(month_day.M < _month)
        warning = Date_Warn; 
    else if(month_day.M == _month && month_day.D < _day)
        warning = Date_Warn;
    else
        warning = No_Warn; 

    // Risk warning check
    if(warning == No_Warn) begin    //Date warning triger skip risk warning check
        case(formula)
        Formula_A, Formula_C : 
            if(mode == Insensitive)
                warning = (_result >= 2047) ? Risk_Warn : No_Warn;
            else if (mode == Normal)
                warning = (_result >= 1023) ? Risk_Warn : No_Warn;
            else
                warning = (_result >= 511) ? Risk_Warn : No_Warn;
        Formula_B, Formula_F, Formula_G, Formula_H :
            if(mode == Insensitive)
                warning = (_result >= 800) ? Risk_Warn : No_Warn;
            else if (mode == Normal)
                warning = (_result >= 400) ? Risk_Warn : No_Warn;
            else
                warning = (_result >= 200) ? Risk_Warn : No_Warn;
        Formula_D, Formula_E :
            if(mode == Insensitive)
                warning = (_result >= 3) ? Risk_Warn : No_Warn;
            else if (mode == Normal)
                warning = (_result >= 2) ? Risk_Warn : No_Warn;
            else
                warning = (_result >= 1) ? Risk_Warn : No_Warn;
        default: warning = No_Warn;
        endcase
    end
end endtask

// function find min, max
// mode0: min
// mode1: med1
// mode2: med2
// mode3: max
function automatic logic [11:0] sort(logic [11:0] I_A, logic [11:0] I_B, logic [11:0] I_C, logic [11:0] I_D, integer mode);
    logic [11:0] result;
    logic [11:0] n1, n2, n3, n4, n5, n6;
    logic [11:0] min1,min2,min3,min4;

    n1 = (I_A < I_B) ? I_A : I_B;  
    n2 = (I_A < I_B) ? I_B : I_A;  
    n3 = (I_C < I_D) ? I_C : I_D;  
    n4 = (I_C < I_D) ? I_D : I_C;  
    min1 = (n1 < n3) ? n1 : n3;
    n5 = (n1 < n3) ? n3 : n1;
    min4 = (n2 > n4) ? n2 : n4;
    n6 = (n2 > n4) ? n4 : n2;
    min2 = (n5 < n6) ? n5 : n6;
    min3 = (n5 < n6) ? n6 : n5;

    // $display("%d %d %d %d", min1,min2,min3,min4);

    if(mode == 0)
        result = min1;
    else if(mode == 1)
        result = min2;
    else if(mode == 2)
        result = min3;
    else
        result = min4;

    return result;
endfunction


// ===============================================================
//                      Load DRAM task 
// ===============================================================
task load_dram_task;
    integer file;
    integer status;
    integer dat;
    integer cnt;
begin
    // environment
    $display("[Info] Start to read dram.dat");
    file = $fopen(DRAMDAT_FROM_DRAM, "r");
    $display("DRAM data position = %s", DRAMDAT_FROM_DRAM);
    if (file == 0) begin
        $display("[ERROR] [FILE] The file (%0s) can't be opened", DRAMDAT_FROM_DRAM);
        $finish;
    end
    // Start Read
    cnt = 65536;

    while(!$feof(file))begin
        // Address
        status = $fscanf(file, "@%h",dat);
        
        status = $fscanf(file, "%2h",dat);
        if(status == 1) begin
            golden_DRAM[cnt] = dat;        
            cnt = cnt + 1;
        end
    end
    $fclose(file);
    $display("[Info] Finish to read dram.dat");
end endtask
// ===============================================================
//                      Generate DRAM task 
// ===============================================================
task generate_dram_task;
    integer file;
    integer dram_data_no;
begin
    // enviroment
    $display("[Info] Start to generate dram.dat");
    file = $fopen(DRAMDAT_TO_GENERATED, "w");
    if (file == 0) begin
        $display("[ERROR] [FILE] The file (%0s) can't be opened", DRAMDAT_TO_GENERATED);
        $finish;
    end

    for(dram_data_no=0 ; dram_data_no<256*2 ; dram_data_no=dram_data_no+2) begin
        // create Date{Month, Day}
        void'(date_rand.randomize());
        month_day = date_rand.date;
        // create index A B C D
        generate_dram_index_task;
        // ==== Write DRAM ====
        // day-> index D -> index C
        $fwrite(file, "@%-5h\n",20'h10000+dram_data_no*4);
        $fwrite(file, "%02h ", month_day.D);
        $fwrite(file, "%02h ", index_D[7:0]);
        $fwrite(file, "%02h ", {index_C[3:0], index_D[11:8]});
        $fwrite(file, "%02h ", index_C[11:4]);
        $fwrite(file, "\n");
        // Month -> Index B -> Index A
        $fwrite(file, "@%-5h\n",20'h10000+(dram_data_no+1)*4);
        $fwrite(file, "%02h ", month_day.M);
        $fwrite(file, "%02h ", index_B[7:0]);
        $fwrite(file, "%02h ", {index_A[3:0], index_B[11:8]});
        $fwrite(file, "%02h ", index_A[11:4]);
        $fwrite(file, "\n");

        // $display("IndexA: %3h, IndexB: %3h, IndexC: %3h, IndexD: %3h",index_A, index_B, index_C, index_D);
    end
    $fclose(file);
    $display("[Info] Generate dram.dat Finished!");
    $finish;
end endtask
// generate dram index task
task generate_dram_index_task;begin
    index_A = $urandom() % 4096;
    index_B = $urandom() % 4096;
    index_C = $urandom() % 4096;
    index_D = $urandom() % 4096;
end endtask


// ===============================================================
//                          Input task 
// ===============================================================
task input_task; begin
    if(operation == 0)
        index_check_task;
    else if(operation == 1)
        update_task;
    else
        check_validate_date_task;
end endtask

// ----- Index check task -----
task index_check_task; begin
    // 1. action
	inf.D.d_act[0] = Index_Check;   // D.dact
    action = Index_Check;
    action_valid_task;
    // 2. formula
    formula_valid_task;
    // 3. mode
    mode_valid_task;
    // 4. Today's date
    date_valid_task;
    // 5. No. data in DRAM  
    data_no_valid_task;
    // 6. Index A,B,C,D 4 cycles
    index_valid_task;
end endtask

// ----- Update task -----
task update_task; begin
	// 1. action
    inf.D.d_act[0] = Update;        // D.dact
    action = Update;
	action_valid_task;
    // 2. Today's date
    date_valid_task;
    // 3. No. data in DRAM  
    data_no_valid_task;
    // 4. Index A,B,C,D 4 cycles
    index_valid_task;

end endtask
// ----- Check validate date task -----
task check_validate_date_task; begin
	// 1. action
    inf.D.d_act[0] = Check_Valid_Date;  // D.dact
    action = Check_Valid_Date;
	action_valid_task;
    // 2. Today's date
    date_valid_task;
    // 3. No. data in DRAM  
    data_no_valid_task;
end endtask

///////////////////////////////////////
///////////////////////////////////////
///////////////////////////////////////

// action_valid task (no data)
task action_valid_task; begin
	inf.sel_action_valid = 1'b1;
    @(negedge clk);
    inf.sel_action_valid = 1'b0;
    inf.D.d_act[0] = 'x;
    delay_task;
end endtask

// formula_valid task
task formula_valid_task; begin
	inf.formula_valid = 1'b1;
    inf.D.d_formula[0] = $urandom() % 8;    // 0~7

    formula = inf.D.d_formula[0];
    // formula = Formula_G; 


    @(negedge clk);
    inf.formula_valid = 1'b0;
    inf.D.d_formula[0] = 'x;    
    delay_task;
end endtask

// mode_valid task
task mode_valid_task; begin
	inf.mode_valid = 1'b1;
    inf.D.d_mode[0] = MODE[$urandom() % 3];

    mode = inf.D.d_mode[0]; 
    // mode = Normal;


    @(negedge clk);
    inf.mode_valid = 1'b0;
    inf.D.d_mode[0] = 'x;
    delay_task;
end endtask

// date_valid task
class rand_date;
    randc Date date;
    constraint date_constraint {
        date.M inside {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
        // 31 day month
        (date.M == 1 || date.M == 3 || date.M == 5 || date.M == 7 || date.M == 8 || date.M == 10 || date.M == 12)  
        -> date.D inside {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
        // 30 day month
        (date.M == 4 || date.M == 6 || date.M == 9 || date.M == 11)  
        -> date.D inside {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30};
        // Feb.
        (date.M == 2)  -> date.D inside {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28};
    }
endclass
rand_date date_rand = new();

task date_valid_task; begin
	inf.date_valid = 1'b1;
    void'(date_rand.randomize());
    inf.D.d_date[0] = date_rand.date;
    month_day = inf.D.d_date[0];
    @(negedge clk);
    inf.date_valid = 1'b0;
    inf.D.d_date[0] = 'x;
    delay_task;
end endtask
// data_no_valid task
task data_no_valid_task; begin
	inf.data_no_valid = 1'b1;
    inf.D.d_data_no[0] = $urandom() % 256;

    data_number = inf.D.d_data_no[0];
    // data_number = 66;

    @(negedge clk);
    inf.data_no_valid = 1'b0;
    inf.D.d_data_no[0] = 'x;
    if(action != Check_Valid_Date)
        delay_task;
end endtask

// index_valid task
task index_valid_task; begin
	for(i=0;i<4;i=i+1) begin
        hold_or_not = $urandom() % 2;
        inf.index_valid = 1'b1;
        inf.D.d_index[0] = $urandom() % 4096;
        index_ABCD[i] = inf.D.d_index[0];
        if(hold_or_not)
            @(negedge clk);
        else begin
            @(negedge clk);
            inf.index_valid = 1'b0;
            inf.D.d_index[0] = 'x; 
            if(i<3)
                delay_task;
        end
    end
    inf.index_valid = 1'b0;
    inf.D.d_index[0] = 'x; 
end endtask

// delay task
task delay_task; begin
	delay_1to4 = $urandom() % 4 + 1;		
    repeat (delay_1to4) @(negedge clk);   ////delay for 1-4 
end endtask

// ===============================================================
//                      Wait out_valid task  
// ===============================================================
task wait_out_valid_task; begin
	latency = 0;
	while(inf.out_valid !== 1'b1)begin
        latency = latency + 1;
        if (latency == 1000) begin
            $display("********************************************************");     
            $display("*  The execution latency exceeded 1000 cycles at %8t   *", $time);
            $display("********************************************************");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end endtask
// ===============================================================
//                      Check answer task  
// ===============================================================
task check_ans_task; begin
    if(inf.warn_msg !== warning) begin
        $display("ans_wrong");
        $display("golden_warning: %s",warning);
        $display("your_warning:  %s",inf.warn_msg);
        $finish;
    end
    else if(inf.complete !== complete) begin
        $display("ans_wrong");
        $display("golden_complete: %1d",complete);
        $display("your_complete:  %1d",inf.complete);
        $finish;
    end
    @(negedge clk);
end endtask


// ===============================================================
//                       Reset task  
// ===============================================================
task reset_task; begin 
    inf.rst_n = 1'b1;
    
    // input signal
    inf.sel_action_valid = 1'b0;
    inf.formula_valid = 1'b0;
    inf.mode_valid = 1'b0;
    inf.date_valid = 1'b0;
    inf.data_no_valid = 1'b0;
    inf.index_valid = 1'b0;
    inf.D = 'bx;

    total_latency = 0;
    // Apply reset
    #CYCLE; inf.rst_n = 1'b0; 
    #CYCLE; inf.rst_n = 1'b1;
    
    // Check initial conditions
    if (inf.out_valid !== 1'b0 || inf.complete !== 1'b0 || inf.warn_msg !== 'b0) begin
        $display("************************************************************");  
        $display("                          FAIL!                           ");    
        $display("*  Output signals should be 0 after initial RESET at %8t *", $time);
        $display("************************************************************");
        repeat (2) #CYCLE;
        $finish;
    end
    #CYCLE; release clk;
end endtask

// ===============================================================
//                      Display task 
// ===============================================================
task display_task; begin
    if(operation == Index_Check) begin
        $display("===================================="); 
        $display("          Index Check task          "); 
        $display("===================================="); 
        $display("------- DRAM data -------");
        $display("Data number = %3d",data_number);
        $display("Month = %2d, Day = %2d",_month, _day);
        $display("IndexA = %4d, IndexB = %4d, IndexC = %4d, IndexD = %4d",_index_A, _index_B, _index_C, _index_D);
        $display("------- Input data -------");
        $display("Month = %2d, Day = %2d",month_day.M, month_day.D);
        $display("T_IndexA = %4d, T_IndexB = %4d, T_IndexC = %4d, T_IndexD = %4d",index_ABCD[0], index_ABCD[1], index_ABCD[2], index_ABCD[3]);
        $display("------- Index abs difference -------");
        $display("G_IndexA = %4d, G_IndexB = %4d, G_IndexC = %4d, G_IndexD = %4d",_g_A, _g_B, _g_C, _g_D);
        $display("----- After formula -----");
        $display("Formula = %s, Result = %4d",formula, _result);
        $display("----- Date/Risk Warning -----");
        $display("Mode = %s, Warn-information = %s", mode, warning); 
        $display("==============================");
    end
    else if(operation == Update) begin 
        $display("=============================="); 
        $display("          Update task         "); 
        $display("=============================="); 
        $display("------- DRAM date -------");
        $display("Month = %2d, Day = %2d",_month, _day);
        $display("------- Update DRAM date -------");
        $display("Month = %2d, Day = %2d",month_day.M, month_day.D);
        $display("=============================="); 
        $display("------- DRAM data -------");
        $display("Data number = %3d",data_number);
        $display("IndexA       = %5d, IndexB       = %5d, IndexC       = %5d, IndexD       = %5d",_index_A, _index_B, _index_C, _index_D);
        $display("------- Variation data check -------");
        $display("T_IndexA     = %5d, T_IndexB     = %5d, T_IndexC     = %5d, T_IndexD     = %5d",index_ABCD[0], index_ABCD[1], index_ABCD[2], index_ABCD[3]);
        $display("T_var_IndexA = %5d, T_var_IndexB = %5d, T_var_IndexC = %5d, T_var_IndexD = %5d",_var_IA, _var_IB, _var_IC, _var_ID);
        $display("------- DRAM data after variation -------");
        $display("var_IndexA   = %5d, var_IndexB   = %5d, var_IndexC   = %5d, var_IndexD   = %5d",_var_A, _var_B, _var_C, _var_D); 
        $display("=============================="); 
        $display("------- DRAM data write back check -------");
        $display("var_IndexA    = %3h, var_IndexB     = %3h, var_IndexC    = %3h, var_IndexD   = %3h",_var_A, _var_B, _var_C, _var_D); 
        $display("DRAM_IndexA   =  %2h, DRAM_IndexBA   =  %2h, DRAM_IndexB   =  %2h",golden_DRAM [65536+data_number*8 + 7], golden_DRAM [65536+data_number*8 + 6], golden_DRAM [65536+data_number*8 + 5]); 
        $display("DRAM_IndexC   =  %2h, DRAM_IndexDC   =  %2h, DRAM_IndexD   =  %2h",golden_DRAM [65536+data_number*8 + 3], golden_DRAM [65536+data_number*8 + 2], golden_DRAM [65536+data_number*8 + 1]); 
        $display("----- Data Warning -----");
        $display("Warn-information = %s", warning); 
        $display("==============================");
    end
    else begin
        $display("===================================="); 
        $display("        Validate date task          "); 
        $display("===================================="); 
        $display("------- DRAM date -------");
        $display("Data number = %3d",data_number);
        $display("Month = %2d, Day = %2d",_month, _day);
        $display("------- Input date -------");
        $display("Month = %2d, Day = %2d",month_day.M, month_day.D);
        $display("----- Date Warning -----");
        $display("Warn-information = %s", warning); 
        $display("==============================");
    end
end endtask

task YOU_PASS_task; begin
    $display("\033[37m                                  .$&X.      x$$x              \033[32m      :BBQvi.");
    $display("\033[37m                                .&&;.X&$  :&&$+X&&x            \033[32m     BBBBBBBBQi");
    $display("\033[37m                               +&&    &&.:&$    .&&            \033[32m    :BBBP :7BBBB.");
    $display("\033[37m                              :&&     &&X&&      $&;           \033[32m    BBBB     BBBB");
    $display("\033[37m                              &&;..   &&&&+.     +&+           \033[32m   iBBBv     BBBB       vBr");
    $display("\033[37m                             ;&&...   X&&&...    +&.           \033[32m   BBBBBKrirBBBB.     :BBBBBB:");
    $display("\033[37m                             x&$..    $&&X...    +&            \033[32m  rBBBBBBBBBBBR.    .BBBM:BBB");
    $display("\033[37m                             X&;...   &&&....    &&            \033[32m  BBBB   .::.      EBBBi :BBU");
    $display("\033[37m                             $&...    &&&....    &&            \033[32m MBBBr           vBBBu   BBB.");
    $display("\033[37m                             $&....   &&&...     &$            \033[32m i7PB          iBBBBB.  iBBB");
    $display("\033[37m                             $&....   &&& ..    .&x                        \033[32m  vBBBBPBBBBPBBB7       .7QBB5i");
    $display("\033[37m                             $&....   &&& ..    x&+                        \033[32m :RBBB.  .rBBBBB.      rBBBBBBBB7");
    $display("\033[37m                             X&;...   x&&....   &&;                        \033[32m    .       BBBB       BBBB  :BBBB");
    $display("\033[37m                             x&X...    &&....   &&:                        \033[32m           rBBBr       BBBB    BBBU");
    $display("\033[37m                             :&$...    &&+...   &&:                        \033[32m           vBBB        .BBBB   :7i.");
    $display("\033[37m                              &&;...   &&$...   &&:                        \033[32m             .7  BBB7   iBBBg");
    $display("\033[37m                               && ...  X&&...   &&;                                         \033[32mdBBB.   5BBBr");
    $display("\033[37m                               .&&;..  ;&&x.    $&;.$&$x;                                   \033[32m ZBBBr  EBBBv     YBBBBQi");
    $display("\033[37m                               ;&&&+   .+xx;    ..  :+x&&&&&&&x                             \033[32m  iBBBBBBBBD     BBBBBBBBB.");
    $display("\033[37m                        +&&&&&&X;..             .          .X&&&&&x                         \033[32m    :LBBBr      vBBBi  5BBB");
    $display("\033[37m                    $&&&+..                                    .:$&&&&.                     \033[32m          ...   :BBB:   BBBu");
    $display("\033[37m                 $&&$.                                             .X&&&&.                  \033[32m         .BBBi   BBBB   iMBu");
    $display("\033[37m              ;&&&:                                               .   .$&&&                x\033[32m          BBBX   :BBBr");
    $display("\033[37m            x&&x.      .+&&&&&.                .x&$x+:                  .$&&X         $+  &x  ;&X   \033[32m  .BBBv  :BBBQ");
    $display("\033[37m          .&&;       .&&&:                      .:x$&&&&X                 .&&&        ;&     +&.    \033[32m   .BBBBBBBBB:");
    $display("\033[37m         $&&       .&&$.                             ..&&&$                 x&& x&&&X+.          X&x\033[32m     rBBBBB1.");
    $display("\033[37m        &&X       ;&&:                                   $&&x                $&x   .;x&&&&:                       ");
    $display("\033[37m      .&&;       ;&x                                      .&&&                &&:       .$&&$    ;&&.             ");
    $display("\033[37m      &&;       .&X                                         &&&.              :&$          $&&x                   ");
    $display("\033[37m     x&X       .X& .                                         &&&.              .            ;&&&  &&:             ");
    $display("\033[37m     &&         $x                                            &&.                            .&&&                 ");
    $display("\033[37m    :&&                                                       ;:                              :&&X                ");
    $display("\033[37m    x&X                 :&&&&&;                ;$&&X:                                          :&&.               ");
    $display("\033[37m    X&x .              :&&&  $&X              &&&  X&$                                          X&&               ");
    $display("\033[37m    x&X                x&&&&&&&$             :&&&&$&&&                                          .&&.              ");
    $display("\033[37m    .&&    \033[38;2;255;192;203m      ....\033[37m  .&&X:;&&+              &&&++;&&                                          .&&               ");
    $display("\033[37m     &&    \033[38;2;255;192;203m  .$&.x+..:\033[37m  ..+Xx.                 :&&&&+\033[38;2;255;192;203m  .;......    \033[37m                             .&&");
    $display("\033[37m     x&x   \033[38;2;255;192;203m .x&:;&x:&X&&.\033[37m              .             \033[38;2;255;192;203m .&X:&&.&&.:&.\033[37m                             :&&");
    $display("\033[37m     .&&:  \033[38;2;255;192;203m  x;.+X..+.;:.\033[37m         ..  &&.            \033[38;2;255;192;203m &X.;&:+&$ &&.\033[37m                             x&;");
    $display("\033[37m      :&&. \033[38;2;255;192;203m    .......   \033[37m         x&&&&&$++&$        \033[38;2;255;192;203m .... ......: \033[37m                             && ");
    $display("\033[37m       ;&&                          X&  .x.              \033[38;2;255;192;203m .... \033[37m                               .&&;                ");
    $display("\033[37m        .&&x                        .&&$X                                          ..         .x&&&               ");
    $display("\033[37m          x&&x..                                                                 :&&&&&+         +&X              ");
    $display("\033[37m            ;&&&:                                                                     x&&$XX;::x&&X               ");
    $display("\033[37m               &&&&&:.                                                              .X&x    +xx:                  ");
    $display("\033[37m                  ;&&&&&&&&$+.                                  :+x&$$X$&&&&&&&&&&&&&$                            ");
    $display("\033[37m                       .+X$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$X+xXXXxxxx+;.                                   ");
    $display("\033[32m                                    Congratulations!");
    $display("\033[32m                                    total latency = %d \033[37m",total_latency);
// light pink blush: \033[38;2;255;192;203m
// character: 125 pixels
// contrast: 180%
end endtask

endprogram

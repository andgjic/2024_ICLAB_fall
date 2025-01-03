`ifdef RTL
    `define CYCLE_TIME 20.0
`endif
`ifdef GATE
    `define CYCLE_TIME 20.0
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

//======================================
//      PARAMETERS & VARIABLES
//======================================
parameter PATNUM          = 100;
parameter CYCLE           = `CYCLE_TIME;
parameter DELAY           = 10000;
parameter MATRIX_DATA_NUM = 16;
parameter OUT_NUM         = 1;


// String control
// Should use %0s
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
//======================================
//      DATA MODEL
//======================================
integer                          a;
integer                    _is_err;
integer             _Inst_received; //received inst
integer             _Inst_gold; //received inst
integer             vvDATA[MATRIX_DATA_NUM-1:0]; //received inst
integer SEED = 5487;

// PATTERN CONTROL
integer       i;
integer       j;
integer       k;
integer       m;
integer    stop;
integer     pat;
integer exe_lat;
integer out_lat;
integer tot_lat;
integer          idxN, idxM, idxR, idxC;

// FILE CONTROL
integer file_input;
integer file_Golden;

reg signed[22:0]     DATA_out_2x2[0:8];
reg signed[50:0]     DATA_out_3x3[0:3];
reg signed[206:0]    DATA_out_4x4;

reg signed[206:0]    Gold_out;

//======================================
//              MAIN
//======================================
initial exe_task;

//======================================
//              Clock
//======================================
initial clk = 1'b0;
always #(CYCLE/2.0) clk = ~clk;

//======================================
//              TASKS
//======================================
task exe_task; begin
    read_file_task;
    reset_task;
    for (pat=0 ; pat<PATNUM ; pat=pat+1) begin
        read_input_task;
        input_task;
        wait_task;
        check_task;
        $display("%0sPASS PATTERN NO.%4d, %0sCycles: %3d%0s",txt_blue_prefix, pat, txt_green_prefix, exe_lat, reset_color);
    end
    pass_task;
end endtask

//**************************************
//      Reset Task
//**************************************
task reset_task; begin
    
    force clk   = 0;
    rst_n       = 1;
    in_valid    = 0;
    in_data     = 'dx;
    in_mode     = 'dx;

    #(CYCLE/2.0) rst_n = 0;
    #(CYCLE/2.0) rst_n = 1;
    if(out_valid !== 0 || out_data !== 0) begin
        $display(".                                                                                                                                                     ");
        $display(".                                                                                                                                                     ");
        $display("                                                                                                                                                      ");
        $display("                                                                                                                                                      ");
        $display("                      \033[1;31m.rrr7rv7LU:\033[1;0m                                                                                                  ");
        $display("                      \033[1;31m7QbEPPqPqDj\033[1;0m                                                                                                  ");
        $display("                      \033[1;31mibI111UjUS1\033[1;0m                         .:iiri.                      \033[1;34m   *********************************    ");
        $display("                      \033[1;31m:dujjUJujX1\033[1;0m                       .KQMDEZZK5s:                   \033[1;34m   * Output signal should be Reset *    ");
        $display("                      \033[1;31m.S2YuJuJ12K\033[1;0m                      7gDgPdqbPX2Egs                  \033[1;34m   *********************************    ");
        $display("                       \033[1;31mK2JsuJju5S\033[1;0m                     :SLJv2KPPP5qSdb7                                                             ");
        $display("                       \033[1;31m5EUUYuJU2K\033[1;0m.                    r7:.::ivUu5Jv75j                                                             ");
        $display("                        .\033[1;31mYXKKKXPgr\033[1;0m                    vr ..  ...... .7                                                             ");
        $display("                    .:.   is\033[1;31mjv77u:\033[1;0m                    7i...........  .                                                             ");
        $display("                       :7ji                          :7:..  .......  .:                                                                               ");
        $display("                  . .:rYrii                          :Y.iIKjs:::Jq1i :7.                                                                              ");
        $display("                       iur::                          :...rIS: :ER:. i.                                                                               ");
        $display("                  ...iu:.v7i.                          ....     .::                                                                                   ");
        $display("                 .  .::vI1Lr                            :::.... ....                                                                                  ");
        $display("                 :2sYr:isjJ.                            ::..::i:: .                                                                                   ");
        $display("                  :Xvr::.:..                            .r.i:i7ir..                                                                                   ");
        $display("                    rvr:..:::.                        YB. vr:rY:7i v.                                                                                 ");
        $display("                     jjr::.::i:.                     .QBM. r7Lvi: :Bdir:.:....                                                                        ");
        $display("                     .XXJri::.::.           ......:.. :BBB5.:7jr:JB7S7v7:..........                                               ....                ");
        $display("                      .S2Yri:....:.:ri   ...........:: :. jBv.:7gBr .i::. .... . . ....  .                           .........::::::i77:::::.         ");
        $display("                       .uu7ri:.......:Ui    ..i.: ...i.    .QZ. Du  ...   ..  . . :.... ......... . rI..::::i:iiiirr777rrr7ri:i::...LZ7               ");
        $display("                         vJs7i......   Xi    .v....:...  .   :.s   ..      .    .::................ 52 ..........::::iirrri::::iii:::v:               ");
        $display("                          :Ls7i:.....  .D   : 7: .... .....    gu   . .   ..    :::.............:. iP ..........:irr7ri:.       ...7i:::              ");
        $display("                            :Lv7:... . :Q. :i.i: . ..  ... . . :B  .....  .. . ..:.........:....  vE...::i:iirriii..                   .              ");
        $display("                               :d2r::.:KS:.rUrs7 .. . . . . .   Bi  . .   . .....::....:::r::...7Z1::::::::..                                         ");
        $display("                                :BBBQBRBiL77s7jX ... . .......  IM .....  .v...:..:::::rrr.:..vBB:                                                    ");
        $display("                                  .JKUv.   :jYSU ...    . . ..  :Y ......::...::..ii:...      ::                                                      ");
        $display("                                            r2Pv......r. ......:. .: ........::::.:                                                                   ");
        $display("                                             rqr....::ri::::..::. : .:..... ..:::.                                                                    ");
        $display("                                             :5i::.....:ii:::... ...:....:..::.:.                                                                     ");
        $display("                                             .5ri:::..:::..:i::.. .::...:...:.::.                                                                     ");
        $display("                                              Yiiiii.:....:i::.. .:i. ..:..:..::.                                                                     ");
        $display("                                              7:i:rii::.::r:... .:i.. ........:..                                                                     ");
        $display("                                             .r:irrr::::ii.....::i.. ....:....:..                                                                     ");
        $display("                                              ::i:::iiri:...:.:ri.. ..::::...i:..                                                                     ");
        $display("                                              :i:::iirri:::i.iri....:i::.. .::...                                                                     ");
        $display("                                             .::::ii::::irriri:...:::.. ...::. ..                                                                     ");
        $display("                                             ::rrvYsvYvvri:i::.::::........:....                                                                      ");
        $display("                                            .i77r::.:::.:rr::::::::.......:.....                                                                      ");
        $display("                                            .i:. ......iii:::ii:::::.:...... ...                                                                      ");
        $display("                                            ::...:::.i7rr:::i::.:::.:...........                                                                      ");
        $display("                                            .i:ii:.:rr::.::i:::::..:.......:....                                                                      ");
        $display("                                             .:...::....:iiii::.::i::........ ..                                                                      ");
        $display("                                               .      .........:::......      .                                                                       ");
        $display("                                              BQZXXsr:                . ...:JX                                                                        ");
        $display("                                             5BBBBBBBBBBEEbEqbdZEDdEdZQBBBBBBBr                                                                       ");
        $display("                                             QBdugQQQBBBBBBQBQBBBBBBBBBBBBBQQgB                                                                       ");
        $display("                                            :BQJgQEMgBBQQBQBBQQBBBQBBBQQQQRZMMB7                                                                      ");
        $display("                                            gBIDBQQgggBQQggMBQBQQQBRQMQZQQBEgMBj                                                                      ");
        $display("                                            BBUBMBBBMggBQQBQgQQBMQBQMMggMggQMQB1                                                                      ");
        $display("                                           .B5ZBQRQQBRggBQBQQgQQBQBQQgMgDZRRQQB2                                                                      ");
        $display("                                           RBZBBQQQQQBQQgQQBQRgQQBQBQBQQMQRQQQBg                                                                      ");
        $display("  ...... ..           .  .                 E1UIPBQBBBBBQQgQQBQQQBQBQBQBQBQQQQRBB                                                                      ");
        $display("                                          .7ir:XQQgRQQQBBBQBQBBBQBQBQQQBQBQQQQQB                                                                   .  ");
        $display("\033[1;0m");
        repeat(5) #(CYCLE);
        $finish;
    end
    #(CYCLE/2.0) release clk;
end endtask


//**************************************
//      Read Input Task
//**************************************
task read_file_task; begin
    file_input  = $fopen("../00_TESTBED/TestData/input.txt","r");
    file_Golden = $fopen("../00_TESTBED/TestData/Golden.txt","r"); 
end endtask

task read_input_task;begin

	a = $fscanf(file_input,"%d",_Inst_received);
    for(idxN=0 ; idxN<MATRIX_DATA_NUM ; idxN=idxN+1) begin // MATRIX_NUM = 3
        a = $fscanf(file_input,"%d",vvDATA[idxN]);
    end

    //Golden
    a = $fscanf(file_Golden,"%d",_Inst_gold);
    case(_Inst_gold)
        4       : begin
            for (idxN=0 ; idxN<9 ; idxN=idxN+1) begin
                a = $fscanf(file_Golden,"%d",DATA_out_2x2[idxN]);
            end
            Gold_out = {DATA_out_2x2[0],DATA_out_2x2[1],DATA_out_2x2[2],DATA_out_2x2[3],DATA_out_2x2[4],DATA_out_2x2[5],DATA_out_2x2[6],DATA_out_2x2[7],DATA_out_2x2[8]};
        end
        6       : begin
            for (idxN=0 ; idxN<4 ; idxN=idxN+1) begin
                a = $fscanf(file_Golden,"%d",DATA_out_3x3[idxN]);
            end
            Gold_out = {DATA_out_3x3[0],DATA_out_3x3[1],DATA_out_3x3[2],DATA_out_3x3[3]};
        end
        default : begin
            a = $fscanf(file_Golden,"%b",DATA_out_4x4);
            Gold_out = DATA_out_4x4;
        end
    endcase
end endtask
//**************************************
//      Input Task
//**************************************
task input_task; begin

    repeat(({$random(SEED)} % 5 + 1)) @(negedge clk);

    // Give DATA ,inst
    for(idxN=0 ; idxN<MATRIX_DATA_NUM ; idxN=idxN+1) begin // MATRIX_NUM = 3
        in_valid = 1;
        in_data = vvDATA[idxN];
        if (idxN == 0) begin
            in_mode = _Inst_received;
        end
        @(negedge clk);
        in_valid    = 0;
        in_data     = 'dx;
        in_mode     = 'dx;
    end                           
end endtask



//**************************************
//      Wait Task
//**************************************
task wait_task; begin
    exe_lat = -1;
    while(out_valid !== 1) begin
        // if(out_data !== 0) begin
        //     $display("\033[1;33m            ︵");
        //     $display("\033[1;33m          /_ /");
        //     $display("\033[1;33m         /_ /");
        //     $display("\033[1;33m     ︵ / _ / ︵");
        //     $display("\033[1;33m  ︵/__/__/___/︵");
        //     $display("\033[1;33m /___/___/__/_/__/    \033[1;31m Output signal should be 0 \033[1;0m");
        //     $display("\033[1;33m{___{__{__{______}");
        //     $display("\033[1;33m  __ ____________/     \033[1;31m when the out_valid is pulled down \033[1;0m");
        //     $display("\033[1;33m  ＼ ___________∕");
        //     $display("\033[1;33m   ＼__________       \033[1;31m at \033[44;1m %4d ps \033[1;0m                        ", $time*1000);
        //     $display("\033[1;33m ★\033[1;0m");
        //     repeat(5) #(CYCLE);
        //     $finish;
        // end
        if (exe_lat == DELAY) begin
            $display("\033[1;33m            ︵");
            $display("\033[1;33m          /_ /");
            $display("\033[1;33m         /_ /");
            $display("\033[1;33m     ︵ / _ / ︵");
            $display("\033[1;33m  ︵/__/__/___/︵");
            $display("\033[1;33m /___/___/__/_/__/    \033[1;31m The execution latency at \033[44;1m %-12d ps \033[1;0m ", $time*1000);
            $display("\033[1;33m{___{__{__{______}");
            $display("\033[1;33m  __ ____________/    \033[1;31m is over \033[44;1m %5d   cycles \033[1;0m", DELAY);
            $display("\033[1;33m  ＼ ___________∕");
            $display("\033[1;33m   ＼__________   ");   
            $display("\033[1;33m ★ \033[1;0m");
            repeat(5) @(negedge clk);
            $finish; 
        end
        exe_lat = exe_lat + 1;
        @(negedge clk);
    end
end endtask


//**************************************
//      Check Task
//**************************************
task check_task; begin
    out_lat = 0;
    _is_err = 0;
    while(out_valid === 1) begin
        if(out_lat == OUT_NUM ) begin

            $display("\033[1;33m    へ　　　　　／|       \033[1;0m ");
            $display("\033[1;33m 　 /＼7　　　 ∠＿/       \033[1;0m ");
            $display("\033[1;33m 　 /　│　　 ／　／       \033[1;0m     ");
            $display("\033[1;33m 　│　Z ＿,＜　／　　 /`ヽ \033[1;0m     ");
            $display("\033[1;33m 　│　　　　　ヽ　　 /　　 \033[1;0m      ");
            $display("\033[1;33m 　 Y　　　　　`　 /　　/  \033[1;0m       ");
            $display("\033[1;33m 　ｲ●　､　●　　⊂⊃〈　　/  \033[1;0m      ");
            $display("\033[1;33m 　()　 へ　　　　|　＼〈  \033[1;0m         ");
            $display("\033[1;33m 　　>ｰ ､_　 ィ　 │ ／／   \033[1;0m         ");
            $display("\033[1;33m 　 / へ　　 /　ﾉ＜| ＼＼  \033[1;0m          ");
            $display("\033[1;33m 　 ヽ_ﾉ　　(_／　 │／／   \033[1;0m         ");
            $display("\033[1;33m 　　7　　　　　　　|／    \033[1;0m        ");
            $display("\033[1;33m 　　＞―r￣￣`ｰ―＿          \033[1;0m ");
            $display("  \033[1;31m  Out cycles is more than %-2d at %-12d ps \033[1;0m", OUT_NUM, $time*1000);
            repeat(5) @(negedge clk);
            $finish;
        end
        //====================
        // Check
        //====================
        case(_Inst_gold)
        4       : begin
            if(out_data !== Gold_out) begin
                _is_err = 1;
            end
        end
        6       : begin
            if(out_data[203:0] !== Gold_out[203:0]) begin
                _is_err = 1;
            end
        end
        default : begin
            if(out_data !== Gold_out) begin
                _is_err = 1;
            end
        end
        endcase

        if(_is_err) begin
            // $display("==================================");
            // $display("out_value = %d , vvGolden_Bit = %d",out_value,vvGolden_Bit[itCalc][idxR][idxC][out_idx]);
            // $display("==================================");
            

            $display("        ⣀⣤⣤⣀");
            $display("⠀⠀⠀⠀⣠⠟⠁⠀⠀⠀⠀⠙⣆");
            $display("⠀⠀⠀⣴⠁⠀⠀⠀⠀⠀⠀⠀⠀⢷     \033[1;32m ================================================  \033[1;0m");
            $display("⠀⠀⠀⡇⠀⠀⡴⠀⠀⡴⠀⠀⠀⠀⡆    \033[1;31m Output is not correct!!! \033[1;0m");
            $display("⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇    \033[1;31m Gold Output is %7h \033[1;0m",Gold_out);
            $display("⠀⠀⠀⢿⠀⠀⣤⣀⣀⣤⠀⠀⠀⣼     ");
            $display("⠀⠀⠀⠀⠳⣀⠀⠀⠀⠀⠀⢀⡴      \033[1;32m ================================================  \033[1;0m");       
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
            $display("⢠⣿⣿⣿⣿⣿⣿⠀⡏ \033[0;31m|here : %7h   |\033[1;0m⣸",out_data);
            $display("⠀⠀⣿⣿⠀⠀⢿⣿⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠃");
            $display("⠀⠙⠁⠀⠀⠘⠋⠛⠒⠒⠒⠒⠒⠒⠒⠒⠒⠋ ");

            // $display("itCalc == %d ",itCalc);
            repeat(5) @(negedge clk);
            $finish;
        end

        out_lat = out_lat + 1;
        @(negedge clk);
    end

    if (out_lat < OUT_NUM) begin     
        $display("     ⣠⣶⡾⠏⠉⠙⠳⢦⡀⠀⠀    ⢠⠞⠉⠙⠲⡀⠀");
        $display("    ⣴⠿⠏⠀⠀⠀⠀⠀⠀⢳⡀⠀  ⡏⠀          ⢷");
        $display("⠀⠀⢠⣟⣋⡀⢀⣀⣀⡀⠀⣀⡀⣧⠀ ⢸  Out cycles    ⡇");
        $display("⠀⠀⢸⣯⡭⠁⠸⣛⣟⠆⡴⣻⡲⣿⠀⣸⠀ is less than %-2d ⡇", OUT_NUM, $time*1000);
        $display("⠀⠀⣟⣿⡭⠀⠀⠀⠀⠀⢱⠀⠀⣿⠀  ⢹⠀⠀     ⠀          ⡇");
        $display("⠀⠀⠙⢿⣯⠄⠀⠀⠀⢀⡀⠀⠀⡿⠀  ⡇      ⠀          ⡼");
        $display("⠀⠀⠀⠀⠹⣶⠆⠀⠀⠀⠀⠀⡴⠃⠀⠀⠘⠤⣄⣄⣄⣄⣠⣄⣄⣄⣄⣄⣄⣄⠞");
        $display("⠀⠀⠀⠀⠀⢸⣷⡦⢤⡤⢤⣞⣁");
        $display("⠀⠀⢀⣤⣴⣿⣏⠁⠀⠀⠸⣏⢯⣷⣖⣦⡀");
        $display("⢀⣾⣽⣿⣿⣿⣿⠛⢲⣶⣾⢉⡷⣿⣿⠵⣿");
        $display("⣼⣿⠍⠉⣿⡭⠉⠙⢺⣇⣼⡏⠀⠀⠀⣄⢸");
        $display("⣿⣿⣧⣀⣿.........⣀⣰⣏⣘⣆........");
        repeat(5) @(negedge clk);
        $finish;
    end
    tot_lat = tot_lat + exe_lat;
end endtask



//**************************************
//      PASS Task
//**************************************

task pass_task; begin
    $display("\033[1;33m               ●┳┳┳┳┳┳┳●                \033[1;35m Congratulation!!! \033[1;0m                                   ");
    $display("\033[1;33m               ┣/\_/\ _/\               \033[1;35m PASS This Lab........Maybe \033[1;0m                          ");
    $display("\033[1;33m               ┃(･ω･)ω-*) ♡             \033[1;35m Total Latency : %-10d\033[1;0m                                ", tot_lat);
    $display("\033[1;33m               (    ノ ●    Sleep well  \       ●");
    $display("\033[1;33m               ＼     ┣┳┳┳┳┳┳┳┳┫");
    $display("\033[1;33m               ＼_.   ┣┻┻┻┻┻┻┻┻┫ \033[1;0m ");

    repeat(5) @(negedge clk);
    $finish;
end endtask


endmodule
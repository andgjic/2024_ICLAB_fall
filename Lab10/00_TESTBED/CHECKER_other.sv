/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

// integer fp_w;

// initial begin
// fp_w = $fopen("out_valid.txt", "w");
// end

/**
 * This section contains the definition of the class and the instantiation of the object.
 *  * 
 * The always_ff blocks update the object based on the values of valid signals.
 * When valid signal is true, the corresponding property is updated with the value of inf.D
 */

class Formula_and_mode;
    Formula_Type f_type;
    Mode f_mode;
endclass

Formula_and_mode fm_info = new();

// Coverage

//declare the cover group 
// 1. Each case of Formula_Type should be select at least 150 times.
/*
Formula_A
Formula_B
Formula_C
Formula_D
Formula_E
Formula_F
Formula_G
Formula_H
*/
covergroup Spec1 @(posedge clk);
	coverpoint inf.D.d_formula[0] iff(inf.formula_valid){
		option.at_least = 150 ;
		bins b1 = {Formula_A} ;
		bins b2 = {Formula_B} ;
		bins b3 = {Formula_C} ;
		bins b4 = {Formula_D} ;
		bins b5 = {Formula_E} ;
        bins b6 = {Formula_F} ;
        bins b7 = {Formula_G} ;
        bins b8 = {Formula_H} ;
	}
endgroup : Spec1

//2. Each case of Mode should be select at least 150 times.
covergroup Spec2 @(posedge clk);
   	coverpoint inf.D.d_mode[0] iff(inf.mode_valid){
   		option.at_least = 150 ;
        bins Insensitive = { Insensitive } ;
		bins Normal = { Normal } ;
		bins Sensitive = { Sensitive } ;
   	}
endgroup

Formula_Type formula_type;
always_ff @(posedge clk iff inf.formula_valid) formula_type = inf.D.d_formula[0];

//3. Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 150 times. (Formula_A,B,C,D,E,F,G,H) x (Insensitive, Normal, Sensitive)
covergroup Spec3 //////////////////////////////////////////////////
    @(posedge clk iff(inf.mode_valid));
    option.at_least = 150;
    formula: coverpoint formula_type{
        //bins formulas[] = {Formula_A, Formula_B, Formula_C, Formula_D, Formula_E, Formula_F, Formula_G, Formula_H};
		bins b1 = {Formula_A} ;
		bins b2 = {Formula_B} ;
		bins b3 = {Formula_C} ;
		bins b4 = {Formula_D} ;
		bins b5 = {Formula_E} ;
        bins b6 = {Formula_F} ;
        bins b7 = {Formula_G} ;
        bins b8 = {Formula_H} ;    
    }
    mode: coverpoint inf.D.d_mode[0] iff(inf.mode_valid) {
        //bins modes[] = { Insensitive, Normal, Sensitive };
        bins Insensitive = { Insensitive } ;
		bins Normal = { Normal } ;
		bins Sensitive = { Sensitive } ;
    }
    formula_cross_mode: cross formula, mode;/*{
        bins A1 = binsof(formula.b1) && binsof(mode.Insensitive);
    }*/

endgroup


//4. Output signal inf.warn_msg should be “No_Warn”, “Date_Warn”, “Data_Warn“,”Risk_Warn, each at least 50 times. (Sample the value when inf.out_valid is high)
covergroup Spec4 @(negedge clk);
	coverpoint inf.warn_msg iff(inf.out_valid){
		option.at_least = 50 ;
		bins No_Warn    = { No_Warn } ;
		bins Date_Warn  = { Date_Warn } ;
		bins Data_Warn	= { Data_Warn } ;
		bins Risk_Warn  = { Risk_Warn } ;
	}
endgroup

// 5. Create the transitions bin for the inf.D.act[0] signal from [Index_Check:Check_Valid_Date] to [Index_Check:Check_Valid_Date]. 
// Each transition should be hit at least 300 times. (sample the value at posedge clk iff inf.sel_action_valid) 
covergroup Spec5 @(posedge clk iff(inf.sel_action_valid));
   	coverpoint inf.D.d_act[0] {
   		option.at_least = 300 ;
   		bins b_0 = ( Index_Check => Index_Check);
        bins b_1 = ( Index_Check => Update);
        bins b_2 = ( Index_Check => Check_Valid_Date) ;
        bins b_3 = ( Update => Index_Check) ;
        bins b_4 = ( Update => Update ) ;
        bins b_5 = ( Update => Check_Valid_Date) ;
        bins b_6 = ( Check_Valid_Date => Index_Check) ;
        bins b_7 = ( Check_Valid_Date => Update );
        bins b_8 = ( Check_Valid_Date => Check_Valid_Date ) ;
   	}
endgroup

Action cur_action;
always_ff @(posedge clk iff inf.sel_action_valid) cur_action = inf.D.d_act[0];
// 6. Create a covergroup for variation of Update action with auto_bin_max = 32, and each bin have to hit at least one time. 
covergroup Spec6 @(posedge clk iff(inf.index_valid && (cur_action === Update)));
	coverpoint inf.D.d_index[0] {
		option.at_least = 1 ;
        option.auto_bin_max = 32 ;
		/*bins b_0 = {[0:127]};
        bins b_1 = {[128:255]};
        bins b_2 = {[256:383]};
        bins b_3 = {[384:511]};
        bins b_4 = {[512:639]};
        bins b_5 = {[640:767]};
        bins b_6 = {[768:895]};
        bins b_7 = {[896:1023]};
        bins b_8 = {[1024:1151]};
        bins b_9 = {[1152:1279]};
        bins b_10 = {[1280:1407]};
        bins b_11 = {[1408:1535]};
        bins b_12 = {[1536:1663]};
        bins b_13 = {[1664:1791]};
        bins b_14 = {[1792:1919]};
        bins b_15 = {[1920:2047]};
        bins b_16 = {[2048:2175]};
        bins b_17 = {[2176:2303]};
        bins b_18 = {[2304:2431]};
        bins b_19 = {[2432:2559]};
        bins b_20 = {[2560:2687]};
        bins b_21 = {[2688:2815]};
        bins b_22 = {[2816:2943]};
        bins b_23 = {[2944:3071]};
        bins b_24 = {[3072:3209]};
        bins b_25 = {[3200:3327]};
        bins b_26 = {[3328:3455]};
        bins b_27 = {[3456:3583]};
        bins b_28 = {[3584:3711]};
        bins b_29 = {[3712:3839]};
        bins b_30 = {[3840:3967]};
        bins b_31 = {[3968:4095]};*/
	}
endgroup

Spec1 cov_1_inst = new();
Spec2 cov_2_inst = new();
Spec3 cov_3_inst = new();
Spec4 cov_4_inst = new();
Spec5 cov_5_inst = new();
Spec6 cov_6_inst = new();



// Assertion
//*    1. All outputs signals (Program.sv) should be zero after reset
property SPEC_1_rst;
    @(posedge inf.rst_n) 1 |-> @(posedge clk) (   inf.out_valid   === 0 &&    inf.complete   === 0 &&    inf.warn_msg    === 0 
                                             &&   inf.AR_VALID    === 0 &&    inf.AR_ADDR     === 0 &&    inf.R_READY     === 0 &&    inf.AW_VALID    === 0 &&    inf.AW_ADDR     === 0 
                                             &&    inf.W_VALID     === 0 &&    inf.W_DATA      === 0 &&    inf.B_READY     === 0 &&    inf.AR_READY    === 0 &&    inf.R_VALID     === 0 &&    inf.R_RESP      === 0 &&    inf.R_DATA      === 0 &&    inf.AW_READY    === 0 &&    inf.W_READY     === 0 &&    inf.B_VALID     === 0 &&    inf.B_RESP      === 0 );
endproperty

// out_valid, warn_msg, complete,
// AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY

//*    2.  Latency should be less than 1000 cycles for each operation.
// rst_n, sel_action_valid, formula_valid, mode_valid, date_valid, data_no_valid, index_valid, D, 
// out_valid, warn_msg, complete,  
property SPEC_2_IDCHK;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Index_Check) ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid 
                                                                              ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  |-> ##[1:999] inf.out_valid;
endproperty

property SPEC_2_UD;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Update) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid 
                                                                         ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)   |-> ##[1:999] inf.out_valid;
endproperty

property SPEC_2_C;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Check_Valid_Date) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid |-> ##[1:999] inf.out_valid;
endproperty

//*    3.  If action is completed (complete=1), warn_msg should be 2’b0 (No_Warn).
property SPEC_3_warnmsg;
    @(negedge clk) ((inf.out_valid!==0) && (inf.complete===1)) |-> inf.warn_msg===No_Warn; 
endproperty

//*    4. Next input valid will be valid 1-4 cycles after previous input valid fall. 
property SPEC_4_IDCHK;

    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Index_Check) |-> ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid 
                                                                              ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid);
endproperty

property SPEC_4_UD;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Update) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid 
                                                                         ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid)  ##[1:4] (inf.index_valid);
endproperty

property SPEC_4_C;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Check_Valid_Date) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid;
endproperty

//*    5. All input valid signals won’t overlap with each other
//rst_n, sel_action_valid, formula_valid, mode_valid, date_valid, data_no_valid, index_valid, D, 
//            out_valid, warn_msg, complete
property SPEC_5_act;
    @(posedge clk) (inf.sel_action_valid===1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_formula;
    @(posedge clk) (inf.formula_valid===1) |-> !(inf.sel_action_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_mode;
    @(posedge clk) (inf.mode_valid===1) |-> !(inf.sel_action_valid || inf.formula_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_date;
    @(posedge clk) (inf.date_valid===1) |-> !(inf.sel_action_valid || inf.formula_valid || inf.mode_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_data_no;
    @(posedge clk) (inf.data_no_valid===1) |-> !(inf.sel_action_valid || inf.formula_valid || inf.mode_valid || inf.date_valid || inf.index_valid); 
endproperty

property SPEC_5_index;
    @(posedge clk) (inf.index_valid===1) |-> !(inf.sel_action_valid || inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid); 
endproperty

//*    6. Out_valid can only be high for exactly one cycle
property SPEC_6_exact_one_outvalid;
    @(posedge clk) (inf.out_valid!==0) |=> !inf.out_valid; 
endproperty

//*    7. Next operation will be valid 1-4 cycles after out_valid fall.
property SPEC_7_next_op;
    @(posedge clk) (inf.out_valid===1) ##(1) (!inf.out_valid) |-> ##[0:3] inf.sel_action_valid; 
endproperty

//*    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
property SPEC_8_MONTH;
    @(posedge clk) (inf.date_valid===1) |-> inf.D.d_date[0].M inside {[1:12]}; 
endproperty

property SPEC_8_31D;
    @(posedge clk) 
    ((inf.date_valid===1) && (  inf.D.d_date[0].M===1  ||
                                inf.D.d_date[0].M===3  ||
                                inf.D.d_date[0].M===5  ||
                                inf.D.d_date[0].M===7  ||
                                inf.D.d_date[0].M===8  ||
                                inf.D.d_date[0].M===10 ||
                                inf.D.d_date[0].M===12
                        )) |-> inf.D.d_date[0].D inside {[1:31]}; 
endproperty

property SPEC_8_28D;
    @(posedge clk) ((inf.date_valid===1) && inf.D.d_date[0].M===2) |-> inf.D.d_date[0].D inside {[1:28]}; 
endproperty

property SPEC_8_30D;
    @(posedge clk) 
    ((inf.date_valid===1) && (  inf.D.d_date[0].M===4 ||
                                inf.D.d_date[0].M===6 ||
                                inf.D.d_date[0].M===9 ||
                                inf.D.d_date[0].M===11)) |-> inf.D.d_date[0].D inside {[1:30]}; 
endproperty

//*    9. The AR_VALID signal should not overlap with the AW_VALID signal.
property SPEC_9_AR_not_overlapping_AW_VALID;
    @(posedge clk) (inf.AR_VALID!==0) |-> !inf.AW_VALID; 
endproperty

property SPEC_9_AW_not_overlapping_AR_VALID;
    @(posedge clk) (inf.AW_VALID!==0) |-> !inf.AR_VALID; 
endproperty

// out valid cannot overlapping with the 6 input valid signals
property SPEC_extra;
    @(posedge clk) (inf.out_valid===1) |-> !(inf.sel_action_valid || inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

//* assert 
assert property(SPEC_1_rst)                  else print_Assertion_violate_msg("1");
assert property(SPEC_2_IDCHK)                else print_Assertion_violate_msg("2");
assert property(SPEC_2_UD)                   else print_Assertion_violate_msg("2");
assert property(SPEC_2_C)                    else print_Assertion_violate_msg("2");
assert property(SPEC_3_warnmsg)              else print_Assertion_violate_msg("3");
assert property(SPEC_4_IDCHK)                else print_Assertion_violate_msg("4");
assert property(SPEC_4_UD)                   else print_Assertion_violate_msg("4");
assert property(SPEC_4_C)                    else print_Assertion_violate_msg("4");
assert property(SPEC_5_act)                    else print_Assertion_violate_msg("5");
assert property(SPEC_5_formula)                else print_Assertion_violate_msg("5");
assert property(SPEC_5_mode)                   else print_Assertion_violate_msg("5");
assert property(SPEC_5_date)                   else print_Assertion_violate_msg("5");
assert property(SPEC_5_data_no)                else print_Assertion_violate_msg("5");
assert property(SPEC_5_index)                  else print_Assertion_violate_msg("5");
assert property(SPEC_6_exact_one_outvalid)     else print_Assertion_violate_msg("6");
assert property(SPEC_7_next_op)                else print_Assertion_violate_msg("7");
assert property(SPEC_8_MONTH)                  else print_Assertion_violate_msg("8");
assert property(SPEC_8_28D)                    else print_Assertion_violate_msg("8");
assert property(SPEC_8_30D)                    else print_Assertion_violate_msg("8");
assert property(SPEC_8_31D)                    else print_Assertion_violate_msg("8");
assert property(SPEC_9_AR_not_overlapping_AW_VALID)                    else print_Assertion_violate_msg("9");
assert property(SPEC_9_AW_not_overlapping_AR_VALID)                    else print_Assertion_violate_msg("9");
assert property(SPEC_extra)                                            else print_Assertion_violate_msg("extra");


//* display task
task print_Assertion_violate_msg(string Assertion_num);
    $display("Assertion %s is violated", Assertion_num);
    $fatal;
endtask

endmodule
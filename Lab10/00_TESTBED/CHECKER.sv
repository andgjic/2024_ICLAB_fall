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
`define CYCLE_TIME 15.0

`include "Usertype.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

//================================================================
// Clock
//================================================================
real CYCLE = `CYCLE_TIME;

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


Formula_Type formula;
always_ff @(negedge clk iff inf.formula_valid) formula = inf.D.d_formula[0];

Action action;
always_ff @(negedge clk iff inf.sel_action_valid) action = inf.D.d_act[0];


// ===============================================================
//                           Coverage 
// ===============================================================
// ---------- Coverage formula X Mode ----------
covergroup coverage123@(negedge clk iff inf.mode_valid);	 
    option.per_instance = 1;
	option.at_least = 150;
	cov_formula: coverpoint formula { bins t_formula [] = {3'h0,3'h1,3'h2,3'h3,3'h4,3'h5,3'h6,3'h7};}
	cov_mode:    coverpoint inf.D.d_mode[0] { bins t_mode [] = {Insensitive, Normal, Sensitive};}
    cov_formula_c_mode:  cross cov_formula, cov_mode;
endgroup
coverage123 coverage_123 = new();

// ---------- Coverage warn_msg ----------
covergroup coverage4@(negedge clk iff inf.out_valid);	
    option.per_instance = 1;
	option.at_least = 50;
	coverpoint inf.warn_msg[1:0]{
		bins warning_No_Warn     = {No_Warn};	
        bins warning_Date_Warn   = {Date_Warn};
        bins warning_Data_Warn   = {Data_Warn};
        bins warning_Risk_Warn   = {Risk_Warn};
	}
endgroup
coverage4 coverage_4 = new();

// ---------- Coverage action transition ----------
covergroup coverage5@(negedge clk iff inf.sel_action_valid);	 
    option.per_instance = 1;
	option.at_least = 300;
	coverpoint inf.D.d_act[0] { bins act_transition [] = ([Index_Check:Check_Valid_Date] => [Index_Check:Check_Valid_Date]);}
endgroup
coverage5 coverage_5 = new();

// ---------- Coverage index value ----------
covergroup coverage6@(negedge clk iff inf.index_valid && action == Update);	 
    option.per_instance = 1;
	option.at_least = 1;
    option.auto_bin_max = 32;
	coverpoint inf.D.d_index[0];
endgroup
coverage6 coverage_6 = new();




// ===============================================================
//                          Assertions 
// ===============================================================
// ---------- Assertion 1 ----------
always @(negedge inf.rst_n) begin
    #CYCLE;
	assert_1 : assert (
        // input valid signal
		(inf.sel_action_valid === 0) && (inf.formula_valid  === 0) &&
		(inf.mode_valid       === 0) && (inf.date_valid     === 0) &&
		(inf.data_no_valid    === 0) && (inf.index_valid    === 0) &&
        // output
        (inf.out_valid  === 0) && (inf.warn_msg  === 0) && (inf.complete  === 0) &&
        // AXI signal
		(inf.AR_VALID   === 0) && (inf.AR_ADDR   === 0) && (inf.R_READY   === 0) && (inf.R_RESP   === 0) &&
        (inf.AW_VALID   === 0) && (inf.AW_ADDR   === 0) &&
        (inf.W_VALID    === 0) && (inf.W_DATA    === 0) && (inf.W_READY    === 0) &&
        (inf.B_READY    === 0) && (inf.B_RESP    === 0)
	)
	else begin 
        $display("Assertion 1 is violated"); 
        $fatal; 
    end
end

// ---------- Assertion 2 ----------
property SPEC_2_index_lat;
    @(negedge clk) (inf.mode_valid === 1)  ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid |-> ##[1:1000] inf.out_valid;
endproperty
property SPEC_2_update_lat;
    @(negedge clk) (inf.sel_action_valid === 1 && inf.D.d_act[0] === Update) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid |-> ##[1:1000] inf.out_valid;
endproperty
property SPEC_2_valid_date_lat;
    @(negedge clk) (inf.sel_action_valid === 1 && inf.D.d_act[0] === Check_Valid_Date) ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid |-> ##[1:1000] inf.out_valid;
endproperty
assert property(SPEC_2_index_lat)       else $fatal(0,"Assertion 2 is violated"); 
assert property(SPEC_2_update_lat)      else $fatal(0,"Assertion 2 is violated"); 
assert property(SPEC_2_valid_date_lat)  else $fatal(0,"Assertion 2 is violated"); 

// ---------- Assertion 3 ----------
property SPEC_3;
    @(negedge clk) (inf.complete === 1) |-> inf.warn_msg === No_Warn;
endproperty
assert property(SPEC_3)       else $fatal(0,"Assertion 3 is violated"); 

// ---------- Assertion 4 ----------
property SPEC_4_index_lat;
    @(negedge clk) (inf.sel_action_valid === 1 && inf.D.d_act[0] === Index_Check)      |->  ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid;
endproperty
property SPEC_4_update_lat;
    @(negedge clk) (inf.sel_action_valid === 1 && inf.D.d_act[0] === Update)           |->  ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid;
endproperty
property SPEC_4_valid_date_lat;
    @(negedge clk) (inf.sel_action_valid === 1 && inf.D.d_act[0] === Check_Valid_Date) |->  ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid;
endproperty
assert property(SPEC_4_index_lat)       else $fatal(0,"Assertion 4 is violated"); 
assert property(SPEC_4_update_lat)      else $fatal(0,"Assertion 4 is violated"); 
assert property(SPEC_4_valid_date_lat)  else $fatal(0,"Assertion 4 is violated"); 

// ---------- Assertion 5 ---------- 
property SPEC_5_sel;
    @(negedge clk) (inf.sel_action_valid === 1) |->  (inf.formula_valid === 0);
endproperty
property SPEC_5_formula;
    @(negedge clk) (inf.formula_valid === 1)    |->  (inf.mode_valid === 0);
endproperty
property SPEC_5_mode;
    @(negedge clk) (inf.mode_valid === 1)       |->  (inf.date_valid === 0);
endproperty
property SPEC_5_date;
    @(negedge clk) (inf.date_valid === 1)       |->  (inf.data_no_valid === 0);
endproperty
property SPEC_5_data_no;
    @(negedge clk) (inf.data_no_valid === 1)    |->  (inf.index_valid === 0);
endproperty
property SPEC_5_index;
    @(negedge clk) (inf.index_valid === 1)      |->  (inf.sel_action_valid === 0);  
endproperty

assert property(SPEC_5_sel)     else $fatal(0,"Assertion 5 is violated"); 
assert property(SPEC_5_formula) else $fatal(0,"Assertion 5 is violated"); 
assert property(SPEC_5_mode)    else $fatal(0,"Assertion 5 is violated"); 
assert property(SPEC_5_date)    else $fatal(0,"Assertion 5 is violated"); 
assert property(SPEC_5_data_no) else $fatal(0,"Assertion 5 is violated"); 
assert property(SPEC_5_index)   else $fatal(0,"Assertion 5 is violated"); 

// ---------- Assertion 6 ---------- 
property SPEC_6;
    @(negedge clk) (inf.out_valid === 1) |=> (inf.out_valid === 0);  
endproperty
assert property(SPEC_6)   else $fatal(0,"Assertion 6 is violated"); 

// ---------- Assertion 7 ---------- 
property SPEC_7;
    @(negedge clk) (inf.out_valid === 1) |=> ##[1:4] (inf.sel_action_valid === 1);   
endproperty
assert property(SPEC_7)   else $fatal(0,"Assertion 7 is violated"); 

// ---------- Assertion 8 ---------- 
property SPEC_8_month;
    @(negedge clk) (inf.date_valid === 1) |-> inf.D.d_date[0].M inside {[1:12]};   
endproperty
property SPEC_8_day_28;
    @(negedge clk) (inf.date_valid === 1) && (inf.D.d_date[0].M == 2) |-> inf.D.d_date[0].D inside {[1:28]};   
endproperty

property SPEC_8_day_30;
    @(negedge clk) (inf.date_valid === 1) && (inf.D.d_date[0].M == 4 || inf.D.d_date[0].M == 6 || 
                                              inf.D.d_date[0].M == 9 || inf.D.d_date[0].M == 11) |-> inf.D.d_date[0].D inside {[1:30]};   
endproperty
property SPEC_8_day_31;
    @(negedge clk) (inf.date_valid === 1) && (inf.D.d_date[0].M == 1 || inf.D.d_date[0].M == 3 || 
                                              inf.D.d_date[0].M == 5 || inf.D.d_date[0].M == 7 || 
                                              inf.D.d_date[0].M == 8 || inf.D.d_date[0].M == 10 || 
                                              inf.D.d_date[0].M == 12) |-> inf.D.d_date[0].D inside {[1:31]};   
endproperty

assert property(SPEC_8_month)    else $fatal(0,"Assertion 8 is violated"); 
assert property(SPEC_8_day_28)   else $fatal(0,"Assertion 8 is violated"); 
assert property(SPEC_8_day_30)   else $fatal(0,"Assertion 8 is violated"); 
assert property(SPEC_8_day_31)   else $fatal(0,"Assertion 8 is violated"); 

// ---------- Assertion 9 ---------- 
property SPEC_9_AXI;
    @(negedge clk) (inf.AR_VALID === 1) |-> (inf.AW_VALID === 0);   
endproperty
assert property(SPEC_9_AXI)   else $fatal(0,"Assertion 9 is violated");  


endmodule



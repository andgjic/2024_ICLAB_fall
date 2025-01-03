
`include "Usertype.sv"

module Program(input clk, INF.Program_inf inf);
import usertype::*;

// ---------- parameter & integer ----------
parameter s_IDLE            = 3'd0; 
parameter s_IN              = 3'd1;
parameter s_DRAM_READ       = 3'd2;  
parameter s_DRAM_READ_WAIT  = 3'd3;  
parameter s_CAL             = 3'd4;
parameter s_DRAM_WRITE      = 3'd5;
parameter s_PRE_OUT         = 3'd6;
parameter s_OUT             = 3'd7; 

integer i, j;

// ---------- enurmerate type ----------
FSM  c_s, n_s;
Action act;
Formula_Type formula;
Mode mode;
Date month_day;
Data_No data_number;
Index [0:3] index_ABCD;
Warn_Msg warning;



// ---------- logic ----------
// counter
logic [2:0]  cnt_index;
// DRAM
logic [63:0] dram_data;
logic [19:0] data_addr;
logic [3:0]  month_d;
logic [4:0]  day_d;
logic [11:0] index_A_d;
logic [11:0] index_B_d; 
logic [11:0] index_C_d;
logic [11:0] index_D_d;

// check index
logic [11:0] formula_result;
logic [11:0] min1, min2, min3, min4; // min1 < min2 < min3 < min4
logic [11:0] g_min1, g_min2, g_min3, g_min4; // min1 < min2 < min3 < min4
logic [13:0] g_sum;
logic signed [12:0] g_index_A_signed;
logic signed [12:0] g_index_B_signed; 
logic signed [12:0] g_index_C_signed;
logic signed [12:0] g_index_D_signed;
logic [11:0] g_index_A;
logic [11:0] g_index_B; 
logic [11:0] g_index_C;
logic [11:0] g_index_D;
// update
logic signed [11:0] index_A_signed;     // input
logic signed [11:0] index_B_signed;     // input
logic signed [11:0] index_C_signed;     // input
logic signed [11:0] index_D_signed;     // input
logic [11:0] index_A_abs;     
logic [11:0] index_B_abs;     
logic [11:0] index_C_abs;     
logic [11:0] index_D_abs;     
logic signed [13:0] var_A_signed;     
logic signed [13:0] var_B_signed;     
logic signed [13:0] var_C_signed;     
logic signed [13:0] var_D_signed;   
logic [11:0] var_A; 
logic [11:0] var_B; 
logic [11:0] var_C; 
logic [11:0] var_D;   

logic in_finish_flag;
logic formula_F_flag;
//=================================================================================================
//                                            FSM
//=================================================================================================
always_comb begin : Finite_state_machine
    case(c_s)
        s_IDLE:                                                     // state 0
            n_s = inf.sel_action_valid ? s_IN : s_IDLE;
        s_IN:                                                       // state 1
            n_s = (inf.data_no_valid) ? s_DRAM_READ : s_IN;
        s_DRAM_READ:
        if(act == Update)
            n_s = inf.R_VALID ? s_DRAM_READ_WAIT : s_DRAM_READ;
        else if(act == Index_Check)
            n_s = inf.R_VALID ?  s_CAL : s_DRAM_READ;
        else
            n_s = inf.R_VALID ?  s_OUT : s_DRAM_READ;
        s_DRAM_READ_WAIT:
            n_s = in_finish_flag ? s_DRAM_WRITE : s_DRAM_READ_WAIT;
        s_CAL:
            n_s = in_finish_flag ? s_PRE_OUT : s_CAL;
        s_PRE_OUT:
            n_s = formula_F_flag ? s_PRE_OUT : s_OUT;
        s_DRAM_WRITE:
            n_s = (inf.B_VALID) ? s_OUT : s_DRAM_WRITE;
        s_OUT:
            n_s = s_IDLE;
        default:                                                    // default
            n_s = s_IDLE;
    endcase
end

always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)
        c_s <= s_IDLE;
    else
        c_s <= n_s;
end

//=================================================================================================
//                                            Counter  
//=================================================================================================
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)
        cnt_index <= 0;
    else if(inf.index_valid)
        cnt_index <= cnt_index + 1;
    else if(c_s == s_IDLE)
        cnt_index <= 0;
end
//=================================================================================================
//                                        Action: Update  
//=================================================================================================
// dram data unsigned -> signed
assign index_A_signed = index_ABCD[0]; 
assign index_B_signed = index_ABCD[1]; 
assign index_C_signed = index_ABCD[2]; 
assign index_D_signed = index_ABCD[3]; 
assign index_A_abs    = index_A_signed[11] ? ~index_A_signed + 1 : index_A_signed; 
assign index_B_abs    = index_B_signed[11] ? ~index_B_signed + 1 : index_B_signed; 
assign index_C_abs    = index_C_signed[11] ? ~index_C_signed + 1 : index_C_signed; 
assign index_D_abs    = index_D_signed[11] ? ~index_D_signed + 1 : index_D_signed; 
// variation calculate
assign var_A_signed = index_A_signed[11] ? index_A_d - index_A_abs : index_A_d + index_A_abs;
assign var_B_signed = index_B_signed[11] ? index_B_d - index_B_abs : index_B_d + index_B_abs;
assign var_C_signed = index_C_signed[11] ? index_C_d - index_C_abs : index_C_d + index_C_abs;
assign var_D_signed = index_D_signed[11] ? index_D_d - index_D_abs : index_D_d + index_D_abs;
// Limit variation result range to 0~4095
assign var_A = var_A_signed[13] ? 0 : ((var_A_signed[12]) ? 4095 : var_A_signed);
assign var_B = var_B_signed[13] ? 0 : ((var_B_signed[12]) ? 4095 : var_B_signed);
assign var_C = var_C_signed[13] ? 0 : ((var_C_signed[12]) ? 4095 : var_C_signed);
assign var_D = var_D_signed[13] ? 0 : ((var_D_signed[12]) ? 4095 : var_D_signed); 


//=================================================================================================
//                             Action: Index check, check validate date  
//=================================================================================================
// store DRAM data
always_ff @(posedge clk) begin
    if(inf.R_VALID)
        dram_data <= inf.R_DATA;
end
// efficient data from dram
assign day_d     = dram_data[7:0];
assign month_d   = dram_data[39:32];
assign index_D_d = dram_data[19:8];
assign index_C_d = dram_data[31:20];
assign index_B_d = dram_data[51:40];
assign index_A_d = dram_data[63:52]; 

// formula  calculation
SORT ascend_1 (.clk(clk), .I0(index_A_d), .I1(index_B_d), .I2(index_C_d), .I3(index_D_d), .O0(min1), .O1(min2), .O2(min3), .O3(min4)); 
SORT ascend_2 (.clk(clk), .I0(g_index_A), .I1(g_index_B), .I2(g_index_C), .I3(g_index_D), .O0(g_min1), .O1(g_min2), .O2(g_min3), .O3(g_min4));  

assign g_index_A_signed = index_A_d - index_ABCD[0];
assign g_index_B_signed = index_B_d - index_ABCD[1];
assign g_index_C_signed = index_C_d - index_ABCD[2];
assign g_index_D_signed = index_D_d - index_ABCD[3];

assign g_index_A = g_index_A_signed[12] ? ~g_index_A_signed + 1 : g_index_A_signed;
assign g_index_B = g_index_B_signed[12] ? ~g_index_B_signed + 1 : g_index_B_signed;
assign g_index_C = g_index_C_signed[12] ? ~g_index_C_signed + 1 : g_index_C_signed;
assign g_index_D = g_index_D_signed[12] ? ~g_index_D_signed + 1 : g_index_D_signed;

always_ff @(posedge clk) begin
    g_sum <= (g_min1 + g_min2 + g_min3);
end
always_ff @(posedge clk) begin 
    case(formula)
        Formula_A : formula_result <= (index_A_d >> 2) + (index_B_d >> 2) + (index_C_d >> 2) + (index_D_d >> 2);
        Formula_B : formula_result <= min4 - min1;
        Formula_C : formula_result <= min1;
        Formula_D : formula_result <= (index_A_d >= 2047) + (index_B_d >= 2047) + (index_C_d >= 2047) + (index_D_d >= 2047);
        Formula_E : formula_result <= (index_A_d >= index_ABCD[0]) + (index_B_d >= index_ABCD[1]) + (index_C_d >= index_ABCD[2]) + (index_D_d >= index_ABCD[3]);
        Formula_F : formula_result <= g_sum/3;
        Formula_G : formula_result <= (g_min1 >> 1) + (g_min2 >> 2) + (g_min3 >> 2); 
        Formula_H : formula_result <= (g_min1 >> 2) + (g_min2 >> 2) + (g_min3 >> 2) + (g_min4 >> 2); 
        default: formula_result <= 0;                                            
    endcase
end
// for Formula_F delay out
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n)
        formula_F_flag <= 0;
    else if(n_s == s_PRE_OUT && formula == Formula_F)
        formula_F_flag <= ~formula_F_flag; 
end

//=================================================================================================
//                                      Warning Check  
//=================================================================================================
always_comb
begin
    if(!inf.rst_n)      
        warning = No_Warn;
    else if(act == Update) begin            // Data warning check (no date check)
        if(var_A_signed[13] || var_B_signed[13] || var_C_signed[13] || var_D_signed[13] || 
            (var_A_signed[12]) || (var_B_signed[12]) || (var_C_signed[12]) || (var_D_signed[12]))
            warning = Data_Warn; 
        else
            warning = No_Warn; 
    end
    else if(month_day.M < month_d)          // Date warning check
        warning = Date_Warn;
    else if(month_day.M == month_d && month_day.D < day_d)
        warning = Date_Warn;
    else begin
        if(act == Index_Check) begin        // Risk warning check
            case(formula)
            Formula_A, Formula_C : 
                if(mode == Insensitive && formula_result >= 2047)
                    warning = Risk_Warn;
                else if (mode == Normal && formula_result >= 1023)
                    warning = Risk_Warn;
                else if (mode == Sensitive && formula_result >= 511)
                    warning = Risk_Warn;
                else
                    warning = No_Warn;
            Formula_B, Formula_F, Formula_G, Formula_H :
                if(mode == Insensitive && formula_result >= 800)
                    warning = Risk_Warn;
                else if (mode == Normal && formula_result >= 400)
                    warning = Risk_Warn;
                else if (mode == Sensitive && formula_result >= 200)
                    warning = Risk_Warn;
                else
                    warning = No_Warn;
            Formula_D, Formula_E :
                if(mode == Insensitive && formula_result >= 3)
                    warning = Risk_Warn;
                else if (mode == Normal && formula_result >= 2)
                    warning = Risk_Warn;
                else if (mode == Sensitive && formula_result >= 1)
                    warning = Risk_Warn;
                else
                    warning = No_Warn;
            default: warning = No_Warn;
            endcase
        end 
        else
            warning = No_Warn;
    end
end




//=================================================================================================                     
//                               AAA           XX   XX       IIIIIIIIII
//                              AA AA           XX XX            II
//                             AA   AA           XXX             II
//                            AAAAAAAAA         XX XX            II
//                           AA       AA       XX   XX       IIIIIIIIII
//=================================================================================================
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< AXI READ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// ==========================================
//                 AXI control
// ==========================================
// ==========================================
//                 AR channel
// ==========================================
// * arvalid
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.AR_VALID <= 0;
    else if(inf.data_no_valid)                
        inf.AR_VALID <= 1;
    else if(inf.AR_READY)
        inf.AR_VALID <= 0;
end

// * araddr
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.AR_ADDR <= 0;
    else if(inf.data_no_valid)
        inf.AR_ADDR <= 17'h10000 + (inf.D.d_data_no[0] << 3); 
end
// ==========================================
//                 R channel
// ==========================================
// * rready
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.R_READY <= 0;
    else 
        inf.R_READY <= 1;
end

// // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< AXI Write >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (only in mode 1)
// ==========================================
//                 AXI control
// ==========================================
// ==========================================
//                 AW channel 
// ==========================================
// * awvalid
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.AW_VALID <= 0;
    else if(inf.AW_READY)
        inf.AW_VALID <= 0; 
    else if(act == Update && inf.R_VALID)                
        inf.AW_VALID <= 1;
    
end
// * awaddr
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.AW_ADDR <= 0;
    else if(act == Update && inf.R_VALID)                
        inf.AW_ADDR <= data_addr; 
end
// ==========================================
//                 W channel 
// ==========================================
// * wvalid
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.W_VALID <= 0;
    else if(n_s == s_DRAM_WRITE)
        inf.W_VALID <= 1;  
    else
        inf.W_VALID <= 0;
end

// * wdata
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.W_DATA <= 0;
    else 
        inf.W_DATA <= {var_A,var_B,4'b0000,month_day.M,var_C,var_D,3'b000,month_day.D};
end

// ==========================================
//                 B channel 
// ==========================================
// * bready
always_ff @(posedge clk or negedge inf.rst_n)
begin
    if(!inf.rst_n)      
        inf.B_READY <= 0;
    else 
        inf.B_READY <= 1;
end

//=================================================================================================
//                                            Input  
//=================================================================================================
// data address
assign data_addr = 17'h10000 + (data_number << 3);

// input finished flag
always_comb begin
    if (!inf.rst_n)
        in_finish_flag = 0;
    else if((act == Index_Check || act == Update) && cnt_index == 4)
        in_finish_flag = 1;  
    else
        in_finish_flag = 0; 
end

// action
always_ff @(posedge clk)
begin
    if(inf.sel_action_valid)
        act <= inf.D.d_act[0];
end
// formula
always_ff @(posedge clk)
begin
    if(inf.formula_valid)
        formula <= inf.D.d_formula[0];
end
// mode
always_ff @(posedge clk)
begin
    if(inf.mode_valid)
        mode <= inf.D.d_mode[0];
end
// date
always_ff @(posedge clk)
begin
    if(inf.date_valid)
        month_day <= inf.D.d_date[0];
end
// data No. from DRAM
always_ff @(posedge clk)
begin
    if(inf.data_no_valid)
        data_number <= inf.D.d_data_no[0];
end
// IndexA -> IndexB -> IndexC -> IndexD
always_ff @(posedge clk)
begin
    if(inf.index_valid)
        index_ABCD[cnt_index] <= inf.D.d_index[0]; 
end

        

//=================================================================================================
//                                            Output 
//=================================================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin
	if(!inf.rst_n) 
        inf.out_valid <= 0;
	else if(c_s == s_OUT)
        inf.out_valid <= 1;
    else
        inf.out_valid <= 0;
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) 
        inf.complete <= 0;
	else if(c_s == s_OUT && warning == No_Warn)
        inf.complete <= 1;
    else
        inf.complete <= 0;
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) 
        inf.warn_msg <= No_Warn;
	else if(c_s == s_OUT)
        inf.warn_msg <= warning;
    else
        inf.warn_msg <= No_Warn;
end





endmodule



module SORT(clk,I0,I1,I2,I3,O0,O1,O2,O3);
input clk;
input [11:0] I0,I1,I2,I3;
output logic [11:0] O0,O1,O2,O3;

logic [11:0] sort [3:0];

logic f3_2, f3_1, f3_0;
logic f2_3, f2_1, f2_0;
logic f1_3, f1_2, f1_0;
logic f0_3, f0_2, f0_1;

wire [1:0] addr_3, addr_2, addr_1, addr_0;
//sorting
//--- Fifth ---
assign f3_2 = (I3 > I2) ? 1'd1 : 1'd0;
assign f3_1 = (I3 > I1) ? 1'd1 : 1'd0;
assign f3_0 = (I3 > I0) ? 1'd1 : 1'd0;
assign addr_3 = f3_2 + f3_1 + f3_0;
//--- Sixth ---
assign f2_3 = ~f3_2;
assign f2_1 = (I2 > I1) ? 1'd1 : 1'd0;
assign f2_0 = (I2 > I0) ? 1'd1 : 1'd0;
assign addr_2 = f2_3 + f2_1 + f2_0;
//--- Seven ---
assign f1_3 = ~f3_1;
assign f1_2 = ~f2_1;
assign f1_0 = (I1 > I0) ? 1'd1 : 1'd0;
assign addr_1 = f1_3 + f1_2 + f1_0;
//--- Eight ---
assign f0_3 = ~f3_0;
assign f0_2 = ~f2_0;
assign f0_1 = ~f1_0;
assign addr_0 = f0_3 + f0_2 + f0_1;

// sort[3] > sort[2] > sort[1] > sort[0]
always @(*)
begin
    //cancel Latch
    sort[3] = 0;
    sort[2] = 0;
    sort[1] = 0;
    sort[0] = 0;
    sort[addr_3] = I3;
    sort[addr_2] = I2;
    sort[addr_1] = I1;
    sort[addr_0] = I0;
end

always_ff @(posedge clk) begin
    O0 <= sort[0];
    O1 <= sort[1];
    O2 <= sort[2];
    O3 <= sort[3];
end

// assign O0 = sort[0];
// assign O1 = sort[1];
// assign O2 = sort[2];
// assign O3 = sort[3];

endmodule
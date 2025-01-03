//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab01 Exercise		: Snack Shopping Calculator
//   Author     		  : Anderson
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SSC.v
//   Module Name : SSC
//   Release version : V1.0 (Release Date: 2024-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SSC(
           // Input signals
           card_num,
           input_money,
           snack_num,
           price,
           // Output signals
           out_valid,
           out_change
       );

//================================================================
//   INPUT AND OUTPUT DECLARATION
//================================================================
input [63:0] card_num;
input [8:0] input_money;
input [31:0] snack_num;
input [31:0] price;
output out_valid;
output [8:0] out_change;

//================================================================
//    Wire & Registers
//================================================================
wire [4:0]card_odd  [7:0];
wire [4:0]card_shift[7:0];
wire [3:0]card_even [7:0];
wire [7:0]sum;
reg output_valid;

wire f7_6, f7_5, f7_4, f7_3, f7_2, f7_1, f7_0;
wire f6_7, f6_5, f6_4, f6_3, f6_2, f6_1, f6_0;
wire f5_7, f5_6, f5_4, f5_3, f5_2, f5_1, f5_0;
wire f4_7, f4_6, f4_5, f4_3, f4_2, f4_1, f4_0;
wire f3_7, f3_6, f3_5, f3_4, f3_2, f3_1, f3_0;
wire f2_7, f2_6, f2_5, f2_4, f2_3, f2_1, f2_0;
wire f1_7, f1_6, f1_5, f1_4, f1_3, f1_2, f1_0;
wire f0_7, f0_6, f0_5, f0_4, f0_3, f0_2, f0_1;
wire [2:0]addr_7, addr_6, addr_5, addr_4, addr_3, addr_2, addr_1, addr_0;
wire [7:0]total     [7:0];
reg  [7:0]total_sort[7:0];

reg  [8:0]remain;
reg  [8:0]buy       [7:0];


//================================================================
//    DESIGN
//================================================================
//---------------------------- Visa check --------------------------------------


assign card_shift[7] = card_num[63:60]<<1;
assign card_shift[6] = card_num[55:52]<<1;
assign card_shift[5] = card_num[47:44]<<1;
assign card_shift[4] = card_num[39:36]<<1;
assign card_shift[3] = card_num[31:28]<<1;
assign card_shift[2] = card_num[23:20]<<1;
assign card_shift[1] = card_num[15:12]<<1;
assign card_shift[0] = card_num[7:4]<<1;


//看減去card_even可不可以變小
assign card_odd [7] = (card_shift[7] >= 10) ? card_shift[7] - 9 : card_shift[7];
assign card_even[7] = card_num[59:56];
assign card_odd [6] = (card_shift[6] >= 10) ? card_shift[6] - 9 : card_shift[6];
assign card_even[6] = card_num[51:48];
assign card_odd [5] = (card_shift[5] >= 10) ? card_shift[5] - 9 : card_shift[5];
assign card_even[5] = card_num[43:40];
assign card_odd [4] = (card_shift[4] >= 10) ? card_shift[4] - 9 : card_shift[4];
assign card_even[4] = card_num[35:32];
assign card_odd [3] = (card_shift[3] >= 10) ? card_shift[3] - 9 : card_shift[3];
assign card_even[3] = card_num[27:24];
assign card_odd [2] = (card_shift[2] >= 10) ? card_shift[2] - 9 : card_shift[2];
assign card_even[2] = card_num[19:16];
assign card_odd [1] = (card_shift[1] >= 10) ? card_shift[1] - 9 : card_shift[1];
assign card_even[1] = card_num[11:8];
assign card_odd [0] = (card_shift[0] >= 10) ? card_shift[0] - 9 : card_shift[0];
assign card_even[0] = card_num[3:0];
// sum max=144
assign sum = card_odd[7]+card_even[7]+card_odd[6]+card_even[6]+card_odd[5]+card_even[5]+card_odd[4]+card_even[4]+
       card_odd[3]+card_even[3]+card_odd[2]+card_even[2]+card_odd[1]+card_even[1]+card_odd[0]+card_even[0];

assign out_valid = output_valid;
always @(*)
begin
    case(sum)
        8'd140:
            output_valid = 1;
        8'd130:
            output_valid = 1;
        8'd120:
            output_valid = 1;
        8'd110:
            output_valid = 1;
        8'd100:
            output_valid = 1;
        8'd90:
            output_valid = 1;
        8'd80:
            output_valid = 1;
        8'd70:
            output_valid = 1;
        8'd60:
            output_valid = 1;
        8'd50:
            output_valid = 1;
        8'd40:
            output_valid = 1;
        8'd30:
            output_valid = 1;
        8'd20:
            output_valid = 1;
        8'd10:
            output_valid = 1;
        8'd0:
            output_valid = 1;
        default:
            output_valid = 0;
    endcase
end

//---------------------------- Shopping --------------------------------------
assign total[7] = snack_num[31:28] * price[31:28];
assign total[6] = snack_num[27:24] * price[27:24];
assign total[5] = snack_num[23:20] * price[23:20];
assign total[4] = snack_num[19:16] * price[19:16];
assign total[3] = snack_num[15:12] * price[15:12];
assign total[2] = snack_num[11: 8] * price[11: 8];
assign total[1] = snack_num[7 : 4] * price[7 : 4];
assign total[0] = snack_num[3 : 0] * price[3 : 0];

//sorting
//--- first ---
assign f7_6 = (total[7] > total[6]) ? 1'd1 : 1'd0; 
assign f7_5 = (total[7] > total[5]) ? 1'd1 : 1'd0;
assign f7_4 = (total[7] > total[4]) ? 1'd1 : 1'd0;
assign f7_3 = (total[7] > total[3]) ? 1'd1 : 1'd0;
assign f7_2 = (total[7] > total[2]) ? 1'd1 : 1'd0;
assign f7_1 = (total[7] > total[1]) ? 1'd1 : 1'd0;
assign f7_0 = (total[7] > total[0]) ? 1'd1 : 1'd0;
assign addr_7 = f7_0 + f7_1 + f7_2 + f7_3 + f7_4 + f7_5 + f7_6;
//--- second ---
assign f6_7 = ~f7_6;
assign f6_5 = (total[6] > total[5]) ? 1'd1 : 1'd0;
assign f6_4 = (total[6] > total[4]) ? 1'd1 : 1'd0;
assign f6_3 = (total[6] > total[3]) ? 1'd1 : 1'd0;
assign f6_2 = (total[6] > total[2]) ? 1'd1 : 1'd0;
assign f6_1 = (total[6] > total[1]) ? 1'd1 : 1'd0;
assign f6_0 = (total[6] > total[0]) ? 1'd1 : 1'd0;
assign addr_6 = f6_7 + f6_5 + f6_4 + f6_3 + f6_2 + f6_1 + f6_0;
//--- Third ---
assign f5_7 = ~f7_5;
assign f5_6 = ~f6_5;
assign f5_4 = (total[5] > total[4]) ? 1'd1 : 1'd0;
assign f5_3 = (total[5] > total[3]) ? 1'd1 : 1'd0;
assign f5_2 = (total[5] > total[2]) ? 1'd1 : 1'd0;
assign f5_1 = (total[5] > total[1]) ? 1'd1 : 1'd0;
assign f5_0 = (total[5] > total[0]) ? 1'd1 : 1'd0;
assign addr_5 = f5_7 + f5_6 + f5_4 + f5_3 + f5_2 + f5_1 + f5_0;
//--- Forth ---
assign f4_7 = ~f7_4;
assign f4_6 = ~f6_4;
assign f4_5 = ~f5_4;
assign f4_3 = (total[4] > total[3]) ? 1'd1 : 1'd0;
assign f4_2 = (total[4] > total[2]) ? 1'd1 : 1'd0;
assign f4_1 = (total[4] > total[1]) ? 1'd1 : 1'd0;
assign f4_0 = (total[4] > total[0]) ? 1'd1 : 1'd0;
assign addr_4 = f4_7 + f4_6 + f4_5 + f4_3 + f4_2 + f4_1 + f4_0;
//--- Fifth ---
assign f3_7 = ~f7_3;
assign f3_6 = ~f6_3;
assign f3_5 = ~f5_3;
assign f3_4 = ~f4_3;
assign f3_2 = (total[3] > total[2]) ? 1'd1 : 1'd0;
assign f3_1 = (total[3] > total[1]) ? 1'd1 : 1'd0;
assign f3_0 = (total[3] > total[0]) ? 1'd1 : 1'd0;
assign addr_3 = f3_7 + f3_6 + f3_5 + f3_4 + f3_2 + f3_1 + f3_0;
//--- Sixth ---
assign f2_7 = ~f7_2;
assign f2_6 = ~f6_2;
assign f2_5 = ~f5_2;
assign f2_4 = ~f4_2;
assign f2_3 = ~f3_2;
assign f2_1 = (total[2] > total[1]) ? 1'd1 : 1'd0;
assign f2_0 = (total[2] > total[0]) ? 1'd1 : 1'd0;
assign addr_2 = f2_7 + f2_6 + f2_5 + f2_4 + f2_3 + f2_1 + f2_0;
//--- Seven ---
assign f1_7 = ~f7_1;
assign f1_6 = ~f6_1;
assign f1_5 = ~f5_1;
assign f1_4 = ~f4_1;
assign f1_3 = ~f3_1;
assign f1_2 = ~f2_1;
assign f1_0 = (total[1] > total[0]) ? 1'd1 : 1'd0;
assign addr_1 = f1_7 + f1_6 + f1_5 + f1_4 + f1_3 + f1_2 + f1_0;
//--- Eight ---
assign f0_7 = ~f7_0;
assign f0_6 = ~f6_0;
assign f0_5 = ~f5_0;
assign f0_4 = ~f4_0;
assign f0_3 = ~f3_0;
assign f0_2 = ~f2_0;
assign f0_1 = ~f1_0;
assign addr_0 = f0_7 + f0_6 + f0_5 + f0_4 + f0_3 + f0_2 + f0_1;

always @(*) begin
    //為了消Latch等addr太多運算卡在X
    total_sort[7] = 0;
    total_sort[6] = 0;
    total_sort[5] = 0;
    total_sort[4] = 0;
    total_sort[3] = 0;
    total_sort[2] = 0;
    total_sort[1] = 0;
    total_sort[0] = 0;
    total_sort[addr_7] = total[7];
    total_sort[addr_6] = total[6];
    total_sort[addr_5] = total[5];
    total_sort[addr_4] = total[4];
    total_sort[addr_3] = total[3];
    total_sort[addr_2] = total[2];
    total_sort[addr_1] = total[1];
    total_sort[addr_0] = total[0];
end


//money
/*   timing violation
assign buy[6] = input_money-total_sort[7];
assign buy[5] = (buy[6] >= total_sort[6]) ? buy[6]-total_sort[6] : buy[6];
assign buy[4] = (buy[5] >= total_sort[5] && buy[5] != buy[6]) ? buy[5]-total_sort[5] : buy[5];
assign buy[3] = (buy[4] >= total_sort[4] && buy[4] != buy[5]) ? buy[4]-total_sort[4] : buy[4];
assign buy[2] = (buy[3] >= total_sort[3] && buy[3] != buy[4]) ? buy[3]-total_sort[3] : buy[3];
assign buy[1] = (buy[2] >= total_sort[2] && buy[2] != buy[3]) ? buy[2]-total_sort[2] : buy[2];
assign buy[0] = (buy[1] >= total_sort[1] && buy[1] != buy[2]) ? buy[1]-total_sort[1] : buy[1];
assign remain = (buy[0] >= total_sort[0] && buy[0] != buy[1]) ? buy[0]-total_sort[0] : buy[0];
*/

always @(*) begin
    buy[7] = input_money-total_sort[7];
    buy[6] = buy[7]-total_sort[6];
    buy[5] = buy[6]-total_sort[5];
    buy[4] = buy[5]-total_sort[4];
    buy[3] = buy[4]-total_sort[3];
    buy[2] = buy[3]-total_sort[2];
    buy[1] = buy[2]-total_sort[1];
    buy[0] = buy[1]-total_sort[0];
end

always @(*)
begin
    if(buy[6]>buy[7])
        remain = buy[7];
    else if(buy[5]>buy[6])
        remain = buy[6];
    else if(buy[4]>buy[5])
        remain = buy[5];
    else if(buy[3]>buy[4])
        remain = buy[4];
    else if(buy[2]>buy[3])
        remain = buy[3];
    else if(buy[1]>buy[2])
        remain = buy[2];
    else if(buy[0]>buy[1])
        remain = buy[1];
    else
        remain = buy[0];
end


assign out_change = (output_valid && (input_money >= total_sort[7])) ? remain : input_money;


endmodule

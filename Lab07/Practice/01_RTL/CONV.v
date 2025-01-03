`include "synchronizer.v"
`include "syn_XOR.v"
module CONV(
	//io
	clk_1,
	clk_2,
	rst_n,
	in_valid,
	in_data1,
	in_data2,
	out_valid,
	out_data
);
//io
input clk_1,clk_2;
input rst_n;
input in_valid;
input [2:0] in_data1;
input [2:0] in_data2;

output reg out_valid;
output reg[7:0] out_data;
//FSM setting
reg [1:0]	count_1;
reg [2:0]	count_2;
//reg,wire
wire[7:0] y [6:0] ;
reg[2:0] x[0:3],h[0:3],x_exe[0:6],h_exe[0:3];
wire inready;
//multi_cycle_path setting
reg  count_mult;
//in
always@(posedge clk_1)begin
	if(in_valid)begin
		h[0]<=h[1];
		h[1]<=h[2];
		h[2]<=h[3];
		h[3]<=in_data1;
		x[0]<=x[1];
		x[1]<=x[2];
		x[2]<=x[3];
		x[3]<=in_data2;
	end 
	else begin
		h[0]<=h[0];
		h[1]<=h[1];
		h[2]<=h[2];
		h[3]<=h[3];
		x[0]<=x[0];
		x[1]<=x[1];
		x[2]<=x[2];
		x[3]<=x[3];
	end
end

//exe
always@(posedge clk_2)
	if(inready)begin
		h_exe[0]<= /*fill in the blank*/  
		h_exe[1]<= /*fill in the blank*/  
		h_exe[2]<= /*fill in the blank*/  
		h_exe[3]<= /*fill in the blank*/  
	end 
	else begin
		h_exe[0]<=h_exe[0];
		h_exe[1]<=h_exe[1];
		h_exe[2]<=h_exe[2];
		h_exe[3]<=h_exe[3];
	end

always@(posedge clk_2)
	if(inready) begin
		x_exe[0]<= /*fill in the blank*/  
		x_exe[1]<= /*fill in the blank*/  
		x_exe[2]<= /*fill in the blank*/  
		x_exe[3]<= /*fill in the blank*/  
		x_exe[4]<= /*fill in the blank*/  
		x_exe[5]<= /*fill in the blank*/  
		x_exe[6]<= /*fill in the blank*/  
	end 
	else begin	
		x_exe[0]<=x_exe[0];
		x_exe[1]<=x_exe[1];
		x_exe[2]<=x_exe[2];
		x_exe[3]<=x_exe[3];
		x_exe[4]<=x_exe[4];
		x_exe[5]<=x_exe[5];
		x_exe[6]<=x_exe[6];
		
	end

	
assign y[0]=x_exe[3]*h_exe[0]+x_exe[4]*h_exe[1]+x_exe[5]*h_exe[2]+x_exe[6]*h_exe[3];
assign y[1]=x_exe[2]*h_exe[0]+x_exe[3]*h_exe[1]+x_exe[4]*h_exe[2]+x_exe[5]*h_exe[3];
assign y[2]=x_exe[1]*h_exe[0]+x_exe[2]*h_exe[1]+x_exe[3]*h_exe[2]+x_exe[4]*h_exe[3];
assign y[3]=x_exe[0]*h_exe[0]+x_exe[1]*h_exe[1]+x_exe[2]*h_exe[2]+x_exe[3]*h_exe[3];
assign y[4]=x_exe[6]*h_exe[0]+x_exe[0]*h_exe[1]+x_exe[1]*h_exe[2]+x_exe[2]*h_exe[3];
assign y[5]=x_exe[5]*h_exe[0]+x_exe[6]*h_exe[1]+x_exe[0]*h_exe[2]+x_exe[1]*h_exe[3];
assign y[6]=x_exe[4]*h_exe[0]+x_exe[5]*h_exe[1]+x_exe[6]*h_exe[2]+x_exe[0]*h_exe[3];
//out
always@(posedge clk_2 or negedge rst_n)
	if(!rst_n)begin
		out_valid<=0;
		out_data<=0;
	end else if(count_2!=7)begin
		out_valid<=1;
		out_data<=y[count_2];
	end else begin
		out_valid<=0;
		out_data<=0;
	end
//FSM
always@(posedge clk_1 or negedge rst_n)
	if(!rst_n)
		count_1 <= 3;
	else if(count_1!=3)
		count_1 <= count_1+1;
	else if(in_valid)
		count_1 <= 0;
	else
		count_1 <= count_1;

always@(posedge clk_2 or negedge rst_n)
	if(!rst_n)
		count_2 <= 7;
	else if(count_2!=7)
		count_2 <= count_2+1;
	else if(  /*fill in the blank*/  )
		count_2 <= 0;
	else
		count_2 <= count_2;

syn_XOR in_exe(.IN(/*fill in the blank*/  ),.OUT(/*fill in the blank*/  ),.TX_CLK(/*fill in the blank*/  ),.RX_CLK(/*fill in the blank*/  ),.RST_N(/*fill in the blank*/  ));


//count_mult

always@(posedge clk_2 or negedge rst_n)
	if(!rst_n)
		count_mult <= 'b1;
	else begin
		if(count_mult != 1'b1)
			count_mult <= 1'b1;
		else if (inready)
			count_mult <= 1'b0;
		else 
			count_mult <= count_mult;
	end

endmodule


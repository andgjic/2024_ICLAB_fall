module QS(
	//io
	clk,
	rst_n,
	in_valid,
	in_data,
	action,
	out_valid,
	out_data
);
//io
input	clk;
input	rst_n;
input	in_valid;
input	[7:0]in_data;
input	action;
output	reg out_valid;
output	reg[7:0] out_data;
//FSM setting
parameter	ST_IDLE	 = 'd0,
		ST_INPUT = 'd1,
		ST_OUTPUT= 'd2,
		QUEUE = 'd0,
		STACK = 'd1;
reg[1:0]	cs,ns;
//reg,wire
reg[3:0] count, len;
reg act;
wire[7:0] Q;
reg[3:0] A;
//in
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		act <= 0;
	else if(in_valid&&count==0)begin
		act <= action;
	end else begin
		act <= act;
	end
end

always@(*)begin
	//design of A
end

//out
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		out_valid <= 0;
		out_data <= 0;
	end else if(/**/)begin
		out_valid <= 1;
		out_data <= Q;
	end else begin
		out_valid <= 0;
		out_data <= 0;
	end

//FSM
always@(posedge	clk or negedge rst_n)	begin
	if(!rst_n) cs	<=	ST_IDLE;
	else cs	 <=	ns;
end
					
always@(*)	begin
	case(cs)
		ST_IDLE:	begin
			if(in_valid) ns	=	ST_INPUT;
			else ns	=	ST_IDLE;
		end	
		ST_INPUT:	begin
			if(!in_valid) ns = ST_OUTPUT;
			else ns = ST_INPUT;
		end
		ST_OUTPUT:		begin
			if(/**/)ns	=	ST_IDLE;
			else ns	=	ST_OUTPUT;
		end
	endcase
end

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		count <= 0;
	else if(!in_valid&&cs!=ST_OUTPUT)
		count <= 0;
	else
		count <= count+1;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		len <= 0;
	else if(in_valid)
		len <= count;
	else
		len <= len;

RA1SH U_SRAM(.Q(),.CLK(),.CEN(),.WEN(),.A(),.D(),.OEN());/**/

endmodule

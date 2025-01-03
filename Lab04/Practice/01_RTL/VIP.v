module VIP(
	// Input signals
	clk,
	rst_n,
	in_valid,
	vector_1,
	vector_2,
	// Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

// FSM parameters
parameter	ST_IDLE		=	'd0,
			ST_INPUT	=	'd1,
			ST_CALCULATE =  'd2,
			ST_OUTPUT	=	'd3;
			
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid;
input [inst_sig_width+inst_exp_width:0] vector_1, vector_2;
output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;


endmodule
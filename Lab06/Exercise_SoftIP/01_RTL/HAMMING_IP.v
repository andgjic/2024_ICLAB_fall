//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2024/10
//		Version		: v1.0
//   	File Name   : HAMMING_IP.v
//   	Module Name : HAMMING_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module HAMMING_IP #(parameter IP_BIT = 8) (
    // Input signals
    IN_code,
    // Output signals
    OUT_code
);

// ===============================================================
// Input & Output
// ===============================================================
// IP_BIT 5~11 bits
input [IP_BIT+4-1:0]  IN_code;
output reg [IP_BIT-1:0] OUT_code;
// ===============================================================
// Design
// ===============================================================
parameter EC_BIT = IP_BIT+4;        // range from 9~15

wire [3:0] pos[EC_BIT-1:0];         // bit with 1's position
wire [3:0] tmp[EC_BIT-2:0];         // XOR temp
reg  [EC_BIT-1:0] decode_data;      // after error fix
wire [3:0] err_idx, real_idx;       // record index

// --------- decide position value with enable bit ----------------
// position 1 2 3 4 5 6 7 8 9 
// pos[i]   0 1 2 3 4 5 6 7 8
// real_idx 8 7 6 5 4 3 2 1 0
// data     1 1 0 0 1 0 1 1 0
genvar i;
generate
    for(i=0;i<EC_BIT;i=i+1) begin: position
        assign pos[i] = (IN_code[EC_BIT-1-i]) ? i+1 : 0;
    end
endgenerate

genvar j;
generate
    for(j=0;j<EC_BIT-1;j=j+1) begin: operate
        if(j==0)
            assign tmp[j] = pos[0] ^ pos[1];
        else
            assign tmp[j] = pos[j+1] ^ tmp[j-1];
    end
endgenerate

assign err_idx  = tmp[EC_BIT-2];
assign real_idx = EC_BIT - err_idx;

// error bit fix
genvar k;
generate
    for(k=0;k<EC_BIT;k=k+1) begin: error_bit
        always @(*) begin
            if(k == real_idx)
                decode_data[k] = ~IN_code[k];
            else
                decode_data[k] = IN_code[k];
        end
    end
endgenerate

always @(*) begin
    OUT_code = {decode_data[EC_BIT-3], decode_data[EC_BIT-5], decode_data[EC_BIT-6], decode_data[EC_BIT-7],
                decode_data[EC_BIT-9 : 0]};
end

endmodule  
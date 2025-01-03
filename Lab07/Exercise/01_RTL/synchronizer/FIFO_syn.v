module FIFO_syn #(parameter WIDTH=8, parameter WORDS=64) (
    wclk,
    rclk,
    rst_n,
    winc,
    wdata,
    wfull,
    rinc,
    rdata,
    rempty,

    flag_fifo_to_clk2,
    flag_clk2_to_fifo,

    flag_fifo_to_clk1,
	flag_clk1_to_fifo
);

input wclk, rclk;
input rst_n;
input winc;
input [WIDTH-1:0] wdata;
output reg wfull;
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
output  flag_fifo_to_clk2;
input flag_clk2_to_fifo;

output flag_fifo_to_clk1;
input flag_clk1_to_fifo;

wire [WIDTH-1:0] rdata_q;

// Remember: 
//   wptr and rptr should be gray coded
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr;                // gray write address
reg [$clog2(WORDS):0] rptr;                // gray read address

// address: binary code
reg   [$clog2(WORDS):0] w_addr;          
reg   [$clog2(WORDS):0] r_addr;          
wire  [$clog2(WORDS):0] w_addr_reg;      
wire  [$clog2(WORDS):0] r_addr_reg;      

// pointer: gray code
wire [$clog2(WORDS):0] rq2_wptr;
wire [$clog2(WORDS):0] wq2_rptr;
wire [$clog2(WORDS):0] wptr_reg;
wire [$clog2(WORDS):0] rptr_reg;

// signal
wire wen;
wire w_enable;
wire r_enable;
wire wfull_reg;
wire rempty_reg;

// counter
reg [8:0]cnt_write;
reg [8:0]cnt_read;


//=================================================================================================
//                                          Write  
//=================================================================================================
//* write enable
assign w_enable = winc & !wfull;
assign wen = ~w_enable;
//* wptr
assign wptr_reg = (w_addr_reg >> 1) ^ w_addr_reg;
//* w_addr
assign w_addr_reg = w_addr + w_enable;
//* wfull
assign wfull_reg = (wptr_reg == {~wq2_rptr[6:5],wq2_rptr[4:0]}) ? 1 : 0;

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)      wptr <= 0;
    else            wptr <= wptr_reg; 
end
always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)     w_addr <= 0;
    else           w_addr <= w_addr_reg;
end

always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)     wfull <= 0;
    else           wfull <= wfull_reg;
end

// count write
always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)     cnt_write <= 0;
    else           cnt_write <= cnt_write + w_enable;
end
//=================================================================================================
//                                          read  
//=================================================================================================
//* read enable
assign r_enable = rinc & ~rempty;
//* rptr
assign rptr_reg = (r_addr_reg >> 1) ^ r_addr_reg;
//* r_addr
assign r_addr_reg = r_addr + r_enable;
//* rempty
assign rempty_reg = (rptr_reg == rq2_wptr) ? 1 : 0;

always @(posedge rclk or negedge rst_n) begin
    if(!rst_n)      rptr <= 0;
    else            rptr <= rptr_reg;
end
always @(posedge rclk or negedge rst_n) begin
      if(!rst_n)  r_addr <= 0;
      else        r_addr <= r_addr + r_enable;
end
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n)     rempty <= 0;
    else           rempty <= rempty_reg;
end

// count read
always @(posedge rclk or negedge rst_n) begin
      if(!rst_n)    cnt_read <= 0;
      else          cnt_read <= cnt_read + r_enable;
end
// ================== synchronizer ===================
NDFF_BUS_syn #(.WIDTH(7)) w_to_r (.D(wptr), .Q(rq2_wptr), .clk(rclk), .rst_n(rst_n));
NDFF_BUS_syn #(.WIDTH(7)) r_to_w (.D(rptr), .Q(wq2_rptr), .clk(wclk), .rst_n(rst_n));



// ================== SRAM ===================
// port a write, port b read
DUAL_64X8X1BM1 u_dual_sram (
    .CKA(wclk), .CKB(rclk),
    .WEAN(wen), .WEBN(1'b1),  
    .CSA(1'b1), .CSB(1'b1),
    .OEA(1'b1), .OEB(1'b1),
    .A0(w_addr[0]), .A1(w_addr[1]), .A2(w_addr[2]), .A3(w_addr[3]), .A4(w_addr[4]), .A5(w_addr[5]),
    .B0(r_addr[0]), .B1(r_addr[1]), .B2(r_addr[2]), .B3(r_addr[3]), .B4(r_addr[4]), .B5(r_addr[5]),
    .DIA0(wdata[0]), .DIA1(wdata[1]), .DIA2(wdata[2]), .DIA3(wdata[3]), .DIA4(wdata[4]), .DIA5(wdata[5]), .DIA6(wdata[6]), .DIA7(wdata[7]),
    .DIB0(1'b0),     .DIB1(1'b0),     .DIB2(1'b0),     .DIB3(1'b0),     .DIB4(1'b0),     .DIB5(1'b0),     .DIB6(1'b0),     .DIB7(1'b0),
    .DOB0(rdata_q[0]), .DOB1(rdata_q[1]), .DOB2(rdata_q[2]), .DOB3(rdata_q[3]), .DOB4(rdata_q[4]), .DOB5(rdata_q[5]), .DOB6(rdata_q[6]), .DOB7(rdata_q[7])
);

always @(posedge rclk, negedge rst_n) begin
    if (!rst_n)
        rdata <= 0;
    else 
		rdata <= rdata_q;
end


endmodule





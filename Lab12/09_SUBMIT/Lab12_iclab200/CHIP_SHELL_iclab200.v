module CHIP(
    // Input signals
    rst_n,
    clk,
    in_valid,
    tetrominoes,
    position,
    // Output signals
    tetris_valid,
    score_valid,
    fail,
    score,
    tetris
);

input               rst_n;
input               clk;
input               in_valid;
input       [2:0]   tetrominoes;
input       [2:0]   position;
output              tetris_valid;
output              score_valid;
output              fail;
output      [3:0]   score;
output      [71:0]  tetris;

wire            C_rst_n;
wire            C_clk;
wire            C_in_valid;
wire    [2:0]   C_tetrominoes;
wire    [2:0]   C_position;
wire            C_tetris_valid;
wire            C_score_valid;
wire            C_fail;
wire    [3:0]   C_score;
wire    [71:0]  C_tetris;

TETRIS CORE(
    .rst_n(C_rst_n),
    .clk(C_clk),
    .in_valid(C_in_valid),
    .tetrominoes(C_tetrominoes),
    .position(C_position),
    .tetris_valid(C_tetris_valid),
    .score_valid(C_score_valid),
    .fail(C_fail),
    .score(C_score),
    .tetris(C_tetris)
);

XMD I_CLK    ( .O(C_clk),         .I(clk),          .PU(1'b0), .PD(1'b0), .SMT(1'b0));

YA2GSD O_TVALID ( .I(C_tetris_valid), .O(tetris_valid),   .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));

//I/O power 3.3V pads x? (DVDD + DGND)
VCC3IOD VDDP0 ();
GNDIOD  GNDP0 ();
VCC3IOD VDDP1 ();
GNDIOD  GNDP1 ();


//...

//Core poweri 1.8V pads x? (VDD + GND)
VCCKD VDDC0 ();
GNDKD GNDC0 ();
VCCKD VDDC1 ();
GNDKD GNDC1 ();
//...



endmodule


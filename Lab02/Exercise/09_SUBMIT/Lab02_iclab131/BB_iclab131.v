module BB(
           //Input Ports
           input clk,
           input rst_n,
           input in_valid,
           input [1:0] inning,   // Current inning number
           input half,           // 0: top of the inning, 1: bottom of the inning
           input [2:0] action,   // Action code

           //Output Ports
           output reg out_valid,  // Result output valid
           output reg [7:0] score_A,  // Score of team A (guest team)
           output reg [7:0] score_B,  // Score of team B (home team)
           output reg [1:0] result    // 0: Team A wins, 1: Team B wins, 2: Darw
       );

//==============================================//
//             Action Memo for Students         //
// Action code interpretation:
// 3’d0: Walk (BB)
// 3’d1: 1H (single hit)
// 3’d2: 2H (double hit)
// 3’d3: 3H (triple hit)
// 3’d4: HR (home run)
// 3’d5: Bunt (short hit)
// 3’d6: Ground ball
// 3’d7: Fly ball
//==============================================//


//==============================================//
//           reg, wire declaration              //
//==============================================//
reg c_s, n_s;
reg in_valid_delay;
reg ovf;

reg [2:0] base;
reg [6:0] base_reg;             // base[2:0] for base situation, base[6:3] for score
reg [3:0] score [1:0];          // score[0] for A, score[1] for B
reg [2:0] score_reg;
reg [2:0] score_hold;
reg [1:0] out, out_reg;


//==============================================//
//               in_valid delay                 //
//==============================================//

// in_valid delay
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        in_valid_delay <= 0;
    else
        in_valid_delay <= in_valid;
end



//==============================================//
//                   Design                     //
//==============================================//
// -------------------------- Base situation  ----------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        base <= 0;
    else if(out_reg == 3)
        base <= 0;
    else if(in_valid)
        base <= base_reg;
end

always @(*)
begin
    case(action)
        3'd0:
        begin
            if(!base[0])
                base_reg = {4'b0, base[2:1], 1'b1};
            else if(!base[1])
                base_reg = {4'b0, base[2], 2'b11};
            else if(!base[2])
                base_reg = {4'b0, 3'b111};
            else
                base_reg = {1'b1, base};
        end
        3'd1:
        begin
            if(out[1])
                base_reg = {2'b0,base[2:1],base[0],2'b01};
            else
                base_reg = {3'b0,base[2],base[1:0],1'b1};
        end
        3'd2:
        begin
            if(out[1])
                base_reg = {1'b0,base,3'd2};
            else
                base_reg = {2'b0,base[2:1],base[0],2'b10};
        end
        3'd3:
            base_reg = {1'b0,base,3'd4};
        3'd4:
            base_reg = {base,1'b1,3'd0};
        3'd5:
            base_reg = {3'b0,base[2],base[1:0],1'b0};
        3'd6:
        begin
            if(out[1] || (out[0] && base[0]))
                base_reg = 0;
            else
                base_reg = {3'b0,base[2],base[1],2'b00};
        end
        3'd7:
        begin
            if(!out[1] && base[2])
                base_reg = {3'b0,base[2],1'b0,base[1:0]};
            else
                base_reg = {4'b0,1'b0,base[1:0]};
        end
        default:
            base_reg = 0;
    endcase
end


// --------------------------- score calculate -------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        {score[1], score[0]} <= 0;
    else if(in_valid && !half)           // if condition signal have unknown, 03 will fail
        score[0] <= {ovf,score_reg};     //Exception: A team will get 9 point task
    else if(in_valid && half)
    begin
        if(inning == 3 && score_hold > score[0])
            score[1] <= score_hold;
        else
            score[1] <= score_reg;
    end
    else if(!in_valid_delay)
        {score[1], score[0]} <= 0;
end
// B win hold the value
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        score_hold <= 0;
    else if(in_valid && !half)
        score_hold <= score[1];
end

always @(*)
begin
    {ovf,score_reg} = score[half] + base_reg[6] + base_reg[5] + base_reg[4] + base_reg[3];
end

// ---------------------------- out calculate -----------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out <= 0;
    else if(out_reg == 3)
        out <= 0;
    else if(in_valid)
        out <= out_reg;
end

always @(*)
begin
    if(action[2]&action[0])         //action5
        out_reg = out + 1;
    else if(action[2]&action[1])    //action6、action7
    begin
        if(base[0])
            out_reg = out + 2;
        else
            out_reg = out + 1;
    end
    else
        out_reg = out;
end

// -------------- output ----------------------
always @(*)
begin
    score_A = score[0];
    score_B = score[1];
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        out_valid <= 0;
    else if(!in_valid && in_valid_delay)
        out_valid <= 1;
    else
        out_valid <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        result <= 0;
    else if(!in_valid && in_valid_delay)
    begin
        if(score[1] > score[0])
            result <= 1;
        else if(score[1] == score[0])
            result <= 2;
        else
            result <= 0;
    end
    else
        result <= 0;
end


endmodule

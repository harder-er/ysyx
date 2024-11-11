module alu(ALUctr,ALUA,ALUB,ALUResult,Less,Zero);
input  [ 3: 0] ALUctr;
input  [31: 0] ALUA;
input  [31: 0] ALUB;
output [31: 0] ALUResult;
output         Less;
output         Zero;

wire AL;
//wire LR;
wire US;
wire SA;
assign AL = ALUctr[3];// 1 算数 0 逻辑 
//assign LR = ALUctr[2];// 1 右移（包括逻辑和算数）  0 左移
assign US = ALUctr[3];// 1 无符号 0 有符号
assign SA = ALUctr[3];// 1 减法 0 加法
wire [31: 0] add_sub_result;
wire [31: 0] shift_result;
wire [31: 0] slt_result;
wire [31: 0] B_result;
wire [31: 0] XOR_result;
wire [31: 0] shift2_result;
wire [31: 0] OR_result;
wire [31: 0] AND_result;
/* verilator lint_off UNUSEDSIGNAL */
wire [63: 0] sr_result;
/* verilator lint_off UNUSEDSIGNAL */
// 32-bit adder
wire [31: 0] adder_a;
wire [31: 0] adder_b;
wire         Carry;
wire         Overflow;
assign adder_a   = ALUA;
assign adder_b   = {32{SA}}^ALUB;  //减法时取反
assign {Carry,add_sub_result} = adder_a + adder_b + {31'h0,SA};
assign Zero = ~(|add_sub_result);
assign Overflow = (ALUA[31] == ALUB[31]) & (add_sub_result[31] != ALUA[31]); 

assign XOR_result = ALUA ^ ALUB;
assign OR_result  = ALUA | ALUB;
assign AND_result = ALUA & ALUB;
assign Less       = US ? SA ^ Carry : Overflow ^ add_sub_result[31];
// 左移可能也需要考虑符号变化，目前还没有考虑，不清楚是不是汇编指令那块考虑了已经
assign shift_result   = ALUA << ALUB[4:0];
assign sr_result      = {{32{ALUA[31]&AL}},ALUA} >> ALUB[4:0];
assign shift2_result  = sr_result[31:0];

assign B_result       = ALUB;
assign slt_result     = {31'b0,Less};

// assign ALUResult      = mux81_1(add_sub_result,shift_result,
//slt_result,B_result,XOR_result,shift2_result,OR_result,AND_result,ALUctr[2:0]);
mux81 mux81_1(
  .a(add_sub_result),
  .b(shift_result  ),
  .c(slt_result    ),
  .d(B_result      ),
  .e(XOR_result    ),
  .f(shift2_result ),
  .g(OR_result     ),
  .h(AND_result    ),
  .s(ALUctr[2:0]   ),
  .y(ALUResult     )
);

endmodule

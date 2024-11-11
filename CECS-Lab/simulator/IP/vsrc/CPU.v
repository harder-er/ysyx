// import "DPI-C" context function void get_ebreak();
import "DPI-C" function  int pmem_read(input  int addr);
import "DPI-C" function void pmem_write(
  input int waddr, input int wdata, input byte wmask);

module CPU(
    input         clk,
    input         rstn,
    output [31:0] pc_cur,
    output [31:0] Inst,
    output reg    commit_wb,
    output        uncache_read_wb
    );

always @(posedge clk) begin
    if (!rstn) begin
        commit_wb <= 1'b0;
    end
    else begin
        commit_wb <= 1'b1;
    end
end

wire [31:0] seq_pc;
wire [31:0] next_pc;
reg  [31:0] inst;
reg  [31:0] pc;
assign pc_cur= pc;

InstrMem u_InstrMem(
    .addr(pc),
    .Instr(inst)
);
wire [31:0] imm;

wire [ 6: 0] op;
wire [ 2: 0] func3;
wire [ 6: 0] func7;
wire [2 :0] ExtOp;
wire        RegWr;
wire        ALUAsrc;
wire [1:0]  ALUBsrc;
wire [3 :0] ALUctr;
wire [2 :0] Branch;
wire        MemtoReg;
wire        MemWr;
wire [ 2: 0] MemOp;
wire [ 4: 0] rd;
wire [ 4: 0] rs1;
wire [ 4: 0] rs2;
wire [31: 0] src1;
wire [31: 0] src2;
wire [31: 0] busW;
wire [31: 0] DataOut;
wire [31: 0] immI;
wire [31: 0] immU;
wire [31: 0] immS;
wire [31: 0] immB;
wire [31: 0] immJ;


wire        PCAsrc  ;
wire        PCBsrc  ;


wire [31:0] ALUA   ;
wire [31:0] ALUB   ;
wire [31:0] ALUResult ;
wire        Zero,Less;
wire [31:0] PCA     ;
wire [31:0] PCB     ;


initial begin
    commit_wb = 1'b0;
end

always @(posedge clk) begin
    if (!rstn) begin
        pc <= 32'h80000000;     
    end
    else begin
        pc <= next_pc;
    end
end


assign Inst            = inst;
assign uncache_read_wb  = 1'b0;
assign op    = inst[ 6: 0];
assign rd    = inst[11: 7];
assign rs1   = inst[19:15];
assign rs2   = inst[24:20];
assign func3 = inst[14:12];
assign func7 = inst[31:25];

ContrGen u_ContrGen(
    .op    (op    ),
    .func3 (func3 ),
    .func7 (func7 ),
    .ExtOp  (ExtOp  ),
    .ALUctr (ALUctr),
    .Branch(Branch),
    .ALUAsrc(ALUAsrc),
    .ALUBsrc(ALUBsrc),
    .MemtoReg(MemtoReg),
    .MemOp  (MemOp),
    .MemWr(MemWr),
    .RegWr  (RegWr  )
);


wire   inst_ebreak;
assign inst_ebreak  = (op == 7'b1110011) & (func3 == 3'b000) & (inst[31:20] == 12'b000000000001);
assign immI  = {{20{inst[31]}}, inst[31:20]};
assign immU  = {inst[31:12], 12'b0};
assign immS  = {{20{inst[31]}}, inst[31:25], inst[11:7]};
assign immB  = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
assign immJ  = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};


mux51 mux51_1(
    .a(immI),
    .b(immU),
    .c(immS),
    .d(immB),
    .e(immJ),
    .s(ExtOp),
    .y(imm )
);
// 000 immI,001 immU,010 immS,011 immB,100 immJ
// 译码逻辑可以更快！，KISS 原则先
                        

assign PCAsrc       = (Branch == 3'b110 && Less == 1'b1)|| (Branch == 3'b111 && Less == 1'b0) ||
                        (Branch == 3'b100 && Zero == 1'b1) || (Branch == 3'b101 && Zero == 1'b0) || 
                        (Branch == 3'b001 ) || (Branch == 3'b010)? 1'b1 : 1'b0;
assign PCBsrc       = (Branch == 3'b010) ? 1'b1 : 1'b0;
assign PCA          = PCAsrc ? imm : 32'h4;
assign PCB          = PCBsrc ?  src1 : pc;
assign next_pc = PCA + PCB;




assign ALUA   = ALUAsrc ? src1 : pc;

assign busW = MemtoReg ? DataOut : ALUResult;
mux31 mux31_1(
    .a(src2),
    .b(imm ),
    .c(32'h4),
    .s(ALUBsrc),
    .y(ALUB));

regfile u_regfile(
    .clk    (clk      ),
    .Ra     (rs1      ),
    .busA   (src1     ),
    .Rb     (rs2      ),
    .busB   (src2     ),
    .RegWr  (RegWr    ),
    .Rw     (rd       ),
    .busW   (busW     )
    );



assign ALUA = src1;
assign ALUB = imm;

alu u_alu(
    .ALUctr     (ALUctr    ),
    .ALUA       (ALUA      ),
    .ALUB       (ALUB      ),
    .Zero       (Zero      ),
    .Less       (Less      ),
    .ALUResult  (ALUResult )
    );
DataMem u_DataMem(
    .Addr       (ALUResult      ),
    .MemOp      (MemOp          ),
    .WrEn       (MemWr          ),
    .DataIn     (src2           ),
    .DataOut    (DataOut        )
);

initial begin
    if (inst_ebreak) begin
        // get_ebreak();
        $display("Ebreak at pc = %h", pc);
        $finish;
    end
    // get_ebreak();
end


endmodule

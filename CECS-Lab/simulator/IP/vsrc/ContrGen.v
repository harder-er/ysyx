module ContrGen(op,func3,func7,ExtOp,RegWr,ALUAsrc,ALUBsrc,ALUctr,Branch,MemtoReg,MemWr,MemOp);
    input [6 :0] op;
    input [2 :0] func3;
    input [6 :0] func7;
    output[2 :0] ExtOp;
    output       RegWr;
    output       ALUAsrc;
    output[1:0]  ALUBsrc;
    output[3 :0] ALUctr;
    output       Branch;
    output       MemtoReg;
    output       MemWr;
    output[2 :0] MemOp;
    wire        inst_lui;
    wire        inst_auipc;
    wire        inst_addi;
    wire        inst_auipc;
    wire        inst_lui;
    wire        inst_slti;
    wire        inst_sltiu;
    wire        inst_xori;
    wire        inst_ori;
    wire        inst_andi;
    wire        inst_slli;
    wire        inst_srli;
    wire        inst_srai;
    wire        inst_add;
    wire        inst_sub;
    wire        inst_sll;
    wire        inst_slt;
    wire        inst_sltu;
    wire        inst_xor;
    wire        inst_srl;
    wire        inst_sra;
    wire        inst_and;
    wire        inst_or;

    wire        inst_beq;
    wire        inst_bne;
    wire        inst_blt;
    wire        inst_bge;
    wire        inst_bltu;
    wire        inst_bgeu;

    wire        inst_lb;
    wire        inst_lh;
    wire        inst_lw;
    wire        inst_lbu;
    wire        inst_lhu;
    wire        inst_sb;
    wire        inst_sh;
    wire        inst_sw;

    wire        inst_jal;
    wire        inst_jalr;

    wire [ 2:0] ExtOP   ;
    wire        RegWr   ;
    wire [ 2:0] Branch  ;
    wire        MemtoReg;
    wire        MemWr   ;
    wire [ 2:0] MemOp   ;

    assign inst_addi    = (op == 7'b0010011 ) & (func3 == 3'b000);
    assign inst_auipc   = (op == 7'b0010111);
    assign inst_lui     = (op == 7'b0110111);
    assign inst_slti    = (op == 7'b0010011 ) & (func3 == 3'b010);
    assign inst_sltiu   = (op == 7'b0010011 ) & (func3 == 3'b011);
    assign inst_xori    = (op == 7'b0010011 ) & (func3 == 3'b100);
    assign inst_ori     = (op == 7'b0010011 ) & (func3 == 3'b110);
    assign inst_andi    = (op == 7'b0010011 ) & (func3 == 3'b111);
    assign inst_slli    = (op == 7'b0010011 ) & (func3 == 3'b001) & (func7 == 7'b0000000);
    assign inst_srli    = (op == 7'b0010011 ) & (func3 == 3'b101) & (func7 == 7'b0000000);
    assign inst_srai    = (op == 7'b0010011 ) & (func3 == 3'b101) & (func7 == 7'b0100000);
    assign inst_add     = (op == 7'b0110011 ) & (func3 == 3'b000) & (func7 == 7'b0000000);
    assign inst_sub     = (op == 7'b0110011 ) & (func3 == 3'b000) & (func7 == 7'b0100000);
    assign inst_sll     = (op == 7'b0110011 ) & (func3 == 3'b001) & (func7 == 7'b0000000);
    assign inst_slt     = (op == 7'b0110011 ) & (func3 == 3'b010) & (func7 == 7'b0000000);
    assign inst_sltu    = (op == 7'b0110011 ) & (func3 == 3'b011) & (func7 == 7'b0000000);
    assign inst_xor     = (op == 7'b0110011 ) & (func3 == 3'b100) & (func7 == 7'b0000000);
    assign inst_srl     = (op == 7'b0110011 ) & (func3 == 3'b101) & (func7 == 7'b0000000);
    assign inst_sra     = (op == 7'b0110011 ) & (func3 == 3'b101) & (func7 == 7'b0100000);
    assign inst_or      = (op == 7'b0110011 ) & (func3 == 3'b110) & (func7 == 7'b0000000);
    assign inst_and     = (op == 7'b0110011 ) & (func3 == 3'b111) & (func7 == 7'b0000000);

    assign inst_beq     = (op == 7'b1100011) & (func3 == 3'b000);
    assign inst_bne     = (op == 7'b1100011) & (func3 == 3'b001);
    assign inst_blt     = (op == 7'b1100011) & (func3 == 3'b100);
    assign inst_bge     = (op == 7'b1100011) & (func3 == 3'b101);
    assign inst_bltu    = (op == 7'b1100011) & (func3 == 3'b110);
    assign inst_bgeu    = (op == 7'b1100011) & (func3 == 3'b111);

    assign inst_lb      = (op == 7'b0000011) & (func3 == 3'b000);
    assign inst_lh      = (op == 7'b0000011) & (func3 == 3'b001);
    assign inst_lw      = (op == 7'b0000011) & (func3 == 3'b010);
    assign inst_lbu     = (op == 7'b0000011) & (func3 == 3'b100);
    assign inst_lhu     = (op == 7'b0000011) & (func3 == 3'b101);
    assign inst_sb      = (op == 7'b0100011) & (func3 == 3'b000);
    assign inst_sh      = (op == 7'b0100011) & (func3 == 3'b001);
    assign inst_sw      = (op == 7'b0100011) & (func3 == 3'b010);

    assign inst_jal     = (op == 7'b1101111);
    assign inst_jalr    = (op == 7'b1100111) & (func3 == 3'b000);
    assign ExtOP        = inst_jalr | inst_addi | inst_slti | inst_sltiu | inst_xori | inst_ori 
                            | inst_andi | inst_slli | inst_srli | inst_srai
                            | inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu ? 3'b000 
                                    : inst_lui | inst_auipc ? 3'b001 
                                    : inst_sb | inst_sh | inst_sw ? 3'b010 
                                    : inst_beq | inst_bne | inst_blt | inst_bge | inst_bltu | inst_bgeu ? 3'b011 
                                    : inst_jal ? 3'b100: 3'b111;
    assign RegWr        = ~inst_beq & ~inst_bne & ~inst_blt & ~inst_bge & ~inst_bltu & ~inst_bgeu & inst_sb & ~inst_sh & ~inst_sw;
    assign Branch       = inst_jal ? 3'b001 : inst_jalr ? 3'b010 :
                             inst_beq ? 3'b100 : 
                             inst_bne ? 3'b101 : 
                             inst_bltu | inst_blt ? 3'b110 : 
                             inst_bge  | inst_bgeu? 3'b111 : 3'b000;
    assign MemtoReg     = inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu;
    assign MemWr        = inst_sb | inst_sh | inst_sw;
    assign MemOp        = inst_lb | inst_sb ? 3'b000 : 
                            inst_lh | inst_sh ? 3'b001 :
                            inst_lw | inst_sw ? 3'b010 :
                            inst_lbu          ? 3'b100 :
                            inst_lhu          ? 3'b101 : 3'b111;//111 表示不取值

    assign ALUAsrc  =  inst_addi | inst_jal | inst_jalr ? 1'b1 : 1'b0;
    assign ALUBsrc =  inst_auipc | inst_addi | inst_lui | inst_slti | inst_sltiu 
                    | inst_xori | inst_ori | inst_andi | inst_slli| inst_srli | inst_srai 
                    | inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | inst_sb | inst_sh | inst_sw ? 2'b01 : 
                     inst_jal | inst_jalr ? 2'b10 : 2'b00;

    assign ALUctr = inst_addi | inst_auipc | inst_add | 
            inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | inst_sb | inst_sh | inst_sw  ? 4'b0000 :
            inst_slli| inst_sll  ? 4'b0001 : 
            inst_slti| inst_slt | inst_beq | inst_bne | inst_blt | inst_bge ? 4'b0010 :
            inst_lui  ? 4'b0011 :
            inst_xor | inst_xori ? 4'b0100 :
            inst_srl | inst_srli ? 4'b0101 :
            inst_or  | inst_ori  ? 4'b0110 :
            inst_and | inst_andi ? 4'b0111 :
            inst_sub  ? 4'b1000 :
            inst_sltiu|inst_sltu | inst_bltu | inst_bgeu ? 4'b1010 :
            inst_sra | inst_srai ? 4'b1101 : 4'b1111; 
endmodule
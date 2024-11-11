

module InstrMem(addr,Instr);
    input [31:0] addr;
    output reg [31:0] Instr;
    always @(*) begin
        Instr = pmem_read(addr);
    end

endmodule   
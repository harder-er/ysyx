
  module DataMem(Addr,MemOp,DataIn,WrEn,DataOut);
  input [31:0] Addr,DataIn;
  input [2 :0] MemOp;
  input        WrEn;

  output [31:0] DataOut;
  wire          valid;
  wire   [7 :0] wmask;
  reg    [31:0] rdata;
  assign valid = ~(MemOp == 3'b111);
  assign wmask = (MemOp == 3'b010) ? 8'b0000_1111 : (MemOp == 3'b001 || MemOp == 3'b101) ? 8'b0000_0011 
                    : (MemOp == 3'b100 || MemOp == 3'b000) ? 8'b0000_0001 : 8'b0000_0000;
  always @(*) begin
    if (valid) begin // 有读写请求时
      rdata = pmem_read(Addr)  ;
      if (WrEn) begin // 有写请求时
        pmem_write(Addr, DataIn, wmask);
      end
    end
    else begin
      rdata = 0;
    end
  end
  assign DataOut = (MemOp == 3'b010) ? rdata : (MemOp == 3'b001) ? {{16{rdata[15]}},rdata[15:0]} : 
                        (MemOp == 3'b101) ? {{16'b0},{rdata[15:0]} } : (MemOp == 3'b100) ? {{24'b0},{rdata[7:0]} } :
                        (MemOp == 3'b000) ? {{24{rdata[7]}},{rdata[7:0]} }  : 32'h0;
  

endmodule
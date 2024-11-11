module mux81(a,b,c,d,e,f,g,h,s,y);
  input  [31:0] a,b,c,d,e,f,g,h;
  input  [2:0]  s;
  output [31:0] y;
  MuxKey #(8, 3, 32) i3 (y, s, {
    3'b000, a,
    3'b001, b,
    3'b010, c,
    3'b011, d,
    3'b100, e,
    3'b101, f,
    3'b110, g,
    3'b111, h
  });

endmodule

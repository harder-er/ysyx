module mux51(a,b,c,d,e,s,y);
  input  [31:0] a,b,c,d,e;
  input  [2:0]  s;
  output [31:0] y;
  MuxKey #(5, 3, 32) i2 (y, s, {
    3'b000, a,
    3'b001, b,
    3'b010, c,
    3'b011, d,
    3'b100, e
  });
endmodule

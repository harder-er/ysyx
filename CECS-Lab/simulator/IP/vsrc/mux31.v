module mux31(a,b,c,s,y);
  input  [31:0] a,b,c;
  input  [1:0]  s;
  output [31:0] y;
  MuxKey #(3, 2, 32) i1 (y, s, {
    2'b00, a,
    2'b01, b,
    2'b10, c
  });
endmodule









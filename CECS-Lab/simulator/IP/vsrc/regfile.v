module regfile(
    input  wire        clk,
    // READ PORT 1
    input  wire [ 4:0] Ra,
    output wire [31:0] busA,
    // READ PORT 2
    input  wire [ 4:0] Rb,
    output wire [31:0] busB,
    // WRITE PORT
    input  wire        RegWr,       //write enable, HIGH valid
    input  wire [ 4:0] Rw,
    input  wire [31:0] busW
);
import "DPI-C" function void set_gpr_ptr(input reg [31:0] a []);
reg [31:0] rf[31:0];
//WRITE
    integer i;
    initial begin
        set_gpr_ptr(rf);
        for(i = 0; i < 32; i = i + 1) begin
            rf[i] = 32'H0;
        end
    end
always @(posedge clk) begin
    if (RegWr) rf[Rw] <= busW;
end

//READ OUT 1
assign busA = (Ra==5'b0) ? 32'b0 : rf[Ra];
// mux21 u_mux21(
//     .a ( 32'b0          ),
//     .b ( rf[Ra]     ),
//     .s ( Ra == 5'b0 ),
//     .y ( busA         )
// );

// mux21 u_mux21_2(
//     .a ( 32'b0          ),
//     .b ( rf[Rb]     ),
//     .s ( Rb == 5'b0 ),
//     .y ( busB         )
// );


//READ OUT 2
assign busB = (Rb==5'b0) ? 32'b0 : rf[Rb];

endmodule

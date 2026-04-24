module mux2to1 (
    input [31:0] d0,
    input [31:0] d1,
    input s0,
    output [31:0] out
); 
    assign out = s0 ? d1 : d0;
endmodule
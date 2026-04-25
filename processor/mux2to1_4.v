module mux2to1_4 (
    input [3:0] d0,
    input [3:0] d1,
    input s0,
    output [3:0] out
); 
    assign out = s0 ? d1 : d0;
endmodule
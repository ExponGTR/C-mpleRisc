module mux2to1 (
    input d0,
    input d1,
    input s0,
    output out
);
    assign out = s0 ? d1 : d0;
endmodule
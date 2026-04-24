module CSeA (
    input a,
    input b,
    input c_in,
    output sum,
    output c_out;
);
    wire s1, s2, c1, c2
    fullAdder fa1 (
        .a(a),
        .b(b),
        .c_in(1'b0);
        .sum(s1),
        .c_out(c1),
    );
    fullAdder fa2 (
        .a(a),
        .b(b),
        .c_in(1'b1);
        .sum(s2),
        .c_out(c2),
    );

    //sum selector
    mux2to1 sumsel (
        .d0(s0),
        .d1(s1),
        .s0(c_in),
        .out(sum)
    );
    //carry selector
    mux2to1 carrysel (
        .d0(c0),
        .d1(c1),
        .s0(c_in),
        .out(c_out)
    );
endmodule
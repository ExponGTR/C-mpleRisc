// based on the carry-select adder/subtractor
module adderSubtractor32 (
    input [31:0] a,
    input [31:0] b,
    input contl,
    output [31:0] res,
    output c_out
);
    wire [32:0] c;
    wire [31:0] b_o; // b XOR contl
    assign c[0] = contl;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            xor(b_o[i], b[i], contl);
            CSeA carrySelectAdder (
                .a(a[i]),
                .b(b_o[i]),
                .c_in(c[i]),
                .sum(res[i]),
                .c_out(c[i + 1])
            );
        end
    endgenerate
    
    assign c_out = c[32];

endmodule


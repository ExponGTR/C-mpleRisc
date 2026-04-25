module immediateUnit (
    input [1:0] modifier,
    input [15:0] imm,
    input [26:0] offset,
    output reg [31:0] immx,
    output [31:0] offsetx
);
    //immx
    always @(*) begin
        case (modifier)
            2'b00: immx = {{16{imm[15]}}, imm}; // sign extension
            2'b01: immx = {16'b0, imm}; // unsigned
            2'b10: immx = {imm, 16'b0}; // higher half-word
            default: immx = 32'b0;
        endcase
    end
    //extended offset
    assign offsetx = {{5{offset[26]}}, offset} << 2; //shift by 2 bits and sign extension
endmodule
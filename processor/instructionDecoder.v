module instructionDecoder (
    input [31:0] instr,
    output [4:0] opcode,
    output isImmediate,
    output [3:0] rd,
    output [3:0] rs1,
    output [3:0] rs2,
    output [1:0] modifier,
    output [15:0] imm,
    output [26:0] offset
);
    assign opcode = instr[31:27];
    assign isImmediate = instr[26];
    assign rd = instr[25:22];
    assign rs1 = instr[21:18];
    assign rs2 = instr[17:14];
    assign modifier = instr[17:16];
    assign imm = instr[15:0];
    assign offset = instr[26:0];
endmodule
module processor (
    input clk,
    input rst
);

    wire [31:0] pc;
    wire [31:0] instr;
    wire [4:0] opcode;
    wire isImmediate;
    wire [3:0] rd, rs1, rs2;
    wire [1:0] modifier;
    wire [15:0] imm;
    wire [26:0] offset;
    
    //hardcoded branch signals for now until we build the Decode/Execute stages
    wire isBranchTaken = 1'b0;
    wire [31:0] branchPC = 32'b0;

    instructionFetch fetchUnit (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .pc(pc)
    );

    instructionMem instrMem (
        .pc(pc),
        .instr(instr)
    );

    instructionDecoder instrDecoder (
        .instr(instr),
        .opcode(opcode),
        .isImmediate(isImmediate),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .modifier(modifier),
        .imm(imm),
        .offset(offset)
    );

endmodule
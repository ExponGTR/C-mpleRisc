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
    wire [31:0] immx, offsetx;

    wire [31:0] branchTarget = pc + offsetx;
    //hardcoded branch signals for now until we build the Decode/Execute stages
    wire isBranchTaken = 1'b0;

    //hardcoded for now till cu and alu are made
    wire writeEnable = 1'b0;
    wire [31:0] writeData = 32'b0;
    wire [31:0] readData1, readData2;

    instructionFetch fetchUnit (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchTarget(branchTarget),
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

    immediateUnit immUnit (
        .modifier(modifier),
        .imm(imm),
        .offset(offset),
        .immx(immx),
        .offsetx(offsetx)
    );

    registerFile regFile (
        .clk(clk),
        .rst(rst),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );

endmodule
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
    wire [31:0] immx, offsetx; //extended imm and offset

    wire [31:0] branchTarget = pc + offsetx;
    wire isBeq, isBgt, isUBranch, isRet, isBranchTaken;
    wire eq, gt;
    wire [31:0] branchPC;
    
    wire writeEnable, flagsWriteEnable;
    wire [31:0] writeData = aluResult; //temporary, will fix later
    wire [31:0] readData1, readData2;

    wire [31:0] op2, aluResult, aluInput2;
    wire isEqual, isGreater;
    wire [3:0] aluSignals;

    instructionFetch fetchUnit (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchTarget(branchPC),
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

    // selection of op2
    mux2to1_32 op2sel (
        .d0(readData2),
        .d1(immx),
        .s0(isImmediate),
        .out(aluInput2)
    );

    ALU alu (
        .op1(readData1),
        .op2(aluInput2),
        .aluResult(aluResult),
        .aluSignals(aluSignals), //will fix after cu is built
        .isEqual(isEqual),
        .isGreater(isGreater)
    );

    CU cu (
        .opcode(opcode),
        .writeEnable(writeEnable),
        .flagsWriteEnable(flagsWriteEnable),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .isRet(isRet),
        .aluSignals(aluSignals)
    );

    flagsRegister flagReg (
        .clk(clk),
        .rst(rst),
        .flagsWriteEnable(flagsWriteEnable),
        .isEqual(isEqual),
        .isGreater(isGreater),
        .eq(eq),
        .gt(gt)
    );

    branchUnit bUnit (
.isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .isRet(isRet),
        .eq(eq),
        .gt(gt),
        .branchTarget(branchTarget),
        .op1(readData1), //case of ret
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC)
    );
endmodule
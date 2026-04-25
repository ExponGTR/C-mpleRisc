module processor (
    input clk,
    input rst
);

    wire [31:0] pc;
    wire [31:0] instr;
    wire [4:0] opcode;
    wire isImmediate;
    wire [3:0] rd;
    wire [1:0] modifier;
    wire [26:0] offset;
    wire [31:0] immx;

    wire [31:0] branchTarget;
    wire isLd, isSt, isBeq, isBgt, isUBranch, isCall, isRet, isBranchTaken;
    wire [31:0] branchPC;
    
    wire writeEnable, flagsWriteEnable;
    wire [31:0] readPort1Data, readPort2Data, writePortData;
    wire [3:0] readPort1Addr, readPort2Addr, writePortAddr;

    wire [31:0] op2, aluResult;
    wire [31:0] ldResult;
    wire isEqual, isGreater;
    wire [3:0] aluSignals;

    instructionFetchUnit fetchUnit (
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


    operandFetchUnit opFetchUnit (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .pc(pc),
        .isSt(isSt),
        .isCall(isCall),
        .isRet(isRet),
        .writeEnable(writeEnable),
        .writePortData(writePortData),
        .writePortAddr(writePortAddr),
        .opcode(opcode),
        .isImmediate(isImmediate),
        .rd(rd),
        .immx(immx),
        .branchTarget(branchTarget),
        .op1(readPort1Data),
        .op2(readPort2Data)
    );

    executeUnit exUnit (
        .clk(clk),
        .rst(rst),
        .op1(readPort1Data),
        .op2(readPort2Data),
        .immx(immx),
        .branchTarget(branchTarget),
        .isImmediate(isImmediate),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .isRet(isRet),
        .flagsWriteEnable(flagsWriteEnable),
        .aluSignals(aluSignals),
        .aluResult(aluResult),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken)
    );

    dataMem memoryUnit (
        .clk(clk),
        .rst(rst),
        .isSt(isSt),
        .isLd(isLd),
        .addr(aluResult),
        .writeData(readPort2Data),
        .readData(ldResult)
    );

    registerWritebackUnit regWriteUnit (
        .aluResult(aluResult),
        .ldResult(ldResult),
        .pc(pc),
        .rd(rd),
        .isLd(isLd),
        .isCall(isCall),
        .writePortData(writePortData),
        .writePortAddr(writePortAddr)
    );

    CU controlUnit (
        .opcode(opcode),
        .writeEnable(writeEnable),
        .flagsWriteEnable(flagsWriteEnable),
        .isLd(isLd),
        .isSt(isSt),
        .isCall(isCall),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .isRet(isRet),
        .aluSignals(aluSignals)
    );
endmodule
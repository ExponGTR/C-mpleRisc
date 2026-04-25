module executeUnit (
    input clk,
    input rst,
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] immx,
    input [31:0] branchTarget,
    input isImmediate,
    input isBeq, isBgt, isUBranch, isRet,
    input flagsWriteEnable,
    input [3:0] aluSignals,
    output [31:0] aluResult,
    output [31:0] branchPC,
    output isBranchTaken
);

    wire [31:0] aluInput2;
    wire isEqual, isGreater, eq, gt;

    //selection of second input to alu
    mux2to1_32 op2sel (
        .d0(op2),
        .d1(immx),
        .s0(isImmediate),
        .out(aluInput2)
    );

    ALU alu (
        .op1(op1),
        .op2(aluInput2),
        .immx(immx),
        .aluSignals(aluSignals),
        .aluResult(aluResult),
        .isEqual(isEqual),
        .isGreater(isGreater)
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
        .op1(op1), //if ret
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC)
    );

endmodule
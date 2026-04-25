module branchUnit (
    input isBeq,
    input isBgt,
    input isUBranch,
    input isRet,
    input eq,
    input gt,
    input [31:0] branchTarget,
    input [31:0] op1,
    output isBranchTaken,
    output [31:0] branchPC
);
    assign isBranchTaken = isUBranch | (isBeq & eq) | (isBgt & gt);
    mux2to1_32 branchPCsel (
        .d0(branchTarget),
        .d1(op1),
        .s0(isRet),
        .out(branchPC)
    );
endmodule
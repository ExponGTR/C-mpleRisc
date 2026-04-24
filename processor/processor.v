module Processor (
    input clk,
    input rst
);

    wire [31:0] pc;
    wire [31:0] instr;
    
    //hardcoded branch signals for now until we build the Decode/Execute stages
    wire isBranchTaken = 1'b0;
    wire [31:0] branchPC = 32'b0;

    InstructionFetch fetchUnit (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .pc(pc)
    );

    InstructionMemory instrMem (
        .pc(currentPC),
        .instr(instr)
    );

endmodule
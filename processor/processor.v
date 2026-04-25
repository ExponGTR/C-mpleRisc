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
    //hardcoded branch signals for now until we build the Decode/Execute stages
    wire isBranchTaken = 1'b0;

    //hardcoded for now till cu and alu are made
    wire writeEnable = 1'b0;
    wire [31:0] writeData = 32'b0;
    wire [31:0] readData1, readData2;

    wire [31:0] op2, aluResult, aluInput2;
    wire isEqual, isGreater;

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
        .aluSignals(opcode[3:0]), //will fix after cu is built
        .isEqual(isEqual),
        .isGreater(isGreater)
    );

endmodule
module operandFetchUnit (
    input clk,
    input rst,
    input [31:0] instr,
    input isSt,
    input isCall,
    input isRet,
    input writeEnable,
    input [31:0] writePortData,
    input [3:0] writePortAddr,
    output [4:0] opcode,
    output isImmediate,
    output [3:0] rd,
    output [31:0] immx,
    input [31:0] pc, 
    output [31:0] branchTarget,
    output [31:0] op1,
    output [31:0] op2
);

    wire [3:0] rs1, rs2;
    wire [3:0] readPort1Addr, readPort2Addr;
    wire [1:0] modifier;
    wire [15:0] imm;
    wire [26:0] offset;
    wire [31:0] offsetx;

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

    assign branchTarget = pc + offsetx;

    //readPort1Addr/readPort2Addr/writePortAddr will change according to instr
    //if ret, r15 (ra) goes to readPort1
    mux2to1_4 readport1sel (
        .d0(rs1),
        .d1(4'b1111), //ra
        .s0(isRet),
        .out(readPort1Addr)
    );
    //if st, rd goes to readPort2
    mux2to1_4 readport2sel (
        .d0(rs2),
        .d1(rd),
        .s0(isSt),
        .out(readPort2Addr)
    );
    registerFile regFile (
        .clk(clk),
        .rst(rst),
        .writeEnable(writeEnable),
        .writePortData(writePortData),
        .readPort1Data(op1),
        .readPort2Data(op2),
        .writePortAddr(writePortAddr),
        .readPort1Addr(readPort1Addr),
        .readPort2Addr(readPort2Addr)
    );
endmodule
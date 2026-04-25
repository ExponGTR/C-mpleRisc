`define ADD 5'b00000
`define CMP 5'b00101
`define ASR 5'b01100
`define LD 5'b01110
`define ST 5'b01111
`define BEQ 5'b10000
`define BGT 5'b10001
`define B 5'b10010
`define CALL 5'b10011
`define RET 5'b10100

module CU (
    input [4:0] opcode,
    output reg writeEnable,
    output reg flagsWriteEnable,
    output reg isLd,
    output reg isSt,
    output reg isBeq,
    output reg isBgt,
    output reg isUBranch,
    output reg isCall,
    output reg isRet,
    output reg [3:0] aluSignals
);

    always @(*) begin
        writeEnable = 1'b0;
        flagsWriteEnable = 1'b0;
        aluSignals = 4'b0000;
        isLd = 1'b0;
        isSt = 1'b0;
        isBeq = 1'b0;
        isBgt = 1'b0;
        isUBranch = 1'b0;
        isCall = 1'b0;
        isRet = 1'b0;
        //writeEnable for ld and ALU instr except cmp
        if ((opcode >= `ADD && opcode <= `ASR && opcode != `CMP) || opcode == `LD || opcode == `CALL) begin
            writeEnable = 1'b1;
        end
        //write to flags when cmp
        else if (opcode == `CMP) begin
            flagsWriteEnable = 1'b1;
        end

        if (opcode >= `ADD && opcode <= `ASR) begin
            aluSignals = opcode[3:0];
        end

        //branching logic
        case (opcode)
            `LD: isLd = 1'b1;
            `ST: isSt = 1'b1;
            `BEQ: isBeq = 1'b1;
            `BGT: isBgt = 1'b1;
            `B: isUBranch = 1'b1;
            `CALL: {isUBranch, isCall} = 2'b11;
            `RET: {isUBranch, isRet} = 2'b11;
            default: ;
        endcase
    end
    
endmodule
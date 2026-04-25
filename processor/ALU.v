module ALU (
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] immx,
    input [3:0] aluSignals,
    output reg [31:0] aluResult,
    output reg isEqual,
    output reg isGreater
);
    wire isSub = (aluSignals == 4'b0001 || aluSignals == 4'b0101); //sub, cmp
    wire [31:0] addSubRes;
    adderSubtractor32  addSub (
        .a(op1),
        .b(op2),
        .contl(isSub),
        .res(addSubRes)
    );
    always @(*) begin
        isEqual = (op1 == op2);
        isGreater = ($signed(op1) > $signed(op2));
        case (aluSignals)
            4'b0000: //add
                aluResult = addSubRes;
            4'b0001: //sub
                aluResult = addSubRes;
            4'b0010: //mul
            4'b0011: //div
            4'b0100: //mod
            4'b0101: //cmp
            4'b0110: //and
                aluResult = op1 & op2;
            4'b0111: //or
                aluResult = op1 | op2;
            4'b1000: //not
                aluResult = ~op2;
            4'b1001: //mov
                aluResult = op2;
            4'b1010: //lsl
            4'b1011: //lsr
            4'b1100: //asr
            default: 
        endcase
    end
endmodule
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
        isEqual = 1'b0;
        isGreater = 1'b0;
        case (aluSignals)
            4'b0000: //add
                aluResult = addSubRes;
            4'b0001: //sub
                aluResult = addSubRes;
            4'b0010: //mul
                aluResult = op1 * op2; //will add booth multiplier later
            4'b0011: //div
                aluResult = op1 / op2; //may add a dedicated divider later
            4'b0100: //mod
                aluResult = op1 % op2; //same as above
            4'b0101: begin //cmp
                isEqual = (op1 == op2);
                isGreater = ($signed(op1) > $signed(op2));
            end                
            4'b0110: //and
                aluResult = op1 & op2;
            4'b0111: //or
                aluResult = op1 | op2;
            4'b1000: //not
                aluResult = ~op2;
            4'b1001: //mov
                aluResult = op2;
            4'b1010: //lsl
                aluResult = op1 << op2; //may add a shifting unit later
            4'b1011: //lsr
                aluResult = op1 >> op2; //same as above
            4'b1100: //asr
                aluResult = op1 >>> op2; //same as above
            default: aluResult = 32'b0;
        endcase
    end
endmodule
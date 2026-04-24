module ALU (
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] immx,
    input [2:0] aluSignals,
    output reg [31:0] aluResult,
    output reg isEqual,
    output reg isGreater
);

    

    always @(*) begin
        case (aluSignals)
            4'b0000: adderSubtractor32 adder (
                .a(op1),
                .b(op2),
                .contl(0),
                .res(aluResult)
            ); //add
            4'b0001: adderSubtractor32 subtractor (
                .a(op1),
                .b(op2),
                .contl(1),
                .res(aluResult)
            ); //sub
            default: 
        endcase
    end
endmodule
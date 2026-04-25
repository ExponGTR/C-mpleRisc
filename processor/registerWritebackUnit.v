module registerWritebackUnit (
    input [31:0] aluResult,
    input [31:0] ldResult,
    input [31:0] pc,
    input [3:0] rd,
    input isLd,
    input isCall,
    output [31:0] writePortData,
    output [3:0] writePortAddr
);
    assign writePortData = isCall ? (pc + 32'd4) : (isLd ? ldResult : aluResult);
    assign writePortAddr = isCall ? 4'd15 : rd;
    
endmodule
module registerWritebackUnit (
    input [31:0] aluResult,
    input [31:0] ldResult,
    input [31:0] returnPC,
    input isLd,
    input isCall,
    output [31:0] result,
    output [3:0] writePort
);
    assign result = isCall ? (pc + 32'd4) : (isLd ? ldResult : aluResult);
    assign writePortAddress = isCall ? 4'd15 : rd;
    
endmodule
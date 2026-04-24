module registerFile (
    input clk,
    input rst,
    input writeEnable,
    input [3:0] rd,
    input [3:0] rs1,
    input [3:0] rs2,
    input [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);
    reg [31:0] registers [0:15];
    assign readData1 = registers[rs1];
    assign readData2 = registers[rs2];
    always @(negedge clk or negedge rst) begin
        if (!rst) begin 
            for (integer i = 0; i < 16; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (writeEnable) begin 
            registers[rd] <= writeData;
        end
    end
endmodule
module registerFile (
    input clk,
    input rst,
    input writeEnable,
    input [3:0] writePort,
    input [3:0] readPort1,
    input [3:0] readPort2,
    input [31:0] writeData,
    output [31:0] readData1,
    output [31:0] readData2
);
    reg [31:0] registers [0:15];
    assign readData1 = registers[readPort1];
    assign readData2 = registers[readPort2];
    always @(negedge clk or negedge rst) begin
        if (!rst) begin 
            for (integer i = 0; i < 16; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (writeEnable) begin 
            registers[writePort] <= writeData;
        end
    end
endmodule
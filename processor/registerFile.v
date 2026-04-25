module registerFile (
    input clk,
    input rst,
    input writeEnable,
    input [3:0] writePortAddr,
    input [3:0] readPort1Addr,
    input [3:0] readPort2Addr,
    input [31:0] writePortData,
    output [31:0] readPort1Data,
    output [31:0] readPort2Data
);
    reg [31:0] registers [0:15];
    assign readPort1Data = registers[readPort1Addr];
    assign readPort2Data = registers[readPort2Addr];
    always @(negedge clk or negedge rst) begin
        if (!rst) begin 
            for (integer i = 0; i < 16; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (writeEnable) begin 
            registers[writePortAddr] <= writePortData;
        end
    end
endmodule
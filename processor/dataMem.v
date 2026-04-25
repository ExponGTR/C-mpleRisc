module dataMem (
    input clk,
    input rst,
    input isSt,
    input isLd,
    input [31:0] addr,
    input [31:0] writeData,
    output [31:0] readData
);

    reg [31:0] mem [0:2047]; //8 KB
    integer i;

    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 2048; i = i + 1) begin
                mem[i] <= 32'b0;
            end
        end
        else if (isSt) begin
            mem[addr[12:2]] <= writeData;
        end
    end

    mux2to1_32 readsel (
        .d0(mem[addr[12:2]]);
        .d1(32'bz);
        .s0(isLd);
        .out(readData)
    );
endmodule
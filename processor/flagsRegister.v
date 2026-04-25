module flagsRegister (
    input clk,
    input rst,
    input flagsWriteEnable,
    input isEqual,
    input isGreater,
    output reg eq,
    output reg gt
);

    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            eq <= 1'b0;
            gt <= 1'b0;
        end
        else if (flagsWriteEnable) begin
            eq <= isEqual;
            gt <= isGreater;
        end
    end

endmodule
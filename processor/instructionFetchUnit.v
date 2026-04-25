
module instructionFetchUnit (
    input clk,
    input rst,
    input isBranchTaken,
    input [31:0] branchTarget,
    output reg [31:0] pc
);
    //using active-low reset and falling edge clock
    wire [31:0] newPC;
    mux2to1_32 pcMux(
        .s0(isBranchTaken),
        .d1(branchTarget),
        .d0(pc + 32'd4),
        .out(newPC)
    );
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 32'b0;
        end
        else begin
            pc <= newPC;
        end
    end
endmodule
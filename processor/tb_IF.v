module tb_InstructionFetch();

    reg clk;
    reg rst;
    reg isBranchTaken;
    reg [31:0] branchPC;
    wire [31:0] pc;

    InstructionFetch uut (
        .clk(clk),
        .rst(rst),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .pc(pc)
    );

    //clock generation
    always #5 clk = ~clk;

    //stimulus
    initial begin
        clk = 0;
        rst = 0;
        isBranchTaken = 0;
        branchPC = 32'd0;
        #20 rst = 1;
        #30 isBranchTaken = 1;
        branchPC = 32'h0000_00A0;
        #10 isBranchTaken = 0;
        
        #30 $finish;
    end
    
    //monitor
    initial begin
        $monitor("Time: %0t, rst: %b, isBranchTaken: %b, branchPC: %h, pc: %h", 
                  $time, rst, isBranchTaken, branchPC, pc);
    end

endmodule
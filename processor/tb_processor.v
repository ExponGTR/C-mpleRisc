module tb_processor();

    reg clk;
    reg rst;
    integer cycle;

    // Instantiate the Top-Level Processor
    processor uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Stimulus and Simulation Control
    initial begin
        $display("Starting SimpleRisc Processor Simulation...");
        
        clk = 0;
        rst = 0;
        cycle = 0;
        #15 rst = 1; 
        #200;
        
        $display("FINAL REGISTER FILE STATE");
        uut.opFetchUnit.regFile.dumpReg();
        $finish;
    end
    
    always @(negedge clk) begin
        if (rst) begin
            // Wait 1 time unit to let the negative-edge non-blocking assignments (<=) settle
            #1; 
            cycle = cycle + 1;
            $display("Cycle: %3d, PC: 0x%08h, Instr: 0x%08h, Opcode: %b, ALU Out: 0x%08h, Branch: %b", 
                cycle, uut.pc, uut.instr, uut.opcode,uut.aluResult, uut.isBranchTaken);
        end
    end

endmodule
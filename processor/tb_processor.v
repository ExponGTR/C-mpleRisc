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
        
        $display("FINAL REGISTER FILE STATE             ");
        for (integer i = 0; i < 16; i = i + 1) begin
            if (uut.regFile.registers[i] !== 32'b0) begin
                $display(" R%0d \t= %0d \t(Hex: 0x%08h)", i, $signed(uut.regFile.registers[i]), uut.regFile.registers[i]);
            end
        end     
        
        $finish;
    end
    
    always @(negedge clk) begin
        if (rst) begin
            // Wait 1 time unit to let the negative-edge non-blocking assignments (<=) settle
            #1; 
            cycle = cycle + 1;
            $display("Cycle: %3d, PC: 0x%08h, Instr: 0x%08h, Opcode: %b, rs1: %d, rs2: %d, rd: %d | ALU Out: 0x%08h | WE: %b | Branch: %b", 
                cycle, uut.pc, uut.instr, uut.opcode, uut.rs1, uut.rs2, uut.rd, uut.aluResult, uut.writeEnable, uut.isBranchTaken);
        end
    end

endmodule
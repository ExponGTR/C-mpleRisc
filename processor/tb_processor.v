module tb_processor();

    reg clk;
    reg rst;

    // Instantiate the Top-Level Processor
    processor uut (
        .clk(clk),
        .rst(rst)
    );

    //clock gen
    always #5 clk = ~clk;

    //stimulus
    initial begin
        clk = 0;
        rst = 0;
        
        #20 rst = 1;
        #100 $finish;
    end
    
    initial begin
        $monitor(
            "Time: %0t, rst: %b, PC: %h, Instruction: %h, Opcode: %b, rd: %d, rs1: %d, rs2: %d, md: %b, immx: %h, offset: %h, R1: %h, R2: %h, ALU Output: %h", 
            $time, rst, uut.pc, uut.instr, uut.opcode, uut.rd, uut.rs1, uut.rs2, uut.modifier, uut.immx,
            uut.offset, uut.readData1, uut.readData2, uut.aluResult
        );
    end

endmodule
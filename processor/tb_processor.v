module tb_Processor();

    reg clk;
    reg rst;

    // Instantiate the Top-Level Processor
    Processor uut (
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
        $monitor("Time: %0t, rst: %b, PC: %h, Instruction: %h", 
                  $time, rst, uut.pc, uut.instr);
    end

endmodule
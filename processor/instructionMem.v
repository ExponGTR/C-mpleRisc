module InstructionMemory (
    input [31:0] pc,
    output [31:0] instr
);
    reg [31:0] memory [0:2047];
    initial begin
        $readmemh("prog.hex", memory);
    end

    //since instr size is 4 bytes, last 2 bits are for byte offset
    assign instr = memory[pc[31:2]];
endmodule
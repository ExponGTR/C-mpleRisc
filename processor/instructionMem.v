module instructionMem (
    input [31:0] pc,
    output [31:0] instr
);
    reg [31:0] mem [0:2047];
    initial begin
        $readmemh("C:\Users\expon\OneDrive\Desktop\Emulation\C-mpleRisc\processor\prog.hex", mem);
    end

    //since instr size is 4 bytes, last 2 bits are for byte offset
    assign instr = mem[pc[31:2]];
endmodule
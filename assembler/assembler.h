#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <stdint.h>

typedef enum Register
{
    r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15
}
Register;

typedef enum Opcode
{
    OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_MOD, OP_CMP, OP_AND, OP_OR, OP_NOT, OP_MOV,
    OP_LSL, OP_LSR, OP_ASR, OP_NOP, OP_LD,  OP_ST,  OP_BEQ, OP_BGT, OP_B, OP_CALL, OP_RET
}
Opcode;

// SimpleRisc has three instruction formats:

// 1. Branch: Branch instructions only have an offset address as an operand.
// Encoding:
// Bits 0-26: Offset (offset)
// Bits 27-31: Opcode (op)

// 2. Immediate: The second source operand is an immediate value.
// Encoding:
// Bits 0-15: Immediate value (imm)
// Bits 16-17: Modifier bits (md)
// Bits 18-21: Source register 1 (rs1)
// Bits 22-25: Destination register (rd)
// Bit 26 : Immediate present (I)
// Bits 27-31 : Opcode (op)

// 3. Register: Both source operands are registers.
// Encoding:
// Bits 0-13: Unused (unused)
// Bits 14-17: Source register 2 (rs2)
// Bits 18-21: Source register 1 (rs1)
// Bits 22-25: Destination register (rd)
// Bit 26 : Immediate present (I)
// Bits 27-31 : Opcode (op)

// Reference: Section 3.3.14 of the book.


typedef union Instr
{
    struct
    {
        int offset : 27;
        unsigned int op : 5;
    }
    b_type;

    struct
    {
        int16_t imm : 16;
        unsigned int md: 2;
        unsigned int rs1 : 4;
        unsigned int rd : 4;
        unsigned int I : 1;
        unsigned int op : 5;
    }
    i_type;
    
    struct
    {
        unsigned int unused: 14;
        unsigned int rs2 : 4;
        unsigned int rs1 : 4;
        unsigned int rd : 4;
        unsigned int I : 1;
        unsigned int op : 5;
    }
    r_type;

    uint32_t machine_code;
}
Instr;


static const int hex_map[256] =
{
    ['0'] = 0, ['1'] = 1, ['2'] = 2, ['3'] = 3, ['4'] = 4, ['5'] = 5, ['6'] = 6, ['7'] = 7, ['8'] = 8, ['9'] = 9,
    ['a'] = 10, ['b'] = 11, ['c'] = 12, ['d'] = 13, ['e'] = 14, ['f'] = 15,
    ['A'] = 10, ['B'] = 11, ['C'] = 12, ['D'] = 13, ['E'] = 14, ['F'] = 15
};

typedef enum TokenType 
{
    TK_OP, TK_REG, TK_IMM, TK_COMMA, TK_EOF
}
TokenType;

typedef struct Token 
{
    TokenType type;
    union 
    {
        Opcode op; // TK_OP
        Register reg; // TK_REG
        int16_t imm; // TK_IMM
    }
    data;
}
Token;

#endif
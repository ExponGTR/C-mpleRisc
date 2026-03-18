// An assembler for the SimpleRisc ISA. 
// Made by Adil Khan for the course EC2203 (Computer Organisation and Architecture) at IIT Patna.
// Original SimpleRisc ISA by Prof. Smruti R. Sarangi, CSE, IIT Delhi.
// Source: https://www.cse.iitd.ac.in/~srsarangi/archbooksoft.html


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include "assembler.h"


uint16_t lc; // Location counter

static const int hex_map[256] =
{
    ['0'] = 0, ['1'] = 1, ['2'] = 2, ['3'] = 3, ['4'] = 4, ['5'] = 5, ['6'] = 6, ['7'] = 7, ['8'] = 8, ['9'] = 9,
    ['a'] = 10, ['b'] = 11, ['c'] = 12, ['d'] = 13, ['e'] = 14, ['f'] = 15,
    ['A'] = 10, ['B'] = 11, ['C'] = 12, ['D'] = 13, ['E'] = 14, ['F'] = 15
};

typedef struct OpMap
{
    const char *mnemonic;
    Opcode op;
    uint8_t md;
}
OpMap;

static const OpMap opcode_table[] =
{
    {"add",  OP_ADD, 0}, {"addh", OP_ADD, 2}, {"addu", OP_ADD, 1},
    {"and",  OP_AND, 0}, {"andh", OP_AND, 2}, {"andu", OP_AND, 1},
    {"asr",  OP_ASR, 0},
    {"b",    OP_B,   0},
    {"beq",  OP_BEQ, 0},
    {"bgt",  OP_BGT, 0},
    {"call", OP_CALL,0},
    {"cmp",  OP_CMP, 0}, {"cmph", OP_CMP, 2}, {"cmpu", OP_CMP, 1},
    {"div",  OP_DIV, 0}, {"divh", OP_DIV, 2}, {"divu", OP_DIV, 1},
    {"ld",   OP_LD,  0}, 
    {"lsl",  OP_LSL, 0}, 
    {"lsr",  OP_LSR, 0},
    {"mod",  OP_MOD, 0}, {"modh", OP_MOD, 2}, {"modu", OP_MOD, 1},
    {"mov",  OP_MOV, 0}, {"movh", OP_MOV, 2}, {"movu", OP_MOV, 1},
    {"mul",  OP_MUL, 0}, {"mulh", OP_MUL, 2}, {"mulu", OP_MUL, 1},
    {"nop",  OP_NOP, 0},
    {"not",  OP_NOT, 0}, {"noth", OP_NOT, 2}, {"notu", OP_NOT, 1},
    {"or",   OP_OR,  0}, {"orh",  OP_OR,  2}, {"oru",  OP_OR,  1},
    {"ret",  OP_RET, 0},
    {"st",   OP_ST,  0},
    {"sub",  OP_SUB, 0}, {"subh", OP_SUB, 2}, {"subu", OP_SUB, 1}
};


Token lex(FILE* ifp); // todo


int main(int argc, char *argv[])
{
    FILE *ifp, *ofp;
    char src[200], dst[200];
    if (argc != 3)
    {
        printf("Usage: ./a.out <src> <dst>\n");
        exit(0);
    }
    strcpy(src, argv[1]); strcpy(dst, argv[2]);
    if ((ifp = fopen(src, "r")) == NULL)
    {
        printf("File does not exist.\n");
        exit(0);
    }
    if ((ofp = fopen(dst, "w")) == NULL)
    {
        printf("File does not exist.\n");
        exit(0);
    }

    // Initialisation
    lc = 0;


    // Use a lexer to read the .asm file
    // Tag tokens to be parsed and store
    // Remove whitespaces and comments
    lex(ifp);


    // Parse the tokens


    // Write the machine code to a file and also print it on the terminal


    return 0;
}

Token lex(FILE *ifp)
{
    Token t;
    int c;
    while ((c = fgetc(ifp)) != EOF)
    {
        // Whitespace
        if (isspace(c)) continue;

        if (c == '[')
        {
            t.type = TK_LB;
            return t;
        }
        if (c == ']')
        {
            t.type = TK_RB;
            return t;
        }

        // Comments
        if (c == ';')
        {
            while ((c = fgetc(ifp)) != '\n' && c != EOF);
            continue;
        }
        break;
    }

    // EOF
    if (c == EOF)
    {
        t.type = TK_EOF;
        return;
    }


    // Comma
    if (c == ',')
    {
        t.type = TK_COMMA;
        return t;
    }

    // Immediate
    if (isdigit(c) || c == '-')
    {
        int val = 0;
        int sign = 1;
        if (c == '-')
        {
            sign = -1;
            c = fgetc(ifp);
        }

        if (c == '0')
        {
            int check = fgetc(ifp);
            // Hexadecimal
            if (check == 'x' || check == 'X')
            {
                while (isxdigit(c = fgetc(ifp)))
                    val = (val << 4) | hex_map[c];
                if (c != EOF) ungetc(c, ifp);
                t.type = TK_IMM;
                t.data.imm = (int16_t)(val * sign);
                return t;
            }
            else ungetc(check, ifp);
        }

        // Decimal
        while (isdigit(c))
        {
            val = val * 10 + (c - '0');
            c = fgetc(ifp);
        }
        if (c != EOF) ungetc(c, ifp);
        t.type = TK_IMM;
        t.data.imm = (int16_t)(val * sign);
        return t;
    }

    if (isalpha(c))
    {
        char buffer[50];
        for (int i = 0; i < 50; i++)
        {
            if (!isalnum(c) || i == 49)
            {
                buffer[i] = '\0';
                if (c != EOF) ungetc(c, ifp);
                break;
            }
            buffer[i] = c;
            c = fgetc(ifp);
        }

        // Register
        if (buffer[0] == 'r' && isdigit(buffer[1]))
        {
            int val = buffer[1] - '0';
            if (isdigit(buffer[2]))
                val = val * 10 + (buffer[2] - '0');
            t.type = TK_REG;
            t.data.reg = val;
            return t;
        }

        // Opcode
        int l = 0, r = (sizeof(opcode_table) / sizeof(OpMap)) - 1;
        OpMap *res = NULL;

        // Binary search for instr
        while (l <= r)
        {
            int m = l + (r - l) / 2;
            int check = strcmp(buffer, opcode_table[m].mnemonic);
            if (check == 0)
            {
                res = &opcode_table[m];
                break;
            }
            else if (check < 0) r = m - 1;
            else l = m + 1;
        }
        if (res != NULL)
        {
            t.type = TK_OP;
            t.data.op_data.op = res->op;
            t.data.op_data.md = res->md;
            return t;
        }

        // No match
        t.type = TK_INVALID;
        return t;
    }
} 
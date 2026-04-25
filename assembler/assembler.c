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

#define MAX_TOKENS 2000
#define MAX_SYMBOLS 100

Token tokens[MAX_TOKENS];
int token_count = 0;

typedef struct Symbol
{
    char name[50];
    uint16_t address;
} Symbol;

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

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


Token lex(FILE* ifp);


int main(int argc, char *argv[])
{
    FILE *ifp, *ofp;
    char src[200], dst[200];
    if (argc != 3)
    {
        printf("Usage: ./a.out <src> <dst>\n");
        exit(0);
    }
    strcpy(src, argv[1]);
    strcpy(dst, argv[2]);
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
    token_count = 0;
    symbol_count = 0;

    Token t;
    while (1)
    {
        t = lex(ifp);
        if (t.type == TK_EOF) break;
        
        if (t.type == TK_INVALID)
        {
            printf("Error: Unrecognized symbol encountered by the Lexer.\n");
            exit(1);
        }
        
        tokens[token_count++] = t;
    }
    fclose(ifp);

    // first pass
    for (int i = 0; i < token_count; i++)
    {
        if (tokens[i].type == TK_LABEL_DECL)
        {
            // record the label and the current address inline
            strcpy(symbol_table[symbol_count].name, tokens[i].data.label);
            symbol_table[symbol_count].address = lc;
            symbol_count++;
        }
        else if (tokens[i].type == TK_OP) lc += 4;
    }

    printf("\tSymbol Table\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("Label: %s \t Address: %d\n", symbol_table[i].name, symbol_table[i].address);
    }

    if ((ofp = fopen(dst, "w")) == NULL)
    {
        printf("Error opening output file.\n");
        exit(1);
    }

    // second pass
    lc = 0;
    int current_token = 0;
    while (current_token < token_count)
    {
        Token t = tokens[current_token];

        if (t.type == TK_OP)
        {
            Instr instr;
            instr.machine_code = 0; // Zero out the bits to be safe
            
            Opcode op = t.data.op_data.op;
            uint8_t md = t.data.op_data.md;
            
            // 3-Operand ALU instructions
            if (op == OP_ADD || op == OP_SUB || op == OP_MUL || op == OP_DIV || 
                op == OP_MOD || op == OP_AND || op == OP_OR  || op == OP_LSL || 
                op == OP_LSR || op == OP_ASR)
            {
                //Syntax: op rd, rs1, rs2/imm
                
                current_token++; // move to rd
                int rd = tokens[current_token].data.reg;
                current_token += 2; // skip rd TK_COMMA and move to rs1
                int rs1 = tokens[current_token].data.reg;
                current_token += 2; // skip rs1 and TK_COMMA and move to last operand
                
                // check r-type or i-type
                if (tokens[current_token].type == TK_REG)
                {
                    int rs2 = tokens[current_token].data.reg;
                    instr.r_type.op = op;
                    instr.r_type.I = 0;
                    instr.r_type.rd = rd;
                    instr.r_type.rs1 = rs1;
                    instr.r_type.rs2 = rs2;
                    instr.r_type.unused = 0;
                }
                else if (tokens[current_token].type == TK_IMM)
                {
                    int16_t imm = tokens[current_token].data.imm;
                    instr.i_type.op = op;
                    instr.i_type.I = 1;
                    instr.i_type.rd = rd;
                    instr.i_type.rs1 = rs1;
                    instr.i_type.md = md;
                    instr.i_type.imm = imm;
                }
            }

            // 2-Operand instructions (cmp, mov, not)
            else if (op == OP_MOV || op == OP_NOT || op == OP_CMP)
            {
                int r_first = tokens[++current_token].data.reg;
                current_token += 2; // skip comma
                
                if (op == OP_CMP)
                {
                    if (tokens[current_token].type == TK_REG)
                    {
                        instr.r_type.op = op;
                        instr.r_type.I = 0;
                        instr.r_type.rs1 = r_first;
                        instr.r_type.rs2 = tokens[current_token].data.reg;
                    }
                    else
                    {
                        instr.i_type.op = op;
                        instr.i_type.I = 1;
                        instr.i_type.rs1 = r_first;
                        instr.i_type.md = md;
                        instr.i_type.imm = tokens[current_token].data.imm;
                    }
                }
                else
                {
                    // mov/not rd, rs/imm
                    instr.i_type.op = op;
                    instr.i_type.rd = r_first;
                    if (tokens[current_token].type == TK_REG)
                    {
                        instr.r_type.I = 0; 
                        if (op == OP_MOV) instr.r_type.rs2 = tokens[current_token].data.reg;
                        else instr.r_type.rs1 = tokens[current_token].data.reg;
                    }
                    else
                    {
                        instr.i_type.I = 1;
                        instr.i_type.md = md;
                        instr.i_type.imm = tokens[current_token].data.imm;
                    }
                }
            }
            
            // Memory instructions (ld, st)
            else if (op == OP_LD || op == OP_ST)
            {
                int rd = tokens[++current_token].data.reg;
                current_token += 2; // skip comma
                int16_t imm = tokens[current_token].data.imm;
                current_token += 2; // skip [
                int rs1 = tokens[current_token].data.reg;
                current_token++; // skip ]
                
                instr.i_type.op = op; instr.i_type.I = 1;
                instr.i_type.rd = rd; instr.i_type.rs1 = rs1; instr.i_type.imm = imm;
            }

            // Branch instructions (b, beq, call)
            else if (op >= OP_BEQ && op <= OP_CALL)
            {
                char* target = tokens[++current_token].data.label;
                int target_addr = -1;
                for (int i = 0; i < symbol_count; i++) {
                    if (strcmp(symbol_table[i].name, target) == 0) {
                        target_addr = symbol_table[i].address;
                        break;
                    }
                }
                instr.b_type.op = op;
                instr.b_type.offset = target_addr - lc; // byte offset
            }

            // ret, nop
            else if (op == OP_RET || op == OP_NOP)
            {
                instr.b_type.op = op;
                instr.b_type.offset = 0;
            }

            fprintf(ofp, "%08X\n", instr.machine_code);
            printf("%08X\n", instr.machine_code);
            
            lc += 4;
        }
        
        current_token++;
    }

    fclose(ofp);
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

    if (c == EOF)
    {
        t.type = TK_EOF;
        return t;
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

    // words
    if (isalpha(c) || c == '.')
    {
        char buffer[50];
        int i = 0;
        
        // read until whitespace or an invalid char
        while (i < 49 && (isalnum(c) || c == '.' || c == '_' || c == ':'))
        {
            buffer[i++] = c;
            c = fgetc(ifp);
        }
        buffer[i] = '\0';
        if (c != EOF) ungetc(c, ifp);

        // label
        if (buffer[i - 1] == ':')
        {
            buffer[i - 1] = '\0'; // stripping the colon
            t.type = TK_LABEL_DECL;
            strcpy(t.data.label, buffer);
            return t;
        }

        // register
        if (buffer[0] == 'r' && isdigit(buffer[1]))
        {
            int val = buffer[1] - '0';
            if (isdigit(buffer[2]))
                val = val * 10 + (buffer[2] - '0');
            t.type = TK_REG;
            t.data.reg = val;
            return t;
        }

        // opcode
        int l = 0, r = (sizeof(opcode_table) / sizeof(OpMap)) - 1;
        OpMap *res = NULL;

        while (l <= r)
        {
            int m = l + (r - l) / 2;
            int check = strcmp(buffer, opcode_table[m].mnemonic);
            if (check == 0)
            {
                res = (OpMap*)&opcode_table[m];
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

        // if not a register or opcode, it must be a label
        t.type = TK_LABEL;
        strcpy(t.data.label, buffer);
        return t;
    }
    
    // Unrecognized symbol
    t.type = TK_INVALID;
    return t;
}
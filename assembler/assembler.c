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

        // Comments
        if (c == ';')
        {
            while ((c = fgetc(ifp)) != '\n' && c != EOF);
            continue;
        }
        break;
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
        int buffer[50];
        for (int i = 0; i < 50; i++)
        {
            if (!isalnum(c) || i == 49)
            {
                buffer[i] = '\0';
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
        
    }
} 
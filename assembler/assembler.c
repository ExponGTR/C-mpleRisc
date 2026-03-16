// An assembler for the SimpleRisc ISA. 
// Made by Adil Khan for the course EC2203 (Computer Organisation and Architecture) at IIT Patna.
// Original SimpleRisc ISA by Prof. Smruti R. Sarangi, CSE, IIT Delhi.
// Source: https://www.cse.iitd.ac.in/~srsarangi/archbooksoft.html


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "assembler.h"


uint16_t lc; // Location counter

typedef enum TokenType {
    TK_OP, TK_REG, TK_IMM, TK_COMMA, TK_EOF
} TokenType;

typedef struct Token {
    TokenType type;
    union {
        Opcode op; // TK_OP
        Register reg; // TK_REG
        int16_t imm; // TK_IMM
    } data;
} Token;

Token lexer(FILE* ifp); // todo


int main(int argc, char *argv[]) {
    FILE *ifp, *ofp;
    char src[200], dst[200];
    if (argc != 3) {
        printf("Usage: ./a.out <src> <dst>\n");
        exit(0);
    }
    strcpy(src, argv[1]); strcpy(dst, argv[2]);
    if ((ifp = fopen(src, "r")) == NULL) {
        printf("File does not exist.\n");
        exit(0);
    }
    if ((ofp = fopen(dst, "w")) == NULL) {
        printf("File does not exist.\n");
        exit(0);
    }

    // Initialisation
    lc = 0;


    // Use a lexer to read the .asm file
    // Tag tokens to be parsed and store
    // Remove whitespaces and comments
    lexer(ifp);


    // Parse the tokens


    // Write the machine code to a file and also print it on the terminal


    return 0;
}
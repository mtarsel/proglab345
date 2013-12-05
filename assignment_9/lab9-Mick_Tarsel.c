#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>

/* token types */
#define OPERATOR    0
#define NUMBER  1
#define DOTOP 2
#define ARROWOP 3 

int current_token, current_attribute;

char buffer[35];

int expr(), factor(), term(); 
void match(int),error(char *);

int main(){

    int value;
    fprintf(stderr, ">>>");
    current_token = get_token();
    value = expr();
    assert(current_token == '\n');
    fprintf(stderr, "\nNo errors: %d\n", value);    

}

void error( char *message )
{
    fprintf( stderr, "Error: %s.\n\n", message );
    exit(1);
}

uint64_t concat(int x, int y) {//long int
//limits to 10 digits
    int temp = y;
    while (y != 0) {
        x *= 10;
        y /= 10;
    }
    return x + temp;
}

int expr()
{
    int value = term();

    while (current_token == DOTOP){
	if (current_attribute == '.'){
	    match(DOTOP);

	    value = concat(value, term());	    

	}
    }
    return value;
}



int term()
{
    int value = factor();
    while (current_token == ARROWOP)
    {
        if (current_attribute == '^')
        {
            match(ARROWOP);
            value *= factor();//TODO
        }
    }
    return value;
}

int factor()
{
    int value;
    if (current_token == '(')
    {
        match('(');
        value = expr();
        match(')');
    }
    else if (current_token == NUMBER)
    {
        value = current_attribute;
        match(NUMBER);
    }
    else
    {
        error("Unexpected token in factor");
    }
    return value;
}



void match( int token )
{
    if (current_token == token)
    {
        current_token = get_token();
    }
    else
    {
        error("Unmatched token");
    }
}


/* tokenizer */
int get_token()
{
    int c;
    int value;

    while (1) {
        switch (c = getchar()) {
        case '.': 
            current_attribute = c;
            fprintf(stderr, "[DOTOP:%c]", c);
            return DOTOP;
        case '^':
            current_attribute = c;
            fprintf(stderr, "[ARROWOP:%c]", c);
            return ARROWOP;
        case '(':
        case ')':
            fprintf(stderr, "[SPECIAL:%c]", c);
            return c;
        case ' ':
        case '\t':
            continue;
        case '\n':
            fprintf(stderr, "%c", c);
            return c;
        default:
            if (isdigit(c)) {
                value = 0;
                do {
                    value = 10*value + (c - '0');
                }
                while (isdigit(c = getchar()));
                ungetc(c, stdin);
                current_attribute = value;
                fprintf(stderr, "[NUM:%d]", current_attribute);
                return NUMBER;
            }
            else {
                fprintf(stderr, "[ERROR:%c]", c);
                return c;
            }
        }
    }
}



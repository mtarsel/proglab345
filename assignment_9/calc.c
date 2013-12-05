#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/* token types */
#define OPERATOR    0
#define NUMBER	1
#define ADDOP	    2
#define MULOP	    3


/* globals */
int current_token;
int current_attribute;

int expr(), term(), factor();
void match( int ), error( char * );


main()
{   
    int value;
    fprintf(stderr, ">>>"); 
    current_token = get_token();
    value = expr();
    assert(current_token == '\n');
    fprintf(stderr, "\nNo errors: %d\n", value);
}

/* parser */

int expr()
{
    int value = term();
    while (current_token == ADDOP)
    {
	if (current_attribute == '+')
	{
	    match(ADDOP);
	    value += term();
	}
	else if (current_attribute == '-')
	{
	    match(ADDOP);
	    value -= term();
	}
    }
    return value;
}

int term()
{
    int value = factor();
    while (current_token == MULOP)
    {
	if (current_attribute == '*')
	{
	    match(MULOP);
	    value *= factor();
	}
	else if (current_attribute == '/')
	{
	    match(MULOP);
	    value /= factor();
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
    else if (current_token == ADDOP)
    {
	if (current_attribute == '-') {
	    match(ADDOP);
	    value = -factor();
	}
	else 
	{
	    error("Unsupported unary plus");
	}
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

/* helpers */
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

void error( char *message )
{
    fprintf( stderr, "Error: %s.\n\n", message );
    exit(1);
}

/* tokenizer */
int get_token()
{
    int c;
    int value;

    while (1) {	
	switch (c = getchar()) {
	case '+': case '-':
	    current_attribute = c;
	    fprintf(stderr, "[ADDOP:%c]", c);
	    return ADDOP; 
	case '*': case '/':
	    current_attribute = c;
	    fprintf(stderr, "[MULOP:%c]", c);
	    return MULOP;
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

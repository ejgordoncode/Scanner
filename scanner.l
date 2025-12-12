/* 
 * This file contains the LEXICAL ANALYSIS portion of the project.
 * Its job is to: recognize IDs, OPs, and punctuation
 */

/* Section One: C code declarations */
%{
    #include <string.h> /* needed for strdup() function */
    /* strdup takes a string, allocates mem. for copy, copies string into mem., returns pointer to new string created by copy */
    #include "parser.tab.h"
%}

/* Section Two: Flex definitions */

%option noyywrap 
/* dev note: yywrap() is called when flex reaches EOF. 
 * noyywrap tells flex to just stop at EOF instead of 
 * calling yywrap() (which returns 1 or 0)
 */

/* Section Three: Rules */
%%

[a-zA-Z][a-zA-Z0-9]*    {
                            yylval.str = strdup(yytext); /* store identified text in yylval */

                            /* dev note: the above line is necessary for including identifier
                             * name in parser error messages, otherwise it's not necessary
                             */
                            /* also note, yytext is the buffer flex reuses for each token, 
                             * so to avoid losing the data it's best to create a permanent copy
                             * (strdup(yytext)) and store a pointer (yylval.str) to the copy 
                             */

                             
                            return ID;
                        }
[+\-*/%]                {return OP;}
"="                     {return ASSIGN;}
";"                     {return SEMICOLON;}
"("                     {return LPAREN;}
")"                     {return RPAREN;}
[ \t]+                  {} /* skip over whitespace */
\n                      {return NEWLINE;}
.                       {return INVALID;}
%%
/* Section Four: Helper functions (none included at this time, left comment for 
 * future clarity in possible future updates) */
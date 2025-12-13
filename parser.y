/* File purpose: define token types */


/* Section One: C code declarations, includes */
%{
    #include <stdio.h>  /* for fprintf, printf, stderr */
    #include <stdlib.h> /* for malloc, free, exit */
    #include <string.h> /* for strdup, strlen, strcmp */
    
    extern int yylex(void); /* initialize scanner function from scanner */
    extern int yylineno; /* initialize current line num from scanner */
    void yyerror(const char *s); /* error handler function declaration */

    /* vars for output and errors */
    char *currLine = NULL; /* original line text */
    char *errorReason = NULL; /* error reason for why parse failed */
    int validParse = 0; /* 1 for successful line parse, 0 for otherwise */

    /* setters and getters for output and error vars */
    void setCurrLine(char *line);
    void setErrReason(const char *reason);
    void setErrReasonWithToken(const char *token);  /* helper function to build "INVALID TOKEN" msg */
    void clearErrState(void);
%}

/* Section Two: Bison declarations */

/* Union for token vals: */
%union {
    char *str;
}

/* Terminals */
%token <str> ID
%token <str> INVALID 
%token OP ASSIGN SEMICOLON LPAREN RPAREN NEWLINE

/* Non-Terminals */
%type <str> stmt expr term assignment

/* Operator precedence rules */
%left OP

/* Section Three: Grammar rules */
%%
program:
    program stmt NEWLINE
    | stmt NEWLINE
    | INVALID NEWLINE {
        /* $1 is the invalid token string */

        setErrReasonWithToken($1);
        
        validParse = 0;

        /* then free the token string */
        free($1);
    }
;

stmt: 
    assignment {
        validParse = 1;
        clearErrState();
    }
    | expr {
        validParse = 1;
        clearErrState();
    }
;

assignment: 
    ID ASSIGN expr SEMICOLON
;

expr: 
    term 
    | expr OP term
;

term: 
    ID 
    | LPAREN expr RPAREN
;

%%

/* Section Four: Additional C code, helper functions */

void yyerror(const char *s) {
    /* set err msg (if not already set) */
    if (!errorReason) {
        /* just says invalid expression when encounters syntax errors */
        setErrReason("invalid expression");
    }
    validParse = 0;
}

void setCurrLine(char *line){
    /* if old line exists, free it up */
    if (currLine) {
        free(currLine);
        currLine = NULL;
    }

    /* copy line if line not null */
    if (line != NULL){
        currLine = strdup(line);
    }
    /* ...otherwise, set current line to null */
    else {
        currLine = NULL;
    }
}

void setErrReason(const char *reason){
    /* if old error reason exists, free it */
    if (errorReason) {
        free(errorReason);
        errorReason = NULL;
    }

    /* if reason not null, set error reason to reason */
    if (reason != NULL){
        errorReason = strdup(reason);
    }
    /* ...otherwise, set errorReason to NULL */
    else {
        errorReason = NULL;
    }
}

void setErrReasonWithToken(const char *token) {
    /* create buffer to hold err msg */
    char message[200];
    
    if (token != NULL) {
        sprintf(message, "invalid token \"%s\"", token); /* 'invalid token "X"' */
    } else {
        /* if no token, just say invalid token */
        sprintf(message, "invalid token");
    }
    
    /* save error message */
    setErrReason(message);
}

void clearErrState(void) {
    /* clear err state after SUCCESSFUL parse */
    if (errorReason) {
        free(errorReason);
        errorReason = NULL;
    }
    validParse = 1;
}

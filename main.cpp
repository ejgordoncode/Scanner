#include <iostream>
#include <fstream>
#include <string>
#include <cstdio>
#include <cstring>
extern "C" {
    int yyparse(void);
    void setCurrLine(char *line);
    void setErrReason(const char *reason); 
    extern int validParse;
    extern char *errorReason;
    extern FILE *yyin;  /* for setting input file */
}
/* parse command-line args */

/**
 * Main parses command-line arguments for the program, and
 * handles input file specification and any other supported options.
 *
 * @param argc The NUMBER of command-line arguments.
 * @param argv The ARRAY of command-line argument strings.
 */
int main(int argc, char **argv){ /* **argv is a pointer to */
    /* dev note: char *argv[] is the exact same as char **argv...
     * In c/c++, the function signature X foo(Y a[]) turns into:
     *      X foo(Y *a) (source: https://stackoverflow.com/questions/5192068/c-char-argv-vs-char-argv)
     * User Fred Foo says "an array argument is demoted to a pointer, so...since argv is declared as an array (of pointers), it becomes a pointer
     *      to pointers"
     * Users Nick Matteo and Lightness Races in Orbit state that: "the name of an array can decay
     *      to a pointer to that array's first element...in certain contexts, such as function calls..."
     * TLDR; passing an array as a function argument means that it will be treated as a POINTER to its
     *      FIRST ELEMENT, thus char *argv[] and char **argv mean the same thing in this context
     */

    /* determine filename (either provided by user or defaults to scanme.txt) */
    std::string filename;
    if (argc > 1) {
        filename = argv[1];  /* case where user provides filename.txt */
    } else {
        filename = "scanme.txt";  /* case where no filename arg provided */
    }

    /* open file */
    FILE *inputFile = fopen(filename.c_str(), "r"); /* inputFile points to a FILE structure */
    /* dev notes for above line: "r" indicates "read mode" for fopen
     *                           filename needs to be converted to c-style string (fopen expects const char*, not std::string) */
    if (!inputFile) {
        std::cerr << "ERROR: Could not open '" << filename << "'" << std::endl;
        return 2; /* return error code */
    }

    /* read and parse each line */
    char lineBuffer[1000];  /* buffer space for each line */
    
    /* Main loop: 
     * 1. read line
     * 2. set current line in parser
     * 3. reset parse state
     * 4. parse the line (using temporary approach)
     * 5. check validParse
     * 6. Print result
     */
    
    /* 1. read line */
    while (fgets(lineBuffer, sizeof(lineBuffer), inputFile)) {
        std::string line = lineBuffer;
        
        /* remove newline */
        if (!line.empty() && line.back() == '\n') {
            line.pop_back();
        }
        if (!line.empty() && line.back() == '\r') {
            line.pop_back();
        }
        
        /* skip empty lines */
        if (line.empty()) {
            continue;
        }
        
        /* 2. set current line */
        setCurrLine(const_cast<char*>(line.c_str()));
        
        /* 3. reset parse state */
        validParse = 0;
        if (errorReason) {
            free(errorReason);
            errorReason = NULL;
        }
        
        /* 4. parse line */

        /* create a tempfile (why: yyparse() reads from yyin, which is a FILE type pointer;
         * fgets reads one line at a time; 
         * temp file isolates each line so parser sees only that line
         * TLDR; read line from inputFile, write to tempfile, parse in tempfile, then erase tempfile contents) */
        FILE *tempFile = tmpfile();
        if (tempFile) {
            /* write line to temp file */
            fprintf(tempFile, "%s\n", line.c_str());
            rewind(tempFile);  /* backtrack to start of file */
            
            /* set yyin to read from temp file */
            yyin = tempFile;
            
            /* parse line in tempfile you just wrote */
            yyparse();
            
            fclose(tempFile);
        } else {
            /* if tmpfile fails*/
            validParse = 0;
            if (!errorReason) {
                setErrReason("invalid expression");
            }
        }
        
        /* 5. check validParse and 6. print line and result */
        if (validParse == 1) {
            /* successful parse case*/
            printf("%s -- valid\n", line.c_str());
        } else {
            /* invalid parse case */
            if (errorReason) {
                printf("%s -- invalid: %s\n", line.c_str(), errorReason);
            } else {
                printf("%s -- invalid: invalid expression\n", line.c_str());
            }
        }
    }
    
    /* close input file */
    fclose(inputFile);

    /* exit successfully */
    return 0;





}








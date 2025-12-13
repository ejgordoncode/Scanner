# Scanner

## Project Description

This project implements a scanner which validates and parses lines from an input file. For 
each line, the 

## Build

How to Compile:

```bash
make
```

<details>What happens when you run "make":
1. Runs bison on `parser.y` to generate `parser.tab.c` and `parser.tab.h`
2. Runs flex on `scanner.l` to generate `lex.yy.c`
3. Compiles all source files to object files
4. Links everything into the executable `scanner`
</details>

How to clean generated files:
```bash
make clean
```

## Run

The program accepts an optional user-provided filename. If no filename is provided, 
a default filename is used ('scanme.txt').

```bash
./scanner [filename]
```

### Example:

```bash
./scanner scanme.txt
./scanner myfile.txt
./scanner          # No filename? No problem! It will use default filename 'scanme.txt'
```

## Output Format

For each line parsed from the input file, the scanner prints one of the following lines:
- `statement -- valid` if the statement is valid (according to the grammar)
- `statement -- invalid: reason` if the statement is invalid, with the reason

## Project Files

- `scanner.l` - Flex specification file (lexer)
- `parser.y` - Bison specification file (parser logic and rules)
- `main.cpp` - Main driver program (file I/O and output formatting)
- `Makefile` - Build configuration for compiling scanner
- `README.md` - The file you're reading now! :)
- `scanme.txt` - Default input file
- `out.txt` - Example expected output (just for reference)

## BNF Grammar Definition

```ebnf
id ::= letter { letter | digit }

statement ::= assignment | expression

expression ::= term { " " op " " term }

term ::= id | "(" expression ")"

assignment ::= id   " "   "="   " "   expression ";"

char ::= "A" | "B" | "C" | "D" | "E" | "F" | "G"
       | "H" | "I" | "J" | "K" | "L" | "M" | "N"
       | "O" | "P" | "Q" | "R" | "S" | "T" | "U"
       | "V" | "W" | "X" | "Y" | "Z" | "a" | "b"
       | "c" | "d" | "e" | "f" | "g" | "h" | "i"
       | "j" | "k" | "l" | "m" | "n" | "o" | "p"
       | "q" | "r" | "s" | "t" | "u" | "v" | "w"
       | "x" | "y" | "z" ;

digit ::= "0" | "1" | "2" | "3" | "4" | "5" | "6"
       | "7" | "8" | "9" 

op ::= '+' | '-' | '*' | '/' | '%'

```
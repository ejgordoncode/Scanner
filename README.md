# Scanner
Tool to scan and parse a text file according to a specific grammar definition.

### BNF Grammar Definition

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
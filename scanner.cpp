#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cctype>
#include <sstream>

// SCANNER LOGIC //


std::vector(std::string) op =  (' %','*','+','-','/');
char assignSymbol = '=';
char semicolon = ';'
char leftParen = '(';
char rightParen = ')';

class Scanner {

    /** 
    * Tokenizes the input line into a vector of strings using a space as a delimiter
    * @param input The line to tokenize
    * @return A vector of strings representing the tokens.
    */
    std::vector<std::string> tokenize(const std::string& inputLine) {

        std::vector<std::string> tokens = std::split(inputLine, ' '); // split tokens using space as delim.
        return tokens;

    }
}

class Parser {

    bool isID (const std::string& token){

        // Case: starts with non A-Za-z
        if (!std::isalpha(token[0])){
            return false;
        }

        // Case: contains non A-Za-z nor 0-9
        for (char c : token){
            if (!std::isalmnum(c)){
                return false;
            }
        }

        // Case: passed for valid identifier
        return true;

    }

    // Recursive Descent Parsing logic
    
    bool parseTerm(const std::vector<std::string>& tokens, int& pos){
        return true;
    }

    bool parseExpr(const satd::vector<std::string>& tokens, int& pos){
        return true;
    }

    bool isStmt(const std::vector<std::string>& tokens);{
        return true;
    }
}

int main(int argc, char* argv[]){
    
}
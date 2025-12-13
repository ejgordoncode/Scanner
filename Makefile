# Makefile for Scanner Project
# Compiles flex, bison, and C++ files into executable 'scanner'

# ============================================
# Variables (customize these as needed)
# ============================================

# C++ compiler
CXX = g++

# C compiler (for flex/bison generated C code)
CC = gcc

# Compiler flags
CXXFLAGS = -Wall -g -std=c++11
CFLAGS = -Wall -g

# Flex and Bison commands
FLEX = flex
BISON = bison

# Executable name (required by assignment)
TARGET = scanner

# Source files
LEX_FILE = scanner.l
YACC_FILE = parser.y
MAIN_FILE = main.cpp

# Generated files (from flex)
LEX_OUTPUT = lex.yy.c

# Generated files (from bison)
YACC_OUTPUT_C = parser.tab.c
YACC_OUTPUT_H = parser.tab.h

# Object files (compiled from source)
OBJS = main.o lex.yy.o parser.tab.o

# ============================================
# Default target (what runs when you type 'make')
# ============================================
all: $(TARGET)

# ============================================
# Build the executable
# ============================================
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)
	@echo "Build complete! Executable: $(TARGET)"

# ============================================
# Compile main.cpp to main.o
# ============================================
main.o: $(MAIN_FILE) $(YACC_OUTPUT_H)
	$(CXX) $(CXXFLAGS) -c $(MAIN_FILE) -o main.o

# ============================================
# Run flex on scanner.l to generate lex.yy.c
# ============================================
lex.yy.c: $(LEX_FILE) $(YACC_OUTPUT_H)
	$(FLEX) $(LEX_FILE)
	@echo "Flex: Generated lex.yy.c from $(LEX_FILE)"

# ============================================
# Compile lex.yy.c to lex.yy.o
# ============================================
lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c -o lex.yy.o

# ============================================
# Run bison on parser.y to generate parser.tab.c and parser.tab.h
# ============================================
$(YACC_OUTPUT_C) $(YACC_OUTPUT_H): $(YACC_FILE)
	$(BISON) -d $(YACC_FILE)
	@echo "Bison: Generated $(YACC_OUTPUT_C) and $(YACC_OUTPUT_H) from $(YACC_FILE)"

# ============================================
# Compile parser.tab.c to parser.tab.o
# ============================================
parser.tab.o: $(YACC_OUTPUT_C)
	$(CC) $(CFLAGS) -c $(YACC_OUTPUT_C) -o parser.tab.o

# ============================================
# Clean target (removes generated files)
# ============================================
clean:
	rm -f $(TARGET) $(OBJS) $(LEX_OUTPUT) $(YACC_OUTPUT_C) $(YACC_OUTPUT_H)
	@echo "Cleaned: Removed all generated files"

# ============================================
# Phony targets (not actual files)
# ============================================
.PHONY: all clean


#!/bin/bash
MAX_THREADS=2
OUT_DIR="../results"
RUNS=2

cd JSON
./collector.pl ./json_serial_lexer   $RUNS $MAX_THREADS $OUT_DIR
./collector.pl ./json_parallel_lexer $RUNS $MAX_THREADS $OUT_DIR
cd ..
cd Lua
./collector.pl ./lua_serial_lexer_brack   $RUNS $MAX_THREADS $OUT_DIR
./collector.pl ./lua_serial_lexer_non_brack   $RUNS $MAX_THREADS $OUT_DIR
./collector.pl ./lua_parallel_lexer_brack $RUNS $MAX_THREADS $OUT_DIR
./collector.pl ./lua_parallel_lexer_non_brack $RUNS $MAX_THREADS $OUT_DIR
cd ..

#!/bin/bash
# This script builds all the binaries and moves them to the benchmarking directories

cd ../JSON/
../../papageno.py -i parser/json_right_recursive.g
make
cp bin/json_parser ../benchmarks/JSON/json_serial_lexer
make clean
make clean-gen

cd ../JSON_parallel_lexer/
../../papageno.py -i parser/json_right_recursive.g
make
cp bin/json_parser ../benchmarks/JSON/json_parallel_lexer
make clean
make clean-gen

cd ../Lua/Lua_bracketed/
../../../papageno.py -i parser/Lua_OPG.g
make
cp bin/lua_parser ../../benchmarks/Lua/lua_serial_lexer_brack
make clean
make clean-gen
cd ..

cd ../Lua/Lua_non_bracketed/
../../../papageno.py -i parser/Lua_OPG.g
make
cp bin/lua_parser ../../benchmarks/Lua/lua_serial_lexer_non_brack
make clean
make clean-gen
cd ..

cd ../Lua_parallel_lexer/Lua_bracketed/
../../../papageno.py -i parser/Lua_OPG.g
make
cp bin/lua_parser ../../benchmarks/Lua/lua_parallel_lexer_brack
make clean
make clean-gen
cd ..

cd ../Lua_parallel_lexer/Lua_non_bracketed/
../../../papageno.py -i parser/Lua_OPG.g
make
cp bin/lua_parser ../../benchmarks/Lua/lua_parallel_lexer_non_brack
make clean
make clean-gen
cd ../../benchmarks

cd bison_baselines/json
make
cp json_bison ../../JSON/
make clean
cd ../../

cd bison_baselines/lua
make
cp lua_lr ../../Lua/lua_bison
make clean
cd ../../

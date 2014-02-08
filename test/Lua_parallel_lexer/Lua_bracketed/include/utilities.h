#ifndef __UT_H_
#define __UT_H_

#include "stdio.h"
#include "stdint.h"
#include "stdlib.h"

#include "debug_functions.h"

int32_t lookup (int32_t symb, int32_t* table, int32_t table_size);
inline void add_symb (int32_t symb, int32_t* table, int32_t table_size);
void init_table(int32_t * table, int32_t table_size, int32_t * array, int32_t array_length);

#endif


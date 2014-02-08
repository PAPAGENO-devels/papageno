#ifndef __PAR_LEX_H_
#define __PAR_LEX_H_

#include "par_lex_lua_bracketed_strings.h"

void perform_lexing(int32_t lex_thread_max_num, char *file_name, parsing_ctx *ctx);

#endif

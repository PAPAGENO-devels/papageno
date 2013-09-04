
#ifndef MATRIX_H_
#define MATRIX_H_
		 
#include "parsing_context.h"

#define ROW_LEN  3/**< Length of a row of the precedence matrix measured in bytes. */
#define PRECEDENCE(matrix, i, j) ((uint32_t)((((matrix)[gr_term_key(i)*ROW_LEN + (gr_term_key(j) >> 2)]) >> (6 - 2*(gr_term_key(j) & 0x03))) & 0x03))

static const uint8_t precedence_matrix[ROW_LEN*TERM_LEN] = {202, 251, 244, 215, 255, 212, 154, 171, 148, 151, 171, 180, 215, 255, 212, 215, 255, 212, 213, 242, 212, 255, 246, 244, 187, 171, 132, 215, 255, 212, 170, 170, 160};
#endif

#ifndef __CONFIG_H_
#define __CONFIG_H_
/* chunk recombination strategy */
#define __SINGLE_RECOMBINATION
/* Number of preallocated parsing stack symbols */
#define __LIST_ALLOC_SIZE 1024
/* Average rhs length. */
#define __RHS_LENGTH 1.9f
/* Average token size. */
#define __TOKEN_SIZE 5.0f
/* Length of a line of cache. */
#define __CACHE_LINE_SIZE 64
#endif

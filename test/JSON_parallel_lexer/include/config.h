#ifndef CONFIG_H_
#define CONFIG_H_
/* chunk recombination strategy */
#define SINGLE_RECOMBINATION
/* Number of preallocated parsing stack symbols */
#define LIST_ALLOC_SIZE 1024
/* Average rhs length. */
#define RHS_LENGTH 1.9f
/* Average token size. */
#define TOKEN_SIZE 5.0f
/* Length of a line of cache. */
#define CACHE_LINE_SIZE 64
#endif

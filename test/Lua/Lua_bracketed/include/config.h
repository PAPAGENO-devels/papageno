#ifndef CONFIG_H_
#define CONFIG_H_

/* define how the remaining reduction after the
 first parallel pass are to be recombined:
 by a single thread -> SINGLE_RECOMBINATION
 by half of the current working threads -> LOG_RECOMBINATION*/
#define SINGLE_RECOMBINATION


/* Handle identification stack parameters. */
#define LIST_ALLOC_SIZE			1024

/* Average rhs length. */
#define RHS_LENGTH				2.6f

/* Average token size. */
#define TOKEN_SIZE				1.1f

/* Length of a line of cache. */
#define CACHE_LINE				64

#endif

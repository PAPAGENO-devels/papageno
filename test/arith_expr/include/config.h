#ifndef __CONFIG_H_
#define __CONFIG_H_

/* define how the remaining reduction after the
 first parallel pass are to be recombined:
 by a single thread -> __SINGLE_RECOMBINATION
 by half of the current working threads -> __LOG_RECOMBINATION*/
#define __SINGLE_RECOMBINATION


/* Handle identification stack parameters. */
#define __LIST_ALLOC_SIZE			1024

/* Average rhs length. */
#define __RHS_LENGTH				2.6f

/* Average token size. */
#define __TOKEN_SIZE				1.1f

/* Length of a line of cache. */
#define __CACHE_LINE				64

#endif

#ifndef __FLEX_RETURN_CODES_H_
#define __FLEX_RETURN_CODES_H_

#define __ERROR_BOTH 		 -3 /* error in both lists */
#define __SECOND_LIST_LEXING_ERROR -2 /* lexing error in list 1 */
#define __FIRST_LIST_LEXING_ERROR  -1 /* lexing error in list 0 */
#define __END_OF_FILE               0 /* reached end of file    */
#define __LEX_CORRECT_BOTH          1 /* correct lexing in both lists */
#define __LEX_FIRST_PAUSE_SEC	  2 /* lexing in list 0, pause in list 1 */
#define __PAUSE_FIRST_LEX_SEC	  3 /* pause in list 0, lexing in list 1 */
#define __CHAR_FIRST_LEX_SEC        4 /* list of CHAR in list 0, lexing in list 1 */
#define __LEX_FIRST_CHAR_SEC	  5 /* lexing in list 0, list of CHAR in list 1 */
#define __PAUSE_BOTH		  6 /* pause in both lists */

#endif
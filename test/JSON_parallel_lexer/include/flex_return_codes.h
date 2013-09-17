#ifndef FLEX_RETURN_CODES_H_
#define FLEX_RETURN_CODES_H_

#define ERROR_BOTH 		 -3 /* error in both lists */
#define SECOND_LIST_LEXING_ERROR -2 /* lexing error in list 1 */
#define FIRST_LIST_LEXING_ERROR  -1 /* lexing error in list 0 */
#define END_OF_FILE               0 /* reached end of file    */
#define LEX_CORRECT_BOTH          1 /* correct lexing in both lists */
#define LEX_FIRST_PAUSE_SEC	  2 /* lexing in list 0, pause in list 1 */
#define PAUSE_FIRST_LEX_SEC	  3 /* pause in list 0, lexing in list 1 */
#define CHAR_FIRST_LEX_SEC        4 /* list of CHAR in list 0, lexing in list 1 */
#define LEX_FIRST_CHAR_SEC	  5 /* lexing in list 0, list of CHAR in list 1 */
#define PAUSE_BOTH		  6 /* pause in both lists */

#endif
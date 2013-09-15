#include "delimiter_bracketed_strings.h"

delimiter *new_delimiter(delimiter_type type, int8_t type_class)
{
    delimiter *temp = (delimiter*) malloc(sizeof(delimiter));

    if(type_class == 0)
    	(temp->type).token = type.token;
    else if (type_class == 1)
    	(temp->type).comment = type.comment;
    else
        (temp->type).bracket_delimiter = type.bracket_delimiter;
    temp->type_class = type_class;
    temp->number_tokens_from_last_comment_string[0] = 0;
    temp->number_tokens_from_last_comment_string[1] = 0;
    temp->last_token[0] = NULL;
    temp->last_token[1] = NULL;
    temp->error[0] = 0;
    temp->error[1] = 0;
    temp->next[0] = NULL;
    temp->next[1] = NULL;
    return temp;
}

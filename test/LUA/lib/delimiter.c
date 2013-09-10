#include "delimiter.h"

delimiter *new_delimiter(delimiter_type type, int8_t type_class)
{
    delimiter *temp = (delimiter*) malloc(sizeof(delimiter));

    if(type_class == 0)
    	(temp->type).token = type.token;
    else
    	(temp->type).comment = type.comment;
    // temp->equal_number = -1;
    temp->number_tokens_from_last_comment = 0;
    temp->last_token = NULL;
    temp->next = NULL;
 
    return temp;
}

void free_delimiter(delimiter *d)
{
	free(d);
}

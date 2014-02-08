#include "flex_token_formatting_bracketed_strings.h"

/*Input c MUST be a character in [0-9a-fA-F]. Returns its decimal value.*/
int8_t hex2dec(char c)
{
	if (isdigit(c))
		return c - '0';
	else if ('a'<= c && c <= 'f')
		return c - 'a' + 10;
	else
		return c - 'A' + 10;		
}

char * append_to_buffer(char* buffer, char c, int32_t* current_buffer_length, int32_t* allocated_buffer_size)
{
	if (*current_buffer_length >= (*allocated_buffer_size)-1) 
	{	//*allocated_buffer_size-1 to leave space for ending \0.
		//Realloc buffer: common string length usually should not cause more than one reallocation.
		*allocated_buffer_size = *allocated_buffer_size + __MAX_BUFFER_SIZE;
		buffer = realloc(buffer, *allocated_buffer_size);
    	if (buffer == NULL)
    	{
        	DEBUG_STDOUT_PRINT("ERROR> could not realloc cut_points. Aborting.\n")
        	exit(1);
        }       
	}    
	buffer[*current_buffer_length] = c;
	*current_buffer_length = *current_buffer_length + 1; 
	//pointer buffer can change after realloc
	return buffer;     
}

char * concat_to_buffer(char* buffer, char* string_to_concat, int32_t string_to_concat_length, int32_t* current_buffer_length, int32_t* allocated_buffer_size)
{
	int32_t maximum_length;
	if (*current_buffer_length + string_to_concat_length >= (*allocated_buffer_size) - 1) 
	{	//*allocated_buffer_size-1 to leave space for ending \0.
		//Realloc buffer: common string length usually should not cause more than one reallocation.
		if (string_to_concat_length >= __MAX_BUFFER_SIZE)
			maximum_length = string_to_concat_length;
		else
			maximum_length = __MAX_BUFFER_SIZE;
		*allocated_buffer_size = *allocated_buffer_size + maximum_length;
		buffer = realloc(buffer, *allocated_buffer_size);
    	if (buffer == NULL)
    	{
        	DEBUG_STDOUT_PRINT("ERROR> could not realloc cut_points. Aborting.\n");
        	exit(1);
        }       
	}
	if (*current_buffer_length == 0) {
		strcpy(buffer, string_to_concat);
	}
	else {
		buffer[*current_buffer_length] = '\0';
		strcat(buffer,string_to_concat);    
	}
	*current_buffer_length = *current_buffer_length + string_to_concat_length;
	//pointer buffer can change after realloc
	return buffer; 
}

void append_pending_bracketed_string(bracketed_string_node **head_list, bracketed_string_node ** top, char** string_ptr, int32_t string_length)
{
	bracketed_string_node * new_node = (bracketed_string_node *)malloc(sizeof(bracketed_string_node));
	if (new_node == NULL) {
   	 	DEBUG_STDOUT_PRINT("ERROR> could not complete malloc pending bracketed string. Aborting.\n");
    	exit(1);
  	}
  	new_node->pending_bracketed_string_ptr = string_ptr;
  	new_node->length = string_length;
  	new_node->allocated_size = string_length + 1;
	new_node->next = NULL;

	if (*head_list == NULL) {
    	*head_list = new_node;
   		*top = new_node;
 	 } else {
    	(*top)->next = new_node;
    	*top = new_node;
  	}	
}

void append_to_all_pending_bracketed_string(bracketed_string_node * head_list, char c)
{
	while (head_list != NULL) {
		*head_list->pending_bracketed_string_ptr = append_to_buffer(*head_list->pending_bracketed_string_ptr, c, &(head_list->length), &(head_list->allocated_size));
		head_list = head_list->next;
	}
}

void concat_to_all_pending_bracketed_string(bracketed_string_node * head_list, char* string_to_concat, int32_t string_to_concat_length)
{
	while (head_list != NULL) {
		*head_list->pending_bracketed_string_ptr = concat_to_buffer(*head_list->pending_bracketed_string_ptr, string_to_concat, string_to_concat_length, &(head_list->length), &(head_list->allocated_size));
		head_list = head_list->next;
	}
}

void terminate_all_pending_string(bracketed_string_node * head_list)
{
	char * string;
	while (head_list != NULL) {
		string = *head_list->pending_bracketed_string_ptr;
		string[head_list->length] = '\0';
		head_list = head_list->next;
	}
}



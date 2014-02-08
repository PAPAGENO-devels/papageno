#include "flex_token_formatting.h"

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

char * append_to_buffer(char* buffer, char c, int32_t current_buffer_length, int32_t* allocated_buffer_size)
{
	if (current_buffer_length >= (*allocated_buffer_size)-1) 
	{	//*allocated_buffer_size-1 to leave space for ending \0.
		//Realloc buffer: common string length usually should not cause more than one reallocation.
		*allocated_buffer_size = *allocated_buffer_size + __MAX_BUFFER_SIZE;
		buffer = realloc(buffer, *allocated_buffer_size);
    	if (buffer == NULL)
    	{
        	DEBUG_STDOUT_PRINT("ERROR> could not realloc cut_points. Aborting.\n");
        	exit(1);
        }       
	}    
	buffer[current_buffer_length] = c; 
	//pointer buffer can change after realloc
	return buffer;   
}
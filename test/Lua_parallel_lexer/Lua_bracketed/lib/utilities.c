#include "utilities.h"

#define __UNDEF_SEP -1


/*Returns 1 if symb is in table, 0 otherwise*/
int32_t lookup (int32_t symb, int32_t* table, int32_t table_size)
{
  int32_t hash = symb%table_size;
  int32_t i;

  for(i = hash; i<table_size; i++)
  {
    if(symb == table[i])
      return 1;
  }
  //i == table_size
  for(i = 0; i<hash; i++)
  {
    if(symb == table[i])
      return 1;
  }
  return 0;
}

void add_symb (int32_t symb, int32_t* table, int32_t table_size)
{
  int32_t hash = symb%table_size;
  int32_t i = hash;
  
  while(i<table_size && table[i]!=__UNDEF_SEP)
    i++;
  if(table[i] == __UNDEF_SEP){
    table[i] = symb;
  }
  else{
    i = 0;
    while(i<hash && table[i]!=__UNDEF_SEP)
     i++;
    if(table[i] == __UNDEF_SEP){
      table[i] = symb;
    }
    else{
      //Tried them all, table is full: this cannot happen if the size of the hash table is larger than the size of the set of separators.
      DEBUG_STDOUT_PRINT("ERROR> Hash table for separators is full. Aborting.\n");
      exit(1);
    }
  } 
}

/*Init table with undefined int32_t __UNDEF_SEP: no separator can have this value. Fill the table with the constant set of separators*/
void init_table(int32_t * table, int32_t table_size, int32_t * array, int32_t array_length)
{
  int32_t i; 
  for(i = 0; i < table_size; i++)
    table[i] = __UNDEF_SEP;
  for(i = 0; i < array_length; i++)
  {
    add_symb(array[i], table, table_size);
  }
}



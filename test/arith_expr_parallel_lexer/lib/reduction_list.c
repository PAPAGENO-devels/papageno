#include <stdlib.h>
#include <stdint.h>
#include "config.h"

#include "reduction_list.h"

void init_reduction_list(reduction_list *list)
{
    list->list = (uint32_t*) malloc(sizeof(uint32_t)*__LIST_ALLOC_SIZE);
    list->ceil = __LIST_ALLOC_SIZE;
    list->idx_last = 0;
}

void append_position_on_reduction_list(reduction_list *list, uint32_t node)
{
    if (list->idx_last >= list->ceil) {
        list->list = (uint32_t*) realloc(list->list, sizeof(uint32_t)*(list->ceil + __LIST_ALLOC_SIZE));
        list->ceil += __LIST_ALLOC_SIZE;
    }
    list->list[list->idx_last] = node;
    ++list->idx_last;
}

uint32_t get_reduction_position_at_index(reduction_list *list, uint32_t index)
{
    if (index >= list->idx_last) {
        return 0;
    }
    return list->list[index];
}

void swap_reduction_lists(reduction_list **src, reduction_list **dst)
{
    reduction_list *tmp = *src;
    *src = *dst;
    *dst = tmp;
}

void free_reduction_list(reduction_list *list)
{
    free(list->list);
    free(list);
}


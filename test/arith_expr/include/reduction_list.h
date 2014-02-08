#ifndef __REDUCTION_LIST_H_
#define __REDUCTION_LIST_H_
typedef struct reduction_list {
	uint32_t *list;
	uint32_t idx_last;
	uint32_t ceil;
} reduction_list;

void init_reduction_list(reduction_list *list);
void append_position_on_reduction_list(reduction_list *list, uint32_t node);
uint32_t get_reduction_position_at_index(reduction_list *list, uint32_t index);
void swap_reduction_lists(reduction_list **src, reduction_list **dst);
void free_reduction_list(reduction_list *list);
#endif

CheckFirstTime("olivia_scripts.lua")
olivia.poetry_idle_table = Idle:create("olivia_idles")
idt = olivia.poetry_idle_table
idt:add_state("rest", { rest_to_book = 0.8, rest = 0.2 })
idt:add_state("rest_to_book", { book = 1 })
idt:add_state("book", { book_to_book_dn = 0.2, book = 0.8 })
idt:add_state("book_to_book_dn", { book_dn = 1 })
idt:add_state("book_dn", { book_dn_up = 0.1, book_dn = 0.9 })
idt:add_state("book_dn_up", { look_book = 1 })
idt:add_state("look_book", { look_book = 0.8, smoke_to_book = 0.2 })
idt:add_state("smoke_to_book", { book_pos = 1 })
idt:add_state("book_pos", { book_to_rest = 0.1, book_pos = 0.9 })
idt:add_state("book_to_rest", { rest_pos = 1 })
idt:add_state("rest_pos", { rest_gest = 0.3, rest_pos = 0.7 })
idt:add_state("rest_gest", { gest = 1 })
idt:add_state("gest", { gest_to_smoke = 0.3, gest = 0.7 })
idt:add_state("gest_to_smoke", { smoke = 1 })
idt:add_state("smoke", { smoke_to_rest = 1 })
idt:add_state("smoke_to_rest", { rest_hold = 1 })
idt:add_state("rest_hold", { rest = 0.33, rest_hold = 0.34, rest_pos = 0.33 })
olivia.standing_idle_table = Idle:create("olivia_idles")
idt = olivia.standing_idle_table
idt:add_state("rest_pos", { rest_gest = 0.01, rest_pos = 0.09 })
idt:add_state("rest_gest", { gest = 1 })
idt:add_state("gest", { gest_to_smoke = 0.5, gest = 0.5 })
idt:add_state("gest_to_smoke", { smoke = 1 })
idt:add_state("smoke", { smoke_to_rest = 1 })
idt:add_state("smoke_to_rest", { rest_pos = 1 })
olivia.dialog_idle_table = Idle:create("olivia_idles")
idt = olivia.dialog_idle_table
idt:add_state("rest", { rest_to_book = 0.1, rest = 0.9 })
idt:add_state("rest_to_book", { book = 1 })
idt:add_state("book", { book_to_book_dn = 0.2, book = 0.8 })
idt:add_state("book_to_book_dn", { book_dn = 1 })
idt:add_state("book_dn", { book_dn_up = 0.8, book_dn = 0.2 })
idt:add_state("book_dn_up", { look_book = 1 })
idt:add_state("look_book", { look_book = 0.2, smoke_to_book = 0.8 })
idt:add_state("smoke_to_book", { book_pos = 1 })
idt:add_state("book_pos", { book_to_rest = 0.8, book_pos = 0.2 })
idt:add_state("book_to_rest", { rest_pos = 1 })
idt:add_state("rest_pos", { rest_gest = 0.6, rest_pos = 0.4 })
idt:add_state("rest_gest", { gest = 1 })
idt:add_state("gest", { gest_to_smoke = 1, gest = 0 })
idt:add_state("gest_to_smoke", { smoke = 1 })
idt:add_state("smoke", { smoke_to_rest = 1 })
idt:add_state("smoke_to_rest", { rest_hold = 1 })
idt:add_state("rest_hold", { rest = 0.6, rest_hold = 0.2, rest_pos = 0.2 })

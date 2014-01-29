CheckFirstTime("dlg_brennis2.lua")
br2 = { }
br2.active = FALSE
br2.text_objs = nil
br2.choices = { }
br2.brennis_questions = { }
br2.brennis_questions[1] = "/lybs133/"
br2.brennis_questions[2] = "/lybs134/"
br2.brennis_questions[3] = "/lybs135/"
br2.brennis_questions[4] = "/lybs136/"
br2.brennis_questions[5] = "/lybs137/"
br2.brennis_questions[6] = "/lybs138/"
br2.brennis_questions[7] = "/lybs139/"
br2.brennis_questions[8] = "/lybs140/"
br2.brennis_questions[9] = "/lybs141/"
br2.brennis_questions[10] = "/lybs142/"
br2.brennis_questions[11] = "/lybs143/"
br2.brennis_questions[12] = "/lybs144/"
br2.brennis_questions[13] = "/lybs145/"
br2.brennis_questions[14] = "/lybs146/"
br2.brennis_questions[15] = "/lybs147/"
br2.intro = function(arg1) -- line 31
    start_script(ly.brennis_stop_idle)
    ly.keno_actor.game_paused = TRUE
    if ly.keno_actor.game_index == 0 then
        ly.keno_actor:choose_number()
    end
    manny:walkto_object(ly.brennis_obj)
    cameraman_disabled = TRUE
    if not ly.tried_keno then
        ly.tried_keno = TRUE
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma127/")
        manny:wait_for_message()
        manny:say_line("/lyma128/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs129/")
        brennis:wait_for_message()
        wait_for_script(ly.brennis_stop_idle)
        brennis:play_chore(br_idles_moves_head, "br_idles.cos")
        brennis:say_line("/lybs130/")
        brennis:wait_for_message()
        sleep_for(1000)
    else
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma131/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        wait_for_script(ly.brennis_stop_idle)
    end
    ly.keno_actor:choose_number()
    brennis:say_line("/lybs132/")
    brennis:wait_for_message()
    brennis:say_line(pick_one_of(br2.brennis_questions, TRUE))
end
br2.init = function(arg1, arg2) -- line 73
    system.buttonHandler = noButtonHandler
    manny:head_look_at(ly.brennis_obj)
    if arg1.intro then
        arg1:intro(arg2)
        wait_for_message()
    end
    system.buttonHandler = arg1
    arg1.top_line = 1
    arg1.current_line = 1
    ly:current_setup(ly_kenla)
    arg1:create_text_objs()
    arg1:calc_num_choices()
    arg1:display_lines()
end
br2.create_text_objs = function(arg1) -- line 94
    local local1, local2
    if arg1.text_objs == nil then
        arg1.text_objs = { }
        local1 = { x = 10, y = Dialog.start_y, fgcolor = Dialog.lo_color, font = verb_font, ljustify = TRUE }
        local2 = 1
        while local2 <= Dialog.max_line do
            arg1.text_objs[local2] = MakeTextObject(" ", local1)
            local1.y = local1.y + Dialog.height
            local2 = local2 + 1
        end
    end
end
br2.calc_num_choices = function(arg1) -- line 110
    local local1
    arg1.num_choices = 0
    local1 = 1
    while arg1.choices[local1] do
        if not arg1.choices[local1].disabled then
            arg1.num_choices = arg1.num_choices + 1
        end
        local1 = local1 + 1
    end
end
br2.display_lines = function(arg1) -- line 124
    local local1, local2, local3
    local1 = 1
    local2 = arg1.top_line
    while local1 <= Dialog.max_line and arg1.choices[local2] ~= nil do
        if not arg1.choices[local2].disabled then
            if local1 == Dialog.max_line and arg1.top_line + local1 - 1 ~= arg1.num_choices then
                local3 = arg1.choices[arg1.top_line + local1 - 1].text
                local3 = local3 .. " ..."
                ChangeTextObject(arg1.text_objs[local1], local3)
            else
                ChangeTextObject(arg1.text_objs[local1], arg1.choices[arg1.top_line + local1 - 1].text)
            end
            if arg1.current_line == arg1.top_line + local1 - 1 then
                ChangeTextObject(arg1.text_objs[local1], { fgcolor = Dialog.hi_color })
            else
                ChangeTextObject(arg1.text_objs[local1], { fgcolor = Dialog.lo_color })
            end
            local1 = local1 + 1
        end
        local2 = local2 + 1
    end
end
br2.buttonHandler = function(arg1, arg2, arg3, arg4) -- line 150
    if arg2 == AKEY and developerMode then
        start_script(arg1.finish, arg1)
    elseif not CommonButtonHandler(arg2, arg3, arg4) then
        if arg3 and not br2.active then
            if control_map.DIALOG_DOWN[arg2] then
                single_start_script(arg1.line_down, arg1)
            elseif control_map.DIALOG_UP[arg2] then
                single_start_script(arg1.line_up, arg1)
            elseif control_map.DIALOG_CHOOSE[arg2] then
                single_start_script(arg1.choose_line, arg1)
            elseif control_map.PAGE_UP[arg2] then
                single_start_script(arg1.line_up, arg1, 4)
            elseif control_map.PAGE_DOWN[arg2] then
                single_start_script(arg1.line_down, arg1, 4)
            end
        end
    end
end
br2.line_down = function(arg1, arg2) -- line 175
    local local1
    if not arg2 then
        arg2 = 1
    end
    while get_generic_control_state("DIALOG_DOWN") do
        arg1.current_line = arg1.current_line + arg2
        if arg1.current_line > arg1.num_choices then
            arg1.current_line = arg1.num_choices
        end
        arg1.top_line = arg1.current_line
        if arg1.top_line > arg1.num_choices - 3 then
            arg1.top_line = arg1.num_choices - 3
        end
        arg1:display_lines()
        local1 = 0
        while local1 < 500 and get_generic_control_state("DIALOG_DOWN") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
br2.line_up = function(arg1, arg2) -- line 203
    local local1
    if not arg2 then
        arg2 = 1
    end
    while get_generic_control_state("DIALOG_UP") do
        arg1.current_line = arg1.current_line - arg2
        if arg1.current_line < 1 then
            arg1.current_line = 1
        end
        if arg1.current_line <= arg1.num_choices - 3 then
            arg1.top_line = arg1.current_line
        end
        arg1:display_lines()
        local1 = 0
        while local1 < 500 and get_generic_control_state("DIALOG_UP") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
br2.choose_line = function(arg1) -- line 228
    local local1
    system.buttonHandler = noButtonHandler
    stop_script(arg1.line_up)
    stop_script(arg1.line_down)
    local1 = arg1.choices[arg1.current_line]
    arg1:clear()
    system.currentActor:say_line(local1.text)
    system.currentActor:wait_for_message()
    if local1.func then
        local1.func(arg1)
    else
        arg1:check_response(arg1.current_line)
    end
end
br2.check_response = function(arg1, arg2) -- line 250
    if arg2 == ly.keno_actor.current_number then
        arg1:positive()
    else
        arg1:negative()
    end
end
br2.positive = function(arg1) -- line 258
    br2.solved = TRUE
    cur_puzzle_state[57] = TRUE
    ly:current_setup(ly_elems)
    brennis:say_line("/lybs149/")
    brennis:wait_for_message()
    brennis:say_line("/lybs150/")
    brennis:wait_for_message()
    manny:say_line("/lyma151/")
    manny:wait_for_message()
    brennis:say_line("/lybs152/")
    brennis:wait_for_message()
    manny:say_line("/lyma153/")
    manny:wait_for_message()
    br2:finish()
end
br2.negative = function(arg1) -- line 277
    if not arg1.choices[38].used then
        arg1.choices[38].disabled = FALSE
    end
    ly:current_setup(ly_elems)
    brennis:say_line("/lybs155/")
    brennis:wait_for_message()
    brennis:say_line("/lybs156/")
    br2:finish()
end
br2.complain = function(arg1) -- line 291
    arg1.choices[38].disabled = TRUE
    arg1.choices[38].used = TRUE
    ly:current_setup(ly_elems)
    brennis:say_line("/lybs158/")
    brennis:wait_for_message()
    brennis:say_line("/lybs159/")
    br2:finish()
end
br2.clear = function(arg1) -- line 304
    local local1
    if arg1.text_objs then
        local1 = 1
        while local1 <= Dialog.max_line do
            if arg1.text_objs[local1] then
                KillTextObject(arg1.text_objs[local1])
                arg1.text_objs[local1] = nil
            end
            local1 = local1 + 1
        end
        arg1.text_objs = nil
    end
end
br2.finish = function(arg1) -- line 321
    ly:current_setup(ly_elems)
    arg1:clear()
    arg1:outro()
    system.buttonHandler = SampleButtonHandler
    system.axisHandler = SampleAxisHandler
    enable_head_control(TRUE)
end
br2.outro = function(arg1) -- line 332
    cameraman_disabled = FALSE
    ly.keno_actor.game_paused = FALSE
    if not br2.solved then
        ly:brennis_start_idle()
    else
        ly:add_object_state(ly_elems, "ly_elevator.bm", "ly_elevator.zbm", OBJSTATE_STATE)
        ly.brennis_obj:set_object_state("ly_elevator.cos")
        ly.brennis_obj:play_chore(0)
        ly.brennis_obj:wait_for_chore()
        hf:first_time_in()
    end
end
br2.choices[1] = { text = "/cnma001/" }
br2.choices[2] = { text = "/cnma002/" }
br2.choices[3] = { text = "/cnma003/" }
br2.choices[4] = { text = "/cnma004/" }
br2.choices[5] = { text = "/cnma005/" }
br2.choices[6] = { text = "/cnma006/" }
br2.choices[7] = { text = "/cnma007/" }
br2.choices[8] = { text = "/cnma008/" }
br2.choices[9] = { text = "/cnma009/" }
br2.choices[10] = { text = "/cnma010/" }
br2.choices[11] = { text = "/cnma011/" }
br2.choices[12] = { text = "/cnma012/" }
br2.choices[13] = { text = "/cnma013/" }
br2.choices[14] = { text = "/cnma014/" }
br2.choices[15] = { text = "/cnma015/" }
br2.choices[16] = { text = "/cnma016/" }
br2.choices[17] = { text = "/cnma017/" }
br2.choices[18] = { text = "/cnma018/" }
br2.choices[19] = { text = "/cnma019/" }
br2.choices[20] = { text = "/cnma020/" }
br2.choices[21] = { text = "/cnma021/" }
br2.choices[22] = { text = "/cnma022/" }
br2.choices[23] = { text = "/cnma023/" }
br2.choices[24] = { text = "/cnma024/" }
br2.choices[25] = { text = "/cnma025/" }
br2.choices[26] = { text = "/cnma026/" }
br2.choices[27] = { text = "/cnma027/" }
br2.choices[28] = { text = "/cnma028/" }
br2.choices[29] = { text = "/cnma029/" }
br2.choices[30] = { text = "/cnma030/" }
br2.choices[31] = { text = "/cnma031/" }
br2.choices[32] = { text = "/cnma032/" }
br2.choices[33] = { text = "/cnma033/" }
br2.choices[34] = { text = "/cnma034/" }
br2.choices[35] = { text = "/cnma035/" }
br2.choices[36] = { text = "/cnma036/" }
br2.choices[37] = { text = "/lyma154/", ["func"] = br2.negative }
br2.choices[38] = { text = "/lyma157/", disabled = TRUE, ["func"] = br2.complain }

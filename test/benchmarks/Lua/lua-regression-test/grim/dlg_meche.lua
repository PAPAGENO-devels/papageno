CheckFirstTime("dlg_meche.lua")
me1 = Dialog:create()
me1.focus = meche
me1.start_using_computer = function(arg1) -- line 19
    manny:walkto(mo.computer)
    manny:wait_for_actor()
    mo:current_setup(mo_comin)
    manny:ignore_boxes()
    manny:setpos(0.45, 1.875, 0)
    manny:setrot(0, 87.7538, 0)
    mo.computer:play_chore(mo_computer_static)
    manny:push_costume("ma_note_type.cos")
    manny:play_chore(ma_note_type_to_type, "ma_note_type.cos")
    manny:wait_for_chore()
    manny:play_chore(ma_note_type_type_loop, "ma_note_type.cos")
    start_sfx("keyboard.imu")
    sleep_for(100)
    mo.computer:play_chore(mo_computer_scroll)
    manny:wait_for_chore()
    stop_sound("keyboard.imu")
    start_sfx("compbeep.wav")
    manny:head_look_at_point(0.2, 1.875, 0.47, 100)
    wait_for_sound("compbeep.wav")
end
me1.stop_using_computer = function(arg1) -- line 48
    manny:play_chore(ma_note_type_type_to_home, "ma_note_type.cos")
    manny:wait_for_chore()
    manny:head_look_at(nil)
    manny:pop_costume()
    manny:follow_boxes()
    manny:setpos(0.5, 1.975, 0)
end
me1.manny_cu_mark = function(arg1) -- line 58
    manny:stop_chore()
    manny:setpos(1.05347, 1.8705, 0)
    manny:setrot(0, 211.716, 0)
    manny:head_look_at_point(1.09287, 1.6884, 0.4074, 360)
end
me1.walk_manny_to_mark = function(arg1) -- line 65
    manny:walkto(1.05347, 1.8705, 0)
    manny:wait_for_actor()
    manny:setrot(0, 211.716, 0)
    manny:head_look_at_point(1.09287, 1.6884, 0.4074)
end
me1.meche_cu_mark = function(arg1) -- line 72
    meche:setpos(1.09687, 1.52627, 0.0201)
    meche:setrot(0, 38.1745, 0)
end
me1.display_lines = function(arg1) -- line 80
    mo:current_setup(mo_mcecu)
    meche:stop_chore()
    meche:play_chore(meche_sit_base)
    single_start_script(meche.new_run_idle, meche, "base")
    arg1.parent.display_lines(me1)
end
me1.wait_and_cut_to_meche = function() -- line 88
    break_here()
    manny:wait_for_message()
    mo:current_setup(mo_mcecu)
end
me1.manny_look_at_window = function(arg1) -- line 94
    manny:setpos(0.55, 2.15, 0)
    manny:setrot(0, 285.945, 0)
    manny:head_look_at(nil)
    manny:head_look_at(mo_tube)
end
me1.execute_line = function(arg1, arg2) -- line 101
    PrintDebug("Executing line!\n")
    if type(arg2) == "table" then
        print_table(arg2)
    else
        PrintDebug(arg2)
    end
    mo:current_setup(mo_mnycu)
    stop_script(meche.new_run_idle)
    meche:stop_chore()
    meche:play_chore(meche_sit_base)
    start_script(me1.wait_and_cut_to_meche)
    Dialog.execute_line(me1, arg2)
end
me1.intro = function(arg1) -- line 118
    me1.node = "first_meche_node"
    stop_script(mo.meche_looks_at_manny_when_he_talks)
    meche:head_look_at(nil)
    if not meche.introduced then
        meche.introduced = TRUE
        me1:manny_cu_mark()
        me1:meche_cu_mark()
        manny.idles_allowed = FALSE
        meche.stop_idle = TRUE
        stop_script(meche.new_run_idle)
        cameraman_disabled = TRUE
        mo:current_setup(mo_mcecu)
        set_override(me1.intro_override, me1)
        sleep_for(1000)
        meche:say_line("/momc001/")
        meche:play_chore(meche_sit_to_chin)
        wait_for_message()
        manny:head_look_at_point({ 1.09287, 1.6884, 0.4074, 360 }, 300)
        meche:say_line("/momc002/")
        meche:play_chore(meche_sit_in_gesture_2)
        meche:wait_for_chore()
        meche:play_chore(meche_sit_gesture_2_hold)
        wait_for_message()
        mo:current_setup(mo_mnycu)
        manny:head_look_at_point(1.09287, 1.6884, 0.4074, 90)
        manny:say_line("/moma003/")
        wait_for_message()
        mo:current_setup(mo_mcecu)
        meche:say_line("/momc004/")
        meche:play_chore(meche_sit_out_gesture_2)
        meche:wait_for_chore()
        meche:play_chore(meche_sit_hand_down)
        wait_for_message()
        mo:current_setup(mo_mnycu)
        manny:say_line("/moma005/")
        break_here()
        manny:head_look_at_point(1.09287, 1.6884, 0.3874)
        sleep_for(500)
        manny:head_look_at_point(1.09287, 1.6884, 0.4074)
        manny:wait_for_message()
        manny:head_look_at(mo.computer)
        manny:say_line("/moma006/")
        sleep_for(500)
        start_script(arg1.start_using_computer, arg1)
        wait_for_message()
        wait_for_script(arg1.start_using_computer)
        manny:say_line("/moma007/")
        wait_for_message()
        manny:head_look_at(mo.computer)
        sleep_for(500)
        manny:head_look_at_point(0.2, 1.875, 0.47)
        sleep_for(500)
        manny:say_line("/moma008/")
        wait_for_message()
        mo:current_setup(mo_mcecu)
        meche:say_line("/momc009/")
        meche:play_chore(meche_sit_scoot_out)
        manny:play_chore(ma_note_type_type_to_home, "ma_note_type.cos")
        manny:wait_for_chore()
        manny:head_look_at(nil)
        manny:pop_costume()
        manny:follow_boxes()
        me1:manny_look_at_window()
        wait_for_message()
        mo:current_setup(mo_mnycu)
        manny:say_line("/moma010/")
        wait_for_message()
        manny:say_line("/moma011/")
        manny:walkto(1.05347, 1.8705, 0)
        manny:head_look_at_point(1.09287, 1.6884, 0.4074)
        manny:wait_for_actor()
        manny:setrot(0, 211.716, 0)
        wait_for_message()
        sleep_for(500)
        mo:current_setup(mo_mcecu)
        meche:say_line("/momc012/")
        meche:play_chore(meche_sit_scoot_in)
        meche:wait_for_chore()
        meche:play_chore(meche_sit_adj_skirt)
        wait_for_message()
        meche:wait_for_chore()
    else
        manny:say_line("/moma015/")
        start_script(me1.walk_manny_to_mark)
        break_here()
        manny:wait_for_actor()
        mo:current_setup(mo_mnycu)
        wait_for_message()
        mo:current_setup(mo_mcecu)
        meche:say_line("/momc016/")
    end
    single_start_script(meche.new_run_idle, meche, "base")
end
me1.intro_override = function() -- line 237
    kill_override()
    stop_sound("keyboard.imu")
    stop_script(me1.start_using_computer)
    if manny:get_costume() == "ma_note_type.cos" then
        manny:pop_costume()
    end
    shut_up_everybody()
    manny:follow_boxes()
    me1:manny_cu_mark()
    me1:meche_cu_mark()
    cameraman_disabled = TRUE
    mo:current_setup(mo_mcecu)
    single_start_script(meche.new_run_idle, meche, "base")
    if me1.talked_out then
        me1.node = "exit_dialog"
    else
        me1.node = "first_meche_node"
    end
    me1:display_lines()
end
me1[100] = { text = "/moma017/", first_meche_node = TRUE }
me1[100].setup = function(arg1) -- line 258
    arg1.off = TRUE
end
me1[100].response = function(arg1) -- line 261
    arg1.off = TRUE
    meche:say_line("/momc018/")
    meche:play_chore_looping(meche_sit_tap_fingers)
end
me1[115] = { text = "/moma019/", first_meche_node = TRUE }
me1[115].response = function(arg1) -- line 268
    arg1.off = TRUE
    me1.node = "birthmark_node"
    meche:say_line("/momc020/")
    meche:play_chore(meche_sit_nod)
end
me1[120] = { text = "/moma021/", first_meche_node = TRUE }
me1[120].response = function(arg1) -- line 277
    arg1.off = TRUE
    me1[130].off = FALSE
    me1.node = "ask_node"
    meche:say_line("/momc022/")
    meche:play_chore(meche_sit_nod)
end
me1[130] = { text = "/moma023/", first_meche_node = TRUE }
me1[130].off = TRUE
me1[130].response = function(arg1) -- line 287
    me1.node = "ask_node"
    meche:say_line("/momc024/")
    meche:play_chore(meche_sit_squeeze_purse)
end
me1.exit_lines.first_meche_node = { text = "/moma025/" }
me1.exit_lines.first_meche_node.response = function(arg1) -- line 295
    me1.node = "exit_dialog"
    meche:say_line("/momc026/")
    meche:play_chore(meche_sit_look_down_in)
    if not me1.exited then
        me1.exited = TRUE
        wait_for_message()
        mo:current_setup(mo_mnycu)
        manny:say_line("/moma027/")
        wait_for_message()
        manny:head_look_at_point(1.09287, 1.6884, 0.3874)
        manny:say_line("/moma028/")
    end
end
me1.aborts.first_meche_node = function(arg1) -- line 311
    me1.talked_out = TRUE
    me1:clear()
    mo:current_setup(mo_mnycu)
    if system.locale == "EN_USA" then
        manny:say_line("/moma029/")
    else
        manny:say_line("/moma025/")
    end
    manny:wait_for_message()
    me1.exit_lines.first_meche_node.response()
end
me1[200] = { text = "/moma030/", birthmark_node = TRUE }
me1[200].response = function(arg1) -- line 326
    arg1.off = TRUE
    me1.node = "first_meche_node"
    meche:say_line("/momc031/")
    meche:play_chore(meche_sit_scoot_out)
    wait_for_message()
    meche:play_chore(meche_sit_scoot_in)
end
me1[210] = { text = "/moma032/", birthmark_node = TRUE }
me1[210].response = function(arg1) -- line 337
    arg1.off = TRUE
    me1.node = "first_meche_node"
    meche:say_line("/momc033/")
    meche:play_chore(meche_sit_look_around)
end
me1[220] = { text = "/moma034/", birthmark_node = TRUE }
me1[220].response = function(arg1) -- line 345
    arg1.off = TRUE
    me1.node = "exit_dialog"
    meche:say_line("/momc035/")
    meche:play_chore(meche_sit_look_around)
end
me1[300] = { text = "/moma036/", ask_node = TRUE }
me1[300].response = function(arg1) -- line 354
    arg1.off = TRUE
    me1[310].off = FALSE
    meche:say_line("/momc037/")
end
me1[310] = { text = "/moma038/", ask_node = TRUE }
me1[310].off = TRUE
me1[310].response = function(arg1) -- line 362
    arg1.off = TRUE
    me1[320].off = FALSE
    meche:say_line("/momc039/")
    meche:play_chore(meche_sit_look_down_in)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_look_tilt_in)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_look_to_base)
end
me1[320] = { text = "/moma040/", ask_node = TRUE }
me1[320].off = TRUE
me1[320].response = function(arg1) -- line 375
    arg1.off = TRUE
    meche:say_line("/momc041/")
    meche:play_chore(meche_sit_to_chin)
    wait_for_message()
    meche:play_chore(meche_sit_hand_down)
    meche:wait_for_chore()
end
me1[330] = { text = "/moma042/", ask_node = TRUE }
me1[330].response = function(arg1) -- line 385
    arg1.off = TRUE
    meche:say_line("/momc043/")
    meche:play_chore(meche_sit_to_chin)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma044/")
    wait_for_message()
    mo:current_setup(mo_mcecu)
    meche:say_line("/momc045/")
    sleep_for(1200)
    meche:play_chore(meche_sit_in_gesture_2)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_gesture_2_hold)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma046/")
end
me1[340] = { text = "/moma047/", ask_node = TRUE }
me1[340].response = function(arg1) -- line 405
    arg1.off = TRUE
    meche:say_line("/momc048/")
    meche:play_chore(meche_sit_lean_fwd)
    wait_for_message()
    meche:say_line("/momc049/")
    meche:play_chore(meche_sit_lean_rt)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma050/")
end
me1[350] = { text = "/moma051/", ask_node = TRUE }
me1[350].response = function(arg1) -- line 418
    arg1.off = TRUE
    meche:say_line("/momc052/")
    meche:play_chore(meche_sit_adj_skirt)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma053/")
    wait_for_message()
    mo:current_setup(mo_mcecu)
    meche:wait_for_chore()
    meche:say_line("/momc054/")
    meche:play_chore(meche_sit_to_chin)
    wait_for_message()
    meche:say_line("/momc055/")
    meche:play_chore(meche_sit_to_gesture_1)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma056/")
end
me1[360] = { text = "/moma057/", ask_node = TRUE }
me1[360].response = function(arg1) -- line 440
    arg1.off = TRUE
    meche:say_line("/momc058/")
    meche:play_chore(meche_sit_scoot_out)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_head_tap_in)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_head_tap_loop)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_head_tap_loop)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_head_tap_out)
    meche:wait_for_chore()
    meche:play_chore(meche_sit_scoot_in)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma059/")
    wait_for_message()
    mo:current_setup(mo_mcecu)
    meche:say_line("/momc060/")
    meche:play_chore(meche_sit_squeeze_purse)
end
me1[370] = { text = "/moma061/", ask_node = TRUE }
me1[370].response = function(arg1) -- line 464
    arg1.off = TRUE
    meche:say_line("/momc062/")
    meche:play_chore(meche_sit_tap_fingers)
end
me1[380] = { text = "/moma063/", ask_node = TRUE }
me1[380].response = function(arg1) -- line 471
    arg1.off = TRUE
    meche:say_line("/momc064/")
    meche:play_chore(meche_sit_lean_fwd)
    wait_for_message()
    mo:current_setup(mo_mnycu)
    manny:say_line("/moma065/")
end
me1.exit_lines.ask_node = { text = "/moma066/" }
me1.exit_lines.ask_node.response = function(arg1) -- line 481
    me1.node = "first_meche_node"
    meche:say_line("/momc067/")
    meche:play_chore(meche_sit_look_down_in)
    wait_for_message()
end
me1.aborts.ask_node = function(arg1) -- line 488
    PrintDebug("Aborting the ask node.\n")
    me1:clear()
    me1[130].off = TRUE
    me1:execute_line(me1.exit_lines.ask_node)
end
me1.outro = function(arg1) -- line 495
    single_start_script(meche.new_run_idle, meche, "base")
    meche.stop_idle = FALSE
    single_start_script(mo.meche_looks_at_manny_when_he_talks)
    cameraman_disabled = FALSE
    mo:manny_two_shot_mark()
    mo:current_setup(mo_ddtws)
end
me1[999] = "EOD"

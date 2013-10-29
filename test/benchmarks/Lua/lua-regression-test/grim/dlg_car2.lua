CheckFirstTime("dlg_car2.lua")
ca2 = Dialog:create()
ca2.focus = sl.view
ca2.intro = function(arg1) -- line 14
    manny.golden = FALSE
    music_state:set_state(stateSL_TALK)
    manny:ignore_boxes()
    manny:setpos(0.8556, 0.306978, 0)
    manny:setrot(0, 283.908, 0)
    manny:push_costume("manny_lunge.cos")
    manny:play_chore_looping(manny_lunge_sit, "manny_lunge.cos")
    manny:set_speech_mode(MODE_BACKGROUND)
    carla:ignore_boxes()
    carla:setpos(1.2179, 0.763751, 0)
    carla:setrot(0, 229.367, 0)
    carla:set_up_mood_swings()
    sl:current_setup(sl_intws)
    break_here()
    carla:say_line("/slca021/")
    carla:wait_for_message()
    manny:play_chore(manny_lunge_gesture, "manny_lunge.cos")
    manny:say_line("/slma022/")
    manny:wait_for_message()
    carla:say_line("/slca023/")
    carla:wait_for_message()
    manny:stop_chore(manny_lunge_gesture, "manny_lunge.cos")
    manny:play_chore(manny_lunge_wait, "manny_lunge.cos")
    manny:say_line("/slma024/")
    manny:wait_for_message()
    carla:say_line("/slca025/")
    carla:wait_for_message()
    ca2.node = "babble_node"
    start_script(ca2.babble)
end
ca2.update_lines = function(arg1) -- line 56
    local local1 = 1
    lines = arg1.current_choices
    while lines[local1] do
        ChangeTextObject(lines[local1].hText, lines[local1].text)
        local1 = local1 + 1
    end
end
ca2.babble = function() -- line 66
    carla:wait_and_say_line("/slca026/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca027/")
    carla:wait_for_message()
    ca2[10].text = "/slma028/"
    ca2[20].text = "/slma029/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca030/")
    carla:wait_for_message()
    ca2[10].text = "/slma031/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca032/")
    carla:wait_for_message()
    ca2[20].text = "/slma033/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca034/")
    carla:wait_for_message()
    ca2[30].text = "/slma035/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca036/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca037/")
    carla:wait_for_message()
    ca2[10].text = "/slma038/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca039/")
    carla:wait_for_message()
    carla:mood_swing("wistful")
    carla:wait_and_say_line("/slca040/")
    carla:wait_for_message()
    ca2[20].text = "/slma041/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca042/")
    carla:wait_for_message()
    ca2[10].text = "/slma043/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca044/")
    carla:wait_for_message()
    ca2[10].text = "/slma045/"
    ca2[20].text = "/slma046/"
    ca2[30].text = "/slma047/"
    ca2:update_lines()
    carla:mood_swing("casual")
    carla:wait_and_say_line("/slca048/")
    carla:wait_for_message()
    ca2[10].text = "/slma049/"
    ca2[20].text = "/slma050/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca051/")
    carla:wait_for_message()
    ca2[10].text = "/slma052/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca053/")
    carla:wait_for_message()
    ca2[10].text = "/slma054/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca055/")
    carla:wait_for_message()
    ca2[20].text = "/slma056/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca057/")
    carla:wait_for_message()
    ca2[10].text = "/slma058/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca059/")
    carla:wait_for_message()
    ca2[10].text = "/slma060/"
    ca2[20].text = "/slma061/"
    ca2[30].text = "/slma062/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca063/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca064/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca065/")
    carla:wait_for_message()
    ca2[10].text = "/slma066/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca067/")
    carla:wait_for_message()
    ca2[10].text = "/slma068/"
    ca2[20].text = "/slma069/"
    ca2[30].text = "/slma070/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca071/")
    carla:wait_for_message()
    carla:mood_swing("wistful")
    carla:wait_and_say_line("/slca072/")
    carla:wait_for_message()
    ca2[10].text = "/slma073/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca074/")
    carla:wait_for_message()
    ca2[20].text = "/slma075/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca076/")
    carla:wait_for_message()
    ca2[30].text = "/slma077/"
    ca2:update_lines()
    carla:mood_swing("casual")
    carla:wait_and_say_line("/slca078/")
    carla:wait_for_message()
    ca2[10].text = "/slma079/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca080/")
    carla:wait_for_message()
    ca2[10].text = "/slma081/"
    ca2[20].text = "/slma082/"
    ca2[30].text = "/slma083/"
    ca2:update_lines()
    carla:mood_swing("emote")
    carla:wait_and_say_line("/slca084/")
    carla:wait_for_message()
    carla:mood_swing("bitter")
    carla:wait_and_say_line("/slca085/")
    carla:wait_for_message()
    ca2[10].text = "/slma086/"
    ca2[20].text = "/slma087/"
    ca2[30].text = "/slma088/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca089/")
    sleep_for(1000)
    carla:mood_swing("stomp")
    carla:wait_for_message()
    ca2[10].text = "/slma090/"
    ca2[20].text = "/slma091/"
    ca2:update_lines()
    carla:mood_swing("angry")
    carla:wait_and_say_line("/slca092/")
    carla:wait_for_message()
    ca2[10].text = "/slma093/"
    ca2[20].text = "/slma094/"
    ca2[30].text = "/slma095/"
    ca2:update_lines()
    carla:mood_swing("tense")
    carla:wait_and_say_line("/slca096/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca097/")
    carla:wait_for_message()
    ca2[10].text = "/slma098/"
    ca2:update_lines()
    carla:mood_swing("cry")
    carla:wait_and_say_line("/slca099/")
    carla:wait_for_message()
    ca2[20].text = "/slma100/"
    ca2[30].text = "/slma101/"
    ca2:update_lines()
    carla:wait_and_say_line("/slca102/")
    carla:wait_for_message()
    carla:wait_and_say_line("/slca103/")
    carla:wait_for_message()
    ca2[10].text = "/slma104/"
    ca2[20].text = "/slma105/"
    ca2:update_lines()
    carla:mood_swing("sob")
    carla:wait_and_say_line("/slca106/")
    carla:wait_for_message()
    ca2[10].text = "/slma107/"
    ca2[20].text = "/slma108/"
    ca2[30].text = "/slma109/"
    ca2:update_lines()
    carla:mood_swing("sniffle")
    carla:say_line("/slca110/")
    carla:wait_for_message()
    while 1 do
        carla:mood_swing("sob")
        carla:wait_and_say_line("/slca111/")
        carla:wait_for_message()
        ca2[10].text = "/slma112/"
        ca2[20].text = "/slma113/"
        ca2[30].text = "/slma114/"
        ca2:update_lines()
        carla:wait_and_say_line("/slca115/")
        carla:wait_for_message()
        carla:wait_and_say_line("/slca116/")
        carla:wait_for_message()
    end
end
ca2[10] = { text = "/slma117/", babble_node = TRUE, gesture = sl.manny_lunge_gesture1 }
ca2[10].response = function(arg1) -- line 312
    ca2.node = "babble_node"
end
ca2[20] = { text = "/slma118/", babble_node = TRUE, gesture = sl.manny_lunge_gesture2 }
ca2[20].response = function(arg1) -- line 317
    ca2.node = "babble_node"
end
ca2[30] = { text = "/slma119/", babble_node = TRUE }
ca2[30].response = function(arg1) -- line 322
    ca2.node = "detector"
    carla:wait_for_message()
    stop_script(ca2.babble)
    carla:stop_looping_chores()
    carla:mood_swing("emote")
    carla:wait_for_message()
    if not ca2.asked_about_detector then
        ca2.asked_about_detector = TRUE
        carla:say_line("/slca120/")
    else
        carla:say_line("/slca121/")
    end
end
ca2[100] = { text = "/slma122/", detector = TRUE }
ca2[100].response = function(arg1) -- line 340
    ca2.node = "exit_dialog"
    stop_script(ca2.babble)
    sl.detector.in_catbox = TRUE
    cur_puzzle_state[26] = TRUE
    sl.detector:make_untouchable()
    cameraman_disabled = TRUE
    carla:stop_looping_chores()
    carla:play_chore(carla_cry_ehold_to_chold, sl.cry_cos)
    carla:wait_for_chore(carla_cry_ehold_to_chold, sl.cry_cos)
    carla:stop_chore(carla_cry_ehold_to_chold, sl.cry_cos)
    carla:play_chore(carla_cry_hold_md_out, sl.cry_cos)
    carla:say_line("/slca123/")
    carla:wait_for_message()
    carla:say_line("/slca124/")
    carla:wait_for_chore(carla_cry_hold_md_out, sl.cry_cos)
    carla:play_chore_looping(carla_cry_shake_md_loop, sl.cry_cos)
    carla:wait_for_message()
    carla:say_line("/slca125/")
    sleep_for(500)
    carla:set_chore_looping(carla_cry_shake_md_loop, FALSE, sl.cry_cos)
    carla:wait_for_chore(carla_cry_shake_md_loop, sl.cry_cos)
    carla:stop_chore(carla_cry_shake_md_loop, sl.cry_cos)
    manny:stop_chore(manny_lunge_sit, "manny_lunge.cos")
    manny:play_chore(manny_lunge_lunge, "manny_lunge.cos")
    carla:play_chore(carla_cry_throw_md, sl.cry_cos)
    manny:wait_for_chore(manny_lunge_lunge, "manny_lunge.cos")
    sleep_for(350)
    start_sfx("mdLand.WAV")
    set_pan("mdLand.WAV", 110)
    wait_for_sound("mdLand.WAV")
    sl:current_setup(sl_winha)
    carla:setpos(1.04081, 0.332219, 0)
    carla:setrot(0, 200.013, 0)
    carla:stop_chore(carla_cry_throw_md, sl.cry_cos)
    manny:stop_chore(manny_lunge_lunge, "manny_lunge.cos")
    manny:setpos(1.1467, 0.575275, 0)
    manny:setrot(0, 302.523, 0)
    manny:play_chore(manny_lunge_lunge2, "manny_lunge.cos")
    carla:wait_for_message()
    carla:say_line("/slca126/")
    carla:wait_for_message()
    carla:say_line("/slca127/")
    carla:wait_for_message()
    carla:wait_for_chore(carla_cry_throw_md, sl.cry_cos)
    carla:stop_chore(carla_cry_throw_md, sl.cry_cos)
    carla:play_chore(carla_stand_hold, sl.search_cos)
    carla:say_line("/slca128/")
    sleep_for(2000)
    manny:wait_for_chore(manny_lunge_lunge2, "manny_lunge.cos")
    manny:stop_chore(manny_lunge_lunge2, "manny_lunge.cos")
    manny:pop_costume()
    manny:setpos(1.25, 0.675, 0)
    manny:setrot(0, 172.425, 0)
    manny:follow_boxes()
    sl:current_setup(sl_intws)
    carla:wait_for_message()
    start_script(sl.carla_storm_out, carla)
    carla:say_line("/slca129/")
    carla:wait_for_message()
    manny:walkto(1.13441, 0.564019, 0)
    manny:wait_for_actor()
    manny:setrot(0, 186.788, 0, TRUE)
    manny:hand_gesture()
    manny:say_line("/slma130/")
    manny:wait_for_message()
    manny:set_speech_mode(MODE_NORMAL)
    sleep_for(1000)
    manny:head_look_at(nil)
    cameraman_disabled = FALSE
    music_state:set_state(stateSL)
end
ca2[110] = { text = "/slma131/", detector = TRUE }
ca2[110].response = function(arg1) -- line 425
    ca2.node = "babble_node"
    ca2[100].text = "/slma132/"
    ca2[110].text = "/slma133/"
    carla:mood_swing("casual")
    carla:say_line("/slca134/")
    carla:wait_for_message()
    carla:say_line("/slca135/")
    carla:wait_for_message()
    ca2[10].text = "/slma136/"
    ca2[20].text = "/slma137/"
    ca2[30].text = "/slma138/"
    start_script(ca2.babble)
end
ca2[999] = "EOD"

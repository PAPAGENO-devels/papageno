CheckFirstTime("th.lua")
dofile("thunderboy1_idles.lua")
dofile("thunderboy2_idles.lua")
dofile("thb1_coffee.lua")
dofile("thb2_coffee.lua")
dofile("msb_snowblow.lua")
dofile("msb_coffee.lua")
dofile("msb_theater.lua")
th = Set:create("th.set", "theater backstage", { th_stgws = 0, th_stgws2 = 0, th_rftha = 2, th_tbyws = 1, th_snocu = 3, th_ovrhd = 4 })
th.lever_actor = Actor:create(nil, nil, nil, "snow lever")
th.lever_actor.default = function(arg1) -- line 24
    arg1:set_costume("msb_snowblow.cos")
    arg1:put_in_set(th)
    arg1:setpos(0.20997, -0.0325, 2.1527)
    arg1:setrot(0, 90, 0)
    arg1:play_chore(msb_snowblow_chain_only)
end
th.coffeepot_actor = Actor:create(nil, nil, nil, "coffee pot")
th.coffeepot_actor.default = function(arg1) -- line 35
    arg1:set_costume("msb_coffee.cos")
    arg1:put_in_set(th)
    arg1:set_softimage_pos(-4.4588, 0, 19.993)
    arg1:setrot(0, 225, 0)
    arg1:play_chore(msb_coffee_coffee_on_burner)
    arg1:set_visibility(TRUE)
end
th.grinder_actor = Actor:create(nil, nil, nil, "grinder")
th.grinder_actor.default = function(arg1) -- line 47
    arg1:set_costume("th_grinder.cos")
    arg1:put_in_set(th)
    arg1:setpos(0.0860798, -0.011, 2.497)
    arg1:setrot(0, 101, 0)
    if th.grinder.has_bone then
        arg1:complete_chore(1)
    else
        arg1:complete_chore(0)
    end
end
th.stop_thunderboys = function() -- line 61
    stop_script(th.backstage_mumbling)
    stop_script(th.backstage_idling)
    thunder_boy_1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
    thunder_boy_1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
    thunder_boy_2:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
end
tb1 = Dialog:create()
tb1.intro = function(arg1) -- line 72
    th.mocked = TRUE
    if find_script(th.meet_the_thunder_boys) then
        stop_script(th.meet_the_thunder_boys)
    end
    th.stop_thunderboys()
    wait_for_message()
    START_CUT_SCENE()
    manny:setpos(0.363558, -0.583726, 0)
    manny:setrot(0, 296.391, 0)
    thunder_boy_1:say_line("/tht1003/")
    thunder_boy_1:wait_for_message()
    END_CUT_SCENE()
end
tb1[100] = { text = "/thma004/", n1 = TRUE }
tb1[100].response = function(arg1) -- line 90
    thunder_boy_2:say_line("/tht2005/")
    manny:head_look_at(th.thunderboy2)
    tb1.kiss_off()
end
tb1[200] = { text = "/thma006/", n1 = TRUE }
tb1[200].response = function(arg1) -- line 97
    thunder_boy_2:say_line("/tht2007/")
    manny:head_look_at(th.thunderboy2)
    tb1.kiss_off()
end
tb1.kiss_off = function() -- line 104
    tb1.node = "exit_dialog"
    wait_for_message()
    thunder_boy_1:say_line("/tht1008/")
    manny:head_look_at(th.thunderboy1)
    wait_for_message()
    thunder_boy_2:say_line("/tht2009/")
    manny:head_look_at(th.thunderboy2)
    wait_for_message()
    manny:head_look_at(nil)
    manny:walkto(0.197732, -0.593037, 0)
    th:current_setup(th_stgws)
    sleep_for(1000)
    thunder_boy_2:say_line("/tht2010/")
    sleep_for(500)
    thunder_boy_1:say_line("/tht1011/")
    wait_for_message()
    start_script(th.backstage_mumbling, th)
    start_script(th.backstage_idling, th)
    cameraman_disabled = FALSE
end
th.back_off = function() -- line 126
    stop_script(th.meet_the_thunder_boys)
    if manny.is_holding == th.coffee_pot then
        start_script(th.serve_coffee)
    else
        cameraman_disabled = TRUE
        th:current_setup(th_tbyws)
        manny:setpos(0.363558, -0.583726, 0)
        manny:setrot(0, 296.391, 0)
        if th.mocked then
            START_CUT_SCENE()
            thunder_boy_2:say_line("/tht2012/")
            wait_for_message()
            thunder_boy_2:say_line("/tht2013/")
            END_CUT_SCENE()
            manny:setpos(0.197732, -0.593037, 0)
            manny:setrot(0, 108.182, 0)
            th:current_setup(th_stgws)
            cameraman_disabled = FALSE
        else
            tb1:init()
        end
    end
end
th.meet_the_thunder_boys = function() -- line 155
    START_CUT_SCENE()
    th.met_thunder_boys = TRUE
    set_override(th.skip_meet_boys, th)
    manny:head_look_at(th.thunderboy2)
    stop_script(th.backstage_mumbling)
    thunder_boy_1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
    thunder_boy_1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
    thunder_boy_2:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
    thunder_boy_2:say_line("/tht2014/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1015/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2016/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1017/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2018/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1019/")
    thunder_boy_1:wait_for_message()
    END_CUT_SCENE()
    manny:head_look_at(nil)
    thunder_boy_2:say_line("/tht2020/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1021/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2022/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2023/")
    thunder_boy_2:wait_for_message()
    start_script(th.backstage_mumbling, th)
end
th.skip_meet_boys = function(arg1) -- line 193
    kill_override()
    single_start_script(th.backstage_mumbling, th)
end
th.eavesdrop = function() -- line 199
    th.stop_thunderboys()
    START_CUT_SCENE()
    box_off("eavesdrop_trigg")
    th.eavesdropped = TRUE
    th:current_setup(th_tbyws)
    break_here()
    thunder_boy_2:say_line("/tht2024/")
    sleep_for(500)
    manny:walkto(0.960463, -1.08513, -0.29)
    manny:wait_for_actor()
    manny:setrot(0, 452.177, 0)
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1025/")
    wait_for_message()
    thunder_boy_2:say_line("/tht2026/")
    wait_for_message()
    thunder_boy_2:say_line("/tht2027/")
    wait_for_message()
    thunder_boy_1:say_line("/tht1028/")
    wait_for_message()
    th:current_setup(th_stgws)
    END_CUT_SCENE()
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.burn_thunderboy_burn = function() -- line 227
    START_CUT_SCENE()
    th.boys_gone = TRUE
    th.thunderboy1:make_untouchable()
    th.thunderboy2:make_untouchable()
    stop_script(th.meet_the_thunder_boys)
    th.stop_thunderboys()
    th.thunderboys_from_above:make_untouchable()
    box_off("personal_bubble")
    box_off("eavesdrop_trigg")
    thunder_boy_1:wait_for_chore()
    thunder_boy_2:wait_for_chore()
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:push_costume("msb_coffee.cos")
    manny:play_chore(msb_coffee_start_pour_on_boyz, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofLng.WAV")
    manny:wait_for_chore(msb_coffee_start_pour_on_boyz, "msb_coffee.cos")
    manny:play_chore_looping(msb_coffee_pour_on_boyz, "msb_coffee.cos")
    music_state:set_sequence(seqCoffeeOnBoys)
    sleep_for(1000)
    th:current_setup(th_tbyws)
    manny:ignore_boxes()
    manny:setpos(0.542084, -0.123266, 2.05)
    manny:setrot(0, 164.794, 0)
    thunder_boy_2:say_line("/tht2029/")
    sleep_for(500)
    thunder_boy_1:stop_chore(thunderboy1_idles_talk1, "thunderboy1_idles.cos")
    thunder_boy_1:stop_chore(thunderboy1_idles_talk2, "thunderboy1_idles.cos")
    thunder_boy_1:stop_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_1:set_time_scale(1.2)
    thunder_boy_1:play_chore(thb1_coffee_coffee_dumped, "thb1_coffee.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_talk1, "thunderboy2_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_talk2, "thunderboy2_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_whole_back, "thunderboy2_idles.cos")
    thunder_boy_2:set_time_scale(1.2)
    thunder_boy_2:play_chore(thb2_coffee_dumped_on, "thb2_coffee.cos")
    thunder_boy_2:wait_for_message()
    manny:stop_chore(msb_coffee_pour_on_boyz, "msb_coffee.cos")
    thunder_boy_2:say_line("/tht2030/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1031/")
    thunder_boy_1:wait_for_message()
    sleep_for(1000)
    thunder_boy_2:say_line("/tht2032/")
    thunder_boy_2:wait_for_message()
    th:current_setup(th_stgws)
    thunder_boy_2:setpos(0.625962, -0.313716, 0)
    thunder_boy_2:setrot(0, 123.538, 0)
    thunder_boy_2:setpos(0.605883, -0.492313, 0)
    thunder_boy_1:setrot(0, 63.5565, 0)
    thunder_boy_2:say_line("/tht2033/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2034/")
    thunder_boy_2:wait_for_chore(thb2_coffee_dumped_on, "thb2_coffee.cos")
    thunder_boy_2:play_chore(thb2_coffee_run, "thb2_coffee.cos")
    thunder_boy_1:play_chore(thb1_coffee_run, "thb1_coffee.cos")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1035/")
    thunder_boy_1:wait_for_chore(thb1_coffee_run, "thb1_coffee.cos")
    th:current_setup(th_rftha)
    manny:follow_boxes()
    manny:put_at_object(th.thunderboys_from_above)
    manny:play_chore(msb_coffee_stop_pour_on_boyz, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour_on_boyz, "msb_coffee.cos")
    thunder_boy_1:wait_for_message()
    thunder_boy_1:free()
    thunder_boy_2:free()
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    END_CUT_SCENE()
end
th.set_up_actors = function(arg1) -- line 312
    if th.boys_gone then
        thunder_boy_1:put_in_set(nil)
        th.thunderboy1:make_untouchable()
        thunder_boy_2:put_in_set(nil)
        th.thunderboy2:make_untouchable()
        box_off("personal_bubble")
        box_off("eavesdrop_trigg")
    else
        thunder_boy_1:default()
        thunder_boy_1:put_in_set(th)
        thunder_boy_1:setpos(0.63103, -0.69655, 0)
        thunder_boy_1:setrot(0, 95.2081, 0)
        thunder_boy_2:default()
        thunder_boy_2:put_in_set(th)
        thunder_boy_2:setpos(0.60327, -0.35421, 0)
        thunder_boy_2:setrot(0, 144.486, 0)
        start_script(th.backstage_mumbling, th)
        start_script(th.backstage_idling, th)
    end
    th.lever_actor:default()
    if th.coffee_pot.touchable then
        th.coffeepot_actor:default()
    end
    if th.snow_machine.has_grinder then
        th.grinder_actor:default()
    end
    if makeup_woman then
        makeup_woman.saylineTable.x = 400
        makeup_woman.saylineTable.y = 200
        makeup_woman.saylineTable.pan = 110
    end
end
th.backstage_lines_one = { "/tht1044/", "/tht1045/", "/tht1046/", "/tht1047/", "/tht1048/", "/tht1049/", "/tht1050/", "/tht1051/", "/tht1052/" }
th.backstage_lines_two = { "/tht2036/", "/tht2037/", "/tht2038/", "/tht2039/", "/tht2040/", "/tht2041/", "/tht2042/", "/tht2043/" }
th.backstage_mumbling = function(arg1) -- line 375
    local local1 = thunder_boy_1
    local local2 = th.backstage_lines_one
    local local3, local4, local5
    while system.currentSet == th do
        if cutSceneLevel <= 0 then
            if local1 == thunder_boy_1 then
                local1:play_chore_looping(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
            else
                local1:play_chore_looping(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
            end
            local3 = rndint(2000, 5000)
            local5 = FALSE
            local4 = 0
            while local4 < local3 do
                if not local5 and rnd(8) and cutSceneLevel <= 0 then
                    if local1 == thunder_boy_1 then
                        local1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                    else
                        local1:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                    end
                    local1:say_line(pick_one_of(local2, TRUE), { background = TRUE, skip_log = TRUE, volume = 10 })
                    local1:wait_for_message()
                    if local1 == thunder_boy_1 then
                        local1:play_chore_looping(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                    else
                        local1:play_chore_looping(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                    end
                    local5 = TRUE
                end
                break_here()
                local4 = local4 + system.frameTime
            end
            if local1 == thunder_boy_1 then
                local1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                local1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
                local1 = thunder_boy_2
                local2 = th.backstage_lines_two
            else
                local1:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                local1:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
                local1 = thunder_boy_1
                local2 = th.backstage_lines_one
            end
        end
        break_here()
    end
end
th.backstage_idling = function(arg1) -- line 427
    local local1, local2
    thunder_boy_1:play_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_2:play_chore(thunderboy1_idles_whole_back, "thunderboy2_idles.cos")
    thunder_boy_1:wait_for_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_2:wait_for_chore(thunderboy1_idles_whole_back, "thunderboy2_idles.cos")
    while system.currentSet == th do
        if local1 == thunderboy1_idles_talk1 then
            local1 = thunderboy1_idles_talk2
        else
            local1 = thunderboy1_idles_talk1
        end
        thunder_boy_1:play_chore(local1, "thunderboy1_idles.cos")
        thunder_boy_1:wait_for_chore(local1, "thunderboy1_idles.cos")
        if local2 == thunderboy2_idles_talk1 then
            local2 = thunderboy2_idles_talk2
        else
            local2 = thunderboy2_idles_talk1
        end
        thunder_boy_2:play_chore(local2, "thunderboy2_idles.cos")
        thunder_boy_2:wait_for_chore(local2, "thunderboy2_idles.cos")
    end
end
th.crash_dressing_room = function() -- line 456
    START_CUT_SCENE()
    if manny.is_holding == th.coffee_pot and (not th.boys_gone or manny.thunder) then
        makeup_woman:say_line("/thmk053/")
        makeup_woman:wait_for_message()
        start_sfx("thCofSht.WAV", IM_HIGH_PRIORITY, 127)
        set_pan("thCofSht.WAV", 127)
        wait_for_sound("thCofSht.WAV")
    elseif not th.boys_gone then
        makeup_woman:say_line("/thmk054/")
    elseif not manny.thunder then
        manny.thunder = TRUE
        cur_puzzle_state[55] = TRUE
        if manny.is_holding == th.coffee_pot then
            th.coffee_pot:free()
            th.coffee_pot:make_untouchable()
            box_on("grinder_box1")
            box_on("grinder_box2")
            manny.is_holding = nil
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
            makeup_woman:say_line("/thmk056/")
        else
            makeup_woman:say_line("/thmk057/")
        end
        wait_for_message()
        makeup_woman:say_line("/thmk058/")
        wait_for_message()
        manny:say_line("/thma059/")
        wait_for_message()
        IrisDown(570, 300, 1000)
        makeup_woman:say_line("/thmk060/")
        wait_for_message()
        sleep_for(500)
        manny.thunder = TRUE
        manny:default("thunder")
        IrisUp(570, 300, 1000)
        manny:walkto(1.06713, -1.14721, -0.29)
        makeup_woman:say_line("/thmk061/")
    else
        manny:say_line("/thma062/")
        wait_for_message()
        makeup_woman:say_line("/thmk063/")
        wait_for_message()
        if not th.bashed_thunder then
            th.bashed_thunder = TRUE
            makeup_woman:say_line("/thmk064/")
            wait_for_message()
            manny:say_line("/thma065/")
            wait_for_message()
            makeup_woman:say_line("/thmk066/")
        end
    end
    END_CUT_SCENE()
    manny:walkto(1.06713, -1.14721, -0.29)
end
th.serve_coffee = function() -- line 519
    th:current_setup(th_stgws)
    th.stop_thunderboys()
    START_CUT_SCENE()
    set_override(th.skip_serve_coffee, th)
    thunder_boy_1:say_line("/tht1067/")
    manny:head_look_at(th.thunderboy1)
    manny:walkto(0.156781, -0.804922, 0, 0, 296.215, 0)
    thunder_boy_1:wait_for_message()
    manny:wait_for_actor()
    thunder_boy_1:wait_for_chore()
    thunder_boy_1:set_time_scale(1.8)
    thunder_boy_2:set_time_scale(1.8)
    manny:push_costume("msb_coffee.cos")
    thunder_boy_1:play_chore(thb1_coffee_get_coffee, "thb1_coffee.cos")
    sleep_for(1500)
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:play_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofSht.WAV")
    manny:wait_for_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    manny:play_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    manny:head_look_at(th.thunderboy2)
    manny:walkto(0.126085, -0.476472, 0, 0, 317.476, 0)
    manny:wait_for_actor()
    thunder_boy_2:wait_for_chore()
    manny:push_costume("msb_coffee.cos")
    thunder_boy_2:play_chore(thb2_coffee_get_coffee, "thb2_coffee.cos")
    sleep_for(1500)
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:play_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofSht.WAV")
    manny:wait_for_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    manny:play_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    thunder_boy_1:set_time_scale(1)
    thunder_boy_2:set_time_scale(1)
    if not th.served then
        th.served = TRUE
        thunder_boy_2:say_line("/tht2068/")
        thunder_boy_2:wait_for_message()
        thunder_boy_2:say_line("/tht2069/")
        thunder_boy_2:wait_for_message()
    else
        thunder_boy_2:say_line("/tht2070/")
        thunder_boy_2:wait_for_message()
    end
    END_CUT_SCENE()
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.skip_serve_coffee = function(arg1) -- line 587
    kill_override()
    if manny:get_costume() == "msb_coffee.cos" then
        manny:pop_costume()
    end
    thunder_boy_1:stop_chore()
    thunder_boy_2:stop_chore()
    thunder_boy_1:set_time_scale(1)
    thunder_boy_2:set_time_scale(1)
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    manny:setpos(0.126085, -0.476472, 0)
    manny:setrot(0, 317.476, 0)
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.climb_in = function(arg1) -- line 604
    local local1
    START_CUT_SCENE()
    th:switch_to_set()
    manny:put_in_set(th)
    manny:setpos(-0.53868401, -1.2299401, 0)
    manny:setrot(0, 78.479599, 0)
    if manny.fancy then
        local1 = "mcc_theater.cos"
    else
        local1 = "msb_theater.cos"
    end
    manny:push_costume(local1)
    manny:play_chore(msb_theater_enter_th, local1)
    manny:wait_for_chore(msb_theater_enter_th, local1)
    manny:blend(msb_rest, msb_theater_enter_th, 500, manny.base_costume, local1)
    sleep_for(500)
    manny:pop_costume()
    manny:walkto(-0.37628499, -1.23063, 0, 0, 285.67001, 0)
    END_CUT_SCENE()
end
th.climb_out = function(arg1) -- line 627
    local local1
    START_CUT_SCENE()
    manny:walkto(-0.53868401, -1.2299401, 0, 0, 78.479599, 0)
    manny:wait_for_actor()
    if manny.fancy then
        local1 = "mcc_theater.cos"
    else
        local1 = "msb_theater.cos"
    end
    manny:push_costume(local1)
    manny:fade_in_chore(msb_theater_exit_th, local1, 500)
    manny:wait_for_chore(msb_theater_exit_th, local1)
    manny:pop_costume()
    END_CUT_SCENE()
end
th.enter = function(arg1) -- line 651
    th:set_up_actors()
    if th.eavesdropped then
        box_off("eavesdrop_trigg")
    end
end
th.exit = function(arg1) -- line 658
    th.lever_actor:free()
    th.coffeepot_actor:free()
    thunder_boy_1:free()
    thunder_boy_2:free()
    stop_script(th.meet_the_thunder_boys)
    stop_script(th.backstage_mumbling)
    stop_script(th.backstage_idling)
end
th.personal_bubble = { }
th.personal_bubble.walkOut = function(arg1) -- line 677
    start_script(th.back_off)
end
th.eavesdrop_trigg = { }
th.eavesdrop_trigg.walkOut = function(arg1) -- line 684
    start_script(th.eavesdrop)
end
th.grinder = Object:create(th, "/thtx071/grinder", 0, 0, 0, { range = 0 })
th.grinder.use_pnt_x = 0.175
th.grinder.use_pnt_y = -0.048978701
th.grinder.use_pnt_z = 2.2
th.grinder.use_rot_x = 0
th.grinder.use_rot_y = 89.391602
th.grinder.use_rot_z = 0
th.grinder.wav = "getMetl.wav"
th.grinder:make_untouchable()
th.grinder.lookAt = function(arg1) -- line 699
    if manny.shot and not manny.healed then
        mf:use_grinder()
    elseif not arg1.has_bone then
        manny:say_line("/thma072/")
    else
        manny:say_line("/thma073/")
    end
end
th.grinder.use = function(arg1) -- line 711
    local local1, local2, local3
    if manny.shot and not manny.healed then
        mf:use_grinder()
    elseif arg1.has_bone and bowlsley_in_hiding then
        manny_grind()
    else
        START_CUT_SCENE()
        look_at_item_in_hand(TRUE)
        if arg1.has_bone or arg1.has_snow then
            if manny.costume_state == "reaper" then
                local1 = md_use_grinder
                local3 = md_activate_grinder_full
                local2 = md_hold_grinder
                start_sfx("grinder.IMU")
                manny:play_chore_looping(local1, manny.base_costume)
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                if arg1.has_bone or arg1.has_snow then
                    manny:stop_chore(local1, manny.base_costume)
                    manny:play_chore(local2, manny.base_costume)
                    manny:play_chore(local3, manny.base_costume)
                end
            elseif manny.fancy then
                manny:stop_chore(mcc_thunder_hold, "mcc_thunder.cos")
                if arg1.has_snow then
                    manny:stop_chore(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
                    manny:play_chore_looping(75, "mcc_thunder.cos")
                else
                    manny:stop_chore(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
                    manny:play_chore_looping(mcc_thunder_use_grinder, "mcc_thunder.cos")
                end
                manny:play_chore_looping(mcc_thunder_hold_grinder, "mcc_thunder.cos")
                start_sfx("grinder.IMU")
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                manny:stop_chore(mcc_thunder_use_grinder, "mcc_thunder.cos")
                manny:stop_chore(75, "mcc_thunder.cos")
                manny:stop_chore(mcc_thunder_hold_grinder, "mcc_thunder.cos")
                manny:play_chore_looping(mcc_thunder_hold, "mcc_thunder.cos")
                if arg1.has_snow then
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
                else
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
                end
            else
                if th.grinder.has_bone then
                    manny:stop_chore(msb_activate_grinder_full, manny.base_costume)
                else
                    manny:stop_chore(msb_activate_grinder_empty, manny.base_costume)
                end
                if arg1.has_snow then
                    local1 = 87
                else
                    local1 = msb_use_grinder
                end
                start_sfx("grinder.IMU")
                manny:play_chore_looping(local1, manny.base_costume)
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                manny:stop_chore(local1, manny.base_costume)
                if th.grinder.has_bone then
                    manny:play_chore_looping(msb_activate_grinder_full, manny.base_costume)
                else
                    manny:play_chore_looping(msb_activate_grinder_empty, manny.base_costume)
                end
            end
        else
            start_sfx("grinder.IMU")
            sleep_for(2000)
            fade_sfx("grinder.imu", 500)
        end
        END_CUT_SCENE()
        if arg1.has_snow then
            arg1.has_snow = FALSE
        end
    end
end
th.grinder.default_response = th.grinder.use
th.snow_machine = Object:create(th, "/thtx074/snow machine", 0.025, -0.0289787, 2.46, { range = 0.60000002 })
th.snow_machine.use_pnt_x = 0.175
th.snow_machine.use_pnt_y = -0.048978701
th.snow_machine.use_pnt_z = 2.2
th.snow_machine.use_rot_x = 0
th.snow_machine.use_rot_y = 89.391602
th.snow_machine.use_rot_z = 0
th.snow_machine.has_grinder = TRUE
th.snow_machine.lookAt = function(arg1) -- line 811
    arg1.seen = TRUE
    manny:say_line("/thma075/")
    if arg1.has_grinder and not th.held_grinder then
        arg1:demo()
    end
end
th.snow_machine.demo = function(arg1) -- line 819
    START_CUT_SCENE()
    wait_for_message()
    manny:say_line("/thma076/")
    arg1:pickUp()
    manny:say_line("/moma053/")
    manny:wait_for_message()
    manny:setrot(0, 126.275, 0, TRUE)
    manny:wait_for_actor()
    manny:say_line("/syma159/")
    look_at_item_in_hand()
    arg1:use_grinder()
    END_CUT_SCENE()
end
th.snow_machine.pickUp = function(arg1) -- line 835
    if arg1.has_grinder then
        th.held_grinder = TRUE
        if manny.is_holding == th.coffee_pot then
            system.default_response("not now")
        else
            START_CUT_SCENE()
            th:current_setup(th_snocu)
            manny:walkto(0.217875, -0.064783, 2.156, 0, -272.067, 0)
            manny:head_look_at(nil)
            arg1.has_grinder = FALSE
            arg1.seen = TRUE
            th.grinder:get()
            if manny.fancy then
                if th.grinder.has_bone then
                    manny:play_chore(mcc_thunder_take_grinder_hand, "mcc_thunder.cos")
                else
                    manny:play_chore(mcc_thunder_take_grinder_no_hand, "mcc_thunder.cos")
                end
            elseif th.grinder.has_bone then
                manny:play_chore(msb_take_grinder_hand, "msb.cos")
            else
                manny:play_chore(msb_take_grinder_no_hand, "msb.cos")
            end
            sleep_for(850)
            start_sfx("thInsGrn.WAV")
            th.grinder_actor:set_visibility(FALSE)
            sleep_for(900)
            start_sfx("grdClLid.wav")
            manny:wait_for_chore()
            if manny.fancy then
                manny:stop_chore(mcc_thunder_take_grinder_hand, "mcc_thunder.cos")
                manny:stop_chore(mcc_thunder_take_grinder_no_hand, "mcc_thunder.cos")
            else
                manny:stop_chore(msb_take_grinder_no_hand, "msb.cos")
                manny:stop_chore(msb_take_grinder_hand, "msb.cos")
            end
            if manny.fancy then
                if th.grinder.has_bone then
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_full, manny.base_costume)
                    manny.hold_chore = mcc_thunder_takeout_grinder_full
                else
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_empty, manny.base_costume)
                    manny.hold_chore = mcc_thunder_takeout_grinder_empty
                end
            elseif th.grinder.has_bone then
                manny:play_chore_looping(msb_activate_grinder_full, manny.base_costume)
                manny.hold_chore = msb_activate_grinder_full
            else
                manny:play_chore_looping(msb_activate_grinder_empty, manny.base_costume)
                manny.hold_chore = msb_activate_grinder_empty
            end
            manny:play_chore_looping(ms_hold, manny.base_costume)
            sleep_for(1000)
            manny.is_holding = th.grinder
            manny:head_look_at(arg1)
            END_CUT_SCENE()
        end
    else
        system.default_response("huge")
    end
end
th.snow_machine.use = function(arg1) -- line 902
    if arg1.has_grinder then
        START_CUT_SCENE()
        manny:walkto(0.217875, -0.064783, 2.156, 0, 82.7267, 0)
        manny:wait_for_actor()
        th:current_setup(th_snocu)
        if manny.fancy then
            manny:push_costume("mcc_snowblow.cos")
        else
            manny:push_costume("msb_snowblow.cos")
        end
        manny:play_chore(msb_snowblow_turn_switch)
        sleep_for(600)
        start_sfx("snoMach.IMU")
        if th.grinder.has_snow or th.grinder.has_bone then
            th:current_setup(th_stgws)
            if not th.snow_actor then
                th.snow_actor = Actor:create(nil, nil, nil, "snow")
            end
            th.snow_actor:put_in_set(th)
            th.snow_actor:set_costume("th_snow.cos")
            th.snow_actor:set_softimage_pos(0, 2, 0)
            th.snow_actor:setrot(0, 180, 0)
            th.snow_actor:play_chore_looping(0)
            sleep_for(5000)
            th:current_setup(th_snocu)
            th.snow_actor:free()
            if th.grinder.has_snow then
                th.grinder.has_snow = FALSE
            end
        else
            sleep_for(2000)
        end
        stop_sound("snoMach.IMU")
        manny:wait_for_chore(msb_snowblow_turn_switch)
        manny:pop_costume()
        END_CUT_SCENE()
        if not arg1.seen then
            arg1:lookAt()
        end
    else
        manny:say_line("/thma077/")
    end
end
th.snow_machine.use_grinder = function(arg1) -- line 947
    if th.grinder.has_bone then
        manny:say_line("/thma078/")
    else
        START_CUT_SCENE()
        manny:walkto(0.217875, -0.064783, 2.156, 0, 82.7267, 0)
        manny:wait_for_actor()
        th:current_setup(th_snocu)
        manny:head_look_at(nil)
        arg1.has_grinder = TRUE
        manny:stop_chore(msb_hold, manny.base_costume)
        if manny.fancy then
            manny:stop_chore(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
            manny:play_chore(mcc_thunder_return_grinder, "mcc_thunder.cos")
        else
            manny:stop_chore(msb_activate_grinder_empty, "msb.cos")
            manny:play_chore(msb_return_grinder, "msb.cos")
        end
        sleep_for(800)
        start_sfx("grdOpLid.wav")
        sleep_for(200)
        start_sfx("thInsGrn.WAV")
        sleep_for(374)
        th.grinder_actor:set_visibility(TRUE)
        manny:wait_for_chore()
        manny.hold_chore = nil
        manny.is_holding = nil
        if manny.fancy then
            manny:stop_chore(mcc_thunder_return_grinder, "mcc_thunder.cos")
        else
            manny:stop_chore(msb_return_grinder, "msb.cos")
        end
        th.grinder:free()
        sleep_for(200)
        manny:head_look_at(arg1)
        END_CUT_SCENE()
    end
end
th.snow_machine.use_hand = function(arg1) -- line 987
    if arg1.has_grinder then
        if th.grinder.has_snow then
            system.default_response("full")
        else
            START_CUT_SCENE()
            manny:walkto(0.196374, -0.0406213, 2.2, 0, 82.7267, 0)
            manny:wait_for_actor()
            nq.arm:free()
            th.grinder.has_bone = TRUE
            manny:head_look_at(nil)
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(manny.hold_chore, manny.base_costume)
            manny.hold_chore = nil
            if manny.fancy then
                manny:push_costume("mcc_snowblow.cos")
            else
                manny:push_costume("msb_snowblow.cos")
            end
            manny:play_chore(msb_snowblow_put_hand)
            manny:wait_for_chore(msb_snowblow_put_hand)
            manny:pop_costume()
            th.grinder_actor:default()
            manny:head_look_at(arg1)
            manny:say_line("/thma079/")
            END_CUT_SCENE()
        end
    else
        th.snow_machine:use()
    end
end
th.snow_machine.use_coffee_pot = function(arg1) -- line 1019
    manny:say_line("/thma080/")
end
th.snow_machine.use_sproutella = function(arg1) -- line 1023
    if arg1.has_grinder and th.grinder.has_bone then
        manny:say_line("/thma081/")
    else
        fi.sproutella:default_response(th.snow_machine)
    end
end
th.lever = Object:create(th, "/thtx082/lever", 0.075000003, 0.151021, 2.5699999, { range = 0.60000002 })
th.lever.use_pnt_x = 0.20997
th.lever.use_pnt_y = -0.032499999
th.lever.use_pnt_z = 2.2
th.lever.use_rot_x = 0
th.lever.use_rot_y = 90
th.lever.use_rot_z = 0
th.lever.lookAt = function(arg1) -- line 1041
    manny:say_line("/thma083/")
end
th.lever.use = function(arg1) -- line 1046
    if th.snow_machine.has_grinder then
        if manny.is_holding == th.coffee_pot then
            system.default_response("not now")
        elseif th.grinder.has_snow or th.grinder.has_bone then
            system.default_response("full")
        else
            th.grinder.has_snow = TRUE
            if manny:walkto_object(arg1) then
                START_CUT_SCENE()
                manny:head_look_at(nil)
                if manny.fancy then
                    manny:push_costume("mcc_snowblow.cos")
                else
                    manny:push_costume("msb_snowblow.cos")
                end
                th.lever_actor:set_visibility(FALSE)
                manny:play_chore(msb_snowblow_pull_chain)
                manny:wait_for_chore(msb_snowblow_pull_chain)
                manny:pop_costume()
                th.lever_actor:set_visibility(TRUE)
                END_CUT_SCENE()
            end
        end
    else
        soft_script()
        manny:say_line("/thma084/")
        wait_for_message()
        manny:say_line("/thma085/")
    end
end
th.lever.pickUp = function(arg1) -- line 1080
    if th.snow_machine.has_grinder then
        start_script(th.snow_machine.pickUp, th.snow_machine)
    else
        th.lever:use()
    end
end
th.ladder_bot = Object:create(th, "/thtx001/ladder", 0.70499998, -0.055, 0.75999999, { range = 1 })
th.ladder_bot.use_pnt_x = 0.46472499
th.ladder_bot.use_pnt_y = -0.040333699
th.ladder_bot.use_pnt_z = 0
th.ladder_bot.use_rot_x = 0
th.ladder_bot.use_rot_y = 258.875
th.ladder_bot.use_rot_z = 0
th.ladder_bot.lookAt = function(arg1) -- line 1099
    system.default_response("ladder")
end
th.ladder_bot.pickUp = function(arg1) -- line 1103
    system.default_response("attached")
end
th.ladder_bot.use = function(arg1) -- line 1107
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(th.ladder_top)
        if not manny.fancy then
            manny:play_chore(msb_lf_hand_on_obj, manny.base_costume)
            manny:wait_for_chore(msb_lf_hand_on_obj, manny.base_costume)
        else
            manny:play_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
            manny:wait_for_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
        end
        manny:put_at_object(th.ladder_top)
        th:current_setup(th_rftha)
        manny:head_look_at(th.ladder_top)
        if not manny.fancy then
            manny:stop_chore(msb_lf_hand_on_obj, manny.base_costume)
            manny:play_chore(msb_end_crouch, manny.base_costume)
            manny:wait_for_chore(msb_end_crouch, manny.base_costume)
            manny:stop_chore(msb_end_crouch, manny.base_costume)
        else
            manny:stop_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
            manny:play_chore(mcc_thunder_end_crouch, manny.base_costume)
            manny:wait_for_chore(mcc_thunder_end_crouch, manny.base_costume)
            manny:stop_chore(mcc_thunder_end_crouch, manny.base_costume)
        end
        END_CUT_SCENE()
    end
end
th.ladder_bot.use_coffeepot = th.ladder_bot.use
th.ladder_top = Object:create(th, "/thtx002/top", 0.495107, -0.087508596, 2.536, { range = 1.2 })
th.ladder_top.use_pnt_x = 0.495
th.ladder_top.use_pnt_y = -0.064999998
th.ladder_top.use_pnt_z = 2.2
th.ladder_top.use_rot_x = 0
th.ladder_top.use_rot_y = 269.82401
th.ladder_top.use_rot_z = 0
th.ladder_top.lookAt = function(arg1) -- line 1149
    system.default_response("ladder")
end
th.ladder_top.pickUp = th.ladder_bot.pickUp
th.ladder_top.use = function(arg1) -- line 1155
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(th.ladder_bot)
        manny:play_chore(msb_reach_low, manny.base_costume)
        manny:play_chore(msb_lf_hand_on_obj, manny.base_costume)
        sleep_for(1000)
        th:current_setup(th_stgws)
        manny:stop_chore(msb_reach_low, manny.base_costume)
        manny:put_at_object(th.ladder_bot)
        manny:head_look_at(th.ladder_top)
        manny:wait_for_chore(msb_lf_hand_on_obj, manny.base_costume)
        manny:stop_chore(msb_lf_hand_on_obj, manny.base_costume)
        manny:play_chore(msb_lf_hand_off_obj, manny.base_costume)
        manny:wait_for_chore(msb_lf_hand_off_obj, manny.base_costume)
        manny:stop_chore(msb_lf_hand_off_obj, manny.base_costume)
        END_CUT_SCENE()
    end
end
th.ladder_top.use_coffeepot = th.ladder_top.use
th.coffee_pot = Object:create(th, "/thtx086/pot of coffee", -0.30750701, -2.2220199, 0.34999999, { range = 0.60000002 })
th.coffee_pot.string_name = "coffeepot"
th.coffee_pot.use_pnt_x = -0.44588
th.coffee_pot.use_pnt_y = -1.9993
th.coffee_pot.use_pnt_z = 0
th.coffee_pot.use_rot_x = 0
th.coffee_pot.use_rot_y = 225.011
th.coffee_pot.use_rot_z = 0
th.coffee_pot.wav = "getBotl.wav"
th.coffee_pot.can_put_away = FALSE
th.coffee_pot.lookAt = function(arg1) -- line 1191
    arg1.seen = TRUE
    manny:say_line("/thma087/")
end
th.coffee_pot.pickUp = function(arg1) -- line 1196
    local local1
    box_on("coffee_box")
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        if manny.fancy then
            local1 = "mcc_coffee.cos"
        else
            local1 = "msb_coffee.cos"
        end
        manny:push_costume(local1)
        th.coffeepot_actor:set_visibility(FALSE)
        manny:play_chore(msb_coffee_get_coffee, local1)
        sleep_for(1000)
        start_sfx("thPotUp.WAV")
        manny:wait_for_chore(msb_coffee_get_coffee, local1)
        manny:pop_costume()
        manny:setrot(0, 299.58401, 0)
        manny:generic_pickup(arg1)
        manny:walkto(-0.25503299, -1.8238699, 0)
        if not arg1.seen then
            look_at_item_in_hand()
        end
        manny:wait_for_actor()
        END_CUT_SCENE()
        box_off("grinder_box1")
        box_off("grinder_box2")
    end
    box_off("coffee_box")
    th.coffee_rack:make_touchable()
end
th.coffee_pot.use = function(arg1) -- line 1229
    if manny.is_holding == th.coffee_pot then
        manny:say_line("/thma088/")
    else
        th.coffee_pot:pickUp()
    end
end
th.coffee_pot.use_grinder = function(arg1) -- line 1237
    if th.grinder.has_bone or th.grinder.has_snow then
        manny:say_line("/thma089/")
    else
        th.grinder:default_response()
    end
end
th.coffee_pot.default_response = th.coffee_pot.use
th.coffee_pot.put_away = function(arg1) -- line 1247
    manny:say_line("/thma090/")
    return FALSE
end
th.coffee_rack = Object:create(th, "/thtx091/burners", -0.30750701, -2.2220199, 0.34999999, { range = 0.60000002 })
th.coffee_rack.use_pnt_x = -0.44588
th.coffee_rack.use_pnt_y = -1.9993
th.coffee_rack.use_pnt_z = 0
th.coffee_rack.use_rot_x = 0
th.coffee_rack.use_rot_y = 180.32401
th.coffee_rack.use_rot_z = 0
th.coffee_rack:make_untouchable()
th.coffee_rack.lookAt = function(arg1) -- line 1264
    manny:say_line("/thma092/")
end
th.coffee_rack.pickUp = th.coffee_rack.lookAt
th.coffee_rack.use_coffeepot = function(arg1) -- line 1270
    local local1
    box_on("coffee_box")
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny.is_holding = nil
        if manny.fancy then
            local1 = "mcc_coffee.cos"
            manny:stop_chore(mcc_thunder_hold, manny.base_costume)
            manny:stop_chore(mcc_thunder_activate_coffeepot, manny.base_costume)
        else
            local1 = "msb_coffee.cos"
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
        end
        manny:push_costume(local1)
        manny:setrot(0, 225, 0)
        manny:play_chore(msb_coffee_pot_to_burner, local1)
        sleep_for(900)
        start_sfx("thPotDn.WAV")
        manny:wait_for_chore(msb_coffee_pot_to_burner, local1)
        th.coffeepot_actor:default()
        manny:pop_costume()
        manny:setrot(0, 299.58401, 0)
        manny:walkto(-0.25503299, -1.8238699, 0)
        manny:wait_for_actor()
        END_CUT_SCENE()
        th.coffee_pot:free()
        th.coffee_pot:make_touchable()
        arg1:make_untouchable()
        box_on("grinder_box1")
        box_on("grinder_box2")
    end
    box_off("coffee_box")
end
th.dressing_room = Object:create(th, "/thtx093/dressing room", 1.35489, -1.1065201, 0.199967, { range = 0.89999998 })
th.dressing_room.use_pnt_x = 0.894467
th.dressing_room.use_pnt_y = -1.0750999
th.dressing_room.use_pnt_z = -0.28999999
th.dressing_room.use_rot_x = 0
th.dressing_room.use_rot_y = 275.81699
th.dressing_room.use_rot_z = 0
th.dressing_room.out_pnt_x = 1.3099999
th.dressing_room.out_pnt_y = -1.155
th.dressing_room.out_pnt_z = -0.28999999
th.dressing_room.out_rot_x = 0
th.dressing_room.out_rot_y = 248.313
th.dressing_room.out_rot_z = 0
th.dressing_room.lookAt = function(arg1) -- line 1324
    manny:say_line("/thma094/")
end
th.dressing_room.walkOut = function(arg1) -- line 1328
    start_script(th.crash_dressing_room)
end
th.thunderboy1 = Object:create(th, "/thtx095/Thunder Boy", 0.79973602, -0.57853103, 0.44, { range = 0.80000001 })
th.thunderboy1.use_pnt_x = 0.51973599
th.thunderboy1.use_pnt_y = -0.51853102
th.thunderboy1.use_pnt_z = 0
th.thunderboy1.use_rot_x = 0
th.thunderboy1.use_rot_y = -122.034
th.thunderboy1.use_rot_z = 0
th.thunderboy1.person = TRUE
th.thunderboy1.lookAt = function(arg1) -- line 1344
    START_CUT_SCENE()
    manny:say_line("/thma096/")
    manny:wait_for_message()
    thunder_boy_2:say_line("/tht2097/")
    thunder_boy_2:wait_for_message()
    END_CUT_SCENE()
end
th.thunderboy1.pickUp = function(arg1) -- line 1353
    manny:say_line("/thma098/")
end
th.thunderboy1.use = function(arg1) -- line 1357
    if not th.mocked then
        START_CUT_SCENE()
        manny:say_line("/thma099/")
        wait_for_message()
        END_CUT_SCENE()
    end
    start_script(th.back_off)
end
th.thunderboy1.use_coffeepot = function(arg1) -- line 1367
    start_script(th.serve_coffee)
end
th.thunderboy2 = Object:create(th, "/thtx100/Thunder Boy", 0.672732, -0.18703701, 0.456, { range = 0.80000001 })
th.thunderboy2.use_pnt_x = 0.51973599
th.thunderboy2.use_pnt_y = -0.51853102
th.thunderboy2.use_pnt_z = 0
th.thunderboy2.use_rot_x = 0
th.thunderboy2.use_rot_y = -122.034
th.thunderboy2.use_rot_z = 0
th.thunderboy2.parent = th.thunderboy1
th.thunderboys_from_above = Object:create(th, "/thtx101/Thunder Boys", 0.69005603, -0.58999997, 2.1800001, { range = 0.60000002 })
th.thunderboys_from_above.use_pnt_x = 0.477274
th.thunderboys_from_above.use_pnt_y = -0.1777813
th.thunderboys_from_above.use_pnt_z = 2.2
th.thunderboys_from_above.use_rot_x = 0
th.thunderboys_from_above.use_rot_y = 171.567
th.thunderboys_from_above.use_rot_z = 0
th.thunderboys_from_above.person = TRUE
th.thunderboys_from_above.lookAt = function(arg1) -- line 1394
    START_CUT_SCENE()
    manny:say_line("/thma102/")
    manny:wait_for_message()
    manny:say_line("/thma103/")
    END_CUT_SCENE()
end
th.thunderboys_from_above.use = function(arg1) -- line 1403
    START_CUT_SCENE()
    manny:say_line("/thma104/")
    manny:wait_for_message()
    thunder_boy_1:say_line("/tht1105/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2106/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2107/")
    END_CUT_SCENE()
end
th.thunderboys_from_above.use_grinder = function(arg1) -- line 1415
    local local1
    if th.grinder.has_bone or th.grinder.has_snow then
        local1 = TRUE
    end
    th.grinder:use()
    if local1 then
        START_CUT_SCENE()
        if not th.talked_dandruff then
            th.talked_dandruff = TRUE
            thunder_boy_1:say_line("/tht1108/")
            thunder_boy_1:wait_for_message()
            thunder_boy_2:say_line("/tht2109/")
            thunder_boy_2:wait_for_message()
            thunder_boy_1:say_line("/tht1110/")
            thunder_boy_1:wait_for_message()
        else
            thunder_boy_1:say_line("/tht1111/")
            thunder_boy_1:wait_for_message()
            thunder_boy_2:say_line("/tht2112/")
            thunder_boy_2:wait_for_message()
            thunder_boy_1:say_line("/tht1113/")
            thunder_boy_1:wait_for_message()
        end
        END_CUT_SCENE()
    end
end
th.thunderboys_from_above.use_coffeepot = function(arg1) -- line 1446
    if manny:walkto_object(arg1) then
        start_script(th.burn_thunderboy_burn)
    end
end
th.te_door = Object:create(th, "/thtx114/basement", -0.890948, -1.26624, 0.13, { range = 0.60000002 })
th.te_door.use_pnt_x = -0.53868401
th.te_door.use_pnt_y = -1.2299401
th.te_door.use_pnt_z = 0
th.te_door.use_rot_x = 0
th.te_door.use_rot_y = 78.479599
th.te_door.use_rot_z = 0
th.te_door.out_pnt_x = -0.53868401
th.te_door.out_pnt_y = -1.2299401
th.te_door.out_pnt_z = 0
th.te_door.out_rot_x = 0
th.te_door.out_rot_y = 78.479599
th.te_door.out_rot_z = 0
th.te_door.walkOut = function(arg1) -- line 1473
    local local1
    if manny.is_holding == th.coffee_pot then
        manny:say_line("/thma115/")
    else
        START_CUT_SCENE()
        th:climb_out()
        te:switch_to_set()
        manny:put_in_set(te)
        local1 = te.th_ladder.base
        manny:setpos(local1.use_pnt_x, local1.use_pnt_y, local1.use_pnt_z)
        manny:push_costume(manny.ladder_costume)
        manny:play_chore(ma_ladder_generic_jump_off, manny.ladder_costume)
        manny:wait_for_chore(ma_ladder_generic_jump_off, manny.ladder_costume)
        manny:pop_costume()
        manny:walkto(-4.9533801, -0.384285, 0, 0, 284.59399, 0)
        END_CUT_SCENE()
    end
end
th.te_door.lookAt = function(arg1) -- line 1494
    manny:say_line("/thma116/")
end
th.te_door.use = th.te_door.walkOut

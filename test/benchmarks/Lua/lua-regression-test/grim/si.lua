CheckFirstTime("si.lua")
si = Set:create("si.set", "Scrimshaw Interior", { si_ladms = 0, si_ladms2 = 0, si_frgms = 1, overhead = 2 })
si.naranja_out = FALSE
si.drill_slow_count = 0
si.gossip_count = 0
dofile("naranja.lua")
dofile("toto.lua")
dofile("mc_in_si.lua")
dofile("frg_door.lua")
dofile("toto_phone.lua")
dofile("toto_photo.lua")
drill_slows = 0
yell_to_drill = 1
drill_loop = 2
head_turn = 3
head_hold = 4
hdhold_to_drill = 5
stop_chktt = 6
chktt_close = 7
chktt_away = 8
chktt_pause = 9
chktt_to_drill = 10
look_fridge = 11
look_to_drill = 12
toto.drilling_chore = nil
DRILL_NORMAL = 0
DRILL_LOADED = 1
DRILL_STOPPED = 2
si.drill_state = nil
si.drill_loop_vol = 80
si.gen_loop_vol = 25
si.refrig_loop_vol = 80
si.takeout_scythe = function() -- line 48
    local local1 = manny:getpos()
    if in_year_four then
        system.default_response("shed light")
    else
        START_CUT_SCENE("no head")
        manny:stop_takeout_chores()
        manny:play_chore(mc_takeout_empty, "mc.cos")
        manny:wait_for_chore(mc_takeout_empty, "mc.cos")
        manny:stop_chore(mc_takeout_empty, "mc.cos")
        si:current_setup(si_ladms)
        if local1.y <= -0.68000001 then
            manny:walkto(-0.10347, -1.55514, 0, 0, -13, 0)
        elseif not si.naranja_out then
            manny:walkto(0.052437998, -0.520679, 0, 0, 230.293, 0)
        else
            toto:set_collision_mode(COLLISION_OFF)
            manny:walkto(0.052437998, -0.520679, 0, 0, -238.293, 0)
        end
        manny:push_costume("mc_scythe.cos")
        manny:play_chore(ma_scythe_takeout_scythe)
        manny:wait_for_chore(ma_scythe_takeout_scythe)
        manny:pop_costume()
        manny:play_chore_looping(ms_hold_scythe, manny.base_costume)
        toto:say_line("/sito071/")
        toto:wait_for_message()
        manny:stop_chore(ms_hold_scythe, manny.base_costume)
        manny:push_costume("mc_scythe.cos")
        manny:play_chore(ma_scythe_putaway_scythe)
        manny:wait_for_chore(ma_scythe_putaway_scythe)
        manny:pop_costume()
        if si.naranja_out then
            toto:set_collision_mode(COLLISION_SPHERE)
            SetActorCollisionScale(toto.hActor, 0.30000001)
            manny:set_collision_mode(COLLISION_SPHERE)
            SetActorCollisionScale(manny.hActor, 0.34999999)
        end
        END_CUT_SCENE()
    end
end
si.watch_totos_head = function() -- line 92
    while system.currentSet == si do
        stop_script(manny.head_follow_mesh)
        repeat
            break_here()
        until hot_object == si.toto_obj
        start_script(manny.head_follow_mesh, manny, toto, 7)
        repeat
            break_here()
        until hot_object ~= si.toto_obj
    end
end
si.drilling_sfx = function() -- line 105
    local local1 = si.drill_state
    while 1 do
        if si.drill_state == DRILL_NORMAL then
            single_start_sfx("siDrNlOn.wav")
            sleep_for(750)
            single_start_sfx("siDrNlLp.imu", nil, 0)
            fade_sfx("siDrNlLp.imu", 250, si.drill_loop_vol)
        elseif si.drill_state == DRILL_LOADED then
            single_start_sfx("siDrLdOn.wav")
            fade_sfx("siDrNlLp.imu", 300, 0)
            sleep_for(2000)
            single_start_sfx("siDrLdLp.imu", nil, 0)
            fade_sfx("siDrLdLp.imu", 400, si.drill_loop_vol)
        elseif si.drill_state == DRILL_STOPPED then
            if local1 == DRILL_NORMAL then
                single_start_sfx("siDrNlOf.wav")
                fade_sfx("siDrNlLp.imu", 250, 0)
            else
                single_start_sfx("siDrLdOf.wav")
                fade_sfx("siDrLdLp.imu", 250, 0)
            end
        end
        local1 = si.drill_state
        while si.drill_state == local1 do
            break_here()
        end
        PrintDebug("drill state change")
    end
end
si.toto_controller = function() -- line 144
    local local1
    local local2
    local local3
    while not si.motor_running and si.naranja_out == FALSE do
        if find_script(si.booze.use_turkey_baster) == FALSE then
            if rnd() then
                si.drill_state = DRILL_NORMAL
                local1 = rndint(3, 5)
                if rnd(7) and not naranja:is_choring(naranja_look_up) and not naranja:is_choring(naranja_look_around) then
                    if rnd() then
                        naranja:play_chore(naranja_look_around)
                    else
                        naranja:play_chore(naranja_look_up)
                    end
                end
                repeat
                    if not naranja:is_choring(naranja_arm_drilled) then
                        naranja:play_chore_looping(naranja_arm_drilled)
                        naranja:stop_chore(naranja_arm_no_drill)
                    end
                    toto:play_chore(toto_drill_loop)
                    toto:wait_for_chore(toto_drill_loop)
                    if si.motor_running then
                        local1 = 0
                    else
                        local1 = local1 - 1
                    end
                until local1 <= 0
                naranja:wait_for_chore(naranja_look_up)
                naranja:wait_for_chore(naranja_look_around)
                naranja:play_chore(naranja_watch_toto)
                local2 = FALSE
            elseif not local2 then
                si.drill_state = DRILL_STOPPED
                naranja:stop_chore(naranja_arm_drilled)
                naranja:play_chore_looping(naranja_arm_no_drill)
                if not cut_scene_level then
                    local3 = start_script(si.naranja_drink)
                end
                toto:play_chore(stop_chktt)
                toto:wait_for_chore(stop_chktt)
                if not si.motor_running then
                    toto:play_chore(chktt_close)
                    toto:wait_for_chore(chktt_close)
                    local1 = rnd(1.5, 3)
                    repeat
                        sleep_for(1000)
                        if si.motor_running then
                            local1 = 0
                        else
                            local1 = local1 - 1
                        end
                        break_here()
                    until local1 <= 0
                    wait_for_script(local3)
                    toto:play_chore(chktt_away)
                    toto:wait_for_chore(chktt_away)
                end
                toto:play_chore(chktt_to_drill)
                toto:wait_for_chore(chktt_to_drill)
                local2 = TRUE
            end
        else
            break_here()
        end
    end
    if si.naranja_out then
        if cutSceneLevel < 1 then
            START_CUT_SCENE()
        end
        manny:head_follow_mesh(toto, 6, TRUE)
        start_script(manny.walkto, manny, si.toto_obj)
        music_state:set_state(stateSI_SLEEP)
        start_script(si.passout_lines1)
        si:current_setup(si_ladms)
        naranja:play_chore(naranja_passout)
        toto:stop_chore(toto_yell_to_drill)
        si.drill_state = DRILL_STOPPED
        toto:play_chore(toto_na_pso)
        naranja:wait_for_chore(naranja_passout)
        toto:wait_for_chore(toto_na_pso)
        stop_script(si.drilling_sfx)
        wait_for_script(si.passout_lines1)
        si:current_setup(si_frgms)
        END_CUT_SCENE()
        stop_script(manny.head_follow_mesh)
        manny:head_look_at(nil, 360)
        manny:default("cafe")
        start_script(cut_scene.passout)
    end
end
si.passout_lines1 = function() -- line 244
    toto:say_line("/psots01a/")
    toto:wait_for_message()
    toto:say_line("/psots01b/")
    toto:wait_for_message()
    toto:say_line("/psots02a/")
    toto:wait_for_message()
    toto:say_line("/psots02b/")
    toto:wait_for_message()
    toto:say_line("/psots03a/")
    toto:wait_for_message()
    toto:say_line("/psots03b/")
    toto:wait_for_message()
    toto:say_line("/psots03c/")
    toto:wait_for_message()
end
si.toto_talk_to_velasco = function() -- line 263
    START_CUT_SCENE()
    si.overheard_passout = TRUE
    toto:say_line("/psots05a/")
    toto:wait_for_message()
    si:current_setup(si_ladms)
    toto:say_line("/psots05b/")
    toto:wait_for_message()
    sleep_for(1000)
    toto:say_line("/psots06a/")
    toto:head_look_at(si.naranja_obj)
    toto:wait_for_message()
    toto:head_look_at(nil)
    toto:say_line("/psots06b/")
    toto:wait_for_message()
    toto:say_line("/psots06c/")
    toto:wait_for_message()
    toto:say_line("/psots06d/")
    toto:wait_for_message()
    toto:head_look_at(nil)
    manny:head_look_at(nil)
    manny:stop_chore()
    si:force_camerachange()
    END_CUT_SCENE()
end
si.naranja_drink = function(arg1) -- line 289
    if not manny:find_sector_name("bottle") then
        MakeSectorActive("bottle", FALSE)
        MakeSectorActive("bottle1", FALSE)
        if arg1 then
            si.naranja_pain = TRUE
            naranja:stop_chore(naranja_arm_drilled)
            naranja:play_chore_looping(naranja_arm_no_drill)
            naranja:play_chore(naranja_pain_to_drink)
            naranja:wait_for_chore()
            si.booze_actor:play_chore(1)
            si.booze:make_untouchable()
            naranja:play_chore(naranja_pain_drink)
            naranja:wait_for_chore()
            naranja:play_chore()
            si.booze_actor:play_chore(0)
            si.booze:make_touchable()
            naranja:play_chore(naranja_from_pain_drink)
            naranja:wait_for_chore()
            si.naranja_pain = FALSE
        else
            naranja:play_chore(naranja_to_grab_bz)
            naranja:wait_for_chore()
            si.booze_actor:play_chore(1)
            si.booze:make_untouchable()
            naranja:play_chore(naranja_got_booze)
            naranja:wait_for_chore()
            naranja:play_chore(naranja_drink_booze)
            naranja:wait_for_chore()
            naranja:play_chore(naranja_stop_drink)
            naranja:wait_for_chore()
            si.booze_actor:play_chore(0)
            si.booze:make_touchable()
            naranja:play_chore(naranja_bz_down)
            naranja:wait_for_chore()
            if si.booze.dosed then
                si.naranja_out = TRUE
                si.lettuce_crisper:make_untouchable()
            end
        end
        MakeSectorActive("bottle", TRUE)
        MakeSectorActive("bottle1", TRUE)
    end
end
toto.one_snore = function() -- line 337
    toto:say_line(pick_one_of({ "/sito008/", "/sito009/", "/sito010/" }), { background = TRUE, volume = 75, skip_log = TRUE })
end
toto.one_mumble = function() -- line 341
    local local1 = { "/sito012/", "/sito013/", "/sito014/", "/sito015/", "/sito016/", "/sito017/", "/sito018/", "/sito019/", "/sito020/", "/sito021/", "/sito022/" }
    if tims_changes_his_mind then
        toto:say_line("/sito011/")
    else
        toto:say_line(pick_one_of(local1), { background = TRUE, volume = 127, skip_log = TRUE })
    end
end
si.toto_snoring = function() -- line 352
    toto:set_speech_mode(MODE_BACKGROUND)
    while 1 do
        toto.one_snore()
        toto:wait_for_message()
        sleep_for(500)
        toto.one_snore()
        toto:wait_for_message()
        sleep_for(500)
        toto.one_snore()
        toto:wait_for_message()
        sleep_for(1000)
        toto:one_mumble()
        toto:wait_for_message()
        sleep_for(1000)
    end
end
si.get_photofinish = function() -- line 370
    START_CUT_SCENE()
    cur_puzzle_state[31] = TRUE
    toto:set_collision_mode(COLLISION_OFF)
    manny:walkto_object(si.toto_obj)
    toto:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(toto.hActor, 0.3)
    stop_script(si.toto_on_phone)
    toto:say_line("/sito003/")
    toto:wait_for_message()
    toto:head_look_at_manny()
    manny:say_line("/sima023/")
    manny:wait_for_message()
    toto:say_line("/sito024/")
    put_away_held_item()
    toto:wait_for_message()
    toto:say_line("/sito025/")
    toto:wait_for_message()
    toto:head_look_at(nil)
    toto:play_chore(toto_phone_hang_up)
    toto:wait_for_chore()
    si.phone_actor:setpos(-0.418431, -0.630621, 0.495)
    si.phone_actor:setrot(180, 0, 0)
    si.phone_actor:put_in_set(si)
    si.phone_actor:play_chore(0)
    toto:push_costume("toto_photo.cos")
    toto:stop_chore(toto_phone_hang_up, "toto_phone.cos")
    toto:play_chore(toto_photo_open_binder)
    sleep_for(1139)
    binder:setpos(0, 0, 100)
    toto:wait_for_chore()
    toto:say_line("/sito026a/")
    toto:wait_for_message()
    toto:say_line("/sito026b/")
    sleep_for(6500)
    toto:stop_chore(toto_photo_open_binder)
    toto:play_chore(toto_photo_give_photo)
    toto:wait_for_message()
    toto:wait_for_chore()
    manny:say_line("/sima027/")
    manny:wait_for_message()
    toto:say_line("/sito028a/")
    toto:wait_for_message()
    toto:say_line("/sito028b/")
    toto:wait_for_message()
    toto:say_line("/sito028c/")
    manny:play_chore(mc_hand_on_obj, manny.base_costume)
    manny:wait_for_chore()
    toto:stop_chore(toto_photo_give_photo)
    toto:play_chore(toto_photo_done_giving)
    manny:play_chore(mc_hand_off_obj, manny.base_costume)
    si.photofinish:get()
    manny:play_chore_looping(mc_activate_photofinsh, manny.base_costume)
    manny.is_holding = si.photofinish
    manny.hold_chore = mc_activate_photofinish
    manny:play_chore_looping(ms_hold, manny.base_costume)
    sleep_for(871)
    binder:setpos(-0.354, -0.781075, 0.2818)
    toto:wait_for_chore()
    manny:wait_for_chore()
    manny:clear_hands()
    toto:wait_for_message()
    manny:say_line("/vima040b/")
    toto:wait_for_chore()
    toto:pop_costume()
    toto:play_chore(toto_phone_grab_phone)
    sleep_for(603)
    si.phone_actor:setpos(0, 0, 100)
    toto:wait_for_chore()
    sleep_for(1000)
    cc.anchor_paper:free()
    END_CUT_SCENE()
    start_script(si.toto_on_phone)
end
si.toto_gossip = { }
si.toto_gossip.sits035 = 0.0099999998
si.toto_gossip.sits040 = 0.1
si.toto_gossip.sits041 = 0.30000001
si.toto_gossip.sits042 = 0.1
si.toto_gossip.sits043 = 0.0099999998
si.toto_gossip.sits044 = 0.1
si.toto_gossip.sits045 = 0.1
si.toto_gossip.sits050 = 0.1
si.toto_gossip.sits051 = 0.0099999998
si.toto_gossip.sits052 = 0.0099999998
si.toto_gossip.sits055 = 0.16
si.interrupt_toto = function(arg1) -- line 474
    line = rndint(2)
    if in_year_four then
        si.sneak_around()
    elseif si.naranja_out then
        START_CUT_SCENE()
        if not arg1 then
            manny:walkto_object(si.toto_obj)
        end
        stop_script(si.toto_on_phone)
        toto:say_line("/sito003/")
        toto:wait_for_message()
        END_CUT_SCENE()
        if arg1 then
            START_CUT_SCENE()
            toto:play_chore(toto_phone_turn_point)
            if line == 0 then
                toto:say_line("/sito004/")
            elseif line == 1 then
                toto:say_line("/sito005/")
            elseif line == 2 then
                toto:say_line("/sito006/")
            end
            toto:wait_for_message()
            start_script(si.toto_on_phone)
            toto:stop_chore(toto_phone_turn_point)
            toto:play_chore(toto_phone_back_to_phone)
            toto:wait_for_chore()
            toto:stop_chore(toto_phone_back_to_phone)
            END_CUT_SCENE()
        end
    else
        START_CUT_SCENE()
        toto:head_look_at_manny()
        toto:wait_for_message()
        si.toto_obj:use(TRUE)
        END_CUT_SCENE()
    end
end
si.toto_on_phone = function() -- line 520
    toto:set_speech_mode(MODE_BACKGROUND)
    while system.currentSet == si do
        toto:wait_for_message()
        if not si.toto_phoning then
            si.toto_phoning = TRUE
            toto:play_chore(toto_phone_grab_phone)
        elseif rnd() then
            toto:push_chore(toto_phone_scratch)
        elseif rnd() then
            toto:push_chore(toto_phone_wave)
        end
        if not si.overheard_passout then
            si.toto_talk_to_velasco()
        end
        si.gossip_count = si.gossip_count + 1
        if si.gossip_count == 1 then
            toto:say_line("/sito030/")
        elseif si.gossip_count == 2 then
            toto:say_line("/sito031/")
        elseif si.gossip_count == 3 then
            toto:say_line("/sito032/")
        elseif si.gossip_count == 4 then
            toto:say_line("/sito033/")
        elseif si.gossip_count == 5 then
            toto:say_line("/sito034/")
        elseif si.gossip_count == 6 then
            toto:say_line("/sito035/")
        elseif si.gossip_count == 7 then
            toto:say_line("/sito036/")
        elseif si.gossip_count == 8 then
            toto:say_line("/sito037/")
        elseif si.gossip_count == 9 then
            toto:say_line("/sito038/")
        elseif si.gossip_count == 10 then
            toto:say_line("/sito039/")
        elseif si.gossip_count == 11 then
            toto:say_line("/sito040/")
        elseif si.gossip_count == 12 then
            toto:say_line("/sito041/")
        elseif si.gossip_count == 13 then
            toto:say_line("/sito042/")
        elseif si.gossip_count == 14 then
            toto:say_line("/sito043/")
        elseif si.gossip_count == 15 then
            toto:say_line("/sito044/")
        elseif si.gossip_count == 16 then
            toto:say_line("/sito045/")
        elseif si.gossip_count == 17 then
            toto:say_line("/sito046/")
        elseif si.gossip_count == 18 then
            toto:say_line("/sito047/")
        elseif si.gossip_count == 19 then
            toto:say_line("/sito048/")
        elseif si.gossip_count == 20 then
            toto:say_line("/sito049/")
        elseif si.gossip_count == 21 then
            toto:say_line("/sito050/")
        elseif si.gossip_count == 22 then
            toto:say_line("/sito051/")
        elseif si.gossip_count == 23 then
            toto:say_line("/sito052/")
        elseif si.gossip_count == 24 then
            toto:say_line("/sito053/")
        elseif si.gossip_count == 25 then
            toto:say_line("/sito054/")
        elseif si.gossip_count == 26 then
            toto:say_line("/sito055/")
        elseif si.gossip_count == 27 then
            toto:say_line("/sito056/")
        elseif si.gossip_count == 28 then
            toto:say_line("/sito057/")
        end
        toto:wait_for_message()
        toto:wait_for_chore()
        sleep_for(3000 * random() + 2000)
    end
end
si.naranja_snoring = function() -- line 608
    naranja:set_speech_mode(MODE_BACKGROUND)
    while system.currentSet == si do
        sleep_for(1000 + random() * 1000)
        if not IsMessageGoing() then
            naranja:say_line("/sina058/")
            naranja:wait_for_message()
        end
        sleep_for(1000 + random() * 1000)
        if not IsMessageGoing() then
            naranja:say_line("/sina059/")
            naranja:wait_for_message()
        end
    end
end
si.slow_drill = function(arg1) -- line 625
    while find_script(si.toto_controller) do
        break_here()
    end
    si.drill_state = DRILL_LOADED
    start_script(si.naranja_drink, TRUE)
    toto:play_chore(toto_drill_slows)
    sleep_for(1500)
    naranja:say_line("/sina060/")
    naranja:wait_for_message()
    toto:wait_for_chore(toto_drill_slows)
    si.drill_state = DRILL_STOPPED
    local local1 = manny:find_sector_name("busted_box")
    if local1 then
        START_CUT_SCENE()
        manny:head_look_at(toto)
        if manny:find_sector_name("fridge_box") then
            start_script(manny.walkto, manny, 1.17378, -1.01255, 0, 0, 415, 0)
        end
        si.drill_slow_count = si.drill_slow_count + 1
        if si.drill_slow_count == 1 then
            toto:say_line("/sito061a/")
            toto:play_chore_looping(toto_yell_loop)
            toto:wait_for_message()
            toto:say_line("/sito061b/")
            toto:wait_for_message()
            toto:say_line("/sito061c/")
            toto:wait_for_message()
        elseif si.drill_slow_count == 2 then
            toto:say_line("/sito062a/")
            toto:wait_for_message()
            toto:say_line("/sito062b/")
            toto:play_chore_looping(toto_yell_loop)
        elseif si.drill_slow_count == 3 then
            toto:say_line("/sito063a/")
            toto:wait_for_message()
            toto:say_line("/sito063b/")
            toto:play_chore_looping(toto_yell_loop)
        else
            toto:say_line("/sito064/")
            toto:play_chore_looping(toto_yell_loop)
        end
        toto:wait_for_message()
        manny:head_look_at(nil)
        MakeSectorActive("no_fridge", TRUE)
        MakeSectorActive("floor_1", TRUE)
        MakeSectorActive("xit_frg_box", TRUE)
        MakeSectorActive("xit_box", TRUE)
        si:current_setup(si_frgms)
        if manny.is_holding then
            put_away_held_item()
        end
        if si.lettuce_crisper:is_open() then
            manny:walkto(1.17155, -1.07449, 0, 0, 347.936, 0)
            manny:wait_for_actor()
            manny:walkto_object(si.lettuce_crisper)
            si.lettuce_crisper:close()
            start_script(manny.walkto_object, manny, si.fridge)
            local local2 = fridge_door:getrot()
            repeat
                local2.y = local2.y + PerSecond(25)
                fridge_door:setrot(0, local2.y, 0)
                break_here()
            until local2.y >= 261
        elseif not si.fridge.door_closed then
            manny:walkto(1.17155, -1.07449, 0, 0, 347.936, 0)
            manny:wait_for_actor()
            manny:walkto_object(si.fridge)
        end
        while not si.fridge.door_closed do
            break_here()
        end
        fridge_door:play_chore(1)
        fridge_door:setrot(0, 179.979, 0)
        si.fridge:close()
        toto:set_chore_looping(toto_yell_loop, FALSE)
        toto:wait_for_chore(toto_yell_loop)
        toto:play_chore(toto_look_to_drill)
        toto:wait_for_chore(toto_look_to_drill)
        fade_sfx("siRefrig.imu", 400, 0)
        fade_sfx("siGenSlw.imu", 400, 0)
        start_sfx("siGenUp.wav", nil, 40)
        sleep_for(600)
        start_sfx("siGenRun.imu", nil, 0)
        fade_sfx("siGenRun.imu", 200, si.gen_loop_vol)
        END_CUT_SCENE()
    else
        si.guys_distracted = TRUE
        toto:say_line("/sito065/")
        toto:play_chore_looping(toto_look_fridge)
        toto:wait_for_message()
        sleep_for(5000)
        start_sfx("siRfSlam.wav")
        si.guys_distracted = FALSE
        if not si.booze.dosed then
            START_CUT_SCENE()
            if local1 then
                si:current_setup(si_frgms)
            end
            fridge_door:play_chore(1)
            si.lettuce_crisper.interest_actor:complete_chore(1)
            fridge_door:setrot(0, 179.979, 0)
            si.fridge:close()
            si.fridge.parent.close(si.fridge)
            si.lettuce_crisper.parent.close(si.lettuce_crisper)
            fade_sfx("siRefrig.imu", 400, 0)
            fade_sfx("siGenSlw.imu", 400, 0)
            start_sfx("siGenUp.wav", nil, 40)
            sleep_for(600)
            start_sfx("siGenRun.imu", nil, 0)
            fade_sfx("siGenRun.imu", 200, si.gen_loop_vol)
            if local1 then
                si:current_setup(si_ladms)
            end
            si.lettuce_crisper:make_untouchable()
            toto:stop_chore(toto_look_fridge)
            toto:play_chore(toto_yell_to_drill)
            toto:say_line("/sito068/")
            toto:wait_for_message()
            toto:say_line("/sito069/")
            toto:wait_for_message()
            END_CUT_SCENE()
        end
    end
    MakeSectorActive("no_fridge", TRUE)
    MakeSectorActive("floor_1", TRUE)
    MakeSectorActive("xit_frg_box", TRUE)
    MakeSectorActive("xit_box", TRUE)
    si.motor_running = FALSE
    start_script(si.toto_controller)
end
si.fridge_box_watch = function(arg1) -- line 777
    local local1
    local local2 = start_script(si.fridge_close)
    wait_for_script(local2)
    if si.fridge:is_open() then
        si.fridge:close()
    end
end
si.fridge_motor = function(arg1) -- line 786
    start_script(si.fridge_box_watch)
    preload_sfx("siRefrig.imu")
    preload_sfx("siGenDn.wav")
    preload_sfx("siGenUp.wav")
    preload_sfx("siGenSlw.imu")
    sleep_for(10000)
    if si.fridge:is_open() then
        start_sfx("siRefrig.imu", nil, si.refrig_loop_vol)
        si.motor_running = TRUE
        sleep_for(500)
        fade_sfx("siGenRun.imu", 200, 0)
        start_sfx("siGenDn.wav", nil, 40)
        sleep_for(600)
        start_sfx("siGenSlw.imu", nil, 0)
        fade_sfx("siGenSlw.imu", 250, si.gen_loop_vol)
        start_script(si.slow_drill)
    end
end
si.fridge_close = function() -- line 810
    si.fridge:make_untouchable()
    local local1 = fridge_door:getrot()
    repeat
        local1.y = local1.y + PerSecond(15)
        fridge_door:setrot(0, local1.y, 0)
        break_here()
    until manny:find_sector_name("fridge_box") or local1.y >= 224
    while manny:find_sector_name("fridge_box") do
        break_here()
    end
    MakeSectorActive("xit_frg_box", FALSE)
    MakeSectorActive("xit_box", FALSE)
    si.lettuce_crisper:make_untouchable()
    if not si.lettuce_crisper:is_open() then
        repeat
            local1.y = local1.y + PerSecond(25)
            fridge_door:setrot(0, local1.y, 0)
            break_here()
        until local1.y >= 261
        si.fridge.door_closed = TRUE
        fridge_door:play_chore(1)
        fridge_door:setrot(0, 179.979, 0)
    else
        repeat
            local1.y = local1.y + PerSecond(15)
            fridge_door:setrot(0, local1.y, 0)
            break_here()
        until local1.y >= 220
    end
    stop_sound("siRefrig.imu")
end
si.sneak_around = function() -- line 844
    manny:say_line("/sima070/")
end
si.set_up_actors = function(arg1) -- line 848
    toto:set_costume("toto.cos")
    toto:default()
    toto:set_mumble_chore(toto_mumble)
    toto:set_talk_chore(1, toto_stop_talk)
    toto:set_talk_chore(2, toto_a)
    toto:set_talk_chore(3, toto_c)
    toto:set_talk_chore(4, toto_e)
    toto:set_talk_chore(5, toto_f)
    toto:set_talk_chore(6, toto_l)
    toto:set_talk_chore(7, toto_m)
    toto:set_talk_chore(8, toto_o)
    toto:set_talk_chore(9, toto_t)
    toto:set_talk_chore(10, toto_u)
    toto:put_in_set(si)
    if not naranja.hCos then
        naranja.hCos = "naranja.cos"
    end
    naranja:set_costume(naranja.hCos)
    naranja:default()
    naranja:set_mumble_chore(naranja_mumble)
    naranja:set_talk_chore(1, naranja_stop_talk)
    naranja:set_talk_chore(2, naranja_a)
    naranja:set_talk_chore(3, naranja_c)
    naranja:set_talk_chore(4, naranja_e)
    naranja:set_talk_chore(5, naranja_f)
    naranja:set_talk_chore(6, naranja_l)
    naranja:set_talk_chore(7, naranja_m)
    naranja:set_talk_chore(8, naranja_o)
    naranja:set_talk_chore(9, naranja_t)
    naranja:set_talk_chore(10, naranja_u)
    naranja:put_in_set(si)
    if not binder then
        binder = Actor:create(nil, nil, nil, "binder")
    end
    binder:set_costume("binder.cos")
    binder:setpos(-0.354, -0.781075, 0.2818)
    binder:setrot(0, 60, 0)
    binder:put_in_set(si)
    if not si.phone_actor then
        si.phone_actor = Actor:create(nil, nil, nil, "reciever")
    end
    si.phone_actor:set_costume("si_phone.cos")
    si.phone_actor:setpos({ x = -0.355015, y = -0.63749, z = 0.458 })
    si.phone_actor:setrot(0, 0, 0)
    si.phone_actor:put_in_set(si)
    si.phone_actor:play_chore(0)
    if in_year_four then
        si.toto_obj:make_untouchable()
        si.naranja_obj:make_untouchable()
        si.booze:make_untouchable()
        naranja:put_in_set(nil)
        toto:push_costume("to_sleep.cos")
        toto:setpos(1.36707, -0.743324, 0.1034)
        toto:setrot(89, 0, 0)
        toto:play_chore_looping(0)
        toto:set_speech_mode(MODE_BACKGROUND)
        start_script(si.toto_snoring)
    else
        NewObjectState(si_ladms, OBJSTATE_STATE, "si_phone_obj.bm", "si_phone_obj.zbm")
        si.phone:set_object_state("si_phone_obj.cos")
        if not si.naranja_out then
            preload_sfx("tkBstSqt.wav")
            start_sfx("siGenRun.imu", nil, si.gen_loop_vol)
            toto:setpos(0.40958, -0.86168, 0)
            toto:setrot(0, 151.925, 0)
            start_script(si.toto_controller)
            start_script(si.drilling_sfx)
            si.naranja_obj:make_touchable()
            SetActorHead(naranja.hActor, 4, 5, 6, 360, 28, 95)
            PutActorAt(naranja.hActor, 0.14681, -0.69212, -0.05687)
            SetActorRot(naranja.hActor, 25.2101, 0, 0)
            start_script(si.naranja_drinking)
        else
            si.lettuce_crisper:make_untouchable()
            si.booze_actor:play_chore(1)
            si.scrimshaw_apparatus.touchable = TRUE
            si.toto_phoning = FALSE
            toto:set_collision_mode(COLLISION_SPHERE)
            SetActorCollisionScale(toto.hActor, 0.3)
            manny:set_collision_mode(COLLISION_SPHERE)
            SetActorCollisionScale(manny.hActor, 0.35)
            toto:setpos(-0.2773, -0.61543, 0)
            toto:setrot(0, 333.598, 0)
            toto:push_costume("toto_phone.cos")
            SetActorHead(toto.hActor, 4, 5, 6, 360, 28, 95)
            si.toto_obj.obj_x = -0.21633
            si.toto_obj.obj_y = -0.605221
            si.toto_obj.obz_z = 0.47
            si.toto_obj.use_pnt_x = 0.0777695
            si.toto_obj.use_pnt_y = -0.397821
            si.toto_obj.use_pnt_z = 0
            si.toto_obj.use_rot_x = 0
            si.toto_obj.use_rot_y = 121.429
            si.toto_obj.use_rot_z = 0
            si.toto_obj.interest_actor:setpos(-0.21633, -0.605221, 0.47)
            si.toto_obj:make_touchable()
            start_script(si.toto_on_phone)
            si.naranja_obj:make_untouchable()
            si.booze:make_untouchable()
            start_script(si.naranja_snoring)
            naranja:push_costume("na_on_cot.cos")
            naranja:setpos(1.36044, -0.6715, 0.117)
            naranja:setrot(90, 0, 0)
            naranja:complete_chore(1, "na_on_cot.cos")
        end
    end
end
si.enter = function(arg1) -- line 977
    si:set_up_actors()
    si.lettuce_crisper.opened = FALSE
    si.fridge.opened = FALSE
    NewObjectState(si_frgms, OBJSTATE_UNDERLAY, "si_cabinet.bm")
    NewObjectState(si_ladms, OBJSTATE_UNDERLAY, "si_ladms_cab.bm")
    si.cabinet:set_object_state("si_cabinet.cos")
    if in_year_four then
        si.cabinet.opened = FALSE
    end
    if si.cabinet.opened then
        si.cabinet.interest_actor:complete_chore(0)
    else
        si.cabinet.interest_actor:complete_chore(1)
    end
    NewObjectState(si_frgms, OBJSTATE_OVERLAY, "si_drawer.bm", nil, TRUE)
    si.lettuce_crisper:set_object_state("si_drawer.cos")
    if not fridge_door then
        fridge_door = Actor:create(nil, nil, nil, "door")
    end
    fridge_door:set_costume("frg_door.cos")
    fridge_door:put_in_set(si)
    fridge_door:set_softimage_pos(7.475, 2.6598, 6.9895)
    fridge_door:setrot(0, 179.979, 0)
    if not si.booze_actor then
        si.booze_actor = Actor:create(nil, nil, nil, "booze")
    end
    if not in_year_four then
        bot = NewObjectState(si_ladms, OBJSTATE_UNDERLAY, "si_bottle.bm", nil, TRUE)
        NewObjectState(si_frgms, OBJSTATE_UNDERLAY, "si_rfbot.bm")
        SendObjectToFront(bot)
        si.booze_actor:set_costume("nr_bottle.cos")
        si.booze_actor:put_in_set(si)
        si.booze_actor:setrot(0, 160, 0)
        si.booze_actor:setpos(-0.21479, -1.01508, 0.33246)
        si.booze_actor:play_chore(0)
    end
    toto:set_speech_mode(MODE_BACKGROUND)
    naranja:set_speech_mode(MODE_BACKGROUND)
    start_script(si.watch_totos_head)
end
si.exit = function(arg1) -- line 1039
    fridge_door:free()
    naranja:free()
    toto:free()
    binder:free()
    if si.phone_actor then
        si.phone_actor:free()
    end
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(si.naranja_snoring)
    stop_script(si.toto_snoring)
    stop_script(si.toto_on_phone)
    stop_script(si.toto_controller)
    stop_script(si.drilling_sfx)
    stop_script(si.watch_totos_head)
    stop_script(si.fridge_collision_actor_locator)
    stop_sound("siRefrig.imu")
    stop_sound("siGenDn.wav")
    stop_sound("siGenUp.wav")
    stop_sound("siGenSlw.imu")
    stop_sound("siGenRun.imu")
    stop_sound("siDrNlOn.wav")
    stop_sound("siDrNlLp.imu")
    stop_sound("siDrNlOf.wav")
    stop_sound("siDrLdOn.wav")
    stop_sound("siDrLdLp.imu")
    stop_sound("siDrLdOf.wav")
    if si.booze_actor then
        si.booze_actor:free()
    end
end
si.update_music_state = function(arg1) -- line 1072
    if si.naranja_out then
        return stateSI_SLEEP
    else
        return stateSI
    end
end
si.fridge_collision_actor_locator = function() -- line 1080
    local local1, local2, local3
    while 1 do
        local1, local2, local3 = GetActorNodeLocation(fridge_door.hActor, 1)
        fridge_collision_actor:setpos(local1, local2, local3)
        break_here()
    end
end
si.nitrogen = Object:create(si, "/sitx072/liquid nitrogen", 0, 0, 0, { range = 0 })
si.nitrogen.string_name = "nitro"
si.nitrogen.wav = "getBotl.wav"
si.nitrogen.lookAt = function(arg1) -- line 1098
    if manny.shot then
        if manny.healed then
            arg1:use()
        else
            mf:look_at_nitro()
        end
    else
        manny:say_line("/sima073/")
    end
end
si.nitrogen.use = function(arg1) -- line 1110
    if not manny.healed then
        if manny.shot then
            mf.freeze_heart()
        else
            soft_script()
            manny:say_line("/sima074a/")
            manny:wait_for_message()
            manny:say_line("/sima074b/")
        end
    else
        manny:say_line("/sima075/")
    end
end
si.nitrogen.default_response = si.nitrogen.use
si.cabinet = Object:create(si, "/sitx076/cabinet", -0.39372, -1.1983, 0.44999999, { range = 0.60000002 })
si.cabinet.use_pnt_x = -0.15000001
si.cabinet.use_pnt_y = -1.211
si.cabinet.use_pnt_z = 0
si.cabinet.use_rot_x = 0
si.cabinet.use_rot_y = 94.6231
si.cabinet.use_rot_z = 0
si.cabinet.opened = FALSE
si.cabinet.lookAt = function(arg1) -- line 1139
    manny:say_line("/sima077/")
end
si.cabinet.pickUp = function(arg1) -- line 1143
    system.default_response("attached")
end
si.cabinet.use = function(arg1) -- line 1147
    START_CUT_SCENE()
    if arg1.opened then
        manny:walkto_object(arg1)
        si:current_setup(si_frgms)
        manny:play_chore(msb_hand_on_obj, manny.base_costume)
        sleep_for(200)
        arg1:close()
        arg1:play_chore(1)
        manny:wait_for_actor()
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
        manny:wait_for_actor()
        sleep_for(500)
        si:current_setup(si_ladms)
    elseif not in_year_four then
        arg1:open()
        si:current_setup(si_frgms)
        manny:walkto_object(arg1)
        manny:play_chore(mc_reach_cabinet, manny.base_costume)
        sleep_for(500)
        arg1:play_chore(0)
        manny:wait_for_chore(mc_reach_cabinet, manny.base_costume)
        manny:stop_chore(mc_reach_cabinet, manny.base_costume)
        system.default_response("empty")
        manny:wait_for_message()
        if not arg1.seen then
            arg1.seen = TRUE
            if si.naranja_out then
                stop_script(si.toto_on_phone)
                toto:say_line("/sito003/")
                toto:wait_for_message()
            end
            sleep_for(500)
            toto:say_line("/sito080/")
            toto:wait_for_message()
            manny:setrot(0, -42.5, 0, TRUE)
            manny:head_look_at(toto)
            manny:say_line("/sima081/")
            manny:wait_for_message()
            toto:say_line("/sito082/")
            toto:wait_for_message()
            manny:setrot(0, 94.6231, 0, TRUE)
            manny:head_look_at(nil)
            if si.naranja_out then
                si.toto_resume()
            else
                naranja:say_line("/sina083/")
                naranja:wait_for_message()
                toto:say_line("/sito084/")
            end
        end
        si:current_setup(si_ladms)
    else
        manny:walkto(-0.05341, -1.07143, 0, 0, 145.622, 0)
        manny:wait_for_actor()
        manny:push_costume("mm_get_nitro.cos")
        manny:play_chore(0)
        sleep_for(500)
        arg1:play_chore(0)
        manny:wait_for_actor()
        manny:play_chore(1)
        manny:wait_for_actor()
        manny:play_chore(2)
        manny:wait_for_actor()
        manny:pop_costume()
        manny:setpos(-0.03331, -1.30403, 0)
        manny:setrot(0, 10.6225, 0)
        si.nitrogen:get()
        manny.is_holding = si.nitrogen
        manny:play_chore_looping(msb_activate_nitro, "msb.cos")
        manny:play_chore_looping(msb_hold, "msb.cos")
        manny.hold_chore = msb_activate_nitro
        arg1:make_untouchable()
    end
    END_CUT_SCENE()
end
si.lettuce_crisper = Object:create(si, "/sitx085/lettuce crisper", 0.84577203, -0.69888902, 0.1, { range = 0.60000002 })
si.lettuce_crisper.use_pnt_x = 0.98833001
si.lettuce_crisper.use_pnt_y = -0.91671002
si.lettuce_crisper.use_pnt_z = 0
si.lettuce_crisper.use_rot_x = 0
si.lettuce_crisper.use_rot_y = 14.989
si.lettuce_crisper.use_rot_z = 0
si.lettuce_crisper:make_untouchable()
si.lettuce_crisper.lookAt = function(arg1) -- line 1241
    START_CUT_SCENE()
    manny:say_line("/sima086/")
    manny:wait_for_message()
    manny:say_line("/sima087/")
    END_CUT_SCENE()
end
si.lettuce_crisper.open = function(arg1) -- line 1249
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    Object.open(arg1)
    manny:push_costume("mc_in_si.cos")
    manny:play_chore(mc_in_si_open_crspr, "mc_in_si.cos")
    sleep_for(1005)
    arg1:play_chore(0)
    arg1:wait_for_chore()
    manny:wait_for_chore(mc_in_si_open_crspr, "mc_in_si.cos")
    manny:pop_costume()
    manny:backup(1000)
    END_CUT_SCENE()
    if not arg1.been_open then
        START_CUT_SCENE()
        arg1.been_open = TRUE
        system.default_response("empty")
        END_CUT_SCENE()
    end
end
si.lettuce_crisper.close = function(arg1) -- line 1271
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    Object.close(arg1)
    manny:push_costume("mc_in_si.cos")
    manny:play_chore(mc_in_si_close_crspr, "mc_in_si.cos")
    sleep_for(900)
    arg1:play_chore(1)
    arg1:wait_for_chore()
    manny:wait_for_chore(mc_in_si_close_crspr, "mc_in_si.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
si.lettuce_crisper.use = function(arg1) -- line 1288
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
si.lettuce_crisper.pickUp = si.lettuce_crisper.use
si.fridge = Object:create(si, "/sitx088/fridge", 0.91577202, -0.68888903, 0.40000001, { range = 0.60000002 })
si.fridge.use_pnt_x = 1.1401
si.fridge.use_pnt_y = -0.80976999
si.fridge.use_pnt_z = 0
si.fridge.use_rot_x = 0
si.fridge.use_rot_y = 68.274002
si.fridge.use_rot_z = 0
si.fridge.close_x = 1.10946
si.fridge.close_y = -0.85006201
si.fridge.close_z = 0
si.fridge.close_rot_x = 0
si.fridge.close_rot_y = -1015.7
si.fridge.close_rot_z = 0
si.fridge.door_closed = TRUE
si.fridge.lookAt = function(arg1) -- line 1319
    if arg1:is_open() then
        manny:say_line("/sima089/")
    else
        manny:say_line("/sima090/")
    end
end
si.fridge.open = function(arg1) -- line 1327
    if in_year_four then
        si.sneak_around()
    elseif si.naranja_out then
        system.default_response("shed light")
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        si.lettuce_crisper:make_touchable()
        si.fridge.door_closed = FALSE
        arg1.parent.open(arg1)
        manny:push_costume("mc_in_si.cos")
        manny:play_chore(mc_in_si_open_frg, "mc_in_si.cos")
        fridge_door:play_chore(frg_door_door_open)
        manny:wait_for_chore(mc_in_si_open_frg, "mc_in_si.cos")
        manny:pop_costume()
        if not si.naranja_out then
            start_script(si.fridge_motor)
        end
        MakeSectorActive("bottle", FALSE)
        MakeSectorActive("bottle1", FALSE)
        MakeSectorActive("no_fridge", FALSE)
        MakeSectorActive("floor_1", FALSE)
        END_CUT_SCENE()
    end
end
si.fridge.close = function(arg1) -- line 1355
    si.fridge:make_touchable()
    if not si.lettuce_crisper:is_open() then
        stop_script(si.fridge_motor)
        arg1.parent.close(arg1)
        si.lettuce_crisper:make_untouchable()
        MakeSectorActive("bottle", TRUE)
        MakeSectorActive("bottle1", TRUE)
        MakeSectorActive("no_fridge", TRUE)
        MakeSectorActive("floor_1", TRUE)
        MakeSectorActive("xit_frg_box", TRUE)
        MakeSectorActive("xit_box", TRUE)
        start_sfx("rfrgDrCl.wav")
    end
    si.fridge.door_closed = TRUE
end
si.fridge.use = function(arg1) -- line 1373
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
si.cot = Object:create(si, "/sitx091/cot", 1.38577, -1.00889, 0.039999999, { range = 0.5 })
si.cot.use_pnt_x = 1.188
si.cot.use_pnt_y = -1.051
si.cot.use_pnt_z = 0
si.cot.use_rot_x = 0
si.cot.use_rot_y = -78.643799
si.cot.use_rot_z = 0
si.cot.lookAt = function(arg1) -- line 1394
    if in_year_four then
        manny:say_line("/sima092/")
    elseif si.naranja_out then
        arg1.seen = TRUE
        manny:say_line("/sima093/")
    else
        manny:say_line("/sima094/")
    end
end
si.cot.use = function(arg1) -- line 1407
    if in_year_four then
        manny:say_line("/sima095/")
    elseif si.naranja_out then
        if not si.rolled_naranja then
            si.rolled_naranja = TRUE
            si.dog_tags:get()
            START_CUT_SCENE()
            manny:say_line("/sima096/")
            manny:walkto(1.26159, -1.04933, 0, 0, 280, 0)
            manny:wait_for_message()
            manny:wait_for_actor()
            manny:play_chore(mc_reach_med, "mc.cos")
            sleep_for(900)
            start_sfx("getDogTg.wav")
            manny:play_chore_looping(mc_activate_dog_tags, "mc.cos")
            manny.hold_chore = mc_activate_dog_tags
            manny.is_holding = si.dog_tags
            manny:wait_for_chore(mc_reach_med, "mc.cos")
            manny:blend(mc_hold, mc_reach_med, 500, "mc.cos", "mc.cos")
            sleep_for(500)
            manny:play_chore_looping(mc_hold, "mc.cos")
            manny:say_line("/sima097/")
            si.dog_tags:lookAt()
            if not arg1.seen then
                manny:wait_for_message()
                arg1:lookAt()
            end
            END_CUT_SCENE()
        else
            manny:say_line("/sima098/")
        end
    else
        manny:say_line("/sima099/")
    end
end
si.cot.pickUp = si.cot.use
si.cot.use_dog_tags = function(arg1) -- line 1448
    manny:say_line("/sima100/")
end
si.dog_tags = Object:create(si, "/sitx101/dog tags", 0, 0, 0, { range = 0 })
si.dog_tags.string_name = "dog_tags"
si.dog_tags.wav = "getDogTg.wav"
si.dog_tags.lookAt = function(arg1) -- line 1457
    manny:say_line("/sima102/")
end
si.dog_tags.use = function(arg1) -- line 1461
    manny:say_line("/sima103/")
end
si.phone = Object:create(si, "/sitx104/phone", -0.37371999, -0.59829998, 0.47999999, { range = 0.60000002 })
si.phone.use_pnt_x = -0.19769
si.phone.use_pnt_y = -0.63867998
si.phone.use_pnt_z = 0
si.phone.use_rot_x = 0
si.phone.use_rot_y = 94.629303
si.phone.use_rot_z = 0
si.phone.lookAt = function(arg1) -- line 1475
    if in_year_four or used_totos_phone then
        manny:say_line("/sima105/")
    else
        manny:say_line("/sima106a/")
        manny:wait_for_message()
        manny:say_line("/sima106b/")
    end
end
si.phone.call_operator = function(arg1) -- line 1485
    manny:say_line("/sima107/")
    manny:wait_for_message()
end
si.phone.use = function(arg1) -- line 1490
    if in_year_four then
        START_CUT_SCENE()
        si.phone:pick_up()
        si.phone:call_operator()
        manny:say_line("/sima108a/")
        manny:nod_head_gesture()
        manny:wait_for_message()
        manny:say_line("/sima108b/")
        manny:hand_gesture()
        manny:wait_for_message()
        start_sfx("inezhgup.wav")
        wait_for_sound("inezhgup.wav")
        si.phone:hang_up()
        manny:say_line("/sima109/")
        manny:shrug_gesture()
        END_CUT_SCENE()
    elseif si.naranja_out then
        si.toto_obj:use()
    elseif not used_totos_phone then
        used_totos_phone = TRUE
        START_CUT_SCENE()
        si.phone:pick_up()
        si.phone:call_operator()
        manny:say_line("/sima110a/")
        manny:nod_head_gesture(TRUE)
        manny:wait_for_message()
        manny:hand_gesture()
        sleep_for(500)
        manny:say_line("/sima110b/")
        manny:wait_for_message()
        sleep_for(1000)
        manny:say_line("/sima111a/")
        manny:twist_head_gesture()
        manny:wait_for_message()
        manny:say_line("/sima111b/")
        manny:wait_for_message()
        start_sfx("inezhgup.wav")
        wait_for_sound("inezhgup.wav")
        si.phone:hang_up()
        manny:shrug_gesture()
        sleep_for(1000)
        END_CUT_SCENE()
        manny:say_line("/sima112/")
    else
        manny:say_line("/sima113/")
    end
end
si.phone.pick_up = function(arg1) -- line 1543
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if in_year_four then
        manny:push_costume("msb_in_si.cos")
    else
        manny:push_costume("mc_in_si.cos")
    end
    manny:play_chore(mc_in_si_grab_phone)
    manny:wait_for_chore()
    manny:stop_chore(mc_in_si_grab_phone)
    manny:play_chore(mc_in_si_hold_phone)
    END_CUT_SCENE()
end
si.phone.hang_up = function(arg1) -- line 1558
    START_CUT_SCENE()
    manny:stop_chore(mc_in_si_hold_phone)
    manny:play_chore(mc_in_si_hang_phone)
    manny:wait_for_chore()
    manny:pop_costume()
    END_CUT_SCENE()
end
si.toto_obj = Object:create(si, "/sitx114/Toto", 0.375, -0.787, 0.347, { range = 0.60000002 })
si.toto_obj.use_pnt_x = 0.46900001
si.toto_obj.use_pnt_y = -1.117
si.toto_obj.use_pnt_z = 0
si.toto_obj.use_rot_x = 0
si.toto_obj.use_rot_y = -12.0664
si.toto_obj.use_rot_z = 0
si.toto_obj.lookAt = function(arg1) -- line 1577
    manny:say_line("/gtcma17/")
end
si.toto_obj.use = function(arg1, arg2) -- line 1581
    if not si.naranja_out then
        if not bug_toto_count then
            bug_toto_count = 1
        else
            bug_toto_count = bug_toto_count + 1
        end
        if not arg2 then
            if bug_toto_count == 1 then
                manny:say_line("/sima115/")
            elseif bug_toto_count == 2 then
                manny:say_line("/sima116/")
            elseif bug_toto_count == 3 then
                manny:say_line("/sima117/")
            elseif bug_toto_count == 4 then
                manny:say_line("/sima118/")
            elseif bug_toto_count == 5 then
                manny:say_line("/sima119/")
            elseif bug_toto_count == 6 then
                manny:say_line("/sima120/")
            elseif bug_toto_count == 7 then
                manny:say_line("/sima121/")
            elseif bug_toto_count == 8 then
                manny:say_line("/sima122/")
            elseif bug_toto_count == 9 then
                manny:say_line("/sima123/")
            elseif bug_toto_count == 10 then
                manny:say_line("/sima124/")
            elseif bug_toto_count == 11 then
                manny:say_line("/sima125/")
            elseif bug_toto_count == 12 then
                manny:say_line("/sima126/")
            elseif bug_toto_count == 13 then
                manny:say_line("/sima127/")
            elseif bug_toto_count == 14 then
                manny:say_line("/sima128a/")
                manny:wait_for_message()
                manny:say_line("/sima128b/")
            else
                manny:say_line("/sima129/")
            end
            manny:wait_for_message()
        end
        PrintDebug(1)
        if bug_toto_count == 1 then
            toto:say_line("/sito130a/")
            toto:wait_for_message()
            toto:say_line("/sito130b/")
        elseif bug_toto_count == 2 then
            toto:say_line("/sito131/")
        elseif bug_toto_count == 3 then
            toto:say_line("/sito132a/")
            toto:wait_for_message()
            toto:say_line("/sito132b/")
        elseif bug_toto_count == 4 then
            toto:say_line("/sito133/")
        elseif bug_toto_count == 5 then
            toto:say_line("/sito134/")
        elseif bug_toto_count == 6 then
            toto:say_line("/sito135/")
        elseif bug_toto_count == 7 then
            toto:say_line("/sito136/")
        elseif bug_toto_count == 8 then
            toto:say_line("/sito137/")
        elseif bug_toto_count == 9 then
            toto:say_line("/sito138/")
        else
            toto:say_line(pick_one_of({ "/sito139/", "/sito140/", "/sito141/", "/sito142/", "/sito143/", "/sito144/", "/sito145/" }, TRUE))
        end
    else
        START_CUT_SCENE()
        stop_script(si.toto_on_phone)
        toto:shut_up()
        manny:head_look_at(si.phone)
        manny:say_line("/clma008/")
        sleep_for(500)
        toto:head_look_at_manny()
        manny:wait_for_message()
        toto:say_line("/sito154/")
        toto:wait_for_message()
        manny:head_look_at(nil)
        toto:head_look_at(nil)
        END_CUT_SCENE()
    end
end
si.toto_obj.use_detector = function(arg1) -- line 1686
    if not si.naranja_out then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        si:current_setup(si_frgms)
        manny:play_chore(mc_use_obj, "mc.cos")
        manny:wait_for_chore()
        toto:say_line("/sito146a/")
        toto:wait_for_message()
        toto:say_line("/sito146b/")
        toto:wait_for_message()
        toto:say_line("/sito146c/")
        END_CUT_SCENE()
    end
end
si.toto_obj.use_pass = function(arg1) -- line 1702
    si.interrupt_toto()
    toto:say_line("/sito147/")
    si.toto_resume()
end
si.toto_obj.use_opener = function(arg1) -- line 1708
    si.interrupt_toto()
    toto:say_line("/sito148a/")
    toto:wait_for_message()
    toto:say_line("/sito148b/")
    si.toto_resume()
end
si.toto_obj.use_book = function(arg1) -- line 1716
    START_CUT_SCENE()
    si.interrupt_toto()
    toto:say_line("/sito149/")
    toto:wait_for_message()
    manny:say_line("/sima150/")
    manny:wait_for_message()
    toto:say_line("/sito151/")
    END_CUT_SCENE()
    si.toto_resume()
end
si.toto_obj.use_case = function(arg1) -- line 1729
    si.interrupt_toto()
    toto:say_line("/sito152/")
    si.toto_resume()
end
si.toto_obj.use_lengua = function(arg1) -- line 1735
    si.interrupt_toto()
    toto:say_line("/sito153a/")
    toto:wait_for_message()
    toto:say_line("/sito153b/")
    si.toto_resume()
end
si.toto_obj.use_anything_else = function(arg1) -- line 1743
    si.interrupt_toto()
    toto:say_line("/sito154/")
    si.toto_resume()
end
si.toto_obj.use_paper = function(arg1) -- line 1749
    if si.naranja_out then
        if not si.got_photofinish then
            si.got_photofinish = TRUE
            si:get_photofinish()
        else
            system.default_response("shed light")
        end
    else
        toto:say_line("/sito130a/")
        toto:wait_for_message()
        toto:say_line("/sito130b/")
    end
end
si.toto_resume = function() -- line 1764
    toto:wait_for_message()
    toto:head_look_at(nil)
    if si.naranja_out then
        start_script(si.toto_on_phone)
    end
end
si.scrimshaw_apparatus = Object:create(si, "/sitx183/stuff", 0.35816801, -0.91463101, 0.1671, { range = 0.60000002 })
si.scrimshaw_apparatus.use_pnt_x = 0.268332
si.scrimshaw_apparatus.use_pnt_y = -1.12954
si.scrimshaw_apparatus.use_pnt_z = 0
si.scrimshaw_apparatus.use_rot_x = 0
si.scrimshaw_apparatus.use_rot_y = 337.784
si.scrimshaw_apparatus.use_rot_z = 0
si.scrimshaw_apparatus.touchable = FALSE
si.scrimshaw_apparatus.lookAt = function(arg1) -- line 1782
    manny:say_line("/sima001/")
end
si.scrimshaw_apparatus.pickUp = function(arg1) -- line 1786
    si.interrupt_toto(TRUE)
end
si.scrimshaw_apparatus.use = function(arg1) -- line 1790
    si.interrupt_toto(TRUE)
end
si.ladder = Object:create(si, "/sitx155/ladder", -0.21371999, -0.0583, 0.80000001, { range = 1 })
si.ladder.use_pnt_x = -0.22
si.ladder.use_pnt_y = -0.221
si.ladder.use_pnt_z = 0
si.ladder.use_rot_x = 0
si.ladder.use_rot_y = 0.093383797
si.ladder.use_rot_z = 0
si.bottom = si.ladder
si.ladder.use = si.ladder.walkOut
si.ladder.walkOut = function(arg1) -- line 1808
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if manny.is_holding then
        put_away_held_item()
    end
    manny:start_climb_ladder()
    manny:climb_up()
    manny:climb_up()
    manny:stop_climb_ladder()
    END_CUT_SCENE()
    se:come_out_door(se.si_door)
end
si.ladder.lookAt = function(arg1) -- line 1824
    manny:say_line("/sima156/")
end
si.ladder.pickUp = function(arg1) -- line 1828
    system.default_response("not portable")
end
si.binders = Object:create(si, "/sitx157/binders", -0.31986701, -0.81404102, 0.34, { range = 0.5 })
si.binders.use_pnt_x = -0.149867
si.binders.use_pnt_y = -0.80404103
si.binders.use_pnt_z = 0
si.binders.use_rot_x = 0
si.binders.use_rot_y = -637.995
si.binders.use_rot_z = 0
si.binders.lookAt = function(arg1) -- line 1840
    soft_script()
    manny:say_line("/sima158/")
    manny:wait_for_message()
    manny:say_line("/sima159/")
    manny:wait_for_message()
    manny:say_line("/sima160/")
end
si.binders.pickUp = function(arg1) -- line 1849
    si.interrupt_toto(TRUE)
end
si.binders.use = si.binders.pickUp
si.booze = Object:create(si, "/sitx162/booze", -0.23999999, -1.03, 0.37, { range = 0.60000002 })
si.booze.use_pnt_x = -0.15000001
si.booze.use_pnt_y = -1.11475
si.booze.use_pnt_z = 0
si.booze.use_rot_x = 0
si.booze.use_rot_y = 63.360298
si.booze.use_rot_z = 0
si.booze.dosed = FALSE
si.booze.lookAt = function(arg1) -- line 1866
    if find_script(si.fridge_motor) then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        manny:say_line("/sima163/")
        if not arg1.seen then
            arg1.seen = TRUE
            manny:wait_for_message()
            naranja:say_line("/sina164/")
            naranja:wait_for_message()
            toto:say_line("/sito165/")
            toto:wait_for_message()
            naranja:say_line("/sina166/")
            naranja:wait_for_message()
            naranja:say_line("/sina167/")
            naranja:wait_for_message()
            toto:say_line("/sito168/")
        end
        END_CUT_SCENE()
    end
end
si.booze.pickUp = function(arg1) -- line 1890
    if si.guys_distracted or find_script(si.fridge_motor) then
        manny:say_line("/sima169/")
    else
        START_CUT_SCENE()
        naranja:say_line("/sina170/")
        naranja:wait_for_message()
        toto:say_line("/sito171/")
        END_CUT_SCENE()
    end
end
si.booze.use_turkey_baster = function(arg1) -- line 1902
    if hk.turkey_baster.full then
        if si.guys_distracted or (si.fridge:is_open() and si.lettuce_crisper:is_open()) then
            cur_puzzle_state[24] = TRUE
            START_CUT_SCENE("no_head")
            local local1 = naranja:getpos()
            manny:head_look_at(local1.x, local1.y, local1.z + 0.60000002)
            while not si.guys_distracted do
                break_here()
            end
            fridge_door:play_chore(1)
            si.lettuce_crisper.interest_actor:complete_chore(1)
            fridge_door:setrot(0, 179.979, 0)
            si.fridge:close()
            si.fridge.parent.close(si.fridge)
            si.lettuce_crisper.parent.close(si.lettuce_crisper)
            arg1.dosed = TRUE
            manny:head_look_at(nil)
            manny:walkto(-0.085999101, -1.18571, 0)
            manny:wait_for_actor()
            manny:setrot(0, 38.629601, 0, TRUE)
            manny:wait_for_actor()
            while si.naranja_pain do
                break_here()
            end
            manny:push_costume("ma_use_baster.cos")
            manny:play_chore(ma_use_baster_use_baster, "ma_use_baster.cos")
            manny:stop_chore(mc_activate_full_baster, "mc.cos")
            manny:stop_chore(mc_hold, "mc.cos")
            start_sfx("tkBstSqt.wav")
            manny:wait_for_chore(ma_use_baster_use_baster, "ma_use_baster.cos")
            manny:stop_chore(ma_use_baster_use_baster, "ma_use_baster.cos")
            manny:pop_costume()
            manny:head_look_at(local1.x, local1.y, local1.z + 0.60000002)
            manny:play_chore_looping(mc_activate_turkey_baster, "mc.cos")
            manny:play_chore_looping(mc_hold, "mc.cos")
            hk.turkey_baster.full = FALSE
            put_away_held_item()
            toto:say_line("/sito066a/")
            toto:wait_for_message()
            toto:say_line("/sito066b/")
            toto:wait_for_message()
            toto:say_line("/sito067/")
            toto:wait_for_message()
            toto:stop_chore(toto_look_fridge)
            toto:play_chore(toto_yell_to_drill)
            toto:wait_for_chore(toto_yell_to_drill)
            manny:head_look_at(nil)
        else
            manny:say_line("/sima172/")
        end
    else
        START_CUT_SCENE()
        manny:say_line("/sima173/")
        manny:wait_for_message()
        manny:say_line("/sima174/")
        END_CUT_SCENE()
    end
end
si.booze.use_rye = function(arg1) -- line 1962
    manny:say_line("/sima175/")
end
si.booze.use_liqueur = si.booze.use_rye
si.booze.use = si.booze.pickUp
si.naranja_obj = Object:create(si, "/sitx176/Sailor", 0.13628, -0.8883, 0.40000001, { range = 0.60000002 })
si.naranja_obj.use_pnt_x = -0.057519201
si.naranja_obj.use_pnt_y = -0.671947
si.naranja_obj.use_pnt_z = 0
si.naranja_obj.use_rot_x = 0
si.naranja_obj.use_rot_y = -122.848
si.naranja_obj.use_rot_z = 0
si.naranja_obj.lookAt = function(arg1) -- line 1979
    manny:say_line("/sima177/")
end
si.naranja_obj.pickUp = function(arg1) -- line 1983
    manny:say_line("/sima178/")
end
si.naranja_obj.use = function(arg1) -- line 1987
    if find_script(si.fridge_motor) then
        START_CUT_SCENE()
        manny:say_line("/sima179/")
        naranja:wait_for_message()
        naranja:say_line("/sina180/")
        END_CUT_SCENE()
    else
        arg1:lookAt()
    end
end
si.photofinish = Object:create(si, "/sitx181/photo", 0, 0, 0, { range = 0 })
si.photofinish.string_name = "photofinish"
si.photofinish.wav = "getCard.wav"
si.photofinish.lookAt = function(arg1) -- line 2004
    START_CUT_SCENE()
    pf:switch_to_set()
    if not arg1.seen then
        arg1.seen = TRUE
        manny:say_line("/sima182/")
        manny:wait_for_message()
    end
    END_CUT_SCENE()
end
si.photofinish.use = si.photofinish.lookAt
si.photofinish.default_response = function(arg1) -- line 2017
    system.default_response("shed light")
end

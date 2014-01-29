CheckFirstTime("shootout.lua")
dofile("me_windows.lua")
me.test_shootout = function() -- line 17
    manny.healed = TRUE
    me:switch_to_set()
    me:current_setup(me_shtgh)
    manny:setpos(3.39682, -2.08289, -0.119392)
    manny:setrot(0, 40.7742, 0)
    me.gun:hold()
    me.setup_shootout()
    preload_sfx("me_glas1.WAV")
    preload_sfx("me_glas2.WAV")
    preload_sfx("me_glas3.WAV")
    preload_sfx("me_gun.WAV")
    preload_sfx("hecgun.WAV")
end
me.glass_sounds = { "me_glas1.WAV", "me_glas2.WAV", "me_glas3.WAV" }
me.smash_all = function() -- line 37
    local local1
    local1 = 1
    repeat
        me.greenhouse:play_chore(local1)
        local1 = local1 + 1
    until local1 == 39
end
me.print_window_angles = function() -- line 46
    local local1
    while 1 do
        if me:current_setup() == me_shtgh then
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[1].act.hActor)))
            me.greenhouse.columns[1].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[2].act.hActor)))
            me.greenhouse.columns[2].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[3].act.hActor)))
            me.greenhouse.columns[3].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[4].act.hActor)))
            me.greenhouse.columns[4].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[5].act.hActor)))
            me.greenhouse.columns[5].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[6].act.hActor)))
            me.greenhouse.columns[6].act:say_line(local1)
            local1 = "<" .. tostring(floor(GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[7].act.hActor)))
            me.greenhouse.columns[7].act:say_line(local1)
        end
        break_here()
    end
end
me.setup_window_objects = function() -- line 69
    local local1 = 1
    me.greenhouse.tObjectStates = { }
    repeat
        me.greenhouse.tObjectStates[1] = me:add_object_state(me_shtgh, "me_" .. tostring(local1) .. ".bm", "me_" .. tostring(local1) .. ".zbm", OBJSTATE_STATE, TRUE)
        local1 = local1 + 1
    until local1 == 40
    me.greenhouse:set_object_state("me_windows.cos")
end
me.place_window_actor = function(arg1, arg2, arg3, arg4) -- line 80
    me.greenhouse.columns[arg1].act:set_costume("x_spot.cos")
    me.greenhouse.columns[arg1].act:set_visibility(FALSE)
    me.greenhouse.columns[arg1].act:put_in_set(me)
    me.greenhouse.columns[arg1].act:setpos(arg2, arg3, arg4)
end
me.setup_window_actors = function() -- line 87
    me.greenhouse.columns = { }
    me.greenhouse.columns[1] = { act = Actor:create(nil, nil, nil, "column 1") }
    me.greenhouse.columns[2] = { act = Actor:create(nil, nil, nil, "column 2") }
    me.greenhouse.columns[3] = { act = Actor:create(nil, nil, nil, "column 3") }
    me.greenhouse.columns[4] = { act = Actor:create(nil, nil, nil, "column 4") }
    me.greenhouse.columns[5] = { act = Actor:create(nil, nil, nil, "column 5") }
    me.greenhouse.columns[6] = { act = Actor:create(nil, nil, nil, "column 6") }
    me.greenhouse.columns[7] = { act = Actor:create(nil, nil, nil, "column 7") }
    me.place_window_actor(1, 2.19182, -1.51689, 0.0256077)
    me.place_window_actor(2, 2.42582, -1.39088, 0.0276077)
    me.place_window_actor(3, 2.61582, -1.23388, 0.00360769)
    me.place_window_actor(4, 2.82582, -1.00488, 0.0136077)
    me.place_window_actor(5, 2.97882, -0.759885, -0.0153923)
    me.place_window_actor(6, 3.07282, -0.478885, 0.0546078)
    me.place_window_actor(7, 3.12282, -0.179885, 0.0286078)
    me.greenhouse.columns[1].objs = { "me_windows_33", "me_windows_26", "me_windows_19", "me_windows_12", "me_windows_5" }
    me.greenhouse.columns[2].objs = { "me_windows_34", "me_windows_27", "me_windows_20", "me_windows_13", "me_windows_6" }
    me.greenhouse.columns[3].objs = { "me_windows_35", "me_windows_28", "me_windows_21", "me_windows_14", "me_windows_7" }
    me.greenhouse.columns[4].objs = { "me_windows_36", "me_windows_29", "me_windows_22", "me_windows_15", "me_windows_8", "me_windows_1" }
    me.greenhouse.columns[5].objs = { "me_windows_37", "me_windows_30", "me_windows_23", "me_windows_16", "me_windows_9", "me_windows_2" }
    me.greenhouse.columns[6].objs = { "me_windows_38", "me_windows_31", "me_windows_24", "me_windows_17", "me_windows_10", "me_windows_3" }
    me.greenhouse.columns[7].objs = { "me_windows_39", "me_windows_32", "me_windows_25", "me_windows_18", "me_windows_11", "me_windows_4" }
end
me.setup_shootout = function() -- line 116
    if not me.greenhouse.columns then
        me.setup_window_actors()
    end
    if not me.greenhouse.tObjectStates then
        me.setup_window_objects()
    end
    if manny:get_costume() ~= "md_shooting.cos" then
        manny:push_costume("md_shooting.cos")
    end
    me.darts.hObjectState = me:add_object_state(me_pmpws, "me_darts.bm", nil, OBJSTATE_STATE, FALSE)
    me.darts:set_object_state("me_darts.cos")
    me.shootout_count = 0
    me.window_broken_flag = { }
end
test = function() -- line 133
    local local1
    while 1 do
        local1 = GetAngleBetweenActors(hector.hActor, manny.hActor)
        ExpireText()
        print_temporary(local1)
        break_here()
    end
end
me.check_for_hit = function() -- line 143
    local local1, local2, local3, local4
    local3 = 999
    local4 = nil
    local1 = 1
    repeat
        local2 = GetAngleBetweenActors(manny.hActor, me.greenhouse.columns[local1].act.hActor)
        if local2 < local3 then
            local4 = local1
            local3 = local2
        end
        local1 = local1 + 1
    until local1 > 7
    if local3 < 45 then
        return local4
    else
        return nil
    end
end
me.smash_window_in_column = function(arg1) -- line 166
    local local1, local2
    local1 = pick_one_of(me.greenhouse.columns[arg1].objs, TRUE)
    local2 = getglobal(local1)
    if local2 then
        start_sfx(pick_one_of(me.glass_sounds, TRUE))
        if not me.window_broken_flag[local2] then
            me.window_broken_flag[local2] = TRUE
            sleep_for(200)
            me.greenhouse:play_chore(local2)
        end
    end
end
me.shootout = function() -- line 181
    local local1
    START_CUT_SCENE()
    me.shootout_begun = TRUE
    me:current_setup(me_shtgh)
    music_state:update()
    local1 = me.check_for_hit()
    start_script(me.manny_shoot)
    sleep_for(500)
    END_CUT_SCENE()
    if local1 then
        me.smash_window_in_column(local1)
        music_state:set_state(stateSHOOT)
        stop_script(me.hector_reaction)
        if not hector.dying then
            start_script(me.hector_reaction)
        end
    end
end
me.manny_shoot = function() -- line 211
    START_CUT_SCENE()
    if manny:get_costume() ~= "md_shooting.cos" then
        manny:push_costume("md_shooting.cos")
    end
    manny:set_rest_chore(nil)
    manny:stop_chore(md_hold, "md.cos")
    manny:play_chore(md_shooting_quick_shot, "md_shooting.cos")
    sleep_for(200)
    start_sfx("me_gun.WAV")
    manny:wait_for_chore(md_shooting_quick_shot, "md_shooting.cos")
    manny:stop_chore(md_shooting_quick_shot, "md_shooting.cos")
    manny:play_chore_looping(md_hold, "md.cos")
    manny:set_rest_chore(md_rest, "md.cos")
    END_CUT_SCENE()
end
manny.run_for_cover = function(arg1) -- line 228
    manny:head_look_at(nil)
    manny:face_entity(3.97991, -1.30607, -0.211625)
    start_script(manny.runto, manny, 3.97991, -1.30607, -0.211625, 0, 72.9266, 0)
    manny:wait_for_actor()
end
manny.duck = function(arg1) -- line 235
    if manny:get_costume() ~= "md_shooting.cos" then
        manny:push_costume("md_shooting.cos")
    end
    manny:set_rest_chore(nil)
    manny:run_chore(md_shooting_duck, "md_shooting.cos")
    manny:stop_chore(md_shooting_duck, "md_shooting.cos")
    manny:set_rest_chore(md_rest, "md.cos")
end
manny.unduck = function(arg1) -- line 245
    manny:fade_out_chore(md_shooting_duck, "md_shooting.cos")
end
hector.run_med_left = function(arg1) -- line 256
    PrintDebug("run_med_left\n")
    hector:walkto(1.68938, -0.43049, 0.27, 0, 211.451, 0)
end
hector.run_right = function(arg1) -- line 260
    PrintDebug("run_right\n")
    hector:walkto(1.42082, 0.93111, 0.27, 0, 316.471, 0)
end
hector.run_back = function(arg1) -- line 264
    PrintDebug("run_back\n")
    hector:walkto(-0.0751248, 1.21843, 0.27, 0, 28.6596, 0)
end
hector.run_left = function(arg1) -- line 268
    PrintDebug("run_left\n")
    hector:walkto(1.42082, -0.63989, 0.27, 0, 187.198, 0)
end
hector.run_front = function(arg1) -- line 272
    PrintDebug("run_front\n")
    hector:walkto(1.84638, -0.00248966, 0.266058, 0, 245, 0)
end
hector.run_way_back = function(arg1) -- line 277
    PrintDebug("run_way_back\n")
    hector:walkto(-0.63262, 0.0755099, 0.27, 0, 73.0735, 0)
end
hector.dodges = { hector.run_med_left, hector.run_right, hector.run_back, hector.run_left, hector.run_front, hector.run_way_back }
hector.run_around_nervously = function() -- line 284
    local local1
    stop_script(hector.part_1_idle)
    hector:complete_chore(he_greenhouse_show_gun, "he_greenhouse.cos")
    if not hector.crouching then
        hector:crouch()
    end
    while not hector.dying do
        local1 = pick_one_of(hector.dodges, TRUE)
        local1()
        hector:wait_for_actor()
        sleep_for(1000)
        hector:look_around()
        if rnd(2) then
            hector:uncrouch()
            hector:look_around()
            hector:crouch()
            hector:look_around()
        end
    end
end
hector.crouch = function(arg1) -- line 306
    stop_script(hector.part_1_idle)
    if not hector.crouching then
        hector.crouching = TRUE
        hector:run_chore(he_greenhouse_aim_to_crouch, "he_greenhouse.cos")
    end
    hector:complete_chore(he_greenhouse_crouch, "he_greenhouse.cos")
end
hector.uncrouch = function(arg1) -- line 315
    hector.crouching = FALSE
    hector:run_chore(he_greenhouse_crouch_to_aim, "he_greenhouse.cos")
end
hector.run_to_window = function(arg1, arg2, arg3) -- line 320
    local local1
    stop_script(hector.part_1_idle)
    stop_script(hector.run_around_nervously)
    stop_script(hector.look_around)
    hector:head_look_at(nil)
    if arg3 then
        hector:setpos(-2.6502399, 0.65807903, 0.266058)
        hector:setrot(0, 72.3787, 0)
    end
    stop_script(hector.part_1_idle)
    hector:complete_chore(he_greenhouse_show_gun, "he_greenhouse.cos")
    start_script(hector.walkto, hector, 1.84638, -0.0024896599, 0.266058)
    hector:wait_for_actor()
    hector:head_look_at(nil)
    hector:play_chore(he_greenhouse_run_to_cruch, "he_greenhouse.cos")
    hector:wait_for_chore(he_greenhouse_run_to_cruch, "he_greenhouse.cos")
    if arg2 then
        hector:look_around()
    end
end
hector.shoot = function(arg1) -- line 349
    hector:head_look_at(nil)
    hector:complete_chore(he_greenhouse_show_gun, "he_greenhouse.cos")
    hector:wait_for_actor()
    if hector.crouching then
        hector:uncrouch()
    end
    hector:play_chore(he_greenhouse_shoot_once, "he_greenhouse.cos")
    start_sfx("hecgun.WAV")
    hector:wait_for_chore(he_greenhouse_shoot_once, "he_greenhouse.cos")
    hector:run_chore(he_greenhouse_shoot_to_aim, "he_greenhouse.cos")
end
hector.get_look_point = function(arg1, arg2) -- line 362
    local local1 = { x = 0, y = 1, z = 0 }
    local local2 = arg1:get_positive_rot()
    local local3 = arg1:getpos()
    local local4
    if arg1.crouching then
        local4 = 0.5
    else
        local4 = 0.80000001
    end
    local1 = RotateVector(local1, { x = 0, y = local2.y, z = 0 })
    lookvec = RotateVector(local1, { x = 0, y = arg2, z = 0 })
    newpoint = { x = local3.x + lookvec.x, y = local3.y + lookvec.y, z = local3.z + local4 }
    return newpoint
end
hector.look_around = function(arg1) -- line 380
    local local1
    local1 = hector:get_look_point(35)
    hector:head_look_at_point(local1, 200)
    sleep_for(1000)
    local1 = hector:get_look_point(-35)
    hector:head_look_at_point(local1, 190)
    sleep_for(1500)
    local1 = hector:get_look_point(35)
    hector:head_look_at_point(local1, 180)
    sleep_for(1000)
    hector:head_look_at(nil, 250)
end
hector.random_taunts = { "/mehe027/", "/mehe028/", "/mehe029/", "/mehe031/", "/mehe034/", "/mehe035/", "/mehe038/" }
hector.face_mannys_voice = function() -- line 409
    local local1
    hector:wait_for_actor()
    while not (IsMessageGoing() and system.lastActorTalking == manny) do
        break_here()
    end
    sleep_for(1000)
    local1 = manny:getpos()
    hector:turn_toward_entity(local1.x, local1.y, local1.z)
end
me.hector_reaction = function() -- line 420
    local local1
    START_CUT_SCENE()
    me.shootout_count = me.shootout_count + 1
    stop_script(hector.part_1_idle)
    stop_script(hector.run_around_nervously)
    stop_script(hector.look_around)
    stop_script(hector.walkto)
    hector:head_look_at(nil)
    if not hector.crouching then
        hector:crouch()
    end
    start_script(hector.run_to_window, hector, TRUE)
    sleep_for(1000)
    start_script(hector.face_mannys_voice)
    hector:wait_for_actor()
    if me.shootout_count == 1 then
        hector:say_line("/mehe016/")
        wait_for_message()
        hector:say_line("/mehe017/")
        wait_for_message()
        manny:say_line("/mema018/")
        wait_for_message()
        manny:say_line("/mema019/")
        manny:wait_for_message()
        hector:say_line("/mehe030/")
    elseif me.shootout_count == 5 then
        manny:say_line("/mema020/")
        manny:wait_for_message()
        hector:say_line("/mehe038/")
    elseif me.shootout_count == 10 then
        manny:say_line("/mema021/")
        wait_for_message()
        manny:say_line("/mema022/")
        manny:wait_for_message()
        hector:say_line("/mehe027/")
        hector:wait_for_message()
        hector:say_line("/mehe036/")
        hector:wait_for_message()
        hector:say_line("/mehe037/")
    elseif me.shootout_count == 15 then
        manny:say_line("/mema023/")
        manny:wait_for_message()
        hector:say_line("/mehe032/")
    elseif me.shootout_count == 20 then
        manny:say_line("/mema024/")
        manny:wait_for_message()
        hector:say_line("/mehe033/")
    elseif me.shootout_count == 25 then
        manny:say_line("/mema025/")
        wait_for_message()
        hector:say_line("/mehe026/")
    else
        hector:say_line(pick_one_of(hector.random_taunts, TRUE))
    end
    manny:wait_for_message()
    hector:wait_for_message()
    hector:wait_for_actor()
    stop_script(hector.run_to_window)
    if find_script(hector.face_mannys_voice) then
        stop_script(hector.face_mannys_voice)
        hector:setrot(0, 220, 0, TRUE)
    end
    hector:wait_for_actor()
    hecrot = hector:get_positive_rot()
    if hecrot.y < 230 then
        hecwin = me_windows_15
    elseif hecrot.y < 262 then
        hecwin = me_windows_16
    else
        hecwin = me_windows_17
    end
    local1 = GetAngleBetweenActors(hector.hActor, manny.hActor)
    if local1 < 20 then
        start_script(manny.run_for_cover, manny)
    end
    stop_script(hector.look_around)
    hector:head_look_at(nil, 999)
    start_script(hector.shoot)
    sleep_for(750)
    start_sfx(pick_one_of(me.glass_sounds, TRUE))
    if not me.window_broken_flag[hecwin] then
        me.window_broken_flag[hecwin] = TRUE
        sleep_for(100)
        me.greenhouse:play_chore(hecwin)
    end
    wait_for_script(manny.run_for_cover)
    if local1 < 20 then
        if find_script(hector.shoot) then
            manny:duck()
            wait_for_script(hector.shoot)
            manny:unduck()
        end
    end
    END_CUT_SCENE()
    start_script(hector.run_around_nervously)
end

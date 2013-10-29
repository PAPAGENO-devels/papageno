CheckFirstTime("bk.lua")
bk = Set:create("bk.set", "Blue Casket kitchen", { bk_medha = 0, bk_ovrhd = 1 })
dofile("bk_door.lua")
dofile("waiter.lua")
dofile("waiter_shooters.lua")
dofile("waiter_idles.lua")
dofile("ma_use_baster.lua")
bk.waiter_look_point = { x = 0.118256, y = 0.320226, z = 0.5052 }
bk.open_door_for_waiter = function() -- line 20
    local local1
    while not beat_waiter:find_sector_name("waiter_dr_trig") do
        local1 = beat_waiter:getpos()
        manny:head_look_at_point(local1.x, local1.y, local1.z + 0.60000002)
        break_here()
    end
    bk.bi_door:play_chore(bk_door_opening)
    while beat_waiter:is_moving() do
        break_here()
    end
    bk.bi_door:play_chore(bk_door_closing)
end
bk.fill_sink = function(arg1) -- line 34
    START_CUT_SCENE("no head")
    bk.seen_water = TRUE
    bi.roofie_trigger_set = TRUE
    EngineDisplay(FALSE)
    LoadCostume("waiter_idles.cos")
    LoadCostume("waiter_shooters.cos")
    if not bk.stuff then
        bk.stuff = Actor:create(nil, nil, nil, "stuff")
    end
    box_on("waiter_box")
    bk.stuff:ignore_boxes()
    bk.stuff:put_in_set(bk)
    bk.stuff:set_costume("waiter_shooters.cos")
    bk.stuff:setpos(0.12807, 0.28539, 0.0015)
    bk.stuff:setrot(0, 359.336, 0)
    bk.stuff:play_chore(waiter_shooters_shooters_start, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_bowl_start, "waiter_shooters.cos")
    set_override(bk.fill_sink_override)
    beat_waiter:default()
    beat_waiter:set_rest_chore(nil)
    beat_waiter:ignore_boxes()
    beat_waiter:put_in_set(bk)
    beat_waiter:setpos(0.12807, 0.28539, 0.0015)
    beat_waiter:setrot(0, 359.336, 0)
    beat_waiter:push_costume("waiter_shooters.cos")
    stop_script(manny.walk_and_face)
    break_here()
    EngineDisplay(TRUE)
    start_script(manny.walk_and_face, manny, -0.179054, -0.283012, 0, 0, 338.792, 0)
    manny:head_look_at_point(bk.waiter_look_point)
    beat_waiter:set_rest_chore(nil)
    beat_waiter:stop_chore()
    beat_waiter:set_head(3, 4, 4, 165, 28, 80)
    beat_waiter:set_look_rate(140)
    beat_waiter:run_chore(waiter_shooters_toss_tray, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_tray_end, "waiter_shooters.cos")
    bk.stuff:stop_chore(waiter_shooters_bowl_start, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_pickup_bowl, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_pickup_hooka, "waiter_shooters.cos")
    beat_waiter:stop_chore(waiter_shooters_toss_tray, "waiter_shooters.cos")
    beat_waiter:play_chore(waiter_shooters_kitchen_action, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_lid_toss, "waiter_shooters.cos")
    sleep_for(9000)
    beat_waiter:say_line("/bkbw001/")
    beat_waiter:wait_for_chore(waiter_shooters_kitchen_action, "waiter_shooters.cos")
    beat_waiter:play_chore_looping(waiter_shooters_shake, "waiter_shooters.cos")
    beat_waiter:wait_for_message()
    beat_waiter:say_line("/bkbw002/")
    sleep_for(2000)
    beat_waiter:head_look_at(bk.cleansers)
    sleep_for(1000)
    beat_waiter:head_look_at(nil)
    wait_for_message()
    manny:head_forward_gesture()
    manny:say_line("/bkma003/")
    beat_waiter:head_look_at(nil)
    manny:head_look_at_point(bk.waiter_look_point)
    wait_for_message()
    beat_waiter:stop_looping_chore(waiter_shooters_shake, "waiter_shooters.cos")
    stop_sound("bkShake.imu")
    beat_waiter:say_line("/bkbw004/")
    bk.stuff:play_chore(waiter_shooters_hide_counter_shooters, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_bowl_end, "waiter_shooters.cos")
    beat_waiter:stop_chore(nil, "waiter_shooters.cos")
    beat_waiter:play_chore(waiter_shooters_pour, "waiter_shooters.cos")
    LoadCostume("waiter_idles.cos")
    beat_waiter:wait_for_chore(waiter_shooters_pour, "waiter_shooters.cos")
    beat_waiter:play_chore(waiter_shooters_idle_shooters, "waiter_shooters.cos")
    beat_waiter:wait_for_message()
    beat_waiter:default()
    beat_waiter:stop_chore(waiter_shooters_idle_shooters, "waiter_shooters.cos")
    beat_waiter:follow_boxes()
    beat_waiter:play_chore(waiter_idles_activate_shooters, "waiter_idles.cos")
    beat_waiter:walkto(-0.0310095, -0.900189, 0)
    bk:open_door_for_waiter()
    beat_waiter:free()
    manny:head_look_at(bk.sink)
    box_off("waiter_box")
    END_CUT_SCENE()
end
bk.fill_sink_override = function() -- line 134
    kill_override()
    bk.stuff:play_chore(waiter_shooters_tray_end, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_bowl_end, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_pickup_bowl, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_hooka_lid_end, "waiter_shooters.cos")
    bk.stuff:play_chore(waiter_shooters_hide_counter_shooters, "waiter_shooters.cos")
    box_off("waiter_box")
    beat_waiter:free()
    manny:head_look_at(nil)
end
bk.push_out_door = function(arg1) -- line 148
    START_CUT_SCENE()
    bk.bi_door:play_chore(bk_door_opening)
    manny:walkto(-0.0310095, -0.900189, 0)
    sleep_for(750)
    bk.bi_door:run_chore(bk_door_closing)
    END_CUT_SCENE()
end
bk.push_in_door = function(arg1) -- line 163
    START_CUT_SCENE()
    EngineDisplay(FALSE)
    bk:switch_to_set()
    manny:put_in_set(bk)
    manny:setpos(0.182621, -0.606099, 0)
    manny:setrot(0, 4.25677, 0)
    bk.bi_door:play_chore(bk_door_closed)
    EngineDisplay(TRUE)
    END_CUT_SCENE()
    if not bk.seen_water and not in_year_four then
        start_script(bk.fill_sink)
    end
end
bk.update_music_state = function(arg1) -- line 193
    if in_year_four then
        return stateBK_YR4
    else
        return stateBK
    end
end
bk.enter = function(arg1) -- line 202
    if in_year_four then
        bk.sink.full = FALSE
        bk.sink:make_untouchable()
        bk.cleansers:make_untouchable()
        bk.keg:make_touchable()
        bk.keg:set_object_state("bk_cask.cos")
        bk.keg.interest_actor:setpos(0.251638, 0.4665, 0.4235)
        bk.keg.interest_actor:setrot(0, 270, 0)
    else
        bk.keg:make_untouchable()
        if hk.turkey_baster.owner == manny and not hk.turkey_baster.full then
            preload_sfx("tkBstFil.wav")
            LoadCostume("ma_use_baster.cos")
        end
        start_sfx("BK_AMB.IMU", IM_HIGH_PRIORITY, 40)
    end
    bk.bi_door_hObjectState = bk:add_object_state(bk_medha, "bk_door.bm", "bk_door.zbm", OBJSTATE_STATE)
    bk.bi_door:set_object_state("bk_door.cos")
    box_off("waiter_box")
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.541113, 0.338238, 2.771)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(beat_waiter.hActor, 0)
    SetActorShadowPoint(beat_waiter.hActor, 0.541113, 0.338238, 2.771)
    SetActorShadowPlane(beat_waiter.hActor, "shadow1")
    AddShadowPlane(beat_waiter.hActor, "shadow1")
end
bk.exit = function(arg1) -- line 241
    KillActorShadows(manny.hActor)
    KillActorShadows(beat_waiter.hActor)
    stop_sound("BK_AMB.IMU")
    PrintDebug("exiting kitchen")
    bk.bi_door:free_object_state()
    beat_waiter:free()
    if bk.stuff then
        bk.stuff:free()
    end
end
bk.sink = Object:create(bk, "/bktx005/sink", -0.048930001, 0.4718, 0.2359, { range = 0.60000002 })
bk.sink.use_pnt_x = -0.099930003
bk.sink.use_pnt_y = 0.27500001
bk.sink.use_pnt_z = 0
bk.sink.use_rot_x = 0
bk.sink.use_rot_y = -0.63243502
bk.sink.use_rot_z = 0
bk.sink.full = TRUE
bk.sink.lookAt = function(arg1) -- line 267
    if bk.sink.full then
        manny:say_line("/bkma006/")
    else
        system.default_response("empty")
    end
end
bk.sink.pickUp = function(arg1) -- line 275
    if arg1.full then
        manny:say_line("/bkma008/")
    else
        system.default_response("empty")
    end
end
bk.sink.use = bk.sink.pickUp
bk.sink.use_turkey_baster = function(arg1) -- line 285
    if hk.turkey_baster.full then
        system.default_response("full")
    else
        soft_script()
        manny:walkto_object(arg1)
        START_CUT_SCENE("no head")
        manny:wait_for_actor()
        cur_puzzle_state[23] = TRUE
        hk.turkey_baster.full = TRUE
        manny:stop_chore(mc_activate_turkey_baster, "mc.cos")
        manny:stop_chore(mc_hold, "mc.cos")
        manny:push_costume("ma_use_baster.cos")
        manny:stop_chore()
        sleep_for(100)
        start_sfx("bongHit.wav")
        manny:play_chore(ma_use_baster_kitchen_baster, "ma_use_baster.cos")
        sleep_for(100)
        start_sfx("getTkBst.wav")
        sleep_for(600)
        fade_sfx("bongHit.wav", 100, 0)
        manny:wait_for_chore(ma_use_baster_kitchen_baster, "ma_use_baster.cos")
        manny:stop_chore()
        manny:pop_costume()
        manny:play_chore_looping(mc_activate_full_baster, "mc.cos")
        manny:play_chore_looping(mc_hold, "mc.cos")
        END_CUT_SCENE()
    end
end
bk.dishwasher = Object:create(bk, "/bktx009/dishwasher", 0.51709998, -0.043099999, 0.23999999, { range = 0.60000002 })
bk.dishwasher.use_pnt_x = 0.25601
bk.dishwasher.use_pnt_y = 0.228331
bk.dishwasher.use_pnt_z = 0
bk.dishwasher.use_rot_x = 0
bk.dishwasher.use_rot_y = -829.95697
bk.dishwasher.use_rot_z = 0
bk.dishwasher.lookAt = function(arg1) -- line 324
    manny:say_line("/bkma010/")
end
bk.dishwasher.pickUp = function(arg1) -- line 328
    system.default_response("not portable")
end
bk.dishwasher.use = function(arg1) -- line 332
    manny:say_line("/bkma012/")
end
bk.cleansers = Object:create(bk, "/bktx013/cleaning supplies", 0.62709999, 0.47690001, 0.63, { range = 0.89999998 })
bk.cleansers.use_pnt_x = 0.263677
bk.cleansers.use_pnt_y = 0.21690799
bk.cleansers.use_pnt_z = 0
bk.cleansers.use_rot_x = 0
bk.cleansers.use_rot_y = -59.871799
bk.cleansers.use_rot_z = 0
bk.cleansers.lookAt = function(arg1) -- line 344
    manny:say_line("/bkma014/")
end
bk.cleansers.pickUp = function(arg1) -- line 348
    manny:say_line("/bkma015/")
end
bk.cleansers.use = function(arg1) -- line 352
    manny:say_line("/bkma016/")
end
bk.dishes = Object:create(bk, "/bktx017/dishes", -0.40290001, -0.19310001, 0.30000001, { range = 0.60000002 })
bk.dishes.use_pnt_x = -0.214204
bk.dishes.use_pnt_y = -0.167189
bk.dishes.use_pnt_z = 0
bk.dishes.use_rot_x = 0
bk.dishes.use_rot_y = -632.56097
bk.dishes.use_rot_z = 0
bk.dishes.lookAt = function(arg1) -- line 364
    if in_year_four then
        manny:say_line("/bkma027/")
    else
        manny:say_line("/bkma018/")
    end
end
bk.dishes.pickUp = function(arg1) -- line 372
    manny:say_line("/bkma019/")
end
bk.dishes.use = function(arg1) -- line 376
    manny:say_line("/bkma020/")
end
bk.garbage = Object:create(bk, "/bktx021/garbage", -0.4729, -0.75309998, 0.16, { range = 0.60000002 })
bk.garbage.use_pnt_x = -0.21734001
bk.garbage.use_pnt_y = -0.54031998
bk.garbage.use_pnt_z = 0
bk.garbage.use_rot_x = 0
bk.garbage.use_rot_y = -971.35999
bk.garbage.use_rot_z = 0
bk.garbage.lookAt = function(arg1) -- line 389
    manny:say_line("/bkma022/")
end
bk.garbage.use = function(arg1) -- line 393
    manny:say_line("/bkma024/")
end
bk.garbage.pickUp = bk.garbage.use
bk.keg = Object:create(bk, "/bktx028/keg", 0.28334299, 0.51959002, 0.43239999, { range = 0.60000002 })
bk.keg.use_pnt_x = 0.039643399
bk.keg.use_pnt_y = 0.27498999
bk.keg.use_pnt_z = 0
bk.keg.use_rot_x = 0
bk.keg.use_rot_y = -78.383499
bk.keg.use_rot_z = 0
bk.keg.lookAt = function(arg1) -- line 407
    soft_script()
    manny:say_line("/bkma029/")
end
bk.keg.pickUp = function(arg1) -- line 412
    system.default_response("hernia")
end
bk.keg.use = function(arg1) -- line 416
    manny:say_line("/bkma030/")
end
bk.keg.use_bottle = function(arg1) -- line 420
    if lm.bottle.full then
        system.default_response("got some")
    elseif manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(msb_lf_hand_on_obj, "msb.cos")
        manny:wait_for_chore()
        start_sfx("hkSpgtOC.wav", IM_MED_PRIORITY, 80)
        wait_for_sound("hkSpgtOC.wav")
        start_sfx("pourJel.wav")
        wait_for_sound("pourJel.wav")
        start_sfx("hkSpgtOC.wav", IM_MED_PRIORITY, 80)
        wait_for_sound("hkSpgtOC.wav")
        manny:stop_chore(msb_activate_empty_bottle, "msb.cos")
        manny:play_chore_looping(msb_activate_bottle, "msb.cos")
        manny:stop_chore(msb_lf_hand_on_obj, "msb.cos")
        manny:play_chore(msb_lf_hand_off_obj, "msb.cos")
        manny:wait_for_chore()
        manny:stop_chore(msb_lf_hand_off_obj, "msb.cos")
        END_CUT_SCENE()
        lm.bottle.full = TRUE
        start_script(lm.bottle.lookAt)
    end
end
bk.bi_door = Object:create(bk, "/bktx025/door", 0.172521, -0.89459902, 0.45989999, { range = 0.60000002 })
bk.bi_door.use_pnt_x = 0.182621
bk.bi_door.use_pnt_y = -0.60609901
bk.bi_door.use_pnt_z = 0
bk.bi_door.use_rot_x = 0
bk.bi_door.use_rot_y = 1262.67
bk.bi_door.use_rot_z = 0
bk.bi_door.out_pnt_x = -0.045413099
bk.bi_door.out_pnt_y = -0.96969801
bk.bi_door.out_pnt_z = 0
bk.bi_door.out_rot_x = 0
bk.bi_door.out_rot_y = 1179.28
bk.bi_door.out_rot_z = 0
bk.bi_door.walkOut = function(arg1) -- line 468
    START_CUT_SCENE()
    bk:push_out_door()
    bi:switch_to_set()
    bi:current_setup(bi_kitdr)
    manny:put_in_set(bi)
    manny:setpos(bi.bk_door.out_pnt_x, bi.bk_door.out_pnt_y, bi.bk_door.out_pnt_z)
    manny:setrot(bi.bk_door.out_pnt_x, bi.bk_door.out_pnt_y + 180, bi.bk_door.out_pnt_z)
    manny:walkto(bi.bk_door.use_pnt_x, bi.bk_door.use_pnt_y, bi.bk_door.use_pnt_z)
    manny:wait_for_actor()
    manny:setpos(-0.226663, -2.12008, 0.15)
    manny:setrot(0, 315.148, 0)
    if in_year_four and not olivia.reunited then
        bi:current_setup(bi_kitdr)
        manny:setrot(0, 68.6345, 0, TRUE)
        manny:wait_for_actor()
        start_script(bi.reunion)
    end
    END_CUT_SCENE()
end
bk.bi_door.lookAt = function(arg1) -- line 489
    manny:say_line("/bkma026/")
end

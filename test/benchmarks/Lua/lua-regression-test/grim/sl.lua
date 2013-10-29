CheckFirstTime("sl.lua")
sl = Set:create("sl.set", "shuttle security", { sl_intha = 0, sl_intha1 = 0, sl_diams = 1, sl_intws = 2, sl_winha = 3, sl_ovrhd = 4 })
dofile("carla_moods.lua")
dofile("manny_lunge.lua")
dofile("ma_charmer.lua")
dofile("ca_detonate.lua")
dofile("sl_inventory.lua")
dofile("mc_fishout_key.lua")
dofile("sl_light.lua")
sl.item = { }
sl.item.init = function(arg1) -- line 27
    sl.item.orient_table = { }
    sl.item.orient_table[0] = { }
    sl.item.orient_table[0].pos = { x = 0.502289, y = -0.519764, z = 0.2192 }
    sl.item.orient_table[0].rot = { x = 102, y = 96, z = 0 }
    sl.item.orient_table[0].item = sl.detector
    sl.item.orient_table[1] = { }
    sl.item.orient_table[1].pos = { x = 0.585489, y = -0.571464, z = 0.2192 }
    sl.item.orient_table[1].rot = { x = 102, y = 70, z = 0 }
    sl.item.orient_table[1].item = hk.turkey_baster
    sl.item.orient_table[2] = { }
    sl.item.orient_table[2].pos = { x = 0.553489, y = -0.619464, z = 0.2086 }
    sl.item.orient_table[2].rot = { x = 94, y = 46, z = 0 }
    sl.item.orient_table[2].item = si.dog_tags
    sl.item.orient_table[3] = { }
    sl.item.orient_table[3].pos = { x = 0.523089, y = -0.622164, z = 0.2086 }
    sl.item.orient_table[3].rot = { x = 94, y = 94, z = 0 }
    sl.item.orient_table[3].item = cf.letters
    sl.item.orient_table[4] = { }
    sl.item.orient_table[4].pos = { x = 0.564089, y = -0.690864, z = 0.2089 }
    sl.item.orient_table[4].rot = { x = 94, y = 246, z = 0 }
    sl.item.orient_table[4].item = sl.key
    sl.item.orient_table[5] = { }
    sl.item.orient_table[5].pos = { x = 0.543989, y = -0.713664, z = 0.2523 }
    sl.item.orient_table[5].rot = { x = 142, y = 278, z = 88 }
    sl.item.orient_table[5].item = hl.case
    sl.item.orient_table[6] = { }
    sl.item.orient_table[6].pos = { x = 0.566989, y = -0.633065, z = 0.2912 }
    sl.item.orient_table[6].rot = { x = 176, y = 402, z = 540 }
    sl.item.orient_table[6].item = ci.liqueur
    sl.item.orient_table[7] = { }
    sl.item.orient_table[7].pos = { x = 0.452389, y = -0.752765, z = 0.2386 }
    sl.item.orient_table[7].rot = { x = 94, y = 416, z = 440 }
    sl.item.orient_table[7].item = cn.printer
    sl.item.orient_table[8] = { }
    sl.item.orient_table[8].pos = { x = 0.545789, y = -0.711765, z = 0.2386 }
    sl.item.orient_table[8].rot = { x = 134, y = 416, z = 440 }
    sl.item.orient_table[8].item = ks.opener
    sl.item.orient_table[9] = { }
    sl.item.orient_table[9].pos = { x = 0.638889, y = -0.806265, z = 0.243 }
    sl.item.orient_table[9].rot = { x = 188, y = 412, z = 364 }
    sl.item.orient_table[9].item = bi.book
    sl.item.orient_table[10] = { }
    sl.item.orient_table[10].pos = { x = 0.51419, y = -0.736465, z = 0.2321 }
    sl.item.orient_table[10].rot = { x = 96, y = 412, z = 364 }
    sl.item.orient_table[10].item = cn.pass
    sl.item.orient_table[11] = { }
    sl.item.orient_table[11].pos = { x = 0.63329, y = -0.751765, z = 0.1258 }
    sl.item.orient_table[11].rot = { x = 86, y = 412, z = 364 }
    sl.item.orient_table[11].item = tb.blackmail_photo
    sl.item.orient_table[12] = { }
    sl.item.orient_table[12].pos = { x = 0.66149, y = -0.739365, z = 0.232 }
    sl.item.orient_table[12].rot = { x = -352, y = 386, z = 364 }
    sl.item.orient_table[12].item = cn.ticket
    sl.item.orient_table[13] = { }
    sl.item.orient_table[13].pos = { x = 0.64539, y = -0.788866, z = 0.2458 }
    sl.item.orient_table[13].rot = { x = -338, y = 384, z = 446 }
    sl.item.orient_table[13].item = si.photofinish
    sl.item.orient_table[14] = { }
    sl.item.orient_table[14].pos = { x = 0.556889, y = -0.775564, z = 0.1787 }
    sl.item.orient_table[14].rot = { x = -324, y = 384, z = 446 }
    sl.item.orient_table[14].item = lx.lengua
    sl.item.orient_table[15] = { }
    sl.item.orient_table[15].pos = { x = 0.687089, y = -0.886864, z = 0.189 }
    sl.item.orient_table[15].rot = { x = -328, y = 384, z = 446 }
    sl.item.orient_table[15].item = hh.union_card
    sl.item.orient_table[16] = { }
    sl.item.orient_table[16].pos = { x = 0.560711, y = -0.505745, z = 0.291 }
    sl.item.orient_table[16].rot = { x = 0, y = 32.8603, z = 0 }
    sl.item.orient_table[16].item = mo.scythe
end
sl.draw_manny_inventory = function(arg1) -- line 116
    local local1, local2
    sl.item:init()
    local1 = 0
    while sl.item.orient_table[local1] do
        local2 = sl.item.orient_table[local1]
        if local2.item.owner == manny then
            if not local2.actor then
                local2.actor = Actor:create(nil, nil, nil, "inventory item")
            end
            local2.actor:set_costume("sl_inventory.cos")
            local2.actor:put_in_set(sl)
            local2.actor:complete_chore(local1)
            local2.actor:setpos(local2.pos.x, local2.pos.y, local2.pos.z)
            local2.actor:setrot(local2.rot.x, local2.rot.y, local2.rot.z)
        end
        local1 = local1 + 1
    end
end
sl.remove_manny_inventory = function(arg1) -- line 138
    local local1, local2
    local1 = 0
    while sl.item.orient_table[local1] do
        local2 = sl.item.orient_table[local1]
        if local2.actor then
            local2.actor:set_costume(nil)
            local2.actor:put_in_set(nil)
        end
        local1 = local1 + 1
    end
end
carla.walkto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 157
    arg1:stop_chore(carla_stand_hold, sl.search_cos)
    arg1:play_chore_looping(carla_walk, sl.search_cos)
    Actor.walkto(arg1, arg2, arg3, arg4)
    while arg1:is_moving() do
        break_here()
    end
    if arg5 then
        arg1:setrot(arg5, arg6, arg7, TRUE)
        arg1:wait_for_actor()
    end
    arg1:stop_chore(carla_walk, sl.search_cos)
    arg1:play_chore(carla_stand_hold, sl.search_cos)
end
sl.blow_up_case = function() -- line 173
    sl.bomb_detonated = TRUE
    hl.case:put_in_limbo()
    sl.key:get()
    music_state:set_state(stateSL_BOMB)
    START_CUT_SCENE()
    manny:head_look_at(sl.carla_obj)
    carla:stop_chore(carla_stand_hold, sl.search_cos)
    carla:set_time_scale(1.2)
    carla:play_chore(carla_hide_detector, sl.search_cos)
    carla:push_costume("ca_detonate.cos")
    carla:play_chore(ca_detonate_detonate)
    manny:stop_chore(mc_hold, "mc.cos")
    manny:set_time_scale(1.2)
    manny:play_chore(mc_give_item, "mc.cos")
    sleep_for(1100)
    start_sfx("slHndCse.wav")
    sleep_for(300)
    manny.is_holding = nil
    manny:stop_chore(mc_activate_cigcase, "mc.cos")
    manny:set_time_scale(1)
    carla:set_time_scale(1)
    manny:fade_out_chore(mc_give_item, "mc.cos", 500)
    sleep_for(2067)
    manny:head_look_at_point(0.58319, -0.79361, 0.24)
    start_script(sl.safe.play_open_and_close, sl.safe, 1000)
    sleep_for(3100)
    start_sfx("cigCsExp.WAV")
    sleep_for(50)
    music_state:update()
    start_script(sl.safe.play_explode, sl.safe)
    sleep_for(1467)
    start_script(sl.safe.play_open_and_close, sl.safe, 1000)
    sleep_for(2000)
    carla:say_line("/slca180/")
    carla:wait_for_message()
    manny:head_look_at(nil)
    carla:say_line("/slca181/")
    carla:wait_for_message()
    carla:head_look_at_point(0.58319, -0.79361, 0.24)
    carla:say_line("/slca182/")
    sleep_for(500)
    manny:head_look_at_point(0.58319, -0.79361, 0.24)
    carla:wait_for_message()
    carla:wait_for_chore()
    manny:push_costume("mc_fishout_key.cos")
    manny:head_look_at(nil)
    manny:play_chore(mc_fishout_key_fishout_key, "mc_fishout_key.cos")
    carla:say_line("/slca183/")
    sleep_for(533)
    carla:play_chore(ca_detonate_hide_bucket, "ca_detonate.cos")
    carla:wait_for_message()
    carla:head_look_at(nil)
    manny:wait_for_chore(mc_fishout_key_fishout_key, "mc_fishout_key.cos")
    manny:play_chore(mc_fishout_key_lookat_key, "mc_fishout_key.cos")
    manny:say_line("/slma184/")
    manny:wait_for_chore(mc_fishout_key_lookat_key, "mc_fishout_key.cos")
    manny:play_chore(mc_fishout_key_lookat_key_hold, "mc_fishout_key.cos")
    manny:wait_for_message()
    if sl.carla_scorned then
        carla:say_line("/slca185/")
    else
        carla:say_line("/slca186/")
    end
    manny:head_look_at(nil)
    manny:play_chore(mc_fishout_key_key_idle, "mc_fishout_key.cos")
    manny:wait_for_chore(mc_fishout_key_key_idle, "mc_fishout_key.cos")
    carla:wait_for_message()
    if not sl.bucket_actor then
        sl.bucket_actor = Actor:create(nil, nil, nil, "bucket")
    end
    sl.bucket_actor:put_in_set(sl)
    sl.bucket_actor:set_costume(nil)
    sl.bucket_actor:set_costume("mc_fishout_key.cos")
    sl.bucket_actor:play_chore(mc_fishout_key_key_basket_end, "mc_fishout_key.cos")
    sl.bucket_actor:put_at_object(sl.carla_obj)
    manny:pop_costume()
    manny:generic_pickup(sl.key)
    manny:head_look_at(nil)
    manny:walkto(-1.24249, 1.0503, -0.517538, 0, 359.056, 0)
    manny:wait_for_actor()
    gt:switch_to_set()
    manny:put_in_set(gt)
    manny:setpos(-1.27368, 6.07243, 19.7)
    manny:setrot(0, 265.643, 0)
    gt:force_camerachange()
    manny:walkto(-0.641409, 6.04704, 19.51, 0, 268.699, 0)
    END_CUT_SCENE()
    music_state:update()
end
sl.search_manny = function() -- line 272
    if manny.golden then
        stop_script(ci.liqueur.timer)
    end
    START_CUT_SCENE()
    start_script(sl.flash_gate_light, sl)
    stop_script(sl.carla_idle)
    sleep_for(500)
    if not sl.carla_scorned then
        sl.detector.actor:hide()
        start_script(carla.stand_up, carla)
    end
    if not sl.searched and not sl.carla_scorned then
        sl.searched = TRUE
        carla:say_line("/slca187/")
    end
    manny:setrot(0, -1228.67, 0, TRUE)
    wait_for_script(carla.stand_up)
    if not sl.carla_scorned then
        MakeSectorActive("carlawalk1", TRUE)
        carla:follow_boxes()
        carla:stop_chore(carla_stand_hold, sl.search_cos)
        carla:walkto(0.00688933, -0.983964, 0, 0, 310, 0)
        carla:wait_for_actor()
        carla:wait_for_message()
        enable_head_control(FALSE)
        carla:play_chore(carla_stand_hold, sl.search_cos)
        carla:say_line("/slca188/")
        sleep_for(1000)
        carla:setrot(0, 310, 0, TRUE)
        manny:walkto(0.198736, -0.710569, 0, 0, 170.362, 0)
        carla:wait_for_message()
        manny:wait_for_actor()
        carla:wait_for_actor()
    else
        carla:say_line("/slca188/")
        sleep_for(1000)
        start_script(manny.walk_and_face, manny, 0.248381, -0.5268, 0, 0, 275.391, 0)
        manny:head_look_at(sl.carla_obj)
        carla:wait_for_message()
        carla:say_line("/slca189/")
        carla:wait_for_message()
        manny:hand_gesture()
        manny:say_line("/slma190/")
        manny:wait_for_message()
        manny:head_look_at(nil)
    end
    END_CUT_SCENE()
    if not sl.carla_scorned then
        START_CUT_SCENE()
        if manny.is_holding then
            manny.is_holding:put_away()
        else
            manny:play_chore(mc_takeout_get, "mc.cos")
            manny:wait_for_chore()
        end
        IrisDown(225, 180, 700)
        sleep_for(1000)
        sl:draw_manny_inventory()
        manny:stop_chore(mc_takeout_get, "mc.cos")
        manny:push_costume("ma_charmer.cos")
        manny:play_chore(ma_charmer_searched, "ma_charmer.cos")
        if not manny.golden then
            carla:stop_chore(carla_stand_hold, sl.search_cos)
            carla:play_chore(carla_srch_mc, sl.search_cos)
            IrisUp(350, 250, 700)
            sleep_for(700)
            carla:wait_for_chore(carla_srch_mc, sl.search_cos)
            manny:wait_for_chore(ma_charmer_searched, "ma_charmer.cos")
            manny:pop_costume()
        end
        END_CUT_SCENE()
        if manny.golden then
            START_CUT_SCENE()
            carla:stop_chore(carla_stand_hold, sl.search_cos)
            carla:play_chore(carla_srch_shrg, sl.search_cos)
            IrisUp(350, 250, 700)
            sleep_for(1700)
            start_sfx("mdBeep.IMU")
            sleep_for(1500)
            stop_sound("mdBeep.IMU")
            sleep_for(800)
            carla:say_line("/slca191/")
            carla:wait_for_chore(carla_srch_shrg, sl.search_cos)
            manny:wait_for_chore(ma_charmer_searched, "ma_charmer.cos")
            carla:wait_for_message()
            manny:pop_costume()
            manny:twist_head_gesture()
            manny:say_line("/slma192/")
            manny:wait_for_message()
            carla:stop_chore(carla_srch_shrg, sl.search_cos)
            carla:play_chore(carla_show_detector, sl.search_cos)
            carla:say_line("/slca193/")
            carla:walkto(0.054836, -0.850169, 0, 0, 310.009, 0)
            carla:wait_for_actor()
            carla:stop_chore(carla_stand_hold, sl.search_cos)
            carla:play_chore(carla_says_turn, sl.search_cos)
            carla:wait_for_message()
            carla:wait_for_chore(carla_says_turn, sl.search_cos)
            manny:shrug_gesture()
            manny:say_line("/slma194/")
            manny:wait_for_message()
            manny:run_chore(mc_belch, "mc.cos")
            manny:stop_chore(mc_belch, "mc.cos")
            manny:shut_up()
            END_CUT_SCENE()
            sl:remove_manny_inventory()
            carla:stop_chore()
            carla:ignore_boxes()
            carla:head_look_at(nil)
            MakeSectorActive("carlawalk1", FALSE)
            Dialog:run("ca2", "dlg_car2.lua")
        else
            START_CUT_SCENE()
            carla:say_line("/slca196/")
            carla:wait_for_message()
            IrisDown(225, 180, 700)
            sleep_for(1000)
            sl:remove_manny_inventory()
            carla:stop_chore()
            carla:ignore_boxes()
            MakeSectorActive("carlawalk1", FALSE)
            carla:set_softimage_pos(9.1847, 0.1254, 7.5366)
            carla:setrot(0, 31.513, 0)
            carla:play_chore_looping(carla_sit_hold, sl.search_cos)
            carla:play_chore(carla_hide_detector, sl.search_cos)
            sl.detector.actor:show()
            carla.idle_state = "sit"
            manny:setrot(0, 283.584, 0)
            manny:head_look_at(sl.carla_obj)
            IrisUp(495, 230, 700)
            sleep_for(700)
            carla:say_line("/slca197/")
            carla:wait_for_message()
            start_script(sl.carla_idle, sl)
            END_CUT_SCENE()
        end
    else
        start_script(sl.carla_idle, sl)
    end
end
sl.flash_gate_light = function(arg1) -- line 435
    local local1
    start_sfx("slAlarm.WAV")
    local1 = 0
    while local1 < 2000 do
        sl.gate:complete_chore(0, "sl_light.cos")
        break_here()
        local1 = local1 + system.frameTime
        break_here()
        local1 = local1 + system.frameTime
        sl.gate:complete_chore(1, "sl_light.cos")
        break_here()
        local1 = local1 + system.frameTime
        break_here()
        local1 = local1 + system.frameTime
    end
end
carla.costume_marker_handler = function(arg1, arg2) -- line 454
    if arg2 == Actor.MARKER_LEFT_WALK or arg2 == Actor.MARKER_RIGHT_WALK then
        arg1:play_default_footstep(arg2, arg1.footsteps)
    end
end
sl.set_up_actors = function(arg1) -- line 460
    sl.search_cos = "carla_srch_chrm.cos"
    sl.cry_cos = "carla_cry.cos"
    carla:set_costume(nil)
    carla:set_costume(sl.cry_cos)
    carla:set_mumble_chore(carla_cry_mumble)
    carla:set_talk_chore(1, carla_cry_stop_talk)
    carla:set_talk_chore(2, carla_cry_a)
    carla:set_talk_chore(3, carla_cry_c)
    carla:set_talk_chore(4, carla_cry_e)
    carla:set_talk_chore(5, carla_cry_f)
    carla:set_talk_chore(6, carla_cry_l)
    carla:set_talk_chore(7, carla_cry_m)
    carla:set_talk_chore(8, carla_cry_o)
    carla:set_talk_chore(9, carla_cry_t)
    carla:set_talk_chore(10, carla_cry_u)
    carla:set_head(3, 4, 5, 165, 28, 80)
    carla:set_look_rate(110)
    carla:push_costume(sl.search_cos)
    carla:set_walk_chore(-1)
    carla:set_walk_rate(0.39)
    carla:set_turn_rate(170)
    carla:put_in_set(sl)
    carla:ignore_boxes()
    carla:set_softimage_pos(9.1847, 0.1254, 7.5366)
    carla:setrot(0, 31.513, 0)
    carla.footsteps = footsteps.marble
    carla:play_chore_looping(carla_sit_hold, sl.search_cos)
    carla.idle_state = "sit"
    if sl.detector.touchable then
        sl.detector.actor:show()
    else
        sl.detector.actor:hide()
    end
    start_script(sl.carla_idle)
end
sl.carla_idle = function(arg1) -- line 501
    while TRUE do
        sleep_for(rndint(5000, 8000))
        if rnd(6) and carla.idle_state == "prop" then
            carla:prop_tilt_head()
            sleep_for(rndint(5000, 8000))
            carla:prop_end_tilt_head()
        elseif rnd(8) then
            if carla.idle_state == "sit" then
                carla:go_to_prop()
            elseif carla.idle_state == "prop" then
                carla:go_to_sit()
            end
        end
    end
end
sl.carla_drinks_liqueur = function(arg1) -- line 519
    carla:say_line("/slca256/")
end
sl.carla_storm_out = function(arg1) -- line 523
    local local1, local2
    carla:setpos(1.04081, 0.332219, 0)
    carla:setrot(0, 200.013, 0)
    carla:stop_chore(carla_stand_hold, sl.search_cos)
    carla:ignore_boxes()
    local1 = 0
    carla:play_chore_looping(carla_walk, sl.search_cos)
    while local1 < 6000 do
        WalkActorForward(carla.hActor)
        break_here()
        local1 = local1 + system.frameTime
        local2 = carla:getpos()
        manny:head_look_at_point(local2.x, local2.y, local2.z + 0.40000001)
    end
    carla:stop_chore(carla_walk, sl.search_cos)
    carla:stop_chore(carla_stand_hold, sl.search_cos)
    carla:set_softimage_pos(9.1847, 0.12540001, 7.5366001)
    carla:setrot(0, 31.513, 0)
    carla:play_chore_looping(carla_sit_hold, sl.search_cos)
    sl.carla_scorned = TRUE
    carla.idle_state = "sit"
    start_script(sl.carla_idle, sl)
end
sl.manny_lunge_gesture1 = function(arg1) -- line 554
    manny:play_chore(manny_lunge_wait, "manny_lunge.cos")
    manny:wait_for_chore(manny_lunge_wait, "manny_lunge.cos")
    manny:stop_chore(manny_lunge_wait, "manny_lunge.cos")
    manny:play_chore(manny_lunge_sit, "manny_lunge.cos")
end
sl.manny_lunge_gesture2 = function(arg1) -- line 561
    manny:play_chore(manny_lunge_gesture, "manny_lunge.cos")
    manny:wait_for_chore(manny_lunge_gesture, "manny_lunge.cos")
    manny:stop_chore(manny_lunge_gesture, "manny_lunge.cos")
    manny:play_chore(manny_lunge_sit, "manny_lunge.cos")
end
manny.charm_point_gesture = function(arg1) -- line 568
    start_script(arg1.play_charm_gesture, arg1, ma_charmer_gesture)
end
manny.charm_nod_gesture = function(arg1) -- line 572
    start_script(arg1.play_charm_gesture, arg1, ma_charmer_head_nod_loop)
end
manny.play_charm_gesture = function(arg1, arg2) -- line 576
    arg1:play_chore(arg2, "ma_charmer.cos")
    arg1:wait_for_chore(arg2, "ma_charmer.cos")
    if arg2 == ma_charmer_gesture then
        arg1:play_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
        arg1:wait_for_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
    else
        arg1:stop_chore(arg2, "ma_charmer.cos")
    end
end
sl.enter = function(arg1) -- line 593
    sl:set_up_actors()
    if system.lastSet ~= gt then
        MakeSectorActive("intro_trigger", FALSE)
    elseif not sl.intro_trigger.seen then
        MakeSectorActive("intro_trigger", TRUE)
    end
    if hl.case.owner == manny then
        NewObjectState(sl_intha, OBJSTATE_STATE, "sl_hatch.bm", "sl_hatch.zbm")
        sl.safe:set_object_state("sl_hatch.cos")
    end
    NewObjectState(sl_intha, OBJSTATE_UNDERLAY, "sl_light.bm")
    sl.gate:set_object_state("sl_light.cos")
end
sl.exit = function(arg1) -- line 608
    stop_script(sl.carla_idle)
    carla:free()
    if sl.bucket_actor then
        sl.bucket_actor:free()
    end
end
sl.intro_trigger = { }
sl.intro_trigger.walkOut = function(arg1) -- line 625
    if not sl.intro_trigger.seen and system.lastSet == gt then
        sl.intro_trigger.seen = TRUE
        MakeSectorActive("intro_trigger", FALSE)
        stop_script(sl.carla_idle)
        START_CUT_SCENE("no head")
        set_override(sl.intro_trigger.skip_walkout, sl.intro_trigger)
        start_script(carla.go_to_prop, carla)
        carla:say_line("/slca198/")
        manny:walkto(-0.140429, -1.01301, 0)
        manny:wait_for_actor()
        manny:setrot(0, -794.132, 0, TRUE)
        manny:head_look_at(sl.carla_obj)
        carla:wait_for_message()
        manny:shrug_gesture()
        manny:say_line("/slma199/")
        wait_for_script(carla.go_to_prop)
        manny:wait_for_message()
        carla:prop_tilt_head()
        carla:say_line("/slca200/")
        carla:wait_for_message()
        carla:prop_end_tilt_head()
        carla:say_line("/slca201/")
        carla:wait_for_message()
        manny:head_look_at(nil)
        enable_head_control(TRUE)
        END_CUT_SCENE()
        start_script(sl.carla_idle)
    end
end
sl.intro_trigger.skip_walkout = function(arg1) -- line 658
    kill_override()
    manny:setpos(-0.140429, -1.01301, 0)
    manny:setrot(0, -794.132, 0)
    manny:head_look_at(nil)
    enable_head_control(TRUE)
    single_start_script(sl.carla_idle)
end
sl.key = Object:create(sl, "/sltx202/skeleton key", 0, 0, 0, { range = 0 })
sl.key.string_name = "key"
sl.key.wav = "getmekey.wav"
sl.key.lookAt = function(arg1) -- line 672
    manny:say_line("/slma203/")
end
sl.key.use = sl.key.lookAt
sl.key.default_response = function(arg1) -- line 678
    manny:say_line("/slma204/")
end
sl.detector = Object:create(sl, "/sltx207/metal detector", 0.67886001, -0.69790399, 0.26199999, { range = 0.60000002 })
sl.detector.string_name = "detector"
sl.detector.use_pnt_x = 0.374879
sl.detector.use_pnt_y = -0.62381101
sl.detector.use_pnt_z = 0
sl.detector.use_rot_x = 0
sl.detector.use_rot_y = -473.388
sl.detector.use_rot_z = 0
sl.detector.wav = "getMetl.wav"
sl.detector.lookAt = function(arg1) -- line 695
    if arg1.owner == manny then
        manny:say_line("/slma208/")
    else
        manny:say_line("/slma209/")
        manny:wait_for_message()
        carla:say_line("/slca210/")
    end
end
sl.detector.pickUp = function(arg1) -- line 705
    if not sl.talked_detectors then
        if manny:walkto_object(sl.carla_obj) then
            Dialog:run("ca1", "dlg_carla.lua", "detector")
        end
    elseif manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(mc_hand_on_obj, "mc.cos")
        manny:say_line("/slma211/")
        sleep_for(1500)
        FadeOutChore(manny.hActor, "mc.cos", mc_hand_on_obj, 500)
        carla:say_line("/slca212/")
        END_CUT_SCENE()
    end
end
sl.detector.use = function(arg1) -- line 723
    if arg1.owner == manny then
        START_CUT_SCENE()
        start_sfx("mdBeep.IMU")
        manny:say_line("/slma213/")
        manny:wait_for_message()
        stop_sound("mdBeep.IMU")
        END_CUT_SCENE()
    else
        arg1:pickUp()
    end
end
sl.detector.actor = Actor:create(nil, nil, nil, "metal detector")
sl.detector.actor.show = function(arg1) -- line 740
    if not arg1.initialized then
        arg1.initialized = TRUE
        arg1:set_costume("carla_srch_chrm.cos")
    end
    arg1:play_chore_looping(carla_detector_only)
    arg1:put_in_set(sl)
    arg1:set_softimage_pos(9.1847, 0.1254, 7.5366)
    arg1:setrot(0, 31.513, 0)
    arg1:set_visibility(TRUE)
end
sl.detector.actor.hide = function(arg1) -- line 752
    arg1:set_visibility(FALSE)
end
sl.escalator_box = Object:create(sl, "/sltx214/escalator box", 0, 0, 0, { range = 0 })
sl.escalator_box.walkOut = function(arg1) -- line 760
    if not sl.escalator_box.tried then
        START_CUT_SCENE()
        sl.escalator_box.tried = TRUE
        carla:say_line("/slca215/")
        carla:wait_for_message()
        manny:say_line("/slma216/")
        manny:wait_for_message()
        carla:say_line("/slca217/")
        carla:wait_for_message()
        manny:say_line("/slma218/")
        manny:wait_for_message()
        END_CUT_SCENE()
    end
    START_CUT_SCENE()
    carla:say_line("/slca219/")
    carla:wait_for_message()
    carla:say_line("/slca220/")
    END_CUT_SCENE()
end
sl.detector_box = Object:create(sl, "/sltx221/metal detector", 0, 0, 0, { range = 0 })
sl.detector_box.walkOut = function(arg1) -- line 783
    start_script(sl.search_manny)
end
sl.carla_obj = Object:create(sl, "/sltx222/Carla", 0.838404, -0.54134703, 0.34999999, { range = 0.69999999 })
sl.carla_obj.use_pnt_x = 0.37193999
sl.carla_obj.use_pnt_y = -0.61785001
sl.carla_obj.use_pnt_z = 0
sl.carla_obj.use_rot_x = 0
sl.carla_obj.use_rot_y = 270
sl.carla_obj.use_rot_z = 0
sl.carla_obj.lookAt = function(arg1) -- line 795
    manny:say_line("/slma223/")
end
sl.carla_obj.use = function(arg1) -- line 799
    if sl.carla_scorned then
        if not sl.detector.in_catbox then
            if manny:walkto_object(arg1) then
                START_CUT_SCENE()
                sl:current_setup(sl_diams)
                manny:push_costume("ma_charmer.cos")
                manny:play_chore(ma_charmer_start_charm, "ma_charmer.cos")
                start_script(carla.go_to_prop, carla)
                manny:wait_for_chore(ma_charmer_start_charm, "ma_charmer.cos")
                manny:stop_chore(ma_charmer_start_charm, "ma_charmer.cos")
                manny:play_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
                manny:wait_for_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
                manny:say_line("/slma224/")
                manny:wait_for_message()
                carla:say_line("/slca225/")
                carla:wait_for_message()
                manny:stop_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
                manny:play_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
                manny:wait_for_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
                manny:pop_costume()
                sl:current_setup(sl_intha)
                END_CUT_SCENE()
            end
        else
            manny:say_line("/slma226/")
            manny:wait_for_message()
            carla:say_line("/slca227/")
        end
    elseif manny:walkto_object(arg1) then
        Dialog:run("ca1", "dlg_carla.lua")
    end
end
sl.carla_obj.use_cigcase = function(arg1) -- line 837
    if manny:walkto_object(arg1) then
        Dialog:run("bo1", "dlg_bomb.lua")
    end
end
sl.carla_obj.use_liqueur = function(arg1) -- line 843
    if not sl.detector.in_catbox then
        start_script(carla.go_to_prop, carla)
        carla:say_line("/slca257/")
    else
        start_script(carla.go_to_sit, carla)
        carla:say_line("/slca258/")
    end
end
sl.carla_obj.pickUp = sl.carla_obj.use
sl.papers = Object:create(sl, "/sltx228/papers", 0.51840401, -0.91134697, 0.28999999, { range = 0.40000001 })
sl.papers.use_pnt_x = 0.375
sl.papers.use_pnt_y = -0.64633
sl.papers.use_pnt_z = 0
sl.papers.use_rot_x = 0
sl.papers.use_rot_y = -182.146
sl.papers.use_rot_z = 0
sl.papers.lookAt = function(arg1) -- line 863
    START_CUT_SCENE()
    manny:say_line("/slma229/")
    manny:wait_for_message()
    END_CUT_SCENE()
    carla:say_line("/slca230/")
end
sl.papers.pickUp = function(arg1) -- line 871
    carla:say_line("/slca231/")
end
sl.papers.use = sl.papers.pickUp
sl.safe = Object:create(sl, "/sltx232/safe", 0.73840398, -0.97134697, 0.0200001, { range = 0.44999999 })
sl.safe.use_pnt_x = 0.56884402
sl.safe.use_pnt_y = -1.06256
sl.safe.use_pnt_z = 0
sl.safe.use_rot_x = 0
sl.safe.use_rot_y = -63.6488
sl.safe.use_rot_z = 0
sl.safe.lookAt = function(arg1) -- line 886
    START_CUT_SCENE()
    if not arg1.seen then
        stop_script(sl.carla_idle)
        arg1.seen = TRUE
        manny:say_line("/slma233/")
        manny:wait_for_message()
        start_script(carla.go_to_sit)
        carla:say_line("/slca234/")
        wait_for_script(carla.go_to_sit)
        carla:wait_for_message()
        manny:say_line("/slma235/")
        manny:wait_for_message()
        carla:say_line("/slca236/")
        start_script(sl.carla_idle)
    else
        manny:say_line("/slma237/")
    end
    END_CUT_SCENE()
end
sl.safe.pickUp = function(arg1) -- line 907
    system.default_response("not portable")
end
sl.safe.use = function(arg1) -- line 911
    system.default_response("locked")
end
sl.safe.play_open_and_close = function(arg1, arg2) -- line 915
    arg1:play_chore(0)
    arg1:wait_for_chore()
    if arg2 then
        sleep_for(arg2)
    end
    arg1:play_chore(1)
    arg1:wait_for_chore()
end
sl.safe.play_explode = function(arg1) -- line 925
    arg1:play_chore(2)
    arg1:wait_for_chore()
end
sl.gate = Object:create(sl, "/sltx238/metal detector", 0.138404, -0.37134701, 0.72000003, { range = 0.74000001 })
sl.gate.use_pnt_x = 0.12059
sl.gate.use_pnt_y = -0.54001898
sl.gate.use_pnt_z = 0
sl.gate.use_rot_x = 0
sl.gate.use_rot_y = -2.8977301
sl.gate.use_rot_z = 0
sl.gate.lookAt = function(arg1) -- line 939
    manny:say_line("/slma239/")
end
sl.gate.pickUp = function(arg1) -- line 943
    system.default_response("not portable")
end
sl.gate.use = function(arg1) -- line 947
    manny:walkto(0.154136, -0.296585, 0)
end
sl.view = Object:create(sl, "/sltx240/view", 2.2633901, 1.1901, -1.4, { range = 1.9 })
sl.view.use_pnt_x = 1.25
sl.view.use_pnt_y = 0.67499799
sl.view.use_pnt_z = 0
sl.view.use_rot_x = 0
sl.view.use_rot_y = -63.568401
sl.view.use_rot_z = 0
sl.view.lookAt = function(arg1) -- line 960
    if sl.detector.in_catbox then
        manny:say_line("/slma241/")
    else
        manny:say_line("/slma242/")
    end
end
sl.view.use = function(arg1) -- line 968
    manny:say_line("/slma243/")
end
sl.lockers = Object:create(sl, "/sltx244/lockers", 1.0822999, 0.86180001, 0.46000001, { range = 0.60000002 })
sl.lockers.use_pnt_x = 0.95897502
sl.lockers.use_pnt_y = 0.58470702
sl.lockers.use_pnt_z = 0
sl.lockers.use_rot_x = 0
sl.lockers.use_rot_y = -379.21301
sl.lockers.use_rot_z = 0
sl.lockers.lookAt = function(arg1) -- line 980
    START_CUT_SCENE()
    manny:say_line("/slma245/")
    manny:wait_for_message()
    END_CUT_SCENE()
    manny:say_line("/slma246/")
    manny:wait_for_message()
    manny:say_line("/slma247/")
end
sl.lockers.use = function(arg1) -- line 990
    START_CUT_SCENE()
    manny:say_line("/slma248/")
    manny:wait_for_message()
    END_CUT_SCENE()
    carla:say_line("/slca249/")
end
sl.they1 = Object:create(sl, "/sltx250/they", 0.468404, -0.881347, 0.81999999, { range = 0 })
sl.they1:make_untouchable()
sl.they2 = Object:create(sl, "/sltx251/they", 0.56840402, -0.28134701, 0.81999999, { range = 0 })
sl.they2:make_untouchable()
sl.gt_door = Object:create(sl, "/sltx252/stairs", -1.1097, 1.47768, -0.38, { range = 1 })
sl.gt_door.use_pnt_x = -1.1999201
sl.gt_door.use_pnt_y = -0.035161398
sl.gt_door.use_pnt_z = 0
sl.gt_door.use_rot_x = 0
sl.gt_door.use_rot_y = 10
sl.gt_door.use_rot_z = 0
sl.gt_door.out_pnt_x = -1.11708
sl.gt_door.out_pnt_y = 0.82613999
sl.gt_door.out_pnt_z = -0.40660501
sl.gt_door.out_rot_x = 0
sl.gt_door.out_rot_y = 7.8907099
sl.gt_door.out_rot_z = 0
sl.gt_box = sl.gt_door
sl.gt_door.lookAt = function(arg1) -- line 1026
    manny:say_line("/slma253/")
end
sl.gt_door.walkOut = function(arg1) -- line 1030
    if sl.detector.in_catbox and not sl.said_goodbye then
        START_CUT_SCENE()
        sl.said_goodbye = TRUE
        manny:say_line("/slma254/")
        manny:wait_for_message()
        start_script(carla.go_to_sit, carla)
        carla:say_line("/slca255/")
        carla:wait_for_message()
        END_CUT_SCENE()
    end
    START_CUT_SCENE()
    gt:switch_to_set()
    gt:current_setup(gt_extst)
    PutActorInSet(system.currentActor.hActor, gt.setFile)
    manny:setpos(-1.55956, 5.7115, 19.8019)
    manny:setrot(0, -357.205, 0)
    SetActorConstrain(manny.hActor, FALSE)
    manny:walkto_object(gt.exit_pt, FALSE)
    END_CUT_SCENE()
end

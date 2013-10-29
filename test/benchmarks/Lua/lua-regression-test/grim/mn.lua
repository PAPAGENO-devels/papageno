CheckFirstTime("mn.lua")
dofile("chepito_drill.lua")
dofile("miner_idles.lua")
mn = Set:create("mn.set", "miners", { mn_noche = 0, mn_ovrhd = 1 })
mn.MAX_FRAME_TIME = 70
mn.miner_chis_min_vol = 15
mn.miner_chis_max_vol = 40
mn.miner_actors = { }
mn.miner_actors.freeze_count = 0
mn.miner_actors.parent = Actor
mn.miner_actors.create = function(arg1, arg2) -- line 27
    local local1
    local1 = Actor:create(nil, nil, nil, "Miner " .. arg2)
    local1.parent = mn.miner_actors
    local1.index = arg2
    local1.hIdle = nil
    return local1
end
mn.miner_actors.default = function(arg1) -- line 38
    local local1
    arg1:set_costume("miner_idles.cos")
    arg1:put_in_set(mn)
    arg1:setpos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    arg1:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
    if arg1.index == 1 then
        arg1.idle_chore = miner_idles_cm1_pick_cycle
    elseif arg1.index == 2 then
        arg1.idle_chore = miner_idles_cm2_axe_cycle
    elseif arg1.index == 3 then
        arg1.idle_chore = miner_idles_cm3_hammer_cycle
    elseif arg1.index == 4 then
        arg1.idle_chore = miner_idles_cm4_chisel_cycle
    end
    local1 = "miner_idles_cm" .. arg1.index .. "_rest2talk"
    arg1.to_talk_chore = getglobal(local1)
    local1 = "miner_idles_cm" .. arg1.index .. "_talk2rest"
    arg1.stop_talk_chore = getglobal(local1)
    arg1.hIdle = start_script(arg1.idle_script, arg1)
end
mn.miner_actors.idle_script = function(arg1) -- line 63
    if arg1.idle_chore == miner_idles_cm4_chisel_cycle then
        PrintDebug("Playing chisel sfx.\n")
        arg1:play_sound_at("minrchis.IMU", mn.miner_chis_min_vol, mn.miner_chis_max_vol)
    end
    arg1:play_chore_looping(arg1.idle_chore, "miner_idles.cos")
    if arg1.index ~= 3 then
        while system.currentSet == mn do
            sleep_for(rndint(5000, 10000))
            if system.frameTime > mn.MAX_FRAME_TIME and mn.miner_actors.freeze_count < 2 then
                mn.miner_actors.freeze_count = mn.miner_actors.freeze_count + 1
                if arg1.idle_chore == miner_idles_cm4_chisel_cycle then
                    PrintDebug("Fading chisel sfx.\n")
                    fade_sfx("minrchis.IMU", 250)
                end
                arg1:set_chore_looping(arg1.idle_chore, FALSE, "miner_idles.cos")
                arg1:wait_for_chore(arg1.idle_chore, "miner_idles.cos")
                if arg1.to_talk_chore then
                    arg1:play_chore(arg1.to_talk_chore, "miner_idles.cos")
                    arg1:wait_for_chore(arg1.to_talk_chore, "miner_idles.cos")
                    arg1:freeze()
                    while arg1.frozen do
                        sleep_for(rndint(10000, 20000))
                        if system.frameTime < mn.MAX_FRAME_TIME then
                            arg1:thaw(TRUE)
                            arg1:play_chore(arg1.stop_talk_chore, "miner_idles.cos")
                            arg1:wait_for_chore(arg1.stop_talk_chore, "miner_idles.cos")
                            mn.miner_actors.freeze_count = mn.miner_actors.freeze_count - 1
                        end
                    end
                end
                if arg1.idle_chore == miner_idles_cm4_chisel_cycle then
                    PrintDebug("Playing chisel sfx.\n")
                    arg1:play_sound_at("minrchis.IMU", mn.miner_chis_min_vol, mn.miner_chis_max_vol)
                end
                arg1:play_chore_looping(arg1.idle_chore, "miner_idles.cos")
            end
        end
    end
    arg1.hIdle = nil
end
chepito.grumbles = { }
chepito.grumbles["/mnch091/"] = 0.1
chepito.grumbles["/mnch092/"] = 0.1
chepito.grumbles["/mnch093/"] = 0.1
chepito.grumbles["/mnch094/"] = 0.2
chepito.grumbles["/mnch095/"] = 0.1
chepito.grumbles["/mnch096/"] = 0.1
chepito.grumbles["/mnch097/"] = 0.1
chepito.grumbles["/mnch098/"] = 0.050000001
chepito.grumbles["/mnch099/"] = 0.050000001
chepito.grumbles["/mnch100/"] = 0.1
chepito.hums = { "/mnch101/", "/mnch102/", "/mnch103/", "/mnch104/", "/mnch105/", "/mnch106/", "/mnch107/", "/mnch108/", "/mnch109/", "/mnch110/", "/mnch111/", "/mnch112/", "/mnch113/", "/mnch114/", "/mnch115/", "/mnch116/", "/mnch117/", "/mnch118/", "/mnch119/" }
mn.chepito_idles = function(arg1) -- line 144
    local local1, local2
    if not chepito.happy then
        chepito.facing_manny = FALSE
        start_sfx("chisel_c.IMU", IM_MED_PRIORITY, chepito.chisel_volume)
        chepito:play_chore_looping(chepito_drill_drill, "chepito_drill.cos")
        chepito.stop_idle = FALSE
        while not chepito.stop_idle do
            local1 = 0
            local2 = rndint(5000, 10000)
            while local1 < local2 and not chepito.stop_idle do
                break_here()
                local1 = local1 + system.frameTime
            end
            if rnd(6) and not chepito.stop_idle then
                chepito:set_chore_looping(chepito_drill_drill, FALSE, "chepito_drill.cos")
                chepito:wait_for_chore(chepito_drill_drill, "chepito_drill.cos")
                fade_sfx("chisel_c.IMU", 500, 0)
                chepito:play_chore(chepito_drill_look_drill, "chepito_drill.cos")
                chepito:wait_for_chore(chepito_drill_look_drill, "chepito_drill.cos")
                stop_sound("chisel_c.IMU")
                if not chepito.stop_idle then
                    start_sfx("chisel_c.IMU", IM_MED_PRIORITY, chepito.chisel_volume)
                    chepito:play_chore_looping(chepito_drill_drill, "chepito_drill.cos")
                end
            end
        end
    else
        chepito.facing_manny = FALSE
        chepito:play_chore_looping(chepito_drill_axe_mine, "chepito_drill.cos")
        chepito.stop_idle = FALSE
        while not chepito.stop_idle do
            local1 = 0
            local2 = rndint(5000, 10000)
            while local1 < local2 and not chepito.stop_idle do
                break_here()
                local1 = local1 + system.frameTime
            end
        end
    end
end
mn.chepito_stop_idle = function(arg1) -- line 188
    chepito.stop_idle = TRUE
    stop_script(mn.chepito_hums)
    stop_script(chepito.talk_randomly_from_weighted_table)
    while find_script(mn.chepito_idles) do
        break_here()
    end
    if not chepito.happy then
        chepito:set_chore_looping(chepito_drill_drill, FALSE, "chepito_drill.cos")
        fade_sfx("chisel_c.IMU", 500, 0)
        chepito:wait_for_chore(chepito_drill_drill, "chepito_drill.cos")
    else
        chepito:set_chore_looping(chepito_drill_axe_mine, FALSE, "chepito_drill.cos")
        chepito:wait_for_chore(chepito_drill_axe_mine, "chepito_drill.cos")
    end
end
mn.chepito_face_manny = function(arg1) -- line 207
    if not chepito.facing_manny then
        if not find_script(mn.chepito_stop_idle) then
            start_script(mn.chepito_stop_idle, mn)
        end
        while find_script(mn.chepito_stop_idle) do
            break_here()
        end
        if not chepito.happy then
            chepito:play_chore(chepito_drill_drill2look_mn, "chepito_drill.cos")
            chepito:wait_for_chore(chepito_drill_drill2look_mn, "chepito_drill.cos")
        else
            chepito:play_chore(chepito_drill_axe2look_mn, "chepito_drill.cos")
            chepito:wait_for_chore(chepito_drill_axe2look_mn, "chepito_drill.cos")
        end
        chepito.facing_manny = TRUE
    end
end
mn.chepito_stop_face_manny = function(arg1, arg2) -- line 228
    if chepito.facing_manny then
        if chepito.happy then
            chepito:play_chore(chepito_drill_mn2axe, "chepito_drill.cos")
            chepito:wait_for_chore(chepito_drill_mn2axe, "chepito_drill.cos")
            if not arg2 then
                start_script(mn.chepito_hums)
            end
        else
            chepito:play_chore(chepito_drill_mn2drill, "chepito_drill.cos")
            chepito:wait_for_chore(chepito_drill_mn2drill, "chepito_drill.cos")
            if not arg2 then
                start_script(chepito.talk_randomly_from_weighted_table, chepito, chepito.grumbles)
            end
        end
        chepito.facing_manny = FALSE
        start_script(mn.chepito_idles)
    end
end
mn.chepito_hums = function(arg1) -- line 248
    local local1
    sleep_for(2000)
    while 1 do
        local1 = random() * 2000
        sleep_for(local1)
        chepito:say_line(pick_one_of(chepito.hums), { background = TRUE, skip_log = TRUE })
        chepito:wait_for_message()
    end
end
mn.swap_tools = function(arg1) -- line 260
    cur_puzzle_state[36] = TRUE
    mn.chisel:get()
    fo.hammer:put_in_limbo()
    START_CUT_SCENE()
    manny:walkto_object(mn.chepito_obj)
    manny:head_forward_gesture()
    manny:say_line("/mnma120/")
    manny:wait_for_message()
    manny:say_line("/mnma121/")
    start_script(mn.chepito_stop_idle, mn)
    manny:wait_for_message()
    while find_script(mn.chepito_stop_idle) do
        break_here()
    end
    chepito:play_chore(chepito_drill_tlswtch2look_mn, "chepito_drill.cos")
    chepito:say_line("/mnch122/")
    chepito:wait_for_chore(chepito_drill_tlswtch2look_mn, "chepito_drill.cos")
    wait_for_message()
    chepito:say_line("/mnch123/")
    wait_for_message()
    manny:play_chore(mn2_give, "mn2.cos")
    manny:wait_for_chore(mn2_give, "mn2.cos")
    manny:stop_chore(manny.hold_chore, "mn2.cos")
    chepito:run_chore(chepito_drill_tlswtch_offr, "chepito_drill.cos")
    chepito:run_chore(chepito_drill_tlswtch_axe, "chepito_drill.cos")
    manny:generic_pickup(mn.chisel)
    manny:stop_chore(mn2_give, "mn2.cos")
    manny:stop_chore(mn2_hold, "mn2.cos")
    manny:play_chore(mn2_give_exit, "mn2.cos")
    chepito:run_chore(chepito_drill_tlswtch_2axe, "chepito_drill.cos")
    manny:wait_for_chore(mn2_give_exit, "mn2.cos")
    manny:stop_chore(mn2_give_exit, "mn2.cos")
    chepito.happy = TRUE
    chepito:say_line("/mnch124/")
    wait_for_message()
    chepito:say_line("/mnch125/")
    wait_for_message()
    chepito.facing_manny = FALSE
    start_script(mn.chepito_idles, mn)
    start_script(mn.chepito_hums, mn)
    END_CUT_SCENE()
end
mn.swap_stockings = function(arg1) -- line 304
    stop_script(chepito.talk_randomly_from_weighted_table)
    stop_script(mn.chepito_hums)
    cur_puzzle_state[38] = TRUE
    ar.stockings:free()
    START_CUT_SCENE()
    manny:walkto_object(mn.chepito_obj)
    manny:head_forward_gesture()
    manny:say_line("/mnma126/")
    manny:wait_for_message()
    manny:say_line("/mnma127/")
    start_script(mn.chepito_stop_idle, mn)
    manny:wait_for_message()
    while find_script(mn.chepito_stop_idle) do
        break_here()
    end
    if chepito.happy then
        chepito:run_chore(chepito_drill_axe2look_mn, "chepito_drill.cos")
        chepito:play_chore(chepito_drill_axe_2take, "chepito_drill.cos")
    else
        chepito:run_chore(chepito_drill_drill2look_mn, "chepito_drill.cos")
        chepito:play_chore(chepito_drill_drill_2take, "chepito_drill.cos")
    end
    chepito:say_line("/mnch128/")
    wait_for_message()
    chepito:say_line("/mnch129/")
    wait_for_message()
    manny:say_line("/mnma130/")
    manny:wait_for_message()
    chepito:say_line("/mnch131/")
    wait_for_message()
    if chepito.talked_gun then
        chepito:say_line("/mnch132/")
        wait_for_message()
        if chepito.happy then
            chepito:play_chore(chepito_drill_axe_gv_gun, "chepito_drill.cos")
        else
            chepito:play_chore(chepito_drill_drill_gv_gun, "chepito_drill.cos")
        end
        chepito:say_line("/mnch133/")
        manny:walkto(0.644639, -8.57646, 0, 0, -164, 0)
        manny:wait_for_actor()
        manny:stop_chore(manny.hold_chore, "mn2.cos")
        manny:play_chore(mn2_give, "mn2.cos")
        if chepito.happy then
            chepito:play_chore(chepito_drill_axe_gv_gun, "chepito_drill.cos")
        else
            chepito:play_chore(chepito_drill_drill_gv_gun, "chepito_drill.cos")
        end
        sleep_for(400)
        start_sfx("fi_grbgn.wav")
        sleep_for(400)
        manny:generic_pickup(mn.gun)
        manny:stop_chore(mn2_give, "mn2.cos")
        manny:play_chore(mn2_give_exit, "mn2.cos")
    else
        if ar.talked_gun then
            chepito:say_line("/mnch134/")
            wait_for_message()
            manny:say_line("/mnma135/")
            manny:wait_for_message()
            chepito:say_line("/mnch136/")
            wait_for_message()
            chepito:say_line("/mnch137/")
        else
            chepito:say_line("/mnch138/")
            wait_for_message()
            manny:say_line("/mnma139/")
            manny:wait_for_message()
            manny:say_line("/mnma140/")
        end
        wait_for_message()
        chepito:say_line("/mnch141/")
        manny:walkto(0.644639, -8.57646, 0, 0, -164, 0)
        manny:wait_for_actor()
        manny:stop_chore(manny.hold_chore, "mn2.cos")
        manny:play_chore(mn2_give, "mn2.cos")
        if chepito.happy then
            chepito:play_chore(chepito_drill_axe_gv_gun, "chepito_drill.cos")
        else
            chepito:play_chore(chepito_drill_drill_gv_gun, "chepito_drill.cos")
        end
        sleep_for(400)
        start_sfx("fi_grbgn.wav")
        sleep_for(400)
        manny:generic_pickup(mn.gun)
        manny:stop_chore(mn2_give, "mn2.cos")
        manny:play_chore(mn2_give_exit, "mn2.cos")
        sleep_for(500)
        wait_for_message()
        manny:say_line("/mnma142/")
    end
    wait_for_message()
    manny:wait_for_chore(mn2_give_exit, "mn2.cos")
    manny:stop_chore(mn2_give_exit, "mn2.cos")
    look_at_item_in_hand(FALSE)
    manny:say_line("/mnma143/")
    manny:wait_for_message()
    chepito:say_line("/mnch144/")
    wait_for_message()
    manny:head_look_at(nil)
    sleep_for(750)
    wait_for_message()
    chepito:say_line("/mnch145/")
    wait_for_message()
    END_CUT_SCENE()
    if chepito.happy then
        chepito:run_chore(chepito_drill_2axe, "chepito_drill.cos")
        start_script(mn.chepito_hums)
    else
        chepito:run_chore(chepito_drill_2drill, "chepito_drill.cos")
        start_script(chepito.talk_randomly_from_weighted_table, chepito, chepito.grumbles)
    end
    start_script(mn.chepito_idles, mn)
end
mn.turn_miner_to_manny = function(arg1, arg2) -- line 428
    local local1
    if arg2 == mn.miners then
        local1 = mn.miner_actors[1]
    elseif arg2 == mn.miners2 then
        local1 = mn.miner_actors[2]
    elseif arg2 == mn.miners4 then
        local1 = mn.miner_actors[4]
    end
    if local1 then
        if not local1.frozen and local1.hIdle then
            stop_script(local1.hIdle)
            if local1:is_choring(local1.idle_chore) then
                local1:set_chore_looping(local1.idle_chore, FALSE)
                local1:wait_for_chore(local1.idle_chore)
                local1:play_chore(local1.to_talk_chore)
                local1:wait_for_chore(local1.to_talk_chore)
                sleep_for(2000)
                local1:play_chore(local1.stop_talk_chore)
                local1:wait_for_chore(local1.stop_talk_chore)
                local1.hIdle = start_script(local1.idle_script, local1)
            end
        end
    end
end
mn.set_up_actors = function(arg1) -- line 456
    if not mn.miner_actors[1] then
        mn.miner_actors[1] = mn.miner_actors:create(1)
        mn.miner_actors[1].pos = { x = -0.917133, y = -3.99835, z = 0 }
        mn.miner_actors[1].rot = { x = 0, y = 41.4456, z = 0 }
    end
    if not mn.miner_actors[2] then
        mn.miner_actors[2] = mn.miner_actors:create(2)
        mn.miner_actors[2].pos = { x = 1.55367, y = -4.77994, z = 0 }
        mn.miner_actors[2].rot = { x = 0, y = 225.263, z = 0 }
    end
    if not mn.miner_actors[3] then
        mn.miner_actors[3] = mn.miner_actors:create(3)
        mn.miner_actors[3].pos = { x = -0.707733, y = -6.83975, z = 0.0155998 }
        mn.miner_actors[3].rot = { x = 0, y = 69.6433, z = 0 }
    end
    if not mn.miner_actors[4] then
        mn.miner_actors[4] = mn.miner_actors:create(4)
        mn.miner_actors[4].pos = { x = -2.51923, y = -2.93645, z = 2.4316 }
        mn.miner_actors[4].rot = { x = 0, y = 88.4529, z = 0 }
    end
    mn.miner_actors[1]:default()
    mn.miner_actors[2]:default()
    mn.miner_actors[3]:default()
    mn.miner_actors[4]:default()
    if dr.reunited then
        mn.chepito_obj:make_touchable()
        chepito:default()
        chepito:push_costume("chepito_drill.cos")
        chepito:put_in_set(mn)
        chepito:ignore_boxes()
        chepito:setpos(0.678937, -8.82255, 0)
        chepito:setrot(0, 260, 0)
        chepito:set_collision_mode(COLLISION_BOX, 0.6)
        single_start_script(su.chepito_light, su)
        chepito.chisel_volume = 60
        start_script(mn.chepito_idles, mn)
        if chepito.happy then
            start_script(mn.chepito_hums)
        else
            start_script(chepito.talk_randomly_from_weighted_table, chepito, chepito.grumbles)
        end
    else
        mn.chepito_obj:make_untouchable()
    end
    manny:set_collision_mode(COLLISION_SPHERE, 0.35)
end
mn.enter = function(arg1) -- line 516
    start_script(mn.set_up_actors)
    mn:add_ambient_sfx(underwater_ambience_list, underwater_ambience_parm_list)
end
mn.exit = function(arg1) -- line 521
    stop_sound("chisel_c.IMU")
    stop_sound("minrchis.IMU")
    mn.miner_actors[1]:free()
    mn.miner_actors[2]:free()
    mn.miner_actors[3]:free()
    mn.miner_actors[4]:free()
    stop_sound("bubvox.imu")
    manny:set_collision_mode(COLLISION_OFF)
    chepito:set_collision_mode(COLLISION_OFF)
    chepito:free()
    stop_script(mn.chepito_hums)
    stop_script(mn.chepito_idles)
    stop_script(chepito.talk_randomly_from_weighted_table)
    stop_script(su.chepito_light)
    stop_script(mn.miner_actors.idle_script)
end
mn.gun = Object:create(mn, "/mntx146/gun", 0, 0, 0, { range = 0 })
mn.gun.wav = "fi_grbgn.wav"
mn.gun.lookAt = function(arg1) -- line 550
    manny:say_line("/mnma147/")
end
mn.gun.use = function(arg1) -- line 554
    arg1:default_response()
end
mn.gun.default_response = function(arg1) -- line 561
    manny:say_line("/mnma149/")
end
mn.chisel = Object:create(mn, "/mntx150/chisel", 0, 0, 0, { range = 0 })
mn.chisel.wav = "getMetl.wav"
mn.chisel.lookAt = function(arg1) -- line 569
    manny:say_line("/mnma151/")
end
mn.chisel.use = function(arg1) -- line 573
    if system.currentSet.use_chisel then
        system.currentSet:use_chisel()
    else
        arg1:operate()
    end
end
mn.chisel.operate = function(arg1) -- line 581
    START_CUT_SCENE()
    manny:push_costume("mn_chisel.cos")
    manny:stop_chore(mn2_activate_chisel, "mn2.cos")
    manny:run_chore(mn_chisel_prepare_chisel, "mn_chisel.cos")
    manny:stop_chore(mn_chisel_prepare_chisel, "mn_chisel.cos")
    if in(system.currentSet:short_name(), Set.stereo_ring_sets) then
        start_sfx("chisel_c.IMU", IM_HIGH_PRIORITY, 127)
    else
        start_sfx("chiselmt.IMU", IM_HIGH_PRIORITY, 127)
    end
    manny:play_chore_looping(mn_chisel_use_chisel, "mn_chisel.cos")
    sleep_for(1000)
    if in(system.currentSet:short_name(), Set.stereo_ring_sets) then
        fade_sfx("chisel_c.IMU", 500)
    else
        fade_sfx("chiselmt.IMU", 500)
    end
    manny:stop_chore(mn_chisel_use_chisel, "mn_chisel.cos")
    manny:run_chore(mn_chisel_back_to_hold, "mn_chisel.cos")
    manny:play_chore_looping(mn2_activate_chisel, "mn2.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
mn.chisel.default_response = function(arg1) -- line 606
    manny:say_line("/mnma152/")
end
mn.miners = Object:create(mn, "/mntx153/miners", -0.80579901, -6.8529301, 0.102, { range = 1 })
mn.miners.use_pnt_x = -0.720164
mn.miners.use_pnt_y = -4.8496599
mn.miners.use_pnt_z = 0
mn.miners.use_rot_x = 0
mn.miners.use_rot_y = 792.23798
mn.miners.use_rot_z = 0
mn.miners.lookAt = function(arg1) -- line 619
    soft_script()
    manny:say_line("/mnma154/")
    manny:wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/mnma155/")
end
mn.miners.use = function(arg1) -- line 627
    START_CUT_SCENE()
    manny:head_forward_gesture()
    manny:say_line("/mnma156/")
    manny:wait_for_message()
    manny:say_line("/mnma157/")
    single_start_script(mn.turn_miner_to_manny, mn, arg1)
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/mnma158/")
    END_CUT_SCENE()
end
mn.miners.use_hammer = function(arg1) -- line 640
    manny:say_line("/mnma159/")
end
mn.miners.use_stockings = function(arg1) -- line 644
    manny:say_line("/mnma160/")
end
mn.miners.use_gun = function(arg1) -- line 648
    manny:say_line("/mnma161/")
end
mn.miners.use_chisel = function(arg1) -- line 652
    manny:say_line("/mnma162/")
end
mn.miners2 = Object:create(mn, "/mntx153/miners", -0.86689901, -4.0929298, 0.17309999, { range = 1 })
mn.miners2.parent = mn.miners
mn.miners3 = Object:create(mn, "/mntx153/miners", -2.2098999, -3.76913, 2, { range = 3.5 })
mn.miners3.parent = mn.miners
mn.miners4 = Object:create(mn, "/mntx153/miners", 1.5199, -4.8031301, 0.2448, { range = 2.5 })
mn.miners4.parent = mn.miners
mn.glow = Object:create(mn, "/mntx163/glowing patch", 1.24406, -9.0741196, 0.51999998, { range = 0.70999998 })
mn.glow.use_pnt_x = 0.72405797
mn.glow.use_pnt_y = -8.7741203
mn.glow.use_pnt_z = 0
mn.glow.use_rot_x = 0
mn.glow.use_rot_y = 244.127
mn.glow.use_rot_z = 0
mn.glow.lookAt = function(arg1) -- line 675
    manny:say_line("/mnma164/")
end
mn.glow.pickUp = function(arg1) -- line 679
    manny:say_line("/mnma165/")
end
mn.glow.use = mn.glow.pickUp
mn.glow.use_scythe = function(arg1) -- line 685
    manny:say_line("/mnma166/")
end
mn.glow.use_hammer = function(arg1) -- line 689
    manny:say_line("/mnma167/")
end
mn.chepito_obj = Object:create(mn, "/mntx168/Chepito", 0.67893702, -8.8225498, 0.3829, { range = 0.69999999 })
mn.chepito_obj.use_pnt_x = 0.55621701
mn.chepito_obj.use_pnt_y = -8.5006599
mn.chepito_obj.use_pnt_z = 0
mn.chepito_obj.use_rot_x = 0
mn.chepito_obj.use_rot_y = 202
mn.chepito_obj.use_rot_z = 0
mn.chepito_obj.lookAt = function(arg1) -- line 701
    if chepito.happy then
        manny:say_line("/mnma169/")
    else
        manny:say_line("/mnma170/")
    end
end
mn.chepito_obj.pickUp = function(arg1) -- line 709
    manny:twist_head_gesture()
    manny:say_line("/mnma171/")
end
mn.chepito_obj.use = function(arg1) -- line 714
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    Dialog:run("cp2", "dlg_chepito2.lua")
end
mn.chepito_obj.use_scythe = function(arg1) -- line 721
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    mn:chepito_face_manny()
    chepito:say_line("/mnch172/")
    chepito:wait_for_message()
    single_start_script(mn.chepito_stop_face_manny, mn)
    END_CUT_SCENE()
end
mn.chepito_obj.use_hammer = function(arg1) -- line 731
    start_script(mn.swap_tools)
end
mn.chepito_obj.use_gun = function(arg1) -- line 735
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    mn:chepito_face_manny()
    chepito:say_line("/mnch173/")
    chepito:wait_for_message()
    single_start_script(mn.chepito_stop_face_manny, mn)
    END_CUT_SCENE()
end
mn.chepito_obj.use_stockings = function(arg1) -- line 745
    start_script(mn.swap_stockings)
end
mn.chepito_obj.use_chisel = function(arg1) -- line 749
    manny:say_line("/mnma174/")
end
mn.ac_door = Object:create(mn, "/mntx175/lit path", 0.85188198, -10.0056, 0.43399999, { range = 0.80000001 })
mn.ac_door.use_pnt_x = 0.484721
mn.ac_door.use_pnt_y = -9.1301498
mn.ac_door.use_pnt_z = 0
mn.ac_door.use_rot_x = 0
mn.ac_door.use_rot_y = 211.037
mn.ac_door.use_rot_z = 0
mn.ac_door.out_pnt_x = 0.76903498
mn.ac_door.out_pnt_y = -9.9310904
mn.ac_door.out_pnt_z = 0
mn.ac_door.out_rot_x = 0
mn.ac_door.out_rot_y = 196.57201
mn.ac_door.out_rot_z = 0
mn.ac_box = mn.ac_door
mn.ac_door.walkOut = function(arg1) -- line 774
    if not ac.tried_walking then
        start_script(ac.walk_too_far, ac)
    else
        ac:come_out_door(ac.mn_door)
    end
end
mn.ac_door.lookAt = function(arg1) -- line 782
    manny:say_line("/mnma176/")
end
mn.ea_door = Object:create(mn, "lit pathway", 0.98783797, -0.169754, 0, { range = 0.60000002 })
mn.ea_door.use_pnt_x = 0.98783797
mn.ea_door.use_pnt_y = -0.169754
mn.ea_door.use_pnt_z = 0
mn.ea_door.use_rot_x = 0
mn.ea_door.use_rot_y = -372.38901
mn.ea_door.use_rot_z = 0
mn.ea_door.out_pnt_x = 0.98783797
mn.ea_door.out_pnt_y = -0.169754
mn.ea_door.out_pnt_z = 0
mn.ea_door.out_rot_x = 0
mn.ea_door.out_rot_y = -372.38901
mn.ea_door.out_rot_z = 0
mn.ea_box = mn.ea_door
mn.ea_door.walkOut = function(arg1) -- line 803
    ea:come_out_door(ea.mn_door)
end
mn.ea_door.lookAt = function(arg1) -- line 807
    manny:say_line("/mnma177/")
end

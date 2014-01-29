CheckFirstTime("lm.lua")
dofile("ve_talks_to_ma.lua")
lm = Set:create("lm.set", "Limbo Dock", { lm_top = 0, lm_velws = 1, lm_gngms = 2, lm_nolim = 3 })
velasco.face_manny = function(arg1) -- line 14
    if find_script(velasco.face_bottle) then
        wait_for_script(velasco.face_bottle)
    end
    velasco:run_chore(ve_talks_to_ma_stop_tinker, "ve_talks_to_ma.cos")
    velasco:stop_chore(ve_talks_to_ma_tinker, "ve_talks_to_ma.cos")
    velasco:run_chore(ve_talks_to_ma_turn_around, "ve_talks_to_ma.cos")
    velasco:stop_chore(ve_talks_to_ma_turn_around, "ve_talks_to_ma.cos")
    velasco:play_chore(ve_talks_to_ma_face_manny, "ve_talks_to_ma.cos")
    velasco.facing_manny = TRUE
end
velasco.face_bottle = function(arg1) -- line 27
    if find_script(velasco.face_manny) then
        wait_for_script(velasco.face_manny)
    end
    velasco.facing_manny = FALSE
    stop_script(velasco.stop_special_talk)
    velasco:stop_chore(ve_talks_to_ma_talk_idle, "ve_talks_to_ma.cos")
    velasco:stop_chore(ve_talks_to_ma_talk2, "ve_talks_to_ma.cos")
    velasco:head_look_at(nil)
    velasco:run_chore(ve_talks_to_ma_back_and_tinker, "ve_talks_to_ma.cos")
    velasco:play_chore_looping(ve_talks_to_ma_tinker, "ve_talks_to_ma.cos")
end
velasco.stop_special_talk = function(arg1, arg2) -- line 41
    velasco:wait_for_message()
    wait_for_script(velasco.face_bottle)
    wait_for_script(velasco.face_manny)
    velasco:set_chore_looping(arg2, FALSE, "ve_talks_to_ma.cos")
    velasco:stop_chore(arg2, "ve_talks_to_ma.cos")
    if velasco.facing_manny then
        velasco:play_chore(ve_talks_to_ma_face_manny, "ve_talks_to_ma.cos")
    end
end
velasco.say_line = function(arg1, arg2) -- line 54
    local local1
    PrintDebug("in velasco say line.\n")
    if velasco:get_costume() == "ve_talks_to_ma.cos" and velasco.facing_manny then
        local1 = pick_one_of({ ve_talks_to_ma_talk_idle, ve_talks_to_ma_talk2 })
        velasco:play_chore_looping(local1, "ve_talks_to_ma.cos")
        arg1.parent.say_line(velasco, arg2)
        single_start_script(velasco.stop_special_talk, velasco, local1)
    else
        arg1.parent.say_line(velasco, arg2)
    end
end
lm.reunion = function() -- line 68
    local local1 = velasco:getpos()
    START_CUT_SCENE()
    velasco:follow_boxes()
    lm.velasco_gone = TRUE
    manny:walkto(-0.35399899, -2.6442599, 0.015, 0, -113, 0)
    sleep_for(400)
    local1.z = local1.z + 0.44999999
    manny:head_look_at_point(local1)
    velasco:say_line("/lmve146/")
    velasco:head_look_at_manny()
    velasco:set_chore_looping(velasco_idles_rocking, FALSE)
    velasco:wait_for_chore()
    velasco:push_chore(velasco_idles_down_from_toes)
    velasco:push_chore()
    wait_for_message()
    manny:wait_for_actor()
    velasco:play_chore(velasco_stand, "velasco.cos")
    velasco:say_line("/lmve147/")
    velasco:wait_for_chore()
    wait_for_message()
    manny:say_line("/lmma148/")
    velasco:push_chore(velasco_idles_up_on_toes)
    velasco:push_chore()
    velasco:push_chore(velasco_idles_rocking, TRUE)
    wait_for_message()
    manny:say_line("/lmma149/")
    wait_for_message()
    velasco:say_line("/lmve150/")
    velasco:head_look_at(nil)
    velasco:set_chore_looping(velasco_idles_rocking, FALSE)
    wait_for_message()
    velasco:say_line("/lmve151/")
    velasco:wait_for_chore()
    velasco:play_chore(velasco_idles_down_from_toes)
    velasco:wait_for_chore()
    velasco:pop_costume()
    velasco:play_chore(velasco_stand)
    wait_for_message()
    velasco:say_line("/lmve152/")
    velasco:head_look_at_manny()
    wait_for_message()
    manny:say_line("/lmma153/")
    wait_for_message()
    velasco:say_line("/lmve154/")
    velasco:head_look_at(nil)
    velasco:set_walk_chore(velasco_walk)
    wait_for_message()
    velasco:say_line("/lmve155/")
    wait_for_message()
    velasco:walkto(-1.08558, -1.75564, 0.015)
    manny:say_line("/lmma156/")
    wait_for_message()
    velasco:say_line("/lmve157/")
    wait_for_message()
    velasco:say_line("/lmve158/")
    wait_for_message()
    sleep_for(500)
    manny:head_look_at(nil)
    manny:tilt_head_gesture()
    manny:say_line("/lmma159/")
    velasco:free()
    END_CUT_SCENE()
end
lm.check_status = function(arg1) -- line 135
    local local1 = made_vacancy
    local local2 = hh.union_card.owner == manny
    local local3 = dd.strike_on
    START_CUT_SCENE()
    IrisDown(0, 0, 1)
    manny:setpos(-0.0231068, -2.6798899, 0.0099999998)
    manny:setrot(0, -120, 0)
    velasco:stop_chore(ve_talks_to_ma_tinker)
    velasco:play_chore(ve_talks_to_ma_face_manny, "ve_talks_to_ma.cos")
    velasco.facing_manny = TRUE
    IrisUp(320, 200, 1000)
    break_here()
    if local1 and not lm.checked_off_vacancy then
        lm.checked_off_vacancy = TRUE
        manny:say_line("/lmma077/")
        wait_for_message()
        velasco:say_line("/lmve078/")
        wait_for_message()
        velasco:say_line("/lmve079/")
        wait_for_message()
        manny:say_line("/lmma080/")
        wait_for_message()
        velasco:say_line("/lmve081/")
        wait_for_message()
    end
    if local3 and not lm.checked_off_tools then
        lm.checked_off_tools = TRUE
        velasco:say_line("/lmve082/")
        wait_for_message()
        manny:say_line("/lmma083/")
        wait_for_message()
        manny:say_line("/lmma084/")
        wait_for_message()
        velasco:say_line("/lmve085/")
        wait_for_message()
    end
    if local2 and not lm.checked_off_card then
        lm.checked_off_card = TRUE
        velasco:say_line("/lmve086/")
        wait_for_message()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = hh.union_card
        close_inventory()
        velasco:say_line("/lmve087/")
        wait_for_message()
        velasco:say_line("/lmve088/")
        wait_for_message()
        velasco:say_line("/lmve089/")
        open_inventory(TRUE, TRUE)
        manny.is_holding = nil
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
        end
    end
    wait_for_message()
    END_CUT_SCENE()
    lm:talk_progress(local1, local2, local3)
end
lm.talk_progress = function(arg1, arg2, arg3, arg4) -- line 203
    START_CUT_SCENE()
    if arg2 and arg3 and arg4 then
        lm.talked_readiness = TRUE
        velasco:say_line("/lmve090/")
        wait_for_message()
        velasco:say_line("/lmve091/")
        wait_for_message()
        manny:say_line("/lmma092/")
        wait_for_message()
        manny:say_line("/lmma093/")
        wait_for_message()
        velasco:say_line("/lmve094/")
        wait_for_message()
    else
        if lm.talked_naranja and not arg2 then
            velasco:say_line("/lmve095/")
            wait_for_message()
            if si.naranja_out then
                velasco:say_line("/lmve096/")
            else
                velasco:say_line("/lmve097/")
            end
            wait_for_message()
            manny:say_line("/lmma098/")
            wait_for_message()
            velasco:say_line("/lmve099/")
            wait_for_message()
        end
        if lm.talked_union and not arg3 then
            velasco:say_line("/lmve100/")
            wait_for_message()
            manny:say_line("/lmma101/")
            wait_for_message()
            velasco:say_line("/lmve102/")
        end
        if lm.talked_tools and not arg4 then
            velasco:say_line("/lmve103/")
            wait_for_message()
            manny:say_line("/lmma104/")
            wait_for_message()
            velasco:say_line("/lmve105/")
        end
    end
    wait_for_message()
    start_script(velasco.face_bottle)
    velasco:say_line("/lmve106/")
    wait_for_message()
    manny:say_line("/lmma107/")
    END_CUT_SCENE()
end
lm.set_up_actors = function(arg1) -- line 257
    if lm.bottle.owner ~= manny then
        if not ship_bottle_actor then
            ship_bottle_actor = Actor:create(nil, nil, nil, "bottle")
        end
        ship_bottle_actor:set_costume("ship_bottle.cos")
        ship_bottle_actor:put_in_set(lm)
        ship_bottle_actor:setpos(0.379959, -3.12955, 0.2457)
        ship_bottle_actor:setrot(89, 270, 0)
    end
    if not lm.velasco_gone then
        velasco:default()
        velasco:put_in_set(lm)
        velasco:ignore_boxes()
        velasco:setpos(0.40248, -2.88345, 0.02539)
        velasco:setrot(0, 160, 0)
        if in_year_four then
            velasco:setpos(0.285, -2.8725, 0.015)
            velasco:setrot(0, 102, 0)
            velasco:push_costume("velasco_idles.cos")
            velasco:play_chore_looping(velasco_idles_rocking)
        else
            velasco:push_costume("ve_talks_to_ma.cos")
            velasco:play_chore_looping(ve_talks_to_ma_tinker, "ve_talks_to_ma.cos")
        end
        velasco.footsteps = footsteps.creak
    end
end
lm.enter = function(arg1) -- line 292
    lm:current_setup(lm_gngms)
    if not in_year_four then
        lm.water.hObjectState = lm:add_object_state(lm_gngms, "lm_water1.bm", nil, OBJSTATE_UNDERLAY)
    else
        lm.water.hObjectState = lm:add_object_state(lm_nolim, "lm_water1.bm", nil, OBJSTATE_UNDERLAY)
    end
    lm.water:set_object_state("lm_water.cos")
    lm.water:play_chore_looping(0)
    if not find_script(cut_scene.idcorpse) then
        lm:set_up_actors()
        if not in_year_four then
            box_on("lm_gngms")
            box_off("lm_nolim")
            if lm.talked_naranja then
                if ve2 then
                    ve2[180].off = FALSE
                end
            end
            if made_vacancy and not lm.checked_off_vacancy or (dd.strike_on and not lm.checked_off_tools) or (hh.union_card.owner == manny and not lm.checked_off_card) then
                start_script(lm.check_status)
            end
        else
            box_off("lm_gngms")
            box_on("lm_nolim")
            lm.limbo:make_untouchable()
            lm.velasco_obj:make_untouchable()
            lm.bottle.range = 0.7
        end
    end
    start_loop_sfx("waterlap.IMU")
    set_vol("waterlap.IMU", 50)
    start_script(foghorn_sfx)
    lm:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 100, 400, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(velasco.hActor, 0)
    SetActorShadowPoint(velasco.hActor, 100, 400, 6000)
    SetActorShadowPlane(velasco.hActor, "shadow1")
    AddShadowPlane(velasco.hActor, "shadow1")
end
lm.exit = function(arg1) -- line 345
    stop_script(foghorn_sfx)
    fade_sfx("waterlap.IMU")
    sleep_for(1000)
    stop_sound("waterlap.IMU")
    if not find_script(cut_scene.idcorpse) then
        velasco:free()
    end
    ship_bottle_actor:free()
    KillActorShadows(manny.hActor)
    KillActorShadows(velasco.hActor)
end
lm.water = Object:create(lm, "", 0, 0, 0, { range = 0 })
lm.spooky_zone = { }
lm.spooky_zone.walkOut = function(arg1) -- line 371
    sleep_for(1000)
    manny:say_line("/lmma108/")
end
lm.velasco_obj = Object:create(lm, "/lmtx109/Velasco", 0.468817, -3.0226099, 0.43000001, { range = 0.89999998 })
lm.velasco_obj.use_pnt_x = 0.063828997
lm.velasco_obj.use_pnt_y = -2.7193301
lm.velasco_obj.use_pnt_z = 0.015
lm.velasco_obj.use_rot_x = 0
lm.velasco_obj.use_rot_y = -157.371
lm.velasco_obj.use_rot_z = 0
lm.velasco_obj.lookAt = function(arg1) -- line 385
    START_CUT_SCENE()
    manny:say_line("/lmma110/")
    wait_for_message()
    velasco:say_line("/lmve111/")
    END_CUT_SCENE()
end
lm.velasco_obj.pickUp = function(arg1) -- line 393
    soft_script()
    manny:say_line("/lmma112/")
    wait_for_message()
    velasco:say_line("/lmve113/")
end
lm.velasco_obj.use = function(arg1) -- line 400
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    Dialog:run("ve2", "dlg_vel2.lua")
end
lm.velasco_obj.use_union_card = function(arg1) -- line 407
    soft_script()
    velasco:say_line("/lmve114/")
end
lm.bottle = Object:create(lm, "/lmtx115/bottle", 0.528817, -3.0726099, 0.27000001, { range = 0.60000002 })
lm.bottle.use_pnt_x = 0.187002
lm.bottle.use_pnt_y = -3.1379499
lm.bottle.use_pnt_z = 0.015
lm.bottle.use_rot_x = 0
lm.bottle.use_rot_y = -55.056801
lm.bottle.use_rot_z = 0
lm.bottle.wav = "getBotl.wav"
lm.bottle.lookAt = function(arg1) -- line 421
    if not in_year_four then
        START_CUT_SCENE()
        manny:say_line("/lmma116/")
        wait_for_message()
        velasco:say_line("/lmve117/")
        END_CUT_SCENE()
    elseif lm.bottle.full then
        manny:say_line("/lmma160/")
    else
        manny:say_line("/lmma161/")
    end
end
lm.bottle.pickUp = function(arg1) -- line 437
    if not in_year_four then
        manny:say_line("/lmma118/")
        wait_for_message()
        velasco:say_line("/lmve119/")
    elseif tim_was_wrong then
        manny:say_line("/lmma165/")
    else
        manny:say_line("/lmma162/")
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:play_chore(ms_reach_med, manny.base_costume)
        sleep_for(400)
        start_sfx("lmGetBot.wav")
        sleep_for(404)
        ship_bottle_actor:free()
        lm.bottle:get()
        manny.hold_chore = msb_activate_empty_bottle
        manny:play_chore_looping(manny.hold_chore, manny.base_costume)
        manny:play_chore_looping(ms_hold, manny.base_costume)
        manny.is_holding = arg1
        manny:wait_for_chore()
        END_CUT_SCENE()
    end
end
lm.bottle.use = function(arg1) -- line 464
    if in_year_four then
        if arg1.owner == manny then
            manny:say_line("/lmma163/")
        else
            arg1:pickUp()
        end
    else
        START_CUT_SCENE()
        manny:say_line("/lmma120/")
        wait_for_message()
        velasco:say_line("/lmve121/")
        wait_for_message()
        velasco:say_line("/lmve122/")
        END_CUT_SCENE()
    end
end
lm.gate = Object:create(lm, "/lmtx123/gate", 0.32881701, -0.87260598, 0.47, { range = 0.80000001 })
lm.gate.use_pnt_x = 0.305531
lm.gate.use_pnt_y = -1.30925
lm.gate.use_pnt_z = 0.015
lm.gate.use_rot_x = 0
lm.gate.use_rot_y = 1814.23
lm.gate.use_rot_z = 0
lm.gate.lookAt = function(arg1) -- line 490
    START_CUT_SCENE()
    system.default_response("locked")
    if not in_year_four then
        wait_for_message()
        velasco:say_line("/lmve124/")
    end
    END_CUT_SCENE()
end
lm.gate.use = lm.gate.lookAt
lm.limbo = Object:create(lm, "/lmtx125/limbo", 1.42882, -1.2726099, 1.28, { range = 1.8 })
lm.limbo.use_pnt_x = 0.289051
lm.limbo.use_pnt_y = -1.61446
lm.limbo.use_pnt_z = 0.015
lm.limbo.use_rot_x = 0
lm.limbo.use_rot_y = 1752.96
lm.limbo.use_rot_z = 0
lm.limbo.lookAt = function(arg1) -- line 510
    manny:say_line("/lmma126/")
end
lm.limbo.pickUp = function(arg1) -- line 514
    manny:say_line("/lmma127/")
end
lm.limbo.use = function(arg1) -- line 518
    START_CUT_SCENE()
    manny:say_line("/lmma128/")
    wait_for_message()
    manny:head_look_at_point(manny:getpos())
    manny:say_line("/lmma129/")
    wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
lm.moon = Object:create(lm, "/lmtx130/moon", -1.27118, 1.12739, 1.6799999, { range = 2.6199999 })
lm.moon.use_pnt_x = -0.243466
lm.moon.use_pnt_y = -0.610349
lm.moon.use_pnt_z = 0.015
lm.moon.use_rot_x = 0
lm.moon.use_rot_y = 1818.49
lm.moon.use_rot_z = 0
lm.moon.immediate = TRUE
lm.moon.lookAt = function(arg1) -- line 539
    START_CUT_SCENE()
    if not in_year_four then
        velasco:set_speech_mode(MODE_BACKGROUND)
    end
    if lm.read_poem and not in_year_four then
        manny:say_line("/lmma131/")
        manny:wait_for_message()
        sleep_for(500)
    end
    music_state:set_state(stateLM_POEM)
    manny:say_line("/lmma132/")
    if lm.read_poem and not in_year_four then
        velasco:say_line("/lmve133/")
    end
    manny:wait_for_message()
    manny:say_line("/lmma134/")
    if lm.read_poem and not in_year_four then
        velasco:say_line("/lmve135/")
    end
    manny:wait_for_message()
    manny:say_line("/lmma136/")
    if lm.read_poem and not in_year_four then
        velasco:say_line("/lmve137/")
    end
    manny:wait_for_message()
    manny:say_line("/lmma138/")
    if not in_year_four then
        velasco:say_line("/lmve139/")
    end
    manny:wait_for_message()
    manny:say_line("/lmma140/")
    if not in_year_four then
        velasco:say_line("/lmve141/")
    end
    manny:wait_for_message()
    manny:say_line("/lmma142/")
    if not in_year_four then
        velasco:say_line("/lmve143/")
    end
    wait_for_message()
    music_state:set_state(stateLM)
    if lm.read_poem and not in_year_four then
        velasco:head_look_at(nil)
    end
    if in_year_four then
        manny:say_line("/lmma164/")
    end
    if not in_year_four then
        velasco:set_speech_mode(MODE_NORMAL)
    end
    lm.read_poem = TRUE
    END_CUT_SCENE()
end
lm.moon.use = function(arg1) -- line 603
    manny:say_line("/lmma144/")
end
lm.moon.pickUp = lm.moon.use
lm.hb_door = Object:create(lm, "/lmtx145/gangplank", -1.01118, -1.88261, 0.46000001, { range = 0.60000002 })
lm.hb_door.use_pnt_x = -0.59510797
lm.hb_door.use_pnt_y = -1.8489
lm.hb_door.use_pnt_z = 0.015
lm.hb_door.use_rot_x = 0
lm.hb_door.use_rot_y = 1553.39
lm.hb_door.use_rot_z = 0
lm.hb_door.out_pnt_x = -0.83130503
lm.hb_door.out_pnt_y = -1.87475
lm.hb_door.out_pnt_z = 0.015
lm.hb_door.out_rot_x = 0
lm.hb_door.out_rot_y = 1529.89
lm.hb_door.out_rot_z = 0
lm.hb_door.walkOut = function(arg1) -- line 629
    hb:come_out_door(hb.lm_door)
end
lm.hb_door:make_untouchable()

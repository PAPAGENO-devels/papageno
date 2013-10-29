CheckFirstTime("cy.lua")
dofile("conv_belt.lua")
dofile("ma_climb_conveyor.lua")
cy = Set:create("cy.set", "conveyor", { cy_surla = 0, cy_ovrhd = 1 })
cy.chain_drift_bottom = { }
cy.chain_drift_bottom.pos = { x = -0.117418, y = 4.5833, z = 0.517712 }
cy.chain_drift_bottom.rot = { x = 45, y = 0.0180664, z = 0 }
cy.chain_drift_top = { }
cy.chain_drift_top.pos = { x = -0.117507, y = 4.86603, z = 0.800555 }
cy.chain_drift_top.rot = { x = 45, y = 359.179, z = 0 }
cy.chain_drift_end = { }
cy.chain_drift_end.pos = { x = -0.0624409, y = 4.01491, z = 0.23 }
cy.chain_drift_end.rot = { x = 0, y = 5.72274, z = 0 }
cy.chain_abort_bottom = 0.4
cy.chain_abort_top = 1.5
cy.loop_vol = 30
cy.drift_to_chain = function(arg1) -- line 30
    START_CUT_SCENE()
    cy.drifting = TRUE
    cy.prev_button_handler = system.buttonHandler
    system.buttonHandler = cy.drift_button_handler
    manny:ignore_boxes()
    manny:push_costume("mn_conveyor.cos")
    start_script(cy.manny_drift_to, cy, cy.chain_drift_bottom.pos, cy.chain_drift_bottom.rot, 20)
    FadeInChore(manny.hActor, "mn_conveyor.cos", mn_conveyor_drift, 1000)
    sleep_for(1000)
    manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
    END_CUT_SCENE()
end
cy.end_drift_gracefully = function(arg1) -- line 47
    if cy.drifting then
        START_CUT_SCENE()
        start_script(cy.manny_drift_to, cy, cy.chain_drift_end.pos, cy.chain_drift_end.rot, 20)
        manny:set_chore_looping(mn_conveyor_drift, FALSE, "mn_conveyor.cos")
        FadeOutChore(manny.hActor, "mn_conveyor.cos", mn_conveyor_drift, 1000)
        sleep_for(1000)
        wait_for_script(cy.manny_drift_to)
        cy:stop_drifting()
        END_CUT_SCENE()
        manny:set_run(FALSE)
        manny:force_auto_run(FALSE)
    end
end
cy.start_drifting = function(arg1, arg2) -- line 62
    cy:switch_to_set()
    cy.drifting = TRUE
    cy.prev_button_handler = system.buttonHandler
    system.buttonHandler = cy.drift_button_handler
    inventory_disabled = TRUE
    manny:set_run(FALSE)
    manny:force_auto_run(FALSE)
    manny:push_costume("mn_conveyor.cos")
    manny:put_in_set(cy)
    manny:ignore_boxes()
    if not arg2 then
        manny:setpos(cy.chain_drift_top.pos.x, cy.chain_drift_top.pos.y, cy.chain_drift_top.pos.z)
        manny:setrot(cy.chain_drift_top.rot.x, cy.chain_drift_top.rot.y, cy.chain_drift_top.rot.z)
    else
        manny:setpos(cy.chain_drift_bottom.pos.x, cy.chain_drift_bottom.pos.y, cy.chain_drift_bottom.pos.z)
        manny:setrot(cy.chain_drift_bottom.rot.x, cy.chain_drift_bottom.rot.y, cy.chain_drift_bottom.rot.z)
    end
    manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
end
cy.stop_drifting = function(arg1) -- line 85
    if cy.drifting then
        cy.drifting = FALSE
        manny:follow_boxes()
        manny:pop_costume()
        manny:set_run(FALSE)
        manny:force_auto_run(FALSE)
        stop_movement_scripts()
        manny:stop_chore(mn2_run, "mn2.cos")
        if cy.prev_button_handler ~= nil and cy.prev_button_handler ~= cy.drift_button_handler then
            system.buttonHandler = cy.prev_button_handler
        else
            system.buttonHandler = SampleButtonHandler
        end
        inventory_disabled = FALSE
    end
end
cy.drift_button_handler = function(arg1, arg2, arg3) -- line 106
    local local1
    local1 = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if control_map.INVENTORY[arg1] and arg2 then
        system.default_response("not now")
    elseif control_map.MOVE_FORWARD[arg1] and arg2 then
        single_start_script(cy.manny_climb_up_chain, cy)
    elseif control_map.MOVE_BACKWARD[arg1] and arg2 then
        single_start_script(cy.manny_climb_down_chain, cy)
    elseif control_map.LOOK_AT[arg1] and arg2 and not local1 then
        if hot_object then
            start_script(Sentence, "lookAt", hot_object)
        else
            PrintDebug("No hot object!\n")
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
cy.manny_climb_up_chain = function(arg1) -- line 129
    local local1, local2, local3, local4
    stop_script(cy.manny_climb_down_chain)
    local4 = FALSE
    while get_generic_control_state("MOVE_FORWARD") and not local4 do
        local2 = manny:getpos()
        local1 = { x = 0, y = 0.40000001, z = 0 }
        local3 = cy.chain_drift_bottom.rot
        local1 = RotateVector(local1, local3)
        local1.x = local1.x + local2.x
        local1.y = local1.y + local2.y
        local1.z = local1.z + local2.z
        manny:stop_chore(mn_conveyor_drift, "mn_conveyor.cos")
        manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
        manny:play_chore_looping(mn_conveyor_crawl, "mn_conveyor.cos")
        cy:manny_drift_to(local1, nil, 20, TRUE)
        break_here()
        local2 = manny:getpos()
        if local2.z >= cy.chain_abort_top then
            local4 = TRUE
        end
    end
    if not local4 then
        start_script(ac.stop_crawl, ac)
    else
        cy:stop_drifting()
        manny:set_run(FALSE)
        manny:force_auto_run(FALSE)
        cy.cv_door:walkOut()
    end
end
cy.manny_climb_down_chain = function(arg1) -- line 166
    local local1, local2, local3, local4
    stop_script(cy.manny_climb_up_chain)
    local4 = FALSE
    while get_generic_control_state("MOVE_BACKWARD") and not local4 do
        local2 = manny:getpos()
        local1 = { x = 0, y = -0.40000001, z = 0 }
        local3 = cy.chain_drift_bottom.rot
        local1 = RotateVector(local1, local3)
        local1.x = local1.x + local2.x
        local1.y = local1.y + local2.y
        local1.z = local1.z + local2.z
        manny:stop_chore(mn_conveyor_drift, "mn_conveyor.cos")
        manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
        manny:play_chore_looping(mn_conveyor_crawl, "mn_conveyor.cos")
        cy:manny_drift_to(local1, nil, 20, TRUE)
        break_here()
        local2 = manny:getpos()
        if local2.z < cy.chain_abort_bottom then
            local4 = TRUE
        end
    end
    if not local4 then
        start_script(ac.stop_crawl, ac)
    else
        manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
        manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
        start_script(cy.end_drift_gracefully, cy)
    end
end
cy.manny_drift_to = function(arg1, arg2, arg3, arg4, arg5) -- line 200
    local local1, local2, local3
    local local4, local5, local6
    local local7, local8
    local local9, local10
    local7 = manny:getpos()
    local8 = manny:get_positive_rot()
    local1 = (arg2.x - local7.x) / arg4
    local2 = (arg2.y - local7.y) / arg4
    local3 = (arg2.z - local7.z) / arg4
    if arg3 then
        if abs(arg3.y - local8.y) > 180 then
            if local8.y < arg3.y then
                local5 = (arg3.y - 360 - local8.y) / arg4
            else
                local5 = (arg3.y + 360 - local8.y) / arg4
            end
        else
            local5 = (arg3.y - local8.y) / arg4
        end
        local4 = (arg3.x - local8.x) / arg4
        local6 = (arg3.z - local8.z) / arg4
    end
    local9 = 0
    local10 = FALSE
    while local9 < arg4 and not local10 do
        local7.x = local7.x + local1
        local7.y = local7.y + local2
        local7.z = local7.z + local3
        manny:setpos(local7.x, local7.y, local7.z)
        if arg3 then
            local8.x = local8.x + local4
            local8.y = local8.y + local5
            local8.z = local8.z + local6
            manny:setrot(local8.x, local8.y, local8.z)
        end
        break_here()
        local9 = local9 + 1
        if arg5 then
            if local7.z <= cy.chain_abort_bottom or local7.z >= cy.chain_abort_top then
                local10 = TRUE
            end
        end
    end
    if not local10 then
        manny:setpos(arg2.x, arg2.y, arg2.z)
        if arg3 then
            manny:setrot(arg3.x, arg3.y, arg3.z)
        end
    end
end
cy.belt_actor = Actor:create(nil, nil, nil, "/cytx013/")
cy.belt_actor.default = function(arg1) -- line 259
    arg1:set_costume("conv_belt.cos")
    arg1:put_in_set(cy)
    arg1:set_softimage_pos(0, 0.7, -44.1271)
    arg1:setrot(0, 180, 0)
end
cy.belt_actor.change_direction = function(arg1) -- line 266
    if cy.lever.up then
        cy.belt_actor:set_chore_looping(conv_belt_forward, FALSE)
        cy.belt_actor:wait_for_chore(conv_belt_forward)
        start_sfx("cy_end.WAV")
        fade_sfx("cy_cvgo.IMU", 300, 0)
        if sound_playing("chnUndw.imu") then
            fade_sfx("chnUndw.imu", 300, 0)
        end
        cy.belt_actor:run_chore(conv_belt_slow_fore)
        cy.belt_actor:play_chore(conv_belt_stop)
        sleep_for(1000)
        cy.belt_actor:stop_chore(conv_belt_stop)
        start_sfx("cy_start.WAV")
        start_sfx("cy_cvgo.IMU", IM_MED_PRIORITY, 0)
        fade_sfx("cy_cvgo.IMU", 2000, cy.loop_vol)
        if ac.chain_state ~= "gone" then
            start_sfx("chnUndw.imu", IM_MED_PRIORITY, 0)
            fade_sfx("chnUndw.imu", 2000, ac.chain_vol)
        end
        cy.belt_actor:run_chore(conv_belt_start_rev)
        cy.belt_actor:run_chore(conv_belt_slow_rev)
        cy.belt_actor:play_chore_looping(conv_belt_reverse)
    else
        cy.belt_actor:set_chore_looping(conv_belt_reverse, FALSE)
        cy.belt_actor:wait_for_chore(conv_belt_reverse)
        start_sfx("cy_end.WAV")
        fade_sfx("cy_cvgo.IMU", 300, 0)
        if sound_playing("chnUndw.imu") then
            fade_sfx("chnUndw.imu", 300, 0)
        end
        cy.belt_actor:run_chore(conv_belt_slow_rev)
        cy.belt_actor:play_chore(conv_belt_stop)
        sleep_for(1000)
        cy.belt_actor:stop_chore(conv_belt_stop)
        start_sfx("cy_start.WAV")
        start_sfx("cy_cvgo.IMU", IM_MED_PRIORITY, 0)
        fade_sfx("cy_cvgo.IMU", 2000, cy.loop_vol)
        if ac.chain_state ~= "gone" then
            start_sfx("chnUndw.imu", IM_MED_PRIORITY, 0)
            fade_sfx("chnUndw.imu", 2000, ac.chain_vol)
        end
        cy.belt_actor:run_chore(conv_belt_start_fore)
        cy.belt_actor:run_chore(conv_belt_slow_fore)
        cy.belt_actor:play_chore_looping(conv_belt_forward)
    end
end
cy.lever_actor = Actor:create(nil, nil, nil, "/cytx014/")
cy.lever_actor.default = function(arg1) -- line 319
    arg1:set_costume("cy_lever.cos")
    arg1:put_in_set(cy)
    arg1:setpos(-0.437215, 3.95936, -0.0817886)
    arg1:setrot(45, 269.674, 0)
end
cy.lever_actor.pull = function(arg1) -- line 326
    local local1, local2
    local1 = 45
    local2 = 5
    while local1 < 100 do
        local1 = local1 + local2
        if local2 < 15 then
            local2 = local2 + 2
        end
        if local1 > 100 then
            local1 = 100
        end
        arg1:setrot(local1, 269.67401, 0)
        break_here()
    end
    sleep_for(250)
    local2 = 10
    while local1 > 45 do
        local1 = local1 - local2
        if local2 < 15 then
            local2 = local2 + 1
        end
        if local1 < 45 then
            local1 = 45
        end
        arg1:setrot(local1, 269.67401, 0)
        break_here()
    end
end
cy.fake_stair_box = function(arg1) -- line 357
    while TRUE do
        if system.currentActor:find_sector_name("conveyor_box") then
            while system.currentActor:find_sector_name("conveyor_box") do
                chore = find_stair_chore()
                system.currentActor:set_walk_chore(chore, system.currentActor.base_costume)
                while system.currentActor:is_choring(chore, TRUE, system.currentActor.base_costume) and system.currentActor:find_sector_name("conveyor_box") do
                    break_here()
                end
                while system.currentActor:is_resting() do
                    break_here()
                end
                break_here()
            end
        end
        if system.currentActor.is_running then
            system.currentActor:set_walk_chore(ms_run, system.currentActor.base_costume)
        elseif not system.currentActor.is_backward then
            system.currentActor:set_walk_chore(ms_walk, system.currentActor.base_costume)
        end
        SetActorConstrain(system.currentActor.hActor, FALSE)
        while not system.currentActor:find_sector_name("conveyor_box") do
            break_here()
        end
        break_here()
    end
end
cy.slide_along_conveyor = function(arg1) -- line 388
    local local1
    while TRUE do
        if manny:find_sector_name("conveyor1") or manny:find_sector_name("conveyor2") then
            local1 = manny:getpos()
            if cy.lever.up then
                local1.y = local1.y + 0.015
            else
                local1.y = local1.y - 0.015
            end
            manny:setpos(local1.x, local1.y, local1.z)
        end
        break_here()
    end
end
cy.climb_onto_conveyor = function(arg1) -- line 405
    START_CUT_SCENE()
    manny:clear_hands()
    MakeSectorActive("at_conveyor", TRUE)
    stop_script(cy.slide_along_conveyor)
    manny:head_look_at(nil)
    manny:walkto(-0.558631, 3.46617, -0.2, 0, 280.27, 0)
    manny:wait_for_actor()
    manny:head_look_at_point(-0.463631, 3.46617, 0.965)
    sleep_for(200)
    manny:ignore_boxes()
    manny:push_costume("ma_climb_conveyor.cos")
    manny:setpos(-0.475596, 3.51664, 0.389)
    manny:setrot(0, 280.27, 0)
    manny:play_chore(ma_climb_conveyor_climb, "ma_climb_conveyor.cos")
    manny:wait_for_chore(ma_climb_conveyor_climb, "ma_climb_conveyor.cos")
    manny:setpos(-0.22, 3.48618, 0.23)
    manny:setrot(0, 280.27, 0)
    manny:stop_chore(ma_climb_conveyor_climb, "ma_climb_conveyor.cos")
    manny:play_chore(ma_climb_conveyor_jump, "ma_climb_conveyor.cos")
    sleep_for(200)
    start_sfx("cy_swsh2.wav")
    sleep_for(800)
    start_sfx("mn_jmpcy.wav")
    manny:wait_for_chore(ma_climb_conveyor_jump, "ma_climb_conveyor.cos")
    manny:pop_costume()
    manny:follow_boxes()
    MakeSectorActive("at_conveyor", FALSE)
    start_script(cy.slide_along_conveyor, cy)
    inventory_disabled = TRUE
    manny.costume_marker_handler = manny.conveyor_costume_marker_handler
    END_CUT_SCENE()
end
cy.jump_off_conveyor = function(arg1) -- line 440
    local local1, local2, local3
    START_CUT_SCENE()
    manny:clear_hands()
    stop_script(cy.slide_along_conveyor)
    manny:walkto(-0.219523, 3.52478, 0.229637, 0, 105.247, 0)
    manny:wait_for_actor()
    manny:ignore_boxes()
    manny:push_costume("ma_climb_conveyor.cos")
    manny:setpos(-0.493, 3.46293, 0.1148)
    manny:setrot(0, 105.247, 0)
    manny:play_chore(ma_climb_conveyor_jump, "ma_climb_conveyor.cos")
    sleep_for(200)
    start_sfx("cy_swsh2.wav")
    sleep_for(500)
    local1 = manny:getpos()
    local2 = 0.0099999998
    local3 = 0
    while local1.z > -0.2 do
        local1.z = local1.z - local2
        if local1.z < -0.2 then
            local1.z = -0.2
        end
        local2 = local2 + 0.0049999999
        manny:setpos(local1.x, local1.y, local1.z)
        break_here()
        local3 = local3 + system.frameTime
        if local3 > 300 then
            start_sfx("mn_jump.wav")
            local3 = -1000
        end
    end
    manny:wait_for_chore(ma_climb_conveyor_jump, "ma_climb_conveyor.cos")
    manny:pop_costume()
    MakeSectorActive("at_conveyor", TRUE)
    manny:follow_boxes()
    while manny:find_sector_name("at_conveyor") do
        WalkActorForward(manny.hActor)
        break_here()
    end
    MakeSectorActive("at_conveyor", FALSE)
    cy.belt:make_touchable()
    inventory_disabled = FALSE
    manny.costume_marker_handler = nil
    END_CUT_SCENE()
end
cy.float_to_ac = function(arg1) -- line 489
    START_CUT_SCENE()
    manny:clear_hands()
    manny:set_walk_chore(-1)
    manny:set_turn_chores(-1, -1)
    manny:set_rest_chore(-1)
    manny:push_costume("mn_conveyor.cos")
    manny:say_line("/voma007/")
    manny:play_chore(mn_conveyor_start_current, "mn_conveyor.cos")
    manny:ignore_boxes()
    start_sfx("current.IMU")
    start_script(ac.manny_bob, ac)
    manny:setrot(0, 228, 0, TRUE)
    while manny:is_choring(mn_conveyor_start_current, FALSE, "mn_conveyor.cos") do
        WalkActorForward(manny.hActor)
        break_here()
    end
    manny:stop_chore(mn_conveyor_start_current, "mn_conveyor.cos")
    manny:play_chore_looping(mn_conveyor_loop_current, "mn_conveyor.cos")
    while manny:find_sector_name("conveyor_exit") do
        WalkActorForward(manny.hActor)
        break_here()
    end
    stop_script(ac.manny_bob, ac)
    system:lock_display()
    ac:switch_to_set()
    manny:put_in_set(ac)
    manny:follow_boxes()
    break_here()
    manny:ignore_boxes()
    manny:setpos(6.03455, -2.02365, 0.3333)
    manny:setrot(0, 95.8004, 0)
    system:unlock_display()
    manny:stop_chore(mn_conveyor_loop_current, "mn_conveyor.cos")
    manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
    stop_sound("current.IMU")
    ac.prev_button_handler = system.buttonHandler
    system.buttonHandler = drift_button_handler
    ac.drifting = TRUE
    inventory_disabled = TRUE
    manny.costume_marker_handler = nil
    END_CUT_SCENE()
end
manny.conveyor_costume_marker_handler = function(arg1, arg2) -- line 534
    local local1 = { "cyCreak1.WAV", "cyCreak2.WAV", "cyCreak3.WAV", "cyCreak4.WAV" }
    local local2, local3, local4
    local4 = FALSE
    local2, local3 = next(local1, nil)
    while local2 do
        if sound_playing(local3) then
            local4 = TRUE
        end
        local2, local3 = next(local1, local2)
    end
    if not local4 then
        local3 = pick_one_of(local1)
        manny:play_sound_at(local3, 10, 100)
    end
    manny:play_default_footstep(arg2)
end
cy.set_up_actors = function(arg1) -- line 559
    cy.belt_actor:default()
    cy.lever_actor:default()
    cy.belt_actor:stop_chore()
    if cy.lever.up then
        cy.belt_actor:play_chore_looping(conv_belt_reverse)
    else
        cy.belt_actor:play_chore_looping(conv_belt_forward)
    end
    cy.belt:set_object_state("cy_chain.cos")
    if ew.crane_broken and ew.crane_down and ew.crane_pos == ew.at_conveyor and not cv.chain_bunched then
        cy.belt:play_chore(0)
        box_off("conveyor1")
        box_off("conveyor2")
        box_off("conveyor3")
        box_on("chain_box1")
        box_on("chain_box2")
        box_on("chain_box3")
        box_off("cv_box")
        box_on("cv_box2")
    else
        cy.belt:play_chore(1)
        box_on("conveyor1")
        box_on("conveyor2")
        box_on("conveyor3")
        box_off("chain_box1")
        box_off("chain_box2")
        box_off("chain_box3")
        box_off("cv_box2")
        box_on("cv_box")
    end
end
cy.enter_on_conveyor = function(arg1) -- line 597
    START_CUT_SCENE()
    manny:clear_hands()
    inventory_disabled = TRUE
    manny.costume_marker_handler = manny.conveyor_costume_marker_handler
    END_CUT_SCENE()
end
cy.enter = function(arg1) -- line 605
    if ew.crane_broken and ew.crane_down and ew.crane_pos == ew.at_conveyor then
        cy:add_object_state(0, "cy_chain1.bm", nil, OBJSTATE_OVERLAY, TRUE)
        cy:add_object_state(0, "cy_chain2.bm", "cy_chain2.zbm", OBJSTATE_STATE)
        cy:add_object_state(0, "cy_chain3.bm", "cy_chain3.zbm", OBJSTATE_STATE)
        cy:add_object_state(0, "cy_chain4.bm", "cy_chain4.zbm", OBJSTATE_STATE)
    end
    play_movie_looping("cy_w.snm")
    if system.lastSet == ea then
        cy.belt:make_touchable()
    else
        cy.belt:make_untouchable()
    end
    cy:set_up_actors()
    start_script(cy.fake_stair_box, cy)
    start_script(cy.slide_along_conveyor, cy)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 10, 10)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    start_sfx("cy_cvgo.IMU", IM_MED_PRIORITY, cy.loop_vol)
    if ac.chain_state ~= "gone" then
        start_sfx("chnUndw.imu", IM_MED_PRIORITY, ac.chain_vol)
    end
    if manny:find_sector_name("ground_box") then
        inventory_disabled = FALSE
        manny.costume_marker_handler = nil
    else
        start_script(cy.enter_on_conveyor)
    end
end
cy.exit = function(arg1) -- line 643
    stop_sound("cy_cvgo.IMU")
    stop_sound("chnUndw.imu")
    StopMovie("cy_w.snm")
    stop_script(cy.fake_stair_box)
    stop_script(cy.slide_along_conveyor, cy)
    cy:stop_drifting()
    KillActorShadows(manny.hActor)
    cy.belt_actor:free()
    cy.lever_actor:free()
    inventory_disabled = FALSE
    manny.costume_marker_handler = nil
end
cy.belt = Object:create(cy, "/cytx003/conveyor belt", -0.35719201, 3.40727, 0.28999999, { range = 1 })
cy.belt.use_pnt_x = -0.65273499
cy.belt.use_pnt_y = 3.50527
cy.belt.use_pnt_z = -0.2
cy.belt.use_rot_x = 0
cy.belt.use_rot_y = -70.459297
cy.belt.use_rot_z = 0
cy.belt.lookAt = function(arg1) -- line 694
    manny:say_line("/cyma004/")
end
cy.belt.use = function(arg1) -- line 698
    start_script(cy.climb_onto_conveyor, cy)
    cy.belt:make_untouchable()
end
cy.belt.make_touchable = function(arg1) -- line 704
    Object.make_touchable(arg1)
    if ew.crane_broken and ew.crane_down and ew.crane_pos == ew.at_conveyor and not cv.chain_bunched then
        arg1:play_chore(0)
    else
        arg1:play_chore(1)
    end
end
cy.lever = Object:create(cy, "/cytx005/lever", -0.462174, 3.99472, -0.035500001, { range = 0.60000002 })
cy.lever.use_pnt_x = -0.83027899
cy.lever.use_pnt_y = 3.9857199
cy.lever.use_pnt_z = -0.2
cy.lever.use_rot_x = 0
cy.lever.use_rot_y = 280.957
cy.lever.use_rot_z = 0
cy.lever.up = TRUE
cy.lever.lookAt = function(arg1) -- line 725
    manny:say_line("/cyma006/")
end
cy.lever.use = function(arg1) -- line 729
    local local1, local2
    START_CUT_SCENE()
    if not cy.belt.touchable then
        cy:jump_off_conveyor()
    end
    manny:walkto_object(arg1)
    manny:default("nautical")
    manny:play_chore(mn2_pull_lever, "mn2.cos")
    if cy.lever.up then
        cy.lever.up = FALSE
    else
        cy.lever.up = TRUE
    end
    sleep_for(1000)
    start_sfx("cy_switch.WAV")
    cy.lever_actor:pull()
    if find_script(cy.belt_actor.change_direction) then
        wait_for_script(cy.belt_actor.change_direction)
    end
    local1 = manny:getpos()
    local2 = manny:getrot()
    if ac.chain_state == "here" then
        ac:switch_to_set()
        RunFullscreenMovie("ac_bu.snm")
        wait_for_movie()
        ac.chain_state = "bunched"
        cy:switch_to_set()
        cy.belt:make_touchable()
        manny:put_in_set(cy)
        manny:setpos(local1.x, local1.y, local1.z)
        manny:setrot(local2.x, local2.y, local2.z)
    elseif cv.chain_bunched then
        cv:switch_to_set()
        cv.chain_actor:play_chore(cv_chain_gone)
        play_movie("cv_bd.snm", 203, 0)
        wait_for_movie()
        cy:switch_to_set()
        manny:put_in_set(cy)
        manny:setpos(local1.x, local1.y, local1.z)
        manny:setrot(local2.x, local2.y, local2.z)
        cy.belt_actor:set_visibility(FALSE)
        cy.belt:play_chore(0)
        manny:head_look_at_point(-0.079957001, 5.4566498, 1.178)
        play_movie("cy_ch.snm")
        wait_for_movie()
        cy.belt_actor:set_visibility(TRUE)
        ac:switch_to_set()
        StartFullscreenMovie("ac_ch.snm")
        wait_for_movie()
        cv.chain_bunched = FALSE
        ac.chain_state = "here"
        cy:switch_to_set()
        manny:put_in_set(cy)
        manny:setpos(local1.x, local1.y, local1.z)
        manny:setrot(local2.x, local2.y, local2.z)
        cy.belt_actor:stop_chore(conv_belt_reverse)
        cy.belt_actor:play_chore_looping(conv_belt_forward)
        cy.belt:make_touchable()
    elseif ac.chain_state == "bunched" then
        cur_puzzle_state[43] = TRUE
        ac:switch_to_set()
        RunFullscreenMovie("ac_ha.snm")
        wait_for_movie()
        ac.chain_state = "wrapped"
        cy:switch_to_set()
        manny:put_in_set(cy)
        manny:setpos(local1.x, local1.y, local1.z)
        manny:setrot(local2.x, local2.y, local2.z)
        cy.belt:make_touchable()
    else
        manny:head_look_at_point(-0.079957001, 5.4566498, 1.178)
        start_script(cy.belt_actor.change_direction, cy.belt_actor)
        manny:wait_for_chore(mn2_pull_lever, "mn2.cos")
        manny:head_look_at(arg1)
    end
    END_CUT_SCENE()
end
cy.lever.pickUp = cy.lever.use
cy.cv_door = Object:create(cy, "/cytx007/surface", -0.0114948, 8.6668997, 4.0833702, { range = 0.60000002 })
cy.cv_door.out_pnt_x = -0.034031902
cy.cv_door.out_pnt_y = 6.0511098
cy.cv_door.out_pnt_z = 1.6543
cy.cv_door.out_rot_x = 0
cy.cv_door.out_rot_y = 1.5181299
cy.cv_door.out_rot_z = 0
cy.cv_door.use_pnt_x = -0.0169535
cy.cv_door.use_pnt_y = 5.6827502
cy.cv_door.use_pnt_z = 1.2493401
cy.cv_door.use_rot_x = 0
cy.cv_door.use_rot_y = 1.5181299
cy.cv_door.use_rot_z = 0
cy.cv_box = cy.cv_door
cy.cv_box2 = cy.cv_door
cy.cv_door.walkOut = function(arg1) -- line 839
    PrintDebug("CV_DOOR WALKOUT!!!\n")
    if cv.chain_bunched or ac.chain_state ~= "gone" then
        START_CUT_SCENE()
        cv:switch_to_set()
        manny:put_in_set(cv)
        manny:setpos(-2.01431, -10.3627, 7.89)
        manny:setrot(0, 98.6993, 0)
        manny:set_run(FALSE)
        manny:force_auto_run(FALSE)
        manny:walkto(-3.28204, -10.4203, 7.89)
        manny:wait_for_actor()
        END_CUT_SCENE()
    else
        cv:come_out_door(cv.cy_door)
    end
end
cy.cv_door.lookAt = function(arg1) -- line 857
    manny:say_line("/cyma008/")
end
cy.ea_door = Object:create(cy, "/cytx009/lit path", -2.1626, 3.41258, 0.25, { range = 0.60000002 })
cy.ea_door.use_pnt_x = -1.9726
cy.ea_door.use_pnt_y = 3.65258
cy.ea_door.use_pnt_z = -0.2
cy.ea_door.use_rot_x = 0
cy.ea_door.use_rot_y = -211.92
cy.ea_door.use_rot_z = 0
cy.ea_door.out_pnt_x = -2.16558
cy.ea_door.out_pnt_y = 3.3426099
cy.ea_door.out_pnt_z = -0.2
cy.ea_door.out_rot_x = 0
cy.ea_door.out_rot_y = -211.92
cy.ea_door.out_rot_z = 0
cy.ea_door2 = cy.ea_door
cy.ea_door.walkOut = function(arg1) -- line 879
    ea:come_out_door(ea.cy_door)
end
cy.ea_door.lookAt = function(arg1) -- line 883
    manny:say_line("/cyma010/")
end
cy.conveyor_exit = Object:create(cy, "/cytx011/more belt", 0.17237701, 1.84667, 0.40000001, { range = 0.60000002 })
cy.conveyor_exit.use_pnt_x = 0.034717601
cy.conveyor_exit.use_pnt_y = 2.7439599
cy.conveyor_exit.use_pnt_z = 0.07
cy.conveyor_exit.use_rot_x = 0
cy.conveyor_exit.use_rot_y = 192.87579
cy.conveyor_exit.use_rot_z = 0
cy.conveyor_exit.out_pnt_x = 0.034717601
cy.conveyor_exit.out_pnt_y = 2.7439599
cy.conveyor_exit.out_pnt_z = 0.07
cy.conveyor_exit.out_rot_x = 0
cy.conveyor_exit.out_rot_y = 192.87579
cy.conveyor_exit.out_rot_z = 0
cy.conveyor_exit.walkOut = function(arg1) -- line 902
    start_script(cy.float_to_ac, cy)
end
cy.conveyor_exit.lookAt = function(arg1) -- line 906
    manny:say_line("/cyma012/")
end
cy.jump_box = { name = "jump off conveyor box" }
cy.jump_box.walkOut = function(arg1) -- line 915
    start_script(cy.jump_off_conveyor, cy)
end
cy.climb_chain_box = { name = "climb chain box" }
cy.climb_chain_box.walkOut = function(arg1) -- line 923
    if ew.crane_broken and ew.crane_down and ew.crane_pos == ew.at_conveyor and not cy.drifting then
        start_script(cy.drift_to_chain, cy)
    end
end

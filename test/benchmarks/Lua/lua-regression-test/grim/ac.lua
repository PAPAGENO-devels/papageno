CheckFirstTime("ac.lua")
dofile("mn_conveyor.lua")
dofile("ac_chain.lua")
dofile("ac_belts.lua")
ac = Set:create("ac.set", "anchor room", { ac_cnvws = 0, ac_ovrhd = 1 })
ac.chain_state = "gone"
ac.chain_actor = nil
ac.chain_vol = 80
underwater_ambience_list = { "undwAmb1.wav", "undwAmb2.wav", "undwAmb3.wav", "undwAmb4.wav", "undwAmb5.wav", "undwAmb6.wav" }
underwater_ambience_parm_list = { min_delay = 6000, max_delay = 12000, min_volume = 30, max_volume = 75 }
ac.belt_actor = Actor:create(nil, nil, nil, "/actx014/")
ac.belt_actor.default = function(arg1) -- line 24
    arg1:set_costume("ac_belts.cos")
    arg1:put_in_set(ac)
    arg1:setpos(7.60617, -2.99209, -0.0117)
    arg1:setrot(0, 180, 0)
    if not cy.lever.up then
        arg1:stop_chore()
        arg1:play_chore_looping(ac_belts_reverse)
    else
        arg1:stop_chore()
        arg1:play_chore_looping(ac_belts_forward)
    end
end
ac.drift_pos = { x = 8.3852701, y = -1.78484, z = 0.33329999 }
ac.drift_rot = { x = 0, y = 95.778801, z = 0 }
ac.manny_drift_up = function(arg1) -- line 43
    local local1, local2
    local2 = 0.0099999998
    local1 = manny:getpos()
    while local1.z < ac.drift_pos.z do
        local1 = manny:getpos()
        local1.z = local1.z + local2
        manny:setpos(local1.x, local1.y, local1.z)
        break_here()
    end
end
ac.manny_bob = function(arg1) -- line 56
    local local1, local2
    local1 = 45
    while TRUE do
        local2 = manny:getpos()
        local2.z = local2.z + sin(local1) / 100
        local1 = local1 + 5
        if local1 > 360 then
            local1 = local1 - 360
        end
        manny:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
end
not_close = function(arg1, arg2, arg3) -- line 72
    if not arg3 then
        arg3 = 0.01
    end
    if abs(arg1 - arg2) > abs(arg3) then
        return TRUE
    else
        return FALSE
    end
end
ac.manny_move_to_drift_point = function(arg1) -- line 84
    local local1, local2, local3
    local local4, local5
    local local6, local7, local8
    local local9, local10
    local9 = 0.44999999
    manny:set_turn_rate(10)
    local10 = { x = 8.5172396, y = -2.9839599, z = -0.40000001 }
    local1 = GetActorYawToPoint(manny.hActor, local10)
    manny:setrot(0, local1, 0, TRUE)
    while find_script(ac.manny_drift_up) do
        WalkActorForward(manny.hActor)
        if local9 < 0.5 then
            local9 = local9 + 0.0099999998
            manny:set_walk_rate(local9)
        end
        break_here()
    end
    start_script(ac.manny_bob, ac)
    local1 = GetActorYawToPoint(manny.hActor, ac.drift_pos)
    while local1 < 0 do
        local1 = local1 + 360
    end
    while local1 > 360 do
        local1 = local1 - 360
    end
    local4 = manny:get_positive_rot()
    local4 = local4.y
    local5 = (local1 - local4) / 100
    while proximity(manny.hActor, ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z) > local9 * 3 do
        WalkActorForward(manny.hActor)
        if local9 < 0.5 then
            local9 = local9 + 0.0099999998
            manny:set_walk_rate(local9)
        end
        if local5 < 0 and local4 > local1 or (local5 > 0 and local4 < local1) then
            local4 = local4 + local5
            manny:setrot(0, local4, 0)
        end
        break_here()
        manny:head_look_at_point(ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z)
    end
    manny:set_chore_looping(mn_conveyor_loop_current, FALSE, "mn_conveyor.cos")
    FadeOutChore(manny.hActor, "mn_conveyor.cos", mn_conveyor_loop_current, 3000)
    local2 = 0
    while local2 < 2000 do
        WalkActorForward(manny.hActor)
        if local5 < 0 and local4 > local1 or (local5 > 0 and local4 < local1) then
            local4 = local4 + local5
            manny:setrot(0, local4, 0)
        end
        break_here()
        manny:head_look_at_point(ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z)
        local2 = local2 + system.frameTime
    end
    FadeInChore(manny.hActor, "mn_conveyor.cos", mn_conveyor_drift, 3000)
    local4 = local1
    manny:setrot(0, local4, 0)
    stop_script(ac.manny_bob)
    local3 = manny:getpos()
    local6 = (ac.drift_pos.x - local3.x) / 80
    local7 = (ac.drift_pos.y - local3.y) / 80
    local8 = (ac.drift_pos.z - local3.z) / 80
    local4 = manny:get_positive_rot()
    local4 = local4.y
    local5 = (ac.drift_rot.y - local4) / 80
    while local2 < 1500 do
        if not_close(local3.x, ac.drift_pos.x) then
            local3.x = local3.x + local6
        end
        if not_close(local3.y, ac.drift_pos.y) then
            local3.y = local3.y + local7
        end
        if not_close(local3.z, ac.drift_pos.z) then
            local3.z = local3.z + local8
        end
        if local5 < 0 and local4 > ac.drift_rot.y or (local5 > 0 and local4 < ac.drift_rot.y) then
            local4 = local4 + local5
            manny:setrot(0, local4, 0)
        end
        manny:setpos(local3.x, local3.y, local3.z)
        break_here()
        manny:head_look_at_point(ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z)
        local2 = local2 + system.frameTime
        if local2 >= 2000 then
            manny:stop_chore(mn_conveyor_loop_current, "mn_conveyor.cos")
        end
    end
    manny:stop_chore(mn_conveyor_loop_current, "mn_conveyor.cos")
    while not_close(local3.x, ac.drift_pos.x) or not_close(local3.y, ac.drift_pos.y) or not_close(local3.z, ac.drift_pos.z) or (local5 < 0 and local4 > ac.drift_rot.y) or (local5 > 0 and local4 < ac.drift_rot.y) do
        if not_close(local3.x, ac.drift_pos.x) then
            local3.x = local3.x + local6
        end
        if not_close(local3.y, ac.drift_pos.y) then
            local3.y = local3.y + local7
        end
        if not_close(local3.z, ac.drift_pos.z) then
            local3.z = local3.z + local8
        end
        if local5 < 0 and local4 > ac.drift_rot.y or (local5 > 0 and local4 < ac.drift_rot.y) then
            local4 = local4 + local5
            manny:setrot(0, local4, 0)
        end
        manny:setpos(local3.x, local3.y, local3.z)
        manny:head_look_at_point(ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z)
        break_here()
    end
    fade_sfx("current.IMU", 2000, 0)
    ac.at_belt_end = FALSE
    manny:setrot(ac.drift_rot.x, ac.drift_rot.y, ac.drift_rot.z, TRUE)
    manny:setpos(ac.drift_pos.x, ac.drift_pos.y, ac.drift_pos.z)
    manny:head_look_at(nil)
end
drift_button_handler = function(arg1, arg2, arg3) -- line 216
    local local1
    local1 = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if cutSceneLevel <= 0 then
        if control_map.INVENTORY[arg1] and arg2 then
            system.default_response("not now")
        elseif control_map.MOVE_FORWARD[arg1] and arg2 then
            single_start_script(ac.crawl_forward, ac)
        elseif control_map.MOVE_BACKWARD[arg1] and arg2 then
            single_start_script(ac.crawl_backward, ac)
        elseif control_map.LOOK_AT[arg1] and arg2 and not local1 then
            if hot_object then
                start_script(Sentence, "lookAt", hot_object)
            else
                PrintDebug("No hot object!\n")
            end
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
ac.crawl_forward = function(arg1) -- line 242
    stop_script(ac.crawl_backward)
    stop_script(ac.stop_crawl)
    manny:set_walk_rate(0.3)
    manny:stop_chore(mn_conveyor_drift, "mn_conveyor.cos")
    manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
    manny:play_chore_looping(mn_conveyor_crawl, "mn_conveyor.cos")
    while get_generic_control_state("MOVE_FORWARD") do
        manny:set_walk_chore(-1)
        WalkActorForward(manny.hActor)
        break_here()
        if ac.at_belt_end and not manny:find_sector_name("ac_gh_box") then
            ac.at_belt_end = FALSE
        end
        if conveyor_hand == 1 then
            start_sfx("mn_crwl1.WAV", IM_LOW_PRIORITY, 50)
        elseif conveyor_hand == 2 then
            start_sfx("mn_crwl2.WAV", IM_LOW_PRIORITY, 50)
        end
        conveyor_hand = 0
    end
    start_script(ac.stop_crawl, ac)
end
ac.crawl_backward = function(arg1) -- line 269
    stop_script(ac.crawl_forward)
    stop_script(ac.stop_crawl)
    if not ac.at_belt_end then
        manny:set_walk_rate(-0.3)
        manny:stop_chore(mn_conveyor_drift, "mn_conveyor.cos")
        manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
        manny:play_chore_looping(mn_conveyor_crawl, "mn_conveyor.cos")
        while get_generic_control_state("MOVE_BACKWARD") and not ac.at_belt_end do
            manny:set_walk_chore(-1)
            WalkActorForward(manny.hActor)
            break_here()
            if conveyor_hand == 1 then
                start_sfx("mn_crwl1.WAV", IM_LOW_PRIORITY, 50)
            elseif conveyor_hand == 2 then
                start_sfx("mn_crwl2.WAV", IM_LOW_PRIORITY, 50)
            end
            conveyor_hand = 0
        end
        start_script(ac.stop_crawl, ac)
    end
end
ac.stop_crawl = function(arg1) -- line 293
    manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
    manny:set_chore_looping(mn_conveyor_crawl, FALSE, "mn_conveyor.cos")
    FadeOutChore(manny.hActor, "mn_conveyor.cos", mn_conveyor_crawl, 250)
    sleep_for(250)
    manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
end
ac.stop_drifting = function(arg1) -- line 301
    if ac.drifting then
        if ac.prev_button_handler ~= nil and ac.prev_button_handler ~= drift_button_handler then
            system.buttonHandler = ac.prev_button_handler
        else
            system.buttonHandler = SampleButtonHandler
        end
        manny:stop_chore(mn_conveyor_drift, "mn_conveyor.cos")
        manny:stop_chore(mn_conveyor_crawl, "mn_conveyor.cos")
        manny:pop_costume()
        manny:set_walk_chore(ms_walk)
        manny:set_walk_rate(0.4)
        manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
        manny:set_rest_chore(ms_rest)
        manny:set_turn_rate(85)
        manny:follow_boxes()
        ac.drifting = FALSE
        inventory_disabled = FALSE
    end
end
ac.walk_too_far = function() -- line 330
    if not ac.tried_walking then
        ac.tried_walking = TRUE
        START_CUT_SCENE()
        ac:switch_to_set()
        manny:put_in_set(ac)
        manny:setpos(2.06181, -4.08239, -0.4)
        manny:setrot(0, 300.824, 0)
        manny:walkto(3.10194, -3.82774, -0.4)
        manny:wait_for_actor()
        manny:say_line("/cwma013/")
        manny:wait_for_message()
        END_CUT_SCENE()
    end
end
ac.set_up_actors = function(arg1) -- line 347
    if ac.chain_state ~= "gone" then
        if ac.chain_actor == nil then
            ac.chain_actor = Actor:create(nil, nil, nil, "Chain object state")
        end
        ac.chain_actor:set_costume("ac_chain.cos")
        ac.chain_actor:put_in_set(ac)
        ac.chain_actor:set_visibility(TRUE)
    elseif ac.chain_actor ~= nil then
        ac.chain_actor:complete_chore(ac_chain_gone)
    end
    if ac.chain_state == "here" then
        ac:add_object_state(0, "ac_1_ch.bm", "ac_1_ch.zbm", OBJSTATE_STATE)
        ac:add_object_state(0, "ac_2_ch.bm", "ac_2_ch.zbm", OBJSTATE_STATE)
        ac.chain_actor:complete_chore(ac_chain_here)
    elseif ac.chain_state == "bunched" then
        ac:add_object_state(0, "ac_1_bu.bm", "ac_1_bu.zbm", OBJSTATE_STATE)
        ac:add_object_state(0, "ac_2_bu.bm", "ac_2_bu.zbm", OBJSTATE_STATE)
        ac:add_object_state(0, "ac_3_bu.bm", "ac_3_bu.zbm", OBJSTATE_STATE)
        ac.chain_actor:complete_chore(ac_chain_bunched)
    elseif ac.chain_state == "wrapped" then
        ac:add_object_state(0, "ac_1_ha.bm", "ac_1_ha.zbm", OBJSTATE_STATE)
        ac:add_object_state(0, "ac_2_ha.bm", "ac_2_ha.zbm", OBJSTATE_STATE)
        ac:add_object_state(0, "ac_3_ha.bm", "ac_3_ha.zbm", OBJSTATE_STATE)
        ac.chain_actor:complete_chore(ac_chain_wrapped)
    end
    if raised_lamancha then
        ac:add_object_state(0, "ac_noanchor.bm", nil, OBJSTATE_UNDERLAY)
        ac.anchor:set_object_state("ac_anchor.cos")
        ac.anchor:complete_chore(0)
    end
    ac.belt_actor:default()
end
ac.enter = function(arg1) -- line 387
    ac:set_up_actors()
    start_sfx("cy_cvgo.IMU", IM_MED_PRIORITY, 100)
    ac:add_ambient_sfx(underwater_ambience_list, underwater_ambience_parm_list)
    if ac.chain_state ~= "gone" then
        start_sfx("chnUndw.imu", IM_MED_PRIORITY, ac.chain_vol)
    end
end
ac.exit = function(arg1) -- line 398
    ac.belt_actor:free()
    ac:stop_drifting()
    if ac.chain_actor then
        ac.chain_actor:free()
    end
    stop_sound("cy_cvgo.IMU")
    stop_sound("bubvox.imu")
    stop_sound("chnUndw.imu")
end
ac.cy_door = Object:create(ac, "door", 4.5749998, -3.2750001, 0.40000001, { range = 0.60000002 })
ac.cy_door.use_pnt_x = 4.5749998
ac.cy_door.use_pnt_y = -3.2750001
ac.cy_door.use_pnt_z = 0.40000001
ac.cy_door.use_rot_x = 0
ac.cy_door.use_rot_y = 88.706398
ac.cy_door.use_rot_z = 0
ac.cy_door.out_pnt_x = 4.5749998
ac.cy_door.out_pnt_y = -3.2750001
ac.cy_door.out_pnt_z = 0.40000001
ac.cy_door.out_rot_x = 0
ac.cy_door.out_rot_y = 88.706398
ac.cy_door.out_rot_z = 0
ac.cy_box = ac.cy_door
ac.cy_door.walkOut = function(arg1) -- line 436
    START_CUT_SCENE()
    cy:switch_to_set()
    manny:put_in_set(cy)
    ac:stop_drifting()
    inventory_disabled = TRUE
    manny:setpos(cy.conveyor_exit.use_pnt_x, cy.conveyor_exit.use_pnt_y, cy.conveyor_exit.use_pnt_z)
    manny:setrot(cy.conveyor_exit.use_rot_x, cy.conveyor_exit.use_rot_y + 180, cy.conveyor_exit.use_rot_z)
    END_CUT_SCENE()
end
ac.anchor = Object:create(ac, "/actx001/anchor", 9.2937899, -1.47218, -0.12, { range = 1.5 })
ac.anchor.use_pnt_x = 9.14363
ac.anchor.use_pnt_y = -1.70524
ac.anchor.use_pnt_z = -0.40000001
ac.anchor.use_rot_x = 0
ac.anchor.use_rot_y = 1052.99
ac.anchor.use_rot_z = 0
ac.anchor.lookAt = function(arg1) -- line 456
    manny:say_line("/acma002/")
end
ac.anchor.pickUp = function(arg1) -- line 460
    manny:say_line("/acma003/")
end
ac.anchor.use_scythe = function(arg1) -- line 464
    manny:say_line("/acma004/")
end
ac.anchor.use_stockings = function(arg1) -- line 468
    manny:say_line("/acma005/")
end
ac.anchor.use_chisel = function(arg1) -- line 472
    manny:say_line("/acma006/")
end
ac.anchor.use = function(arg1) -- line 476
    ac.gh_door:walkOut()
end
ac.gh_door = Object:create(ac, "/actx007/anchor", 9.2937899, -1.47218, -0.12, { range = 0 })
ac.gh_door.use_pnt_x = 9.14363
ac.gh_door.use_pnt_y = -1.70524
ac.gh_door.use_pnt_z = -0.40000001
ac.gh_door.use_rot_x = 0
ac.gh_door.use_rot_y = 1052.99
ac.gh_door.use_rot_z = 0
ac.gh_door.out_pnt_x = 9.4553699
ac.gh_door.out_pnt_y = -1.43809
ac.gh_door.out_pnt_z = -0.40000001
ac.gh_door.out_rot_x = 0
ac.gh_door.out_rot_y = 999.01898
ac.gh_door.out_rot_z = 0
ac.ac_gh_box = ac.gh_door
ac.gh_door:make_untouchable()
ac.gh_door.walkOut = function(arg1) -- line 500
    if not raised_lamancha then
        START_CUT_SCENE()
        IrisDown(320, 240, 1000)
        sleep_for(1000)
        ac.belt_actor:free()
        fade_sfx("cy_cvgo.IMU", 200)
        fade_sfx("chnUndw.imu", 200)
        ImSetState(STATE_NULL)
        stop_sound("cy_cvgo.IMU", 200)
        stop_sound("chnUndw.imu", 200)
        sleep_for(200)
        if not gh.been_there then
            start_script(cut_scene.lamancha, cut_scene)
        else
            gh:come_out_door(gh.ac_door)
            IrisUp(609, 314, 1000)
        end
        END_CUT_SCENE()
    else
        ac.at_belt_end = TRUE
    end
end
ac.drift_trigger = { name = "drift trigger" }
ac.drift_trigger.walkOut = function(arg1) -- line 528
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
    start_script(ac.manny_drift_up, ac)
    start_script(ac.manny_move_to_drift_point, ac)
    manny:wait_for_chore(mn_conveyor_start_current, "mn_conveyor.cos")
    manny:play_chore_looping(mn_conveyor_loop_current, "mn_conveyor.cos")
    wait_for_script(ac.manny_move_to_drift_point)
    ac.prev_button_handler = system.buttonHandler
    system.buttonHandler = drift_button_handler
    inventory_disabled = TRUE
    ac.drifting = TRUE
    END_CUT_SCENE()
end
ac.mn_door = Object:create(ac, "path", 0, 0, 0, { range = 0 })
ac.mn_door.use_pnt_x = 1.8935
ac.mn_door.use_pnt_y = -4.2574601
ac.mn_door.use_pnt_z = -0.40000001
ac.mn_door.use_rot_x = 0
ac.mn_door.use_rot_y = 110.836
ac.mn_door.use_rot_z = 0
ac.mn_door.out_pnt_x = -2.4612501
ac.mn_door.out_pnt_y = -5.1782598
ac.mn_door.out_pnt_z = -0.40000001
ac.mn_door.out_rot_x = 0
ac.mn_door.out_rot_y = 97.321503
ac.mn_door.out_rot_z = 0
ac.mn_door.touchable = FALSE
ac.mn_box = ac.mn_door
ac.mn_door.walkOut = function(arg1) -- line 570
    mn:come_out_door(mn.ac_door)
end

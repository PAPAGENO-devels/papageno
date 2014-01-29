CheckFirstTime("ew.lua")
dofile("crane.lua")
ew = Set:create("ew.set", "end of the world", { ew_ishla = 0, ew_ovrhd = 1 })
ew.music_counter = 0
CRANE_SPEED = 10
ew.crane_points = { }
ew.crane_points[0] = { }
ew.crane_points[0].pos = { x = -0.195516, y = -1.36254, z = -1.299 }
ew.crane_points[0].rot = { x = 0, y = 94.3899, z = 0 }
ew.crane_points[1] = { }
ew.crane_points[1].pos = { x = -0.204701, y = -1.24289, z = -1.299 }
ew.crane_points[1].rot = { x = 0, y = 94.3899, z = 0 }
ew.crane_points[2] = { }
ew.crane_points[2].pos = { x = -0.212356, y = -1.14319, z = -1.299 }
ew.crane_points[2].rot = { x = 0, y = 95.4127, z = 0 }
ew.crane_points[3] = { }
ew.crane_points[3].pos = { x = -0.231221, y = -0.944089, z = -1.299 }
ew.crane_points[3].rot = { x = 0, y = 95.4127, z = 0 }
ew.crane_points[4] = { }
ew.crane_points[4].pos = { x = -0.250087, y = -0.744988, z = -1.299 }
ew.crane_points[4].rot = { x = 0, y = 95.4127, z = 0 }
ew.crane_points[5] = { }
ew.crane_points[5].pos = { x = -0.267067, y = -0.565797, z = -1.299 }
ew.crane_points[5].rot = { x = 0, y = 97.3118, z = 0 }
ew.crane_points[6] = { }
ew.crane_points[6].pos = { x = -0.29252, y = -0.367433, z = -1.299 }
ew.crane_points[6].rot = { x = 0, y = 99.2711, z = 0 }
ew.crane_points[7] = { }
ew.crane_points[7].pos = { x = -0.324741, y = -0.170058, z = -1.299 }
ew.crane_points[7].rot = { x = 0, y = 102.631, z = 0 }
ew.crane_points[8] = { }
ew.crane_points[8].pos = { x = -0.368475, y = 0.0250848, z = -1.299 }
ew.crane_points[8].rot = { x = 0, y = 106.717, z = 0 }
ew.crane_points[9] = { }
ew.crane_points[9].pos = { x = -0.504842, y = 0.222564, z = -1.299 }
ew.crane_points[9].rot = { x = 0, y = 115.522, z = 0 }
ew.crane_points[10] = { }
ew.crane_points[10].pos = { x = -0.615764, y = 0.409756, z = -1.299 }
ew.crane_points[10].rot = { x = 0, y = 124.888, z = 0 }
ew.crane_points[11] = { }
ew.crane_points[11].pos = { x = -0.78678, y = 0.63038, z = -1.299 }
ew.crane_points[11].rot = { x = 0, y = 129.767, z = 0 }
ew.crane_points[12] = { }
ew.crane_points[12].pos = { x = -0.982809, y = 0.743015, z = -1.299 }
ew.crane_points[12].rot = { x = 0, y = 135.113, z = 0 }
ew.crane_points[13] = { }
ew.crane_points[13].pos = { x = -1.17633, y = 0.894887, z = -1.299 }
ew.crane_points[13].rot = { x = 0, y = 144.89, z = 0 }
ew.crane_points[14] = { }
ew.crane_points[14].pos = { x = -1.50502, y = 0.996818, z = -1.299 }
ew.crane_points[14].rot = { x = 0, y = 151.497, z = 0 }
ew.crane_points[15] = { }
ew.crane_points[15].pos = { x = -1.78102, y = 1.04727, z = -1.299 }
ew.crane_points[15].rot = { x = 0, y = 160.016, z = 0 }
ew.crane_points[16] = { }
ew.crane_points[16].pos = { x = -2.04848, y = 1.03976, z = -1.299 }
ew.crane_points[16].rot = { x = 0, y = 166.125, z = 0 }
ew.crane_points[17] = { }
ew.crane_points[17].pos = { x = -2.40612, y = 1.06319, z = -1.2532 }
ew.crane_points[17].rot = { x = 0, y = 172.472, z = 0 }
ew.crane_points[18] = { }
ew.crane_points[18].pos = { x = -2.66296, y = 1.06126, z = -1.1776 }
ew.crane_points[18].rot = { x = 0, y = 181.352, z = 0 }
ew.crane_points[19] = { }
ew.crane_points[19].pos = { x = -2.95654, y = 1.01722, z = -1.1445 }
ew.crane_points[19].rot = { x = 0, y = 189.598, z = 0 }
ew.crane_points[20] = { }
ew.crane_points[20].pos = { x = -3.24564, y = 0.948033, z = -1.1445 }
ew.crane_points[20].rot = { x = 0, y = 199.154, z = 0 }
ew.crane_points[21] = { }
ew.crane_points[21].pos = { x = -3.55745, y = 0.819236, z = -1.0537 }
ew.crane_points[21].rot = { x = 0, y = 207.946, z = 0 }
ew.crane_points[22] = { }
ew.crane_points[22].pos = { x = -3.87541, y = 0.650527, z = -0.9428 }
ew.crane_points[22].rot = { x = 0, y = 214.867, z = 0 }
ew.crane_points[23] = { }
ew.crane_points[23].pos = { x = -4.11395, y = 0.415188, z = -0.9428 }
ew.crane_points[23].rot = { x = 0, y = 224.438, z = 0 }
ew.crane_points[24] = { }
ew.crane_points[24].pos = { x = -4.25619, y = 0.160655, z = -0.852 }
ew.crane_points[24].rot = { x = 0, y = 235.249, z = 0 }
ew.crane_points[25] = { }
ew.crane_points[25].pos = { x = -4.30947, y = -0.166427, z = -0.8046 }
ew.crane_points[25].rot = { x = 0, y = 242.075, z = 0 }
ew.crane_points[26] = { }
ew.crane_points[26].pos = { x = -4.34558, y = -0.463871, z = -0.7594 }
ew.crane_points[26].rot = { x = 0, y = 252.304, z = 0 }
ew.crane_points[27] = { }
ew.crane_points[27].pos = { x = -4.34959, y = -0.674897, z = -0.7385 }
ew.crane_points[27].rot = { x = 0, y = 268.546, z = 0 }
ew.crane_points[28] = { }
ew.crane_points[28].pos = { x = -4.3257, y = -0.875492, z = -0.6465 }
ew.crane_points[28].rot = { x = 0, y = 298.493, z = 0 }
ew.crane_points.num_points = 29
ew.crane_points.index = 0
ew.at_conveyor = 0
ew.in_between = 1
ew.at_crusher = ew.crane_points.num_points - 1
ew.crane_pos = ew.at_conveyor
ew.crane_actor = Actor:create(nil, nil, nil, "/ewtx002/")
ew.crane_actor.cur_point = 0
ew.crane_actor.volume = 90
ew.crane_actor.default = function(arg1) -- line 158
    arg1:set_costume("crane.cos")
    arg1:put_in_set(ew)
    SetActorScale(arg1.hActor, 0.2)
    arg1:setpos(0, 0, 0)
    arg1:setrot(0, 0, 0)
    arg1:set_walk_rate(0.1)
    arg1:set_turn_rate(15)
    arg1:set_walk_chore(-1)
    arg1:set_turn_chores(-1, -1)
    arg1:set_rest_chore(-1)
    if ew.crane_broken then
        arg1:play_chore(crane_broken)
    else
        arg1:play_chore(crane_fixed)
    end
end
ew.crane_actor.move_left = function(arg1) -- line 176
    local local1 = 0
    stop_script(arg1.move_right)
    if not sound_playing("crane.imu") then
        start_sfx("crane.imu")
    else
        fade_sfx("crane.imu", 500, arg1.volume)
    end
    START_CUT_SCENE()
    while get_generic_control_state("TURN_LEFT") and local1 < ew.crane_points.num_points do
        local1 = arg1.cur_point + 1
        if local1 < ew.crane_points.num_points then
            arg1:move_to_point(local1)
        end
    end
    END_CUT_SCENE()
    if sound_playing("crane.imu") then
        fade_sfx("crane.imu", 500, 0)
    end
end
ew.crane_actor.move_right = function(arg1) -- line 201
    local local1 = 0
    stop_script(arg1.move_left)
    if not sound_playing("crane.imu") then
        start_sfx("crane.imu")
    else
        fade_sfx("crane.imu", 500, arg1.volume)
    end
    START_CUT_SCENE()
    while get_generic_control_state("TURN_RIGHT") and local1 >= 0 do
        local1 = arg1.cur_point - 1
        if local1 >= 0 then
            arg1:move_to_point(local1)
        end
    end
    END_CUT_SCENE()
    if sound_playing("crane.imu") then
        fade_sfx("crane.imu", 500, 0)
    end
end
ew.crane_actor.init_current_point = function(arg1) -- line 226
    local local1, local2
    if arg1.cur_point == nil then
        arg1.cur_point = 0
    end
    local1 = ew.crane_points[arg1.cur_point].pos
    local2 = ew.crane_points[arg1.cur_point].rot
    arg1:setpos(local1.x, local1.y, local1.z)
    arg1:setrot(local2.x, local2.y, local2.z)
    if arg1.cur_point == ew.at_conveyor or arg1.cur_point == ew.at_crusher then
        ew.crane_pos = arg1.cur_point
    else
        ew.crane_pos = ew.in_between
    end
end
ew.crane_actor.move_to_point = function(arg1, arg2) -- line 245
    local local1, local2, local3
    local local4, local5, local6, local7
    local local8, local9
    local1 = ew.crane_points[arg1.cur_point]
    local2 = ew.crane_points[arg2]
    if local2 then
        local4 = (local2.pos.x - local1.pos.x) / CRANE_SPEED
        local5 = (local2.pos.y - local1.pos.y) / CRANE_SPEED
        local6 = (local2.pos.z - local1.pos.z) / CRANE_SPEED
        if abs(local2.rot.y - local1.rot.y) > 180 then
            if local1.rot.y < local2.rot.y then
                local7 = (local2.rot.y - 360 - local1.rot.y) / CRANE_SPEED
            else
                local7 = (local2.rot.y + 360 - local1.rot.y) / CRANE_SPEED
            end
        else
            local7 = (local2.rot.y - local1.rot.y) / CRANE_SPEED
        end
        local3 = 0
        local8 = local1.pos
        local9 = local1.rot
        while local3 < CRANE_SPEED do
            local8.x = local8.x + local4
            local8.y = local8.y + local5
            local8.z = local8.z + local6
            arg1:setpos(local8.x, local8.y, local8.z)
            local9.y = local9.y + local7
            arg1:setrot(local9.x, local9.y, local9.z)
            break_here()
            local3 = local3 + 1
        end
        arg1.cur_point = arg2
        arg1:init_current_point()
    end
end
ew.buttonHandler = function(arg1, arg2, arg3) -- line 290
    if cutSceneLevel <= 0 then
        if control_map.TURN_LEFT[arg1] and arg2 then
            if ew.crane_down then
                start_script(ew.raise_crane_and_move, ew, ew.crane_actor.move_left)
            else
                single_start_script(ew.crane_actor.move_left, ew.crane_actor)
            end
        elseif control_map.TURN_RIGHT[arg1] and arg2 then
            if ew.crane_down then
                start_script(ew.raise_crane_and_move, ew, ew.crane_actor.move_right)
            else
                single_start_script(ew.crane_actor.move_right, ew.crane_actor)
            end
        elseif control_map.INVENTORY[arg1] and arg2 then
            system.default_response("not now")
        elseif control_map.MOVE_FORWARD[arg1] and arg2 then
            single_start_script(ew.raise_crane, ew)
        elseif control_map.MOVE_BACKWARD[arg1] and arg2 then
            single_start_script(ew.lower_crane, ew)
        elseif control_map.USE[arg1] or control_map.PICK_UP[arg1] and arg2 then
            start_script(ew.exit_crane, ew)
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
ew.raise_crane_and_move = function(arg1, arg2) -- line 322
    if system.currentSet == ew then
        single_start_script(ew.raise_crane, ew)
        wait_for_script(ew.raise_crane)
        cutSceneLevel = 0
        if arg2 == ew.crane_actor.move_left and get_generic_control_state("TURN_LEFT") then
            single_start_script(arg2, ew.crane_actor)
        elseif arg2 == ew.crane_actor.move_right and get_generic_control_state("TURN_RIGHT") then
            single_start_script(arg2, ew.crane_actor)
        end
    end
end
ew.operate_crane = function(arg1) -- line 335
    ew.prev_button_handler = system.buttonHandler
    system.buttonHandler = ew.buttonHandler
    ew:switch_to_set()
    ew.crane_actor:default()
    ew.crane_actor:init_current_point()
    manny:put_in_set(ew)
    manny:set_visibility(FALSE)
    if not ew.used_crane then
        ew.used_crane = TRUE
        ew:preview_crane()
    end
end
ew.preview_crane = function(arg1) -- line 355
    local local1, local2
    START_CUT_SCENE()
    sleep_for(500)
    start_sfx("crane.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("crane.IMU", 500, ew.crane_actor.volume)
    sleep_for(500)
    local1 = 0
    local2 = ew.crane_actor:getrot()
    while local1 < 8 do
        ew.crane_actor:setrot(local2.x, local2.y, 1)
        break_here()
        ew.crane_actor:setrot(local2.x, local2.y, 0)
        break_here()
        local1 = local1 + 1
    end
    ew.crane_actor:setrot(local2.x, local2.y, local2.z)
    fade_sfx("crane.IMU", 500, 0)
    END_CUT_SCENE()
end
ew.raise_crane = function(arg1) -- line 378
    START_CUT_SCENE()
    if ew.crane_down then
        ew.crane_down = FALSE
        if ew.crane_broken then
            if ac.chain_state == "wrapped" then
                ew:exit_crane(TRUE)
                ew.crane_pos = ew.at_crusher
                ew.crane_actor.cur_point = ew.at_crusher
                ac.chain_state = "gone"
                cv.chain_bunched = FALSE
                start_script(cut_scene.posidon, cut_scene)
            elseif ew.crane_pos == ew.at_crusher then
                cu:free_crusher()
            elseif ew.crane_pos == ew.at_conveyor then
                cv:recoil_chain()
            else
                ew:chain_out_trough()
            end
        elseif ew.crane_pos == ew.at_conveyor then
            ew:end_snap_at_anchor()
        else
            START_CUT_SCENE()
            ew.crane_actor:stop_chore(crane_down)
            start_sfx("crane_ud.WAV")
            ew.crane_actor:run_chore(crane_up)
            END_CUT_SCENE()
            if bu.scoop_here then
                bu.scoop_here = FALSE
            end
        end
    end
    END_CUT_SCENE()
end
ew.lower_crane = function(arg1) -- line 415
    START_CUT_SCENE()
    if not ew.crane_down then
        if ew.crane_broken then
            if ew.crane_pos == ew.in_between then
                ew:chain_in_trough()
            elseif ew.crane_pos == ew.at_conveyor then
                if raised_lamancha then
                    system.default_response("already")
                else
                    cv:spill_chain()
                end
            elseif ew.crane_pos == ew.at_crusher then
                cu:spill_chain()
            end
        elseif ew.crane_pos == ew.in_between then
            ew:snap_at_limbo()
        elseif ew.crane_pos == ew.at_conveyor then
            ew:snap_at_anchor()
        elseif ew.crane_pos == ew.at_crusher then
            ew:land_on_beach()
        end
    end
    END_CUT_SCENE()
end
ew.snap_at_limbo = function(arg1) -- line 443
    START_CUT_SCENE()
    ew.crane_actor:stop_chore(crane_up)
    start_sfx("crane_ud.WAV")
    ew.crane_actor:run_chore(crane_down)
    ew.crane_down = TRUE
    END_CUT_SCENE()
end
ew.snap_at_anchor = function(arg1) -- line 452
    START_CUT_SCENE()
    ew.crane_actor:run_chore(crane_down)
    ac:switch_to_set()
    if not ac.crane_actor then
        ac.crane_actor = Actor:create(nil, nil, nil, "crane scoop")
    end
    ac.crane_actor:set_costume(nil)
    ac.crane_actor:set_costume("crane_scoop.cos")
    SetActorFrustrumCull(ac.crane_actor.hActor, FALSE)
    SetActorScale(ac.crane_actor.hActor, 0.3)
    ac.crane_actor:put_in_set(ac)
    ac.crane_actor:setpos(7.74274, -0.252156, 11.728)
    ac.crane_actor:setrot(0, 309.762, 0)
    ac.crane_actor:play_chore(0)
    sleep_for(500)
    start_sfx("scoopcls.WAV")
    ac.crane_actor:wait_for_chore(0)
    sleep_for(1000)
    SetActorFrustrumCull(ac.crane_actor.hActor, TRUE)
    ac.crane_actor:free()
    ew:switch_to_set()
    ew.crane_down = FALSE
    ew.crane_actor:default()
    ew.crane_actor:init_current_point()
    ew.crane_actor:play_chore(crane_down_hold)
    manny:put_in_set(ew)
    manny:set_visibility(FALSE)
    ew.crane_down = TRUE
    END_CUT_SCENE()
end
ew.end_snap_at_anchor = function(arg1) -- line 488
    START_CUT_SCENE()
    ac:switch_to_set()
    if not ac.crane_actor then
        ac.crane_actor = Actor:create(nil, nil, nil, "crane scoop")
    end
    ac.crane_actor:set_costume(nil)
    ac.crane_actor:set_costume("crane_scoop.cos")
    SetActorFrustrumCull(ac.crane_actor.hActor, FALSE)
    SetActorScale(ac.crane_actor.hActor, 0.3)
    ac.crane_actor:put_in_set(ac)
    ac.crane_actor:setpos(7.74274, -0.252156, 11.728)
    ac.crane_actor:setrot(0, 309.762, 0)
    start_sfx("scoopopn.WAV")
    ac.crane_actor:play_chore(1)
    ac.crane_actor:wait_for_chore(1)
    SetActorFrustrumCull(ac.crane_actor.hActor, TRUE)
    ac.crane_actor:free()
    ew:switch_to_set()
    ew.crane_down = FALSE
    ew.crane_actor:stop_chore(crane_down_hold)
    ew.crane_actor:default()
    ew.crane_actor:init_current_point()
    ew.crane_actor:run_chore(crane_up)
    manny:put_in_set(ew)
    manny:set_visibility(FALSE)
    ew.crane_down = FALSE
    END_CUT_SCENE()
end
ew.land_on_beach = function(arg1) -- line 522
    START_CUT_SCENE()
    bu:lower_scoop()
    ew:exit_crane()
    END_CUT_SCENE()
end
ew.chain_in_trough = function(arg1) -- line 529
    START_CUT_SCENE()
    music_state:set_sequence(seqCraneTrack)
    ew.crane_down = TRUE
    set_override(ew.skip_chain_in_trough, ew)
    ck:switch_to_set()
    play_movie("ck_chain.snm", 320, 0)
    wait_for_movie()
    ew:switch_to_set()
    END_CUT_SCENE()
end
ew.skip_chain_in_trough = function(arg1) -- line 542
    kill_override()
    ew:switch_to_set()
end
ew.chain_out_trough = function(arg1) -- line 547
    START_CUT_SCENE()
    ew.crane_down = FALSE
    set_override(ew.skip_chain_in_trough, ew)
    ck:switch_to_set()
    play_movie("ck_chain_reverse.snm", 320, 0)
    wait_for_movie()
    ew:switch_to_set()
    END_CUT_SCENE()
end
ew.exit_crane = function(arg1, arg2) -- line 559
    stop_script(ew.raise_crane_and_move)
    if arg2 then
        single_start_script(WalkManny)
        system.buttonHandler = ew.prev_button_handler
        manny:set_visibility(TRUE)
        system.buttonHandler = SampleButtonHandler
    elseif ew.crane_pos == ew.in_between then
        manny:say_line("/ewma001/")
    else
        single_start_script(WalkManny)
        system.buttonHandler = ew.prev_button_handler
        manny:set_visibility(TRUE)
        doorman_in_hot_box = TRUE
        if ew.crane_pos == ew.at_conveyor then
            START_CUT_SCENE()
            cv:switch_to_set()
            manny:put_in_set(cv)
            manny:setpos(-4.34365, -10.3907, 7.89)
            manny:setrot(0, 233.953, 0)
            manny:walkto(-3.32008, -10.4037, 7.89)
            manny:wait_for_actor()
            END_CUT_SCENE()
        else
            start_script(cu.exit_crane, cu)
        end
    end
end
ew.update_music_state = function(arg1) -- line 600
    if ew.music_counter > 2 then
        return stateEW_LATER
    else
        return stateEW
    end
end
ew.enter = function(arg1) -- line 608
    play_movie_looping("ew_w.snm")
    ew.crane_actor:default()
    ew.crane_actor:init_current_point()
    ew.music_counter = ew.music_counter + 1
end
ew.exit = function(arg1) -- line 616
    ew.crane_actor:free()
    StopMovie()
end
ew.cu_door = Object:create(ew, "door", -4.1750002, 0.40000001, 0.15000001, { range = 0.60000002 })
ew.cu_door.use_pnt_x = -4.1750002
ew.cu_door.use_pnt_y = 0.40000001
ew.cu_door.use_pnt_z = 0.15000001
ew.cu_door.use_rot_x = 0
ew.cu_door.use_rot_y = -811.15503
ew.cu_door.use_rot_z = 0
ew.cu_door.out_pnt_x = -4.1750002
ew.cu_door.out_pnt_y = 0.40000001
ew.cu_door.out_pnt_z = 0.15000001
ew.cu_door.out_rot_x = 0
ew.cu_door.out_rot_y = -811.15503
ew.cu_door.out_rot_z = 0
ew.cu_box = ew.cu_door
ew.cu_door.walkOut = function(arg1) -- line 649
    cu:come_out_door(cu.ew_door)
end
ew.cv_door = Object:create(ew, "door", -6.0118299, 0.375577, 0.15000001, { range = 0 })
ew.cv_door.use_pnt_x = -6.0118299
ew.cv_door.use_pnt_y = 0.375577
ew.cv_door.use_pnt_z = 0.15000001
ew.cv_door.use_rot_x = 0
ew.cv_door.use_rot_y = -989.16498
ew.cv_door.use_rot_z = 0
ew.cv_door.out_pnt_x = -6.0118299
ew.cv_door.out_pnt_y = 0.375577
ew.cv_door.out_pnt_z = 0.15000001
ew.cv_door.out_rot_x = 0
ew.cv_door.out_rot_y = -989.16498
ew.cv_door.out_rot_z = 0
ew.cv_box = ew.cv_door
ew.cv_door.walkOut = function(arg1) -- line 670
    cv:come_out_door(cv.ew_door)
end
ew.ck_door = Object:create(ew, "door", -6.625, -1.125, 0.15000001, { range = 0 })
ew.ck_door.use_pnt_x = -6.625
ew.ck_door.use_pnt_y = -1.125
ew.ck_door.use_pnt_z = 0.15000001
ew.ck_door.use_rot_x = 0
ew.ck_door.use_rot_y = -926.67902
ew.ck_door.use_rot_z = 0
ew.ck_door.out_pnt_x = -6.625
ew.ck_door.out_pnt_y = -1.125
ew.ck_door.out_pnt_z = 0.15000001
ew.ck_door.out_rot_x = 0
ew.ck_door.out_rot_y = -926.67902
ew.ck_door.out_rot_z = 0
ew.ck_box = ew.ck_door
ew.ck_door.walkOut = function(arg1) -- line 692
    ck:come_out_door(ck.ew_door)
end

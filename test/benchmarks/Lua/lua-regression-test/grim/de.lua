CheckFirstTime("de.lua")
dofile("de_screen.lua")
dofile("forklift.lua")
de = Set:create("de.set", "dillopede elevator", { de_frkha = 0 })
de.forklift_actor = Actor:create(nil, nil, nil, "forklift")
de.forklift_actor.initialized = FALSE
de.forklift_actor.initialize = function(arg1) -- line 28
    if not arg1.initialized and system.currentSet == wc then
        arg1.initialized = TRUE
        arg1.blades_up = FALSE
        arg1.currentSet = wc
        arg1:default()
        arg1:put_in_set(wc)
        arg1:setpos(0.934834, -2.1862, 0)
        arg1:setrot(0, 14.7653, 0)
        arg1.current_pos = { x = 0.934834, y = -2.1862, z = 0 }
        arg1.current_rot = { x = 0, y = 14.7653, z = 0 }
        arg1:play_chore(forklift_down_hold)
        arg1:set_collision_mode(COLLISION_BOX, 1)
    end
end
de.forklift_actor.default = function(arg1) -- line 44
    arg1:free()
    arg1:set_costume("forklift.cos")
    arg1:set_walk_rate(0.4)
    arg1:set_turn_rate(30)
    arg1:set_mumble_chore(forklift_manny_mumble)
    arg1:set_talk_chore(1, forklift_stop_talk)
    arg1:set_talk_chore(2, forklift_a)
    arg1:set_talk_chore(3, forklift_c)
    arg1:set_talk_chore(4, forklift_e)
    arg1:set_talk_chore(5, forklift_f)
    arg1:set_talk_chore(6, forklift_l)
    arg1:set_talk_chore(7, forklift_m)
    arg1:set_talk_chore(8, forklift_o)
    arg1:set_talk_chore(9, forklift_t)
    arg1:set_talk_chore(10, forklift_u)
    arg1:play_chore(forklift_mc_hide)
    if not arg1.blades_up then
        arg1:play_chore(forklift_down_hold)
    else
        arg1:play_chore(forklift_up_hold)
    end
    arg1:follow_boxes()
    SetActorReflection(arg1.hActor, 0)
    arg1.turns_disabled = FALSE
end
de.forklift_actor.spot_offset = { x = 0.019602999, y = -0.31899399, z = 0 }
de.forklift_actor.use_offset = { x = 0.35984999, y = -0.37974, z = 0 }
de.forklift_actor.out_offset = { x = 0.48767999, y = -0.37901601, z = 0 }
de.forklift_actor.lever_offset = { x = -0.2846958, y = 0.066358998, z = 0 }
de.forklift_actor.lever_use_offset = { x = -0.434297, y = 0.004007, z = 0 }
de.forklift_actor.get_spot_point = function(arg1) -- line 81
    local local1, local2, local3
    local2 = arg1:getrot()
    local1 = RotateVector(arg1.spot_offset, local2)
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = 0.47999999
    return local1.x, local1.y, local1.z
end
de.forklift_actor.get_use_point = function(arg1) -- line 94
    local local1, local2, local3
    local2 = arg1:getrot()
    local1 = RotateVector(arg1.use_offset, local2)
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = 0
    return local1.x, local1.y, local1.z
end
de.forklift_actor.get_out_point = function(arg1) -- line 107
    local local1, local2, local3
    local2 = arg1:getrot()
    local1 = RotateVector(arg1.out_offset, local2)
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = 0
    return local1.x, local1.y, local1.z
end
de.forklift_actor.get_lever_points = function(arg1) -- line 120
    local local1, local2, local3, local4
    local3 = arg1:getrot()
    local1 = RotateVector(arg1.lever_offset, local3)
    local4 = arg1:getpos()
    local1.x = local1.x + local4.x
    local1.y = local1.y + local4.y
    local1.z = 0.30000001
    local2 = RotateVector(arg1.lever_use_offset, local3)
    local2.x = local2.x + local4.x
    local2.y = local2.y + local4.y
    local2.z = 0
    return local1.x, local1.y, local1.z, local2.x, local2.y, local2.z
end
de.forklift_actor.get_use_rot = function(arg1) -- line 138
    local local1
    local1 = arg1:getrot()
    local1.y = local1.y + 87.834099
    if local1.y > 360 then
        local1.y = local1.y - 360
    end
    return local1.x, local1.y, local1.z
end
de.forklift_actor.can_get_out_here = function(arg1) -- line 149
    local local1, local2, local3, local4, local5, local6
    local local7 = FALSE
    system.currentSet:activate_forklift_boxes(FALSE)
    local1, local2, local3 = arg1:get_use_point()
    if GetPointSector(local1, local2, local3) then
        local1, local2, local3 = arg1:get_out_point()
        if GetPointSector(local1, local2, local3) then
            local4, local5, local6, local1, local2, local3 = arg1:get_lever_points()
            if GetPointSector(local1, local2, local3) then
                local7 = TRUE
            end
        end
    end
    system.currentSet:activate_forklift_boxes(TRUE)
    return local7
end
de.forklift_actor.update_object = function(arg1) -- line 171
    local local1 = { }
    local local2 = { }
    local local3 = { }
    local1.x, local1.y, local1.z = arg1:get_use_point()
    system.currentSet.forklift.use_pnt_x = local1.x
    system.currentSet.forklift.use_pnt_y = local1.y
    system.currentSet.forklift.use_pnt_z = local1.z
    local2.x, local2.y, local2.z = arg1:get_use_rot()
    system.currentSet.forklift.use_rot_x = local2.x
    system.currentSet.forklift.use_rot_y = local2.y
    system.currentSet.forklift.use_rot_z = local2.z
    local1.x, local1.y, local1.z = arg1:get_spot_point()
    system.currentSet.forklift.obj_x = local1.x
    system.currentSet.forklift.obj_y = local1.y
    system.currentSet.forklift.obj_z = local1.z
    system.currentSet.forklift.interest_actor:setpos(local1.x, local1.y, local1.z)
    local1.x, local1.y, local1.z, local3.x, local3.y, local3.z = arg1:get_lever_points()
    system.currentSet.lever.obj_x = local1.x
    system.currentSet.lever.obj_y = local1.y
    system.currentSet.lever.obj_z = local1.z
    system.currentSet.lever.interest_actor:setpos(local1.x, local1.y, local1.z)
    system.currentSet.lever.use_pnt_x = local3.x
    system.currentSet.lever.use_pnt_y = local3.y
    system.currentSet.lever.use_pnt_z = local3.z
    local2 = arg1:getrot()
    system.currentSet.lever.use_rot_x = local2.x
    system.currentSet.lever.use_rot_y = local2.y + 267
    system.currentSet.lever.use_rot_z = local2.z
end
de.forklift_actor.mount = function(arg1) -- line 206
    if de:walk_to_forklift() then
        START_CUT_SCENE()
        arg1:play_chore(forklift_mc_climb_fork)
        manny:set_visibility(FALSE)
        arg1:wait_for_chore(forklift_mc_climb_fork)
        arg1:play_chore(forklift_mc_in_fork)
        manny:put_in_set(nil)
        manny.say_line = manny.forklift_say_line
        arg1:set_selected()
        system.currentSet.forklift:make_untouchable()
        system.currentSet.lever:make_untouchable()
        arg1:set_walk_chore(-1)
        arg1:set_turn_chores(-1, -1)
        arg1:follow_boxes()
        SetActorReflection(arg1.hActor, 50)
        system.currentSet:activate_forklift_boxes(TRUE)
        arg1:follow_boxes()
        system.buttonHandler = forklift_button_handler
        manny.is_driving = TRUE
        inventory_disabled = TRUE
        start_sfx("forkStrt.WAV")
        sleep_for(1500)
        start_sfx("forkIdle.IMU")
        END_CUT_SCENE()
    end
end
de.forklift_actor.dismount = function(arg1) -- line 238
    local local1, local2, local3, local4
    if not arg1:can_get_out_here() then
        system.default_response("not here")
        return FALSE
    end
    START_CUT_SCENE()
    manny.is_driving = FALSE
    stop_script(arg1.forward)
    stop_script(arg1.backward)
    stop_script(arg1.turn_left)
    stop_script(arg1.turn_right)
    if sound_playing("forkDriv.IMU") then
        fade_sfx("forkDriv.IMU", 100)
    end
    stop_sound("forkBkup.IMU")
    box_on("fork_box1")
    if system.currentSet == de then
        MakeSectorActive("fork_box1", TRUE)
        MakeSectorActive("fork_box2", TRUE)
        MakeSectorActive("fork_box3", TRUE)
        MakeSectorActive("fork_box4", TRUE)
        MakeSectorActive("fork_box5", TRUE)
        MakeSectorActive("fork_box6", TRUE)
    end
    if not de.forklift_actor:find_sector_name("fork_box1") and not de.shaft.stuck then
        local4 = de.forklift_actor:get_positive_rot()
        if local4.y > 220 and local4.y < 300 then
            de.forklift_actor:setrot(0, 270, 0, TRUE)
            de.forklift_actor:set_walk_rate(0.40000001)
        else
            de.forklift_actor:setrot(0, 88, 0, TRUE)
            de.forklift_actor:set_walk_rate(-0.40000001)
        end
        while not de.forklift_actor:find_sector_name("fork_box1") do
            WalkActorForward(de.forklift_actor.hActor)
            break_here()
        end
    end
    system.currentSet:activate_forklift_boxes(FALSE)
    stop_sound("forkIdle.IMU")
    start_sfx("forkStop.WAV")
    arg1:play_chore(forklift_mc_out)
    arg1:wait_for_chore(forklift_mc_out)
    arg1:update_object()
    system.currentSet.forklift:make_touchable()
    system.currentSet.lever:make_touchable()
    local1, local2, local3 = de.forklift_actor:get_out_point()
    manny:put_in_set(system.currentSet)
    manny:setpos(local1, local2, local3)
    local4 = arg1:getrot()
    manny:setrot(local4.x, local4.y + 280, local4.z)
    manny:set_visibility(TRUE)
    arg1:stop_chore(forklift_mc_out)
    arg1:play_chore(forklift_mc_hide)
    arg1:set_collision_mode(COLLISION_BOX, 1)
    END_CUT_SCENE()
    manny:set_selected()
    system.buttonHandler = SampleButtonHandler
    manny.say_line = manny.normal_say_line
    inventory_disabled = FALSE
    arg1.current_pos = arg1:getpos()
    arg1.current_rot = arg1:getrot()
end
manny.forklift_say_line = function(arg1, arg2, arg3) -- line 318
    local local1
    if not manny.is_driving then
        Actor.normal_say_line(arg1, arg2, arg3)
    else
        local1 = de.forklift_actor.name
        de.forklift_actor.name = manny.name
        de.forklift_actor:say_line(arg2, arg3)
        de.forklift_actor.name = local1
    end
end
de.forklift_actor.forward = function(arg1) -- line 331
    stop_script(arg1.backward)
    if sound_playing("forkBkup.IMU") then
        stop_sound("forkBkup.IMU")
    end
    if sound_playing("forkIdle.IMU") then
        fade_sfx("forkIdle.IMU", 100, 0)
    end
    arg1:set_walk_rate(0.4)
    start_sfx("forkDriv.IMU")
    while get_generic_control_state("MOVE_FORWARD") and cutSceneLevel <= 0 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    fade_sfx("forkDriv.IMU", 500, 0)
    if not sound_playing("forkIdle.IMU") then
        start_sfx("forkIdle.IMU")
    else
        fade_sfx("forkIdle.IMU", 100, 127)
    end
end
de.forklift_actor.backward = function(arg1) -- line 356
    stop_script(arg1.forward)
    if sound_playing("forkDriv.IMU") then
        fade_sfx("forkDriv.IMU", 500, 0)
    end
    if not sound_playing("forkIdle.IMU") then
        start_sfx("forkIdle.IMU")
    end
    start_sfx("forkBkup.IMU")
    arg1:set_walk_rate(-0.3)
    while get_generic_control_state("MOVE_BACKWARD") and cutSceneLevel <= 0 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:set_walk_rate(0.4)
    stop_sound("forkBkup.IMU")
end
de.forklift_actor.turn_left = function(arg1) -- line 376
    stop_script(arg1.turn_right)
    while get_generic_control_state("TURN_LEFT") and cutSceneLevel <= 0 do
        if not arg1.turns_disabled then
            TurnActor(arg1.hActor, 1)
        end
        break_here()
    end
end
de.forklift_actor.turn_right = function(arg1) -- line 387
    stop_script(arg1.turn_left)
    while get_generic_control_state("TURN_RIGHT") and cutSceneLevel <= 0 do
        if not arg1.turns_disabled then
            TurnActor(arg1.hActor, -1)
        end
        break_here()
    end
end
de.forklift_actor.driveto = function(arg1, arg2, arg3, arg4) -- line 398
    local local1
    arg1:set_walk_chore(-1)
    arg1:set_turn_chores(-1, -1)
    arg1:set_walk_rate(0.40000001)
    if sound_playing("forkBkup.IMU") then
        stop_sound("forkBkup.IMU")
    end
    if sound_playing("forkIdle.IMU") then
        fade_sfx("forkIdle.IMU", 100, 0)
    end
    start_sfx("forkDriv.IMU")
    while proximity(arg1.hActor, arg2, arg3, arg4) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    fade_sfx("forkDriv.IMU", 500, 0)
    if not sound_playing("forkIdle.IMU") then
        start_sfx("forkIdle.IMU")
    else
        fade_sfx("forkIdle.IMU", 100, 127)
    end
end
de.forklift_actor.monitor_boxes = function(arg1) -- line 423
    local local1, local2
    while TRUE do
        local1 = arg1:get_positive_rot()
        if local1.y > 40 and local1.y < 130 then
            MakeSectorActive("fork_box2", TRUE)
            MakeSectorActive("fork_box3", TRUE)
            local2 = de.shaft:getpos()
            if not arg1.blades_up and local2.z >= -0.0204992 and local2.z <= 1.62642 then
                MakeSectorActive("fork_box5", TRUE)
                MakeSectorActive("fork_box6", TRUE)
            else
                MakeSectorActive("fork_box5", FALSE)
                MakeSectorActive("fork_box6", FALSE)
            end
        else
            MakeSectorActive("fork_box2", FALSE)
            MakeSectorActive("fork_box3", FALSE)
            MakeSectorActive("fork_box5", FALSE)
            MakeSectorActive("fork_box6", FALSE)
        end
        if not de.grating:is_open() then
            MakeSectorActive("fork_stuck_trig", TRUE)
            MakeSectorActive("fork_trigger", FALSE)
            MakeSectorActive("fork_exit_box", FALSE)
            if local1.y > 10 and local1.y < 170 then
                MakeSectorActive("fork_box4", TRUE)
            else
                MakeSectorActive("fork_box4", FALSE)
                while not arg1:find_sector_name("fork_box") do
                    WalkActorForward(arg1.hActor)
                    break_here()
                end
            end
            if arg1:find_sector_name("fork_box2") or arg1:find_sector_name("fork_box3") then
                arg1.turns_disabled = TRUE
                arg1:setrot(0, 90, 0, TRUE)
            else
                arg1.turns_disabled = FALSE
            end
        else
            arg1.turns_disabled = FALSE
            MakeSectorActive("fork_box2", TRUE)
            MakeSectorActive("fork_box3", TRUE)
            MakeSectorActive("fork_box4", TRUE)
            MakeSectorActive("fork_box5", TRUE)
            MakeSectorActive("fork_box6", TRUE)
            MakeSectorActive("fork_exit_box", TRUE)
            MakeSectorActive("fork_trigger", TRUE)
            MakeSectorActive("fork_stuck_trig", FALSE)
        end
        if de.forklift_actor.currentSet == de and manny.is_driving then
            de.forklift_actor:follow_boxes()
        end
        break_here()
    end
end
de.forklift_actor.slide_out = function(arg1) -- line 491
    local local1 = 0
    local local2 = -0.1
    local local3
    stop_script(arg1.monitor_boxes)
    START_CUT_SCENE()
    local3 = de.shaft:getpos()
    while local3.z < 1.227 do
        break_here()
        local3 = de.shaft:getpos()
    end
    de.forklift_actor:set_walk_chore(-1)
    de.forklift_actor:set_turn_chores(-1, -1)
    while arg1:find_sector_name("fork_box5") or arg1:find_sector_name("fork_box6") or arg1:find_sector_name("fork_box2") or arg1:find_sector_name("fork_box3") do
        local1 = local1 + 1
        SetActorPitch(arg1.hActor, local1)
        arg1:set_walk_rate(local2)
        WalkActorForward(arg1.hActor)
        local2 = local2 - 0.1
        break_here()
    end
    de.forklift_actor:set_walk_chore(-1)
    de.forklift_actor:set_turn_chores(-1, -1)
    while local1 > 0 and local2 < 0 do
        local1 = local1 - 1
        SetActorPitch(arg1.hActor, local1)
        local2 = local2 + 0.5
        arg1:set_walk_rate(local2)
        WalkActorForward(arg1.hActor)
        break_here()
    end
    de.forklift_actor:set_walk_chore(-1)
    de.forklift_actor:set_turn_chores(-1, -1)
    local1 = 3
    while local1 > 0 do
        SetActorPitch(arg1.hActor, local1)
        break_here()
        SetActorPitch(arg1.hActor, 0)
        break_here()
        local1 = local1 - 1
    end
    END_CUT_SCENE()
    arg1:set_walk_chore(-1)
    arg1:set_turn_chores(-1, -1)
    start_script(arg1.monitor_boxes, arg1)
end
de.forklift_actor.stop_elevator = function(arg1) -- line 545
    local local1, local2
    local local3
    stop_script(arg1.monitor_boxes)
    cur_puzzle_state[21] = TRUE
    START_CUT_SCENE()
    stop_sound("deRun.IMU")
    start_sfx("deCrash.WAV")
    local3 = de.shaft:getpos()
    while local3.z > de.shaft.z_pos["stuck"] do
        break_here()
        local3 = de.shaft:getpos()
    end
    stop_script(de.raise_elevator)
    start_script(de.shaft.follow_blades, de.shaft)
    local1 = 0
    local2 = 1
    while local1 > -8 do
        local1 = local1 - local2
        SetActorPitch(arg1.hActor, local1)
        local2 = local2 + 0.5
        break_here()
    end
    sleep_for(1000)
    while local1 < 0 do
        local1 = local1 + 0.2
        if local1 > 0 then
            local1 = 0
        end
        SetActorPitch(arg1.hActor, local1)
        break_here()
    end
    de.shaft.floor = "stuck"
    de.shaft.stuck = TRUE
    de.shaft:setpos(-0.71435797, -0.29663301, de.shaft.z_pos["stuck"])
    END_CUT_SCENE()
    arg1:set_walk_chore(-1)
    arg1:set_turn_chores(-1, -1)
end
de.forklift_actor.back_out_stuck = function(arg1) -- line 591
    local local1
    START_CUT_SCENE()
    single_start_script(de.continue_raise_elevator, de)
    box_on("fork_box1")
    de.shaft.stuck = FALSE
    de.forklift_actor:setrot(0, 88, 0, TRUE)
    de.forklift_actor:wait_for_actor()
    de.forklift_actor:set_walk_rate(-0.40000001)
    if not sound_playing("forkIdle.IMU") then
        start_sfx("forkIdle.IMU")
    end
    start_sfx("forkBkup.IMU")
    while not de.forklift_actor:find_sector_name("fork_box1") do
        de.forklift_actor:walk_forward()
        break_here()
    end
    de.forklift_actor:set_walk_rate(0.40000001)
    stop_sound("forkBkup.IMU")
    local1 = de.shaft:getpos()
    while local1.z > de.shaft.z_pos["stuck"] - 2 do
        break_here()
        local1 = de.shaft:getpos()
    end
    END_CUT_SCENE()
end
de.forklift_actor.monitor_objects = function(arg1) -- line 623
    local local1, local2, local3, local4
    local3 = system.currentSet.forklift
    local4 = system.currentSet.lever
    while TRUE do
        if not manny.is_driving and arg1.currentSet == system.currentSet then
            local1 = proximity(manny.hActor, local3.use_pnt_x, local3.use_pnt_y, local3.use_pnt_z)
            local2 = proximity(manny.hActor, local4.use_pnt_x, local4.use_pnt_y, local4.use_pnt_z)
            if local1 > local2 then
                system.currentSet.forklift.touchable = FALSE
                system.currentSet.lever.touchable = TRUE
                if hot_object == system.currentSet.forklift then
                    hot_object = nil
                end
            else
                system.currentSet.forklift.touchable = TRUE
                system.currentSet.lever.touchable = FALSE
                if hot_object == system.currentSet.lever then
                    hot_object = nil
                end
            end
        end
        break_here()
    end
end
de.walk_to_forklift = function(arg1) -- line 653
    START_CUT_SCENE()
    manny:walkto_object(system.currentSet.forklift)
    manny:wait_for_actor()
    de.forklift_actor:set_collision_mode(COLLISION_OFF)
    manny:walkto_object(system.currentSet.forklift)
    manny:wait_for_actor()
    END_CUT_SCENE()
    return TRUE
end
forklift_button_handler = function(arg1, arg2, arg3) -- line 665
    if cutSceneLevel <= 0 then
        if control_map.PICK_UP[arg1] or control_map.USE[arg1] then
            if arg2 then
                start_script(de.forklift_actor.dismount, de.forklift_actor)
            end
        elseif control_map.MOVE_FORWARD[arg1] then
            if not de.shaft.stuck then
                if arg2 then
                    if not find_script(de.forklift_actor.forward) then
                        start_script(de.forklift_actor.forward, de.forklift_actor)
                    end
                end
            end
        elseif control_map.MOVE_BACKWARD[arg1] then
            if arg2 then
                if de.shaft.stuck and de.shaft.floor == "secret_hallway" then
                    manny:say_line("/dema003/")
                elseif de.shaft.stuck then
                    single_start_script(de.forklift_actor.back_out_stuck, de.forklift_actor)
                elseif not find_script(de.forklift_actor.backward) then
                    start_script(de.forklift_actor.backward, de.forklift_actor)
                end
            end
        elseif control_map.TURN_LEFT[arg1] then
            if not de.shaft.stuck then
                if arg2 then
                    single_start_script(de.forklift_actor.turn_left, de.forklift_actor)
                end
            end
        elseif control_map.TURN_RIGHT[arg1] then
            if not de.shaft.stuck then
                if arg2 then
                    single_start_script(de.forklift_actor.turn_right, de.forklift_actor)
                end
            end
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
de.shaft = Actor:create(nil, nil, nil, "elevator shaft")
de.shaft.floor = "bottom_floor"
de.shaft.z_pos = { bottom_floor = 13.0895, top_floor = -8.0805902, secret_hallway = 1.62642, stuck = -0.0204992 }
de.shaft.default = function(arg1) -- line 723
    arg1:free()
    arg1:set_costume("forklift.cos")
    arg1:put_in_set(de)
    arg1:setpos(-0.714358, -0.296633, -8.08059)
    arg1:setrot(0, 89.9778, 0)
    if arg1.z_pos[arg1.floor] then
        arg1:setpos(-0.714358, -0.296633, arg1.z_pos[arg1.floor])
    end
    arg1:play_chore(forklift_shaft_only)
end
de.shaft.follow_blades = function(arg1) -- line 735
    local local1, local2, local3, local4
    local4 = arg1:getpos()
    while TRUE do
        local1, local2, local3 = GetActorNodeLocation(de.forklift_actor.hActor, 20)
        arg1:setpos(local4.x, local4.y, local3 - 0.1481148)
        break_here()
    end
end
de.raise_elevator = function(arg1) -- line 746
    local local1, local2, local3
    local local4 = FALSE
    de.shaft.floor = "going_up"
    de.grating:play_chore(de_screen_close)
    de.grating:wait_for_chore()
    de.grating:close()
    sleep_for(1000)
    start_sfx("deStart.wav")
    sleep_for(1750)
    start_sfx("deRun.IMU")
    local2 = de.shaft:getpos()
    local3 = 0
    while local3 < 10 do
        local2.z = local2.z + 0.0049999999
        local3 = local3 + 1
        de.shaft:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
    local2 = de.shaft:getpos()
    local1 = de.shaft.z_pos["top_floor"]
    local3 = 0.0099999998
    while local2.z > local1 do
        local2.z = local2.z - local3
        if abs(local2.z - local1) <= 1 then
            if not local4 then
                local4 = TRUE
                fade_sfx("deRun.IMU", 500, 0)
                start_sfx("deStop.WAV")
            end
            if local3 > 0.0099999998 then
                local3 = local3 - local3 / 10
            end
        elseif local3 < 0.1 then
            local3 = local3 + local3 / 10
        end
        de.shaft:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
    de.shaft:setpos(local2.x, local2.y, local1)
    if de.shaft.floor == "going_up" then
        start_sfx("deThump.wav")
        sleep_for(750)
        de.grating:play_chore(de_screen_open)
        de.grating:wait_for_chore()
        de.grating:open()
        de.shaft.floor = "top_floor"
    end
end
de.continue_raise_elevator = function(arg1) -- line 801
    local local1 = FALSE
    local local2, local3, local4
    de.shaft.stuck = FALSE
    de.shaft.floor = "going_up"
    start_sfx("deStart.wav")
    sleep_for(1750)
    start_sfx("deRun.IMU")
    sleep_for(1000)
    stop_script(de.shaft.follow_blades)
    single_start_script(de.forklift_actor.monitor_boxes, de.forklift_actor)
    local2 = de.shaft:getpos()
    local1 = de.shaft.z_pos["top_floor"]
    local3 = 0.050000001
    while local2.z > local1 do
        local2.z = local2.z - local3
        if abs(local2.z - local1) <= 1 then
            if not local4 then
                local4 = TRUE
                fade_sfx("deRun.IMU", 500, 0)
                start_sfx("deStop.WAV")
            end
            if local3 > 0.0099999998 then
                local3 = local3 - local3 / 10
            end
        elseif local3 < 0.1 then
            local3 = local3 + local3 / 10
        end
        de.shaft:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
    de.shaft:setpos(local2.x, local2.y, local1)
    if de.shaft.floor == "going_up" then
        start_sfx("deThump.wav")
        sleep_for(750)
        de.grating:play_chore(de_screen_open)
        de.grating:wait_for_chore()
        de.grating:open()
        de.shaft.floor = "top_floor"
    end
end
de.lower_elevator = function(arg1) -- line 849
    local local1, local2, local3
    local local4 = FALSE
    de.shaft.floor = "going_down"
    de.grating:play_chore(de_screen_close)
    de.grating:wait_for_chore()
    de.grating:close()
    sleep_for(1000)
    start_sfx("deStart.wav")
    sleep_for(1750)
    start_sfx("deRun.IMU")
    local2 = de.shaft:getpos()
    local3 = 0
    while local3 < 10 do
        local2.z = local2.z - 0.0049999999
        local3 = local3 + 1
        de.shaft:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
    local2 = de.shaft:getpos()
    local1 = de.shaft.z_pos["bottom_floor"]
    local3 = 0.0099999998
    while local2.z < local1 do
        local2.z = local2.z + local3
        if abs(local2.z - local1) <= 1 then
            if not local4 then
                local4 = TRUE
                fade_sfx("deRun.IMU", 500, 0)
                start_sfx("deStop.WAV")
            end
            if local3 > 0.0099999998 then
                local3 = local3 - local3 / 10
            end
        elseif local3 < 0.1 then
            local3 = local3 + local3 / 10
        end
        de.shaft:setpos(local2.x, local2.y, local2.z)
        break_here()
    end
    de.shaft:setpos(local2.x, local2.y, local1)
    if de.shaft.floor == "going_down" then
        start_sfx("deThump.wav")
        sleep_for(750)
        de.grating:play_chore(de_screen_open)
        de.grating:wait_for_chore()
        de.grating:open()
        de.shaft.floor = "bottom_floor"
    end
end
de.activate_forklift_boxes = function(arg1, arg2) -- line 907
    if arg2 then
        MakeSectorActive("manny_box", FALSE)
        MakeSectorActive("fork_box1", TRUE)
        if de.grating:is_open() then
            MakeSectorActive("fork_trigger", TRUE)
            MakeSectorActive("fork_stuck_trig", FALSE)
        else
            MakeSectorActive("fork_trigger", FALSE)
            MakeSectorActive("fork_stuck_trig", TRUE)
        end
        start_script(de.forklift_actor.monitor_boxes, de.forklift_actor)
    else
        stop_script(de.forklift_actor.monitor_boxes)
        MakeSectorActive("manny_box", TRUE)
        MakeSectorActive("fork_box1", FALSE)
        MakeSectorActive("fork_box2", FALSE)
        MakeSectorActive("fork_box3", FALSE)
        MakeSectorActive("fork_box4", FALSE)
        MakeSectorActive("fork_box5", FALSE)
        MakeSectorActive("fork_box6", FALSE)
        MakeSectorActive("fork_exit_box", FALSE)
        MakeSectorActive("fork_trigger", FALSE)
        MakeSectorActive("fork_stuck_trig", FALSE)
    end
end
de.drive_in = function(arg1) -- line 935
    de:switch_to_set()
    de.forklift_actor:put_in_set(de)
    de.forklift_actor:setpos(-0.160368, -0.42447, 0)
    de.forklift_actor:setrot(0, -89.1654, 0)
    de.forklift_actor.currentSet = de
    de.forklift_actor.current_pos = { x = -0.160368, y = -0.42447, z = 0 }
    de.forklift_actor.current_rot = { x = 0, y = -89.1654, z = 0 }
end
de.enter = function(arg1) -- line 1019
    NewObjectState(de_frkha, OBJSTATE_STATE, "de_screen.bm", "de_screen.zbm")
    de.grating:set_object_state("de_screen.cos")
    if de.grating:is_open() then
        de.grating:play_chore(de_screen_set_open)
    else
        de.grating:play_chore(de_screen_set_closed)
    end
    he.elevator:unlock()
    de.forklift_actor:initialize()
    if de.forklift_actor.currentSet == de then
        de.forklift_actor:put_in_set(de)
        de.forklift_actor:set_visibility(TRUE)
        de.forklift_actor:setpos(de.forklift_actor.current_pos.x, de.forklift_actor.current_pos.y, de.forklift_actor.current_pos.z)
        de.forklift_actor:setrot(de.forklift_actor.current_rot.x, de.forklift_actor.current_rot.y, de.forklift_actor.current_rot.z)
        de.forklift_actor:update_object()
        de.forklift:make_touchable()
        de.lever:make_touchable()
    else
        de.forklift:make_untouchable()
        de.lever:make_untouchable()
    end
    de.shaft:default()
    SetActorClipActive(de.shaft.hActor, TRUE)
    SetActorClipPlane(de.shaft.hActor, -376, -6, 156, -2.07293, -0.024033, -2.4744)
    de:activate_forklift_boxes(manny.is_driving)
    manny:set_collision_mode(COLLISION_SPHERE, 0.35)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 5)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(de.forklift_actor.hActor, 0)
    SetActorShadowPoint(de.forklift_actor.hActor, 0, 0, 5)
    SetActorShadowPlane(de.forklift_actor.hActor, "shadow1")
    AddShadowPlane(de.forklift_actor.hActor, "shadow1")
    if manny.is_driving then
        manny.say_line = manny.forklift_say_line
        start_sfx("forkIdle.IMU")
    end
    single_start_script(de.forklift_actor.monitor_objects, de.forklift_actor)
end
de.exit = function(arg1) -- line 1072
    stop_sound("forkIdle.IMU")
    stop_sound("forkDriv.IMU")
    stop_sound("forkBkup.IMU")
    stop_sound("deRun.IMU")
    stop_script(de.shaft.follow_blades)
    stop_script(de.forklift_actor.monitor_boxes)
    manny:set_collision_mode(COLLISION_OFF)
    KillActorShadows(manny.hActor)
    KillActorShadows(de.forklift_actor.hActor)
    stop_script(de.forklift_actor.monitor_objects)
end
de.forklift = Object:create(de, "/detx001/forklift", -0.019050101, -0.223704, 0.44, { range = 0.69999999 })
de.forklift.use_pnt_x = 0.42223001
de.forklift.use_pnt_y = -0.55665803
de.forklift.use_pnt_z = 0
de.forklift.use_rot_x = 0
de.forklift.use_rot_y = 425.66
de.forklift.use_rot_z = 0
de.forklift.touchable = FALSE
de.forklift.lookAt = function(arg1) -- line 1104
    if de.shaft.stuck then
        manny:say_line("/dema002/")
    else
        wc.forklift:lookAt()
    end
end
de.forklift.pickUp = function(arg1) -- line 1113
    wc.forklift:pickUp()
end
de.forklift.lower_blades = function(arg1) -- line 1117
    de.forklift_actor.blades_up = FALSE
    START_CUT_SCENE()
    manny:walkto_object(system.currentSet.lever)
    de.forklift_actor:play_chore(forklift_fork_down, "forklift.cos")
    manny:set_visibility(FALSE)
    sleep_for(200)
    start_sfx("forkUpDn.WAV")
    sleep_for(933)
    if system.currentSet == de and de.shaft.floor == "secret_hallway" then
        de.grating:play_chore(de_screen_close)
        de.grating:close()
    end
    sleep_for(900)
    manny:set_visibility(TRUE)
    de.forklift_actor:play_chore(forklift_mc_hide)
    de.forklift_actor:wait_for_chore(forklift_fork_down)
    de.forklift_actor:play_chore(forklift_down_hold, "forklift.cos")
    END_CUT_SCENE()
    if system.currentSet == de and de.shaft.floor == "secret_hallway" then
        de.shaft.floor = "stuck"
    end
end
de.forklift.raise_blades = function(arg1) -- line 1143
    de.forklift_actor.blades_up = TRUE
    START_CUT_SCENE()
    manny:walkto_object(system.currentSet.lever)
    de.forklift_actor:play_chore(forklift_fork_up, "forklift.cos")
    manny:set_visibility(FALSE)
    sleep_for(200)
    start_sfx("forkUpDn.WAV")
    sleep_for(933)
    if system.currentSet == de and de.shaft.floor == "stuck" then
        de.grating:play_chore(de_screen_open)
        de.grating:open()
    end
    sleep_for(900)
    manny:set_visibility(TRUE)
    de.forklift_actor:play_chore(forklift_mc_hide)
    de.forklift_actor:wait_for_chore(forklift_fork_up)
    de.forklift_actor:play_chore(forklift_up_hold, "forklift.cos")
    END_CUT_SCENE()
    if system.currentSet == de and de.shaft.floor == "stuck" then
        de.shaft.floor = "secret_hallway"
    end
end
de.forklift.use = function(arg1) -- line 1169
    if de.shaft.stuck and de.shaft.floor == "secret_hallway" then
        manny:say_line("/dema003/")
    else
        de.forklift_actor:update_object()
        start_script(de.forklift_actor.mount, de.forklift_actor)
    end
end
de.lever = Object:create(de, "/detx004/lever", -0.65904999, -0.223704, 0.28, { range = 0.60000002 })
de.lever.use_pnt_x = -0.60983902
de.lever.use_pnt_y = -0.54779798
de.lever.use_pnt_z = 0
de.lever.use_rot_x = 0
de.lever.use_rot_y = 371.30499
de.lever.use_rot_z = 0
de.lever.lookAt = function(arg1) -- line 1187
    wc.lever:lookAt()
end
de.lever.use = function(arg1) -- line 1191
    de.forklift_actor:update_object()
    if de.forklift_actor.blades_up then
        de.forklift:lower_blades()
    else
        de.forklift:raise_blades()
    end
end
de.button = Object:create(de, "/detx005/button", 0.050949801, 0.77629697, 0.23, { range = 0.69999999 })
de.button.use_pnt_x = 0.076113999
de.button.use_pnt_y = 0.41569301
de.button.use_pnt_z = 0
de.button.use_rot_x = 0
de.button.use_rot_y = 12.0311
de.button.use_rot_z = 0
de.button.lookAt = function(arg1) -- line 1210
    manny:say_line("/dema006/")
end
de.button.pickUp = function(arg1) -- line 1214
    system.default_response("not how")
end
de.button.use = function(arg1) -- line 1218
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:play_chore(ms_hand_on_obj, "mc.cos")
    sleep_for(500)
    start_sfx("deBtn.WAV")
    manny:wait_for_chore(ms_hand_on_obj, "mc.cos")
    manny:stop_chore(ms_hand_on_obj, "mc.cos")
    manny:play_chore(ms_hand_off_obj, "mc.cos")
    manny:wait_for_chore(ms_hand_off_obj, "mc.cos")
    END_CUT_SCENE()
    if de.shaft.floor == "top_floor" then
        start_script(de.lower_elevator, de)
    elseif de.shaft.floor == "bottom_floor" then
        start_script(de.raise_elevator, de)
    elseif de.shaft.stuck then
        start_script(de.button.stuck, de.button)
    elseif de.shaft.floor == "going_up" or de.shaft.floor == "going_down" then
        manny:say_line("/dema007/")
    end
end
de.button.stuck = function(arg1) -- line 1241
    START_CUT_SCENE()
    manny:head_look_at(de.grating)
    manny:say_line("/dema008/")
    wait_for_message()
    manny:head_look_at(nil)
    manny:say_line("/dema009/")
    END_CUT_SCENE()
end
de.grating = Object:create(de, "/detx010/door", -1.1990499, -0.643704, 0.47999999, { range = 1.2 })
de.grating.use_pnt_x = -0.40065399
de.grating.use_pnt_y = 0.40080401
de.grating.use_pnt_z = 0
de.grating.use_rot_x = 0
de.grating.use_rot_y = 98.296898
de.grating.use_rot_z = 0
de.grating.out_pnt_x = -0.89499998
de.grating.out_pnt_y = 0.328538
de.grating.out_pnt_z = 0
de.grating.out_rot_x = 0
de.grating.out_rot_y = 98.296898
de.grating.out_rot_z = 0
de.grating.opened = TRUE
de.grating.left_use_pnt_x = -0.335446
de.grating.left_use_pnt_y = -1.1489
de.grating.left_use_pnt_z = 0
de.grating.left_use_rot_x = 0
de.grating.left_use_rot_y = 85.784401
de.grating.left_use_rot_z = 0
de.grating.left_out_pnt_x = -0.89499998
de.grating.left_out_pnt_y = -1.10788
de.grating.left_out_pnt_z = 0
de.grating.left_out_rot_x = 0
de.grating.left_out_rot_y = 85.784401
de.grating.left_out_rot_z = 0
de.grating.comeOut = function(arg1) -- line 1286
    local local1
    local1 = manny:getpos()
    if local1.x > 1.5700001 then
        START_CUT_SCENE()
        manny:setpos(arg1.left_out_pnt_x, arg1.left_out_pnt_y, arg1.left_out_pnt_z)
        manny:setrot(arg1.left_out_rot_x, arg1.left_out_rot_y + 180, arg1.left_out_rot_z)
        manny:walkto(arg1.left_use_pnt_x, arg1.left_use_pnt_y, arg1.left_use_pnt_z)
        manny:wait_for_actor()
        END_CUT_SCENE()
    else
        Object.come_out_door(arg1)
    end
end
de.grating.walkOut = function(arg1) -- line 1302
    if de.shaft.floor == "top_floor" then
        he:come_out_door(he.elevator)
    elseif de.shaft.floor == "secret_hallway" then
        dh:come_out_door(dh.de_door)
    elseif de.shaft.floor == "stuck" then
        manny:say_line("/dema011/")
    elseif de.shaft.floor == "bottom_floor" then
        wc:switch_to_set()
        manny:put_in_set(wc)
        manny:setpos(wc.de_door.out_pnt_x, wc.de_door.out_pnt_y, wc.de_door.out_pnt_z)
        manny:setrot(wc.de_door.out_rot_x, wc.de_door.out_rot_y + 180, wc.de_door.out_rot_z)
        wc.de_door:play_chore(0)
        wc.de_door:wait_for_chore()
        wc.de_door:open()
        manny:walkto(wc.de_door.use_pnt_x, wc.de_door.use_pnt_y, wc.de_door.use_pnt_z)
    elseif de.shaft.floor == "going_up" or de.shaft.floor == "going_down" then
        manny:say_line("/dema012/")
    end
end
de.grating.lookAt = function(arg1) -- line 1324
    local local1
    if de.shaft.floor == "top_floor" then
        manny:say_line("/dema013/")
    elseif de.shaft.floor == "secret_hallway" then
        manny:say_line("/dema014/")
    elseif de.shaft.stuck then
        manny:say_line("/dema015/")
    elseif de.shaft.floor == "bottom_floor" then
        manny:say_line("/dema016/")
    elseif de.shaft.floor == "going_up" or de.shaft.floor == "going_down" then
        local1 = de.shaft:getpos()
        if de.shaft.floor == "going_up" and local1.z < de.shaft.z_pos["stuck"] or (de.shaft.floor == "going_down" and local1.z > de.shaft.z_pos["secret_hallway"]) then
            manny:say_line("/dema017/")
        else
            Object.lookAt(arg1)
        end
    end
end
de.fork_trigger = { name = "forklift trigger" }
de.fork_trigger.walkOut = function(arg1) -- line 1351
    if de.grating:is_open() then
        if de.shaft.floor ~= "bottom_floor" then
            manny:say_line("/dema012/")
        else
            start_script(wc.drive_in, wc)
        end
    end
end
de.fork_stuck_trig = { name = "forklift stuck trigger" }
de.fork_stuck_trig.walkOut = function(arg1) -- line 1365
    if de.shaft.floor == "going_up" then
        start_script(de.forklift_actor.stop_elevator, de.forklift_actor)
    elseif de.shaft.floor == "going_down" then
        start_script(de.forklift_actor.slide_out, de.forklift_actor)
    end
end

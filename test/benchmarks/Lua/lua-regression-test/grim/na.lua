CheckFirstTime("na.lua")
dofile("na_trapdoor.lua")
na = Set:create("na.set", "navigation room", { na_top = 0, na_intha = 1, na_intws = 2, na_mancu = 3 })
na.bw_out_points = { }
na.bw_out_points[0] = { pos = { x = 3.15329, y = -0.641857, z = 0.5 }, rot = { x = 0, y = 18.6574, z = 0 } }
na.bw_out_points[1] = { pos = { x = -0.222127, y = 3.55086, z = 0.5 }, rot = { x = 0, y = 227.602, z = 0 } }
na.bw_out_points[2] = { pos = { x = -2.89712, y = 3.16993, z = 0.5 }, rot = { x = 0, y = 339.683, z = 0 } }
na.bw_out_points[3] = { pos = { x = 5.22106, y = -1.634, z = 0.5 }, rot = { x = 0, y = 188.897, z = 0 } }
na.bw_out_points[4] = { pos = { x = 0.770985, y = -3.77095, z = 0.5 }, rot = { x = 0, y = 92.7718, z = 0 } }
na.bw_out_points[5] = { pos = { x = 3.32583, y = -1.69583, z = 0.5 }, rot = { x = 0, y = 137.086, z = 0 } }
na.SIGNPOST_SOLVED_DISTANCE = 0.6
na.check_for_nav_solved = function(arg1, arg2) -- line 26
    local local1
    local local2, local3, local4, local5
    local local6
    if not arg2 then
        local1 = proximity(signpost.hActor, na.rubacava_point.x, na.rubacava_point.y, na.rubacava_point.z)
    else
        local1 = sqrt((arg2.x - na.rubacava_point.x) ^ 2 + (arg2.y - na.rubacava_point.y) ^ 2 + (arg2.z - na.rubacava_point.z) ^ 2)
    end
    if local1 <= na.SIGNPOST_SOLVED_DISTANCE then
        START_CUT_SCENE()
        set_override(na.skip_check_nav_solved, na)
        start_sfx("quake.IMU")
        set_pan("quake.IMU", 20)
        sleep_for(500)
        local2 = manny:getpos()
        local3 = manny:get_positive_rot()
        local4 = { x = -1, y = 0.5, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z + 0.30000001
        manny:head_look_at_point(local4.x, local4.y, local4.z)
        sleep_for(2000)
        local5 = start_sfx("quake.IMU")
        set_pan(local5, 100)
        local4 = { x = 1, y = 0.5, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z + 0.30000001
        manny:head_look_at_point(local4.x, local4.y, local4.z)
        sleep_for(2000)
        local4 = { x = 0, y = -3, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z
        manny:setrot(local3.x, local3.y + 180, local3.z, TRUE)
        manny:runto(local4.x, local4.y, local4.z)
        local6 = 0
        while local6 < 2000 and manny:is_moving() do
            break_here()
            local6 = local6 + system.frameTime
        end
        fade_sfx(local5, 3000, 0)
        fade_sfx("quake.IMU", 3000, 0)
        na:current_setup(na_intha)
        RunFullscreenMovie("dooropen.snm")
        END_CUT_SCENE()
        manny:set_run(FALSE)
        na:solve_nav()
        return TRUE
    else
        return FALSE
    end
end
na.skip_check_nav_solved = function(arg1) -- line 93
    kill_override()
    manny:set_run(FALSE)
    stop_sound("quake.IMU")
    na:current_setup(na_intha)
    manny:head_look_at(nil)
    na:solve_nav()
end
na.solve_nav = function(arg1) -- line 102
    cur_puzzle_state[13] = TRUE
    na.trapdoor:make_touchable()
    signpost.current_set = nil
    signpost:free()
    sg.signpost:make_untouchable()
    na.signpost:make_untouchable()
    na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
    bonewagon:set_visibility(TRUE)
    bonewagon:set_collision_mode(COLLISION_BOX, 1)
    if bonewagon.current_set == na then
        bonewagon:setpos(3.60411, -0.419015, 0.5)
        bonewagon:setrot(0, 159.729, 0)
        bonewagon.current_pos = { x = 3.60411, y = -0.419015, z = 0.5 }
        bonewagon.current_rot = { x = 0, y = 159.729, z = 0 }
        sg:park_BW_obj()
    end
    na:activate_trapdoor_boxes(TRUE)
    na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
    manny:put_at_object(na.trapdoor)
    nav_solved = TRUE
    music_state:set_state(stateNA_SOLVED)
    START_CUT_SCENE()
    manny:say_line("/sgma053/")
    manny:wait_for_message()
    END_CUT_SCENE()
end
na.activate_trapdoor_boxes = function(arg1, arg2) -- line 136
    local local1, local2
    MakeSectorActive("na_lb_box", arg2)
    local2 = 1
    while local2 <= 11 do
        local1 = "trap_box" .. local2
        MakeSectorActive(local1, arg2)
        local2 = local2 + 1
    end
    MakeSectorActive("notrap_box", not arg2)
    single_start_script(na.footstep_monitor, na)
end
na.rubacava_point = nil
na.choose_random_sign_point = function(arg1) -- line 154
    local local1
    if arg1.rubacava_point == nil then
        local1 = { }
        local1.x = -1.2223099
        local1.y = -0.205108
        local1.z = 0.5
        arg1.rubacava_point = local1
    end
end
na.tilt_bonewagon = function(arg1) -- line 172
    local local1
    while not bonewagon:find_sector_name("trap_box9") do
        break_here()
    end
    while bonewagon:find_sector_name("trap_box9") do
        local1 = proximity(bonewagon.hActor, -0.161172, -1.64503, 0.5) * -30
        if local1 > 0 then
            local1 = 0
        elseif local1 < -30 then
            local1 = -30
        end
        SetActorPitch(bonewagon.hActor, local1)
        break_here()
    end
end
na.footstep_monitor = function(arg1) -- line 190
    while TRUE do
        if manny:find_sector_name("trap_box9") or manny:find_sector_name("trap_box11") then
            manny.footsteps = footsteps.metal
        else
            manny.footsteps = footsteps.dirt
        end
        break_here()
    end
end
na.examine_signpost = function(arg1) -- line 201
    local local1, local2
    local local3, local4, local5
    local local6
    START_CUT_SCENE()
    local1 = { }
    local1.pos = signpost:getpos()
    local1.rot = signpost:getrot()
    local2 = { }
    local2.pos = manny:getpos()
    local2.rot = manny:getrot()
    local6 = na:current_setup()
    na:current_setup(na_mancu)
    signpost:setpos(4.0353198, -1.21448, 0.5)
    local3 = 3.8364899 + (local2.pos.x - local1.pos.x)
    local4 = -1.23856 + (local2.pos.y - local1.pos.y)
    local5 = 0.5
    manny:ignore_boxes()
    manny:setpos(local3, local4, local5)
    if bonewagon.current_set == system.currentSet then
        bonewagon:set_visibility(FALSE)
        bonewagon:set_collision_mode(COLLISION_OFF)
    end
    manny:head_look_at_point({ 4.0353198, -1.21448, 1 })
    if not na.nav_points.happened then
        manny:say_line("/nama003/")
    else
        manny:say_line("/nama004/")
    end
    manny:wait_for_message()
    sleep_for(1000)
    na:current_setup(local6)
    signpost:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
    manny:follow_boxes()
    manny:setpos(local2.pos.x, local2.pos.y, local2.pos.z)
    manny:head_look_at(na.signpost)
    if bonewagon.current_set == system.currentSet then
        bonewagon:set_visibility(TRUE)
        bonewagon:set_collision_mode(COLLISION_BOX, 1)
    end
    END_CUT_SCENE()
end
na.enter = function(arg1) -- line 255
    manny:set_collision_mode(COLLISION_SPHERE, 0.4)
    na:choose_random_sign_point()
    na:add_object_state(na_intha, "na_trapdoor.bm", "na_trapdoor.zbm", OBJSTATE_STATE)
    na.trapdoor:set_object_state("na_trapdoor.cos")
    if nav_solved then
        na:activate_trapdoor_boxes(TRUE)
        na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
        start_script(na.tilt_bonewagon, na)
    else
        na:activate_trapdoor_boxes(FALSE)
        na.trapdoor:play_chore(na_trapdoor_hide, "na_trapdoor.cos")
    end
    if bonewagon.current_set == arg1 then
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(bonewagon.current_pos.x, bonewagon.current_pos.y, bonewagon.current_pos.z)
        bonewagon:setrot(bonewagon.current_rot.x, bonewagon.current_rot.y, bonewagon.current_rot.z)
        if not manny.is_driving then
            single_start_script(sg.glottis_roars, sg, bonewagon)
        end
    end
    if signpost.current_set == arg1 then
        signpost:put_in_set(arg1)
        signpost:setpos(signpost.current_pos.x, signpost.current_pos.y, signpost.current_pos.z)
        signpost:setrot(signpost.current_rot.x, signpost.current_rot.y, signpost.current_rot.z)
    end
    if manny.is_driving then
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, 127)
    end
    na:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
na.exit = function(arg1) -- line 297
    stop_script(na.footstep_monitor)
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    bonewagon:shut_up()
    stop_script(na.tilt_bonewagon)
    stop_script(bonewagon.cruise_sounds)
    stop_sound("bwIdle.IMU")
end
na.update_music_state = function(arg1) -- line 311
    if manny.is_driving then
        return stateOO_BONE
    elseif nav_solved then
        return stateNA_SOLVED
    else
        return stateNA
    end
end
na.signpost = Object:create(na, "/natx002/sign post", 0, 0, 0, { range = 1.5 })
na.signpost.use_pnt_x = 0
na.signpost.use_pnt_y = 0
na.signpost.use_pnt_z = 0
na.signpost.use_rot_x = 0
na.signpost.use_rot_y = 0
na.signpost.use_rot_z = 0
na.signpost:make_untouchable()
na.signpost.lookAt = function(arg1) -- line 336
    na:examine_signpost()
end
na.signpost.pickUp = function(arg1) -- line 340
    START_CUT_SCENE()
    signpost:set_collision_mode(COLLISION_OFF)
    manny:walkto_object(arg1)
    signpost:pick_up()
    sg.signpost:get()
    manny.is_holding = sg.signpost
    arg1:make_untouchable()
    if system.object_names_showing then
        system.currentSet:make_objects_visible()
        system.currentSet:update_object_names()
    end
    END_CUT_SCENE()
end
na.signpost.use = na.signpost.pickUp
na.all_paths = Object:create(na, "/natx005/dark passage", 0, 0, 0, { range = 0 })
na.all_paths.lookAt = function(arg1) -- line 362
    manny:say_line("/nama006/")
end
na.trapdoor = Object:create(na, "/natx007/opening", -1.8434, -1.82987, 0.51999998, { range = 2 })
na.trapdoor.use_pnt_x = -0.208358
na.trapdoor.use_pnt_y = -1.88557
na.trapdoor.use_pnt_z = 0.5
na.trapdoor.use_rot_x = 0
na.trapdoor.use_rot_y = 0
na.trapdoor.use_rot_z = 0
na.trapdoor.out_pnt_x = -0.209998
na.trapdoor.out_pnt_y = 1.02899
na.trapdoor.out_pnt_z = -0.86926502
na.trapdoor.out_rot_x = 0
na.trapdoor.out_rot_y = 0
na.trapdoor.out_rot_z = 0
na.trapdoor:make_untouchable()
na.trapdoor.make_touchable = function(arg1) -- line 385
    Object.make_touchable(arg1)
    if system.object_names_showing then
        na:update_object_names()
    end
end
na.trapdoor.lookAt = function(arg1) -- line 392
    manny:say_line("/nama008/")
end
na.trapdoor.use = function(arg1) -- line 396
    if not manny.is_driving then
        START_CUT_SCENE()
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        lb:come_out_door(lb.na_door)
        END_CUT_SCENE()
    else
        na.glotdriv_trigr:walkOut()
    end
end
na.trapdoor.walkOut = na.trapdoor.use
na.na_lb_box = na.trapdoor
na.glotdriv_trigr = { name = "glotdriv_trigger" }
na.glotdriv_trigr.walkOut = function(arg1) -- line 413
    if manny.is_driving and na.trapdoor.touchable then
        START_CUT_SCENE()
        RunFullscreenMovie("glotdriv.snm")
        bonewagon:put_in_set(nil)
        lb:switch_to_set()
        lb:current_setup(lb_modws)
        END_CUT_SCENE()
    end
end
na.bone_wagon = Object:create(na, "/natx009/Bone Wagon", 0.97060001, -1.1162, 1.2, { range = 2.5 })
na.bone_wagon.use_pnt_x = 0.64422601
na.bone_wagon.use_pnt_y = -1.13239
na.bone_wagon.use_pnt_z = 0.5
na.bone_wagon.use_rot_x = 0
na.bone_wagon.use_rot_y = 645.83502
na.bone_wagon.use_rot_z = 0
na.bone_wagon:make_untouchable()
na.bone_wagon.lookAt = function(arg1) -- line 437
    sg.bone_wagon:lookAt()
end
na.bone_wagon.pickUp = function(arg1) -- line 441
    sg.bone_wagon:pickUp()
end
na.bone_wagon.use = function(arg1) -- line 445
    sg:get_in_BW()
end
na.bone_wagon.use_scythe = function(arg1) -- line 449
    sg.bone_wagon:use_scythe()
end
na.bone_wagon.use_bone = function(arg1) -- line 453
    sg.bone_wagon:use_bone()
end
na.sg_door = Object:create(na, "/natx010/door", 7.43084, -6.4731998, 0, { range = 0.5 })
na.sg_box = na.sg_door
na.sg_door.use_pnt_x = 6.3092499
na.sg_door.use_pnt_y = -5.1433201
na.sg_door.use_pnt_z = 0.5
na.sg_door.use_rot_x = 0
na.sg_door.use_rot_y = 253
na.sg_door.use_rot_z = 0
na.sg_door.out_pnt_x = 7.43084
na.sg_door.out_pnt_y = -6.4731998
na.sg_door.out_pnt_z = 0.5
na.sg_door.out_rot_x = 0
na.sg_door.out_rot_y = -484.245
na.sg_door.out_rot_z = 0
na.sg_door.walkOut = function(arg1) -- line 481
    sg:come_out_door(sg.na_door)
end
na.nav_points = { }
na.nav_points.last_index = nil
na.nav_points.walkOut = function(arg1) -- line 495
    local local1, local2
    START_CUT_SCENE()
    if system.currentActor == manny and get_generic_control_state("RUN") then
        system.currentActor:runto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    elseif system.currentActor == bonewagon then
        bonewagon:stop_movement_scripts()
        bonewagon:set_walk_rate(bonewagon.max_walk_rate)
        fade_sfx("bwIdle.IMU", 1000, 0)
        bonewagon:walkto(arg1.bonewagon_out_pnt_x, arg1.bonewagon_out_pnt_y, arg1.bonewagon_out_pnt_z)
    end
    system.currentActor:wait_for_actor()
    if system.currentActor == manny then
        manny:set_run(FALSE)
    end
    local2 = nil
    while local2 == nil do
        local1 = rndint(1, 12)
        if local1 ~= arg1.index and local1 ~= na.nav_points.last_index then
            if na.nav_points:away_from_signpost(local1) then
                local2 = na.nav_points[local1]
                na.nav_points.last_index = local1
            end
        end
        break_here()
    end
    PrintDebug("out_door = " .. local1 .. "\n")
    if system.currentActor == manny then
        system.currentActor:setpos(local2.out_pnt_x, local2.out_pnt_y, local2.out_pnt_z)
        system.currentActor:runto(local2.use_pnt_x, local2.use_pnt_y, local2.use_pnt_z, local2.use_rot_x, local2.use_rot_y + 180, local2.use_rot_z)
        system.currentActor:wait_for_actor()
    elseif system.currentActor == bonewagon then
        bonewagon:stop_movement_scripts()
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
        system.currentActor:setpos(local2.bonewagon_out_pnt_x, local2.bonewagon_out_pnt_y, local2.bonewagon_out_pnt_z)
        system.currentActor:setrot(local2.bonewagon_out_rot_x, local2.bonewagon_out_rot_y + 180, local2.bonewagon_out_rot_z)
        bonewagon:driveto(local2.use_pnt_x, local2.use_pnt_y, local2.use_pnt_z)
    end
    if not na.nav_points.happened then
        na.nav_points.happened = TRUE
        manny:say_line("/nama001/")
    end
    END_CUT_SCENE()
    if get_generic_control_state("MOVE_FORWARD") then
        if manny.is_driving then
            single_start_script(bonewagon.gas, bonewagon)
        end
    end
end
na.nav_points.away_from_signpost = function(arg1, arg2) -- line 555
    if signpost.current_set ~= na then
        return TRUE
    elseif proximity(signpost.hActor, arg1[arg2].bonewagon_out_pnt_x, arg1[arg2].bonewagon_out_pnt_y, arg1[arg2].bonewagon_out_pnt_z) < 10 then
        return FALSE
    else
        return TRUE
    end
end
na.nav_points[1] = { opened = TRUE, immediate = TRUE, index = 1 }
na.nav_points[1].use_pnt_x = -1.6622699
na.nav_points[1].use_pnt_y = -4.6346402
na.nav_points[1].use_pnt_z = 0.5
na.nav_points[1].use_rot_x = 0
na.nav_points[1].use_rot_y = 146.248
na.nav_points[1].use_rot_z = 0
na.nav_points[1].out_pnt_x = -2.39167
na.nav_points[1].out_pnt_y = -5.4372802
na.nav_points[1].out_pnt_z = 0.5
na.nav_points[1].out_rot_x = 0
na.nav_points[1].out_rot_y = 135.17999
na.nav_points[1].out_rot_z = 0
na.nav_points[1].walkOut = na.nav_points.walkOut
na.nav_points[2] = { opened = TRUE, immediate = TRUE, index = 2 }
na.nav_points[2].use_pnt_x = -4.4720802
na.nav_points[2].use_pnt_y = -1.91714
na.nav_points[2].use_pnt_z = 0.5
na.nav_points[2].use_rot_x = 0
na.nav_points[2].use_rot_y = 133.786
na.nav_points[2].use_rot_z = 0
na.nav_points[2].out_pnt_x = -5.3769598
na.nav_points[2].out_pnt_y = -2.87236
na.nav_points[2].out_pnt_z = 0.5
na.nav_points[2].out_rot_x = 0
na.nav_points[2].out_rot_y = 497.70999
na.nav_points[2].out_rot_z = 0
na.nav_points[2].walkOut = na.nav_points.walkOut
na.nav_points[3] = { opened = TRUE, immediate = TRUE, index = 3 }
na.nav_points[3].use_pnt_x = -6.11096
na.nav_points[3].use_pnt_y = 1.9079601
na.nav_points[3].use_pnt_z = 0.5
na.nav_points[3].use_rot_x = 0
na.nav_points[3].use_rot_y = 122.553
na.nav_points[3].use_rot_z = 0
na.nav_points[3].out_pnt_x = -7.6507502
na.nav_points[3].out_pnt_y = 0.749448
na.nav_points[3].out_pnt_z = 0.5
na.nav_points[3].out_rot_x = 0
na.nav_points[3].out_rot_y = 490.267
na.nav_points[3].out_rot_z = 0
na.nav_points[3].walkOut = na.nav_points.walkOut
na.nav_points[4] = { opened = TRUE, immediate = TRUE, index = 4 }
na.nav_points[4].use_pnt_x = -4.50388
na.nav_points[4].use_pnt_y = 3.57882
na.nav_points[4].use_pnt_z = 0.5
na.nav_points[4].use_rot_x = 0
na.nav_points[4].use_rot_y = 771.30798
na.nav_points[4].use_rot_z = 0
na.nav_points[4].out_pnt_x = -7.9057798
na.nav_points[4].out_pnt_y = 5.7978601
na.nav_points[4].out_pnt_z = 0.5
na.nav_points[4].out_rot_x = 0
na.nav_points[4].out_rot_y = 771.30798
na.nav_points[4].out_rot_z = 0
na.nav_points[4].walkOut = na.nav_points.walkOut
na.nav_points[5] = { opened = TRUE, immediate = TRUE, index = 5 }
na.nav_points[5].use_pnt_x = -4.7105999
na.nav_points[5].use_pnt_y = 6.0127501
na.nav_points[5].use_pnt_z = 0.5
na.nav_points[5].use_rot_x = 0
na.nav_points[5].use_rot_y = 715.633
na.nav_points[5].use_rot_z = 0
na.nav_points[5].out_pnt_x = -4.6799002
na.nav_points[5].out_pnt_y = 9.6187496
na.nav_points[5].out_pnt_z = 0.5
na.nav_points[5].out_rot_x = 0
na.nav_points[5].out_rot_y = 715.633
na.nav_points[5].out_rot_z = 0
na.nav_points[5].walkOut = na.nav_points.walkOut
na.nav_points[6] = { opened = TRUE, immediate = TRUE, index = 6 }
na.nav_points[6].use_pnt_x = -1.34286
na.nav_points[6].use_pnt_y = 6.7671599
na.nav_points[6].use_pnt_z = 0.5
na.nav_points[6].use_rot_x = 0
na.nav_points[6].use_rot_y = 718.26202
na.nav_points[6].use_rot_z = 0
na.nav_points[6].out_pnt_x = -1.0425
na.nav_points[6].out_pnt_y = 10.6854
na.nav_points[6].out_pnt_z = 0.5
na.nav_points[6].out_rot_x = 0
na.nav_points[6].out_rot_y = 718.26202
na.nav_points[6].out_rot_z = 0
na.nav_points[6].walkOut = na.nav_points.walkOut
na.nav_points[7] = { opened = TRUE, immediate = TRUE, index = 7 }
na.nav_points[7].use_pnt_x = 2.0485799
na.nav_points[7].use_pnt_y = 8.4344902
na.nav_points[7].use_pnt_z = 0.5
na.nav_points[7].use_rot_x = 0
na.nav_points[7].use_rot_y = 691.46698
na.nav_points[7].use_rot_z = 0
na.nav_points[7].out_pnt_x = 3.0051601
na.nav_points[7].out_pnt_y = 10.2608
na.nav_points[7].out_pnt_z = 0.5
na.nav_points[7].out_rot_x = 0
na.nav_points[7].out_rot_y = 701.25702
na.nav_points[7].out_rot_z = 0
na.nav_points[7].walkOut = na.nav_points.walkOut
na.nav_points[8] = { opened = TRUE, immediate = TRUE, index = 8 }
na.nav_points[8].use_pnt_x = 4.70544
na.nav_points[8].use_pnt_y = 5.39078
na.nav_points[8].use_pnt_z = 0.5
na.nav_points[8].use_rot_x = 0
na.nav_points[8].use_rot_y = 1047.17
na.nav_points[8].use_rot_z = 0
na.nav_points[8].out_pnt_x = 6.5631399
na.nav_points[8].out_pnt_y = 8.34795
na.nav_points[8].out_pnt_z = 0.5
na.nav_points[8].out_rot_x = 0
na.nav_points[8].out_rot_y = 1047.17
na.nav_points[8].out_rot_z = 0
na.nav_points[8].walkOut = na.nav_points.walkOut
na.nav_points[9] = { opened = TRUE, immediate = TRUE, index = 9 }
na.nav_points[9].use_pnt_x = 7.8786502
na.nav_points[9].use_pnt_y = 3.7764101
na.nav_points[9].use_pnt_z = 0.5
na.nav_points[9].use_rot_x = 0
na.nav_points[9].use_rot_y = 1365.0601
na.nav_points[9].use_rot_z = 0
na.nav_points[9].out_pnt_x = 9.7726297
na.nav_points[9].out_pnt_y = 4.4060798
na.nav_points[9].out_pnt_z = 0.5
na.nav_points[9].out_rot_x = 0
na.nav_points[9].out_rot_y = 1376.39
na.nav_points[9].out_rot_z = 0
na.nav_points[9].walkOut = na.nav_points.walkOut
na.nav_points[10] = { opened = TRUE, immediate = TRUE, index = 10 }
na.nav_points[10].use_pnt_x = 8.5132399
na.nav_points[10].use_pnt_y = 0.23104601
na.nav_points[10].use_pnt_z = 0.5
na.nav_points[10].use_rot_x = 0
na.nav_points[10].use_rot_y = 1717.15
na.nav_points[10].use_rot_z = 0
na.nav_points[10].out_pnt_x = 10.8235
na.nav_points[10].out_pnt_y = 0.91224998
na.nav_points[10].out_pnt_z = 0.5
na.nav_points[10].out_rot_x = 0
na.nav_points[10].out_rot_y = 1733.52
na.nav_points[10].out_rot_z = 0
na.nav_points[10].walkOut = na.nav_points.walkOut
na.nav_points[11] = { opened = TRUE, immediate = TRUE, index = 11 }
na.nav_points[11].use_pnt_x = 8.0326595
na.nav_points[11].use_pnt_y = -2.3932199
na.nav_points[11].use_pnt_z = 0.5
na.nav_points[11].use_rot_x = 0
na.nav_points[11].use_rot_y = 2065.75
na.nav_points[11].use_rot_z = 0
na.nav_points[11].out_pnt_x = 10.7659
na.nav_points[11].out_pnt_y = -2.5953
na.nav_points[11].out_pnt_z = 0.5
na.nav_points[11].out_rot_x = 0
na.nav_points[11].out_rot_y = 2065.75
na.nav_points[11].out_rot_z = 0
na.nav_points[11].walkOut = na.nav_points.walkOut
na.nav_points[12] = { opened = TRUE, immediate = TRUE, index = 12 }
na.nav_points[12].use_pnt_x = 1.89314
na.nav_points[12].use_pnt_y = -6.4507098
na.nav_points[12].use_pnt_z = 0.5
na.nav_points[12].use_rot_x = 0
na.nav_points[12].use_rot_y = 165.52
na.nav_points[12].use_rot_z = 0
na.nav_points[12].out_pnt_x = 1.55873
na.nav_points[12].out_pnt_y = -7.7474899
na.nav_points[12].out_pnt_z = 0.5
na.nav_points[12].out_rot_x = 0
na.nav_points[12].out_rot_y = 165.52
na.nav_points[12].out_rot_z = 0
na.nav_points[12].walkOut = na.nav_points.walkOut
na.nav_points[1].bonewagon_out_pnt_x = -4.7062402
na.nav_points[1].bonewagon_out_pnt_y = -7.51126
na.nav_points[1].bonewagon_out_pnt_z = 0.5
na.nav_points[1].bonewagon_out_rot_x = 0
na.nav_points[1].bonewagon_out_rot_y = 139.108
na.nav_points[1].bonewagon_out_rot_z = 0
na.nav_points[2].bonewagon_out_pnt_x = -7.99891
na.nav_points[2].bonewagon_out_pnt_y = -4.9516501
na.nav_points[2].bonewagon_out_pnt_z = 0.5
na.nav_points[2].bonewagon_out_rot_x = 0
na.nav_points[2].bonewagon_out_rot_y = 136.179
na.nav_points[2].bonewagon_out_rot_z = 0
na.nav_points[3].bonewagon_out_pnt_x = -10.0029
na.nav_points[3].bonewagon_out_pnt_y = -1.71706
na.nav_points[3].bonewagon_out_pnt_z = 0.5
na.nav_points[3].bonewagon_out_rot_x = 0
na.nav_points[3].bonewagon_out_rot_y = 130.61099
na.nav_points[3].bonewagon_out_rot_z = 0
na.nav_points[4].bonewagon_out_pnt_x = -11.9683
na.nav_points[4].bonewagon_out_pnt_y = 7.9263301
na.nav_points[4].bonewagon_out_pnt_z = 0.5
na.nav_points[4].bonewagon_out_rot_x = 0
na.nav_points[4].bonewagon_out_rot_y = 57.449501
na.nav_points[4].bonewagon_out_rot_z = 0
na.nav_points[5].bonewagon_out_pnt_x = -4.9099998
na.nav_points[5].bonewagon_out_pnt_y = 18.455
na.nav_points[5].bonewagon_out_pnt_z = 0.5
na.nav_points[5].bonewagon_out_rot_x = 0
na.nav_points[5].bonewagon_out_rot_y = -40.159
na.nav_points[5].bonewagon_out_rot_z = 0
na.nav_points[6].bonewagon_out_pnt_x = -0.40590999
na.nav_points[6].bonewagon_out_pnt_y = 18.074301
na.nav_points[6].bonewagon_out_pnt_z = 0.5
na.nav_points[6].bonewagon_out_rot_x = 0
na.nav_points[6].bonewagon_out_rot_y = 357.64999
na.nav_points[6].bonewagon_out_rot_z = 0
na.nav_points[7].bonewagon_out_pnt_x = 5.2837901
na.nav_points[7].bonewagon_out_pnt_y = 17.2509
na.nav_points[7].bonewagon_out_pnt_z = 0.5
na.nav_points[7].bonewagon_out_rot_x = 0
na.nav_points[7].bonewagon_out_rot_y = 698.73297
na.nav_points[7].bonewagon_out_rot_z = 0
na.nav_points[8].bonewagon_out_pnt_x = 10.8676
na.nav_points[8].bonewagon_out_pnt_y = 15.5262
na.nav_points[8].bonewagon_out_pnt_z = 0.5
na.nav_points[8].bonewagon_out_rot_x = 0
na.nav_points[8].bonewagon_out_rot_y = 1410.5
na.nav_points[8].bonewagon_out_rot_z = 0
na.nav_points[9].bonewagon_out_pnt_x = 16.0665
na.nav_points[9].bonewagon_out_pnt_y = 7.8298802
na.nav_points[9].bonewagon_out_pnt_z = 0.5
na.nav_points[9].bonewagon_out_rot_x = 0
na.nav_points[9].bonewagon_out_rot_y = 1737.46
na.nav_points[9].bonewagon_out_rot_z = 0
na.nav_points[10].bonewagon_out_pnt_x = 16.580601
na.nav_points[10].bonewagon_out_pnt_y = 0.45177901
na.nav_points[10].bonewagon_out_pnt_z = 0.5
na.nav_points[10].bonewagon_out_rot_x = 0
na.nav_points[10].bonewagon_out_rot_y = 2072.22
na.nav_points[10].bonewagon_out_rot_z = 0
na.nav_points[11].bonewagon_out_pnt_x = 15.2199
na.nav_points[11].bonewagon_out_pnt_y = -3.3735099
na.nav_points[11].bonewagon_out_pnt_z = 0.5
na.nav_points[11].bonewagon_out_rot_x = 0
na.nav_points[11].bonewagon_out_rot_y = 2407.49
na.nav_points[11].bonewagon_out_rot_z = 0
na.nav_points[12].bonewagon_out_pnt_x = -0.120106
na.nav_points[12].bonewagon_out_pnt_y = -11.213
na.nav_points[12].bonewagon_out_pnt_z = 0.5
na.nav_points[12].bonewagon_out_rot_x = 0
na.nav_points[12].bonewagon_out_rot_y = 151.653
na.nav_points[12].bonewagon_out_rot_z = 0
na.path1 = na.nav_points[1]
na.path2 = na.nav_points[2]
na.path3 = na.nav_points[3]
na.path4 = na.nav_points[4]
na.path5 = na.nav_points[5]
na.path6 = na.nav_points[6]
na.path7 = na.nav_points[7]
na.path8 = na.nav_points[8]
na.path9 = na.nav_points[9]
na.path10 = na.nav_points[10]
na.path11 = na.nav_points[11]
na.path12 = na.nav_points[12]
na.writenavpoint = function(arg1, arg2) -- line 855
    local local1
    local local2, local3
    local1 = InputDialog("Nav points", "Index:")
    local1 = tonumber(local1)
    if na.nav_points[local1] == nil then
        na.nav_points[local1] = { }
    end
    local2 = manny:getpos()
    local3 = manny:getrot()
    if arg2 then
        na.nav_points[local1].use_pos = local2
        na.nav_points[local1].use_rot = local3
    else
        na.nav_points[local1].out_pos = local2
        na.nav_points[local1].out_rot = local3
    end
    PrintDebug("Got nav " .. local1 .. "\n")
    writeto("navpoints.txt")
    local1 = 0
    while local1 < 12 do
        if na.nav_points[local1] then
            write("na.nav_points[" .. local1 .. "] = {}\n")
            if na.nav_points[local1].use_pos then
                write("na.nav_points[" .. local1 .. "].use_pnt_x = " .. na.nav_points[local1].use_pos.x .. "\n")
                write("na.nav_points[" .. local1 .. "].use_pnt_y = " .. na.nav_points[local1].use_pos.y .. "\n")
                write("na.nav_points[" .. local1 .. "].use_pnt_z = " .. na.nav_points[local1].use_pos.z .. "\n")
            end
            if na.nav_points[local1].use_rot then
                write("na.nav_points[" .. local1 .. "].use_rot_x = " .. na.nav_points[local1].use_rot.x .. "\n")
                write("na.nav_points[" .. local1 .. "].use_rot_y = " .. na.nav_points[local1].use_rot.y .. "\n")
                write("na.nav_points[" .. local1 .. "].use_rot_z = " .. na.nav_points[local1].use_rot.z .. "\n")
            end
            if na.nav_points[local1].out_pos then
                write("na.nav_points[" .. local1 .. "].out_pnt_x = " .. na.nav_points[local1].out_pos.x .. "\n")
                write("na.nav_points[" .. local1 .. "].out_pnt_y = " .. na.nav_points[local1].out_pos.y .. "\n")
                write("na.nav_points[" .. local1 .. "].out_pnt_z = " .. na.nav_points[local1].out_pos.z .. "\n")
            end
            if na.nav_points[local1].out_rot then
                write("na.nav_points[" .. local1 .. "].out_rot_x = " .. na.nav_points[local1].out_rot.x .. "\n")
                write("na.nav_points[" .. local1 .. "].out_rot_y = " .. na.nav_points[local1].out_rot.y .. "\n")
                write("na.nav_points[" .. local1 .. "].out_rot_z = " .. na.nav_points[local1].out_rot.z .. "\n")
            end
        end
        local1 = local1 + 1
    end
    writeto()
end
NavButtonHandler = function(arg1, arg2, arg3) -- line 909
    if arg1 == UKEY and arg2 then
        na:writenavpoint(TRUE)
    elseif arg1 == OKEY and arg2 then
        na:writenavpoint(FALSE)
    else
        SampleButtonHandler(arg1, arg2, arg3)
    end
end

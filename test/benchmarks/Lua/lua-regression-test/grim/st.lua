CheckFirstTime("st.lua")
st = Set:create("st.set", "st", { st_strws = 0, st_ovrhead = 1 })
st.camera_adjusts = { 0 }
dofile("st_pinata.lua")
dofile("pigeons.lua")
st.NUMBER_OF_PIGEONS = 5
st.center = { }
st.center.x = 4.35802
st.center.y = -0.0935754
st.choose_start_points = function(arg1) -- line 31
    local local1, local2
    repeat
        repeat
            local1, local2 = pick_from_nonweighted_table(st.pigeon_homes)
        until not local1.used
    until arg1.start_pnt.x ~= local1.pos.x and arg1.start_pnt.y ~= local1.pos.y and arg1.start_pnt.z ~= local1.pos.z
    if arg1.pigeon_number then
        st.pigeon_homes[arg1.pigeon_number].used = FALSE
    end
    local1.used = TRUE
    arg1.pigeon_number = local2
    arg1.start_pnt.x = local1.pos.x
    arg1.start_pnt.y = local1.pos.y
    arg1.start_pnt.z = local1.pos.z
end
st.init_pigeons = function() -- line 51
    local local1 = 0
    st.init_homes()
    repeat
        local1 = local1 + 1
        if not pigeons[local1] then
            pigeons[local1] = Actor:create(nil, nil, nil, "pigeon" .. local1)
        end
        pigeons[local1].costume_marker_handler = bird_sound_monitor
        pigeons[local1].start_pnt = { }
        pigeons[local1].orbit_pnt = { }
        st.choose_start_points(pigeons[local1])
        pigeons[local1].orbit_pnt.x = st.pigeon_dest[local1].pos.x
        pigeons[local1].orbit_pnt.y = st.pigeon_dest[local1].pos.y
        pigeons[local1].orbit_pnt.z = st.pigeon_dest[local1].pos.z
        pigeons[local1]:set_costume("pigeon_idles.cos")
        pigeons[local1]:set_colormap("pigeons.cmp")
        pigeons[local1]:set_walk_rate(0.80000001)
        pigeons[local1]:set_turn_rate(60)
        pigeons[local1]:ignore_boxes()
        pigeons[local1]:put_in_set(st)
        pigeons[local1]:setpos(pigeons[local1].start_pnt.x, pigeons[local1].start_pnt.y, pigeons[local1].start_pnt.z)
        start_script(st.pigeon_brain, pigeons[local1])
    until local1 == st.NUMBER_OF_PIGEONS
end
st.pigeon_brain = function(arg1) -- line 84
    local local1
    break_here()
    while 1 do
        PointActorAt(arg1.hActor, st.center.x, st.center.y, arg1.start_pnt.z)
        if rnd(9) then
            if rnd(8) then
                local1 = start_script(st.point_and_fly_away, arg1)
                wait_for_script(local1)
            end
        else
            sleep_for(rnd(250, 750))
            arg1:play_chore(pigeon_idles_pecking)
            arg1:wait_for_chore()
        end
        break_here()
    end
end
st.point_and_fly_away = function(arg1) -- line 110
    local local1
    local local2 = { }
    local local3 = { }
    local local4
    local local5
    local local6 = 0
    local local7
    local local8, local9, local10, local11
    local local12
    local local13
    if rnd(1) then
        arg1:play_chore(pigeon_idles_scared_takeoff)
        while arg1:is_choring(pigeon_idles_scared_takeoff) do
            local3 = arg1:getpos()
            TurnActorTo(arg1.hActor, st.center.x, st.center.y, local3.z)
            arg1:walk_forward()
            break_here()
        end
        local3 = arg1:getpos()
        local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (local3.z - arg1.start_pnt.z) ^ 2)
        repeat
            st.choose_start_points(arg1)
            local3 = arg1:getpos()
            local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (local3.z - arg1.start_pnt.z) ^ 2)
            local11 = 90 - acos((local3.z - arg1.start_pnt.z) / local5)
        until local11 <= 45 and local11 >= -45 and local11 ~= 0
        if local11 > 0 then
            local7 = pigeon_idles_glide
        else
            local7 = pigeon_idles_fly_cycle
        end
        repeat
            local3 = arg1:getpos()
            TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, local3.z)
            local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (local3.z - arg1.start_pnt.z) ^ 2)
            if not arg1:is_choring(local7) then
                arg1:play_chore(local7)
            end
            local4 = tan(local11) * local5
            local4 = local4 + arg1.start_pnt.z
            arg1:setpos(local3.x, local3.y, local4)
            arg1:walk_forward()
            break_here()
        until local5 <= 1
        repeat
            local3 = arg1:getpos()
            if not TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z) then
                PointActorAt(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            end
            local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (local3.z - arg1.start_pnt.z) ^ 2)
            local4 = tan(local11) * local5
            local4 = local4 + arg1.start_pnt.z
            local12 = GetActorWalkRate(arg1.hActor)
            if local12 >= local5 then
                if not local13 then
                    local13 = TRUE
                    arg1:play_chore(pigeon_idles_landing)
                end
            end
            if PerSecond(local12) > local5 then
                arg1:set_walk_rate(local5)
            end
            arg1:setpos(local3.x, local3.y, local4)
            arg1:walk_forward()
            break_here()
        until local5 < 0.039999999
    else
        arg1:play_chore(pigeon_idles_scared_takeoff)
        while arg1:is_choring(pigeon_idles_scared_takeoff) do
            TurnActorTo(arg1.hActor, arg1.orbit_pnt.x, arg1.orbit_pnt.y, arg1.orbit_pnt.z)
            local3 = arg1:getpos()
            if local3.z <= arg1.orbit_pnt.z then
                local6 = local6 + 1
                arg1:setpos(local3.x, local3.y, local3.z + local6 / 10000)
            end
            arg1:walk_forward()
            break_here()
        end
        repeat
            local3 = arg1:getpos()
            if local3.z <= arg1.orbit_pnt.z then
                local6 = local6 + 1
                arg1:setpos(local3.x, local3.y, local3.z + local6 / 10000)
            end
            local2 = sqrt((local3.x - arg1.orbit_pnt.x) ^ 2 + (local3.y - arg1.orbit_pnt.y) ^ 2 + (local3.z - arg1.orbit_pnt.z) ^ 2)
            if not arg1:is_choring(pigeon_idles_fly_cycle) then
                arg1:play_chore(pigeon_idles_fly_cycle)
            end
            arg1:walk_forward()
            TurnActorTo(arg1.hActor, arg1.orbit_pnt.x, arg1.orbit_pnt.y, arg1.orbit_pnt.z)
            break_here()
        until local2 <= 0.5
        repeat
            local3 = arg1:getpos()
            local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2)
            if not arg1:is_choring(pigeon_idles_glide) then
                arg1:play_chore(pigeon_idles_glide)
            end
            local4 = tan(15) * local5
            local4 = local4 + arg1.start_pnt.z
            if local3.z > local4 then
                arg1:setpos(local3.x, local3.y, local4)
            end
            arg1:walk_forward()
            TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            break_here()
        until local5 <= 1
        repeat
            if not TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z) then
                PointActorAt(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            end
            local5 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2)
            local4 = tan(15) * local5
            local4 = local4 + arg1.start_pnt.z
            local12 = GetActorWalkRate(arg1.hActor)
            if local12 >= local5 then
                if not local13 then
                    local13 = TRUE
                    arg1:play_chore(pigeon_idles_landing)
                end
            end
            if PerSecond(local12) > local5 then
                arg1:set_walk_rate(local5)
            end
            arg1:walk_forward()
            local3 = arg1:getpos()
            if local3.z > local4 then
                arg1:setpos(local3.x, local3.y, local4)
            end
            break_here()
        until local5 < 0.039999999
    end
    arg1:stop_chore(nil)
    arg1:setpos(arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
    arg1:play_chore(pigeon_idles_standing)
    arg1:set_walk_rate(0.80000001)
    sleep_for(1000)
end
st.set_up_actors = function(arg1) -- line 303
    clown:default()
    clown:put_in_set(st)
    clown:setpos(0.345265, 1.60425, -0.1)
    clown:setrot(0, 277.042, 0)
    clown:play_chore_looping(balloonman_tie_balloon)
    SetShadowColor(15, 15, 25)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 700, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 700, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow11")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 700, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, 700, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow21")
    AddShadowPlane(manny.hActor, "shadow21")
end
st.enter = function(arg1) -- line 337
    manny.footsteps = footsteps.pavement
    st:add_object_state(0, "st_pinata_crowd.bm", nil, OBJSTATE_UNDERLAY)
    st:add_object_state(0, "st_pinata_crowd2.bm", nil, OBJSTATE_UNDERLAY)
    st.fe_door:set_object_state("st_pinata.cos")
    st.fe_door.interest_actor:play_chore(st_pinata_here)
    st.fe_door.interest_actor:play_chore_looping(st_pinata_idle)
    start_sfx("traffic1.imu")
    set_vol("traffic1.imu", 20)
    st.init_pigeons()
    if not fe.pop_trigger then
        if not prop_pigeon then
            prop_pigeon = Actor:create(nil, nil, nil, "prop pigeon")
        end
        rf.default_pigeon(prop_pigeon)
        prop_pigeon:put_in_set(st)
        prop_pigeon:setpos(0.524414, 0.142143, 0.58)
        prop_pigeon:setrot(0, -61, 0)
        prop_pigeon:play_chore_looping(pigeon_idles_pecking)
        if not prop_pigeon2 then
            prop_pigeon2 = Actor:create(nil, nil, nil, "prop pigeon")
        end
        rf.default_pigeon(prop_pigeon2)
        prop_pigeon2:put_in_set(st)
        prop_pigeon2:setpos(0.624414, 0.05, 0.58)
        prop_pigeon2:setrot(0, -61, 0)
    end
    st:set_up_actors()
end
st.exit = function(arg1) -- line 376
    local local1 = 1
    stop_script(st.point_and_fly_away)
    stop_script(st.pigeon_brain)
    stop_script(bird_climb)
    repeat
        local1 = local1 + 1
        pigeons[local1]:free()
    until local1 == st.NUMBER_OF_PIGEONS
    prop_pigeon:free()
    prop_pigeon2:free()
    clown:free()
    KillActorShadows(manny.hActor)
    stop_sound("traffic1.imu")
    st.fe_door.interest_actor:set_chore_looping(st_pinata_idle, FALSE)
    st.fe_door.interest_actor:stop_chore(st_pinata_idle)
    st.fe_door.interest_actor:play_chore(st_pinata_gone)
end
st.crates = Object:create(st, "/fetx093/crates", 0.53045601, 2.4614401, 0.059999999, { range = 1.5 })
st.crates.use_pnt_x = 1.93046
st.crates.use_pnt_y = 2.3714399
st.crates.use_pnt_z = 0.059999999
st.crates.use_rot_x = 0
st.crates.use_rot_y = 97.022102
st.crates.use_rot_z = 0
st.crates.lookAt = function(arg1) -- line 414
    soft_script()
    manny:say_line("/fema094/")
    wait_for_message()
    manny:say_line("/fema095/")
end
st.crates.pickUp = function(arg1) -- line 421
    system.default_response("hernia")
end
st.crates.use = function(arg1) -- line 425
    manny:say_line("/fema096/")
end
st.os_door = Object:create(st, "/sttx097/door", 6.16397, -2.40711, 0.059999999, { range = 0 })
st.os_door.use_pnt_x = 6.16397
st.os_door.use_pnt_y = -2.40711
st.os_door.use_pnt_z = 0.059999999
st.os_door.use_rot_x = 0
st.os_door.use_rot_y = -439.26501
st.os_door.use_rot_z = 0
st.os_door.out_pnt_x = 6.8000002
st.os_door.out_pnt_y = -2.2862999
st.os_door.out_pnt_z = 0.059999999
st.os_door.out_rot_x = 0
st.os_door.out_rot_y = -439.26501
st.os_door.out_rot_z = 0
st.os_door.touchable = FALSE
st.os_box = st.os_door
st.os_door.walkOut = function(arg1) -- line 453
    os:come_out_door(os.st_door)
end
st.al_door = Object:create(st, "/sttx002/door", 5.19554, -3.7165501, 0, { range = 0 })
st.al_door.use_pnt_x = 5.3355398
st.al_door.use_pnt_y = -2.80656
st.al_door.use_pnt_z = 0
st.al_door.use_rot_x = 0
st.al_door.use_rot_y = 166.5
st.al_door.use_rot_z = 0
st.al_door.out_pnt_x = 5.23523
st.al_door.out_pnt_y = -3.2249999
st.al_door.out_pnt_z = 0
st.al_door.out_rot_x = 0
st.al_door.out_rot_y = 166.5
st.al_door.out_rot_z = 0
st.al_door.touchable = FALSE
st.al_box = st.al_door
st.al_door.walkOut = function(arg1) -- line 478
    al:come_out_door(al.st_door)
end
st.fe_door = Object:create(st, "/sttx003/festival", 1.6874, -0.0062998701, 0.60000002, { range = 4 })
st.fe_box = st.fe_door
st.fe_door.use_pnt_x = 1.641
st.fe_door.use_pnt_y = 0.24699999
st.fe_door.use_pnt_z = 0
st.fe_door.use_rot_x = 0
st.fe_door.use_rot_y = 85.913803
st.fe_door.use_rot_z = 0
st.fe_door.walkOut = function(arg1) -- line 495
    local local1, local2, local3
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    fe:switch_to_set()
    PutActorInSet(system.currentActor.hActor, fe.setFile)
    PutActorAt(system.currentActor.hActor, local1, local2, -0.097999997)
end
st.fe_door.lookAt = function(arg1) -- line 504
    manny:say_line("/stma005/")
    wait_for_message()
    manny:say_line("/stma006/")
end
st.fe_door.use = function(arg1) -- line 510
    manny:walkto_object(arg1)
end
st.rp_door = Object:create(st, "/sttx098/door", 6.08075, 1.11544, 0, { range = 0 })
st.rp_door.use_pnt_x = 6.08075
st.rp_door.use_pnt_y = 1.11544
st.rp_door.use_pnt_z = 0
st.rp_door.use_rot_x = 0
st.rp_door.use_rot_y = -93.111504
st.rp_door.use_rot_z = 0
st.rp_door.out_pnt_x = 6.8249998
st.rp_door.out_pnt_y = 1.07499
st.rp_door.out_pnt_z = 0
st.rp_door.out_rot_x = 0
st.rp_door.out_rot_z = 0
st.rp_door.touchable = FALSE
st.rp_stbox = st.rp_door
st.rp_door.walkOut = function(arg1) -- line 533
    rp:come_out_door(rp.st_door)
end
st.rp_sidwk_door = Object:create(st, "/sttx099/door", 6.1188402, 2.2841401, 0.059999999, { range = 0 })
st.rp_sidwk_door.use_pnt_x = 6.1188402
st.rp_sidwk_door.use_pnt_y = 2.2841401
st.rp_sidwk_door.use_pnt_z = 0.059999999
st.rp_sidwk_door.use_rot_x = 0
st.rp_sidwk_door.use_rot_y = 276.31
st.rp_sidwk_door.use_rot_z = 0
st.rp_sidwk_door.out_pnt_x = 6.8249998
st.rp_sidwk_door.out_pnt_y = 2.3625
st.rp_sidwk_door.out_pnt_z = 0.059999999
st.rp_sidwk_door.out_rot_x = 0
st.rp_sidwk_door.out_rot_y = 276.31
st.rp_sidwk_door.out_rot_z = 0
st.rp_sidwk_door.touchable = FALSE
st.rp_sidebox = st.rp_sidwk_door
st.rp_sidwk_door.walkOut = function(arg1) -- line 557
    rp:come_out_door(rp.st_sidwk_door)
end
st.os_st_door = Object:create(st, "/sttx100/door", 6.3185802, -0.750099, 0, { range = 0.60000002 })
st.os_st_door.use_pnt_x = 6.3185802
st.os_st_door.use_pnt_y = -0.750099
st.os_st_door.use_pnt_z = 0
st.os_st_door.use_rot_x = 0
st.os_st_door.use_rot_y = -73.990898
st.os_st_door.use_rot_z = 0
st.os_st_door.out_pnt_x = 6.8249998
st.os_st_door.out_pnt_y = -0.652363
st.os_st_door.out_pnt_z = 0
st.os_st_door.out_rot_x = 0
st.os_st_door.out_rot_y = -96.959801
st.os_st_door.out_rot_z = 0
st.os_st_door.touchable = FALSE
st.os_stbox = st.os_st_door
st.os_st_door.walkOut = function(arg1) -- line 581
    os:come_out_door(os.st_st_door)
end

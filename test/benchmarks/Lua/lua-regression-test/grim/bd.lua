CheckFirstTime("bd.lua")
dofile("ma_throw_bone.lua")
dofile("beaver.lua")
bd = Set:create("bd.set", "Beaver Dam", { bd_beacu = 0, bd_damha = 1, bd_rckws = 2, bd_ovrhd = 3 })
bd.flame_vol = 20
bd.exting_vol = 80
bd.solve_com = function(arg1) -- line 18
    com_solved = TRUE
    if bv.padlock.unlocked and mod_solved then
        bd:leave_forest()
    end
end
bd.beaver_sink_bone = function() -- line 26
    local local1
    sp.bone_actor:getpos()
    repeat
        local1 = sp.bone_actor:getpos()
        local1.z = local1.z - PerSecond(0.025)
        sp.bone_actor:setpos(local1)
        break_here()
    until local1.z < -0.25
end
bd.beaver_gets_stuck = function(arg1) -- line 36
    local local1
    local local2 = { }
    local local3
    local1 = bone_beaver[bd.beaver_in_the_air]
    bd.beaver_in_the_air = nil
    local1.dead = TRUE
    stop_sound(local1.imu)
    if local1.number == bd.NUMBER_OF_BEAVERS then
        bd.all_beavers_dead = TRUE
    end
    bd.flying_beaver:make_untouchable()
    START_CUT_SCENE()
    music_state:set_sequence(seqBeaverSink)
    start_sfx("extingsh.wav", nil, bd.exting_vol)
    stop_script(bd.throw_bone_in_tar)
    stunt_beaver:setpos(local1:getpos())
    local1:set_visibility(FALSE)
    stunt_beaver:wait_for_chore(beaver_freeze_dive)
    start_sfx(pick_one_of({ "bvbloop1.wav", "bvbloop2.wav", "bvbloop3.wav" }))
    bd.beaver_in_the_air = FALSE
    bd.flying_beaver:make_untouchable()
    local2 = stunt_beaver:getpos()
    repeat
        break_here()
        local2.z = local2.z - PerSecond(0.079999998)
        if local2.z <= 0.40000001 then
            local2.z = 0.40000001
        end
        stunt_beaver:setpos(local2.x, local2.y, local2.z)
    until local2.z == 0.40000001
    while bd.firing_extinguisher do
        break_here()
    end
    END_CUT_SCENE()
    bd.tar:make_touchable()
    local1:free()
    MakeSectorActive("beaver_rock", TRUE)
    stunt_beaver:free()
    if bd.all_beavers_dead then
        stop_script(bd.mother_brain)
        mother_beaver:free()
        cur_puzzle_state[15] = TRUE
        music_state:set_state(BD_SOLVED)
        single_start_script(bd.leave_glottis, bd)
        start_script(bd.solve_com)
    else
        start_script(bd.fake_beaver)
    end
end
bd.fake_beaver = function() -- line 89
    local local1, local2
    local local3 = { }
    local local4
    if not bd.all_beavers_dead then
        START_CUT_SCENE()
        local1 = 0
        repeat
            local1 = local1 + 1
            stop_sound(bone_beaver[local1].imu)
            bone_beaver[local1]:free()
        until local1 == bd.NUMBER_OF_BEAVERS
        stop_script(bd.mother_brain)
        stop_script(bd.beaver_brain)
        stop_script(bd.beaver_walk)
        stop_script(bd.beaver_pat)
        stop_script(bd.beaver_gnaw)
        stop_script(bd.beaver_swim)
        stop_script(bd.beaver_attack)
        stop_script(bd.beaver_re_ignite)
        stop_script(bd.leave_glottis)
        stop_script(bd.look_for_mother)
        stop_script(bd.run_to_mother)
        mother_beaver:free()
        local1 = 0
        repeat
            local1 = local1 + 1
            if not bone_beaver[local1].dead then
                local4 = bone_beaver[local1]
            end
        until local4
        local4:set_costume("beaver.cos")
        local4:follow_boxes()
        local4:put_in_set(bd)
        local4:set_turn_rate(40)
        local4:set_walk_rate(0.25)
        local4.on_fire = TRUE
        local4.medic = FALSE
        local4.is_swimming = FALSE
        local4.preparing_to_swim = FALSE
        local4.kill_manny = FALSE
        local4.jump_in = { }
        local4.jump_out = { }
        local4.finish = { }
        local4.number = local1
        local4.imu = nil
        local4.imu = "bvFlame1.imu"
        local4:set_visibility(TRUE)
        local4:ignore_boxes()
        local4:set_walk_rate(0.25)
        local4:setpos(2.9765301, 1.21289, 0.1184)
        local4:setrot(0, 0, 0)
        local4:play_chore_looping(beaver_walk)
        local4:play_chore_looping(beaver_flaming)
        start_sfx(local4.imu)
        repeat
            local3 = local4:getpos()
            local3.y = local3.y + PerSecond(0.40000001)
            if local3.y >= 2.48 then
                local3.y = 2.48
            end
            local4:setpos(local3.x, local3.y, local3.z)
            if not manny:find_sector_name("beaver_rock1") then
                manny:walk_forward()
            end
            break_here()
        until local3.y == 2.48
        preload_sfx("extingsh.wav")
        local4:setpos(2.925, 3.0250001, 0.56999999)
        local4:setrot(0, -125.5, 0)
        local4:follow_boxes()
        repeat
            local3 = local4:getpos()
            if not manny:find_sector_name("beaver_rock1") then
                manny:walk_forward()
            end
            local4:walk_forward()
            break_here()
        until local3.z >= 0.67000002
        local4:stop_chore(beaver_walk)
        END_CUT_SCENE()
        while bd:current_setup() == bd_rckws do
            break_here()
        end
        START_CUT_SCENE()
        local4:free()
        bd.set_up_beavers()
        local1 = 0
        repeat
            local1 = local1 + 1
            if not bone_beaver[local1].dead then
                local4 = bone_beaver[local1]
            end
        until local4
        MakeSectorActive("bv_cheat", TRUE)
        repeat
            local1 = local1 + 1
            if not bone_beaver[local1].dead then
                local4 = bone_beaver[local1]
            end
        until local4
        stop_script(local4.brain_script)
        if local4.ign then
            stop_script(local4.ign)
        end
        if local4.att then
            stop_script(local4.att)
        end
        if local4.wlk then
            stop_script(local4.wlk)
        end
        if local4.pat then
            stop_script(local4.pat)
        end
        if local4.gnw then
            stop_script(local4.gnw)
        end
        if local4.swm then
            stop_script(local4.swm)
        end
        local4:setpos(3.25, 1.975, 0.13)
        local4:setrot(0, 231, 0)
        repeat
            if not local4:is_choring(beaver_walk, beaver_hCos) then
                local4:play_chore(beaver_walk)
            end
            manny:walk_forward()
            local4:walk_forward()
            break_here()
        until not local4:find_sector_name("bv_cheat")
        MakeSectorActive("bv_cheat", FALSE)
        local4.brain_script = start_script(bd.beaver_brain, local4)
        bd.tar:make_untouchable()
        END_CUT_SCENE()
    end
end
bd.throw_bone_in_tar = function(arg1) -- line 238
    local local1
    local local2 = 0
    local local3
    local local4 = { }
    local local5 = { }
    local local6
    local local7
    local local8 = manny.is_holding
    cur_puzzle_state[14] = TRUE
    MakeSectorActive("beaver_rock", FALSE)
    preload_sfx("boneTar.wav")
    START_CUT_SCENE()
    bd.tar:make_untouchable()
    if not sp.bone_actor then
        sp.bone_actor = Actor:create(nil, nil, nil, "bone")
    end
    sp.bone_actor:put_in_set(bd)
    sp.bone_actor:set_costume("bone.cos")
    sp.bone_actor:setpos({ x = 4.9290299, y = 2.3366899, z = -0.192 })
    sp.bone_actor:setrot(89, 0, 0)
    sp.bone_actor:set_visibility(FALSE)
    manny:walkto_object(bd.tar)
    manny:wait_for_actor()
    manny:stop_chore(manny.hold_chore, manny.base_costume)
    manny:stop_chore(ms_hold, manny.base_costume)
    local8:free()
    local8.owner = sp.bone_pile
    manny.is_holding = nil
    manny:push_costume("ma_throw_bone.cos")
    manny:play_chore(2)
    manny:wait_for_chore()
    start_sfx("boneTar.wav")
    sp.bone_actor:set_visibility(TRUE)
    start_script(bd.beaver_sink_bone)
    manny:pop_costume()
    END_CUT_SCENE()
    stop_script(bd.fake_beaver)
    if not bd.all_beavers_dead then
        local2 = 0
        repeat
            local2 = local2 + 1
            if not bone_beaver[local2].dead then
                local3 = bone_beaver[local2]
            end
        until local3
        local3:play_chore_looping(beaver_walk)
        repeat
            local4 = local3:getpos()
            local3:walk_forward()
            break_here()
        until local4.x >= 4
        local3:set_chore_looping(beaver_walk, FALSE)
        local3:wait_for_chore(beaver_walk)
        local4 = local3:getpos()
        local5 = local3:getrot()
        if not stunt_beaver then
            stunt_beaver = Actor:create(nil, nil, nil, "stunt beaver")
        end
        stunt_beaver:set_costume(beaver_hCos)
        stunt_beaver:put_in_set(bd)
        stunt_beaver:setpos(0, 0, 0)
        stunt_beaver:setrot(local5.x, local5.y, local5.z)
        stunt_beaver:play_chore(beaver_freeze_dive)
        local3:play_chore(beaver_big_dive)
        bd.guarenteed_win = TRUE
        sleep_for(2000)
        music_state:set_sequence(seqBeaverFly)
        sleep_for(2757)
        bd.beaver_in_the_air = local3.number
        sp.bone_actor:set_visibility(FALSE)
        if bd.firing_extinguisher and bd:test_angle() <= 20 and manny:is_choring(2, "ma_use_extin.cos") then
            local3.fireproof = FALSE
            bd.guarenteed_win = FALSE
            bd.firing_extinguisher = FALSE
            stop_sound(local3.imu)
            start_script(bd.beaver_gets_stuck)
            while 1 do
                break_here()
            end
        else
            start_sfx(pick_one_of({ "bvbloop1.wav", "bvbloop2.wav", "bvbloop3.wav" }))
            local3:wait_for_chore(beaver_big_dive)
            bd.beaver_in_the_air = FALSE
            bd.flying_beaver:make_untouchable()
            sleep_for(1000)
            local3.fireproof = TRUE
        end
    end
    bd.guarenteed_win = FALSE
    bd.firing_extinguisher = FALSE
    MakeSectorActive("beaver_rock", TRUE)
    if not bd.all_beavers_dead then
        start_script(bd.fake_beaver)
    end
    bd.tar:make_touchable()
end
bd.get_in_BW = function(arg1) -- line 345
    START_CUT_SCENE()
    bd.bone_wagon:make_untouchable()
    sg.bone_wagon.hText = MakeTextObject("Manny IS the Bone Wagon", { x = 40, y = 380, font = pt_font, fgcolor = Aqua })
    system.buttonHandler = bone_wagon_button_handler
    break_here()
    SetActorWalkRate(manny.hActor, 3)
    END_CUT_SCENE()
    bd:drive_out()
end
bd.leave_BW = function(arg1) -- line 356
    bd.bone_wagon:make_touchable()
    manny.is_driving = FALSE
    SetActorWalkRate(manny, MANNY_WALK_RATE)
    system.buttonHandler = SampleButtonHandler
    KillTextObject(sg.bone_wagon.hText)
end
bd.set_pitch = function() -- line 364
    local local1 = 0
    while 1 do
        repeat
            local1 = local1 - PerSecond(3)
            SetActorPitch(manny.hActor, local1)
            break_here()
        until local1 <= -0.75
        repeat
            local1 = local1 + PerSecond(3)
            SetActorPitch(manny.hActor, local1)
            break_here()
        until local1 >= 0.75
    end
end
bd.set_roll = function() -- line 380
    local local1 = 0
    while 1 do
        repeat
            local1 = local1 - PerSecond(3)
            SetActorRoll(manny.hActor, local1)
            break_here()
        until local1 <= -0.75
        repeat
            local1 = local1 + PerSecond(3)
            SetActorRoll(manny.hActor, local1)
            break_here()
        until local1 >= 0.75
    end
end
bd.leave_drive = function() -- line 396
    while 1 do
        manny:walk_forward()
        break_here()
    end
end
bd.leave_forest = function() -- line 403
    start_script(cut_scene.outofpf, cut_scene)
end
bd.watch_tele_boxes = function() -- line 408
    local local1
    while 1 do
        if manny:find_sector_name("tele_box1") then
            manny:setpos(2.79283, 4.0671701, 0.161622)
            manny:setrot(0, -104, 0)
            bd.rock_trail:make_untouchable()
            bd:current_setup(bd_rckws)
            bd.tar:make_touchable()
            local1 = 0
            repeat
                local1 = local1 + 1
                bone_beaver[local1].fireproof = TRUE
            until local1 == bd.NUMBER_OF_BEAVERS
            if sp.bone_actor then
                sp.bone_actor:set_visibility(FALSE)
            end
            while manny:find_sector_name("tele_box2") do
                break_here()
            end
        elseif manny:find_sector_name("tele_box2") then
            manny:setpos(2.7550001, 4, 0, 17)
            manny:setrot(0, -194, 0)
            bd:current_setup(bd_damha)
            bd.tar:make_untouchable()
            bd.rock_trail:make_touchable()
            local1 = 0
            repeat
                local1 = local1 + 1
                bone_beaver[local1].fireproof = FALSE
            until local1 == bd.NUMBER_OF_BEAVERS
            while manny:find_sector_name("tele_box1") do
                break_here()
            end
        end
        break_here()
    end
end
bd.set_up_actors = function(arg1) -- line 449
    if not bd.all_beavers_dead then
        bd.set_up_beavers()
    end
end
bd.NUMBER_OF_BEAVERS = 3
bone_beaver = { }
bd.set_up_beavers = function() -- line 465
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not beaver_hCos then
            beaver_hCos = "beaver.cos"
        end
        if not bone_beaver[local1] then
            bone_beaver[local1] = Actor:create(nil, nil, nil, "bone beaver")
            bone_beaver[local1].dead = FALSE
        end
        if not bone_beaver[local1].dead then
            bone_beaver[local1]:set_costume(beaver_hCos)
            bone_beaver[local1]:follow_boxes()
            bone_beaver[local1]:put_in_set(bd)
            bone_beaver[local1]:setpos(rnd(4.0749998, 9.7749996), rnd(0.25, 1.325), 0.11)
            bone_beaver[local1]:set_turn_rate(40)
            bone_beaver[local1]:set_walk_rate(0.25)
            bone_beaver[local1].on_fire = TRUE
            bone_beaver[local1].medic = FALSE
            bone_beaver[local1].is_swimming = FALSE
            bone_beaver[local1].preparing_to_swim = FALSE
            bone_beaver[local1].kill_manny = FALSE
            bone_beaver[local1].jump_in = { }
            bone_beaver[local1].jump_out = { }
            bone_beaver[local1].finish = { }
            bone_beaver[local1].number = local1
            bone_beaver[local1].imu = nil
            bone_beaver[local1].fireproof = FALSE
            bone_beaver[local1]:setrot(0, 0, 0)
            if local1 == 1 then
                bone_beaver[local1].jump_in.x = 5.52
                bone_beaver[local1].jump_in.y = 1.52
                bone_beaver[local1].jump_in["r"] = -15
                bone_beaver[local1].jump_out.x = 5.7906098
                bone_beaver[local1].jump_out.y = 1.88727
                bone_beaver[local1].jump_out["r"] = 162.10001
                bone_beaver[local1].finish.x = 6.6182098
                bone_beaver[local1].finish.y = 1.39
                bone_beaver[local1].finish.z = 0.13
                bone_beaver[local1].finish["r"] = 90
                bone_beaver[local1].imu = "bvFlame1.imu"
            elseif local1 == 2 then
                bone_beaver[local1].jump_in.x = 7.5500002
                bone_beaver[local1].jump_in.y = 1.62
                bone_beaver[local1].jump_in["r"] = 7.5700002
                bone_beaver[local1].jump_out.x = 7.0171099
                bone_beaver[local1].jump_out.y = 1.93946
                bone_beaver[local1].jump_out["r"] = 221.2
                bone_beaver[local1].finish.x = 8.2722101
                bone_beaver[local1].finish.y = 1.17563
                bone_beaver[local1].finish.z = 0.13
                bone_beaver[local1].finish["r"] = 170
                bone_beaver[local1].imu = "bvFlame2.imu"
            else
                bone_beaver[local1].jump_in.x = 8.2399998
                bone_beaver[local1].jump_in.y = 1.64
                bone_beaver[local1].jump_in["r"] = 16.299999
                bone_beaver[local1].jump_out.x = 8.1814098
                bone_beaver[local1].jump_out.y = 1.9897
                bone_beaver[local1].jump_out["r"] = 168
                bone_beaver[local1].finish.x = 5.0484099
                bone_beaver[local1].finish.y = 1.21033
                bone_beaver[local1].finish.z = 0.13
                bone_beaver[local1].finish["r"] = 108
                bone_beaver[local1].imu = "bvFlame3.imu"
            end
            bone_beaver[local1]:set_collision_mode(COLLISION_SPHERE)
            SetActorCollisionScale(bone_beaver[local1].hActor, 0.34999999)
            bd.switch_modes(bone_beaver[local1])
            bone_beaver[local1].brain_script = start_script(bd.beaver_brain, bone_beaver[local1])
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    if not mother_beaver then
        mother_beaver = Actor:create(nil, nil, nil, "bone beaver")
    end
    if not bd.all_beavers_dead then
        mother_beaver:set_costume(beaver_hCos)
        mother_beaver:follow_boxes()
        mother_beaver:put_in_set(bd)
        mother_beaver:setpos(0, 0, 0)
        mother_beaver:set_turn_rate(30)
        mother_beaver:set_walk_rate(0.15000001)
        start_script(bd.mother_brain)
    end
end
bone = function() -- line 554
    local local1
    repeat
        local1 = alloc_object_from_table(sp.bones)
        if local1 then
            local1:get()
        end
    until not local1
end
bd.switch_modes = function(arg1) -- line 564
    if arg1.on_fire then
        arg1:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(arg1.hActor, 0.35)
        arg1:stop_chore(nil)
        arg1:play_chore_looping(beaver_flaming)
        start_sfx(arg1.imu, IM_LOW_PRIORITY, 63)
        set_vol(arg1.imu, bd.flame_vol)
    else
        arg1:set_collision_mode(COLLISION_OFF)
        arg1:stop_chore(nil)
        arg1:play_chore_looping(beaver_stop_flaming)
        stop_sound(arg1.imu)
    end
end
bd.mother_brain = function() -- line 581
    local local1
    mother_beaver:setpos(11.3783, 4.02946, -0.111307)
    mother_beaver:setrot(0, 718.89502, 0)
    mother_beaver:play_chore_looping(beaver_walk)
    mother_beaver:play_chore_looping(beaver_flaming)
    while 1 do
        sleep_for(5000)
        mother_beaver:walkto(10.2853, 4.9162698, -0.17449901, 915.88)
        mother_beaver:wait_for_actor()
        mother_beaver:walkto(11.3783, 4.02946, -0.111307, 718.89502)
        mother_beaver:wait_for_actor()
    end
end
bd.calculate_beaver_hit = function() -- line 597
    local local1 = 0
    local local2
    local local3
    local local4
    repeat
        local1 = local1 + 1
        if not bone_beaver[local1].dead and bone_beaver[local1].on_fire and bone_beaver[local1].fireproof == FALSE then
            local3 = GetAngleBetweenActors(manny.hActor, bone_beaver[local1].hActor)
            local2 = proximity(manny, bone_beaver[local1])
            if local3 <= 35 and local2 <= 2 then
                local4 = TRUE
                bone_beaver[local1].on_fire = FALSE
                start_sfx("bvFreeze.wav")
                bd.switch_modes(bone_beaver[local1])
            end
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    return local4
end
bd.beaver_re_ignite = function(arg1) -- line 618
    local local1 = 0
    local local2 = { }
    local local3, local4
    local local5 = { }
    local local6 = { }
    local local7
    arg1:set_turn_rate(200)
    arg1:set_walk_rate(1.6)
    repeat
        local1 = local1 + 1
        if not bone_beaver[local1].dead and arg1.number ~= local1 then
            local2[local1] = proximity(arg1, bone_beaver[local1])
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    local1 = 0
    local3 = nil
    local4 = 1000
    repeat
        local1 = local1 + 1
        if arg1.number ~= local1 and bone_beaver[local1].is_swimming == FALSE and not bone_beaver[local1].dead then
            if local2[local1] < local4 then
                local4 = local2[local1]
                local3 = bone_beaver[local1]
            end
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    if local3 and local3.on_fire then
        local4 = proximity(arg1, local3)
        local5 = arg1:getpos()
        local6 = local3:getpos()
        while local4 >= 0.2 and local3.on_fire do
            if not arg1:is_choring(beaver_freeze_run, beaver_hCos) then
                arg1:play_chore(beaver_freeze_run)
            end
            TurnActorTo(arg1.hActor, local6.x, local6.y, local6.z)
            arg1:walk_forward()
            break_here()
            local5 = arg1:getpos()
            local6 = local3:getpos()
            local4 = proximity(arg1, local3)
        end
        if local3.on_fire then
            arg1.on_fire = TRUE
            bd.switch_modes(arg1)
            start_sfx("bvRelite.wav")
            arg1:wait_for_chore()
            arg1:set_turn_rate(40)
            arg1:set_walk_rate(0.25)
        else
            start_script(bd.beaver_re_ignite, arg1)
            return
        end
    else
        arg1.mommy = start_script(bd.run_to_mother, arg1)
        wait_for_script(arg1.mommy)
    end
end
bd.look_for_mother = function(arg1) -- line 683
    local local1
    while not arg1.on_fire do
        local1 = proximity(arg1, mother_beaver)
        if local1 <= 0.2 and not arg1.on_fire then
            arg1.on_fire = TRUE
            bd.switch_modes(arg1)
            arg1:stop_chore(beaver_freeze_run)
            arg1:play_chore_looping(beaver_run)
        end
        break_here()
    end
end
bd.run_to_mother = function(arg1) -- line 697
    local local1
    local local2 = { x = 0.36293, y = 0.51626998, z = 0.38 }
    arg1.fireproof = TRUE
    arg1.is_swimming = TRUE
    arg1:play_chore_looping(beaver_freeze_run)
    arg1.mommy_look = start_script(bd.look_for_mother, arg1)
    arg1:walkto_object(bd.jump_point)
    arg1:wait_for_actor()
    stop_script(arg1.mommy_look)
    if not arg1.on_fire then
        arg1.on_fire = TRUE
        bd.switch_modes(arg1)
    end
    arg1:stop_chore(beaver_run)
    arg1:play_chore(beaver_dive_in)
    arg1:wait_for_chore(beaver_dive_in)
    arg1:ignore_boxes()
    arg1:setpos(0, 0, 0)
    sleep_for(rnd(4000, 6000))
    arg1:stop_chore(beaver_dive_in)
    arg1:setpos(arg1.jump_out.x, arg1.jump_out.y, -0.25)
    arg1:setrot(50, 180, 0)
    arg1:play_chore(beaver_climb_out)
    arg1:wait_for_chore()
    rot = arg1:getrot()
    vec = RotateVector(local2, rot)
    pos = arg1:getpos()
    vec.x = vec.x + pos.x
    vec.y = vec.y + pos.y
    vec.z = vec.z + pos.z
    arg1.fireproof = TRUE
    arg1:follow_boxes()
    arg1:setpos(vec.x, vec.y, vec.z)
    arg1:setrot(0, 287 + 180, 0)
    arg1.is_swimming = FALSE
    arg1:stop_chore(beaver_climb_out)
    arg1:set_turn_rate(40)
    arg1:set_walk_rate(0.25)
    start_script(bd.re_ignite_timer, arg1)
end
bd.re_ignite_timer = function(arg1) -- line 743
    sleep_for(1000)
    arg1.fireproof = FALSE
end
bd.beaver_walk = function(arg1, arg2, arg3, arg4) -- line 748
    local local1
    local local2 = arg1:getpos()
    local local3
    local1 = sqrt((local2.x - arg2) ^ 2 + (local2.y - arg3) ^ 2)
    arg1:play_chore_looping(beaver_walk)
    while local1 > 0.25 do
        TurnActorTo(arg1.hActor, arg2, arg3, local2.z)
        arg1:walk_forward()
        local2 = arg1:getpos()
        local1 = sqrt((local2.x - arg2) ^ 2 + (local2.y - arg3) ^ 2)
        if arg1.kill_manny and not arg1.is_swimming then
            local1 = 0
            arg4 = nil
        end
        if not arg1.on_fire then
            local1 = 0
            arg4 = nil
        end
        break_here()
    end
    arg1:set_chore_looping(beaver_walk, FALSE)
    if arg4 then
        local3 = start_script(arg1.setrot, arg1, 0, arg4, 0, TRUE)
        while find_script(local3) do
            if not arg1:is_choring(beaver_walk, beaver_hCos) then
                arg1:play_chore(beaver_walk)
            end
            arg1:walk_forward()
            break_here()
        end
    end
end
bd.beaver_pat = function(arg1) -- line 785
    local local1 = rnd(0, 360)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:play_chore(beaver_tail_beat)
    while arg1:is_choring(beaver_tail_beat, beaver_hCos) and not arg1.kill_manny and arg1.on_fire do
        break_here()
    end
end
bd.beaver_gnaw = function(arg1) -- line 794
    local local1 = rnd(0, 360)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:play_chore(beaver_bite)
    while arg1:is_choring(beaver_bite, beaver_hCos) and not arg1.kill_manny and arg1.on_fire do
        break_here()
    end
end
bd.beaver_swim = function(arg1) -- line 804
    local local1
    local local2
    local local3 = { }
    local local4 = { }
    local local5 = { }
    local local6 = { x = 0.36293, y = 0.51626998, z = 0.38 }
    local1 = 0
    repeat
        local1 = local1 + 1
        if bone_beaver[local1].is_swimming or bone_beaver[local1].preparing_to_swim then
            return
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    arg1.wlk = start_script(bd.beaver_walk, arg1, arg1.jump_in.x, arg1.jump_in.y, arg1.jump_in.r)
    arg1.preparing_to_swim = TRUE
    while find_script(arg1.wlk) do
        if arg1.kill_manny then
            stop_script(arg1.wlk)
            arg1.is_swimming = FALSE
            arg1.preparing_to_swim = FALSE
            return
        end
        break_here()
    end
    arg1.preparing_to_swim = FALSE
    arg1.is_swimming = TRUE
    arg1:play_chore(beaver_dive_in)
    sleep_for(700)
    start_sfx(pick_one_of({ "bvbloop1.wav", "bvbloop2.wav", "bvbloop3.wav" }))
    arg1:wait_for_chore()
    arg1:ignore_boxes()
    arg1:setpos(7.1076102, 2.6989, -0.75)
    arg1:setrot(0, -9, 0)
    arg1:play_chore_looping(beaver_walk)
    curpos = arg1:getpos()
    repeat
        curpos.z = curpos.z + PerSecond(0.2)
        if curpos.z > -0.25 then
            curpos.z = -0.25
        end
        arg1:walk_forward()
        arg1:setpos(curpos.x, curpos.y, curpos.z)
        break_here()
    until curpos.z == -0.25
    arg1:set_turn_rate(100)
    arg1:follow_boxes()
    local2 = rndint(1, 3)
    repeat
        local2 = local2 - 1
        arg1.wlk = start_script(bd.beaver_walk, arg1, rnd(6.3000002, 8.2299995), rnd(1.9400001, 4.8000002))
        wait_for_script(arg1.wlk)
    until local2 == 0
    arg1.wlk = start_script(bd.beaver_walk, arg1, 7.1076102, 2.6989, -178.82899)
    wait_for_script(arg1.wlk)
    arg1:play_chore_looping(beaver_walk)
    arg1:ignore_boxes()
    curpos = arg1:getpos()
    repeat
        curpos.z = curpos.z - PerSecond(0.2)
        if curpos.z < -0.75 then
            curpos.z = -0.75
        end
        arg1:walk_forward()
        arg1:setpos(curpos.x, curpos.y, curpos.z)
        break_here()
    until curpos.z == -0.75
    arg1:stop_chore(beaver_walk)
    arg1:setpos(arg1.jump_out.x, arg1.jump_out.y, -0.25)
    arg1:setrot(50, 180, 0)
    arg1:play_chore(beaver_climb_out)
    arg1:wait_for_chore()
    local4 = arg1:getrot()
    local5 = RotateVector(local6, local4)
    local3 = arg1:getpos()
    local5.x = local5.x + local3.x
    local5.y = local5.y + local3.y
    local5.z = local5.z + local3.z
    arg1.fireproof = TRUE
    arg1:follow_boxes()
    arg1:setpos(local5.x, local5.y, 0.13)
    arg1:setrot(0, 287 + 180, 0)
    arg1.is_swimming = FALSE
    arg1:stop_chore(beaver_climb_out)
    arg1:set_turn_rate(40)
    start_script(bd.re_ignite_timer, arg1)
end
bd.beaver_brain = function(arg1) -- line 899
    local local1
    start_script(bd.watch_proximity, arg1)
    while 1 do
        if not arg1.on_fire then
            arg1.ign = start_script(bd.beaver_re_ignite, arg1)
            wait_for_script(arg1.ign)
        elseif arg1.kill_manny then
            arg1.att = start_script(bd.beaver_attack, arg1)
            wait_for_script(arg1.att)
        else
            local1 = rndint(3)
            if local1 == 0 then
                arg1.wlk = start_script(bd.beaver_walk, arg1, rnd(4.0749998, 9.7749996), rnd(0.25, 1.325))
                wait_for_script(arg1.wlk)
            elseif local1 == 1 then
                arg1.pat = start_script(bd.beaver_pat, arg1)
                wait_for_script(arg1.pat)
            elseif local1 == 2 then
                arg1.gnw = start_script(bd.beaver_gnaw, arg1)
                wait_for_script(arg1.gnw)
            elseif local1 == 3 then
                arg1.swm = start_script(bd.beaver_swim, arg1)
                wait_for_script(arg1.swm)
            end
            break_here()
        end
    end
end
bd.camera_break = function() -- line 930
    system.lock_display()
    break_here()
    system.unlock_display()
end
bd.camerachange = function(arg1, arg2, arg3) -- line 936
    if arg3 == bd_damha and arg2 == bd_rckws then
        start_script(bd.camera_break)
    end
end
bd.check_visibility = function() -- line 942
    local local1
    local local2
    while not bd.all_beavers_dead do
        if bd:current_setup() == bd_damha then
            local2 = nil
            local1 = 0
            repeat
                local1 = local1 + 1
                bone_beaver[local1]:set_visibility(TRUE)
            until local1 == bd.NUMBER_OF_BEAVERS
            while bd:current_setup() == bd.damha do
                break_here()
            end
        else
            local1 = 0
            repeat
                local1 = local1 + 1
                bone_beaver[local1]:set_visibility(FALSE)
            until local1 == bd.NUMBER_OF_BEAVERS
            if bd:current_setup() == bd_rckws then
                start_script(bd.fake_beaver)
            end
            local2 = bd:current_setup()
            while bd:current_setup() == local2 do
                break_here()
            end
        end
        break_here()
    end
end
bd.watch_proximity = function(arg1) -- line 974
    local local1
    while 1 do
        local1 = proximity(manny, arg1)
        if local1 <= 3.5 and manny:find_sector_name("death") then
            arg1.kill_manny = TRUE
        else
            arg1.kill_manny = FALSE
        end
        break_here()
    end
end
bd.beaver_attack = function(arg1) -- line 988
    local local1 = manny:getpos()
    local local2 = arg1:getpos()
    local local3 = sqrt((local2.x - local1.x) ^ 2 + (local2.y - local1.y) ^ 2 + (local2.z - local1.z) ^ 2)
    local local4
    if not find_script(bd.monitor_beaver_attack) then
        start_script(bd.monitor_beaver_attack)
    end
    arg1:play_chore_looping(beaver_run)
    arg1:set_walk_rate(1.5)
    arg1:set_turn_rate(150)
    while arg1.on_fire and bd:current_setup() ~= bd_rckws do
        if local3 <= 0.5 and not find_script(bd.beaver_escape) then
            start_script(bd.beaver_escape)
        end
        TurnActorTo(arg1.hActor, local1.x, local1.y, local1.z)
        arg1:walk_forward()
        break_here()
        local1 = manny:getpos()
        local2 = arg1:getpos()
        local3 = sqrt((local2.x - local1.x) ^ 2 + (local2.y - local1.y) ^ 2 + (local2.z - local1.z) ^ 2)
    end
end
bd.monitor_beaver_attack = function() -- line 1016
    MakeSectorActive("off_chase", FALSE)
    while find_script(bd.beaver_attack) do
        break_here()
    end
    MakeSectorActive("off_chase", TRUE)
end
bd.beaver_escape = function() -- line 1024
    stop_script(monitor_run)
    START_CUT_SCENE()
    local local1 = 0
    repeat
        local1 = local1 + 1
        bone_beaver[local1]:set_collision_mode(COLLISION_OFF)
    until local1 == bd.NUMBER_OF_BEAVERS
    if manny:get_costume() == "ma_use_extin.cos" then
        manny:pop_costume()
        stop_script(bd.extinguisher.use)
        stop_script(bd.extinguisher.fire_extinguisher)
        manny:play_chore_looping(manny.hold_chore, "ma.cos")
        stop_sound("extingsh.imu")
        manny:play_chore_looping(ma_hold, "ma.cos")
        inventory_disabled = FALSE
    end
    if system.buttonHandler == fireExtinguisherHandler then
        system.buttonHandler = inventory_save_handler
    end
    stop_script(bd.leave_glottis)
    manny:set_collision_mode(COLLISION_OFF)
    if manny.is_backward then
        manny:set_walk_backwards(FALSE)
    end
    manny:say_line(pick_one_of({ "/bdma006A/", "/bdma006B/", "/bdma006C/" }))
    start_script(manny.runto, manny, bd.bv_door.out_pnt_x, bd.bv_door.out_pnt_y, bd.bv_door.out_pnt_z)
    manny:wait_for_message()
    END_CUT_SCENE()
    stop_movement_scripts()
    if inInventorySet() then
        close_inventory()
    end
    bv:come_out_door(bv.bd_door)
    if not bd.beavers.met then
        bd.beavers.met = TRUE
    end
end
bd.meet_the_beavers = function() -- line 1068
    START_CUT_SCENE()
    local local1 = 0
    repeat
        local1 = local1 + 1
        stop_script(bone_beaver[local1].brain_script)
        if local1 == 1 then
            bone_beaver[1]:setpos(4.5769401, 1.27459, -0.1)
            bone_beaver[1]:setrot(0, 45, 0)
            bone_beaver[1]:play_chore_looping(beaver_bite)
        elseif local1 == 2 then
            bone_beaver[2]:setpos(8.6178102, 0.71539903, -0.1)
            bone_beaver[2]:setrot(0, 180, 0)
            bone_beaver[2]:play_chore_looping(beaver_tail_beat)
        elseif local1 == 3 then
            bone_beaver[3]:setpos(6.7908101, 1.1584001, -0.1)
            bone_beaver[3]:setrot(0, 300, 0)
            bone_beaver[3]:play_chore_looping(beaver_walk)
        end
    until local1 == bd.NUMBER_OF_BEAVERS
    manny:walkto(3.0162799, 0.78265703, 0.21988299)
    manny:wait_for_actor()
    RunFullscreenMovie("distbeav.snm")
    start_script(bd.beaver_attack, bone_beaver[1])
    while system.currentSet == bd do
        break_here()
    end
    END_CUT_SCENE()
end
bd.leave_glottis = function() -- line 1100
    local local1 = { }
    while 1 do
        bd.dont_attack_manny = FALSE
        repeat
            local1 = manny:getpos()
            break_here()
        until local1.x > 9.8000002
        bd.firing_extinguisher = FALSE
        START_CUT_SCENE()
        bd.dont_attack_manny = TRUE
        manny:say_line("/bdma029/")
        local local2 = manny:getpos()
        manny:walkto(9.7749996, local2.y, 0.13)
        wait_for_message()
        manny:say_line("/bdma030/")
        END_CUT_SCENE()
    end
end
bd.enter = function(arg1) -- line 1127
    MakeSectorActive("bv_cheat", FALSE)
    MakeSectorActive("off_chase", TRUE)
    NewObjectState(bd_damha, OBJSTATE_UNDERLAY, "bd_2_tar.bm")
    NewObjectState(bd_rckws, OBJSTATE_UNDERLAY, "bd_3_tar.bm")
    bd.tar:set_object_state("tar_river.cos")
    bd.tar.interest_actor:play_chore_looping(0)
    if not bd.all_beavers_dead then
        bd:set_up_actors()
        start_script(bd.watch_tele_boxes)
        start_script(bd.check_visibility)
    else
        MakeSectorActive("off_chase", FALSE)
    end
    if not ma_throw_bone_cos then
        ma_throw_bone_cos = "ma_throw_bone.cos"
    end
    if manny.is_driving then
        bd:drive_in()
    end
    bd.tar:make_untouchable()
    bd.dam:make_touchable()
    preload_sfx("bvRelite.wav")
    preload_sfx("bvFreeze.wav")
    preload_sfx("bevrHiss.wav")
    start_script(bd.leave_glottis)
    if not bd.entered_bd then
        bd.entered_bd = TRUE
        start_script(bd.meet_the_beavers)
    end
    bd:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
bd.exit = function(arg1) -- line 1173
    local local1 = 0
    repeat
        local1 = local1 + 1
        stop_sound(bone_beaver[local1].imu)
        bone_beaver[local1]:free()
    until local1 == bd.NUMBER_OF_BEAVERS
    stop_script(bd.watch_proximity)
    stop_script(bd.mother_brain)
    stop_script(bd.beaver_brain)
    stop_script(bd.beaver_walk)
    stop_script(bd.beaver_pat)
    stop_script(bd.beaver_gnaw)
    stop_script(bd.beaver_swim)
    stop_script(bd.beaver_attack)
    stop_script(bd.check_visibility)
    stop_script(bd.watch_tele_boxes)
    stop_script(bd.beaver_re_ignite)
    stop_script(bd.leave_glottis)
    stop_script(bd.look_for_mother)
    stop_script(bd.run_to_mother)
    mother_beaver:free()
    if manny:get_costume() == "ma_use_extin.cos" then
        manny:pop_costume()
        stop_script(bd.extinguisher.use)
        stop_script(bd.extinguisher.fire_extinguisher)
        manny:play_chore_looping(manny.hold_chore, "ma.cos")
        manny:play_chore_looping(ma_hold, "ma.cos")
    end
    if system.buttonHandler == fireExtinguisherHandler then
        system.buttonHandler = inventory_save_handler
    end
    SetActorClipActive(manny.hActor, FALSE)
    if bd.dont_attack_manny == TRUE then
        END_CUT_SCENE()
    end
    if sp.bone_actor then
        sp.bone_actor:free()
    end
    stop_sound("extingsh.imu")
end
bd.update_music_state = function(arg1) -- line 1215
    if bd.all_beavers_dead then
        return stateBD_SOLVED
    else
        return stateBD
    end
end
bd.extinguisher = Object:create(bd, "/bdtx018/fire extinguisher", 0, 0, 0, { range = 0 })
bd.extinguisher.string_name = "extinguisher"
bd.extinguisher.wav = "getMetl.wav"
bd.extinguisher.lookAt = function(arg1) -- line 1234
    if bd.beavers.met then
        manny:say_line("/bdma019/")
    else
        manny:say_line("/vima035/")
    end
end
bd.test_angle = function(arg1) -- line 1242
    if not fire_test_actor then
        fire_test_actor = Actor:create(nil, nil, nil, "x")
    end
    fire_test_actor:put_in_set(bd)
    fire_test_actor:setpos({ x = 4.69903, y = 2.43169, z = -0.2 })
    return GetAngleBetweenActors(manny.hActor, fire_test_actor.hActor)
end
bd.extinguisher.default_response = function(arg1) -- line 1249
    manny:say_line("/bdma020/")
end
bd.clip_planes = function() -- line 1253
    local local1 = { }
    SetActorClipActive(manny.hActor, TRUE)
    while bd:current_setup() == bd_rckws and bd.firing_extinguisher do
        local1 = manny:getrot()
        manny:set_run(FALSE)
        if local1.y >= 90 then
            SetActorClipPlane(manny.hActor, 1, 1, 0, 3.22333, 2.6201501, -0.1)
        else
            SetActorClipPlane(manny.hActor, 10, 1, 0, 3.38605, 3.5179801, -0.1)
        end
        if manny:find_sector_name("stop_shootin") then
            bd.firing_extinguisher = FALSE
        end
        break_here()
    end
    SetActorClipActive(manny.hActor, FALSE)
end
bd.extinguisher.use = function(arg1) -- line 1273
    local local1
    local local2
    local local3
    if system.currentSet == bd then
        inventory_disabled = TRUE
        START_CUT_SCENE()
        manny:set_run(FALSE)
        inventory_save_handler = system.buttonHandler
        system.buttonHandler = fireExtinguisherHandler
        bd.firing_extinguisher = TRUE
        manny:stop_chore(manny.hold_chore, "ma.cos")
        manny:stop_chore(ma_hold, "ma.cos")
        manny:push_costume("ma_use_extin.cos")
        manny:play_chore(1, "ma_use_extin.cos")
        manny:wait_for_chore(1, "ma_use_extin.cos")
        END_CUT_SCENE()
        local1 = bd.extinguisher.fire_extinguisher()
        if local1 and not find_script(bd.leave_glottis) then
            bd.beavers.sprayed = bd.beavers.sprayed + 1
            if bd.beavers.sprayed == 1 then
                manny:say_line("/bdma021/")
            elseif bd.beavers.sprayed == 2 then
                manny:say_line("/bdma022/")
            elseif bd.beavers.sprayed == 3 then
                manny:say_line("/bdma023/")
            elseif bd.beavers.sprayed == 4 then
                manny:say_line("/bdma024/")
            elseif bd.beavers.sprayed == 5 then
                manny:say_line("/bdma025/")
            elseif bd.beavers.sprayed == 6 then
                manny:say_line("/bdma026/")
            else
                manny:say_line("/bdma027/")
            end
        end
        manny:pop_costume()
        manny:play_chore_looping(manny.hold_chore, "ma.cos")
        manny:play_chore_looping(ma_hold, "ma.cos")
        inventory_disabled = FALSE
    else
        bd.extinguisher:default_response()
    end
end
bd.extinguisher_count_min_time = function(arg1) -- line 1325
    sleep_for(1500)
    bd.extinguisher.min_time_elapsed = TRUE
end
bd.extinguisher.fire_extinguisher = function(arg1) -- line 1330
    local local1, local2
    bd.rock_trail:make_untouchable()
    if bd:current_setup() == bd_rckws then
        start_script(bd.clip_planes)
    end
    bd.extinguisher.min_time_elapsed = FALSE
    start_script(bd.extinguisher_count_min_time)
    start_sfx("extingsh.imu")
    repeat
        manny:play_chore(2, "ma_use_extin.cos")
        while manny:is_choring(2, "ma_use_extin.cos") and bd.firing_extinguisher do
            local2 = bd.calculate_beaver_hit()
            if local2 then
                local1 = TRUE
            end
            break_here()
        end
        break_here()
    until not bd.firing_extinguisher and bd.extinguisher.min_time_elapsed == TRUE
    stop_sound("extingsh.imu")
    manny:play_chore(3, "ma_use_extin.cos")
    manny:wait_for_chore(3, "ma_use_extin.cos")
    system.buttonHandler = inventory_save_handler
    bd.rock_trail:make_touchable()
    return local1
end
fireExtinguisherHandler = function(arg1, arg2, arg3) -- line 1358
    if control_map.USE[arg1] and not arg2 and bd.guarenteed_win == FALSE then
        bd.firing_extinguisher = FALSE
    end
    inventory_save_handler(arg1, arg2, arg3)
end
bd.beavers = Object:create(bd, "/bdtx028/beaver", 0, 0, 0, { range = 0 })
bd.beavers.sprayed = 0
bd.beavers.use_extinguisher = bd.extinguisher.use
bd.beavers.use_bone = function(arg1, arg2) -- line 1371
    start_script(bd.throw_bone_in_tar)
end
bd.dam = Object:create(bd, "/bdtx031/dam", 4.2374601, 0.60527599, 0.30000001, { range = 1 })
bd.dam.use_pnt_x = 3.3612599
bd.dam.use_pnt_y = 0.43803501
bd.dam.use_pnt_z = 0.1
bd.dam.use_rot_x = 0
bd.dam.use_rot_y = 268.81799
bd.dam.use_rot_z = 0
bd.dam.lookAt = function(arg1) -- line 1384
    manny:say_line("/bdma032/")
end
bd.dam.pickUp = function(arg1) -- line 1388
    got_bone = alloc_object_from_table(sp.bones)
    if got_bone then
        START_CUT_SCENE()
        preload_sfx("getBone.wav")
        if not sp.said_spare then
            sp.said_spare = TRUE
            manny:say_line("/spma014/")
        end
        manny:wait_for_actor()
        manny:play_chore(ma_reach_low, "ma.cos")
        sleep_for(864)
        start_sfx("getBone.wav")
        got_bone:get()
        got_bone.wav = "getBone.wav"
        manny.is_holding = got_bone
        manny:play_chore_looping(ma_hold, "ma.cos")
        manny:play_chore_looping(ma_activate_bone, "ma.cos")
        manny.hold_chore = ma_activate_bone
        manny:wait_for_chore(ma_reach_low, "ma.cos")
        manny:stop_chore(ma_reach_low, "ma.cos")
        END_CUT_SCENE()
    else
        manny:say_line("/spma015/")
    end
end
bd.dam.use_bone = function(arg1, arg2) -- line 1415
    arg2:free()
    arg2.owner = sp.bone_pile
    START_CUT_SCENE()
    if not sp.said_drop then
        sp.said_drop = TRUE
        manny:say_line("/spma016/")
    end
    preload_sfx("getBone.wav")
    manny:play_chore(ma_reach_low, "ma.cos")
    sleep_for(864)
    start_sfx("getBone.wav")
    manny.is_holding = nil
    manny:stop_chore(ma_hold, "ma.cos")
    manny:stop_chore(ma_activate_bone, "ma.cos")
    manny.hold_chore = nil
    manny:wait_for_chore(ma_reach_low, "ma.cos")
    manny:stop_chore(ma_reach_low, "ma.cos")
    END_CUT_SCENE()
end
bd.dam.use = function(arg1) -- line 1437
    bd.dam:pickUp()
end
bd.dam.use_extinguisher = bd.extinguisher.use
bd.tar = Object:create(bd, "/bdtx035/river of tar", 4.9643002, 2.3482001, -0.2, { range = 2 })
bd.tar.use_pnt_x = 3.86603
bd.tar.use_pnt_y = 2.74369
bd.tar.use_pnt_z = -0.1
bd.tar.use_rot_x = 0
bd.tar.use_rot_y = 241.035
bd.tar.use_rot_z = 0
bd.tar.touchable = FALSE
bd.tar.lookAt = function(arg1) -- line 1453
    START_CUT_SCENE()
    manny:say_line("/bdma036/")
    wait_for_message()
    manny:say_line("/bdma037/")
    END_CUT_SCENE()
end
bd.tar.pickUp = function(arg1) -- line 1461
    manny:say_line("/bdma038/")
end
bd.tar.use = function(arg1) -- line 1465
    manny:say_line("/bdma039/")
end
bd.tar.use_bone = function(arg1) -- line 1469
    if bd:current_setup() == bd_rckws then
        start_script(bd.throw_bone_in_tar)
    else
        system.default_response("not here")
    end
end
bd.tar.use_extinguisher = bd.extinguisher.use
bd.flying_beaver = Object:create(bd, "/bdtx040/diving beaver", 4.9643002, 2.3482001, 0.55000001, { range = 5 })
bd.flying_beaver.use_pnt_x = 4.6707802
bd.flying_beaver.use_pnt_y = 2.33794
bd.flying_beaver.use_pnt_z = 0.1
bd.flying_beaver.use_rot_x = 0
bd.flying_beaver.use_rot_y = -456.60699
bd.flying_beaver.use_rot_z = 0
bd.flying_beaver:make_untouchable()
bd.flying_beaver.lookAt = function(arg1) -- line 1491
    manny:say_line("/bdma041/")
end
bd.flying_beaver.pickUp = function(arg1) -- line 1495
    manny:say_line("/bdma042/")
end
bd.flying_beaver.use_extinguisher = function(arg1) -- line 1499
    bd:beaver_gets_stuck()
end
bd.flying_beaver.use = bd.flying_beaver.pickUp
bd.rock_trail = Object:create(bd, "", 2.56338, 3.8006101, 0.488161, { range = 2.5 })
bd.rock_trail.use_pnt_x = 2.40117
bd.rock_trail.use_pnt_y = 1.38107
bd.rock_trail.use_pnt_z = 0.25
bd.rock_trail.use_rot_x = 0
bd.rock_trail.use_rot_y = -449.66599
bd.rock_trail.use_rot_z = 0
bd.rock_trail.lookAt = function(arg1) -- line 1515
    manny:say_line("/syma159/")
end
bd.rock_trail.pickUp = function(arg1) -- line 1518
    manny:say_line("/syma159/")
end
bd.rock_trail.use = function(arg1) -- line 1521
    manny:say_line("/syma159/")
end
bd.rock_trail.use_extinguisher = bd.extinguisher.use
bd.sg_door = Object:create(bd, "/bdtx051/road", -9.3249798, -5.7775102, 1.8, { range = 0.80000001 })
bd.sg_door.use_pnt_x = -8.6349201
bd.sg_door.use_pnt_y = -5.6901698
bd.sg_door.use_pnt_z = 1.4
bd.sg_door.use_rot_x = 0
bd.sg_door.use_rot_y = -243.368
bd.sg_door.use_rot_z = 0
bd.sg_door.lookAt = function(arg1) -- line 1539
    manny:say_line("/bdma052/")
end
bd.sg_door.use = function(arg1) -- line 1543
    sg:come_out_door(sg.mod_door)
end
bd.sg_door.walkOut = bd.sg_door.use
bd.bd_sg_box = bd.sg_door
bd.jump_point = Object:create(bd, "", 9.5613604, 5.0908999, -0.19, { range = 0 })
bd.jump_point.use_pnt_x = 9.5613604
bd.jump_point.use_pnt_y = 5.0908999
bd.jump_point.use_pnt_z = -0.19
bd.jump_point.use_rot_x = 0
bd.jump_point.use_rot_y = 101.076
bd.jump_point.use_rot_z = 0
bd.trail = Object:create(bd, "/bdtx063/trail", -4.8607001, -0.71929997, 1.5, { range = 0.60000002 })
bd.trail.use_pnt_x = -4.5086498
bd.trail.use_pnt_y = 0.68820697
bd.trail.use_pnt_z = 0.85000098
bd.trail.use_rot_x = 0
bd.trail.use_rot_y = 844.255
bd.trail.use_rot_z = 0
bd.trail.walkOut = function(arg1) -- line 1569
    bd:come_out_door(bd.gate)
end
bd.corner_box = bd.trail
bd.bv_door = Object:create(bd, "/bdtx064/door", -0.402688, 0.80833, 0.029999999, { range = 0 })
bd.bv_door.use_pnt_x = 1.65302
bd.bv_door.use_pnt_y = 0.56033897
bd.bv_door.use_pnt_z = 0.227428
bd.bv_door.use_rot_x = 0
bd.bv_door.use_rot_y = -259.535
bd.bv_door.use_rot_z = 0
bd.bv_door.out_pnt_x = 1.21024
bd.bv_door.out_pnt_y = 0.47850901
bd.bv_door.out_pnt_z = 0.218633
bd.bv_door.out_rot_x = 0
bd.bv_door.out_rot_y = -259.535
bd.bv_door.out_rot_z = 0
bd.bv_box = bd.bv_door
bd.bv_door.walkOut = function(arg1) -- line 1593
    bv:come_out_door(bv.bd_door)
end

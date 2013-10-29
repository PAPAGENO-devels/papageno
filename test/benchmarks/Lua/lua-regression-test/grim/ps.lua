CheckFirstTime("ps.lua")
ps = Set:create("ps.set", "pearl sub", { ps_widha = 0, ps_barfg = 1, ps_subla = 2, ps_ovrhd = 3, ps_intro = 4 })
dofile("barnacle.lua")
ps.set_up_actors = function(arg1) -- line 19
    if not ps.barnacle then
        ps.barnacle = Actor:create(nil, nil, nil, "barnacles")
    end
    ps.barnacle:set_costume("barnacle.cos")
    ps.barnacle:put_in_set(ps)
    ps.barnacle:setpos(-11.2506, 3.79427, 2.58294)
    ps.barnacle:setrot(0, -191.951, 0)
    ps.barnacle:play_chore_looping(barnacle_idles)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.35)
end
ps.octo_watch_manny = function() -- line 34
    local local1 = manny:getpos()
    octoeye:set_head(0, 0, 0, 0, 0, 360)
    while 1 do
        octoeye:head_look_at_manny()
        break_here()
    end
end
ps.chepito_light = function() -- line 43
    local local1, local2, local3
    local local4 = { }
    while 1 do
        local1, local2, local3 = GetActorNodeLocation(chepito.hActor, 12)
        SetLightPosition("chepito_light", local1, local2, local3)
        ps.lantern.interest_actor:setpos(local1, local2, local3)
        local4 = chepito:getpos()
        ps.chepito_obj.interest_actor:setpos(local4.x, local4.y, local4.z + 0.40000001)
        if hot_object == ps.chepito_obj then
            manny:head_look_at(ps.chepito_obj)
        end
        break_here()
    end
end
ps.glottis_follow_manny = function() -- line 61
    local local1 = glottis:getpos()
    local local2 = { }
    local local3, local4
    local local5 = { x = 1, y = -1, z = 0 }
    break_here()
    while 1 do
        if ps:current_setup() == ps_barfg then
            local1 = glottis:getpos()
            glottis:walkto(-11.3708, 5.8907299, 2.52, 0, 155.19901, 0)
            glottis:wait_for_actor()
            while ps:current_setup() == ps_barfg do
                glottis:head_look_at_manny()
                break_here()
            end
        else
            glottis:head_look_at_manny()
            while proximity(glottis, manny) > 1.5 and ps:current_setup() ~= ps_barfg do
                glottis:head_look_at_manny()
                repeat
                    glottis:head_look_at_manny()
                    glottis:stop_chore(glottis_home_pose, "glottis_sailor.cos")
                    local2 = manny:getrot()
                    local4 = RotateVector(local5, local2)
                    local3 = manny:getpos()
                    local4.x = local4.x + local3.x
                    local4.y = local4.y + local3.y
                    local4.z = local4.z + local3.z
                    TurnActorTo(glottis.hActor, local4.x, local4.y, local4.z)
                    break_here()
                    glottis:set_walk_rate(GetActorWalkRate(manny.hActor))
                    glottis:walk_forward()
                    local1 = glottis:getpos()
                    ps.glottis_obj.interest_actor:setpos(local1.x, local1.y, local1.z + 1)
                until proximity(glottis, manny) < 1.1 or ps:current_setup() == ps_barfg
            end
            break_here()
            glottis:set_walk_rate(MANNY_WALK_RATE)
            glottis:play_chore(glottis_home_pose, "glottis_sailor.cos")
        end
    end
end
ps.chepito_follow_manny = function() -- line 108
    local local1 = chepito:getpos()
    local local2 = { }
    local local3, local4
    local local5 = { x = 0.2, y = -0.5, z = 0 }
    break_here()
    while 1 do
        if ps:current_setup() == ps_barfg then
            local1 = chepito:getpos()
            chepito:walkto(-11.1406, 4.7150502, 2.52, 0, 134.09801, 0)
            chepito:wait_for_actor()
            while ps:current_setup() == ps_barfg do
                chepito:head_look_at_manny()
                break_here()
            end
        else
            chepito:head_look_at_manny()
            while proximity(chepito, manny) > 1 do
                chepito:head_look_at_manny()
                repeat
                    chepito:head_look_at_manny()
                    chepito:stop_chore(chepito_base)
                    local2 = manny:getrot()
                    local4 = RotateVector(local5, local2)
                    local3 = manny:getpos()
                    local4.x = local4.x + local3.x
                    local4.y = local4.y + local3.y
                    local4.z = local4.z + local3.z
                    TurnActorTo(chepito.hActor, local4.x, local4.y, local4.z)
                    chepito:set_walk_rate(GetActorWalkRate(manny.hActor))
                    chepito:walk_forward()
                    break_here()
                    local1 = chepito:getpos()
                    ps.chepito_obj.interest_actor:setpos(local1.x, local1.y, local1.z + 0.25)
                until proximity(chepito, manny) < 0.60000002 or ps:current_setup() == ps_barfg
            end
            break_here()
            chepito:set_walk_rate(MANNY_WALK_RATE)
            chepito:play_chore(chepito_base)
        end
    end
end
ps.pre_subjacked = function() -- line 154
    local local1 = { "/such143/", "/such144/Grrrr!", "/such145/Aaaaaah!", "/such146/LeggoleggoLEGGO!" }
    MakeSectorActive("barnacle_box", FALSE)
    stop_script(ps.chepito_follow_manny)
    ps.barnacle:set_chore_looping(barnacle_idles, FALSE)
    chepito:walkto(-11.7438, 4.1452899, 2.52, 0, -191.951, 0)
    chepito:wait_for_actor()
    chepito:ignore_boxes()
    ps.barnacle:blend(barnacle_hold_ct, barnacle_idles, 800)
    chepito:fade_in_chore(chepito_2trapped, "chepito.cos", 500)
    ps.barnacle:wait_for_chore()
    ps.barnacle:play_chore_looping(barnacle_ct_thrash)
    chepito:say_line("/such143/")
    chepito:wait_for_chore(chepito_2trapped)
    chepito.trapped_in_ps = TRUE
    chepito:play_chore_looping(chepito_trapped)
    start_sfx("ct_thrash.IMU")
    while 1 do
        chepito:say_line(pick_from_nonweighted_table(local1, TRUE), { background = TRUE })
        chepito:wait_for_message()
        sleep_for(500)
    end
end
ps.octo = function() -- line 184
    while 1 do
        if ps:current_setup() == ps_widha then
            StartMovie("ps_0.snm", TRUE, 168, 161)
            while ps:current_setup() == ps_widha do
                break_here()
            end
        elseif ps:current_setup() == ps_subla then
            StartMovie("ps_2.snm", TRUE, 290, 75)
            while ps:current_setup() == ps_subla do
                break_here()
            end
        elseif ps:current_setup() == ps_barfg then
            StartMovie("ps_1.snm", TRUE, 220, 148)
            while ps:current_setup() == ps_barfg do
                break_here()
            end
        end
        system:lock_display()
        StopMovie()
        ForceRefresh()
        break_here()
        system:unlock_display()
    end
end
ps.camerachange = function(arg1, arg2, arg3) -- line 211
    StopMovie()
    if arg3 == ps_widha and ps.octo_here then
        StartMovie("ps_0.snm", TRUE, 168, 161)
    elseif arg3 == ps_subla and ps.octo_here then
        StartMovie("ps_2.snm", TRUE, 290, 75)
    elseif arg3 == ps_barfg and ps.octo_here then
        StartMovie("ps_1.snm", TRUE, 220, 148)
    end
end
ps.enter = function(arg1) -- line 223
    cur_puzzle_state[34] = TRUE
    MakeSectorActive("backdoor", FALSE)
    ps:set_up_actors()
    ps:add_ambient_sfx(underwater_ambience_list, underwater_ambience_parm_list)
end
ps.exit = function(arg1) -- line 231
    stop_sound("bubvox.imu")
    stop_script(ps.chepito_light)
    stop_script(ps.octo)
    stop_script(ps.octo_watch_manny)
    stop_script(ps.chepito_follow_manny)
    stop_script(ps.glottis_follow_manny)
    chepito:free()
    glottis:free()
    octoeye:free()
    ps.barnacle:free()
end
ps.clam_animation = function(arg1) -- line 253
    ps.barnacle:wait_for_chore(barnacle_caress)
    ps.barnacle:play_chore_looping(barnacle_idles)
end
ps.barnacle_box = { }
ps.barnacle_box.walkOut = function(arg1) -- line 260
    START_CUT_SCENE()
    ps.barnacle:set_chore_looping(barnacle_idles, FALSE)
    ps.barnacle:blend(barnacle_caress, barnacle_idles, 800)
    start_script(ps.clam_animation)
    manny:head_look_at(ps.barnicle)
    manny:say_line("/psma001/")
    manny:wait_for_message()
    start_script(manny.setrot, manny, 0, -452.416, 0, TRUE)
    manny:wait_for_actor()
    manny.move_in_reverse = TRUE
    start_script(move_actor_backward, manny.hActor)
    sleep_for(800)
    stop_script(move_actor_backward)
    manny:set_walk_backwards(FALSE)
    manny.move_in_reverse = FALSE
    manny:set_walk_backwards(FALSE)
    wait_for_message()
    if not ps.groped then
        ps.groped = TRUE
        manny:say_line("/psma002/")
        wait_for_message()
    end
    END_CUT_SCENE()
end
ps.barrier1 = { }
ps.barrier1.walkOut = function(arg1) -- line 290
    manny:say_line("/psma003/")
end
ps.barrier2 = ps.barrier1
ps.sub = Object:create(ps, "/pstx004/sub", 2.4552, 0.383313, 0.0200001, { range = 50 })
ps.sub.use_pnt_x = 6.3151999
ps.sub.use_pnt_y = 7.6433101
ps.sub.use_pnt_z = 2.5
ps.sub.use_rot_x = 0
ps.sub.use_rot_y = 525.47198
ps.sub.use_rot_z = 0
ps.sub.immediate = TRUE
ps.sub.lookAt = function(arg1) -- line 308
    manny:say_line("/psma005/")
end
ps.sub.pickUp = function(arg1) -- line 312
    system.default_response("underwater")
end
ps.sub.use = function(arg1) -- line 316
    manny:say_line("/psma006/")
end
ps.octopus = Object:create(ps, "/pstx007/octopus", 1.7352, 0.383313, 2.23, { range = 50 })
ps.octopus.use_pnt_x = 6.3151999
ps.octopus.use_pnt_y = 7.6433101
ps.octopus.use_pnt_z = 2.5
ps.octopus.use_rot_x = 0
ps.octopus.use_rot_y = 525.47198
ps.octopus.use_rot_z = 0
ps.octopus.immediate = TRUE
ps.octopus.lookAt = function(arg1) -- line 330
    soft_script()
    manny:say_line("/psma008/")
    wait_for_message()
    manny:say_line("/psma009/")
end
ps.octopus.use = function(arg1) -- line 337
    manny:say_line("/psma010/")
end
ps.pearl = Object:create(ps, "/pstx011/the Pearl", -0.49479899, -2.6066899, 5.4200001, { range = 50 })
ps.pearl.use_pnt_x = 6.3151999
ps.pearl.use_pnt_y = 7.6433101
ps.pearl.use_pnt_z = 2.5
ps.pearl.use_rot_x = 0
ps.pearl.use_rot_y = 525.47198
ps.pearl.use_rot_z = 0
ps.pearl.lookAt = function(arg1) -- line 350
    soft_script()
    manny:say_line("/psma012/")
    wait_for_message()
    manny:say_line("/psma013/")
    wait_for_message()
    glottis:say_line("/psgl014/")
end
ps.pearl.pickUp = function(arg1) -- line 359
    manny:say_line("/psma015/")
    wait_for_message()
    chepito:say_line("/psch016/")
end
ps.pearl.use = ps.pearl.pickUp
ps.glottis_obj = Object:create(ps, "/pstx017/Glottis", 8.4403496, 8.0503101, 3.4200001, { range = 1.5 })
ps.glottis_obj.use_pnt_x = 7.1703401
ps.glottis_obj.use_pnt_y = 7.7503099
ps.glottis_obj.use_pnt_z = 2.5
ps.glottis_obj.use_rot_x = 0
ps.glottis_obj.use_rot_y = -45.7803
ps.glottis_obj.use_rot_z = 0
ps.glottis_obj.lookAt = function(arg1) -- line 375
    manny:say_line("/psma018/")
end
ps.glottis_obj.pickUp = function(arg1) -- line 379
    system.default_response("underwater")
end
ps.glottis_obj.use = function(arg1) -- line 383
    manny:say_line("/psma019/")
    wait_for_message()
    glottis:say_line("/psgl020/")
    wait_for_message()
    chepito:say_line("/psch021/")
end
ps.chepito_obj = Object:create(ps, "/pstx022/Chepito", 7.75034, 8.5103102, 3.04, { range = 1.5 })
ps.chepito_obj.use_pnt_x = 7.1703401
ps.chepito_obj.use_pnt_y = 7.7503099
ps.chepito_obj.use_pnt_z = 2.5
ps.chepito_obj.use_rot_x = 0
ps.chepito_obj.use_rot_y = -45.7803
ps.chepito_obj.use_rot_z = 0
ps.chepito_obj.lookAt = function(arg1) -- line 399
    manny:say_line("/psma023/")
end
ps.chepito_obj.pickUp = function(arg1) -- line 403
    manny:say_line("/psma024/")
end
ps.chepito_obj.use = function(arg1) -- line 407
    START_CUT_SCENE()
    manny:say_line("/psma025/")
    wait_for_message()
    manny:say_line("/psma026/")
    wait_for_message()
    chepito:say_line("/psch027/")
    wait_for_message()
    chepito:say_line("/psch028/")
    END_CUT_SCENE()
end
ps.lantern = Object:create(ps, "/pstx029/lantern", 7.75034, 8.5103102, 3.25, { range = 0.60000002 })
ps.lantern.use_pnt_x = 7.1703401
ps.lantern.use_pnt_y = 7.7503099
ps.lantern.use_pnt_z = 2.5
ps.lantern.use_rot_x = 0
ps.lantern.use_rot_y = -45.7803
ps.lantern.use_rot_z = 0
ps.lantern.lookAt = function(arg1) -- line 428
    manny:say_line("/psma030/")
end
ps.lantern.use = function(arg1) -- line 432
    chepito:say_line("/psch031/")
    wait_for_message()
    chepito:say_line("/psch032/")
end
ps.lantern.pickUp = ps.lantern.use
ps.barnacles = Object:create(ps, "/pstx033/barnacles", -11.5604, 3.8449399, 2.7969, { range = 0.60000002 })
ps.barnacles.use_pnt_x = -11.9244
ps.barnacles.use_pnt_y = 3.8557401
ps.barnacles.use_pnt_z = 2.52
ps.barnacles.use_rot_x = 0
ps.barnacles.use_rot_y = 239.808
ps.barnacles.use_rot_z = 0
ps.barnacles.lookAt = function(arg1) -- line 449
    manny:say_line("/psma034/")
end
ps.barnacles.pickUp = function(arg1) -- line 453
    manny:say_line("/psma035/")
end
ps.barnacles.use = function(arg1) -- line 457
    manny:say_line("/psma036/")
end
ps.backdoor_trigger = Object:create(ps, "trigger", 0, 0, 0, { range = 0 })
ps.back_trigger = ps.backdoor_trigger
ps.backdoor_trigger.walkOut = function(arg1) -- line 467
    START_CUT_SCENE("no head")
    start_script(ps.pre_subjacked)
    manny:walkto(-11.1, 3.35, 2.3, 0, 256.233, 0)
    manny:wait_for_actor()
    MakeSectorActive("backdoor", TRUE)
    manny:setpos(-10.55, 3.02499, 2.32)
    manny:setrot(0, 742.695, 0)
    manny:walkto(-11.1578, 4.43829, 2.52, 0, 743.268, 0)
    manny:wait_for_actor()
    manny:head_look_at(chepito)
    MakeSectorActive("backdoor", FALSE)
    while not chepito.trapped_in_ps do
        break_here()
    end
    manny:head_look_at(nil)
    start_script(manny.walkto, manny, -10.5679, 6.50009, 2.52)
    while manny:find_sector_name("ps_barfg") do
        break_here()
    end
    END_CUT_SCENE()
    stop_script(ps.pre_subjacked)
    stop_script(ps.octo)
    stop_sound("ct_thrash.IMU")
    start_script(cut_scene.subjacked)
    stop_sound("ps_oct.imu")
end

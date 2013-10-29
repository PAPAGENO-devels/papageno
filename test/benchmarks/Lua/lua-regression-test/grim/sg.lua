CheckFirstTime("sg.lua")
sg = Set:create("sg.set", "signpost fork", { sg_ovrhd = 0, sg_sgnha = 1, sg_sgnha2 = 1, sg_sgnha3 = 1, sg_sgnha4 = 1, sg_sgnha5 = 1, sg_spdws = 2, sg_mancu = 3 })
dofile("glottis_throws.lua")
dofile("glottis_cry.lua")
dofile("gl_saved.lua")
dofile("ma_save_gl.lua")
dofile("signpost.lua")
dofile("ma_action_sign.lua")
dofile("ma_climb_bw.lua")
dofile("gl_boarding_bw.lua")
dofile("bonewagon_gl.lua")
rh = function() -- line 23
    manny:default()
    sg:switch_to_set()
    start_script(sg.glottis_rip_heart)
end
glottis.snores = { }
glottis.snores["/sggl001/"] = 0.2
glottis.snores["/sggl002/"] = 0.15000001
glottis.snores["/sggl003/"] = 0.039999999
glottis.snores["/sggl004/"] = 0.039999999
glottis.snores["/sggl005/"] = 0.15000001
glottis.snores["/sggl006/"] = 0.15000001
glottis.snores["/sggl007/"] = 0.15000001
glottis.snores["/sggl008/"] = 0.039999999
glottis.snores["/sggl009/"] = 0.039999999
glottis.snores["/sggl010/"] = 0.039999999
glottis.roars = { }
glottis.roars[1] = { line = "/sggl011/", freq = 0.1, choreTbl = { bonewagon_gl_2vrm_lft, bonewagon_gl_vrm2drv } }
glottis.roars[2] = { line = "/sggl012/", freq = 0.2, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2drv } }
glottis.roars[3] = { line = "/sggl013/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2drv, bonewagon_gl_mck_shft } }
glottis.roars[4] = { line = "/sggl014/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[5] = { line = "/sggl015/", freq = 0.1, choreTbl = { bonewagon_gl_rx2rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_2steer, bonewagon_gl_rx_steer, bonewagon_gl_rx_hook, bonewagon_gl_rx2drv } }
glottis.roars[6] = { line = "/sggl016/", freq = 0.1, choreTbl = { bonewagon_gl_2rmbl, bonewagon_gl_rmbl2drv, bonewagon_gl_2rmbl, bonewagon_gl_rmbl2drv } }
glottis.roars[7] = { line = "/sggl017/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[8] = { line = "/sggl018/", freq = 0.1, choreTbl = { bonewagon_gl_rx2rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_2steer, bonewagon_gl_rx_steer, bonewagon_gl_rx_hook, bonewagon_gl_rx2drv } }
glottis.roars[9] = { line = "/sggl019/", freq = 0.050000001, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[10] = { line = "/sggl020/", freq = 0.050000001, choreTbl = { bonewagon_gl_gl_2hands_out, bonewagon_gl_gl_cvr_eyes, bonewagon_gl_uncover_eyes, bonewagon_gl_gl_stop_hands_out } }
sg.glottis_roars = function(arg1, arg2) -- line 69
    local local1
    local local2, local3, local4, local5
    if not arg2 then
        arg2 = bonewagon
    end
    while TRUE do
        sleep_for(rndint(1000, 5000))
        if cutSceneLevel <= 0 then
            local2 = random()
            local5 = 0
            local3, local4 = next(glottis.roars, nil)
            local1 = nil
            while local3 and not local1 do
                local5 = local5 + local4.freq
                if local5 > local2 then
                    local1 = local4
                end
                local3, local4 = next(glottis.roars, local3)
            end
            if not local1 then
                local1 = glottis.roars[1]
            end
            if local1.choreTbl then
                start_script(sg.glottis_roars_animate, sg, arg2, local1.choreTbl)
            end
            arg2:say_line(local1.line, { skip_log = TRUE, background = TRUE, volume = 65 })
            arg2:wait_for_message()
            wait_for_script(sg.glottis_roars_animate)
        end
    end
end
sg.glottis_roars_animate = function(arg1, arg2, arg3) -- line 106
    local local1, local2, local3
    local3 = bonewagon_gl_gl_drive
    local1, local2 = next(arg3, nil)
    while local1 do
        arg2:play_chore(local2)
        arg2:wait_for_chore(local2)
        local3 = local2
        local1, local2 = next(arg3, local1)
    end
    arg2:stop_chore(local3)
    arg2:play_chore(bonewagon_gl_gl_drive)
end
signpost = Actor:create(nil, nil, nil, "Signpost")
signpost.offset_vector = { x = -0.0211, y = 0.1585, z = 0 }
signpost.manny_offset = { x = 0.15078799, y = 0.066618003, z = 0 }
signpost.default = function(arg1) -- line 131
    arg1:set_costume("signpost.cos")
    arg1:set_turn_rate(20)
    arg1:set_collision_mode(COLLISION_BOX, 0.3)
end
signpost.put_at_manny = function(arg1, arg2) -- line 137
    local local1, local2, local3
    local2 = manny:getrot()
    local1 = RotateVector(arg1.offset_vector, local2)
    local3 = manny:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local1.z + local3.z
    arg1:put_in_set(system.currentSet)
    arg1:setpos(local1.x, local1.y, local1.z)
    arg1:setrot(local2.x, local2.y - 110, local2.z)
    if not arg2 then
        arg1:show()
    end
end
signpost.get_manny_pos = function(arg1) -- line 154
    local local1, local2, local3, local4
    local2 = signpost:getrot()
    local1 = RotateVector(arg1.manny_offset, local2)
    local3 = signpost:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local4 = manny:getpos()
    local1.z = local4.z
    return local1.x, local1.y, local1.z
end
signpost.get_future_manny_pos = function(arg1) -- line 168
    local local1, local2, local3, local4, local5
    local5 = manny:getrot()
    local3 = RotateVector(arg1.offset_vector, local5)
    local4 = manny:getpos()
    local3.x = local3.x + local4.x
    local3.y = local3.y + local4.y
    local3.z = local4.z
    arg1:setpos(local3.x, local3.y, local3.z)
    local2 = GetActorYawToPoint(arg1.hActor, system.currentSet.rubacava_point)
    local2 = { 0, local2, 0 }
    local1 = RotateVector(arg1.manny_offset, local2)
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
signpost.show = function(arg1) -- line 190
    arg1:play_chore(signpost_show)
    arg1:set_collision_mode(COLLISION_BOX, 0.3)
end
signpost.hide = function(arg1) -- line 195
    arg1:play_chore(signpost_hide)
    arg1:set_collision_mode(COLLISION_OFF)
end
signpost.pick_up = function(arg1) -- line 200
    manny:push_costume("ma_action_sign.cos")
    manny:play_chore(ma_action_sign_lift_sign, "ma_action_sign.cos")
    sleep_for(500)
    start_sfx("sgSgnOut.WAV")
    sleep_for(150)
    arg1:hide()
    manny:wait_for_chore()
    manny:pop_costume()
    manny:play_chore_looping(ma_hold_sign, "ma.cos")
end
signpost.put_down = function(arg1) -- line 212
    manny:stop_chore(ma_hold_sign, "ma.cos")
    manny:push_costume("ma_action_sign.cos")
    manny:play_chore(ma_action_sign_plant_sign, "ma_action_sign.cos")
    sleep_for(1300)
    start_sfx("sgSgnIn.WAV")
    sleep_for(960)
    arg1:put_at_manny()
    manny:wait_for_chore(ma_action_sign_plant_sign, "ma_action_sign.cos")
    manny:pop_costume()
end
sg.check_post = function(arg1, arg2) -- line 224
    if manny.is_holding == sg.signpost then
        START_CUT_SCENE()
        if arg2 == sg.sp_door then
            manny:walkto(-2.83579, -4.87312, 0, 0, 5.9804, 0)
            manny:wait_for_actor()
        else
            manny:walkto_object(arg2)
            manny:wait_for_actor()
        end
        sg.signpost:plant()
        manny:wait_for_message()
        manny:say_line("/sgma040/")
        manny:wait_for_message()
        manny:say_line("/sgma041/")
        manny:wait_for_message()
        END_CUT_SCENE()
        return TRUE
    else
        return FALSE
    end
end
dofile("bonewagon.lua")
sg.bw_out_points = { }
sg.bw_out_points[0] = { pos = { x = -3.87446, y = -1.04915, z = 0 }, rot = { x = 0, y = 337.62799, z = 0 } }
sg.bw_out_points[1] = { pos = { x = 0.26031801, y = 0.98607898, z = 0 }, rot = { x = 0, y = 236.30299, z = 0 } }
sg.bw_out_points[2] = { pos = { x = 3.44713, y = -2.0948, z = 0 }, rot = { x = 0, y = 239.709, z = 0 } }
sg.bw_out_points[3] = { pos = { x = 6.2069998, y = 0.25447601, z = 0 }, rot = { x = 0, y = 310.397, z = 0 } }
bonewagon = Actor:create(nil, nil, nil, "Bone Wagon")
bonewagon.max_walk_rate = 4.5
bonewagon.max_backward_rate = -3
bonewagon.max_turn_rate = 60
bonewagon.min_turn_rate = 0
bonewagon.going = FALSE
bonewagon.keep_moving = FALSE
bonewagon.is_backward = FALSE
bonewagon.wheel_state = "center"
bonewagon.max_volume = 30
bonewagon.glottis_offset_pos = { x = 0.76233, y = 0.34405601, z = 0 }
bonewagon.glottis_offset_rot = { x = 0, y = 98.228401, z = 0 }
bonewagon.manny_offset_pos = { x = 0.52359003, y = -1.335618, z = 0 }
bonewagon.manny_offset_rot = { x = 0, y = 82.184402, z = 0 }
bonewagon.manny_out_offset_pos = { x = 0.66830659, y = -1.518109, z = 0 }
bonewagon.manny_out_offset_rot = { x = 0, y = 278.89801, z = 0 }
bonewagon.manny_all_out_offset = { x = 0.97174299, y = -1.354003, z = 0 }
bonewagon.rev_sfx = { "bwup01.WAV", "bwup02.WAV", "bwup04.wav", "bwup05.wav", "bwup06.wav" }
bonewagon.down_sfx = { "bwdown02.WAV", "bwdown04.WAV", "bwdown06.WAV" }
bonewagon.tire_sfx = { "bwTire01.WAV", "bwTire02.WAV", "bwTire03.WAV", "bwTire04.WAV" }
bonewagon.cruise_sfx = { "bwrev05.wav", "bwrev07.wav", "bwrev09.wav", "bwrev12.wav" }
bonewagon.default = function(arg1, arg2) -- line 287
    arg1:follow_boxes()
    arg1:set_visibility(TRUE)
    if manny.is_driving then
        arg1:set_costume("bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_stay_up, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
        arg1:set_collision_mode(COLLISION_SPHERE, 0.3)
    else
        arg1:set_costume("bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_stay_up, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_no_shocks)
        arg1:set_collision_mode(COLLISION_BOX)
    end
    arg1.walk_rate = 0.5
    arg1.turn_dir = 0
    arg1.turn_rate = arg1.min_turn_rate
    arg1:set_walk_rate(arg1.walk_rate)
    arg1:set_turn_rate(arg1.turn_rate)
    arg1:set_talk_color(Orange)
    SetActorReflection(arg1.hActor, 50)
end
bonewagon.get_glottis_pos_rot = function(arg1) -- line 314
    local local1, local2, local3, local4
    local3 = arg1:get_positive_rot()
    local1 = RotateVector(arg1.glottis_offset_pos, local3)
    local4 = arg1:getpos()
    local1.x = local1.x + local4.x
    local1.y = local1.y + local4.y
    local1.z = local4.z
    newRot = arg1:get_positive_rot()
    newRot.y = newRot.y + arg1.glottis_offset_rot.y
    if newRot.y > 360 then
        newRot.y = newRot.y - 360
    end
    if newRot.y < 0 then
        newRot.y = newRot.y + 360
    end
    return local1, newRot
end
bonewagon.get_manny_pos = function(arg1, arg2) -- line 336
    local local1, local2, local3
    local2 = arg1:get_positive_rot()
    if not arg2 then
        local1 = RotateVector(arg1.manny_offset_pos, local2)
    else
        local1 = RotateVector(arg1.manny_out_offset_pos, local2)
    end
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
bonewagon.get_manny_far_pos = function(arg1) -- line 353
    local local1, local2, local3
    local2 = arg1:get_positive_rot()
    local1 = RotateVector(arg1.manny_all_out_offset, local2)
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
bonewagon.get_manny_rot = function(arg1, arg2) -- line 367
    local local1
    local1 = arg1:get_positive_rot()
    if not arg2 then
        local1.y = local1.y + arg1.manny_offset_rot.y
    else
        local1.y = local1.y + arg1.manny_out_offset_rot.y
    end
    if local1.y > 360 then
        local1.y = local1.y - 360
    end
    if local1.y < 0 then
        local1.y = local1.y + 360
    end
    return local1.x, local1.y, local1.z
end
bonewagon.accelerate = function(arg1, arg2, arg3) -- line 385
    local local1
    if not arg2 then
        arg2 = 0.1
    end
    local1 = arg2
    stop_script(arg1.decelerate)
    if not arg3 then
        while arg1.walk_rate < arg1.max_walk_rate do
            arg1.walk_rate = arg1.walk_rate + arg2
            if arg1.walk_rate > arg1.max_walk_rate then
                arg1.walk_rate = arg1.max_walk_rate
            end
            arg1:set_walk_rate(arg1.walk_rate)
            arg2 = arg2 + local1
            break_here()
        end
    else
        while arg1.walk_rate > arg1.max_backward_rate do
            arg1.walk_rate = arg1.walk_rate - arg2
            if arg1.walk_rate < arg1.max_backward_rate then
                arg1.walk_rate = arg1.max_backward_rate
            end
            arg1:set_walk_rate(arg1.walk_rate)
            break_here()
        end
    end
end
bonewagon.decelerate = function(arg1, arg2, arg3) -- line 417
    local local1
    if not arg2 then
        arg2 = 0.1
    end
    local1 = arg2
    stop_script(arg1.accelerate)
    if not arg3 then
        while arg1.walk_rate > 1 do
            arg1.walk_rate = arg1.walk_rate - arg2
            if arg1.walk_rate < 1 then
                arg1.walk_rate = 1
            end
            arg1:set_walk_rate(arg1.walk_rate)
            arg2 = arg2 + local1
            break_here()
        end
    else
        while arg1.walk_rate < 0 do
            arg1.walk_rate = arg1.walk_rate + arg2
            if arg1.walk_rate > 0.1 then
                arg1.walk_rate = 0.1
            end
            arg1:set_walk_rate(arg1.walk_rate)
            break_here()
        end
    end
end
bonewagon.cruise_sounds = function(arg1) -- line 449
    fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume / 2)
    arg1.cur_cruise_sound = nil
    while TRUE do
        arg1.cur_cruise_sound = pick_one_of(bonewagon.cruise_sfx, TRUE)
        bonewagon:play_sound_at(arg1.cur_cruise_sound, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        wait_for_sound(arg1.cur_cruise_sound)
        break_here()
    end
end
bonewagon.stop_cruise_sounds = function(arg1, arg2) -- line 460
    local local1, local2
    stop_script(arg1.cruise_sounds)
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    if not arg2 then
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    end
end
bonewagon.gas = function(arg1) -- line 499
    local local1
    stop_script(arg1.reverse, arg1)
    arg1.going = TRUE
    local1 = pick_one_of(bonewagon.rev_sfx, TRUE)
    bonewagon:play_sound_at(local1, 1, 10, IM_HIGH_PRIORITY)
    fade_sfx(local1, 500, bonewagon.max_volume)
    single_start_script(bonewagon.cruise_sounds, bonewagon)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    start_script(arg1.accelerate, arg1)
    while get_generic_control_state("MOVE_FORWARD") or arg1.keep_moving do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    if sound_playing(local1) then
        fade_sfx(local1, 500, 0)
    end
    local1 = pick_one_of(bonewagon.down_sfx, TRUE)
    bonewagon:play_sound_at(local1, 10, bonewagon.max_volume, IM_HIGH_PRIORITY)
    start_script(arg1.decelerate, arg1)
    single_start_script(bonewagon.stop_cruise_sounds, bonewagon)
    while arg1.walk_rate > 1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    fade_sfx(local1, 300, 0)
    arg1.going = FALSE
end
bonewagon.reverse = function(arg1) -- line 541
    local local1
    if find_script(arg1.gas) then
        stop_script(arg1.gas)
        arg1:brake()
    end
    arg1.going = TRUE
    start_script(arg1.accelerate, arg1, nil, TRUE)
    brakesfx = pick_one_of(bonewagon.tire_sfx, TRUE)
    single_start_sfx(brakesfx, IM_MED_PRIORITY, bonewagon.max_volume)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    while get_generic_control_state("MOVE_BACKWARD") or arg1.keep_moving do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    start_script(arg1.decelerate, arg1, 0.5, TRUE)
    while arg1.walk_rate < 0 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1.going = FALSE
end
bonewagon.brake = function(arg1, arg2) -- line 574
    local local1, local2
    stop_script(arg1.accelerate, arg1)
    if arg1.walk_rate > 0.1 then
        local2 = pick_one_of(bonewagon.down_sfx, TRUE)
        local1 = pick_one_of(bonewagon.tire_sfx, TRUE)
        if not arg2 then
            single_start_sfx(local2, IM_HIGH_PRIORITY, 0)
            fade_sfx(local2, 500, bonewagon.max_volume)
        end
    end
    single_start_script(arg1.decelerate, arg1, 0.30000001)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    while find_script(arg1.decelerate) do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    if not arg2 then
        single_start_sfx(local1, IM_MED_PRIORITY, bonewagon.max_volume)
    end
    arg1.going = FALSE
end
bonewagon.left = function(arg1) -- line 611
    if find_script(arg1.right) then
        stop_script(arg1.right)
    end
    if arg1.actual_walk_rate > 0.1 then
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
    end
    start_script(arg1.turn_wheels, arg1, "left")
    while get_generic_control_state("TURN_LEFT") do
        break_here()
    end
    if arg1.wheel_state == "left" then
        start_script(arg1.turn_wheels, arg1, "center")
    end
end
bonewagon.right = function(arg1) -- line 630
    if find_script(arg1.left) then
        stop_script(arg1.left)
    end
    if arg1.actual_walk_rate > 0.1 then
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
    end
    start_script(arg1.turn_wheels, arg1, "right")
    while get_generic_control_state("TURN_RIGHT") do
        break_here()
    end
    if arg1.wheel_state == "right" then
        start_script(arg1.turn_wheels, arg1, "center")
    end
end
bonewagon.turn_wheels = function(arg1, arg2) -- line 649
    if arg2 == "left" then
        arg1:stop_chore(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
        if arg1.wheel_state == "right" then
            arg1:play_chore(bonewagon_gl_rt_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_rt_to_ctr)
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "center" then
            arg1:play_chore(bonewagon_gl_turn_lft, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_turn_lft)
            arg1:play_chore_looping(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
            arg1.wheel_state = "left"
        end
    elseif arg2 == "center" then
        arg1:stop_chore(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
        if arg1.wheel_state == "right" then
            arg1:play_chore(bonewagon_gl_rt_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_rt_to_ctr)
            arg1:play_chore_looping(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "left" then
            arg1:play_chore(bonewagon_gl_lft_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_lft_to_ctr)
            arg1:play_chore_looping(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
            arg1.wheel_state = "center"
        end
    elseif arg2 == "right" then
        arg1:stop_chore(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
        if arg1.wheel_state == "left" then
            arg1:play_chore(bonewagon_gl_lft_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_lft_to_ctr)
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "center" then
            arg1:play_chore(bonewagon_gl_turn_rt, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_turn_rt)
            arg1:play_chore_looping(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
            arg1.wheel_state = "right"
        end
    end
end
bonewagon.walkto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 696
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    if arg1.walk_rate < 1.5 or GetActorWalkRate(arg1.hActor) < 1.5 then
        arg1.walk_rate = 1.5
        arg1:set_walk_rate(1.5)
    end
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    Actor.walkto(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
bonewagon.driveto = function(arg1, arg2, arg3, arg4, arg5) -- line 712
    local local1
    local local2
    arg1:walkto(arg2, arg3, arg4)
    while arg1:is_moving() do
        local1 = proximity(bonewagon.hActor, arg2, arg3, arg4)
        arg1.walk_rate = min(arg1.max_walk_rate, local1)
        arg1.walk_rate = max(arg1.walk_rate, 1.5)
        arg1:set_walk_rate(arg1.walk_rate)
        if local1 < 1 and local2 == nil then
            arg1:stop_cruise_sounds()
            if not arg5 then
                local2 = pick_one_of(bonewagon.down_sfx, TRUE)
                arg1:play_sound_at(local2, 10, bonewagon.max_volume, IM_HIGH_PRIORITY)
            end
        end
        break_here()
    end
    arg1:wait_for_actor()
end
bonewagon.drivetorot = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 735
    local local1, local2
    arg1:stop_cruise_sounds()
    arg1.cur_cruise_sound = nil
    arg1:set_turn_rate(arg1.max_turn_rate / 2)
    arg1.walk_rate = 0.80000001
    arg1:set_walk_rate(arg1.walk_rate)
    Actor.walkto(arg1, arg2, arg3, arg4)
    while arg1:is_moving() do
        local1 = proximity(bonewagon.hActor, arg2, arg3, arg4)
        if local1 > 0.5 then
            arg1.walk_rate = arg1.walk_rate + 0.2
        else
            arg1.walk_rate = arg1.walk_rate - 0.2
        end
        arg1.walk_rate = min(arg1.max_walk_rate, arg1.walk_rate)
        arg1.walk_rate = max(arg1.walk_rate, 1.5)
        arg1:set_walk_rate(arg1.walk_rate)
        if not arg1.cur_cruise_sound or not sound_playing(arg1.cur_cruise_sound) then
            arg1.cur_cruise_sound = pick_one_of(bonewagon.cruise_sfx, TRUE)
            arg1:play_sound_at(arg1.cur_cruise_sound, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        end
        break_here()
    end
    arg1:stop_cruise_sounds()
    local2 = nil
    arg1:set_turn_rate(arg1.max_turn_rate / 3)
    Actor.setrot(arg1, arg5, arg6, arg7, TRUE)
    while arg1:is_turning() do
        if not local2 or not sound_playing(local2) then
            local2 = pick_one_of(bonewagon.tire_sfx, TRUE)
            arg1:play_sound_at(local2, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        end
        break_here()
    end
end
bonewagon.monitor_turns = function(arg1) -- line 774
    local local1, local2
    local1 = arg1:getpos()
    arg1.actual_walk_rate = 0
    while TRUE do
        arg1.turn_rate = abs(20 * arg1.actual_walk_rate)
        if arg1.turn_rate > arg1.max_turn_rate then
            arg1.turn_rate = arg1.max_turn_rate
        end
        arg1:set_turn_rate(arg1.turn_rate)
        if get_generic_control_state("TURN_LEFT") and cutSceneLevel <= 0 then
            if arg1.turn_rate > 1 then
                if arg1.walk_rate > 0 or get_generic_control_state("MOVE_FORWARD") then
                    TurnActor(arg1.hActor, 1)
                else
                    TurnActor(arg1.hActor, -1)
                end
            else
                if not bonewagon:playing_tire_sfx() then
                    start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
                end
                arg1:set_turn_rate(30)
                TurnActor(arg1.hActor, 1)
            end
        elseif get_generic_control_state("TURN_RIGHT") and cutSceneLevel <= 0 then
            if arg1.turn_rate > 1 then
                if arg1.walk_rate > 0 or get_generic_control_state("MOVE_FORWARD") then
                    TurnActor(arg1.hActor, -1)
                else
                    TurnActor(arg1.hActor, 1)
                end
            else
                if not bonewagon:playing_tire_sfx() then
                    start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
                end
                arg1:set_turn_rate(30)
                TurnActor(arg1.hActor, -1)
            end
        end
        break_here()
        local2 = proximity(arg1.hActor, local1.x, local1.y, local1.z)
        arg1.actual_walk_rate = local2 / system.frameTime * 1000
        local1 = arg1:getpos()
    end
end
bonewagon.playing_tire_sfx = function(arg1) -- line 826
    local local1, local2, local3
    local1 = FALSE
    local2, local3 = next(arg1.tire_sfx, nil)
    while local2 and not local1 do
        if sound_playing(local3) then
            local1 = TRUE
        end
        local2, local3 = next(arg1.tire_sfx, local2)
    end
    return local1
end
bonewagon.stop_movement_scripts = function(arg1) -- line 841
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.brake)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    stop_script(bonewagon.accelerate)
    stop_script(bonewagon.decelerate)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
end
bonewagon.squelch_sfx = function(arg1) -- line 856
    local local1, local2
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    if sound_playing("bwIdle.IMU") then
        set_vol("bwIdle.IMU", bonewagon.max_volume / 3)
    end
end
bonewagon.restore_sfx = function(arg1) -- line 892
    local local1, local2
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    if sound_playing("bwIdle.IMU") then
        set_vol("bwIdle.IMU", bonewagon.max_volume)
    end
end
bonewagon.in_danger_box = function(arg1) -- line 928
    return arg1:find_sector_name("no_bw_box")
end
bonewagon.can_get_out_here = function(arg1) -- line 935
    local local1, local2, local3
    local local4 = FALSE
    local1, local2, local3 = arg1:get_manny_far_pos()
    if GetPointSector(local1, local2, local3) then
        PrintDebug("Found point sector!\n")
        local4 = TRUE
    else
        PrintDebug("Failed point sector!\n")
        local4 = FALSE
    end
    if local4 then
        if signpost.current_set == system.currentSet then
            if proximity(signpost.hActor, local1, local2, local3) < 1 then
                PrintDebug("Failed signpost proximity!\n")
                local4 = FALSE
            end
        end
    end
    return local4
end
bonewagon.find_safe_out_point = function(arg1) -- line 960
    local local1 = system.currentSet.bw_out_points
    local local2, local3, local4
    local local5, local6
    if not bw_scout then
        bw_scout = Actor:create(nil, nil, nil, "bonewagon scout")
    end
    local2 = nil
    local5 = 9999
    bw_scout.parent = arg1
    bw_scout:set_visibility(FALSE)
    bw_scout:put_in_set(system.currentSet)
    if local1 then
        local3, local4 = next(local1, nil)
        while local3 do
            PrintDebug("Trying point " .. local4.pos.x .. ", " .. local4.pos.y .. ", " .. local4.pos.z .. "\n")
            local6 = proximity(arg1.hActor, local4.pos.x, local4.pos.y, local4.pos.z)
            bw_scout:setpos(local4.pos.x, local4.pos.y, local4.pos.z)
            bw_scout:setrot(local4.rot.x, local4.rot.y, local4.rot.z)
            if bw_scout:can_get_out_here() then
                if local6 < local5 then
                    PrintDebug("Chosen!\n")
                    local5 = local6
                    local2 = local3
                else
                    PrintDebug("Found better point.\n")
                end
            else
                PrintDebug("Failed.\n")
            end
            local3, local4 = next(local1, local3)
        end
    end
    return local2
end
bonewagon.collision_handler = function(arg1, arg2) -- line 999
    if arg2 == signpost then
        start_script(sg.signpost_collapse, sg)
    end
end
sg.signpost_collapse = function(arg1) -- line 1005
    local local1, local2, local3
    signpost:set_collision_mode(COLLISION_OFF)
    signpost.knocked_over = TRUE
    signpost.save_rot = signpost:get_positive_rot()
    local2 = copy_table(signpost.save_rot)
    local3 = bonewagon:get_positive_rot()
    local2.y = local3.y
    start_sfx("sgCrash.WAV", IM_HIGH_PRIORITY)
    if bonewagon.walk_rate < 0 or get_generic_control_state("MOVE_BACKWARD") then
        local1 = 10
        while local2.x < 80 do
            local2.x = local2.x + local1
            if local2.x > 80 then
                local2.x = 80
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            break_here()
        end
    else
        local1 = -10
        while local2.x > -80 do
            local2.x = local2.x + local1
            if local2.x < -80 then
                local2.x = -80
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            break_here()
        end
    end
end
sg.signpost_uncollapse = function(arg1) -- line 1041
    local local1 = signpost:get_positive_rot()
    local local2 = signpost.save_rot
    local local3
    if signpost.knocked_over then
        if proximity(bonewagon.hActor, signpost.hActor) > 2 then
            if signpost.current_set == system.currentSet then
                start_sfx("sgSgnSlw.WAV")
                wait_for_sound("sgSgnSlw.WAV")
                start_sfx("sgSgnStp.WAV")
                local3 = 10
                while local3 ~= 0 do
                    signpost:setrot(local2.x + local3, local2.y, local2.z)
                    if local3 > 0 then
                        local3 = floor(abs(local3 - 1))
                    else
                        local3 = -floor(abs(local3 - 1))
                    end
                    break_here()
                end
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            signpost.knocked_over = FALSE
            system.currentSet.signpost:make_touchable()
        else
            system.currentSet.signpost:make_untouchable()
        end
    end
end
sg.examine_signpost = function(arg1) -- line 1074
    local local1, local2
    local local3, local4, local5
    local local6
    if sg.signpost.uprooted and sg:current_setup() ~= sg_spdws then
        START_CUT_SCENE()
        local1 = { }
        local1.pos = signpost:getpos()
        local1.rot = signpost:getrot()
        local2 = { }
        local2.pos = manny:getpos()
        local2.rot = manny:getrot()
        local6 = sg:current_setup()
        sg:current_setup(sg_mancu)
        signpost:setpos(4.0353198, -1.21448, 0)
        local3 = 3.8364899 + (local2.pos.x - local1.pos.x)
        local4 = -1.23856 + (local2.pos.y - local1.pos.y)
        local5 = 0
        manny:ignore_boxes()
        manny:setpos(local3, local4, local5)
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(FALSE)
            bonewagon:set_collision_mode(COLLISION_OFF)
        end
        manny:head_look_at_point({ 4.0353198, -1.21448, 0.5 })
        manny:say_line("/sgma051/")
        manny:wait_for_message()
        sleep_for(1000)
        sg:current_setup(local6)
        signpost:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
        manny:follow_boxes()
        manny:setpos(local2.pos.x, local2.pos.y, local2.pos.z)
        manny:head_look_at(sg.signpost)
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(TRUE)
            bonewagon:set_collision_mode(COLLISION_BOX, 1)
        end
        END_CUT_SCENE()
    else
        manny:say_line("/sgma051/")
    end
end
bone_wagon_button_handler = function(arg1, arg2, arg3) -- line 1123
    if cutSceneLevel <= 0 and not find_script(Sentence) then
        if control_map.PICK_UP[arg1] or control_map.USE[arg1] then
            if arg2 then
                single_start_script(sg.leave_BW, sg)
            end
        elseif control_map.MOVE_FORWARD[arg1] then
            if arg2 then
                if not find_script(bonewagon.gas) then
                    start_script(bonewagon.gas, bonewagon)
                end
            end
        elseif control_map.MOVE_BACKWARD[arg1] then
            if arg2 then
                if not find_script(bonewagon.reverse) then
                    start_script(bonewagon.reverse, bonewagon)
                end
            end
        elseif control_map.TURN_LEFT[arg1] then
            if arg2 then
                single_start_script(bonewagon.left, bonewagon)
            end
        elseif control_map.TURN_RIGHT[arg1] then
            if arg2 then
                single_start_script(bonewagon.right, bonewagon)
            end
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
sg.get_in_BW = function(arg1) -- line 1157
    local local1, local2, local3
    stop_script(sg.glottis_roars)
    stop_script(glottis.talk_randomly_from_weighted_table)
    if manny.is_holding == sg.signpost then
        sg.signpost:plant()
    end
    glottis.heartless = FALSE
    sg.glottis_obj:make_untouchable()
    inventory_disabled = TRUE
    START_CUT_SCENE()
    if not sg.bone_wagon.ridden then
        sg:switch_to_set()
        manny:set_collision_mode(COLLISION_OFF)
        glottis:set_collision_mode(COLLISION_OFF)
        bonewagon:set_collision_mode(COLLISION_OFF)
        signpost:set_collision_mode(COLLISION_OFF)
        sg:current_setup(sg_sgnha)
        glottis:set_costume(nil)
        glottis:put_in_set(sg)
        glottis:set_costume("gl_boarding_bw.cos")
        local1, local2 = bonewagon:get_glottis_pos_rot()
        glottis:setpos(local1.x, local1.y, local1.z)
        glottis:setrot(local2.x, local2.y, local2.z)
        manny:put_at_object(sg.bone_wagon)
        manny:head_look_at(glottis)
        IrisUp(300, 150, 1000)
        sleep_for(500)
        manny:say_line("/sgma021/")
        manny:wait_for_message()
        glottis:say_line("/sggl022/")
        glottis:wait_for_message()
        manny:set_visibility(FALSE)
        glottis:play_chore(gl_boarding_bw_hop_in_bw, "gl_boarding_bw.cos")
        bonewagon:play_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        sleep_for(700)
        start_sfx("bwGlClmb.WAV")
        glottis:wait_for_chore(gl_boarding_bw_hop_in_bw, "gl_boarding_bw.cos")
        glottis:put_in_set(nil)
        bonewagon:play_chore(bonewagon_gl_drive, "bonewagon_gl.cos")
        sleep_for(1400)
        start_sfx("bwMaClmb.WAV")
        bonewagon:wait_for_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        bonewagon:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
    else
        if system.currentSet == sg then
            sg:current_setup(sg_sgnha)
        end
        manny:walk_closeto_object(system.currentSet.bone_wagon, 0.80000001)
        manny:wait_for_actor()
        bonewagon:set_collision_mode(COLLISION_OFF)
        manny:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(system.currentSet.bone_wagon)
        manny:wait_for_actor()
        manny:set_visibility(FALSE)
        bonewagon:play_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        sleep_for(2100)
        start_sfx("bwMaClmb.WAV")
        bonewagon:wait_for_chore()
        bonewagon:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
        manny:put_in_set(nil)
    end
    start_sfx("bwStart.WAV", IM_HIGH_PRIORITY)
    sleep_for(200)
    start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    sleep_for(500)
    if not sg.signpost.uprooted then
        sg.bone_wagon.ridden = TRUE
        sg.signpost.uprooted = TRUE
        sg:current_setup(sg_sgnha)
        sleep_for(1000)
        bonewagon:play_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_HIGH_PRIORITY, bonewagon.max_volume)
        start_sfx("bwrev01.wav", IM_HIGH_PRIORITY, bonewagon.max_volume)
        sleep_for(1700)
        fade_sfx("bwrev01.wav", 500)
        start_sfx("sgCrash.WAV", IM_HIGH_PRIORITY)
        sleep_for(200)
        start_script(sg.signpost_lean, sg)
        sleep_for(100)
        glottis:say_line("/gagl017/")
        bonewagon:wait_for_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        bonewagon:stop_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        bonewagon:setpos(-2.8169899, -3.0120001, 0)
        bonewagon:setrot(0, 39.022099, 0)
        bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
        glottis:wait_for_message()
        bonewagon.walk_rate = 0.1
        local3 = 0
        while local3 < 100 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate + 0.1
            bonewagon:walk_forward()
            break_here()
            local3 = local3 + system.frameTime
        end
        start_script(sg.signpost_vibrate, sg)
        start_sfx("bwrev01.wav", IM_HIGH_PRIORITY, bonewagon.max_volume)
        local3 = 0
        while local3 < 200 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate + 0.2
            bonewagon:walk_forward()
            break_here()
            local3 = local3 + system.frameTime
        end
        local3 = 0
        bonewagon:set_turn_rate(10)
        while bonewagon.walk_rate > 0.1 and local3 < 2000 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate - 0.02
            bonewagon:walk_forward()
            TurnActor(bonewagon.hActor, -1)
            break_here()
            local3 = local3 + system.frameTime
        end
        bonewagon.walk_rate = 0.1
        bonewagon:set_walk_rate(bonewagon.walk_rate)
        glottis:say_line("/sugl165/")
        glottis:wait_for_message()
    end
    END_CUT_SCENE()
    bonewagon.current_set = nil
    if signpost.current_set == system.currentSet then
        signpost:set_collision_mode(COLLISION_BOX, 0.40000001)
    end
    system.currentSet.bone_wagon:make_untouchable()
    manny.is_driving = TRUE
    bonewagon:default()
    start_script(bonewagon.monitor_turns, bonewagon)
    sg:enable_bonewagon_boxes(TRUE)
    system.buttonHandler = bone_wagon_button_handler
    bonewagon:set_selected()
    manny:put_in_set(nil)
    music_state:set_state(stateOO_BONE)
end
sg.signpost_lean = function(arg1) -- line 1314
    local local1 = 5
    while local1 < 25 do
        SetActorPitch(signpost.hActor, local1)
        local1 = local1 + local1 / 2
        break_here()
    end
end
sg.signpost_vibrate = function(arg1) -- line 1323
    local local1 = 25
    local local2 = 1
    start_sfx("sgSgnStp.wav")
    while abs(local1) > 1 do
        SetActorPitch(signpost.hActor, local1 * local2)
        local1 = local1 - local1 / 6
        local2 = -local2
        break_here()
    end
    SetActorPitch(signpost.hActor, 0)
end
sg.park_BW_obj = function(arg1) -- line 1337
    local local1
    local local2 = { }
    bonewagon:stop_movement_scripts()
    bonewagon:wait_for_actor()
    bonewagon:stop_movement_scripts()
    local1 = bonewagon:getpos()
    system.currentSet.bone_wagon.obj_x = local1.x
    system.currentSet.bone_wagon.obj_y = local1.y
    system.currentSet.bone_wagon.obj_z = local1.z + 0.25
    system.currentSet.bone_wagon.interest_actor:setpos(local1.x, local1.y, local1.z)
    local1 = { }
    local1.x, local1.y, local1.z = bonewagon:get_manny_pos()
    system.currentSet.bone_wagon.use_pnt_x = local1.x
    system.currentSet.bone_wagon.use_pnt_y = local1.y
    system.currentSet.bone_wagon.use_pnt_z = local1.z
    local2.x, local2.y, local2.z = bonewagon:get_manny_rot()
    system.currentSet.bone_wagon.use_rot_x = local2.x
    system.currentSet.bone_wagon.use_rot_y = local2.y
    system.currentSet.bone_wagon.use_rot_z = local2.z
    system.currentSet.bone_wagon:make_touchable()
end
sg.leave_BW = function(arg1, arg2) -- line 1364
    local local1, local2, local3
    START_CUT_SCENE()
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    bonewagon:brake(TRUE)
    END_CUT_SCENE()
    if not arg2 then
        if system.currentSet.enable_bonewagon_boxes then
            system.currentSet:enable_bonewagon_boxes(FALSE)
        end
        if not bonewagon:can_get_out_here() then
            if system.currentSet.enable_bonewagon_boxes then
                system.currentSet:enable_bonewagon_boxes(TRUE)
            end
            local1 = bonewagon:find_safe_out_point()
            if local1 then
                system.default_response("not here")
                local1 = system.currentSet.bw_out_points[local1]
                bonewagon:drivetorot(local1.pos.x, local1.pos.y, local1.pos.z, local1.rot.x, local1.rot.y, local1.rot.z)
                bonewagon:wait_for_actor()
            else
                system.default_response("no room")
                return
            end
        end
    end
    bonewagon:stop_cruise_sounds(TRUE)
    fade_sfx("bwIdle.IMU", 1000, 0)
    if system.currentSet.enable_bonewagon_boxes then
        system.currentSet:enable_bonewagon_boxes(FALSE)
    end
    sg:park_BW_obj()
    manny.is_driving = FALSE
    stop_script(bonewagon.monitor_turns)
    system.buttonHandler = SampleButtonHandler
    START_CUT_SCENE()
    bonewagon:play_chore(bonewagon_gl_ma_jump_out, "bonewagon_gl.cos")
    bonewagon:wait_for_chore(bonewagon_gl_ma_jump_out, "bonewagon_gl.cos")
    bonewagon:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    manny:put_in_set(system.currentSet)
    local1, local2, local3 = bonewagon:get_manny_pos(TRUE)
    manny:setpos(local1, local2, local3)
    local1, local2, local3 = bonewagon:get_manny_rot(TRUE)
    manny:setrot(local1, local2, local3)
    manny:set_selected()
    manny:set_visibility(TRUE)
    bonewagon:play_chore(bonewagon_gl_hide_ma, "bonewagon_gl.cos")
    local1 = 0
    while local1 < 1000 do
        manny:walk_forward()
        break_here()
        local1 = local1 + system.frameTime
    end
    manny:set_collision_mode(COLLISION_SPHERE, 0.5)
    bonewagon:set_collision_mode(COLLISION_BOX, 1)
    END_CUT_SCENE()
    inventory_disabled = FALSE
    bonewagon.current_set = system.currentSet
    bonewagon.current_pos = bonewagon:getpos()
    bonewagon.current_rot = bonewagon:getrot()
    bonewagon:stop_cruise_sounds(TRUE)
    start_script(sg.signpost_uncollapse, sg)
    single_start_script(sg.glottis_roars, sg)
    music_state:update(system.currentSet)
end
sg.enable_bonewagon_boxes = function(arg1, arg2) -- line 1448
    local local1, local2
    local1 = 1
    while local1 <= 17 do
        local2 = "bw_box" .. local1
        MakeSectorActive(local2, arg2)
        local1 = local1 + 1
    end
    local1 = 1
    while local1 <= 22 do
        local2 = "mn_box" .. local1
        MakeSectorActive(local2, not arg2)
        local1 = local1 + 1
    end
    if not arg2 then
        local1 = not sg.glottis_obj.touchable
        MakeSectorActive("glot_box1", local1)
        MakeSectorActive("glot_box2", local1)
        MakeSectorActive("glot_box3", local1)
        MakeSectorActive("no_glot_box1", sg.glottis_obj.touchable)
        MakeSectorActive("no_glot_box2", sg.glottis_obj.touchable)
        MakeSectorActive("no_glot_box3", sg.glottis_obj.touchable)
    else
        MakeSectorActive("glot_box1", FALSE)
        MakeSectorActive("glot_box2", FALSE)
        MakeSectorActive("glot_box3", FALSE)
        MakeSectorActive("no_glot_box1", FALSE)
        MakeSectorActive("no_glot_box2", FALSE)
        MakeSectorActive("no_glot_box3", FALSE)
    end
    MakeSectorActive("sg_sp_box_bw", arg2)
    MakeSectorActive("sg_sm_box_bw", arg2)
end
sg.update_glottis = function(arg1) -- line 1492
    stop_script(sg.glottis_roars)
    stop_script(glottis.talk_randomly_from_weighted_table)
    ExpireText()
    if glottis.ripped_heart then
        if glottis.heartless then
            glottis:default()
            glottis:put_in_set(sg)
            glottis:ignore_boxes()
            glottis:setpos(-2.76674, -4.90863, 0)
            glottis:setrot(0, 41.4323, 0)
            glottis:push_costume("glottis_throws.cos")
            glottis:play_chore(glottis_throws_sleep)
            if not find_script(glottis.talk_randomly_from_weighted_table) then
                start_script(glottis.talk_randomly_from_weighted_table, glottis, glottis.snores)
            end
            MakeSectorActive("glot_box1", FALSE)
            MakeSectorActive("glot_box2", FALSE)
            MakeSectorActive("glot_box3", FALSE)
            MakeSectorActive("no_glot_box1", TRUE)
            MakeSectorActive("no_glot_box2", TRUE)
            MakeSectorActive("no_glot_box3", TRUE)
        else
            sg.glottis_obj:make_untouchable()
            if not manny.is_driving then
                MakeSectorActive("glot_box1", TRUE)
                MakeSectorActive("glot_box2", TRUE)
                MakeSectorActive("glot_box3", TRUE)
            end
            MakeSectorActive("no_glot_box1", FALSE)
            MakeSectorActive("no_glot_box2", FALSE)
            MakeSectorActive("no_glot_box3", FALSE)
            glottis:free()
            glottis:put_in_set(nil)
            if bonewagon.current_set == sg and not manny.is_driving then
                single_start_script(sg.glottis_roars, sg, bonewagon)
            end
        end
    else
        MakeSectorActive("glot_box1", TRUE)
        MakeSectorActive("glot_box2", TRUE)
        MakeSectorActive("glot_box3", TRUE)
        MakeSectorActive("no_glot_box1", FALSE)
        MakeSectorActive("no_glot_box2", FALSE)
        MakeSectorActive("no_glot_box3", FALSE)
    end
end
sg.glottis_rip_heart = function(arg1) -- line 1546
    glottis.ripped_heart = TRUE
    glottis.heartless = TRUE
    sp.web.contains = sp.heart
    START_CUT_SCENE()
    music_state:set_sequence(seqGlottisHeart)
    set_override(sg.glottis_rip_heart_override, sg)
    sg:current_setup(sg_sgnha)
    LoadCostume("glottis_throws.cos")
    LoadCostume("glottis_cry.cos")
    manny:setpos(-5.56994, -4.63949, 0)
    manny:setrot(0, 306.939, 0)
    glottis:default()
    glottis:put_in_set(sg)
    glottis:push_costume("glottis_cry.cos")
    glottis:ignore_boxes()
    glottis:setpos(-2.76674, -4.90863, 0)
    glottis:setrot(0, 41.4323, 0)
    glottis:play_chore_looping(glottis_cry_cry_cyc, "glottis_cry.cos")
    sg:current_setup(sg_sgnha)
    manny:walkto(-5.19219, -4.35516, 0)
    glottis:say_line("/sggl023/")
    manny:wait_for_actor()
    manny:setrot(0, 274.838, 0)
    glottis:wait_for_message()
    glottis:say_line("/sggl024/")
    manny:walkto(-3.36409, -4.55001, 0)
    sleep_for(500)
    sg:current_setup(sg_spdws)
    manny:setpos(-3.75837, -4.61657, 0)
    manny:setrot(0, 263.997, 0)
    manny:walkto(-3.46798, -4.64709, 0, 0, 263.962, 0)
    manny:wait_for_actor()
    manny:turn_toward_entity(-2.6755, -4.83566, 0)
    manny:head_look_at_point(-2.98244, -4.81335, 0.552)
    glottis:wait_for_message()
    manny:hand_gesture()
    manny:say_line("/sgma025/")
    manny:wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/sgma026/")
    glottis:set_chore_looping(glottis_cry_cry_cyc, FALSE, "glottis_cry.cos")
    glottis:wait_for_chore("glottis_cry_cry_cyc", "glottis_cry.cos")
    glottis:play_chore(glottis_cry_cry_out, "glottis_cry.cos")
    manny:wait_for_message()
    glottis:say_line("/sggl027/")
    glottis:wait_for_message()
    glottis:play_chore(glottis_cry_head_swing_in, "glottis_cry.cos")
    glottis:say_line("/sggl028/")
    glottis:wait_for_chore(glottis_cry_head_swing_in, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_head_swing_cyc, "glottis_cry.cos")
    wait_for_message()
    glottis:set_chore_looping(glottis_cry_head_swing_cyc, FALSE, "glottis_cry.cos")
    glottis:say_line("/sggl029/")
    glottis:wait_for_chore(glottis_cry_head_swing_cyc, "glottis_cry.cos")
    glottis:play_chore(glottis_cry_head_swing_out, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_head_swing_out, "glottis_cry.cos")
    sleep_for(500)
    glottis:say_line("/sggl023/")
    glottis:play_chore(glottis_cry_tantrum_in, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_tantrum_in, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_tantrum_cyc, "glottis_cry.cos")
    wait_for_message()
    manny:say_line("/sgma030/")
    glottis:set_chore_looping(glottis_cry_tantrum_cyc, FALSE, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_tantrum_cyc, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_tantrum_out, "glottis_cry.cos")
    wait_for_message()
    glottis:wait_for_chore(glottis_cry_tantrum_out, "glottis_cry.cos")
    glottis:stop_chore()
    glottis:push_costume("glottis_throws.cos")
    glottis:play_chore(glottis_throws_throws, "glottis_throws.cos")
    glottis:say_line("/sggl031/")
    wait_for_message()
    glottis:say_line("/sggl032/")
    wait_for_message()
    glottis:say_line("/sggl034/")
    wait_for_message()
    glottis:say_line("/sggl035/")
    wait_for_message()
    glottis:say_line("/sggl036/")
    wait_for_message()
    glottis:wait_for_chore()
    glottis:play_chore(glottis_throws_sleep, "glottis_throws.cos")
    break_here()
    manny:say_line("/sgma038/")
    sleep_for(500)
    start_script(manny.walkto_object, manny, sg.glottis_obj)
    manny:wait_for_message()
    manny:wait_for_actor()
    glottis:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/sgma039/")
    break_here()
    manny:wait_for_message()
    END_CUT_SCENE()
    start_script(cut_scene.sp06a, cut_scene)
    wait_for_script(cut_scene.sp06a)
    wait_for_message()
    sg:update_glottis()
end
sg.glottis_rip_heart_override = function(arg1) -- line 1669
    kill_override()
    sg:switch_to_set()
    sg:current_setup(sg_spdws)
    manny:shut_up()
    glottis:stop_chore()
    glottis:shut_up()
    manny:default()
    manny:put_at_object(sg.glottis_obj)
    if not find_script(glottis.talk_randomly_from_weighted_table) then
        start_script(glottis.talk_randomly_from_weighted_table, glottis, glottis.snores)
    end
    sg:update_glottis()
end
sg.replace_heart = function() -- line 1685
    cur_puzzle_state[11] = TRUE
    sg.heart:put_in_limbo()
    sg.glottis_obj:make_untouchable()
    glottis.heartless = FALSE
    sg.bone_wagon.contains = glottis
    stop_script(glottis.talk_randomly_from_weighted_table)
    set_override(sg.replace_heart_override)
    START_CUT_SCENE()
    manny:walkto(-2.23264, -4.77272, 0, 0, 131.467, 0)
    manny:wait_for_actor()
    MakeSectorActive("glot_box1", TRUE)
    MakeSectorActive("glot_box2", TRUE)
    manny:walkto(-2.23264, -4.77272, 0, 0, 131.467, 0)
    manny:wait_for_actor()
    manny:stop_chore(ma_activate_heart, "ma.cos")
    manny:stop_chore(ma_hold, "ma.cos")
    manny:push_costume("ma_save_gl.cos")
    glottis:shut_up()
    glottis:stop_chore()
    glottis:pop_costume()
    glottis:push_costume("gl_saved.cos")
    glottis:head_look_at(nil)
    glottis:play_chore(gl_saved_saved, "gl_saved.cos")
    manny:play_chore(ma_save_gl_save_glottis, "ma_save_gl.cos")
    sleep_for(2000)
    stop_sound("glHrtBt.IMU")
    start_sfx("sgHrtShv.wav")
    sleep_for(4000)
    glottis:say_line("/cpdgl12a/")
    wait_for_message()
    glottis:say_line("/cpdgl12b/")
    wait_for_message()
    glottis:say_line("/cpdgl12c/")
    wait_for_message()
    glottis:say_line("/cpdgl12d/")
    wait_for_message()
    glottis:say_line("/cpdgl12e/")
    wait_for_message()
    glottis:say_line("/cpdgl12f/")
    wait_for_message()
    glottis:wait_for_chore()
    manny:wait_for_chore()
    IrisDown(320, 240, 1000)
    sleep_for(1500)
    manny:pop_costume()
    glottis:pop_costume()
    glottis:default()
    END_CUT_SCENE()
    inventory_disabled = FALSE
    start_script(cut_scene.copaldie, cut_scene)
end
sg.replace_heart_override = function() -- line 1747
    kill_override()
    manny:stop_chore()
    manny:stop_chore(ma_activate_heart, "ma.cos")
    manny:stop_chore(ma_hold, "ma.cos")
    manny:pop_costume()
    glottis:shut_up()
    glottis:stop_chore()
    glottis:pop_costume()
    stop_sound("glHrtBt.IMU")
    glottis:default()
    start_script(sg.get_in_BW)
end
sg.rubacava_point = { x = 2.138, y = 12.1412, z = 0 }
sg.enter = function(arg1) -- line 1769
    sg:update_glottis()
    manny:set_collision_mode(COLLISION_SPHERE, 0.4)
    if sg.signpost.touchable and signpost.current_set == arg1 then
        sg.signpost:make_visible()
    end
    if not sg.bone_wagon.ridden then
        bonewagon:default()
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(2.88665, -0.798663, 0)
        bonewagon:setrot(0, 219.129, 0)
    end
    if bonewagon.current_set == arg1 then
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(bonewagon.current_pos.x, bonewagon.current_pos.y, bonewagon.current_pos.z)
        bonewagon:setrot(bonewagon.current_rot.x, bonewagon.current_rot.y, bonewagon.current_rot.z)
        if not manny.is_driving then
            single_start_script(sg.glottis_roars, sg, bonewagon)
        end
    end
    if not manny.is_driving then
        sg:enable_bonewagon_boxes(FALSE)
    else
        sg:enable_bonewagon_boxes(TRUE)
    end
    if sg.heart.touchable then
        preload_sfx("sgGetHrt.wav")
        preload_sfx("sgHrtShv.wav")
        sg.heart:make_touchable()
        start_sfx("glHrtBt.imu", IM_HIGH_PRIORITY, sp.heartbeat_vol_medium)
    else
        sg.heart:make_untouchable()
    end
    if manny.is_driving then
        bonewagon:default()
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    end
    sg:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
sg.camerachange = function(arg1, arg2, arg3) -- line 1820
    if arg3 == sg_spdws then
        if manny.is_driving or bonewagon:in_danger_box() then
            sg:current_setup(arg2)
        end
    end
    if signpost.current_set == sg and manny.is_holding ~= sg.signpost then
        if arg3 == sg_spdws then
            signpost:play_chore(signpost_show)
        else
            signpost:play_chore(signpost_show_lit)
        end
    end
    if sound_playing("glHrtBt.imu") then
        if arg3 == sg_spdws then
            set_vol("glHrtBt.imu", sp.heartbeat_vol_medium)
        else
            set_vol("glHrtBt.imu", sp.heartbeat_vol_far)
        end
    end
end
sg.update_music_state = function(arg1) -- line 1855
    if manny.is_driving then
        return stateOO_BONE
    else
        return stateSG
    end
end
sg.exit = function(arg1) -- line 1863
    manny:set_collision_mode(COLLISION_OFF)
    if sg.heart.visible_actor then
        sg.heart.visible_actor:free()
    end
    stop_script(glottis.talk_randomly_from_weighted_table)
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    glottis:free()
    bonewagon:shut_up()
    stop_sound("bwIdle.IMU")
    stop_sound("glHrtBt.imu")
end
sg.glottis_obj = Object:create(sg, "/sgtx043/Glottis", -2.4567201, -5.0476298, 0.3705, { range = 2 })
sg.glottis_obj.use_pnt_x = -2.23264
sg.glottis_obj.use_pnt_y = -4.7727199
sg.glottis_obj.use_pnt_z = 0
sg.glottis_obj.use_rot_x = 0
sg.glottis_obj.use_rot_y = 131.467
sg.glottis_obj.use_rot_z = 0
sg.glottis_obj.lookAt = function(arg1) -- line 1898
end
sg.glottis_obj.pickUp = function(arg1) -- line 1901
end
sg.glottis_obj.use = function(arg1) -- line 1904
end
sg.glottis_obj.lookAt = function(arg1) -- line 1907
    if glottis.heartless then
        manny:say_line("/sgma044/")
    else
        sg.bone_wagon:lookAt()
    end
end
sg.glottis_obj.pickUp = function(arg1) -- line 1915
    manny:say_line("/sgma045/")
end
sg.glottis_obj.use = function(arg1) -- line 1919
    if glottis.heartless then
        manny:say_line("/sgma046/")
    else
        sg:get_in_BW()
    end
end
sg.glottis_obj.use_heart = function(arg1) -- line 1927
    start_script(sg.replace_heart)
end
sg.glottis_obj.use_scythe = function(arg1) -- line 1931
    START_CUT_SCENE()
    manny:say_line("/sgma047/")
    manny:wait_for_message()
    manny:say_line("/sgma048/")
    END_CUT_SCENE()
end
sg.glottis_obj.use_bone = function(arg1) -- line 1939
    manny:say_line("/sgma049/")
end
sg.signpost = Object:create(sg, "/sgtx050/sign post", -1.87272, -4.17906, 0.60000002, { range = 1.5 })
sg.signpost.use_pnt_x = -1.71085
sg.signpost.use_pnt_y = -4.1479301
sg.signpost.use_pnt_z = 0
sg.signpost.use_rot_x = 0
sg.signpost.use_rot_y = 2617.03
sg.signpost.use_rot_z = 0
sg.signpost.uprooted = FALSE
sg.signpost.used_once = FALSE
sg.signpost.default_rot = { x = 0, y = 346.20999, z = 0 }
sg.signpost.can_put_away = FALSE
signpost.current_set = sg
signpost.current_pos = { x = -1.87272, y = -4.17906, z = 0 }
signpost.current_rot = { x = 0, y = 346.20999, z = 0 }
sg.signpost.lookAt = function(arg1) -- line 1962
    system.currentSet:examine_signpost()
end
sg.signpost.put_away = function(arg1) -- line 1966
    system.default_response("not now")
    return FALSE
end
sg.signpost.pickUp = function(arg1) -- line 1975
    if arg1.uprooted then
        if manny:walk_closeto_object(arg1, 0.8) then
            cur_puzzle_state[12] = TRUE
            START_CUT_SCENE()
            arg1.used_once = TRUE
            manny:wait_for_actor()
            signpost:set_collision_mode(COLLISION_OFF)
            manny:walkto_object(arg1)
            manny:wait_for_actor()
            signpost:pick_up()
            sg.signpost:get()
            manny.is_holding = arg1
            sg.signpost:make_untouchable()
            END_CUT_SCENE()
            signpost.current_set = nil
        else
            system.default_repsonse("reach")
        end
    elseif manny:walk_closeto_object(arg1, 0.8) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        signpost:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:push_costume("ma_action_sign.cos")
        manny:play_chore(ma_action_sign_try_to_lift, "ma_action_sign.cos")
        manny:wait_for_chore()
        manny:pop_costume()
        manny:say_line("/sgma052/")
        signpost:set_collision_mode(COLLISION_BOX, 0.3)
        END_CUT_SCENE()
    else
        system.default_response("reach")
    end
end
sg.signpost.plant = function(arg1) -- line 2014
    local local1, local2, local3
    local local4
    local local5, local6
    local local7
    local local8 = FALSE
    local local9, local10, local11
    if bonewagon.current_set == system.currentSet then
        local9, local10, local11 = bonewagon:get_manny_far_pos()
        if proximity(manny.hActor, bonewagon.hActor) < 2 or proximity(manny.hActor, local9, local10, local11) < 1.5 then
            system.default_response("not here")
            manny:wait_for_message()
            manny:say_line("/sgma065/")
            return FALSE
        end
    end
    local3 = { }
    local3.x, local3.y, local3.z = signpost:get_future_manny_pos()
    if not GetPointSector(local3.x, local3.y, local3.z) then
        system.default_response("no room")
        return FALSE
    end
    START_CUT_SCENE()
    arg1:free()
    manny.is_holding = nil
    inventory_disabled = FALSE
    if system.currentSet == na or (system.currentSet == sg and sg:current_setup() ~= sg_spdws) then
        local7 = { }
        local7.pos = manny:getpos()
        local7.rot = manny:getrot()
        signpost:put_at_manny(TRUE)
        local7.signpos = signpost:getpos()
        local7.destangle = GetActorYawToPoint(signpost.hActor, system.currentSet.rubacava_point)
        if system.currentSet == na then
            na:current_setup(na_mancu)
        else
            sg:current_setup(sg_mancu)
        end
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(FALSE)
            bonewagon:set_collision_mode(COLLISION_OFF)
        end
        manny:setpos(3.8364899, -1.23856, 0.5)
    end
    signpost:put_down()
    signpost:play_chore(signpost_show)
    if system.currentSet == sg then
        local4 = arg1
    else
        local4 = na.signpost
    end
    signpost:set_collision_mode(COLLISION_OFF)
    manny:backup(500)
    signpost:set_collision_mode(COLLISION_BOX, 0.30000001)
    if system.currentSet == na then
        if na:check_for_nav_solved(local7.signpos) then
            local8 = TRUE
        end
    end
    if not local8 then
        if local7 then
            sg.signpost:spin(system.currentSet.rubacava_point, local7.destangle)
            manny:setrot(0, local7.destangle, 0, TRUE)
            manny:wait_for_actor()
            sleep_for(1000)
            local1 = signpost:getpos()
            local3 = manny:getpos()
            if system.currentSet == sg then
                sg:current_setup(sg_sgnha)
            else
                na:current_setup(na_intha)
            end
            if bonewagon.current_set == system.currentSet then
                bonewagon:set_visibility(TRUE)
                bonewagon:set_collision_mode(COLLISION_BOX, 1)
            end
            signpost:play_chore(signpost_show_lit)
            signpost:setpos(local7.signpos.x, local7.signpos.y, local7.signpos.z)
            local3.x = local7.signpos.x - (local1.x - local3.x)
            local3.y = local7.signpos.y - (local1.y - local3.y)
            local3.z = local7.signpos.z
            manny:setpos(local3.x, local3.y, local3.z)
            signpost:setrot(0, local7.destangle, 0)
        else
            sg.signpost:spin(system.currentSet.rubacava_point)
            if system.currentSet == sg and sg:current_setup() ~= sg_spdws then
                signpost:play_chore(signpost_show_lit)
            end
        end
        local4.interest_actor:put_in_set(system.currentSet)
        local1 = signpost:getpos()
        local4.obj_x = local1.x
        local4.obj_y = local1.y
        local4.obj_z = local1.z + 0.60000002
        local4.interest_actor:setpos(local4.obj_x, local4.obj_y, local4.obj_z)
        local4:make_touchable()
        local4.use_pnt_x, local4.use_pnt_y, local4.use_pnt_z = signpost:get_manny_pos()
        local2 = signpost:getrot()
        local4.use_rot_x = local2.x
        local4.use_rot_y = local2.y + 110
        local4.use_rot_z = local2.z
        signpost:set_collision_mode(COLLISION_BOX, 0.30000001)
    end
    END_CUT_SCENE()
    if not local8 then
        signpost.current_set = system.currentSet
        signpost.current_pos = signpost:getpos()
        signpost.current_rot = signpost:getrot()
    end
    return TRUE
end
sg.signpost.spin = function(arg1, arg2, arg3) -- line 2146
    local local1
    local local2, local3
    local local4, local5
    local1 = signpost:getrot()
    while local1.y > 360 do
        local1.y = local1.y - 360
    end
    while local1.y < 0 do
        local1.y = local1.y + 360
    end
    local2 = 0
    local3 = 1
    start_sfx("sgSgnRot.IMU")
    while local2 < 5 do
        local1.y = local1.y + local3
        if local3 < 40 then
            local3 = local3 + 1
        end
        if local1.y > 360 then
            local1.y = local1.y - 360
            local2 = local2 + 1
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    if not arg3 then
        arg3 = GetActorYawToPoint(signpost.hActor, arg2)
    end
    while arg3 > 360 do
        arg3 = arg3 - 360
    end
    while arg3 < 0 do
        arg3 = arg3 + 360
    end
    fade_sfx("sgSgnRot.IMU", 200, 0)
    start_sfx("sgSgnSlw.WAV", 127, 0)
    fade_sfx("sgSgnSlw.WAV", 200, 127)
    while local3 > 1 do
        local1.y = local1.y + local3
        local3 = local3 - local3 / 4
        if local1.y > 360 then
            local1.y = local1.y - 360
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    stop_sound("sgSgnRot.IMU")
    local3 = 1
    local4 = arg3
    if local4 > local1.y then
        local4 = local4 - 360
    end
    local5 = 0
    while local1.y > local4 do
        local1.y = local1.y - local3
        local3 = local3 + local3 / 2
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
        local5 = local5 + system.frameTime
        if local5 >= 150 then
            single_start_sfx("sgSgnStp.WAV")
        end
    end
    if local5 < 100 then
        single_start_sfx("sgSgnStp.WAV")
    end
    if abs(local1.y - local4) < local3 then
        local3 = abs(local1.y - local4)
    end
    while abs(local1.y - local4) > 1 do
        local3 = local3 - local3 / 3
        if local1.y > local4 then
            local1.y = local4 - local3
        else
            local1.y = local4 + local3
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    signpost:setrot(0, arg3, 0)
end
sg.signpost.use = function(arg1) -- line 2243
    if manny.is_holding == arg1 then
        arg1:plant()
    else
        sg.signpost:pickUp()
    end
end
sg.signpost.use_scythe = function(arg1) -- line 2251
    if arg1.uprooted then
        manny:say_line("/sgma054/")
    else
        manny:say_line("/sgma055/")
        manny:wait_for_message()
        manny:say_line("/sgma056/")
    end
end
sg.signpost.make_visible = function(arg1) -- line 2261
    signpost:default()
    signpost:put_in_set(system.currentSet)
    signpost:setpos(signpost.current_pos.x, signpost.current_pos.y, signpost.current_pos.z)
    signpost:setrot(signpost.current_rot.x, signpost.current_rot.y, signpost.current_rot.z)
    signpost:play_chore(signpost_show, "signpost.cos")
end
sg.heart = Object:create(sg, "/sgtx057/heart", -2.80985, -4.17379, 0.073100001, { range = 1 })
sg.heart.use_pnt_x = -2.6830399
sg.heart.use_pnt_y = -4.1160302
sg.heart.use_pnt_z = 0
sg.heart.use_rot_x = 0
sg.heart.use_rot_y = 118.755
sg.heart.use_rot_z = 0
sg.heart.wav = "spHrtWeb.wav"
sg.heart.touchable = FALSE
sg.heart.can_put_away = FALSE
sg.heart.lookAt = function(arg1) -- line 2282
    arg1.seen = TRUE
    manny:say_line("/spma010/")
end
sg.heart.pickUp = function(arg1) -- line 2287
    if manny:walk_closeto_object(arg1, 0.5) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        arg1.visible_actor:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:play_chore(ma_reach_low, "ma.cos")
        sleep_for(650)
        sg.heart:get()
        sg.heart:make_untouchable()
        manny:play_chore_looping(ma_activate_heart_beat, "ma.cos")
        start_sfx("sgGetHrt.wav")
        sleep_for(500)
        manny:play_chore_looping(ma_hold, "ma.cos")
        manny:stop_chore(ma_reach_low, "ma.cos")
        manny.is_holding = arg1
        if not arg1.seen then
            arg1:lookAt()
        end
        END_CUT_SCENE()
    end
end
sg.heart.use = function(arg1) -- line 2311
    if arg1.owner == manny then
        manny:say_line("/sgma058/")
    else
        arg1:pickUp()
    end
end
sg.heart.default_response = function(arg1) -- line 2319
    manny:say_line("/sgma059/")
end
sg.heart.use_scythe = function(arg1) -- line 2323
    manny:say_line("/sgma060/")
end
sg.heart.make_touchable = function(arg1) -- line 2327
    if not arg1.visible_actor then
        arg1.visible_actor = Actor:create(nil, nil, nil, arg1.name)
    end
    Object.make_touchable(arg1)
    arg1.visible_actor:set_costume("sp_glottis_heart.cos")
    arg1.visible_actor:put_in_set(sg)
    arg1.visible_actor:setpos(arg1.obj_x, arg1.obj_y, arg1.obj_z)
    arg1.visible_actor:setrot(0, 0, 0)
    arg1.visible_actor:set_visibility(TRUE)
    arg1.visible_actor:play_chore_looping(0)
    arg1.visible_actor:set_collision_mode(COLLISION_BOX, 1.1)
end
sg.heart.make_untouchable = function(arg1) -- line 2342
    if arg1.visible_actor then
        arg1.visible_actor:set_collision_mode(COLLISION_OFF)
        arg1.visible_actor:put_in_set(nil)
        arg1.visible_actor:set_visibility(FALSE)
        arg1.visible_actor:stop_chore(0)
    end
    Object.make_untouchable(arg1)
end
sg.heart.put_away = function(arg1) -- line 2352
    arg1:default_response()
    return FALSE
end
sg.bone_wagon = Object:create(sg, "/sgtx061/Bone Wagon", 3.50579, -0.84495902, 0.2538, { range = 2.5 })
sg.bone_wagon.use_pnt_x = 1.63726
sg.bone_wagon.use_pnt_y = -0.094200999
sg.bone_wagon.use_pnt_z = 0
sg.bone_wagon.use_rot_x = 0
sg.bone_wagon.use_rot_y = 301.353
sg.bone_wagon.use_rot_z = 0
sg.bone_wagon.lookAt = function(arg1) -- line 2366
    if not glottis.heartless then
        manny:say_line("/sgma062/")
    else
        manny:say_line("/sgma063/")
    end
end
sg.bone_wagon.pickUp = function(arg1) -- line 2374
    system.default_response("tow")
end
sg.bone_wagon.use = function(arg1) -- line 2378
    if not glottis.heartless then
        sg:get_in_BW()
    else
        manny:say_line("/trma068/")
    end
end
sg.bone_wagon.use_scythe = function(arg1) -- line 2386
    manny:say_line("/sgma065/")
end
sg.bone_wagon.use_bone = function(arg1) -- line 2390
    manny:say_line("/sgma066/")
end
sg.sm_door = Object:create(sg, "/sgtx067/trail", -5.7180099, -5.4510102, 1.1, { range = 1.5 })
sg.sg_sm_box = sg.sm_door
sg.sg_sm_box_bw = sg.sm_door
sg.sm_door.use_pnt_x = -4.5913901
sg.sm_door.use_pnt_y = -4.3188801
sg.sm_door.use_pnt_z = 0
sg.sm_door.use_rot_x = 0
sg.sm_door.use_rot_y = -224.203
sg.sm_door.use_rot_z = 0
sg.sm_door.out_pnt_x = -5.1719098
sg.sm_door.out_pnt_y = -4.9159999
sg.sm_door.out_pnt_z = 0
sg.sm_door.out_rot_x = 0
sg.sm_door.out_rot_y = -224.203
sg.sm_door.out_rot_z = 0
sg.sm_door.walkOut = function(arg1) -- line 2416
    if manny.is_driving then
        bonewagon:squelch_sfx()
        if rnd(5) then
            glottis:say_line("/sggl071/")
        else
            glottis:say_line("/sggl069/")
        end
        glottis:wait_for_message()
        bonewagon:restore_sfx()
    elseif glottis.heartless then
        manny:say_line("/sgma070/")
    elseif not sg:check_post(arg1) then
        sm:come_out_door(sm.sg_door)
    end
end
sg.sm_door.comeOut = function(arg1) -- line 2435
    if not glottis.ripped_heart then
        start_script(sg.glottis_rip_heart)
    else
        arg1:come_out_door()
    end
end
sg.sp_door = Object:create(sg, "/sgtx072/path", -2.20207, -6.4960999, 0.47999999, { range = 1.5 })
sg.sg_sp_box = sg.sp_door
sg.sg_sp_box_bw = sg.sp_door
sg.sp_door.use_pnt_x = -2.9080701
sg.sp_door.use_pnt_y = -6.0844102
sg.sp_door.use_pnt_z = 0
sg.sp_door.use_rot_x = 0
sg.sp_door.use_rot_y = 197.575
sg.sp_door.use_rot_z = 0
sg.sp_door.out_pnt_x = -2.1252999
sg.sp_door.out_pnt_y = -6.5885901
sg.sp_door.out_pnt_z = 0
sg.sp_door.out_rot_x = 0
sg.sp_door.out_rot_y = -152.37801
sg.sp_door.out_rot_z = 0
sg.sp_door.lookAt = function(arg1) -- line 2464
    manny:say_line("/sgma073/")
end
sg.sp_door.walkOut = function(arg1) -- line 2468
    if manny.is_driving then
        bonewagon:squelch_sfx()
        glottis:say_line("/sggl074/")
        glottis:wait_for_message()
        bonewagon:restore_sfx()
    elseif not sg:check_post(arg1) then
        if not sp.seen_intro then
            sp.intro_flag = TRUE
        end
        sp:come_out_door(sp.sg_door)
    end
end
sg.sp_door.comeOut = function(arg1) -- line 2484
    system.lock_display()
    break_here()
    sg:current_setup(2)
    manny:setpos(-2.89254, -6.14322, 0)
    manny:setrot(0, 746.691, 0)
    system.unlock_display()
end
sg.mod_door = Object:create(sg, "/sgtx075/bumpy road", 12.542, 4.9489999, 0.80000001, { range = 1.5 })
sg.sg_mod_box = sg.mod_door
sg.mod_door.use_pnt_x = 11.1404
sg.mod_door.use_pnt_y = 3.9449799
sg.mod_door.use_pnt_z = 0
sg.mod_door.use_rot_x = 0
sg.mod_door.use_rot_y = 320.28
sg.mod_door.use_rot_z = 0
sg.mod_door.out_pnt_x = 11.6844
sg.mod_door.out_pnt_y = 4.5656199
sg.mod_door.out_pnt_z = 0
sg.mod_door.out_rot_x = 0
sg.mod_door.out_rot_y = 301.72699
sg.mod_door.out_rot_z = 0
sg.mod_door.lookAt = function(arg1) -- line 2514
    if glottis.talked_clearance then
        START_CUT_SCENE()
        manny:say_line("/sgma076/")
        manny:wait_for_message()
        manny:say_line("/sgma077/")
        END_CUT_SCENE()
    else
        manny:say_line("/sgma078/")
    end
end
sg.mod_door.walkOut = function(arg1) -- line 2526
    local local1
    if glottis.heartless then
        sg.sm_door:walkOut()
    elseif manny.is_driving then
        if mod_solved then
            START_CUT_SCENE()
            stop_script(bonewagon.gas)
            stop_script(bonewagon.reverse)
            stop_script(bonewagon.left)
            stop_script(bonewagon.right)
            bonewagon:brake(TRUE)
            bonewagon:stop_cruise_sounds()
            sleep_for(500)
            bonewagon:play_chore(bonewagon_gl_shocks)
            bonewagon:wait_for_chore(bonewagon_gl_shocks)
            bonewagon:play_chore_looping(bonewagon_gl_stay_Up)
            local1 = 0
            bonewagon:set_walk_rate(1)
            bonewagon:ignore_boxes()
            while local1 < 1000 do
                bonewagon:walk_forward()
                break_here()
                local1 = local1 + system.frameTime
            end
            bonewagon:stop_chore(bonewagon_gl_stay_up)
            bonewagon:play_chore(bonewagon_gl_no_shocks)
            bonewagon:follow_boxes()
            END_CUT_SCENE()
            bv:drive_in()
        elseif not glottis.talked_clearance then
            glottis.talked_clearance = TRUE
            bonewagon:squelch_sfx()
            glottis:say_line("/sggl079/")
            glottis:wait_for_message()
            glottis:say_line("/sggl080/")
            glottis:wait_for_message()
            bonewagon:restore_sfx()
        else
            bonewagon:squelch_sfx()
            glottis:say_line("/sggl081/")
            glottis:wait_for_message()
            bonewagon:restore_sfx()
        end
    elseif not sg:check_post(arg1) then
        bv:come_out_door(bv.sg_door)
    end
end
sg.na_door = Object:create(sg, "/sgtx082/trail", -0.498, 7.7490001, 0.27000001, { range = 1.5 })
sg.sg_na_box = sg.na_door
sg.na_door.use_pnt_x = -1.04241
sg.na_door.use_pnt_y = 6.2573299
sg.na_door.use_pnt_z = 0
sg.na_door.use_rot_x = 0
sg.na_door.use_rot_y = 332.31601
sg.na_door.use_rot_z = 0
sg.na_door.out_pnt_x = -0.35649699
sg.na_door.out_pnt_y = 7.70927
sg.na_door.out_pnt_z = 0
sg.na_door.out_rot_x = 0
sg.na_door.out_rot_y = -7.7764401
sg.na_door.out_rot_z = 0
sg.na_door.lookAt = function(arg1) -- line 2606
    manny:say_line("/sgma083/")
end
sg.na_door.walkOut = function(arg1) -- line 2610
    if glottis.heartless then
        sg.sm_door:walkOut()
    else
        na:come_out_door(na.sg_door)
    end
end
sg.tr_door = Object:create(sg, "/sgtx084/trail", 5.82793, -6.8160901, 0.5, { range = 1.5 })
sg.sg_tr_box = sg.tr_door
sg.tr_door.use_pnt_x = 5.3253398
sg.tr_door.use_pnt_y = -5.6335101
sg.tr_door.use_pnt_z = 0
sg.tr_door.use_rot_x = 0
sg.tr_door.use_rot_y = -143.755
sg.tr_door.use_rot_z = 0
sg.tr_door.out_pnt_x = 6.01823
sg.tr_door.out_pnt_y = -6.7782698
sg.tr_door.out_pnt_z = 0
sg.tr_door.out_rot_x = 0
sg.tr_door.out_rot_y = -156.267
sg.tr_door.out_rot_z = 0
sg.tr_door.lookAt = function(arg1) -- line 2637
    START_CUT_SCENE()
    ResetMarioControls()
    manny:say_line("/sgma085/")
    manny:setpos(5.43677, -5.04949, 0, 0, 11.5, 0)
    END_CUT_SCENE()
end
sg.tr_door.walkOut = function(arg1) -- line 2645
    if glottis.heartless then
        sg.sm_door:walkOut()
    elseif not manny.is_driving then
        arg1:lookAt()
    else
        tr:drive_in()
    end
end

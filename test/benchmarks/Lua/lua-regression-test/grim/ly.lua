CheckFirstTime("ly.lua")
dofile("br_idles.lua")
dofile("cc_taplook.lua")
dofile("cc_play_slot.lua")
dofile("meche_seduction.lua")
dofile("cc_seduction.lua")
dofile("unicycle_man.lua")
dofile("ly_slot_door.lua")
dofile("msb_msb_sheet.lua")
dofile("meche_ruba.lua")
dofile("cc_toga.lua")
dofile("mi_with_cc_toga.lua")
dofile("ly_cc_sheet.lua")
ly = Set:create("ly.set", "le mans lobby", { ly_top = 0, ly_intha = 1, ly_intha1 = 1, ly_intha2 = 1, ly_intha3 = 1, ly_intha4 = 1, ly_intha5 = 1, ly_intha6 = 1, ly_intha7 = 1, ly_sltha = 2, ly_chaws = 3, ly_elems = 4, ly_kenla = 5, ly_lavha = 6 })
ly.unicycle_roll_min_vol = 5
ly.unicycle_roll_max_vol = 20
slot_wheel = { parent = Actor }
slot_wheel.pitch = { }
slot_wheel.pitch[1] = { 30, 105, 175, 280 }
slot_wheel.pitch[2] = { 140, 210, 315 }
slot_wheel.pitch[3] = { 65, 245 }
slot_wheel.pitch[4] = { 350 }
slot_wheel.create = function(arg1) -- line 42
    local local1
    local local2
    local1 = Actor:create(nil, nil, nil, "slot wheel")
    local1.parent = arg1
    local2 = rndint(1, 4)
    local1.cur_pitch = arg1.pitch[local2][1]
    local1.slot = FALSE
    return local1
end
slot_wheel.default = function(arg1) -- line 55
    arg1:set_costume("ly_slotwheel.cos")
    arg1:put_in_set(ly)
    arg1:setrot(arg1.cur_pitch, 270, 90)
end
slot_wheel.spin = function(arg1) -- line 61
    local local1
    local local2
    local local3
    local local4 = { "ly_wlsp1.WAV", "ly_wlsp2.WAV", "ly_wlsp3.WAV" }
    local2 = arg1:get_positive_rot()
    local1 = 10
    arg1.slot = nil
    while arg1.slot == nil do
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        arg1.cur_pitch = arg1.cur_pitch - local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        if local1 < 60 then
            local1 = local1 + 1
        end
        break_here()
    end
    local3 = FALSE
    while not local3 do
        if local1 > 5 then
            local1 = local1 - 1
        end
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
    arg1:play_sound_at(pick_one_of(local4, TRUE))
end
slot_wheel.scramble_to_win = function(arg1) -- line 107
    local local1
    local local2, local3
    arg1.slot = 4
    local2 = arg1:get_positive_rot()
    if rnd(5) then
        local1 = 5
    else
        local1 = -5
    end
    local3 = FALSE
    arg1.cur_pitch = local2.x
    while not local3 do
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
end
slot_wheel.check_match = function(arg1) -- line 137
    local local1, local2
    local local3
    local3 = FALSE
    local1, local2 = next(arg1.pitch[arg1.slot], nil)
    while local1 and not local3 do
        if abs(local2 - arg1.cur_pitch) < 5 then
            local3 = TRUE
        end
        local1, local2 = next(arg1.pitch[arg1.slot], local1)
    end
    return local3
end
slot_machine = { }
slot_machine.create = function(arg1) -- line 156
    local local1
    local1 = { }
    local1.parent = arg1
    local1.actors = { }
    local1.pos = { }
    local1.rot = nil
    local1.spinning = FALSE
    return local1
end
slot_machine.create_wheels = function(arg1) -- line 169
    local local1
    if not arg1.actors then
        arg1.actors = { }
    end
    local1 = 1
    while local1 <= 3 do
        if not arg1.actors[local1] then
            arg1.actors[local1] = slot_wheel:create()
        end
        local1 = local1 + 1
    end
end
slot_machine.free = function(arg1) -- line 185
    if arg1.actors then
        if arg1.actors[1] then
            arg1.actors[1]:free()
        end
        if arg1.actors[2] then
            arg1.actors[2]:free()
        end
        if arg1.actors[3] then
            arg1.actors[3]:free()
        end
    end
    arg1.actors = nil
end
slot_machine.default = function(arg1) -- line 200
    local local1
    arg1:create_wheels()
    local1 = 1
    while local1 <= 3 do
        arg1.actors[local1]:default()
        arg1.actors[local1]:setpos(arg1.pos[local1].x, arg1.pos[local1].y, arg1.pos[local1].z)
        if arg1.rot then
            arg1.actors[local1]:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
        end
        local1 = local1 + 1
    end
end
slot_machine.spin = function(arg1) -- line 216
    arg1.spin_scripts = { }
    arg1.spinning = TRUE
    arg1.wheel_sound = arg1.actors[1]:play_sound_at("ly_wheel.IMU", 10, 80)
    arg1.spin_scripts[1] = start_script(arg1.actors[1].spin, arg1.actors[1])
    break_here()
    arg1.spin_scripts[2] = start_script(arg1.actors[2].spin, arg1.actors[2])
    break_here()
    arg1.spin_scripts[3] = start_script(arg1.actors[3].spin, arg1.actors[3])
end
slot_machine.scramble_to_win = function(arg1) -- line 229
    local local1, local2, local3
    local1 = start_script(arg1.actors[1].scramble_to_win, arg1.actors[1])
    local2 = start_script(arg1.actors[2].scramble_to_win, arg1.actors[2])
    local3 = start_script(arg1.actors[3].scramble_to_win, arg1.actors[3])
    wait_for_script(local1)
    wait_for_script(local2)
    wait_for_script(local3)
end
slot_machine.stop = function(arg1, arg2) -- line 239
    local local1
    local local2
    if arg1.spinning then
        local1 = FALSE
        local2 = { }
        repeat
            local2[1] = rndint(1, 4)
            local2[2] = rndint(1, 4)
            local2[3] = rndint(1, 4)
            if not arg2 then
                if local2[1] == local2[2] and local2[2] == local2[3] then
                    local1 = FALSE
                else
                    local1 = TRUE
                end
            elseif local2[1] == local2[2] and local2[2] == local2[3] then
                local1 = TRUE
            else
                local1 = FALSE
            end
            if not local1 then
                break_here()
            end
        until local1
        arg1.actors[1].slot = local2[1]
        if arg1.spin_scripts[1] then
            wait_for_script(arg1.spin_scripts[1])
        end
        sleep_for(100)
        arg1.actors[2].slot = local2[2]
        if arg1.spin_scripts[2] then
            wait_for_script(arg1.spin_scripts[2])
        end
        sleep_for(100)
        arg1.actors[3].slot = local2[3]
        if arg1.spin_scripts[3] then
            wait_for_script(arg1.spin_scripts[3])
        end
    end
    arg1.spinning = FALSE
    stop_sound("ly_wheel.IMU")
    arg1.spin_scripts = nil
end
slot_machine.freeze = function(arg1) -- line 295
    arg1.actors[1]:freeze()
    arg1.actors[2]:freeze()
    arg1.actors[3]:freeze()
end
slot_machine.thaw = function(arg1, arg2) -- line 301
    arg1.actors[1]:thaw(arg2)
    arg1.actors[2]:thaw(arg2)
    arg1.actors[3]:thaw(arg2)
end
ly.slot_handle = { }
ly.slot_handle.parent = Actor
ly.slot_handle.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 312
    local local1
    local1 = Actor:create(nil, nil, nil, "handle")
    local1.parent = ly.slot_handle
    if arg2 then
        local1.pos = { }
        local1.pos.x = arg2
        local1.pos.y = arg3
        local1.pos.z = arg4
    end
    if arg5 then
        local1.rot = { }
        local1.rot.x = arg5
        local1.rot.y = arg6
        local1.rot.z = arg7
    end
    return local1
end
ly.slot_handle.default = function(arg1) -- line 333
    arg1:put_in_set(ly)
    arg1:set_costume("ly_slothandle.cos")
    arg1:play_chore(1)
    if arg1.pos then
        arg1:setpos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    end
    if arg1.rot then
        arg1:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
    end
end
ly.slot_handle.init = function(arg1) -- line 345
    if not arg1[1] then
        arg1[1] = ly.slot_handle:create(0.63847, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[2] then
        arg1[2] = ly.slot_handle:create(1.05447, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[3] then
        arg1[3] = ly.slot_handle:create(1.82115, -0.135567, 0.015, 0, 270, 0)
    end
    if not arg1[4] then
        arg1[4] = ly.slot_handle:create(1.82285, -0.541493, 0.013, 0, 270, 0)
    end
    arg1[1]:default()
    arg1[2]:default()
    arg1[3]:default()
    arg1[4]:default()
    arg1[4]:set_visibility(FALSE)
    arg1[1]:freeze()
    arg1[2]:freeze()
end
ly.slot_handle.free = function(arg1) -- line 369
    if arg1[1] then
        arg1[1]:free()
    end
    if arg1[2] then
        arg1[2]:free()
    end
    if arg1[3] then
        arg1[3]:free()
    end
end
charlies_slot = slot_machine:create()
charlies_slot.pos[1] = { x = 2.1475301, y = -0.416738, z = 0.44400001 }
charlies_slot.pos[2] = { x = 2.1475301, y = -0.492737, z = 0.44400001 }
charlies_slot.pos[3] = { x = 2.1475301, y = -0.569736, z = 0.44400001 }
mannys_slot = slot_machine:create()
mannys_slot.pos[1] = { x = 2.1358399, y = -0.0144972, z = 0.44499999 }
mannys_slot.pos[2] = { x = 2.1358399, y = -0.0924972, z = 0.44499999 }
mannys_slot.pos[3] = { x = 2.1358399, y = -0.169497, z = 0.44499999 }
ly.keno_actor = Actor:create(nil, nil, nil, "keno board")
ly.keno_actor.current_number = nil
ly.keno_actor.current_game = nil
ly.keno_actor.game_index = 1
ly.keno_actor.game_paused = FALSE
ly.keno_actor.default = function(arg1) -- line 417
    arg1:set_costume("ly_keno.cos")
    arg1:put_in_set(ly)
    arg1:setpos(-0.0558433, -0.0978411, 2.801)
    arg1:set_visibility(TRUE)
end
ly.keno_actor.game = function(arg1) -- line 424
    while TRUE do
        arg1:clear_game()
        while arg1.game_index < 10 do
            if not arg1.game_paused then
                arg1:choose_number()
            end
            sleep_for(15000)
        end
        break_here()
    end
end
ly.keno_actor.clear_game = function(arg1) -- line 437
    arg1.current_game = { }
    arg1.game_index = 0
    arg1.current_number = nil
    arg1:complete_chore(32)
end
ly.keno_actor.choose_number = function(arg1) -- line 444
    local local1, local2
    local2 = TRUE
    while local2 do
        local1 = rndint(1, 32)
        if not arg1:find_number(local1) then
            local2 = FALSE
        else
            break_here()
        end
    end
    arg1.game_index = arg1.game_index + 1
    arg1.current_game[arg1.game_index] = local1
    arg1.current_number = local1
    arg1:complete_chore(local1 - 1)
    arg1:play_sound_at("ly_keno.wav", 10, 70)
end
ly.keno_actor.find_number = function(arg1, arg2) -- line 463
    local local1, local2
    local2 = FALSE
    local1 = 1
    while local1 <= arg1.game_index and not local2 do
        if arg1.current_game[local1] == arg2 then
            local2 = TRUE
        end
        local1 = local1 + 1
    end
    return local2
end
unicycle_man.point = { }
unicycle_man.point[0] = { }
unicycle_man.point[0].pos = { x = 0.89800102, y = 0.39131901, z = 0 }
unicycle_man.point[0].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point[1] = { }
unicycle_man.point[1].pos = { x = 0.49000099, y = 0.394319, z = 0 }
unicycle_man.point[1].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.mid = { }
unicycle_man.point["mid"].pos = { x = 0.74000102, y = 0.090319097, z = 0 }
unicycle_man.point["mid"].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.charlie = { }
unicycle_man.point["charlie"].pos = { x = 1.84929, y = -0.39064199, z = 0 }
unicycle_man.point["charlie"].rot = { x = 0, y = 270.01999, z = 0 }
unicycle_man.cur_point = 0
unicycle_man.save_pos = function(arg1) -- line 499
    arg1.current_pos = arg1:getpos()
    arg1.current_rot = arg1:getrot()
end
unicycle_man.restore_pos = function(arg1) -- line 504
    local local1
    if arg1.current_pos then
        arg1:setpos(arg1.current_pos.x, arg1.current_pos.y, arg1.current_pos.z)
        arg1:setrot(arg1.current_rot.x, arg1.current_rot.y, arg1.current_rot.z)
    else
        local1 = arg1.point[arg1.cur_point]
        arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
        arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
    end
end
unicycle_man.cycle_to = function(arg1, arg2, arg3) -- line 517
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg1.point.mid.pos)
    local1 = local1 + 180
    arg1:set_turn_rate(120)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:setrot(0, local1, 0, TRUE)
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(-0.30000001)
    while proximity(arg1.hActor, arg1.point.mid.pos.x, arg1.point.mid.pos.y, arg1.point.mid.pos.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:stop_chore(unicycle_man_roll)
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.cycle_straight_to = function(arg1, arg2, arg3) -- line 564
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:set_turn_rate(120)
    arg1:stop_chore(unicycle_man_idles)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    arg1:setrot(0, local1, 0, TRUE)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.turn_to_manny = function(arg1) -- line 591
    local local1, local2
    local2 = manny:getpos()
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    local1 = GetActorYawToPoint(arg1.hActor, local2)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    stop_sound("um_roll.IMU")
end
ly.agent_talk_count = 0
ly.talk_to_agent = function(arg1) -- line 610
    local local1 = TRUE
    local local2 = FALSE
    local local3, local4
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    manny:set_collision_mode(COLLISION_OFF)
    ly.agent_talk_count = ly.agent_talk_count + 1
    if ly.agent_talk_count == 1 then
        ly.met_agent = TRUE
        manny:say_line("/lyma066/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum067/")
        unicycle_man:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:say_line("/lyum068/")
        unicycle_man:wait_for_message()
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        manny:tilt_head_gesture(TRUE)
        manny:point_gesture(TRUE)
        manny:say_line("/lyma069/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum070/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum071/")
        unicycle_man:wait_for_message()
    elseif ly.agent_talk_count == 2 then
        manny:say_line("/lyma072/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        unicycle_man:say_line("/lyum073/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum074/")
        unicycle_man:wait_for_message()
        manny:say_line("/lyma075/")
    elseif ly.meche_talk_count < 2 then
        manny:say_line("/lyma076/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum077/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum078/")
        unicycle_man:wait_for_message()
        local2 = TRUE
    elseif not ly.charlie_on_floor then
        manny:say_line("/lyma079/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum080/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum081/")
        unicycle_man:wait_for_message()
    else
        local1 = FALSE
        start_script(ly.charlies_jackpot)
    end
    END_CUT_SCENE()
    manny:set_collision_mode(COLLISION_OFF)
    if local1 then
        start_script(ly.unicycle_idles, ly, local2)
    end
end
ly.unicycle_idles = function(arg1, arg2) -- line 708
    local local1, local2
    unicycle_man.in_machine = FALSE
    unicycle_man.rolling = FALSE
    while TRUE do
        break_here()
        ly:track_unicycle_man()
        if not arg2 then
            local1 = unicycle_man.cur_point + 1
            if not unicycle_man.point[local1] then
                local1 = 0
            end
            unicycle_man.cur_point = local1
            unicycle_man.rolling = TRUE
            start_script(unicycle_man.cycle_to, unicycle_man, unicycle_man.point[local1].pos, unicycle_man.point[local1].rot)
            while find_script(unicycle_man.cycle_to) do
                break_here()
                ly:track_unicycle_man()
            end
            unicycle_man.rolling = FALSE
            sleep_for(10000)
        else
            local1 = unicycle_man.cur_point
            unicycle_man:setrot(unicycle_man.point[local1].rot.x, unicycle_man.point[local1].rot.y, unicycle_man.point[local1].rot.z, TRUE)
            unicycle_man:wait_for_actor()
        end
        unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
        unicycle_man:wait_for_chore(unicycle_man_idles)
        unicycle_man.in_machine = TRUE
        unicycle_man:run_chore(unicycle_man_crawl_slot)
        start_script(ly.unicycle_slot_sfx)
        sleep_for(rndint(6000, 9000))
        unicycle_man:play_sound_at("ly_pyoff.IMU", 80, 110)
        unicycle_man:run_chore(unicycle_man_out_slot)
        fade_sfx("ly_pyoff.IMU", 200)
        unicycle_man:play_chore_looping(unicycle_man_idles)
        unicycle_man.in_machine = FALSE
        sleep_for(10000)
    end
end
ly.unicycle_stop_idles = function(arg1) -- line 762
    stop_sound("ly_pyoff.IMU")
    stop_script(ly.unicycle_idles)
    if unicycle_man.rolling then
        while find_script(unicycle_man.cycle_to) do
            break_here()
            ly:track_unicycle_man()
        end
        unicycle_man.rolling = FALSE
    elseif unicycle_man.in_machine then
        if unicycle_man:is_choring(unicycle_man_crawl_slot) then
            unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
            unicycle_man:run_chore(unicycle_man_out_slot)
        elseif unicycle_man:is_choring(unicycle_man_out_slot) then
            unicycle_man:wait_for_chore(unicycle_man_out_slot)
        else
            unicycle_man:run_chore(unicycle_man_out_slot)
        end
    end
    unicycle_man:play_chore_looping(unicycle_man_idles)
end
ly.track_unicycle_man = function(arg1) -- line 788
    local local1
    local1 = unicycle_man:getpos()
    ly.unicycle_man.obj_x = local1.x
    ly.unicycle_man.obj_y = local1.y
    ly.unicycle_man.obj_z = local1.z + 0.40000001
    ly.unicycle_man.interest_actor:put_in_set(ly)
    ly.unicycle_man.interest_actor:setpos(ly.unicycle_man.obj_x, ly.unicycle_man.obj_y, ly.unicycle_man.obj_z)
    if hot_object == ly.unicycle_man then
        system.currentActor:head_look_at(ly.unicycle_man)
    end
end
ly.unicycle_slot_sfx = function(arg1) -- line 802
    local local1 = { "um_swit1.wav", "um_swit2.wav", "um_swit3.wav" }
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
end
ly.brennis_idle_table = Idle:create("br_idles")
idt = ly.brennis_idle_table
idt:add_state("rest", { rest = 0.97000003, looks = 0.0099999998, moves_head = 0.0099999998, scrtch_chst = 0.0099999998 })
idt:add_state("looks", { rest = 1 })
idt:add_state("moves_head", { rest = 1 })
idt:add_state("scrtch_chst", { rest = 1 })
ly.brennis_talk_count = 0
ly.brennis_stop_idle = function(arg1) -- line 830
    stop_script(brennis.ly_idle_script)
    brennis.ly_idle_script = nil
    brennis:wait_for_chore()
    brennis:play_chore(br_idles_rest)
end
ly.brennis_start_idle = function(arg1) -- line 837
    brennis:stop_chore()
    brennis.ly_idle_script = start_script(brennis.new_run_idle, brennis, "rest", ly.brennis_idle_table, "br_idles.cos")
end
ly.talk_clothes_with_brennis = function(arg1) -- line 842
    START_CUT_SCENE()
    ly.brennis_talk_count = ly.brennis_talk_count + 1
    start_script(ly.brennis_stop_idle, ly)
    if ly.brennis_talk_count == 1 then
        ly:current_setup(ly_kenla)
        sleep_for(1500)
        manny:tilt_head_gesture()
        manny:say_line("/lyma012/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs013/")
        brennis:wait_for_message()
        brennis:say_line("/lybs014/")
    elseif ly.brennis_talk_count == 2 then
        ly:current_setup(ly_kenla)
        manny:shrug_gesture()
        manny:say_line("/lyma015/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_scrtch_chst, "br_idles.cos")
        brennis:say_line("/lybs016/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma017/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs018/")
    elseif ly.brennis_talk_count == 3 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma019/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs020/")
        brennis:wait_for_message()
        brennis:say_line("/lybs021/")
        brennis:wait_for_message()
        brennis:say_line("/lybs022/")
        brennis:wait_for_message()
    elseif ly.brennis_talk_count == 4 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma023/")
        manny:wait_for_message()
        manny:tilt_head_gesture()
        manny:say_line("/lyma024/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs025/")
        brennis:wait_for_message()
        brennis:say_line("/lybs026/")
        brennis:wait_for_chore(br_idles_bar_door, "br_idles.cos")
    elseif ly.brennis_talk_count == 5 then
        ly:current_setup(ly_kenla)
        manny:point_gesture()
        manny:say_line("/lyma027/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs028/")
        brennis:wait_for_message()
        brennis:say_line("/lybs029/")
        brennis:wait_for_message()
        brennis:say_line("/lybs030/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma031/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs032/")
    else
        ly:current_setup(ly_kenla)
        manny:twist_head_gesture()
        manny:say_line("/lyma033/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs034/")
    end
    END_CUT_SCENE()
    brennis:wait_for_chore()
    ly:brennis_start_idle()
end
ly.meche_talk_count = 0
ly.gun_control = function() -- line 947
    while TRUE do
        break_here()
        if manny.is_holding == fi.gun and system.currentSet == ly then
            START_CUT_SCENE()
            wait_for_script(open_inventory)
            wait_for_script(close_inventory)
            manny:clear_hands()
            manny:say_line("/lyma003/")
            manny:wait_for_message()
            manny:say_line("/lyma004/")
            END_CUT_SCENE()
        end
    end
end
ly.playslots = function(arg1, arg2) -- line 963
    START_CUT_SCENE()
    manny:walkto(1.8283, -0.263458, 0, 0, 292.582, 0)
    manny:wait_for_actor()
    manny:head_look_at(nil)
    ly.slot_handle[3]:thaw(TRUE)
    mannys_slot:thaw(TRUE)
    ly.slot_handle[3]:play_chore(0)
    sleep_for(50)
    manny:play_chore(msb_reach_cabinet, manny.base_costume)
    sleep_for(500)
    mannys_slot:spin()
    sleep_for(500)
    manny:head_look_at(ly.slot1)
    if not ly.played then
        ly.played = TRUE
        manny:say_line("/lyma006/")
        wait_for_message()
        manny:say_line("/lyma007/")
        wait_for_message()
    end
    manny:wait_for_chore(msb_reach_cabinet, manny.base_costume)
    manny:stop_chore(msb_reach_cabinet, manny.base_costume)
    manny:head_look_at(ly.slot1)
    ly.slot_handle[3]:wait_for_chore(0)
    ly.slot_handle[3]:freeze()
    if rnd() then
        mannys_slot:stop(FALSE)
        if not ly.lost then
            ly.lost = TRUE
            manny:say_line("/lyma008/")
        end
    else
        mannys_slot:stop(TRUE)
        manny:say_line("/lyma009/")
        if not ly.won then
            ly.won = TRUE
            manny:wait_for_message()
            manny:head_look_at_point(1.89026, -0.0954438, 0)
            manny:say_line("/lyma010/")
            manny:wait_for_message()
            manny:say_line("/lyma011/")
        end
    end
    END_CUT_SCENE()
    manny:head_look_at(nil)
    mannys_slot:freeze()
end
ly.talk_clothes_with_meche = function(arg1) -- line 1019
    START_CUT_SCENE()
    if ly.charlie_on_floor then
        meche:say_line("/lymc005/")
    else
        ly.meche_talk_count = ly.meche_talk_count + 1
        if ly.meche_talk_count == 1 then
            single_start_script(ly.seduce_charlie, ly)
            manny:say_line("/lyma035/")
            manny:wait_for_message()
            meche:say_line("/lymc036/")
        elseif ly.meche_talk_count == 2 then
            manny:walkto_object(ly.meche_obj)
            manny:wait_for_actor()
            if find_script(ly.seduce_charlie) and ly.meche_obj.touchable then
                stop_script(ly.seduce_charlie)
            end
            manny:say_line("/lyma037/")
            manny:wait_for_message()
            while not ly.meche_obj.touchable do
                break_here()
            end
            meche:say_line("/lymc038/")
            meche:wait_for_message()
            meche:say_line("/lymc039/")
            meche:wait_for_message()
            meche:say_line("/lymc040/")
            ly:manny_take_sheet_from_meche()
        elseif ly.meche_talk_count == 3 then
            manny:say_line("/lyma041/")
            manny:wait_for_message()
            meche:say_line("/lymc042/")
            meche:wait_for_message()
            meche:say_line("/lymc043/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
            meche:wait_for_message()
            manny:say_line("/lyma044/")
        else
            manny:say_line("/lyma045/")
            manny:wait_for_message()
            meche:say_line("/lymc046/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
        end
    end
    END_CUT_SCENE()
end
ly.manny_take_sheet_from_meche = function(arg1) -- line 1071
    manny:walkto_object(ly.meche_obj)
    manny:wait_for_actor()
    if meche:is_choring(meche_seduction_mec_sed_ch, FALSE, "meche_seduction.cos") then
        meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    end
    stop_script(ly.seduce_charlie)
    stop_script(ly.meche_idles)
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(0, "mi_msb_sheet.cos")
    manny:push_costume("msb_msb_sheet.cos")
    manny:setrot(0, 231.446, 0)
    manny:play_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    ly.sheet:get()
    manny.is_holding = ly.sheet
    meche:wait_for_chore(0, "mi_msb_sheet.cos")
    meche:stop_chore(0, "mi_msb_sheet.cos")
    meche:play_chore(meche_ruba_hands_down_hold, "meche_ruba.cos")
    manny:wait_for_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    meche.holding_sheet = FALSE
    inventory_disabled = TRUE
    ly.ready_to_seduce = FALSE
    single_start_script(ly.meche_idles)
end
ly.talk_toga_with_charlie = function(arg1) -- line 1101
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    manny:walkto_object(ly.charlie_obj)
    if ly.meche_talk_count < 3 then
        manny:say_line("/lyma047/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc048/")
        charlie:run_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    else
        manny:say_line("/lyma049/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc050/")
        charlie:wait_for_message()
        charlie:play_chore(cc_taplook_turn2slots, "cc_taplook.cos")
        charlie:say_line("/lycc051/")
        charlie:wait_for_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    end
    if not find_script(charlies_slot.stop) then
        charlies_slot:stop()
    else
        wait_for_script(charlies_slot.stop)
    end
    charlie:stop_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    charlie:pop_costume()
    start_script(ly.charlie_idles, ly)
    END_CUT_SCENE()
end
ly.throw_sheet = function(arg1) -- line 1149
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    stop_script(charlies_slot.stop)
    stop_sound("ly_wheel.IMU")
    stop_script(slot_wheel.spin)
    if not ly.sheet_on_floor.has_object_states then
        ly:add_object_state(ly_sltha, "ly_cc_sheet.bm", "ly_cc_sheet.zbm", OBJSTATE_STATE, TRUE)
        ly.sheet_on_floor:set_object_state("ly_cc_sheet.cos")
        ly.sheet_on_floor.interest_actor:put_in_set(ly)
    end
    ly.sheet:free()
    ly.charlie_on_floor = TRUE
    ly.charlie_obj:make_untouchable()
    box_off("charlie_box")
    box_off("mannys_slot")
    manny.is_holding = nil
    manny:stop_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    inventory_disabled = FALSE
    manny:pop_costume()
    manny:setpos(1.50568, -0.210109, 0)
    manny:setrot(0, 176.891, 0)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    charlie:set_visibility(FALSE)
    ly.sheet_on_floor:play_chore(ly_cc_sheet_here)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_sheet_toss.snm")
    sleep_for(500)
    start_sfx("cc_shtts.WAV")
    ly.slot_handle[4]:set_visibility(TRUE)
    sleep_for(1000)
    if not ly.sheeted then
        ly.sheeted = TRUE
        charlie:say_line("/lycc052/")
    else
        charlie:say_line("/lycc053/")
    end
    sleep_for(4600)
    start_sfx("ccsheet1.wav")
    sleep_for(1250)
    start_sfx("cc_falls.wav")
    charlie:wait_for_message()
    charlie:say_line("/lycc054/")
    charlie:wait_for_message()
    ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
    wait_for_movie()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    start_script(ly.charlie_struggle)
    start_script(ly.charlie_get_up_timer)
    END_CUT_SCENE()
end
ly.charlie_struggle = function(arg1) -- line 1226
    local local1
    local local2 = { "/lycc055/", "/lycc056/", "/lycc057/", "/lycc058/", "/lycc059/", "/lycc060/", "/lycc061/", "/lycc062/", "/lycc063/" }
    while TRUE do
        sleep_for(2000)
        ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
        local1 = pick_one_of({ "ccsheet1.wav", "ccsheet2.wav", "ccsheet3.wav", "ccsheet4.wav", "ccsheet5.wav", "ccsheet6.wav" })
        start_sfx(local1, IM_HIGH_PRIORITY, 100)
        charlie:say_line(pick_one_of(local2, TRUE), { background = TRUE, skip_log = TRUE, volume = 80 })
        charlie:wait_for_message()
    end
end
ly.charlie_get_up_timer = function(arg1) -- line 1248
    sleep_for(25000)
    stop_script(ly.charlie_struggle)
    while cutSceneLevel > 0 do
        break_here()
    end
    START_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.charlie_obj:make_touchable()
    box_on("charlie_box")
    box_on("mannys_slot")
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_getup.snm")
    charlie:set_visibility(TRUE)
    ly.slot_handle[4]:set_visibility(FALSE)
    stop_script(ly.meche_idles)
    charlie:push_costume("cc_seduction.cos")
    charlie:play_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche.holding_sheet = TRUE
    sleep_for(2000)
    start_sfx("ccsheet1.wav")
    sleep_for(2500)
    start_sfx("cc_shtof.WAV")
    charlie:say_line("/lycc064/", { volume = 90 })
    wait_for_movie()
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    charlie:wait_for_message()
    charlie:say_line("/lycc065/")
    charlie:wait_for_message()
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    END_CUT_SCENE()
    start_script(ly.charlie_idles, ly)
    start_script(ly.meche_idles, ly)
end
ly.charlies_jackpot = function(arg1) -- line 1310
    local local1
    local local2
    local local3, local4
    stop_script(ly.charlie_get_up_timer)
    stop_script(ly.charlie_idles)
    stop_script(ly.meche_idles)
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    if not find_script(charlies_slot.stop) then
        start_script(charlies_slot.stop, charlies_slot, FALSE)
    end
    ly:add_object_state(ly_chaws, "ly_slot_door.bm", "ly_slot_door.zbm", OBJSTATE_STATE)
    ly.charlie_obj:set_object_state("ly_slot_door.cos")
    ly.charlie_obj.interest_actor:set_visibility(TRUE)
    ly.charlie_obj.interest_actor:put_in_set(ly)
    manny:walkto(0.60399699, -0.122419, 0, 0, 324.94, 0)
    manny:say_line("/lyma082/")
    manny:wait_for_message()
    wait_for_script(ly.unicycle_stop_idles)
    unicycle_man:turn_to_manny()
    local1 = GetActorYawToPoint(manny.hActor, unicycle_man.point["charlie"].pos)
    manny:setrot(0, local1, 0, TRUE)
    manny:point_gesture()
    manny:say_line("/lyma083/")
    manny:wait_for_message()
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point["charlie"].pos, unicycle_man.point["charlie"].rot)
    unicycle_man:say_line("/lyum084/")
    unicycle_man:wait_for_message()
    wait_for_script(unicycle_man.cycle_straight_to)
    unicycle_man:wait_for_actor()
    unicycle_man:setpos(1.90781, -0.36290601, 0)
    unicycle_man:setrot(0, 270, 0)
    ly:current_setup(ly_chaws)
    meche:set_visibility(FALSE)
    unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
    unicycle_man:wait_for_chore(unicycle_man_idles)
    unicycle_man:play_chore(unicycle_man_crawl_slot)
    stop_sound("um_roll.IMU")
    sleep_for(3500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    sleep_for(3300)
    unicycle_man:play_chore(unicycle_man_hide_body)
    unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
    start_script(ly.unicycle_slot_sfx)
    ly.charlie_obj:run_chore(ly_slot_door_close)
    sleep_for(1000)
    charlies_slot:scramble_to_win()
    local3 = Actor:create(nil, nil, nil, "Money")
    local3:set_costume("coin_pile.cos")
    local3:put_in_set(ly)
    local3:setpos(1.99385, -0.48749301, 0.16)
    local3:setrot(0, 0, 0)
    local4 = 0.1
    start_sfx("ly_pyoff.IMU")
    while local4 <= 1 do
        SetActorScale(local3.hActor, local4)
        break_here()
        local4 = local4 + 0.050000001
    end
    fade_sfx("ly_pyoff.IMU", 1000)
    sleep_for(2500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    unicycle_man:play_chore(unicycle_man_out_slot_no_grab)
    sleep_for(500)
    unicycle_man:play_chore(unicycle_man_show_body)
    sleep_for(4000)
    ly.charlie_obj:play_chore(ly_slot_door_close)
    unicycle_man:wait_for_chore(unicycle_man_out_slot_no_grab)
    ly:current_setup(ly_sltha)
    meche:set_visibility(TRUE)
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point[0].pos, unicycle_man.point[0].rot)
    sleep_for(3000)
    stop_script(ly.charlie_struggle)
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    stop_script(unicycle_man.cycle_straight_to)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_win.snm")
    sleep_for(3000)
    start_sfx("cc_shtof.WAV")
    wait_for_movie()
    ly:current_setup(ly_sltha)
    unicycle_man:setpos(unicycle_man.point[0].pos.x, unicycle_man.point[0].pos.y, unicycle_man.point[0].pos.z)
    unicycle_man:setrot(unicycle_man.point[0].rot.x, unicycle_man.point[0].rot.y, unicycle_man.point[0].rot.z)
    unicycle_man:stop_chore(unicycle_man_roll)
    unicycle_man:play_chore_looping(unicycle_man_idles)
    charlie:stop_chore(nil, "cc_play_slot.cos")
    charlie:play_chore(cc_play_slot_hide_handle, "cc_play_slot.cos")
    charlie:push_costume("cc_seduction.cos")
    charlie:setpos(1.49489, -0.50857699, -0.119)
    charlie:setrot(0, 260, 0)
    charlie:set_visibility(TRUE)
    meche:setpos(1.44189, -0.845577, 0)
    meche:setrot(0, 330, 0)
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:stop_chore(nil, "meche_seduction.cos")
    meche:stop_chore(nil, "mi_msb_sheet.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche:set_visibility(TRUE)
    charlie:play_chore(cc_seduction_take_money, "cc_seduction.cos")
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    charlie:say_line("/lycc085/")
    sleep_for(3200)
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    charlie:wait_for_message()
    meche:say_line("/lymc086/")
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    local3:free()
    local3 = nil
    charlie:wait_for_chore(cc_seduction_take_money, "cc_seduction.cos")
    box_on("charlie_box")
    box_on("mannys_slot")
    box_on("meche_box")
    music_state:set_sequence(seqChowchillaBye)
    IrisDown(450, 320, 1000)
    sleep_for(1500)
    ly:current_setup(ly_lavha)
    unicycle_man:free()
    stop_sound("um_roll.IMU")
    manny:setpos(2.22596, 3.59653, 0.89999998)
    manny:setrot(0, 102.462, 0)
    manny:set_collision_mode(COLLISION_OFF)
    meche:set_costume(nil)
    meche:set_costume("meche_ruba.cos")
    meche:set_mumble_chore(meche_ruba_mumble)
    meche:set_talk_chore(1, meche_ruba_stop_talk)
    meche:set_talk_chore(2, meche_ruba_a)
    meche:set_talk_chore(3, meche_ruba_c)
    meche:set_talk_chore(4, meche_ruba_e)
    meche:set_talk_chore(5, meche_ruba_f)
    meche:set_talk_chore(6, meche_ruba_l)
    meche:set_talk_chore(7, meche_ruba_m)
    meche:set_talk_chore(8, meche_ruba_o)
    meche:set_talk_chore(9, meche_ruba_t)
    meche:set_talk_chore(10, meche_ruba_u)
    meche:push_costume("mi_with_cc_toga.cos")
    meche:set_collision_mode(COLLISION_OFF)
    meche:setpos(2.03021, 3.5079, 0.90061998)
    meche:setrot(0, 306.86899, 0)
    meche:play_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    charlie:set_costume(nil)
    charlie:set_costume("cc_toga.cos")
    charlie:set_mumble_chore(cc_toga_mumble)
    charlie:set_talk_chore(1, cc_toga_stop_talk)
    charlie:set_talk_chore(2, cc_toga_a)
    charlie:set_talk_chore(3, cc_toga_c)
    charlie:set_talk_chore(4, cc_toga_e)
    charlie:set_talk_chore(5, cc_toga_f)
    charlie:set_talk_chore(6, cc_toga_l)
    charlie:set_talk_chore(7, cc_toga_m)
    charlie:set_talk_chore(8, cc_toga_o)
    charlie:set_talk_chore(9, cc_toga_t)
    charlie:set_talk_chore(10, cc_toga_u)
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:set_walk_chore(cc_toga_walk)
    charlie:set_walk_rate(0.25)
    charlie:set_head(7, 8, 9, 120, 80, 80)
    charlie:set_look_rate(100)
    ly.mens_room:open()
    charlie:setpos(1.89022, 4.5444798, 0.89999998)
    charlie:setrot(0, 180.181, 0)
    charlie:follow_boxes()
    charlie.footsteps = footsteps.marble
    if not ly.mens_room.has_object_states then
        ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
        ly.mens_room:set_object_state("ly_bath_door.cos")
    end
    IrisUp(125, 325, 1000)
    sleep_for(500)
    manny:head_look_at(nil)
    meche:head_look_at(nil)
    manny:head_forward_gesture()
    manny:say_line("/lyma087/")
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/lyma088/")
    manny:wait_for_message()
    meche:play_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    meche:say_line("/lymc089/")
    meche:wait_for_message()
    meche:wait_for_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    ly.mens_room:play_chore(0)
    start_sfx("ly_batho.WAV")
    manny:head_look_at_point(1.94195, 3.9626, 1.302)
    charlie:walkto(1.95579, 3.78863, 0.89999998)
    sleep_for(500)
    start_script(manny.backup, manny, 1000)
    while charlie:is_moving() do
        if not charlie:find_sector_name("bath_psg") then
            charlie.footsteps = footsteps.rug
        end
        break_here()
    end
    charlie.footsteps = footsteps.rug
    ly.mens_room:play_chore(1)
    start_sfx("ly_bathc.WAV")
    ly.mens_room:close()
    charlie:say_line("/lycc090/", { x = 160, y = 30 })
    meche:stop_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    meche:stop_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    mi_with_cc_done_turning = FALSE
    meche:play_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    sleep_for(1000)
    charlie:head_look_at(meche)
    sleep_for(2400)
    charlie:head_look_at(nil)
    charlie:setrot(0, 100, 0, TRUE)
    charlie:fade_in_chore(cc_toga_take_meche, "cc_toga.cos", 500)
    charlie:wait_for_chore(cc_toga_take_meche, "cc_toga.cos")
    charlie:play_chore(cc_toga_hold_meche, "cc_toga.cos")
    while mi_with_cc_done_turning < 1 do
        break_here()
    end
    while meche:is_choring(mi_with_cc_toga_to_cc_toga, FALSE, "mi_with_cc_toga.cos") do
        WalkActorForward(charlie.hActor)
        break_here()
    end
    meche:wait_for_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    manny:head_look_at(nil)
    END_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.sheet_on_floor:make_untouchable()
    ly.charlie_obj:make_untouchable()
    ly.meche_obj:make_untouchable()
    ly.unicycle_man:make_untouchable()
    ly.charlie_gone = TRUE
    music_state:update()
    cur_puzzle_state[56] = TRUE
    charlie:free()
    meche:free()
end
ly.charlie_idles = function(arg1) -- line 1596
    while system.currentSet == ly do
        ly.ready_to_seduce = FALSE
        charlie:play_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        sleep_for(1000)
        charlies_slot:spin()
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlies_slot:stop(FALSE)
        if find_script(ly.seduce_charlie) then
            ly.ready_to_seduce = TRUE
            while ly.ready_to_seduce do
                break_here()
            end
        end
        break_here()
    end
end
ly.meche_idles = function(arg1) -- line 1614
    local local1 = FALSE
    while system.currentSet == ly do
        if meche.holding_sheet then
            if rnd(8) and not find_script(ly.seduce_charlie) then
                if cutSceneLevel <= 0 then
                    start_script(ly.seduce_charlie, ly)
                    wait_for_script(ly.seduce_charlie)
                end
            end
        elseif rnd(5) then
            if local1 then
                meche:run_chore(meche_ruba_drop_hands, "meche_ruba.cos")
                local1 = FALSE
                sleep_for(rndint(1000, 5000))
            else
                meche:run_chore(meche_ruba_xarms, "meche_ruba.cos")
                local1 = TRUE
                sleep_for(rndint(5000, 10000))
            end
        end
        break_here()
    end
end
ly.seduce_charlie = function(arg1) -- line 1642
    while not ly.ready_to_seduce do
        break_here()
    end
    ly.meche_obj:make_untouchable()
    charlie:set_collision_mode(COLLISION_SPHERE, 0.8)
    meche:play_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    sleep_for(1000)
    charlie:push_costume("cc_seduction.cos")
    charlie:fade_in_chore(cc_seduction_sed_by_mec, "cc_seduction.cos", 500)
    sleep_for(6000)
    ly.meche_obj:make_touchable()
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    ly.ready_to_seduce = FALSE
    meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
end
ly.set_up_actors = function(arg1) -- line 1665
    ly.keno_actor:default()
    ly.slot_handle:init()
    charlies_slot:default()
    mannys_slot:default()
    mannys_slot:freeze()
    brennis:put_in_set(ly)
    brennis:default()
    brennis:push_costume("br_idles.cos")
    brennis:setpos(-0.0427321, 4.02445, 0.9)
    brennis:setrot(0, -2343.65, 0)
    ly:brennis_start_idle()
    if not ly.charlie_gone then
        charlie:set_costume(nil)
        charlie:set_costume("ccharlie.cos")
        charlie:set_mumble_chore(ccharlie_mumble)
        charlie:set_talk_chore(1, ccharlie_no_talk)
        charlie:set_talk_chore(2, ccharlie_a)
        charlie:set_talk_chore(3, ccharlie_c)
        charlie:set_talk_chore(4, ccharlie_e)
        charlie:set_talk_chore(5, ccharlie_f)
        charlie:set_talk_chore(6, ccharlie_l)
        charlie:set_talk_chore(7, ccharlie_m)
        charlie:set_talk_chore(8, ccharlie_o)
        charlie:set_talk_chore(9, ccharlie_t)
        charlie:set_talk_chore(10, ccharlie_u)
        charlie:push_costume("cc_play_slot.cos")
        charlie:put_in_set(ly)
        charlie:ignore_boxes()
        charlie:setpos(1.83869, -0.508564, 0.014)
        charlie:setrot(0, 260, 0)
        start_script(ly.charlie_idles, ly)
        meche:set_costume(nil)
        meche:set_costume("meche_ruba.cos")
        meche:set_mumble_chore(meche_ruba_mumble)
        meche:set_talk_chore(1, meche_ruba_stop_talk)
        meche:set_talk_chore(2, meche_ruba_a)
        meche:set_talk_chore(3, meche_ruba_c)
        meche:set_talk_chore(4, meche_ruba_e)
        meche:set_talk_chore(5, meche_ruba_f)
        meche:set_talk_chore(6, meche_ruba_l)
        meche:set_talk_chore(7, meche_ruba_m)
        meche:set_talk_chore(8, meche_ruba_o)
        meche:set_talk_chore(9, meche_ruba_t)
        meche:set_talk_chore(10, meche_ruba_u)
        meche:put_in_set(ly)
        meche:ignore_boxes()
        meche:setpos(1.4388, -0.679984, 0)
        meche:setrot(0, 313.314, 0)
        meche:push_costume("meche_seduction.cos")
        meche:push_costume("mi_msb_sheet.cos")
        meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
        meche.holding_sheet = TRUE
        start_script(ly.meche_idles, ly)
        unicycle_man:default()
        unicycle_man:put_in_set(ly)
        unicycle_man:restore_pos()
        start_script(ly.unicycle_idles, ly)
    else
        charlie:free()
        meche:free()
        unicycle_man:free()
    end
end
ly.set_up_object_states = function(arg1) -- line 1737
    ly:add_object_state(ly_kenla, "ly_keno_1.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_2.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_3.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_32.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_32.bm", nil, OBJSTATE_UNDERLAY)
end
ly.cameraman = function(arg1) -- line 1804
    local local1, local2
    local local3
    cameraman_watching_set = arg1
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead and cutSceneLevel <= 0 then
        local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
        if cameraman_box_name then
            local3 = getglobal(cameraman_box_name)
            if local3 ~= nil and ly:current_setup() ~= local3 then
                ly:current_setup(local3)
            end
        elseif ly:current_setup() ~= "ly_intha" then
            ly:current_setup(ly_intha)
        end
    end
end
ly.manny_collisions = function(arg1) -- line 1826
    while system.currentSet == ly do
        if manny:find_sector_name("slot_box") or manny:find_sector_name("mannys_slot") or manny:find_sector_name("charlie_box") or manny:find_sector_name("meche_box") then
            manny:set_collision_mode(COLLISION_SPHERE, 0.35)
        else
            manny:set_collision_mode(COLLISION_OFF)
        end
        break_here()
    end
end
ly.update_music_state = function(arg1) -- line 1843
    if ly.charlie_gone then
        return stateLY_BREN
    else
        return stateLY
    end
end
ly.enter = function(arg1) -- line 1852
    ly:set_up_object_states()
    ly:set_up_actors()
    start_script(ly.gun_control)
    start_script(ly.keno_actor.game, ly.keno_actor)
    start_script(ly.manny_collisions, ly)
    ly:add_ambient_sfx({ "lyAmb1.wav", "lyAmb2.wav", "lyAmb3.wav", "lyAmb4.wav" }, { min_volume = 40, max_volume = 127, min_delay = 6000, max_delay = 10000 })
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -4, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
ly.exit = function(arg1) -- line 1872
    stop_script(ly.manny_collisions)
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(slot_wheel.spin)
    stop_script(ly.unicycle_idles)
    stop_script(ly.unicycle_slot_sfx)
    stop_script(ly.keno_actor.game)
    ly.keno_actor:free()
    charlies_slot:free()
    mannys_slot:free()
    stop_script(ly.charlie_idles)
    charlie:free()
    meche:free()
    if brennis.ly_idle_script then
        stop_script(brennis.ly_idle_script)
        brennis.ly_idle_script = nil
    end
    brennis:free()
    unicycle_man:save_pos()
    unicycle_man:free()
    stop_script(ly.gun_control)
    stop_script(ly.charlie_struggle)
    stop_script(ly.charlie_get_up_timer)
    ly.sheet_on_floor.interest_actor:set_costume(nil)
    ly.sheet_on_floor.has_object_states = FALSE
    ly.mens_room.interest_actor:set_costume(nil)
    ly.mens_room.has_object_states = FALSE
    ly.service_door.interest_actor:set_costume(nil)
    ly.service_door.has_object_states = FALSE
    stop_sound("um_roll.IMU")
    stop_sound("ly_pyoff.IMU")
    stop_sound("ly_wheel.IMU")
    KillActorShadows(manny.hActor)
end
ly.sheet = Object:create(ly, "/lytx091/sheet", 0, 0, 0, { range = 0 })
ly.sheet.use = function(arg1) -- line 1928
    manny:say_line("/lyma092/")
end
ly.sheet.lookAt = function(arg1) -- line 1932
    manny:say_line("/lyma093/")
end
ly.sheet.default_response = ly.sheet.use
ly.brennis_obj = Object:create(ly, "/lytx094/elevator demon", -0.048044398, 3.9284, 1.51, { range = 0.80000001 })
ly.brennis_obj.use_pnt_x = -0.12957799
ly.brennis_obj.use_pnt_y = 3.47597
ly.brennis_obj.use_pnt_z = 0.89999998
ly.brennis_obj.use_rot_x = 0
ly.brennis_obj.use_rot_y = 349.754
ly.brennis_obj.use_rot_z = 0
ly.brennis_obj.person = TRUE
ly.brennis_obj.demon = TRUE
ly.brennis_obj.lookAt = function(arg1) -- line 1951
    manny:say_line("/lyma095/")
end
ly.brennis_obj.pickUp = function(arg1) -- line 1955
    system.default_response("right")
end
ly.brennis_obj.use = function(arg1) -- line 1959
    if not manny.fancy then
        if manny:walkto_object(arg1) then
            start_script(ly.talk_clothes_with_brennis)
        end
    elseif fi.gun.owner ~= manny then
        manny:turn_left(180)
        manny:say_line("/lyma096/")
    else
        Dialog:run("br2", "dlg_brennis2.lua")
    end
end
ly.brennis_obj.use_sheet = function(arg1) -- line 1974
    START_CUT_SCENE()
    manny:say_line("/lyma097/")
    wait_for_message()
    brennis:say_line("/lybs098/")
    END_CUT_SCENE()
end
ly.statue = Object:create(ly, "/lytx099/statue", 3.34677, -2.6134701, 2.5899999, { range = 1.6 })
ly.statue.use_pnt_x = 3.34677
ly.statue.use_pnt_y = -1.78347
ly.statue.use_pnt_z = 0.44999999
ly.statue.use_rot_x = 0
ly.statue.use_rot_y = 922.95398
ly.statue.use_rot_z = 0
ly.statue.lookAt = function(arg1) -- line 1992
    manny:say_line("/lyma100/")
end
ly.statue.pickUp = function(arg1) -- line 1996
    system.default_response("right")
end
ly.statue.use = function(arg1) -- line 2000
    manny:say_line("/lyma101/")
end
ly.statue.use_sheet = function(arg1) -- line 2004
    manny:say_line("/lyma102/")
end
ly.charlie_obj = Object:create(ly, "/lytx103/Chowchilla Charlie", 1.82118, -0.51648003, 0.37200001, { range = 0.60000002 })
ly.charlie_obj.use_pnt_x = 1.61446
ly.charlie_obj.use_pnt_y = -0.26686499
ly.charlie_obj.use_pnt_z = 0
ly.charlie_obj.use_rot_x = 0
ly.charlie_obj.use_rot_y = 220.021
ly.charlie_obj.use_rot_z = 0
ly.charlie_obj.person = TRUE
ly.charlie_obj.lookAt = function(arg1) -- line 2019
    if not arg1.seen then
        START_CUT_SCENE()
        arg1.seen = TRUE
        manny:say_line("/lyma104/")
        manny:wait_for_message()
        manny:say_line("/lyma105/")
        END_CUT_SCENE()
    else
        manny:say_line("/lyma106/")
    end
end
ly.charlie_obj.pickUp = function(arg1) -- line 2032
    manny:say_line("/lyma107/")
end
ly.charlie_obj.use = function(arg1) -- line 2036
    start_script(ly.talk_toga_with_charlie)
end
ly.charlie_obj.use_sheet = function(arg1) -- line 2040
    start_script(ly.throw_sheet)
end
ly.meche_obj = Object:create(ly, "/lytx108/Meche", 1.52403, -0.63770503, 0.47499999, { range = 0.80000001 })
ly.meche_obj.use_pnt_x = 1.65277
ly.meche_obj.use_pnt_y = -0.32719201
ly.meche_obj.use_pnt_z = 0
ly.meche_obj.use_rot_x = 0
ly.meche_obj.use_rot_y = 153.737
ly.meche_obj.use_rot_z = 0
ly.meche_obj.person = TRUE
ly.meche_obj.lookAt = function(arg1) -- line 2055
    manny:say_line("/lyma109/")
end
ly.meche_obj.pickUp = function(arg1) -- line 2059
    system.default_response("not now")
end
ly.meche_obj.use = function(arg1) -- line 2063
    start_script(ly.talk_clothes_with_meche)
end
ly.meche_obj.use_sheet = function(arg1) -- line 2067
    if ly.meche_talk_count < 4 then
        arg1:use()
    else
        manny:say_line("/lyma110/")
        manny:wait_for_message()
        meche:say_line("/lymc111/")
    end
end
ly.slot1 = Object:create(ly, "/lytx112/slot machine", 1.98998, -0.113677, 0.47, { range = 0.60000002 })
ly.slot1.use_pnt_x = 1.63983
ly.slot1.use_pnt_y = -0.272295
ly.slot1.use_pnt_z = 0
ly.slot1.use_rot_x = 0
ly.slot1.use_rot_y = 280.24301
ly.slot1.use_rot_z = 0
ly.slot1.lookAt = function(arg1) -- line 2087
    manny:say_line("/lyma113/")
end
ly.slot1.pickUp = function(arg1) -- line 2091
    system.default_response("portable")
end
ly.slot1.use = function(arg1) -- line 2095
    if manny:find_sector_name("mannys_slot") then
        start_script(ly.playslots, ly, arg1)
    elseif manny:walkto_object(arg1) then
        start_script(ly.playslots, ly, arg1)
    end
end
ly.slot1.use_sheet = function(arg1) -- line 2103
    manny:say_line("/lyma114/")
end
ly.sheet_on_floor = Object:create(ly, "/lytx115/sheet", 1.7376, -0.488377, 0, { range = 0.60000002 })
ly.sheet_on_floor.use_pnt_x = 1.5376
ly.sheet_on_floor.use_pnt_y = -0.62837702
ly.sheet_on_floor.use_pnt_z = 0
ly.sheet_on_floor.use_rot_x = 0
ly.sheet_on_floor.use_rot_y = -33.944099
ly.sheet_on_floor.use_rot_z = 0
ly.sheet_on_floor:make_untouchable()
ly.sheet_on_floor.lookAt = function(arg1) -- line 2118
    manny:say_line("/lyma116/")
end
ly.sheet_on_floor.pickUp = function(arg1) -- line 2122
    arg1:make_untouchable()
    ly.sheet:hold()
end
ly.sheet_on_floor.use = ly.sheet_on_floor.pickUp
ly.unicycle_man = Object:create(ly, "/lytx117/gambler", 1.05716, 0.50252402, 0.40000001, { range = 0.80000001 })
ly.unicycle_man.use_pnt_x = 1.2671601
ly.unicycle_man.use_pnt_y = 0.25252399
ly.unicycle_man.use_pnt_z = 0
ly.unicycle_man.use_rot_x = 0
ly.unicycle_man.use_rot_y = 1495.33
ly.unicycle_man.use_rot_z = 0
ly.unicycle_man.person = TRUE
ly.unicycle_man.lookAt = function(arg1) -- line 2140
    if not ly.met_agent then
        manny:say_line("/lyma118/")
    else
        manny:say_line("/lyma119/")
    end
end
ly.unicycle_man.pickUp = function(arg1) -- line 2148
    system.default_response("think")
end
ly.unicycle_man.use = function(arg1) -- line 2152
    start_script(ly.talk_to_agent)
end
ly.mens_room = Object:create(ly, "/lytx120/door", 2.03262, 4.2983999, 1.39, { range = 0.5 })
ly.mens_room.use_pnt_x = 1.9454401
ly.mens_room.use_pnt_y = 3.98
ly.mens_room.use_pnt_z = 0.89999998
ly.mens_room.use_rot_x = 0
ly.mens_room.use_rot_y = 14.326
ly.mens_room.use_rot_z = 0
ly.mens_room.out_pnt_x = 1.76959
ly.mens_room.out_pnt_y = 4.6870298
ly.mens_room.out_pnt_z = 0.89999998
ly.mens_room.out_rot_x = 0
ly.mens_room.out_rot_y = 4.1866498
ly.mens_room.out_rot_z = 0
ly.mens_room.passage = { "bath_psg" }
ly.mens_room.lookAt = function(arg1) -- line 2175
    manny:say_line("/lyma121/")
end
ly.mens_room.walkOut = function(arg1) -- line 2179
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
        manny:wait_for_message()
        ly.sheet:use()
    elseif not manny.fancy then
        if not ly.mens_room.has_object_states then
            ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
            ly.mens_room:set_object_state("ly_bath_door.cos")
        end
        if not ly.charlie_gone then
            if not ly.peed then
                ly.peed = TRUE
                arg1:open_door_and_enter()
                manny:say_line("/lyma122/")
                manny:wait_for_message()
                manny:say_line("/lyma123/")
            else
                manny:say_line("/lyma124/")
            end
        else
            manny.fancy = TRUE
            arg1:open_door_and_enter()
            manny:shrug_gesture()
            manny:say_line("/lyma125/")
        end
    else
        manny:say_line("/lyma126/")
    end
    END_CUT_SCENE()
end
ly.mens_room.open_door_and_enter = function(arg1) -- line 2216
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y, arg1.use_rot_z)
    manny:play_chore(msb_hand_on_obj, manny.base_costume)
    sleep_for(200)
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:open()
    manny:wait_for_chore(msb_hand_on_obj, manny.base_costume)
    manny:stop_chore(msb_hand_on_obj, manny.base_costume)
    manny:play_chore(msb_hand_off_obj, manny.base_costume)
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
    manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    if manny.fancy then
        sleep_for(3000)
        manny:default("thunder")
    else
        sleep_for(4000)
        start_sfx("ly_urinl.WAV")
    end
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:wait_for_chore(0)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    arg1:close()
end
ly.service_door = Object:create(ly, "/lytx120/door", 2.5296299, 4.0496202, 1.339, { range = 0.5 })
ly.service_door.use_pnt_x = 2.5390899
ly.service_door.use_pnt_y = 3.6882501
ly.service_door.use_pnt_z = 0.89999998
ly.service_door.use_rot_x = 0
ly.service_door.use_rot_y = 358.625
ly.service_door.use_rot_z = 0
ly.service_door.out_pnt_x = 2.53511
ly.service_door.out_pnt_y = 4.48
ly.service_door.out_pnt_z = 0.89999998
ly.service_door.out_rot_x = 0
ly.service_door.out_rot_y = 359.58701
ly.service_door.out_rot_z = 0
ly.service_door.touchable = FALSE
ly.service_door.passage = { "service_psg" }
ly.service_door.walkOut = function(arg1) -- line 2271
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y + 180, arg1.use_rot_z)
        manny:wait_for_message()
        ly.sheet:use()
    else
        if not ly.service_door.has_object_states then
            ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
            ly.service_door:set_object_state("ly_service_door.cos")
        end
        manny:walkto(2.56884, 3.85944, 0.9, 0, 16.9137, 0)
        manny:wait_for_actor()
        manny:play_chore(msb_reach_med, manny.base_costume)
        sleep_for(250)
        start_script(manny.backup, manny, 350)
        sleep_for(250)
        arg1:play_chore(0)
        arg1:wait_for_chore(0)
        arg1:open()
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        sleep_for(1000)
        arg1:play_chore(1)
        arg1:close()
    end
    END_CUT_SCENE()
    if manny.is_holding ~= ly.sheet then
        te:come_out_door(te.ly_door)
    end
end
ly.service_door.comeOut = function(arg1) -- line 2304
    START_CUT_SCENE()
    ly:switch_to_set()
    ly:current_setup(ly_lavha)
    if not ly.service_door.has_object_states then
        ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
        ly.service_door:set_object_state("ly_service_door.cos")
    end
    arg1:open()
    manny:put_in_set(ly)
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    if not manny.fancy then
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:play_chore(mcc_thunder_hand_off_obj, "mcc_thunder.cos")
    end
    arg1:play_chore(0)
    arg1:wait_for_chore(0)
    if not manny.fancy then
        manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
        manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:wait_for_chore(mcc_thunder_hand_off_obj, manny.base_costume)
        manny:stop_chore(mcc_thunder_hand_off_obj, manny.base_costume)
    end
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    manny:wait_for_actor()
    arg1:run_chore(1)
    arg1:close()
    END_CUT_SCENE()
end
ly.sh_door = Object:create(ly, "/lytx002/door", -0.098697402, -3.63239, 0.83999997, { range = 0.60000002 })
ly.sh_door.use_pnt_x = -0.098411702
ly.sh_door.use_pnt_y = -3.13359
ly.sh_door.use_pnt_z = 0.44999999
ly.sh_door.use_rot_x = 0
ly.sh_door.use_rot_y = 179.772
ly.sh_door.use_rot_z = 0
ly.sh_door.out_pnt_x = -0.097895198
ly.sh_door.out_pnt_y = -3.425
ly.sh_door.out_pnt_z = 0.44999999
ly.sh_door.out_rot_x = 0
ly.sh_door.out_rot_y = 179.772
ly.sh_door.out_rot_z = 0
ly.sh_door.touchable = FALSE
ly.sh_box = ly.sh_door
ly.sh_door.walkOut = function(arg1) -- line 2364
    START_CUT_SCENE()
    ResetMarioControls()
    manny:say_line("/doma165/")
    manny:walkto(-0.100971, -3.23397, 0.45, 0, 6.21033, 0)
    END_CUT_SCENE()
end

CheckFirstTime("vd.lua")
vd = Set:create("vd.set", "vault door", { vd_top = 0, vd_safex = 1, vd_safex1 = 1, vd_safcu = 2 })
vd.shrinkable = 0.04
vd.wheel_vol = 30
dofile("mn_open_safe.lua")
dofile("mn_scythe_door.lua")
vd.meches_muffled_cries = function() -- line 19
    while 1 do
        meche:say_line(pick_one_of({ "/vdmc001/", "/vdmc002/", "/vdmc003/", "/vdmc004/", "/vdmc005/", "/vdmc006/", "/vdmc007/", "/vdmc008/", "/vdmc009/", "/vdmc010/", "/vdmc011/", "/vdmc012/", "/vdmc013/", "/vdmc014/", "/vdmc015/", "/vdmc016/", "/vdmc017/", "/vdmc018/", "/vdmc019/" }), { background = TRUE, skip_log = TRUE })
        sleep_for(5000)
    end
end
vd.scythe_fall = function() -- line 45
    local local1 = 0
    local local2 = { }
    local local3 = start_script(vd.scythe_sideways)
    start_sfx("scythfal.wav")
    repeat
        local1 = local1 + PerSecond(5)
        if local1 > 90 then
            local1 = 90
        end
        local2 = door_scythe:getrot()
        door_scythe:setrot(local2.x, local2.y, local2.z - local1)
        break_here()
        local2 = door_scythe:getrot()
    until local2.z <= -90
    door_scythe:setrot(local2.x, local2.y, -90)
    wait_for_script(local3)
end
vd.scythe_sideways = function() -- line 65
    local local1 = { }
    local local2 = 0.0099999998
    repeat
        local1 = door_scythe:getpos()
        local2 = local2 + PerSecond(0.0049999999)
        door_scythe:setpos(local1.x + local2, local1.y, local1.z)
        break_here()
    until local1.x >= 0.223141
    door_scythe:setpos(0.223141, local1.y, local1.z)
end
vd.open_safe = function() -- line 77
    local local1
    cur_puzzle_state[39] = TRUE
    START_CUT_SCENE()
    manny:play_chore(ms_hand_on_obj, manny.base_costume)
    manny:wait_for_chore()
    vd.handle:play_chore(2)
    manny:play_chore(ms_hand_off_obj, manny.base_costume)
    vd.handle:wait_for_chore()
    vd.handle:play_chore(0)
    vd.door_jam:play_chore(1)
    vd.safe_door:free()
    StartMovie("vd.snm", nil, 233, 119)
    local1 = start_script(vd.scythe_fall)
    wait_for_movie()
    music_state:set_sequence(seqOpenVault)
    vd.door_jam:play_chore(2)
    vd.door_open = TRUE
    music_state:update()
    wait_for_script(local1)
    manny:walkto(-0.105456, 0.34172001, 0, 0, -11.4314, 0)
    manny:play_chore(50, manny.base_costume)
    mn2_event = FALSE
    repeat
        break_here()
    until mn2_event
    door_scythe:free()
    mo.scythe:get()
    MakeSectorActive("scythe_here", TRUE)
    vd.tumblers.secured = FALSE
    manny:wait_for_chore()
    manny.is_holding = mo.scythe
    open_inventory(TRUE, TRUE)
    vd.tumblers.name = "tumblers"
    vd.tumblers:make_untouchable()
    vd.wheel:make_untouchable()
    vd.handle:make_untouchable()
    vd.vo_door:make_touchable()
    MakeSectorActive("safe_passage", TRUE)
    if not vd.cracked_safe then
        vd.cracked_safe = TRUE
        wait_for_message()
        manny:say_line("/vdma020/")
        wait_for_message()
        manny:say_line("/vdma021/")
        wait_for_message()
        sleep_for(750)
        manny:say_line("/vdma022/")
        manny:tilt_head_gesture()
    end
    END_CUT_SCENE()
end
system.tumblerTemplate = { name = "<unnamed>", actor = nil, pos = nil, rot = nil, lock = nil, lock_val = nil, lock_pin = nil }
Tumbler = system.tumblerTemplate
Tumbler.create = function(arg1, arg2, arg3) -- line 148
    local local1 = { }
    local1.parent = Tumbler
    local1.name = arg2
    local1.actor = Actor:create(nil, nil, nil, arg2)
    local1.rot = rndint(0, 359)
    local1.lock_val = local1.rot
    local1.pos = arg3
    local1.lock = FALSE
    local1.lock_pin = rndint(0, 359)
    return local1
end
Tumbler.set_up_actor = function(arg1) -- line 164
    arg1.actor:set_costume("tumbler.cos")
    arg1.actor:play_chore_looping(0)
    arg1.actor:put_in_set(vd)
    arg1.actor:setrot(0, arg1.rot, 0)
    arg1.actor:set_softimage_pos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    arg1:reset_lock_value()
    start_script(arg1.monitor_rot, arg1)
    start_script(arg1.make_noise, arg1)
end
Tumbler.monitor_rot = function(arg1) -- line 175
    while 1 do
        arg1.actor:setrot(0, arg1.rot, 0)
        break_here()
    end
end
Tumbler.make_noise = function(arg1) -- line 182
    local local1 = { }
    local local2, local3
    while 1 do
        local1 = arg1.actor:getrot()
        if abs(arg1.rot - local1.y) > 15 then
            if vd:current_setup() == vd_safcu then
                local3 = rndint(50, 80)
            else
                local3 = rndint(10, 40)
            end
            local2 = pick_one_of({ "vdTmbl1.wav", "vdTmbl2.wav", "vdTmbl3.wav", "vdTmbl4.wav" })
            start_sfx(local2, IM_LOW_PRIORITY, local3)
            wait_for_sound(local2)
        else
            break_here()
        end
    end
end
Tumbler.reset_lock_value = function(arg1) -- line 204
    local local1 = arg1.actor:get_positive_rot()
    arg1.lock = FALSE
    arg1.lock_val = local1.y + arg1.lock_pin
    if arg1.lock_val >= 360 then
        arg1.lock_val = arg1.lock_val - 360
    end
end
Tumbler.scramble = function(arg1, arg2) -- line 217
    local local1 = 100
    local local2 = rnd()
    local local3 = { }
    repeat
        if local2 then
            arg1.rot = arg1.rot - local1
        else
            arg1.rot = arg1.rot + local1
        end
        local1 = local1 - PerSecond(15)
        break_here()
    until local1 <= 0
    local3 = arg1.actor:get_positive_rot()
    arg1.rot = floor(local3.y)
    arg1:reset_lock_value()
    if arg2 then
        arg1.lock = TRUE
    end
end
Tumbler.free = function(arg1) -- line 238
    arg1.actor:free()
    stop_script(arg1.monitor_rot)
    stop_script(arg1.make_noise)
end
system.safeTemplate = { name = "<unnamed>", tumblers = nil, wheel = nil, current_setting = nil, direction = nil }
Safe = system.safeTemplate
Safe.create = function(arg1, arg2) -- line 252
    local local1 = { }
    local1.parent = Safe
    local1.name = arg2
    local1.tumblers = { }
    local1.wheel = { }
    local1.current_setting = 0
    local1.direction = CLOCKWISE
    local1.tumblers[1] = Tumbler:create("t1", { x = 1.1426001, y = 3.0685, z = -6.4158001 })
    local1.tumblers[2] = Tumbler:create("t2", { x = 1.1426001, y = 3.2776999, z = -6.4158001 })
    local1.tumblers[3] = Tumbler:create("t3", { x = 1.1426001, y = 3.4872999, z = -6.4158001 })
    local1.tumblers[4] = Tumbler:create("t4", { x = 1.1426001, y = 3.7004001, z = -6.4158001 })
    local1.wheel = Actor:create(nil, nil, nil, "wheel")
    return local1
end
Safe.set_up_actors = function(arg1) -- line 274
    arg1.tumblers[1]:set_up_actor()
    arg1.tumblers[2]:set_up_actor()
    arg1.tumblers[3]:set_up_actor()
    arg1.tumblers[4]:set_up_actor()
    if meche.locked_up or cur_puzzle_state[41] == TRUE then
        arg1.wheel:set_costume("vault_wheel.cos")
        arg1.wheel:put_in_set(vd)
        arg1.wheel:set_softimage_pos(-0.6378, 3.4855, -6.3778)
        arg1.wheel:setrot(0, 180, 0)
    end
    arg1.tumblers[1].lock = TRUE
    start_script(arg1.monitor_lock, arg1)
    start_script(arg1.monitor_tumblers, arg1)
end
CLOCKWISE = 0
C_CLOCKWISE = 1
Safe.monitor_lock = function(arg1) -- line 298
    arg1.direction = CLOCKWISE
    while 1 do
        while arg1.direction == CLOCKWISE do
            break_here()
        end
        arg1.tumblers[2]:reset_lock_value()
        arg1.tumblers[3]:reset_lock_value()
        arg1.tumblers[4]:reset_lock_value()
        while arg1.direction == C_CLOCKWISE do
            break_here()
        end
        arg1.tumblers[2]:reset_lock_value()
        arg1.tumblers[3]:reset_lock_value()
        arg1.tumblers[4]:reset_lock_value()
    end
end
Safe.monitor_tumblers = function(arg1) -- line 320
    while 1 do
        if arg1.tumblers[1].rot >= 248 and arg1.tumblers[1].rot <= 290 and (arg1.tumblers[2].rot >= 248 and arg1.tumblers[2].rot <= 290) and (arg1.tumblers[3].rot >= 248 and arg1.tumblers[3].rot <= 290) and (arg1.tumblers[4].rot >= 248 and arg1.tumblers[4].rot <= 290) then
            vd.tumblers.alligned = TRUE
        else
            vd.tumblers.alligned = FALSE
        end
        break_here()
    end
end
Safe.scramble = function(arg1) -- line 335
    start_script(arg1.tumblers[1].scramble, arg1.tumblers[1], TRUE)
    start_script(arg1.tumblers[2].scramble, arg1.tumblers[2])
    start_script(arg1.tumblers[3].scramble, arg1.tumblers[3])
    arg1.tumblers[4]:scramble()
end
Safe.spin_tumblers_right = function(arg1) -- line 342
    if not find_script(arg1.scramble) then
        if arg1.tumblers[1].lock then
            arg1.tumblers[1].rot = arg1.tumblers[1].rot + 1
            if arg1.tumblers[1].rot == 360 then
                arg1.tumblers[1].rot = 0
            end
            if arg1.tumblers[1].rot == arg1.tumblers[2].lock_val and arg1.tumblers[2].lock == FALSE then
                arg1.tumblers[2].lock = TRUE
            end
        end
        if arg1.tumblers[2].lock then
            arg1.tumblers[2].rot = arg1.tumblers[2].rot + 1
            if arg1.tumblers[2].rot == 360 then
                arg1.tumblers[2].rot = 0
            end
            if arg1.tumblers[2].rot == arg1.tumblers[3].lock_val and arg1.tumblers[3].lock == FALSE then
                arg1.tumblers[3].lock = TRUE
            end
        end
        if arg1.tumblers[3].lock then
            arg1.tumblers[3].rot = arg1.tumblers[3].rot + 1
            if arg1.tumblers[3].rot == 360 then
                arg1.tumblers[3].rot = 0
            end
            if arg1.tumblers[3].rot == arg1.tumblers[4].lock_val and arg1.tumblers[4].lock == FALSE then
                arg1.tumblers[4].lock = TRUE
            end
        end
        if arg1.tumblers[4].lock then
            arg1.tumblers[4].rot = arg1.tumblers[4].rot + 1
            if arg1.tumblers[4].rot == 360 then
                arg1.tumblers[4].rot = 0
            end
        end
    end
end
Safe.spin_tumblers_left = function(arg1) -- line 386
    if not find_script(arg1.scramble) then
        if arg1.tumblers[1].lock then
            arg1.tumblers[1].rot = arg1.tumblers[1].rot - 1
            if arg1.tumblers[1].rot == -1 then
                arg1.tumblers[1].rot = 359
            end
            if arg1.tumblers[1].rot == arg1.tumblers[2].lock_val and arg1.tumblers[2].lock == FALSE then
                arg1.tumblers[2].lock = TRUE
            end
        end
        if arg1.tumblers[2].lock then
            arg1.tumblers[2].rot = arg1.tumblers[2].rot - 1
            if arg1.tumblers[2].rot == -1 then
                arg1.tumblers[2].rot = 359
            end
            if arg1.tumblers[2].rot == arg1.tumblers[3].lock_val and arg1.tumblers[3].lock == FALSE then
                arg1.tumblers[3].lock = TRUE
            end
        end
        if arg1.tumblers[3].lock then
            arg1.tumblers[3].rot = arg1.tumblers[3].rot - 1
            if arg1.tumblers[3].rot == -1 then
                arg1.tumblers[3].rot = 359
            end
            if arg1.tumblers[3].rot == arg1.tumblers[4].lock_val and arg1.tumblers[4].lock == FALSE then
                arg1.tumblers[4].lock = TRUE
            end
        end
        if arg1.tumblers[4].lock then
            arg1.tumblers[4].rot = arg1.tumblers[4].rot - 1
            if arg1.tumblers[4].rot == -1 then
                arg1.tumblers[4].rot = 359
            end
        end
    end
end
vd.play_wheel_sfx = function() -- line 430
    if not sound_playing("vdWeel1.wav") or sound_playing("vdWeel2.wav") or sound_playing("vdWeel3.wav") or sound_playing("vdWeel4.wav") then
        sfx = pick_from_nonweighted_table({ "vdWeel1.wav", "vdWeel2.wav", "vdWeel3.wav", "vdWeel4.wav" })
        start_sfx(pick_one_of({ "vdWeel1.wav", "vdWeel2.wav", "vdWeel3.wav", "vdWeel4.wav" }), IM_MED_PRIORITY, vd.wheel_vol)
    end
end
Safe.spin_left = function(arg1, arg2) -- line 439
    local local1
    arg1.direction = C_CLOCKWISE
    vd.play_wheel_sfx()
    arg1.current_setting = arg1.current_setting + arg2
    if arg1.current_setting >= 360 then
        arg1.current_setting = arg1.current_setting - 360
    end
    arg1.wheel:setrot(0, 180, arg1.current_setting)
end
Safe.spin_right = function(arg1, arg2) -- line 450
    local local1
    arg1.direction = CLOCKWISE
    vd.play_wheel_sfx()
    arg1.current_setting = arg1.current_setting - arg2
    if arg1.current_setting <= 0 then
        arg1.current_setting = arg1.current_setting + 360
    end
    arg1.wheel:setrot(0, 180, arg1.current_setting)
end
Safe.free = function(arg1) -- line 463
    arg1.tumblers[1]:free()
    arg1.tumblers[2]:free()
    arg1.tumblers[3]:free()
    arg1.tumblers[4]:free()
    arg1.wheel:free()
    stop_script(arg1.monitor_lock)
    stop_script(arg1.monitor_tumblers)
end
vd.hide_actors = function() -- line 476
    vd.safe_door.tumblers[1].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[2].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[3].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[4].actor:set_visibility(FALSE)
    while not vd.door_busted do
        if vd.cameraChange then
            if vd:current_setup() == vd_safex then
                vd.safe_door.tumblers[1].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[2].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[3].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[4].actor:set_visibility(FALSE)
            else
                vd.safe_door.tumblers[1].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[2].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[3].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[4].actor:set_visibility(TRUE)
            end
        end
        break_here()
    end
    vd.safe_door.tumblers[1].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[2].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[3].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[4].actor:set_visibility(TRUE)
end
vd.safe_fun = function() -- line 503
    START_CUT_SCENE()
    if vd.door_busted then
        vd:current_setup(vd_safcu)
        manny:walkto(-0.0345833, 0.276218, 0, 0, 10.5, 0)
        manny:wait_for_actor()
        manny:set_rest_chore(-1)
        manny:play_chore(18, manny.base_costume)
        manny:wait_for_chore()
    else
        manny:walkto(0.00651957, 0.218281, 0, 0, 0, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_open_safe.cos")
        manny:play_chore(mn_open_safe_hand_on_wheel)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = vd.buttonHandler
    END_CUT_SCENE()
end
vd.turn_clockwise = function() -- line 526
    local local1 = 5
    local local2 = 0
    START_CUT_SCENE()
    if vd.door_busted then
        manny:play_chore_looping(49, manny.base_costume)
        while get_generic_control_state("TURN_RIGHT") do
            vd.safe_door:spin_right(local1)
            local2 = 0
            repeat
                vd.safe_door:spin_tumblers_right()
                local2 = local2 + 1
            until local2 == local1
            local1 = local1 + 3
            if local1 >= 20 then
                local1 = 20
            end
            vd.play_wheel_sfx()
            break_here()
        end
        manny:set_chore_looping(49, FALSE, manny.base_costume)
        manny:wait_for_chore(49, manny.base_costume)
    else
        manny:play_chore(mn_open_safe_turn_right)
        start_script(vd.safe_door.spin_right, vd.safe_door, 45)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    END_CUT_SCENE()
end
vd.turn_counterclockwise = function() -- line 561
    local local1 = 5
    local local2
    START_CUT_SCENE()
    if vd.door_busted then
        manny:play_chore_looping(49, manny.base_costume)
        while get_generic_control_state("TURN_LEFT") do
            vd.safe_door:spin_left(local1)
            local2 = 0
            repeat
                vd.safe_door:spin_tumblers_left()
                local2 = local2 + 1
            until local2 == local1
            local1 = local1 + 3
            if local1 >= 20 then
                local1 = 20
            end
            vd.play_wheel_sfx()
            break_here()
        end
        manny:set_chore_looping(49, FALSE, manny.base_costume)
        manny:wait_for_chore(49, manny.base_costume)
    else
        manny:play_chore(mn_open_safe_turn_left)
        start_script(vd.safe_door.spin_right, vd.safe_door, 45)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    END_CUT_SCENE()
end
vd.back_off = function() -- line 596
    START_CUT_SCENE()
    if vd.door_busted then
        vd:current_setup(vd_safex)
        manny:stop_chore(mn2_use, manny.base_costume)
        manny:stop_chore(mn2_hand_on_obj, manny.base_costume)
        manny:play_chore(mn2_hand_off_obj, manny.base_costume)
        manny:wait_for_chore()
        manny:stop_chore(mn2_hand_off_obj, manny.base_costume)
        manny:set_rest_chore(ms_rest, "mn2.cos")
    else
        manny:play_chore(mn_open_safe_done_turn)
        manny:wait_for_chore()
        manny:pop_costume()
    end
    END_CUT_SCENE()
    system.buttonHandler = inventory_save_handler
end
vd.buttonHandler = function(arg1, arg2, arg3) -- line 616
    if arg1 == EKEY and controlKeyDown and arg2 then
        start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.TURN_RIGHT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.turn_clockwise)
    elseif control_map.TURN_LEFT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.turn_counterclockwise)
    elseif control_map.OVERRIDE[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.back_off)
    elseif control_map.MOVE_BACKWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.back_off)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
vd.update_music_state = function(arg1) -- line 638
    if meche.locked_up and not vd.door_open then
        return stateVD
    else
        return stateFH
    end
end
vd.enter = function(arg1) -- line 648
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_1_lock.bm")
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_handle.bm")
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_safe_open.bm")
    vd.door_jam:set_object_state("vd_jam.cos")
    vd.handle:set_object_state("vd_handle.cos")
    if not vd.door_open then
        if vd.door_busted then
            vd.door_jam:play_chore(0)
        else
            vd.door_jam:play_chore(1)
        end
        vd.handle:play_chore(0)
        if not vd.safe_door then
            vd.safe_door = Safe:create("safe")
        end
        vd.safe_door:set_up_actors()
        start_script(vd.hide_actors)
    else
        vd.door_jam:play_chore(2)
        vd.handle:play_chore(0)
    end
    MakeSectorActive("safe_passage", FALSE)
    if meche.locked_up and not meche_freed then
        vd.heard_meche = TRUE
        if vd.door_open then
            vd.wheel:make_untouchable()
            vd.handle:make_untouchable()
            vd.door_jam:make_untouchable()
            MakeSectorActive("safe_passage", TRUE)
        elseif vd.door_busted then
            vd.wheel:make_touchable()
            vd.handle:make_touchable()
            vd.door_jam:make_untouchable()
            vd.tumblers:make_touchable()
        else
            start_script(vd.meches_muffled_cries)
            vd.wheel:make_touchable()
            vd.handle:make_touchable()
            vd.door_jam:make_touchable()
        end
    elseif cur_puzzle_state[41] == TRUE then
        vd.wheel:make_touchable()
        vd.handle:make_touchable()
        vd.door_jam:make_untouchable()
        vd.tumblers:make_touchable()
    else
        MakeSectorActive("vd_safcu", FALSE)
        vd.wheel:make_untouchable()
        vd.handle:make_untouchable()
        vd.handle:make_untouchable()
        NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_1_wall.bm")
        vd.handle:set_object_state("vd_wall.cos")
        vd.handle:play_chore(0)
    end
    if vd.tumblers.secured then
        MakeSectorActive("scythe_here", FALSE)
        door_scythe:set_costume("scythe_scythe_door.cos")
        door_scythe:put_in_set(vd)
        door_scythe:setpos(0.0055, 0.33717, 0)
        door_scythe:setrot(0, -6.211, 0)
        door_scythe:play_chore_looping(0)
    end
end
vd.exit = function(arg1) -- line 721
    vd.safe_door:free()
    if door_scythe then
        door_scythe:free()
    end
    stop_script(vd.hide_actors)
    stop_script(vd.meches_muffled_cries)
end
vd.wheel = Object:create(vd, "/vdtx023/wheel", -0.071915798, 0.65689498, 0.34, { range = 0.60000002 })
vd.wheel.use_pnt_x = -0.092005402
vd.wheel.use_pnt_y = 0.44999999
vd.wheel.use_pnt_z = 0
vd.wheel.use_rot_x = 0
vd.wheel.use_rot_y = 8.8126001
vd.wheel.use_rot_z = 0
vd.wheel:make_untouchable()
vd.wheel.lookAt = function(arg1) -- line 745
    soft_script()
    manny:say_line("/vdma024/")
    manny:wait_for_message()
    manny:say_line("/vdma025/")
end
vd.wheel.use = function(arg1) -- line 752
    vd.wheel.tried = TRUE
    if meche_freed then
        system.default_response("not now")
    elseif vd.door_busted then
        if vd.tumblers.alligned then
            if vd.tumblers.secured then
                manny:walkto(0.00651957, 0.218281, 0, 0, 0, 0)
                manny:wait_for_actor()
                manny:push_costume("mn_open_safe.cos")
                manny:play_chore(mn_open_safe_hand_on_wheel)
                manny:wait_for_chore()
                manny:play_chore(mn_open_safe_hold_wheel)
                manny:say_line("/vdma026/")
                wait_for_message()
                manny:play_chore(mn_open_safe_done_turn)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:say_line("/vdma027/")
            else
                start_script(vd.safe_fun)
            end
        else
            start_script(vd.safe_fun)
        end
    else
        start_script(vd.safe_fun)
    end
end
vd.wheel.pickUp = vd.wheel.use
vd.wheel.use_chisel = function(arg1) -- line 784
    manny:say_line("/vdma028/")
end
vd.handle = Object:create(vd, "/vdtx029/handle", -0.320117, 0.57889301, 0.38, { range = 0.60000002 })
vd.handle.use_pnt_x = -0.125559
vd.handle.use_pnt_y = 0.33589101
vd.handle.use_pnt_z = 0
vd.handle.use_rot_x = 0
vd.handle.use_rot_y = 416.95801
vd.handle.use_rot_z = 0
vd.handle:make_untouchable()
vd.handle.lookAt = function(arg1) -- line 800
    manny:say_line("/vdma030/")
end
vd.handle.pickUp = function(arg1) -- line 804
    system.default_response("attached")
end
vd.handle.use = function(arg1) -- line 808
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:set_rest_chore(-1)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        if vd.tumblers.alligned then
            if vd.tumblers.secured then
                vd.open_safe()
            else
                manny:play_chore(ms_hand_on_obj, manny.base_costume)
                manny:wait_for_chore()
                arg1:play_chore(1)
                start_script(vd.safe_door.scramble, vd.safe_door)
                manny:play_chore(ms_hand_off_obj, manny.base_costume)
                manny:wait_for_chore()
                manny:say_line("/vdma031/")
                wait_for_message()
                manny:say_line("/vdma032/")
            end
        else
            manny:play_chore(ms_hand_on_obj, manny.base_costume)
            manny:wait_for_chore()
            arg1:play_chore(1)
            if not vd.tumblers_secured then
                start_script(vd.safe_door.scramble, vd.safe_door)
            end
            manny:play_chore(ms_hand_off_obj, manny.base_costume)
            manny:wait_for_chore()
            if vd.wheel.tried then
                manny:say_line("/vdma033/")
            else
                vd.wheel.tried = TRUE
                vd.wheel:lookAt()
            end
        end
        manny:set_rest_chore(ms_rest, manny.base_costume)
        END_CUT_SCENE()
    end
end
vd.handle.use_chisel = function(arg1) -- line 851
    manny:say_line("/vdma034/")
end
vd.door_jam = Object:create(vd, "/vdtx035/door jam", 0.127995, 0.63, 0.34999999, { range = 0.60000002 })
vd.door_jam.use_pnt_x = 0.057923201
vd.door_jam.use_pnt_y = 0.449918
vd.door_jam.use_pnt_z = 0
vd.door_jam.use_rot_x = 0
vd.door_jam.use_rot_y = -12.8311
vd.door_jam.use_rot_z = 0
vd.door_jam:make_untouchable()
vd.door_jam.lookAt = function(arg1) -- line 867
    soft_script()
    manny:say_line("/vdma036/")
    wait_for_message()
    manny:say_line("/vdma037/")
end
vd.door_jam.use = vd.door_jam.lookAt
vd.door_jam.use_scythe = function(arg1) -- line 876
    soft_script()
    manny:say_line("/vdma038/")
end
vd.door_jam.use_hammer = function(arg1) -- line 881
    manny:say_line("/vdma039/")
end
vd.door_jam.use_chisel = function(arg1) -- line 885
    START_CUT_SCENE()
    vd.door_jam:make_untouchable()
    vd.tumblers:make_touchable()
    manny:walkto(-0.0135804, 0.218281, 0, 0, 0, 0)
    manny:wait_for_actor()
    manny:push_costume("mn_open_safe.cos")
    manny:play_chore(mn_open_safe_drill_prep)
    manny:wait_for_chore()
    manny:stop_chore(mn_open_safe_drill_prep)
    manny:play_chore(mn_open_safe_drill)
    sleep_for(3000)
    StartMovie("safecrak.snm", nil, 152, 0)
    sleep_for(600)
    manny:say_line("/vdma040/")
    manny:stop_chore(mn_open_safe_drill)
    manny:play_chore(mn_open_safe_drill_done)
    wait_for_movie()
    arg1:play_chore(0)
    vd.door_busted = TRUE
    manny:wait_for_chore()
    manny:pop_costume()
    wait_for_message()
    manny:say_line("/vdma041/")
    wait_for_message()
    manny:say_line("/vdma042/")
    END_CUT_SCENE()
    stop_script(vd.meches_muffled_cries)
end
vd.tumblers = Object:create(vd, "/vdtx043/tumblers", 0.127995, 0.63, 0.34999999, { range = 0.60000002 })
vd.tumblers.use_pnt_x = 0.057923201
vd.tumblers.use_pnt_y = 0.449918
vd.tumblers.use_pnt_z = 0
vd.tumblers.use_rot_x = 0
vd.tumblers.use_rot_y = -12.8311
vd.tumblers.use_rot_z = 0
vd.tumblers:make_untouchable()
vd.tumblers.lookAt = function(arg1) -- line 927
    if vd.tumblers.alligned then
        if vd.tumblers.secured then
            manny:say_line("/vdma044/")
        else
            manny:say_line("/vdma045/")
        end
    else
        manny:say_line("/vdma046/")
    end
end
vd.tumblers.use_chisel = function(arg1) -- line 939
    if vd.tumblers.secured or vd.door_open then
        system.default_response("not now")
    elseif meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:walkto(-0.0135804, 0.218281, 0, 0, 0, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_open_safe.cos")
        manny:play_chore(mn_open_safe_drill_prep)
        manny:wait_for_chore()
        manny:stop_chore(mn_open_safe_drill_prep)
        manny:play_chore(mn_open_safe_drill)
        sleep_for(500)
        start_script(vd.safe_door.scramble, vd.safe_door)
        sleep_for(3100)
        manny:stop_chore(mn_open_safe_drill)
        manny:play_chore(mn_open_safe_drill_done)
        manny:wait_for_chore()
        manny:pop_costume()
        manny:say_line("/vdma047/")
        END_CUT_SCENE()
    end
end
vd.tumblers.use = function(arg1) -- line 967
    if arg1.secured then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        manny:say_line("/vdma048/")
        wait_for_message()
        END_CUT_SCENE()
        start_script(Sentence, "use", vd_wheel)
    end
end
vd.tumblers.pickUp = function(arg1) -- line 979
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        if vd.tumblers.secured then
            manny:walkto(0.0055, 0.33717, 0, 0, -6.211, 0)
            manny:wait_for_actor()
            manny:push_costume("mn_scythe_door.cos")
            door_scythe:free()
            manny:play_chore(mn_scythe_door_scythe_out_door)
            manny:wait_for_chore()
            mo.scythe:get()
            manny.is_holding = mo.scythe
            manny.hold_chore = ms_hold_scythe
            manny:play_chore_looping(mn2_hold_scythe, manny.base_costume)
            vd.tumblers.secured = FALSE
            arg1.name = "tumblers"
            manny:pop_costume()
            MakeSectorActive("scythe_here", TRUE)
        else
            manny:say_line("/vdma049/")
        end
        END_CUT_SCENE()
    end
end
vd.tumblers.use_scythe = function(arg1) -- line 1006
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:walkto(0.0055, 0.33717, 0, 0, -6.211, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_scythe_door.cos")
        manny:play_chore(mn_scythe_door_scythe_in_door)
        manny:wait_for_chore()
        if vd.tumblers.alligned then
            mo.scythe:free()
            manny.is_holding = nil
            manny:stop_chore(manny.hold_chore, manny.base_costume)
            manny.hold_chore = nil
            vd.tumblers.secured = TRUE
            arg1.name = "scythe in tumblers"
            if not door_scythe then
                door_scythe = Actor:create(nil, nil, nil, "door scythe")
            end
            door_scythe:set_costume("scythe_scythe_door.cos")
            door_scythe:put_in_set(vd)
            door_scythe:setpos(0.0055, 0.33717, 0)
            door_scythe:setrot(0, -6.211, 0)
            door_scythe:play_chore_looping(0)
            manny:say_line("/vdma050/")
            manny:pop_costume()
            MakeSectorActive("scythe_here", FALSE)
        else
            manny:play_chore(mn_scythe_door_scythe_out_door)
            manny:wait_for_chore()
            manny:pop_costume()
            mo.scythe.owner = manny
            manny.is_holding = mo.scythe
            manny.hold_chore = ms_activate_scythe
            manny:play_chore_looping(manny.hold_chore, manny.base_costume)
            manny:say_line("/vdma051/")
        end
        END_CUT_SCENE()
    end
end
vd.fh_door = Object:create(vd, "door", -0.186533, -0.231243, 0.44999999, { range = 0.60000002 })
vd.fh_door.use_pnt_x = -0.186533
vd.fh_door.use_pnt_y = -0.231243
vd.fh_door.use_pnt_z = 0
vd.fh_door.use_rot_x = 0
vd.fh_door.use_rot_y = -170.83299
vd.fh_door.use_rot_z = 0
vd.fh_door.out_pnt_x = -0.186533
vd.fh_door.out_pnt_y = -0.231243
vd.fh_door.out_pnt_z = 0
vd.fh_door.out_rot_x = 0
vd.fh_door.out_rot_y = -170.83299
vd.fh_door.out_rot_z = 0
vd.fh_box = vd.fh_door
vd.fh_door.touchable = FALSE
vd.fh_door.walkOut = function(arg1) -- line 1070
    fh:come_out_door(fh.vd_door)
end
vd.vo_door = Object:create(vd, "door", -0.0449185, 0.82523298, 0.49399999, { range = 0.60000002 })
vd.vo_door.use_pnt_x = -0.0449185
vd.vo_door.use_pnt_y = 0.474233
vd.vo_door.use_pnt_z = 0
vd.vo_door.use_rot_x = 0
vd.vo_door.use_rot_y = -5035.4102
vd.vo_door.use_rot_z = 0
vd.vo_door.out_pnt_x = -0.112959
vd.vo_door.out_pnt_y = 0.64996803
vd.vo_door.out_pnt_z = 0
vd.vo_door.out_rot_x = 0
vd.vo_door.out_rot_y = -356.367
vd.vo_door.out_rot_z = 0
vd.vo_door:make_untouchable()
vd.vo_door.walkOut = function(arg1) -- line 1096
    vo:come_out_door(vo.vd_door)
end
vd.vo_door.lookAt = function(arg1) -- line 1100
    manny:say_line("/vdma053/")
end
vd.ar_door = Object:create(vd, "door", 0.50083399, 2.45, 0, { range = 0.60000002 })
vd.ar_door.use_pnt_x = 0.47602099
vd.ar_door.use_pnt_y = 2.0909801
vd.ar_door.use_pnt_z = 0
vd.ar_door.use_rot_x = 0
vd.ar_door.use_rot_y = 185.078
vd.ar_door.use_rot_z = 0
vd.ar_door.out_pnt_x = 0.50083399
vd.ar_door.out_pnt_y = 2.45
vd.ar_door.out_pnt_z = 0
vd.ar_door.out_rot_x = 0
vd.ar_door.out_rot_y = -373.83701
vd.ar_door.out_rot_z = 0
vd.ar_box = vd.ar_door
vd.ar_door.comeOut = function(arg1) -- line 1121
    vd:current_setup(vd_safex)
    Object.come_out_door(arg1)
end
vd.ar_door.walkOut = function(arg1) -- line 1126
    ar:come_out_door(ar.vd_door)
end
vd.ar_door.lookAt = function(arg1) -- line 1130
    if dr.reunited then
        manny:say_line("/vdma054/")
    else
        manny:say_line("/vdma055/")
    end
end

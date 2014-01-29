CheckFirstTime("le.lua")
le = Set:create("le.set", "Ledge", { le_alloh = 0, le_rufla = 1, le_ladws = 2, le_overhd = 3 })
le.camera_adjusts = { 20, 10, 25 }
dofile("ma_ladder_generic.lua")
dofile("ma_rope.lua")
dofile("manny_scales_rope.lua")
dofile("ledge_rope.lua")
dofile("ma_enter_office.lua")
rope_looker = Actor:create()
le.NUMBER_OF_PIGEONS = 5
MANNY_TOLERANCE = 0.5
MANNY_LANDING_TOLERANCE = 1
le.pigeons_obj = { }
le.choose_start_pnts = function() -- line 33
    local local1
    repeat
        local1 = pick_from_nonweighted_table(le.pigeon_homes)
    until not local1.used
    local1.used = TRUE
    return local1.pos.x, local1.pos.y, local1.pos.z, local1.face
end
le.init_pigeons = function() -- line 43
    local local1 = 0
    local local2, local3, local4, local5
    repeat
        local1 = local1 + 1
        if not pigeons[local1] then
            pigeons[local1] = Actor:create(nil, nil, nil, "pigeon" .. local1)
        end
        pigeons[local1].start_pnt = { }
        pigeons[local1].orbit_pnt = { }
        pigeons.fly_direction = nil
        pigeons[local1].pigeon_number = local1
        local2, local3, local4, local5 = le.choose_start_pnts()
        pigeons[local1].start_pnt.x = local2
        pigeons[local1].start_pnt.y = local3
        pigeons[local1].start_pnt.z = local4
        pigeons[local1].fly_direction = local5
        if not le.pigeons_obj[local1] then
            le.pigeons_obj[local1] = Object:create(le, "pigeon_obj" .. local1, pigeons[local1].start_pnt.x, pigeons[local1].start_pnt.y, pigeons[local1].start_pnt.z, { range = 0.80000001 })
            le.pigeons_obj[local1].parent = le.master_pigeon_obj
        else
            le.pigeons_obj[local1].obj_x = pigeons[local1].start_pnt.x
            le.pigeons_obj[local1].obj_y = pigeons[local1].start_pnt.y
            le.pigeons_obj[local1].obj_z = pigeons[local1].start_pnt.z
        end
        pigeons[local1].costume_marker_handler = bird_sound_monitor
        pigeons[local1]:set_costume("pigeon_idles.cos")
        pigeons[local1]:set_colormap("pigeons.cmp")
        pigeons[local1]:set_walk_rate(0.80000001)
        pigeons[local1]:set_turn_rate(120)
        pigeons[local1]:ignore_boxes()
        pigeons[local1]:put_in_set(le)
        pigeons[local1]:setpos(local2, local3, local4)
        start_script(le.pigeon_brain, pigeons[local1])
    until local1 == le.NUMBER_OF_PIGEONS
end
le.point_and_fly_away = function(arg1) -- line 90
    local local1
    local local2
    local local3 = { }
    local local4 = TRUE
    local local5 = { }
    local local6 = { }
    local local7
    local local8
    local local9 = FALSE
    local local10
    local1 = arg1.orbit_pnt.z
    local2 = start_script(bird_climb, arg1, local1, 0.75, pigeon_idles_scared_takeoff)
    while find_script(local2) do
        if not TurnActorTo(arg1.hActor, arg1.orbit_pnt.x, arg1.orbit_pnt.y, arg1.orbit_pnt.z) then
            arg1:walk_forward()
        else
            TurnActorTo(arg1.hActor, arg1.orbit_pnt.x, arg1.orbit_pnt.y, arg1.orbit_pnt.z)
        end
        break_here()
    end
    repeat
        repeat
            local6 = manny:getpos()
            local3 = sqrt((local6.x - arg1.start_pnt.x) ^ 2 + (local6.y - arg1.start_pnt.y) ^ 2 + (local6.z - arg1.start_pnt.z) ^ 2)
            if not arg1:is_choring(pigeon_idles_fly_cycle) then
                arg1:play_chore(pigeon_idles_fly_cycle)
            end
            arg1:walk_forward()
            TurnActorTo(arg1.hActor, arg1.orbit_pnt.x, arg1.orbit_pnt.y, arg1.orbit_pnt.z)
            break_here()
        until local3 >= MANNY_LANDING_TOLERANCE
        repeat
            local6 = manny:getpos()
            local3 = sqrt((local6.x - arg1.start_pnt.x) ^ 2 + (local6.y - arg1.start_pnt.y) ^ 2 + (local6.z - arg1.start_pnt.z) ^ 2)
            local5 = arg1:getpos()
            local8 = sqrt((local5.x - arg1.start_pnt.x) ^ 2 + (local5.y - arg1.start_pnt.y) ^ 2)
            if not arg1:is_choring(pigeon_idles_glide) then
                arg1:play_chore(pigeon_idles_glide)
            end
            arg1:walk_forward()
            TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            break_here()
        until local3 <= MANNY_LANDING_TOLERANCE or local8 < 1
        repeat
            local6 = manny:getpos()
            local3 = sqrt((local6.x - arg1.start_pnt.x) ^ 2 + (local6.y - arg1.start_pnt.y) ^ 2 + (local6.z - arg1.start_pnt.z) ^ 2)
            if not TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z) then
                PointActorAt(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            end
            local8 = sqrt((local5.x - arg1.start_pnt.x) ^ 2 + (local5.y - arg1.start_pnt.y) ^ 2)
            local7 = tan(15) * local8
            local7 = local7 + arg1.start_pnt.z
            local10 = GetActorWalkRate(arg1.hActor)
            if local10 >= local8 then
                if not local9 then
                    local9 = TRUE
                    arg1:play_chore(pigeon_idles_landing)
                end
            end
            if PerSecond(local10) > local8 then
                arg1:set_walk_rate(local8)
            end
            arg1:walk_forward()
            local5 = arg1:getpos()
            if local5.z > local7 then
                arg1:setpos(local5.x, local5.y, local7)
            end
            break_here()
        until local3 <= MANNY_LANDING_TOLERANCE or local8 < 0.039999999
        arg1:set_walk_rate(0.80000001)
        local6 = manny:getpos()
        local3 = sqrt((local6.x - arg1.start_pnt.x) ^ 2 + (local6.y - arg1.start_pnt.y) ^ 2 + (local6.z - arg1.start_pnt.z) ^ 2)
        if local3 > MANNY_LANDING_TOLERANCE then
            local4 = FALSE
        end
    until not local4
    arg1:setpos(arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
    arg1:play_chore(pigeon_idles_standing)
end
le.fly_away = function(arg1) -- line 187
    local local1
    if arg1.fly_direction == "x" then
        arg1.orbit_pnt.x = arg1.start_pnt.x + rnd(2, 4)
        arg1.orbit_pnt.y = arg1.start_pnt.y
    else
        arg1.orbit_pnt.x = arg1.start_pnt.x
        arg1.orbit_pnt.y = arg1.start_pnt.y - rnd(2, 4)
    end
    arg1.orbit_pnt.z = arg1.start_pnt.z + 0.28
    local1 = start_script(le.point_and_fly_away, arg1)
    wait_for_script(local1)
end
le.pigeon_brain = function(arg1) -- line 207
    local local1 = proximity(arg1, manny)
    break_here()
    while 1 do
        local1 = proximity(arg1, manny)
        if local1 < MANNY_TOLERANCE then
            le.pigeons_obj[arg1.pigeon_number]:make_untouchable()
            le.fly_away(arg1)
        else
            le.pigeons_obj[arg1.pigeon_number]:make_touchable()
            sleep_for(rnd(250, 750))
            if rnd(3) then
                arg1:play_chore(pigeon_idles_pecking)
                while arg1:is_choring(pigeon_idles_pecking) and local1 > MANNY_TOLERANCE do
                    local1 = proximity(arg1, manny)
                    break_here()
                end
            else
                arg1:play_chore(pigeon_idles_jump_for_turn)
                if rnd() then
                    arg1:turn_right(90)
                else
                    arg1:turn_left(90)
                end
                while arg1:is_choring(pigeon_idles_jump_for_turn) and local1 > MANNY_TOLERANCE do
                    local1 = proximity(arg1, manny)
                    break_here()
                end
            end
        end
        break_here()
    end
end
le.activate_rope_boxes = function(arg1) -- line 254
    local local1, local2
    if le.rope_up.touchable then
        local1 = FALSE
    else
        local1 = TRUE
    end
    if le.rope_is_coiled then
        local2 = TRUE
    else
        local2 = FALSE
    end
    MakeSectorActive("coilgone1", not local2)
    MakeSectorActive("coilgone2", not local2)
    MakeSectorActive("ropegone1", local1)
    MakeSectorActive("ropegone2", local1)
end
le.init_ropes = function(arg1) -- line 278
    tie_rope:default()
    tie_rope:set_costume("manny_scales_rope.cos")
    tie_rope:put_in_set(system.currentSet)
    tie_rope:setpos(0.410085, 1.26691, 0.14)
    tie_rope:setrot(0, 15.2617, 0)
    tie_rope:play_chore(manny_scales_rope_show, "manny_scales_rope.cos")
    tie_rope:stop_chore(manny_scales_rope_show)
    ledge_rope:default()
    ledge_rope:put_in_set(system.currentSet)
    ledge_rope:setpos(0.15408, 1.38179, 0)
    ledge_rope:setrot(0, -8.044, 0)
    if le.rope_is_coiled then
        ledge_rope:play_chore(ledge_rope_rope_coiled_hold)
    elseif le.rope_up.touchable then
        ledge_rope:setrot(0, -55.7798, 0)
        ledge_rope:set_softimage_pos(1.59861, 0, -15.9998)
        ledge_rope:play_chore(ledge_rope_rope_up_hold)
    else
        ledge_rope:play_chore(ledge_rope_rope_hang_hold)
    end
    le:activate_rope_boxes()
    if le.grappling_hook.touchable or le.rope_up.touchable then
        ledge_rope:play_chore(ledge_rope_show_coral)
    else
        ledge_rope:play_chore(ledge_rope_hide_coral)
    end
end
le.rotate_manny_right = function(arg1) -- line 310
    local local1
    while get_generic_control_state("TURN_RIGHT") do
        local1 = manny:get_positive_rot()
        if local1.y > le.MAX_ROPE_ROT or local1.y < le.MIN_ROPE_ROT + 10 then
            TurnActor(manny.hActor, -1)
        end
        break_here()
    end
end
le.rotate_manny_left = function(arg1) -- line 322
    local local1
    while get_generic_control_state("TURN_LEFT") do
        local1 = manny:get_positive_rot()
        if local1.y < le.MIN_ROPE_ROT or local1.y > le.MAX_ROPE_ROT - 10 then
            TurnActor(manny.hActor, 1)
        end
        break_here()
    end
end
ledge_rope_button_handler = function(arg1, arg2, arg3) -- line 334
    if cutSceneLevel <= 0 then
        if control_map.TURN_LEFT[arg1] then
        elseif control_map.TURN_RIGHT[arg1] then
        elseif control_map.LOOK_AT[arg1] and arg2 then
            single_start_script(le.examine_holding_rope, le)
        elseif control_map.USE[arg1] and arg2 then
            single_start_script(le.manny_throw_rope, le)
        elseif control_map.PICK_UP[arg1] and arg2 then
            single_start_script(le.manny_drop_rope, le)
        elseif control_map.INVENTORY[arg1] and arg2 then
            if inventory_disabled then
                system.default_response("not now")
            elseif Inventory.num_items == 1 and mo.scythe.owner ~= manny then
                manny:say_line("/syma091/")
            else
                single_start_script(le.manny_rope_inventory)
            end
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    end
end
le.examine_holding_rope = function(arg1) -- line 375
    START_CUT_SCENE()
    manny:head_look_at(le.ladder_to_roof)
    le.ladder_to_roof:lookAt()
    wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
le.manny_pick_up_rope = function(arg1) -- line 399
    if not le.manny_holding_rope then
        START_CUT_SCENE()
        manny:clear_hands()
        if not le.rope_is_coiled then
            manny:push_costume("ma_rope.cos")
            manny:play_chore(ma_rope_coil_rope, "ma_rope.cos")
            ledge_rope:play_chore(ledge_rope_coil_rope)
            sleep_for(250)
            start_sfx("coilRope.wav")
            manny:wait_for_chore()
            le.rope_is_coiled = TRUE
        else
            manny:push_costume("ma_rope.cos")
            manny:play_chore(ma_rope_pickup_rope, "ma_rope.cos")
            ledge_rope:play_chore(ledge_rope_pickup_rope)
            sleep_for(500)
            start_sfx("getRope.wav")
            manny:wait_for_chore()
        end
        END_CUT_SCENE()
        enable_head_control(FALSE)
        system.buttonHandler = ledge_rope_button_handler
        le.manny_holding_rope = TRUE
    end
end
le.manny_drop_rope = function(arg1) -- line 432
    if le.manny_holding_rope then
        START_CUT_SCENE()
        manny:play_chore(ma_rope_drop_rope, "ma_rope.cos")
        ledge_rope:play_chore(ledge_rope_drop_rope)
        sleep_for(250)
        start_sfx("getRope.wav")
        manny:wait_for_chore()
        manny:pop_costume()
        END_CUT_SCENE()
        le.manny_holding_rope = FALSE
        le:activate_rope_boxes()
        system.buttonHandler = SampleButtonHandler
        enable_head_control(TRUE)
    end
end
le.manny_rope_inventory = function(arg1) -- line 454
    START_CUT_SCENE()
    start_script(le.manny_drop_rope, le)
    wait_for_script(le.manny_drop_rope)
    END_CUT_SCENE()
    start_script(open_inventory)
end
le.manny_throw_rope = function(arg1) -- line 468
    local local1 = FALSE
    local local2, local3, local4
    if le.manny_holding_rope then
        if le.grappling_hook.touchable then
            local1 = TRUE
            cur_puzzle_state[8] = TRUE
        else
            local1 = FALSE
        end
        START_CUT_SCENE()
        if local1 then
            set_override(le.override_throw_hook, le)
            le:current_setup(le_ladws)
            manny:play_chore(ma_rope_hook_rope, "ma_rope.cos")
            ledge_rope:play_chore(ledge_rope_hook_rope)
            while manny:is_choring(ma_rope_hook_rope) do
                local2, local3, local4 = GetActorNodeLocation(ledge_rope.hActor, 18)
                manny:head_look_at_point(local2, local3, local4)
                break_here()
            end
            manny:pop_costume()
            le.grappling_hook:make_untouchable()
            le.rope_up:make_touchable()
            le:current_setup(le_alloh)
        else
            set_override(le.override_throw_miss, le)
            manny:play_chore(ma_rope_throw_rope, "ma_rope.cos")
            ledge_rope:play_chore(ledge_rope_throw_rope)
            while manny:is_choring(ma_rope_throw_rope) do
                local2, local3, local4 = GetActorNodeLocation(ledge_rope.hActor, 18)
                manny:head_look_at_point(local2, local3, local4)
                break_here()
            end
            manny:pop_costume()
            manny:head_look_at(nil)
        end
        END_CUT_SCENE()
        le.manny_holding_rope = FALSE
        le.rope_is_coiled = FALSE
        le:activate_rope_boxes()
        system.buttonHandler = SampleButtonHandler
        enable_head_control(TRUE)
    end
end
le.override_throw_hook = function(arg1) -- line 519
    kill_override()
    le.manny_holding_rope = FALSE
    le.rope_is_coiled = FALSE
    le:activate_rope_boxes()
    system.buttonHandler = SampleButtonHandler
    enable_head_control(TRUE)
    le.grappling_hook:make_untouchable()
    le.rope_up:make_touchable()
    le:current_setup(le_alloh)
    le:init_ropes()
end
le.override_throw_miss = function(arg1) -- line 535
    kill_override()
    le.manny_holding_rope = FALSE
    le.rope_is_coiled = FALSE
    le:activate_rope_boxes()
    system.buttonHandler = SampleButtonHandler
    enable_head_control(TRUE)
    le:init_ropes()
end
le.tie_coral = function(arg1) -- line 548
    START_CUT_SCENE()
    set_override(le.tie_coral_override, le)
    if not le.rope_is_coiled then
        manny:walkto_object(le.loose_end)
        put_away_held_item()
        le:manny_pick_up_rope()
        le:manny_drop_rope()
        manny.is_holding = dom.coral
        start_script(close_inventory)
        wait_for_script(close_inventory)
    end
    le.loose_end:make_untouchable()
    PutActorInSet(le.grappling_hook.interest_actor.hActor, le.hSet)
    enable_head_control(FALSE)
    manny:walkto(0.222428, 1.38618, 0)
    while manny:is_moving() do
        break_here()
    end
    manny:turn_toward_entity(0.0924284, 1.59618, 0)
    manny:stop_chore(ms_activate_coral, "ms.cos")
    manny.is_holding = nil
    manny.hold_chore = nil
    manny:stop_chore(ms_hold, "ms.cos")
    manny:push_costume("ma_rope.cos")
    manny:head_look_at_point(0.115, 1.5223, 0)
    manny:play_chore(ma_rope_tie_coral, "ma_rope.cos")
    sleep_for(1000)
    ledge_rope:play_chore(ledge_rope_show_coral)
    manny:wait_for_chore()
    manny:pop_costume()
    manny:head_look_at(le.grappling_hook)
    dom.coral:put_in_limbo()
    le.grappling_hook:lookAt()
    le.grappling_hook:make_touchable()
    END_CUT_SCENE()
    enable_head_control(TRUE)
end
le.tie_coral_override = function(arg1) -- line 594
    kill_override()
    if manny:get_costume() == "ma_rope.cos" then
        manny:pop_costume()
    end
    manny:stop_chore(ms_hold_coral, "ms.cos")
    dom.coral:put_in_limbo()
    manny:setpos(0.222428, 1.38618, 0)
    le.grappling_hook:make_touchable()
    le.loose_end:make_untouchable()
    le.rope_is_coiled = TRUE
    le.manny_holding_rope = FALSE
    manny:head_look_at(le.grappling_hook)
    le:init_ropes()
    enable_head_control(TRUE)
end
le.enter = function(arg1) -- line 618
    local local1 = 1
    LoadCostume("ma_rope.cos")
    LoadCostume("manny_scales.cos")
    LoadCostume("manny_scales_rope.cos")
    LoadCostume("ledge_rope.cos")
    LoadCostume("ma_enter_office.cos")
    preload_sfx("coilRope.wav")
    preload_sfx("getRope.wav")
    manny.footsteps = footsteps.marble
    le.init_homes()
    le.init_pigeons()
    if reaped_bruno then
        if not le.dom_warning.missed_dom then
            box_on("doms_trigger")
        end
        if reaped_meche then
            MakeSectorActive("doms_win_box", TRUE)
            NewObjectState(le_rufla, OBJSTATE_UNDERLAY, "le_open_window_do.bm")
            le.dom_door:set_object_state("le_open_doms_window.cos")
            if le.dom_door:is_open() then
                le.dom_door.interest_actor:complete_chore(0)
            end
        else
            MakeSectorActive("doms_win_box", FALSE)
        end
        le.co_door:close()
        le.co_door:lock()
        le.co_door.use_pnt_x = 0.149452
        le.co_door.use_pnt_y = 0.660429
        le.co_door.use_pnt_z = 0
        le.co_door.use_rot_x = 0
        le.co_door.use_rot_y = 94.720596
        le.co_door.use_rot_z = 0
        le.co_door.out_pnt_x = 0.149452
        le.co_door.out_pnt_y = 0.660429
        le.co_door.out_pnt_z = 0
        le.co_door.out_rot_x = 0
        le.co_door.out_rot_y = 94.720596
        le.co_door.out_rot_z = 0
        NewObjectState(le_rufla, OBJSTATE_UNDERLAY, "le_cl_.bm")
        NewObjectState(le_alloh, OBJSTATE_UNDERLAY, "le_open_window_co_oh.bm")
        NewObjectState(le_ladws, OBJSTATE_UNDERLAY, "le_open_window_co.bm")
        le.copals_drapes:set_object_state("le_copals_windows.cos")
        le.copals_drapes.interest_actor:play_chore(0)
    else
        le.co_door:open()
        le.co_door:unlock()
        MakeSectorActive("doms_trigger", FALSE)
    end
    SetShadowColor(15, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -1000, 1000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0, -1000, 1000)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow21")
    le:init_ropes()
end
le.exit = function() -- line 696
    local local1 = 1
    stop_script(le.point_and_fly_away)
    stop_script(le.fly_away)
    stop_script(le.pigeon_brain)
    stop_script(bird_climb)
    le.dom_door:free_object_state()
    le.copals_drapes:free_object_state()
    ledge_rope:free()
    tie_rope:free()
    KillActorShadows(manny.hActor)
    repeat
        local1 = local1 + 1
        pigeons[local1]:free()
    until local1 == le.NUMBER_OF_PIGEONS
end
le.rope_down = Object:create(le, "/letx001/hanging rope", 0.45500001, 1.1210001, 0, { range = 0.60000002 })
le.rope_down.use_pnt_x = 0.237
le.rope_down.use_pnt_y = 1.28
le.rope_down.use_pnt_z = 0
le.rope_down.use_rot_x = 0
le.rope_down.use_rot_y = -100.824
le.rope_down.use_rot_z = 0
le.rope_down.lookAt = function(arg1) -- line 731
    START_CUT_SCENE()
    manny:say_line("/lema002/")
    wait_for_message()
    END_CUT_SCENE()
    manny:say_line("/lema003/")
end
le.rope_down.use = function(arg1) -- line 740
    START_CUT_SCENE()
    enable_head_control(FALSE)
    MakeSectorActive("ropegone1", TRUE)
    MakeSectorActive("ropegone2", TRUE)
    manny:walkto(0.37544, 1.32678, -0.05066, 0, 10.3132, 0)
    manny:wait_for_actor()
    manny:clear_hands()
    manny:head_look_at(nil)
    manny:push_costume("manny_scales.cos")
    manny:play_chore(manny_scales_climb_down, "manny_scales.cos")
    manny:wait_for_chore()
    manny:stop_chore(manny_scales_climb_down, "manny_scales.cos")
    manny:pop_costume()
    END_CUT_SCENE()
    al.rope:climbDown()
end
le.rope_down.climbUp = function(arg1) -- line 761
    le:switch_to_set()
    manny:put_at_object(arg1)
end
le.loose_end = Object:create(le, "/letx004/loose end of rope", 0.245, 1.497, 0.050000001, { range = 0.60000002 })
le.loose_end.use_pnt_x = 0.15408
le.loose_end.use_pnt_y = 1.38179
le.loose_end.use_pnt_z = 0
le.loose_end.use_rot_x = 0
le.loose_end.use_rot_y = -8.0439997
le.loose_end.use_rot_z = 0
le.loose_end.lookAt = function(arg1) -- line 776
    START_CUT_SCENE()
    manny:say_line("/lema005/")
    wait_for_message()
    manny:say_line("/lema006/")
    END_CUT_SCENE()
end
le.loose_end.use = function(arg1) -- line 785
    if manny:walkto_object(arg1) then
        le:manny_pick_up_rope()
    end
end
le.loose_end.pickUp = le.loose_end.use
le.loose_end.use_coral = function(arg1) -- line 794
    start_script(le.tie_coral, le)
end
le.grappling_hook = Object:create(le, "/letx007/grappling hook", 0.1269, 1.541, 0, { range = 0.5 })
le.grappling_hook.use_pnt_x = 0.15408
le.grappling_hook.use_pnt_y = 1.38179
le.grappling_hook.use_pnt_z = 0
le.grappling_hook.use_rot_x = 0
le.grappling_hook.use_rot_y = -8.0439997
le.grappling_hook.use_rot_z = 0
le.grappling_hook.touchable = FALSE
le.grappling_hook.lookAt = function(arg1) -- line 809
    manny:say_line("/lema008/")
end
le.grappling_hook.use = function(arg1) -- line 813
    if manny:walkto_object(arg1) then
        le:manny_pick_up_rope()
    end
end
le.grappling_hook.pickUp = le.grappling_hook.use
le.rope_up = Object:create(le, "/letx009/rope to ledge", 0.26300001, 1.88034, 0.5, { range = 0.80000001 })
le.rope_up.use_pnt_x = 0.15000001
le.rope_up.use_pnt_y = 1.59998
le.rope_up.use_pnt_z = 0
le.rope_up.use_rot_x = 0
le.rope_up.use_rot_y = -55.7798
le.rope_up.use_rot_z = 0
le.rope_up.touchable = FALSE
le.rope_up.lookAt = function(arg1) -- line 831
    manny:say_line("/lema010/")
end
le.rope_up.use = function(arg1) -- line 835
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:clear_hands()
        ledge_rope:setrot(0, -55.7798, 0)
        ledge_rope:set_softimage_pos(1.59861, 0, -15.9998)
        ledge_rope:play_chore(ledge_rope_shimmy_rope)
        manny:push_costume("ma_rope.cos")
        manny:play_chore(ma_rope_shimmy_rope, "ma_rope.cos")
        manny:wait_for_chore()
        manny:setpos(le.rope_up_top.use_pnt_x, le.rope_up_top.use_pnt_y, le.rope_up_top.use_pnt_z)
        manny:setrot(0, 0, 0)
        manny:stop_chore(ma_rope_shimmy_rope, "ma_rope.cos")
        manny:pop_costume()
        END_CUT_SCENE()
    end
end
le.rope_up.pickUp = le.rope_up.use
le.rope_up_top = Object:create(le, "/letx011/rope to ledge", 0.13, 2.346, 1.202, { range = 0.5 })
le.rope_up_top.use_pnt_x = -0.055
le.rope_up_top.use_pnt_y = 2.3610001
le.rope_up_top.use_pnt_z = 1.202
le.rope_up_top.use_rot_x = 0
le.rope_up_top.use_rot_y = -551.88
le.rope_up_top.use_rot_z = 0
le.rope_up_top.lookAt = function(arg1) -- line 865
    manny:say_line("/lema012/")
end
le.rope_up_top.use = function(arg1) -- line 869
    system.currentActor:setpos(le.rope_up.use_pnt_x, le.rope_up.use_pnt_y, le.rope_up.use_pnt_z)
end
le.rope_up_top.pickUp = le.rope_up_top.use
le.ladder_to_roof = Ladder:create(le, "/letx013/", -1.23036, 3.71891, 1.83, { range = 1.8 })
le.le_ladderup_box = le.ladder_to_roof
le.le_ladderdn_box = le.ladder_to_roof
le.ladder_to_roof.base.use_pnt_x = -1.161
le.ladder_to_roof.base.use_pnt_y = 3.6470001
le.ladder_to_roof.base.use_pnt_z = 1.202
le.ladder_to_roof.base.use_rot_x = 0
le.ladder_to_roof.base.use_rot_y = 83.063904
le.ladder_to_roof.base.use_rot_z = 0
le.ladder_to_roof.base.out_pnt_x = -0.89999998
le.ladder_to_roof.base.out_pnt_y = 3.6800001
le.ladder_to_roof.base.out_pnt_z = 1.202
le.ladder_to_roof.base.out_rot_x = 0
le.ladder_to_roof.base.out_rot_y = 261.35101
le.ladder_to_roof.base.out_rot_z = 0
le.ladder_to_roof.top.use_pnt_x = -1.795
le.ladder_to_roof.top.use_pnt_y = 3.6110001
le.ladder_to_roof.top.use_pnt_z = 4.2119999
le.ladder_to_roof.top.use_rot_x = 0
le.ladder_to_roof.top.use_rot_y = -82.809998
le.ladder_to_roof.top.use_rot_z = 0
le.ladder_to_roof.minz = 1.202
le.ladder_to_roof.maxz = 2.5
le.ladder_to_roof.base.box = "le_ladderup_box"
le.ladder_to_roof.top.box = "le_ladderdn_box"
le.ladder_to_roof.lookAt = function(arg1) -- line 913
    manny:say_line("/lema014/")
end
le.ladder_to_roof.walkOut = function(arg1, arg2) -- line 917
    if arg2 == arg1.top.box then
        le.cut_to_rf_trigger:walkOut()
    end
end
le.cut_to_rf_trigger = { }
le.le_cuttorf_box = le.cut_to_rf_trigger
le.cut_to_rf_trigger.walkOut = function(arg1) -- line 927
    manny:stop_climb_ladder()
    rf:switch_to_set()
    rf:current_setup(rf_rufha)
    manny.save_cos_depth = GetActorCostumeDepth(manny.hActor)
    START_CUT_SCENE()
    set_override(le.override_cut_to_rf, le)
    manny:clear_hands()
    manny:put_in_set(rf)
    manny:setpos(-2.025, 3.78, 3.72)
    manny:setrot(0, 97.5285, 0)
    manny:push_costume("manny_scales.cos")
    manny:play_chore(manny_scales_jump_to_co, "manny_scales.cos")
    sleep_for(800)
    start_sfx("mannyJmp.WAV")
    manny:wait_for_chore()
    manny:pop_costume()
    manny:walkto(-4.08258, 5.16606, 3.72)
    while manny:is_moving() do
        break_here()
    end
    END_CUT_SCENE()
    if not rf.seen_eggs then
        rf.seen_eggs = TRUE
        start_script(rf.show_eggs)
    end
end
le.override_cut_to_rf = function(arg1, arg2) -- line 961
    while GetActorCostumeDepth(manny.hActor) > manny.save_cos_depth do
        manny:pop_costume()
    end
    if arg2 then
        kill_override()
        while GetActorCostumeDepth(manny.hActor) > manny.save_cos_depth do
            manny:pop_costume()
        end
        manny:put_in_set(rf)
        manny:setpos(-4.08258, 5.16606, 3.72)
        manny:setrot(0, 77.006, 0)
        rf:current_setup(rf_rufha)
    end
end
le.master_pigeon_obj = Object:create(le, "master pigeon", 0, 0, 0, { range = 0 })
le.master_pigeon_obj.lookAt = function(arg1) -- line 980
    rf.pigeons1:use()
end
le.master_pigeon_obj.pickUp = function(arg1) -- line 984
    rf.pigeons1:pickUp()
end
le.master_pigeon_obj.use = function(arg1) -- line 988
    rf.pigeons1:pickUp()
end
le.copals_drapes = Object:create(le, "", 0, 0, 0, { range = 0 })
le.dom_door = Object:create(le, "/letx015/window", -3.2379999, 0.667, 0.44, { range = 1.2 })
le.dom_door.use_pnt_x = -3.38642
le.dom_door.use_pnt_y = -0.13642
le.dom_door.use_pnt_z = 0
le.dom_door.use_rot_x = 0
le.dom_door.use_rot_y = 0.032897901
le.dom_door.use_rot_z = 0
le.dom_door.lookAt = function(arg1) -- line 1013
    if reaped_bruno and not reaped_meche then
        manny:say_line("/lema016/")
    else
        manny:say_line("/lema017/")
    end
end
le.dom_door.use = function(arg1) -- line 1021
    local local1
    if not reaped_bruno then
        if arg1.tried_opening then
            manny:say_line("/lema018/")
        elseif manny:walkto_object(arg1) then
            START_CUT_SCENE()
            manny:clear_hands()
            manny:push_costume("ma_enter_office.cos")
            manny:play_chore(ma_enter_office_start_try_window, "ma_enter_office.cos")
            manny:wait_for_chore(ma_enter_office_start_try_window, "ma_enter_office.cos")
            manny:say_line("/lema018/")
            manny:wait_for_message()
            manny:play_chore(ma_enter_office_end_try_window, "ma_enter_office.cos")
            manny:say_line("/lema019/")
            manny:wait_for_message()
            manny:wait_for_chore(ma_enter_office_end_try_window, "ma_enter_office.cos")
            manny:pop_costume()
            END_CUT_SCENE()
        end
    elseif not reaped_meche then
        manny:say_line("/lema020/")
    elseif manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:clear_hands()
        manny:push_costume("ma_enter_office.cos")
        if not le.dom_door:is_open() then
            manny:play_chore(ma_enter_office_open_window, "ma_enter_office.cos")
            sleep_for(550)
            start_sfx("windowdo.wav")
            sleep_for(225)
            le.dom_door.interest_actor:play_chore(0)
            le.dom_door.interest_actor:wait_for_chore()
            manny:wait_for_chore()
        end
        manny:play_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
        sleep_for(300)
        start_sfx("maGrbWnd.WAV")
        manny:wait_for_chore()
        manny:stop_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
        le.dom_door:open()
        dom.window:open()
        manny:pop_costume()
        manny:follow_boxes()
        dom:switch_to_set()
        manny:play_sound_at("rugfall.wav")
        manny:put_in_set(dom)
        manny:setpos(1.1554199, 2.58599, 0)
        manny:setrot(0, 170.25101, 0)
        END_CUT_SCENE()
    end
end
le.dom_warning = Object:create(le, "/letx021/trigger", 0, 0, 0, { range = 0 })
le.doms_trigger = le.dom_warning
le.dom_warning.walkOut = function(arg1) -- line 1081
    if reaped_bruno then
        if reaped_meche then
            if not le.dom_warning.missed_dom then
                le.dom_warning.missed_dom = TRUE
                manny:say_line("/lema022/")
            end
        else
            manny:say_line("/lema023/")
        end
    end
end
le.co_door = Object:create(le, "/letx024/window", -0.093000002, 0.5923, 0.41, { range = 0.62539101 })
le.le_co_box = le.co_door
le.co_door.passage = { "co_psg" }
le.co_door.use_pnt_x = 0.103421
le.co_door.use_pnt_y = 0.67330498
le.co_door.use_pnt_z = 0
le.co_door.use_rot_x = 0
le.co_door.use_rot_y = 92.932098
le.co_door.use_rot_z = 0
le.co_door.out_pnt_x = 0.103421
le.co_door.out_pnt_y = 0.67330498
le.co_door.out_pnt_z = 0
le.co_door.out_rot_x = 0
le.co_door.out_rot_y = 92.932098
le.co_door.out_rot_z = 0
le.co_door.lookAt = function(arg1) -- line 1114
    if reaped_meche then
        manny:say_line("/lema025/")
    elseif reaped_bruno then
        manny:say_line("/lema027/")
    else
        manny:say_line("/lema026/")
    end
end
le.co_door.walkOut = function(arg1) -- line 1126
    if not reaped_meche and not reaped_bruno then
        le:jump_into_co()
    else
        arg1:lookAt()
    end
end
le.co_door.use = le.co_door.walkOut
le.jump_into_co = function(arg1) -- line 1136
    START_CUT_SCENE()
    cameraman_disabled = TRUE
    manny:walkto_object(le.co_door)
    manny:clear_hands()
    manny:push_costume("ma_enter_office.cos")
    manny:play_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
    sleep_for(300)
    start_sfx("maGrbWnd.WAV")
    sleep_for(700)
    manny:stop_chore(ma_enter_office_step_in_do, "ma_enter_office.cos")
    manny:pop_costume()
    manny:put_in_set(co)
    co:switch_to_set()
    manny:setpos(0.950364, 2.9558, 0)
    manny:setrot(0, 190.196, 0)
    co:current_setup(1)
    manny:push_costume("manny_scales.cos")
    manny:play_chore(manny_scales_jump_to_co, "manny_scales.cos")
    sleep_for(800)
    start_sfx("maJmpCpt.WAV")
    manny:wait_for_chore()
    manny:pop_costume()
    cameraman_disabled = FALSE
    END_CUT_SCENE()
end
le.co_door2 = Object:create(le, "/letx024/window", -0.978432, -0.0309864, 0.50999999, { range = 0.60000002 })
le.co_door2.use_pnt_x = -0.978432
le.co_door2.use_pnt_y = -0.210986
le.co_door2.use_pnt_z = 0
le.co_door2.use_rot_x = 0
le.co_door2.use_rot_y = 2.4669299
le.co_door2.use_rot_z = 0
le.co_door2.lookAt = le.co_door.lookAt
le.co_door3 = Object:create(le, "/letx024/window", -1.83843, -0.0309864, 0.50999999, { range = 0.60000002 })
le.co_door3.use_pnt_x = -1.77988
le.co_door3.use_pnt_y = -0.226787
le.co_door3.use_pnt_z = 0
le.co_door3.use_rot_x = 0
le.co_door3.use_rot_y = 15.9242
le.co_door3.use_rot_z = 0
le.co_door3.lookAt = le.co_door.lookAt

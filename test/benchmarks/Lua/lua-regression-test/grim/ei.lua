CheckFirstTime("ei.lua")
ei = Set:create("ei.set", "engine room interior", { ei_top = 0, ei_intha = 1 })
dofile("mn_levers.lua")
dofile("ei_outside.lua")
ei.ship_creak_vol = 14
dofile("anchors.lua")
show_hooked_anchor = function(arg1) -- line 32
    prop_anchor = Actor:create(nil, nil, nil, "prop anchor")
    prop_hook = Actor:create(nil, nil, nil, "prop_hook")
    prop_anchor:put_in_set(ei)
    prop_anchor:set_costume("anchors.cos")
    prop_anchor:setrot(0, 0, 0)
    prop_anchor:play_chore_looping(anchors_upr_hooked_stop)
    prop_hook:put_in_set(ei)
    prop_hook:set_costume("anchors.cos")
    prop_hook:setrot(0, 0, 0)
    prop_hook:play_chore_looping(anchors_lwr_hooked_stop)
    start_script(locate_bottom_anchor, prop_anchor, prop_hook)
    if arg1 == star_anchor then
        port_anchor:setpos(-0.0597416, -0.3246, -0.696)
        port_anchor:setrot(0, 20, 0)
        star_anchor:setpos(0.0198187, -0.354, 0.6412)
        star_anchor:setrot(0, 180, 0)
        star_hook:setrot(0, 180, 0)
        prop_anchor:setpos(1.5107, 0.7343, 0.8152)
        prop_anchor:setrot(0, 270, 0)
        prop_hook:setrot(0, 270, 0)
    else
        star_anchor:setpos(0.0467813, -0.6282, -0.8429)
        star_anchor:setrot(0, 0, 0)
        port_anchor:setpos(0.100058, -0.3298, 0.6692)
        port_anchor:setrot(0, 180, 0)
        port_hook:setrot(0, 180, 0)
        prop_anchor:setpos(-1.5706, 0.5713, 0.8503)
        prop_anchor:setrot(0, 90, 0)
        prop_hook:setrot(0, 90, 0)
    end
end
monitor_port_anchor_state = function() -- line 75
    local local1
    local local2 = ei.pa
    local local3 = ei.anchors_hooked
    while 1 do
        force_port_anchor_update = FALSE
        port_anchor:put_in_set(op)
        port_hook:put_in_set(op)
        local1 = local2.state
        local3 = ei.anchors_hooked
        port_anchor:stop_chore()
        port_hook:stop_chore()
        if ei.anchors_hooked then
            port_hook:set_visibility(TRUE)
        else
            port_hook:set_visibility(FALSE)
        end
        if local2.state == "out" then
            port_anchor:setpos(-0.136742, -1.4378, -0.14749999)
            port_anchor:setrot(-45, 0, 0)
            port_anchor:play_chore_looping(anchors_upr_sway)
        elseif local2.state == "straight" or local2.state == "under" then
            port_anchor:setpos(0.040158398, -0.5553, -0.69999999)
            port_anchor:setrot(0, 180, 0)
            port_anchor:play_chore_looping(anchors_upr_sway)
            port_hook:play_chore_looping(anchors_lower_sway)
        elseif local2.state == "drawn" or local2.state == "portholed" then
            port_anchor:setpos(-0.059741601, -0.32460001, -0.69599998)
            port_anchor:setrot(0, 20, 0)
            port_hook:play_chore(anchors_lower_sway)
        elseif local2.state == "up" then
            port_anchor:setpos(0.100058, -0.32980001, 0.6692)
            port_anchor:setrot(0, 180, 0)
            port_hook:setrot(0, 180, 0)
            port_anchor:play_chore_looping(anchors_upr_sway)
            port_hook:play_chore_looping(anchors_lower_sway)
        end
        while local2.state == local1 and local3 == ei.anchors_hooked and not force_port_anchor_update do
            break_here()
        end
        break_here()
    end
end
monitor_star_anchor_state = function() -- line 126
    local local1
    local local2 = ei.sa
    local local3 = ei.anchors_hooked
    while 1 do
        force_star_anchor_update = FALSE
        local1 = local2.state
        local3 = ei.anchors_hooked
        star_anchor:put_in_set(dp)
        star_hook:put_in_set(dp)
        star_anchor:stop_chore()
        star_hook:stop_chore()
        if ei.anchors_hooked then
            star_hook:set_visibility(TRUE)
        else
            star_hook:set_visibility(FALSE)
        end
        if local2.state == "out" then
            star_anchor:setpos(0.0051812702, -1.8283, -0.18520001)
            star_anchor:setrot(-45, 0, 0)
            star_anchor:play_chore_looping(anchors_upr_sway)
        elseif local2.state == "straight" or local2.state == "under" then
            star_anchor:setpos(0.046781301, -0.62819999, -0.69999999)
            star_anchor:setrot(0, 180, 0)
            star_hook:play_chore_looping(anchors_lower_sway)
            star_anchor:play_chore_looping(anchors_upr_sway)
        elseif local2.state == "drawn" or local2.state == "portholed" then
            star_anchor:setpos(0.046781301, -0.62819999, -0.84289998)
            star_anchor:setrot(0, 0, 0)
            star_hook:play_chore(anchors_lower_sway)
        elseif local2.state == "up" then
            star_anchor:setpos(0.019818701, -0.354, 0.64120001)
            star_anchor:setrot(0, 180, 0)
            star_hook:setrot(0, 180, 0)
            star_anchor:play_chore_looping(anchors_upr_sway)
            star_hook:play_chore_looping(anchors_lower_sway)
        end
        while local2.state == local1 and local3 == ei.anchors_hooked and not force_star_anchor_update do
            break_here()
        end
        break_here()
    end
end
ei.sa = { state = "straight", name = "starboard anchor" }
ei.pa = { state = "straight", name = "port-side anchor" }
ei.sa.other_anchor = ei.pa
ei.pa.other_anchor = ei.sa
ei.anchors_hooked = FALSE
ei.boat_state = "pier"
locate_bottom_anchor = function(arg1, arg2) -- line 206
    local local1 = { x = 0, y = 0, z = 0 }
    local local2 = { }
    local local3, local4
    while arg2:get_costume() do
        local2 = arg1:getrot()
        local4 = RotateVector(local1, local2)
        local3 = arg1:getpos()
        local4.x = local4.x + local3.x
        local4.y = local4.y + local3.y
        local4.z = local4.z + local3.z
        arg2:setpos(local4.x, local4.y, local4.z)
        break_here()
    end
end
anchor_init = function() -- line 224
    if not star_anchor then
        star_anchor = Actor:create(nil, nil, nil, "star anchor")
        port_anchor = Actor:create(nil, nil, nil, "port anchor")
        star_hook = Actor:create(nil, nil, nil, "star bottom anchor")
        port_hook = Actor:create(nil, nil, nil, "port bottom anchor")
    end
    star_anchor:put_in_set(dp)
    star_anchor:set_costume("anchors.cos")
    port_anchor:setrot(0, 0, 0)
    star_anchor:play_chore_looping(anchors_upr_sway)
    star_hook:put_in_set(dp)
    star_hook:set_costume("anchors.cos")
    star_hook:play_chore_looping(anchors_lower_sway)
    start_script(locate_bottom_anchor, star_anchor, star_hook)
    port_anchor:put_in_set(op)
    port_anchor:set_costume("anchors.cos")
    port_anchor:setrot(0, 0, 0)
    port_anchor:play_chore_looping(anchors_upr_sway)
    port_hook:put_in_set(op)
    port_hook:set_costume("anchors.cos")
    port_hook:play_chore_looping(anchors_lower_sway)
    start_script(locate_bottom_anchor, port_anchor, port_hook)
    if ei.anchors_hooked then
        port_hook:set_visibility(TRUE)
        star_hook:set_visibility(TRUE)
    else
        port_hook:set_visibility(FALSE)
        star_hook:set_visibility(FALSE)
    end
    start_script(monitor_port_anchor_state)
    start_script(monitor_star_anchor_state)
end
ei.anchor_rip = function() -- line 264
    local local1 = 0
    local local2 = prop_anchor:getpos()
    repeat
        local1 = local1 + PerSecond(0.015)
        local2 = prop_anchor:getpos()
        prop_anchor:setpos(local2.x, local2.y, local2.z - local1)
        break_here()
    until local1 < 0.28
    prop_anchor:free()
    prop_hook:free()
    prop_anchor = nil
    prop_hook = nil
end
ei.rip_ship = function() -- line 280
    preload_sfx("anchrip.wav")
    START_CUT_SCENE()
    ei.ship_ripped = TRUE
    manny:say_line("/eima001/")
    wait_for_message()
    stop_script(ei.glottis_look_at_manny)
    NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_r.bm")
    ei.dp_button:set_object_state("ei_rip_r.cos")
    NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_l.bm")
    ei.op_button:set_object_state("ei_rip_l.cos")
    if hooked_porthole == dp.anchor then
        glottis:push_costume("glottis_rip_left.cos")
        ei.dp_button:play_chore(0)
    else
        glottis:push_costume("glottis_rip_right.cos")
        ei.op_button:play_chore(0)
    end
    start_script(ei.anchor_rip)
    glottis:play_chore(0)
    start_sfx("anchrip.wav")
    glottis:wait_for_chore()
    glottis:pop_costume()
    if hooked_porthole == op.anchor then
        dp:end_result()
        NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_r.bm")
        ei.dp_button:set_object_state("ei_rip_r.cos")
        ei.dp_button:play_chore(0)
    else
        op:end_result()
        NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_l.bm")
        ei.op_button:set_object_state("ei_rip_l.cos")
        ei.op_button:complete_chore(0)
    end
    glottis:say_line("/eigl002/")
    wait_for_message()
    manny:say_line("/eima003/")
    END_CUT_SCENE()
end
ei.anchor_talk = function(arg1) -- line 328
    if arg1 == "locked" then
        manny:say_line("/eima004/")
    elseif arg1 == "up" then
        manny:say_line("/cwma010/")
        wait_for_message()
        manny:say_line("/eima006/")
    elseif arg1 == "down" then
        manny:say_line("/eima007/")
    elseif arg1 == "easier" then
        manny:say_line("/eima008/")
    elseif arg1 == "there" then
        manny:say_line("/eima031/")
    end
end
ei.glottis_look_at_manny = function() -- line 345
    while 1 do
        glottis:head_look_at_manny()
        break_here()
    end
end
anchor_cutscene = function(arg1, arg2) -- line 353
    if arg1 == ei.pa then
        op:anchor_cutscene(arg2)
    else
        dp:anchor_cutscene(arg2)
    end
end
ei.change_anchor_state = function(arg1, arg2, arg3) -- line 361
    local local1 = arg2.other_anchor
    if ei.ship_ripped then
        manny:say_line("/eima009/")
    else
        start_script(fade_sfx, "eiCreak.imu", 300, 0)
        START_CUT_SCENE()
        if arg3 == "raise" then
            if ei.anchors_hooked then
                if arg2.state == "portholed" then
                    start_script(ei.rip_ship)
                elseif arg2.state == "up" then
                    system.default_response("as far")
                else
                    arg2.state = "straight"
                    break_here()
                    anchor_cutscene(arg2, arg3)
                end
                arg2.state = "up"
                local1.state = "drawn"
            else
                if arg2.state == "up" then
                    system.default_response("as far")
                else
                    if arg2.state == "out" then
                        arg2.state = "straight"
                        break_here()
                    end
                    anchor_cutscene(arg2, arg3)
                end
                arg2.state = "up"
            end
        elseif ei.anchors_hooked then
            if local1.state == "portholed" then
                manny:say_line("/eima010/")
            elseif arg2.state == "out" then
                system.default_response("as far")
            elseif arg2.state == "straight" then
                system.default_response("as far")
            elseif arg2.state == "under" then
                system.default_response("as far")
            elseif arg2.state == "drawn" then
                system.default_response("as far")
            elseif arg2.state == "up" then
                anchor_cutscene(arg2, arg3)
                arg2.state = "straight"
                local1.state = "under"
            end
        elseif arg2.state == "out" then
            system.default_response("as far")
        elseif arg2.state == "straight" then
            system.default_response("as far")
        elseif arg2.state == "under" then
            system.default_response("as far")
        elseif arg2.state == "up" then
            anchor_cutscene(arg2, arg3)
            arg2.state = "straight"
            if arg2.other_anchor.state == "under" then
                PrintDebug("hooked")
                ei.anchors_hooked = TRUE
                sleep_for(500)
                start_sfx("anchlock.wav")
                wait_for_sound("anchlock.wav")
            end
        end
        END_CUT_SCENE()
        start_script(start_sfx, "eiCreak.imu", IM_MEDIUM_PRIORITY, ei.ship_creak_vol)
    end
end
ei.take_controls = function(arg1) -- line 438
    START_CUT_SCENE()
    manny:walkto_object(ei.spot)
    manny:wait_for_actor()
    manny:push_costume("mn_levers.cos")
    manny:play_chore_looping(mn_levers_hat_on)
    ei.lever_actor:set_visibility(FALSE)
    manny:play_chore(mn_levers_hands_on_levers)
    system.buttonHandler = engineButtonHandler
    END_CUT_SCENE()
end
ei.drop_controls = function(arg1) -- line 450
    START_CUT_SCENE()
    manny:play_chore(mn_levers_back_to_idle)
    manny:wait_for_chore()
    ei.lever_actor:set_visibility(TRUE)
    manny:pop_costume()
    manny:play_chore_looping(mn2_hat_on, "mn2.cos")
    END_CUT_SCENE()
    system.buttonHandler = SampleButtonHandler
end
view_moving_pier = function() -- line 461
    stop_sound("eiCreak.imu")
    start_sfx("eistrain.imu")
    if ei.boat_state == "ocean" then
        ei.pier:stop_chore(ei_outside_bobbing_away)
        ei.pier:play_chore(ei_outside_move_near)
        ei.pier:wait_for_chore()
        ei.pier:stop_chore(ei_outside_move_near)
        ei.pier:play_chore_looping(ei_outside_bobbing_near)
    else
        ei.pier:stop_chore(ei_outside_bobbing_near)
        ei.pier:play_chore(ei_outside_move_away)
        ei.pier:wait_for_chore()
        ei.pier:stop_chore(ei_outside_move_away)
        ei.pier:play_chore_looping(ei_outside_bobbing_away)
    end
    fade_sfx("eistrain.imu", 400, 0)
    start_sfx("eiCreak.imu", IM_MEDIUM_PRIORITY, ei.ship_creak_vol)
end
ei.drive_ship = function(arg1, arg2) -- line 482
    stop_sound("eiCreak.imu")
    START_CUT_SCENE()
    start_sfx("eirev.wav")
    if arg2 == "forward" then
        manny:play_chore(mn_levers_both_up)
        manny:wait_for_chore()
        ul.props_running = TRUE
        go_under_lola()
        manny:play_chore(mn_levers_neutral_hold)
        start_sfx("eirevend.wav")
        manny:wait_for_chore()
    elseif arg2 == "reverse" then
        manny:play_chore(mn_levers_both_down)
        manny:wait_for_chore()
        if ei.ship_ripped then
            stop_script(show_hooked_anchor)
            stop_script(monitor_port_anchor_state)
            stop_script(monitor_star_anchor_state)
            port_anchor:free()
            port_hook:free()
            star_anchor:free()
            star_hook:free()
            system.buttonHandler = SampleButtonHandler
            start_script(cut_scene.hydrfoil, cut_scene)
        else
            ul.props_running = TRUE
            go_under_lola()
            manny:play_chore(mn_levers_neutral2)
            start_sfx("eirevend.wav")
            manny:wait_for_chore()
            go_under_lola()
        end
    elseif arg2 == "port" then
        manny:play_chore(mn_levers_right_up)
        manny:wait_for_chore()
        ul.props_running = TRUE
        go_under_lola()
        if ei.boat_state == "ocean" then
            view_moving_pier()
            ei.boat_state = "pier"
            if ei.sa.state == "out" then
                ei.sa.state = "straight"
            elseif ei.sa.state == "straight" then
                ei.sa.state = "under"
            end
            if ei.pa.state == "straight" then
                ei.pa.state = "out"
            elseif ei.pa.state == "under" then
                ei.pa.state = "straight"
            end
            manny:play_chore(mn_levers_neutral4)
            start_sfx("eirevend.wav")
            manny:wait_for_actor()
            go_under_lola()
        else
            manny:play_chore(mn_levers_neutral4)
            start_sfx("eirevend.wav")
            manny:wait_for_actor()
        end
    elseif arg2 == "starboard" then
        manny:play_chore(mn_levers_left_up)
        manny:wait_for_chore()
        ul.props_running = TRUE
        go_under_lola()
        if ei.boat_state == "pier" then
            view_moving_pier()
            ei.boat_state = "ocean"
            if ei.sa.state == "straight" then
                ei.sa.state = "out"
            elseif ei.sa.state == "under" then
                ei.sa.state = "straight"
            end
            if ei.pa.state == "out" then
                ei.pa.state = "straight"
            elseif ei.pa.state == "straight" then
                ei.pa.state = "under"
            end
            manny:play_chore(mn_levers_neutral3)
            start_sfx("eirevend.wav")
            manny:wait_for_chore()
            go_under_lola()
        else
            manny:play_chore(mn_levers_neutral3)
            start_sfx("eirevend.wav")
            manny:wait_for_chore()
        end
    end
    wait_for_message()
    END_CUT_SCENE()
    start_sfx("eiCreak.imu", IM_MEDIUM_PRIORITY, ei.ship_creak_vol)
end
engineButtonHandler = function(arg1, arg2, arg3) -- line 585
    local local1 = FALSE
    if cutSceneLevel <= 0 then
        if control_map.MOVE_FORWARD[arg1] and arg2 then
            local1 = TRUE
            single_start_script(ei.drive_ship, ei, "forward")
        elseif control_map.MOVE_BACKWARD[arg1] and arg2 then
            local1 = TRUE
            single_start_script(ei.drive_ship, ei, "reverse")
        elseif control_map.TURN_LEFT[arg1] and arg2 then
            local1 = TRUE
            single_start_script(ei.drive_ship, ei, "port")
        elseif control_map.TURN_RIGHT[arg1] and arg2 then
            local1 = TRUE
            single_start_script(ei.drive_ship, ei, "starboard")
        elseif control_map.USE[arg1] or control_map.PICK_UP[arg1] or control_map.INVENTORY[arg1] and arg2 then
            local1 = TRUE
            single_start_script(ei.drop_controls, ei)
        end
    end
    if not local1 then
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
ei.set_up_actors = function(arg1) -- line 613
    manny:put_in_set(ei)
    glottis:set_costume("glottis_sailor.cos")
    glottis:set_talk_color(Orange)
    glottis:set_visibility(TRUE)
    glottis:set_head(3, 4, 4, 165, 28, 80)
    glottis:set_mumble_chore(glottis_mumble)
    glottis:set_talk_chore(1, glottis_stop_talk)
    glottis:set_talk_chore(2, glottis_a)
    glottis:set_talk_chore(3, glottis_c)
    glottis:set_talk_chore(4, glottis_e)
    glottis:set_talk_chore(5, glottis_f)
    glottis:set_talk_chore(6, glottis_l)
    glottis:set_talk_chore(7, glottis_m)
    glottis:set_talk_chore(8, glottis_o)
    glottis:set_talk_chore(9, glottis_t)
    glottis:set_talk_chore(10, glottis_u)
    glottis:put_in_set(ei)
    glottis:setpos(0.507027, 0.975, 0)
    glottis:setrot(0, 880, 0)
    glottis:play_chore_looping(glottis_flip_ears)
    glottis:set_collision_mode(COLLISION_SPHERE)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.35)
    SetActorCollisionScale(glottis.hActor, 0.5)
    if ei.seen_hitmen then
        glottis:play_chore(glottis_sailor_eyes_bulging, "glottis_sailor.cos")
        start_script(ei.glottis_look_at_manny)
    end
    if not ei.pier then
        ei.pier = Actor:create(nil, nil, nil, "pier")
    end
    ei.pier:set_costume("ei_outside.cos")
    ei.pier:put_in_set(ei)
    ei.pier:set_softimage_pos(16.8937, 2.2758, -8.8166)
    ei.pier:setrot(0, 180, 0)
    if ei.boat_state == "ocean" then
        ei.pier:play_chore_looping(ei_outside_bobbing_away)
    else
        ei.pier:play_chore_looping(ei_outside_bobbing_near)
    end
    if not ei.lever_actor then
        ei.lever_actor = Actor:create(nil, nil, nil, "lever")
    end
    ei.lever_actor:set_costume("mn_levers.cos")
    ei.lever_actor:put_in_set(ei)
    ei.lever_actor:setpos(-0.7592, 0.4438, 0)
    ei.lever_actor:setrot(0, 1.97816, 0)
    ei.lever_actor:play_chore_looping(mn_levers_levers_only)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.75, 0.81, 4.89)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(glottis.hActor, 0)
    SetActorShadowPoint(glottis.hActor, -0.75, 0.81, 4.89)
    SetActorShadowPlane(glottis.hActor, "shadow1")
    AddShadowPlane(glottis.hActor, "shadow1")
end
ei.enter = function(arg1) -- line 687
    ei:current_setup(ei_intha)
    ei:set_up_actors()
    if not port_anchor then
        anchor_init()
    end
    if prop_anchor then
        if ei.pa.state == "portholed" then
            prop_anchor:setpos(1.5107, 0.7343, 0.8152)
            prop_anchor:setrot(0, 270, 0)
            prop_hook:setrot(0, 270, 0)
        else
            prop_anchor:setpos(-1.5706, 0.5713, 0.8503)
            prop_anchor:setrot(0, 90, 0)
            prop_hook:setrot(0, 90, 0)
        end
    end
    if ei.ship_ripped then
        NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_r.bm")
        ei.dp_button:set_object_state("ei_rip_r.cos")
        ei.dp_button:complete_chore(0)
        NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_anchor_rip_l.bm")
        ei.op_button:set_object_state("ei_rip_l.cos")
        ei.op_button:complete_chore(0)
    end
    NewObjectState(ei_intha, OBJSTATE_UNDERLAY, "ei_door.bm")
    ei.il_door:set_object_state("ei_door.cos")
    start_sfx("eiCreak.imu", IM_MEDIUM_PRIORITY, ei.ship_creak_vol)
end
ei.exit = function(arg1) -- line 723
    glottis:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    glottis:free()
    ei.pier:free()
    stop_script(ei.glottis_look_at_manny)
    ei.lever_actor:free()
    stop_sound("eiCreak.imu")
    KillActorShadows(manny.hActor)
    KillActorShadows(glottis.hActor)
end
ei.dp_button = Object:create(ei, "button", 1.2046601, 0.65616298, 0.28, { range = 0.60000002 })
ei.dp_button.use_pnt_x = 0.83009499
ei.dp_button.use_pnt_y = 0.31885201
ei.dp_button.use_pnt_z = 0
ei.dp_button.use_rot_x = 0
ei.dp_button.use_rot_y = -56.958099
ei.dp_button.use_rot_z = 0
ei.dp_button.lookAt = function(arg1) -- line 751
    manny:say_line("/eima011/")
end
ei.dp_button.pickUp = function(arg1) -- line 755
    system.default_response("attached")
end
ei.dp_button.use = function(arg1) -- line 759
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(mn2_hand_on_obj, "mn2.cos")
    manny:wait_for_chore()
    start_sfx("deBtn.wav")
    manny:stop_chore(mn2_hand_on_obj, "mn2.cos")
    manny:play_chore(mn2_hand_off_obj, "mn2.cos")
    manny:wait_for_chore()
    manny:stop_chore(mn2_hand_off_obj, "mn2.cos")
    END_CUT_SCENE()
    if ei.sa.state == "up" then
        ei:change_anchor_state(ei.sa, "lower")
    else
        ei:change_anchor_state(ei.sa, "raise")
    end
    manny:setpos(0.830095, 0.318852, 0)
    manny:setrot(0, -56.9581, 0)
end
ei.op_button = Object:create(ei, "button", -1.17233, 0.589715, 0.31, { range = 0.60000002 })
ei.op_button.use_pnt_x = -0.979298
ei.op_button.use_pnt_y = 0.198717
ei.op_button.use_pnt_z = 0
ei.op_button.use_rot_x = 0
ei.op_button.use_rot_y = 60.062
ei.op_button.use_rot_z = 0
ei.op_button.lookAt = function(arg1) -- line 789
    manny:say_line("/eima012/")
end
ei.op_button.pickUp = function(arg1) -- line 793
    system.default_response("attached")
end
ei.op_button.use = function(arg1) -- line 797
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(mn2_hand_on_obj, "mn2.cos")
    manny:wait_for_chore()
    start_sfx("deBtn.wav")
    manny:stop_chore(mn2_hand_on_obj, "mn2.cos")
    manny:play_chore(mn2_hand_off_obj, "mn2.cos")
    manny:wait_for_chore()
    manny:stop_chore(mn2_hand_off_obj, "mn2.cos")
    END_CUT_SCENE()
    if ei.pa.state == "up" then
        ei:change_anchor_state(ei.pa, "lower")
    else
        ei:change_anchor_state(ei.pa, "raise")
    end
    manny:setpos(-0.979298, 0.198717, 0)
    manny:setrot(0, 60.062, 0)
end
ei.intruments = Object:create(ei, "instruments", -0.741952, 0.97491002, 0.56999999, { range = 0.60000002 })
ei.intruments.use_pnt_x = -0.741952
ei.intruments.use_pnt_y = 0.52490997
ei.intruments.use_pnt_z = 0
ei.intruments.use_rot_x = 0
ei.intruments.use_rot_y = 365.23599
ei.intruments.use_rot_z = 0
ei.intruments.lookAt = function(arg1) -- line 827
    manny:say_line("/eima013/")
    wait_for_message()
    glottis:say_line("/eigl014/")
    wait_for_message()
    glottis:say_line("/eigl015/")
end
ei.intruments.use = function(arg1) -- line 835
    ei.left_control:use()
end
ei.left_control = Object:create(ei, "lever", -0.85195202, 0.67491001, 0.25999999, { range = 0.60000002 })
ei.left_control.use_pnt_x = -0.741952
ei.left_control.use_pnt_y = 0.52490997
ei.left_control.use_pnt_z = 0
ei.left_control.use_rot_x = 0
ei.left_control.use_rot_y = 365.23599
ei.left_control.use_rot_z = 0
ei.left_control.lookAt = function(arg1) -- line 847
    manny:say_line("/eima016/")
end
ei.left_control.use = function(arg1) -- line 851
    ei:take_controls()
end
ei.left_control.pick_up = ei.left_control.use
ei.right_control = Object:create(ei, "lever", -0.61195201, 0.67491001, 0.25999999, { range = 0.60000002 })
ei.right_control.use_pnt_x = -0.741952
ei.right_control.use_pnt_y = 0.52490997
ei.right_control.use_pnt_z = 0
ei.right_control.use_rot_x = 0
ei.right_control.use_rot_y = 365.23599
ei.right_control.use_rot_z = 0
ei.right_control.lookAt = function(arg1) -- line 865
    manny:say_line("/eima017/")
end
ei.right_control.use = function(arg1) -- line 869
    ei:take_controls()
end
ei.right_control.pick_up = ei.right_control.use
ei.engine = Object:create(ei, "engine", -0.40317801, -0.38499999, 0.44999999, { range = 0.80000001 })
ei.engine.use_pnt_x = -0.30317801
ei.engine.use_pnt_y = 0.175
ei.engine.use_pnt_z = 0
ei.engine.use_rot_x = 0
ei.engine.use_rot_y = 180.84399
ei.engine.use_rot_z = 0
ei.engine.lookAt = function(arg1) -- line 883
    START_CUT_SCENE()
    manny:say_line("/eima018/")
    wait_for_message()
    manny:say_line("/eima019/")
    wait_for_message()
    glottis:say_line("/eigl020/")
    wait_for_message()
    glottis:say_line("/eigl021/")
    wait_for_message()
    manny:say_line("/eima022/")
    END_CUT_SCENE()
end
ei.engine.pickUp = function(arg1) -- line 897
    system.default_response("bolted")
end
ei.engine.use = function(arg1) -- line 901
    manny:say_line("/eima023/")
    wait_for_message()
    manny:say_line("/eima024/")
end
ei.spot = Object:create(ei, "", 0, 0, 0, { range = 0 })
ei.spot.use_pnt_x = -0.75919998
ei.spot.use_pnt_y = 0.4438
ei.spot.use_pnt_z = 0
ei.spot.use_rot_x = 0
ei.spot.use_rot_y = 1.97816
ei.spot.use_rot_z = 0
ei.glottis_obj = Object:create(ei, "Glottis", 0.447227, 1.04851, 0.56999999, { range = 0.80000001 })
ei.glottis_obj.use_pnt_x = -0.0127726
ei.glottis_obj.use_pnt_y = 0.72851402
ei.glottis_obj.use_pnt_z = 0
ei.glottis_obj.use_rot_x = 0
ei.glottis_obj.use_rot_y = -41.402302
ei.glottis_obj.use_rot_z = 0
ei.glottis_obj.lookAt = function(arg1) -- line 926
    manny:say_line("/eima025/")
    wait_for_message()
    glottis:say_line("/eigl026/")
end
ei.glottis_obj.use = function(arg1) -- line 932
    START_CUT_SCENE()
    manny:say_line("/eima027/")
    wait_for_message()
    manny:say_line("/eima028/")
    wait_for_message()
    glottis:say_line("/eigl029/")
    wait_for_message()
    sleep_for(500)
    glottis:say_line("/eigl030/")
    END_CUT_SCENE()
end
ei.op_door = Object:create(ei, "door", -1.01042, 0.33446601, 0, { range = 0 })
ei.op_door.use_pnt_x = -0.75845301
ei.op_door.use_pnt_y = 0.311728
ei.op_door.use_pnt_z = 0
ei.op_door.use_rot_x = 0
ei.op_door.use_rot_y = 69.007202
ei.op_door.use_rot_z = 0
ei.op_door.out_pnt_x = -0.94445699
ei.op_door.out_pnt_y = 0.38302299
ei.op_door.out_pnt_z = 0
ei.op_door.out_rot_x = 0
ei.op_door.out_rot_y = 69.007202
ei.op_door.out_rot_z = 0
ei.op_box = ei.op_door
ei.op_door.walkOut = function(arg1) -- line 967
    op:come_out_door(op.ei_door)
end
ei.dp_door = Object:create(ei, "door", 1.08878, 0.70887601, 0, { range = 0 })
ei.dp_door.use_pnt_x = 0.84227997
ei.dp_door.use_pnt_y = 0.335841
ei.dp_door.use_pnt_z = 0
ei.dp_door.use_rot_x = 0
ei.dp_door.use_rot_y = -16.0637
ei.dp_door.use_rot_z = 0
ei.dp_door.out_pnt_x = 1.08825
ei.dp_door.out_pnt_y = 0.73490602
ei.dp_door.out_pnt_z = 0
ei.dp_door.out_rot_x = 0
ei.dp_door.out_rot_y = -87.632202
ei.dp_door.out_rot_z = 0
ei.dp_box = ei.dp_door
ei.dp_door.walkOut = function(arg1) -- line 989
    dp:come_out_door(dp.ei_door)
end
ei.il_door = Object:create(ei, "hatch", -0.075000003, 1.2049, 0.41, { range = 0 })
ei.il_door.use_pnt_x = -0.075000003
ei.il_door.use_pnt_y = 1.0749
ei.il_door.use_pnt_z = 0
ei.il_door.use_rot_x = 0
ei.il_door.use_rot_y = -349.22198
ei.il_door.use_rot_z = 0

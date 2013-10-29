CheckFirstTime("op.lua")
op = Set:create("op.set", "ocean porthole", { op_top = 0, op_extms = 1 })
op.position_manny = function() -- line 13
    if find_script(op.anchor_cutscene) then
        manny:setpos(0.0189584, 0, 15, 0)
        manny:setrot(0, -184.433, 0)
    else
        START_CUT_SCENE()
        break_here()
        break_here()
        manny:walkto(op.anchor)
        manny:wait_for_actor()
        END_CUT_SCENE()
    end
end
op.anchor_cutscene = function(arg1, arg2) -- line 27
    local local1 = { }
    local local2 = 0
    local local3 = FALSE
    if system.currentSet == ei then
        op:switch_to_set()
        bSwitchRooms = TRUE
    end
    if arg2 == "lower" then
        start_sfx("anchup.wav")
        repeat
            local1 = port_anchor:getpos()
            local2 = local2 + 0.1
            local1.z = local1.z - PerSecond(local2)
            if local1.z < -0.86390001 then
                local1.z = -0.86390001
            end
            port_anchor:setpos(local1.x, local1.y, local1.z)
            break_here()
        until local1.z == -0.86390001
        start_sfx("anchspls.wav")
    else
        start_sfx("anchup.wav")
        repeat
            local1 = port_anchor:getpos()
            local2 = local2 + 0.1
            local1.z = local1.z + PerSecond(local2)
            if local1.z > 0.76789999 then
                local1.z = 0.76789999
            end
            port_anchor:setpos(local1.x, local1.y, local1.z)
            break_here()
        until local1.z == 0.76789999
    end
    if bSwitchRooms then
        ei:switch_to_set()
    end
end
op.end_result = function(arg1) -- line 67
    op:switch_to_set_soft()
    port_anchor:put_in_set(op)
    port_hook:put_in_set(op)
    NewObjectState(op_extms, OBJSTATE_STATE, "op_torn.bm")
    op.anchor:set_object_state("op_torn.cos")
    op.anchor:play_chore(0)
    port_anchor:setpos(0.100058, -0.3298, 0.6692)
    port_anchor:setrot(0, 90, 0)
    port_hook:setrot(0, 90, 0)
    star_anchor:stop_chore()
    star_anchor:setpos(0.0467813, -0.6282, -0.8429)
    star_anchor:setrot(0, 0, 0)
    port_anchor:play_chore_looping(anchors_upr_sway)
    port_hook:play_chore_looping(anchors_lower_sway)
    sleep_for(3000)
    op:return_to_set()
end
op.switch_to_set_soft = function(arg1) -- line 90
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    inventory_save_set = system.currentSet
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = op
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    inventory_save_handler = system.buttonHandler
end
op.return_to_set = function(arg1) -- line 105
    op:exit()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    system.buttonHandler = inventory_save_handler
end
op.enter = function(arg1) -- line 120
    local local1
    MakeSectorActive("op_wall", FALSE)
    op:current_setup(op_extms)
    force_port_anchor_update = TRUE
    if ei.ship_ripped then
        NewObjectState(op_extms, OBJSTATE_STATE, "op_torn.bm", "op_torn.zbm")
        op.anchor:set_object_state("op_torn.cos")
        op.anchor:play_chore(0)
    end
    start_script(op.position_manny)
    SetActorClipActive(manny.hActor, TRUE)
    SetActorClipPlane(manny.hActor, 0, 1, 0.02, 0.0122126, 0.016807901, 0)
    port_anchor:put_in_set(op)
    port_hook:put_in_set(op)
    if ei.pa.state == "straight" or ei.pa.state == "out" or ei.pa.state == "up" or ei.pa.state == "under" then
        start_sfx("dpCreak.imu", IM_HIGH_PRIORITY, 90)
    end
end
op.exit = function(arg1) -- line 145
    KillTextObject(op.hText)
    SetActorClipActive(manny.hActor, FALSE)
    stop_sound("dpCreak.imu")
end
op.anchor = Object:create(op, "anchor", -0.201042, -0.44999999, 0.58999997, { range = 0.94999999 })
op.anchor.use_pnt_x = 0.018958399
op.anchor.use_pnt_y = 0.15000001
op.anchor.use_pnt_z = 0
op.anchor.use_rot_x = 0
op.anchor.use_rot_y = -184.433
op.anchor.use_rot_z = 0
op.anchor.lookAt = function(arg1) -- line 164
    if ei.ship_ripped then
        manny:say_line("/eima009/")
    elseif ei.pa.state == "up" then
        if ei.anchors_hooked then
            start_script(ei.anchor_talk, "locked")
        else
            start_script(ei.anchor_talk, "up")
        end
    else
        start_script(ei.anchor_talk, "down")
    end
end
op.anchor.pickUp = function(arg1) -- line 180
    system.default_response("reach")
end
op.anchor.use = op.anchor.pickUp
op.anchor.use_scythe = function(arg1) -- line 185
    local local1 = { }
    local local2 = { }
    local local3 = 0
    if ei.ship_ripped then
        manny:say_line("/eima009/")
    else
        START_CUT_SCENE()
        if ei.pa.state == "up" then
            if ei.anchors_hooked then
                ei.sa.state = "portholed"
                hooked_porthole = op.anchor
                local1 = manny:getpos()
                local2 = manny:getrot()
                MakeSectorActive("op_wall", TRUE)
                manny:walkto(0.018958399, 0.15000001, 0, 0, 175.56799, 0)
                manny:wait_for_actor()
                SetActorClipActive(manny.hActor, FALSE)
                stop_script(monitor_port_anchor_state)
                stop_script(monitor_star_anchor_state)
                port_anchor:set_chore_looping(anchors_upr_sway, FALSE)
                port_hook:set_chore_looping(anchors_lower_sway, FALSE)
                port_anchor:wait_for_chore()
                port_hook:wait_for_chore()
                manny:push_costume("mn_hook_anchors.cos")
                manny:stop_chore(mn2_hold_scythe, "mn2.cos")
                manny:play_chore(0)
                port_anchor:stop_chore(anchors_upr_sway)
                port_hook:stop_chore(anchors_lower_sway)
                port_anchor:play_chore(anchors_upr_hooked)
                port_hook:play_chore(anchors_lower_hooked)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
                start_script(show_hooked_anchor, port_anchor)
                start_script(ei.anchor_talk, "there")
                manny:walkto(local1.x, local1.y, local1.z, local2.x, local2.y, local2.z)
                manny:wait_for_actor()
                SetActorClipActive(manny.hActor, TRUE)
                MakeSectorActive("op_wall", FALSE)
            else
                MakeSectorActive("op_wall", TRUE)
                manny:walkto(0.000928819, 0.219815, 0, 0, 210.44299, 0)
                manny:wait_for_actor()
                manny:head_look_at(manny)
                manny:play_chore(mn2_lft_on_obj, "mn2.cos")
                manny:wait_for_chore()
                start_sfx("anchup.wav")
                repeat
                    local1 = port_anchor:getpos()
                    local3 = local3 + 0.1
                    local1.z = local1.z - PerSecond(local3)
                    if local1.z < 0.30000001 then
                        local1.z = 0.30000001
                    end
                    port_anchor:setpos(local1.x, local1.y, local1.z)
                    break_here()
                until local1.z == 0.30000001
                stop_sound("anchup.wav")
                manny:play_chore(mn2_lft_off, "mn2.cos")
                manny:wait_for_chore()
                manny:walkto(0.018958399, 0.15000001, 0, 0, 175.56799, 0)
                manny:wait_for_actor()
                SetActorClipActive(manny.hActor, FALSE)
                manny:push_costume("mn_hook_anchors.cos")
                manny:stop_chore(mn2_hold_scythe, "mn2.cos")
                manny:play_chore(1)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
                manny:walkto(0.000928819, 0.219815, 0, 0, 210.44299, 0)
                MakeSectorActive("op_wall", FALSE)
                SetActorClipActive(manny.hActor, TRUE)
                manny:wait_for_actor()
                manny:head_look_at(manny)
                manny:play_chore(mn2_lft_on_obj, "mn2.cos")
                manny:wait_for_chore()
                start_sfx("anchup.wav")
                local3 = 0
                repeat
                    local1 = port_anchor:getpos()
                    local3 = local3 + 0.1
                    local1.z = local1.z + PerSecond(local3)
                    if local1.z > 0.76789999 then
                        local1.z = 0.76789999
                    end
                    port_anchor:setpos(local1.x, local1.y, local1.z)
                    break_here()
                until local1.z == 0.76789999
                stop_sound("anchup.wav")
                manny:play_chore(mn2_lft_off, "mn2.cos")
                manny:wait_for_chore()
                system.default_response("frustrated")
            end
        else
            start_script(ei.anchor_talk, "easier")
        end
        manny:wait_for_message()
        mo.scythe:put_away()
        END_CUT_SCENE()
    end
end
clipplane_button_handler = function(arg1, arg2, arg3) -- line 306
    if arg1 == NUMPAD4KEY and arg2 then
        start_script(rotate_clip, arg1)
    elseif arg1 == NUMPAD6KEY and arg2 then
        start_script(rotate_clip, arg1)
    elseif arg1 == NUMPAD8KEY and arg2 then
        start_script(rotate_clip, arg1)
    elseif arg1 == NUMPAD2KEY and arg2 then
        start_script(rotate_clip, arg1)
    elseif arg1 == NUMPAD7KEY and arg2 then
        start_script(rotate_clip, arg1)
    elseif arg1 == NUMPAD3KEY and arg2 then
        start_script(rotate_clip, arg1)
    else
        SampleButtonHandler(arg1, arg2, arg3)
    end
end
rotate_clip = function(arg1) -- line 324
    while GetControlState(arg1) do
        if arg1 == NUMPAD4KEY then
            clipplane.x = clipplane.x - 2
        elseif arg1 == NUMPAD6KEY then
            clipplane.x = clipplane.x + 2
        elseif arg1 == NUMPAD2KEY then
            clipplane.y = clipplane.y + 2
        elseif arg1 == NUMPAD8KEY then
            clipplane.y = clipplane.y - 2
        elseif arg1 == NUMPAD7KEY then
            clipplane.z = clipplane.z - 2
        elseif arg1 == NUMPAD3KEY then
            clipplane.z = clipplane.z + 2
        end
        break_here()
    end
end
testclip = function() -- line 343
    local local1 = { }
    local local2 = { }
    if spotfinder == nil or not spotfinder.active then
        toggle_spotfinder()
    end
    SetActorClipActive(manny.hActor, TRUE)
    while TRUE do
        local1 = spotfinder:getpos()
        local1 = normalize_vector(local1)
        break_here()
    end
end
op.ei_door = Object:create(op, "door", 0.247621, 0.77042902, 0.54000002, { range = 0 })
op.ei_door.use_pnt_x = 0.247621
op.ei_door.use_pnt_y = 0.36042899
op.ei_door.use_pnt_z = 0
op.ei_door.use_rot_x = 0
op.ei_door.use_rot_y = -356.49799
op.ei_door.use_rot_z = 0
op.ei_door.out_pnt_x = 0.25003099
op.ei_door.out_pnt_y = 0.67497098
op.ei_door.out_pnt_z = 0
op.ei_door.out_rot_x = 0
op.ei_door.out_rot_y = -350.01999
op.ei_door.out_rot_z = 0
op.ei_box = op.ei_door
op.ei_door.walkOut = function(arg1) -- line 414
    ei:come_out_door(ei.op_door)
end

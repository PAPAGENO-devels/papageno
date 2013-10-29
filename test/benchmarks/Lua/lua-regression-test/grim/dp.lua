CheckFirstTime("dp.lua")
dp = Set:create("dp.set", "dock porthole", { dp_top = 0, dp_extms = 1 })
dp.anchor_creak_vol = 20
dp.position_manny = function() -- line 15
    START_CUT_SCENE()
    break_here()
    break_here()
    manny:walkto(dp.anchor)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
dp.anchor_cutscene = function(arg1, arg2) -- line 24
    local local1 = { }
    local local2 = 0
    dp:switch_to_set()
    if arg2 == "lower" then
        start_sfx("anchup.wav")
        repeat
            local1 = star_anchor:getpos()
            local2 = local2 + 0.1
            local1.z = local1.z - PerSecond(local2)
            if local1.z < -0.84289998 then
                local1.z = -0.84289998
            end
            star_anchor:setpos(local1.x, local1.y, local1.z)
            break_here()
        until local1.z == -0.84289998
        start_sfx("anchspls.wav")
    else
        start_sfx("anchup.wav")
        repeat
            local1 = star_anchor:getpos()
            local2 = local2 + 0.1
            local1.z = local1.z + PerSecond(local2)
            if local1.z > 0.79110003 then
                local1.z = 0.79110003
            end
            star_anchor:setpos(local1.x, local1.y, local1.z)
            break_here()
        until local1.z == 0.79110003
    end
    ei:switch_to_set()
end
dp.end_result = function(arg1) -- line 57
    dp:switch_to_set_soft()
    star_anchor:put_in_set(dp)
    star_hook:put_in_set(dp)
    star_anchor:setpos(0.0198187, -0.354, 0.6412)
    star_anchor:setrot(0, 90, 0)
    star_hook:setrot(0, 90, 0)
    star_anchor:play_chore_looping(anchors_upr_sway)
    star_hook:play_chore_looping(anchors_lower_sway)
    port_anchor:setpos(-0.0597416, -0.3246, -0.696)
    port_anchor:setrot(0, 20, 0)
    port_anchor:stop_chore()
    port_hook:play_chore(anchors_lower_sway)
    sleep_for(3000)
    dp:return_to_set()
end
dp.switch_to_set_soft = function(arg1) -- line 79
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    inventory_save_set = system.currentSet
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = dp
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    inventory_save_handler = system.buttonHandler
end
dp.return_to_set = function(arg1) -- line 95
    dp:exit()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    system.buttonHandler = inventory_save_handler
end
dp.enter = function(arg1) -- line 110
    dp:current_setup(dp_extms)
    if ei.ship_ripped then
        NewObjectState(dp_extms, OBJSTATE_STATE, "dp_torn.bm", "dp_torn.zbm")
        dp.anchor:set_object_state("dp_tear.cos")
        dp.anchor:play_chore(0)
    end
    force_star_anchor_update = TRUE
    start_script(dp.position_manny)
    star_anchor:put_in_set(dp)
    star_hook:put_in_set(dp)
    SetActorClipPlane(manny.hActor, 0, 1, 0.02, -0.03, 0.0106954, 0)
    SetActorClipActive(manny.hActor, TRUE)
    MakeSectorActive("dp_wall", FALSE)
    if ei.sa.state == "straight" or ei.sa.state == "out" or ei.sa.state == "up" or ei.sa.state == "under" then
        start_sfx("dpCreak.imu", IM_HIGH_PRIORITY, 90)
    end
end
dp.exit = function(arg1) -- line 133
    SetActorClipActive(manny.hActor, FALSE)
    stop_sound("dpCreak.imu")
end
dp.anchor = Object:create(dp, "anchor", 0.102681, -0.505, 0.62, { range = 2 })
dp.anchor.use_pnt_x = -0.037318699
dp.anchor.use_pnt_y = 0.125
dp.anchor.use_pnt_z = 0
dp.anchor.use_rot_x = 0
dp.anchor.use_rot_y = -165.627
dp.anchor.use_rot_z = 0
dp.anchor.lookAt = function(arg1) -- line 152
    if ei.ship_ripped then
        manny:say_line("/eima009/")
    elseif ei.sa.state == "up" then
        if ei.anchors_hooked then
            start_script(ei.anchor_talk, "locked")
        else
            start_script(ei.anchor_talk, "up")
        end
    else
        start_script(ei.anchor_talk, "down")
    end
end
dp.anchor.pickUp = function(arg1) -- line 168
    system.default_response("reach")
end
dp.anchor.use = dp.anchor.pickUp
dp.anchor.use_scythe = function(arg1) -- line 174
    local local1 = 0
    if ei.ship_ripped then
        manny:say_line("/eima009/")
    else
        START_CUT_SCENE()
        if ei.sa.state == "up" then
            if ei.anchors_hooked then
                ei.pa.state = "portholed"
                hooked_porthole = dp.anchor
                MakeSectorActive("dp_wall", TRUE)
                manny:walkto(0.0173187, 0.176, 0, 0, 180, 0)
                manny:wait_for_actor()
                stop_script(monitor_star_anchor_state)
                stop_script(monitor_port_anchor_state)
                star_anchor:set_chore_looping(anchors_upr_sway, FALSE)
                star_hook:set_chore_looping(anchors_lower_sway, FALSE)
                star_anchor:wait_for_chore()
                star_hook:wait_for_chore()
                SetActorClipActive(manny.hActor, FALSE)
                manny:push_costume("mn_hook_anchors.cos")
                manny:stop_chore(mn2_hold_scythe, "mn2.cos")
                manny:play_chore(0)
                star_anchor:stop_chore(anchors_upr_sway)
                star_hook:stop_chore(anchors_lower_sway)
                star_anchor:play_chore(anchors_upr_hooked)
                star_hook:play_chore(anchors_lower_hooked)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:walkto(0.0014863299, 0.36675799, 0, 0, -175, 0)
                SetActorClipActive(manny.hActor, TRUE)
                MakeSectorActive("dp_wall", FALSE)
                manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
                start_script(show_hooked_anchor, star_anchor)
                start_script(ei.anchor_talk, "there")
            else
                MakeSectorActive("dp_wall", TRUE)
                manny:walkto(-0.104396, 0.220246, 0, 0, -208.562, 0)
                manny:wait_for_actor()
                manny:head_look_at(manny)
                manny:play_chore(mn2_lft_on_obj, "mn2.cos")
                manny:wait_for_chore()
                start_sfx("anchup.wav")
                repeat
                    pos = star_anchor:getpos()
                    local1 = local1 + 0.1
                    pos.z = pos.z - PerSecond(local1)
                    if pos.z < 0.30000001 then
                        pos.z = 0.30000001
                    end
                    star_anchor:setpos(pos.x, pos.y, pos.z)
                    break_here()
                until pos.z == 0.30000001
                stop_sound("anchup.wav")
                manny:play_chore(mn2_lft_off, "mn2.cos")
                manny:wait_for_chore()
                manny:walkto(0.0173187, 0.176, 0, 0, 180, 0)
                manny:wait_for_actor()
                SetActorClipActive(manny.hActor, FALSE)
                manny:push_costume("mn_hook_anchors.cos")
                manny:stop_chore(mn2_hold_scythe, "mn2.cos")
                manny:play_chore(1)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
                manny:walkto(-0.104396, 0.220246, 0, 0, -208.562, 0)
                manny:wait_for_actor()
                manny:head_look_at(manny)
                manny:play_chore(mn2_lft_on_obj, "mn2.cos")
                manny:wait_for_chore()
                SetActorClipActive(manny.hActor, TRUE)
                start_sfx("anchup.wav")
                local1 = 0
                repeat
                    pos = star_anchor:getpos()
                    local1 = local1 + 0.1
                    pos.z = pos.z + PerSecond(local1)
                    if pos.z > 0.76789999 then
                        pos.z = 0.76789999
                    end
                    star_anchor:setpos(pos.x, pos.y, pos.z)
                    break_here()
                until pos.z == 0.76789999
                stop_sound("anchup.wav")
                manny:play_chore(mn2_lft_off, "mn2.cos")
                manny:wait_for_chore()
                manny:walkto(0.0014863299, 0.36675799, 0, 0, -175, 0)
                MakeSectorActive("dp_wall", FALSE)
                system.default_response("frustrated")
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
dp.ei_door = Object:create(dp, "/dptx002/door", -0.60294801, 0.13393299, 0, { range = 0.60000002 })
dp.ei_door.use_pnt_x = -0.60294801
dp.ei_door.use_pnt_y = 0.13393299
dp.ei_door.use_pnt_z = 0
dp.ei_door.use_rot_x = 0
dp.ei_door.use_rot_y = -171.37199
dp.ei_door.use_rot_z = 0
dp.ei_door:make_untouchable()
dp.ei_box = dp.ei_door
dp.ei_door.walkOut = function(arg1) -- line 302
    ei:come_out_door(ei.dp_door)
end

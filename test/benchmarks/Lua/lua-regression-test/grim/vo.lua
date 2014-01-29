CheckFirstTime("vo.lua")
dofile("mn_lift_ax.lua")
dofile("meche_in_vi.lua")
vo = Set:create("vo.set", "outer vault", { vo_overhead = 0, vo_intha = 1, vo_amrms = 2 })
vault_meche_init = function() -- line 15
    meche:set_walk_chore(meche_in_vi_walk, "meche_in_vi.cos")
    meche:set_rest_chore(meche_in_vi_hands_down_hold, "meche_in_vi.cos")
end
aa = function() -- line 21
    start_script(vo.open_secret_door)
end
vo.open_secret_door = function() -- line 25
    local local1
    cur_puzzle_state[40] = TRUE
    START_CUT_SCENE()
    manny:walkto(-0.079352997, 0.39862201, 0, 0, -86.685699, 0)
    manny:wait_for_actor()
    manny:push_costume("mn_scythe_door.cos")
    manny:stop_chore(mn2_hold_scythe, "mn2.cos")
    manny:play_chore(mn_scythe_door_to_scythe_short)
    manny:wait_for_chore()
    StartMovie("vo_vault.snm", nil, 320, 90)
    vo.secret_door:make_touchable()
    vo.secret_door.opened = TRUE
    vo:update_states()
    manny:play_chore(mn_scythe_door_stop_scythe_short)
    manny:wait_for_chore()
    manny:pop_costume()
    manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
    wait_for_movie()
    wait_for_message()
    meche:set_costume("meche_sit.cos")
    meche:set_mumble_chore(meche_sit_mumble)
    meche:set_talk_chore(1, meche_sit_no_talk)
    meche:set_talk_chore(2, meche_sit_a)
    meche:set_talk_chore(3, meche_sit_c)
    meche:set_talk_chore(4, meche_sit_e)
    meche:set_talk_chore(5, meche_sit_f)
    meche:set_talk_chore(6, meche_sit_l)
    meche:set_talk_chore(7, meche_sit_m)
    meche:set_talk_chore(8, meche_sit_o)
    meche:set_talk_chore(9, meche_sit_t)
    meche:set_talk_chore(10, meche_sit_u)
    meche:push_costume("meche_in_vi.cos")
    meche:put_in_set(vo)
    meche:setpos(-1.47453, 1.4645, 0)
    meche:setrot(0, -152.509, 0)
    meche:set_walk_rate(0.30000001)
    meche:follow_boxes()
    meche.footsteps = footsteps.reverb
    meche:play_chore_looping(meche_in_vi_walk, "meche_in_vi.cos")
    local local2 = start_script(meche.walkto, meche, -1.27968, 1.1593, 0, 0, -129.48, 0)
    wait_for_script(local2)
    meche:stop_chore(meche_in_vi_walk, "meche_in_vi.cos")
    meche:play_chore(meche_in_vi_hands_down_hold, "meche_in_vi.cos")
    manny:head_look_at(nil)
    manny:turn_right(180)
    meche:say_line("/vomc001/")
    wait_for_message()
    meche:say_line("/vomc003/")
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
    wait_for_message()
    manny:say_line("/voma004/")
    wait_for_message()
    manny:say_line("/voma005/")
    meche:play_chore(meche_in_vi_drop_hands)
    meche:wait_for_chore()
    meche:play_chore_looping(meche_in_vi_walk)
    meche:walkto(-1.47453, 1.4645, 0)
    wait_for_message()
    meche:say_line("/vomc006/")
    wait_for_message()
    meche:free()
    END_CUT_SCENE()
end
vo.close_safe = function() -- line 94
    START_CUT_SCENE()
    vd.door_open = FALSE
    vd.tumblers.alligned = FALSE
    vd.tumblers.secured = FALSE
    vd.tumblers:make_touchable()
    vd.wheel:make_touchable()
    vd.handle:make_touchable()
    vo.vd_door:lock()
    manny:walkto_object(vo.open_door)
    manny:wait_for_actor()
    manny:set_rest_chore(-1)
    manny:play_chore(ms_hand_on_obj, "mn2.cos")
    manny:wait_for_chore()
    manny:play_chore(ms_hand_off_obj, "mn2.cos")
    StartMovie("vo_safe.snm", nil, 0, 120)
    wait_for_movie()
    vo:update_states()
    manny:wait_for_actor()
    manny:set_rest_chore(ms_rest, "mn2.cos")
    manny:say_line("/voma007/")
    wait_for_message()
    manny:say_line("/voma008/")
    wait_for_message()
    manny:say_line("/voma009/")
    END_CUT_SCENE()
end
vo.get_axe = function() -- line 122
    START_CUT_SCENE()
    start_script(vo.lockup_watcher)
    if system.currentSet == vo then
        manny:walkto_object(vo.broadaxe)
        MakeSectorActive("noax1", FALSE)
        MakeSectorActive("noax2", FALSE)
        MakeSectorActive("noax3", FALSE)
        MakeSectorActive("noax4", FALSE)
        MakeSectorActive("noax5", FALSE)
        MakeSectorActive("noax6", FALSE)
        MakeSectorActive("noax7", FALSE)
        MakeSectorActive("noax8", FALSE)
        MakeSectorActive("noax9", FALSE)
        MakeSectorActive("noax10", FALSE)
        MakeSectorActive("noax11", FALSE)
        MakeSectorActive("under_door", FALSE)
        if not vd.door_open then
            MakeSectorActive("door_open", TRUE)
            MakeSectorActive("door_open2", TRUE)
        else
            MakeSectorActive("door_open", FALSE)
            MakeSectorActive("door_open2", FALSE)
        end
        if vo.secret_door.opened then
            MakeSectorActive("axe_exit", TRUE)
            MakeSectorActive("secret_pass1", FALSE)
            MakeSectorActive("secret_pass2", FALSE)
        else
            MakeSectorActive("axe_exit", FALSE)
        end
    else
        manny:walkto_object(vi.broadaxe)
        MakeSectorActive("noax1", FALSE)
        MakeSectorActive("noax2", FALSE)
        MakeSectorActive("noax3", FALSE)
        MakeSectorActive("noax4", FALSE)
    end
    manny:wait_for_actor()
    manny:follow_boxes()
    manny.base_costume = "mn2.cos"
    manny.gesture_costume = "mn_gestures.cos"
    manny:set_costume(manny.base_costume)
    manny:set_walk_rate(0.4)
    manny:set_mumble_chore(mn2_mumble)
    manny:set_talk_chore(1, mn2_stop_talk)
    manny:set_talk_chore(2, mn2_a)
    manny:set_talk_chore(3, mn2_c)
    manny:set_talk_chore(4, mn2_e)
    manny:set_talk_chore(5, mn2_f)
    manny:set_talk_chore(6, mn2_l)
    manny:set_talk_chore(7, mn2_m)
    manny:set_talk_chore(8, mn2_o)
    manny:set_talk_chore(9, mn2_t)
    manny:set_talk_chore(9, mn2_u)
    manny:set_turn_rate(85)
    manny.talk_chore = ms_talk
    manny.stop_talk_chore = ms_stop_talk
    manny:push_costume("mn_lift_ax.cos")
    manny:play_chore(mn_lift_ax_lift_ax)
    sleep_for(1300)
    start_sfx("voAxGet.wav")
    vo_axe:set_visibility(FALSE)
    SetActorReflection(manny.hActor, 90)
    manny:wait_for_chore()
    END_CUT_SCENE()
    manny.idles_allowed = FALSE
    manny_has_axe = TRUE
    inventory_disabled = TRUE
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = axeButtonHandler
    vo.broadaxe:make_untouchable()
    vi.broadaxe:make_untouchable()
    manny:set_walk_chore(nil)
    manny:set_rest_chore(nil)
    manny:stop_chore(mn_lift_ax_lift_ax, "mn_lift_ax.cos")
    manny:play_chore_looping(mn_lift_ax_hold_ax, "mn_lift_ax.cos")
    if vo.secret_door.opened then
        PrintDebug("constraining")
        start_script(vo.exit_with_axe)
    end
end
vo.lower_axe = function() -- line 213
    local local1 = { }
    local local2 = { }
    local local3 = { x = 0.0103, y = 0.3971, z = 0 }
    local local4 = { }
    START_CUT_SCENE()
    vo.stop_turn()
    vo.stop_walk()
    manny:stop_chore(mn_lift_ax_hold_ax)
    manny:play_chore(mn_lift_ax_lower_ax)
    sleep_for(1000)
    local1 = manny:getpos()
    local2 = manny:get_positive_rot()
    vo_axe:setpos(local1)
    vo_axe:setrot(local2)
    vo_axe.pos_x = local1.x
    vo_axe.pos_y = local1.y
    vo_axe.pos_z = local1.z
    vo_axe.rot_x = local2.x
    vo_axe.rot_y = local2.y
    vo_axe.rot_z = local2.z
    vo_axe.currentSet = system.currentSet
    vo_axe:set_visibility(TRUE)
    vo_axe:put_in_set(system.currentSet)
    local4 = RotateVector(local3, local2)
    local4.x = local4.x + local1.x
    local4.y = local4.y + local1.y
    local4.z = local4.z + local1.z
    if system.currentSet == vo then
        vo.broadaxe:make_touchable()
        vo.broadaxe.interest_actor:put_in_set(vo)
        vo.broadaxe.obj_x = local4.x
        vo.broadaxe.obj_y = local4.y
        vo.broadaxe.obj_z = local4.z
        vo.broadaxe.interest_actor:setpos(local4)
        vo.broadaxe.use_pnt_x = local1.x
        vo.broadaxe.use_pnt_y = local1.y
        vo.broadaxe.use_pnt_z = local1.z
        vo.broadaxe.use_rot_x = local2.x
        vo.broadaxe.use_rot_y = local2.y
        vo.broadaxe.use_rot_z = local2.z
    else
        vi.broadaxe:make_touchable()
        vi.broadaxe.interest_actor:put_in_set(vi)
        vi.broadaxe.obj_x = local4.x
        vi.broadaxe.obj_y = local4.y
        vi.broadaxe.obj_z = local4.z
        vi.broadaxe.interest_actor:setpos(local4)
        vi.broadaxe.use_pnt_x = local1.x
        vi.broadaxe.use_pnt_y = local1.y
        vi.broadaxe.use_pnt_z = local1.z
        vi.broadaxe.use_rot_x = local2.x
        vi.broadaxe.use_rot_y = local2.y
        vi.broadaxe.use_rot_z = local2.z
    end
    manny_has_axe = FALSE
    if system.currentSet == vo then
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
        MakeSectorActive("noax4", TRUE)
        MakeSectorActive("noax5", TRUE)
        MakeSectorActive("noax6", TRUE)
        MakeSectorActive("noax7", TRUE)
        MakeSectorActive("noax8", TRUE)
        MakeSectorActive("noax9", TRUE)
        MakeSectorActive("noax10", TRUE)
        MakeSectorActive("noax11", TRUE)
        vo:update_states()
    else
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
        MakeSectorActive("noax4", TRUE)
    end
    manny:wait_for_chore()
    manny:default("nautical")
    manny:follow_boxes()
    END_CUT_SCENE()
    manny.idles_allowed = TRUE
    SetActorReflection(manny.hActor, 60)
    inventory_disabled = FALSE
    system.buttonHandler = inventory_save_handler
    manny:head_look_at(nil)
end
vo.turn_left = function() -- line 313
    local local1 = { }
    manny:play_chore_looping(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
    start_sfx("voAxTDrg.imu")
    while 1 do
        local1 = manny:getrot()
        manny:setrot(local1.x, local1.y + 10, local1.z, TRUE)
        break_here()
    end
end
vo.turn_right = function() -- line 326
    local local1 = { }
    manny:play_chore_looping(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
    start_sfx("voAxTDrg.imu")
    while 1 do
        local1 = manny:getrot()
        manny:setrot(local1.x, local1.y - 10, local1.z, TRUE)
        break_here()
    end
end
vo.walk_backward = function() -- line 338
    manny:set_walk_rate(-0.2)
    manny:play_chore_looping(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
    start_sfx("voAxBDrg.imu")
    while 1 do
        manny:walk_forward()
        break_here()
    end
end
vo.stop_turn = function() -- line 348
    stop_script(vo.turn_left)
    stop_script(vo.turn_right)
    stop_sound("voAxTDrg.imu")
    if not find_script(vo.walk_backward) then
        manny:stop_chore(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
        manny:play_chore_looping(mn_lift_ax_hold_ax, "mn_lift_ax.cos")
    end
end
vo.stop_walk = function() -- line 358
    stop_script(vo.walk_backward)
    stop_sound("voAxBDrg.imu")
    if not find_script(vo.turn_left) and not find_script(vo.turn_right) then
        manny:stop_chore(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
        manny:play_chore_looping(mn_lift_ax_hold_ax, "mn_lift_ax.cos")
    end
end
vo.exit_with_axe = function() -- line 367
    while manny_has_axe do
        repeat
            break_here()
        until manny:find_sector_name("axe_exit")
        vo.manny_exiting = TRUE
        vo.stop_turn()
        if system.currentSet == vo then
            vo.secret_door:use()
        else
            vi.vo_door:walkOut()
        end
        while manny:find_sector_name("axe_exit") do
            break_here()
        end
        vo.manny_exiting = FALSE
    end
end
vo.lockup_watcher = function() -- line 386
    while manny_has_axe do
        if manny:find_sector_name("secret_door") then
            vo.secret_door:walkOut()
        elseif manny:find_sector_name("vo_door") then
            vi.vo_door:walkOut()
        end
    end
end
axeButtonHandler = function(arg1, arg2, arg3) -- line 396
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if arg1 == EKEY and controlKeyDown and arg2 then
        single_start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.OVERRIDE[arg1] and arg2 and curSceneLevel <= 0 then
        single_start_script(vo.lower_axe)
    elseif control_map.TURN_RIGHT[arg1] and cutSceneLevel <= 0 and not vo.manny_exiting then
        if arg2 then
            single_start_script(vo.turn_right)
        else
            single_start_script(vo.stop_turn)
        end
    elseif control_map.TURN_LEFT[arg1] and cutSceneLevel <= 0 and not vo.manny_exiting then
        if arg2 then
            single_start_script(vo.turn_left)
        else
            single_start_script(vo.stop_turn)
        end
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vo.broadaxe.lookAt, vo.broadaxe)
    elseif control_map.MOVE_BACKWARD[arg1] and cutSceneLevel <= 0 then
        if arg2 then
            single_start_script(vo.walk_backward)
        else
            single_start_script(vo.stop_walk)
        end
    elseif control_map.USE[arg1] and arg2 and cutSceneLevel <= 0 and not vo.manny_exiting then
        single_start_script(vo.drop_axe)
    elseif control_map.PICK_UP[arg1] and arg2 and cutSceneLevel <= 0 and not vo.manny_exiting then
        single_start_script(vo.lower_axe)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
drop_test = function() -- line 436
    local local1 = { x = -0.236279, y = -0.387934, z = 0 }
    local local2 = { }
    local local3 = { }
    local local4 = manny:getpos()
    local local5
    local local6 = sqrt((local4.x - local1.x) ^ 2 + (local4.y - local1.y) ^ 2 + (local4.z - local1.z) ^ 2)
    local2.x = local1.x - local4.x
    local2.y = local1.y - local4.y
    local2.z = local1.z - local4.z
    local3.x, local3.y, local3.z = GetActorPuckVector(manny.hActor)
    local2 = normalize_vector(local2)
    local3 = normalize_vector(local3)
    local5 = GetAngleBetweenVectors(local3, local2)
    if system.currentSet == vi and local6 > 0.15000001 and local6 < 0.43000001 and local5 <= 30 then
        return TRUE
    end
end
vo.drop_axe = function() -- line 458
    local local1 = { }
    local local2 = { }
    local local3 = { x = 0.0103, y = 0.3971, z = 0 }
    local local4 = { }
    local local5 = { x = -0.236279, y = -0.387934, z = 0 }
    START_CUT_SCENE()
    vo.stop_turn()
    vo.stop_walk()
    manny:stop_chore(mn_lift_ax_hold_ax)
    manny:play_chore(mn_lift_ax_pickup_ax)
    manny:say_line("/voma010/")
    sleep_for(3500)
    local1 = manny:getpos()
    local2 = manny:get_positive_rot()
    vo_axe:setpos(local1)
    vo_axe:setrot(local2)
    vo_axe.pos_x = local1.x
    vo_axe.pos_y = local1.y
    vo_axe.pos_z = local1.z
    vo_axe.rot_x = local2.x
    vo_axe.rot_y = local2.y
    vo_axe.rot_z = local2.z
    vo_axe:put_in_set(system.currentSet)
    vo_axe.currentSet = system.currentSet
    local4 = RotateVector(local3, local2)
    local4.x = local4.x + local1.x
    local4.y = local4.y + local1.y
    local4.z = local4.z + local1.z
    if system.currentSet == vo then
        vo.broadaxe:make_touchable()
        vo.broadaxe.interest_actor:put_in_set(vo)
        vo.broadaxe.obj_x = local4.x
        vo.broadaxe.obj_y = local4.y
        vo.broadaxe.obj_z = local4.z
        vo.broadaxe.interest_actor:setpos(local4)
        vo.broadaxe.use_pnt_x = local1.x
        vo.broadaxe.use_pnt_y = local1.y
        vo.broadaxe.use_pnt_z = local1.z
        vo.broadaxe.use_rot_x = local2.x
        vo.broadaxe.use_rot_y = local2.y
        vo.broadaxe.use_rot_z = local2.z
    else
        vi.broadaxe:make_touchable()
        vi.broadaxe.interest_actor:put_in_set(vi)
        vi.broadaxe.obj_x = local4.x
        vi.broadaxe.obj_y = local4.y
        vi.broadaxe.obj_z = local4.z
        vi.broadaxe.interest_actor:setpos(local4)
        vi.broadaxe.use_pnt_x = local1.x
        vi.broadaxe.use_pnt_y = local1.y
        vi.broadaxe.use_pnt_z = local1.z
        vi.broadaxe.use_rot_x = local2.x
        vi.broadaxe.use_rot_y = local2.y
        vi.broadaxe.use_rot_z = local2.z
    end
    local local6 = drop_test()
    sleep_for(500)
    if local6 then
        start_sfx("voAxBrk.wav")
        vi.break_tile()
    else
        start_sfx("voAxDrop.wav")
    end
    manny:wait_for_chore()
    vo_axe:set_visibility(TRUE)
    manny:default("nautical")
    manny_has_axe = FALSE
    manny.idles_allowed = TRUE
    inventory_disabled = FALSE
    system.buttonHandler = inventory_save_handler
    SetActorReflection(manny.hActor, 60)
    if system.currentSet == vo then
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
        MakeSectorActive("noax4", TRUE)
        MakeSectorActive("noax5", TRUE)
        MakeSectorActive("noax6", TRUE)
        MakeSectorActive("noax7", TRUE)
        MakeSectorActive("noax8", TRUE)
        MakeSectorActive("noax9", TRUE)
        MakeSectorActive("noax10", TRUE)
        MakeSectorActive("noax11", TRUE)
        vo:update_states()
    else
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
        MakeSectorActive("noax4", TRUE)
    end
    END_CUT_SCENE()
    if local6 then
        START_CUT_SCENE()
        vo.get_axe()
        manny:set_walk_rate(-0.2)
        manny:play_chore_looping(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
        local local7 = 0.30000001
        start_sfx("voAxBDrg.imu")
        repeat
            manny:walk_forward()
            local7 = local7 - PerSecond(0.2)
            if local7 < 0 then
                local7 = 0
            end
            break_here()
        until local7 == 0
        stop_sound("voAxBDrg.imu")
        manny:stop_chore(mn_lift_ax_drag_ax, "mn_lift_ax.cos")
        manny:play_chore_looping(mn_lift_ax_hold_ax, "mn_lift_ax.cos")
        vo.lower_axe()
        start_script(vi.escape_safe)
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        wait_for_message()
        manny:say_line("/voma011/")
        if not vo.broadaxe.dropped then
            vo.broadaxe.dropped = TRUE
            wait_for_message()
            manny:say_line("/voma012/")
        end
        END_CUT_SCENE()
    end
    manny:follow_boxes()
end
vo.update_states = function(arg1) -- line 602
    if vd.door_open then
        vo.open_door:make_touchable()
        MakeSectorActive("safe_passage", TRUE)
        MakeSectorActive("under_door", FALSE)
        vo.open_door:play_chore(1)
    else
        vo.open_door:make_untouchable()
        MakeSectorActive("safe_passage", FALSE)
        MakeSectorActive("under_door", TRUE)
        vo.open_door:play_chore(0)
    end
    if vo.secret_door.opened then
        vo.secret_door:make_touchable()
        vo.drawers3.parent = Object
        vo.drawers3:make_untouchable()
        MakeSectorActive("secret_pass1", TRUE)
        MakeSectorActive("secret_pass2", TRUE)
        vo.secret_door:play_chore(0)
    else
        MakeSectorActive("axe_exit", FALSE)
        vo.secret_door:make_untouchable()
        vo.drawers3:make_touchable()
        MakeSectorActive("secret_pass1", FALSE)
        MakeSectorActive("secret_pass2", FALSE)
        vo.secret_door:play_chore(1)
    end
    if manny_has_axe then
        MakeSectorActive("noax1", FALSE)
        MakeSectorActive("noax2", FALSE)
        MakeSectorActive("noax3", FALSE)
        MakeSectorActive("noax4", FALSE)
        MakeSectorActive("noax5", FALSE)
        MakeSectorActive("noax6", FALSE)
        MakeSectorActive("noax7", FALSE)
        MakeSectorActive("noax8", FALSE)
        MakeSectorActive("noax9", FALSE)
        MakeSectorActive("noax10", FALSE)
        MakeSectorActive("noax11", FALSE)
        MakeSectorActive("under_door", FALSE)
        if not vd.door_open then
            MakeSectorActive("door_open", TRUE)
            MakeSectorActive("door_open2", TRUE)
        else
            MakeSectorActive("door_open", FALSE)
            MakeSectorActive("door_open2", FALSE)
        end
        if vo.secret_door.opened then
            MakeSectorActive("axe_exit", TRUE)
            MakeSectorActive("secret_pass1", FALSE)
            MakeSectorActive("secret_pass2", FALSE)
        else
            MakeSectorActive("axe_exit", FALSE)
        end
    else
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
        MakeSectorActive("noax4", TRUE)
        MakeSectorActive("noax5", TRUE)
        MakeSectorActive("noax6", TRUE)
        MakeSectorActive("noax7", TRUE)
        MakeSectorActive("noax8", TRUE)
        MakeSectorActive("noax9", TRUE)
        MakeSectorActive("noax10", TRUE)
        MakeSectorActive("noax11", TRUE)
    end
end
vo.enter = function(arg1) -- line 681
    NewObjectState(vo_intha, OBJSTATE_STATE, "vo_safe.bm", "vo_safe.zbm")
    vo.open_door:set_object_state("vo_door.cos")
    NewObjectState(vo_intha, OBJSTATE_STATE, "vo_secret.bm", "vo_secret.zbm")
    vo.secret_door:set_object_state("vo_secret.cos")
    if not vo_axe then
        vo_axe = Actor:create(nil, nil, nil, "axe")
        vo_axe.pos_x = -0.57863
        vo_axe.pos_y = 1.52808
        vo_axe.pos_z = 0
        vo_axe.rot_x = 0
        vo_axe.rot_y = 320
        vo_axe.rot_z = 0
        vo_axe.currentSet = system.currentSet
    end
    if vo_axe.currentSet == system.currentSet then
        vo_axe:put_in_set(vo)
        vo_axe:setpos(vo_axe.pos_x, vo_axe.pos_y, vo_axe.pos_z)
        vo_axe:setrot(vo_axe.rot_x, vo_axe.rot_y, vo_axe.rot_z)
        vo_axe:set_costume("mn_lift_ax.cos")
        vo_axe:play_chore(3)
    end
    vo:update_states()
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
vo.exit = function(arg1) -- line 718
    meche:free()
    KillActorShadows(manny.hActor)
end
vo.open_door = Object:create(vo, "/votx013/vault door", -0.35592201, 0.36448601, 0.3461, { range = 0.60000002 })
vo.open_door.use_pnt_x = -0.48652199
vo.open_door.use_pnt_y = 0.61648601
vo.open_door.use_pnt_z = 0
vo.open_door.use_rot_x = 0
vo.open_door.use_rot_y = 216.981
vo.open_door.use_rot_z = 0
vo.open_door.lookAt = function(arg1) -- line 737
    manny:say_line("/voma014/")
end
vo.open_door.use = function(arg1) -- line 741
    vo.close_safe()
end
vo.open_door.use_chisel = function(arg1) -- line 745
    manny:say_line("/voma015/")
end
vo.wall_tab = Object:create(vo, "/votx016/metal tab", 0.14598399, 0.031533599, 0.58999997, { range = 0.80000001 })
vo.wall_tab.use_pnt_x = 0.095983997
vo.wall_tab.use_pnt_y = 0.15153401
vo.wall_tab.use_pnt_z = 0
vo.wall_tab.use_rot_x = 0
vo.wall_tab.use_rot_y = -6996.23
vo.wall_tab.use_rot_z = 0
vo.wall_tab.lookAt = function(arg1) -- line 757
    soft_script()
    if vd.door_open then
        manny:say_line("/voma017/")
    else
        manny:say_line("/voma018/")
    end
end
vo.wall_tab.use = function(arg1) -- line 767
    soft_script()
    manny:say_line("/voma019/")
    wait_for_message()
    manny:say_line("/voma020/")
end
vo.wall_tab.use_chisel = function(arg1) -- line 774
    manny:say_line("/voma021/")
end
vo.wall_tab.pickUp = vo.wall_tab.use
vo.wall_tab.use_scythe = function(arg1) -- line 780
    if vd.door_open then
        START_CUT_SCENE()
        manny:walkto(-0.079353, 0.398622, 0, 0, -86.6857, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_scythe_door.cos")
        manny:stop_chore(mn2_hold_scythe, "mn2.cos")
        manny:play_chore(mn_scythe_door_to_scythe_short)
        manny:wait_for_chore()
        manny:play_chore(mn_scythe_door_stop_scythe_short)
        manny:wait_for_chore()
        manny:pop_costume()
        manny:play_chore_looping(mn2_hold_scythe, "mn2.cos")
        END_CUT_SCENE()
    elseif vo.secret_door.opened then
        system.default_response("shed light")
    else
        start_script(vo.open_secret_door)
    end
end
vo.drawers1 = Object:create(vo, "/votx022/drawers", -1.2701401, 0.224554, 0.41, { range = 0.69999999 })
vo.drawers1.use_pnt_x = -1.32014
vo.drawers1.use_pnt_y = 0.59455401
vo.drawers1.use_pnt_z = 0
vo.drawers1.use_rot_x = 0
vo.drawers1.use_rot_y = -5622.98
vo.drawers1.use_rot_z = 0
vo.drawers1.lookAt = function(arg1) -- line 811
    soft_script()
    manny:say_line("/voma023/")
    wait_for_message()
    manny:say_line("/voma024/")
end
vo.drawers1.use = function(arg1) -- line 818
    soft_script()
    manny:say_line("/voma025/")
    wait_for_message()
    manny:say_line("/voma026/")
end
vo.drawers1.pickUp = vo.drawers1.use
vo.drawers1.use_scythe = function(arg1) -- line 827
    soft_script()
    manny:say_line("/voma028/")
end
vo.drawers1.use_chisel = function(arg1) -- line 832
    START_CUT_SCENE()
    manny:walkto(-1.32288, 0.557319, 0, 0, 120, 0)
    manny:wait_for_actor()
    mn.chisel:use()
    manny:say_line("/voma029/")
    wait_for_message()
    manny:say_line("/voma030/")
    END_CUT_SCENE()
end
vo.drawers2 = Object:create(vo, "/votx031/drawers", -1.57014, 0.59455401, 0.80000001, { range = 1 })
vo.drawers2.use_pnt_x = -1.32014
vo.drawers2.use_pnt_y = 0.59455401
vo.drawers2.use_pnt_z = 0
vo.drawers2.use_rot_x = 0
vo.drawers2.use_rot_y = -5622.98
vo.drawers2.use_rot_z = 0
vo.drawers2.parent = vo.drawers1
vo.drawers3 = Object:create(vo, "/votx032/drawers", -1.61014, 0.94455397, 0.47999999, { range = 0.80000001 })
vo.drawers3.use_pnt_x = -1.32014
vo.drawers3.use_pnt_y = 0.59455401
vo.drawers3.use_pnt_z = 0
vo.drawers3.use_rot_x = 0
vo.drawers3.use_rot_y = -5677.6802
vo.drawers3.use_rot_z = 0
vo.drawers3.parent = vo.drawers1
vo.drawers4 = Object:create(vo, "/votx033/drawers", -1.23141, 2.04703, 0.40000001, { range = 0.69999999 })
vo.drawers4.use_pnt_x = -1.08946
vo.drawers4.use_pnt_y = 1.77124
vo.drawers4.use_pnt_z = 0
vo.drawers4.use_rot_x = 0
vo.drawers4.use_rot_y = 1146.3
vo.drawers4.use_rot_z = 0
vo.drawers4.parent = vo.drawers1
vo.suit = Object:create(vo, "/votx034/suit of armor", 0.041497, 1.7197, 0.68000001, { range = 0.80000001 })
vo.suit.use_pnt_x = -0.338503
vo.suit.use_pnt_y = 1.7596999
vo.suit.use_pnt_z = 0
vo.suit.use_rot_x = 0
vo.suit.use_rot_y = -5499.7402
vo.suit.use_rot_z = 0
vo.suit.lookAt = function(arg1) -- line 883
    manny:say_line("/voma035/")
end
vo.suit.pickUp = function(arg1) -- line 887
    manny:say_line("/voma036/")
end
vo.suit.use = function(arg1) -- line 891
    if arg1.has_axe then
        vo.get_axe()
    elseif not vo.secret_door.opened then
        START_CUT_SCENE()
        soft_script()
        manny:walkto(-0.0789884, 1.60599, 0, 0, -43, 0)
        manny:wait_for_actor()
        manny:knock_on_door_anim()
        manny:say_line("/voma037/")
        wait_for_message()
        manny:say_line("/voma038/")
        wait_for_message()
        manny:say_line("/voma039/")
        END_CUT_SCENE()
    else
        manny:say_line("/voma040/")
    end
end
vo.suit.use_scythe = function(arg1) -- line 913
    START_CUT_SCENE()
    manny:walkto(-0.361878, 1.74097, 0, 0, -60, 0)
    manny:play_chore(mn2_use_obj, "mn2.cos")
    manny:say_line("/voma041/")
    manny:wait_for_chore()
    manny:stop_chore(mn2_use_obj, "mn2.cos")
    END_CUT_SCENE()
end
vo.suit.use_chisel = function(arg1) -- line 923
    manny:say_line("/voma042/")
end
vo.broadaxe = Object:create(vo, "/votx043/broadaxe", -0.57862997, 1.52808, 0, { range = 0.5 })
vo.broadaxe.use_pnt_x = -0.57862997
vo.broadaxe.use_pnt_y = 1.52808
vo.broadaxe.use_pnt_z = 0
vo.broadaxe.use_rot_x = 0
vo.broadaxe.use_rot_y = 320
vo.broadaxe.use_rot_z = 0
vo.broadaxe.lookAt = function(arg1) -- line 935
    manny:say_line("/voma044/")
end
vo.broadaxe.pickUp = function(arg1) -- line 940
    vo.get_axe()
end
vo.broadaxe.use = function(arg1) -- line 944
    vo.get_axe()
end
vo.broadaxe.put_away = vo.broadaxe.use
vo.broadaxe.default_response = vo.broadaxe.use
vo.vd_door = Object:create(vo, "/votx045/door", -0.0043929298, -0.53289002, 0.41999999, { range = 0.80000001 })
vo.vd_door.use_pnt_x = 0.0096925097
vo.vd_door.use_pnt_y = 0.103199
vo.vd_door.use_pnt_z = 0
vo.vd_door.use_rot_x = 0
vo.vd_door.use_rot_y = -7021.1201
vo.vd_door.use_rot_z = 0
vo.vd_door.out_pnt_x = 0.0057194601
vo.vd_door.out_pnt_y = -0.1
vo.vd_door.out_pnt_z = 0
vo.vd_door.out_rot_x = 0
vo.vd_door.out_rot_y = -7021.1201
vo.vd_door.out_rot_z = 0
vo.vd_box = vo.vd_door
vo.vd_door.walkOut = function(arg1) -- line 974
    if vd.door_open then
        vd:come_out_door(vd.vo_door)
        vd:current_setup(vd_safex)
    else
        arg1:locked_out()
    end
end
vo.vd_door.locked_out = function(arg1) -- line 983
    manny:say_line("/voma046/")
end
vo.vd_door.lookAt = function(arg1) -- line 987
    if vd.door_open then
        manny:say_line("/voma047/")
    else
        arg1:locked_out()
    end
end
vo.secret_door = Object:create(vo, "/votx048/secret door", -1.64437, 1.08671, 0.47, { range = 0.60000002 })
vo.secret_door.use_pnt_x = -1.40437
vo.secret_door.use_pnt_y = 1.06671
vo.secret_door.use_pnt_z = 0
vo.secret_door.use_rot_x = 0
vo.secret_door.use_rot_y = -274.26501
vo.secret_door.use_rot_z = 0
vo.secret_door.out_pnt_x = -1.675
vo.secret_door.out_pnt_y = 1.03729
vo.secret_door.out_pnt_z = 0
vo.secret_door.out_rot_x = 0
vo.secret_door.out_rot_y = -273.17499
vo.secret_door.out_rot_z = 0
vo.secret_door:make_untouchable()
vo.secret_door.lookAt = function(arg1) -- line 1012
    manny:say_line("/voma049/")
end
vo.secret_door.use = function(arg1) -- line 1017
    if manny_has_axe then
        vi:switch_to_set()
        manny:setpos(0.403806, -0.296262, 0)
        manny:setrot(0, -810, 0)
        manny:put_in_set(vi)
        vo_axe:put_in_set(vi)
        vo.broadaxe:make_untouchable()
        vi.broadaxe:make_touchable()
    else
        vi:come_out_door(vi.vo_door)
    end
end
vo.secret_door.walkOut = vo.secret_door.use

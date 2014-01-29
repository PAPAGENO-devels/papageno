CheckFirstTime("mf.lua")
mf = Set:create("mf.set", "Meadow Flowers", { mf_medoh = 0, mf_ovrhd = 1 })
dofile("md_dying.lua")
mf.look_right_point = { x = -0.03975, y = -0.1272, z = 0.456 }
mf.look_left_point = { x = 0.18425, y = -0.1272, z = 0.456 }
mf.look_heart_point = { x = 0.12225, y = -0.2462, z = 0.279 }
mf.look_hand_point = { x = -0.02475, y = -0.3622, z = 0.242 }
mf.roll_head = function() -- line 24
    local local1 = ceil(random() * 2)
    local local2 = 1
    repeat
        manny:head_look_at_point(mf.look_right_point)
        sleep_for(1000 + random() * 1000)
        manny:head_look_at_point(mf.look_left_point)
        sleep_for(1000 + random() * 1000)
        local2 = local2 + 1
    until local2 > local1
    manny:head_look_at(nil)
end
mf.look_at_nitro = function(arg1) -- line 37
    manny:head_look_at_point(mf.look_hand_point)
    manny:say_line("/mfma002/")
    manny:wait_for_message()
    manny:head_look_at(nil)
end
mf.use_grinder = function(arg1) -- line 44
    manny:head_look_at_point(mf.look_hand_point)
    manny:say_line("/mfma003/")
    manny:wait_for_message()
    manny:head_look_at(nil)
end
mf.setup_suffering = function() -- line 51
    manny.dying = TRUE
    manny.shot = TRUE
    mf:switch_to_set()
    manny:put_in_set(mf)
    mo.scythe:free()
    th.grinder:free()
    si.nitrogen:free()
    th.grinder:get()
    si.nitrogen:get()
    th.grinder.has_bone = FALSE
    manny:default()
    manny:ignore_boxes()
    manny:push_costume("md_dying.cos")
    manny:set_softimage_pos(0.7925, 0, 6.212)
    manny:setrot(0, 184.514, 0)
    manny:set_head(3, 4, 5, 165, 45, 80)
    system.buttonHandler = dead_button_handler
    manny:stop_chore()
    manny:play_chore(md_dying_rest, "md_dying.cos")
    start_script(mf.background_moans)
end
mf.moans = { "/mfma004/", "/mfma005/", "/mfma006/", "/mfma007/", "/mfma008/", "/mfma009/" }
mf.background_moans = function() -- line 89
    while 1 do
        sleep_for(6000 + 2000 * random())
        manny:wait_for_message()
        single_start_script(mf.roll_head)
        manny:say_line(pick_one_of(mf.moans, TRUE))
        manny:wait_for_message()
    end
end
mf.continuous_moans = function() -- line 99
    while 1 do
        manny:say_line(pick_one_of(mf.moans, TRUE))
        manny:wait_for_message()
        sleep_for(500)
    end
end
mf.flail_around = function() -- line 107
    stop_script(mf.background_moans)
    single_start_script(mf.continuous_moans)
    manny:run_chore(md_dying_flail, "md_dying.cos")
    stop_script(mf.continuous_moans)
    start_script(mf.background_moans)
end
mf.freeze_heart = function() -- line 115
    START_CUT_SCENE()
    manny:head_look_at(nil)
    stop_script(mf.background_moans)
    stop_script(mf.roll_head)
    stop_script(mf.flail_around)
    stop_script(mf.continuous_moans)
    manny:stop_chore(md_activate_nitro, "md.cos")
    manny:play_chore(md_dying_nitro, "md_dying.cos")
    sleep_for(1500)
    manny:say_line("/mfma010/")
    manny:wait_for_message()
    sleep_for(500)
    manny:say_line("/mfma011/")
    wait_for_message()
    manny:run_chore(md_dying_yank, "md_dying.cos")
    manny:say_line("/mfma012/")
    manny:wait_for_message()
    sleep_for(1000)
    me:switch_to_set()
    manny.is_holding = FALSE
    manny:default()
    manny.healed = TRUE
    manny.dying = FALSE
    manny:put_in_set(me)
    manny:follow_boxes()
    manny:setpos(4.08184, -12.6856, -7.39215)
    manny:setrot(0, 145.507, 0)
    system.buttonHandler = SampleButtonHandler
    single_start_script(WalkManny)
    start_script(me.setup_part2)
    me:current_setup(me_carla)
    manny:head_look_at(nil)
    manny:walkto(5.14629, -14.151, -8.11214)
    manny:wait_for_actor()
    start_script(me.olivia_searching)
    END_CUT_SCENE()
end
dead_button_handler = function(arg1, arg2, arg3) -- line 156
    if cutSceneLevel <= 0 then
        shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
        controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
        altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
        bsKeyDown = GetControlState(BSKEY)
        stopKeyDown(arg1, arg2)
        anyModifierDown = shiftKeyDown or controlKeyDown or altKeyDown or bsKeyDown
        stop_script(mf.continuous_moans)
        if arg1 == KEY1 and arg2 or (arg1 == KEY2 and arg2) or (arg1 == KEY3 and arg2) or (arg1 == KEY4 and arg2) or (arg1 == KEY5 and arg2) or (arg1 == KEY6 and arg2) or (arg1 == KEY7 and arg2) or (arg1 == KEY8 and arg2) or (arg1 == KEY9 and arg2) or (arg1 == EQUALSKEY and arg2) or (arg1 == MINUSKEY and arg2) then
            start_script(inventory_hot_key_pressed, arg1)
        elseif control_map.MOVE_FORWARD[arg1] or control_map.MOVE_BACKWARD[arg1] or control_map.TURN_LEFT[arg1] or control_map.TURN_RIGHT[arg1] or control_map.MOVE_SOUTH[arg1] or control_map.MOVE_NORTH[arg1] or control_map.MOVE_EAST[arg1] or control_map.MOVE_WEST[arg1] or control_map.MOVE_NORTHWEST[arg1] or control_map.MOVE_NORTHEAST[arg1] or control_map.MOVE_SOUTHWEST[arg1] or control_map.MOVE_SOUTHEAST[arg1] and arg2 and not anyModifierDown then
            single_start_script(mf.flail_around)
        elseif control_map.PICK_UP[arg1] and arg2 and not anyModifierDown then
            if system.currentActor.is_holding then
                PrintDebug("putting away held item")
                start_script(dead_open_inventory, TRUE)
            else
                single_start_script(mf.wound.use, mf.wound)
            end
        elseif control_map.LOOK_AT[arg1] and arg2 and not anyModifierDown then
            if manny.is_holding then
                single_start_script(manny.is_holding.lookAt, manny.is_holding)
            else
                single_start_script(mf.wound.lookAt, mf.wound)
            end
        elseif control_map.USE[arg1] and arg2 and not anyModifierDown then
            if system.currentActor.is_holding then
                single_start_script(manny.is_holding.use, manny.is_holding)
            else
                single_start_script(mf.wound.use, mf.wound)
            end
        elseif control_map.INVENTORY[arg1] and arg2 and not anyModifierDown then
            start_script(dead_open_inventory)
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    end
end
mf.enter = function(arg1) -- line 225
    arg1:current_setup(mf_medoh)
end
mf.exit = function(arg1) -- line 229
    stop_script(mf.background_moans)
    stop_script(mf.continuous_moans)
    stop_script(mf.roll_head)
end
mf.wound = Object:create(mf, "/mftx013/wound", 0.065250002, -0.15620001, 0.20100001, { range = 0.60000002 })
mf.wound.use_pnt_x = -0.128648
mf.wound.use_pnt_y = -0.023381701
mf.wound.use_pnt_z = -0.31999999
mf.wound.use_rot_x = 0
mf.wound.use_rot_y = -145.369
mf.wound.use_rot_z = 0
mf.wound:make_untouchable()
mf.wound.lookAt = function(arg1) -- line 251
    START_CUT_SCENE()
    manny:head_look_at_point(mf.look_heart_point)
    manny:say_line("/mfma014/")
    wait_for_message()
    manny:head_look_at(nil)
    manny:say_line("/mfma015/")
    END_CUT_SCENE()
end
mf.wound.use = function(arg1) -- line 261
    START_CUT_SCENE()
    manny:say_line("/mfma016/")
    manny:head_look_at_point(mf.look_heart_point)
    sleep_for(2000)
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
mf.wound.use_nitro = function(arg1) -- line 270
    start_script(mf.freeze_heart)
end
mf.wound.use_scythe = function(arg1) -- line 274
    mf:use_scythe()
end

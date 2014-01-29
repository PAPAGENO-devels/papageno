CheckFirstTime("at.lua")
at = Set:create("at.set", "albinizod tunnel", { at_ledbw = 0, at_albcu = 1, at_intbw = 2, at_ovrhd = 3 })
dofile("alb_idles.lua")
dofile("alb_roar.lua")
dofile("msb_jump_off.lua")
dofile("msb_ladder_generic.lua")
dofile("bonewagon_alb.lua")
dofile("bonewagon_cc.lua")
at.bw_idle_vol = 30
at.mess_with_alligator = function() -- line 21
    manny:say_line("/atma001/")
    wait_for_message()
    manny:say_line("/atma002/")
end
at.locate_actors = function(arg1) -- line 28
    while 1 do
        at.bone_wagon.interest_actor:setpos(glottis:getpos())
        at.albinizod_obj.interest_actor:setpos(zod:getpos())
        break_here()
    end
end
ZOD_PROX = 2.5
zod_set_to_pin = FALSE
IN_BW = 0
ON_LEDGE = 1
PAST_ZOD = 2
ON_GROUND = 3
ON_LEDGE = 4
at.manny_state = nil
at.solve_puzzle = function(arg1) -- line 57
    albinizod_pinned = TRUE
    cur_puzzle_state[53] = TRUE
    stop_script(at.zod_brain)
    stop_script(at.zod_follow_bw)
    stop_script(at.watch_for_chase)
    MakeSectorActive("puzzle_solved", TRUE)
    start_sfx("atBWlnd.wav")
    START_CUT_SCENE()
    sleep_for(500)
    zod:setrot(0, 0, 0)
    at:current_setup(at_intbw)
    END_CUT_SCENE()
    start_script(at.zod_pinned)
end
at.zod_pinned = function(arg1) -- line 76
    zod_set_to_pin = FALSE
    zod:stop_chore()
    zod:play_chore(alb_idles_start_trap)
    zod:wait_for_chore()
    zod:play_chore(alb_idles_trap_loop)
    zod:wait_for_chore()
    while 1 do
        zod:blend(alb_idles_trap_loop, alb_idles_end_trap, 300)
        zod:wait_for_chore(alb_idles_trap_loop)
        zod:blend(alb_idles_end_trap, alb_idles_trap_loop, 300)
        zod:wait_for_chore(alb_idles_end_trap)
    end
    music_state:update()
end
at.wait_here = function(arg1, arg2) -- line 92
    repeat
        sleep_for(10)
        if at.manny_trigger_zod or find_script(at.drive_forward) then
            arg2 = 0
        else
            arg2 = arg2 - 1
        end
    until arg2 <= 0
end
at.zod_brain = function() -- line 103
    local local1
    local local2 = { }
    while 1 do
        at.manny_trigger_zod = FALSE
        while not at.manny_trigger_zod do
            break_here()
            if zod.walking then
                while zod.walking do
                    break_here()
                end
            elseif not find_script(at.drive_forward) then
                zod.up = TRUE
                zod:thaw()
                ForceRefresh()
                zod:play_chore(alb_idles_start_snap)
                zod:wait_for_chore()
                zod:stop_chore(alb_idles_start_snap)
                local1 = 1
                repeat
                    zod:play_chore(alb_idles_snap_loop)
                    zod:wait_for_chore()
                    local1 = local1 - 1
                    if at.manny_trigger_zod or find_script(at.drive_forward) then
                        local1 = 0
                    end
                until local1 <= 0
                zod:stop_chore(alb_idles_snap_loop)
                zod:play_chore(alb_idles_end_snap)
                zod:wait_for_chore()
                zod:stop_chore(alb_idles_end_snap)
                zod:play_chore(alb_idles_idle)
                zod:freeze()
                at:wait_here(rnd(10, 50))
                zod.up = FALSE
            end
            break_here()
        end
        START_CUT_SCENE()
        zod:thaw()
        ForceRefresh()
        stop_script(at.zod_follow_bw)
        zod:play_chore(alb_idles_sit_up)
        zod:wait_for_chore()
        zod:stop_chore(alb_idles_sit_up)
        zod:play_chore(alb_idles_turn)
        zod:wait_for_chore()
        at:current_setup(at_albcu)
        zod:setrot(0, 180, 0)
        zod:stop_chore(alb_idles_turn)
        zod:play_chore(alb_idles_idle)
        zod:setpos(0, 2.96925, 0)
        sleep_for(1000)
        at:current_setup(at_intbw)
        start_script(at.watch_for_chase)
        END_CUT_SCENE()
        local2 = manny:getpos()
        while local2.y < 3.5 do
            if glottis.bonewagon_up then
                zod_set_to_pin = TRUE
            end
            repeat
                zod:head_look_at_manny()
                local2 = manny:getpos()
                break_here()
            until local2.y > 0.2
            zod:head_look_at(nil)
            zod:play_chore(alb_idles_start_snap)
            zod:wait_for_chore()
            zod:stop_chore(alb_idles_start_snap)
            zod:play_chore_looping(alb_idles_snap_loop)
            while local2.y < 3.5 and local2.y > 0.2 do
                local2 = manny:getpos()
                break_here()
            end
            zod:set_chore_looping(alb_idles_snap_loop, FALSE)
            zod:wait_for_chore(alb_idles_snap_loop)
            zod:stop_chore(alb_idles_snap_loop)
            zod:play_chore(alb_idles_end_snap)
            zod:wait_for_chore()
            zod:stop_chore(alb_idles_end_snap)
            zod:play_chore(alb_idles_idle)
        end
        zod_set_to_pin = FALSE
        START_CUT_SCENE()
        zod:stop_chore(alb_idles_idle)
        zod:set_walk_rate(0.5)
        repeat
            zod:walk_forward()
            break_here()
        until zod:find_sector_name("turn_trigger")
        zod:play_chore(alb_idles_sit_up)
        zod:wait_for_chore()
        zod:stop_chore(alb_idles_sit_up)
        zod:play_chore(alb_idles_turn)
        zod:wait_for_chore()
        zod:setrot(0, 0, 0)
        zod:stop_chore(alb_idles_turn)
        stop_script(at.watch_for_chase)
        start_script(at.zod_follow_bw)
        END_CUT_SCENE()
    end
end
at.manny_escape = function() -- line 216
    local local1 = manny:getpos()
    stop_script(at.watch_manny)
    repeat
        manny:climb_up()
        local1 = manny:getpos()
    until local1.z >= 1.3
    manny:stop_climb_ladder()
    manny:runto(0.69999999, 5.875, 1.3)
    manny:wait_for_actor()
    start_script(at.watch_manny)
end
at.watch_for_chase = function(arg1) -- line 229
    repeat
        break_here()
    until manny:find_sector_name("chase_trigger")
    stop_script(at.zod_brain)
    zod_set_to_pin = FALSE
    START_CUT_SCENE()
    zod:set_walk_rate(1)
    zod:stop_chore()
    start_script(at.manny_escape)
    zod:walkto(-0.2, 0.64999998, 0, 0, 180, 0)
    zod:wait_for_actor()
    zod:play_chore(alb_idles_start_snap)
    zod:wait_for_chore()
    zod:stop_chore(alb_idles_start_snap)
    local local1 = 2
    repeat
        zod:play_chore(alb_idles_snap_loop)
        zod:wait_for_chore()
        local1 = local1 - 1
    until local1 == 0
    zod:stop_chore(alb_idles_snap_loop)
    zod:play_chore(alb_idles_end_snap)
    zod:wait_for_chore()
    zod:stop_chore(alb_idles_end_snap)
    zod:play_chore(alb_idles_idle)
    manny:wait_for_actor()
    zod:play_chore(alb_idles_sit_up)
    zod:wait_for_chore()
    zod:stop_chore(alb_idles_sit_up)
    zod:play_chore(alb_idles_turn)
    zod:wait_for_chore()
    zod:setrot(0, 0, 0)
    zod:stop_chore(alb_idles_turn)
    start_script(at.zod_follow_bw)
    start_script(at.zod_brain)
    END_CUT_SCENE()
end
at.zod_follow_bw = function(arg1) -- line 268
    local local1 = FALSE
    while 1 do
        if proximity(glottis, zod) < 2.9000001 and not zod.up or not local1 then
            local1 = TRUE
            zod:thaw()
            ForceRefresh()
            zod.walking = TRUE
            start_sfx("alFS.imu")
            repeat
                zod:set_walk_rate(-0.5)
                zod:walk_forward()
                break_here()
            until proximity(glottis, zod) >= 2.9000001
            zod:freeze()
        elseif proximity(glottis, zod) > 3 and not zod.up then
            zod.walking = TRUE
            zod:thaw()
            ForceRefresh()
            start_sfx("alFS.imu")
            repeat
                zod:set_walk_rate(0.5)
                zod:walk_forward()
                break_here()
            until proximity(glottis, zod) <= 2.9000001
            zod:freeze()
        else
            zod.walking = FALSE
            break_here()
        end
        stop_sound("alFS.imu")
    end
end
at.toggle_remote = function(arg1) -- line 311
    START_CUT_SCENE()
    stop_script(at.drive_forward)
    stop_script(at.drive_backward)
    at.glottis_pos = glottis:getpos()
    at.zod_pos = zod:getpos()
    at.zod_rot = zod:getrot()
    glottis:free()
    zod:free()
    stop_script(at.watch_manny)
    stop_script(at.locate_actors)
    stop_script(at.zod_follow_bw)
    stop_script(at.zod_pinned)
    stop_script(at.zod_brain)
    at_cut:switch_to_set()
    if manny.is_holding then
        if manny.fancy then
            mannys_hands:play_chore(mcc_inv_remote_in)
            mannys_hands:wait_for_chore()
            manny.is_holding = nil
            mannys_hands:play_chore(mcc_inv_empty_hand_out)
            mannys_hands:wait_for_chore()
        else
            mannys_hands:play_chore(msb_inv_remote_in)
            mannys_hands:wait_for_chore()
            manny.is_holding = nil
            mannys_hands:play_chore(msb_inv_mt_hand_out)
            mannys_hands:wait_for_chore()
        end
    elseif manny.fancy then
        mannys_hands:play_chore(mcc_inv_empty_hand_in)
        mannys_hands:wait_for_chore()
        manny.is_holding = sh.remote
        mannys_hands:play_chore(mcc_inv_remote_out)
        mannys_hands:wait_for_chore()
    else
        mannys_hands:play_chore(msb_inv_mt_hand_in)
        mannys_hands:wait_for_chore()
        manny.is_holding = sh.remote
        mannys_hands:play_chore(msb_inv_remote_out)
        mannys_hands:wait_for_chore()
    end
    at_cut:return_to_set()
    at.manny_state = IN_BW
    at:enter()
    END_CUT_SCENE()
end
at_cut = { }
at_cut.set_up_actors = function(arg1, arg2) -- line 372
    local local1
    local local2
    if DEMO then
        local1 = "demo_inv.cos"
    elseif manny.costume_state == "suit" then
        local1 = "inventory.cos"
    elseif manny.costume_state == "action" then
        local1 = "action_inv.cos"
    elseif manny.costume_state == "cafe" then
        local1 = "cafe_inv.cos"
    elseif manny.costume_state == "nautical" then
        local1 = "mn_inv.cos"
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            local1 = "mcc_inv.cos"
        else
            local1 = "msb_inv.cos"
        end
    end
    if not mannys_hands then
        mannys_hands = Actor:create(nil, nil, nil, "/sytx188/")
    end
    mannys_hands:set_costume(local1)
    mannys_hands:put_in_set(arg2)
    mannys_hands:moveto(0, 0, 0)
    mannys_hands:setrot(0, 180, 0)
end
at_cut.switch_to_set = function(arg1) -- line 404
    local local1
    local local2, local3
    system:lock_display()
    system.lastSet = system.currentSet
    inventory_save_set = system.currentSet
    LockSet(system.currentSet.setFile)
    if manny.fancy then
        local1 = charlie_inv
    else
        local1 = siberian_inv
    end
    MakeCurrentSet(local1.setFile)
    at_cut:set_up_actors(local1)
    system.currentSet = local1
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    zod:put_in_set(at)
    system:unlock_display()
end
at_cut.return_to_set = function(arg1) -- line 432
    mannys_hands:free()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    zod:put_in_set(at)
end
at.drive_backward = function(arg1) -- line 444
    local local1 = { }
    glottis:thaw()
    ForceRefresh()
    while 1 do
        local1 = glottis:getpos()
        local1.y = local1.y + PerSecond(0.5)
        glottis:setpos(local1)
        break_here()
    end
end
at.drive_forward = function(arg1) -- line 456
    glottis:thaw()
    ForceRefresh()
    while 1 do
        if proximity(glottis, zod) > 3 or not glottis:find_sector_name("close_enough") then
            pos = glottis:getpos()
            pos.y = pos.y - PerSecond(0.5)
            glottis:setpos(pos)
        end
        break_here()
    end
end
at.hot_key_pressed = function(arg1, arg2) -- line 469
    local local1
    if shiftKeyDown then
        if arg2 == KEY1 then
            local1 = Inventory.ordered_inventory_table[10]
        elseif arg2 == KEY2 then
            local1 = Inventory.ordered_inventory_table[11]
        elseif arg2 == KEY3 then
            local1 = Inventory.ordered_inventory_table[12]
        elseif arg2 == KEY4 then
            local1 = Inventory.ordered_inventory_table[13]
        elseif arg2 == KEY5 then
            local1 = Inventory.ordered_inventory_table[14]
        elseif arg2 == KEY6 then
            local1 = Inventory.ordered_inventory_table[15]
        elseif arg2 == KEY7 then
            local1 = Inventory.ordered_inventory_table[16]
        elseif arg2 == KEY8 then
            local1 = Inventory.ordered_inventory_table[17]
        elseif arg2 == KEY9 then
            local1 = Inventory.ordered_inventory_table[18]
        end
    elseif arg2 == KEY1 then
        local1 = Inventory.ordered_inventory_table[1]
    elseif arg2 == KEY2 then
        local1 = Inventory.ordered_inventory_table[2]
    elseif arg2 == KEY3 then
        local1 = Inventory.ordered_inventory_table[3]
    elseif arg2 == KEY4 then
        local1 = Inventory.ordered_inventory_table[4]
    elseif arg2 == KEY5 then
        local1 = Inventory.ordered_inventory_table[5]
    elseif arg2 == KEY6 then
        local1 = Inventory.ordered_inventory_table[6]
    elseif arg2 == KEY7 then
        local1 = Inventory.ordered_inventory_table[7]
    elseif arg2 == KEY8 then
        local1 = Inventory.ordered_inventory_table[8]
    elseif arg2 == KEY9 then
        local1 = Inventory.ordered_inventory_table[9]
    end
    if local1 then
        if local1 ~= sh.remote then
            system.default_response("not now")
        else
            start_script(at.toggle_remote)
        end
    end
end
at_bw_handler = function(arg1, arg2, arg3) -- line 523
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if arg1 == EKEY and controlKeyDown and arg2 and DeveloperMode then
        start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel == 0 then
        if manny.is_holding then
            start_script(sh.remote.lookAt)
        else
            start_script(at.ledge.lookAt)
        end
    elseif control_map.PICK_UP[arg1] and arg2 and cutSceneLevel == 0 and manny.is_holding then
        start_script(at.toggle_remote)
    elseif control_map.USE[arg1] and arg2 and cutSceneLevel == 0 then
        if manny.is_holding then
            start_script(Sentence, "use", manny.is_holding)
        else
            start_script(at.ledge.use)
        end
    elseif control_map.MOVE_BACKWARD[arg1] and cutSceneLevel == 0 then
        if arg2 then
            start_script(at.drive_backward)
        else
            stop_script(at.drive_backward)
            glottis:freeze()
        end
    elseif control_map.MOVE_FORWARD[arg1] and cutSceneLevel == 0 then
        if arg2 then
            start_script(at.drive_forward)
        else
            stop_script(at.drive_forward)
            glottis:freeze()
        end
    elseif control_map.INVENTORY[arg1] and arg2 and cutSceneLevel == 0 then
        start_script(at.toggle_remote)
    elseif arg1 == KEY1 and arg2 or (arg1 == KEY2 and arg2) or (arg1 == KEY3 and arg2) or (arg1 == KEY4 and arg2) or (arg1 == KEY5 and arg2) or (arg1 == KEY6 and arg2) or (arg1 == KEY7 and arg2) or (arg1 == KEY8 and arg2) or (arg1 == KEY9 and arg2) or (arg1 == EQUALSKEY and arg2) or (arg1 == MINUSKEY and arg2) then
        start_script(at.hot_key_pressed, at, arg1)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
at.start_in_bw = function(arg1) -- line 578
    manny:set_visibility(FALSE)
    system.currentActor = glottis
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = at_bw_handler
    if manny.fancy then
        glottis:play_chore(bonewagon_cc_ma_sit)
    else
        glottis:play_chore(bonewagon_gl_ma_sit)
    end
end
at.start_at_bw = function(arg1) -- line 590
    START_CUT_SCENE()
    manny:set_visibility(FALSE)
    system.currentActor = glottis
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = at_bw_handler
    at:current_setup(at_intbw)
    if glottis.bonewagon_up then
        sleep_for(800)
        sh.remote:lower()
    end
    glottis:thaw()
    glottis:play_chore(bonewagon_alb_ma_jump_in)
    glottis:wait_for_chore(bonewagon_alb_ma_jump_in)
    glottis:stop_chore(bonewagon_alb_ma_jump_in)
    glottis:play_chore(bonewagon_alb_ma_sit)
    END_CUT_SCENE()
end
at.start_at_ladder = function(arg1) -- line 609
end
at.zod_pinned_at_start = function(arg1) -- line 612
    glottis:setpos(-0.15, 4.45, 0)
    zod:setpos(-0.15, 2.96925, 0)
    zod:setrot(0, -360, 0)
    start_script(at.zod_pinned)
end
at.set_up_actors = function(arg1) -- line 619
    if not zod then
        zod = Actor:create(nil, nil, nil, "Albinizod")
    end
    zod:set_costume("alb_idles.cos")
    zod:put_in_set(at)
    if at.zod_pos then
        zod:setpos(at.zod_pos)
        zod:setrot(at.zod_rot)
    else
        zod:setpos(0.2, 0.2, 0)
        zod:setrot(0, 0, 0)
    end
    zod:set_walk_chore(alb_idles_walk)
    zod:follow_boxes()
    zod:set_head(3, 3, 3, 50, 50, 50)
    if manny.costume_state == "thunder" then
        if manny.fancy then
            glottis:set_costume("bonewagon_cc.cos")
        else
            glottis:set_costume("bonewagon_thunder.cos")
        end
    else
        glottis:set_costume("bonewagon_alb.cos")
    end
    glottis:put_in_set(at)
    glottis:set_visibility(TRUE)
    glottis:set_mumble_chore(bonewagon_gl_gl_mumble)
    glottis:set_talk_chore(1, bonewagon_gl_stop_talk)
    glottis:set_talk_chore(2, bonewagon_gl_a)
    glottis:set_talk_chore(3, bonewagon_gl_c)
    glottis:set_talk_chore(4, bonewagon_gl_e)
    glottis:set_talk_chore(5, bonewagon_gl_f)
    glottis:set_talk_chore(6, bonewagon_gl_l)
    glottis:set_talk_chore(7, bonewagon_gl_m)
    glottis:set_talk_chore(8, bonewagon_gl_o)
    glottis:set_talk_chore(9, bonewagon_gl_t)
    glottis:set_talk_chore(10, bonewagon_gl_u)
    if at.glottis_pos then
        glottis:setpos(at.glottis_pos)
    else
        glottis:setpos({ x = -0.15, y = 6.235, z = 0 })
    end
    glottis:setrot(0, 180, 0)
    glottis:follow_boxes()
    glottis:play_chore(bonewagon_gl_gl_cvr_eyes_hold)
    if glottis.bonewagon_up then
        glottis:play_chore(bonewagon_gl_stay_up)
    end
end
at.update_music_state = function(arg1) -- line 671
    if albinizod_pinned then
        return stateAT_TRAP
    else
        return stateAT
    end
end
at.enter = function(arg1) -- line 680
    single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, at.bw_idle_vol)
    at:set_up_actors()
    start_script(at.watch_manny)
    if not albinizod_pinned then
        MakeSectorActive("puzzle_solved", FALSE)
        start_script(at.zod_follow_bw)
        start_script(at.zod_brain)
    else
        MakeSectorActive("puzzle_solved", TRUE)
        at.zod_pinned_at_start()
    end
    start_script(at.locate_actors)
    if at.manny_state == IN_BW then
        start_script(at.start_in_bw)
    elseif at.manny_state == ON_GROUND then
        start_script(at.start_at_bw)
    elseif at.manny_state == PAST_ZOD then
        start_script(at.start_at_ladder)
    end
end
at.exit = function(arg1) -- line 704
    at.glottis_pos = glottis:getpos()
    at.zod_pos = zod:getpos()
    at.zod_rot = zod:getrot()
    glottis:free()
    zod:free()
    stop_script(at.watch_manny)
    stop_script(at.locate_actors)
    stop_script(at.zod_follow_bw)
    stop_script(at.zod_pinned)
    stop_script(at.zod_brain)
    stop_sound("alFs.imu")
    stop_sound("bwIdle.imu")
end
at.bone_wagon = Object:create(at, "/attx003/Bone Wagon", 0, 0, 0, { range = 2 })
at.bone_wagon.string_name = "at_wagon"
at.bone_wagon.lookAt = function(arg1) -- line 729
    manny:say_line("/atma004/")
    wait_for_message()
    manny:say_line("/atma005/")
end
at.bone_wagon.use = function(arg1) -- line 735
    if albinizod_pinned then
        system.default_response("not now")
    elseif not at.ledge.touchable then
        START_CUT_SCENE()
        at:current_setup(at_albcu)
        manny:ignore_boxes()
        manny:setpos(0.619514, 5.84285, 1.135)
        manny:setrot(0, -301.164, 0)
        if manny.fancy then
            manny:push_costume("mcc_jump_off.cos")
        else
            manny:push_costume("msb_jump_off.cos")
        end
        manny:play_chore(msb_jump_off_jump_off)
        sleep_for(2010)
        manny:pop_costume()
        at:current_setup(at_intbw)
        at:start_in_bw()
        at.ledge.touchable = TRUE
        END_CUT_SCENE()
    end
end
at.ledge = Object:create(at, "/attx006/catwalk", 0, 0, 0, { range = 2 })
at.ledge.lookAt = function(arg1) -- line 761
    manny:say_line("/atma007/")
end
at.ledge.use = function(arg1) -- line 765
    local local1 = glottis:getpos()
    local local2 = glottis:getrot()
    local local3 = { }
    local local4 = { x = -0.74551398, y = 0.247446, z = 0 }
    if glottis.bonewagon_up then
        if glottis:find_sector_name("close_enough") then
            START_CUT_SCENE()
            manny:ignore_boxes()
            manny:setpos(local1.x + 0.014, local1.y + 1.5453, local1.z + 1.4126)
            manny:setrot(local2)
            if manny.fancy then
                manny:push_costume("mcc_jump_off.cos")
            else
                manny:push_costume("msb_jump_off.cos")
            end
            manny:set_visibility(TRUE)
            if manny.fancy then
                glottis:play_chore(bonewagon_cc_hide_ma)
            else
                glottis:play_chore(bonewagon_gl_hide_ma)
            end
            manny:play_chore(msb_jump_off_stand_up)
            manny:wait_for_chore()
            manny:play_chore(msb_jump_off_turn)
            manny:wait_for_chore()
            at:current_setup(at_albcu)
            glottis:freeze()
            manny:play_chore(msb_jump_off_jump_off)
            sleep_for(500)
            repeat
                local1 = manny:getpos()
                local1.z = local1.z - PerSecond(0.050000001)
                if local1.z < 1.3 then
                    local1.z = 1.3
                end
                manny:setpos(local1)
            until local1.z == 1.3
            manny:wait_for_chore()
            start_sfx("fs3mtrr2.wav")
            sleep_for(100)
            start_sfx("fs3mtrr1.wav")
            local2 = manny:getrot()
            local3 = RotateVector(local4, local2)
            local1 = manny:getpos()
            local3.x = local3.x + local1.x
            local3.y = local3.y + local1.y
            local3.z = local3.z + local1.z
            manny:setpos(local3)
            manny:setrot(0, local2.y + 342.543, 0)
            manny:pop_costume()
            manny:follow_boxes()
            system.currentActor = manny
            system.buttonHandler = SampleButtonHandler
            at.ledge:make_untouchable()
            at:current_setup(at_intbw)
            manny:stop_chore(msb_hold, manny.base_costume)
            glottis:thaw()
            ForceRefresh()
            END_CUT_SCENE()
        else
            manny:say_line("/atma007/")
            manny:wait_for_message()
            manny:say_line("/hama102/")
            manny:wait_for_message()
            system.default_response("reach")
        end
    else
        manny:say_line("/vima052/")
    end
end
at.albinizod_obj = Object:create(at, "/attx008/cave-gator", -0.20827, 1.20654, 0, { range = 2 })
at.albinizod_obj.use_pnt_x = -0.20827
at.albinizod_obj.use_pnt_y = 1.78654
at.albinizod_obj.use_pnt_z = 0
at.albinizod_obj.use_rot_x = 0
at.albinizod_obj.use_rot_y = -1976.1899
at.albinizod_obj.use_rot_z = 0
at.albinizod_obj.string_name = "gator"
at.albinizod_obj.lookAt = function(arg1) -- line 855
    if albinizod_pinned then
        manny:say_line("/atma009/")
    else
        manny:say_line("/atma010/")
        wait_for_message()
        manny:say_line("/atma011/")
        manny:point_gesture()
    end
end
at.albinizod_obj.use = function(arg1) -- line 866
    soft_script()
    manny:say_line("/atma012/")
    wait_for_message()
    manny:say_line("/atma013/")
end
at.ladder_base = Object:create(at, "", 0, 0, 0, { range = 0 })
at.ladder_top = Object:create(at, "", 0, 0, 0, { range = 0 })
at.ladder_base.use_pnt_x = 0.40000001
at.ladder_base.use_pnt_y = -0.58347303
at.ladder_base.use_pnt_z = 0
at.ladder_base.use_rot_x = 0
at.ladder_base.use_rot_y = -98.119102
at.ladder_base.use_rot_z = 0
at.ladder_base.out_pnt_x = 0.27092001
at.ladder_base.out_pnt_y = -0.60680401
at.ladder_base.out_pnt_z = 0
at.ladder_base.out_rot_x = 0
at.ladder_base.out_rot_y = 107.629
at.ladder_base.out_rot_z = 0
at.ladder_top.use_pnt_x = 0.475889
at.ladder_top.use_pnt_y = -0.58347303
at.ladder_top.use_pnt_z = 1.3
at.ladder_top.use_rot_x = 0
at.ladder_top.use_rot_y = -98.119102
at.ladder_top.use_rot_z = 0
at.watch_manny = function() -- line 899
    local local1 = { }
    local local2
    while 1 do
        local1 = manny:getpos()
        if manny.is_climbing and local1.z <= 0 and albinizod_pinned then
            local2 = start_script(at.get_off_ladder, at, "bottom")
            wait_for_script(local2)
        elseif manny.is_climbing and local1.z >= 0.70599997 then
            local2 = start_script(at.get_off_ladder, at, "top")
            wait_for_script(local2)
        elseif not manny.is_climbing and manny:find_sector_name("top") and local1.z == 1.3 then
            local2 = start_script(at.get_on_ladder, at, "top")
            wait_for_script(local2)
        elseif not manny.is_climbing and manny:find_sector_name("bottom") and local1.z == 0 then
            local2 = start_script(at.get_on_ladder, at, "bottom")
            wait_for_script(local2)
        end
        break_here()
    end
end
at.get_on_ladder = function(arg1, arg2) -- line 921
    manny.is_climbing = TRUE
    if arg2 == "top" then
        START_CUT_SCENE()
        at.manny_trigger_zod = TRUE
        inventory_disabled = TRUE
        manny:walkto(0.43637, -0.605, 1.3, 0, -95.9144, 0)
        manny:wait_for_actor()
        if manny.fancy then
            manny:push_costume("mcc_ladder_generic.cos")
        else
            manny:push_costume("msb_ladder_generic.cos")
        end
        manny:play_chore(msb_ladder_generic_mount_ladder)
        manny:wait_for_chore()
        manny:ignore_boxes()
        manny:setpos(0.38637, -0.605, 1)
        manny:play_chore(msb_ladder_generic_post_mount)
        manny:wait_for_chore()
        manny.climb_chore = ma_ladder_generic_climb_down2
        manny.costume_marker_handler = arg1.ladder_marker_handler
        manny:setpos({ x = 0.38637, y = -0.595, z = 0.706 })
        manny:stop_chore(msb_ladder_generic_post_mount)
        manny:climb_down()
        END_CUT_SCENE()
    elseif arg2 == "bottom" then
        START_CUT_SCENE()
        manny:walkto_object(at.ladder_base)
        manny:wait_for_actor()
        manny:start_climb_ladder()
        manny:climb_up()
        manny:climb_up()
        manny:climb_up()
        END_CUT_SCENE()
    end
end
at.get_off_ladder = function(arg1, arg2) -- line 959
    START_CUT_SCENE()
    if arg2 == "top" then
        manny.is_climbing = FALSE
        stop_script(manny.climb_up)
        stop_script(manny.climb_down)
        stop_script(climb_actor_up)
        stop_script(climb_actor_down)
        manny:stop_chore(ma_ladder_generic_climb1)
        manny:stop_chore(ma_ladder_generic_climb2)
        manny:stop_chore(ma_ladder_generic_climb_down1)
        manny:stop_chore(ma_ladder_generic_climb_down2)
        manny:setpos(0.43637, -0.605, 1.3)
        manny:play_chore(msb_ladder_generic_unmount_ladder)
        manny:wait_for_chore()
        manny:pop_costume()
        inventory_disabled = FALSE
        manny.costume_marker_handler = nil
        manny:follow_boxes()
        while manny:find_sector_name("top") do
            manny:walk_forward()
            break_here()
        end
    elseif arg2 == "bottom" then
        manny:stop_climb_ladder()
        manny:walkto(0.23885, -0.604971, 0, 0, -640, 0)
    end
    END_CUT_SCENE()
end
at.zw_door = Object:create(at, "/attx014/sewer", -0.282056, 7.8309498, 0, { range = 1 })
at.zw_door.use_pnt_x = -0.282056
at.zw_door.use_pnt_y = 7.8309498
at.zw_door.use_pnt_z = 0
at.zw_door.use_rot_x = 0
at.zw_door.use_rot_y = -354.44101
at.zw_door.use_rot_z = 0
at.zw_door:make_untouchable()
at.zw_door.walkOut = function(arg1) -- line 1005
    zw:come_out_door(zw.at_door)
end
at.fp_door = Object:create(at, "/attx015/sewer", -0.48330101, -0.57499999, 0, { range = 0 })
at.fp_door.use_pnt_x = -0.48330101
at.fp_door.use_pnt_y = -0.57499999
at.fp_door.use_pnt_z = 0
at.fp_door.use_rot_x = 0
at.fp_door.use_rot_y = -178.55701
at.fp_door.use_rot_z = 0
at.fp_door.out_pnt_x = -0.48330101
at.fp_door.out_pnt_y = -0.57499999
at.fp_door.out_pnt_z = 0
at.fp_door.out_rot_x = 0
at.fp_door.out_rot_y = -178.55701
at.fp_door.out_rot_z = 0
at.florist_box = at.fp_door
at.fp_door.walkOut = function(arg1) -- line 1028
    at.manny_state = PAST_ZOD
    fp:come_out_door(fp.at_door)
end
at.jump_point = Object:create(at, "", 0.849998, 6.3249998, 1.3, { range = 0 })
at.jump_point.use_pnt_x = 0.52499998
at.jump_point.use_pnt_y = 6.4250002
at.jump_point.use_pnt_z = 1.3
at.jump_point.use_rot_x = 0
at.jump_point.use_rot_y = -360.58701
at.jump_point.use_rot_z = 0
at.jump = at.jump_point
at.jump_point.walkOut = function(arg1) -- line 1044
    local local1 = { }
    START_CUT_SCENE()
    if not albinizod_pinned then
        while zod_set_to_pin do
            break_here()
        end
    end
    system:lock_display()
    manny:set_visibility(TRUE)
    glottis:set_visibility(FALSE)
    at:current_setup(at_ledbw)
    manny:ignore_boxes()
    manny:setpos(0.52499998, 6.4250002, 1.206)
    manny:setrot(0, -425.832, 0)
    if manny.fancy then
        manny:push_costume("mcc_jump_off.cos")
    else
        manny:push_costume("msb_jump_off.cos")
    end
    glottis:thaw()
    system:unlock_display()
    glottis:set_visibility(FALSE)
    manny:play_chore(msb_jump_off_jump_off)
    sleep_for(1675)
    repeat
        local1 = manny:getpos()
        local1.z = local1.z - PerSecond(2.0999999)
        if local1.z < 0 then
            local1.z = 0
        end
        manny:setpos(local1)
        break_here()
    until local1.z == 0
    manny:wait_for_chore()
    END_CUT_SCENE()
    manny:pop_costume()
    manny:follow_boxes()
    zw:come_out_door(zw.at_door)
end

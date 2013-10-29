CheckFirstTime("tr.lua")
tr = Set:create("tr.set", "tree pump room", { tr_estha = 1, tr_estha2 = 1, tr_estha3 = 1, tr_estha4 = 1, tr_pmpws = 2 })
dofile("tree.lua")
dofile("gl_tree.lua")
dofile("gl_fastwalk.lua")
dofile("tr_lever.lua")
dofile("ma_use_wb.lua")
dofile("wheelbarrow.lua")
dofile("ma_use_lever.lua")
dofile("tr_bulges.lua")
tr.beat = 1
tr.factory_vol_near = 90
tr.factory_vol_far = 30
tr.wheel_vol = 127
tr.solve_mod = function(arg1) -- line 25
    cur_puzzle_state[17] = TRUE
    mod_solved = TRUE
    if com_solved and bv.padlock.unlocked then
        bd:leave_forest()
    else
        system.currentSet.bone_wagon:make_untouchable()
        manny.is_driving = TRUE
        start_script(bonewagon.monitor_turns, bonewagon)
        sg:enable_bonewagon_boxes(TRUE)
        manny:put_in_set(nil)
        system.buttonHandler = bone_wagon_button_handler
        bonewagon:set_selected()
        sg:switch_to_set()
        sg:current_setup(sg_sgnha)
        bonewagon:stop_movement_scripts()
        bonewagon:put_in_set(sg)
        bonewagon:default()
        bonewagon:setpos(7.38346, -12.853, 0)
        bonewagon:setrot(0, 341.687, 0)
        bonewagon:set_walk_rate(bonewagon.max_walk_rate)
        bonewagon:driveto(5.62575, -2.35111, 0)
        bonewagon:wait_for_actor()
        kill_override()
    end
end
tr.check_hoses = function() -- line 68
    local local1
    while 1 do
        foo, tr.barrow.box = tr.barrow:find_sector_type(HOT)
        if in(tr.barrow.box, { "hose_box1", "hose_box2", "hose_box3", "hose_box4" }) then
            local1 = tr[tostring(tr.barrow.box)]
            if local1["walkOut"] then
                start_script(local1.walkOut, local1, tr.barrow)
            end
            while tr.barrow:find_sector_type(HOT) do
                break_here()
            end
        end
        break_here()
    end
end
tr.update_barrow_object_pos = function() -- line 91
    local local1 = manny:getpos()
    local local2 = { }
    local2 = tr.barrow:getpos()
    tr.wheelbarrow.use_pnt_x = local2.x - 0.43465999
    tr.wheelbarrow.use_pnt_y = local2.y + 0.22658999
    tr.wheelbarrow.use_pnt_z = local1.z
    tr.wheelbarrow.obj_x = local2.x - 0.22431999
    tr.wheelbarrow.obj_y = local2.y + 0.078610003
    tr.wheelbarrow.obj_z = local2.z + 0.11664
    tr.wheelbarrow:update_look_point()
end
tr.push_barrow = function() -- line 111
    local local1, local2
    tr.set_walk_backwards(FALSE)
    if cutSceneLevel <= 0 then
        manny:play_chore(ma_use_wb_start_walk, "ma_use_wb.cos")
        tr.barrow:play_chore(wheelbarrow_ma_start_walk, "wheelbarrow.cos")
        sleep_for(750)
        tr.barrow:play_chore_looping(wheelbarrow_ma_walk, "wheelbarrow.cos")
        while manny:is_choring(ma_use_wb_start_walk, TRUE, "ma_use_wb.cos") do
            manny:walk_forward()
            tr.barrow:walk_forward()
            break_here()
        end
        manny:wait_for_chore(ma_use_wb_start_walk, "ma_use_wb.cos")
        manny:play_chore_looping(ma_use_wb_walk, "ma_use_wb.cos")
        tr.barrow:play_chore_looping(wheelbarrow_ma_walk, "wheelbarrow.cos")
        while get_generic_control_state("MOVE_FORWARD") and cutSceneLevel <= 0 and not manny:find_sector_name("wb_push_lim") do
            manny:walk_forward()
            tr.barrow:walk_forward()
            break_here()
        end
        manny:stop_chore(ma_use_wb_walk, "ma_use_wb.cos")
        tr.barrow:stop_chore(wheelbarrow_ma_walk, "wheelbarrow.cos")
        manny:play_chore(ma_use_wb_stop_walk, "ma_use_wb.cos")
        tr.barrow:play_chore(wheelbarrow_ma_stop_walk, "wheelbarrow.cos")
        manny:wait_for_chore(ma_use_wb_stop_walk, "ma_use_wb.cos")
    end
end
tr.set_walk_backwards = function(arg1) -- line 144
    if arg1 then
        manny.is_backward = TRUE
        manny:set_walk_chore(ma_use_wb_walk_back, "ma_use_wb.cos")
        manny:set_walk_rate(-0.4)
        tr.barrow:set_walk_rate(-0.4)
    else
        manny.is_backward = FALSE
        manny:set_walk_chore(ma_use_wb_walk, "ma_use_wb.cos")
        manny:set_walk_rate(0.4)
        tr.barrow:set_walk_rate(0.4)
    end
end
tr.pull_barrow = function() -- line 163
    tr.set_walk_backwards(TRUE)
    manny:stop_chore()
    manny:play_chore_looping(ma_use_wb_walk_back, "ma_use_wb.cos")
    tr.barrow:play_chore_looping(wheelbarrow_ma_walk, "wheelbarrow.cos")
    while get_generic_control_state("MOVE_BACKWARD") and cutSceneLevel <= 0 and not manny:find_sector_name("wb_pull_lim") or system.currentActor.move_in_reverse do
        manny:walk_forward()
        tr.barrow:walk_forward()
        break_here()
    end
    manny:stop_chore(ma_use_wb_walk_back, "ma_use_wb.cos")
    tr.barrow:stop_chore(wheelbarrow_ma_walk, "wheelbarrow.cos")
    stop_sound("walkWB.IMU")
    manny:play_chore(ma_use_wb_hold_wb, "ma_use_wb.cos")
    tr.barrow:play_chore(wheelbarrow_ma_hold, "wheelbarrow.cos")
end
wheelbarrow_button_handler = function(arg1, arg2, arg3) -- line 181
    if cutSceneLevel <= 0 then
        if control_map.MOVE_FORWARD[arg1] then
            if arg2 then
                if manny:find_sector_name("wb_push_lim") then
                    PrintDebug("found sector name: " .. tostring(manny:find_sector_name("wb_push_lim")) .. "\n")
                    start_script(tr.wheelbarrow.out_of_bounds, tr.wheelbarrow)
                else
                    stop_script(tr.pull_barrow)
                    if find_script(tr.push_barrow) == nil then
                        start_script(tr.push_barrow)
                    end
                end
            end
        elseif control_map.MOVE_BACKWARD[arg1] then
            if arg2 then
                if manny:find_sector_name("wb_pull_lim") then
                    PrintDebug("found sector name: " .. tostring(manny:find_sector_name("wb_push_lim")) .. "\n")
                    start_script(tr.wheelbarrow.out_of_bounds, tr.wheelbarrow)
                else
                    stop_script(tr.push_barrow)
                    if find_script(tr.pull_barrow) == nil then
                        start_script(tr.pull_barrow)
                    end
                end
            else
                start_script(tr.set_walk_backwards, FALSE)
            end
        elseif control_map.USE[arg1] and arg2 then
            start_script(tr.drop_wheelbarrow)
        elseif control_map.PICK_UP[arg1] and arg2 then
            start_script(tr.drop_wheelbarrow)
        elseif control_map.OVERRIDE[arg1] and arg2 then
            start_script(tr.drop_wheelbarrow)
        elseif control_map.INVENTORY[arg1] and arg2 then
            start_script(tr.drop_wheelbarrow)
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    end
end
tr.pick_up_wheelbarrow = function() -- line 226
    if manny:walk_closeto_object(tr.wheelbarrow, 0.5) then
        inventory_disabled = TRUE
        manny.idles_allowed = FALSE
        manny.holding_wheelbarrow = TRUE
        START_CUT_SCENE()
        tr.barrow:set_collision_mode(COLLISION_OFF)
        manny:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(tr.wheelbarrow)
        manny:wait_for_actor()
        manny:setrot(tr.wheelbarrow.use_rot_x, tr.wheelbarrow.use_rot_y, tr.wheelbarrow.use_rot_z)
        manny:push_costume("ma_use_wb.cos")
        manny:head_look_at(nil)
        tr.barrow:play_chore(wheelbarrow_ma_lift, "wheelbarrow.cos")
        manny:play_chore(ma_use_wb_lift_wb, "ma_use_wb.cos")
        manny:wait_for_chore()
        manny:set_walk_chore(nil)
        manny:set_rest_chore(nil)
        tr.barrow:set_walk_chore(nil)
        tr.barrow:set_rest_chore(nil)
        END_CUT_SCENE()
        start_script(tr.check_hoses)
        system.buttonHandler = wheelbarrow_button_handler
    else
        system.default_response("reach")
    end
end
tr.drop_wheelbarrow = function() -- line 262
    inventory_disabled = FALSE
    manny.idles_allowed = TRUE
    manny.holding_wheelbarrow = FALSE
    START_CUT_SCENE()
    tr.set_walk_backwards(FALSE)
    tr.update_barrow_object_pos()
    manny:stop_chore()
    tr.barrow:set_rest_chore(nil)
    tr.barrow:stop_chore()
    manny:play_chore(ma_use_wb_drop_wb)
    tr.barrow:play_chore(wheelbarrow_ma_drop)
    manny:wait_for_chore()
    manny:stop_chore()
    manny:pop_costume()
    manny:default()
    manny:set_walk_backwards(TRUE)
    manny.move_in_reverse = TRUE
    start_script(move_actor_backward, manny.hActor)
    sleep_for(500)
    stop_script(move_actor_backward)
    manny:set_walk_backwards(FALSE)
    manny.move_in_reverse = FALSE
    manny:set_walk_backwards(FALSE)
    tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
    manny:set_collision_mode(COLLISION_SPHERE, 0.5)
    END_CUT_SCENE()
    stop_script(tr.check_hoses)
    system.buttonHandler = SampleButtonHandler
end
tr.go_normal = function(arg1) -- line 302
    tr.tree.synched = FALSE
    START_CUT_SCENE()
    if tr.switch.pos == "up" then
        if tr.tree.has_glottis then
            tree_pump:stop_looping_chore(tree_xab_gl, "tree.cos", TRUE)
            tree_pump:play_chore_looping(tree_normal_gl, "tree.cos")
        else
            tree_pump:stop_looping_chore(tree_abnormal_no_gl, "tree.cos", TRUE)
            tree_pump:play_chore_looping(tree_normal, "tree.cos")
        end
    end
    END_CUT_SCENE()
end
tr.go_abnormal = function(arg1) -- line 317
    START_CUT_SCENE()
    tr.tree.synched = TRUE
    if tr.switch.pos == "up" then
        if tr.tree.has_glottis then
            tree_pump:stop_looping_chore(tree_normal_gl, "tree.cos", TRUE)
            tree_pump:play_chore_looping(tree_xab_gl, "tree.cos")
            glottis:say_line("/trgl033/")
            wait_for_message()
        else
            tree_pump:stop_looping_chore(tree_normal, "tree.cos", TRUE)
            tree_pump:play_chore_looping(tree_abnormal_no_gl, "tree.cos")
        end
    end
    END_CUT_SCENE()
    if tr.switch.pos == "up" and tr.tree.has_glottis then
        START_CUT_SCENE()
        single_start_script(tr.drop_wheelbarrow)
        sleep_for(4000)
        END_CUT_SCENE()
        start_script(tr, stop_ambient_sfx, tr)
        stop_sound("treeWeel.imu")
        single_start_script(cut_scene.puzl19c)
    end
end
tr.see_pumps = function(arg1) -- line 350
    if not mod_solved then
        START_CUT_SCENE("nohead")
        tr:current_setup(tr_pmpws)
        manny:setpos(2.81627, -0.960528, -1.77)
        manny:setrot(0, 9.81997, 0)
        manny:head_look_at(tr.tree)
        sleep_for(500)
        manny:walkto(2.81023, 0.257844, -1.77, 0, 345.036, 0)
        break_here()
        if not tr.seen_pumps then
            tr.seen_pumps = TRUE
            set_override(tr.see_pumps_override, tr)
            manny:head_look_at(tr.tree)
            manny:say_line("/trma001/")
            manny:head_look_at(tr.tree)
            wait_for_message()
            manny:head_look_at(tr.tree)
            manny:say_line("/trma002/")
            wait_for_message()
            sleep_for(500)
            manny:head_look_at_point(3.08236, -0.496168, -1.3388)
            manny:turn_right(90)
            manny:say_line("/trma003/")
            wait_for_message()
            tr.barrow:set_visibility(TRUE)
            glottis:set_visibility(TRUE)
            if not (glottis:get_costume() == "gl_tree.cos") then
                glottis:push_costume("gl_tree.cos")
            end
            tr.barrow:play_chore(wheelbarrow_gl_wheels, "wheelbarrow.cos")
            glottis:play_chore(gl_tree_wheels, "gl_tree.cos")
            glottis:say_line("/trgl004/")
            sleep_for(300)
            manny:turn_left(110)
            manny:head_look_at(tr.glottis_obj)
            sleep_for(500)
            manny:head_look_at(tr.barrow)
            glottis:head_look_at(manny)
            wait_for_message()
            glottis:say_line("/trgl005/")
            sleep_for(2000)
            glottis:head_look_at(tr.barrow)
            sleep_for(4000)
            glottis:head_look_at_point(2.39817, 2.43442, -0.4244)
            wait_for_message()
            glottis:head_look_at(manny)
            glottis:stop_chore()
            glottis:pop_costume()
            Object:lookAt()
            glottis:head_look_at(nil)
            glottis:play_chore(glottis_home_pos, "glottis.cos")
            start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
            tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
            enable_head_control(TRUE)
            manny:head_look_at(nil)
        else
            box_on("glottis_box")
            glottis:follow_boxes()
            tr.barrow:set_collision_mode(COLLISION_OFF)
            glottis:setpos(0.921907, 3.62018, -1.77)
            glottis:setrot(0, 190, 0)
            glottis:set_visibility(TRUE)
            glottis:head_look_at(nil)
            glottis:stop_chore()
            glottis:push_costume("gl_fastwalk.cos")
            glottis:set_collision_mode(COLLISION_OFF)
            glottis:set_walk_chore(0, "gl_fastwalk.cos")
            glottis:set_walk_rate(0.85)
            glottis:set_rest_chore(glottis_home_pose, "glottis.cos")
            glottis:walkto(2.26387, 2.95142, -1.77, 0, 190, 0)
            glottis:wait_for_actor()
            glottis:pop_costume()
            glottis:ignore_boxes()
            glottis:set_rest_chore(-1)
            glottis:stop_chore()
            glottis:default()
            glottis:put_in_set(tr)
            glottis:play_chore(glottis_home_pos, "glottis.cos")
            box_off("glottis_box")
            box_off("glot_gone_box")
            start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
            tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
        end
        END_CUT_SCENE()
        tr.update_barrow_object_pos()
    end
end
tr.see_pumps_override = function() -- line 445
    kill_override()
    glottis:set_visibility(TRUE)
    if glottis:get_costume() == "gl_tree.cos" then
        glottis:stop_chore()
        glottis:pop_costume()
    end
    glottis:default()
    glottis:put_in_set(tr)
    glottis:play_chore(glottis_home_pose, "glottis.cos")
    single_start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
    tr.barrow:set_visibility(TRUE)
    tr:current_setup(tr_pmpws)
    tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
    glottis:set_collision_mode(COLLISION_OFF)
    manny:setpos(2.84886, 0.155232, -1.77)
    manny:setrot(0, 26.723, 0)
end
tr.pump_timer_and_checker = function(arg1) -- line 465
    while 1 do
        if tr.pump1.beat == tr.beat and system.currentSet == tr then
            start_script(tr.pump1.strike, tr.pump1)
        end
        if tr.pump2.beat == tr.beat and system.currentSet == tr then
            start_script(tr.pump2.strike, tr.pump2)
        end
        if tr.pump3.beat == tr.beat and system.currentSet == tr then
            start_script(tr.pump3.strike, tr.pump3)
        end
        if tr.pump4.beat == tr.beat and system.currentSet == tr then
            start_script(tr.pump4.strike, tr.pump4)
        end
        if tr.pump1.beat == tr.pump2.beat and tr.pump3.beat == tr.pump4.beat then
            if tr.pump1.beat ~= tr.pump3.beat then
                if not tr.tree.synched then
                    start_script(tr.go_abnormal)
                end
            elseif tr.tree.synched then
                start_script(tr.go_normal)
            end
        elseif tr.tree.synched then
            start_script(tr.go_normal)
        end
        tr.beat = tr.beat + 1
        if tr.beat > 4 then
            tr.beat = 1
        end
        sleep_for(500)
    end
end
tr.hose_watch = function(arg1, arg2) -- line 512
    fade_sfx("hoseRlse.wav", 250, 0)
    if system.currentSet == tr then
        start_sfx("hoseKink.wav", IM_MED_PRIORITY)
    end
    if arg1 == tr.pump1 then
        tr.bulges:play_chore(tr_bulges_bulge1)
    elseif arg1 == tr.pump2 then
        tr.bulges:play_chore(tr_bulges_bulge2)
    elseif arg1 == tr.pump3 then
        tr.bulges:play_chore(tr_bulges_bulge3)
    elseif arg1 == tr.pump4 then
        tr.bulges:play_chore(tr_bulges_bulge4)
    end
    while arg2:find_sector_type(HOT) do
        break_here()
    end
    arg1.beat = tr.beat
    tr.bulges:play_chore(tr_bulges_no_bulges)
    fade_sfx("hoseKink.wav", 250, 0)
    if system.currentSet == tr then
        start_sfx("hoseRlse.wav", IM_MED_PRIORITY)
    end
end
tr.drive_in = function(arg1) -- line 548
    local local1, local2
    START_CUT_SCENE()
    tr:switch_to_set()
    tr:current_setup(tr_estha)
    bonewagon:stop_cruise_sounds()
    bonewagon:stop_movement_scripts()
    bonewagon:put_in_set(tr)
    bonewagon:setpos(0.125, -5.6999998, -1.77)
    bonewagon:setrot(0, 351.38699, 0)
    bonewagon:set_walk_rate(2.5)
    bonewagon:ignore_boxes()
    bonewagon.walk_rate = 2.5
    start_sfx("bwDown02.WAV", IM_MED_PRIORITY, bonewagon.max_volume)
    fade_sfx("bwDown02.WAV", 500)
    local1 = 0
    repeat
        WalkActorForward(bonewagon.hActor)
        break_here()
        local2 = proximity(bonewagon.hActor, 0.54844201, -2.8974099, -1.77)
        bonewagon.walk_rate = max(1.2, bonewagon.walk_rate - 0.1)
        bonewagon:set_walk_rate(bonewagon.walk_rate)
        local1 = local1 + system.frameTime
    until local2 < 1 or local1 > 1500
    bonewagon:setpos(0.54844201, -2.8974099, -1.77)
    start_sfx("bwTire01.WAV")
    bonewagon:setpos(0.54844201, -2.8974099, -1.77)
    sg:leave_BW(TRUE)
    stop_script(glottis.talk_randomly_from_weighted_table)
    stop_script(sg.glottis_roars)
    bonewagon:set_collision_mode(COLLISION_BOX)
    if not mod_solved then
        bonewagon:play_chore(bonewagon_gl_hide_gl)
    end
    END_CUT_SCENE()
    start_script(tr.see_pumps, tr)
end
tr.drive_out = function(arg1, arg2) -- line 589
    local local1
    START_CUT_SCENE()
    if arg2 then
        bonewagon:stop_movement_scripts()
        bonewagon.walk_rate = -1
        start_sfx("bwStart.WAV")
        start_sfx("bwTire01.WAV")
        local1 = 0
        while local1 < 1000 do
            WalkActorForward(bonewagon.hActor)
            break_here()
            bonewagon.walk_rate = bonewagon.walk_rate - 0.1
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            local1 = local1 + system.frameTime
        end
    end
    sg:switch_to_set()
    sg:current_setup(sg_sgnha)
    bonewagon:follow_boxes()
    bonewagon:stop_movement_scripts()
    bonewagon:put_in_set(sg)
    bonewagon:setpos(7.38346, -12.853, 0)
    bonewagon:setrot(0, 341.68701, 0)
    bonewagon:set_walk_rate(bonewagon.max_walk_rate)
    if not arg2 then
        IrisUp(400, 150, 1000)
    end
    bonewagon:driveto(5.6257501, -2.35111, 0)
    END_CUT_SCENE()
end
tr.get_in_BW = function(arg1) -- line 624
    stop_script(glottis.new_run_idle)
    if not mod_solved then
        manny:walk_closeto_object(system.currentSet.bone_wagon, 1)
        manny:wait_for_actor()
        box_on("glottis_box")
        glottis:follow_boxes()
        glottis:stop_chore()
        glottis:push_costume("gl_fastwalk.cos")
        glottis:set_walk_chore(0, "gl_fastwalk.cos")
        glottis:set_walk_rate(0.85)
        glottis:set_rest_chore(glottis_home_pose, "glottis.cos")
        glottis:set_collision_mode(COLLISION_SPHERE, 0.9)
        start_script(glottis.walkto, glottis, system.currentSet.bone_wagon)
        bonewagon:set_collision_mode(COLLISION_OFF)
        manny:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(system.currentSet.bone_wagon)
        manny:wait_for_actor()
        manny:set_visibility(FALSE)
        bonewagon:play_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        bonewagon:wait_for_chore()
        bonewagon:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
        manny:put_in_set(nil)
        bonewagon.current_set = nil
        system.currentSet.bone_wagon:make_untouchable()
        manny.is_driving = TRUE
        bonewagon:default()
        bonewagon:play_chore(bonewagon_gl_hide_gl, "bonewagon_gl.cos")
        start_script(bonewagon.monitor_turns, bonewagon)
        system.buttonHandler = bone_wagon_button_handler
        bonewagon:set_selected()
        music_state:set_state(stateOO_BONE)
        IrisDown(200, 300, 1000)
        sleep_for(1250)
        stop_script(glottis.walkto)
        glottis:pop_costume()
        glottis:set_rest_chore(-1)
        glottis:ignore_boxes()
        glottis:stop_chore()
        box_off("glottis_box")
        box_off("glot_gone_box")
        bonewagon:play_chore(bonewagon_gl_gl_drive)
    else
        sg:get_in_BW()
    end
end
tr.glottis_climbs_down = function(arg1) -- line 689
    START_CUT_SCENE()
    tr.tree.has_glottis = FALSE
    tr.glottis_obj:make_touchable()
    wait_for_message()
    glottis:say_line("/trgl006/")
    glottis:wait_for_message()
    if manny.holding_wheelbarrow then
        tr:drop_wheelbarrow()
    end
    if proximity(manny.hActor, tr.switch.use_pnt_x, tr.switch.use_pnt_y, tr.switch.use_pnt_z) > 0.8 then
        start_script(manny.walkto, manny, 2.31609, 1.83491, -1.77, 0, 334.119, 0)
    end
    manny:head_look_at(tr.tree)
    glottis:set_chore_looping(gl_tree_fastens_cycle, FALSE, "gl_tree.cos")
    stop_script(tr.glottis_tinker_sfx)
    glottis:wait_for_chore(gl_tree_fastens_cycle, "gl_tree.cos")
    if find_script(manny.walkto) then
        wait_for_script(manny.walkto)
    end
    glottis:play_chore(gl_tree_jumpdown, "gl_tree.cos")
    glottis:wait_for_chore(gl_tree_jumpdown, "gl_tree.cos")
    glottis:stop_chore()
    glottis:pop_costume()
    glottis:push_costume("gl_fastwalk.cos")
    box_on("glottis_box")
    glottis:follow_boxes()
    glottis:set_collision_mode(COLLISION_OFF)
    tr.barrow:set_collision_mode(COLLISION_OFF)
    glottis:head_look_at(nil)
    glottis:set_walk_chore(0, "gl_fastwalk.cos")
    glottis:set_walk_rate(0.85)
    glottis:set_rest_chore(glottis_home_pose, "glottis.cos")
    glottis:walkto(2.26387, 2.95142, -1.77, 0, 190, 0)
    glottis:wait_for_actor()
    glottis:pop_costume()
    glottis:set_rest_chore(-1)
    glottis:ignore_boxes()
    glottis:stop_chore()
    box_off("glottis_box")
    box_off("glot_gone_box")
    glottis:default()
    glottis:put_in_set(tr)
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    glottis:play_chore(glottis_stop_talk, "glottis.cos")
    start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
    tr.tree.just_weighted = TRUE
    break_here()
    glottis:head_look_at_manny()
    tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
    if tr.switch.pos == "down" then
        tr.switch:use()
    end
    END_CUT_SCENE()
end
tr.glottis_in_tree = function(arg1) -- line 756
    sleep_for(10000)
    while inInventorySet() do
        break_here()
    end
    start_script(tr.glottis_climbs_down, tr)
end
tr.grab_weight_n_go = function(arg1) -- line 764
    local local1 = tr.barrow:getpos()
    tr.barrow:set_collision_mode(COLLISION_OFF)
    stop_script(glottis.new_run_idle)
    box_on("glottis_box")
    box_on("glot_gone_box")
    glottis:head_look_at(nil)
    glottis:push_costume("gl_fastwalk.cos")
    glottis:follow_boxes()
    glottis:set_walk_chore(0, "gl_fastwalk.cos")
    glottis:set_walk_rate(0.85000002)
    glottis:set_rest_chore(glottis_home_pose, "glottis.cos")
    glottis:set_turn_chores(gl_fastwalk_swivel_left, gl_fastwalk_swivel_right)
    glottis:set_collision_mode(COLLISION_OFF)
    glottis:walk_and_face(local1.x - 0.0704, local1.y + 0.62962002, -1.77, 0, 169.752, 0)
    glottis:wait_for_actor()
    glottis:stop_chore(glottis_rock_loop, "glottis.cos")
    if not (glottis:get_costume() == "gl_tree.cos") then
        glottis:push_costume("gl_tree.cos")
    end
    glottis:stop_chore()
    glottis:run_chore(gl_tree_grabwt, "gl_tree.cos")
    glottis:stop_chore()
    glottis:pop_costume()
    glottis:play_chore(gl_fastwalk_show_weight, "gl_fastwalk.cos")
    glottis:walkto(4.4216099, 6.41011, -1.78091, 0, 284.82901, 0, TRUE)
    glottis:wait_for_actor()
    glottis:pop_costume()
    glottis:stop_chore(nil, "glottis.cos")
    glottis:ignore_boxes()
    glottis:set_rest_chore(-1)
    glottis:stop_chore()
    glottis:setpos(4.4216099, 6.41011, -1.78091)
    glottis:setrot(0, 284.82901, 0)
    glottis:push_costume("gl_tree.cos")
    glottis:stop_chore(nil, "glottis.cos")
    glottis:play_chore(glottis_stop_talk, "glottis.cos")
    glottis:run_chore(gl_tree_climb, "gl_tree.cos")
    box_off("glottis_box")
    box_on("glot_gone_box")
    tr.barrow:set_collision_mode(COLLISION_BOX, 0.80000001)
end
tr.glottis_climbs_tree = function(arg1) -- line 817
    START_CUT_SCENE()
    tr.tree.has_glottis = TRUE
    stop_script(glottis.new_run_idle)
    if not tr.tree.interested_glottis then
        LoadCostume("gl_akimbo_idles.cos")
        tr.tree.interested_glottis = TRUE
        glottis:head_look_at_manny()
        manny:head_look_at(tr.glottis_obj)
        manny:turn_toward_entity(tr.glottis_obj)
        glottis:say_line("/trgl007/")
        wait_for_message()
        glottis:head_look_at(tr.tree)
        glottis:say_line("/trgl008/")
        sleep_for(2000)
        glottis:head_look_at_manny()
        wait_for_message()
        glottis:say_line("/trgl009/")
        glottis:head_look_at(nil)
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        sleep_for(500)
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        wait_for_message()
        glottis:stop_chore()
        glottis:say_line("/trgl010/")
        glottis:push_costume("gl_akimbo_idles.cos")
        glottis:run_chore(gl_akimbo_idles_hand_on_chest, "gl_akimbo_idles.cos")
        glottis:run_chore(gl_akimbo_idles_hand_chest_akimbo, "gl_akimbo_idles.cos")
        wait_for_message()
        glottis:stop_chore()
        glottis:say_line("/trgl011/")
        glottis:run_chore(gl_akimbo_idles_on_right_hand, "gl_akimbo_idles.cos")
        sleep_for(1500)
        glottis:stop_chore(gl_akimbo_idles_on_right_hand, "gl_akimbo_idles.cos")
        glottis:run_chore(gl_akimbo_idles_on_left_hand, "gl_akimbo_idles.cos")
        sleep_for(1000)
        glottis:stop_chore(gl_akimbo_idles_on_left_hand, "gl_akimbo_idles.cos")
        glottis:run_chore(gl_akimbo_idles_hands_to_akimbo, "gl_akimbo_idles.cos")
        glottis:stop_chore(gl_akimbo_idles_hands_to_akimbo, "gl_akimbo_idles.cos")
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        sleep_for(750)
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        glottis:run_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:stop_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:pop_costume()
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        wait_for_message()
        start_script(tr.grab_weight_n_go)
        glottis:say_line("/trgl012/")
        wait_for_message()
        glottis:say_line("/trgl013/")
    else
        glottis:say_line("/trgl014/")
        start_script(tr.grab_weight_n_go)
    end
    manny:head_look_at(tr.tree)
    manny:turn_toward_entity(tr.tree)
    wait_for_script(tr.grab_weight_n_go)
    tr.glottis_obj:make_untouchable()
    if tr.tree.angered_glottis == 0 then
        glottis:say_line("/trgl015/")
    elseif tr.tree.angered_glottis < 7 then
        glottis:say_line("/trgl016/")
    elseif tr.tree.angered_glottis == 7 then
        glottis:say_line("/trgl017/")
    else
        glottis:say_line("/trgl018/")
    end
    glottis:run_chore(gl_tree_fasten_wt_in, "gl_tree.cos")
    start_script(tr.glottis_tinker_sfx)
    glottis:wait_for_message()
    glottis:play_chore_looping(gl_tree_fastens_cycle, "gl_tree.cos")
    END_CUT_SCENE()
    manny:head_look_at(nil)
    start_script(tr.glottis_in_tree)
end
tr.glottis_tinker_sfx = function(arg1) -- line 906
    local local1
    while 1 do
        local1 = pick_one_of({ "trWork1.wav", "trWork2.wav", "trWork3.wav", "trWork4.wav", "trWork5.wav" })
        start_sfx(local1, IM_LOW_PRIORITY, rndint(60, 90))
        set_pan(local1, 85)
        wait_for_sound(local1)
    end
end
tr.walk_glottis_back = function() -- line 917
    box_on("glottis_box")
    box_on("glot_gone_box")
    glottis:set_collision_mode(COLLISION_OFF)
    tr.barrow:set_collision_mode(COLLISION_OFF)
    glottis:push_costume("gl_fastwalk.cos")
    glottis:follow_boxes()
    glottis:set_walk_chore(0, "gl_fastwalk.cos")
    glottis:set_walk_rate(0.85)
    glottis:set_rest_chore(glottis_home_pose, "glottis.cos")
    glottis:walkto(2.26387, 2.95142, -1.77, 0, 190, 0)
    glottis:wait_for_actor()
    glottis:pop_costume()
    glottis:ignore_boxes()
    glottis:set_rest_chore(-1)
    glottis:stop_chore()
    glottis:play_chore(glottis_stop_talk, "glottis.cos")
    glottis:play_chore(glottis_home_pose, "glottis.cos")
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
    box_off("glottis_box")
    box_off("glot_gone_box")
end
tr.let_glottis_down = function(arg1) -- line 942
    START_CUT_SCENE()
    tr.tree.angered_glottis = tr.tree.angered_glottis + 1
    wait_for_message()
    glottis:set_visibility(TRUE)
    set_override(tr.let_glottis_down_override)
    glottis:play_chore(gl_tree_falls_fr_spin, "gl_tree.cos")
    glottis:wait_for_chore(gl_tree_falls_fr_spin, "gl_tree.cos")
    glottis:stop_chore()
    glottis:pop_costume()
    start_script(tr.walk_glottis_back)
    glottis:head_look_at_manny()
    enable_head_control(FALSE)
    sleep_for(1000)
    if tr.tree.angered_glottis < 7 then
        glottis:say_line("/trgl019/")
        start_script(manny.turn_toward_entity, manny, tr.glottis_obj)
        wait_for_message()
        manny:head_look_at(tr.glottis_obj)
        if tr.tree.angered_glottis == 1 then
            manny:say_line("/trma020/")
        elseif tr.tree.angered_glottis == 2 then
            manny:say_line("/trma021/")
        elseif tr.tree.angered_glottis == 3 then
            manny:say_line("/trma022/")
        elseif tr.tree.angered_glottis == 4 then
            manny:say_line("/trma023/")
        elseif tr.tree.angered_glottis == 5 then
            manny:say_line("/trma024/")
            wait_for_message()
            glottis:say_line("/trgl025/")
            wait_for_message()
            manny:say_line("/trma026/")
        else
            manny:say_line("/trma027/")
        end
        wait_for_message()
        glottis:wait_for_actor()
        glottis:stop_chore()
        glottis:push_costume("gl_akimbo_idles.cos")
        glottis:play_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:say_line("/trgl028/")
        glottis:wait_for_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:stop_chore()
        glottis:pop_costume()
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        wait_for_message()
    else
        glottis:say_line("/trgl029/")
    end
    glottis:wait_for_actor()
    tr.glottis_obj:make_touchable()
    tr.tree.has_glottis = FALSE
    glottis:default()
    glottis:put_in_set(tr)
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    glottis:head_look_at(tr.barrow)
    glottis:play_chore(glottis_home_pose, "glottis.cos")
    glottis:wait_for_message()
    start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
    tr.switch:use()
    manny:head_look_at(nil)
    enable_head_control(TRUE)
    END_CUT_SCENE()
end
tr.let_glottis_down_override = function() -- line 1017
    kill_override()
    stop_script(tr.walk_glottis_back)
    glottis:default()
    glottis:put_in_set(tr)
    glottis:head_look_at(tr.barrow)
    shut_up_everybody()
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    tr.glottis_obj:make_touchable()
    tr.tree.has_glottis = FALSE
    glottis:play_chore(glottis_home_pose, "glottis.cos")
    start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
    if tr.switch.pos == "down" then
        tr.switch:use()
    end
    manny:head_look_at(nil)
    enable_head_control(TRUE)
end
tr.start_wheel_sfx = function(arg1) -- line 1037
    single_start_sfx("treeWeel.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("treeWeel.IMU", 750, tr.wheel_vol)
end
tr.stop_wheel_sfx = function(arg1) -- line 1043
    fade_sfx("treeWeel.IMU", 500, 0)
    sleep_for(500)
    stop_sound("treeWeel.IMU")
end
tr.start_up_wheel = function(arg1) -- line 1050
    START_CUT_SCENE()
    cur_puzzle_state[16] = TRUE
    manny:turn_toward_entity(tr.tree)
    manny:head_look_at(tr.tree)
    stop_script(tr.glottis_in_tree)
    stop_script(tr.glottis_tinker_sfx)
    if find_script(tr.glottis_climbs_down) then
        wait_for_script(tr.glottis_climbs_down)
    end
    start_script(tr.start_wheel_sfx, tr)
    if tr.tree.has_glottis then
        glottis:stop_chore(gl_tree_fastens_cycle, "gl_tree.cos")
        glottis:set_visibility(FALSE)
        music_state:set_state(stateTR_ESTHA)
        tree_pump:stop_chore(tree_no_spin_shake, "tree.cos")
        tree_pump:run_chore(tree_start_spin_gl, "tree.cos")
        tree_pump:stop_chore(tree_start_spin_gl, "tree.cos")
        if tr.tree.synched then
            tree_pump:play_chore_looping(tree_xab_gl, "tree.cos")
        else
            tree_pump:play_chore_looping(tree_normal_gl, "tree.cos")
        end
    else
        tree_pump:stop_chore(tree_no_spin_shake, "tree.cos")
        tree_pump:run_chore(tree_start_spin_no_gl, "tree.cos")
        tree_pump:stop_chore(tree_start_spin_no_gl, "tree.cos")
        if tr.tree.synched then
            tree_pump:play_chore_looping(tree_abnormal_no_gl, "tree.cos")
        else
            tree_pump:play_chore_looping(tree_normal, "tree.cos")
        end
    end
    if tr.tree.has_glottis then
        if not glottis.spun then
            glottis.spun = TRUE
            glottis:say_line("/trgl030/")
            wait_for_message()
            glottis:say_line("/trgl031/")
            wait_for_message()
        else
            if tr.tree.angered_glottis < 6 then
                glottis:say_line("/trgl032/")
            else
                glottis:say_line("/trgl033/")
            end
            glottis:wait_for_message()
        end
        if tr.tree.synched then
            START_CUT_SCENE()
            single_start_script(tr.drop_wheelbarrow)
            sleep_for(4000)
            END_CUT_SCENE()
            stop_sound("treeWeel.imu")
            single_start_script(cut_scene.puzl19c)
        else
            sleep_for(500)
            if tr.tree.angered_glottis < 1 then
                manny:say_line("/trma034/")
                manny:tilt_head_gesture()
            end
        end
    elseif tr.tree.just_weighted then
        stop_script(glottis.new_run_idle)
        tr.tree.just_weighted = FALSE
        glottis:head_look_at(tr.tree)
        manny:say_line("/trma035/")
        manny:twist_head_gesture()
        wait_for_message()
        glottis:head_look_at_manny()
        glottis:stop_chore()
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        glottis:push_costume("gl_akimbo_idles.cos")
        glottis:play_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:say_line("/trgl036/")
        glottis:wait_for_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
        glottis:stop_chore()
        glottis:pop_costume()
        glottis:head_look_at(nil)
        glottis:default()
        glottis:put_in_set(tr)
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        wait_for_message()
        start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
    end
    END_CUT_SCENE()
end
tr.set_up_aftermath = function(arg1) -- line 1157
    tr.tree.has_glottis = FALSE
    stop_script(tr.pump_timer_and_checker)
    stop_script(tr.glottis_in_tree)
    stop_script(glottis.talk_randomly_from_weighted_table)
    stop_script(sg.glottis_roars)
    stop_script(tr.hose_watch)
    stop_script(tr.start_up_wheel)
    tr.tree.synched = FALSE
    tr.tree:make_untouchable()
    tr.seen_pumps = TRUE
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    if manny:get_costume() == "ma_use_wb.cos" then
        manny:pop_costume()
    end
    tr.barrow:free()
    tree_pump:free()
    tr.wheelbarrow:make_untouchable()
    tr.rubble.hObjectState = tr:add_object_state(tr_estha, "tr_rubble.bm", nil, OBJSTATE_STATE)
    tr.rubble:set_object_state("tr_rubble.cos")
    tr.rubble:play_chore(0)
    box_off("tr_pmpws")
    box_off("rubble_box")
    box_on("glot_gone_box")
    box_off("glottis_box")
end
tr.set_up_actors = function(arg1) -- line 1186
    glottis:default()
    glottis:ignore_boxes()
    glottis:put_in_set(tr)
    glottis:setpos(2.26387, 2.95142, -1.77)
    glottis:setrot(0, 190, 0)
    if not tr.barrow then
        tr.barrow = Actor:create(nil, nil, nil, "wheelbarrow")
    end
    tr.barrow:set_costume("wheelbarrow.cos")
    tr.barrow:follow_boxes()
    tr.barrow:put_in_set(tr)
    tr.barrow:set_walk_chore(wheelbarrow_ma_walk, "wheelbarrow.cos")
    tr.barrow:set_rest_chore(nil)
    manny:set_walk_rate(0.4)
    tr.barrow:setpos(3.14042, 2.12169, -1.77)
    tr.barrow:setrot(0, 243.648, 0)
    glottis:set_visibility(FALSE)
    if not tr.seen_pumps then
        tr.barrow:set_visibility(FALSE)
    else
        tr.barrow:set_visibility(TRUE)
        tr.barrow:set_collision_mode(COLLISION_BOX, 0.8)
        tr.update_barrow_object_pos()
    end
    if not tree_pump then
        tree_pump = Actor:create(nil, nil, nil, "tree")
        tree_pump:set_costume("tree.cos")
    end
    tree_pump:put_in_set(tr)
    tree_pump:set_softimage_pos(55.1336, -17.7856, -70.8365)
    tree_pump:setrot(0, 180, 0)
    tree_pump:play_chore_looping(tree_normal, "tree.cos")
end
tr.enter = function(arg1) -- line 1231
    if not mod_solved then
        LoadCostume("gl_akimbo_idles.cos")
        LoadCostume("glottis.cos")
        LoadCostume("tree.cos")
        tr.switch.hObjectState = tr:add_object_state(tr_pmpws, "tr_lever.bm", nil, OBJSTATE_STATE)
        tr.switch:set_object_state("tr_lever.cos")
        start_script(tr.pump_timer_and_checker)
        tr:set_up_actors()
        preload_sfx("hoseKink.wav")
        preload_sfx("hoseRlse.wav")
    else
        tr:set_up_aftermath()
    end
    if tr.seen_pumps then
        box_off("intro_trigger")
    end
    start_script(tr.start_wheel_sfx, tr)
    tr:add_ambient_sfx({ "treeBuz1.WAV", "treeBuz2.WAV", "treeBuz3.WAV", "treeBuz4.WAV" }, { min_pan = 0, max_pan = 64, min_volume = 20, max_volume = 80 })
    tr:add_object_state(tr_pmpws, "tr_bulge1.bm", nil, OBJSTATE_OVERLAY, TRUE)
    tr:add_object_state(tr_pmpws, "tr_bulge2.bm", nil, OBJSTATE_OVERLAY, TRUE)
    tr:add_object_state(tr_pmpws, "tr_bulge3.bm", nil, OBJSTATE_OVERLAY, TRUE)
    tr:add_object_state(tr_pmpws, "tr_bulge4.bm", nil, OBJSTATE_OVERLAY, TRUE)
    tr.bulges:set_object_state("tr_bulges.cos")
    tr.bulges:play_chore(tr_bulges_no_bulges)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 500, 2000, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(glottis.hActor, 0)
    SetActorShadowPoint(glottis.hActor, 500, 2000, 6000)
    SetActorShadowPlane(glottis.hActor, "shadow1")
    AddShadowPlane(glottis.hActor, "shadow1")
end
tr.camerachange = function(arg1, arg2, arg3) -- line 1284
    music_state:set_state(tr:update_music_state(arg3))
end
tr.exit = function(arg1) -- line 1292
    stop_script(tr.pump_timer_and_checker)
    tr.barrow:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    glottis:free()
    if manny.holding_wheelbarrow then
        tr.set_walk_backwards(FALSE)
        manny:default()
        stop_script(tr.check_hoses)
        system.buttonHandler = SampleButtonHandler
        manny.holding_wheelbarrow = FALSE
    end
    tr.barrow:free()
    tr:stop_ambient_sfx(TRUE)
    start_script(tr.stop_wheel_sfx, tr)
    tr.rubble:free_object_state()
    tr.switch:free_object_state()
    KillActorShadows(manny.hActor)
    KillActorShadows(glottis.hActor)
end
tr.update_music_state = function(arg1, arg2) -- line 1318
    if not arg2 then
        arg2 = tr:current_setup()
    end
    if not mod_solved then
        if arg2 == tr_estha then
            return stateTR_ESTHA
        else
            return stateTR_PMPWS
        end
    else
        return stateTR_SOLVED
    end
end
tr.bulges = Object:create(tr, "", 0, 0, 0, { range = 0 })
tr.woods = { }
tr.tr_woods_box = tr.woods
tr.woods.walkOut = function(arg1) -- line 1341
    manny:say_line("/trma037/")
end
tr.pump1 = Object:create(tr, "/trtx038/pump", 0, 0, 0, { range = 0 })
tr.pump1.beat = 3
tr.pump1.strike = function(arg1) -- line 1349
    tree_pump:play_chore(tree_top_left_pump_on, "tree.cos")
end
tr.pump1.walkOut = function(arg1, arg2) -- line 1353
    if arg2 == tr.barrow then
        arg1.beat = 0
        start_script(tr.hose_watch, arg1, arg2)
    end
end
tr.hose_box4 = tr.pump1
tr.pump2 = Object:create(tr, "/trtx039/pump", 0, 0, 0, { range = 0 })
tr.pump2.beat = 1
tr.pump2.strike = function(arg1) -- line 1367
    tree_pump:play_chore(tree_btm_left_pump_on, "tree.cos")
end
tr.pump2.walkOut = function(arg1, arg2) -- line 1371
    if arg2 == tr.barrow then
        arg1.beat = 0
        start_script(tr.hose_watch, arg1, arg2)
    end
end
tr.hose_box3 = tr.pump2
tr.pump3 = Object:create(tr, "/trtx040/pump", 0, 0, 0, { range = 0 })
tr.pump3.beat = 2
tr.pump3.strike = function(arg1) -- line 1385
    tree_pump:play_chore(tree_top_rt_pump_on, "tree.cos")
end
tr.pump3.walkOut = function(arg1, arg2) -- line 1389
    if arg2 == tr.barrow then
        arg1.beat = 0
        start_script(tr.hose_watch, arg1, arg2)
    end
end
tr.hose_box2 = tr.pump3
tr.pump4 = Object:create(tr, "/trtx041/pump", 0, 0, 0, { range = 0 })
tr.pump4.beat = 4
tr.pump4.strike = function(arg1) -- line 1403
    tree_pump:play_chore(tree_btm_rt_pump_on, "tree.cos")
end
tr.pump4.walkOut = function(arg1, arg2) -- line 1407
    if arg2 == tr.barrow then
        arg1.beat = 0
        start_script(tr.hose_watch, arg1, arg2)
    end
end
tr.hose_box1 = tr.pump4
tr.trailer = Object:create(tr, "/trtx042/trailer", 1.38989, -0.028965, -1.3, { range = 1 })
tr.trailer.use_pnt_x = 1.84404
tr.trailer.use_pnt_y = -0.27755299
tr.trailer.use_pnt_z = -1.77
tr.trailer.use_rot_x = 0
tr.trailer.use_rot_y = 49.9119
tr.trailer.use_rot_z = 0
tr.trailer.lookAt = function(arg1) -- line 1425
    manny:say_line("/trma043/")
end
tr.trailer.pickUp = function(arg1) -- line 1429
    manny:say_line("/trma044/")
end
tr.trailer.use = tr.trailer.pickUp
tr.switch = Object:create(tr, "/trtx045/switch", 2.0009999, 0.86723, -1.336, { range = 0.69999999 })
tr.switch.use_pnt_x = 2.2
tr.switch.use_pnt_y = 0.78223002
tr.switch.use_pnt_z = -1.77
tr.switch.use_rot_x = 0
tr.switch.use_rot_y = -249.327
tr.switch.use_rot_z = 0
tr.switch.pos = "up"
tr.switch.lookAt = function(arg1) -- line 1446
    if mod_solved then
        arg1:use()
    elseif arg1.pos == "up" then
        manny:say_line("/trma046/")
    else
        manny:say_line("/trma047/")
    end
end
tr.switch.use = function(arg1) -- line 1458
    if mod_solved then
        manny:say_line("/trma048/")
    else
        manny:head_look_at(arg1)
        if manny:walkto_object(arg1) then
            if arg1.pos == "up" then
                arg1:flipDn()
            else
                arg1:flipUp()
            end
        end
    end
end
tr.switch.flipUp = function(arg1) -- line 1473
    START_CUT_SCENE()
    arg1.pos = "up"
    manny:wait_for_actor()
    manny:push_costume("ma_use_lever.cos")
    manny:play_chore(ma_use_lever_lever_up, "ma_use_lever.cos")
    sleep_for(250)
    arg1:play_chore(tr_lever_switch_up)
    arg1:wait_for_chore()
    manny:wait_for_chore(ma_use_lever_lever_up, "ma_use_lever.cos")
    manny:pop_costume()
    END_CUT_SCENE()
    start_script(tr.start_up_wheel, tr)
end
tr.switch.flipDn = function(arg1) -- line 1488
    arg1.pos = "down"
    START_CUT_SCENE()
    manny:wait_for_actor()
    manny:push_costume("ma_use_lever.cos")
    manny:play_chore(ma_use_lever_lever_down, "ma_use_lever.cos")
    sleep_for(566)
    arg1:play_chore(tr_lever_switch_down)
    arg1:wait_for_chore()
    manny:wait_for_chore(ma_use_lever_lever_down, "ma_use_lever.cos")
    manny:pop_costume()
    start_script(tr.stop_wheel_sfx, tr)
    if tr.tree.has_glottis then
        music_state:set_sequence(seqGlottTreeFall)
        music_state:update()
        if tr.tree.synched then
            tree_pump:stop_looping_chore(tree_xab_gl, "tree.cos", FALSE)
        else
            tree_pump:stop_looping_chore(tree_normal_gl, "tree.cos", FALSE)
        end
        tree_pump:run_chore(tree_stop_spin_gl, "tree.cos")
        tree_pump:stop_chore(tree_stop_spin_gl, "tree.cos")
        tree_pump:play_chore(tree_hide_gl, "tree.cos")
    else
        if tr.tree.synched then
            tree_pump:set_chore_looping(tree_abnormal_no_gl, FALSE, "tree.cos")
            tree_pump:wait_for_chore(tree_abnormal_no_gl, "tree.cos")
            tree_pump:stop_chore(tree_abnormal_no_gl, "tree.cos")
        else
            tree_pump:set_chore_looping(tree_normal, FALSE, "tree.cos")
            tree_pump:wait_for_chore(tree_normal, "tree.cos")
            tree_pump:stop_chore(tree_normal, "tree.cos")
        end
        tree_pump:run_chore(tree_stop_spin_no_gl, "tree.cos")
        tree_pump:stop_chore(tree_stop_spin_no_gl, "tree.cos")
    end
    tree_pump:play_chore_looping(tree_no_spin_shake, "tree.cos")
    END_CUT_SCENE()
    if tr.tree.has_glottis then
        tr:let_glottis_down()
    else
        tr:glottis_climbs_tree()
    end
end
tr.switch.pickUp = tr.switch.use
tr.tree = Object:create(tr, "/trtx049/tree", 5.4289398, 6.7318702, 0, { range = 3.3 })
tr.tree.use_pnt_x = 6.1333599
tr.tree.use_pnt_y = 6.48316
tr.tree.use_pnt_z = -1.77
tr.tree.use_rot_x = 0
tr.tree.use_rot_y = 375.88599
tr.tree.use_rot_z = 0
tr.tree.synched = FALSE
tr.tree.angered_glottis = 0
tr.tree.lookAt = function(arg1) -- line 1548
    if not tr.tree.interested_glottis then
        manny:say_line("/trma050/")
    else
        manny:say_line("/trma055/")
    end
    manny:twist_head_gesture()
end
tr.tree.use = function(arg1) -- line 1557
    manny:say_line("/trma051/")
end
tr.rubble = Object:create(tr, "", 0, 0, 0, { range = 0 })
tr.glottis_obj = Object:create(tr, "/trtx052/Glottis", 2.3989899, 2.63112, -1.1246001, { range = 1.5 })
tr.glottis_obj.use_pnt_x = 2.60499
tr.glottis_obj.use_pnt_y = 2.5146201
tr.glottis_obj.use_pnt_z = -1.77
tr.glottis_obj.use_rot_x = 0
tr.glottis_obj.use_rot_y = 66.955803
tr.glottis_obj.use_rot_z = 0
tr.glottis_obj.lookAt = function(arg1) -- line 1571
    if glottis.spun then
        manny:say_line("/trma053/")
    else
        manny:say_line("/trma054/")
    end
end
tr.glottis_obj.use = function(arg1) -- line 1579
    if tr.switch.pos == "down" then
        START_CUT_SCENE()
        manny:say_line("/trma055/")
        wait_for_message()
        END_CUT_SCENE()
        tr:glottis_climbs_tree()
    elseif not tr.tree.discussed then
        START_CUT_SCENE()
        tr.tree.discussed = TRUE
        LoadCostume("gl_akimbo_idles.cos")
        set_override(tr.glottis_obj.use_override)
        stop_script(glottis.new_run_idle)
        manny:shrug_gesture()
        manny:say_line("/trma056/")
        wait_for_message()
        glottis:say_line("/trgl057/")
        glottis:wait_for_chore()
        glottis:play_chore(glottis_smart_ass, "glottis.cos")
        wait_for_message()
        glottis:say_line("/trgl058/")
        glottis:wait_for_chore(glottis_smart_ass, "glottis.cos")
        glottis:stop_chore(glottis_smart_ass, "glottis.cos")
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        sleep_for(500)
        glottis:push_costume("gl_akimbo_idles.cos")
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        glottis:run_chore(gl_akimbo_idles_head_flick, "gl_akimbo_idles.cos")
        glottis:stop_chore(gl_akimbo_idles_head_flick, "gl_akimbo_idles.cos")
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        wait_for_message()
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        glottis:play_chore(gl_akimbo_idles_lean_in_talk, "gl_akimbo_idles.cos")
        sleep_for(200)
        glottis:say_line("/trgl059/")
        glottis:wait_for_chore(gl_akimbo_idles_lean_in_talk, "gl_akimbo_idles.cos")
        glottis:stop_chore(gl_akimbo_idles_lean_in_talk, "gl_akimbo_idles.cos")
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        glottis:head_look_at(tr.tree)
        sleep_for(2000)
        glottis:head_look_at(nil)
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        glottis:run_chore(gl_akimbo_idles_pick_wedgie, "gl_akimbo_idles.cos")
        wait_for_message()
        glottis:head_look_at_manny()
        manny:say_line("/trma060/")
        wait_for_message()
        glottis:wait_for_chore(gl_akimbo_idles_pick_wedgie, "gl_akimbo_idles.cos")
        glottis:stop_chore(gl_akimbo_idles_pick_wedgie, "gl_akimbo_idles.cos")
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        glottis:say_line("/trgl061/")
        sleep_for(500)
        glottis:head_look_at(nil)
        sleep_for(500)
        glottis:stop_chore(glottis_home_pose, "glottis.cos")
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        sleep_for(200)
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        sleep_for(200)
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        wait_for_message()
        glottis:stop_chore(glottis_flip_ears, "glottis.cos")
        glottis:say_line("/trgl062/")
        glottis:run_chore(gl_akimbo_idles_nod, "gl_akimbo_idles.cos")
        glottis:stop_chore()
        glottis:pop_costume()
        glottis:default()
        glottis:put_in_set(tr)
        glottis:play_chore(glottis_home_pose, "glottis.cos")
        sleep_for(500)
        start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        glottis:head_look_at_manny()
        manny:say_line("/trma063/")
        wait_for_message()
        glottis:say_line("/trgl064/")
        glottis:head_look_at(tr.switch)
        sleep_for(1000)
        glottis:head_look_at(tr.tree)
        wait_for_message()
        glottis:head_look_at(nil)
        END_CUT_SCENE()
    end
end
tr.glottis_obj.use_override = function(arg1) -- line 1674
    kill_override()
    if glottis:get_costume() == "gl_akimbo_idles.cos" then
        glottis:stop_chore()
        glottis:pop_costume()
    end
    glottis:shut_up()
    manny:shut_up()
    glottis:default()
    glottis:put_in_set(tr)
    glottis:play_chore(glottis_home_pose, "glottis.cos")
    start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis.cos")
end
tr.bone_wagon = Object:create(tr, "/trtx065/Bone Wagon", 1.26989, -3.3589599, -1, { range = 1.4 })
tr.bone_wagon.use_pnt_x = 1.36216
tr.bone_wagon.use_pnt_y = -2.7460599
tr.bone_wagon.use_pnt_z = -1.77
tr.bone_wagon.use_rot_x = 0
tr.bone_wagon.use_rot_y = -567.37
tr.bone_wagon.use_rot_z = 0
tr.bone_wagon:make_untouchable()
tr.bone_wagon.lookAt = function(arg1) -- line 1699
    if mod_solved then
        manny:say_line("/trma066/")
    else
        manny:say_line("/trma067/")
    end
end
tr.bone_wagon.use = function(arg1) -- line 1707
    if tr.tree.has_glottis then
        manny:say_line("/trma068/")
    else
        START_CUT_SCENE()
        tr:get_in_BW()
        if not mod_solved then
            tr:drive_out(FALSE)
        else
            tr:drive_out(TRUE)
        end
        END_CUT_SCENE()
    end
end
tr.bone_wagon.pickUp = function(arg1) -- line 1722
    sg.bone_wagon:pickUp()
end
na.bone_wagon.use_scythe = function(arg1) -- line 1726
    sg.bone_wagon:use_scythe()
end
na.bone_wagon.use_bone = function(arg1) -- line 1730
    sg.bone_wagon:use_bone()
end
tr.wheelbarrow = Object:create(tr, "/trtx069/wheelbarrow", 2.9161, 2.2003, -1.6036, { range = 1 })
tr.wheelbarrow.use_pnt_x = 2.70576
tr.wheelbarrow.use_pnt_y = 2.34828
tr.wheelbarrow.use_pnt_z = -1.77
tr.wheelbarrow.use_rot_x = 0
tr.wheelbarrow.use_rot_y = 243.64799
tr.wheelbarrow.use_rot_z = 0
tr.wheelbarrow.lookAt = function(arg1) -- line 1743
    manny:say_line("/trma070/")
end
tr.wheelbarrow.use = function(arg1) -- line 1747
    start_script(tr.pick_up_wheelbarrow)
end
tr.wheelbarrow.out_of_bounds = function(arg1) -- line 1751
    manny:say_line("/trma071/")
    wait_for_message()
    glottis:say_line("/trgl072/")
end
tr.wheelbarrow.pickUp = tr.wheelbarrow.use
tr.sg_door = Object:create(tr, "/trtx073/road", 5.3698902, -2.6089599, 0.30000001, { range = 1 })
tr.sg_door.use_pnt_x = 4.3702898
tr.sg_door.use_pnt_y = -1.68819
tr.sg_door.use_pnt_z = -1.77
tr.sg_door.use_rot_x = 0
tr.sg_door.use_rot_y = -129.858
tr.sg_door.use_rot_z = 0
tr.sg_door.out_pnt_x = 5.3698902
tr.sg_door.out_pnt_y = -2.6089599
tr.sg_door.out_pnt_z = 0.30000001
tr.sg_door.out_rot_x = 0
tr.sg_door.out_rot_y = 0
tr.sg_door.out_rot_z = 0
tr.tr_sg_box = tr.sg_door
tr.tr_sg_box2 = tr.sg_door
tr.sg_door.lookAt = function(arg1) -- line 1792
    manny:say_line("/trma074/")
end
tr.sg_door.use = function(arg1) -- line 1796
    if not manny.is_driving then
        manny:say_line("/trma075/")
    end
end
tr.sg_door.walkOut = tr.sg_door.use

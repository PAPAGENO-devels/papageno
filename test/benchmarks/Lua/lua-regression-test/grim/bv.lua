CheckFirstTime("bv.lua")
bv = Set:create("bv.set", "beaver room", { bv_gtefg = 0, bv_gtews = 1 })
bv.get_in_BW = function(arg1) -- line 13
    stop_script(sg.glottis_roars)
    inventory_disabled = TRUE
    START_CUT_SCENE()
    MakeSectorActive("sg_box2", FALSE)
    manny:walkto_object(bv.bone_wagon)
    bonewagon:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    manny:push_costume("ma_climb_bw.cos")
    manny:play_chore(ma_climb_bw_get_on_bw, "ma_climb_bw.cos")
    sleep_for(1000)
    manny:pop_costume("ma_climb_bw.cos")
    manny:put_in_set(nil)
    END_CUT_SCENE()
    bonewagon:default("no shocks")
    system.currentSet.bone_wagon:make_untouchable()
    manny.is_driving = TRUE
    start_script(bonewagon.monitor_turns, bonewagon)
    sg:enable_bonewagon_boxes(TRUE)
    system.buttonHandler = bone_wagon_button_handler
    bonewagon:set_selected()
    bv:drive_out()
end
bv.drive_in = function(arg1) -- line 41
    bv:switch_to_set()
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    stop_script(bonewagon.monitor_turns)
    bonewagon:stop_cruise_sounds(TRUE)
    bonewagon:free()
    manny.is_driving = FALSE
    bv:put_bonewagon_in_set()
    MakeSectorActive("bw_here1", TRUE)
    MakeSectorActive("bw_here2", TRUE)
    MakeSectorActive("bw_here3", TRUE)
    MakeSectorActive("bw_here4", TRUE)
    MakeSectorActive("sg_box2", TRUE)
    MakeSectorActive("bw_gone", FALSE)
    MakeSectorActive("bw_gone2", FALSE)
    manny:default("action")
    manny:put_in_set(bv)
    manny:setpos(-6.96196, -5.59888, 1.44995)
    manny:setrot(0, 316.178, 0)
    system.buttonHandler = SampleButtonHandler
    manny:set_selected()
    inventory_disabled = FALSE
    if com_solved then
        bv:talk_gate()
    end
end
bv.put_bonewagon_in_set = function(arg1) -- line 78
    NewObjectState(bv_gtefg, OBJSTATE_UNDERLAY, "bv_bone.bm", "bv_bone.zbm")
    bv.bone_wagon:set_object_state("bv_bone.cos")
    bv.bone_wagon:make_touchable()
    bv.bone_wagon:play_chore(0)
    glottis:put_in_set(bv)
    glottis:ignore_boxes()
    glottis:setpos(-8.53971, -6.6831, 1.07249)
    glottis:setrot(0, 285, 0)
    glottis:set_visibility(TRUE)
    glottis:set_collision_mode(COLLISION_OFF)
    glottis:set_costume(nil)
    glottis:set_costume("bonewagon_gl.cos")
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
    glottis:play_chore(bonewagon_gl_hide_bw, "bonewagon_gl.cos")
    glottis:play_chore(bonewagon_gl_vrm2drv)
    single_start_script(sg.glottis_roars, sg, glottis)
    bv.bone_wagon.touchable = TRUE
end
bv.drive_out = function(arg1) -- line 110
    if bd.all_beavers_dead and com_solved then
    elseif com_solved and not bd.talked_gate then
        bv:talk_gate()
    elseif not bv.driven_out and bv.gate.used then
        START_CUT_SCENE()
        bv.driven_out = TRUE
        manny:say_line("/bdma007/")
        wait_for_message()
        glottis:say_line("/bdgl008/")
        wait_for_message()
        glottis:say_line("/bdgl009/")
        wait_for_message()
        glottis:say_line("/bdgl010/")
        wait_for_message()
        glottis:say_line("/bdgl011/")
        wait_for_message()
        END_CUT_SCENE()
    end
    START_CUT_SCENE()
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
    bonewagon:setpos(10.7812, 4.2, 0)
    bonewagon:setrot(0, 137, 0)
    bonewagon:set_walk_rate(bonewagon.max_walk_rate)
    bonewagon:driveto(9.86, 3.38, 0)
    END_CUT_SCENE()
end
bv.talk_gate = function(arg1) -- line 154
    START_CUT_SCENE()
    bv.talked_gate = TRUE
    wait_for_message()
    manny:say_line("/bdma001/")
    wait_for_message()
    manny:say_line("/bdma002/")
    wait_for_message()
    glottis:say_line("/bdgl003/")
    wait_for_message()
    glottis:say_line("/bdgl004/")
    wait_for_message()
    manny:say_line("/bdma005/")
    wait_for_message()
    END_CUT_SCENE()
end
bv.set_up_actors = function(arg1) -- line 176
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not table_actor[local1] then
            table_actor[local1] = Actor:create(nil, nil, nil, "table" .. local1)
        end
        table_actor[local1]:set_costume("x_spot.cos")
        table_actor[local1]:set_visibility(FALSE)
        table_actor[local1]:put_in_set(bv)
        table_actor[local1]:set_collision_mode(COLLISION_SPHERE)
        if local1 == 1 then
            table_actor[local1]:setpos({ x = -6.6742401, y = -4.7673802, z = 1.4 })
            SetActorCollisionScale(table_actor[local1].hActor, 0.40000001)
        elseif local1 == 2 then
            table_actor[local1]:setpos({ x = -6.2895498, y = -4.2446198, z = 1.4 })
            SetActorCollisionScale(table_actor[local1].hActor, 0.44999999)
        elseif local1 == 3 then
            table_actor[local1]:setpos({ x = -6.6375198, y = -4.3564701, z = 1.4 })
            SetActorCollisionScale(table_actor[local1].hActor, 0.2)
        end
    until local1 == 3
end
bv.enter = function(arg1) -- line 201
    if system.lastSet == lb then
        bv.entered_from = lb
    elseif system.lastSet == sg then
        bv.entered_from = sg
    end
    bv:set_up_actors()
    NewObjectState(bv_gtews, OBJSTATE_STATE, "bv_door.bm")
    bv.bd_door:set_object_state("bv_door.cos")
    if not bv.gate.used then
        MakeSectorActive("gate_box", FALSE)
    else
        bv.bd_door.interest_actor:complete_chore(0)
    end
    NewObjectState(bv_gtews, OBJSTATE_UNDERLAY, "bv_lock_open.bm")
    bv.padlock:set_object_state("bv_lock.cos")
    bv.padlock:make_touchable()
    bv.padlock.interest_actor:put_in_set(bv)
    if bv.padlock.unlocked then
        bv.padlock:play_chore(0)
    else
        bv.padlock:play_chore(1)
    end
    if bv.bone_wagon.touchable then
        MakeSectorActive("bw_here1", TRUE)
        MakeSectorActive("bw_here2", TRUE)
        MakeSectorActive("bw_here3", TRUE)
        MakeSectorActive("bw_here4", TRUE)
        MakeSectorActive("sg_box2", TRUE)
        MakeSectorActive("bw_gone", FALSE)
        MakeSectorActive("bw_gone2", FALSE)
        bv:put_bonewagon_in_set()
    else
        MakeSectorActive("bw_here1", FALSE)
        MakeSectorActive("bw_here2", FALSE)
        MakeSectorActive("bw_here3", FALSE)
        MakeSectorActive("bw_here4", FALSE)
        MakeSectorActive("sg_box2", FALSE)
        MakeSectorActive("bw_gone", TRUE)
        MakeSectorActive("bw_gone2", TRUE)
    end
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 1)
    bv:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
bv.exit = function(arg1) -- line 255
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    manny:set_collision_mode(COLLISION_OFF)
    glottis:free()
    local local1 = 0
    repeat
        local1 = local1 + 1
        table_actor[local1]:free()
    until local1 == 3
end
bv.bone_wagon = Object:create(bv, "", -8.0924196, -6.1200299, 1.59793, { range = 0.89999998 })
bv.bone_wagon.use_pnt_x = -8.75
bv.bone_wagon.use_pnt_y = -5.375
bv.bone_wagon.use_pnt_z = 1.5
bv.bone_wagon.use_rot_x = 0
bv.bone_wagon.use_rot_y = 164.41499
bv.bone_wagon.use_rot_z = 0
bv.bone_wagon.touchable = FALSE
bv.bone_wagon.lookAt = function(arg1) -- line 284
    manny:say_line("/bdma034/")
end
bv.bone_wagon.pickUp = function(arg1) -- line 288
    sg.bone_wagon:pickUp()
end
bv.bone_wagon.use = function(arg1) -- line 292
    bv.get_in_BW()
end
bv.padlock = Object:create(bd, "/bdtx043/padlock", -7.80795, -3.03668, 1.636, { range = 1 })
bv.padlock.use_pnt_x = -7.4479599
bv.padlock.use_pnt_y = -3.3187799
bv.padlock.use_pnt_z = 1.4
bv.padlock.use_rot_x = 0
bv.padlock.use_rot_y = 58.1805
bv.padlock.use_rot_z = 0
bv.padlock.unlocked = FALSE
bv.padlock.lookAt = function(arg1) -- line 306
    manny:say_line("/bdma044/")
end
bv.padlock.pickUp = function(arg1) -- line 310
    soft_script()
    manny:say_line("/cwma018/")
    wait_for_message()
    manny:say_line("/cwma019/")
end
bv.padlock.use = function(arg1) -- line 319
    if lb.key.owner == manny then
        arg1:use_key()
    else
        arg1:pickUp()
    end
end
bv.padlock.use_key = function(arg1) -- line 328
    if com_solved then
        START_CUT_SCENE()
        arg1.unlocked = TRUE
        arg1:make_touchable()
        lb.key:free()
        manny:walkto(-7.45797, -3.4511, 1.4, 0, 54, 0)
        manny:wait_for_actor()
        manny:stop_chore(manny.hold_chore, "ma.cos")
        manny.is_holding = nil
        manny:set_chore_looping(ms_hold, FALSE, "ma.cos")
        FadeOutChore(manny.hActor, "ma.cos", ms_hold, 500)
        sleep_for(500)
        manny:play_chore(ms_reach_med, "ma.cos")
        sleep_for(500)
        start_sfx("lbOpnLok.wav")
        wait_for_sound("lbOpnLok.wav")
        manny:wait_for_chore()
        manny:say_line("/bdma047/")
        wait_for_message()
        manny:say_line("/bdma048/")
        wait_for_message()
        END_CUT_SCENE()
        if mod_solved then
            IrisDown(320, 240, 1000)
            sleep_for(1000)
            bd:leave_forest()
        end
    elseif bd.beavers.met then
        manny:say_line("/bdma049/")
    else
        manny:say_line("/bdma050/")
    end
end
bv.padlock_obj = Object:create(bv, "", -8.2456703, -2.4595499, 1.6799999, { range = 0 })
bv.padlock_obj.use_pnt_x = -6.8536701
bv.padlock_obj.use_pnt_y = -3.7895501
bv.padlock_obj.use_pnt_z = 1.4
bv.padlock_obj.use_rot_x = 0
bv.padlock_obj.use_rot_y = 49.8106
bv.padlock_obj.use_rot_z = 0
bv.gate = Object:create(bd, "/bdtx053/gate", -6.4033198, -3.2437, 1.9, { range = 0.60000002 })
bv.gate.use_pnt_x = -6.4050102
bv.gate.use_pnt_y = -3.325
bv.gate.use_pnt_z = 1.4
bv.gate.use_rot_x = 0
bv.gate.use_rot_y = 374.823
bv.gate.use_rot_z = 0
bv.gate.out_pnt_x = -6.4050102
bv.gate.out_pnt_y = -3.325
bv.gate.out_pnt_z = 1.4
bv.gate.out_rot_x = 0
bv.gate.out_rot_y = 374.823
bv.gate.out_rot_z = 0
bv.gate.used = FALSE
bv.gate.lookAt = function(arg1) -- line 392
    manny:say_line("/bdma054/")
end
bv.gate.use = function(arg1) -- line 396
    MakeSectorActive("gate_box", TRUE)
    START_CUT_SCENE()
    if not opened_bv_gate then
        opened_bv_gate = TRUE
        local local1 = 0
        repeat
            local1 = local1 + 1
            table_actor[local1]:free()
        until local1 == 3
        bv.gate.used = TRUE
        stop_script(sg.glottis_roars)
        glottis:shut_up()
        glottis:free()
        glottis:default()
        glottis:put_in_set(bv)
        MakeSectorActive("bw_here1", FALSE)
        MakeSectorActive("bw_here2", FALSE)
        MakeSectorActive("bw_here3", FALSE)
        MakeSectorActive("bw_here4", FALSE)
        MakeSectorActive("sg_box2", FALSE)
        MakeSectorActive("bw_gone", TRUE)
        MakeSectorActive("bw_gone2", TRUE)
        glottis:push_costume("gl_fastwalk.cos")
        glottis:follow_boxes()
        glottis:set_walk_chore(0, "gl_fastwalk.cos")
        glottis:setpos(-7.6774802, -5.0910201, 1.4398201)
        glottis:walkto(-7.15869, -4.8460102, 1.4)
        manny:walkto(-6.4112301, -3.3310001, 1.4)
        manny:wait_for_actor()
        manny:setrot(0, 10.55, 0, TRUE)
        manny:wait_for_actor()
        glottis:wait_for_actor()
        glottis:head_look_at(manny)
        manny:start_open_door_anim()
        sleep_for(1000)
        bv.bd_door:play_chore(0)
        manny:finish_open_door_anim()
        set_override(skip_stupid_glottis_in_bv)
        glottis:say_line("/bdgl055/")
        sleep_for(1000)
        if not bv.bone_wagon.touchable then
            manny:set_turn_rate(150)
            manny:setrot(0, 179, 0, TRUE)
            manny:head_look_at(glottis)
            wait_for_message()
            manny:set_turn_rate(85)
            manny:say_line("/bdma056/")
            wait_for_message()
        else
            manny:setrot(0, 179, 0, TRUE)
            manny:head_look_at(glottis)
            wait_for_message()
        end
        glottis:say_line("/bdgl057/")
        wait_for_message()
        manny:say_line("/bdma058/")
        wait_for_message()
        glottis:say_line("/bdgl059/")
        wait_for_message()
        manny:say_line("/bdma060/")
        wait_for_message()
        glottis:say_line("/bdgl061/")
        wait_for_message()
        glottis:say_line("/bdgl062/")
        manny:head_look_at(nil)
        manny:walkto(-6.5250001, -2.8499999, 1.4)
        wait_for_message()
        if not bv.bone_wagon.touchable and mod_solved then
            sg.bone_wagon:make_untouchable()
            na.bone_wagon:make_untouchable()
            lb.bone_wagon:make_untouchable()
            bv.bone_wagon:make_touchable()
        end
        kill_override()
    end
    END_CUT_SCENE()
    bd:come_out_door(bd.bv_door)
    glottis:free()
end
skip_stupid_glottis_in_bv = function() -- line 489
    kill_override()
    if not bv.bone_wagon.touchable and mod_solved then
        sg.bone_wagon:make_untouchable()
        na.bone_wagon:make_untouchable()
        lb.bone_wagon:make_untouchable()
        bv.bone_wagon:make_touchable()
    end
    bd:come_out_door(bd.bv_door)
    glottis:free()
end
bv.bd_door = Object:create(bv, "", -6.3963399, -3.23757, 1.8324, { range = 0 })
bv.bd_door.use_pnt_x = -6.4050102
bv.bd_door.use_pnt_y = -3.325
bv.bd_door.use_pnt_z = 1.4
bv.bd_door.use_rot_x = 0
bv.bd_door.use_rot_y = 374.823
bv.bd_door.use_rot_z = 0
bv.bd_door.out_pnt_x = -6.4050102
bv.bd_door.out_pnt_y = -3.325
bv.bd_door.out_pnt_z = 1.4
bv.bd_door.out_rot_x = 0
bv.bd_door.out_rot_y = 374.823
bv.bd_door.out_rot_z = 0
bv.bd_box = bv.bd_door
bv.bd_door.walkOut = function(arg1) -- line 522
    bd:come_out_door(bd.bv_door)
    if manny.is_backward then
        START_CUT_SCENE()
        manny:walk_forward()
        break_here()
        manny:walk_forward()
        END_CUT_SCENE()
    end
end
bv.bd_door.comeOut = function(arg1) -- line 533
    manny:set_run(FALSE)
    stop_movement_scripts()
    manny:setpos(-6.45925, -3.33356, 1.4)
    manny:setrot(0, -163.666, 0)
    break_here()
    stop_movement_scripts()
    if cutSceneLevel > 0 then
        PrintDebug("force end cut scene")
        END_CUT_SCENE()
    end
end
bv.sg_door = Object:create(bv, "/bvtx063/door", -10.3279, -5.9112301, 1.48455, { range = 0 })
bv.sg_door.use_pnt_x = -8.6774502
bv.sg_door.use_pnt_y = -5.9317298
bv.sg_door.use_pnt_z = 1.48455
bv.sg_door.use_rot_x = 0
bv.sg_door.use_rot_y = 118.189
bv.sg_door.use_rot_z = 0
bv.sg_door.out_pnt_x = -9.3049803
bv.sg_door.out_pnt_y = -6.1276202
bv.sg_door.out_pnt_z = 1.49998
bv.sg_door.out_rot_x = 0
bv.sg_door.out_rot_y = 129.14
bv.sg_door.out_rot_z = 0
bv.sg_box = bv.sg_door
bv.sg_box2 = bv.sg_door
bv.sg_door.walkOut = function(arg1) -- line 564
    if bv.entered_from == lb then
        lb:come_out_door(lb.bd_door)
    else
        sg:come_out_door(sg.mod_door)
    end
end

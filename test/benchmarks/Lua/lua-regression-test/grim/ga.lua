CheckFirstTime("ga.lua")
ga = Set:create("ga.set", "Garage", { ga_elerv = 0, ga_elerv2 = 0, ga_entha = 1, ga_entha2 = 1, ga_entha3 = 1, ga_entha4 = 1, ga_wshms = 2, ga_rckha = 3, ga_ofcws = 4, ga_rckws = 5, ga_rckws2 = 5, overhead = 6, ga_ofcha = 7 })
ga.cheat_boxes = { ga_cheat_box_1 = 0, ga_cheat_box_2 = 1, ga_cheat_box_3 = 2, ga_cheat_box_4 = 3, ga_cheat_box_5 = 4, ga_cheat_box_6 = 5, ga_cheat_box_7 = 6, ga_cheat_box_8 = 7 }
dofile("glottis_scripts.lua")
dofile("dlg_glottis.lua")
dofile("ga_elevator.lua")
dofile("ga_skid_marks.lua")
dofile("glottis_peek.lua")
dofile("ga_door.lua")
ga.glottis_music = FALSE
ga.test = function(arg1) -- line 30
    manny:stop_chore(nil, "ms.cos")
    manny:setpos(1.43663, 8.85144, 0)
    if not glottis.is_outside then
        glottis:emerge()
    end
    sleep_for(500)
    glottis.hand_work_order()
end
glottis.hand_work_order = function() -- line 40
    manny:kill_head_script()
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_give_workorder, "gl_akimbo_idles.cos")
    start_script(manny.walk_and_face, manny, 0.969331, 8.7336, 0, 0, 91.6708, 0)
    sleep_for(1000)
    manny:play_chore(ms_hand_on_obj, "ms.cos")
    break_here()
    manny:play_chore(ms_reach_med, "ms.cos")
    sleep_for(500)
    manny:setrot(0, 109.711, 0)
    manny:stop_chore(ms_reach_med, "ms.cos")
    manny:stop_chore(ms_hand_on_obj, "ms.cos")
    manny:generic_pickup(ga.work_order)
    glottis:wait_for_chore(gl_akimbo_idles_give_workorder, "gl_akimbo_idles.cos")
    start_sfx("getWrkOr.wav")
    look_at_item_in_hand(TRUE)
    glottis:complete_chore(gl_akimbo_idles_deactivate_workorder, "gl_akimbo_idles.cos")
    glottis:play_chore(gl_akimbo_idles_workorder_to_akimbo, "gl_akimbo_idles.cos")
    glottis:wait_for_chore(gl_akimbo_idles_workorder_to_akimbo, "gl_akimbo_idles.cos")
    glottis:akimbo()
end
ga.domino_drive_by = function() -- line 63
    START_CUT_SCENE()
    system:lock_display()
    set_override(ga.domino_drive_by_override)
    StartMovie("ga_limo1.snm", nil, 448, 166)
    system:unlock_display()
    wait_for_movie()
    ga:current_setup(ga_entha)
    StartMovie("ga_limo2.snm")
    wait_for_movie()
    END_CUT_SCENE()
    ga.domino_drive_by_override()
end
ga.domino_drive_by_override = function() -- line 77
    system:lock_display()
    kill_override()
    ga:current_setup(ga_elerv)
    break_here()
    system:unlock_display()
end
glottis.emerge = function(arg1) -- line 85
    ga:current_setup(ga_ofcha)
    manny:head_look_at(ga.gs_door)
    ga.glottis_music = TRUE
    music_state:update(system.currentSet)
    play_movie("ga_out.snm", 142, 139)
    sleep_for(2000)
    wait_for_movie()
    ga:current_setup(ga_ofcws)
    glottis:set_visibility(TRUE)
    glottis.is_outside = TRUE
    manny.head_script = start_script(manny.head_follow_mesh, manny, glottis, 4)
end
glottis.demerge = function(arg1) -- line 99
    glottis:set_visibility(FALSE)
    glottis:stop_chore(nil)
    manny:kill_head_script()
    ga:current_setup(ga_ofcha)
    play_movie("ga_in.snm", 142, 139)
    wait_for_movie()
    ga.glottis_eyes:make_untouchable()
    glottis.is_outside = FALSE
    manny:head_look_at(nil)
    ga:force_camerachange()
    ga.glottis_music = FALSE
    music_state:update(system.currentSet)
end
ga.back_away = function(arg1) -- line 116
    manny:setrot(0, 59.9581, 0, TRUE)
    manny:backup(arg1)
end
ga.prepare_for_glottis = function(arg1) -- line 121
    if arg1 == "door" then
        ga.back_away(2000)
    elseif arg1 == ga.toolbox1 then
        ga.back_away(3000)
    elseif arg1 == ga.toolbox2 then
        manny:turn_toward_entity(ga.gs_door)
    elseif arg1 == "crash" then
        manny:turn_toward_entity(ga.gs_door)
    elseif arg1 == "fountain" then
        manny:turn_toward_entity(ga.gs_door)
    end
end
ga.dialog_pos = function() -- line 135
    glottis.head_script = start_script(glottis.head_follow_mesh, glottis, manny, 6)
    start_script(manny.walk_and_face, manny, 1.43663, 8.85144, 0, 0, 53.4055, 0)
    repeat
        break_here()
    until point_proximity(1.43663, 8.85144, 0) < 0.5
    glottis:kill_head_script()
    glottis:head_look_at_point({ x = 1.43663, y = 8.85144, z = 0.475 })
end
ga.disturb_glottis = function(arg1, arg2) -- line 145
    local local1
    if not reaped_bruno then
        glottis:head_look_at(nil)
        if glottis.recruited then
            single_start_script(ga.do_not_disturb_glottis)
        else
            START_CUT_SCENE("no head")
            manny:head_look_at(nil)
            wait_for_message()
            if glottis.met then
                if arg2 == "door" then
                    if not ga.called_genie then
                        ga.called_genie = TRUE
                        manny:say_line("/gama082/")
                    end
                    wait_for_message()
                elseif arg2 == ga.toolbox1 or arg2 == ga.toolbox2 or arg2 == "fountain" then
                    glottis:say_line("/gagl085/")
                end
                start_script(ga.prepare_for_glottis, arg2)
                sleep_for(1000)
                wait_for_message()
                glottis:emerge()
                glottis:say_line("/gagl084/")
                ga.dialog_pos()
            else
                glottis.met = TRUE
                if arg2 == "door" then
                    manny:say_line("/gama083/")
                    manny:wait_for_message()
                end
                glottis:say_line("/gagl085/")
                sleep_for(500)
                start_script(ga.prepare_for_glottis, arg2)
                glottis:wait_for_message()
                if arg2 == ga.toolbox1 or arg2 == ga.toolbox2 or arg2 == "fountain" or arg2 == "crash" then
                    glottis:say_line("/gagl086/")
                end
                sleep_for(500)
                if arg2 == "crash" then
                    start_script(ga.dialog_pos)
                    glottis:emerge()
                else
                    glottis:emerge()
                    ga.dialog_pos()
                end
                wait_for_message()
                glottis:say_line("/gagl087/")
                wait_for_message()
                glottis:say_line("/gagl088/")
                glottis:shrug()
            end
            wait_for_message()
            cameraman_disabled = TRUE
            ga:current_setup(ga_ofcws)
            ga.crash:disable()
            END_CUT_SCENE()
            Dialog:run("gl1", "dlg_glottis.lua")
        end
    end
end
ga.do_not_disturb_glottis = function(arg1) -- line 213
    START_CUT_SCENE("no head")
    glottis:set_costume(nil)
    glottis:set_costume("glottis_peek.cos")
    glottis:set_collision_mode(COLLISION_OFF)
    glottis:set_visibility(TRUE)
    glottis:put_in_set(ga)
    glottis:ignore_boxes()
    glottis:setpos(0.421567, 10.3963, 0)
    glottis:setrot(0, 186.662, 0)
    glottis:head_look_at(nil)
    glottis:set_mumble_chore(glottis_peek_mumble)
    glottis:set_talk_chore(1, glottis_peek_m)
    glottis:set_talk_chore(2, glottis_peek_a)
    glottis:set_talk_chore(3, glottis_peek_c)
    glottis:set_talk_chore(4, glottis_peek_e)
    glottis:set_talk_chore(5, glottis_peek_f)
    glottis:set_talk_chore(6, glottis_peek_l)
    glottis:set_talk_chore(7, glottis_peek_m)
    glottis:set_talk_chore(8, glottis_peek_o)
    glottis:set_talk_chore(9, glottis_peek_t)
    glottis:set_talk_chore(10, glottis_peek_u)
    glottis:play_chore(glottis_peek_peek_in, "glottis_peek.cos")
    glottis:wait_for_chore(glottis_peek_peek_in, "glottis_peek.cos")
    glottis:say_line("/gagl089/")
    start_script(manny.walkto, manny, ga.window)
    manny:head_look_at(ga.window)
    wait_for_message()
    glottis:say_line("/gagl090/")
    wait_for_message()
    manny:say_line("/gama091/")
    sleep_for(500)
    manny:shrug_gesture()
    wait_for_message()
    glottis:say_line("/gagl092/")
    wait_for_message()
    glottis:say_line("/gagl093/")
    wait_for_message()
    manny:say_line("/gama094/")
    manny:twist_head_gesture()
    wait_for_message()
    glottis:stop_chore(glottis_peek_peek_hold)
    glottis:play_chore(glottis_peek_peek_done)
    glottis:wait_for_chore()
    glottis:set_visibility(FALSE)
    manny:say_line("/gama095/")
    manny:point_gesture()
    wait_for_message()
    manny:say_line("/gama096/")
    manny:turn_right(90)
    END_CUT_SCENE()
end
ga.set_up_actors = function(arg1) -- line 267
    glottis:default()
    glottis:push_costume("gl_akimbo_idles.cos")
    glottis:set_mumble_chore(glottis_mumble)
    glottis:put_in_set(ga)
    glottis:setpos(0.755, 9.182, 0)
    glottis:setrot(0, 230, 0)
    glottis:follow_boxes()
    glottis:set_visibility(FALSE)
    SetShadowColor(5, 5, 5)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 15.5084, 12.3313, 3.76082)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 15.5084, 12.3313, 3.76082)
    SetActorShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow3")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, 15.5084, 12.3313, 3.76082)
    SetActorShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow4")
    SetActiveShadow(glottis.hActor, 0)
    SetActorShadowPoint(glottis.hActor, 0, 0, 100)
    SetActorShadowPlane(glottis.hActor, "shadow1")
    AddShadowPlane(glottis.hActor, "shadow1")
end
ga.update_music_state = function(arg1) -- line 315
    if ga.glottis_music then
        return stateGS
    else
        return stateGA
    end
end
ga.enter = function(arg1) -- line 324
    ga:add_object_state(0, "ga_ele_dr.bm", "ga_ele_dr.zbm", OBJSTATE_STATE)
    ga.ha_door:set_object_state("ga_elevator.cos")
    if reaped_bruno then
        ga.door_object_states.hObjectState1 = ga:add_object_state(ga_rckha, "ga_3_opndor.bm", nil, OBJSTATE_STATE, FALSE)
        ga.door_object_states.hObjectState2 = ga:add_object_state(ga_rckws, "ga_5_opndor.bm", nil, OBJSTATE_STATE, FALSE)
        ga.door_object_states.hObjectState3 = ga:add_object_state(ga_ofcha, "ga_7_opndor.bm", "ga_7_opndor.zbm", OBJSTATE_STATE, FALSE)
        ga.door_object_states.hObjectState4 = ga:add_object_state(ga_rckha, "ga_3_glnote.bm", nil, OBJSTATE_STATE, FALSE)
        ga.door_object_states.hObjectState5 = ga:add_object_state(ga_rckws, "ga_5_glnote.bm", nil, OBJSTATE_STATE, FALSE)
        ga.door_object_states.hObjectState6 = ga:add_object_state(ga_ofcha, "ga_7_glnote.bm", nil, OBJSTATE_STATE, FALSE)
        ga.door_object_states:set_object_state("ga_door.cos")
        if reaped_meche then
            ga:add_object_state(ga_entha, "ga_skid_marks.bm", nil, OBJSTATE_UNDERLAY)
            ga.skid_marks:set_object_state("ga_skid_marks.cos")
            ga.skid_marks:play_chore(ga_skid_marks_here, "ga_skid_marks.cos")
            ga.gs_door.locked = FALSE
            ga.gs_door.opened = TRUE
            Object.open(ga.gs_door)
            ga.door_object_states:play_chore(ga_door_opened)
            ga.gs_door.obj_x = 0.575784
            ga.gs_door.obj_y = 9.81803
            ga.gs_door.obj_z = 0.545
            ga.gs_door:update_look_point()
            ga.al_door:unlock()
            ga.al_door:open()
            Object.open(ga.al_door)
            ga:add_object_state(ga_entha, "ga_rollup_entha.bm", "ga_rollup_entha.zbm", OBJSTATE_STATE)
            ga:add_object_state(ga_rckws, "ga_rollup_rckws.bm", nil, OBJSTATE_UNDERLAY)
            ga.al_door:set_object_state("ga_rollup_door.cos")
            ga.al_door:play_chore(0)
            ga.ha_door.locked = TRUE
            MakeSectorActive("no_hallway", FALSE)
            MakeSectorActive("ha_door_trigger", FALSE)
            MakeSectorActive("crash_box_1", nil)
            MakeSectorActive("crash_box_2", nil)
        else
            ga.gs_door.opened = FALSE
            ga.gs_door.locked = TRUE
            Object.close(ga.gs_door)
            ga.al_door:close()
            ga.al_door:lock()
            Object.close(ga.al_door)
            ga.door_object_states:play_chore(ga_door_note_here)
        end
    else
        ga.door_object_states.opened = FALSE
        ga.gs_door.locked = TRUE
        Object.close(ga.gs_door)
        ga.al_door:close()
        ga.al_door:lock()
        MakeSectorActive("ha_door_trigger", TRUE)
    end
    if ga.crash.triggered then
        ga.crash:disable()
        MakeSectorActive("crash_box_1", nil)
        MakeSectorActive("crash_box_2", nil)
    end
    ga:set_up_actors()
    if not ga.seen_domino and ha.been_there then
        ga.seen_domino = TRUE
        start_script(ga.domino_drive_by, ga)
    else
        ga:add_object_state(7, "ga_new_door.bm", nil, OBJSTATE_UNDERLAY)
    end
    preload_sfx("gaTools.wav")
end
ga.exit = function(arg1) -- line 416
    glottis:free()
    ga.glottis_eyes:make_untouchable()
    KillActorShadows(manny.hActor)
    KillActorShadows(glottis.hActor)
end
ga.door_object_states = Object:create(ga, "", 0, 0, 0, { range = 0 })
ga.door_object_states:make_untouchable()
ga.skid_marks = Object:create(ga, "", 0, 0, 0, { range = 0 })
ga.skid_marks.touchable = FALSE
ga.work_order = Object:create(ga, "/gatx098/work order", 0, 0, 0, { range = 0 })
ga.work_order.string_name = "work_order"
ga.work_order.wav = "getWrkOr.wav"
ga.work_order.shrink_radius = 0.029999999
ga.work_order.lookAt = function(arg1) -- line 443
    manny:say_line("/gama099/")
end
ga.work_order.use = ga.work_order.lookAt
ga.work_order.default_response = function(arg1) -- line 449
    manny:say_line("/gama100/")
end
ga.fountain = Object:create(ga, "/gatx105/water fountain", 1.2787, 9.8868198, 0.3971, { range = 0.60000002 })
ga.fountain.use_pnt_x = 1.425
ga.fountain.use_pnt_y = 9.8983202
ga.fountain.use_pnt_z = 0
ga.fountain.use_rot_x = 0
ga.fountain.use_rot_y = 96.035202
ga.fountain.use_rot_z = 0
ga.fountain.lookAt = function(arg1) -- line 462
    manny:say_line("/gama106/")
end
ga.fountain.use = function(arg1) -- line 466
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        manny:push_costume("manny_wave.cos")
        manny:play_chore(manny_wave_wave, "manny_wave.cos")
        sleep_for(500)
        start_sfx("gaWtrFtn.wav")
        manny:fade_out_chore(manny_wave_wave, "manny_wave.cos")
        manny:wait_for_chore(manny_wave_wave, "manny_wave.cos")
        manny:pop_costume()
        END_CUT_SCENE()
        ga:disturb_glottis("fountain")
    end
end
ga.toolbox1 = Object:create(ga, "/gatx107/tool cabinet", 0.325892, 8.8715601, 0.3371, { range = 0.75 })
ga.toolbox1.use_pnt_x = 0.52919197
ga.toolbox1.use_pnt_y = 8.8715601
ga.toolbox1.use_pnt_z = 0
ga.toolbox1.use_rot_x = 0
ga.toolbox1.use_rot_y = 105.39
ga.toolbox1.use_rot_z = 0
ga.toolbox1.lookAt = function(arg1) -- line 492
    manny:say_line("/gama108/")
end
ga.toolbox1.use = function(arg1) -- line 496
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        END_CUT_SCENE()
        if not arg1.touched then
            START_CUT_SCENE()
            arg1.touched = TRUE
            start_sfx("gaTools.wav")
            manny:push_costume("ma_wheel_stuck.cos")
            manny:run_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
            manny:play_chore_looping(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
            sleep_for(1000)
            manny:say_line("/gama109/")
            wait_for_sound("gaTools.wav")
            manny:stop_chore(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
            manny:run_chore(ma_wheel_stuck_hand_off_tu, "ma_wheel_stuck.cos")
            manny:pop_costume()
            wait_for_message()
            END_CUT_SCENE()
            start_script(ga.disturb_glottis, ga, arg1)
        else
            manny:say_line("/gama109/")
        end
    end
end
ga.toolbox2 = Object:create(ga, "/gatx110/tool cabinet", 1.12326, 7.2038102, 0.32030001, { range = 0.69999999 })
ga.toolbox2.use_pnt_x = 1.02086
ga.toolbox2.use_pnt_y = 7.4755101
ga.toolbox2.use_pnt_z = 0
ga.toolbox2.use_rot_x = 0
ga.toolbox2.use_rot_y = 201.31599
ga.toolbox2.use_rot_z = 0
ga.toolbox2.lookAt = ga.toolbox1.lookAt
ga.toolbox2.use = ga.toolbox1.use
ga.window = Object:create(ga, "/gatx111/window", 0.40641999, 9.7950602, 0.44999999, { range = 0.55000001 })
ga.window.use_pnt_x = 0.31200001
ga.window.use_pnt_y = 9.6400003
ga.window.use_pnt_z = 0
ga.window.use_rot_x = 0
ga.window.use_rot_y = 1035.87
ga.window.use_rot_z = 0
ga.window.lookAt = function(arg1) -- line 546
    if reaped_bruno then
        manny:say_line("/gama112/")
    else
        manny:say_line("/gama113/")
    end
end
ga.window.use = function(arg1) -- line 554
    manny:say_line("/gama114/")
end
ga.crash = Object:create(ga, "/gatx115/crash trigger", 0, 0, 0, { range = 0 })
ga.crash:make_untouchable()
ga.crash.triggered = FALSE
ga.tire_box = ga.crash
ga.crash.disable = function(arg1) -- line 564
    MakeSectorActive("crash_box_1", nil)
    MakeSectorActive("crash_box_2", nil)
end
ga.crash.walkOut = function(arg1) -- line 569
    START_CUT_SCENE()
    arg1.triggered = TRUE
    start_sfx("gaJunk.wav")
    sleep_for(4000)
    END_CUT_SCENE()
    start_script(manny.walk_and_face, manny, 3.31, 7.143, 0, 0, 1124.42, 0)
    if not reaped_bruno and not glottis.recruited then
        start_script(ga.disturb_glottis, ga, "crash")
    end
end
ga.glottis_eyes = Object:create(ga, "/gatx116/Glottis' eyes", 0.93450201, 9.1657104, 0.86000001, { range = 3 })
ga.glottis_eyes:make_untouchable()
ga.glottis_eyes.use_pnt_x = 1.46
ga.glottis_eyes.use_pnt_y = 9.4619999
ga.glottis_eyes.use_pnt_z = 0
ga.glottis_eyes.use_rot_x = 0
ga.glottis_eyes.use_rot_y = 1190.17
ga.glottis_eyes.use_rot_z = 0
ga.kiosk = Object:create(ga, "/gatx123/kiosk", 14.1299, 8.6680603, 0.5, { range = 0.89999998 })
ga.kiosk.use_pnt_x = 13.5499
ga.kiosk.use_pnt_y = 8.69806
ga.kiosk.use_pnt_z = 0
ga.kiosk.use_rot_x = 0
ga.kiosk.use_rot_y = -439.996
ga.kiosk.use_rot_z = 0
ga.kiosk.lookAt = function(arg1) -- line 600
    soft_script()
    manny:say_line("/gama124/")
    wait_for_message()
    manny:say_line("/gama125/")
end
ga.kiosk.pickUp = function(arg1) -- line 607
end
ga.kiosk.use = function(arg1) -- line 610
    soft_script()
    manny:say_line("/gama126/")
    wait_for_message()
    manny:say_line("/gama127/")
end
ga.lol_trigger = { }
ga.lol_trigger.walkOut = function(arg1) -- line 618
    ga.lol.use()
end
ga.lol = Object:create(ga, "/gatx128/Land of the Living", 15.4095, 13.5545, 1.0700001, { range = 2.5999999 })
ga.lol.use_pnt_x = 15.4095
ga.lol.use_pnt_y = 10.5345
ga.lol.use_pnt_z = 0
ga.lol.use_rot_x = 0
ga.lol.use_rot_y = -371.84799
ga.lol.use_rot_z = 0
ga.lol.lookAt = function(arg1) -- line 630
    manny:say_line("/gama129/")
end
ga.lol.use = function(arg1) -- line 634
    manny:say_line("/gama130/")
    wait_for_message()
    manny:say_line("/gama131/")
end
ga.cars = Object:create(ga, "/gatx132/cars", 5.63764, 6.3539, 1.17, { range = 2.3 })
ga.cars.use_pnt_x = 5.7176399
ga.cars.use_pnt_y = 7.0138998
ga.cars.use_pnt_z = 0
ga.cars.use_rot_x = 0
ga.cars.use_rot_y = -555.85498
ga.cars.use_rot_z = 0
ga.cars.lookAt = function(arg1) -- line 648
    if reaped_meche then
        soft_script()
        manny:say_line("/gama133/")
        wait_for_message()
        manny:say_line("/gama134/")
    else
        manny:say_line("/gama135/")
    end
end
ga.cars.pickUp = function(arg1) -- line 659
    manny:say_line("/gama136/")
end
ga.cars.use = ga.cars.pickUp
ga.gs_door = Object:create(ga, "/gatx117/door", 0.83642, 9.7850504, 0.5, { range = 0.75 })
ga.ga_gs_box = ga.gs_door
ga.gs_door.use_pnt_x = 0.82700002
ga.gs_door.use_pnt_y = 9.6400003
ga.gs_door.use_pnt_z = 0
ga.gs_door.use_rot_x = 0
ga.gs_door.use_rot_y = 6.74999
ga.gs_door.use_rot_z = 0
ga.gs_door.out_pnt_x = 0.80800003
ga.gs_door.out_pnt_y = 10
ga.gs_door.out_pnt_z = 0
ga.gs_door.out_rot_x = 0
ga.gs_door.out_rot_y = 2.9427099
ga.gs_door.out_rot_z = 0
ga.gs_door.passage = { "ga_shop_box_1", "ga_shop_box_2" }
ga.gs_door.lookAt = function(arg1) -- line 693
    if reaped_meche then
        soft_script()
        manny:say_line("/gama102/")
        wait_for_message()
        manny:say_line("/gama103/")
    elseif reaped_bruno then
        arg1.read_junk = TRUE
        manny:say_line("/gama104/")
    else
        system.default_response("closed")
    end
end
ga.gs_door.locked_out = function(arg1) -- line 707
    START_CUT_SCENE()
    if reaped_bruno then
        manny:walkto_object(ga.gs_door)
        manny:setrot(0, 35.9933, 0, TRUE)
        manny:wait_for_actor()
        manny:play_chore(ms_reach_med, "ms.cos")
        sleep_for(500)
        system.default_response("locked")
        manny:wait_for_chore(ms_reach_med, "ms.cos")
        manny:stop_chore(ms_reach_med, "ms.cos")
        manny:walkto(arg1)
        wait_for_message()
        if not arg1.read_junk then
            arg1:lookAt()
        end
    else
        manny:knock_on_door_anim()
    end
    END_CUT_SCENE()
    if not reaped_bruno then
        ga:disturb_glottis("door")
    end
end
ga.gs_door.walkOut = function(arg1) -- line 733
    gs:come_out_door(gs.ga_door)
end
ga.ha_door = Object:create(ga, "/gatx118/elevator", 15.7683, 0.016555, 0.47999999, { range = 0.75 })
ga.ga_ha_box = ga.ha_door
ga.ha_door.use_pnt_x = 15.772
ga.ha_door.use_pnt_y = 0.22499999
ga.ha_door.use_pnt_z = 0
ga.ha_door.use_rot_x = 0
ga.ha_door.use_rot_y = 176.205
ga.ha_door.use_rot_z = 0
ga.ha_door.out_pnt_x = 15.6093
ga.ha_door.out_pnt_y = -0.55000001
ga.ha_door.out_pnt_z = 0
ga.ha_door.out_rot_x = 0
ga.ha_door.out_rot_y = -179.776
ga.ha_door.out_rot_z = 0
ga.ha_door.passage = { "ga_elevator_psg" }
ga.ha_door.locked_out = function(arg1) -- line 772
    START_CUT_SCENE()
    manny:say_line("/gama119/")
    wait_for_message()
    manny:say_line("/gama120/")
    END_CUT_SCENE()
end
ga.ha_door.lookAt = function(arg1) -- line 781
    if not arg1:is_locked() then
        system.default_response("here already")
    else
        arg1:locked_out()
    end
end
ga.ha_door.walkOut = function(arg1) -- line 789
    START_CUT_SCENE()
    manny:clear_hands()
    manny.footsteps = footsteps.concrete
    manny:walkto_object(arg1, TRUE)
    start_script(arg1.close, arg1)
    while TurnActorTo(manny.hActor, arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z) do
        break_here()
    end
    wait_for_script(arg1.close)
    ha:switch_to_set()
    manny:put_in_set(ha)
    manny:setpos(ha.ga_door.out_pnt_x, ha.ga_door.out_pnt_y, ha.ga_door.out_pnt_z)
    manny:setrot(0, 266.69, 0)
    ha.ga_door:open()
    manny:walkto(ha.ga_door.use_pnt_x, ha.ga_door.use_pnt_y, ha.ga_door.use_pnt_z)
    manny:wait_for_actor()
    ha.ga_door:close()
    END_CUT_SCENE()
end
ga.ha_door.open = function(arg1) -- line 811
    if arg1:is_locked() then
        return Object.open(arg1)
    end
    if not arg1:is_open() then
        arg1.interest_actor:play_chore(ga_elevator_open, "ga_elevator.cos")
        arg1.interest_actor:wait_for_chore()
        Object.open(arg1)
    end
    return TRUE
end
ga.ha_door.close = function(arg1) -- line 825
    if arg1:is_open() then
        arg1.interest_actor:play_chore(ga_elevator_close, "ga_elevator.cos")
        arg1.interest_actor:wait_for_chore()
        Object.close(arg1)
    end
end
ga.ha_door.use = function(arg1) -- line 834
    START_CUT_SCENE()
    if not arg1:is_locked() then
        if not arg1:is_open() then
            arg1:open()
        end
        arg1:walkOut()
    else
        arg1:lockedOut()
    end
    END_CUT_SCENE()
end
ga.ha_door_trigger = { }
ga.ha_door_trigger.walkOut = function(arg1) -- line 852
    if ga.ha_door:is_locked() then
        return
    end
    if ga.ha_door.interest_actor:is_choring() then
        ga.ha_door.interest_actor:wait_for_chore()
    end
    ga.ha_door:open()
    while manny:find_sector_name("ha_door_trigger") do
        break_here()
    end
    if manny:find_sector_name("ga_elerv_floor") then
        if ga.ha_door.interest_actor:is_choring() then
            ga.ha_door.interest_actor:wait_for_chore()
        end
        ga.ha_door:close()
    end
end
ga.al_door = Object:create(ga, "/gatx121/big door", 18.025499, 5.5318699, 0.54000002, { range = 1.5 })
ga.al_door.use_pnt_x = 17.715
ga.al_door.use_pnt_y = 5.572
ga.al_door.use_pnt_z = 0
ga.al_door.use_rot_x = 0
ga.al_door.use_rot_y = 269.45999
ga.al_door.use_rot_z = 0
ga.al_door.out_pnt_x = 18.200001
ga.al_door.out_pnt_y = 5.5710001
ga.al_door.out_pnt_z = 0
ga.al_door.out_rot_x = 0
ga.al_door.out_rot_y = 269.45999
ga.al_door.out_rot_z = 0
ga.ga_al_box = ga.al_door
ga.al_door.passage = { "ga_al_pass1" }
ga.al_door.lookAt = function(arg1) -- line 898
    manny:say_line("/gama122/")
end
ga.al_door.locked_out = function(arg1) -- line 901
    al.ga_door:locked_out()
end
ga.al_door.walkOut = function(arg1) -- line 905
    al:come_out_door(al.ga_door)
end

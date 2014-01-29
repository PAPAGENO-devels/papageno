CheckFirstTime("do.lua")
dom = Set:create("do.set", "Domino's Office", { do_cnrla = 0, do_winws = 1, do_winws2 = 1, do_dorws = 2, overhead = 3 })
dom.camera_adjusts = { 20, 350, 340 }
dom.shrinkable = 0.03
dom.sb_close_vol = 127
dom.sb_medium_vol = 50
dom.sb_far_vol = 20
dofile("ma_drink.lua")
dofile("domino_boxing.lua")
dofile("manny_box.lua")
dofile("ma_open_drwr.lua")
dofile("ma_reachin_drwr.lua")
dofile("do_drawer_open.lua")
dofile("do_door_open.lua")
dofile("do_window_open.lua")
dofile("ma_exit_office.lua")
dofile("bag_box_ma.lua")
dofile("mouthpiece_box.lua")
domino.face_manny = function(arg1, arg2) -- line 31
    if find_script(domino.face_bag) then
        wait_for_script(domino.face_bag)
    end
    domino.facing_manny = TRUE
    domino:stop_looping_chore(domino_boxing_boxing, "domino_boxing.cos")
    if arg2 then
        domino:play_chore(domino_boxing_trans_spunch, "domino_boxing.cos")
        sleep_for(2500)
        stop_sound("speedbag.imu")
        domino:wait_for_chore(domino_boxing_trans_spunch, "domino_boxing.cos")
    else
        domino:play_chore(domino_boxing_drop_hands, "domino_boxing.cos")
        sleep_for(500)
        stop_sound("speedbag.imu")
        domino:wait_for_chore(domino_boxing_drop_hands, "domino_boxing.cos")
    end
    dom:current_setup(do_winws)
    domino:run_chore(domino_boxing_to_talk, "domino_boxing.cos")
end
domino.face_bag = function(arg1) -- line 52
    if find_script(domino.face_manny) then
        wait_for_script(domino.face_manny)
    end
    domino.facing_manny = FALSE
    domino:run_chore(domino_boxing_to_box, "domino_boxing.cos")
    domino:update_talk_chores()
    dom:current_setup(do_dorws)
    domino:play_chore_looping(domino_boxing_boxing, "domino_boxing.cos")
    start_sfx("speedbag.imu", IM_LOW_PRIORITY, dom.sb_medium_vol)
end
domino.update_talk_chores = function(arg1) -- line 64
    if domino.facing_manny then
        domino:set_mumble_chore(domino_boxing_mumble, "domino_boxing.cos")
        domino:set_talk_chore(1, domino_boxing_no_talk)
        domino:set_talk_chore(2, domino_boxing_a)
        domino:set_talk_chore(3, domino_boxing_c)
        domino:set_talk_chore(4, domino_boxing_e)
        domino:set_talk_chore(5, domino_boxing_f)
        domino:set_talk_chore(6, domino_boxing_l)
        domino:set_talk_chore(7, domino_boxing_m)
        domino:set_talk_chore(8, domino_boxing_o)
        domino:set_talk_chore(9, domino_boxing_t)
        domino:set_talk_chore(10, domino_boxing_u)
    else
        domino:set_mumble_chore(domino_boxing_mumble, "domino_boxing.cos")
        domino:set_talk_chore(1, domino_boxing_no_talk)
        domino:set_talk_chore(2, nil)
        domino:set_talk_chore(3, nil)
        domino:set_talk_chore(4, nil)
        domino:set_talk_chore(5, nil)
        domino:set_talk_chore(6, nil)
        domino:set_talk_chore(7, nil)
        domino:set_talk_chore(8, nil)
        domino:set_talk_chore(9, nil)
        domino:set_talk_chore(10, nil)
    end
end
scotch = Actor:create(nil, nil, nil, "/dotx093/")
scotch.default = function(arg1) -- line 98
    scotch:set_costume("do_scotch.cos")
    scotch:ignore_boxes()
    scotch:put_in_set(dom)
    scotch:setpos(1.3319, 2.32167, 0)
    scotch:setrot(0, 223.277, 0)
    scotch:play_chore(0)
end
speed_bag = Actor:create(nil, nil, nil, "/dotx144/")
speed_bag.default = function(arg1) -- line 108
    speed_bag:set_costume("bag_box_ma.cos")
    speed_bag:ignore_boxes()
    speed_bag:put_in_set(dom)
    speed_bag:setpos(dom.bag.use_pnt_x, dom.bag.use_pnt_y, dom.bag.use_pnt_z)
    speed_bag:setrot(0, dom.bag.use_rot_y, 0)
    speed_bag:play_chore(bag_box_ma_here)
end
dom.set_up_actors = function(arg1) -- line 117
    scotch:default()
    drawer_glow = NewObjectState(do_cnrla, OBJSTATE_STATE, "do_drawer_w_glow.bm", "do_drawer.zbm")
    drawer_woglow = NewObjectState(do_cnrla, OBJSTATE_STATE, "do_drawer_w_o_glow.bm", "do_drawer.zbm")
    dom.drawer_object:set_object_state("do_drawer_open.cos")
    NewObjectState(do_cnrla, OBJSTATE_UNDERLAY, "do_open_door.bm")
    NewObjectState(do_dorws, OBJSTATE_STATE, "do_open_door_dorws.bm", "do_open_door_dorws.zbm")
    dom.ha_door:set_object_state("do_door_open.cos")
    NewObjectState(do_winws, OBJSTATE_STATE, "do_open_window.bm", "do_open_window.zbm")
    dom.window:set_object_state("do_window_open.cos")
    NewObjectState(do_cnrla, OBJSTATE_OVERLAY, "do_tubemask.bm", nil, TRUE)
    dom.tube_object:set_object_state("do_tube.cos")
    if dom:current_setup() == do_cnrla then
        dom.tube_object.interest_actor:play_chore_looping(0)
    end
    if not ma_drink_cos then
        ma_drink_cos = "ma_drink.cos"
    end
    if not reaped_meche then
        dom.bag:make_untouchable()
        MakeSectorActive("dom_box", FALSE)
        domino:default()
        domino:put_in_set(dom)
        domino:set_costume("domino_boxing.cos")
        domino.facing_manny = FALSE
        domino:update_talk_chores()
        domino:setpos(0.21078, 1.01771, 0)
        domino:setrot(0, -321.566, 0)
        domino:set_collision_mode(COLLISION_BOX)
        SetActorCollisionScale(domino.hActor, 0.5)
        manny:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(manny.hActor, 0.35)
        MakeSectorActive("do_exit_box", TRUE)
        dom.domino_obj:make_touchable()
        domino:play_chore_looping(domino_boxing_boxing)
    else
        dom.bag:make_touchable()
        MakeSectorActive("dom_box", TRUE)
        domino:put_in_set(nil)
        MakeSectorActive("do_exit_box", FALSE)
        dom.domino_obj:make_untouchable()
        speed_bag:default()
        if not dom.mouthpiece_actor then
            dom.mouthpiece_actor = Actor:create(nil, nil, nil, "mouthpiece")
        end
        if dom.mouthpiece.owner ~= manny then
            dom.mouthpiece_actor:set_costume("mouthpiece_box.cos")
            dom.mouthpiece_actor:put_in_set(system.currentSet)
            dom.mouthpiece_actor:ignore_boxes()
            dom.mouthpiece_actor:setpos(0.3, 1.09654, 0.006)
            dom.mouthpiece_actor:setrot(0, 74.1295, 0)
            if dom.mouthpiece.status == MOUTHPIECE_ON_SHELF then
                PrintDebug("on the shelf")
                dom.mouthpiece_actor:play_chore_looping(mouthpiece_box_sitting)
            elseif dom.mouthpiece.status == MOUTHPIECE_KNOCKED_ONCE then
                dom.mouthpiece_actor:complete_chore(mouthpiece_box_first_hit)
            elseif dom.mouthpiece.status == MOUTHPIECE_KNOCKED_TWICE then
                dom.mouthpiece_actor:complete_chore(mouthpiece_box_second_hit)
            elseif dom.mouthpiece.status == MOUTHPIECE_ON_FLOOR then
                dom.mouthpiece_actor:play_chore_looping(mouthpiece_box_sitting)
                dom.mouthpiece_actor:setpos(0.29, 1.02654, -0.67)
            end
        end
    end
    NewObjectState(do_cnrla, OBJSTATE_STATE, "do_open_door.bm", nil, 1)
    if reaped_meche then
        dom.ha_door:play_chore(do_door_open_door_set_closed)
    else
        dom.ha_door:play_chore(do_door_open_door_set_open)
    end
    if dom.window:is_open() then
        dom.window:play_chore(do_window_open_window_set_open)
    else
        dom.window:play_chore(do_window_open_window_set_closed)
    end
    if dom.drawer_object:is_open() then
        if dom.coral.owner == IN_THE_ROOM then
            dom.drawer_object:play_chore(do_drawer_open_drawer_set_open_glow)
        else
            dom.drawer_object:play_chore(do_drawer_open_drawer_set_open_wo_glow)
        end
    else
        dom.drawer_object:play_chore(do_drawer_open_drawer_set_closed)
    end
end
dom.climb_out = function(arg1) -- line 220
    START_CUT_SCENE()
    while manny.is_idling do
        break_here()
    end
    dom:current_setup(1)
    manny:ignore_boxes()
    manny:setpos(1.1908, 2.82343, 0)
    manny:setrot(0, 1.96674, 0)
    manny:push_costume("ma_exit_office.cos")
    manny:play_chore(0, "ma_exit_office.cos")
    sleep_for(500)
    start_sfx("maEntWnd.WAV")
    manny:wait_for_chore()
    manny:pop_costume()
    manny:stop_chore(0, "ma_exit_office.cos")
    manny:follow_boxes()
    le:come_out_door(le.dom_door)
    le:current_setup(le_rufla)
    END_CUT_SCENE()
end
dom.enter = function(arg1) -- line 250
    LoadCostume("ma_drink.cos")
    LoadCostume("ma_note_type.cos")
    LoadCostume("ma_reachin_drwr.cos")
    LoadCostume("ma_open_drwr.cos")
    LoadCostume("manny_box.cos")
    LoadCostume("ma_exit_office.cos")
    LoadCostume("bag_box_ma.cos")
    LoadCostume("do_drawer_open.cos")
    manny.footsteps = footsteps.rug
    SetShadowColor(0, 10, 20)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 200, 1000, 2000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(domino.hActor, 0)
    SetActorShadowPoint(domino.hActor, 200, 1000, 2000)
    SetActorShadowPlane(domino.hActor, "shadow1")
    AddShadowPlane(domino.hActor, "shadow1")
    SetActiveShadow(speed_bag.hActor, 0)
    SetActorShadowPoint(speed_bag.hActor, 200, 1000, 2000)
    SetActorShadowPlane(speed_bag.hActor, "shadow1")
    AddShadowPlane(speed_bag.hActor, "shadow1")
    dom:set_up_actors()
    if not reaped_meche then
        start_sfx("speedbag.imu", IM_LOW_PRIORITY, dom.sb_medium_vol)
    end
end
dom.exit = function(arg1) -- line 289
    KillActorShadows(manny.hActor)
    KillActorShadows(domino.hActor)
    KillActorShadows(speed_bag.hActor)
    speed_bag:free()
    scotch:free()
    domino:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    domino:free()
    stop_sound("speedbag.imu")
end
dom.camerachange = function(arg1, arg2, arg3) -- line 302
    if arg2 == do_cnrla then
        dom.tube_object.interest_actor:stop_chore(0)
    elseif arg3 == do_cnrla then
        dom.tube_object.interest_actor:play_chore_looping(0)
    end
    if not reaped_meche then
        if arg3 == do_cnrla then
            set_vol("speedbag.imu", dom.sb_far_vol)
        elseif arg3 == do_winws then
            set_vol("speedbag.imu", dom.sb_medium_vol)
        else
            set_vol("speedbag.imu", dom.sb_close_vol)
        end
    end
end
dom.scotch_object = Object:create(dom, "/dotx095/scotch", 1.54015, 2.23106, 0.23999999, { range = 0.775047 })
dom.scotch_object.use_pnt_x = 1.3319
dom.scotch_object.use_pnt_y = 2.3216701
dom.scotch_object.use_pnt_z = 0
dom.scotch_object.use_rot_x = 0
dom.scotch_object.use_rot_y = 223.27699
dom.scotch_object.use_rot_z = 0
dom.scotch_object.string_name = "scotch_object"
dom.scotch_object.lookAt = function(arg1) -- line 340
    if reaped_meche then
        START_CUT_SCENE()
        manny:say_line("/doma096/")
        wait_for_message()
        manny:say_line("/doma097/")
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        manny:say_line("/doma098/")
        wait_for_message()
        domino:say_line("/dodo099/")
        END_CUT_SCENE()
    end
end
dom.scotch_object.use = function(arg1) -- line 356
    while manny.is_idling do
        break_here()
    end
    if manny:walkto(arg1) then
        START_CUT_SCENE("no head")
        manny:push_costume(ma_drink_cos)
        scotch:play_chore(1)
        manny:play_chore(ma_drink_drink, "ma_drink.cos")
        manny:wait_for_chore()
        scotch:play_chore(0)
        manny:pop_costume()
        END_CUT_SCENE()
    end
end
dom.scotch_object.pickUp = dom.scotch_object.use
dom.tube_object = Object:create(dom, "/dotx100/tube", 0.82014501, 2.9410601, 0.27000001, { range = 0.71758699 })
dom.tube_object.use_pnt_x = 0.880418
dom.tube_object.use_pnt_y = 2.7402599
dom.tube_object.use_pnt_z = 0
dom.tube_object.use_rot_x = 0
dom.tube_object.use_rot_y = 29.6826
dom.tube_object.use_rot_z = 0
dom.tube_object.lookAt = function(arg1) -- line 387
    manny:say_line("/doma101/")
end
dom.tube_object.use = function(arg1) -- line 391
    START_CUT_SCENE()
    manny:say_line("/doma102/")
    wait_for_message()
    END_CUT_SCENE()
    manny:say_line("/doma103/")
    manny:twist_head_gesture()
end
dom.tube_object.use_coral = dom.tube_object.use
dom.tube_object.use_cat_balloon = dom.tube_object.use
dom.tube_object.use_dingo_balloon = dom.tube_object.use
dom.tube_object.use_frost_balloon = dom.tube_object.use
dom.tube_object.use_eggs = dom.tube_object.use
dom.tube_object.use_bread = dom.tube_object.use
dom.frames_1_obj = Object:create(dom, "/dotx104/diplomas", 1.58015, 2.3310599, 0.51999998, { range = 0.65618002 })
dom.frames_1_obj.use_pnt_x = 1.3200001
dom.frames_1_obj.use_pnt_y = 2.21
dom.frames_1_obj.use_pnt_z = 0
dom.frames_1_obj.use_rot_x = 0
dom.frames_1_obj.use_rot_y = -136.72301
dom.frames_1_obj.use_rot_z = 0
dom.frames_1_obj.lookAt = function(arg1) -- line 419
    if reaped_meche then
        manny:say_line("/doma105/")
    else
        START_CUT_SCENE()
        manny:say_line("/doma106/")
        wait_for_message()
        domino:say_line("/dodo107/")
        wait_for_message()
        manny:say_line("/doma108/")
        END_CUT_SCENE()
    end
end
dom.frames_1_obj.pickUp = function(arg1) -- line 433
    manny:say_line("/doma109/")
end
dom.computer_obj = Object:create(dom, "/dotx110/computer", 0.140145, 2.3710599, 0.46000001, { range = 0.74503303 })
dom.computer_obj.use_pnt_x = 0.42500001
dom.computer_obj.use_pnt_y = 2.3800001
dom.computer_obj.use_pnt_z = 0
dom.computer_obj.use_rot_x = 0
dom.computer_obj.use_rot_y = 94.57
dom.computer_obj.use_rot_z = 0
dom.computer_obj.count = 0
dom.computer_obj.use = function(arg1) -- line 451
    if reaped_meche then
        while manny.is_idling do
            break_here()
        end
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        if manny.is_holding then
            put_away_held_item()
        end
        if dom.computer_obj.count < 2 then
            manny:say_line("/doma111/")
            wait_for_message()
        end
        dom.computer_obj.count = dom.computer_obj.count + 1
        if dom.computer_obj.count <= 9 then
            manny:push_costume("ma_note_type.cos")
            manny:play_chore(ma_note_type_to_type, "ma_note_type.cos")
            manny:wait_for_chore()
            manny:play_chore(ma_note_type_type_loop, "ma_note_type.cos")
            start_sfx("keyboard.imu")
            manny:wait_for_chore()
            stop_sound("keyboard.imu")
            start_sfx("compbeep.wav")
            manny:head_look_at(0.155, 2.42, 0.47)
            wait_for_sound("compbeep.wav")
            sleep_for(500)
        end
        if dom.computer_obj.count == 1 then
            manny:say_line("/doma112/")
        elseif dom.computer_obj.count == 2 then
            manny:say_line("/doma113/")
        elseif dom.computer_obj.count == 3 then
            manny:say_line("/doma114/")
        elseif dom.computer_obj.count == 4 then
            manny:say_line("/doma115/")
        elseif dom.computer_obj.count == 5 then
            manny:say_line("/doma116/")
        elseif dom.computer_obj.count == 6 then
            manny:say_line("/doma117/")
        elseif dom.computer_obj.count == 7 then
            manny:say_line("/doma118/")
        elseif dom.computer_obj.count == 8 then
            manny:say_line("/doma119/")
        elseif dom.computer_obj.count == 9 then
            manny:say_line("/doma120/")
        else
            manny:say_line("/doma121/")
        end
        if dom.computer_obj.count <= 9 then
            manny:play_chore(ma_note_type_type_to_home, "ma_note_type.cos")
            manny:wait_for_chore()
            manny:pop_costume()
        end
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:head_look_at(dom.domino_obj)
        manny:say_line("/doma122/")
        wait_for_message()
        domino:say_line("/dodo123/")
        sleep_for(750)
        manny:head_look_at(arg1)
        END_CUT_SCENE()
    end
end
dom.computer_obj.pickUp = function(arg1) -- line 525
    system.default_response("not portable")
end
dom.computer_obj.lookAt = dom.computer_obj.use
dom.domino_obj = Object:create(dom, "/dotx125/Domino", 0.274019, 0.91632497, 0.48100001, { range = 0.89999998 })
dom.domino_obj.use_pnt_x = 0.705019
dom.domino_obj.use_pnt_y = 0.67032599
dom.domino_obj.use_pnt_z = 0
dom.domino_obj.use_rot_x = 0
dom.domino_obj.use_rot_y = 47.768902
dom.domino_obj.use_rot_z = 0
dom.domino_obj.lookAt = function(arg1) -- line 548
    START_CUT_SCENE()
    manny:say_line("/doma126/")
    wait_for_message()
    domino:say_line("/dodo127/")
    END_CUT_SCENE()
end
dom.domino_obj.pickUp = function(arg1) -- line 556
    manny:say_line("/doma128/")
end
dom.domino_obj.use = function(arg1) -- line 560
    if manny:walkto(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        END_CUT_SCENE()
        Dialog:run("do1", "dlg_domino.lua")
    end
end
dom.domino_obj.use_scythe = function(arg1) -- line 569
    manny:say_line("/doma168/")
end
dom.frames_2_obj = Object:create(dom, "/dotx129/pictures", 0.140145, 0.021059999, 0.52999997, { range = 0.93014002 })
dom.frames_2_obj.use_pnt_x = 0.107839
dom.frames_2_obj.use_pnt_y = 0.60944098
dom.frames_2_obj.use_pnt_z = 0
dom.frames_2_obj.use_rot_x = 0
dom.frames_2_obj.use_rot_y = 197.991
dom.frames_2_obj.use_rot_z = 0
dom.frames_2_obj.lookAt = function(arg1) -- line 585
    if reaped_meche then
        manny:say_line("/doma130/")
    else
        START_CUT_SCENE()
        manny:say_line("/doma131/")
        wait_for_message()
        END_CUT_SCENE()
        domino:say_line("/dodo132/")
    end
end
dom.frames_2_obj.pickUp = function(arg1) -- line 597
    manny:say_line("/doma133/")
end
dom.drawer_object = Object:create(dom, "/dotx134/drawer", 0.4962, 2.2067001, 0.17, { range = 0.5 })
dom.drawer_object.use_pnt_x = 0.52600002
dom.drawer_object.use_pnt_y = 2.3800001
dom.drawer_object.use_pnt_z = 0
dom.drawer_object.use_rot_x = 0
dom.drawer_object.use_rot_y = 549.80103
dom.drawer_object.use_rot_z = 0
dom.drawer_object.nothin_there = function(arg1) -- line 617
    manny:say_line("/doma135/")
end
dom.drawer_object.lookAt = function(arg1) -- line 621
    if arg1:is_open() then
        if dom.coral.owner == IN_THE_ROOM then
            manny:say_line("/doma136/")
        else
            dom.drawer_object:nothin_there()
        end
    else
        manny:say_line("/doma137/")
    end
end
dom.drawer_object.use = function(arg1) -- line 636
    if manny:walkto_object(arg1) then
        START_CUT_SCENE(no_head)
        if not reaped_meche then
            manny:play_chore(ms_reach_med, "ms.cos")
            sleep_for(200)
            domino:say_line("/dodo138/")
        elseif arg1:is_open() then
            while manny.is_idling do
                break_here()
            end
            if manny.is_holding then
                put_away_held_item()
            end
            if dom.coral.owner == IN_THE_ROOM then
                preload_sfx("getCoral.wav")
                manny:push_costume("ma_reachin_drwr.cos")
                manny:play_chore(ma_reachin_drwr_grab_coral, "ma_reachin_drwr.cos")
                sleep_for(933)
                SendObjectToFront(drawer_woglow)
                arg1:play_chore(do_drawer_open_drawer_set_open_wo_glow)
                sleep_for(150)
                manny:stop_chore(ma_reachin_drwr_grab_coral, "ma_reachin_drwr.cos")
                manny:pop_costume()
                dom.coral:get()
                manny:say_line("/gtcma12/")
                manny.is_holding = dom.coral
                manny.hold_chore = ms_activate_coral
                manny:play_chore_looping(ms_activate_coral, "ms.cos")
                manny:play_chore_looping(ms_hold, "ms.cos")
            else
                manny:push_costume("ma_open_drwr.cos")
                manny:play_chore(ma_open_drwr_close_drwr, "ma_open_drwr.cos")
                sleep_for(500)
                start_sfx("deskopen.wav")
                arg1:play_chore(do_drawer_open_drawer_close_wo_glow)
                manny:wait_for_chore()
                manny:pop_costume()
                arg1:close()
            end
        else
            preload_sfx("getCoral.wav")
            if manny.is_holding then
                put_away_held_item()
            end
            manny:push_costume("ma_open_drwr.cos")
            manny:play_chore(ma_open_drwr_open_drwr, "ma_open_drwr.cos")
            sleep_for(700)
            start_sfx("deskopen.wav")
            if dom.coral.owner == IN_THE_ROOM then
                arg1:play_chore(do_drawer_open_drawer_open_glow)
            else
                arg1:play_chore(do_drawer_open_drawer_open_wo_glow)
            end
            manny:wait_for_chore()
            manny:pop_costume()
            if dom.coral.owner == IN_THE_ROOM then
                start_sfx("getCoral.wav")
            end
            arg1:open()
            if dom.coral.owner == IN_THE_ROOM then
                if not arg1.seen then
                    arg1.seen = TRUE
                    wait_for_message()
                    manny:say_line("/doma139/")
                end
            end
        end
        END_CUT_SCENE()
    end
end
dom.drawer_object.pickUp = dom.drawer_object.use
dom.coral = Object:create(dom, "/dotx140/coral", 0.4962, 2.2067001, 0.17, { range = 0.5 })
dom.coral.use_pnt_x = dom.drawer_object.use_pnt_x
dom.coral.use_pnt_y = dom.drawer_object.use_pnt_y
dom.coral.use_pnt_z = dom.drawer_object.use_pnt_z
dom.coral.use_rot_x = dom.drawer_object.use_rot_x
dom.coral.use_rot_y = dom.drawer_object.use_rot_y
dom.coral.use_rot_z = dom.drawer_object.use_rot_z
dom.coral:make_untouchable()
dom.coral.wav = "getCoral.wav"
dom.coral.lookAt = function(arg1) -- line 730
    manny:say_line("/doma141/")
end
dom.coral.pickUp = function(arg1) -- line 734
    if dom.coral.owner == IN_THE_ROOM then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        END_CUT_SCENE()
        arg1:get()
        dom.coral:make_untouchable()
    end
end
dom.coral.use = function(arg1) -- line 744
    manny:say_line("/doma142/")
end
dom.coral.default_response = function(arg1) -- line 748
    manny:say_line("/doma143/")
end
dom.bag = Object:create(dom, "/dotx144/speed bag", 0.100145, 1.16106, 0.58999997, { range = 0.89999998 })
dom.bag.use_pnt_x = 0.276687
dom.bag.use_pnt_y = 1.09654
dom.bag.use_pnt_z = 0
dom.bag.use_rot_x = 0
dom.bag.use_rot_y = 74.129501
dom.bag.use_rot_z = 0
dom.bag.punch_count = 0
dom.bag.lookAt = function(arg1) -- line 769
    manny:say_line("/doma145/")
end
dom.bag.pickUp = function(arg1) -- line 773
    system.default_response("attached")
end
dom.bag.use = function(arg1) -- line 777
    if dom.bag.punch_count < 3 then
        if not manny_box_cos then
            manny_box_cos = "manny_box.cos"
        end
        if DEMO then
            START_CUT_SCENE(no_head)
            cameraman_disabled = FALSE
            manny:walkto_object(arg1)
            manny:push_costume(manny_box_cos)
            dom:current_setup(do_dorws)
            if speed_bag:is_choring(0) or speed_bag:is_choring(3) then
                manny:play_chore(manny_box_first_hit, manny_box_cos)
                sleep_for(600)
                start_sfx("speedhit.wav", nil, 90)
                sleep_for(400)
                speed_bag:stop_chore(3)
                speed_bag:stop_chore(0)
                speed_bag:play_chore(3)
            else
                speed_bag:stop_chore(0)
                speed_bag:play_chore(0)
                manny:play_chore(manny_box_first_hit, manny_box_cos)
                sleep_for(600)
                start_sfx("speedhit.wav", nil, 90)
            end
            manny:wait_for_chore()
            manny:pop_costume()
            dom:current_setup(do_winws)
            END_CUT_SCENE()
        else
            START_CUT_SCENE()
            manny:walkto_object(arg1)
            dom:current_setup(do_winws)
            manny:push_costume(manny_box_cos)
            if dom.bag.punch_count == 0 then
                manny:play_chore(manny_box_first_hit, manny_box_cos)
                speed_bag:play_chore(0)
                sleep_for(300)
                dom.mouthpiece_actor:stop_chore(mouthpiece_box_sitting)
                dom.mouthpiece_actor:play_chore(mouthpiece_box_first_hit)
                sleep_for(300)
                start_sfx("speedhit.wav", nil, 50)
                manny:wait_for_chore()
                dom.mouthpiece.status = MOUTHPIECE_KNOCKED_ONCE
            elseif dom.bag.punch_count == 1 then
                if speed_bag:is_choring(0) or speed_bag:is_choring(3) then
                    manny:play_chore(manny_box_first_hit, manny_box_cos)
                    sleep_for(300)
                    dom.mouthpiece_actor:play_chore(mouthpiece_box_second_hit)
                    sleep_for(300)
                    start_sfx("speedhit.wav", nil, 80)
                    sleep_for(400)
                    speed_bag:stop_chore(3)
                    speed_bag:stop_chore(0)
                    speed_bag:play_chore(3)
                else
                    speed_bag:stop_chore(0)
                    speed_bag:play_chore(0)
                    manny:play_chore(manny_box_first_hit, manny_box_cos)
                    sleep_for(300)
                    dom.mouthpiece_actor:play_chore(mouthpiece_box_second_hit)
                    sleep_for(300)
                    start_sfx("speedhit.wav", nil, 80)
                end
                dom.mouthpiece.status = MOUTHPIECE_KNOCKED_TWICE
                manny:wait_for_chore()
            elseif dom.bag.punch_count == 2 then
                if speed_bag:is_choring(0) or speed_bag:is_choring(3) then
                    manny:play_chore(manny_box_first_hit, manny_box_cos)
                    sleep_for(300)
                    dom.mouthpiece_actor:play_chore(mouthpiece_box_third_hit)
                    sleep_for(300)
                    start_sfx("speedhit.wav", nil, 127)
                    sleep_for(400)
                    speed_bag:stop_chore(3)
                    speed_bag:stop_chore(0)
                    speed_bag:play_chore(3)
                else
                    speed_bag:stop_chore(0)
                    speed_bag:play_chore(0)
                    manny:play_chore(manny_box_first_hit, manny_box_cos)
                    sleep_for(300)
                    dom.mouthpiece_actor:play_chore(mouthpiece_box_third_hit)
                    sleep_for(300)
                    start_sfx("speedhit.wav", nil, 80)
                end
                dom.mouthpiece_actor:wait_for_chore()
                manny:wait_for_chore()
                dom.mouthpiece:make_touchable()
                dom.mouthpiece_actor:stop_chore(mouthpiece_box_third_hit)
                dom.mouthpiece_actor:play_chore_looping(mouthpiece_box_sitting)
                dom.mouthpiece_actor:setpos(0.29, 1.02654, -0.67)
                dom.mouthpiece.status = MOUTHPIECE_ON_FLOOR
            end
            dom.bag.punch_count = dom.bag.punch_count + 1
            manny:pop_costume()
            END_CUT_SCENE()
        end
    else
        START_CUT_SCENE(no_head)
        cameraman_disabled = FALSE
        manny:walkto_object(arg1)
        manny:push_costume(manny_box_cos)
        dom:current_setup(do_dorws)
        if speed_bag:is_choring(0) or speed_bag:is_choring(3) then
            manny:play_chore(manny_box_first_hit, manny_box_cos)
            sleep_for(600)
            start_sfx("speedhit.wav", nil, 90)
            sleep_for(400)
            speed_bag:stop_chore(3)
            speed_bag:stop_chore(0)
            speed_bag:play_chore(3)
        else
            speed_bag:stop_chore(0)
            speed_bag:play_chore(0)
            manny:play_chore(manny_box_first_hit, manny_box_cos)
            sleep_for(600)
            start_sfx("speedhit.wav", nil, 90)
        end
        manny:wait_for_chore()
        manny:pop_costume()
        dom:current_setup(do_winws)
        END_CUT_SCENE()
    end
end
dom.bag:make_untouchable()
dom.mouthpiece = Object:create(dom, "/dotx147/mouthpiece", 0.100145, 1.02106, 0.0100002, { range = 0.5 })
dom.mouthpiece.use_pnt_x = 0.28738701
dom.mouthpiece.use_pnt_y = 0.91093999
dom.mouthpiece.use_pnt_z = 0
dom.mouthpiece.use_rot_x = 0
dom.mouthpiece.use_rot_y = 56.720402
dom.mouthpiece.use_rot_z = 0
MOUTHPIECE_ON_SHELF = 0
MOUTHPIECE_KNOCKED_ONCE = 1
MOUTHPIECE_KNOCKED_TWICE = 2
MOUTHPIECE_ON_FLOOR = 3
dom.mouthpiece.bonded = FALSE
dom.mouthpiece.molded = FALSE
dom.mouthpiece.status = MOUTHPIECE_ON_SHELF
dom.mouthpiece.lookAt = function(arg1) -- line 924
    if arg1.bonded then
        if arg1.molded then
            manny:say_line("/doma148/")
        else
            manny:say_line("/doma149/")
        end
    else
        manny:say_line("/doma150/")
        if arg1.owner == manny then
            START_CUT_SCENE()
            wait_for_message()
            manny:say_line("/doma151/")
            END_CUT_SCENE()
        end
    end
end
dom.mouthpiece.pickUp = function(arg1) -- line 942
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:play_chore(ms_reach_low, "ms.cos")
    sleep_for(804)
    dom.mouthpiece:get()
    dom.mouthpiece_actor:free()
    manny:wait_for_chore(ms_reach_low, "ms.cos")
    manny:stop_chore(ms_reach_low, "ms.cos")
    manny:play_chore_looping(ms_hold, "ms.cos")
    manny:play_chore_looping(ms_activate_mouthpiece, "ms.cos")
    manny.hold_chore = ms_activate_mouthpiece
    manny.is_holding = dom.mouthpiece
    manny:say_line("/doma152/")
    END_CUT_SCENE()
end
dom.mouthpiece.use = function(arg1) -- line 959
    if arg1.owner == IN_THE_ROOM then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        manny:push_costume("ma_fill_bondo.cos")
        manny:stop_chore(manny.hold_chore, "ms.cos")
        manny:stop_chore(ms_hold, "ms.cos")
        if arg1.bonded then
            cur_puzzle_state[10] = TRUE
            manny:play_chore(ma_fill_bondo_put_filled_mp_mouth)
            manny:wait_for_chore()
            manny:pop_costume()
            manny:play_chore_looping(manny.hold_chore, "ms.cos")
            manny:play_chore_looping(ms_hold, "ms.cos")
            if arg1.molded then
                manny:say_line("/doma153/")
            else
                arg1.molded = TRUE
                manny:say_line("/doma154/")
                wait_for_message()
                manny:say_line("/doma155/")
            end
        else
            manny:play_chore(ma_fill_bondo_wear_mp)
            manny:wait_for_chore()
            manny:play_chore(ma_fill_bondo_wear_turn)
            manny:wait_for_chore()
            manny:play_chore(ma_fill_bondo_takeoff_mp)
            manny:wait_for_chore()
            manny:pop_costume()
            manny:play_chore_looping(manny.hold_chore, "ms.cos")
            manny:play_chore_looping(ms_hold, "ms.cos")
            manny:say_line("/doma156/")
            wait_for_message()
            manny:say_line("/doma157/")
        end
        END_CUT_SCENE()
    end
end
dom.mouthpiece.default_response = function(arg1) -- line 1002
    if arg1.bonded then
        if arg1.molded then
            manny:say_line("/doma158/")
        else
            manny:say_line("/doma159/")
        end
    else
        manny:say_line("/doma160/")
    end
end
dom.mouthpiece:make_untouchable()
dom.window = Object:create(dom, "/dotx161/window", 1.1762, 3.0267, 0.47999999, { range = 0.69999999 })
dom.window.use_pnt_x = 1.20166
dom.window.use_pnt_y = 2.73315
dom.window.use_pnt_z = 0
dom.window.use_rot_x = 0
dom.window.use_rot_y = 3.5924101
dom.window.use_rot_z = 0
dom.window.out_pnt_x = 1.20166
dom.window.out_pnt_y = 2.73315
dom.window.out_pnt_z = 0
dom.window.out_rot_x = 0
dom.window.out_rot_y = 3.5924101
dom.window.out_rot_z = 0
dom.do_window_box = dom.window
dom.window.lookAt = function(arg1) -- line 1034
    manny:say_line("/doma162/")
end
dom.window.use = function(arg1) -- line 1038
    if reaped_meche then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        if manny.is_holding then
            put_away_held_item()
        end
        dom:climb_out()
        END_CUT_SCENE()
    else
        manny:say_line("/doma163/")
    end
end
dom.window.walkOut = dom.window.use
dom.ha_door = Object:create(dom, "/dotx164/door", 0.76014501, -0.048941199, 0.50999999, { range = 0.93039 })
dom.do_ha_box = dom.ha_door
dom.ha_door.use_pnt_x = 0.75
dom.ha_door.use_pnt_y = 0.1
dom.ha_door.use_pnt_z = 0
dom.ha_door.use_rot_x = 0
dom.ha_door.use_rot_y = 179.62199
dom.ha_door.use_rot_z = 0
dom.ha_door.out_pnt_x = 0.74199998
dom.ha_door.out_pnt_y = -0.2
dom.ha_door.out_pnt_z = 0
dom.ha_door.out_rot_x = 0
dom.ha_door.out_rot_y = -179.88901
dom.ha_door.out_rot_z = 0
dom.ha_door.walkOut = function(arg1) -- line 1074
    if reaped_meche then
        soft_script()
        manny:say_line("/doma165/")
    else
        ha:come_out_door(ha.do_door)
    end
end
dom.ha_door.lookAt = function(arg1) -- line 1087
    manny:say_line("/doma167/")
end
dom.ha_door.pickUp = dom.ha_door.walkOut

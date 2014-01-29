CheckFirstTime("ha.lua")
ha = Set:create("ha.set", "Hallway", { ha_elvos = 0, ha_revls = 1, ha_intls = 2, ha_intls2 = 2, ha_evaws = 3, ha_evacu = 4, ha_mnycu = 5, overhead = 6 })
ha.shrinkable = 0.025
ha.cheat_boxes = { ha_cheat_box_1 = 1 }
dofile("eva_sec.lua")
dofile("ha_elvos_elev_door.lua")
dofile("ha_elvos_garelev_door.lua")
dofile("ha_intls_domino_door.lua")
dofile("ma_open_door.lua")
dofile("hole_punch.lua")
dofile("ma_card_punch.lua")
ha.eva_chat_box = { }
ha.random_squeaks = function(arg1) -- line 27
    local local1, local2
    local2 = 0
    if not arg1 then
        arg1 = 1
    end
    while local2 < arg1 do
        local1 = pick_from_nonweighted_table(fe.balloon_sfx)
        start_sfx(local1)
        wait_for_sound(local1)
        local2 = local2 + 1
    end
end
ha.elevator_open_too_long = function() -- line 42
    if system.currentSet == ha then
        START_CUT_SCENE()
        eva:say_line("/haev165/")
        wait_for_message()
        manny:say_line("/hama166/")
        wait_for_message()
        eva:say_line("/haev167/")
        eva.talked_elevator_too_long = TRUE
        END_CUT_SCENE()
    end
end
ha.elevator_min_msecs = 8000
ha.elevator_max_msecs = 10000
ha.elevator_too_long_msecs = 60000
ha.elevator_door_timer = function(arg1) -- line 60
    local local1, local2
    local2 = 0
    while arg1:is_open() do
        local1 = rnd(ha.elevator_min_msecs, ha.elevator_max_msecs)
        sleep_for(local1)
        local2 = local2 + local1
        if arg1:is_open() then
            if arg1 == ha.lo_door then
                arg1.interest_actor:play_chore(ha_elvos_elev_door_abort_close)
            else
                arg1.interest_actor:play_chore(ha_elvos_garelev_door_abort_close)
            end
            arg1.interest_actor:wait_for_chore()
            if local2 >= ha.elevator_too_long_msecs and not eva.talked_elevator_too_long then
                local2 = 0
                ha.elevator_open_too_long()
            end
        end
    end
end
ha.eva_chat_box.walkOut = function(arg1) -- line 84
    local local1
    if fe.balloon_cat.owner == manny or fe.balloon_dingo.owner == manny or fe.balloon_frost == manny then
        local1 = TRUE
    end
    if tu.chem_state == "both chem" and not eva.talked_server then
        eva.talked_server = TRUE
        eva:say_line("/haev122/")
        wait_for_message()
        manny:say_line("/hama123/")
    elseif local1 and not eva.talked_balloons then
        eva.talked_balloons = TRUE
        ha.random_squeaks(3)
        eva:say_line("/haev124/")
        wait_for_message()
        start_script(ha.random_squeaks, 2)
        manny:say_line("/hama125/")
    elseif ga.been_there and not glottis.met and not eva.driver_hint then
        eva.driver_hint = TRUE
        eva:say_line("/haev126/")
    end
end
ha.funny_bones = function() -- line 107
    START_CUT_SCENE("nohead")
    manny:head_look_at(nil)
    manny:walkto(6.52021, 0.682541, 0)
    manny:wait_for_actor()
    start_script(play_movie, "funny.snm", 384, 110)
    sleep_for(1000)
    copal:say_line("/haco127/")
    sleep_for(500)
    manny:head_look_at(ha.co_door)
    sleep_for(500)
    manny:setrot(0, 172.154, 0, TRUE)
    copal:wait_for_message()
    copal:say_line("/haco128/")
    copal:wait_for_message()
    copal:say_line("/haco129/")
    wait_for_movie()
    system:lock_display()
    copal:wait_for_message()
    END_CUT_SCENE()
    stop_script(run_idle)
    stop_sound("keyboard.IMU")
    eva:stop_chore()
    eva:free()
    start_script(cut_scene.reapmec3, cut_scene)
end
ha.check_evas_head = function(arg1) -- line 134
    if ha:current_setup() == ha_mnycu or ha:current_setup() == ha_elvos then
        eva:set_visibility(FALSE)
    else
        eva:set_visibility(TRUE)
    end
end
ha.eva_follow_manny = function(arg1) -- line 146
    local local1, local2, local3, local4, local5
    while 1 do
        local1, local2, local3, local4, local5 = GetVisibleThings()
        if local1 ~= eva.hActor and local2 ~= eva.hActor and local3 ~= eva.hActor and local4 ~= eva.hActor and local5 ~= eva.hActor then
            eva:head_look_at(manny)
        else
            eva:head_look_at(nil)
        end
        break_here()
    end
end
ha.set_up_actors = function(arg1) -- line 159
    if not eva.idle_table then
        eva.idle_table = { }
        eva.idle_table[eva_sec_look_up] = { }
        eva.idle_table[eva_sec_look_up][eva_sec_look_back] = 0.5
        eva.idle_table[eva_sec_look_up][eva_sec_to_type] = 0.5
        eva.idle_table[eva_sec_look_back] = { }
        eva.idle_table[eva_sec_look_back][eva_sec_look_up] = 0.1
        eva.idle_table[eva_sec_look_back][eva_sec_read_loop] = 0.7
        eva.idle_table[eva_sec_look_back][eva_sec_hand_down] = 0.1
        eva.idle_table[eva_sec_look_back][eva_sec_flip_page] = 0.1
        eva.idle_table[eva_sec_to_type] = { }
        eva.idle_table[eva_sec_to_type][eva_sec_trans_type] = 0.99
        eva.idle_table[eva_sec_to_type][eva_sec_to_read] = 0.01
        eva.idle_table[eva_sec_trans_type] = { }
        eva.idle_table[eva_sec_trans_type][eva_sec_type] = 0.5
        eva.idle_table[eva_sec_trans_type][eva_sec_chk_type] = 0.5
        eva.idle_table[eva_sec_type] = { }
        eva.idle_table[eva_sec_type][eva_sec_type] = 0.85
        eva.idle_table[eva_sec_type][eva_sec_chk_type] = 0.1
        eva.idle_table[eva_sec_type][eva_sec_to_read] = 0.05
        eva.idle_table[eva_sec_chk_type] = { }
        eva.idle_table[eva_sec_chk_type][eva_sec_type] = 0.95
        eva.idle_table[eva_sec_chk_type][eva_sec_to_read] = 0.05
        eva.idle_table[eva_sec_to_read] = { }
        eva.idle_table[eva_sec_to_read][eva_sec_read_loop] = 0.5
        eva.idle_table[eva_sec_to_read][eva_sec_flip_page] = 0.5
        eva.idle_table[eva_sec_hand_down] = { }
        eva.idle_table[eva_sec_hand_down][eva_sec_up_file] = 0.9
        eva.idle_table[eva_sec_hand_down][eva_sec_stretch] = 0.1
        eva.idle_table[eva_sec_up_file] = { }
        eva.idle_table[eva_sec_up_file][eva_sec_to_file] = 0.8
        eva.idle_table[eva_sec_up_file][eva_sec_look_loop] = 0.09
        eva.idle_table[eva_sec_up_file][eva_sec_down_file] = 0.01
        eva.idle_table[eva_sec_to_file] = { }
        eva.idle_table[eva_sec_to_file][eva_sec_file_loop] = 0.8
        eva.idle_table[eva_sec_to_file][eva_sec_look_nail] = 0.2
        eva.idle_table[eva_sec_look_nail] = { }
        eva.idle_table[eva_sec_look_nail][eva_sec_look_loop] = 0.8
        eva.idle_table[eva_sec_look_nail][eva_sec_down_file] = 0.2
        eva.idle_table[eva_sec_look_loop] = { }
        eva.idle_table[eva_sec_look_loop][eva_sec_look_loop] = 0.03
        eva.idle_table[eva_sec_look_loop][eva_sec_down_file] = 0.3
        eva.idle_table[eva_sec_look_loop][eva_sec_to_file] = 0.67
        eva.idle_table[eva_sec_file_loop] = { }
        eva.idle_table[eva_sec_file_loop][eva_sec_file_loop] = 0.95
        eva.idle_table[eva_sec_file_loop][eva_sec_look_nail] = 0.05
        eva.idle_table[eva_sec_down_file] = { }
        eva.idle_table[eva_sec_down_file][eva_sec_stretch] = 0.9
        eva.idle_table[eva_sec_down_file][eva_sec_up_file] = 0.1
        eva.idle_table[eva_sec_stretch] = { }
        eva.idle_table[eva_sec_stretch][eva_sec_read_loop] = 1
        eva.idle_table[eva_sec_flip_page] = { }
        eva.idle_table[eva_sec_flip_page][eva_sec_flip_page] = 0.3
        eva.idle_table[eva_sec_flip_page][eva_sec_read_loop] = 0.7
        eva.idle_table[eva_sec_read_loop] = { }
        eva.idle_table[eva_sec_read_loop][eva_sec_read_loop] = 0.6
        eva.idle_table[eva_sec_read_loop][eva_sec_look_up] = 0.2
        eva.idle_table[eva_sec_read_loop][eva_sec_hand_down] = 0.05
        eva.idle_table[eva_sec_read_loop][eva_sec_flip_page] = 0.15
    end
    eva:default("sec")
    eva:setrot(0, 50, 0)
    eva:setpos(7.14472, 0.36273, 0.007)
    eva:set_head(33, 34, 35, 165, 28, 80)
    eva:put_in_set(ha)
    ha:check_evas_head()
    start_script(run_idle, eva, eva.idle_table, eva_sec_type)
    if not copal then
        copal = Actor:create("x_spot.3do", nil, nil, "/hatx130/")
    end
    copal:put_in_set(co)
    copal:set_visibility(FALSE)
    copal:setpos(7.14472, 0.3, 0.3)
    copal:set_talk_color(Blue)
    ha.hole_punch:default_actor()
    SetShadowColor(5, 5, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -30, 200)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow5")
end
ha.enter = function(arg1) -- line 290
    manny.footsteps = footsteps.rug
    ha:set_up_actors()
    ha:add_object_state(ha_elvos, "elev_door.bm", "elev_door.zbm", OBJSTATE_STATE)
    ha:add_object_state(ha_elvos, "garelev_door_close.bm", "garelev_door_close.zbm", OBJSTATE_STATE)
    ha:add_object_state(ha_intls, "domino_door_open.bm", nil, OBJSTATE_STATE)
    ha.ga_door:set_object_state("ha_elvos_garelev_door.cos")
    ha.do_door:set_object_state("ha_intls_domino_door.cos")
    ha.lo_door:set_object_state("ha_elvos_elev_door.cos")
    if reaped_bruno and not reaped_meche then
        MakeSectorActive("ha_do_gate", TRUE)
        ha.do_door:play_chore(2)
        ha.do_door:unlock()
    else
        ha.do_door:play_chore(3)
        MakeSectorActive("ha_do_gate", FALSE)
        ha.do_door:lock()
    end
    MakeSectorActive("ha_co_gate", FALSE)
    ha.ga_door:make_touchable()
    ha.lo_door:make_touchable()
end
ha.camerachange = function(arg1, arg2, arg3) -- line 318
    ha:check_evas_head()
    if reaped_meche and arg3 == ha_evaws then
        start_script(ha.funny_bones)
    end
    music_state:set_state(arg1:update_music_state(arg3))
end
ha.update_music_state = function(arg1, arg2) -- line 328
    local local1
    if local1 == nil then
        local1 = arg1:current_setup()
    end
    if local1 == ha_elvos then
        return stateHA_ELVOS
    elseif local1 == ha_revls then
        return stateHA_REVLS
    elseif local1 == ha_intls then
        return stateHA_INTLS
    elseif local1 == ha_mnycu then
        return stateHA_MNYCU
    elseif local1 == ha_evacu then
        return stateHA_EVACU
    elseif local1 == ha_evaws then
        return stateHA_EVAWS
    end
end
ha.exit = function(arg1) -- line 350
    stop_script(run_idle)
    eva:set_visibility(TRUE)
    eva:free()
    ha.ga_door:free_object_state()
    ha.do_door:free_object_state()
    ha.lo_door:free_object_state()
    ha.hole_punch.objstate_actor:free()
    KillActorShadows(manny.hActor)
end
ha.hole_punch = Object:create(ha, "/hatx131/hole punch", 7.1735702, 0.748806, 0.25999999, { range = 0.5 })
ha.hole_punch.use_pnt_x = 7.12498
ha.hole_punch.use_pnt_y = 0.89999998
ha.hole_punch.use_pnt_z = 0
ha.hole_punch.use_rot_x = 0
ha.hole_punch.use_rot_y = 194.299
ha.hole_punch.use_rot_z = 0
ha.hole_punch.lookAt = function(arg1) -- line 383
    manny:say_line("/hama132/")
end
ha.hole_punch.pickUp = function(arg1) -- line 387
    START_CUT_SCENE()
    manny:say_line("/hama133/")
    wait_for_message()
    eva:say_line("/haev134/")
    wait_for_message()
    END_CUT_SCENE()
end
ha.hole_punch.use = function(arg1) -- line 397
    local local1
    START_CUT_SCENE()
    enable_head_control(FALSE)
    manny:head_look_at_point(7.1265998, 0.37580001, 0.38)
    break_here()
    manny:say_line("/hama136/")
    manny:wait_for_message()
    eva:say_line("/haev137/")
    eva:wait_for_message()
    manny:walkto_object(arg1)
    manny:push_costume("ma_card_punch.cos")
    local1 = 0
    while local1 < 2 do
        manny:play_chore(ma_card_punch_hit_puncher, "ma_card_punch.cos")
        arg1.objstate_actor:play_chore(hole_punch_hit_puncher, "hole_punch.cos")
        manny:wait_for_chore()
        local1 = local1 + 1
    end
    manny:stop_chore(hole_punch_hit_puncher, "hole_punch.cos")
    manny:play_chore_looping(ms_rest, "ms.cos")
    manny:pop_costume()
    manny:head_look_at_point(7.1265998, 0.37580001, 0.38)
    manny:say_line("/hama138/")
    manny:wait_for_message()
    eva:say_line("/haev139/")
    sleep_for(200)
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
ha.hole_punch.use_card = function(arg1, arg2) -- line 431
    if arg2.punched then
        manny:say_line("/hama140/")
    else
        arg2.punched = TRUE
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:stop_chore(ms_hold_card, "ms.cos")
        manny:push_costume("ma_card_punch.cos")
        manny:play_chore_looping(ma_card_punch_act_card)
        manny:play_chore(ma_card_punch_card_punch, "ma_card_punch.cos")
        arg1.objstate_actor:play_chore(hole_punch_card_punch, "hole_punch.cos")
        manny:wait_for_chore()
        manny:stop_chore(ma_card_punch_act_card)
        manny:play_chore(ma_card_punch_act_hole_card)
        manny:play_chore_looping(ma_card_punch_hide_card)
        manny:blend(ms_activate_hole_card, ma_card_punch_card_punch, 500, "ms.cos", "ma_card_punch.cos")
        sleep_for(500)
        manny:pop_costume()
        manny:play_chore_looping(ms_activate_hole_card, "ms.cos")
        if not mo.one_card.ever_punched then
            mo.one_card.ever_punched = TRUE
            eva:say_line("/haev141/")
            wait_for_message()
            manny:say_line("/hama142/")
        end
        END_CUT_SCENE()
    end
end
ha.hole_punch.use_cards = function(arg1) -- line 465
    mo.cards:switch_to_one()
    ha.hole_punch:use_card(mo.one_card)
end
ha.hole_punch.use_mt_balloon = function(arg1) -- line 470
    manny:say_line("/hama168/")
end
ha.hole_punch.use_full_balloon = ha.hole_punch.use_mt_balloon
ha.hole_punch.default_actor = function(arg1) -- line 476
    if not arg1.objstate_actor then
        arg1.objstate_actor = Actor:create(nil, nil, nil, "hole punch")
    end
    arg1.objstate_actor:set_costume("hole_punch.cos")
    arg1.objstate_actor:put_in_set(ha)
    arg1.objstate_actor:set_visibility(TRUE)
    arg1.objstate_actor:setpos(7.19556, 0.884999, 0.00230002)
    arg1.objstate_actor:setrot(0, 170, 0)
    arg1.objstate_actor:play_chore(hole_punch_show, "hole_punch.cos")
end
ha.eva_obj = Object:create(ha, "/hatx143/Eva", 7.1265998, 0.37580001, 0.38, { range = 1 })
ha.eva_obj.use_pnt_x = 6.9679999
ha.eva_obj.use_pnt_y = 0.89700001
ha.eva_obj.use_pnt_z = 0
ha.eva_obj.use_rot_x = 0
ha.eva_obj.use_rot_y = 197.37
ha.eva_obj.use_rot_z = 0
ha.eva_obj.lookAt = function(arg1) -- line 497
    START_CUT_SCENE()
    manny:say_line("/hama144/")
    wait_for_message()
    eva:say_line("/haev145/")
    END_CUT_SCENE()
end
ha.eva_obj.use_memo = function(arg1) -- line 505
    eva:say_line("/haev146/")
end
ha.eva_obj.use = function(arg1) -- line 509
    Dialog:run("ev1", "dlg_eva.lua")
end
ha.eva_obj.use_work_order = function(arg1) -- line 513
    Dialog:run("ev1", "dlg_eva.lua", "work_order")
end
ha.eva_obj.use_card = function(arg1) -- line 517
    eva:say_line("/haev147/")
    manny:use_default()
end
ha.eva_obj.use_cards = function(arg1) -- line 522
    eva:say_line("/haev148/")
    manny:use_default()
end
ha.eva_obj.use_cat_balloon = function(arg1) -- line 527
    start_script(ha.random_squeaks, 2)
    manny:use_default()
    eva:say_line("/haev169/")
end
ha.eva_obj.use_dingo_balloon = ha.eva_obj.use_cat_balloon
ha.eva_obj.use_frost_balloon = ha.eva_obj.use_cat_balloon
ha.do_door = Object:create(ha, "/hatx149/door", 2.5557101, -0.1668127, 0.46000001, { range = 1.05431 })
ha.ha_do_box = ha.do_door
ha.do_door.passage = { "ha_do_gate" }
ha.do_door:lock()
ha.do_door.use_pnt_x = 2.5090001
ha.do_door.use_pnt_y = 0.141
ha.do_door.use_pnt_z = 0
ha.do_door.use_rot_x = 0
ha.do_door.use_rot_y = -547.21503
ha.do_door.use_rot_z = 0
ha.do_door.out_pnt_x = 2.5350001
ha.do_door.out_pnt_y = -0.097000003
ha.do_door.out_pnt_z = 0
ha.do_door.out_rot_x = 0
ha.do_door.out_rot_y = -169.132
ha.do_door.out_rot_z = 0
ha.do_door.lookAt = function(arg1) -- line 568
    manny:say_line("/doma167/")
end
ha.do_door.walkOut = function(arg1) -- line 572
    dom:come_out_door(dom.ha_door)
end
ha.do_door.use_card = function(arg1) -- line 576
    mo.one_card:picklock()
end
ha.do_door.locked_out = function(arg1) -- line 580
    manny:say_line("/hama150/")
    wait_for_message()
    if not ha.do_door.lamented and not reaped_meche then
        START_CUT_SCENE()
        ha.do_door.lamented = TRUE
        wait_for_message()
        manny:say_line("/hama151/")
        wait_for_message()
        manny:say_line("/hama170/")
        END_CUT_SCENE()
    end
end
ha.co_door = Object:create(ha, "/hatx152/door", 6.2465901, -0.24420001, 0.46000001, { range = 1.05431 })
ha.co_door:lock()
ha.ha_co_box = ha.co_door
ha.co_door.use_pnt_x = 6.197
ha.co_door.use_pnt_y = 0.111
ha.co_door.use_pnt_z = 0
ha.co_door.use_rot_x = 0
ha.co_door.use_rot_y = -181.09
ha.co_door.use_rot_z = 0
ha.co_door.out_pnt_x = 6.2319999
ha.co_door.out_pnt_y = -0.197
ha.co_door.out_pnt_z = 0
ha.co_door.out_rot_x = 0
ha.co_door.out_rot_y = 168.612
ha.co_door.out_rot_z = 0
ha.co_door.locked_out = function(arg1) -- line 618
    eva:say_line("/haev153/")
end
ha.co_door.walkOut = function(arg1) -- line 622
end
ha.co_door.lookAt = function(arg1) -- line 625
    START_CUT_SCENE()
    manny:say_line("/hama154/")
    wait_for_message()
    eva:say_line("/haev155/")
    wait_for_message()
    manny:say_line("/hama156/")
    wait_for_message()
    eva:say_line("/haev157/")
    wait_for_message()
    manny:say_line("/hama158/")
    END_CUT_SCENE()
end
ha.mo_door = Object:create(ha, "/hatx159/door", 0.84439999, -0.1543, 0.46000001, { range = 1.05431 })
ha.mo_door.passage = { "mo_door_psg1", "mo_door_psg2" }
ha.mo_door:open()
ha.ha_mo_box = ha.mo_door
ha.mo_door.use_pnt_x = 0.83600003
ha.mo_door.use_pnt_y = 0.122
ha.mo_door.use_pnt_z = 0
ha.mo_door.use_rot_x = 0
ha.mo_door.use_rot_y = 185.87
ha.mo_door.use_rot_z = 0
ha.mo_door.out_pnt_x = 0.86799997
ha.mo_door.out_pnt_y = -0.152
ha.mo_door.out_pnt_z = 0
ha.mo_door.out_rot_x = 0
ha.mo_door.out_rot_y = -160.21001
ha.mo_door.out_rot_z = 0
ha.mo_door.lookAt = function(arg1) -- line 661
    manny:say_line("/hama160/")
end
ha.mo_door.walkOut = function(arg1) -- line 665
    mo:come_out_door(mo.ha_door)
end
ha.ga_door = Object:create(ha, "/hatx161/elevator", 6.58356, 1.92881, 0.44, { range = 0.89999998 })
ha.ga_door.passage = { "ga_door_passage", "ga_door_psg2" }
ha.ga_door.use_pnt_x = 6.724
ha.ga_door.use_pnt_y = 1.931
ha.ga_door.use_pnt_z = 0
ha.ga_door.use_rot_x = 0
ha.ga_door.use_rot_y = 87.173103
ha.ga_door.use_rot_z = 0
ha.ga_door.out_pnt_x = 6.2729998
ha.ga_door.out_pnt_y = 2.029
ha.ga_door.out_pnt_z = 0
ha.ga_door.out_rot_x = 0
ha.ga_door.out_rot_y = 87.173103
ha.ga_door.out_rot_z = 0
ha.ga_door.walkOut = function(arg1) -- line 691
    START_CUT_SCENE()
    manny:clear_hands()
    manny:walkto(ha.ga_door.out_pnt_x, ha.ga_door.out_pnt_y, ha.ga_door.out_pnt_z)
    manny:wait_for_actor()
    start_script(ha.ga_door.close, ha.ga_door)
    while TurnActorTo(manny.hActor, ha.ga_door.use_pnt_x, ha.ga_door.use_pnt_y, ha.ga_door.use_pnt_z) do
        break_here()
    end
    wait_for_script(ha.ga_door.close)
    ga:switch_to_set()
    manny:put_in_set(ga)
    manny:setpos(ga.ha_door.out_pnt_x, ga.ha_door.out_pnt_y, ga.ha_door.out_pnt_z)
    manny:setrot(ga.ha_door.out_rot_x, ga.ha_door.out_rot_y + 180, ga.ha_door.out_rot_z)
    ga.ha_door:open()
    manny:walkto(ga.ha_door.use_pnt_x, ga.ha_door.use_pnt_y, ga.ha_door.use_pnt_z)
    manny:wait_for_actor()
    start_script(ga.ha_door.close, ga.ha_door)
    END_CUT_SCENE()
end
ha.ga_door.lookAt = function(arg1) -- line 715
    manny:say_line("/hama162/")
end
ha.ga_door.use = function(arg1) -- line 719
    START_CUT_SCENE()
    if not arg1:is_open() then
        arg1:open()
    end
    arg1:walkOut()
    END_CUT_SCENE()
end
ha.ga_door.open = function(arg1) -- line 728
    if not arg1:is_open() then
        arg1.interest_actor:wait_for_chore(ha_elvos_garelev_door_door_close)
        arg1.interest_actor:stop_chore()
        arg1.interest_actor:play_chore(ha_elvos_garelev_door_door_open)
        arg1.interest_actor:wait_for_chore()
        Object.open(arg1)
    end
    return TRUE
end
ha.ga_door.close = function(arg1) -- line 740
    if arg1:is_open() then
        Object.close(arg1)
        arg1.interest_actor:wait_for_chore(ha_elvos_garelev_door_door_open)
        arg1.interest_actor:stop_chore()
        arg1.interest_actor:play_chore(ha_elvos_garelev_door_door_close)
        arg1.interest_actor:wait_for_chore()
    end
    return TRUE
end
ha.ga_door_trigger = { }
ha.ga_door_trigger.walkOut = function(arg1) -- line 757
    local local1
    if ha.ga_door.interest_actor:is_choring() then
        ha.ga_door.interest_actor:wait_for_chore()
    end
    ha.ga_door:open()
    local1 = start_script(ha.elevator_door_timer, ha.ga_door)
    while manny:find_sector_name("ga_door_trigger") do
        break_here()
    end
    while manny:find_sector_name("ga_crushed") do
        break_here()
    end
    stop_script(local1)
    if manny:find_sector_name("ga_door") then
        single_start_script(ha.ga_door.walkOut)
        return nil
    elseif ha.ga_door.interest_actor:is_choring() then
        ha.ga_door.interest_actor:wait_for_chore()
    end
    ha.ga_door:close()
end
ha.lo_door = Object:create(ha, "/hatx163/elevator", 7.1044002, 3.0057001, 0.49000001, { range = 0.89999998 })
ha.lo_door.passage = { "lo_door_passage", "lo_door_psg2" }
ha.lo_door.use_pnt_x = 7.1040101
ha.lo_door.use_pnt_y = 2.3378401
ha.lo_door.use_pnt_z = 0
ha.lo_door.use_rot_x = 0
ha.lo_door.use_rot_y = 1.5
ha.lo_door.use_rot_z = 0
ha.lo_door.out_pnt_x = 7.08074
ha.lo_door.out_pnt_y = 3.2
ha.lo_door.out_pnt_z = 0
ha.lo_door.out_rot_x = 0
ha.lo_door.out_rot_y = 1.5
ha.lo_door.out_rot_z = 0
ha.lo_door.lookAt = function(arg1) -- line 803
    manny:say_line("/hama164/")
end
ha.lo_door.open = function(arg1) -- line 807
    if not arg1:is_open() then
        arg1.interest_actor:wait_for_chore(ha_elvos_elev_door_door_close)
        arg1.interest_actor:stop_chore()
        arg1:play_chore(ha_elvos_elev_door_door_open)
        arg1:wait_for_chore()
        Object.open(arg1)
    end
    return TRUE
end
ha.lo_door.close = function(arg1) -- line 819
    if arg1:is_open() then
        Object.close(arg1)
        arg1.interest_actor:wait_for_chore(ha_elvos_elev_door_door_open)
        arg1.interest_actor:stop_chore()
        arg1:play_chore(ha_elvos_elev_door_door_close)
        arg1:wait_for_chore()
    end
    return TRUE
end
ha.lo_door.walkOut = function(arg1) -- line 831
    stop_script(ha.elevator_door_timer)
    START_CUT_SCENE()
    manny:clear_hands()
    if ha.lo_door.interest_actor:is_choring() then
        ha.lo_door.interest_actor:wait_for_chore()
    end
    manny:walkto(ha.lo_door.out_pnt_x, ha.lo_door.out_pnt_y, ha.lo_door.out_pnt_z, ha.lo_door.out_rot_x, ha.lo_door.out_rot_y + 180, ha.lo_door.out_rot_z)
    ha.lo_door:close()
    END_CUT_SCENE()
    lo:switch_to_set()
    manny:put_in_set(lo)
    manny:setpos(lo.ha_door.out_pnt_x, lo.ha_door.out_pnt_y, lo.ha_door.out_pnt_z)
    manny:setrot(lo.ha_door.out_rot_x, lo.ha_door.out_rot_y + 180, lo.ha_door.out_rot_z)
    lo:elev_walk_out()
end
ha.lo_door.use = function(arg1) -- line 850
    START_CUT_SCENE()
    if not arg1:is_open() then
        arg1:open()
    end
    arg1:walkOut()
    END_CUT_SCENE()
end
ha.lo_door_trigger = { }
ha.lo_door_trigger.walkOut = function(arg1) -- line 864
    local local1
    if ha.lo_door.interest_actor:is_choring() then
        ha.lo_door.interest_actor:wait_for_chore()
    end
    ha.lo_door:open()
    local1 = start_script(ha.elevator_door_timer, ha.lo_door)
    while manny:find_sector_name("lo_door_trigger") do
        break_here()
    end
    while manny:find_sector_name("lo_crushed") do
        break_here()
    end
    stop_script(local1)
    if manny:find_sector_name("lo_door") then
        single_start_script(ha.lo_door.walkOut)
        return nil
    elseif ha.lo_door.interest_actor:is_choring() then
        ha.lo_door.interest_actor:wait_for_chore()
    end
    ha.lo_door:close()
end

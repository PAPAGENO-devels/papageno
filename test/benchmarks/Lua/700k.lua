CheckFirstTime("tu.lua")
dofile("ma_operate_bolt.lua")
dofile("brennis_fix_idle.lua")
dofile("brennis_on_fire.lua")
dofile("tu_fans.lua")
dofile("tu_switcher_door.lua")
dofile("tu_deadbolt.lua")
dofile("tu_switcher.lua")
dofile("tu_canister.lua")
dofile("tu_fire.lua")
dofile("ma_tube_action.lua")
tu = Set:create("tu.set", "Tube Room", { tu_dorcu = 0, tu_dorcu2 = 0, tu_redcu = 1, tu_swiha = 2, tu_swiha2 = 2, tu_swiha3 = 2, tu_tubws = 3, tu_tubws2 = 3, tu_swicu = 4, overhead = 5, tu_swopn = 6 })
tu.shrinkable = 0.029
tu.chem_state = "no chem"
tu.door_state = "closed"
tu.fan_volume = 30
tu.switcher_volume = 40
tu.set_up_switcher_door = function(arg1) -- line 32
    local local1
    local1 = tu.switcher_door.hObjectState
    tu.switcher_door.interest_actor:put_in_set(tu)
    tu.switcher_door:complete_chore(tu_switcher_door_gone, "tu_switcher_door.cos")
    ForceRefresh()
    if tu.door_state == "open" then
        tu.switcher_door.hObjectState = tu:add_object_state(tu_dorcu, "TU_0_DORCU_door_open.bm", "tu_dor_door_open.zbm", OBJSTATE_STATE)
        tu.switcher_door:complete_chore(tu_switcher_door_open, "tu_switcher_door.cos")
    elseif tu.door_state == "closed" then
        tu.switcher_door.hObjectState = tu:add_object_state(tu_dorcu, "TU_0_DORCU_door_close.bm", "tu_dor_door_close.zbm", OBJSTATE_STATE)
        tu.switcher_door:complete_chore(tu_switcher_door_closed, "tu_switcher_door.cos")
    else
        tu.switcher_door.hObjectState = tu:add_object_state(tu_dorcu, "TU_0_DORCU_door_ajar.bm", "TU_0_DORCU_door_ajar.zbm", OBJSTATE_STATE)
        tu.switcher_door:complete_chore(tu_switcher_door_ajar, "tu_switcher_door.cos")
    end
    SendObjectToBack(tu.switcher_door.hObjectState)
    if local1 then
        FreeObjectState(local1)
    end
    SendObjectToFront(tu.open_bolt.hObjectState)
end
tu.set_up_actors = function(arg1) -- line 57
    if tu.chem_state == "both chem" then
        brennis:default()
        brennis:put_in_set(tu)
        brennis:setpos(0.27442, -0.4735, 0)
        brennis:setrot(0, 31.834, 0)
        brennis:set_mumble_chore(brennis_fix_idle_mumble)
        brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
        brennis:set_talk_chore(2, brennis_fix_idle_a)
        brennis:set_talk_chore(3, brennis_fix_idle_c)
        brennis:set_talk_chore(4, brennis_fix_idle_e)
        brennis:set_talk_chore(5, brennis_fix_idle_f)
        brennis:set_talk_chore(6, brennis_fix_idle_l)
        brennis:set_talk_chore(7, brennis_fix_idle_m)
        brennis:set_talk_chore(8, brennis_fix_idle_o)
        brennis:set_talk_chore(9, brennis_fix_idle_t)
        brennis:set_talk_chore(10, brennis_fix_idle_u)
        single_start_script(brennis.idle, brennis)
        if not brennis.burnt then
            preload_sfx("brSpark.WAV")
            preload_sfx("brExplo.WAV")
            preload_sfx("brFire.IMU")
        end
    else
        brennis:put_in_set(nil)
    end
    tu.extinguisher:set_object_state("extinguisher.cos")
    if tu.extinguisher.touchable then
        tu.extinguisher.interest_actor:play_chore(0)
    else
        tu.extinguisher.interest_actor:play_chore(1)
    end
end
tu.set_up_states = function(arg1) -- line 96
    if tu.chem_state == "both chem" then
        MakeSectorActive("switcher_box1", FALSE)
        MakeSectorActive("switcher_box2", FALSE)
        MakeSectorActive("switcher_box3", FALSE)
        tu.door_wheel:make_untouchable()
        tu.closed_bolt:make_untouchable()
        tu.open_bolt:make_touchable()
        tu.open_wheel:make_touchable()
        tu.brennis_obj:make_touchable()
        tu.door_state = "open"
    else
        tu.brennis_obj:make_untouchable()
        if tu.door_state == "open" then
            MakeSectorActive("switcher_box1", TRUE)
            MakeSectorActive("switcher_box2", TRUE)
            MakeSectorActive("switcher_box3", TRUE)
            tu.door_wheel:make_untouchable()
            tu.closed_bolt:make_untouchable()
            tu.open_bolt:make_touchable()
            tu.open_wheel:make_touchable()
        else
            MakeSectorActive("switcher_box1", NIL)
            MakeSectorActive("switcher_box2", NIL)
            MakeSectorActive("switcher_box3", NIL)
            tu.door_wheel:make_touchable()
            tu.closed_bolt:make_touchable()
            tu.open_bolt:make_untouchable()
            tu.open_wheel:make_untouchable()
        end
    end
    tu.fans:make_untouchable()
    tu.fans.interest_actor:stop_chore()
    if tu.chem_state == "both chem" then
        tu.fans.interest_actor:play_chore(tu_fans_static, "tu_fans.cos")
    else
        if tu.door_state == "open" then
            tu.fans.interest_actor:play_chore_looping(tu_fans_spin_door_open, "tu_fans.cos")
        else
            tu.fans.interest_actor:play_chore_looping(tu_fans_spin, "tu_fans.cos")
        end
        single_start_sfx("tuFanLp.IMU", nil, tu.fan_volume)
    end
    tu.switcher.interest_actor:stop_chore()
    if tu.chem_state == "both chem" then
        stop_sound("tuSwtch.IMU")
        if tu.door_state == "open" then
            tu.switcher.interest_actor:play_chore(tu_switcher_still_door_open, "tu_switcher.cos")
        else
            tu.switcher.interest_actor:play_chore(tu_switcher_still, "tu_switcher.cos")
        end
    else
        if tu.door_state == "open" then
            tu.switcher.interest_actor:play_chore_looping(tu_switcher_switch_door_open, "tu_switcher.cos")
        else
            tu.switcher.interest_actor:play_chore_looping(tu_switcher_switch, "tu_switcher.cos")
        end
        single_start_sfx("tuSwtch.IMU", nil, tu.switcher_volume)
    end
    tu.switcher_door:set_object_state("tu_switcher_door.cos")
    tu.switcher_door.hObjectState = nil
    tu:set_up_switcher_door()
    if tu.door_state == "open" then
        MakeSectorActive("open_box_1", TRUE)
        MakeSectorActive("open_box_2", TRUE)
        MakeSectorActive("open_box_23", TRUE)
        MakeSectorActive("open_box_3", TRUE)
        MakeSectorActive("open_box_4", TRUE)
        MakeSectorActive("closed_box_11", FALSE)
        MakeSectorActive("closed_box_112", FALSE)
        MakeSectorActive("closed_box_1", FALSE)
        MakeSectorActive("closed_box_2", FALSE)
        MakeSectorActive("closed_box_3", FALSE)
    else
        MakeSectorActive("open_box_1", FALSE)
        MakeSectorActive("open_box_2", FALSE)
        MakeSectorActive("open_box_3", FALSE)
        MakeSectorActive("open_box_4", FALSE)
        MakeSectorActive("closed_box_1", TRUE)
        MakeSectorActive("closed_box_2", TRUE)
        MakeSectorActive("closed_box_3", TRUE)
    end
    if tu.door_state == "open" then
        if tu.open_bolt:is_locked() then
            tu.open_bolt:play_chore(tu_deadbolt_here)
        else
            tu.open_bolt:play_chore(tu_deadbolt_here_unlocked)
        end
    end
end
tu.set_up_object_states = function(arg1) -- line 202
    tu:add_object_state(tu_dorcu, "tu_door_fan1.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_dorcu, "tu_door_fan2.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_tubws, "tu_fan_test.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_tubws, "tu_floor_fans1.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_tubws, "tu_floor_fans2.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_swopn, "tu_swi_fans.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_swopn, "tu_swi_fans2.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_swiha, "tu_swi_fans.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_swiha, "tu_swi_fans2.bm", nil, OBJSTATE_UNDERLAY)
    tu.fans:set_object_state("tu_fans.cos")
    tu:add_object_state(tu_tubws, "tu_tub_switcher.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_dorcu, "tu_dor_switcher.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_dorcu, "tu_dor_switcher_dopen.bm", nil, OBJSTATE_UNDERLAY)
    tu.switcher:set_object_state("tu_switcher.cos")
    tu.open_bolt.hObjectState = tu:add_object_state(tu_dorcu, "tu_turn_bolt.bm", "tu_turn_bolt.zbm", OBJSTATE_STATE)
    tu.open_bolt:set_object_state("tu_deadbolt.cos")
    tu:add_object_state(tu_tubws, "tu_3_bolt.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_redcu, "tu_can_go.bm", nil, OBJSTATE_UNDERLAY)
    tu:add_object_state(tu_redcu, "tu_can_stop.bm", nil, OBJSTATE_UNDERLAY)
    tu.red_tube:set_object_state("tu_canister.cos")
    tu:add_object_state(tu_tubws, "TU_3_TUBWS_doropn.bm", nil, OBJSTATE_UNDERLAY)
    if not brennis.burnt then
        LoadCostume("brennis_on_fire.cos")
    end
end
tu.send_balloon = function(arg1, arg2) -- line 240
    local local1 = arg2.chem
    START_CUT_SCENE()
    ExpireText()
    arg2.source_balloon.owner = clown
    arg2:free()
    arg2.owner = pk
    cur_puzzle_state[4] = TRUE
    tu.closed_bolt:unlock()
    tu.open_bolt:unlock()
    brennis.seen_working_this_time = FALSE
    eva.talked_server = FALSE
    set_override(tu.skip_send_balloon, tu)
    ImSetState(STATE_NULL)
    break_here()
    if not tu.sent_balloon then
        tu.sent_balloon = TRUE
    end
    stop_sound("tuSwtch.IMU")
    if tu.chem_state == "no chem" then
        if local1 == 1 then
            tu.chem_state = "chem 1"
            RunFullscreenMovie("swtchuns.snm")
        else
            tu.chem_state = "chem 2"
            RunFullscreenMovie("swtchuns.snm")
        end
    elseif tu.chem_state == "chem 1" then
        if local1 == 1 then
            RunFullscreenMovie("swtchuns.snm")
        else
            tu.chem_state = "both chem"
            RunFullscreenMovie("swtchsuc.snm")
        end
    elseif tu.chem_state == "chem 2" then
        if local1 == 1 then
            tu.chem_state = "both chem"
            RunFullscreenMovie("swtchsuc.snm")
        else
            RunFullscreenMovie("swtchuns.snm")
        end
    elseif tu.chem_state == "both chem" then
    end
    wait_for_message()
    sleep_for(500)
    stop_sound("tuSwtch.IMU")
    ImSetState(stateMO)
    if tu.chem_state == "both chem" then
        start_sfx("tusqueal.IMU")
        sleep_for(1500)
        if not tu.ever_jammed then
            tu.ever_jammed = TRUE
            manny:say_line("/tuma048/")
        else
            manny:say_line("/tuma049/")
        end
        manny:wait_for_message()
        fade_sfx("tusqueal.IMU", 1500)
    end
    END_CUT_SCENE()
end
tu.skip_send_balloon = function(arg1) -- line 322
    kill_override()
    stop_sound("tusqueal.IMU")
    tu.ever_jammed = TRUE
end
tu.send_bread = function(arg1, arg2) -- line 329
    START_CUT_SCENE()
    ExpireText()
    tu.closed_bolt:unlock()
    tu.open_bolt:unlock()
    brennis.seen_working_this_time = FALSE
    eva.talked_server = FALSE
    ImSetState(STATE_NULL)
    break_here()
    stop_sound("tuSwtch.IMU")
    RunFullscreenMovie("swtchbrd.snm")
    wait_for_message()
    sleep_for(500)
    stop_sound("tuSwtch.IMU")
    ImSetState(stateMO)
    END_CUT_SCENE()
end
tu.send_canister_through = function(arg1) -- line 360
    sleep_for(rndint(150, 1000))
    start_sfx("tubCnPas.WAV")
    sleep_for(100)
    tu.red_tube:play_chore(tu_canister_pass_through)
end
brennis.burn = function(arg1, arg2) -- line 367
    local local1, local2, local3
    brennis.burnt = TRUE
    START_CUT_SCENE()
    cameraman_disabled = TRUE
    stop_script(brennis.idle)
    stop_script(brennis.stop_idle)
    if not arg2 then
        tu:add_object_state(tu_swopn, "tu_sparks.bm", nil, OBJSTATE_OVERLAY, TRUE)
        tu.flames:set_object_state("tu_fire.cos")
        tu:current_setup(tu_swopn)
        brennis:set_costume("brennis_on_fire.cos")
        brennis:set_mumble_chore(brennis_on_fire_mumble)
        brennis:set_talk_chore(1, brennis_on_fire_stop_talk)
        brennis:set_talk_chore(2, brennis_on_fire_a)
        brennis:set_talk_chore(3, brennis_on_fire_c)
        brennis:set_talk_chore(4, brennis_on_fire_e)
        brennis:set_talk_chore(5, brennis_on_fire_f)
        brennis:set_talk_chore(6, brennis_on_fire_l)
        brennis:set_talk_chore(7, brennis_on_fire_m)
        brennis:set_talk_chore(8, brennis_on_fire_o)
        brennis:set_talk_chore(9, brennis_on_fire_t)
        brennis:set_talk_chore(10, brennis_on_fire_u)
        brennis:play_chore(brennis_on_fire_on_fire, "brennis_on_fire.cos")
        brennis:wait_for_chore(brennis_on_fire_on_fire, "brennis_on_fire.cos")
    else
        brennis:stop_chore()
        brennis:set_costume("brennis_on_fire.cos")
        brennis:set_mumble_chore(brennis_on_fire_mumble)
        brennis:set_talk_chore(1, brennis_on_fire_stop_talk)
        brennis:set_talk_chore(2, brennis_on_fire_a)
        brennis:set_talk_chore(3, brennis_on_fire_c)
        brennis:set_talk_chore(4, brennis_on_fire_e)
        brennis:set_talk_chore(5, brennis_on_fire_f)
        brennis:set_talk_chore(6, brennis_on_fire_l)
        brennis:set_talk_chore(7, brennis_on_fire_m)
        brennis:set_talk_chore(8, brennis_on_fire_o)
        brennis:set_talk_chore(9, brennis_on_fire_t)
        brennis:set_talk_chore(10, brennis_on_fire_u)
        brennis:say_line("/tubs050/")
        manny:face_entity(tu.brennis_obj)
    end
    brennis:play_chore(brennis_on_fire_pat_flames, "brennis_on_fire.cos")
    start_sfx("brSpark.WAV")
    tu.flames:play_chore(tu_fire_sparks, "tu_fire.cos")
    sleep_for(200)
    start_sfx("brExplo.WAV")
    tu.flames.interest_actor:wait_for_chore(tu_fire_sparks, "tu_fire.cos")
    if not arg2 then
        brennis:say_line("/tubs050/")
    end
    sleep_for(150)
    start_sfx("brFire.IMU")
    brennis:wait_for_message()
    fade_sfx("brFire.IMU", 1500)
    if bd.extinguisher.owner ~= manny then
        tu:current_setup(tu_tubws)
        if not arg2 then
            manny:setpos(1.44547, -0.40514901, 0)
            manny:setrot(0, 32.306999, 0)
            manny:head_look_at(nil)
        end
        manny:runto(tu.extinguisher.use_pnt_x, tu.extinguisher.use_pnt_y, tu.extinguisher.use_pnt_z, tu.extinguisher.use_rot_x, tu.extinguisher.use_rot_y, tu.extinguisher.use_rot_z)
        manny:wait_for_actor()
        manny:set_time_scale(3)
        start_sfx("tuGetExt.wav")
        tu.extinguisher:pickUp()
        manny:set_time_scale(1)
        start_script(manny.runto, manny, 1.44547, -0.40514901, 0)
        sleep_for(1000)
        tu:current_setup(tu_dorcu)
        manny:put_at_object(tu.brennis_obj)
        manny:set_run(FALSE)
    else
        tu:current_setup(0)
        if proximity(manny.hActor, tu.brennis_obj.use_pnt_x, tu.brennis_obj.use_pnt_y, tu.brennis_obj.use_pnt_z) > 0.1 then
            manny:runto(tu.brennis_obj.use_pnt_x, tu.brennis_obj.use_pnt_y, tu.brennis_obj.use_pnt_z)
            manny:wait_for_actor()
        else
            manny:put_at_object(tu.brennis_obj)
            sleep_for(400)
        end
        manny:head_look_at(nil)
        if manny.is_holding ~= bd.extinguisher then
            manny:setrot(0, 172.51601, 0, TRUE)
            manny:pull_out_item(bd.extinguisher)
        end
        manny:setrot(tu.brennis_obj.use_rot_x, tu.brennis_obj.use_rot_y, tu.brennis_obj.use_rot_z, TRUE)
    end
    brennis:play_chore(brennis_on_fire_stop_manny, "brennis_on_fire.cos")
    brennis:say_line("/tubs051/")
    brennis:wait_for_message()
    brennis:say_line("/tubs052/")
    brennis:wait_for_message()
    brennis:say_line("/tubs053/")
    brennis:wait_for_message()
    local1, local2, local3 = GetActorNodeLocation(system.currentActor.hActor, 12)
    manny:head_look_at_point(local1, local2, local3)
    brennis:say_line("/tubs054/")
    brennis:wait_for_message()
    manny:head_look_at(nil)
    manny:say_line("/tuma055/")
    manny:wait_for_message()
    brennis:say_line("/tubs056/")
    sleep_for(500)
    brennis:play_chore(brennis_on_fire_turn_around, "brennis_on_fire.cos")
    brennis:wait_for_message()
    manny:stop_chore(ms_hold, "ms.cos")
    manny:play_chore(ms_putback_big, "ms.cos")
    manny:wait_for_chore(ms_putback_big, "ms.cos")
    manny:stop_chore(ms_putback_big, "ms.cos")
    manny:stop_chore(ms_activate_extinguisher, "ms.cos")
    manny:play_chore(ms_putback_done, "ms.cos")
    manny:wait_for_chore(ms_putback_done, "ms.cos")
    manny:stop_chore(ms_putback_done, "ms.cos")
    manny.is_holding = nil
    brennis:wait_for_chore(brennis_on_fire_turn_around, "brennis_on_fire.cos")
    brennis:set_costume("brennis_fix_idle.cos")
    brennis:set_mumble_chore(brennis_fix_idle_mumble)
    brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
    brennis:set_talk_chore(2, brennis_fix_idle_a)
    brennis:set_talk_chore(3, brennis_fix_idle_c)
    brennis:set_talk_chore(4, brennis_fix_idle_e)
    brennis:set_talk_chore(5, brennis_fix_idle_f)
    brennis:set_talk_chore(6, brennis_fix_idle_l)
    brennis:set_talk_chore(7, brennis_fix_idle_m)
    brennis:set_talk_chore(8, brennis_fix_idle_o)
    brennis:set_talk_chore(9, brennis_fix_idle_t)
    brennis:set_talk_chore(10, brennis_fix_idle_u)
    tu:current_setup(tu_dorcu)
    cameraman_disabled = FALSE
    END_CUT_SCENE()
    start_script(brennis.idle, brennis)
end
brennis.leave = function(arg1) -- line 528
    START_CUT_SCENE()
    tu.chem_state = "no chem"
    tu:current_setup(tu_dorcu)
    brennis:stop_idle()
    tu:current_setup(tu_redcu)
    manny:set_visibility(FALSE)
    brennis:set_costume("br_grab_card.cos")
    brennis:setpos(0, 0, 0)
    brennis:setrot(0, 180, 0)
    brennis:play_chore(0, "br_grab_card.cos")
    brennis:wait_for_chore(0, "br_grab_card.cos")
    tu:current_setup(tu_dorcu)
    tu.switcher.interest_actor:play_chore(tu_switcher_still, "tu_switcher.cos")
    brennis:set_costume(nil)
    brennis:default()
    brennis:put_in_set(tu)
    brennis:setpos(0.27442, -0.4735, 0)
    brennis:setrot(0, 31.834, 0)
    brennis:set_mumble_chore(brennis_fix_idle_mumble)
    brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
    brennis:set_talk_chore(2, brennis_fix_idle_a)
    brennis:set_talk_chore(3, brennis_fix_idle_c)
    brennis:set_talk_chore(4, brennis_fix_idle_e)
    brennis:set_talk_chore(5, brennis_fix_idle_f)
    brennis:set_talk_chore(6, brennis_fix_idle_l)
    brennis:set_talk_chore(7, brennis_fix_idle_m)
    brennis:set_talk_chore(8, brennis_fix_idle_o)
    brennis:set_talk_chore(9, brennis_fix_idle_t)
    brennis:set_talk_chore(10, brennis_fix_idle_u)
    brennis:play_chore(brennis_fix_idle_exit_tube_room, "brennis_fix_idle.cos")
    sleep_for(300)
    start_sfx("tuFanOn.WAV", nil, 90)
    tu.fans.interest_actor:play_chore_looping(tu_fans_spin_door_open, "tu_fans.cos")
    wait_for_sound("tuFanOn.WAV")
    single_start_sfx("tuFanLp.IMU", nil, tu.fan_volume)
    single_start_sfx("tuSwtch.IMU", nil, tu.switcher_volume)
    brennis:say_line("/tubs057/")
    sleep_for(5000)
    if tu.open_bolt:is_locked() then
        tu.door_state = "ajar"
        tu:set_up_switcher_door()
        play_movie("tu_db.snm", 2, 16)
        wait_for_movie()
    else
        tu.door_state = "closed"
        tu:set_up_switcher_door()
        play_movie("tu_dwb.snm", 66, 16)
        wait_for_movie()
    end
    if tu.open_bolt:is_locked() then
        tu.switcher_door:play_chore(tu_switcher_door_ajar)
    else
        tu.switcher_door:play_chore(tu_switcher_door_closed)
    end
    tu.switcher.interest_actor:play_chore_looping(tu_switcher_switch, "tu_switcher.cos")
    brennis:wait_for_message()
    brennis:wait_for_chore(brennis_fix_idle_exit_tube_room, "brennis_fix_idle.cos")
    manny:set_visibility(TRUE)
    END_CUT_SCENE()
    tu:set_up_states()
end
brennis.idle = function(arg1) -- line 605
    arg1.turned_to_talk = FALSE
    while TRUE do
        arg1.is_scratching = FALSE
        arg1:play_chore(brennis_fix_idle_fix_idle, "brennis_fix_idle.cos")
        arg1:wait_for_chore(brennis_fix_idle_fix_idle, "brennis_fix_idle.cos")
        if rnd(8) then
            arg1.is_scratching = TRUE
            arg1:play_chore(brennis_fix_idle_buttscratch, "brennis_fix_idle.cos")
            arg1:wait_for_chore(brennis_fix_idle_buttscratch, "brennis_fix_idle.cos")
        end
    end
end
brennis.stop_idle = function(arg1) -- line 619
    if find_script(brennis.stop_talking) then
        wait_for_script(brennis.stop_talking)
    end
    stop_script(arg1.idle)
    arg1:wait_for_chore()
end
brennis.start_talking = function(arg1) -- line 627
    if not arg1.turned_to_talk then
        arg1:stop_idle()
        arg1:play_chore(brennis_fix_idle_to_talk, "brennis_fix_idle.cos")
        arg1:wait_for_chore(brennis_fix_idle_to_talk, "brennis_fix_idle.cos")
        arg1:play_chore_looping(brennis_fix_idle_talk_hold, "brennis_fix_idle.cos")
        arg1.turned_to_talk = TRUE
    end
end
brennis.stop_talking = function(arg1) -- line 637
    if arg1.turned_to_talk then
        arg1:stop_chore(brennis_fix_idle_talk_hold, "brennis_fix_idle.cos")
        arg1:play_chore(brennis_fix_idle_back_to_fix_idle, "brennis_fix_idle.cos")
        arg1:wait_for_chore(brennis_fix_idle_back_to_fix_idle, "brennis_fix_idle.cos")
        arg1.turned_to_talk = FALSE
        single_start_script(arg1.idle, arg1)
    end
end
tu.enter = function(arg1) -- line 654
    tu.burn_box.triggered = FALSE
    tu.switcher_door:make_untouchable()
    tu.fans:make_untouchable()
    tu.flames:make_untouchable()
    tu:set_up_object_states()
    tu:set_up_actors()
    tu:set_up_states()
    tu:camerachange(nil, tu:current_setup())
    LoadCostume("ma_operate_bolt.cos")
    LoadCostume("ma_wheel_stuck.cos")
    LoadCostume("ma_tube_action.cos")
    LoadCostume("brennis_fix_idle.cos")
end
tu.exit = function(arg1) -- line 672
    stop_script(brennis.idle)
    stop_script(brennis.stop_idle)
    brennis:free()
    stop_sound("tuFanLp.IMU")
    stop_sound("tuFanOn.WAV")
    stop_sound("tuFanOff.WAV")
    stop_sound("tubAirNb.IMU")
    stop_sound("tubAirPb.IMU")
    stop_sound("tubAirFb.IMU")
    stop_sound("tubCnVib.IMU")
    stop_sound("tuSwtch.IMU")
end
tu.camerachange = function(arg1, arg2, arg3) -- line 686
    tu.switcher:make_touchable()
    tu.red_tube:make_touchable()
    if arg3 == tu_dorcu then
        tu.switcher:make_untouchable()
        brennis.seen_working_this_time = TRUE
    elseif arg3 == tu_redcu then
        tu.switcher:make_untouchable()
    elseif arg3 == tu_swiha or arg3 == tu_swopn then
        tu.switcher:inside_use_point()
    elseif arg3 == tu_tubws then
        tu.switcher:side_use_point()
    elseif arg3 == tu_swicu then
        tu.switcher:inside_use_point()
        tu.red_tube:make_untouchable()
    end
    if arg3 == tu_redcu and tu.chem_state ~= "both chem" then
        single_start_sfx("tubAirNb.IMU")
    else
        stop_sound("tubAirNb.IMU")
    end
    if arg3 == tu_dorcu then
        if tu.open_bolt.locked and tu.door_state == "open" then
            tu.open_bolt:play_chore(tu_deadbolt_here)
        end
    end
end
tu.cameraman = function(arg1) -- line 720
    local local1, local2
    local local3
    local local4
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead then
        local4 = system.currentActor:find_sector_name(tostring(cameraman_box_name))
        if not local4 or arg1 ~= cameraman_watching_set then
            arg1.cameraChange = TRUE
            cameraman_watching_set = arg1
            local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
            local3 = arg1.setups[tostring(cameraman_box_name)]
            if local3 == tu_swiha and tu.door_state == "open" then
                local3 = tu_swopn
            end
            arg1:current_setup(local3)
        else
            arg1.cameraChange = FALSE
        end
    end
end
tu.update_music_state = function(arg1) -- line 747
    if tu.chem_state == "both chem" then
        return stateTU_BRENNIS
    else
        return stateTU
    end
end
tu.manny_lock_deadbolt = function(arg1, arg2) -- line 755
    manny:push_costume("ma_operate_bolt.cos")
    if arg2 then
        tu.open_bolt:play_chore(tu_deadbolt_here_unlocked)
        manny:play_chore(ma_operate_bolt_lock_bolt, "ma_operate_bolt.cos")
        sleep_for(533)
        tu.open_bolt:play_chore(tu_deadbolt_lock, "tu_deadbolt.cos")
    else
        tu.open_bolt:play_chore(tu_deadbolt_here)
        manny:play_chore(ma_operate_bolt_unlock_bolt, "ma_operate_bolt.cos")
        sleep_for(533)
        tu.open_bolt:play_chore(tu_deadbolt_unlock, "tu_deadbolt.cos")
    end
    manny:wait_for_chore()
    manny:pop_costume()
end
tu.door_wheel = Object:create(tu, "/tutx058/wheel", 0.61358398, -0.835706, 0.31, { range = 0.5 })
tu.door_wheel.use_pnt_x = 0.80013198
tu.door_wheel.use_pnt_y = -0.93841499
tu.door_wheel.use_pnt_z = 0
tu.door_wheel.use_rot_x = 0
tu.door_wheel.use_rot_y = 52.717899
tu.door_wheel.use_rot_z = 0
tu.door_wheel.lookAt = function(arg1) -- line 788
    manny:say_line("/tuma059/")
end
tu.door_wheel.use = function(arg1) -- line 792
    local local1
    if tu.door_state == "ajar" then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:push_costume("ma_wheel_stuck.cos")
        manny:play_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
        manny:wait_for_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
        manny:set_walk_chore(ms_back_off, manny.base_costume)
        manny:set_walk_rate(-0.11)
        play_movie("tu_dob.snm", 2, 16)
        local1 = 0
        while local1 < 1300 do
            WalkActorForward(manny.hActor)
            break_here()
            local1 = local1 + system.frameTime
        end
        StopMovie()
        manny:set_walk_backwards(FALSE)
        manny:stop_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
        manny:pop_costume()
        tu.door_state = "open"
        tu.open_bolt.locked = TRUE
        FreeObjectState(tu.switcher_door.hObjectState)
        tu.switcher_door.hObjectState = nil
        tu:set_up_states()
        SendObjectToFront(tu.open_bolt.hObjectState)
        tu.open_bolt:complete_chore(tu_deadbolt_here, "tu_deadbolt.cos")
        tu:current_setup(tu_swopn)
        manny:setpos(0.97562599, -1.18225, 0)
        manny:setrot(0, 358.32401, 0)
        manny:head_look_at(nil)
        sleep_for(500)
        manny:walkto(0.44540301, -0.66003799, 0, 0, 46.101501, 0)
        manny:wait_for_actor()
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:push_costume("ma_wheel_stuck.cos")
        manny:play_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
        manny:wait_for_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
        manny:play_chore(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
        manny:play_sound_at("valvtwst.wav")
        manny:wait_for_chore(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
        manny:play_chore(ma_wheel_stuck_hand_off_tu, "ma_wheel_stuck.cos")
        manny:wait_for_chore(ma_wheel_stuck_hand_off_tu, "ma_wheel_stuck.cos")
        manny:pop_costume()
        manny:say_line("/tuma060/")
        manny:wait_for_message()
        if not tu.closed_bolt:is_locked() then
            manny:say_line("/tuma061/")
        end
        END_CUT_SCENE()
    end
end
tu.closed_bolt = Object:create(tu, "/tutx062/deadbolt", 0.473584, -0.955706, 0.36000001, { range = 0.5 })
tu.closed_bolt.use_pnt_x = 0.62627202
tu.closed_bolt.use_pnt_y = -1.05899
tu.closed_bolt.use_pnt_z = 0
tu.closed_bolt.use_rot_x = 0
tu.closed_bolt.use_rot_y = 90.141098
tu.closed_bolt.use_rot_z = 0
tu.closed_bolt.lookAt = function(arg1) -- line 865
    if arg1:is_locked() then
        manny:say_line("/tuma063/")
    else
        manny:say_line("/tuma064/")
    end
end
tu.closed_bolt.use = function(arg1) -- line 874
    if tu.door_state == "ajar" then
        manny:say_line("/tuma065/")
    else
        system.default_response("with what")
    end
end
tu.closed_bolt:lock()
tu.open_bolt = Object:create(tu, "/tutx067/dead bolt", 1.05984, -0.93449301, 0.38, { range = 0.5 })
tu.open_bolt.use_pnt_x = 0.84163702
tu.open_bolt.use_pnt_y = -1.0251
tu.open_bolt.use_pnt_z = 0
tu.open_bolt.use_rot_x = 0
tu.open_bolt.use_rot_y = 327.87601
tu.open_bolt.use_rot_z = 0
tu.open_bolt.lookAt = function(arg1) -- line 893
    tu.closed_bolt.lookAt(arg1)
end
tu.open_bolt.use = function(arg1) -- line 897
    if arg1:is_locked() then
        START_CUT_SCENE()
        cur_puzzle_state[5] = FALSE
        manny:walkto_object(arg1)
        arg1:unlock()
        tu.closed_bolt:unlock()
        tu:manny_lock_deadbolt(FALSE)
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        cur_puzzle_state[5] = TRUE
        manny:walkto_object(arg1)
        arg1:lock()
        tu.closed_bolt:lock()
        tu:manny_lock_deadbolt(TRUE)
        if not arg1.ever_locked then
            arg1.ever_locked = TRUE
            manny:say_line("/tuma068/")
            wait_for_message()
            manny:say_line("/tuma069/")
        end
        END_CUT_SCENE()
    end
end
tu.open_bolt:unlock()
tu.open_bolt.make_untouchable = function(arg1) -- line 925
    arg1:play_chore(tu_deadbolt_gone, "tu_deadbolt.cos")
    Object.make_untouchable(arg1)
end
tu.open_bolt.make_touchable = function(arg1) -- line 931
    if arg1:is_locked() then
        arg1:play_chore(tu_deadbolt_here_unlocked, "tu_deadbolt.cos")
    else
        arg1:play_chore(tu_deadbolt_here, "tu_deadbolt.cos")
    end
    Object.make_touchable(arg1)
end
tu.open_wheel = Object:create(tu, "/tutx070/wheel", 0.83358401, -0.77570599, 0.23999999, { range = 0.5 })
tu.open_wheel.use_pnt_x = 0.80046499
tu.open_wheel.use_pnt_y = -1.03627
tu.open_wheel.use_pnt_z = 0
tu.open_wheel.use_rot_x = 0
tu.open_wheel.use_rot_y = 325.18799
tu.open_wheel.use_rot_z = 0
tu.open_wheel.lookAt = function(arg1) -- line 952
    manny:say_line("/tuma071/")
end
tu.open_wheel.use = function(arg1) -- line 956
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:push_costume("ma_wheel_stuck.cos")
    manny:play_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
    manny:wait_for_chore(ma_wheel_stuck_hand_on_tu, "ma_wheel_stuck.cos")
    manny:play_chore(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
    manny:play_sound_at("valvtwst.wav")
    manny:wait_for_chore(ma_wheel_stuck_turn_tu, "ma_wheel_stuck.cos")
    manny:play_chore(ma_wheel_stuck_hand_off_tu, "ma_wheel_stuck.cos")
    manny:wait_for_chore(ma_wheel_stuck_hand_off_tu, "ma_wheel_stuck.cos")
    manny:pop_costume()
    manny:say_line("/tuma072/")
    END_CUT_SCENE()
end
tu.brennis_obj = Object:create(tu, "/tutx073/repairman", 0.39063501, -0.48363599, 0.40000001, { range = 0.89999998 })
tu.brennis_obj.use_pnt_x = 0.71560103
tu.brennis_obj.use_pnt_y = -0.89723903
tu.brennis_obj.use_pnt_z = 0
tu.brennis_obj.use_rot_x = 0
tu.brennis_obj.use_rot_y = 56.1894
tu.brennis_obj.use_rot_z = 0
tu.brennis_obj.lookAt = function(arg1) -- line 982
    manny:say_line("/tuma074/")
end
tu.brennis_obj.use = function(arg1) -- line 986
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if br1 then
        br1:init()
    else
        result = dofile("dlg_brennis.lua")
        if not result then
            br1:init()
        else
            brennis:leave()
        end
    end
end
tu.red_tube = Object:create(tu, "/tutx075/red tube", 0.64748901, -0.162466, 0.36000001, { range = 0.80000001 })
tu.red_tube.use_pnt_x = 0.55390501
tu.red_tube.use_pnt_y = -0.298289
tu.red_tube.use_pnt_z = 0
tu.red_tube.use_rot_x = 0
tu.red_tube.use_rot_y = 4.2853999
tu.red_tube.use_rot_z = 0
tu.red_tube.closeup_use_pnt_x = 0.55000001
tu.red_tube.closeup_use_pnt_y = -0.29300001
tu.red_tube.closeup_use_pnt_z = 0
tu.red_tube.closeup_use_rot_x = 0
tu.red_tube.closeup_use_rot_y = 2164.27
tu.red_tube.closeup_use_rot_z = 0
tu.red_tube.lookAt = function(arg1) -- line 1025
    local local1
    START_CUT_SCENE()
    local1 = tu:current_setup()
    tu:current_setup(tu_redcu)
    if rnd(5) and tu.chem_state ~= "both chem" then
        start_script(tu.send_canister_through, tu)
    end
    if arg1.seen and not arg1.pondered then
        arg1.pondered = TRUE
        arg1:ponder()
    else
        arg1.seen = TRUE
        manny:say_line("/tuma076/")
    end
    manny:wait_for_message()
    tu:current_setup(local1)
    END_CUT_SCENE()
end
tu.red_tube.use = function(arg1) -- line 1048
    if tu.door_state == "open" and tu.chem_state ~= "both chem" then
        if not tu.red_tube.seen_locked then
            if manny:walkto_object(arg1) then
                tu.red_tube.seen_locked = TRUE
                START_CUT_SCENE()
                manny:walkto_object(tu.red_tube)
                tu:current_setup(tu_redcu)
                if rnd(5) then
                    start_script(tu.send_canister_through, tu)
                end
                manny:ignore_boxes()
                manny:setpos(0.521, -0.31933, 0.0120163)
                manny:setrot(0, 4.68058, 0)
                manny:push_costume("ma_tube_action.cos")
                manny:play_chore(ma_tube_action_handle_shake, "ma_tube_action.cos")
                manny:wait_for_chore()
                manny:pop_costume()
                manny:follow_boxes()
                manny:put_at_object(tu.red_tube)
                tu:current_setup(tu_swopn)
                END_CUT_SCENE()
                system.default_response("locked")
            end
        else
            system.default_response("locked")
        end
    else
        system.default_response("reach")
    end
end
tu.red_tube.use_card = function(arg1, arg2) -- line 1080
    if tu.door_state ~= "open" or tu.chem_state == "both chem" then
        system.default_response("reach")
    else
        arg2:free()
        manny:stop_chore(ms_hold_card, "ms.cos")
        manny:stop_chore(ms_activate_hole_card, "ms.cos")
        manny.is_holding = nil
        if arg2.punched then
            cur_puzzle_state[6] = TRUE
            START_CUT_SCENE()
            tu:current_setup(tu_redcu)
            manny:ignore_boxes()
            manny:stop_chore(ms_hold, "ms.cos")
            manny:setpos(0.485339, -0.311661, 0)
            manny:setrot(0, 359.564, 0)
            manny:stop_chore(ms_hold, "ms.cos")
            manny:stop_chore(ms_hold_card, "ms.cos")
            manny:push_costume("ma_tube_action.cos")
            manny:play_chore(ma_tube_action_canister_stop, "ma_tube_action.cos")
            sleep_for(1000)
            stop_sound("tubAirNb.IMU")
            start_sfx("tubAirPb.IMU")
            sleep_for(3600)
            tu.red_tube:play_chore(tu_canister_stop, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore()
            start_sfx("tubCnVib.IMU")
            tu.red_tube.interest_actor:play_chore_looping(tu_canister_stop_loop, "tu_canister.cos")
            manny:wait_for_chore(ma_tube_action_canister_stop, "ma_tube_action.cos")
            manny:play_chore_looping(ma_tube_action_canister_hold, "ma_tube_action.cos")
            manny:say_line("/tuma078/")
            wait_for_message()
            manny:say_line("/tuma079/")
            wait_for_message()
            manny:say_line("/tuma080/")
            wait_for_message()
            manny:say_line("/tuma081/")
            wait_for_message()
            manny:stop_chore(ma_tube_action_canister_hold, "ma_tube_action.cos")
            manny:play_chore(ma_tube_action_canister_letgo, "ma_tube_action.cos")
            sleep_for(200)
            start_sfx("tubCnPas.WAV")
            sleep_for(400)
            stop_sound("tubCnVib.IMU")
            tu.red_tube.interest_actor:stop_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:play_chore(tu_canister_go, "tu_canister.cos")
            stop_sound("tubAirPb.IMU")
            start_sfx("tubAirNb.IMU")
            manny:wait_for_chore()
            manny:pop_costume()
            manny:follow_boxes()
            manny:put_at_object(tu.red_tube)
            tu:current_setup(tu_swopn)
            break_here()
            manny:say_line("/tuma082/")
            wait_for_message()
            tu:current_setup(tu_dorcu)
            manny:say_line("/tuma083/")
            manny:walkto(1.2208, -1.16499, 0, 0, 351.67, 0)
            manny:wait_for_message()
            break_here()
            stop_sound("tuFanLp.IMU")
            stop_sound("tubAirPb.IMU")
            stop_sound("tubAirNb.IMU")
            stop_sound("tubCnVib.IMU")
            stop_sound("tuSwtch.IMU")
            END_CUT_SCENE()
            start_script(cut_scene.bonewgn)
        else
            START_CUT_SCENE()
            tu:current_setup(tu_redcu)
            manny:ignore_boxes()
            manny:setpos(0.485339, -0.311661, 0)
            manny:setrot(0, 359.564, 0)
            manny:stop_chore(ms_hold, "ms.cos")
            manny:stop_chore(ms_hold_card, "ms.cos")
            manny:push_costume("ma_tube_action.cos")
            manny:play_chore(ma_tube_action_lose_card, "ma_tube_action.cos")
            sleep_for(1200)
            stop_sound("tubAirNb.IMU")
            start_sfx("tubAirFb.IMU")
            sleep_for(800)
            tu.red_tube.interest_actor:play_chore(tu_canister_stop, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_stop, "tu_canister.cos")
            tu.red_tube.interest_actor:play_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_stop_loop, "tu_canister.cos")
            start_sfx("tubCdLos.wav")
            wait_for_sound("tubCdLos.wav")
            start_sfx("tubCnPas.WAV")
            tu.red_tube.interest_actor:play_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:play_chore(tu_canister_go, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:play_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_stop_loop, "tu_canister.cos")
            tu.red_tube.interest_actor:play_chore(tu_canister_go, "tu_canister.cos")
            tu.red_tube.interest_actor:wait_for_chore(tu_canister_go, "tu_canister.cos")
            stop_sound("tubAirFb.IMU")
            start_sfx("tubAirNb.IMU")
            manny:wait_for_chore(ma_tube_action_lose_card, "ma_tube_action.cos")
            manny:pop_costume()
            manny:follow_boxes()
            manny:put_at_object(tu.red_tube)
            tu:current_setup(tu_swopn)
            break_here()
            manny:say_line("/tuma085/")
            END_CUT_SCENE()
        end
    end
end
tu.red_tube.ponder = function(arg1) -- line 1208
    manny:say_line("/tuma093/")
    manny:wait_for_message()
    manny:say_line("/tuma094/")
end
tu.red_tube.use_cards = function(arg1) -- line 1214
    if tu.door_state ~= "open" or tu.chem_state == "both chem" then
        system.default_response("reach")
    else
        mo.cards:switch_to_one()
        tu.red_tube:use_card(mo.one_card)
    end
end
tu.switcher = Object:create(tu, "/tutx086/switcher", 0.0035840999, 0.014294, 0.55000001, { range = 1.5 })
tu.switcher.inside_use_point = function(arg1) -- line 1226
    tu.switcher.use_pnt_x = 0.431
    tu.switcher.use_pnt_y = -0.397
    tu.switcher.use_pnt_z = 0
    tu.switcher.use_rot_x = 0
    tu.switcher.use_rot_y = 2211.66
    tu.switcher.use_rot_z = 0
end
tu.switcher.side_use_point = function(arg1) -- line 1235
    tu.switcher.use_pnt_x = 0.812
    tu.switcher.use_pnt_y = 0.819
    tu.switcher.use_pnt_z = 0
    tu.switcher.use_rot_x = 0
    tu.switcher.use_rot_y = 2323.98
    tu.switcher.use_rot_z = 0
end
tu.switcher.front_use_point = function(arg1) -- line 1244
    tu.switcher.use_pnt_x = 1.158
    tu.switcher.use_pnt_y = -0.106
    tu.switcher.use_pnt_z = 0
    tu.switcher.use_rot_x = 0
    tu.switcher.use_rot_y = 2243.52
    tu.switcher.use_rot_z = 0
end
tu.switcher:side_use_point()
tu.switcher.lookAt = function(arg1) -- line 1255
    if tu.chem_state == "chem 1" then
        manny:say_line("/tuma087/")
    elseif tu.chem_state == "chem 2" then
        manny:say_line("/tuma088/")
    elseif tu.chem_state == "both chem" then
        manny:say_line("/tuma089/")
    else
        manny:say_line("/tuma090/")
    end
end
tu.switcher.use = function(arg1) -- line 1267
    manny:say_line("/tuma091/")
end
tu.fans = Object:create(tu, "fans", 0, 0, 0, { range = 0 })
tu.switcher_door = Object:create(tu, "switcher door", 1, -1, 0, { range = 0 })
tu.flames = Object:create(tu, "flames", 0.0035840999, 0.014294, 0.55000001, { range = 0 })
tu.extinguisher = Object:create(tu, "/bdtx018/fire extinguisher", 1.24414, 1.46034, 0.31990001, { range = 0.60000002 })
tu.extinguisher.string_name = "extinguisher"
tu.extinguisher.big = TRUE
tu.extinguisher.wav = "getMetl.wav"
tu.extinguisher.use_pnt_x = 1.32596
tu.extinguisher.use_pnt_y = 1.24541
tu.extinguisher.use_pnt_z = 0
tu.extinguisher.use_rot_x = 0
tu.extinguisher.use_rot_y = 30.280001
tu.extinguisher.use_rot_z = 0
tu.extinguisher.lookAt = function(arg1) -- line 1298
    manny:say_line("/vima035/")
end
tu.extinguisher.pickUp = function(arg1) -- line 1302
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(ms_hand_on_obj, "ms.cos")
        manny:wait_for_chore()
        sleep_for(100 / GetActorTimeScale(manny.hActor))
        arg1:make_disappear()
        bd.extinguisher:get()
        manny:stop_chore(ms_hand_on_obj, "ms.cos")
        start_sfx("tuGetExt.wav")
        manny:play_chore(ms_activate_extinguisher, "ms.cos")
        manny:play_chore(ms_hand_off_obj, "ms.cos")
        sleep_for(400 / GetActorTimeScale(manny.hActor))
        manny:stop_chore(ms_hand_off_obj, "ms.cos")
        manny:play_chore(ms_hold, "ms.cos")
        manny.is_holding = bd.extinguisher
        manny.hold_chore = ms_activate_extinguisher
        END_CUT_SCENE()
    end
end
tu.extinguisher.use = tu.extinguisher.pickUp
tu.extinguisher.make_disappear = function(arg1) -- line 1325
    arg1.interest_actor:play_chore(1)
    arg1:make_untouchable()
end
tu.lo_door = Object:create(tu, "/tutx092/door", 1.57358, 1.8042901, 0.5, { range = 0.5 })
tu.tu_lo_box = tu.lo_door
tu.lo_door.use_pnt_x = 1.5089999
tu.lo_door.use_pnt_y = 1.286
tu.lo_door.use_pnt_z = 0
tu.lo_door.use_rot_x = 0
tu.lo_door.use_rot_y = 718.34698
tu.lo_door.use_rot_z = 0
tu.lo_door.out_pnt_x = 1.58289
tu.lo_door.out_pnt_y = 1.74386
tu.lo_door.out_pnt_z = 0
tu.lo_door.out_rot_x = 0
tu.lo_door.out_rot_y = 712.00201
tu.lo_door.out_rot_z = 0
tu.lo_door.walkOut = function(arg1) -- line 1354
    if tu.chem_state == "both chem" and brennis.seen_working_this_time then
        brennis:leave()
    end
    lo:come_out_door(lo.tu_door)
end
tu.burn_box = { }
tu.burn_box.name = "burn box"
tu.burn_box.triggered = FALSE
tu.burn_box.walkOut = function(arg1) -- line 1365
    if not arg1.triggered then
        arg1.triggered = TRUE
    elseif tu.chem_state == "both chem" and not brennis.burnt then
        brennis:burn(TRUE)
    end
end
CheckFirstTime("tp.lua")
dofile("tp_interface.lua")
tp = Set:create("tp.set", "ticket printer", { tp_tckcu = 0 })
tp.current_button = nil
tp.week = nil
tp.day = nil
tp.race = nil
tp.RACE = 1
tp.DAY = 2
tp.WEEK = 3
tp.PRINT = 4
system.digitTemplate = { name = "<unnamed>", x = nil, y = nil, elements = nil }
Digit = system.digitTemplate
Digit.create = function(arg1, arg2, arg3, arg4) -- line 45
    local local1 = { }
    local local2 = 1
    local1.parent = Digit
    local1.name = arg2
    local1.x = arg3
    local1.y = arg4
    local1.elements = { }
    repeat
        local1.elements[local2] = DrawLine(tp.basenumber[local2].x1 + local1.x, tp.basenumber[local2].y1 + local1.y, tp.basenumber[local2].x2 + local1.x, tp.basenumber[local2].y2 + local1.y, { color = tp.text_color_dim, layer = 1 })
        local2 = local2 + 1
    until local2 == 14
    return local1
end
Digit.draw_number = function(arg1, arg2) -- line 68
    local local1 = 1
    repeat
        ChangePrimitive(arg1.elements[local1], { color = tp.text_color_dim, layer = 1 })
        local1 = local1 + 1
    until local1 == 14
    local1 = 1
    repeat
        ChangePrimitive(arg1.elements[tp.number[arg2][local1]], { color = tp.text_color_bright, layer = 1 })
        local1 = local1 + 1
    until not tp.number[arg2][local1]
end
Digit.draw_char = function(arg1, arg2) -- line 83
    local local1 = 1
    repeat
        ChangePrimitive(arg1.elements[local1], { color = tp.text_color_dim, layer = 1 })
        local1 = local1 + 1
    until local1 == 14
    local1 = 1
    repeat
        if tp.letter[arg2][local1] then
            ChangePrimitive(arg1.elements[tp.letter[arg2][local1]], { color = tp.text_color_bright, layer = 1 })
        end
        local1 = local1 + 1
    until not tp.letter[arg2][local1]
end
Digit.destroy = function(arg1) -- line 101
    local local1 = 1
    repeat
        KillPrimitive(arg1.elements[local1])
        local1 = local1 + 1
    until local1 == 14
end
system.ledTemplate = { name = "<unnamed>", digits = nil, num_digits = 0 }
Led = system.ledTemplate
Led.create = function(arg1, arg2) -- line 120
    local local1 = { }
    local local2 = 1
    local1.parent = Led
    local1.name = arg2
    local1.digits = { }
    local1.num_digits = 0
    return local1
end
Led.add_digit = function(arg1, arg2, arg3) -- line 133
    local local1 = arg1.num_digits + 1
    arg1.digits[local1] = Digit:create("digit " .. local1, arg2, arg3)
    arg1.num_digits = arg1.num_digits + 1
end
Led.display_number = function(arg1, arg2) -- line 141
    local local1 = arg1.num_digits
    local local2, local3
    if arg2 > 9 then
        local2 = floor(arg2 / 10)
        local3 = mod(arg2, 10)
    else
        local2 = 0
        local3 = arg2
    end
    arg1.digits[local1]:draw_number(local3)
    local1 = local1 - 1
    arg1.digits[local1]:draw_number(local2)
    local1 = local1 - 1
    while arg1.digits[local1] do
        arg1.digits[local1]:draw_number(0)
        local1 = local1 - 1
    end
end
Led.display_str = function(arg1, arg2) -- line 164
    local local1 = 1
    local local2
    arg2 = LocalizeString(arg2)
    arg2 = trim_header(arg2)
    arg2 = americanize_string(arg2)
    repeat
        local2 = strsub(arg2, local1, local1)
        if local2 then
            arg1.digits[local1]:draw_char(local2)
            local1 = local1 + 1
        end
    until local1 > arg1.num_digits or not local2
end
americanize_string = function(arg1) -- line 181
    local local1 = { }
    local local2
    local local3, local4, local5, local6
    local1.A = "\192\193\194\195\196\197\198\224\225\226\227\228\229\230"
    local1.C = "\199\231"
    local1.E = "\200\201\202\203\232\233\234\235"
    local1.I = "\204\205\206\207\236\237\238\239"
    local1.N = "\209\241"
    local1.O = "\210\211\212\213\214\242\243\244\245\246\248\216"
    local1.U = "\217\218\219\220\249\250\251\252"
    local1.Y = "\221\159\253\255"
    local1.OE = "\140\156"
    local1.AE = "\198\230"
    local1.S = "\154\138"
    local1.SS = "\223"
    local2 = arg1
    local3, local4 = next(local1, nil)
    while local3 do
        local6 = strlen(local4)
        local5 = 1
        while local5 <= local6 do
            local2 = gsub(local2, strsub(local4, local5, local5), local3)
            local5 = local5 + 1
        end
        local3, local4 = next(local1, local3)
    end
    local2 = strlower(local2)
    return local2
end
Led.destroy = function(arg1) -- line 216
    local local1 = 1
    repeat
        arg1.digits[local1]:destroy()
        local1 = local1 + 1
    until local1 > arg1.num_digits
end
tp.init_number_tables = function() -- line 238
    tp.basenumber = { }
    tp.basenumber[1] = { }
    tp.basenumber[2] = { }
    tp.basenumber[3] = { }
    tp.basenumber[4] = { }
    tp.basenumber[5] = { }
    tp.basenumber[6] = { }
    tp.basenumber[7] = { }
    tp.basenumber[8] = { }
    tp.basenumber[9] = { }
    tp.basenumber[10] = { }
    tp.basenumber[11] = { }
    tp.basenumber[12] = { }
    tp.basenumber[13] = { }
    tp.basenumber[1].x1 = 1
    tp.basenumber[1].y1 = 0
    tp.basenumber[1].x2 = 12
    tp.basenumber[1].y2 = 0
    tp.basenumber[2].x1 = 0
    tp.basenumber[2].y1 = 1
    tp.basenumber[2].x2 = 0
    tp.basenumber[2].y2 = 13
    tp.basenumber[3].x1 = 13
    tp.basenumber[3].y1 = 1
    tp.basenumber[3].x2 = 13
    tp.basenumber[3].y2 = 13
    tp.basenumber[4].x1 = 1
    tp.basenumber[4].y1 = 14
    tp.basenumber[4].x2 = 12
    tp.basenumber[4].y2 = 14
    tp.basenumber[5].x1 = 0
    tp.basenumber[5].y1 = 15
    tp.basenumber[5].x2 = 0
    tp.basenumber[5].y2 = 27
    tp.basenumber[6].x1 = 13
    tp.basenumber[6].y1 = 15
    tp.basenumber[6].x2 = 13
    tp.basenumber[6].y2 = 27
    tp.basenumber[7].x1 = 1
    tp.basenumber[7].y1 = 28
    tp.basenumber[7].x2 = 12
    tp.basenumber[7].y2 = 28
    tp.basenumber[8].x1 = 6
    tp.basenumber[8].y1 = 1
    tp.basenumber[8].x2 = 6
    tp.basenumber[8].y2 = 12
    tp.basenumber[9].x1 = 6
    tp.basenumber[9].y1 = 15
    tp.basenumber[9].x2 = 6
    tp.basenumber[9].y2 = 27
    tp.basenumber[10].x1 = 1
    tp.basenumber[10].y1 = 26
    tp.basenumber[10].x2 = 5
    tp.basenumber[10].y2 = 15
    tp.basenumber[11].x1 = 7
    tp.basenumber[11].y1 = 12
    tp.basenumber[11].x2 = 12
    tp.basenumber[11].y2 = 1
    tp.basenumber[12].x1 = 1
    tp.basenumber[12].y1 = 1
    tp.basenumber[12].x2 = 5
    tp.basenumber[12].y2 = 12
    tp.basenumber[13].x1 = 7
    tp.basenumber[13].y1 = 15
    tp.basenumber[13].x2 = 11
    tp.basenumber[13].y2 = 26
    tp.number = { }
    tp.number[0] = { }
    tp.number[0][1] = 1
    tp.number[0][2] = 2
    tp.number[0][3] = 3
    tp.number[0][4] = 5
    tp.number[0][5] = 6
    tp.number[0][6] = 7
    tp.number[1] = { }
    tp.number[1][1] = 8
    tp.number[1][2] = 9
    tp.number[2] = { }
    tp.number[2][1] = 1
    tp.number[2][2] = 3
    tp.number[2][3] = 4
    tp.number[2][4] = 5
    tp.number[2][5] = 7
    tp.number[3] = { }
    tp.number[3][1] = 1
    tp.number[3][2] = 3
    tp.number[3][3] = 4
    tp.number[3][4] = 6
    tp.number[3][5] = 7
    tp.number[4] = { }
    tp.number[4][1] = 2
    tp.number[4][2] = 3
    tp.number[4][3] = 4
    tp.number[4][4] = 6
    tp.number[5] = { }
    tp.number[5][1] = 1
    tp.number[5][2] = 2
    tp.number[5][3] = 4
    tp.number[5][4] = 6
    tp.number[5][5] = 7
    tp.number[6] = { }
    tp.number[6][1] = 2
    tp.number[6][2] = 4
    tp.number[6][3] = 5
    tp.number[6][4] = 6
    tp.number[6][5] = 7
    tp.number[7] = { }
    tp.number[7][1] = 1
    tp.number[7][2] = 3
    tp.number[7][3] = 6
    tp.number[8] = { }
    tp.number[8][1] = 1
    tp.number[8][2] = 2
    tp.number[8][3] = 3
    tp.number[8][4] = 4
    tp.number[8][5] = 5
    tp.number[8][6] = 6
    tp.number[8][7] = 7
    tp.number[9] = { }
    tp.number[9][1] = 1
    tp.number[9][2] = 2
    tp.number[9][3] = 3
    tp.number[9][4] = 4
    tp.number[9][5] = 6
    tp.letter = { }
    tp.letter["a"] = { }
    tp.letter.a[1] = 1
    tp.letter.a[2] = 2
    tp.letter.a[3] = 3
    tp.letter.a[4] = 4
    tp.letter.a[5] = 5
    tp.letter.a[6] = 6
    tp.letter.b = { }
    tp.letter.b[1] = 1
    tp.letter.b[2] = 2
    tp.letter.b[3] = 3
    tp.letter.b[4] = 4
    tp.letter.b[5] = 5
    tp.letter.b[6] = 6
    tp.letter.b[7] = 7
    tp.letter.c = { }
    tp.letter.c[1] = 1
    tp.letter.c[2] = 2
    tp.letter.c[3] = 5
    tp.letter.c[4] = 7
    tp.letter["d"] = { }
    tp.letter.d[1] = 2
    tp.letter.d[2] = 5
    tp.letter.d[3] = 10
    tp.letter.d[4] = 12
    tp.letter["e"] = { }
    tp.letter.e[1] = 1
    tp.letter.e[2] = 2
    tp.letter.e[3] = 4
    tp.letter.e[4] = 5
    tp.letter.e[5] = 7
    tp.letter["f"] = { }
    tp.letter.f[1] = 1
    tp.letter.f[2] = 2
    tp.letter.f[3] = 4
    tp.letter.f[4] = 5
    tp.letter.g = { }
    tp.letter.g[1] = 1
    tp.letter.g[2] = 2
    tp.letter.g[3] = 5
    tp.letter.g[4] = 7
    tp.letter.g[5] = 13
    tp.letter.h = { }
    tp.letter.h[1] = 2
    tp.letter.h[2] = 3
    tp.letter.h[3] = 4
    tp.letter.h[4] = 5
    tp.letter.h[5] = 6
    tp.letter["i"] = { }
    tp.letter.i[1] = 8
    tp.letter.i[2] = 9
    tp.letter.j = { }
    tp.letter.j[1] = 1
    tp.letter.j[2] = 8
    tp.letter.j[3] = 10
    tp.letter.j[4] = 5
    tp.letter.k = { }
    tp.letter.k[1] = 8
    tp.letter.k[2] = 9
    tp.letter.k[3] = 11
    tp.letter.k[4] = 13
    tp.letter["l"] = { }
    tp.letter.l[1] = 2
    tp.letter.l[2] = 5
    tp.letter.l[3] = 7
    tp.letter.m = { }
    tp.letter.m[1] = 2
    tp.letter.m[2] = 3
    tp.letter.m[3] = 5
    tp.letter.m[4] = 6
    tp.letter.m[5] = 12
    tp.letter.m[6] = 11
    tp.letter["n"] = { }
    tp.letter.n[1] = 2
    tp.letter.n[2] = 3
    tp.letter.n[3] = 5
    tp.letter.n[4] = 6
    tp.letter.n[5] = 12
    tp.letter.n[6] = 13
    tp.letter["o"] = { }
    tp.letter.o[1] = 1
    tp.letter.o[2] = 2
    tp.letter.o[3] = 3
    tp.letter.o[4] = 5
    tp.letter.o[5] = 6
    tp.letter.o[6] = 7
    tp.letter.p = { }
    tp.letter.p[1] = 1
    tp.letter.p[2] = 2
    tp.letter.p[3] = 3
    tp.letter.p[4] = 4
    tp.letter.p[5] = 5
    tp.letter.q = { }
    tp.letter.q[1] = 1
    tp.letter.q[2] = 2
    tp.letter.q[3] = 3
    tp.letter.q[4] = 5
    tp.letter.q[5] = 6
    tp.letter.q[6] = 7
    tp.letter.q[7] = 13
    tp.letter["r"] = { }
    tp.letter.r[1] = 1
    tp.letter.r[2] = 2
    tp.letter.r[3] = 3
    tp.letter.r[4] = 4
    tp.letter.r[5] = 5
    tp.letter.r[6] = 13
    tp.letter.s = { }
    tp.letter.s[1] = 1
    tp.letter.s[2] = 12
    tp.letter.s[3] = 13
    tp.letter.s[4] = 7
    tp.letter["t"] = { }
    tp.letter.t[1] = 1
    tp.letter.t[2] = 8
    tp.letter.t[3] = 9
    tp.letter["u"] = { }
    tp.letter.u[1] = 2
    tp.letter.u[2] = 3
    tp.letter.u[3] = 5
    tp.letter.u[4] = 6
    tp.letter.u[5] = 7
    tp.letter.v = { }
    tp.letter.v[1] = 2
    tp.letter.v[2] = 5
    tp.letter.v[3] = 10
    tp.letter.v[4] = 11
    tp.letter["w"] = { }
    tp.letter.w[1] = 2
    tp.letter.w[2] = 3
    tp.letter.w[3] = 5
    tp.letter.w[4] = 6
    tp.letter.w[5] = 10
    tp.letter.w[6] = 13
    tp.letter.x = { }
    tp.letter.x[1] = 10
    tp.letter.x[2] = 11
    tp.letter.x[3] = 12
    tp.letter.x[4] = 13
    tp.letter.y = { }
    tp.letter.y[1] = 9
    tp.letter.y[2] = 11
    tp.letter.y[3] = 12
    tp.letter.z = { }
    tp.letter.z[1] = 1
    tp.letter.z[2] = 7
    tp.letter.z[3] = 10
    tp.letter.z[4] = 11
    tp.window_offset = { }
    tp.window_offset[1] = { }
    tp.window_offset[1].x = 198
    tp.window_offset[1].y = 211
    tp.window_offset[2] = { }
    tp.window_offset[2].x = 214
    tp.window_offset[2].y = 211
    tp.window_offset[3] = { }
    tp.window_offset[3].x = 320
    tp.window_offset[3].y = 256
    tp.window_offset[4] = { }
    tp.window_offset[4].x = 336
    tp.window_offset[4].y = 256
    tp.window_offset[5] = { }
    tp.window_offset[5].x = 352
    tp.window_offset[5].y = 256
    tp.window_offset[6] = { }
    tp.window_offset[6].x = 453
    tp.window_offset[6].y = 211
    tp.window_offset[7] = { }
    tp.window_offset[7].x = 469
    tp.window_offset[7].y = 211
    tp.daystr = { }
    tp.daystr[1] = "/tptx189/"
    tp.daystr[2] = "/tptx190/"
    tp.daystr[3] = "/tptx191/"
    tp.daystr[4] = "/tptx192/"
    tp.daystr[5] = "/tptx193/"
    tp.daystr[6] = "/tptx194/"
    tp.daystr[7] = "/tptx195/"
end
tp.enter = function(arg1) -- line 613
    NewObjectState(tp_tckcu, OBJSTATE_OVERLAY, "print_ticket.bm")
    tp.stub:set_object_state("tp_stub.cos")
    tp.init_number_tables()
    if not mannys_hands then
        mannys_hands = Actor:create(nil, nil, nil, "/sytx188/")
    end
    mannys_hands:set_costume("tp_interface.cos")
    mannys_hands:put_in_set(tp)
    mannys_hands:moveto(-0.029, 0.002, 0)
    mannys_hands:setrot(0, 180, 0)
    tp.current_button = tp.RACE
    tp.text_color_bright = MakeColor(255, 150, 0)
    tp.text_color_dim = MakeColor(80, 80, 0)
    week_field = Led:create("week")
    week_field:add_digit(tp.window_offset[1].x, tp.window_offset[1].y)
    week_field:add_digit(tp.window_offset[2].x, tp.window_offset[2].y)
    week_field:display_number(1)
    tp.week = 1
    cn.ticket.week = 1
    day_field = Led:create("day")
    day_field:add_digit(tp.window_offset[3].x, tp.window_offset[3].y)
    day_field:add_digit(tp.window_offset[4].x, tp.window_offset[4].y)
    day_field:add_digit(tp.window_offset[5].x, tp.window_offset[5].y)
    day_field:display_str(tp.daystr[1])
    tp.day = 1
    cn.ticket.day = 1
    race_field = Led:create("race")
    race_field:add_digit(tp.window_offset[6].x, tp.window_offset[6].y)
    race_field:add_digit(tp.window_offset[7].x, tp.window_offset[7].y)
    race_field:display_number(1)
    tp.race = 1
    cn.ticket.race = 1
end
tp.exit = function(arg1) -- line 656
    mannys_hands:free()
    week_field:destroy()
    race_field:destroy()
    day_field:destroy()
end
tp.switch_to_set = function(arg1) -- line 664
    if IsMoviePlaying() then
        StopMovie()
    else
        system.loopingMovie = nil
    end
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    inventory_save_set = system.currentSet
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = tp
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
end
tp.return_to_set = function(arg1, arg2) -- line 685
    START_CUT_SCENE()
    if arg2 then
        tp.stub:play_chore(0)
        tp.stub:wait_for_chore()
    end
    END_CUT_SCENE()
    tp:exit()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    system.buttonHandler = inventory_save_handler
    if system.loopingMovie and type(system.loopingMovie) == "table" then
        play_movie_looping(system.loopingMovie.name, system.loopingMovie.x, system.loopingMovie.y)
    end
    if arg2 then
        START_CUT_SCENE()
        put_away_held_item()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.ticket
        start_script(close_inventory)
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
    end
end
tpButtonHandler = function(arg1, arg2, arg3) -- line 724
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if control_map.OVERRIDE[arg1] and arg2 then
        single_start_script(tp.close_printer)
    elseif control_map.TURN_RIGHT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.move_right)
    elseif control_map.TURN_LEFT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.move_left)
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel <= 0 or (control_map.USE[arg1] and arg2 and cutSceneLevel <= 0) then
        single_start_script(cn.printer.lookAt, cn.printer)
    elseif control_map.MOVE_BACKWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.push_down)
    elseif control_map.MOVE_FORWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(tp.push_up)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
tp.move_left = function() -- line 747
    local local1
    while get_generic_control_state("TURN_LEFT") do
        if tp.current_button == tp.RACE then
            tp.current_button = tp.DAY
            mannys_hands:moveto(-0.015, 0.0020000001, 0)
        elseif tp.current_button == tp.DAY then
            tp.current_button = tp.WEEK
            mannys_hands:moveto(-0.001, 0.0020000001, 0)
        elseif tp.current_button == tp.WEEK then
            tp.current_button = tp.PRINT
            mannys_hands:moveto(-0.015, -0.02, 0)
        elseif tp.current_button == tp.PRINT then
            tp.current_button = tp.RACE
            mannys_hands:moveto(-0.028999999, 0.0020000001, 0)
        end
        mannys_hands:wait_for_actor()
        local1 = 0
        while local1 < 500 and get_generic_control_state("TURN_LEFT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
tp.move_right = function() -- line 777
    local local1
    while get_generic_control_state("TURN_RIGHT") do
        if tp.current_button == tp.WEEK then
            tp.current_button = tp.DAY
            mannys_hands:moveto(-0.015, 0.0020000001, 0)
        elseif tp.current_button == tp.DAY then
            tp.current_button = tp.RACE
            mannys_hands:moveto(-0.028999999, 0.0020000001, 0)
        elseif tp.current_button == tp.RACE then
            tp.current_button = tp.PRINT
            mannys_hands:moveto(-0.015, -0.02, 0)
        elseif tp.current_button == tp.PRINT then
            tp.current_button = tp.WEEK
            mannys_hands:moveto(-0.001, 0.0020000001, 0)
        end
        mannys_hands:wait_for_actor()
        local1 = 0
        while local1 < 500 and get_generic_control_state("TURN_RIGHT") do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
end
tp.close_printer = function() -- line 807
    tp.return_to_set()
end
tp.push_up = function() -- line 811
    START_CUT_SCENE()
    mannys_hands:play_chore(tp_interface_press_up)
    sleep_for(100)
    if tp.current_button == tp.RACE then
        tp.race = tp.race + 1
        if tp.race > 15 then
            tp.race = 1
        end
        cn.ticket.race = tp.race
        start_sfx("prntBtn1.wav", 100, 80)
        race_field:display_number(tp.race)
    elseif tp.current_button == tp.DAY then
        tp.day = tp.day + 1
        if tp.day > 7 then
            tp.day = 1
        end
        cn.ticket.day = tp.day
        start_sfx("prntBtn2.wav", 100, 80)
        day_field:display_str(tp.daystr[tp.day])
    elseif tp.current_button == tp.WEEK then
        tp.week = tp.week + 1
        if tp.week > 32 then
            tp.week = 1
        end
        cn.ticket.week = tp.week
        start_sfx("prntBtn3.wav", 100, 80)
        week_field:display_number(tp.week)
    elseif tp.current_button == tp.PRINT then
        start_sfx("prntPrnt.wav")
        cn.ticket:get()
        tp:return_to_set(TRUE)
    end
    mannys_hands:wait_for_chore()
    END_CUT_SCENE()
end
tp.push_down = function() -- line 853
    START_CUT_SCENE()
    if tp.current_button == tp.PRINT then
        mannys_hands:play_chore(tp_interface_press_up)
    else
        mannys_hands:play_chore(tp_interface_press_down)
    end
    sleep_for(100)
    if tp.current_button == tp.RACE then
        tp.race = tp.race - 1
        if tp.race < 1 then
            tp.race = 15
        end
        cn.ticket.race = tp.race
        start_sfx("prntBtn1.wav", 100, 80)
        race_field:display_number(tp.race)
    elseif tp.current_button == tp.DAY then
        tp.day = tp.day - 1
        if tp.day < 1 then
            tp.day = 7
        end
        cn.ticket.day = tp.day
        start_sfx("prntBtn2.wav", 100, 80)
        day_field:display_str(tp.daystr[tp.day])
    elseif tp.current_button == tp.WEEK then
        tp.week = tp.week - 1
        if tp.week < 1 then
            tp.week = 32
        end
        cn.ticket.week = tp.week
        start_sfx("prntBtn3.wav", 100, 80)
        week_field:display_number(tp.week)
    elseif tp.current_button == tp.PRINT then
        start_sfx("prntPrnt.wav")
        cn.ticket:get()
        tp:return_to_set(TRUE)
    end
    mannys_hands:wait_for_chore()
    END_CUT_SCENE()
end
tp.stub = Object:create(tp, "", 0, 0, 0, { range = 0 })
CheckFirstTime("th.lua")
dofile("thunderboy1_idles.lua")
dofile("thunderboy2_idles.lua")
dofile("thb1_coffee.lua")
dofile("thb2_coffee.lua")
dofile("msb_snowblow.lua")
dofile("msb_coffee.lua")
dofile("msb_theater.lua")
th = Set:create("th.set", "theater backstage", { th_stgws = 0, th_stgws2 = 0, th_rftha = 2, th_tbyws = 1, th_snocu = 3, th_ovrhd = 4 })
th.lever_actor = Actor:create(nil, nil, nil, "snow lever")
th.lever_actor.default = function(arg1) -- line 24
    arg1:set_costume("msb_snowblow.cos")
    arg1:put_in_set(th)
    arg1:setpos(0.20997, -0.0325, 2.1527)
    arg1:setrot(0, 90, 0)
    arg1:play_chore(msb_snowblow_chain_only)
end
th.coffeepot_actor = Actor:create(nil, nil, nil, "coffee pot")
th.coffeepot_actor.default = function(arg1) -- line 35
    arg1:set_costume("msb_coffee.cos")
    arg1:put_in_set(th)
    arg1:set_softimage_pos(-4.4588, 0, 19.993)
    arg1:setrot(0, 225, 0)
    arg1:play_chore(msb_coffee_coffee_on_burner)
    arg1:set_visibility(TRUE)
end
th.grinder_actor = Actor:create(nil, nil, nil, "grinder")
th.grinder_actor.default = function(arg1) -- line 47
    arg1:set_costume("th_grinder.cos")
    arg1:put_in_set(th)
    arg1:setpos(0.0860798, -0.011, 2.497)
    arg1:setrot(0, 101, 0)
    if th.grinder.has_bone then
        arg1:complete_chore(1)
    else
        arg1:complete_chore(0)
    end
end
th.stop_thunderboys = function() -- line 61
    stop_script(th.backstage_mumbling)
    stop_script(th.backstage_idling)
    thunder_boy_1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
    thunder_boy_1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
    thunder_boy_2:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
end
tb1 = Dialog:create()
tb1.intro = function(arg1) -- line 72
    th.mocked = TRUE
    if find_script(th.meet_the_thunder_boys) then
        stop_script(th.meet_the_thunder_boys)
    end
    th.stop_thunderboys()
    wait_for_message()
    START_CUT_SCENE()
    manny:setpos(0.363558, -0.583726, 0)
    manny:setrot(0, 296.391, 0)
    thunder_boy_1:say_line("/tht1003/")
    thunder_boy_1:wait_for_message()
    END_CUT_SCENE()
end
tb1[100] = { text = "/thma004/", n1 = TRUE }
tb1[100].response = function(arg1) -- line 90
    thunder_boy_2:say_line("/tht2005/")
    manny:head_look_at(th.thunderboy2)
    tb1.kiss_off()
end
tb1[200] = { text = "/thma006/", n1 = TRUE }
tb1[200].response = function(arg1) -- line 97
    thunder_boy_2:say_line("/tht2007/")
    manny:head_look_at(th.thunderboy2)
    tb1.kiss_off()
end
tb1.kiss_off = function() -- line 104
    tb1.node = "exit_dialog"
    wait_for_message()
    thunder_boy_1:say_line("/tht1008/")
    manny:head_look_at(th.thunderboy1)
    wait_for_message()
    thunder_boy_2:say_line("/tht2009/")
    manny:head_look_at(th.thunderboy2)
    wait_for_message()
    manny:head_look_at(nil)
    manny:walkto(0.197732, -0.593037, 0)
    th:current_setup(th_stgws)
    sleep_for(1000)
    thunder_boy_2:say_line("/tht2010/")
    sleep_for(500)
    thunder_boy_1:say_line("/tht1011/")
    wait_for_message()
    start_script(th.backstage_mumbling, th)
    start_script(th.backstage_idling, th)
    cameraman_disabled = FALSE
end
th.back_off = function() -- line 126
    stop_script(th.meet_the_thunder_boys)
    if manny.is_holding == th.coffee_pot then
        start_script(th.serve_coffee)
    else
        cameraman_disabled = TRUE
        th:current_setup(th_tbyws)
        manny:setpos(0.363558, -0.583726, 0)
        manny:setrot(0, 296.391, 0)
        if th.mocked then
            START_CUT_SCENE()
            thunder_boy_2:say_line("/tht2012/")
            wait_for_message()
            thunder_boy_2:say_line("/tht2013/")
            END_CUT_SCENE()
            manny:setpos(0.197732, -0.593037, 0)
            manny:setrot(0, 108.182, 0)
            th:current_setup(th_stgws)
            cameraman_disabled = FALSE
        else
            tb1:init()
        end
    end
end
th.meet_the_thunder_boys = function() -- line 155
    START_CUT_SCENE()
    th.met_thunder_boys = TRUE
    set_override(th.skip_meet_boys, th)
    manny:head_look_at(th.thunderboy2)
    stop_script(th.backstage_mumbling)
    thunder_boy_1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
    thunder_boy_1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
    thunder_boy_2:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
    thunder_boy_2:say_line("/tht2014/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1015/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2016/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1017/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2018/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1019/")
    thunder_boy_1:wait_for_message()
    END_CUT_SCENE()
    manny:head_look_at(nil)
    thunder_boy_2:say_line("/tht2020/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1021/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2022/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2023/")
    thunder_boy_2:wait_for_message()
    start_script(th.backstage_mumbling, th)
end
th.skip_meet_boys = function(arg1) -- line 193
    kill_override()
    single_start_script(th.backstage_mumbling, th)
end
th.eavesdrop = function() -- line 199
    th.stop_thunderboys()
    START_CUT_SCENE()
    box_off("eavesdrop_trigg")
    th.eavesdropped = TRUE
    th:current_setup(th_tbyws)
    break_here()
    thunder_boy_2:say_line("/tht2024/")
    sleep_for(500)
    manny:walkto(0.960463, -1.08513, -0.29)
    manny:wait_for_actor()
    manny:setrot(0, 452.177, 0)
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1025/")
    wait_for_message()
    thunder_boy_2:say_line("/tht2026/")
    wait_for_message()
    thunder_boy_2:say_line("/tht2027/")
    wait_for_message()
    thunder_boy_1:say_line("/tht1028/")
    wait_for_message()
    th:current_setup(th_stgws)
    END_CUT_SCENE()
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.burn_thunderboy_burn = function() -- line 227
    START_CUT_SCENE()
    th.boys_gone = TRUE
    th.thunderboy1:make_untouchable()
    th.thunderboy2:make_untouchable()
    stop_script(th.meet_the_thunder_boys)
    th.stop_thunderboys()
    th.thunderboys_from_above:make_untouchable()
    box_off("personal_bubble")
    box_off("eavesdrop_trigg")
    thunder_boy_1:wait_for_chore()
    thunder_boy_2:wait_for_chore()
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:push_costume("msb_coffee.cos")
    manny:play_chore(msb_coffee_start_pour_on_boyz, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofLng.WAV")
    manny:wait_for_chore(msb_coffee_start_pour_on_boyz, "msb_coffee.cos")
    manny:play_chore_looping(msb_coffee_pour_on_boyz, "msb_coffee.cos")
    music_state:set_sequence(seqCoffeeOnBoys)
    sleep_for(1000)
    th:current_setup(th_tbyws)
    manny:ignore_boxes()
    manny:setpos(0.542084, -0.123266, 2.05)
    manny:setrot(0, 164.794, 0)
    thunder_boy_2:say_line("/tht2029/")
    sleep_for(500)
    thunder_boy_1:stop_chore(thunderboy1_idles_talk1, "thunderboy1_idles.cos")
    thunder_boy_1:stop_chore(thunderboy1_idles_talk2, "thunderboy1_idles.cos")
    thunder_boy_1:stop_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_1:set_time_scale(1.2)
    thunder_boy_1:play_chore(thb1_coffee_coffee_dumped, "thb1_coffee.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_talk1, "thunderboy2_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_talk2, "thunderboy2_idles.cos")
    thunder_boy_2:stop_chore(thunderboy2_idles_whole_back, "thunderboy2_idles.cos")
    thunder_boy_2:set_time_scale(1.2)
    thunder_boy_2:play_chore(thb2_coffee_dumped_on, "thb2_coffee.cos")
    thunder_boy_2:wait_for_message()
    manny:stop_chore(msb_coffee_pour_on_boyz, "msb_coffee.cos")
    thunder_boy_2:say_line("/tht2030/")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1031/")
    thunder_boy_1:wait_for_message()
    sleep_for(1000)
    thunder_boy_2:say_line("/tht2032/")
    thunder_boy_2:wait_for_message()
    th:current_setup(th_stgws)
    thunder_boy_2:setpos(0.625962, -0.313716, 0)
    thunder_boy_2:setrot(0, 123.538, 0)
    thunder_boy_2:setpos(0.605883, -0.492313, 0)
    thunder_boy_1:setrot(0, 63.5565, 0)
    thunder_boy_2:say_line("/tht2033/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2034/")
    thunder_boy_2:wait_for_chore(thb2_coffee_dumped_on, "thb2_coffee.cos")
    thunder_boy_2:play_chore(thb2_coffee_run, "thb2_coffee.cos")
    thunder_boy_1:play_chore(thb1_coffee_run, "thb1_coffee.cos")
    thunder_boy_2:wait_for_message()
    thunder_boy_1:say_line("/tht1035/")
    thunder_boy_1:wait_for_chore(thb1_coffee_run, "thb1_coffee.cos")
    th:current_setup(th_rftha)
    manny:follow_boxes()
    manny:put_at_object(th.thunderboys_from_above)
    manny:play_chore(msb_coffee_stop_pour_on_boyz, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour_on_boyz, "msb_coffee.cos")
    thunder_boy_1:wait_for_message()
    thunder_boy_1:free()
    thunder_boy_2:free()
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    END_CUT_SCENE()
end
th.set_up_actors = function(arg1) -- line 312
    if th.boys_gone then
        thunder_boy_1:put_in_set(nil)
        th.thunderboy1:make_untouchable()
        thunder_boy_2:put_in_set(nil)
        th.thunderboy2:make_untouchable()
        box_off("personal_bubble")
        box_off("eavesdrop_trigg")
    else
        thunder_boy_1:default()
        thunder_boy_1:put_in_set(th)
        thunder_boy_1:setpos(0.63103, -0.69655, 0)
        thunder_boy_1:setrot(0, 95.2081, 0)
        thunder_boy_2:default()
        thunder_boy_2:put_in_set(th)
        thunder_boy_2:setpos(0.60327, -0.35421, 0)
        thunder_boy_2:setrot(0, 144.486, 0)
        start_script(th.backstage_mumbling, th)
        start_script(th.backstage_idling, th)
    end
    th.lever_actor:default()
    if th.coffee_pot.touchable then
        th.coffeepot_actor:default()
    end
    if th.snow_machine.has_grinder then
        th.grinder_actor:default()
    end
    if makeup_woman then
        makeup_woman.saylineTable.x = 400
        makeup_woman.saylineTable.y = 200
        makeup_woman.saylineTable.pan = 110
    end
end
th.backstage_lines_one = { "/tht1044/", "/tht1045/", "/tht1046/", "/tht1047/", "/tht1048/", "/tht1049/", "/tht1050/", "/tht1051/", "/tht1052/" }
th.backstage_lines_two = { "/tht2036/", "/tht2037/", "/tht2038/", "/tht2039/", "/tht2040/", "/tht2041/", "/tht2042/", "/tht2043/" }
th.backstage_mumbling = function(arg1) -- line 375
    local local1 = thunder_boy_1
    local local2 = th.backstage_lines_one
    local local3, local4, local5
    while system.currentSet == th do
        if cutSceneLevel <= 0 then
            if local1 == thunder_boy_1 then
                local1:play_chore_looping(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
            else
                local1:play_chore_looping(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
            end
            local3 = rndint(2000, 5000)
            local5 = FALSE
            local4 = 0
            while local4 < local3 do
                if not local5 and rnd(8) and cutSceneLevel <= 0 then
                    if local1 == thunder_boy_1 then
                        local1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                    else
                        local1:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                    end
                    local1:say_line(pick_one_of(local2, TRUE), { background = TRUE, skip_log = TRUE, volume = 10 })
                    local1:wait_for_message()
                    if local1 == thunder_boy_1 then
                        local1:play_chore_looping(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                    else
                        local1:play_chore_looping(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                    end
                    local5 = TRUE
                end
                break_here()
                local4 = local4 + system.frameTime
            end
            if local1 == thunder_boy_1 then
                local1:stop_chore(thunderboy1_idles_mumble, "thunderboy1_idles.cos")
                local1:play_chore(thunderboy1_idles_stop_talk, "thunderboy1_idles.cos")
                local1 = thunder_boy_2
                local2 = th.backstage_lines_two
            else
                local1:stop_chore(thunderboy2_idles_mumble, "thunderboy2_idles.cos")
                local1:play_chore(thunderboy2_idles_stop_talk, "thunderboy2_idles.cos")
                local1 = thunder_boy_1
                local2 = th.backstage_lines_one
            end
        end
        break_here()
    end
end
th.backstage_idling = function(arg1) -- line 427
    local local1, local2
    thunder_boy_1:play_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_2:play_chore(thunderboy1_idles_whole_back, "thunderboy2_idles.cos")
    thunder_boy_1:wait_for_chore(thunderboy1_idles_whole_back, "thunderboy1_idles.cos")
    thunder_boy_2:wait_for_chore(thunderboy1_idles_whole_back, "thunderboy2_idles.cos")
    while system.currentSet == th do
        if local1 == thunderboy1_idles_talk1 then
            local1 = thunderboy1_idles_talk2
        else
            local1 = thunderboy1_idles_talk1
        end
        thunder_boy_1:play_chore(local1, "thunderboy1_idles.cos")
        thunder_boy_1:wait_for_chore(local1, "thunderboy1_idles.cos")
        if local2 == thunderboy2_idles_talk1 then
            local2 = thunderboy2_idles_talk2
        else
            local2 = thunderboy2_idles_talk1
        end
        thunder_boy_2:play_chore(local2, "thunderboy2_idles.cos")
        thunder_boy_2:wait_for_chore(local2, "thunderboy2_idles.cos")
    end
end
th.crash_dressing_room = function() -- line 456
    START_CUT_SCENE()
    if manny.is_holding == th.coffee_pot and (not th.boys_gone or manny.thunder) then
        makeup_woman:say_line("/thmk053/")
        makeup_woman:wait_for_message()
        start_sfx("thCofSht.WAV", IM_HIGH_PRIORITY, 127)
        set_pan("thCofSht.WAV", 127)
        wait_for_sound("thCofSht.WAV")
    elseif not th.boys_gone then
        makeup_woman:say_line("/thmk054/")
    elseif not manny.thunder then
        manny.thunder = TRUE
        cur_puzzle_state[55] = TRUE
        if manny.is_holding == th.coffee_pot then
            th.coffee_pot:free()
            th.coffee_pot:make_untouchable()
            box_on("grinder_box1")
            box_on("grinder_box2")
            manny.is_holding = nil
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
            makeup_woman:say_line("/thmk056/")
        else
            makeup_woman:say_line("/thmk057/")
        end
        wait_for_message()
        makeup_woman:say_line("/thmk058/")
        wait_for_message()
        manny:say_line("/thma059/")
        wait_for_message()
        IrisDown(570, 300, 1000)
        makeup_woman:say_line("/thmk060/")
        wait_for_message()
        sleep_for(500)
        manny.thunder = TRUE
        manny:default("thunder")
        IrisUp(570, 300, 1000)
        manny:walkto(1.06713, -1.14721, -0.29)
        makeup_woman:say_line("/thmk061/")
    else
        manny:say_line("/thma062/")
        wait_for_message()
        makeup_woman:say_line("/thmk063/")
        wait_for_message()
        if not th.bashed_thunder then
            th.bashed_thunder = TRUE
            makeup_woman:say_line("/thmk064/")
            wait_for_message()
            manny:say_line("/thma065/")
            wait_for_message()
            makeup_woman:say_line("/thmk066/")
        end
    end
    END_CUT_SCENE()
    manny:walkto(1.06713, -1.14721, -0.29)
end
th.serve_coffee = function() -- line 519
    th:current_setup(th_stgws)
    th.stop_thunderboys()
    START_CUT_SCENE()
    set_override(th.skip_serve_coffee, th)
    thunder_boy_1:say_line("/tht1067/")
    manny:head_look_at(th.thunderboy1)
    manny:walkto(0.156781, -0.804922, 0, 0, 296.215, 0)
    thunder_boy_1:wait_for_message()
    manny:wait_for_actor()
    thunder_boy_1:wait_for_chore()
    thunder_boy_1:set_time_scale(1.8)
    thunder_boy_2:set_time_scale(1.8)
    manny:push_costume("msb_coffee.cos")
    thunder_boy_1:play_chore(thb1_coffee_get_coffee, "thb1_coffee.cos")
    sleep_for(1500)
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:play_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofSht.WAV")
    manny:wait_for_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    manny:play_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    manny:head_look_at(th.thunderboy2)
    manny:walkto(0.126085, -0.476472, 0, 0, 317.476, 0)
    manny:wait_for_actor()
    thunder_boy_2:wait_for_chore()
    manny:push_costume("msb_coffee.cos")
    thunder_boy_2:play_chore(thb2_coffee_get_coffee, "thb2_coffee.cos")
    sleep_for(1500)
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
    manny:play_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    sleep_for(100)
    start_sfx("thCofSht.WAV")
    manny:wait_for_chore(msb_coffee_2coffee_pour, "msb_coffee.cos")
    manny:play_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:wait_for_chore(msb_coffee_stop_pour, "msb_coffee.cos")
    manny:pop_costume()
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    thunder_boy_1:set_time_scale(1)
    thunder_boy_2:set_time_scale(1)
    if not th.served then
        th.served = TRUE
        thunder_boy_2:say_line("/tht2068/")
        thunder_boy_2:wait_for_message()
        thunder_boy_2:say_line("/tht2069/")
        thunder_boy_2:wait_for_message()
    else
        thunder_boy_2:say_line("/tht2070/")
        thunder_boy_2:wait_for_message()
    end
    END_CUT_SCENE()
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.skip_serve_coffee = function(arg1) -- line 587
    kill_override()
    if manny:get_costume() == "msb_coffee.cos" then
        manny:pop_costume()
    end
    thunder_boy_1:stop_chore()
    thunder_boy_2:stop_chore()
    thunder_boy_1:set_time_scale(1)
    thunder_boy_2:set_time_scale(1)
    manny:play_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_activate_coffeepot, manny.base_costume)
    manny:setpos(0.126085, -0.476472, 0)
    manny:setrot(0, 317.476, 0)
    single_start_script(th.backstage_mumbling, th)
    single_start_script(th.backstage_idling, th)
end
th.climb_in = function(arg1) -- line 604
    local local1
    START_CUT_SCENE()
    th:switch_to_set()
    manny:put_in_set(th)
    manny:setpos(-0.53868401, -1.2299401, 0)
    manny:setrot(0, 78.479599, 0)
    if manny.fancy then
        local1 = "mcc_theater.cos"
    else
        local1 = "msb_theater.cos"
    end
    manny:push_costume(local1)
    manny:play_chore(msb_theater_enter_th, local1)
    manny:wait_for_chore(msb_theater_enter_th, local1)
    manny:blend(msb_rest, msb_theater_enter_th, 500, manny.base_costume, local1)
    sleep_for(500)
    manny:pop_costume()
    manny:walkto(-0.37628499, -1.23063, 0, 0, 285.67001, 0)
    END_CUT_SCENE()
end
th.climb_out = function(arg1) -- line 627
    local local1
    START_CUT_SCENE()
    manny:walkto(-0.53868401, -1.2299401, 0, 0, 78.479599, 0)
    manny:wait_for_actor()
    if manny.fancy then
        local1 = "mcc_theater.cos"
    else
        local1 = "msb_theater.cos"
    end
    manny:push_costume(local1)
    manny:fade_in_chore(msb_theater_exit_th, local1, 500)
    manny:wait_for_chore(msb_theater_exit_th, local1)
    manny:pop_costume()
    END_CUT_SCENE()
end
th.enter = function(arg1) -- line 651
    th:set_up_actors()
    if th.eavesdropped then
        box_off("eavesdrop_trigg")
    end
end
th.exit = function(arg1) -- line 658
    th.lever_actor:free()
    th.coffeepot_actor:free()
    thunder_boy_1:free()
    thunder_boy_2:free()
    stop_script(th.meet_the_thunder_boys)
    stop_script(th.backstage_mumbling)
    stop_script(th.backstage_idling)
end
th.personal_bubble = { }
th.personal_bubble.walkOut = function(arg1) -- line 677
    start_script(th.back_off)
end
th.eavesdrop_trigg = { }
th.eavesdrop_trigg.walkOut = function(arg1) -- line 684
    start_script(th.eavesdrop)
end
th.grinder = Object:create(th, "/thtx071/grinder", 0, 0, 0, { range = 0 })
th.grinder.use_pnt_x = 0.175
th.grinder.use_pnt_y = -0.048978701
th.grinder.use_pnt_z = 2.2
th.grinder.use_rot_x = 0
th.grinder.use_rot_y = 89.391602
th.grinder.use_rot_z = 0
th.grinder.wav = "getMetl.wav"
th.grinder:make_untouchable()
th.grinder.lookAt = function(arg1) -- line 699
    if manny.shot and not manny.healed then
        mf:use_grinder()
    elseif not arg1.has_bone then
        manny:say_line("/thma072/")
    else
        manny:say_line("/thma073/")
    end
end
th.grinder.use = function(arg1) -- line 711
    local local1, local2, local3
    if manny.shot and not manny.healed then
        mf:use_grinder()
    elseif arg1.has_bone and bowlsley_in_hiding then
        manny_grind()
    else
        START_CUT_SCENE()
        look_at_item_in_hand(TRUE)
        if arg1.has_bone or arg1.has_snow then
            if manny.costume_state == "reaper" then
                local1 = md_use_grinder
                local3 = md_activate_grinder_full
                local2 = md_hold_grinder
                start_sfx("grinder.IMU")
                manny:play_chore_looping(local1, manny.base_costume)
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                if arg1.has_bone or arg1.has_snow then
                    manny:stop_chore(local1, manny.base_costume)
                    manny:play_chore(local2, manny.base_costume)
                    manny:play_chore(local3, manny.base_costume)
                end
            elseif manny.fancy then
                manny:stop_chore(mcc_thunder_hold, "mcc_thunder.cos")
                if arg1.has_snow then
                    manny:stop_chore(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
                    manny:play_chore_looping(75, "mcc_thunder.cos")
                else
                    manny:stop_chore(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
                    manny:play_chore_looping(mcc_thunder_use_grinder, "mcc_thunder.cos")
                end
                manny:play_chore_looping(mcc_thunder_hold_grinder, "mcc_thunder.cos")
                start_sfx("grinder.IMU")
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                manny:stop_chore(mcc_thunder_use_grinder, "mcc_thunder.cos")
                manny:stop_chore(75, "mcc_thunder.cos")
                manny:stop_chore(mcc_thunder_hold_grinder, "mcc_thunder.cos")
                manny:play_chore_looping(mcc_thunder_hold, "mcc_thunder.cos")
                if arg1.has_snow then
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
                else
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
                end
            else
                if th.grinder.has_bone then
                    manny:stop_chore(msb_activate_grinder_full, manny.base_costume)
                else
                    manny:stop_chore(msb_activate_grinder_empty, manny.base_costume)
                end
                if arg1.has_snow then
                    local1 = 87
                else
                    local1 = msb_use_grinder
                end
                start_sfx("grinder.IMU")
                manny:play_chore_looping(local1, manny.base_costume)
                sleep_for(2000)
                manny:head_look_at(nil)
                fade_sfx("grinder.imu", 500)
                manny:stop_chore(local1, manny.base_costume)
                if th.grinder.has_bone then
                    manny:play_chore_looping(msb_activate_grinder_full, manny.base_costume)
                else
                    manny:play_chore_looping(msb_activate_grinder_empty, manny.base_costume)
                end
            end
        else
            start_sfx("grinder.IMU")
            sleep_for(2000)
            fade_sfx("grinder.imu", 500)
        end
        END_CUT_SCENE()
        if arg1.has_snow then
            arg1.has_snow = FALSE
        end
    end
end
th.grinder.default_response = th.grinder.use
th.snow_machine = Object:create(th, "/thtx074/snow machine", 0.025, -0.0289787, 2.46, { range = 0.60000002 })
th.snow_machine.use_pnt_x = 0.175
th.snow_machine.use_pnt_y = -0.048978701
th.snow_machine.use_pnt_z = 2.2
th.snow_machine.use_rot_x = 0
th.snow_machine.use_rot_y = 89.391602
th.snow_machine.use_rot_z = 0
th.snow_machine.has_grinder = TRUE
th.snow_machine.lookAt = function(arg1) -- line 811
    arg1.seen = TRUE
    manny:say_line("/thma075/")
    if arg1.has_grinder and not th.held_grinder then
        arg1:demo()
    end
end
th.snow_machine.demo = function(arg1) -- line 819
    START_CUT_SCENE()
    wait_for_message()
    manny:say_line("/thma076/")
    arg1:pickUp()
    manny:say_line("/moma053/")
    manny:wait_for_message()
    manny:setrot(0, 126.275, 0, TRUE)
    manny:wait_for_actor()
    manny:say_line("/syma159/")
    look_at_item_in_hand()
    arg1:use_grinder()
    END_CUT_SCENE()
end
th.snow_machine.pickUp = function(arg1) -- line 835
    if arg1.has_grinder then
        th.held_grinder = TRUE
        if manny.is_holding == th.coffee_pot then
            system.default_response("not now")
        else
            START_CUT_SCENE()
            th:current_setup(th_snocu)
            manny:walkto(0.217875, -0.064783, 2.156, 0, -272.067, 0)
            manny:head_look_at(nil)
            arg1.has_grinder = FALSE
            arg1.seen = TRUE
            th.grinder:get()
            if manny.fancy then
                if th.grinder.has_bone then
                    manny:play_chore(mcc_thunder_take_grinder_hand, "mcc_thunder.cos")
                else
                    manny:play_chore(mcc_thunder_take_grinder_no_hand, "mcc_thunder.cos")
                end
            elseif th.grinder.has_bone then
                manny:play_chore(msb_take_grinder_hand, "msb.cos")
            else
                manny:play_chore(msb_take_grinder_no_hand, "msb.cos")
            end
            sleep_for(850)
            start_sfx("thInsGrn.WAV")
            th.grinder_actor:set_visibility(FALSE)
            sleep_for(900)
            start_sfx("grdClLid.wav")
            manny:wait_for_chore()
            if manny.fancy then
                manny:stop_chore(mcc_thunder_take_grinder_hand, "mcc_thunder.cos")
                manny:stop_chore(mcc_thunder_take_grinder_no_hand, "mcc_thunder.cos")
            else
                manny:stop_chore(msb_take_grinder_no_hand, "msb.cos")
                manny:stop_chore(msb_take_grinder_hand, "msb.cos")
            end
            if manny.fancy then
                if th.grinder.has_bone then
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_full, manny.base_costume)
                    manny.hold_chore = mcc_thunder_takeout_grinder_full
                else
                    manny:play_chore_looping(mcc_thunder_takeout_grinder_empty, manny.base_costume)
                    manny.hold_chore = mcc_thunder_takeout_grinder_empty
                end
            elseif th.grinder.has_bone then
                manny:play_chore_looping(msb_activate_grinder_full, manny.base_costume)
                manny.hold_chore = msb_activate_grinder_full
            else
                manny:play_chore_looping(msb_activate_grinder_empty, manny.base_costume)
                manny.hold_chore = msb_activate_grinder_empty
            end
            manny:play_chore_looping(ms_hold, manny.base_costume)
            sleep_for(1000)
            manny.is_holding = th.grinder
            manny:head_look_at(arg1)
            END_CUT_SCENE()
        end
    else
        system.default_response("huge")
    end
end
th.snow_machine.use = function(arg1) -- line 902
    if arg1.has_grinder then
        START_CUT_SCENE()
        manny:walkto(0.217875, -0.064783, 2.156, 0, 82.7267, 0)
        manny:wait_for_actor()
        th:current_setup(th_snocu)
        if manny.fancy then
            manny:push_costume("mcc_snowblow.cos")
        else
            manny:push_costume("msb_snowblow.cos")
        end
        manny:play_chore(msb_snowblow_turn_switch)
        sleep_for(600)
        start_sfx("snoMach.IMU")
        if th.grinder.has_snow or th.grinder.has_bone then
            th:current_setup(th_stgws)
            if not th.snow_actor then
                th.snow_actor = Actor:create(nil, nil, nil, "snow")
            end
            th.snow_actor:put_in_set(th)
            th.snow_actor:set_costume("th_snow.cos")
            th.snow_actor:set_softimage_pos(0, 2, 0)
            th.snow_actor:setrot(0, 180, 0)
            th.snow_actor:play_chore_looping(0)
            sleep_for(5000)
            th:current_setup(th_snocu)
            th.snow_actor:free()
            if th.grinder.has_snow then
                th.grinder.has_snow = FALSE
            end
        else
            sleep_for(2000)
        end
        stop_sound("snoMach.IMU")
        manny:wait_for_chore(msb_snowblow_turn_switch)
        manny:pop_costume()
        END_CUT_SCENE()
        if not arg1.seen then
            arg1:lookAt()
        end
    else
        manny:say_line("/thma077/")
    end
end
th.snow_machine.use_grinder = function(arg1) -- line 947
    if th.grinder.has_bone then
        manny:say_line("/thma078/")
    else
        START_CUT_SCENE()
        manny:walkto(0.217875, -0.064783, 2.156, 0, 82.7267, 0)
        manny:wait_for_actor()
        th:current_setup(th_snocu)
        manny:head_look_at(nil)
        arg1.has_grinder = TRUE
        manny:stop_chore(msb_hold, manny.base_costume)
        if manny.fancy then
            manny:stop_chore(mcc_thunder_takeout_grinder_empty, "mcc_thunder.cos")
            manny:play_chore(mcc_thunder_return_grinder, "mcc_thunder.cos")
        else
            manny:stop_chore(msb_activate_grinder_empty, "msb.cos")
            manny:play_chore(msb_return_grinder, "msb.cos")
        end
        sleep_for(800)
        start_sfx("grdOpLid.wav")
        sleep_for(200)
        start_sfx("thInsGrn.WAV")
        sleep_for(374)
        th.grinder_actor:set_visibility(TRUE)
        manny:wait_for_chore()
        manny.hold_chore = nil
        manny.is_holding = nil
        if manny.fancy then
            manny:stop_chore(mcc_thunder_return_grinder, "mcc_thunder.cos")
        else
            manny:stop_chore(msb_return_grinder, "msb.cos")
        end
        th.grinder:free()
        sleep_for(200)
        manny:head_look_at(arg1)
        END_CUT_SCENE()
    end
end
th.snow_machine.use_hand = function(arg1) -- line 987
    if arg1.has_grinder then
        if th.grinder.has_snow then
            system.default_response("full")
        else
            START_CUT_SCENE()
            manny:walkto(0.196374, -0.0406213, 2.2, 0, 82.7267, 0)
            manny:wait_for_actor()
            nq.arm:free()
            th.grinder.has_bone = TRUE
            manny:head_look_at(nil)
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(manny.hold_chore, manny.base_costume)
            manny.hold_chore = nil
            if manny.fancy then
                manny:push_costume("mcc_snowblow.cos")
            else
                manny:push_costume("msb_snowblow.cos")
            end
            manny:play_chore(msb_snowblow_put_hand)
            manny:wait_for_chore(msb_snowblow_put_hand)
            manny:pop_costume()
            th.grinder_actor:default()
            manny:head_look_at(arg1)
            manny:say_line("/thma079/")
            END_CUT_SCENE()
        end
    else
        th.snow_machine:use()
    end
end
th.snow_machine.use_coffee_pot = function(arg1) -- line 1019
    manny:say_line("/thma080/")
end
th.snow_machine.use_sproutella = function(arg1) -- line 1023
    if arg1.has_grinder and th.grinder.has_bone then
        manny:say_line("/thma081/")
    else
        fi.sproutella:default_response(th.snow_machine)
    end
end
th.lever = Object:create(th, "/thtx082/lever", 0.075000003, 0.151021, 2.5699999, { range = 0.60000002 })
th.lever.use_pnt_x = 0.20997
th.lever.use_pnt_y = -0.032499999
th.lever.use_pnt_z = 2.2
th.lever.use_rot_x = 0
th.lever.use_rot_y = 90
th.lever.use_rot_z = 0
th.lever.lookAt = function(arg1) -- line 1041
    manny:say_line("/thma083/")
end
th.lever.use = function(arg1) -- line 1046
    if th.snow_machine.has_grinder then
        if manny.is_holding == th.coffee_pot then
            system.default_response("not now")
        elseif th.grinder.has_snow or th.grinder.has_bone then
            system.default_response("full")
        else
            th.grinder.has_snow = TRUE
            if manny:walkto_object(arg1) then
                START_CUT_SCENE()
                manny:head_look_at(nil)
                if manny.fancy then
                    manny:push_costume("mcc_snowblow.cos")
                else
                    manny:push_costume("msb_snowblow.cos")
                end
                th.lever_actor:set_visibility(FALSE)
                manny:play_chore(msb_snowblow_pull_chain)
                manny:wait_for_chore(msb_snowblow_pull_chain)
                manny:pop_costume()
                th.lever_actor:set_visibility(TRUE)
                END_CUT_SCENE()
            end
        end
    else
        soft_script()
        manny:say_line("/thma084/")
        wait_for_message()
        manny:say_line("/thma085/")
    end
end
th.lever.pickUp = function(arg1) -- line 1080
    if th.snow_machine.has_grinder then
        start_script(th.snow_machine.pickUp, th.snow_machine)
    else
        th.lever:use()
    end
end
th.ladder_bot = Object:create(th, "/thtx001/ladder", 0.70499998, -0.055, 0.75999999, { range = 1 })
th.ladder_bot.use_pnt_x = 0.46472499
th.ladder_bot.use_pnt_y = -0.040333699
th.ladder_bot.use_pnt_z = 0
th.ladder_bot.use_rot_x = 0
th.ladder_bot.use_rot_y = 258.875
th.ladder_bot.use_rot_z = 0
th.ladder_bot.lookAt = function(arg1) -- line 1099
    system.default_response("ladder")
end
th.ladder_bot.pickUp = function(arg1) -- line 1103
    system.default_response("attached")
end
th.ladder_bot.use = function(arg1) -- line 1107
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(th.ladder_top)
        if not manny.fancy then
            manny:play_chore(msb_lf_hand_on_obj, manny.base_costume)
            manny:wait_for_chore(msb_lf_hand_on_obj, manny.base_costume)
        else
            manny:play_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
            manny:wait_for_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
        end
        manny:put_at_object(th.ladder_top)
        th:current_setup(th_rftha)
        manny:head_look_at(th.ladder_top)
        if not manny.fancy then
            manny:stop_chore(msb_lf_hand_on_obj, manny.base_costume)
            manny:play_chore(msb_end_crouch, manny.base_costume)
            manny:wait_for_chore(msb_end_crouch, manny.base_costume)
            manny:stop_chore(msb_end_crouch, manny.base_costume)
        else
            manny:stop_chore(mcc_thunder_lf_hand_on_obj, manny.base_costume)
            manny:play_chore(mcc_thunder_end_crouch, manny.base_costume)
            manny:wait_for_chore(mcc_thunder_end_crouch, manny.base_costume)
            manny:stop_chore(mcc_thunder_end_crouch, manny.base_costume)
        end
        END_CUT_SCENE()
    end
end
th.ladder_bot.use_coffeepot = th.ladder_bot.use
th.ladder_top = Object:create(th, "/thtx002/top", 0.495107, -0.087508596, 2.536, { range = 1.2 })
th.ladder_top.use_pnt_x = 0.495
th.ladder_top.use_pnt_y = -0.064999998
th.ladder_top.use_pnt_z = 2.2
th.ladder_top.use_rot_x = 0
th.ladder_top.use_rot_y = 269.82401
th.ladder_top.use_rot_z = 0
th.ladder_top.lookAt = function(arg1) -- line 1149
    system.default_response("ladder")
end
th.ladder_top.pickUp = th.ladder_bot.pickUp
th.ladder_top.use = function(arg1) -- line 1155
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:head_look_at(th.ladder_bot)
        manny:play_chore(msb_reach_low, manny.base_costume)
        manny:play_chore(msb_lf_hand_on_obj, manny.base_costume)
        sleep_for(1000)
        th:current_setup(th_stgws)
        manny:stop_chore(msb_reach_low, manny.base_costume)
        manny:put_at_object(th.ladder_bot)
        manny:head_look_at(th.ladder_top)
        manny:wait_for_chore(msb_lf_hand_on_obj, manny.base_costume)
        manny:stop_chore(msb_lf_hand_on_obj, manny.base_costume)
        manny:play_chore(msb_lf_hand_off_obj, manny.base_costume)
        manny:wait_for_chore(msb_lf_hand_off_obj, manny.base_costume)
        manny:stop_chore(msb_lf_hand_off_obj, manny.base_costume)
        END_CUT_SCENE()
    end
end
th.ladder_top.use_coffeepot = th.ladder_top.use
th.coffee_pot = Object:create(th, "/thtx086/pot of coffee", -0.30750701, -2.2220199, 0.34999999, { range = 0.60000002 })
th.coffee_pot.string_name = "coffeepot"
th.coffee_pot.use_pnt_x = -0.44588
th.coffee_pot.use_pnt_y = -1.9993
th.coffee_pot.use_pnt_z = 0
th.coffee_pot.use_rot_x = 0
th.coffee_pot.use_rot_y = 225.011
th.coffee_pot.use_rot_z = 0
th.coffee_pot.wav = "getBotl.wav"
th.coffee_pot.can_put_away = FALSE
th.coffee_pot.lookAt = function(arg1) -- line 1191
    arg1.seen = TRUE
    manny:say_line("/thma087/")
end
th.coffee_pot.pickUp = function(arg1) -- line 1196
    local local1
    box_on("coffee_box")
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        if manny.fancy then
            local1 = "mcc_coffee.cos"
        else
            local1 = "msb_coffee.cos"
        end
        manny:push_costume(local1)
        th.coffeepot_actor:set_visibility(FALSE)
        manny:play_chore(msb_coffee_get_coffee, local1)
        sleep_for(1000)
        start_sfx("thPotUp.WAV")
        manny:wait_for_chore(msb_coffee_get_coffee, local1)
        manny:pop_costume()
        manny:setrot(0, 299.58401, 0)
        manny:generic_pickup(arg1)
        manny:walkto(-0.25503299, -1.8238699, 0)
        if not arg1.seen then
            look_at_item_in_hand()
        end
        manny:wait_for_actor()
        END_CUT_SCENE()
        box_off("grinder_box1")
        box_off("grinder_box2")
    end
    box_off("coffee_box")
    th.coffee_rack:make_touchable()
end
th.coffee_pot.use = function(arg1) -- line 1229
    if manny.is_holding == th.coffee_pot then
        manny:say_line("/thma088/")
    else
        th.coffee_pot:pickUp()
    end
end
th.coffee_pot.use_grinder = function(arg1) -- line 1237
    if th.grinder.has_bone or th.grinder.has_snow then
        manny:say_line("/thma089/")
    else
        th.grinder:default_response()
    end
end
th.coffee_pot.default_response = th.coffee_pot.use
th.coffee_pot.put_away = function(arg1) -- line 1247
    manny:say_line("/thma090/")
    return FALSE
end
th.coffee_rack = Object:create(th, "/thtx091/burners", -0.30750701, -2.2220199, 0.34999999, { range = 0.60000002 })
th.coffee_rack.use_pnt_x = -0.44588
th.coffee_rack.use_pnt_y = -1.9993
th.coffee_rack.use_pnt_z = 0
th.coffee_rack.use_rot_x = 0
th.coffee_rack.use_rot_y = 180.32401
th.coffee_rack.use_rot_z = 0
th.coffee_rack:make_untouchable()
th.coffee_rack.lookAt = function(arg1) -- line 1264
    manny:say_line("/thma092/")
end
th.coffee_rack.pickUp = th.coffee_rack.lookAt
th.coffee_rack.use_coffeepot = function(arg1) -- line 1270
    local local1
    box_on("coffee_box")
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny.is_holding = nil
        if manny.fancy then
            local1 = "mcc_coffee.cos"
            manny:stop_chore(mcc_thunder_hold, manny.base_costume)
            manny:stop_chore(mcc_thunder_activate_coffeepot, manny.base_costume)
        else
            local1 = "msb_coffee.cos"
            manny:stop_chore(msb_hold, manny.base_costume)
            manny:stop_chore(msb_activate_coffeepot, manny.base_costume)
        end
        manny:push_costume(local1)
        manny:setrot(0, 225, 0)
        manny:play_chore(msb_coffee_pot_to_burner, local1)
        sleep_for(900)
        start_sfx("thPotDn.WAV")
        manny:wait_for_chore(msb_coffee_pot_to_burner, local1)
        th.coffeepot_actor:default()
        manny:pop_costume()
        manny:setrot(0, 299.58401, 0)
        manny:walkto(-0.25503299, -1.8238699, 0)
        manny:wait_for_actor()
        END_CUT_SCENE()
        th.coffee_pot:free()
        th.coffee_pot:make_touchable()
        arg1:make_untouchable()
        box_on("grinder_box1")
        box_on("grinder_box2")
    end
    box_off("coffee_box")
end
th.dressing_room = Object:create(th, "/thtx093/dressing room", 1.35489, -1.1065201, 0.199967, { range = 0.89999998 })
th.dressing_room.use_pnt_x = 0.894467
th.dressing_room.use_pnt_y = -1.0750999
th.dressing_room.use_pnt_z = -0.28999999
th.dressing_room.use_rot_x = 0
th.dressing_room.use_rot_y = 275.81699
th.dressing_room.use_rot_z = 0
th.dressing_room.out_pnt_x = 1.3099999
th.dressing_room.out_pnt_y = -1.155
th.dressing_room.out_pnt_z = -0.28999999
th.dressing_room.out_rot_x = 0
th.dressing_room.out_rot_y = 248.313
th.dressing_room.out_rot_z = 0
th.dressing_room.lookAt = function(arg1) -- line 1324
    manny:say_line("/thma094/")
end
th.dressing_room.walkOut = function(arg1) -- line 1328
    start_script(th.crash_dressing_room)
end
th.thunderboy1 = Object:create(th, "/thtx095/Thunder Boy", 0.79973602, -0.57853103, 0.44, { range = 0.80000001 })
th.thunderboy1.use_pnt_x = 0.51973599
th.thunderboy1.use_pnt_y = -0.51853102
th.thunderboy1.use_pnt_z = 0
th.thunderboy1.use_rot_x = 0
th.thunderboy1.use_rot_y = -122.034
th.thunderboy1.use_rot_z = 0
th.thunderboy1.person = TRUE
th.thunderboy1.lookAt = function(arg1) -- line 1344
    START_CUT_SCENE()
    manny:say_line("/thma096/")
    manny:wait_for_message()
    thunder_boy_2:say_line("/tht2097/")
    thunder_boy_2:wait_for_message()
    END_CUT_SCENE()
end
th.thunderboy1.pickUp = function(arg1) -- line 1353
    manny:say_line("/thma098/")
end
th.thunderboy1.use = function(arg1) -- line 1357
    if not th.mocked then
        START_CUT_SCENE()
        manny:say_line("/thma099/")
        wait_for_message()
        END_CUT_SCENE()
    end
    start_script(th.back_off)
end
th.thunderboy1.use_coffeepot = function(arg1) -- line 1367
    start_script(th.serve_coffee)
end
th.thunderboy2 = Object:create(th, "/thtx100/Thunder Boy", 0.672732, -0.18703701, 0.456, { range = 0.80000001 })
th.thunderboy2.use_pnt_x = 0.51973599
th.thunderboy2.use_pnt_y = -0.51853102
th.thunderboy2.use_pnt_z = 0
th.thunderboy2.use_rot_x = 0
th.thunderboy2.use_rot_y = -122.034
th.thunderboy2.use_rot_z = 0
th.thunderboy2.parent = th.thunderboy1
th.thunderboys_from_above = Object:create(th, "/thtx101/Thunder Boys", 0.69005603, -0.58999997, 2.1800001, { range = 0.60000002 })
th.thunderboys_from_above.use_pnt_x = 0.477274
th.thunderboys_from_above.use_pnt_y = -0.1777813
th.thunderboys_from_above.use_pnt_z = 2.2
th.thunderboys_from_above.use_rot_x = 0
th.thunderboys_from_above.use_rot_y = 171.567
th.thunderboys_from_above.use_rot_z = 0
th.thunderboys_from_above.person = TRUE
th.thunderboys_from_above.lookAt = function(arg1) -- line 1394
    START_CUT_SCENE()
    manny:say_line("/thma102/")
    manny:wait_for_message()
    manny:say_line("/thma103/")
    END_CUT_SCENE()
end
th.thunderboys_from_above.use = function(arg1) -- line 1403
    START_CUT_SCENE()
    manny:say_line("/thma104/")
    manny:wait_for_message()
    thunder_boy_1:say_line("/tht1105/")
    thunder_boy_1:wait_for_message()
    thunder_boy_2:say_line("/tht2106/")
    thunder_boy_2:wait_for_message()
    thunder_boy_2:say_line("/tht2107/")
    END_CUT_SCENE()
end
th.thunderboys_from_above.use_grinder = function(arg1) -- line 1415
    local local1
    if th.grinder.has_bone or th.grinder.has_snow then
        local1 = TRUE
    end
    th.grinder:use()
    if local1 then
        START_CUT_SCENE()
        if not th.talked_dandruff then
            th.talked_dandruff = TRUE
            thunder_boy_1:say_line("/tht1108/")
            thunder_boy_1:wait_for_message()
            thunder_boy_2:say_line("/tht2109/")
            thunder_boy_2:wait_for_message()
            thunder_boy_1:say_line("/tht1110/")
            thunder_boy_1:wait_for_message()
        else
            thunder_boy_1:say_line("/tht1111/")
            thunder_boy_1:wait_for_message()
            thunder_boy_2:say_line("/tht2112/")
            thunder_boy_2:wait_for_message()
            thunder_boy_1:say_line("/tht1113/")
            thunder_boy_1:wait_for_message()
        end
        END_CUT_SCENE()
    end
end
th.thunderboys_from_above.use_coffeepot = function(arg1) -- line 1446
    if manny:walkto_object(arg1) then
        start_script(th.burn_thunderboy_burn)
    end
end
th.te_door = Object:create(th, "/thtx114/basement", -0.890948, -1.26624, 0.13, { range = 0.60000002 })
th.te_door.use_pnt_x = -0.53868401
th.te_door.use_pnt_y = -1.2299401
th.te_door.use_pnt_z = 0
th.te_door.use_rot_x = 0
th.te_door.use_rot_y = 78.479599
th.te_door.use_rot_z = 0
th.te_door.out_pnt_x = -0.53868401
th.te_door.out_pnt_y = -1.2299401
th.te_door.out_pnt_z = 0
th.te_door.out_rot_x = 0
th.te_door.out_rot_y = 78.479599
th.te_door.out_rot_z = 0
th.te_door.walkOut = function(arg1) -- line 1473
    local local1
    if manny.is_holding == th.coffee_pot then
        manny:say_line("/thma115/")
    else
        START_CUT_SCENE()
        th:climb_out()
        te:switch_to_set()
        manny:put_in_set(te)
        local1 = te.th_ladder.base
        manny:setpos(local1.use_pnt_x, local1.use_pnt_y, local1.use_pnt_z)
        manny:push_costume(manny.ladder_costume)
        manny:play_chore(ma_ladder_generic_jump_off, manny.ladder_costume)
        manny:wait_for_chore(ma_ladder_generic_jump_off, manny.ladder_costume)
        manny:pop_costume()
        manny:walkto(-4.9533801, -0.384285, 0, 0, 284.59399, 0)
        END_CUT_SCENE()
    end
end
th.te_door.lookAt = function(arg1) -- line 1494
    manny:say_line("/thma116/")
end
th.te_door.use = th.te_door.walkOut
CheckFirstTime("vd.lua")
vd = Set:create("vd.set", "vault door", { vd_top = 0, vd_safex = 1, vd_safex1 = 1, vd_safcu = 2 })
vd.shrinkable = 0.04
vd.wheel_vol = 30
dofile("mn_open_safe.lua")
dofile("mn_scythe_door.lua")
vd.meches_muffled_cries = function() -- line 19
    while 1 do
        meche:say_line(pick_one_of({ "/vdmc001/", "/vdmc002/", "/vdmc003/", "/vdmc004/", "/vdmc005/", "/vdmc006/", "/vdmc007/", "/vdmc008/", "/vdmc009/", "/vdmc010/", "/vdmc011/", "/vdmc012/", "/vdmc013/", "/vdmc014/", "/vdmc015/", "/vdmc016/", "/vdmc017/", "/vdmc018/", "/vdmc019/" }), { background = TRUE, skip_log = TRUE })
        sleep_for(5000)
    end
end
vd.scythe_fall = function() -- line 45
    local local1 = 0
    local local2 = { }
    local local3 = start_script(vd.scythe_sideways)
    start_sfx("scythfal.wav")
    repeat
        local1 = local1 + PerSecond(5)
        if local1 > 90 then
            local1 = 90
        end
        local2 = door_scythe:getrot()
        door_scythe:setrot(local2.x, local2.y, local2.z - local1)
        break_here()
        local2 = door_scythe:getrot()
    until local2.z <= -90
    door_scythe:setrot(local2.x, local2.y, -90)
    wait_for_script(local3)
end
vd.scythe_sideways = function() -- line 65
    local local1 = { }
    local local2 = 0.0099999998
    repeat
        local1 = door_scythe:getpos()
        local2 = local2 + PerSecond(0.0049999999)
        door_scythe:setpos(local1.x + local2, local1.y, local1.z)
        break_here()
    until local1.x >= 0.223141
    door_scythe:setpos(0.223141, local1.y, local1.z)
end
vd.open_safe = function() -- line 77
    local local1
    cur_puzzle_state[39] = TRUE
    START_CUT_SCENE()
    manny:play_chore(ms_hand_on_obj, manny.base_costume)
    manny:wait_for_chore()
    vd.handle:play_chore(2)
    manny:play_chore(ms_hand_off_obj, manny.base_costume)
    vd.handle:wait_for_chore()
    vd.handle:play_chore(0)
    vd.door_jam:play_chore(1)
    vd.safe_door:free()
    StartMovie("vd.snm", nil, 233, 119)
    local1 = start_script(vd.scythe_fall)
    wait_for_movie()
    music_state:set_sequence(seqOpenVault)
    vd.door_jam:play_chore(2)
    vd.door_open = TRUE
    music_state:update()
    wait_for_script(local1)
    manny:walkto(-0.105456, 0.34172001, 0, 0, -11.4314, 0)
    manny:play_chore(50, manny.base_costume)
    mn2_event = FALSE
    repeat
        break_here()
    until mn2_event
    door_scythe:free()
    mo.scythe:get()
    MakeSectorActive("scythe_here", TRUE)
    vd.tumblers.secured = FALSE
    manny:wait_for_chore()
    manny.is_holding = mo.scythe
    open_inventory(TRUE, TRUE)
    vd.tumblers.name = "tumblers"
    vd.tumblers:make_untouchable()
    vd.wheel:make_untouchable()
    vd.handle:make_untouchable()
    vd.vo_door:make_touchable()
    MakeSectorActive("safe_passage", TRUE)
    if not vd.cracked_safe then
        vd.cracked_safe = TRUE
        wait_for_message()
        manny:say_line("/vdma020/")
        wait_for_message()
        manny:say_line("/vdma021/")
        wait_for_message()
        sleep_for(750)
        manny:say_line("/vdma022/")
        manny:tilt_head_gesture()
    end
    END_CUT_SCENE()
end
system.tumblerTemplate = { name = "<unnamed>", actor = nil, pos = nil, rot = nil, lock = nil, lock_val = nil, lock_pin = nil }
Tumbler = system.tumblerTemplate
Tumbler.create = function(arg1, arg2, arg3) -- line 148
    local local1 = { }
    local1.parent = Tumbler
    local1.name = arg2
    local1.actor = Actor:create(nil, nil, nil, arg2)
    local1.rot = rndint(0, 359)
    local1.lock_val = local1.rot
    local1.pos = arg3
    local1.lock = FALSE
    local1.lock_pin = rndint(0, 359)
    return local1
end
Tumbler.set_up_actor = function(arg1) -- line 164
    arg1.actor:set_costume("tumbler.cos")
    arg1.actor:play_chore_looping(0)
    arg1.actor:put_in_set(vd)
    arg1.actor:setrot(0, arg1.rot, 0)
    arg1.actor:set_softimage_pos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    arg1:reset_lock_value()
    start_script(arg1.monitor_rot, arg1)
    start_script(arg1.make_noise, arg1)
end
Tumbler.monitor_rot = function(arg1) -- line 175
    while 1 do
        arg1.actor:setrot(0, arg1.rot, 0)
        break_here()
    end
end
Tumbler.make_noise = function(arg1) -- line 182
    local local1 = { }
    local local2, local3
    while 1 do
        local1 = arg1.actor:getrot()
        if abs(arg1.rot - local1.y) > 15 then
            if vd:current_setup() == vd_safcu then
                local3 = rndint(50, 80)
            else
                local3 = rndint(10, 40)
            end
            local2 = pick_one_of({ "vdTmbl1.wav", "vdTmbl2.wav", "vdTmbl3.wav", "vdTmbl4.wav" })
            start_sfx(local2, IM_LOW_PRIORITY, local3)
            wait_for_sound(local2)
        else
            break_here()
        end
    end
end
Tumbler.reset_lock_value = function(arg1) -- line 204
    local local1 = arg1.actor:get_positive_rot()
    arg1.lock = FALSE
    arg1.lock_val = local1.y + arg1.lock_pin
    if arg1.lock_val >= 360 then
        arg1.lock_val = arg1.lock_val - 360
    end
end
Tumbler.scramble = function(arg1, arg2) -- line 217
    local local1 = 100
    local local2 = rnd()
    local local3 = { }
    repeat
        if local2 then
            arg1.rot = arg1.rot - local1
        else
            arg1.rot = arg1.rot + local1
        end
        local1 = local1 - PerSecond(15)
        break_here()
    until local1 <= 0
    local3 = arg1.actor:get_positive_rot()
    arg1.rot = floor(local3.y)
    arg1:reset_lock_value()
    if arg2 then
        arg1.lock = TRUE
    end
end
Tumbler.free = function(arg1) -- line 238
    arg1.actor:free()
    stop_script(arg1.monitor_rot)
    stop_script(arg1.make_noise)
end
system.safeTemplate = { name = "<unnamed>", tumblers = nil, wheel = nil, current_setting = nil, direction = nil }
Safe = system.safeTemplate
Safe.create = function(arg1, arg2) -- line 252
    local local1 = { }
    local1.parent = Safe
    local1.name = arg2
    local1.tumblers = { }
    local1.wheel = { }
    local1.current_setting = 0
    local1.direction = CLOCKWISE
    local1.tumblers[1] = Tumbler:create("t1", { x = 1.1426001, y = 3.0685, z = -6.4158001 })
    local1.tumblers[2] = Tumbler:create("t2", { x = 1.1426001, y = 3.2776999, z = -6.4158001 })
    local1.tumblers[3] = Tumbler:create("t3", { x = 1.1426001, y = 3.4872999, z = -6.4158001 })
    local1.tumblers[4] = Tumbler:create("t4", { x = 1.1426001, y = 3.7004001, z = -6.4158001 })
    local1.wheel = Actor:create(nil, nil, nil, "wheel")
    return local1
end
Safe.set_up_actors = function(arg1) -- line 274
    arg1.tumblers[1]:set_up_actor()
    arg1.tumblers[2]:set_up_actor()
    arg1.tumblers[3]:set_up_actor()
    arg1.tumblers[4]:set_up_actor()
    if meche.locked_up or cur_puzzle_state[41] == TRUE then
        arg1.wheel:set_costume("vault_wheel.cos")
        arg1.wheel:put_in_set(vd)
        arg1.wheel:set_softimage_pos(-0.6378, 3.4855, -6.3778)
        arg1.wheel:setrot(0, 180, 0)
    end
    arg1.tumblers[1].lock = TRUE
    start_script(arg1.monitor_lock, arg1)
    start_script(arg1.monitor_tumblers, arg1)
end
CLOCKWISE = 0
C_CLOCKWISE = 1
Safe.monitor_lock = function(arg1) -- line 298
    arg1.direction = CLOCKWISE
    while 1 do
        while arg1.direction == CLOCKWISE do
            break_here()
        end
        arg1.tumblers[2]:reset_lock_value()
        arg1.tumblers[3]:reset_lock_value()
        arg1.tumblers[4]:reset_lock_value()
        while arg1.direction == C_CLOCKWISE do
            break_here()
        end
        arg1.tumblers[2]:reset_lock_value()
        arg1.tumblers[3]:reset_lock_value()
        arg1.tumblers[4]:reset_lock_value()
    end
end
Safe.monitor_tumblers = function(arg1) -- line 320
    while 1 do
        if arg1.tumblers[1].rot >= 248 and arg1.tumblers[1].rot <= 290 and (arg1.tumblers[2].rot >= 248 and arg1.tumblers[2].rot <= 290) and (arg1.tumblers[3].rot >= 248 and arg1.tumblers[3].rot <= 290) and (arg1.tumblers[4].rot >= 248 and arg1.tumblers[4].rot <= 290) then
            vd.tumblers.alligned = TRUE
        else
            vd.tumblers.alligned = FALSE
        end
        break_here()
    end
end
Safe.scramble = function(arg1) -- line 335
    start_script(arg1.tumblers[1].scramble, arg1.tumblers[1], TRUE)
    start_script(arg1.tumblers[2].scramble, arg1.tumblers[2])
    start_script(arg1.tumblers[3].scramble, arg1.tumblers[3])
    arg1.tumblers[4]:scramble()
end
Safe.spin_tumblers_right = function(arg1) -- line 342
    if not find_script(arg1.scramble) then
        if arg1.tumblers[1].lock then
            arg1.tumblers[1].rot = arg1.tumblers[1].rot + 1
            if arg1.tumblers[1].rot == 360 then
                arg1.tumblers[1].rot = 0
            end
            if arg1.tumblers[1].rot == arg1.tumblers[2].lock_val and arg1.tumblers[2].lock == FALSE then
                arg1.tumblers[2].lock = TRUE
            end
        end
        if arg1.tumblers[2].lock then
            arg1.tumblers[2].rot = arg1.tumblers[2].rot + 1
            if arg1.tumblers[2].rot == 360 then
                arg1.tumblers[2].rot = 0
            end
            if arg1.tumblers[2].rot == arg1.tumblers[3].lock_val and arg1.tumblers[3].lock == FALSE then
                arg1.tumblers[3].lock = TRUE
            end
        end
        if arg1.tumblers[3].lock then
            arg1.tumblers[3].rot = arg1.tumblers[3].rot + 1
            if arg1.tumblers[3].rot == 360 then
                arg1.tumblers[3].rot = 0
            end
            if arg1.tumblers[3].rot == arg1.tumblers[4].lock_val and arg1.tumblers[4].lock == FALSE then
                arg1.tumblers[4].lock = TRUE
            end
        end
        if arg1.tumblers[4].lock then
            arg1.tumblers[4].rot = arg1.tumblers[4].rot + 1
            if arg1.tumblers[4].rot == 360 then
                arg1.tumblers[4].rot = 0
            end
        end
    end
end
Safe.spin_tumblers_left = function(arg1) -- line 386
    if not find_script(arg1.scramble) then
        if arg1.tumblers[1].lock then
            arg1.tumblers[1].rot = arg1.tumblers[1].rot - 1
            if arg1.tumblers[1].rot == -1 then
                arg1.tumblers[1].rot = 359
            end
            if arg1.tumblers[1].rot == arg1.tumblers[2].lock_val and arg1.tumblers[2].lock == FALSE then
                arg1.tumblers[2].lock = TRUE
            end
        end
        if arg1.tumblers[2].lock then
            arg1.tumblers[2].rot = arg1.tumblers[2].rot - 1
            if arg1.tumblers[2].rot == -1 then
                arg1.tumblers[2].rot = 359
            end
            if arg1.tumblers[2].rot == arg1.tumblers[3].lock_val and arg1.tumblers[3].lock == FALSE then
                arg1.tumblers[3].lock = TRUE
            end
        end
        if arg1.tumblers[3].lock then
            arg1.tumblers[3].rot = arg1.tumblers[3].rot - 1
            if arg1.tumblers[3].rot == -1 then
                arg1.tumblers[3].rot = 359
            end
            if arg1.tumblers[3].rot == arg1.tumblers[4].lock_val and arg1.tumblers[4].lock == FALSE then
                arg1.tumblers[4].lock = TRUE
            end
        end
        if arg1.tumblers[4].lock then
            arg1.tumblers[4].rot = arg1.tumblers[4].rot - 1
            if arg1.tumblers[4].rot == -1 then
                arg1.tumblers[4].rot = 359
            end
        end
    end
end
vd.play_wheel_sfx = function() -- line 430
    if not sound_playing("vdWeel1.wav") or sound_playing("vdWeel2.wav") or sound_playing("vdWeel3.wav") or sound_playing("vdWeel4.wav") then
        sfx = pick_from_nonweighted_table({ "vdWeel1.wav", "vdWeel2.wav", "vdWeel3.wav", "vdWeel4.wav" })
        start_sfx(pick_one_of({ "vdWeel1.wav", "vdWeel2.wav", "vdWeel3.wav", "vdWeel4.wav" }), IM_MED_PRIORITY, vd.wheel_vol)
    end
end
Safe.spin_left = function(arg1, arg2) -- line 439
    local local1
    arg1.direction = C_CLOCKWISE
    vd.play_wheel_sfx()
    arg1.current_setting = arg1.current_setting + arg2
    if arg1.current_setting >= 360 then
        arg1.current_setting = arg1.current_setting - 360
    end
    arg1.wheel:setrot(0, 180, arg1.current_setting)
end
Safe.spin_right = function(arg1, arg2) -- line 450
    local local1
    arg1.direction = CLOCKWISE
    vd.play_wheel_sfx()
    arg1.current_setting = arg1.current_setting - arg2
    if arg1.current_setting <= 0 then
        arg1.current_setting = arg1.current_setting + 360
    end
    arg1.wheel:setrot(0, 180, arg1.current_setting)
end
Safe.free = function(arg1) -- line 463
    arg1.tumblers[1]:free()
    arg1.tumblers[2]:free()
    arg1.tumblers[3]:free()
    arg1.tumblers[4]:free()
    arg1.wheel:free()
    stop_script(arg1.monitor_lock)
    stop_script(arg1.monitor_tumblers)
end
vd.hide_actors = function() -- line 476
    vd.safe_door.tumblers[1].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[2].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[3].actor:set_visibility(FALSE)
    vd.safe_door.tumblers[4].actor:set_visibility(FALSE)
    while not vd.door_busted do
        if vd.cameraChange then
            if vd:current_setup() == vd_safex then
                vd.safe_door.tumblers[1].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[2].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[3].actor:set_visibility(FALSE)
                vd.safe_door.tumblers[4].actor:set_visibility(FALSE)
            else
                vd.safe_door.tumblers[1].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[2].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[3].actor:set_visibility(TRUE)
                vd.safe_door.tumblers[4].actor:set_visibility(TRUE)
            end
        end
        break_here()
    end
    vd.safe_door.tumblers[1].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[2].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[3].actor:set_visibility(TRUE)
    vd.safe_door.tumblers[4].actor:set_visibility(TRUE)
end
vd.safe_fun = function() -- line 503
    START_CUT_SCENE()
    if vd.door_busted then
        vd:current_setup(vd_safcu)
        manny:walkto(-0.0345833, 0.276218, 0, 0, 10.5, 0)
        manny:wait_for_actor()
        manny:set_rest_chore(-1)
        manny:play_chore(18, manny.base_costume)
        manny:wait_for_chore()
    else
        manny:walkto(0.00651957, 0.218281, 0, 0, 0, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_open_safe.cos")
        manny:play_chore(mn_open_safe_hand_on_wheel)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = vd.buttonHandler
    END_CUT_SCENE()
end
vd.turn_clockwise = function() -- line 526
    local local1 = 5
    local local2 = 0
    START_CUT_SCENE()
    if vd.door_busted then
        manny:play_chore_looping(49, manny.base_costume)
        while get_generic_control_state("TURN_RIGHT") do
            vd.safe_door:spin_right(local1)
            local2 = 0
            repeat
                vd.safe_door:spin_tumblers_right()
                local2 = local2 + 1
            until local2 == local1
            local1 = local1 + 3
            if local1 >= 20 then
                local1 = 20
            end
            vd.play_wheel_sfx()
            break_here()
        end
        manny:set_chore_looping(49, FALSE, manny.base_costume)
        manny:wait_for_chore(49, manny.base_costume)
    else
        manny:play_chore(mn_open_safe_turn_right)
        start_script(vd.safe_door.spin_right, vd.safe_door, 45)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    END_CUT_SCENE()
end
vd.turn_counterclockwise = function() -- line 561
    local local1 = 5
    local local2
    START_CUT_SCENE()
    if vd.door_busted then
        manny:play_chore_looping(49, manny.base_costume)
        while get_generic_control_state("TURN_LEFT") do
            vd.safe_door:spin_left(local1)
            local2 = 0
            repeat
                vd.safe_door:spin_tumblers_left()
                local2 = local2 + 1
            until local2 == local1
            local1 = local1 + 3
            if local1 >= 20 then
                local1 = 20
            end
            vd.play_wheel_sfx()
            break_here()
        end
        manny:set_chore_looping(49, FALSE, manny.base_costume)
        manny:wait_for_chore(49, manny.base_costume)
    else
        manny:play_chore(mn_open_safe_turn_left)
        start_script(vd.safe_door.spin_right, vd.safe_door, 45)
        manny:wait_for_chore()
        manny:play_chore(mn_open_safe_hold_wheel)
    end
    END_CUT_SCENE()
end
vd.back_off = function() -- line 596
    START_CUT_SCENE()
    if vd.door_busted then
        vd:current_setup(vd_safex)
        manny:stop_chore(mn2_use, manny.base_costume)
        manny:stop_chore(mn2_hand_on_obj, manny.base_costume)
        manny:play_chore(mn2_hand_off_obj, manny.base_costume)
        manny:wait_for_chore()
        manny:stop_chore(mn2_hand_off_obj, manny.base_costume)
        manny:set_rest_chore(ms_rest, "mn2.cos")
    else
        manny:play_chore(mn_open_safe_done_turn)
        manny:wait_for_chore()
        manny:pop_costume()
    end
    END_CUT_SCENE()
    system.buttonHandler = inventory_save_handler
end
vd.buttonHandler = function(arg1, arg2, arg3) -- line 616
    if arg1 == EKEY and controlKeyDown and arg2 then
        start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.TURN_RIGHT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.turn_clockwise)
    elseif control_map.TURN_LEFT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.turn_counterclockwise)
    elseif control_map.OVERRIDE[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.back_off)
    elseif control_map.MOVE_BACKWARD[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(vd.back_off)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
vd.update_music_state = function(arg1) -- line 638
    if meche.locked_up and not vd.door_open then
        return stateVD
    else
        return stateFH
    end
end
vd.enter = function(arg1) -- line 648
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_1_lock.bm")
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_handle.bm")
    NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_safe_open.bm")
    vd.door_jam:set_object_state("vd_jam.cos")
    vd.handle:set_object_state("vd_handle.cos")
    if not vd.door_open then
        if vd.door_busted then
            vd.door_jam:play_chore(0)
        else
            vd.door_jam:play_chore(1)
        end
        vd.handle:play_chore(0)
        if not vd.safe_door then
            vd.safe_door = Safe:create("safe")
        end
        vd.safe_door:set_up_actors()
        start_script(vd.hide_actors)
    else
        vd.door_jam:play_chore(2)
        vd.handle:play_chore(0)
    end
    MakeSectorActive("safe_passage", FALSE)
    if meche.locked_up and not meche_freed then
        vd.heard_meche = TRUE
        if vd.door_open then
            vd.wheel:make_untouchable()
            vd.handle:make_untouchable()
            vd.door_jam:make_untouchable()
            MakeSectorActive("safe_passage", TRUE)
        elseif vd.door_busted then
            vd.wheel:make_touchable()
            vd.handle:make_touchable()
            vd.door_jam:make_untouchable()
            vd.tumblers:make_touchable()
        else
            start_script(vd.meches_muffled_cries)
            vd.wheel:make_touchable()
            vd.handle:make_touchable()
            vd.door_jam:make_touchable()
        end
    elseif cur_puzzle_state[41] == TRUE then
        vd.wheel:make_touchable()
        vd.handle:make_touchable()
        vd.door_jam:make_untouchable()
        vd.tumblers:make_touchable()
    else
        MakeSectorActive("vd_safcu", FALSE)
        vd.wheel:make_untouchable()
        vd.handle:make_untouchable()
        vd.handle:make_untouchable()
        NewObjectState(vd_safex, OBJSTATE_UNDERLAY, "vd_1_wall.bm")
        vd.handle:set_object_state("vd_wall.cos")
        vd.handle:play_chore(0)
    end
    if vd.tumblers.secured then
        MakeSectorActive("scythe_here", FALSE)
        door_scythe:set_costume("scythe_scythe_door.cos")
        door_scythe:put_in_set(vd)
        door_scythe:setpos(0.0055, 0.33717, 0)
        door_scythe:setrot(0, -6.211, 0)
        door_scythe:play_chore_looping(0)
    end
end
vd.exit = function(arg1) -- line 721
    vd.safe_door:free()
    if door_scythe then
        door_scythe:free()
    end
    stop_script(vd.hide_actors)
    stop_script(vd.meches_muffled_cries)
end
vd.wheel = Object:create(vd, "/vdtx023/wheel", -0.071915798, 0.65689498, 0.34, { range = 0.60000002 })
vd.wheel.use_pnt_x = -0.092005402
vd.wheel.use_pnt_y = 0.44999999
vd.wheel.use_pnt_z = 0
vd.wheel.use_rot_x = 0
vd.wheel.use_rot_y = 8.8126001
vd.wheel.use_rot_z = 0
vd.wheel:make_untouchable()
vd.wheel.lookAt = function(arg1) -- line 745
    soft_script()
    manny:say_line("/vdma024/")
    manny:wait_for_message()
    manny:say_line("/vdma025/")
end
vd.wheel.use = function(arg1) -- line 752
    vd.wheel.tried = TRUE
    if meche_freed then
        system.default_response("not now")
    elseif vd.door_busted then
        if vd.tumblers.alligned then
            if vd.tumblers.secured then
                manny:walkto(0.00651957, 0.218281, 0, 0, 0, 0)
                manny:wait_for_actor()
                manny:push_costume("mn_open_safe.cos")
                manny:play_chore(mn_open_safe_hand_on_wheel)
                manny:wait_for_chore()
                manny:play_chore(mn_open_safe_hold_wheel)
                manny:say_line("/vdma026/")
                wait_for_message()
                manny:play_chore(mn_open_safe_done_turn)
                manny:wait_for_chore()
                manny:pop_costume()
                manny:say_line("/vdma027/")
            else
                start_script(vd.safe_fun)
            end
        else
            start_script(vd.safe_fun)
        end
    else
        start_script(vd.safe_fun)
    end
end
vd.wheel.pickUp = vd.wheel.use
vd.wheel.use_chisel = function(arg1) -- line 784
    manny:say_line("/vdma028/")
end
vd.handle = Object:create(vd, "/vdtx029/handle", -0.320117, 0.57889301, 0.38, { range = 0.60000002 })
vd.handle.use_pnt_x = -0.125559
vd.handle.use_pnt_y = 0.33589101
vd.handle.use_pnt_z = 0
vd.handle.use_rot_x = 0
vd.handle.use_rot_y = 416.95801
vd.handle.use_rot_z = 0
vd.handle:make_untouchable()
vd.handle.lookAt = function(arg1) -- line 800
    manny:say_line("/vdma030/")
end
vd.handle.pickUp = function(arg1) -- line 804
    system.default_response("attached")
end
vd.handle.use = function(arg1) -- line 808
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:set_rest_chore(-1)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        if vd.tumblers.alligned then
            if vd.tumblers.secured then
                vd.open_safe()
            else
                manny:play_chore(ms_hand_on_obj, manny.base_costume)
                manny:wait_for_chore()
                arg1:play_chore(1)
                start_script(vd.safe_door.scramble, vd.safe_door)
                manny:play_chore(ms_hand_off_obj, manny.base_costume)
                manny:wait_for_chore()
                manny:say_line("/vdma031/")
                wait_for_message()
                manny:say_line("/vdma032/")
            end
        else
            manny:play_chore(ms_hand_on_obj, manny.base_costume)
            manny:wait_for_chore()
            arg1:play_chore(1)
            if not vd.tumblers_secured then
                start_script(vd.safe_door.scramble, vd.safe_door)
            end
            manny:play_chore(ms_hand_off_obj, manny.base_costume)
            manny:wait_for_chore()
            if vd.wheel.tried then
                manny:say_line("/vdma033/")
            else
                vd.wheel.tried = TRUE
                vd.wheel:lookAt()
            end
        end
        manny:set_rest_chore(ms_rest, manny.base_costume)
        END_CUT_SCENE()
    end
end
vd.handle.use_chisel = function(arg1) -- line 851
    manny:say_line("/vdma034/")
end
vd.door_jam = Object:create(vd, "/vdtx035/door jam", 0.127995, 0.63, 0.34999999, { range = 0.60000002 })
vd.door_jam.use_pnt_x = 0.057923201
vd.door_jam.use_pnt_y = 0.449918
vd.door_jam.use_pnt_z = 0
vd.door_jam.use_rot_x = 0
vd.door_jam.use_rot_y = -12.8311
vd.door_jam.use_rot_z = 0
vd.door_jam:make_untouchable()
vd.door_jam.lookAt = function(arg1) -- line 867
    soft_script()
    manny:say_line("/vdma036/")
    wait_for_message()
    manny:say_line("/vdma037/")
end
vd.door_jam.use = vd.door_jam.lookAt
vd.door_jam.use_scythe = function(arg1) -- line 876
    soft_script()
    manny:say_line("/vdma038/")
end
vd.door_jam.use_hammer = function(arg1) -- line 881
    manny:say_line("/vdma039/")
end
vd.door_jam.use_chisel = function(arg1) -- line 885
    START_CUT_SCENE()
    vd.door_jam:make_untouchable()
    vd.tumblers:make_touchable()
    manny:walkto(-0.0135804, 0.218281, 0, 0, 0, 0)
    manny:wait_for_actor()
    manny:push_costume("mn_open_safe.cos")
    manny:play_chore(mn_open_safe_drill_prep)
    manny:wait_for_chore()
    manny:stop_chore(mn_open_safe_drill_prep)
    manny:play_chore(mn_open_safe_drill)
    sleep_for(3000)
    StartMovie("safecrak.snm", nil, 152, 0)
    sleep_for(600)
    manny:say_line("/vdma040/")
    manny:stop_chore(mn_open_safe_drill)
    manny:play_chore(mn_open_safe_drill_done)
    wait_for_movie()
    arg1:play_chore(0)
    vd.door_busted = TRUE
    manny:wait_for_chore()
    manny:pop_costume()
    wait_for_message()
    manny:say_line("/vdma041/")
    wait_for_message()
    manny:say_line("/vdma042/")
    END_CUT_SCENE()
    stop_script(vd.meches_muffled_cries)
end
vd.tumblers = Object:create(vd, "/vdtx043/tumblers", 0.127995, 0.63, 0.34999999, { range = 0.60000002 })
vd.tumblers.use_pnt_x = 0.057923201
vd.tumblers.use_pnt_y = 0.449918
vd.tumblers.use_pnt_z = 0
vd.tumblers.use_rot_x = 0
vd.tumblers.use_rot_y = -12.8311
vd.tumblers.use_rot_z = 0
vd.tumblers:make_untouchable()
vd.tumblers.lookAt = function(arg1) -- line 927
    if vd.tumblers.alligned then
        if vd.tumblers.secured then
            manny:say_line("/vdma044/")
        else
            manny:say_line("/vdma045/")
        end
    else
        manny:say_line("/vdma046/")
    end
end
vd.tumblers.use_chisel = function(arg1) -- line 939
    if vd.tumblers.secured or vd.door_open then
        system.default_response("not now")
    elseif meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:walkto(-0.0135804, 0.218281, 0, 0, 0, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_open_safe.cos")
        manny:play_chore(mn_open_safe_drill_prep)
        manny:wait_for_chore()
        manny:stop_chore(mn_open_safe_drill_prep)
        manny:play_chore(mn_open_safe_drill)
        sleep_for(500)
        start_script(vd.safe_door.scramble, vd.safe_door)
        sleep_for(3100)
        manny:stop_chore(mn_open_safe_drill)
        manny:play_chore(mn_open_safe_drill_done)
        manny:wait_for_chore()
        manny:pop_costume()
        manny:say_line("/vdma047/")
        END_CUT_SCENE()
    end
end
vd.tumblers.use = function(arg1) -- line 967
    if arg1.secured then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        manny:say_line("/vdma048/")
        wait_for_message()
        END_CUT_SCENE()
        start_script(Sentence, "use", vd_wheel)
    end
end
vd.tumblers.pickUp = function(arg1) -- line 979
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        if vd.tumblers.secured then
            manny:walkto(0.0055, 0.33717, 0, 0, -6.211, 0)
            manny:wait_for_actor()
            manny:push_costume("mn_scythe_door.cos")
            door_scythe:free()
            manny:play_chore(mn_scythe_door_scythe_out_door)
            manny:wait_for_chore()
            mo.scythe:get()
            manny.is_holding = mo.scythe
            manny.hold_chore = ms_hold_scythe
            manny:play_chore_looping(mn2_hold_scythe, manny.base_costume)
            vd.tumblers.secured = FALSE
            arg1.name = "tumblers"
            manny:pop_costume()
            MakeSectorActive("scythe_here", TRUE)
        else
            manny:say_line("/vdma049/")
        end
        END_CUT_SCENE()
    end
end
vd.tumblers.use_scythe = function(arg1) -- line 1006
    if meche_freed then
        system.default_response("not now")
    else
        START_CUT_SCENE()
        manny:walkto(0.0055, 0.33717, 0, 0, -6.211, 0)
        manny:wait_for_actor()
        manny:push_costume("mn_scythe_door.cos")
        manny:play_chore(mn_scythe_door_scythe_in_door)
        manny:wait_for_chore()
        if vd.tumblers.alligned then
            mo.scythe:free()
            manny.is_holding = nil
            manny:stop_chore(manny.hold_chore, manny.base_costume)
            manny.hold_chore = nil
            vd.tumblers.secured = TRUE
            arg1.name = "scythe in tumblers"
            if not door_scythe then
                door_scythe = Actor:create(nil, nil, nil, "door scythe")
            end
            door_scythe:set_costume("scythe_scythe_door.cos")
            door_scythe:put_in_set(vd)
            door_scythe:setpos(0.0055, 0.33717, 0)
            door_scythe:setrot(0, -6.211, 0)
            door_scythe:play_chore_looping(0)
            manny:say_line("/vdma050/")
            manny:pop_costume()
            MakeSectorActive("scythe_here", FALSE)
        else
            manny:play_chore(mn_scythe_door_scythe_out_door)
            manny:wait_for_chore()
            manny:pop_costume()
            mo.scythe.owner = manny
            manny.is_holding = mo.scythe
            manny.hold_chore = ms_activate_scythe
            manny:play_chore_looping(manny.hold_chore, manny.base_costume)
            manny:say_line("/vdma051/")
        end
        END_CUT_SCENE()
    end
end
vd.fh_door = Object:create(vd, "door", -0.186533, -0.231243, 0.44999999, { range = 0.60000002 })
vd.fh_door.use_pnt_x = -0.186533
vd.fh_door.use_pnt_y = -0.231243
vd.fh_door.use_pnt_z = 0
vd.fh_door.use_rot_x = 0
vd.fh_door.use_rot_y = -170.83299
vd.fh_door.use_rot_z = 0
vd.fh_door.out_pnt_x = -0.186533
vd.fh_door.out_pnt_y = -0.231243
vd.fh_door.out_pnt_z = 0
vd.fh_door.out_rot_x = 0
vd.fh_door.out_rot_y = -170.83299
vd.fh_door.out_rot_z = 0
vd.fh_box = vd.fh_door
vd.fh_door.touchable = FALSE
vd.fh_door.walkOut = function(arg1) -- line 1070
    fh:come_out_door(fh.vd_door)
end
vd.vo_door = Object:create(vd, "door", -0.0449185, 0.82523298, 0.49399999, { range = 0.60000002 })
vd.vo_door.use_pnt_x = -0.0449185
vd.vo_door.use_pnt_y = 0.474233
vd.vo_door.use_pnt_z = 0
vd.vo_door.use_rot_x = 0
vd.vo_door.use_rot_y = -5035.4102
vd.vo_door.use_rot_z = 0
vd.vo_door.out_pnt_x = -0.112959
vd.vo_door.out_pnt_y = 0.64996803
vd.vo_door.out_pnt_z = 0
vd.vo_door.out_rot_x = 0
vd.vo_door.out_rot_y = -356.367
vd.vo_door.out_rot_z = 0
vd.vo_door:make_untouchable()
vd.vo_door.walkOut = function(arg1) -- line 1096
    vo:come_out_door(vo.vd_door)
end
vd.vo_door.lookAt = function(arg1) -- line 1100
    manny:say_line("/vdma053/")
end
vd.ar_door = Object:create(vd, "door", 0.50083399, 2.45, 0, { range = 0.60000002 })
vd.ar_door.use_pnt_x = 0.47602099
vd.ar_door.use_pnt_y = 2.0909801
vd.ar_door.use_pnt_z = 0
vd.ar_door.use_rot_x = 0
vd.ar_door.use_rot_y = 185.078
vd.ar_door.use_rot_z = 0
vd.ar_door.out_pnt_x = 0.50083399
vd.ar_door.out_pnt_y = 2.45
vd.ar_door.out_pnt_z = 0
vd.ar_door.out_rot_x = 0
vd.ar_door.out_rot_y = -373.83701
vd.ar_door.out_rot_z = 0
vd.ar_box = vd.ar_door
vd.ar_door.comeOut = function(arg1) -- line 1121
    vd:current_setup(vd_safex)
    Object.come_out_door(arg1)
end
vd.ar_door.walkOut = function(arg1) -- line 1126
    ar:come_out_door(ar.vd_door)
end
vd.ar_door.lookAt = function(arg1) -- line 1130
    if dr.reunited then
        manny:say_line("/vdma054/")
    else
        manny:say_line("/vdma055/")
    end
end
CheckFirstTime("vi.lua")
dofile("mn_suitcase.lua")
vi = Set:create("vi.set", "vault interior", { vi_top = 0, vi_intla = 1 })
vi.additional_water_droplets = function(arg1) -- line 13
    while 1 do
        sleep_for(rndint(400, 1500))
        single_start_sfx(pick_one_of({ "swrDrop1.wav", "swrDrop2.wav", "swrDrop3.wav", "swrDrop4.wav" }), IM_LOW_PRIORITY, rndint(80, 127))
        break_here()
    end
end
vi.start_sprinkler = function() -- line 22
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    vi.sprinklers_going = TRUE
    vi.sprinkler:play_chore_looping(0)
    start_sfx("viSprink.imu")
    start_script(vi.additional_water_droplets)
    if not vi.tried_sprinklers then
        vi.tried_sprinklers = TRUE
        manny:say_line("/vima001/")
        wait_for_message()
        IrisDown(355, 245, 1000)
        sleep_for(1500)
        IrisUp(215, 280, 1000)
        vi.valve:play_chore(1)
        manny:say_line("/vima002/")
        wait_for_message()
        meche:say_line("/vimc003/")
        wait_for_message()
        music_state:set_sequence(seqSprinkler)
    else
        sleep_for(500)
        meche:say_line("/vimc004/")
        wait_for_message()
        music_state:set_sequence(seqSprinkler)
        IrisDown(355, 245, 1000)
        sleep_for(500)
        IrisUp(215, 280, 1000)
        vi.valve:play_chore(1)
    end
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.stop_sprinkler = function() -- line 58
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    vi.sprinklers_going = FALSE
    vi.sprinkler:stop_chore(0)
    vi.sprinkler:play_chore(1)
    stop_sound("viSprink.imu")
    stop_script(vi.additional_water_droplets)
    vi.valve:play_chore(2)
    meche:say_line("/vimc005/")
    StartMovie("vi.snm", nil, 40, 305)
    start_sfx("viSprnOf.wav")
    wait_for_movie()
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.bicker = function() -- line 75
    vi.bickered = TRUE
    meche_idle_ok = FALSE
    break_here()
    meche:say_line("/vimc006/")
    meche:wait_for_message()
    meche:say_line("/vimc007/")
    meche:wait_for_message()
    meche_idle_ok = TRUE
end
vi.reconcile = function() -- line 86
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    manny:say_line("/vima008/")
    wait_for_message()
    meche:say_line("/vimc009/")
    wait_for_message()
    meche:say_line("/vimc010/")
    wait_for_message()
    meche:say_line("/vimc011/")
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.meche_lookat_manny = function() -- line 102
    while 1 do
        meche:head_look_at_manny()
        break_here()
    end
end
vi.discover_tickets = function() -- line 109
    vi.suitcases.seen = TRUE
    meche_idle_ok = FALSE
    START_CUT_SCENE()
    MakeSectorActive("suitcase_box", TRUE)
    start_script(manny.walkto, manny, -1.09908, -0.465614, 0, 0, 31.61, 0)
    manny:say_line("/vima012/")
    wait_for_message()
    meche:say_line("/vimc013/")
    meche:play_chore_looping(meche_in_vi_walk)
    while TurnActorTo(meche.hActor, -1.09908, -0.465614, 0) do
        break_here()
    end
    meche:stop_chore(meche_in_vi_walk)
    wait_for_message()
    manny:wait_for_actor()
    manny:push_costume("mn_suitcase.cos")
    manny:play_chore(0, "mn_suitcase.cos")
    sleep_for(1500)
    music_state:set_sequence(seqDeadTix)
    suitcase3:set_visibility(FALSE)
    start_script(vi.meche_lookat_manny)
    meche:say_line("/vimc014/")
    wait_for_message()
    meche:say_line("/vimc015/")
    wait_for_message()
    meche:say_line("/vimc016/")
    wait_for_message()
    manny:say_line("/vima017/")
    manny:play_chore(mn_suitcase_close, "mn_suitcase.cos")
    wait_for_message()
    meche:say_line("/vimc018/")
    manny:wait_for_chore()
    wait_for_message()
    manny:pop_costume()
    suitcase3:set_visibility(TRUE)
    if find_script(vi.escape_safe) then
        manny:walkto(-0.904647, -0.474899, 0, 0, -440, 0)
    else
        manny:walkto(-0.727755, -0.176263, 0, 0, 33, 0)
    end
    manny:say_line("/vima019/")
    wait_for_message()
    manny:wait_for_actor()
    manny:say_line("/vima020/")
    manny:push_costume("mn_gestures.cos")
    manny:play_chore(manny_gestures_hand_gesture)
    wait_for_message()
    manny:say_line("/vima021/")
    wait_for_message()
    meche:say_line("/vimc022/")
    wait_for_message()
    manny:say_line("/vima023/")
    manny:play_chore(manny_gestures_head_nod)
    manny:wait_for_chore()
    manny:play_chore(manny_gestures_pointing)
    wait_for_message()
    manny:wait_for_chore()
    manny:say_line("/vima024/")
    manny:play_chore(manny_gestures_shrug)
    wait_for_message()
    manny:say_line("/vima025/")
    wait_for_message()
    MakeSectorActive("suitcase_box", TRUE)
    manny:pop_costume()
    vi.suitcases:lookAt()
    stop_script(vi.meche_lookat_manny)
    meche:head_look_at(nil)
    END_CUT_SCENE()
    meche_idle_ok = TRUE
end
vi.break_tile = function() -- line 182
    meche_idle_ok = FALSE
    START_CUT_SCENE()
    vi.tile_broken = TRUE
    vi.valve:play_chore(0)
    vi.valve:wait_for_chore()
    END_CUT_SCENE()
end
vi.escape_safe = function() -- line 192
    meche_freed = TRUE
    cur_puzzle_state[41] = TRUE
    START_CUT_SCENE()
    MakeSectorActive("suitcase_box", TRUE)
    manny:walkto(0.101501, -0.338144, 0, 0, -270.681, 0)
    manny:wait_for_actor()
    meche:follow_boxes()
    manny:say_line("/vima026/")
    manny:hand_gesture()
    wait_for_message()
    meche:say_line("/vimc027/")
    meche:play_chore_looping(meche_in_vi_walk)
    local local1 = start_script(meche.walkto, meche, -0.24616, -0.21772, 0, 0, 180, 0)
    wait_for_script(local1)
    meche:stop_chore(meche_in_vi_walk)
    meche:play_chore(meche_in_vi_hands_down_hold)
    wait_for_message()
    if not vi.suitcases.seen then
        vi.discover_tickets()
        wait_for_message()
        manny:say_line("/vima028/")
        manny:shrug_gesture()
        meche:play_chore_looping(meche_in_vi_walk)
        local local2 = start_script(meche.walkto, meche, -0.24616, -0.21772, 0, 0, 180, 0)
        wait_for_script(local2)
        meche:stop_chore(meche_in_vi_walk)
    else
        manny:say_line("/vima029/")
        manny:shrug_gesture()
    end
    wait_for_message()
    manny:say_line("/vima030/")
    manny:twist_head_gesture()
    wait_for_message()
    manny:say_line("/vima031/")
    wait_for_message()
    meche:play_chore(meche_in_vi_slide)
    meche:wait_for_chore()
    meche:free()
    stop_sound("viSprink.imu")
    stop_script(vi.additional_water_droplets)
    music_state:set_sequence(seqYr3Iris)
    IrisDown(355, 245, 1000)
    sleep_for(1500)
    stop_script(vo.exit_with_axe)
    vo_axe:free()
    END_CUT_SCENE()
    if raised_lamancha then
        start_script(bl.everybodys_here)
    else
        start_script(bl.passengers_before_boat)
    end
end
vi.meche_hold = function(arg1, arg2) -- line 250
    local local1 = rnd(arg1, arg2)
    if meche_idle_ok then
        repeat
            local1 = local1 - PerSecond(1)
            break_here()
            if not meche_idle_ok then
                local1 = 0
            end
        until local1 <= 0
    end
end
vi.meche_head_idle = function() -- line 263
    meche_idle_ok = TRUE
    while not vi.tile_broken do
        while meche_idle_ok do
            if manny_has_axe then
                meche:head_look_at_manny()
                while manny_has_axe do
                    break_here()
                end
            else
                meche:head_look_at_point({ x = -0.539173, y = 0.482942, z = 0.276 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.607073, y = 0.219642, z = 0.6374 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.813073, y = 0.219642, z = 0.4295 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.753373, y = 0.247742, z = 0.5051 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.994773, y = 0.288742, z = 0.244 })
                vi.meche_hold(0.5, 5)
            end
        end
        meche:head_look_at_manny()
        while not meche_idle_ok do
            break_here()
        end
    end
    meche:head_look_at(nil)
end
vi.meche_arm_idle = function() -- line 294
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
    while not vi.tile_broken do
        while meche_idle_ok do
            meche:play_chore(meche_in_vi_drop_hands)
            meche:wait_for_chore()
            vi.meche_hold(5, 9)
            meche:play_chore(meche_in_vi_xarms)
            meche:wait_for_chore()
            vi.meche_hold(5, 9)
        end
        break_here()
    end
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
end
vi.set_up_actors = function(arg1) -- line 314
    if not suitcase1 then
        suitcase1 = Actor:create(nil, nil, nil, "case")
    end
    suitcase1:set_costume("mn_suitcase.cos")
    suitcase1:put_in_set(vi)
    suitcase1:setpos(-1.06803, -0.238608, -0.139)
    suitcase1:setrot(0, 75.6, 0)
    suitcase1:play_chore(mn_suitcase_suitcase_only)
    if not suitcase2 then
        suitcase2 = Actor:create(nil, nil, nil, "case")
    end
    suitcase2:set_costume("mn_suitcase.cos")
    suitcase2:put_in_set(vi)
    suitcase2:setpos(-1.14757, -0.4833, -0.064)
    suitcase2:setrot(0, 16.6, 0)
    suitcase2:play_chore(mn_suitcase_suitcase_only)
    if not suitcase3 then
        suitcase3 = Actor:create(nil, nil, nil, "case")
    end
    suitcase3:set_costume("mn_suitcase.cos")
    suitcase3:put_in_set(vi)
    suitcase3:setpos(-1.09908, -0.465614, 0)
    suitcase3:setrot(0, 31.61, 0)
    suitcase3:play_chore(mn_suitcase_suitcase_only)
    meche:set_costume("meche_in_vi.cos")
    meche:set_mumble_chore(meche_in_vi_mumble)
    meche:set_talk_chore(1, meche_in_vi_stop_talk)
    meche:set_talk_chore(2, meche_in_vi_a)
    meche:set_talk_chore(3, meche_in_vi_c)
    meche:set_talk_chore(4, meche_in_vi_e)
    meche:set_talk_chore(5, meche_in_vi_f)
    meche:set_talk_chore(6, meche_in_vi_l)
    meche:set_talk_chore(7, meche_in_vi_m)
    meche:set_talk_chore(8, meche_in_vi_o)
    meche:set_talk_chore(9, meche_in_vi_t)
    meche:set_talk_chore(10, meche_in_vi_u)
    meche:set_head(5, 5, 5, 165, 28, 80)
    meche:set_look_rate(200)
    meche:put_in_set(vi)
    meche:ignore_boxes()
    meche:setpos(-0.829475, 0.313889, 0)
    meche:setrot(0, 213, 0)
    meche.footsteps = footsteps.reverb
    start_script(vi.meche_head_idle)
    start_script(vi.meche_arm_idle)
end
vi.enter = function(arg1) -- line 372
    MakeSectorActive("suitcase_box", FALSE)
    vi:current_setup(vi_intla)
    vi:set_up_actors()
    if not vi.bickered and not find_script(slide_show) then
        start_script(vi.bicker)
    end
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_tile.bm")
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_water_tile.bm")
    vi.valve:set_object_state("vi_tile.cos")
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_sprinkler.bm")
    vi.sprinkler:set_object_state("vi_sprinkler.cos")
    if vi.sprinklers_going then
        vi.valve:play_chore(1)
        vi.sprinkler:play_chore_looping(0)
        start_script(vi.additional_water_droplets)
        start_sfx("viSprink.imu")
    else
        vi.valve:play_chore(2)
        vi.sprinkler:play_chore(1)
    end
    MakeSectorActive("meche_box", FALSE)
    if manny_has_axe then
        MakeSectorActive("noax1", FALSE)
        MakeSectorActive("noax2", FALSE)
        MakeSectorActive("noax3", FALSE)
    else
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
    end
    if vo_axe.currentSet == system.currentSet then
        vo_axe:put_in_set(vi)
        vo_axe:setpos(vo_axe.pos_x, vo_axe.pos_y, vo_axe.pos_z)
        vo_axe:setrot(vo_axe.rot_x, vo_axe.rot_y, vo_axe.rot_z)
        vo_axe:set_costume("mn_lift_ax.cos")
        vo_axe:play_chore(3)
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.7, 0.2, 3.2)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(meche.hActor, 0)
    SetActorShadowPoint(meche.hActor, -0.7, 0.2, 3.2)
    SetActorShadowPlane(meche.hActor, "shadow1")
    AddShadowPlane(meche.hActor, "shadow1")
end
vi.exit = function(arg1) -- line 429
    meche:free()
    suitcase1:free()
    suitcase2:free()
    suitcase3:free()
    stop_script(vi.meche_head_idle)
    stop_script(vi.meche_arm_idle)
    stop_script(vi.additional_water_droplets)
    stop_sound("viSprink.imu")
    KillActorShadows(manny.hActor)
    KillActorShadows(meche.hActor)
end
vi.suitcases = Object:create(vi, "/vitx032/suitcases", -1.3056901, -0.404212, 0.27000001, { range = 0.60000002 })
vi.suitcases.use_pnt_x = -1.01569
vi.suitcases.use_pnt_y = -0.53421199
vi.suitcases.use_pnt_z = 0
vi.suitcases.use_rot_x = 0
vi.suitcases.use_rot_y = -279.534
vi.suitcases.use_rot_z = 0
vi.suitcases.lookAt = function(arg1) -- line 457
    if not arg1.seen then
        start_script(vi.discover_tickets)
    else
        manny:say_line("/vima033/")
    end
end
vi.suitcases.pickUp = vi.suitcases.lookAt
vi.suitcases.use = vi.suitcases.lookAt
vi.valve = Object:create(vi, "/vitx034/valve", -0.192596, -1.20491, 0.31, { range = 0.60000002 })
vi.valve.use_pnt_x = -0.385097
vi.valve.use_pnt_y = -1.23524
vi.valve.use_pnt_z = 0
vi.valve.use_rot_x = 0
vi.valve.use_rot_y = -436.32101
vi.valve.use_rot_z = 0
vi.valve.opened = TRUE
vi.valve.lookAt = function(arg1) -- line 479
    manny:say_line("/vima035/")
end
vi.valve.open = function(arg1) -- line 483
    arg1.opened = TRUE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:set_rest_chore(nil)
    manny:play_chore(mn2_reach_med, manny.base_costume)
    start_sfx("viValve.wav", nil, 90)
    manny:wait_for_chore()
    manny:set_rest_chore(mn2_rest, manny.base_costume)
    END_CUT_SCENE()
    if vi.sprinkler_activated then
        start_script(vi.start_sprinkler)
    end
end
vi.valve.close = function(arg1) -- line 499
    arg1.opened = FALSE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:set_rest_chore(nil)
    manny:play_chore(mn2_reach_med, manny.base_costume)
    start_sfx("viValve.wav", nil, 90)
    manny:wait_for_chore()
    manny:set_rest_chore(mn2_rest, manny.base_costume)
    END_CUT_SCENE()
    if vi.sprinkler_activated then
        start_script(vi.stop_sprinkler)
    end
end
vi.valve.use = function(arg1) -- line 515
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
vi.meche_obj = Object:create(vi, "/vitx036/Meche", -0.811068, 0.30837601, 0.52029997, { range = 0.69999999 })
vi.meche_obj.use_pnt_x = -0.77146798
vi.meche_obj.use_pnt_y = -0.128224
vi.meche_obj.use_pnt_z = 0
vi.meche_obj.use_rot_x = 0
vi.meche_obj.use_rot_y = 44.716599
vi.meche_obj.use_rot_z = 0
vi.meche_obj.lookAt = function(arg1) -- line 531
    if vi.sprinklers_going then
        manny:say_line("/vima037/")
    elseif not vi.reconciled then
        manny:say_line("/vima038/")
    else
        arg1:use()
    end
end
vi.meche_obj.pickUp = function(arg1) -- line 543
    START_CUT_SCENE()
    manny:say_line("/vima039/")
    wait_for_message()
    meche:say_line("/vimc040/")
    meche:wait_for_message()
    manny:say_line("/vima040b/")
    END_CUT_SCENE()
end
vi.meche_obj.use = function(arg1) -- line 553
    if not vi.reconciled then
        vi.reconciled = TRUE
        start_script(vi.reconcile)
    else
        START_CUT_SCENE()
        manny:say_line("/vima041/")
        wait_for_message()
        meche:say_line("/vimc042/")
        END_CUT_SCENE()
    end
end
vi.drain = Object:create(vi, "/vitx043/drain", -0.47740099, -0.653943, 0, { range = 0.60000002 })
vi.drain.use_pnt_x = -0.25740099
vi.drain.use_pnt_y = -0.52394301
vi.drain.use_pnt_z = 0
vi.drain.use_rot_x = 0
vi.drain.use_rot_y = -966.367
vi.drain.use_rot_z = 0
vi.drain:make_untouchable()
vi.vent = Object:create(vi, "/vitx044/vent", -0.85521197, 0.46798399, 1.21, { range = 1.5 })
vi.vent.use_pnt_x = -0.41288999
vi.vent.use_pnt_y = 0.16989399
vi.vent.use_pnt_z = 0
vi.vent.use_rot_x = 0
vi.vent.use_rot_y = -1026.98
vi.vent.use_rot_z = 0
vi.vent.lookAt = function(arg1) -- line 585
    manny:say_line("/vima045/")
end
vi.vent.use = function(arg1) -- line 589
    START_CUT_SCENE()
    manny:say_line("/vima046/")
    if not arg1.tried then
        arg1.tried = TRUE
        wait_for_message()
        meche:say_line("/vimc047/")
        wait_for_message()
        manny:say_line("/vima048/")
    end
    END_CUT_SCENE()
end
vi.vent.use_scythe = function(arg1) -- line 602
    manny:say_line("/vima049/")
end
vi.sprinkler = Object:create(vi, "/vitx050/sprinkler", -0.14229301, 0.264732, 1.02, { range = 1.3 })
vi.sprinkler.use_pnt_x = -0.246362
vi.sprinkler.use_pnt_y = -0.056466099
vi.sprinkler.use_pnt_z = 0
vi.sprinkler.use_rot_x = 0
vi.sprinkler.use_rot_y = 117.803
vi.sprinkler.use_rot_z = 0
vi.sprinkler.lookAt = function(arg1) -- line 615
    manny:say_line("/vima051/")
end
vi.sprinkler.use = function(arg1) -- line 619
    manny:say_line("/vima052/")
end
vi.sprinkler.use_chisel = vi.sprinkler.use
vi.sprinkler.use_scythe = function(arg1) -- line 625
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("mn_scythe_sprinkler.cos")
    manny:play_chore(0)
    sleep_for(2200)
    start_sfx("viChop.wav")
    manny:wait_for_chore()
    manny:pop_costume()
    vi.sprinkler_activated = TRUE
    if vi.valve.opened then
        wait_for_message()
        start_script(vi.start_sprinkler)
    end
end
vi.broadaxe = Object:create(vi, "axe", 0, 0, 0, { range = 1 })
vi.broadaxe.use_pnt_x = 0
vi.broadaxe.use_pnt_y = 0
vi.broadaxe.use_pnt_z = 0
vi.broadaxe.use_rot_x = 0
vi.broadaxe.use_rot_y = 0
vi.broadaxe.use_rot_z = 0
vi.broadaxe:make_untouchable()
vi.broadaxe.lookAt = function(arg1) -- line 652
    manny:say_line("/voma044/")
end
vi.broadaxe.pickUp = function(arg1) -- line 657
    vo.get_axe()
end
vi.broadaxe.use = function(arg1) -- line 661
    vo.get_axe()
end
vi.broadaxe.default_response = vi.broadaxe.use
vi.vo_door = Object:create(vi, "/vitx053/secret door", 2.00371, -0.26364201, 0.47, { range = 0.69999999 })
vi.vo_door.use_pnt_x = 1.2337101
vi.vo_door.use_pnt_y = -0.26364201
vi.vo_door.use_pnt_z = 0
vi.vo_door.use_rot_x = 0
vi.vo_door.use_rot_y = -455.82001
vi.vo_door.use_rot_z = 0
vi.vo_door.out_pnt_x = 1.6
vi.vo_door.out_pnt_y = -0.30083799
vi.vo_door.out_pnt_z = 0
vi.vo_door.out_rot_x = 0
vi.vo_door.out_rot_y = -455.82001
vi.vo_door.out_rot_z = 0
vi.vo_door.walkOut = function(arg1) -- line 688
    if manny_has_axe then
        vo:switch_to_set()
        manny:setpos(-1.01436, 1.01177, 0)
        manny:setrot(0, -280, 0)
        manny:put_in_set(vo)
        vo_axe:put_in_set(vo)
        vi.broadaxe:make_untouchable()
        vo.broadaxe:make_touchable()
    else
        vo:come_out_door(vo.secret_door)
    end
end
vi.vo_door.lookAt = function(arg1) -- line 702
    manny:say_line("/vima054/")
end
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
CheckFirstTime("sg.lua")
sg = Set:create("sg.set", "signpost fork", { sg_ovrhd = 0, sg_sgnha = 1, sg_sgnha2 = 1, sg_sgnha3 = 1, sg_sgnha4 = 1, sg_sgnha5 = 1, sg_spdws = 2, sg_mancu = 3 })
dofile("glottis_throws.lua")
dofile("glottis_cry.lua")
dofile("gl_saved.lua")
dofile("ma_save_gl.lua")
dofile("signpost.lua")
dofile("ma_action_sign.lua")
dofile("ma_climb_bw.lua")
dofile("gl_boarding_bw.lua")
dofile("bonewagon_gl.lua")
rh = function() -- line 23
    manny:default()
    sg:switch_to_set()
    start_script(sg.glottis_rip_heart)
end
glottis.snores = { }
glottis.snores["/sggl001/"] = 0.2
glottis.snores["/sggl002/"] = 0.15000001
glottis.snores["/sggl003/"] = 0.039999999
glottis.snores["/sggl004/"] = 0.039999999
glottis.snores["/sggl005/"] = 0.15000001
glottis.snores["/sggl006/"] = 0.15000001
glottis.snores["/sggl007/"] = 0.15000001
glottis.snores["/sggl008/"] = 0.039999999
glottis.snores["/sggl009/"] = 0.039999999
glottis.snores["/sggl010/"] = 0.039999999
glottis.roars = { }
glottis.roars[1] = { line = "/sggl011/", freq = 0.1, choreTbl = { bonewagon_gl_2vrm_lft, bonewagon_gl_vrm2drv } }
glottis.roars[2] = { line = "/sggl012/", freq = 0.2, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2drv } }
glottis.roars[3] = { line = "/sggl013/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2drv, bonewagon_gl_mck_shft } }
glottis.roars[4] = { line = "/sggl014/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[5] = { line = "/sggl015/", freq = 0.1, choreTbl = { bonewagon_gl_rx2rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_2steer, bonewagon_gl_rx_steer, bonewagon_gl_rx_hook, bonewagon_gl_rx2drv } }
glottis.roars[6] = { line = "/sggl016/", freq = 0.1, choreTbl = { bonewagon_gl_2rmbl, bonewagon_gl_rmbl2drv, bonewagon_gl_2rmbl, bonewagon_gl_rmbl2drv } }
glottis.roars[7] = { line = "/sggl017/", freq = 0.1, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc_rmbl, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[8] = { line = "/sggl018/", freq = 0.1, choreTbl = { bonewagon_gl_rx2rmbl, bonewagon_gl_rx_rmbl, bonewagon_gl_rx_2steer, bonewagon_gl_rx_steer, bonewagon_gl_rx_hook, bonewagon_gl_rx2drv } }
glottis.roars[9] = { line = "/sggl019/", freq = 0.050000001, choreTbl = { bonewagon_gl_sc_hook, bonewagon_gl_sc2steer, bonewagon_gl_sc_steer, bonewagon_gl_sc2drv } }
glottis.roars[10] = { line = "/sggl020/", freq = 0.050000001, choreTbl = { bonewagon_gl_gl_2hands_out, bonewagon_gl_gl_cvr_eyes, bonewagon_gl_uncover_eyes, bonewagon_gl_gl_stop_hands_out } }
sg.glottis_roars = function(arg1, arg2) -- line 69
    local local1
    local local2, local3, local4, local5
    if not arg2 then
        arg2 = bonewagon
    end
    while TRUE do
        sleep_for(rndint(1000, 5000))
        if cutSceneLevel <= 0 then
            local2 = random()
            local5 = 0
            local3, local4 = next(glottis.roars, nil)
            local1 = nil
            while local3 and not local1 do
                local5 = local5 + local4.freq
                if local5 > local2 then
                    local1 = local4
                end
                local3, local4 = next(glottis.roars, local3)
            end
            if not local1 then
                local1 = glottis.roars[1]
            end
            if local1.choreTbl then
                start_script(sg.glottis_roars_animate, sg, arg2, local1.choreTbl)
            end
            arg2:say_line(local1.line, { skip_log = TRUE, background = TRUE, volume = 65 })
            arg2:wait_for_message()
            wait_for_script(sg.glottis_roars_animate)
        end
    end
end
sg.glottis_roars_animate = function(arg1, arg2, arg3) -- line 106
    local local1, local2, local3
    local3 = bonewagon_gl_gl_drive
    local1, local2 = next(arg3, nil)
    while local1 do
        arg2:play_chore(local2)
        arg2:wait_for_chore(local2)
        local3 = local2
        local1, local2 = next(arg3, local1)
    end
    arg2:stop_chore(local3)
    arg2:play_chore(bonewagon_gl_gl_drive)
end
signpost = Actor:create(nil, nil, nil, "Signpost")
signpost.offset_vector = { x = -0.0211, y = 0.1585, z = 0 }
signpost.manny_offset = { x = 0.15078799, y = 0.066618003, z = 0 }
signpost.default = function(arg1) -- line 131
    arg1:set_costume("signpost.cos")
    arg1:set_turn_rate(20)
    arg1:set_collision_mode(COLLISION_BOX, 0.3)
end
signpost.put_at_manny = function(arg1, arg2) -- line 137
    local local1, local2, local3
    local2 = manny:getrot()
    local1 = RotateVector(arg1.offset_vector, local2)
    local3 = manny:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local1.z + local3.z
    arg1:put_in_set(system.currentSet)
    arg1:setpos(local1.x, local1.y, local1.z)
    arg1:setrot(local2.x, local2.y - 110, local2.z)
    if not arg2 then
        arg1:show()
    end
end
signpost.get_manny_pos = function(arg1) -- line 154
    local local1, local2, local3, local4
    local2 = signpost:getrot()
    local1 = RotateVector(arg1.manny_offset, local2)
    local3 = signpost:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local4 = manny:getpos()
    local1.z = local4.z
    return local1.x, local1.y, local1.z
end
signpost.get_future_manny_pos = function(arg1) -- line 168
    local local1, local2, local3, local4, local5
    local5 = manny:getrot()
    local3 = RotateVector(arg1.offset_vector, local5)
    local4 = manny:getpos()
    local3.x = local3.x + local4.x
    local3.y = local3.y + local4.y
    local3.z = local4.z
    arg1:setpos(local3.x, local3.y, local3.z)
    local2 = GetActorYawToPoint(arg1.hActor, system.currentSet.rubacava_point)
    local2 = { 0, local2, 0 }
    local1 = RotateVector(arg1.manny_offset, local2)
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
signpost.show = function(arg1) -- line 190
    arg1:play_chore(signpost_show)
    arg1:set_collision_mode(COLLISION_BOX, 0.3)
end
signpost.hide = function(arg1) -- line 195
    arg1:play_chore(signpost_hide)
    arg1:set_collision_mode(COLLISION_OFF)
end
signpost.pick_up = function(arg1) -- line 200
    manny:push_costume("ma_action_sign.cos")
    manny:play_chore(ma_action_sign_lift_sign, "ma_action_sign.cos")
    sleep_for(500)
    start_sfx("sgSgnOut.WAV")
    sleep_for(150)
    arg1:hide()
    manny:wait_for_chore()
    manny:pop_costume()
    manny:play_chore_looping(ma_hold_sign, "ma.cos")
end
signpost.put_down = function(arg1) -- line 212
    manny:stop_chore(ma_hold_sign, "ma.cos")
    manny:push_costume("ma_action_sign.cos")
    manny:play_chore(ma_action_sign_plant_sign, "ma_action_sign.cos")
    sleep_for(1300)
    start_sfx("sgSgnIn.WAV")
    sleep_for(960)
    arg1:put_at_manny()
    manny:wait_for_chore(ma_action_sign_plant_sign, "ma_action_sign.cos")
    manny:pop_costume()
end
sg.check_post = function(arg1, arg2) -- line 224
    if manny.is_holding == sg.signpost then
        START_CUT_SCENE()
        if arg2 == sg.sp_door then
            manny:walkto(-2.83579, -4.87312, 0, 0, 5.9804, 0)
            manny:wait_for_actor()
        else
            manny:walkto_object(arg2)
            manny:wait_for_actor()
        end
        sg.signpost:plant()
        manny:wait_for_message()
        manny:say_line("/sgma040/")
        manny:wait_for_message()
        manny:say_line("/sgma041/")
        manny:wait_for_message()
        END_CUT_SCENE()
        return TRUE
    else
        return FALSE
    end
end
dofile("bonewagon.lua")
sg.bw_out_points = { }
sg.bw_out_points[0] = { pos = { x = -3.87446, y = -1.04915, z = 0 }, rot = { x = 0, y = 337.62799, z = 0 } }
sg.bw_out_points[1] = { pos = { x = 0.26031801, y = 0.98607898, z = 0 }, rot = { x = 0, y = 236.30299, z = 0 } }
sg.bw_out_points[2] = { pos = { x = 3.44713, y = -2.0948, z = 0 }, rot = { x = 0, y = 239.709, z = 0 } }
sg.bw_out_points[3] = { pos = { x = 6.2069998, y = 0.25447601, z = 0 }, rot = { x = 0, y = 310.397, z = 0 } }
bonewagon = Actor:create(nil, nil, nil, "Bone Wagon")
bonewagon.max_walk_rate = 4.5
bonewagon.max_backward_rate = -3
bonewagon.max_turn_rate = 60
bonewagon.min_turn_rate = 0
bonewagon.going = FALSE
bonewagon.keep_moving = FALSE
bonewagon.is_backward = FALSE
bonewagon.wheel_state = "center"
bonewagon.max_volume = 30
bonewagon.glottis_offset_pos = { x = 0.76233, y = 0.34405601, z = 0 }
bonewagon.glottis_offset_rot = { x = 0, y = 98.228401, z = 0 }
bonewagon.manny_offset_pos = { x = 0.52359003, y = -1.335618, z = 0 }
bonewagon.manny_offset_rot = { x = 0, y = 82.184402, z = 0 }
bonewagon.manny_out_offset_pos = { x = 0.66830659, y = -1.518109, z = 0 }
bonewagon.manny_out_offset_rot = { x = 0, y = 278.89801, z = 0 }
bonewagon.manny_all_out_offset = { x = 0.97174299, y = -1.354003, z = 0 }
bonewagon.rev_sfx = { "bwup01.WAV", "bwup02.WAV", "bwup04.wav", "bwup05.wav", "bwup06.wav" }
bonewagon.down_sfx = { "bwdown02.WAV", "bwdown04.WAV", "bwdown06.WAV" }
bonewagon.tire_sfx = { "bwTire01.WAV", "bwTire02.WAV", "bwTire03.WAV", "bwTire04.WAV" }
bonewagon.cruise_sfx = { "bwrev05.wav", "bwrev07.wav", "bwrev09.wav", "bwrev12.wav" }
bonewagon.default = function(arg1, arg2) -- line 287
    arg1:follow_boxes()
    arg1:set_visibility(TRUE)
    if manny.is_driving then
        arg1:set_costume("bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_stay_up, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
        arg1:set_collision_mode(COLLISION_SPHERE, 0.3)
    else
        arg1:set_costume("bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_stay_up, "bonewagon_gl.cos")
        arg1:play_chore(bonewagon_gl_no_shocks)
        arg1:set_collision_mode(COLLISION_BOX)
    end
    arg1.walk_rate = 0.5
    arg1.turn_dir = 0
    arg1.turn_rate = arg1.min_turn_rate
    arg1:set_walk_rate(arg1.walk_rate)
    arg1:set_turn_rate(arg1.turn_rate)
    arg1:set_talk_color(Orange)
    SetActorReflection(arg1.hActor, 50)
end
bonewagon.get_glottis_pos_rot = function(arg1) -- line 314
    local local1, local2, local3, local4
    local3 = arg1:get_positive_rot()
    local1 = RotateVector(arg1.glottis_offset_pos, local3)
    local4 = arg1:getpos()
    local1.x = local1.x + local4.x
    local1.y = local1.y + local4.y
    local1.z = local4.z
    newRot = arg1:get_positive_rot()
    newRot.y = newRot.y + arg1.glottis_offset_rot.y
    if newRot.y > 360 then
        newRot.y = newRot.y - 360
    end
    if newRot.y < 0 then
        newRot.y = newRot.y + 360
    end
    return local1, newRot
end
bonewagon.get_manny_pos = function(arg1, arg2) -- line 336
    local local1, local2, local3
    local2 = arg1:get_positive_rot()
    if not arg2 then
        local1 = RotateVector(arg1.manny_offset_pos, local2)
    else
        local1 = RotateVector(arg1.manny_out_offset_pos, local2)
    end
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
bonewagon.get_manny_far_pos = function(arg1) -- line 353
    local local1, local2, local3
    local2 = arg1:get_positive_rot()
    local1 = RotateVector(arg1.manny_all_out_offset, local2)
    local3 = arg1:getpos()
    local1.x = local1.x + local3.x
    local1.y = local1.y + local3.y
    local1.z = local3.z
    return local1.x, local1.y, local1.z
end
bonewagon.get_manny_rot = function(arg1, arg2) -- line 367
    local local1
    local1 = arg1:get_positive_rot()
    if not arg2 then
        local1.y = local1.y + arg1.manny_offset_rot.y
    else
        local1.y = local1.y + arg1.manny_out_offset_rot.y
    end
    if local1.y > 360 then
        local1.y = local1.y - 360
    end
    if local1.y < 0 then
        local1.y = local1.y + 360
    end
    return local1.x, local1.y, local1.z
end
bonewagon.accelerate = function(arg1, arg2, arg3) -- line 385
    local local1
    if not arg2 then
        arg2 = 0.1
    end
    local1 = arg2
    stop_script(arg1.decelerate)
    if not arg3 then
        while arg1.walk_rate < arg1.max_walk_rate do
            arg1.walk_rate = arg1.walk_rate + arg2
            if arg1.walk_rate > arg1.max_walk_rate then
                arg1.walk_rate = arg1.max_walk_rate
            end
            arg1:set_walk_rate(arg1.walk_rate)
            arg2 = arg2 + local1
            break_here()
        end
    else
        while arg1.walk_rate > arg1.max_backward_rate do
            arg1.walk_rate = arg1.walk_rate - arg2
            if arg1.walk_rate < arg1.max_backward_rate then
                arg1.walk_rate = arg1.max_backward_rate
            end
            arg1:set_walk_rate(arg1.walk_rate)
            break_here()
        end
    end
end
bonewagon.decelerate = function(arg1, arg2, arg3) -- line 417
    local local1
    if not arg2 then
        arg2 = 0.1
    end
    local1 = arg2
    stop_script(arg1.accelerate)
    if not arg3 then
        while arg1.walk_rate > 1 do
            arg1.walk_rate = arg1.walk_rate - arg2
            if arg1.walk_rate < 1 then
                arg1.walk_rate = 1
            end
            arg1:set_walk_rate(arg1.walk_rate)
            arg2 = arg2 + local1
            break_here()
        end
    else
        while arg1.walk_rate < 0 do
            arg1.walk_rate = arg1.walk_rate + arg2
            if arg1.walk_rate > 0.1 then
                arg1.walk_rate = 0.1
            end
            arg1:set_walk_rate(arg1.walk_rate)
            break_here()
        end
    end
end
bonewagon.cruise_sounds = function(arg1) -- line 449
    fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume / 2)
    arg1.cur_cruise_sound = nil
    while TRUE do
        arg1.cur_cruise_sound = pick_one_of(bonewagon.cruise_sfx, TRUE)
        bonewagon:play_sound_at(arg1.cur_cruise_sound, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        wait_for_sound(arg1.cur_cruise_sound)
        break_here()
    end
end
bonewagon.stop_cruise_sounds = function(arg1, arg2) -- line 460
    local local1, local2
    stop_script(arg1.cruise_sounds)
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            fade_sfx(local2, 200)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    if not arg2 then
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    end
end
bonewagon.gas = function(arg1) -- line 499
    local local1
    stop_script(arg1.reverse, arg1)
    arg1.going = TRUE
    local1 = pick_one_of(bonewagon.rev_sfx, TRUE)
    bonewagon:play_sound_at(local1, 1, 10, IM_HIGH_PRIORITY)
    fade_sfx(local1, 500, bonewagon.max_volume)
    single_start_script(bonewagon.cruise_sounds, bonewagon)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    start_script(arg1.accelerate, arg1)
    while get_generic_control_state("MOVE_FORWARD") or arg1.keep_moving do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    if sound_playing(local1) then
        fade_sfx(local1, 500, 0)
    end
    local1 = pick_one_of(bonewagon.down_sfx, TRUE)
    bonewagon:play_sound_at(local1, 10, bonewagon.max_volume, IM_HIGH_PRIORITY)
    start_script(arg1.decelerate, arg1)
    single_start_script(bonewagon.stop_cruise_sounds, bonewagon)
    while arg1.walk_rate > 1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    fade_sfx(local1, 300, 0)
    arg1.going = FALSE
end
bonewagon.reverse = function(arg1) -- line 541
    local local1
    if find_script(arg1.gas) then
        stop_script(arg1.gas)
        arg1:brake()
    end
    arg1.going = TRUE
    start_script(arg1.accelerate, arg1, nil, TRUE)
    brakesfx = pick_one_of(bonewagon.tire_sfx, TRUE)
    single_start_sfx(brakesfx, IM_MED_PRIORITY, bonewagon.max_volume)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    while get_generic_control_state("MOVE_BACKWARD") or arg1.keep_moving do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    start_script(arg1.decelerate, arg1, 0.5, TRUE)
    while arg1.walk_rate < 0 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1.going = FALSE
end
bonewagon.brake = function(arg1, arg2) -- line 574
    local local1, local2
    stop_script(arg1.accelerate, arg1)
    if arg1.walk_rate > 0.1 then
        local2 = pick_one_of(bonewagon.down_sfx, TRUE)
        local1 = pick_one_of(bonewagon.tire_sfx, TRUE)
        if not arg2 then
            single_start_sfx(local2, IM_HIGH_PRIORITY, 0)
            fade_sfx(local2, 500, bonewagon.max_volume)
        end
    end
    single_start_script(arg1.decelerate, arg1, 0.30000001)
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
    while find_script(arg1.decelerate) do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    if not arg2 then
        single_start_sfx(local1, IM_MED_PRIORITY, bonewagon.max_volume)
    end
    arg1.going = FALSE
end
bonewagon.left = function(arg1) -- line 611
    if find_script(arg1.right) then
        stop_script(arg1.right)
    end
    if arg1.actual_walk_rate > 0.1 then
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
    end
    start_script(arg1.turn_wheels, arg1, "left")
    while get_generic_control_state("TURN_LEFT") do
        break_here()
    end
    if arg1.wheel_state == "left" then
        start_script(arg1.turn_wheels, arg1, "center")
    end
end
bonewagon.right = function(arg1) -- line 630
    if find_script(arg1.left) then
        stop_script(arg1.left)
    end
    if arg1.actual_walk_rate > 0.1 then
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
    end
    start_script(arg1.turn_wheels, arg1, "right")
    while get_generic_control_state("TURN_RIGHT") do
        break_here()
    end
    if arg1.wheel_state == "right" then
        start_script(arg1.turn_wheels, arg1, "center")
    end
end
bonewagon.turn_wheels = function(arg1, arg2) -- line 649
    if arg2 == "left" then
        arg1:stop_chore(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
        if arg1.wheel_state == "right" then
            arg1:play_chore(bonewagon_gl_rt_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_rt_to_ctr)
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "center" then
            arg1:play_chore(bonewagon_gl_turn_lft, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_turn_lft)
            arg1:play_chore_looping(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
            arg1.wheel_state = "left"
        end
    elseif arg2 == "center" then
        arg1:stop_chore(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
        if arg1.wheel_state == "right" then
            arg1:play_chore(bonewagon_gl_rt_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_rt_to_ctr)
            arg1:play_chore_looping(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "left" then
            arg1:play_chore(bonewagon_gl_lft_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_lft_to_ctr)
            arg1:play_chore_looping(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
            arg1.wheel_state = "center"
        end
    elseif arg2 == "right" then
        arg1:stop_chore(bonewagon_gl_hold_lft, "bonewagon_gl.cos")
        arg1:stop_chore(bonewagon_gl_hold_ctr, "bonewagon_gl.cos")
        if arg1.wheel_state == "left" then
            arg1:play_chore(bonewagon_gl_lft_to_ctr, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_lft_to_ctr)
            arg1.wheel_state = "center"
        end
        if arg1.wheel_state == "center" then
            arg1:play_chore(bonewagon_gl_turn_rt, "bonewagon_gl.cos")
            arg1:wait_for_chore(bonewagon_gl_turn_rt)
            arg1:play_chore_looping(bonewagon_gl_hold_rt, "bonewagon_gl.cos")
            arg1.wheel_state = "right"
        end
    end
end
bonewagon.walkto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 696
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    if arg1.walk_rate < 1.5 or GetActorWalkRate(arg1.hActor) < 1.5 then
        arg1.walk_rate = 1.5
        arg1:set_walk_rate(1.5)
    end
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    Actor.walkto(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
bonewagon.driveto = function(arg1, arg2, arg3, arg4, arg5) -- line 712
    local local1
    local local2
    arg1:walkto(arg2, arg3, arg4)
    while arg1:is_moving() do
        local1 = proximity(bonewagon.hActor, arg2, arg3, arg4)
        arg1.walk_rate = min(arg1.max_walk_rate, local1)
        arg1.walk_rate = max(arg1.walk_rate, 1.5)
        arg1:set_walk_rate(arg1.walk_rate)
        if local1 < 1 and local2 == nil then
            arg1:stop_cruise_sounds()
            if not arg5 then
                local2 = pick_one_of(bonewagon.down_sfx, TRUE)
                arg1:play_sound_at(local2, 10, bonewagon.max_volume, IM_HIGH_PRIORITY)
            end
        end
        break_here()
    end
    arg1:wait_for_actor()
end
bonewagon.drivetorot = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 735
    local local1, local2
    arg1:stop_cruise_sounds()
    arg1.cur_cruise_sound = nil
    arg1:set_turn_rate(arg1.max_turn_rate / 2)
    arg1.walk_rate = 0.80000001
    arg1:set_walk_rate(arg1.walk_rate)
    Actor.walkto(arg1, arg2, arg3, arg4)
    while arg1:is_moving() do
        local1 = proximity(bonewagon.hActor, arg2, arg3, arg4)
        if local1 > 0.5 then
            arg1.walk_rate = arg1.walk_rate + 0.2
        else
            arg1.walk_rate = arg1.walk_rate - 0.2
        end
        arg1.walk_rate = min(arg1.max_walk_rate, arg1.walk_rate)
        arg1.walk_rate = max(arg1.walk_rate, 1.5)
        arg1:set_walk_rate(arg1.walk_rate)
        if not arg1.cur_cruise_sound or not sound_playing(arg1.cur_cruise_sound) then
            arg1.cur_cruise_sound = pick_one_of(bonewagon.cruise_sfx, TRUE)
            arg1:play_sound_at(arg1.cur_cruise_sound, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        end
        break_here()
    end
    arg1:stop_cruise_sounds()
    local2 = nil
    arg1:set_turn_rate(arg1.max_turn_rate / 3)
    Actor.setrot(arg1, arg5, arg6, arg7, TRUE)
    while arg1:is_turning() do
        if not local2 or not sound_playing(local2) then
            local2 = pick_one_of(bonewagon.tire_sfx, TRUE)
            arg1:play_sound_at(local2, 10, bonewagon.max_volume, IM_MED_PRIORITY)
        end
        break_here()
    end
end
bonewagon.monitor_turns = function(arg1) -- line 774
    local local1, local2
    local1 = arg1:getpos()
    arg1.actual_walk_rate = 0
    while TRUE do
        arg1.turn_rate = abs(20 * arg1.actual_walk_rate)
        if arg1.turn_rate > arg1.max_turn_rate then
            arg1.turn_rate = arg1.max_turn_rate
        end
        arg1:set_turn_rate(arg1.turn_rate)
        if get_generic_control_state("TURN_LEFT") and cutSceneLevel <= 0 then
            if arg1.turn_rate > 1 then
                if arg1.walk_rate > 0 or get_generic_control_state("MOVE_FORWARD") then
                    TurnActor(arg1.hActor, 1)
                else
                    TurnActor(arg1.hActor, -1)
                end
            else
                if not bonewagon:playing_tire_sfx() then
                    start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
                end
                arg1:set_turn_rate(30)
                TurnActor(arg1.hActor, 1)
            end
        elseif get_generic_control_state("TURN_RIGHT") and cutSceneLevel <= 0 then
            if arg1.turn_rate > 1 then
                if arg1.walk_rate > 0 or get_generic_control_state("MOVE_FORWARD") then
                    TurnActor(arg1.hActor, -1)
                else
                    TurnActor(arg1.hActor, 1)
                end
            else
                if not bonewagon:playing_tire_sfx() then
                    start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_LOW_PRIORITY, bonewagon.max_volume)
                end
                arg1:set_turn_rate(30)
                TurnActor(arg1.hActor, -1)
            end
        end
        break_here()
        local2 = proximity(arg1.hActor, local1.x, local1.y, local1.z)
        arg1.actual_walk_rate = local2 / system.frameTime * 1000
        local1 = arg1:getpos()
    end
end
bonewagon.playing_tire_sfx = function(arg1) -- line 826
    local local1, local2, local3
    local1 = FALSE
    local2, local3 = next(arg1.tire_sfx, nil)
    while local2 and not local1 do
        if sound_playing(local3) then
            local1 = TRUE
        end
        local2, local3 = next(arg1.tire_sfx, local2)
    end
    return local1
end
bonewagon.stop_movement_scripts = function(arg1) -- line 841
    bonewagon:set_walk_chore(-1)
    bonewagon:set_turn_chores(-1, -1)
    bonewagon:set_rest_chore(-1)
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.brake)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    stop_script(bonewagon.accelerate)
    stop_script(bonewagon.decelerate)
    bonewagon:play_chore(bonewagon_gl_gl_drive, "bonewagon_gl.cos")
    bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
end
bonewagon.squelch_sfx = function(arg1) -- line 856
    local local1, local2
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume / 3)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    if sound_playing("bwIdle.IMU") then
        set_vol("bwIdle.IMU", bonewagon.max_volume / 3)
    end
end
bonewagon.restore_sfx = function(arg1) -- line 892
    local local1, local2
    local1, local2 = next(bonewagon.rev_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.rev_sfx, local1)
    end
    local1, local2 = next(bonewagon.down_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.down_sfx, local1)
    end
    local1, local2 = next(bonewagon.tire_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.tire_sfx, local1)
    end
    local1, local2 = next(bonewagon.cruise_sfx, nil)
    while local1 do
        if sound_playing(local2) then
            set_vol(local2, bonewagon.max_volume)
        end
        local1, local2 = next(bonewagon.cruise_sfx, local1)
    end
    if sound_playing("bwIdle.IMU") then
        set_vol("bwIdle.IMU", bonewagon.max_volume)
    end
end
bonewagon.in_danger_box = function(arg1) -- line 928
    return arg1:find_sector_name("no_bw_box")
end
bonewagon.can_get_out_here = function(arg1) -- line 935
    local local1, local2, local3
    local local4 = FALSE
    local1, local2, local3 = arg1:get_manny_far_pos()
    if GetPointSector(local1, local2, local3) then
        PrintDebug("Found point sector!\n")
        local4 = TRUE
    else
        PrintDebug("Failed point sector!\n")
        local4 = FALSE
    end
    if local4 then
        if signpost.current_set == system.currentSet then
            if proximity(signpost.hActor, local1, local2, local3) < 1 then
                PrintDebug("Failed signpost proximity!\n")
                local4 = FALSE
            end
        end
    end
    return local4
end
bonewagon.find_safe_out_point = function(arg1) -- line 960
    local local1 = system.currentSet.bw_out_points
    local local2, local3, local4
    local local5, local6
    if not bw_scout then
        bw_scout = Actor:create(nil, nil, nil, "bonewagon scout")
    end
    local2 = nil
    local5 = 9999
    bw_scout.parent = arg1
    bw_scout:set_visibility(FALSE)
    bw_scout:put_in_set(system.currentSet)
    if local1 then
        local3, local4 = next(local1, nil)
        while local3 do
            PrintDebug("Trying point " .. local4.pos.x .. ", " .. local4.pos.y .. ", " .. local4.pos.z .. "\n")
            local6 = proximity(arg1.hActor, local4.pos.x, local4.pos.y, local4.pos.z)
            bw_scout:setpos(local4.pos.x, local4.pos.y, local4.pos.z)
            bw_scout:setrot(local4.rot.x, local4.rot.y, local4.rot.z)
            if bw_scout:can_get_out_here() then
                if local6 < local5 then
                    PrintDebug("Chosen!\n")
                    local5 = local6
                    local2 = local3
                else
                    PrintDebug("Found better point.\n")
                end
            else
                PrintDebug("Failed.\n")
            end
            local3, local4 = next(local1, local3)
        end
    end
    return local2
end
bonewagon.collision_handler = function(arg1, arg2) -- line 999
    if arg2 == signpost then
        start_script(sg.signpost_collapse, sg)
    end
end
sg.signpost_collapse = function(arg1) -- line 1005
    local local1, local2, local3
    signpost:set_collision_mode(COLLISION_OFF)
    signpost.knocked_over = TRUE
    signpost.save_rot = signpost:get_positive_rot()
    local2 = copy_table(signpost.save_rot)
    local3 = bonewagon:get_positive_rot()
    local2.y = local3.y
    start_sfx("sgCrash.WAV", IM_HIGH_PRIORITY)
    if bonewagon.walk_rate < 0 or get_generic_control_state("MOVE_BACKWARD") then
        local1 = 10
        while local2.x < 80 do
            local2.x = local2.x + local1
            if local2.x > 80 then
                local2.x = 80
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            break_here()
        end
    else
        local1 = -10
        while local2.x > -80 do
            local2.x = local2.x + local1
            if local2.x < -80 then
                local2.x = -80
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            break_here()
        end
    end
end
sg.signpost_uncollapse = function(arg1) -- line 1041
    local local1 = signpost:get_positive_rot()
    local local2 = signpost.save_rot
    local local3
    if signpost.knocked_over then
        if proximity(bonewagon.hActor, signpost.hActor) > 2 then
            if signpost.current_set == system.currentSet then
                start_sfx("sgSgnSlw.WAV")
                wait_for_sound("sgSgnSlw.WAV")
                start_sfx("sgSgnStp.WAV")
                local3 = 10
                while local3 ~= 0 do
                    signpost:setrot(local2.x + local3, local2.y, local2.z)
                    if local3 > 0 then
                        local3 = floor(abs(local3 - 1))
                    else
                        local3 = -floor(abs(local3 - 1))
                    end
                    break_here()
                end
            end
            signpost:setrot(local2.x, local2.y, local2.z)
            signpost.knocked_over = FALSE
            system.currentSet.signpost:make_touchable()
        else
            system.currentSet.signpost:make_untouchable()
        end
    end
end
sg.examine_signpost = function(arg1) -- line 1074
    local local1, local2
    local local3, local4, local5
    local local6
    if sg.signpost.uprooted and sg:current_setup() ~= sg_spdws then
        START_CUT_SCENE()
        local1 = { }
        local1.pos = signpost:getpos()
        local1.rot = signpost:getrot()
        local2 = { }
        local2.pos = manny:getpos()
        local2.rot = manny:getrot()
        local6 = sg:current_setup()
        sg:current_setup(sg_mancu)
        signpost:setpos(4.0353198, -1.21448, 0)
        local3 = 3.8364899 + (local2.pos.x - local1.pos.x)
        local4 = -1.23856 + (local2.pos.y - local1.pos.y)
        local5 = 0
        manny:ignore_boxes()
        manny:setpos(local3, local4, local5)
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(FALSE)
            bonewagon:set_collision_mode(COLLISION_OFF)
        end
        manny:head_look_at_point({ 4.0353198, -1.21448, 0.5 })
        manny:say_line("/sgma051/")
        manny:wait_for_message()
        sleep_for(1000)
        sg:current_setup(local6)
        signpost:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
        manny:follow_boxes()
        manny:setpos(local2.pos.x, local2.pos.y, local2.pos.z)
        manny:head_look_at(sg.signpost)
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(TRUE)
            bonewagon:set_collision_mode(COLLISION_BOX, 1)
        end
        END_CUT_SCENE()
    else
        manny:say_line("/sgma051/")
    end
end
bone_wagon_button_handler = function(arg1, arg2, arg3) -- line 1123
    if cutSceneLevel <= 0 and not find_script(Sentence) then
        if control_map.PICK_UP[arg1] or control_map.USE[arg1] then
            if arg2 then
                single_start_script(sg.leave_BW, sg)
            end
        elseif control_map.MOVE_FORWARD[arg1] then
            if arg2 then
                if not find_script(bonewagon.gas) then
                    start_script(bonewagon.gas, bonewagon)
                end
            end
        elseif control_map.MOVE_BACKWARD[arg1] then
            if arg2 then
                if not find_script(bonewagon.reverse) then
                    start_script(bonewagon.reverse, bonewagon)
                end
            end
        elseif control_map.TURN_LEFT[arg1] then
            if arg2 then
                single_start_script(bonewagon.left, bonewagon)
            end
        elseif control_map.TURN_RIGHT[arg1] then
            if arg2 then
                single_start_script(bonewagon.right, bonewagon)
            end
        else
            CommonButtonHandler(arg1, arg2, arg3)
        end
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
sg.get_in_BW = function(arg1) -- line 1157
    local local1, local2, local3
    stop_script(sg.glottis_roars)
    stop_script(glottis.talk_randomly_from_weighted_table)
    if manny.is_holding == sg.signpost then
        sg.signpost:plant()
    end
    glottis.heartless = FALSE
    sg.glottis_obj:make_untouchable()
    inventory_disabled = TRUE
    START_CUT_SCENE()
    if not sg.bone_wagon.ridden then
        sg:switch_to_set()
        manny:set_collision_mode(COLLISION_OFF)
        glottis:set_collision_mode(COLLISION_OFF)
        bonewagon:set_collision_mode(COLLISION_OFF)
        signpost:set_collision_mode(COLLISION_OFF)
        sg:current_setup(sg_sgnha)
        glottis:set_costume(nil)
        glottis:put_in_set(sg)
        glottis:set_costume("gl_boarding_bw.cos")
        local1, local2 = bonewagon:get_glottis_pos_rot()
        glottis:setpos(local1.x, local1.y, local1.z)
        glottis:setrot(local2.x, local2.y, local2.z)
        manny:put_at_object(sg.bone_wagon)
        manny:head_look_at(glottis)
        IrisUp(300, 150, 1000)
        sleep_for(500)
        manny:say_line("/sgma021/")
        manny:wait_for_message()
        glottis:say_line("/sggl022/")
        glottis:wait_for_message()
        manny:set_visibility(FALSE)
        glottis:play_chore(gl_boarding_bw_hop_in_bw, "gl_boarding_bw.cos")
        bonewagon:play_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        sleep_for(700)
        start_sfx("bwGlClmb.WAV")
        glottis:wait_for_chore(gl_boarding_bw_hop_in_bw, "gl_boarding_bw.cos")
        glottis:put_in_set(nil)
        bonewagon:play_chore(bonewagon_gl_drive, "bonewagon_gl.cos")
        sleep_for(1400)
        start_sfx("bwMaClmb.WAV")
        bonewagon:wait_for_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        bonewagon:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
    else
        if system.currentSet == sg then
            sg:current_setup(sg_sgnha)
        end
        manny:walk_closeto_object(system.currentSet.bone_wagon, 0.80000001)
        manny:wait_for_actor()
        bonewagon:set_collision_mode(COLLISION_OFF)
        manny:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(system.currentSet.bone_wagon)
        manny:wait_for_actor()
        manny:set_visibility(FALSE)
        bonewagon:play_chore(bonewagon_gl_ma_jump_in, "bonewagon_gl.cos")
        sleep_for(2100)
        start_sfx("bwMaClmb.WAV")
        bonewagon:wait_for_chore()
        bonewagon:play_chore(bonewagon_gl_ma_sit, "bonewagon_gl.cos")
        manny:put_in_set(nil)
    end
    start_sfx("bwStart.WAV", IM_HIGH_PRIORITY)
    sleep_for(200)
    start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    sleep_for(500)
    if not sg.signpost.uprooted then
        sg.bone_wagon.ridden = TRUE
        sg.signpost.uprooted = TRUE
        sg:current_setup(sg_sgnha)
        sleep_for(1000)
        bonewagon:play_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        single_start_sfx(pick_one_of(bonewagon.tire_sfx, TRUE), IM_HIGH_PRIORITY, bonewagon.max_volume)
        start_sfx("bwrev01.wav", IM_HIGH_PRIORITY, bonewagon.max_volume)
        sleep_for(1700)
        fade_sfx("bwrev01.wav", 500)
        start_sfx("sgCrash.WAV", IM_HIGH_PRIORITY)
        sleep_for(200)
        start_script(sg.signpost_lean, sg)
        sleep_for(100)
        glottis:say_line("/gagl017/")
        bonewagon:wait_for_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        bonewagon:stop_chore(bonewagon_gl_backup, "bonewagon_gl.cos")
        bonewagon:setpos(-2.8169899, -3.0120001, 0)
        bonewagon:setrot(0, 39.022099, 0)
        bonewagon:play_chore(bonewagon_gl_no_shocks, "bonewagon_gl.cos")
        glottis:wait_for_message()
        bonewagon.walk_rate = 0.1
        local3 = 0
        while local3 < 100 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate + 0.1
            bonewagon:walk_forward()
            break_here()
            local3 = local3 + system.frameTime
        end
        start_script(sg.signpost_vibrate, sg)
        start_sfx("bwrev01.wav", IM_HIGH_PRIORITY, bonewagon.max_volume)
        local3 = 0
        while local3 < 200 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate + 0.2
            bonewagon:walk_forward()
            break_here()
            local3 = local3 + system.frameTime
        end
        local3 = 0
        bonewagon:set_turn_rate(10)
        while bonewagon.walk_rate > 0.1 and local3 < 2000 do
            bonewagon:set_walk_rate(bonewagon.walk_rate)
            bonewagon.walk_rate = bonewagon.walk_rate - 0.02
            bonewagon:walk_forward()
            TurnActor(bonewagon.hActor, -1)
            break_here()
            local3 = local3 + system.frameTime
        end
        bonewagon.walk_rate = 0.1
        bonewagon:set_walk_rate(bonewagon.walk_rate)
        glottis:say_line("/sugl165/")
        glottis:wait_for_message()
    end
    END_CUT_SCENE()
    bonewagon.current_set = nil
    if signpost.current_set == system.currentSet then
        signpost:set_collision_mode(COLLISION_BOX, 0.40000001)
    end
    system.currentSet.bone_wagon:make_untouchable()
    manny.is_driving = TRUE
    bonewagon:default()
    start_script(bonewagon.monitor_turns, bonewagon)
    sg:enable_bonewagon_boxes(TRUE)
    system.buttonHandler = bone_wagon_button_handler
    bonewagon:set_selected()
    manny:put_in_set(nil)
    music_state:set_state(stateOO_BONE)
end
sg.signpost_lean = function(arg1) -- line 1314
    local local1 = 5
    while local1 < 25 do
        SetActorPitch(signpost.hActor, local1)
        local1 = local1 + local1 / 2
        break_here()
    end
end
sg.signpost_vibrate = function(arg1) -- line 1323
    local local1 = 25
    local local2 = 1
    start_sfx("sgSgnStp.wav")
    while abs(local1) > 1 do
        SetActorPitch(signpost.hActor, local1 * local2)
        local1 = local1 - local1 / 6
        local2 = -local2
        break_here()
    end
    SetActorPitch(signpost.hActor, 0)
end
sg.park_BW_obj = function(arg1) -- line 1337
    local local1
    local local2 = { }
    bonewagon:stop_movement_scripts()
    bonewagon:wait_for_actor()
    bonewagon:stop_movement_scripts()
    local1 = bonewagon:getpos()
    system.currentSet.bone_wagon.obj_x = local1.x
    system.currentSet.bone_wagon.obj_y = local1.y
    system.currentSet.bone_wagon.obj_z = local1.z + 0.25
    system.currentSet.bone_wagon.interest_actor:setpos(local1.x, local1.y, local1.z)
    local1 = { }
    local1.x, local1.y, local1.z = bonewagon:get_manny_pos()
    system.currentSet.bone_wagon.use_pnt_x = local1.x
    system.currentSet.bone_wagon.use_pnt_y = local1.y
    system.currentSet.bone_wagon.use_pnt_z = local1.z
    local2.x, local2.y, local2.z = bonewagon:get_manny_rot()
    system.currentSet.bone_wagon.use_rot_x = local2.x
    system.currentSet.bone_wagon.use_rot_y = local2.y
    system.currentSet.bone_wagon.use_rot_z = local2.z
    system.currentSet.bone_wagon:make_touchable()
end
sg.leave_BW = function(arg1, arg2) -- line 1364
    local local1, local2, local3
    START_CUT_SCENE()
    stop_script(bonewagon.gas)
    stop_script(bonewagon.reverse)
    stop_script(bonewagon.left)
    stop_script(bonewagon.right)
    bonewagon:brake(TRUE)
    END_CUT_SCENE()
    if not arg2 then
        if system.currentSet.enable_bonewagon_boxes then
            system.currentSet:enable_bonewagon_boxes(FALSE)
        end
        if not bonewagon:can_get_out_here() then
            if system.currentSet.enable_bonewagon_boxes then
                system.currentSet:enable_bonewagon_boxes(TRUE)
            end
            local1 = bonewagon:find_safe_out_point()
            if local1 then
                system.default_response("not here")
                local1 = system.currentSet.bw_out_points[local1]
                bonewagon:drivetorot(local1.pos.x, local1.pos.y, local1.pos.z, local1.rot.x, local1.rot.y, local1.rot.z)
                bonewagon:wait_for_actor()
            else
                system.default_response("no room")
                return
            end
        end
    end
    bonewagon:stop_cruise_sounds(TRUE)
    fade_sfx("bwIdle.IMU", 1000, 0)
    if system.currentSet.enable_bonewagon_boxes then
        system.currentSet:enable_bonewagon_boxes(FALSE)
    end
    sg:park_BW_obj()
    manny.is_driving = FALSE
    stop_script(bonewagon.monitor_turns)
    system.buttonHandler = SampleButtonHandler
    START_CUT_SCENE()
    bonewagon:play_chore(bonewagon_gl_ma_jump_out, "bonewagon_gl.cos")
    bonewagon:wait_for_chore(bonewagon_gl_ma_jump_out, "bonewagon_gl.cos")
    bonewagon:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    manny:put_in_set(system.currentSet)
    local1, local2, local3 = bonewagon:get_manny_pos(TRUE)
    manny:setpos(local1, local2, local3)
    local1, local2, local3 = bonewagon:get_manny_rot(TRUE)
    manny:setrot(local1, local2, local3)
    manny:set_selected()
    manny:set_visibility(TRUE)
    bonewagon:play_chore(bonewagon_gl_hide_ma, "bonewagon_gl.cos")
    local1 = 0
    while local1 < 1000 do
        manny:walk_forward()
        break_here()
        local1 = local1 + system.frameTime
    end
    manny:set_collision_mode(COLLISION_SPHERE, 0.5)
    bonewagon:set_collision_mode(COLLISION_BOX, 1)
    END_CUT_SCENE()
    inventory_disabled = FALSE
    bonewagon.current_set = system.currentSet
    bonewagon.current_pos = bonewagon:getpos()
    bonewagon.current_rot = bonewagon:getrot()
    bonewagon:stop_cruise_sounds(TRUE)
    start_script(sg.signpost_uncollapse, sg)
    single_start_script(sg.glottis_roars, sg)
    music_state:update(system.currentSet)
end
sg.enable_bonewagon_boxes = function(arg1, arg2) -- line 1448
    local local1, local2
    local1 = 1
    while local1 <= 17 do
        local2 = "bw_box" .. local1
        MakeSectorActive(local2, arg2)
        local1 = local1 + 1
    end
    local1 = 1
    while local1 <= 22 do
        local2 = "mn_box" .. local1
        MakeSectorActive(local2, not arg2)
        local1 = local1 + 1
    end
    if not arg2 then
        local1 = not sg.glottis_obj.touchable
        MakeSectorActive("glot_box1", local1)
        MakeSectorActive("glot_box2", local1)
        MakeSectorActive("glot_box3", local1)
        MakeSectorActive("no_glot_box1", sg.glottis_obj.touchable)
        MakeSectorActive("no_glot_box2", sg.glottis_obj.touchable)
        MakeSectorActive("no_glot_box3", sg.glottis_obj.touchable)
    else
        MakeSectorActive("glot_box1", FALSE)
        MakeSectorActive("glot_box2", FALSE)
        MakeSectorActive("glot_box3", FALSE)
        MakeSectorActive("no_glot_box1", FALSE)
        MakeSectorActive("no_glot_box2", FALSE)
        MakeSectorActive("no_glot_box3", FALSE)
    end
    MakeSectorActive("sg_sp_box_bw", arg2)
    MakeSectorActive("sg_sm_box_bw", arg2)
end
sg.update_glottis = function(arg1) -- line 1492
    stop_script(sg.glottis_roars)
    stop_script(glottis.talk_randomly_from_weighted_table)
    ExpireText()
    if glottis.ripped_heart then
        if glottis.heartless then
            glottis:default()
            glottis:put_in_set(sg)
            glottis:ignore_boxes()
            glottis:setpos(-2.76674, -4.90863, 0)
            glottis:setrot(0, 41.4323, 0)
            glottis:push_costume("glottis_throws.cos")
            glottis:play_chore(glottis_throws_sleep)
            if not find_script(glottis.talk_randomly_from_weighted_table) then
                start_script(glottis.talk_randomly_from_weighted_table, glottis, glottis.snores)
            end
            MakeSectorActive("glot_box1", FALSE)
            MakeSectorActive("glot_box2", FALSE)
            MakeSectorActive("glot_box3", FALSE)
            MakeSectorActive("no_glot_box1", TRUE)
            MakeSectorActive("no_glot_box2", TRUE)
            MakeSectorActive("no_glot_box3", TRUE)
        else
            sg.glottis_obj:make_untouchable()
            if not manny.is_driving then
                MakeSectorActive("glot_box1", TRUE)
                MakeSectorActive("glot_box2", TRUE)
                MakeSectorActive("glot_box3", TRUE)
            end
            MakeSectorActive("no_glot_box1", FALSE)
            MakeSectorActive("no_glot_box2", FALSE)
            MakeSectorActive("no_glot_box3", FALSE)
            glottis:free()
            glottis:put_in_set(nil)
            if bonewagon.current_set == sg and not manny.is_driving then
                single_start_script(sg.glottis_roars, sg, bonewagon)
            end
        end
    else
        MakeSectorActive("glot_box1", TRUE)
        MakeSectorActive("glot_box2", TRUE)
        MakeSectorActive("glot_box3", TRUE)
        MakeSectorActive("no_glot_box1", FALSE)
        MakeSectorActive("no_glot_box2", FALSE)
        MakeSectorActive("no_glot_box3", FALSE)
    end
end
sg.glottis_rip_heart = function(arg1) -- line 1546
    glottis.ripped_heart = TRUE
    glottis.heartless = TRUE
    sp.web.contains = sp.heart
    START_CUT_SCENE()
    music_state:set_sequence(seqGlottisHeart)
    set_override(sg.glottis_rip_heart_override, sg)
    sg:current_setup(sg_sgnha)
    LoadCostume("glottis_throws.cos")
    LoadCostume("glottis_cry.cos")
    manny:setpos(-5.56994, -4.63949, 0)
    manny:setrot(0, 306.939, 0)
    glottis:default()
    glottis:put_in_set(sg)
    glottis:push_costume("glottis_cry.cos")
    glottis:ignore_boxes()
    glottis:setpos(-2.76674, -4.90863, 0)
    glottis:setrot(0, 41.4323, 0)
    glottis:play_chore_looping(glottis_cry_cry_cyc, "glottis_cry.cos")
    sg:current_setup(sg_sgnha)
    manny:walkto(-5.19219, -4.35516, 0)
    glottis:say_line("/sggl023/")
    manny:wait_for_actor()
    manny:setrot(0, 274.838, 0)
    glottis:wait_for_message()
    glottis:say_line("/sggl024/")
    manny:walkto(-3.36409, -4.55001, 0)
    sleep_for(500)
    sg:current_setup(sg_spdws)
    manny:setpos(-3.75837, -4.61657, 0)
    manny:setrot(0, 263.997, 0)
    manny:walkto(-3.46798, -4.64709, 0, 0, 263.962, 0)
    manny:wait_for_actor()
    manny:turn_toward_entity(-2.6755, -4.83566, 0)
    manny:head_look_at_point(-2.98244, -4.81335, 0.552)
    glottis:wait_for_message()
    manny:hand_gesture()
    manny:say_line("/sgma025/")
    manny:wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/sgma026/")
    glottis:set_chore_looping(glottis_cry_cry_cyc, FALSE, "glottis_cry.cos")
    glottis:wait_for_chore("glottis_cry_cry_cyc", "glottis_cry.cos")
    glottis:play_chore(glottis_cry_cry_out, "glottis_cry.cos")
    manny:wait_for_message()
    glottis:say_line("/sggl027/")
    glottis:wait_for_message()
    glottis:play_chore(glottis_cry_head_swing_in, "glottis_cry.cos")
    glottis:say_line("/sggl028/")
    glottis:wait_for_chore(glottis_cry_head_swing_in, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_head_swing_cyc, "glottis_cry.cos")
    wait_for_message()
    glottis:set_chore_looping(glottis_cry_head_swing_cyc, FALSE, "glottis_cry.cos")
    glottis:say_line("/sggl029/")
    glottis:wait_for_chore(glottis_cry_head_swing_cyc, "glottis_cry.cos")
    glottis:play_chore(glottis_cry_head_swing_out, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_head_swing_out, "glottis_cry.cos")
    sleep_for(500)
    glottis:say_line("/sggl023/")
    glottis:play_chore(glottis_cry_tantrum_in, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_tantrum_in, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_tantrum_cyc, "glottis_cry.cos")
    wait_for_message()
    manny:say_line("/sgma030/")
    glottis:set_chore_looping(glottis_cry_tantrum_cyc, FALSE, "glottis_cry.cos")
    glottis:wait_for_chore(glottis_cry_tantrum_cyc, "glottis_cry.cos")
    glottis:play_chore_looping(glottis_cry_tantrum_out, "glottis_cry.cos")
    wait_for_message()
    glottis:wait_for_chore(glottis_cry_tantrum_out, "glottis_cry.cos")
    glottis:stop_chore()
    glottis:push_costume("glottis_throws.cos")
    glottis:play_chore(glottis_throws_throws, "glottis_throws.cos")
    glottis:say_line("/sggl031/")
    wait_for_message()
    glottis:say_line("/sggl032/")
    wait_for_message()
    glottis:say_line("/sggl034/")
    wait_for_message()
    glottis:say_line("/sggl035/")
    wait_for_message()
    glottis:say_line("/sggl036/")
    wait_for_message()
    glottis:wait_for_chore()
    glottis:play_chore(glottis_throws_sleep, "glottis_throws.cos")
    break_here()
    manny:say_line("/sgma038/")
    sleep_for(500)
    start_script(manny.walkto_object, manny, sg.glottis_obj)
    manny:wait_for_message()
    manny:wait_for_actor()
    glottis:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/sgma039/")
    break_here()
    manny:wait_for_message()
    END_CUT_SCENE()
    start_script(cut_scene.sp06a, cut_scene)
    wait_for_script(cut_scene.sp06a)
    wait_for_message()
    sg:update_glottis()
end
sg.glottis_rip_heart_override = function(arg1) -- line 1669
    kill_override()
    sg:switch_to_set()
    sg:current_setup(sg_spdws)
    manny:shut_up()
    glottis:stop_chore()
    glottis:shut_up()
    manny:default()
    manny:put_at_object(sg.glottis_obj)
    if not find_script(glottis.talk_randomly_from_weighted_table) then
        start_script(glottis.talk_randomly_from_weighted_table, glottis, glottis.snores)
    end
    sg:update_glottis()
end
sg.replace_heart = function() -- line 1685
    cur_puzzle_state[11] = TRUE
    sg.heart:put_in_limbo()
    sg.glottis_obj:make_untouchable()
    glottis.heartless = FALSE
    sg.bone_wagon.contains = glottis
    stop_script(glottis.talk_randomly_from_weighted_table)
    set_override(sg.replace_heart_override)
    START_CUT_SCENE()
    manny:walkto(-2.23264, -4.77272, 0, 0, 131.467, 0)
    manny:wait_for_actor()
    MakeSectorActive("glot_box1", TRUE)
    MakeSectorActive("glot_box2", TRUE)
    manny:walkto(-2.23264, -4.77272, 0, 0, 131.467, 0)
    manny:wait_for_actor()
    manny:stop_chore(ma_activate_heart, "ma.cos")
    manny:stop_chore(ma_hold, "ma.cos")
    manny:push_costume("ma_save_gl.cos")
    glottis:shut_up()
    glottis:stop_chore()
    glottis:pop_costume()
    glottis:push_costume("gl_saved.cos")
    glottis:head_look_at(nil)
    glottis:play_chore(gl_saved_saved, "gl_saved.cos")
    manny:play_chore(ma_save_gl_save_glottis, "ma_save_gl.cos")
    sleep_for(2000)
    stop_sound("glHrtBt.IMU")
    start_sfx("sgHrtShv.wav")
    sleep_for(4000)
    glottis:say_line("/cpdgl12a/")
    wait_for_message()
    glottis:say_line("/cpdgl12b/")
    wait_for_message()
    glottis:say_line("/cpdgl12c/")
    wait_for_message()
    glottis:say_line("/cpdgl12d/")
    wait_for_message()
    glottis:say_line("/cpdgl12e/")
    wait_for_message()
    glottis:say_line("/cpdgl12f/")
    wait_for_message()
    glottis:wait_for_chore()
    manny:wait_for_chore()
    IrisDown(320, 240, 1000)
    sleep_for(1500)
    manny:pop_costume()
    glottis:pop_costume()
    glottis:default()
    END_CUT_SCENE()
    inventory_disabled = FALSE
    start_script(cut_scene.copaldie, cut_scene)
end
sg.replace_heart_override = function() -- line 1747
    kill_override()
    manny:stop_chore()
    manny:stop_chore(ma_activate_heart, "ma.cos")
    manny:stop_chore(ma_hold, "ma.cos")
    manny:pop_costume()
    glottis:shut_up()
    glottis:stop_chore()
    glottis:pop_costume()
    stop_sound("glHrtBt.IMU")
    glottis:default()
    start_script(sg.get_in_BW)
end
sg.rubacava_point = { x = 2.138, y = 12.1412, z = 0 }
sg.enter = function(arg1) -- line 1769
    sg:update_glottis()
    manny:set_collision_mode(COLLISION_SPHERE, 0.4)
    if sg.signpost.touchable and signpost.current_set == arg1 then
        sg.signpost:make_visible()
    end
    if not sg.bone_wagon.ridden then
        bonewagon:default()
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(2.88665, -0.798663, 0)
        bonewagon:setrot(0, 219.129, 0)
    end
    if bonewagon.current_set == arg1 then
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(bonewagon.current_pos.x, bonewagon.current_pos.y, bonewagon.current_pos.z)
        bonewagon:setrot(bonewagon.current_rot.x, bonewagon.current_rot.y, bonewagon.current_rot.z)
        if not manny.is_driving then
            single_start_script(sg.glottis_roars, sg, bonewagon)
        end
    end
    if not manny.is_driving then
        sg:enable_bonewagon_boxes(FALSE)
    else
        sg:enable_bonewagon_boxes(TRUE)
    end
    if sg.heart.touchable then
        preload_sfx("sgGetHrt.wav")
        preload_sfx("sgHrtShv.wav")
        sg.heart:make_touchable()
        start_sfx("glHrtBt.imu", IM_HIGH_PRIORITY, sp.heartbeat_vol_medium)
    else
        sg.heart:make_untouchable()
    end
    if manny.is_driving then
        bonewagon:default()
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
    end
    sg:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
sg.camerachange = function(arg1, arg2, arg3) -- line 1820
    if arg3 == sg_spdws then
        if manny.is_driving or bonewagon:in_danger_box() then
            sg:current_setup(arg2)
        end
    end
    if signpost.current_set == sg and manny.is_holding ~= sg.signpost then
        if arg3 == sg_spdws then
            signpost:play_chore(signpost_show)
        else
            signpost:play_chore(signpost_show_lit)
        end
    end
    if sound_playing("glHrtBt.imu") then
        if arg3 == sg_spdws then
            set_vol("glHrtBt.imu", sp.heartbeat_vol_medium)
        else
            set_vol("glHrtBt.imu", sp.heartbeat_vol_far)
        end
    end
end
sg.update_music_state = function(arg1) -- line 1855
    if manny.is_driving then
        return stateOO_BONE
    else
        return stateSG
    end
end
sg.exit = function(arg1) -- line 1863
    manny:set_collision_mode(COLLISION_OFF)
    if sg.heart.visible_actor then
        sg.heart.visible_actor:free()
    end
    stop_script(glottis.talk_randomly_from_weighted_table)
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    glottis:free()
    bonewagon:shut_up()
    stop_sound("bwIdle.IMU")
    stop_sound("glHrtBt.imu")
end
sg.glottis_obj = Object:create(sg, "/sgtx043/Glottis", -2.4567201, -5.0476298, 0.3705, { range = 2 })
sg.glottis_obj.use_pnt_x = -2.23264
sg.glottis_obj.use_pnt_y = -4.7727199
sg.glottis_obj.use_pnt_z = 0
sg.glottis_obj.use_rot_x = 0
sg.glottis_obj.use_rot_y = 131.467
sg.glottis_obj.use_rot_z = 0
sg.glottis_obj.lookAt = function(arg1) -- line 1898
end
sg.glottis_obj.pickUp = function(arg1) -- line 1901
end
sg.glottis_obj.use = function(arg1) -- line 1904
end
sg.glottis_obj.lookAt = function(arg1) -- line 1907
    if glottis.heartless then
        manny:say_line("/sgma044/")
    else
        sg.bone_wagon:lookAt()
    end
end
sg.glottis_obj.pickUp = function(arg1) -- line 1915
    manny:say_line("/sgma045/")
end
sg.glottis_obj.use = function(arg1) -- line 1919
    if glottis.heartless then
        manny:say_line("/sgma046/")
    else
        sg:get_in_BW()
    end
end
sg.glottis_obj.use_heart = function(arg1) -- line 1927
    start_script(sg.replace_heart)
end
sg.glottis_obj.use_scythe = function(arg1) -- line 1931
    START_CUT_SCENE()
    manny:say_line("/sgma047/")
    manny:wait_for_message()
    manny:say_line("/sgma048/")
    END_CUT_SCENE()
end
sg.glottis_obj.use_bone = function(arg1) -- line 1939
    manny:say_line("/sgma049/")
end
sg.signpost = Object:create(sg, "/sgtx050/sign post", -1.87272, -4.17906, 0.60000002, { range = 1.5 })
sg.signpost.use_pnt_x = -1.71085
sg.signpost.use_pnt_y = -4.1479301
sg.signpost.use_pnt_z = 0
sg.signpost.use_rot_x = 0
sg.signpost.use_rot_y = 2617.03
sg.signpost.use_rot_z = 0
sg.signpost.uprooted = FALSE
sg.signpost.used_once = FALSE
sg.signpost.default_rot = { x = 0, y = 346.20999, z = 0 }
sg.signpost.can_put_away = FALSE
signpost.current_set = sg
signpost.current_pos = { x = -1.87272, y = -4.17906, z = 0 }
signpost.current_rot = { x = 0, y = 346.20999, z = 0 }
sg.signpost.lookAt = function(arg1) -- line 1962
    system.currentSet:examine_signpost()
end
sg.signpost.put_away = function(arg1) -- line 1966
    system.default_response("not now")
    return FALSE
end
sg.signpost.pickUp = function(arg1) -- line 1975
    if arg1.uprooted then
        if manny:walk_closeto_object(arg1, 0.8) then
            cur_puzzle_state[12] = TRUE
            START_CUT_SCENE()
            arg1.used_once = TRUE
            manny:wait_for_actor()
            signpost:set_collision_mode(COLLISION_OFF)
            manny:walkto_object(arg1)
            manny:wait_for_actor()
            signpost:pick_up()
            sg.signpost:get()
            manny.is_holding = arg1
            sg.signpost:make_untouchable()
            END_CUT_SCENE()
            signpost.current_set = nil
        else
            system.default_repsonse("reach")
        end
    elseif manny:walk_closeto_object(arg1, 0.8) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        signpost:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:push_costume("ma_action_sign.cos")
        manny:play_chore(ma_action_sign_try_to_lift, "ma_action_sign.cos")
        manny:wait_for_chore()
        manny:pop_costume()
        manny:say_line("/sgma052/")
        signpost:set_collision_mode(COLLISION_BOX, 0.3)
        END_CUT_SCENE()
    else
        system.default_response("reach")
    end
end
sg.signpost.plant = function(arg1) -- line 2014
    local local1, local2, local3
    local local4
    local local5, local6
    local local7
    local local8 = FALSE
    local local9, local10, local11
    if bonewagon.current_set == system.currentSet then
        local9, local10, local11 = bonewagon:get_manny_far_pos()
        if proximity(manny.hActor, bonewagon.hActor) < 2 or proximity(manny.hActor, local9, local10, local11) < 1.5 then
            system.default_response("not here")
            manny:wait_for_message()
            manny:say_line("/sgma065/")
            return FALSE
        end
    end
    local3 = { }
    local3.x, local3.y, local3.z = signpost:get_future_manny_pos()
    if not GetPointSector(local3.x, local3.y, local3.z) then
        system.default_response("no room")
        return FALSE
    end
    START_CUT_SCENE()
    arg1:free()
    manny.is_holding = nil
    inventory_disabled = FALSE
    if system.currentSet == na or (system.currentSet == sg and sg:current_setup() ~= sg_spdws) then
        local7 = { }
        local7.pos = manny:getpos()
        local7.rot = manny:getrot()
        signpost:put_at_manny(TRUE)
        local7.signpos = signpost:getpos()
        local7.destangle = GetActorYawToPoint(signpost.hActor, system.currentSet.rubacava_point)
        if system.currentSet == na then
            na:current_setup(na_mancu)
        else
            sg:current_setup(sg_mancu)
        end
        if bonewagon.current_set == system.currentSet then
            bonewagon:set_visibility(FALSE)
            bonewagon:set_collision_mode(COLLISION_OFF)
        end
        manny:setpos(3.8364899, -1.23856, 0.5)
    end
    signpost:put_down()
    signpost:play_chore(signpost_show)
    if system.currentSet == sg then
        local4 = arg1
    else
        local4 = na.signpost
    end
    signpost:set_collision_mode(COLLISION_OFF)
    manny:backup(500)
    signpost:set_collision_mode(COLLISION_BOX, 0.30000001)
    if system.currentSet == na then
        if na:check_for_nav_solved(local7.signpos) then
            local8 = TRUE
        end
    end
    if not local8 then
        if local7 then
            sg.signpost:spin(system.currentSet.rubacava_point, local7.destangle)
            manny:setrot(0, local7.destangle, 0, TRUE)
            manny:wait_for_actor()
            sleep_for(1000)
            local1 = signpost:getpos()
            local3 = manny:getpos()
            if system.currentSet == sg then
                sg:current_setup(sg_sgnha)
            else
                na:current_setup(na_intha)
            end
            if bonewagon.current_set == system.currentSet then
                bonewagon:set_visibility(TRUE)
                bonewagon:set_collision_mode(COLLISION_BOX, 1)
            end
            signpost:play_chore(signpost_show_lit)
            signpost:setpos(local7.signpos.x, local7.signpos.y, local7.signpos.z)
            local3.x = local7.signpos.x - (local1.x - local3.x)
            local3.y = local7.signpos.y - (local1.y - local3.y)
            local3.z = local7.signpos.z
            manny:setpos(local3.x, local3.y, local3.z)
            signpost:setrot(0, local7.destangle, 0)
        else
            sg.signpost:spin(system.currentSet.rubacava_point)
            if system.currentSet == sg and sg:current_setup() ~= sg_spdws then
                signpost:play_chore(signpost_show_lit)
            end
        end
        local4.interest_actor:put_in_set(system.currentSet)
        local1 = signpost:getpos()
        local4.obj_x = local1.x
        local4.obj_y = local1.y
        local4.obj_z = local1.z + 0.60000002
        local4.interest_actor:setpos(local4.obj_x, local4.obj_y, local4.obj_z)
        local4:make_touchable()
        local4.use_pnt_x, local4.use_pnt_y, local4.use_pnt_z = signpost:get_manny_pos()
        local2 = signpost:getrot()
        local4.use_rot_x = local2.x
        local4.use_rot_y = local2.y + 110
        local4.use_rot_z = local2.z
        signpost:set_collision_mode(COLLISION_BOX, 0.30000001)
    end
    END_CUT_SCENE()
    if not local8 then
        signpost.current_set = system.currentSet
        signpost.current_pos = signpost:getpos()
        signpost.current_rot = signpost:getrot()
    end
    return TRUE
end
sg.signpost.spin = function(arg1, arg2, arg3) -- line 2146
    local local1
    local local2, local3
    local local4, local5
    local1 = signpost:getrot()
    while local1.y > 360 do
        local1.y = local1.y - 360
    end
    while local1.y < 0 do
        local1.y = local1.y + 360
    end
    local2 = 0
    local3 = 1
    start_sfx("sgSgnRot.IMU")
    while local2 < 5 do
        local1.y = local1.y + local3
        if local3 < 40 then
            local3 = local3 + 1
        end
        if local1.y > 360 then
            local1.y = local1.y - 360
            local2 = local2 + 1
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    if not arg3 then
        arg3 = GetActorYawToPoint(signpost.hActor, arg2)
    end
    while arg3 > 360 do
        arg3 = arg3 - 360
    end
    while arg3 < 0 do
        arg3 = arg3 + 360
    end
    fade_sfx("sgSgnRot.IMU", 200, 0)
    start_sfx("sgSgnSlw.WAV", 127, 0)
    fade_sfx("sgSgnSlw.WAV", 200, 127)
    while local3 > 1 do
        local1.y = local1.y + local3
        local3 = local3 - local3 / 4
        if local1.y > 360 then
            local1.y = local1.y - 360
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    stop_sound("sgSgnRot.IMU")
    local3 = 1
    local4 = arg3
    if local4 > local1.y then
        local4 = local4 - 360
    end
    local5 = 0
    while local1.y > local4 do
        local1.y = local1.y - local3
        local3 = local3 + local3 / 2
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
        local5 = local5 + system.frameTime
        if local5 >= 150 then
            single_start_sfx("sgSgnStp.WAV")
        end
    end
    if local5 < 100 then
        single_start_sfx("sgSgnStp.WAV")
    end
    if abs(local1.y - local4) < local3 then
        local3 = abs(local1.y - local4)
    end
    while abs(local1.y - local4) > 1 do
        local3 = local3 - local3 / 3
        if local1.y > local4 then
            local1.y = local4 - local3
        else
            local1.y = local4 + local3
        end
        signpost:setrot(local1.x, local1.y, local1.z)
        break_here()
    end
    signpost:setrot(0, arg3, 0)
end
sg.signpost.use = function(arg1) -- line 2243
    if manny.is_holding == arg1 then
        arg1:plant()
    else
        sg.signpost:pickUp()
    end
end
sg.signpost.use_scythe = function(arg1) -- line 2251
    if arg1.uprooted then
        manny:say_line("/sgma054/")
    else
        manny:say_line("/sgma055/")
        manny:wait_for_message()
        manny:say_line("/sgma056/")
    end
end
sg.signpost.make_visible = function(arg1) -- line 2261
    signpost:default()
    signpost:put_in_set(system.currentSet)
    signpost:setpos(signpost.current_pos.x, signpost.current_pos.y, signpost.current_pos.z)
    signpost:setrot(signpost.current_rot.x, signpost.current_rot.y, signpost.current_rot.z)
    signpost:play_chore(signpost_show, "signpost.cos")
end
sg.heart = Object:create(sg, "/sgtx057/heart", -2.80985, -4.17379, 0.073100001, { range = 1 })
sg.heart.use_pnt_x = -2.6830399
sg.heart.use_pnt_y = -4.1160302
sg.heart.use_pnt_z = 0
sg.heart.use_rot_x = 0
sg.heart.use_rot_y = 118.755
sg.heart.use_rot_z = 0
sg.heart.wav = "spHrtWeb.wav"
sg.heart.touchable = FALSE
sg.heart.can_put_away = FALSE
sg.heart.lookAt = function(arg1) -- line 2282
    arg1.seen = TRUE
    manny:say_line("/spma010/")
end
sg.heart.pickUp = function(arg1) -- line 2287
    if manny:walk_closeto_object(arg1, 0.5) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        arg1.visible_actor:set_collision_mode(COLLISION_OFF)
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:play_chore(ma_reach_low, "ma.cos")
        sleep_for(650)
        sg.heart:get()
        sg.heart:make_untouchable()
        manny:play_chore_looping(ma_activate_heart_beat, "ma.cos")
        start_sfx("sgGetHrt.wav")
        sleep_for(500)
        manny:play_chore_looping(ma_hold, "ma.cos")
        manny:stop_chore(ma_reach_low, "ma.cos")
        manny.is_holding = arg1
        if not arg1.seen then
            arg1:lookAt()
        end
        END_CUT_SCENE()
    end
end
sg.heart.use = function(arg1) -- line 2311
    if arg1.owner == manny then
        manny:say_line("/sgma058/")
    else
        arg1:pickUp()
    end
end
sg.heart.default_response = function(arg1) -- line 2319
    manny:say_line("/sgma059/")
end
sg.heart.use_scythe = function(arg1) -- line 2323
    manny:say_line("/sgma060/")
end
sg.heart.make_touchable = function(arg1) -- line 2327
    if not arg1.visible_actor then
        arg1.visible_actor = Actor:create(nil, nil, nil, arg1.name)
    end
    Object.make_touchable(arg1)
    arg1.visible_actor:set_costume("sp_glottis_heart.cos")
    arg1.visible_actor:put_in_set(sg)
    arg1.visible_actor:setpos(arg1.obj_x, arg1.obj_y, arg1.obj_z)
    arg1.visible_actor:setrot(0, 0, 0)
    arg1.visible_actor:set_visibility(TRUE)
    arg1.visible_actor:play_chore_looping(0)
    arg1.visible_actor:set_collision_mode(COLLISION_BOX, 1.1)
end
sg.heart.make_untouchable = function(arg1) -- line 2342
    if arg1.visible_actor then
        arg1.visible_actor:set_collision_mode(COLLISION_OFF)
        arg1.visible_actor:put_in_set(nil)
        arg1.visible_actor:set_visibility(FALSE)
        arg1.visible_actor:stop_chore(0)
    end
    Object.make_untouchable(arg1)
end
sg.heart.put_away = function(arg1) -- line 2352
    arg1:default_response()
    return FALSE
end
sg.bone_wagon = Object:create(sg, "/sgtx061/Bone Wagon", 3.50579, -0.84495902, 0.2538, { range = 2.5 })
sg.bone_wagon.use_pnt_x = 1.63726
sg.bone_wagon.use_pnt_y = -0.094200999
sg.bone_wagon.use_pnt_z = 0
sg.bone_wagon.use_rot_x = 0
sg.bone_wagon.use_rot_y = 301.353
sg.bone_wagon.use_rot_z = 0
sg.bone_wagon.lookAt = function(arg1) -- line 2366
    if not glottis.heartless then
        manny:say_line("/sgma062/")
    else
        manny:say_line("/sgma063/")
    end
end
sg.bone_wagon.pickUp = function(arg1) -- line 2374
    system.default_response("tow")
end
sg.bone_wagon.use = function(arg1) -- line 2378
    if not glottis.heartless then
        sg:get_in_BW()
    else
        manny:say_line("/trma068/")
    end
end
sg.bone_wagon.use_scythe = function(arg1) -- line 2386
    manny:say_line("/sgma065/")
end
sg.bone_wagon.use_bone = function(arg1) -- line 2390
    manny:say_line("/sgma066/")
end
sg.sm_door = Object:create(sg, "/sgtx067/trail", -5.7180099, -5.4510102, 1.1, { range = 1.5 })
sg.sg_sm_box = sg.sm_door
sg.sg_sm_box_bw = sg.sm_door
sg.sm_door.use_pnt_x = -4.5913901
sg.sm_door.use_pnt_y = -4.3188801
sg.sm_door.use_pnt_z = 0
sg.sm_door.use_rot_x = 0
sg.sm_door.use_rot_y = -224.203
sg.sm_door.use_rot_z = 0
sg.sm_door.out_pnt_x = -5.1719098
sg.sm_door.out_pnt_y = -4.9159999
sg.sm_door.out_pnt_z = 0
sg.sm_door.out_rot_x = 0
sg.sm_door.out_rot_y = -224.203
sg.sm_door.out_rot_z = 0
sg.sm_door.walkOut = function(arg1) -- line 2416
    if manny.is_driving then
        bonewagon:squelch_sfx()
        if rnd(5) then
            glottis:say_line("/sggl071/")
        else
            glottis:say_line("/sggl069/")
        end
        glottis:wait_for_message()
        bonewagon:restore_sfx()
    elseif glottis.heartless then
        manny:say_line("/sgma070/")
    elseif not sg:check_post(arg1) then
        sm:come_out_door(sm.sg_door)
    end
end
sg.sm_door.comeOut = function(arg1) -- line 2435
    if not glottis.ripped_heart then
        start_script(sg.glottis_rip_heart)
    else
        arg1:come_out_door()
    end
end
sg.sp_door = Object:create(sg, "/sgtx072/path", -2.20207, -6.4960999, 0.47999999, { range = 1.5 })
sg.sg_sp_box = sg.sp_door
sg.sg_sp_box_bw = sg.sp_door
sg.sp_door.use_pnt_x = -2.9080701
sg.sp_door.use_pnt_y = -6.0844102
sg.sp_door.use_pnt_z = 0
sg.sp_door.use_rot_x = 0
sg.sp_door.use_rot_y = 197.575
sg.sp_door.use_rot_z = 0
sg.sp_door.out_pnt_x = -2.1252999
sg.sp_door.out_pnt_y = -6.5885901
sg.sp_door.out_pnt_z = 0
sg.sp_door.out_rot_x = 0
sg.sp_door.out_rot_y = -152.37801
sg.sp_door.out_rot_z = 0
sg.sp_door.lookAt = function(arg1) -- line 2464
    manny:say_line("/sgma073/")
end
sg.sp_door.walkOut = function(arg1) -- line 2468
    if manny.is_driving then
        bonewagon:squelch_sfx()
        glottis:say_line("/sggl074/")
        glottis:wait_for_message()
        bonewagon:restore_sfx()
    elseif not sg:check_post(arg1) then
        if not sp.seen_intro then
            sp.intro_flag = TRUE
        end
        sp:come_out_door(sp.sg_door)
    end
end
sg.sp_door.comeOut = function(arg1) -- line 2484
    system.lock_display()
    break_here()
    sg:current_setup(2)
    manny:setpos(-2.89254, -6.14322, 0)
    manny:setrot(0, 746.691, 0)
    system.unlock_display()
end
sg.mod_door = Object:create(sg, "/sgtx075/bumpy road", 12.542, 4.9489999, 0.80000001, { range = 1.5 })
sg.sg_mod_box = sg.mod_door
sg.mod_door.use_pnt_x = 11.1404
sg.mod_door.use_pnt_y = 3.9449799
sg.mod_door.use_pnt_z = 0
sg.mod_door.use_rot_x = 0
sg.mod_door.use_rot_y = 320.28
sg.mod_door.use_rot_z = 0
sg.mod_door.out_pnt_x = 11.6844
sg.mod_door.out_pnt_y = 4.5656199
sg.mod_door.out_pnt_z = 0
sg.mod_door.out_rot_x = 0
sg.mod_door.out_rot_y = 301.72699
sg.mod_door.out_rot_z = 0
sg.mod_door.lookAt = function(arg1) -- line 2514
    if glottis.talked_clearance then
        START_CUT_SCENE()
        manny:say_line("/sgma076/")
        manny:wait_for_message()
        manny:say_line("/sgma077/")
        END_CUT_SCENE()
    else
        manny:say_line("/sgma078/")
    end
end
sg.mod_door.walkOut = function(arg1) -- line 2526
    local local1
    if glottis.heartless then
        sg.sm_door:walkOut()
    elseif manny.is_driving then
        if mod_solved then
            START_CUT_SCENE()
            stop_script(bonewagon.gas)
            stop_script(bonewagon.reverse)
            stop_script(bonewagon.left)
            stop_script(bonewagon.right)
            bonewagon:brake(TRUE)
            bonewagon:stop_cruise_sounds()
            sleep_for(500)
            bonewagon:play_chore(bonewagon_gl_shocks)
            bonewagon:wait_for_chore(bonewagon_gl_shocks)
            bonewagon:play_chore_looping(bonewagon_gl_stay_Up)
            local1 = 0
            bonewagon:set_walk_rate(1)
            bonewagon:ignore_boxes()
            while local1 < 1000 do
                bonewagon:walk_forward()
                break_here()
                local1 = local1 + system.frameTime
            end
            bonewagon:stop_chore(bonewagon_gl_stay_up)
            bonewagon:play_chore(bonewagon_gl_no_shocks)
            bonewagon:follow_boxes()
            END_CUT_SCENE()
            bv:drive_in()
        elseif not glottis.talked_clearance then
            glottis.talked_clearance = TRUE
            bonewagon:squelch_sfx()
            glottis:say_line("/sggl079/")
            glottis:wait_for_message()
            glottis:say_line("/sggl080/")
            glottis:wait_for_message()
            bonewagon:restore_sfx()
        else
            bonewagon:squelch_sfx()
            glottis:say_line("/sggl081/")
            glottis:wait_for_message()
            bonewagon:restore_sfx()
        end
    elseif not sg:check_post(arg1) then
        bv:come_out_door(bv.sg_door)
    end
end
sg.na_door = Object:create(sg, "/sgtx082/trail", -0.498, 7.7490001, 0.27000001, { range = 1.5 })
sg.sg_na_box = sg.na_door
sg.na_door.use_pnt_x = -1.04241
sg.na_door.use_pnt_y = 6.2573299
sg.na_door.use_pnt_z = 0
sg.na_door.use_rot_x = 0
sg.na_door.use_rot_y = 332.31601
sg.na_door.use_rot_z = 0
sg.na_door.out_pnt_x = -0.35649699
sg.na_door.out_pnt_y = 7.70927
sg.na_door.out_pnt_z = 0
sg.na_door.out_rot_x = 0
sg.na_door.out_rot_y = -7.7764401
sg.na_door.out_rot_z = 0
sg.na_door.lookAt = function(arg1) -- line 2606
    manny:say_line("/sgma083/")
end
sg.na_door.walkOut = function(arg1) -- line 2610
    if glottis.heartless then
        sg.sm_door:walkOut()
    else
        na:come_out_door(na.sg_door)
    end
end
sg.tr_door = Object:create(sg, "/sgtx084/trail", 5.82793, -6.8160901, 0.5, { range = 1.5 })
sg.sg_tr_box = sg.tr_door
sg.tr_door.use_pnt_x = 5.3253398
sg.tr_door.use_pnt_y = -5.6335101
sg.tr_door.use_pnt_z = 0
sg.tr_door.use_rot_x = 0
sg.tr_door.use_rot_y = -143.755
sg.tr_door.use_rot_z = 0
sg.tr_door.out_pnt_x = 6.01823
sg.tr_door.out_pnt_y = -6.7782698
sg.tr_door.out_pnt_z = 0
sg.tr_door.out_rot_x = 0
sg.tr_door.out_rot_y = -156.267
sg.tr_door.out_rot_z = 0
sg.tr_door.lookAt = function(arg1) -- line 2637
    START_CUT_SCENE()
    ResetMarioControls()
    manny:say_line("/sgma085/")
    manny:setpos(5.43677, -5.04949, 0, 0, 11.5, 0)
    END_CUT_SCENE()
end
sg.tr_door.walkOut = function(arg1) -- line 2645
    if glottis.heartless then
        sg.sm_door:walkOut()
    elseif not manny.is_driving then
        arg1:lookAt()
    else
        tr:drive_in()
    end
end
CheckFirstTime("rf.lua")
dofile("pigeon_idles.lua")
dofile("ma_crumble_bread.lua")
rf = Set:create("rf.set", "Roof", { rf_nstoh = 0, rf_rufha = 1, rf_rufha2 = 1, rf_rufha3 = 1, rf_rufws = 2, rf_rufws2 = 2, rf_overhead = 3, rf_pigeon = 4 })
rf.camera_adjusts = { 320, 340, 25 }
rf.cheat_boxes = { rf_cheat_box_1 = 1, rf_cheat_box_2 = 2 }
rf.set_up_actors = function(arg1) -- line 34
    if not ma_crumble_bread_cos then
        ma_crumble_bread_cos = "ma_crumble_bread.cos"
    end
    rf.escape_point_1:set_object_state("le_copals_windows.cos")
    rf.escape_point_2:set_object_state("le_open_doms_window.cos")
    rf.escape_point_1.interest_actor:play_chore(0)
    rf.escape_point_2.interest_actor:complete_chore(0)
    rf.escape_point_1.touchable = FALSE
    rf.escape_point_2.touchable = FALSE
    if rf.pigeons_gone then
        MakeSectorActive("bird_threshhold", TRUE)
        MakeSectorActive("rf_nstoh", TRUE)
        rf.pigeons1:stop_chore(0)
        rf.pigeons1:play_chore(1)
        rf.pigeons1:make_untouchable()
        rf.pigeons2:make_untouchable()
        rf.pigeons3:make_untouchable()
    else
        rf.init_pigeons()
        rf.pigeons1:set_object_state("pigeon_os.cos")
        rf.pigeons1:play_chore_looping(0)
        MakeSectorActive("bird_threshhold", FALSE)
        MakeSectorActive("rf_nstoh", FALSE)
    end
    if not rf.egg_actor then
        rf.egg_actor = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor1 = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor2 = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor3 = Actor:create(nil, nil, nil, "egg_actor")
    end
    if rf.eggs.owner ~= manny then
        rf.egg_actor:put_in_set(rf)
        rf.egg_actor:setpos(-13.43, 11.2, 4.28)
        rf.egg_actor:setrot(0, -334.498, 0)
        rf.egg_actor:set_costume("eggs.cos")
    end
    rf.egg_actor1:put_in_set(rf)
    rf.egg_actor1:setpos(-13.4255, 11.3217, 4.3)
    rf.egg_actor1:setrot(0, 210, 0)
    rf.egg_actor1:set_costume("eggs.cos")
    rf.egg_actor2:put_in_set(rf)
    rf.egg_actor2:setpos(-13.5055, 11.3117, 4.29)
    rf.egg_actor2:setrot(0, 90, 0)
    rf.egg_actor2:set_costume("eggs.cos")
    rf.egg_actor3:put_in_set(rf)
    rf.egg_actor3:setpos(-13.4602, 11.245, 4.31)
    rf.egg_actor3:setrot(0, -334.498, 0)
    rf.egg_actor3:set_costume("eggs.cos")
end
rf.balloon_placement = { }
rf.balloon_placement.cat = { }
rf.balloon_placement.dingo = { }
rf.balloon_placement.frost = { }
rf.balloon_placement["cat"].x = -11.3502
rf.balloon_placement["cat"].y = 7.77496
rf.balloon_placement["cat"].z = 3.8199999
rf.balloon_placement["cat"].cos = "cat_balloon.cos"
rf.balloon_placement["cat"]["r"] = -54.182598
rf.balloon_placement["dingo"].x = -11.3502
rf.balloon_placement["dingo"].y = 7.77496
rf.balloon_placement["dingo"].z = 3.77
rf.balloon_placement["dingo"]["r"] = -57.493099
rf.balloon_placement["dingo"].cos = "dingo_balloon.cos"
rf.balloon_placement["frost"].x = -11.3802
rf.balloon_placement["frost"].y = 7.7449598
rf.balloon_placement["frost"].z = 3.8199999
rf.balloon_placement["frost"]["r"] = -57.493099
rf.balloon_placement["frost"].cos = "frost_balloon.cos"
rf.update_states = function(arg1) -- line 127
    local local1
    if not dish_item_actor then
        dish_item_actor = Actor:create(nil, nil, nil, "dish item")
    end
    if rf.dish.contains then
        if rf.dish.contains == fe.balloon_cat then
            local1 = "cat"
        elseif rf.dish.contains == fe.balloon_dingo then
            local1 = "dingo"
        elseif rf.dish.contains == fe.balloon_frost then
            local1 = "frost"
        end
        dish_item_actor:set_costume(rf.balloon_placement[local1].cos)
        dish_item_actor:put_in_set(rf)
        dish_item_actor:setpos(rf.balloon_placement[local1].x, rf.balloon_placement[local1].y, rf.balloon_placement[local1].z)
        dish_item_actor:setrot(0, rf.balloon_placement[local1].r, 0)
        dish_item_actor:scale(0.80000001)
        dish_item_actor:set_colormap("items_more.cmp")
    else
        dish_item_actor:free()
    end
    if rf.pigeons_gone then
        MakeSectorActive("bird_threshhold", TRUE)
        MakeSectorActive("rf_nstoh", TRUE)
        rf.pigeons1.touchable = FALSE
        rf.pigeons2.touchable = FALSE
        rf.pigeons3.touchable = FALSE
        rf.pigeons1:stop_chore(0)
        rf.pigeons1:play_chore(1)
    else
        rf.pigeons1.touchable = TRUE
        rf.pigeons2.touchable = TRUE
        rf.pigeons3.touchable = TRUE
        rf.pigeons1:play_chore_looping(0)
    end
end
rf.pigeon_liftoff = function(arg1) -- line 174
    while 1 do
        arg1:offsetBy(0, 0, rnd(0.008, 0.03))
        break_here()
    end
end
rf.pigeon_mover = function(arg1) -- line 181
    local local1 = 0
    local local2 = { }
    arg1.costume_marker_handler = nil
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    sleep_for(rnd(500, 1000))
    repeat
        arg1:setpos(-1, 4.5, 4.54)
        local2 = arg1:getpos()
        PointActorAt(arg1.hActor, 4.1999998, rnd(3.5, 6), 4.54)
        arg1:play_sound_at("flockFly.wav")
        while local2.x <= 2 do
            arg1:walk_forward()
            break_here()
            local2 = arg1:getpos()
        end
        local1 = local1 + 1
    until local1 == 3
end
rf.pigeons_eat_bread = function() -- line 201
    local local1 = 1
    START_CUT_SCENE()
    cur_puzzle_state[9] = TRUE
    if rf.dish_contains then
        rf.dish_contains:free()
    end
    rf.pigeons_gone = TRUE
    rf.dish.contains = nil
    stop_script(rf.pigeon_brain)
    stop_script(rf.pigeon_attack)
    stop_script(rf.fly_fly_fly)
    stop_script(rf.pigeon_eat)
    stop_script(rf.turn_toward_home)
    stop_script(bird_climb)
    stop_script(rf.pigeon_walk)
    stop_sound("flockeat.imu")
    sleep_for(100)
    start_sfx("bloonpop.wav")
    prop_pigeon:stop_chore(nil)
    prop_pigeon:push_chore(pigeon_idles_scared_takeoff)
    prop_pigeon:push_chore()
    dish_item_actor:free()
    start_script(rf.pigeon_liftoff, prop_pigeon)
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:play_chore(pigeon_idles_scared_takeoff)
        sleep_for(rnd(50, 150))
        start_script(rf.pigeon_liftoff, pigeons[local1])
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    local1 = 1
    sleep_for(1500)
    prop_pigeon:stop_chore(nil)
    prop_pigeon:put_in_set(nil)
    stop_script(rf.pigeon_liftoff)
    le:init_ropes()
    rf.pigeons1:stop_chore(0)
    rf.pigeons1:play_chore(1)
    rf:current_setup(rf_pigeon)
    local1 = 1
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:set_walk_rate(rnd(1, 2))
        start_script(rf.pigeon_mover, pigeons[local1])
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    sleep_for(6000)
    rf:set_up_actors()
    rf:current_setup(rf_rufws)
    rf.pigeons1:stop_chore(0)
    rf.pigeons1:play_chore(1)
    stop_script(rf.pigeon_mover)
    local1 = 1
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:put_in_set(nil)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    break_here()
    rf.sky:make_touchable()
    manny:head_look_at(rf.sky)
    wait_for_message()
    music_state:set_sequence(seqLedgepeckers)
    sleep_for(3000)
    manny:say_line("/rfma054/")
    wait_for_message()
    rf.pigeons1:free_object_state()
    rf.sky:make_untouchable()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
rf.show_eggs = function(arg1) -- line 296
    local local1 = 1
    START_CUT_SCENE()
    set_override(rf.show_eggs_override, rf)
    rf:current_setup(rf_nstoh)
    local1 = 1
    repeat
        pigeons[local1]:moveto(rnd(-13, -12.575), rnd(10.35, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    sleep_for(3000)
    rf:current_setup(rf_rufha)
    break_here()
    local1 = 1
    repeat
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    END_CUT_SCENE()
end
rf.show_eggs_override = function(arg1) -- line 321
    local local1 = 1
    repeat
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
end
rf.show_eggs_override = function(arg1, arg2) -- line 329
    rf:current_setup(rf_rufha)
    local local1 = 1
    repeat
        pigeons[local1]:set_chore_looping(pigeon_idles_pecking, FALSE)
        pigeons[local1]:set_chore_looping(pigeon_idles_jump_for_turn, FALSE)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    if arg2 then
        kill_override()
    end
end
BZ_X = -13.25
BZ_7 = 10.45
BZ_Z = 3.72
rf.NUMBER_OF_PIGEONS = 7
FLY_SPEED = 0.80000001
PIGEON_GLIDE_SPEED = 0.5
PIGEON_WALK_SPEED = 0.1
pigeons = { }
birdidle = { }
birdidle[1] = pigeon_idles_pecking
birdidle[2] = pigeon_idles_lead_to_walk
birdidle[3] = pigeon_idles_jump_for_turn
birdidle[4] = pigeon_idles_head_turns
rf.all_pigeons_pecking = nil
rf.kill_pigeons = nil
rf.seen_birds = nil
rf.no_attack_manny = FALSE
rf.default_pigeon = function(arg1, arg2) -- line 383
    arg1:set_costume("pigeon_idles.cos")
    arg1:set_colormap("pigeons.cmp")
    arg1:set_walk_rate(PIGEON_WALK_SPEED)
    arg1:set_turn_rate(90)
    arg1:ignore_boxes()
end
rf.pigeon_walk = function(arg1) -- line 398
    arg1:play_chore(pigeon_idles_lead_to_walk)
    arg1:wait_for_chore()
    arg1:play_chore(pigeon_idles_walk_cycle)
    while arg1:is_choring() do
        arg1:walk_forward()
        break_here()
    end
    arg1:play_chore(pigeon_idles_stopwalk_cycle)
    while arg1:is_choring() do
        arg1:walk_forward()
        break_here()
    end
    if not arg1:find_sector_name("bird_zone") then
        repeat
            PointActorAt(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            arg1:play_chore(pigeon_idles_lead_to_walk)
            arg1:wait_for_chore()
            arg1:play_chore(pigeon_idles_walk_cycle)
            while arg1:is_choring() do
                arg1:walk_forward()
                break_here()
            end
            arg1:play_chore(pigeon_idles_stopwalk_cycle)
            while arg1:is_choring() do
                arg1:walk_forward()
                break_here()
            end
        until arg1:find_sector_name("bird_zone")
    end
end
rf.turn_toward_home = function(arg1) -- line 439
    arg1:set_turn_rate(90)
    while TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z) do
        arg1:walk_forward()
        break_here()
    end
    while 1 do
        arg1:walk_forward()
        break_here()
    end
end
rf.fly_fly_fly = function(arg1) -- line 461
    arg1:set_turn_rate(250)
    while 1 do
        while TurnActorTo(arg1.hActor, manny.hActor) do
            arg1:walk_forward()
            if proximity(arg1, manny) < 0.65 then
                if not find_script(rf.manny_flee) then
                    start_script(rf.manny_flee)
                end
            end
            break_here()
        end
        arg1:walk_forward()
        break_here()
    end
end
rf.pigeon_attack = function(arg1) -- line 488
    local local1
    local local2
    local local3 = { }
    if not inventory_disabled then
        inventory_disabled = TRUE
    end
    arg1:set_walk_rate(FLY_SPEED)
    local1 = start_script(rf.fly_fly_fly, arg1)
    foo2 = start_script(bird_climb, arg1, arg1.height, 1.6, pigeon_idles_scared_takeoff)
    wait_for_script(foo2)
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    while manny:find_sector_name("attack_zone") or manny:find_sector_name("attack_box") do
        break_here()
    end
    stop_sound("rfPigMus.imu")
    if inventory_disabled then
        inventory_disabled = FALSE
    end
    repeat
        local3 = arg1:getpos()
        local2 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (1 - 1) ^ 2)
        break_here()
    until local2 > 2
    stop_script(local1)
    local1 = start_script(rf.turn_toward_home, arg1)
    arg1:set_chore_looping(pigeon_idles_fly_cycle, FALSE)
    arg1:wait_for_chore()
    SetActorWalkRate(arg1.hActor, PIGEON_GLIDE_SPEED)
    arg1:play_chore(pigeon_idles_glide_hook_up)
    arg1:wait_for_chore()
    arg1:play_chore_looping(pigeon_idles_glide)
    repeat
        local3 = arg1:getpos()
        local2 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (1 - 1) ^ 2)
        if local3.z > 3.95 then
            arg1:setpos(local3.x, local3.y, local3.z - 0.0040000002)
        end
        break_here()
    until local2 < 1
    arg1:set_chore_looping(pigeon_idles_glide, FALSE)
    foo2 = start_script(bird_climb, arg1, arg1.start_pnt.z, 1, pigeon_idles_landing)
    wait_for_script(foo2)
    stop_script(local1)
    local3 = arg1:getpos()
    arg1:setpos(local3.x, local3.y, BZ_Z)
    arg1:set_walk_rate(PIGEON_WALK_SPEED)
end
rf.turn_to_food = function(arg1) -- line 558
    arg1:set_turn_rate(250)
    while TurnActorTo(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z) do
        arg1:walk_forward()
        break_here()
    end
    while 1 do
        arg1:walk_forward()
        break_here()
    end
end
rf.pigeon_eat = function(arg1) -- line 577
    local local1, local2
    local local3
    local local4 = { }
    local local5
    local local6
    local local7 = FALSE
    arg1.height = 4.0999999
    arg1:set_walk_rate(FLY_SPEED)
    local1 = start_script(rf.turn_to_food, arg1)
    local2 = start_script(bird_climb, arg1, arg1.height, 1.6, pigeon_idles_scared_takeoff)
    wait_for_script(local2)
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    repeat
        local4 = arg1:getpos()
        local3 = sqrt((local4.x - arg1.eat_pnt.x) ^ 2 + (local4.y - arg1.eat_pnt.y) ^ 2)
        break_here()
    until local3 < 1.5
    stop_script(local1)
    local4 = arg1:getpos()
    while local3 >= 0.050000001 do
        if not TurnActorTo(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z) then
            PointActorAt(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
        end
        local3 = sqrt((local4.x - arg1.eat_pnt.x) ^ 2 + (local4.y - arg1.eat_pnt.y) ^ 2)
        local5 = tan(15) * local3
        local5 = local5 + arg1.eat_pnt.z
        local6 = GetActorWalkRate(arg1.hActor)
        if local6 >= local3 then
            if not local7 then
                local7 = TRUE
                arg1:stop_chore(pigeon_idles_fly_cycle)
                arg1:play_chore(pigeon_idles_landing)
            end
        end
        if PerSecond(local6) > local3 then
            arg1:set_walk_rate(local3)
        end
        arg1:walk_forward()
        local4 = arg1:getpos()
        arg1:setpos(local4.x, local4.y, local5)
        break_here()
        if local7 and not arg1:is_choring(pigeon_idles_landing) then
            arg1:setpos(arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
            arg1:setrot(arg1.eat_rot.x, arg1.eat_rot.y, arg1.eat_rot.z)
        end
    end
    arg1:setpos(arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
    arg1:setrot(arg1.eat_rot.x, arg1.eat_rot.y, arg1.eat_rot.z)
    arg1:wait_for_chore()
    arg1:play_chore_looping(pigeon_idles_pecking)
    arg1.eating = TRUE
    while not rf.all_pigeons_pecking do
        break_here()
    end
    arg1:set_chore_looping(pigeon_idles_pecking, FALSE)
    arg1:wait_for_chore()
    arg1.height = arg1.height + 0.0099999998
    local1 = start_script(rf.pigeon_attack, arg1)
    wait_for_script(local1)
    arg1.eating = FALSE
end
rf.wait_for_pigeons = function() -- line 660
    local local1 = 1
    local local2 = 0
    local local3
    rf.all_pigeons_pecking = FALSE
    repeat
        if pigeons[local1].eating then
            if local1 == 1 then
                start_sfx("flockeat.imu")
                local3 = start_script(rf.diminish_bread_pile)
            end
            local1 = local1 + 1
        else
            break_here()
        end
        local2 = local2 + 1
    until local1 > rf.NUMBER_OF_PIGEONS or local2 > 500
    if not local3 then
        local3 = start_script(rf.diminish_bread_pile)
    end
    wait_for_script(local3)
    rf.all_pigeons_pecking = TRUE
    rf.dish_contains = nil
    if rf.kill_pigeons then
        stop_script(rf.pigeon_brain)
        stop_script(rf.pigeon_eat)
        stop_script(rf.pigeon_attack)
        start_script(rf.pigeons_eat_bread)
    end
end
pigeon_coo_sfx = { "pigeon1.wav", "pigeon2.wav", "pigeon3.wav", "pigeon4.wav", "pigeon5.wav", "pigeon6.wav", "pigeon7.wav", "pigeon8.wav" }
rf.pigeon_brain = function(arg1) -- line 703
    local local1
    local local2
    local local3
    arg1.start_pnt = arg1:getpos()
    break_here()
    while TRUE do
        if manny:find_sector_name("attack_zone") or manny:find_sector_name("attack_box") and not rf.no_attack_manny then
            single_start_sfx("rfPigMus.imu")
            arg1.height = arg1.start_pnt.z + rnd(0.51999998, 0.62)
            local2 = start_script(rf.pigeon_attack, arg1)
            wait_for_script(local2)
            arg1:play_chore(pigeon_idles_standing)
        elseif find_script(rf.wait_for_pigeons) then
            local2 = start_script(rf.pigeon_eat, arg1)
            wait_for_script(local2)
            rf:update_states()
        else
            local1 = pick_from_nonweighted_table(birdidle)
            if local1 == pigeon_idles_lead_to_walk then
                local2 = start_script(rf.pigeon_walk, arg1)
                wait_for_script(local2)
            elseif local1 == pigeon_idles_jump_for_turn then
                if rnd() then
                    arg1:turn_right(90)
                else
                    arg1:turn_left(90)
                end
            end
            if rnd() then
                local3 = pick_one_of(pigeon_coo_sfx, TRUE)
                if rnd() then
                    single_start_sfx(local3)
                end
            end
            arg1:play_chore(local1)
            arg1:wait_for_chore()
        end
    end
end
rf.init_pigeons = function() -- line 764
    local local1 = 0
    local local2
    repeat
        local1 = local1 + 1
        if not pigeons[local1] then
            pigeons[local1] = Actor:create(nil, nil, nil, "pigeon" .. local1)
        end
        pigeons[local1].costume_marker_handler = bird_sound_monitor
        pigeons[local1].eat_pnt = { }
        pigeons[local1].eat_rot = { }
        pigeons[local1].start_pnt = { }
        if local1 == 1 then
            pigeons[local1].eat_pnt.x = -11.4224
            pigeons[local1].eat_pnt.y = 7.7199998
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 2 then
            pigeons[local1].eat_pnt.x = -11.4524
            pigeons[local1].eat_pnt.y = 7.8200002
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -89.845901
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 3 then
            pigeons[local1].eat_pnt.x = -11.4324
            pigeons[local1].eat_pnt.y = 7.77
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -56.6021
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 4 then
            pigeons[local1].eat_pnt.x = -11.3824
            pigeons[local1].eat_pnt.y = 7.9099998
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -89.845901
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 5 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 6 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 7 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        end
        rf.default_pigeon(pigeons[local1], local1)
        pigeons[local1].start_pnt.x = nil
        pigeons[local1].start_pnt.y = nil
        pigeons[local1].start_pnt.z = nil
        pigeons[local1].height = nil
        pigeons[local1].eating = nil
        pigeons[local1]:put_in_set(rf)
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), BZ_Z)
        start_script(rf.pigeon_brain, pigeons[local1])
    until local1 == rf.NUMBER_OF_PIGEONS
    if not prop_pigeon then
        prop_pigeon = Actor:create(nil, nil, nil, "prop pigeon")
    end
    rf.default_pigeon(prop_pigeon, 6)
    prop_pigeon:put_in_set(rf)
    prop_pigeon:setpos(-13.4947, 11.19, 4.6799998)
    prop_pigeon:setrot(0, -179.218, 0)
    prop_pigeon:play_chore_looping(pigeon_idles_pecking)
end
rf.manny_flee = function() -- line 859
    local local1, local2
    stop_script(monitor_run)
    START_CUT_SCENE()
    manny:set_walk_backwards(FALSE)
    manny:set_turn_rate(360)
    rf.pigeons1.count = rf.pigeons1.count + 1
    if rf.pigeons1.count == 1 then
        manny:say_line("/rfma044/")
    elseif rf.pigeons1.count == 2 then
        manny:say_line("/rfma045/")
    elseif rf.pigeons1.count == 3 then
        manny:say_line("/rfma046/")
    elseif rf.pigeons1.count == 4 then
        manny:say_line("/rfma047/")
    elseif rf.pigeons1.count == 5 then
        manny:say_line("/rfma048/")
    elseif rf.pigeons1.count == 6 then
        manny:say_line("/rfma049/")
    else
        manny:say_line("/rfma050/")
    end
    local1 = object_proximity(rf.escape_point_1)
    local2 = object_proximity(rf.escape_point_2)
    if local1 <= local2 then
        local2 = object_proximity(rf.escape_point_3)
        if local1 <= local2 then
            manny:runto(rf.escape_point_1.use_pnt_x, rf.escape_point_1.use_pnt_y, rf.escape_point_1.use_pnt_z)
        else
            manny:runto(rf.escape_point_3.use_pnt_x, rf.escape_point_3.use_pnt_y, rf.escape_point_3.use_pnt_z)
        end
    else
        local2 = object_proximity(rf.escape_point_4)
        if local1 <= local2 then
            manny:runto(rf.escape_point_2.use_pnt_x, rf.escape_point_2.use_pnt_y, rf.escape_point_2.use_pnt_z)
        else
            manny:runto(rf.escape_point_4.use_pnt_x, rf.escape_point_4.use_pnt_y, rf.escape_point_4.use_pnt_z)
        end
    end
    fade_sfx("rfPigMus.imu")
    manny:wait_for_actor()
    manny:set_run(FALSE)
    manny:wait_for_message()
    break_here()
    manny:turn_toward_entity(rf.pigeons1)
    END_CUT_SCENE()
    if inventory_disabled then
        inventory_disabled = FALSE
    end
end
rf.manny_follow_birds = function() -- line 916
    while 1 do
        manny:head_look_at(pigeons[1])
        break_here()
    end
end
rf.grow_bread_pile = function() -- line 929
    local local1 = 0.1
    local local2 = { }
    if not bread_pile_actor then
        bread_pile_actor = Actor:create(nil, nil, nil, "bread pile actor")
    end
    bread_pile_actor:put_in_set(rf)
    bread_pile_actor:set_costume("bread_pile.cos")
    bread_pile_actor:setpos(-11.3908, 7.7994599, 3.76)
    bread_pile_actor:setrot(0, 0, 0)
    bread_pile_actor:scale(local1)
    repeat
        local2 = bread_pile_actor:getpos()
        local1 = local1 + PerSecond(0.21250001)
        local2.z = local2.z + PerSecond(0.003)
        bread_pile_actor:scale(local1)
        bread_pile_actor:setpos(local2.x, local2.y, local2.z)
        break_here()
    until local1 >= 1.7
end
rf.diminish_bread_pile = function() -- line 954
    local local1 = 1.7
    local local2 = { }
    repeat
        local2 = bread_pile_actor:getpos()
        local1 = local1 - PerSecond(0.42500001)
        local2.z = local2.z - PerSecond(0.0060000001)
        SetActorScale(bread_pile_actor.hActor, local1)
        bread_pile_actor:setpos(local2.x, local2.y, local2.z)
        break_here()
    until local1 <= 0.1
    stop_sound("flockeat.imu")
    bread_pile_actor:free()
end
rf.enter = function(arg1) -- line 978
    LoadCostume("ma_crumble_bread.cos")
    NewObjectState(rf_rufws, OBJSTATE_UNDERLAY, "flock_ws_comp.bm", nil, TRUE)
    NewObjectState(rf_rufws, OBJSTATE_UNDERLAY, "flock_ws1_comp.bm", nil, TRUE)
    NewObjectState(rf_rufha, OBJSTATE_UNDERLAY, "flock_ha_comp.bm", nil, TRUE)
    NewObjectState(rf_pigeon, OBJSTATE_OVERLAY, "le_cl_.bm")
    manny.footsteps = footsteps.gravel
    manny:put_in_set(rf)
    rf:set_up_actors()
    rf:update_states()
    rf:camerachange()
    SetShadowColor(15, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 1000, 1000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
rf.exit = function(arg1) -- line 1002
    local local1 = 1
    stop_script(rf.pigeon_brain)
    stop_script(rf.pigeon_attack)
    stop_script(rf.fly_fly_fly)
    stop_script(rf.pigeon_eat)
    stop_script(rf.turn_toward_home)
    stop_script(bird_climb)
    stop_script(rf.pigeon_walk)
    prop_pigeon:free()
    repeat
        pigeons[local1]:free()
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    KillActorShadows(manny.hActor)
    rf.pigeons1:free_object_state()
    rf.pigeons2:free_object_state()
    rf.pigeons3:free_object_state()
    dish_item_actor:free()
    rf.egg_actor:free()
    rf.egg_actor1:free()
    rf.egg_actor2:free()
    rf.egg_actor3:free()
    rf.escape_point_1:free_object_state()
    rf.escape_point_2:free_object_state()
end
rf.ladder_object = Object:create(rf, "/rftx002/ladder", -4.2644401, 3.6105299, 4.6999998, { range = 0 })
rf.rf_ladder_box = rf.ladder_object
rf.ladder_object.use_pnt_x = -2.306
rf.ladder_object.use_pnt_y = 4.7729998
rf.ladder_object.use_pnt_z = 3.72
rf.ladder_object.use_rot_x = 0
rf.ladder_object.use_rot_y = -545.13
rf.ladder_object.use_rot_z = 0
rf.ladder_object.out_pnt_x = -2.3640001
rf.ladder_object.out_pnt_y = 4.138
rf.ladder_object.out_pnt_z = 3.72
rf.ladder_object.out_rot_x = 0
rf.ladder_object.out_rot_y = -545.13
rf.ladder_object.out_rot_z = 0
rf.ladder_object.walkOut = function(arg1) -- line 1061
    manny:clear_hands()
    le:switch_to_set()
    manny:put_in_set(le)
    le:current_setup(le_alloh)
    manny:follow_boxes()
    manny:setpos(le.rope_up.use_pnt_x, le.rope_up.use_pnt_y, le.rope_up.use_pnt_z)
    manny:setrot(le.rope_up.use_rot_x, le.rope_up.use_rot_y, le.rope_up.use_rot_z)
end
rf.dish = Object:create(rf, "", -11.5502, 7.79496, 3.72, { range = 1 })
rf.dish.use_pnt_x = -11.55
rf.dish.use_pnt_y = 7.7964301
rf.dish.use_pnt_z = 3.72
rf.dish.use_rot_x = 0
rf.dish.use_rot_y = -88.131897
rf.dish.use_rot_z = 0
rf.dish.contains = nil
rf.dish.walk_to_me = function(arg1) -- line 1084
    local local1
    local local2 = 9999
    START_CUT_SCENE()
    repeat
        TurnActorTo(manny.hActor, -11.36, 7.7849598, 3.72)
        local1 = local2
        manny:walk_forward()
        break_here()
        local2 = point_proximity(-11.325, 7.8000002, 3.72)
    until local2 >= local1
    while TurnActorTo(manny.hActor, -11.36, 7.7849598, 3.72) do
        break_here()
    end
    END_CUT_SCENE()
end
rf.dish.lookAt = function(arg1) -- line 1101
    if arg1.contains == nil then
        if rf.pigeons_gone then
            manny:say_line("/rfma004/")
        else
            manny:say_line("/rfma005/")
        end
    elseif arg1.contains == fe.balloon_cat or arg1.contains == fe.balloon_dingo or arg1.contains == fe.balloon_frost then
        manny:say_line("/rfma006/")
    else
        manny:say_line("/rfma007/")
    end
end
rf.dish.pickUp = function(arg1) -- line 1116
    local local1 = arg1.contains
    local local2
    if arg1.contains then
        START_CUT_SCENE()
        arg1:walk_to_me()
        if local1 == fe.balloon_cat then
            local2 = ms_activate_cat_balloon
        elseif local1 == fe.balloon_dingo then
            local2 = ms_activate_dingo_balloon
        elseif local1 == fe.balloon_frost then
            local2 = ms_activate_frost_balloon
        end
        manny:play_chore(ms_reach_med, "ms.cos")
        sleep_for(603)
        arg1.contains:get()
        arg1.contains = nil
        rf:update_states()
        manny:play_chore_looping(local2, "ms.cos")
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny.is_holding = local1
        manny.hold_chore = local2
        manny:wait_for_chore(ms_reach_med, "ms.cos")
        manny:stop_chore(ms_reach_med, "ms.cos")
        END_CUT_SCENE()
    else
        manny:say_line("/rfma008/")
    end
end
rf.dish.use = function(arg1) -- line 1147
    arg1:walk_to_me()
    if arg1.contains then
        arg1:pickUp()
    else
        manny:say_line("/rfma009/")
    end
end
rf.dish.use_eggs = function(arg1) -- line 1157
    arg1:walk_to_me()
    manny:say_line("/rfma010/")
end
rf.dish.add_item = function(arg1, arg2) -- line 1162
    local local1 = arg1.contains
    local local2
    rf.no_attack_manny = TRUE
    arg1:walk_to_me()
    if not rf.pigeons_gone then
        if arg2 == fe.breads.bread1 or arg2 == fe.breads.bread2 or arg2 == fe.breads.bread3 or arg2 == fe.breads.bread4 or arg2 == fe.breads.bread5 then
            arg2:free()
            arg2.owner = fe.basket
            START_CUT_SCENE("no head")
            manny:stop_chore(ms_hold_bread, "ms.cos")
            manny:push_costume(ma_crumble_bread_cos)
            manny:play_chore(ma_crumble_bread_crumble_bread, ma_crumble_bread_cos)
            manny:play_sound_at("breadbrk.wav")
            manny:play_sound_at("breadpor.wav")
            start_script(rf.grow_bread_pile)
            manny:wait_for_chore(ma_crumble_bread_crumble_bread, ma_crumble_bread_cos)
            manny:pop_costume()
            manny.move_in_reverse = TRUE
            start_script(move_actor_backward, system.currentActor.hActor)
            sleep_for(1000)
            stop_script(move_actor_backward)
            system.currentActor:set_walk_backwards(FALSE)
            manny.move_in_reverse = FALSE
            manny:walkto(-11.9406, 7.3115101, 3.72)
            manny:wait_for_actor()
            manny:turn_toward_entity(rf.dish)
            start_script(rf.manny_follow_birds)
            if rf.dish.contains then
                rf.kill_pigeons = TRUE
            end
            rf.dish.foo = start_script(rf.wait_for_pigeons)
            wait_for_script(rf.dish.foo)
            wait_for_script(rf.pigeon_eat)
            stop_script(rf.manny_follow_birds)
            END_CUT_SCENE()
        else
            START_CUT_SCENE()
            if arg1.contains then
                if local1 == fe.balloon_cat then
                    local2 = ms_activate_cat_balloon
                elseif local1 == fe.balloon_dingo then
                    local2 = ms_activate_dingo_balloon
                elseif local1 == fe.balloon_frost then
                    local2 = ms_activate_frost_balloon
                end
                manny:stop_chore(ms_hold, "ms.cos")
                manny:play_chore(ms_reach_med, "ms.cos")
                sleep_for(603)
                arg2:free()
                arg1.contains:get()
                arg1.contains = arg2
                arg2.owner = rf.dish
                rf:update_states()
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny:play_chore_looping(local2, "ms.cos")
                manny:play_chore_looping(ms_hold, "ms.cos")
                manny.is_holding = local1
                manny.hold_chore = local2
                manny:wait_for_chore(ms_reach_med, "ms.cos")
            else
                manny:stop_chore(ms_hold, "ms.cos")
                manny:play_chore(ms_reach_med, "ms.cos")
                sleep_for(603)
                arg2:free()
                arg1.contains = arg2
                arg2.owner = rf.dish
                rf:update_states()
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny.hold_chore = nil
                manny.is_holding = nil
                manny:wait_for_chore(ms_reach_med, "ms.cos")
            end
            END_CUT_SCENE()
            if not rf.tried_scary_balloon then
                rf.tried_scary_balloon = TRUE
                manny:say_line("/rfma011/")
            end
        end
        rf.no_attack_manny = FALSE
    elseif arg2 == fe.breads.bread1 or arg2 == fe.breads.bread2 or arg2 == fe.breads.bread3 or arg2 == fe.breads.bread4 or arg2 == fe.breads.bread5 then
        arg2:default_response()
    else
        arg2:use()
    end
end
rf.dish.use_cat_balloon = function(arg1, arg2) -- line 1260
    arg1:add_item(arg2)
end
rf.dish.use_dingo_balloon = function(arg1, arg2) -- line 1264
    arg1:add_item(arg2)
end
rf.dish.use_frost_balloon = function(arg1, arg2) -- line 1268
    arg1:add_item(arg2)
end
rf.dish.use_bread = function(arg1, arg2) -- line 1272
    arg1:add_item(arg2)
end
rf.eggs = Object:create(rf, "/rftx012/eggs", 0, 0, 0, { range = 0 })
rf.eggs.lookAt = function(arg1) -- line 1281
    manny:say_line("/rfma013/")
end
rf.eggs.use = function(arg1) -- line 1285
    manny:say_line("/rfma014/")
end
rf.eggs.default_response = function(arg1) -- line 1289
    manny:say_line("/rfma015/")
end
rf.nest = Object:create(rf, "/rftx016/nest", -13.4724, 11.2718, 4.27, { range = 0.69999999 })
rf.nest.use_pnt_x = -13.4422
rf.nest.use_pnt_y = 11.0513
rf.nest.use_pnt_z = 3.72
rf.nest.use_rot_x = 0
rf.nest.use_rot_y = 12.124
rf.nest.use_rot_z = 0
rf.nest.contains = rf.eggs
rf.nest.use_eggs = function(arg1) -- line 1305
    manny:say_line("/rfma010/")
end
rf.nest.lookAt = function(arg1) -- line 1309
    if arg1.contains == rf.eggs then
        manny:say_line("/rfma017/")
    else
        manny:say_line("/rfma018/")
    end
end
rf.nest.pickUp = function(arg1) -- line 1317
    if arg1.contains == rf.eggs then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:say_line("/rfma019/")
        manny:play_chore(ms_reach_high, "ms.cos")
        sleep_for(1407)
        start_sfx("getEggs.wav")
        rf.egg_actor:free()
        arg1.contains = nil
        rf.eggs:get()
        rf.eggs.wav = "getEggs.wav"
        manny:play_chore_looping(ms_activate_eggs, "ms.cos")
        sleep_for(704)
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny.hold_chore = ms_activate_eggs
        manny.is_holding = rf.eggs
        manny:wait_for_chore(ms_reach_high, "ms.cos")
        manny:stop_chore(ms_reach_high, "ms.cos")
        manny:head_look_at(nil)
        END_CUT_SCENE()
    else
        arg1:lookAt()
    end
end
rf.nest.use = rf.nest.pickUp
rf.pigeons1 = Object:create(rf, "/rftx021/pigeons", -13.3372, 10.6634, 3.72, { range = 3.5999999 })
rf.pigeons1.use_pnt_x = -10.4459
rf.pigeons1.use_pnt_y = 8.5341501
rf.pigeons1.use_pnt_z = 3.72
rf.pigeons1.use_rot_x = 0
rf.pigeons1.use_rot_y = -320.36401
rf.pigeons1.use_rot_z = 0
rf.pigeons1.look_count = 0
rf.pigeons1.count = 0
rf.pigeons1.lookAt = function(arg1) -- line 1362
    rf.pigeons1.look_count = rf.pigeons1.look_count + 1
    if rf.pigeons1.look_count == 1 then
        manny:say_line("/rfma022/")
    elseif rf.pigeons1.look_count == 2 then
        manny:say_line("/rfma023/")
    elseif rf.pigeons1.look_count == 3 then
        manny:say_line("/rfma024/")
    elseif rf.pigeons1.look_count == 4 then
        manny:say_line("/rfma025/")
    elseif rf.pigeons1.look_count == 5 then
        manny:say_line("/rfma026/")
    else
        arg1:use()
    end
end
rf.pigeons1.pickUp = function(arg1) -- line 1380
    manny:say_line("/rfma027/")
    if salvador.talked_pigeons then
        START_CUT_SCENE()
        wait_for_message()
        manny:say_line("/rfma028/")
        END_CUT_SCENE()
    end
end
rf.pigeons1.use = function(arg1) -- line 1391
    manny:say_line("/rfma029/")
end
rf.pigeons1.not_working = function(arg1) -- line 1395
    manny:say_line("/rfma030/")
    wait_for_message()
end
rf.pigeons1.use_cat_balloon = function(arg1) -- line 1400
    START_CUT_SCENE()
    fe.balloon_cat:use()
    wait_for_message()
    rf.pigeons1:not_working()
    manny:say_line("/rfma031/")
    END_CUT_SCENE()
end
rf.pigeons1.use_dingo_balloon = function(arg1) -- line 1409
    START_CUT_SCENE()
    fe.balloon_dingo:use()
    wait_for_message()
    manny:say_line("/rfma032/")
    END_CUT_SCENE()
end
rf.pigeons1.use_frost_balloon = function(arg1) -- line 1416
    START_CUT_SCENE()
    fe.balloon_frost:use()
    wait_for_message()
    manny:say_line("/rfma033/")
    END_CUT_SCENE()
end
rf.pigeons1.use_scythe = function(arg1) -- line 1437
    START_CUT_SCENE()
    manny:say_line("/rfma037/")
    wait_for_message()
    mo.scythe:use()
    sleep_for(500)
    manny:say_line("/rfma038/")
    END_CUT_SCENE()
end
rf.pigeons1.use_mouthpiece = function(arg1) -- line 1447
    manny:say_line("/rfma039/")
    wait_for_message()
    manny:say_line("/rfma040/")
    wait_for_message()
    manny:say_line("/rfma041/")
end
rf.pigeons1.use_bread = function(arg1) -- line 1455
    manny:say_line("/rfma042/")
end
rf.pigeons2 = Object:create(rf, "/rftx051/pigeons", -13.3372, 10.6634, 3.72, { range = 0 })
rf.pigeons2.use_pnt_x = -10.4459
rf.pigeons2.use_pnt_y = 8.5341501
rf.pigeons2.use_pnt_z = 3.72
rf.pigeons2.use_rot_x = 0
rf.pigeons2.use_rot_y = -320.36401
rf.pigeons2.use_rot_z = 0
rf.pigeons2.parent = rf.pigeons1
rf.pigeons3 = Object:create(rf, "/rftx051/pigeons", -13.3372, 10.6634, 3.72, { range = 0 })
rf.pigeons3.use_pnt_x = -10.4459
rf.pigeons3.use_pnt_y = 8.5341501
rf.pigeons3.use_pnt_z = 3.72
rf.pigeons3.use_rot_x = 0
rf.pigeons3.use_rot_y = -320.36401
rf.pigeons3.use_rot_z = 0
rf.pigeons3.parent = rf.pigeons1
rf.sky = Object:create(rf, "/rftx053/sky", -12.9724, 9.50179, 5.5999999, { range = 0.5 })
rf.sky.use_pnt_x = -10.83
rf.sky.use_pnt_y = 7.934
rf.sky.use_pnt_z = 3.72
rf.sky.use_rot_x = 0
rf.sky.use_rot_y = -303.345
rf.sky.use_rot_z = 0
rf.sky:make_untouchable()
rf.sky.lookAt = function(arg1) -- line 1493
end
rf.sky.pickUp = function(arg1) -- line 1496
end
rf.sky.use = function(arg1) -- line 1499
end
rf.escape_point_1 = Object:create(rf, "/rftx055/x", -10.1976, 9.35886, 3.72, { range = 0 })
rf.escape_point_1.use_pnt_x = -10.1976
rf.escape_point_1.use_pnt_y = 9.35886
rf.escape_point_1.use_pnt_z = 3.72
rf.escape_point_1.use_rot_x = 0
rf.escape_point_1.use_rot_y = -78.999199
rf.escape_point_1.use_rot_z = 0
rf.escape_point_2 = Object:create(rf, "/rftx056/x", -12.7606, 6.9607301, 3.72, { range = 0 })
rf.escape_point_2.use_pnt_x = -12.7606
rf.escape_point_2.use_pnt_y = 6.9607301
rf.escape_point_2.use_pnt_z = 3.72
rf.escape_point_2.use_rot_x = 0
rf.escape_point_2.use_rot_y = 200.63
rf.escape_point_2.use_rot_z = 0
rf.escape_point_3 = Object:create(rf, "", -10.5521, 7.8463898, 3.72, { range = 0 })
rf.escape_point_3.use_pnt_x = -10.5521
rf.escape_point_3.use_pnt_y = 7.8463898
rf.escape_point_3.use_pnt_z = 3.72
rf.escape_point_3.use_rot_x = 0
rf.escape_point_3.use_rot_y = -41.502998
rf.escape_point_3.use_rot_z = 0
rf.escape_point_3:make_untouchable()
rf.escape_point_4 = Object:create(rf, "", -11.4381, 6.9501801, 3.72, { range = 0 })
rf.escape_point_4.use_pnt_x = -11.4381
rf.escape_point_4.use_pnt_y = 6.9501801
rf.escape_point_4.use_pnt_z = 3.72
rf.escape_point_4.use_rot_x = 0
rf.escape_point_4.use_rot_y = -469.336
rf.escape_point_4.use_rot_z = 0
rf.escape_point_4:make_untouchable()
CheckFirstTime("na.lua")
dofile("na_trapdoor.lua")
na = Set:create("na.set", "navigation room", { na_top = 0, na_intha = 1, na_intws = 2, na_mancu = 3 })
na.bw_out_points = { }
na.bw_out_points[0] = { pos = { x = 3.15329, y = -0.641857, z = 0.5 }, rot = { x = 0, y = 18.6574, z = 0 } }
na.bw_out_points[1] = { pos = { x = -0.222127, y = 3.55086, z = 0.5 }, rot = { x = 0, y = 227.602, z = 0 } }
na.bw_out_points[2] = { pos = { x = -2.89712, y = 3.16993, z = 0.5 }, rot = { x = 0, y = 339.683, z = 0 } }
na.bw_out_points[3] = { pos = { x = 5.22106, y = -1.634, z = 0.5 }, rot = { x = 0, y = 188.897, z = 0 } }
na.bw_out_points[4] = { pos = { x = 0.770985, y = -3.77095, z = 0.5 }, rot = { x = 0, y = 92.7718, z = 0 } }
na.bw_out_points[5] = { pos = { x = 3.32583, y = -1.69583, z = 0.5 }, rot = { x = 0, y = 137.086, z = 0 } }
na.SIGNPOST_SOLVED_DISTANCE = 0.6
na.check_for_nav_solved = function(arg1, arg2) -- line 26
    local local1
    local local2, local3, local4, local5
    local local6
    if not arg2 then
        local1 = proximity(signpost.hActor, na.rubacava_point.x, na.rubacava_point.y, na.rubacava_point.z)
    else
        local1 = sqrt((arg2.x - na.rubacava_point.x) ^ 2 + (arg2.y - na.rubacava_point.y) ^ 2 + (arg2.z - na.rubacava_point.z) ^ 2)
    end
    if local1 <= na.SIGNPOST_SOLVED_DISTANCE then
        START_CUT_SCENE()
        set_override(na.skip_check_nav_solved, na)
        start_sfx("quake.IMU")
        set_pan("quake.IMU", 20)
        sleep_for(500)
        local2 = manny:getpos()
        local3 = manny:get_positive_rot()
        local4 = { x = -1, y = 0.5, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z + 0.30000001
        manny:head_look_at_point(local4.x, local4.y, local4.z)
        sleep_for(2000)
        local5 = start_sfx("quake.IMU")
        set_pan(local5, 100)
        local4 = { x = 1, y = 0.5, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z + 0.30000001
        manny:head_look_at_point(local4.x, local4.y, local4.z)
        sleep_for(2000)
        local4 = { x = 0, y = -3, z = 0 }
        local4 = RotateVector(local4, local3)
        local4.x = local4.x + local2.x
        local4.y = local4.y + local2.y
        local4.z = local2.z
        manny:setrot(local3.x, local3.y + 180, local3.z, TRUE)
        manny:runto(local4.x, local4.y, local4.z)
        local6 = 0
        while local6 < 2000 and manny:is_moving() do
            break_here()
            local6 = local6 + system.frameTime
        end
        fade_sfx(local5, 3000, 0)
        fade_sfx("quake.IMU", 3000, 0)
        na:current_setup(na_intha)
        RunFullscreenMovie("dooropen.snm")
        END_CUT_SCENE()
        manny:set_run(FALSE)
        na:solve_nav()
        return TRUE
    else
        return FALSE
    end
end
na.skip_check_nav_solved = function(arg1) -- line 93
    kill_override()
    manny:set_run(FALSE)
    stop_sound("quake.IMU")
    na:current_setup(na_intha)
    manny:head_look_at(nil)
    na:solve_nav()
end
na.solve_nav = function(arg1) -- line 102
    cur_puzzle_state[13] = TRUE
    na.trapdoor:make_touchable()
    signpost.current_set = nil
    signpost:free()
    sg.signpost:make_untouchable()
    na.signpost:make_untouchable()
    na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
    bonewagon:set_visibility(TRUE)
    bonewagon:set_collision_mode(COLLISION_BOX, 1)
    if bonewagon.current_set == na then
        bonewagon:setpos(3.60411, -0.419015, 0.5)
        bonewagon:setrot(0, 159.729, 0)
        bonewagon.current_pos = { x = 3.60411, y = -0.419015, z = 0.5 }
        bonewagon.current_rot = { x = 0, y = 159.729, z = 0 }
        sg:park_BW_obj()
    end
    na:activate_trapdoor_boxes(TRUE)
    na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
    manny:put_at_object(na.trapdoor)
    nav_solved = TRUE
    music_state:set_state(stateNA_SOLVED)
    START_CUT_SCENE()
    manny:say_line("/sgma053/")
    manny:wait_for_message()
    END_CUT_SCENE()
end
na.activate_trapdoor_boxes = function(arg1, arg2) -- line 136
    local local1, local2
    MakeSectorActive("na_lb_box", arg2)
    local2 = 1
    while local2 <= 11 do
        local1 = "trap_box" .. local2
        MakeSectorActive(local1, arg2)
        local2 = local2 + 1
    end
    MakeSectorActive("notrap_box", not arg2)
    single_start_script(na.footstep_monitor, na)
end
na.rubacava_point = nil
na.choose_random_sign_point = function(arg1) -- line 154
    local local1
    if arg1.rubacava_point == nil then
        local1 = { }
        local1.x = -1.2223099
        local1.y = -0.205108
        local1.z = 0.5
        arg1.rubacava_point = local1
    end
end
na.tilt_bonewagon = function(arg1) -- line 172
    local local1
    while not bonewagon:find_sector_name("trap_box9") do
        break_here()
    end
    while bonewagon:find_sector_name("trap_box9") do
        local1 = proximity(bonewagon.hActor, -0.161172, -1.64503, 0.5) * -30
        if local1 > 0 then
            local1 = 0
        elseif local1 < -30 then
            local1 = -30
        end
        SetActorPitch(bonewagon.hActor, local1)
        break_here()
    end
end
na.footstep_monitor = function(arg1) -- line 190
    while TRUE do
        if manny:find_sector_name("trap_box9") or manny:find_sector_name("trap_box11") then
            manny.footsteps = footsteps.metal
        else
            manny.footsteps = footsteps.dirt
        end
        break_here()
    end
end
na.examine_signpost = function(arg1) -- line 201
    local local1, local2
    local local3, local4, local5
    local local6
    START_CUT_SCENE()
    local1 = { }
    local1.pos = signpost:getpos()
    local1.rot = signpost:getrot()
    local2 = { }
    local2.pos = manny:getpos()
    local2.rot = manny:getrot()
    local6 = na:current_setup()
    na:current_setup(na_mancu)
    signpost:setpos(4.0353198, -1.21448, 0.5)
    local3 = 3.8364899 + (local2.pos.x - local1.pos.x)
    local4 = -1.23856 + (local2.pos.y - local1.pos.y)
    local5 = 0.5
    manny:ignore_boxes()
    manny:setpos(local3, local4, local5)
    if bonewagon.current_set == system.currentSet then
        bonewagon:set_visibility(FALSE)
        bonewagon:set_collision_mode(COLLISION_OFF)
    end
    manny:head_look_at_point({ 4.0353198, -1.21448, 1 })
    if not na.nav_points.happened then
        manny:say_line("/nama003/")
    else
        manny:say_line("/nama004/")
    end
    manny:wait_for_message()
    sleep_for(1000)
    na:current_setup(local6)
    signpost:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
    manny:follow_boxes()
    manny:setpos(local2.pos.x, local2.pos.y, local2.pos.z)
    manny:head_look_at(na.signpost)
    if bonewagon.current_set == system.currentSet then
        bonewagon:set_visibility(TRUE)
        bonewagon:set_collision_mode(COLLISION_BOX, 1)
    end
    END_CUT_SCENE()
end
na.enter = function(arg1) -- line 255
    manny:set_collision_mode(COLLISION_SPHERE, 0.4)
    na:choose_random_sign_point()
    na:add_object_state(na_intha, "na_trapdoor.bm", "na_trapdoor.zbm", OBJSTATE_STATE)
    na.trapdoor:set_object_state("na_trapdoor.cos")
    if nav_solved then
        na:activate_trapdoor_boxes(TRUE)
        na.trapdoor:play_chore(na_trapdoor_show, "na_trapdoor.cos")
        start_script(na.tilt_bonewagon, na)
    else
        na:activate_trapdoor_boxes(FALSE)
        na.trapdoor:play_chore(na_trapdoor_hide, "na_trapdoor.cos")
    end
    if bonewagon.current_set == arg1 then
        bonewagon:put_in_set(arg1)
        bonewagon:setpos(bonewagon.current_pos.x, bonewagon.current_pos.y, bonewagon.current_pos.z)
        bonewagon:setrot(bonewagon.current_rot.x, bonewagon.current_rot.y, bonewagon.current_rot.z)
        if not manny.is_driving then
            single_start_script(sg.glottis_roars, sg, bonewagon)
        end
    end
    if signpost.current_set == arg1 then
        signpost:put_in_set(arg1)
        signpost:setpos(signpost.current_pos.x, signpost.current_pos.y, signpost.current_pos.z)
        signpost:setrot(signpost.current_rot.x, signpost.current_rot.y, signpost.current_rot.z)
    end
    if manny.is_driving then
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, 127)
    end
    na:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
na.exit = function(arg1) -- line 297
    stop_script(na.footstep_monitor)
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(sg.glottis_roars)
    glottis:shut_up()
    bonewagon:shut_up()
    stop_script(na.tilt_bonewagon)
    stop_script(bonewagon.cruise_sounds)
    stop_sound("bwIdle.IMU")
end
na.update_music_state = function(arg1) -- line 311
    if manny.is_driving then
        return stateOO_BONE
    elseif nav_solved then
        return stateNA_SOLVED
    else
        return stateNA
    end
end
na.signpost = Object:create(na, "/natx002/sign post", 0, 0, 0, { range = 1.5 })
na.signpost.use_pnt_x = 0
na.signpost.use_pnt_y = 0
na.signpost.use_pnt_z = 0
na.signpost.use_rot_x = 0
na.signpost.use_rot_y = 0
na.signpost.use_rot_z = 0
na.signpost:make_untouchable()
na.signpost.lookAt = function(arg1) -- line 336
    na:examine_signpost()
end
na.signpost.pickUp = function(arg1) -- line 340
    START_CUT_SCENE()
    signpost:set_collision_mode(COLLISION_OFF)
    manny:walkto_object(arg1)
    signpost:pick_up()
    sg.signpost:get()
    manny.is_holding = sg.signpost
    arg1:make_untouchable()
    if system.object_names_showing then
        system.currentSet:make_objects_visible()
        system.currentSet:update_object_names()
    end
    END_CUT_SCENE()
end
na.signpost.use = na.signpost.pickUp
na.all_paths = Object:create(na, "/natx005/dark passage", 0, 0, 0, { range = 0 })
na.all_paths.lookAt = function(arg1) -- line 362
    manny:say_line("/nama006/")
end
na.trapdoor = Object:create(na, "/natx007/opening", -1.8434, -1.82987, 0.51999998, { range = 2 })
na.trapdoor.use_pnt_x = -0.208358
na.trapdoor.use_pnt_y = -1.88557
na.trapdoor.use_pnt_z = 0.5
na.trapdoor.use_rot_x = 0
na.trapdoor.use_rot_y = 0
na.trapdoor.use_rot_z = 0
na.trapdoor.out_pnt_x = -0.209998
na.trapdoor.out_pnt_y = 1.02899
na.trapdoor.out_pnt_z = -0.86926502
na.trapdoor.out_rot_x = 0
na.trapdoor.out_rot_y = 0
na.trapdoor.out_rot_z = 0
na.trapdoor:make_untouchable()
na.trapdoor.make_touchable = function(arg1) -- line 385
    Object.make_touchable(arg1)
    if system.object_names_showing then
        na:update_object_names()
    end
end
na.trapdoor.lookAt = function(arg1) -- line 392
    manny:say_line("/nama008/")
end
na.trapdoor.use = function(arg1) -- line 396
    if not manny.is_driving then
        START_CUT_SCENE()
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        lb:come_out_door(lb.na_door)
        END_CUT_SCENE()
    else
        na.glotdriv_trigr:walkOut()
    end
end
na.trapdoor.walkOut = na.trapdoor.use
na.na_lb_box = na.trapdoor
na.glotdriv_trigr = { name = "glotdriv_trigger" }
na.glotdriv_trigr.walkOut = function(arg1) -- line 413
    if manny.is_driving and na.trapdoor.touchable then
        START_CUT_SCENE()
        RunFullscreenMovie("glotdriv.snm")
        bonewagon:put_in_set(nil)
        lb:switch_to_set()
        lb:current_setup(lb_modws)
        END_CUT_SCENE()
    end
end
na.bone_wagon = Object:create(na, "/natx009/Bone Wagon", 0.97060001, -1.1162, 1.2, { range = 2.5 })
na.bone_wagon.use_pnt_x = 0.64422601
na.bone_wagon.use_pnt_y = -1.13239
na.bone_wagon.use_pnt_z = 0.5
na.bone_wagon.use_rot_x = 0
na.bone_wagon.use_rot_y = 645.83502
na.bone_wagon.use_rot_z = 0
na.bone_wagon:make_untouchable()
na.bone_wagon.lookAt = function(arg1) -- line 437
    sg.bone_wagon:lookAt()
end
na.bone_wagon.pickUp = function(arg1) -- line 441
    sg.bone_wagon:pickUp()
end
na.bone_wagon.use = function(arg1) -- line 445
    sg:get_in_BW()
end
na.bone_wagon.use_scythe = function(arg1) -- line 449
    sg.bone_wagon:use_scythe()
end
na.bone_wagon.use_bone = function(arg1) -- line 453
    sg.bone_wagon:use_bone()
end
na.sg_door = Object:create(na, "/natx010/door", 7.43084, -6.4731998, 0, { range = 0.5 })
na.sg_box = na.sg_door
na.sg_door.use_pnt_x = 6.3092499
na.sg_door.use_pnt_y = -5.1433201
na.sg_door.use_pnt_z = 0.5
na.sg_door.use_rot_x = 0
na.sg_door.use_rot_y = 253
na.sg_door.use_rot_z = 0
na.sg_door.out_pnt_x = 7.43084
na.sg_door.out_pnt_y = -6.4731998
na.sg_door.out_pnt_z = 0.5
na.sg_door.out_rot_x = 0
na.sg_door.out_rot_y = -484.245
na.sg_door.out_rot_z = 0
na.sg_door.walkOut = function(arg1) -- line 481
    sg:come_out_door(sg.na_door)
end
na.nav_points = { }
na.nav_points.last_index = nil
na.nav_points.walkOut = function(arg1) -- line 495
    local local1, local2
    START_CUT_SCENE()
    if system.currentActor == manny and get_generic_control_state("RUN") then
        system.currentActor:runto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    elseif system.currentActor == bonewagon then
        bonewagon:stop_movement_scripts()
        bonewagon:set_walk_rate(bonewagon.max_walk_rate)
        fade_sfx("bwIdle.IMU", 1000, 0)
        bonewagon:walkto(arg1.bonewagon_out_pnt_x, arg1.bonewagon_out_pnt_y, arg1.bonewagon_out_pnt_z)
    end
    system.currentActor:wait_for_actor()
    if system.currentActor == manny then
        manny:set_run(FALSE)
    end
    local2 = nil
    while local2 == nil do
        local1 = rndint(1, 12)
        if local1 ~= arg1.index and local1 ~= na.nav_points.last_index then
            if na.nav_points:away_from_signpost(local1) then
                local2 = na.nav_points[local1]
                na.nav_points.last_index = local1
            end
        end
        break_here()
    end
    PrintDebug("out_door = " .. local1 .. "\n")
    if system.currentActor == manny then
        system.currentActor:setpos(local2.out_pnt_x, local2.out_pnt_y, local2.out_pnt_z)
        system.currentActor:runto(local2.use_pnt_x, local2.use_pnt_y, local2.use_pnt_z, local2.use_rot_x, local2.use_rot_y + 180, local2.use_rot_z)
        system.currentActor:wait_for_actor()
    elseif system.currentActor == bonewagon then
        bonewagon:stop_movement_scripts()
        single_start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 0)
        fade_sfx("bwIdle.IMU", 1000, bonewagon.max_volume)
        system.currentActor:setpos(local2.bonewagon_out_pnt_x, local2.bonewagon_out_pnt_y, local2.bonewagon_out_pnt_z)
        system.currentActor:setrot(local2.bonewagon_out_rot_x, local2.bonewagon_out_rot_y + 180, local2.bonewagon_out_rot_z)
        bonewagon:driveto(local2.use_pnt_x, local2.use_pnt_y, local2.use_pnt_z)
    end
    if not na.nav_points.happened then
        na.nav_points.happened = TRUE
        manny:say_line("/nama001/")
    end
    END_CUT_SCENE()
    if get_generic_control_state("MOVE_FORWARD") then
        if manny.is_driving then
            single_start_script(bonewagon.gas, bonewagon)
        end
    end
end
na.nav_points.away_from_signpost = function(arg1, arg2) -- line 555
    if signpost.current_set ~= na then
        return TRUE
    elseif proximity(signpost.hActor, arg1[arg2].bonewagon_out_pnt_x, arg1[arg2].bonewagon_out_pnt_y, arg1[arg2].bonewagon_out_pnt_z) < 10 then
        return FALSE
    else
        return TRUE
    end
end
na.nav_points[1] = { opened = TRUE, immediate = TRUE, index = 1 }
na.nav_points[1].use_pnt_x = -1.6622699
na.nav_points[1].use_pnt_y = -4.6346402
na.nav_points[1].use_pnt_z = 0.5
na.nav_points[1].use_rot_x = 0
na.nav_points[1].use_rot_y = 146.248
na.nav_points[1].use_rot_z = 0
na.nav_points[1].out_pnt_x = -2.39167
na.nav_points[1].out_pnt_y = -5.4372802
na.nav_points[1].out_pnt_z = 0.5
na.nav_points[1].out_rot_x = 0
na.nav_points[1].out_rot_y = 135.17999
na.nav_points[1].out_rot_z = 0
na.nav_points[1].walkOut = na.nav_points.walkOut
na.nav_points[2] = { opened = TRUE, immediate = TRUE, index = 2 }
na.nav_points[2].use_pnt_x = -4.4720802
na.nav_points[2].use_pnt_y = -1.91714
na.nav_points[2].use_pnt_z = 0.5
na.nav_points[2].use_rot_x = 0
na.nav_points[2].use_rot_y = 133.786
na.nav_points[2].use_rot_z = 0
na.nav_points[2].out_pnt_x = -5.3769598
na.nav_points[2].out_pnt_y = -2.87236
na.nav_points[2].out_pnt_z = 0.5
na.nav_points[2].out_rot_x = 0
na.nav_points[2].out_rot_y = 497.70999
na.nav_points[2].out_rot_z = 0
na.nav_points[2].walkOut = na.nav_points.walkOut
na.nav_points[3] = { opened = TRUE, immediate = TRUE, index = 3 }
na.nav_points[3].use_pnt_x = -6.11096
na.nav_points[3].use_pnt_y = 1.9079601
na.nav_points[3].use_pnt_z = 0.5
na.nav_points[3].use_rot_x = 0
na.nav_points[3].use_rot_y = 122.553
na.nav_points[3].use_rot_z = 0
na.nav_points[3].out_pnt_x = -7.6507502
na.nav_points[3].out_pnt_y = 0.749448
na.nav_points[3].out_pnt_z = 0.5
na.nav_points[3].out_rot_x = 0
na.nav_points[3].out_rot_y = 490.267
na.nav_points[3].out_rot_z = 0
na.nav_points[3].walkOut = na.nav_points.walkOut
na.nav_points[4] = { opened = TRUE, immediate = TRUE, index = 4 }
na.nav_points[4].use_pnt_x = -4.50388
na.nav_points[4].use_pnt_y = 3.57882
na.nav_points[4].use_pnt_z = 0.5
na.nav_points[4].use_rot_x = 0
na.nav_points[4].use_rot_y = 771.30798
na.nav_points[4].use_rot_z = 0
na.nav_points[4].out_pnt_x = -7.9057798
na.nav_points[4].out_pnt_y = 5.7978601
na.nav_points[4].out_pnt_z = 0.5
na.nav_points[4].out_rot_x = 0
na.nav_points[4].out_rot_y = 771.30798
na.nav_points[4].out_rot_z = 0
na.nav_points[4].walkOut = na.nav_points.walkOut
na.nav_points[5] = { opened = TRUE, immediate = TRUE, index = 5 }
na.nav_points[5].use_pnt_x = -4.7105999
na.nav_points[5].use_pnt_y = 6.0127501
na.nav_points[5].use_pnt_z = 0.5
na.nav_points[5].use_rot_x = 0
na.nav_points[5].use_rot_y = 715.633
na.nav_points[5].use_rot_z = 0
na.nav_points[5].out_pnt_x = -4.6799002
na.nav_points[5].out_pnt_y = 9.6187496
na.nav_points[5].out_pnt_z = 0.5
na.nav_points[5].out_rot_x = 0
na.nav_points[5].out_rot_y = 715.633
na.nav_points[5].out_rot_z = 0
na.nav_points[5].walkOut = na.nav_points.walkOut
na.nav_points[6] = { opened = TRUE, immediate = TRUE, index = 6 }
na.nav_points[6].use_pnt_x = -1.34286
na.nav_points[6].use_pnt_y = 6.7671599
na.nav_points[6].use_pnt_z = 0.5
na.nav_points[6].use_rot_x = 0
na.nav_points[6].use_rot_y = 718.26202
na.nav_points[6].use_rot_z = 0
na.nav_points[6].out_pnt_x = -1.0425
na.nav_points[6].out_pnt_y = 10.6854
na.nav_points[6].out_pnt_z = 0.5
na.nav_points[6].out_rot_x = 0
na.nav_points[6].out_rot_y = 718.26202
na.nav_points[6].out_rot_z = 0
na.nav_points[6].walkOut = na.nav_points.walkOut
na.nav_points[7] = { opened = TRUE, immediate = TRUE, index = 7 }
na.nav_points[7].use_pnt_x = 2.0485799
na.nav_points[7].use_pnt_y = 8.4344902
na.nav_points[7].use_pnt_z = 0.5
na.nav_points[7].use_rot_x = 0
na.nav_points[7].use_rot_y = 691.46698
na.nav_points[7].use_rot_z = 0
na.nav_points[7].out_pnt_x = 3.0051601
na.nav_points[7].out_pnt_y = 10.2608
na.nav_points[7].out_pnt_z = 0.5
na.nav_points[7].out_rot_x = 0
na.nav_points[7].out_rot_y = 701.25702
na.nav_points[7].out_rot_z = 0
na.nav_points[7].walkOut = na.nav_points.walkOut
na.nav_points[8] = { opened = TRUE, immediate = TRUE, index = 8 }
na.nav_points[8].use_pnt_x = 4.70544
na.nav_points[8].use_pnt_y = 5.39078
na.nav_points[8].use_pnt_z = 0.5
na.nav_points[8].use_rot_x = 0
na.nav_points[8].use_rot_y = 1047.17
na.nav_points[8].use_rot_z = 0
na.nav_points[8].out_pnt_x = 6.5631399
na.nav_points[8].out_pnt_y = 8.34795
na.nav_points[8].out_pnt_z = 0.5
na.nav_points[8].out_rot_x = 0
na.nav_points[8].out_rot_y = 1047.17
na.nav_points[8].out_rot_z = 0
na.nav_points[8].walkOut = na.nav_points.walkOut
na.nav_points[9] = { opened = TRUE, immediate = TRUE, index = 9 }
na.nav_points[9].use_pnt_x = 7.8786502
na.nav_points[9].use_pnt_y = 3.7764101
na.nav_points[9].use_pnt_z = 0.5
na.nav_points[9].use_rot_x = 0
na.nav_points[9].use_rot_y = 1365.0601
na.nav_points[9].use_rot_z = 0
na.nav_points[9].out_pnt_x = 9.7726297
na.nav_points[9].out_pnt_y = 4.4060798
na.nav_points[9].out_pnt_z = 0.5
na.nav_points[9].out_rot_x = 0
na.nav_points[9].out_rot_y = 1376.39
na.nav_points[9].out_rot_z = 0
na.nav_points[9].walkOut = na.nav_points.walkOut
na.nav_points[10] = { opened = TRUE, immediate = TRUE, index = 10 }
na.nav_points[10].use_pnt_x = 8.5132399
na.nav_points[10].use_pnt_y = 0.23104601
na.nav_points[10].use_pnt_z = 0.5
na.nav_points[10].use_rot_x = 0
na.nav_points[10].use_rot_y = 1717.15
na.nav_points[10].use_rot_z = 0
na.nav_points[10].out_pnt_x = 10.8235
na.nav_points[10].out_pnt_y = 0.91224998
na.nav_points[10].out_pnt_z = 0.5
na.nav_points[10].out_rot_x = 0
na.nav_points[10].out_rot_y = 1733.52
na.nav_points[10].out_rot_z = 0
na.nav_points[10].walkOut = na.nav_points.walkOut
na.nav_points[11] = { opened = TRUE, immediate = TRUE, index = 11 }
na.nav_points[11].use_pnt_x = 8.0326595
na.nav_points[11].use_pnt_y = -2.3932199
na.nav_points[11].use_pnt_z = 0.5
na.nav_points[11].use_rot_x = 0
na.nav_points[11].use_rot_y = 2065.75
na.nav_points[11].use_rot_z = 0
na.nav_points[11].out_pnt_x = 10.7659
na.nav_points[11].out_pnt_y = -2.5953
na.nav_points[11].out_pnt_z = 0.5
na.nav_points[11].out_rot_x = 0
na.nav_points[11].out_rot_y = 2065.75
na.nav_points[11].out_rot_z = 0
na.nav_points[11].walkOut = na.nav_points.walkOut
na.nav_points[12] = { opened = TRUE, immediate = TRUE, index = 12 }
na.nav_points[12].use_pnt_x = 1.89314
na.nav_points[12].use_pnt_y = -6.4507098
na.nav_points[12].use_pnt_z = 0.5
na.nav_points[12].use_rot_x = 0
na.nav_points[12].use_rot_y = 165.52
na.nav_points[12].use_rot_z = 0
na.nav_points[12].out_pnt_x = 1.55873
na.nav_points[12].out_pnt_y = -7.7474899
na.nav_points[12].out_pnt_z = 0.5
na.nav_points[12].out_rot_x = 0
na.nav_points[12].out_rot_y = 165.52
na.nav_points[12].out_rot_z = 0
na.nav_points[12].walkOut = na.nav_points.walkOut
na.nav_points[1].bonewagon_out_pnt_x = -4.7062402
na.nav_points[1].bonewagon_out_pnt_y = -7.51126
na.nav_points[1].bonewagon_out_pnt_z = 0.5
na.nav_points[1].bonewagon_out_rot_x = 0
na.nav_points[1].bonewagon_out_rot_y = 139.108
na.nav_points[1].bonewagon_out_rot_z = 0
na.nav_points[2].bonewagon_out_pnt_x = -7.99891
na.nav_points[2].bonewagon_out_pnt_y = -4.9516501
na.nav_points[2].bonewagon_out_pnt_z = 0.5
na.nav_points[2].bonewagon_out_rot_x = 0
na.nav_points[2].bonewagon_out_rot_y = 136.179
na.nav_points[2].bonewagon_out_rot_z = 0
na.nav_points[3].bonewagon_out_pnt_x = -10.0029
na.nav_points[3].bonewagon_out_pnt_y = -1.71706
na.nav_points[3].bonewagon_out_pnt_z = 0.5
na.nav_points[3].bonewagon_out_rot_x = 0
na.nav_points[3].bonewagon_out_rot_y = 130.61099
na.nav_points[3].bonewagon_out_rot_z = 0
na.nav_points[4].bonewagon_out_pnt_x = -11.9683
na.nav_points[4].bonewagon_out_pnt_y = 7.9263301
na.nav_points[4].bonewagon_out_pnt_z = 0.5
na.nav_points[4].bonewagon_out_rot_x = 0
na.nav_points[4].bonewagon_out_rot_y = 57.449501
na.nav_points[4].bonewagon_out_rot_z = 0
na.nav_points[5].bonewagon_out_pnt_x = -4.9099998
na.nav_points[5].bonewagon_out_pnt_y = 18.455
na.nav_points[5].bonewagon_out_pnt_z = 0.5
na.nav_points[5].bonewagon_out_rot_x = 0
na.nav_points[5].bonewagon_out_rot_y = -40.159
na.nav_points[5].bonewagon_out_rot_z = 0
na.nav_points[6].bonewagon_out_pnt_x = -0.40590999
na.nav_points[6].bonewagon_out_pnt_y = 18.074301
na.nav_points[6].bonewagon_out_pnt_z = 0.5
na.nav_points[6].bonewagon_out_rot_x = 0
na.nav_points[6].bonewagon_out_rot_y = 357.64999
na.nav_points[6].bonewagon_out_rot_z = 0
na.nav_points[7].bonewagon_out_pnt_x = 5.2837901
na.nav_points[7].bonewagon_out_pnt_y = 17.2509
na.nav_points[7].bonewagon_out_pnt_z = 0.5
na.nav_points[7].bonewagon_out_rot_x = 0
na.nav_points[7].bonewagon_out_rot_y = 698.73297
na.nav_points[7].bonewagon_out_rot_z = 0
na.nav_points[8].bonewagon_out_pnt_x = 10.8676
na.nav_points[8].bonewagon_out_pnt_y = 15.5262
na.nav_points[8].bonewagon_out_pnt_z = 0.5
na.nav_points[8].bonewagon_out_rot_x = 0
na.nav_points[8].bonewagon_out_rot_y = 1410.5
na.nav_points[8].bonewagon_out_rot_z = 0
na.nav_points[9].bonewagon_out_pnt_x = 16.0665
na.nav_points[9].bonewagon_out_pnt_y = 7.8298802
na.nav_points[9].bonewagon_out_pnt_z = 0.5
na.nav_points[9].bonewagon_out_rot_x = 0
na.nav_points[9].bonewagon_out_rot_y = 1737.46
na.nav_points[9].bonewagon_out_rot_z = 0
na.nav_points[10].bonewagon_out_pnt_x = 16.580601
na.nav_points[10].bonewagon_out_pnt_y = 0.45177901
na.nav_points[10].bonewagon_out_pnt_z = 0.5
na.nav_points[10].bonewagon_out_rot_x = 0
na.nav_points[10].bonewagon_out_rot_y = 2072.22
na.nav_points[10].bonewagon_out_rot_z = 0
na.nav_points[11].bonewagon_out_pnt_x = 15.2199
na.nav_points[11].bonewagon_out_pnt_y = -3.3735099
na.nav_points[11].bonewagon_out_pnt_z = 0.5
na.nav_points[11].bonewagon_out_rot_x = 0
na.nav_points[11].bonewagon_out_rot_y = 2407.49
na.nav_points[11].bonewagon_out_rot_z = 0
na.nav_points[12].bonewagon_out_pnt_x = -0.120106
na.nav_points[12].bonewagon_out_pnt_y = -11.213
na.nav_points[12].bonewagon_out_pnt_z = 0.5
na.nav_points[12].bonewagon_out_rot_x = 0
na.nav_points[12].bonewagon_out_rot_y = 151.653
na.nav_points[12].bonewagon_out_rot_z = 0
na.path1 = na.nav_points[1]
na.path2 = na.nav_points[2]
na.path3 = na.nav_points[3]
na.path4 = na.nav_points[4]
na.path5 = na.nav_points[5]
na.path6 = na.nav_points[6]
na.path7 = na.nav_points[7]
na.path8 = na.nav_points[8]
na.path9 = na.nav_points[9]
na.path10 = na.nav_points[10]
na.path11 = na.nav_points[11]
na.path12 = na.nav_points[12]
na.writenavpoint = function(arg1, arg2) -- line 855
    local local1
    local local2, local3
    local1 = InputDialog("Nav points", "Index:")
    local1 = tonumber(local1)
    if na.nav_points[local1] == nil then
        na.nav_points[local1] = { }
    end
    local2 = manny:getpos()
    local3 = manny:getrot()
    if arg2 then
        na.nav_points[local1].use_pos = local2
        na.nav_points[local1].use_rot = local3
    else
        na.nav_points[local1].out_pos = local2
        na.nav_points[local1].out_rot = local3
    end
    PrintDebug("Got nav " .. local1 .. "\n")
    writeto("navpoints.txt")
    local1 = 0
    while local1 < 12 do
        if na.nav_points[local1] then
            write("na.nav_points[" .. local1 .. "] = {}\n")
            if na.nav_points[local1].use_pos then
                write("na.nav_points[" .. local1 .. "].use_pnt_x = " .. na.nav_points[local1].use_pos.x .. "\n")
                write("na.nav_points[" .. local1 .. "].use_pnt_y = " .. na.nav_points[local1].use_pos.y .. "\n")
                write("na.nav_points[" .. local1 .. "].use_pnt_z = " .. na.nav_points[local1].use_pos.z .. "\n")
            end
            if na.nav_points[local1].use_rot then
                write("na.nav_points[" .. local1 .. "].use_rot_x = " .. na.nav_points[local1].use_rot.x .. "\n")
                write("na.nav_points[" .. local1 .. "].use_rot_y = " .. na.nav_points[local1].use_rot.y .. "\n")
                write("na.nav_points[" .. local1 .. "].use_rot_z = " .. na.nav_points[local1].use_rot.z .. "\n")
            end
            if na.nav_points[local1].out_pos then
                write("na.nav_points[" .. local1 .. "].out_pnt_x = " .. na.nav_points[local1].out_pos.x .. "\n")
                write("na.nav_points[" .. local1 .. "].out_pnt_y = " .. na.nav_points[local1].out_pos.y .. "\n")
                write("na.nav_points[" .. local1 .. "].out_pnt_z = " .. na.nav_points[local1].out_pos.z .. "\n")
            end
            if na.nav_points[local1].out_rot then
                write("na.nav_points[" .. local1 .. "].out_rot_x = " .. na.nav_points[local1].out_rot.x .. "\n")
                write("na.nav_points[" .. local1 .. "].out_rot_y = " .. na.nav_points[local1].out_rot.y .. "\n")
                write("na.nav_points[" .. local1 .. "].out_rot_z = " .. na.nav_points[local1].out_rot.z .. "\n")
            end
        end
        local1 = local1 + 1
    end
    writeto()
end
NavButtonHandler = function(arg1, arg2, arg3) -- line 909
    if arg1 == UKEY and arg2 then
        na:writenavpoint(TRUE)
    elseif arg1 == OKEY and arg2 then
        na:writenavpoint(FALSE)
    else
        SampleButtonHandler(arg1, arg2, arg3)
    end
end
CheckFirstTime("ly.lua")
dofile("br_idles.lua")
dofile("cc_taplook.lua")
dofile("cc_play_slot.lua")
dofile("meche_seduction.lua")
dofile("cc_seduction.lua")
dofile("unicycle_man.lua")
dofile("ly_slot_door.lua")
dofile("msb_msb_sheet.lua")
dofile("meche_ruba.lua")
dofile("cc_toga.lua")
dofile("mi_with_cc_toga.lua")
dofile("ly_cc_sheet.lua")
ly = Set:create("ly.set", "le mans lobby", { ly_top = 0, ly_intha = 1, ly_intha1 = 1, ly_intha2 = 1, ly_intha3 = 1, ly_intha4 = 1, ly_intha5 = 1, ly_intha6 = 1, ly_intha7 = 1, ly_sltha = 2, ly_chaws = 3, ly_elems = 4, ly_kenla = 5, ly_lavha = 6 })
ly.unicycle_roll_min_vol = 5
ly.unicycle_roll_max_vol = 20
slot_wheel = { parent = Actor }
slot_wheel.pitch = { }
slot_wheel.pitch[1] = { 30, 105, 175, 280 }
slot_wheel.pitch[2] = { 140, 210, 315 }
slot_wheel.pitch[3] = { 65, 245 }
slot_wheel.pitch[4] = { 350 }
slot_wheel.create = function(arg1) -- line 42
    local local1
    local local2
    local1 = Actor:create(nil, nil, nil, "slot wheel")
    local1.parent = arg1
    local2 = rndint(1, 4)
    local1.cur_pitch = arg1.pitch[local2][1]
    local1.slot = FALSE
    return local1
end
slot_wheel.default = function(arg1) -- line 55
    arg1:set_costume("ly_slotwheel.cos")
    arg1:put_in_set(ly)
    arg1:setrot(arg1.cur_pitch, 270, 90)
end
slot_wheel.spin = function(arg1) -- line 61
    local local1
    local local2
    local local3
    local local4 = { "ly_wlsp1.WAV", "ly_wlsp2.WAV", "ly_wlsp3.WAV" }
    local2 = arg1:get_positive_rot()
    local1 = 10
    arg1.slot = nil
    while arg1.slot == nil do
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        arg1.cur_pitch = arg1.cur_pitch - local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        if local1 < 60 then
            local1 = local1 + 1
        end
        break_here()
    end
    local3 = FALSE
    while not local3 do
        if local1 > 5 then
            local1 = local1 - 1
        end
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
    arg1:play_sound_at(pick_one_of(local4, TRUE))
end
slot_wheel.scramble_to_win = function(arg1) -- line 107
    local local1
    local local2, local3
    arg1.slot = 4
    local2 = arg1:get_positive_rot()
    if rnd(5) then
        local1 = 5
    else
        local1 = -5
    end
    local3 = FALSE
    arg1.cur_pitch = local2.x
    while not local3 do
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
end
slot_wheel.check_match = function(arg1) -- line 137
    local local1, local2
    local local3
    local3 = FALSE
    local1, local2 = next(arg1.pitch[arg1.slot], nil)
    while local1 and not local3 do
        if abs(local2 - arg1.cur_pitch) < 5 then
            local3 = TRUE
        end
        local1, local2 = next(arg1.pitch[arg1.slot], local1)
    end
    return local3
end
slot_machine = { }
slot_machine.create = function(arg1) -- line 156
    local local1
    local1 = { }
    local1.parent = arg1
    local1.actors = { }
    local1.pos = { }
    local1.rot = nil
    local1.spinning = FALSE
    return local1
end
slot_machine.create_wheels = function(arg1) -- line 169
    local local1
    if not arg1.actors then
        arg1.actors = { }
    end
    local1 = 1
    while local1 <= 3 do
        if not arg1.actors[local1] then
            arg1.actors[local1] = slot_wheel:create()
        end
        local1 = local1 + 1
    end
end
slot_machine.free = function(arg1) -- line 185
    if arg1.actors then
        if arg1.actors[1] then
            arg1.actors[1]:free()
        end
        if arg1.actors[2] then
            arg1.actors[2]:free()
        end
        if arg1.actors[3] then
            arg1.actors[3]:free()
        end
    end
    arg1.actors = nil
end
slot_machine.default = function(arg1) -- line 200
    local local1
    arg1:create_wheels()
    local1 = 1
    while local1 <= 3 do
        arg1.actors[local1]:default()
        arg1.actors[local1]:setpos(arg1.pos[local1].x, arg1.pos[local1].y, arg1.pos[local1].z)
        if arg1.rot then
            arg1.actors[local1]:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
        end
        local1 = local1 + 1
    end
end
slot_machine.spin = function(arg1) -- line 216
    arg1.spin_scripts = { }
    arg1.spinning = TRUE
    arg1.wheel_sound = arg1.actors[1]:play_sound_at("ly_wheel.IMU", 10, 80)
    arg1.spin_scripts[1] = start_script(arg1.actors[1].spin, arg1.actors[1])
    break_here()
    arg1.spin_scripts[2] = start_script(arg1.actors[2].spin, arg1.actors[2])
    break_here()
    arg1.spin_scripts[3] = start_script(arg1.actors[3].spin, arg1.actors[3])
end
slot_machine.scramble_to_win = function(arg1) -- line 229
    local local1, local2, local3
    local1 = start_script(arg1.actors[1].scramble_to_win, arg1.actors[1])
    local2 = start_script(arg1.actors[2].scramble_to_win, arg1.actors[2])
    local3 = start_script(arg1.actors[3].scramble_to_win, arg1.actors[3])
    wait_for_script(local1)
    wait_for_script(local2)
    wait_for_script(local3)
end
slot_machine.stop = function(arg1, arg2) -- line 239
    local local1
    local local2
    if arg1.spinning then
        local1 = FALSE
        local2 = { }
        repeat
            local2[1] = rndint(1, 4)
            local2[2] = rndint(1, 4)
            local2[3] = rndint(1, 4)
            if not arg2 then
                if local2[1] == local2[2] and local2[2] == local2[3] then
                    local1 = FALSE
                else
                    local1 = TRUE
                end
            elseif local2[1] == local2[2] and local2[2] == local2[3] then
                local1 = TRUE
            else
                local1 = FALSE
            end
            if not local1 then
                break_here()
            end
        until local1
        arg1.actors[1].slot = local2[1]
        if arg1.spin_scripts[1] then
            wait_for_script(arg1.spin_scripts[1])
        end
        sleep_for(100)
        arg1.actors[2].slot = local2[2]
        if arg1.spin_scripts[2] then
            wait_for_script(arg1.spin_scripts[2])
        end
        sleep_for(100)
        arg1.actors[3].slot = local2[3]
        if arg1.spin_scripts[3] then
            wait_for_script(arg1.spin_scripts[3])
        end
    end
    arg1.spinning = FALSE
    stop_sound("ly_wheel.IMU")
    arg1.spin_scripts = nil
end
slot_machine.freeze = function(arg1) -- line 295
    arg1.actors[1]:freeze()
    arg1.actors[2]:freeze()
    arg1.actors[3]:freeze()
end
slot_machine.thaw = function(arg1, arg2) -- line 301
    arg1.actors[1]:thaw(arg2)
    arg1.actors[2]:thaw(arg2)
    arg1.actors[3]:thaw(arg2)
end
ly.slot_handle = { }
ly.slot_handle.parent = Actor
ly.slot_handle.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 312
    local local1
    local1 = Actor:create(nil, nil, nil, "handle")
    local1.parent = ly.slot_handle
    if arg2 then
        local1.pos = { }
        local1.pos.x = arg2
        local1.pos.y = arg3
        local1.pos.z = arg4
    end
    if arg5 then
        local1.rot = { }
        local1.rot.x = arg5
        local1.rot.y = arg6
        local1.rot.z = arg7
    end
    return local1
end
ly.slot_handle.default = function(arg1) -- line 333
    arg1:put_in_set(ly)
    arg1:set_costume("ly_slothandle.cos")
    arg1:play_chore(1)
    if arg1.pos then
        arg1:setpos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    end
    if arg1.rot then
        arg1:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
    end
end
ly.slot_handle.init = function(arg1) -- line 345
    if not arg1[1] then
        arg1[1] = ly.slot_handle:create(0.63847, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[2] then
        arg1[2] = ly.slot_handle:create(1.05447, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[3] then
        arg1[3] = ly.slot_handle:create(1.82115, -0.135567, 0.015, 0, 270, 0)
    end
    if not arg1[4] then
        arg1[4] = ly.slot_handle:create(1.82285, -0.541493, 0.013, 0, 270, 0)
    end
    arg1[1]:default()
    arg1[2]:default()
    arg1[3]:default()
    arg1[4]:default()
    arg1[4]:set_visibility(FALSE)
    arg1[1]:freeze()
    arg1[2]:freeze()
end
ly.slot_handle.free = function(arg1) -- line 369
    if arg1[1] then
        arg1[1]:free()
    end
    if arg1[2] then
        arg1[2]:free()
    end
    if arg1[3] then
        arg1[3]:free()
    end
end
charlies_slot = slot_machine:create()
charlies_slot.pos[1] = { x = 2.1475301, y = -0.416738, z = 0.44400001 }
charlies_slot.pos[2] = { x = 2.1475301, y = -0.492737, z = 0.44400001 }
charlies_slot.pos[3] = { x = 2.1475301, y = -0.569736, z = 0.44400001 }
mannys_slot = slot_machine:create()
mannys_slot.pos[1] = { x = 2.1358399, y = -0.0144972, z = 0.44499999 }
mannys_slot.pos[2] = { x = 2.1358399, y = -0.0924972, z = 0.44499999 }
mannys_slot.pos[3] = { x = 2.1358399, y = -0.169497, z = 0.44499999 }
ly.keno_actor = Actor:create(nil, nil, nil, "keno board")
ly.keno_actor.current_number = nil
ly.keno_actor.current_game = nil
ly.keno_actor.game_index = 1
ly.keno_actor.game_paused = FALSE
ly.keno_actor.default = function(arg1) -- line 417
    arg1:set_costume("ly_keno.cos")
    arg1:put_in_set(ly)
    arg1:setpos(-0.0558433, -0.0978411, 2.801)
    arg1:set_visibility(TRUE)
end
ly.keno_actor.game = function(arg1) -- line 424
    while TRUE do
        arg1:clear_game()
        while arg1.game_index < 10 do
            if not arg1.game_paused then
                arg1:choose_number()
            end
            sleep_for(15000)
        end
        break_here()
    end
end
ly.keno_actor.clear_game = function(arg1) -- line 437
    arg1.current_game = { }
    arg1.game_index = 0
    arg1.current_number = nil
    arg1:complete_chore(32)
end
ly.keno_actor.choose_number = function(arg1) -- line 444
    local local1, local2
    local2 = TRUE
    while local2 do
        local1 = rndint(1, 32)
        if not arg1:find_number(local1) then
            local2 = FALSE
        else
            break_here()
        end
    end
    arg1.game_index = arg1.game_index + 1
    arg1.current_game[arg1.game_index] = local1
    arg1.current_number = local1
    arg1:complete_chore(local1 - 1)
    arg1:play_sound_at("ly_keno.wav", 10, 70)
end
ly.keno_actor.find_number = function(arg1, arg2) -- line 463
    local local1, local2
    local2 = FALSE
    local1 = 1
    while local1 <= arg1.game_index and not local2 do
        if arg1.current_game[local1] == arg2 then
            local2 = TRUE
        end
        local1 = local1 + 1
    end
    return local2
end
unicycle_man.point = { }
unicycle_man.point[0] = { }
unicycle_man.point[0].pos = { x = 0.89800102, y = 0.39131901, z = 0 }
unicycle_man.point[0].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point[1] = { }
unicycle_man.point[1].pos = { x = 0.49000099, y = 0.394319, z = 0 }
unicycle_man.point[1].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.mid = { }
unicycle_man.point["mid"].pos = { x = 0.74000102, y = 0.090319097, z = 0 }
unicycle_man.point["mid"].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.charlie = { }
unicycle_man.point["charlie"].pos = { x = 1.84929, y = -0.39064199, z = 0 }
unicycle_man.point["charlie"].rot = { x = 0, y = 270.01999, z = 0 }
unicycle_man.cur_point = 0
unicycle_man.save_pos = function(arg1) -- line 499
    arg1.current_pos = arg1:getpos()
    arg1.current_rot = arg1:getrot()
end
unicycle_man.restore_pos = function(arg1) -- line 504
    local local1
    if arg1.current_pos then
        arg1:setpos(arg1.current_pos.x, arg1.current_pos.y, arg1.current_pos.z)
        arg1:setrot(arg1.current_rot.x, arg1.current_rot.y, arg1.current_rot.z)
    else
        local1 = arg1.point[arg1.cur_point]
        arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
        arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
    end
end
unicycle_man.cycle_to = function(arg1, arg2, arg3) -- line 517
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg1.point.mid.pos)
    local1 = local1 + 180
    arg1:set_turn_rate(120)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:setrot(0, local1, 0, TRUE)
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(-0.30000001)
    while proximity(arg1.hActor, arg1.point.mid.pos.x, arg1.point.mid.pos.y, arg1.point.mid.pos.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:stop_chore(unicycle_man_roll)
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.cycle_straight_to = function(arg1, arg2, arg3) -- line 564
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:set_turn_rate(120)
    arg1:stop_chore(unicycle_man_idles)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    arg1:setrot(0, local1, 0, TRUE)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.turn_to_manny = function(arg1) -- line 591
    local local1, local2
    local2 = manny:getpos()
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    local1 = GetActorYawToPoint(arg1.hActor, local2)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    stop_sound("um_roll.IMU")
end
ly.agent_talk_count = 0
ly.talk_to_agent = function(arg1) -- line 610
    local local1 = TRUE
    local local2 = FALSE
    local local3, local4
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    manny:set_collision_mode(COLLISION_OFF)
    ly.agent_talk_count = ly.agent_talk_count + 1
    if ly.agent_talk_count == 1 then
        ly.met_agent = TRUE
        manny:say_line("/lyma066/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum067/")
        unicycle_man:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:say_line("/lyum068/")
        unicycle_man:wait_for_message()
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        manny:tilt_head_gesture(TRUE)
        manny:point_gesture(TRUE)
        manny:say_line("/lyma069/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum070/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum071/")
        unicycle_man:wait_for_message()
    elseif ly.agent_talk_count == 2 then
        manny:say_line("/lyma072/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        unicycle_man:say_line("/lyum073/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum074/")
        unicycle_man:wait_for_message()
        manny:say_line("/lyma075/")
    elseif ly.meche_talk_count < 2 then
        manny:say_line("/lyma076/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum077/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum078/")
        unicycle_man:wait_for_message()
        local2 = TRUE
    elseif not ly.charlie_on_floor then
        manny:say_line("/lyma079/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum080/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum081/")
        unicycle_man:wait_for_message()
    else
        local1 = FALSE
        start_script(ly.charlies_jackpot)
    end
    END_CUT_SCENE()
    manny:set_collision_mode(COLLISION_OFF)
    if local1 then
        start_script(ly.unicycle_idles, ly, local2)
    end
end
ly.unicycle_idles = function(arg1, arg2) -- line 708
    local local1, local2
    unicycle_man.in_machine = FALSE
    unicycle_man.rolling = FALSE
    while TRUE do
        break_here()
        ly:track_unicycle_man()
        if not arg2 then
            local1 = unicycle_man.cur_point + 1
            if not unicycle_man.point[local1] then
                local1 = 0
            end
            unicycle_man.cur_point = local1
            unicycle_man.rolling = TRUE
            start_script(unicycle_man.cycle_to, unicycle_man, unicycle_man.point[local1].pos, unicycle_man.point[local1].rot)
            while find_script(unicycle_man.cycle_to) do
                break_here()
                ly:track_unicycle_man()
            end
            unicycle_man.rolling = FALSE
            sleep_for(10000)
        else
            local1 = unicycle_man.cur_point
            unicycle_man:setrot(unicycle_man.point[local1].rot.x, unicycle_man.point[local1].rot.y, unicycle_man.point[local1].rot.z, TRUE)
            unicycle_man:wait_for_actor()
        end
        unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
        unicycle_man:wait_for_chore(unicycle_man_idles)
        unicycle_man.in_machine = TRUE
        unicycle_man:run_chore(unicycle_man_crawl_slot)
        start_script(ly.unicycle_slot_sfx)
        sleep_for(rndint(6000, 9000))
        unicycle_man:play_sound_at("ly_pyoff.IMU", 80, 110)
        unicycle_man:run_chore(unicycle_man_out_slot)
        fade_sfx("ly_pyoff.IMU", 200)
        unicycle_man:play_chore_looping(unicycle_man_idles)
        unicycle_man.in_machine = FALSE
        sleep_for(10000)
    end
end
ly.unicycle_stop_idles = function(arg1) -- line 762
    stop_sound("ly_pyoff.IMU")
    stop_script(ly.unicycle_idles)
    if unicycle_man.rolling then
        while find_script(unicycle_man.cycle_to) do
            break_here()
            ly:track_unicycle_man()
        end
        unicycle_man.rolling = FALSE
    elseif unicycle_man.in_machine then
        if unicycle_man:is_choring(unicycle_man_crawl_slot) then
            unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
            unicycle_man:run_chore(unicycle_man_out_slot)
        elseif unicycle_man:is_choring(unicycle_man_out_slot) then
            unicycle_man:wait_for_chore(unicycle_man_out_slot)
        else
            unicycle_man:run_chore(unicycle_man_out_slot)
        end
    end
    unicycle_man:play_chore_looping(unicycle_man_idles)
end
ly.track_unicycle_man = function(arg1) -- line 788
    local local1
    local1 = unicycle_man:getpos()
    ly.unicycle_man.obj_x = local1.x
    ly.unicycle_man.obj_y = local1.y
    ly.unicycle_man.obj_z = local1.z + 0.40000001
    ly.unicycle_man.interest_actor:put_in_set(ly)
    ly.unicycle_man.interest_actor:setpos(ly.unicycle_man.obj_x, ly.unicycle_man.obj_y, ly.unicycle_man.obj_z)
    if hot_object == ly.unicycle_man then
        system.currentActor:head_look_at(ly.unicycle_man)
    end
end
ly.unicycle_slot_sfx = function(arg1) -- line 802
    local local1 = { "um_swit1.wav", "um_swit2.wav", "um_swit3.wav" }
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
end
ly.brennis_idle_table = Idle:create("br_idles")
idt = ly.brennis_idle_table
idt:add_state("rest", { rest = 0.97000003, looks = 0.0099999998, moves_head = 0.0099999998, scrtch_chst = 0.0099999998 })
idt:add_state("looks", { rest = 1 })
idt:add_state("moves_head", { rest = 1 })
idt:add_state("scrtch_chst", { rest = 1 })
ly.brennis_talk_count = 0
ly.brennis_stop_idle = function(arg1) -- line 830
    stop_script(brennis.ly_idle_script)
    brennis.ly_idle_script = nil
    brennis:wait_for_chore()
    brennis:play_chore(br_idles_rest)
end
ly.brennis_start_idle = function(arg1) -- line 837
    brennis:stop_chore()
    brennis.ly_idle_script = start_script(brennis.new_run_idle, brennis, "rest", ly.brennis_idle_table, "br_idles.cos")
end
ly.talk_clothes_with_brennis = function(arg1) -- line 842
    START_CUT_SCENE()
    ly.brennis_talk_count = ly.brennis_talk_count + 1
    start_script(ly.brennis_stop_idle, ly)
    if ly.brennis_talk_count == 1 then
        ly:current_setup(ly_kenla)
        sleep_for(1500)
        manny:tilt_head_gesture()
        manny:say_line("/lyma012/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs013/")
        brennis:wait_for_message()
        brennis:say_line("/lybs014/")
    elseif ly.brennis_talk_count == 2 then
        ly:current_setup(ly_kenla)
        manny:shrug_gesture()
        manny:say_line("/lyma015/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_scrtch_chst, "br_idles.cos")
        brennis:say_line("/lybs016/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma017/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs018/")
    elseif ly.brennis_talk_count == 3 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma019/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs020/")
        brennis:wait_for_message()
        brennis:say_line("/lybs021/")
        brennis:wait_for_message()
        brennis:say_line("/lybs022/")
        brennis:wait_for_message()
    elseif ly.brennis_talk_count == 4 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma023/")
        manny:wait_for_message()
        manny:tilt_head_gesture()
        manny:say_line("/lyma024/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs025/")
        brennis:wait_for_message()
        brennis:say_line("/lybs026/")
        brennis:wait_for_chore(br_idles_bar_door, "br_idles.cos")
    elseif ly.brennis_talk_count == 5 then
        ly:current_setup(ly_kenla)
        manny:point_gesture()
        manny:say_line("/lyma027/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs028/")
        brennis:wait_for_message()
        brennis:say_line("/lybs029/")
        brennis:wait_for_message()
        brennis:say_line("/lybs030/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma031/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs032/")
    else
        ly:current_setup(ly_kenla)
        manny:twist_head_gesture()
        manny:say_line("/lyma033/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs034/")
    end
    END_CUT_SCENE()
    brennis:wait_for_chore()
    ly:brennis_start_idle()
end
ly.meche_talk_count = 0
ly.gun_control = function() -- line 947
    while TRUE do
        break_here()
        if manny.is_holding == fi.gun and system.currentSet == ly then
            START_CUT_SCENE()
            wait_for_script(open_inventory)
            wait_for_script(close_inventory)
            manny:clear_hands()
            manny:say_line("/lyma003/")
            manny:wait_for_message()
            manny:say_line("/lyma004/")
            END_CUT_SCENE()
        end
    end
end
ly.playslots = function(arg1, arg2) -- line 963
    START_CUT_SCENE()
    manny:walkto(1.8283, -0.263458, 0, 0, 292.582, 0)
    manny:wait_for_actor()
    manny:head_look_at(nil)
    ly.slot_handle[3]:thaw(TRUE)
    mannys_slot:thaw(TRUE)
    ly.slot_handle[3]:play_chore(0)
    sleep_for(50)
    manny:play_chore(msb_reach_cabinet, manny.base_costume)
    sleep_for(500)
    mannys_slot:spin()
    sleep_for(500)
    manny:head_look_at(ly.slot1)
    if not ly.played then
        ly.played = TRUE
        manny:say_line("/lyma006/")
        wait_for_message()
        manny:say_line("/lyma007/")
        wait_for_message()
    end
    manny:wait_for_chore(msb_reach_cabinet, manny.base_costume)
    manny:stop_chore(msb_reach_cabinet, manny.base_costume)
    manny:head_look_at(ly.slot1)
    ly.slot_handle[3]:wait_for_chore(0)
    ly.slot_handle[3]:freeze()
    if rnd() then
        mannys_slot:stop(FALSE)
        if not ly.lost then
            ly.lost = TRUE
            manny:say_line("/lyma008/")
        end
    else
        mannys_slot:stop(TRUE)
        manny:say_line("/lyma009/")
        if not ly.won then
            ly.won = TRUE
            manny:wait_for_message()
            manny:head_look_at_point(1.89026, -0.0954438, 0)
            manny:say_line("/lyma010/")
            manny:wait_for_message()
            manny:say_line("/lyma011/")
        end
    end
    END_CUT_SCENE()
    manny:head_look_at(nil)
    mannys_slot:freeze()
end
ly.talk_clothes_with_meche = function(arg1) -- line 1019
    START_CUT_SCENE()
    if ly.charlie_on_floor then
        meche:say_line("/lymc005/")
    else
        ly.meche_talk_count = ly.meche_talk_count + 1
        if ly.meche_talk_count == 1 then
            single_start_script(ly.seduce_charlie, ly)
            manny:say_line("/lyma035/")
            manny:wait_for_message()
            meche:say_line("/lymc036/")
        elseif ly.meche_talk_count == 2 then
            manny:walkto_object(ly.meche_obj)
            manny:wait_for_actor()
            if find_script(ly.seduce_charlie) and ly.meche_obj.touchable then
                stop_script(ly.seduce_charlie)
            end
            manny:say_line("/lyma037/")
            manny:wait_for_message()
            while not ly.meche_obj.touchable do
                break_here()
            end
            meche:say_line("/lymc038/")
            meche:wait_for_message()
            meche:say_line("/lymc039/")
            meche:wait_for_message()
            meche:say_line("/lymc040/")
            ly:manny_take_sheet_from_meche()
        elseif ly.meche_talk_count == 3 then
            manny:say_line("/lyma041/")
            manny:wait_for_message()
            meche:say_line("/lymc042/")
            meche:wait_for_message()
            meche:say_line("/lymc043/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
            meche:wait_for_message()
            manny:say_line("/lyma044/")
        else
            manny:say_line("/lyma045/")
            manny:wait_for_message()
            meche:say_line("/lymc046/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
        end
    end
    END_CUT_SCENE()
end
ly.manny_take_sheet_from_meche = function(arg1) -- line 1071
    manny:walkto_object(ly.meche_obj)
    manny:wait_for_actor()
    if meche:is_choring(meche_seduction_mec_sed_ch, FALSE, "meche_seduction.cos") then
        meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    end
    stop_script(ly.seduce_charlie)
    stop_script(ly.meche_idles)
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(0, "mi_msb_sheet.cos")
    manny:push_costume("msb_msb_sheet.cos")
    manny:setrot(0, 231.446, 0)
    manny:play_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    ly.sheet:get()
    manny.is_holding = ly.sheet
    meche:wait_for_chore(0, "mi_msb_sheet.cos")
    meche:stop_chore(0, "mi_msb_sheet.cos")
    meche:play_chore(meche_ruba_hands_down_hold, "meche_ruba.cos")
    manny:wait_for_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    meche.holding_sheet = FALSE
    inventory_disabled = TRUE
    ly.ready_to_seduce = FALSE
    single_start_script(ly.meche_idles)
end
ly.talk_toga_with_charlie = function(arg1) -- line 1101
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    manny:walkto_object(ly.charlie_obj)
    if ly.meche_talk_count < 3 then
        manny:say_line("/lyma047/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc048/")
        charlie:run_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    else
        manny:say_line("/lyma049/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc050/")
        charlie:wait_for_message()
        charlie:play_chore(cc_taplook_turn2slots, "cc_taplook.cos")
        charlie:say_line("/lycc051/")
        charlie:wait_for_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    end
    if not find_script(charlies_slot.stop) then
        charlies_slot:stop()
    else
        wait_for_script(charlies_slot.stop)
    end
    charlie:stop_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    charlie:pop_costume()
    start_script(ly.charlie_idles, ly)
    END_CUT_SCENE()
end
ly.throw_sheet = function(arg1) -- line 1149
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    stop_script(charlies_slot.stop)
    stop_sound("ly_wheel.IMU")
    stop_script(slot_wheel.spin)
    if not ly.sheet_on_floor.has_object_states then
        ly:add_object_state(ly_sltha, "ly_cc_sheet.bm", "ly_cc_sheet.zbm", OBJSTATE_STATE, TRUE)
        ly.sheet_on_floor:set_object_state("ly_cc_sheet.cos")
        ly.sheet_on_floor.interest_actor:put_in_set(ly)
    end
    ly.sheet:free()
    ly.charlie_on_floor = TRUE
    ly.charlie_obj:make_untouchable()
    box_off("charlie_box")
    box_off("mannys_slot")
    manny.is_holding = nil
    manny:stop_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    inventory_disabled = FALSE
    manny:pop_costume()
    manny:setpos(1.50568, -0.210109, 0)
    manny:setrot(0, 176.891, 0)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    charlie:set_visibility(FALSE)
    ly.sheet_on_floor:play_chore(ly_cc_sheet_here)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_sheet_toss.snm")
    sleep_for(500)
    start_sfx("cc_shtts.WAV")
    ly.slot_handle[4]:set_visibility(TRUE)
    sleep_for(1000)
    if not ly.sheeted then
        ly.sheeted = TRUE
        charlie:say_line("/lycc052/")
    else
        charlie:say_line("/lycc053/")
    end
    sleep_for(4600)
    start_sfx("ccsheet1.wav")
    sleep_for(1250)
    start_sfx("cc_falls.wav")
    charlie:wait_for_message()
    charlie:say_line("/lycc054/")
    charlie:wait_for_message()
    ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
    wait_for_movie()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    start_script(ly.charlie_struggle)
    start_script(ly.charlie_get_up_timer)
    END_CUT_SCENE()
end
ly.charlie_struggle = function(arg1) -- line 1226
    local local1
    local local2 = { "/lycc055/", "/lycc056/", "/lycc057/", "/lycc058/", "/lycc059/", "/lycc060/", "/lycc061/", "/lycc062/", "/lycc063/" }
    while TRUE do
        sleep_for(2000)
        ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
        local1 = pick_one_of({ "ccsheet1.wav", "ccsheet2.wav", "ccsheet3.wav", "ccsheet4.wav", "ccsheet5.wav", "ccsheet6.wav" })
        start_sfx(local1, IM_HIGH_PRIORITY, 100)
        charlie:say_line(pick_one_of(local2, TRUE), { background = TRUE, skip_log = TRUE, volume = 80 })
        charlie:wait_for_message()
    end
end
ly.charlie_get_up_timer = function(arg1) -- line 1248
    sleep_for(25000)
    stop_script(ly.charlie_struggle)
    while cutSceneLevel > 0 do
        break_here()
    end
    START_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.charlie_obj:make_touchable()
    box_on("charlie_box")
    box_on("mannys_slot")
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_getup.snm")
    charlie:set_visibility(TRUE)
    ly.slot_handle[4]:set_visibility(FALSE)
    stop_script(ly.meche_idles)
    charlie:push_costume("cc_seduction.cos")
    charlie:play_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche.holding_sheet = TRUE
    sleep_for(2000)
    start_sfx("ccsheet1.wav")
    sleep_for(2500)
    start_sfx("cc_shtof.WAV")
    charlie:say_line("/lycc064/", { volume = 90 })
    wait_for_movie()
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    charlie:wait_for_message()
    charlie:say_line("/lycc065/")
    charlie:wait_for_message()
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    END_CUT_SCENE()
    start_script(ly.charlie_idles, ly)
    start_script(ly.meche_idles, ly)
end
ly.charlies_jackpot = function(arg1) -- line 1310
    local local1
    local local2
    local local3, local4
    stop_script(ly.charlie_get_up_timer)
    stop_script(ly.charlie_idles)
    stop_script(ly.meche_idles)
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    if not find_script(charlies_slot.stop) then
        start_script(charlies_slot.stop, charlies_slot, FALSE)
    end
    ly:add_object_state(ly_chaws, "ly_slot_door.bm", "ly_slot_door.zbm", OBJSTATE_STATE)
    ly.charlie_obj:set_object_state("ly_slot_door.cos")
    ly.charlie_obj.interest_actor:set_visibility(TRUE)
    ly.charlie_obj.interest_actor:put_in_set(ly)
    manny:walkto(0.60399699, -0.122419, 0, 0, 324.94, 0)
    manny:say_line("/lyma082/")
    manny:wait_for_message()
    wait_for_script(ly.unicycle_stop_idles)
    unicycle_man:turn_to_manny()
    local1 = GetActorYawToPoint(manny.hActor, unicycle_man.point["charlie"].pos)
    manny:setrot(0, local1, 0, TRUE)
    manny:point_gesture()
    manny:say_line("/lyma083/")
    manny:wait_for_message()
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point["charlie"].pos, unicycle_man.point["charlie"].rot)
    unicycle_man:say_line("/lyum084/")
    unicycle_man:wait_for_message()
    wait_for_script(unicycle_man.cycle_straight_to)
    unicycle_man:wait_for_actor()
    unicycle_man:setpos(1.90781, -0.36290601, 0)
    unicycle_man:setrot(0, 270, 0)
    ly:current_setup(ly_chaws)
    meche:set_visibility(FALSE)
    unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
    unicycle_man:wait_for_chore(unicycle_man_idles)
    unicycle_man:play_chore(unicycle_man_crawl_slot)
    stop_sound("um_roll.IMU")
    sleep_for(3500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    sleep_for(3300)
    unicycle_man:play_chore(unicycle_man_hide_body)
    unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
    start_script(ly.unicycle_slot_sfx)
    ly.charlie_obj:run_chore(ly_slot_door_close)
    sleep_for(1000)
    charlies_slot:scramble_to_win()
    local3 = Actor:create(nil, nil, nil, "Money")
    local3:set_costume("coin_pile.cos")
    local3:put_in_set(ly)
    local3:setpos(1.99385, -0.48749301, 0.16)
    local3:setrot(0, 0, 0)
    local4 = 0.1
    start_sfx("ly_pyoff.IMU")
    while local4 <= 1 do
        SetActorScale(local3.hActor, local4)
        break_here()
        local4 = local4 + 0.050000001
    end
    fade_sfx("ly_pyoff.IMU", 1000)
    sleep_for(2500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    unicycle_man:play_chore(unicycle_man_out_slot_no_grab)
    sleep_for(500)
    unicycle_man:play_chore(unicycle_man_show_body)
    sleep_for(4000)
    ly.charlie_obj:play_chore(ly_slot_door_close)
    unicycle_man:wait_for_chore(unicycle_man_out_slot_no_grab)
    ly:current_setup(ly_sltha)
    meche:set_visibility(TRUE)
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point[0].pos, unicycle_man.point[0].rot)
    sleep_for(3000)
    stop_script(ly.charlie_struggle)
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    stop_script(unicycle_man.cycle_straight_to)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_win.snm")
    sleep_for(3000)
    start_sfx("cc_shtof.WAV")
    wait_for_movie()
    ly:current_setup(ly_sltha)
    unicycle_man:setpos(unicycle_man.point[0].pos.x, unicycle_man.point[0].pos.y, unicycle_man.point[0].pos.z)
    unicycle_man:setrot(unicycle_man.point[0].rot.x, unicycle_man.point[0].rot.y, unicycle_man.point[0].rot.z)
    unicycle_man:stop_chore(unicycle_man_roll)
    unicycle_man:play_chore_looping(unicycle_man_idles)
    charlie:stop_chore(nil, "cc_play_slot.cos")
    charlie:play_chore(cc_play_slot_hide_handle, "cc_play_slot.cos")
    charlie:push_costume("cc_seduction.cos")
    charlie:setpos(1.49489, -0.50857699, -0.119)
    charlie:setrot(0, 260, 0)
    charlie:set_visibility(TRUE)
    meche:setpos(1.44189, -0.845577, 0)
    meche:setrot(0, 330, 0)
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:stop_chore(nil, "meche_seduction.cos")
    meche:stop_chore(nil, "mi_msb_sheet.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche:set_visibility(TRUE)
    charlie:play_chore(cc_seduction_take_money, "cc_seduction.cos")
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    charlie:say_line("/lycc085/")
    sleep_for(3200)
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    charlie:wait_for_message()
    meche:say_line("/lymc086/")
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    local3:free()
    local3 = nil
    charlie:wait_for_chore(cc_seduction_take_money, "cc_seduction.cos")
    box_on("charlie_box")
    box_on("mannys_slot")
    box_on("meche_box")
    music_state:set_sequence(seqChowchillaBye)
    IrisDown(450, 320, 1000)
    sleep_for(1500)
    ly:current_setup(ly_lavha)
    unicycle_man:free()
    stop_sound("um_roll.IMU")
    manny:setpos(2.22596, 3.59653, 0.89999998)
    manny:setrot(0, 102.462, 0)
    manny:set_collision_mode(COLLISION_OFF)
    meche:set_costume(nil)
    meche:set_costume("meche_ruba.cos")
    meche:set_mumble_chore(meche_ruba_mumble)
    meche:set_talk_chore(1, meche_ruba_stop_talk)
    meche:set_talk_chore(2, meche_ruba_a)
    meche:set_talk_chore(3, meche_ruba_c)
    meche:set_talk_chore(4, meche_ruba_e)
    meche:set_talk_chore(5, meche_ruba_f)
    meche:set_talk_chore(6, meche_ruba_l)
    meche:set_talk_chore(7, meche_ruba_m)
    meche:set_talk_chore(8, meche_ruba_o)
    meche:set_talk_chore(9, meche_ruba_t)
    meche:set_talk_chore(10, meche_ruba_u)
    meche:push_costume("mi_with_cc_toga.cos")
    meche:set_collision_mode(COLLISION_OFF)
    meche:setpos(2.03021, 3.5079, 0.90061998)
    meche:setrot(0, 306.86899, 0)
    meche:play_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    charlie:set_costume(nil)
    charlie:set_costume("cc_toga.cos")
    charlie:set_mumble_chore(cc_toga_mumble)
    charlie:set_talk_chore(1, cc_toga_stop_talk)
    charlie:set_talk_chore(2, cc_toga_a)
    charlie:set_talk_chore(3, cc_toga_c)
    charlie:set_talk_chore(4, cc_toga_e)
    charlie:set_talk_chore(5, cc_toga_f)
    charlie:set_talk_chore(6, cc_toga_l)
    charlie:set_talk_chore(7, cc_toga_m)
    charlie:set_talk_chore(8, cc_toga_o)
    charlie:set_talk_chore(9, cc_toga_t)
    charlie:set_talk_chore(10, cc_toga_u)
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:set_walk_chore(cc_toga_walk)
    charlie:set_walk_rate(0.25)
    charlie:set_head(7, 8, 9, 120, 80, 80)
    charlie:set_look_rate(100)
    ly.mens_room:open()
    charlie:setpos(1.89022, 4.5444798, 0.89999998)
    charlie:setrot(0, 180.181, 0)
    charlie:follow_boxes()
    charlie.footsteps = footsteps.marble
    if not ly.mens_room.has_object_states then
        ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
        ly.mens_room:set_object_state("ly_bath_door.cos")
    end
    IrisUp(125, 325, 1000)
    sleep_for(500)
    manny:head_look_at(nil)
    meche:head_look_at(nil)
    manny:head_forward_gesture()
    manny:say_line("/lyma087/")
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/lyma088/")
    manny:wait_for_message()
    meche:play_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    meche:say_line("/lymc089/")
    meche:wait_for_message()
    meche:wait_for_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    ly.mens_room:play_chore(0)
    start_sfx("ly_batho.WAV")
    manny:head_look_at_point(1.94195, 3.9626, 1.302)
    charlie:walkto(1.95579, 3.78863, 0.89999998)
    sleep_for(500)
    start_script(manny.backup, manny, 1000)
    while charlie:is_moving() do
        if not charlie:find_sector_name("bath_psg") then
            charlie.footsteps = footsteps.rug
        end
        break_here()
    end
    charlie.footsteps = footsteps.rug
    ly.mens_room:play_chore(1)
    start_sfx("ly_bathc.WAV")
    ly.mens_room:close()
    charlie:say_line("/lycc090/", { x = 160, y = 30 })
    meche:stop_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    meche:stop_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    mi_with_cc_done_turning = FALSE
    meche:play_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    sleep_for(1000)
    charlie:head_look_at(meche)
    sleep_for(2400)
    charlie:head_look_at(nil)
    charlie:setrot(0, 100, 0, TRUE)
    charlie:fade_in_chore(cc_toga_take_meche, "cc_toga.cos", 500)
    charlie:wait_for_chore(cc_toga_take_meche, "cc_toga.cos")
    charlie:play_chore(cc_toga_hold_meche, "cc_toga.cos")
    while mi_with_cc_done_turning < 1 do
        break_here()
    end
    while meche:is_choring(mi_with_cc_toga_to_cc_toga, FALSE, "mi_with_cc_toga.cos") do
        WalkActorForward(charlie.hActor)
        break_here()
    end
    meche:wait_for_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    manny:head_look_at(nil)
    END_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.sheet_on_floor:make_untouchable()
    ly.charlie_obj:make_untouchable()
    ly.meche_obj:make_untouchable()
    ly.unicycle_man:make_untouchable()
    ly.charlie_gone = TRUE
    music_state:update()
    cur_puzzle_state[56] = TRUE
    charlie:free()
    meche:free()
end
ly.charlie_idles = function(arg1) -- line 1596
    while system.currentSet == ly do
        ly.ready_to_seduce = FALSE
        charlie:play_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        sleep_for(1000)
        charlies_slot:spin()
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlies_slot:stop(FALSE)
        if find_script(ly.seduce_charlie) then
            ly.ready_to_seduce = TRUE
            while ly.ready_to_seduce do
                break_here()
            end
        end
        break_here()
    end
end
ly.meche_idles = function(arg1) -- line 1614
    local local1 = FALSE
    while system.currentSet == ly do
        if meche.holding_sheet then
            if rnd(8) and not find_script(ly.seduce_charlie) then
                if cutSceneLevel <= 0 then
                    start_script(ly.seduce_charlie, ly)
                    wait_for_script(ly.seduce_charlie)
                end
            end
        elseif rnd(5) then
            if local1 then
                meche:run_chore(meche_ruba_drop_hands, "meche_ruba.cos")
                local1 = FALSE
                sleep_for(rndint(1000, 5000))
            else
                meche:run_chore(meche_ruba_xarms, "meche_ruba.cos")
                local1 = TRUE
                sleep_for(rndint(5000, 10000))
            end
        end
        break_here()
    end
end
ly.seduce_charlie = function(arg1) -- line 1642
    while not ly.ready_to_seduce do
        break_here()
    end
    ly.meche_obj:make_untouchable()
    charlie:set_collision_mode(COLLISION_SPHERE, 0.8)
    meche:play_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    sleep_for(1000)
    charlie:push_costume("cc_seduction.cos")
    charlie:fade_in_chore(cc_seduction_sed_by_mec, "cc_seduction.cos", 500)
    sleep_for(6000)
    ly.meche_obj:make_touchable()
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    ly.ready_to_seduce = FALSE
    meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
end
ly.set_up_actors = function(arg1) -- line 1665
    ly.keno_actor:default()
    ly.slot_handle:init()
    charlies_slot:default()
    mannys_slot:default()
    mannys_slot:freeze()
    brennis:put_in_set(ly)
    brennis:default()
    brennis:push_costume("br_idles.cos")
    brennis:setpos(-0.0427321, 4.02445, 0.9)
    brennis:setrot(0, -2343.65, 0)
    ly:brennis_start_idle()
    if not ly.charlie_gone then
        charlie:set_costume(nil)
        charlie:set_costume("ccharlie.cos")
        charlie:set_mumble_chore(ccharlie_mumble)
        charlie:set_talk_chore(1, ccharlie_no_talk)
        charlie:set_talk_chore(2, ccharlie_a)
        charlie:set_talk_chore(3, ccharlie_c)
        charlie:set_talk_chore(4, ccharlie_e)
        charlie:set_talk_chore(5, ccharlie_f)
        charlie:set_talk_chore(6, ccharlie_l)
        charlie:set_talk_chore(7, ccharlie_m)
        charlie:set_talk_chore(8, ccharlie_o)
        charlie:set_talk_chore(9, ccharlie_t)
        charlie:set_talk_chore(10, ccharlie_u)
        charlie:push_costume("cc_play_slot.cos")
        charlie:put_in_set(ly)
        charlie:ignore_boxes()
        charlie:setpos(1.83869, -0.508564, 0.014)
        charlie:setrot(0, 260, 0)
        start_script(ly.charlie_idles, ly)
        meche:set_costume(nil)
        meche:set_costume("meche_ruba.cos")
        meche:set_mumble_chore(meche_ruba_mumble)
        meche:set_talk_chore(1, meche_ruba_stop_talk)
        meche:set_talk_chore(2, meche_ruba_a)
        meche:set_talk_chore(3, meche_ruba_c)
        meche:set_talk_chore(4, meche_ruba_e)
        meche:set_talk_chore(5, meche_ruba_f)
        meche:set_talk_chore(6, meche_ruba_l)
        meche:set_talk_chore(7, meche_ruba_m)
        meche:set_talk_chore(8, meche_ruba_o)
        meche:set_talk_chore(9, meche_ruba_t)
        meche:set_talk_chore(10, meche_ruba_u)
        meche:put_in_set(ly)
        meche:ignore_boxes()
        meche:setpos(1.4388, -0.679984, 0)
        meche:setrot(0, 313.314, 0)
        meche:push_costume("meche_seduction.cos")
        meche:push_costume("mi_msb_sheet.cos")
        meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
        meche.holding_sheet = TRUE
        start_script(ly.meche_idles, ly)
        unicycle_man:default()
        unicycle_man:put_in_set(ly)
        unicycle_man:restore_pos()
        start_script(ly.unicycle_idles, ly)
    else
        charlie:free()
        meche:free()
        unicycle_man:free()
    end
end
ly.set_up_object_states = function(arg1) -- line 1737
    ly:add_object_state(ly_kenla, "ly_keno_1.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_2.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_3.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_32.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_32.bm", nil, OBJSTATE_UNDERLAY)
end
ly.cameraman = function(arg1) -- line 1804
    local local1, local2
    local local3
    cameraman_watching_set = arg1
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead and cutSceneLevel <= 0 then
        local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
        if cameraman_box_name then
            local3 = getglobal(cameraman_box_name)
            if local3 ~= nil and ly:current_setup() ~= local3 then
                ly:current_setup(local3)
            end
        elseif ly:current_setup() ~= "ly_intha" then
            ly:current_setup(ly_intha)
        end
    end
end
ly.manny_collisions = function(arg1) -- line 1826
    while system.currentSet == ly do
        if manny:find_sector_name("slot_box") or manny:find_sector_name("mannys_slot") or manny:find_sector_name("charlie_box") or manny:find_sector_name("meche_box") then
            manny:set_collision_mode(COLLISION_SPHERE, 0.35)
        else
            manny:set_collision_mode(COLLISION_OFF)
        end
        break_here()
    end
end
ly.update_music_state = function(arg1) -- line 1843
    if ly.charlie_gone then
        return stateLY_BREN
    else
        return stateLY
    end
end
ly.enter = function(arg1) -- line 1852
    ly:set_up_object_states()
    ly:set_up_actors()
    start_script(ly.gun_control)
    start_script(ly.keno_actor.game, ly.keno_actor)
    start_script(ly.manny_collisions, ly)
    ly:add_ambient_sfx({ "lyAmb1.wav", "lyAmb2.wav", "lyAmb3.wav", "lyAmb4.wav" }, { min_volume = 40, max_volume = 127, min_delay = 6000, max_delay = 10000 })
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -4, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
ly.exit = function(arg1) -- line 1872
    stop_script(ly.manny_collisions)
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(slot_wheel.spin)
    stop_script(ly.unicycle_idles)
    stop_script(ly.unicycle_slot_sfx)
    stop_script(ly.keno_actor.game)
    ly.keno_actor:free()
    charlies_slot:free()
    mannys_slot:free()
    stop_script(ly.charlie_idles)
    charlie:free()
    meche:free()
    if brennis.ly_idle_script then
        stop_script(brennis.ly_idle_script)
        brennis.ly_idle_script = nil
    end
    brennis:free()
    unicycle_man:save_pos()
    unicycle_man:free()
    stop_script(ly.gun_control)
    stop_script(ly.charlie_struggle)
    stop_script(ly.charlie_get_up_timer)
    ly.sheet_on_floor.interest_actor:set_costume(nil)
    ly.sheet_on_floor.has_object_states = FALSE
    ly.mens_room.interest_actor:set_costume(nil)
    ly.mens_room.has_object_states = FALSE
    ly.service_door.interest_actor:set_costume(nil)
    ly.service_door.has_object_states = FALSE
    stop_sound("um_roll.IMU")
    stop_sound("ly_pyoff.IMU")
    stop_sound("ly_wheel.IMU")
    KillActorShadows(manny.hActor)
end
ly.sheet = Object:create(ly, "/lytx091/sheet", 0, 0, 0, { range = 0 })
ly.sheet.use = function(arg1) -- line 1928
    manny:say_line("/lyma092/")
end
ly.sheet.lookAt = function(arg1) -- line 1932
    manny:say_line("/lyma093/")
end
ly.sheet.default_response = ly.sheet.use
ly.brennis_obj = Object:create(ly, "/lytx094/elevator demon", -0.048044398, 3.9284, 1.51, { range = 0.80000001 })
ly.brennis_obj.use_pnt_x = -0.12957799
ly.brennis_obj.use_pnt_y = 3.47597
ly.brennis_obj.use_pnt_z = 0.89999998
ly.brennis_obj.use_rot_x = 0
ly.brennis_obj.use_rot_y = 349.754
ly.brennis_obj.use_rot_z = 0
ly.brennis_obj.person = TRUE
ly.brennis_obj.demon = TRUE
ly.brennis_obj.lookAt = function(arg1) -- line 1951
    manny:say_line("/lyma095/")
end
ly.brennis_obj.pickUp = function(arg1) -- line 1955
    system.default_response("right")
end
ly.brennis_obj.use = function(arg1) -- line 1959
    if not manny.fancy then
        if manny:walkto_object(arg1) then
            start_script(ly.talk_clothes_with_brennis)
        end
    elseif fi.gun.owner ~= manny then
        manny:turn_left(180)
        manny:say_line("/lyma096/")
    else
        Dialog:run("br2", "dlg_brennis2.lua")
    end
end
ly.brennis_obj.use_sheet = function(arg1) -- line 1974
    START_CUT_SCENE()
    manny:say_line("/lyma097/")
    wait_for_message()
    brennis:say_line("/lybs098/")
    END_CUT_SCENE()
end
ly.statue = Object:create(ly, "/lytx099/statue", 3.34677, -2.6134701, 2.5899999, { range = 1.6 })
ly.statue.use_pnt_x = 3.34677
ly.statue.use_pnt_y = -1.78347
ly.statue.use_pnt_z = 0.44999999
ly.statue.use_rot_x = 0
ly.statue.use_rot_y = 922.95398
ly.statue.use_rot_z = 0
ly.statue.lookAt = function(arg1) -- line 1992
    manny:say_line("/lyma100/")
end
ly.statue.pickUp = function(arg1) -- line 1996
    system.default_response("right")
end
ly.statue.use = function(arg1) -- line 2000
    manny:say_line("/lyma101/")
end
ly.statue.use_sheet = function(arg1) -- line 2004
    manny:say_line("/lyma102/")
end
ly.charlie_obj = Object:create(ly, "/lytx103/Chowchilla Charlie", 1.82118, -0.51648003, 0.37200001, { range = 0.60000002 })
ly.charlie_obj.use_pnt_x = 1.61446
ly.charlie_obj.use_pnt_y = -0.26686499
ly.charlie_obj.use_pnt_z = 0
ly.charlie_obj.use_rot_x = 0
ly.charlie_obj.use_rot_y = 220.021
ly.charlie_obj.use_rot_z = 0
ly.charlie_obj.person = TRUE
ly.charlie_obj.lookAt = function(arg1) -- line 2019
    if not arg1.seen then
        START_CUT_SCENE()
        arg1.seen = TRUE
        manny:say_line("/lyma104/")
        manny:wait_for_message()
        manny:say_line("/lyma105/")
        END_CUT_SCENE()
    else
        manny:say_line("/lyma106/")
    end
end
ly.charlie_obj.pickUp = function(arg1) -- line 2032
    manny:say_line("/lyma107/")
end
ly.charlie_obj.use = function(arg1) -- line 2036
    start_script(ly.talk_toga_with_charlie)
end
ly.charlie_obj.use_sheet = function(arg1) -- line 2040
    start_script(ly.throw_sheet)
end
ly.meche_obj = Object:create(ly, "/lytx108/Meche", 1.52403, -0.63770503, 0.47499999, { range = 0.80000001 })
ly.meche_obj.use_pnt_x = 1.65277
ly.meche_obj.use_pnt_y = -0.32719201
ly.meche_obj.use_pnt_z = 0
ly.meche_obj.use_rot_x = 0
ly.meche_obj.use_rot_y = 153.737
ly.meche_obj.use_rot_z = 0
ly.meche_obj.person = TRUE
ly.meche_obj.lookAt = function(arg1) -- line 2055
    manny:say_line("/lyma109/")
end
ly.meche_obj.pickUp = function(arg1) -- line 2059
    system.default_response("not now")
end
ly.meche_obj.use = function(arg1) -- line 2063
    start_script(ly.talk_clothes_with_meche)
end
ly.meche_obj.use_sheet = function(arg1) -- line 2067
    if ly.meche_talk_count < 4 then
        arg1:use()
    else
        manny:say_line("/lyma110/")
        manny:wait_for_message()
        meche:say_line("/lymc111/")
    end
end
ly.slot1 = Object:create(ly, "/lytx112/slot machine", 1.98998, -0.113677, 0.47, { range = 0.60000002 })
ly.slot1.use_pnt_x = 1.63983
ly.slot1.use_pnt_y = -0.272295
ly.slot1.use_pnt_z = 0
ly.slot1.use_rot_x = 0
ly.slot1.use_rot_y = 280.24301
ly.slot1.use_rot_z = 0
ly.slot1.lookAt = function(arg1) -- line 2087
    manny:say_line("/lyma113/")
end
ly.slot1.pickUp = function(arg1) -- line 2091
    system.default_response("portable")
end
ly.slot1.use = function(arg1) -- line 2095
    if manny:find_sector_name("mannys_slot") then
        start_script(ly.playslots, ly, arg1)
    elseif manny:walkto_object(arg1) then
        start_script(ly.playslots, ly, arg1)
    end
end
ly.slot1.use_sheet = function(arg1) -- line 2103
    manny:say_line("/lyma114/")
end
ly.sheet_on_floor = Object:create(ly, "/lytx115/sheet", 1.7376, -0.488377, 0, { range = 0.60000002 })
ly.sheet_on_floor.use_pnt_x = 1.5376
ly.sheet_on_floor.use_pnt_y = -0.62837702
ly.sheet_on_floor.use_pnt_z = 0
ly.sheet_on_floor.use_rot_x = 0
ly.sheet_on_floor.use_rot_y = -33.944099
ly.sheet_on_floor.use_rot_z = 0
ly.sheet_on_floor:make_untouchable()
ly.sheet_on_floor.lookAt = function(arg1) -- line 2118
    manny:say_line("/lyma116/")
end
ly.sheet_on_floor.pickUp = function(arg1) -- line 2122
    arg1:make_untouchable()
    ly.sheet:hold()
end
ly.sheet_on_floor.use = ly.sheet_on_floor.pickUp
ly.unicycle_man = Object:create(ly, "/lytx117/gambler", 1.05716, 0.50252402, 0.40000001, { range = 0.80000001 })
ly.unicycle_man.use_pnt_x = 1.2671601
ly.unicycle_man.use_pnt_y = 0.25252399
ly.unicycle_man.use_pnt_z = 0
ly.unicycle_man.use_rot_x = 0
ly.unicycle_man.use_rot_y = 1495.33
ly.unicycle_man.use_rot_z = 0
ly.unicycle_man.person = TRUE
ly.unicycle_man.lookAt = function(arg1) -- line 2140
    if not ly.met_agent then
        manny:say_line("/lyma118/")
    else
        manny:say_line("/lyma119/")
    end
end
ly.unicycle_man.pickUp = function(arg1) -- line 2148
    system.default_response("think")
end
ly.unicycle_man.use = function(arg1) -- line 2152
    start_script(ly.talk_to_agent)
end
ly.mens_room = Object:create(ly, "/lytx120/door", 2.03262, 4.2983999, 1.39, { range = 0.5 })
ly.mens_room.use_pnt_x = 1.9454401
ly.mens_room.use_pnt_y = 3.98
ly.mens_room.use_pnt_z = 0.89999998
ly.mens_room.use_rot_x = 0
ly.mens_room.use_rot_y = 14.326
ly.mens_room.use_rot_z = 0
ly.mens_room.out_pnt_x = 1.76959
ly.mens_room.out_pnt_y = 4.6870298
ly.mens_room.out_pnt_z = 0.89999998
ly.mens_room.out_rot_x = 0
ly.mens_room.out_rot_y = 4.1866498
ly.mens_room.out_rot_z = 0
ly.mens_room.passage = { "bath_psg" }
ly.mens_room.lookAt = function(arg1) -- line 2175
    manny:say_line("/lyma121/")
end
ly.mens_room.walkOut = function(arg1) -- line 2179
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
        manny:wait_for_message()
        ly.sheet:use()
    elseif not manny.fancy then
        if not ly.mens_room.has_object_states then
            ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
            ly.mens_room:set_object_state("ly_bath_door.cos")
        end
        if not ly.charlie_gone then
            if not ly.peed then
                ly.peed = TRUE
                arg1:open_door_and_enter()
                manny:say_line("/lyma122/")
                manny:wait_for_message()
                manny:say_line("/lyma123/")
            else
                manny:say_line("/lyma124/")
            end
        else
            manny.fancy = TRUE
            arg1:open_door_and_enter()
            manny:shrug_gesture()
            manny:say_line("/lyma125/")
        end
    else
        manny:say_line("/lyma126/")
    end
    END_CUT_SCENE()
end
ly.mens_room.open_door_and_enter = function(arg1) -- line 2216
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y, arg1.use_rot_z)
    manny:play_chore(msb_hand_on_obj, manny.base_costume)
    sleep_for(200)
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:open()
    manny:wait_for_chore(msb_hand_on_obj, manny.base_costume)
    manny:stop_chore(msb_hand_on_obj, manny.base_costume)
    manny:play_chore(msb_hand_off_obj, manny.base_costume)
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
    manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    if manny.fancy then
        sleep_for(3000)
        manny:default("thunder")
    else
        sleep_for(4000)
        start_sfx("ly_urinl.WAV")
    end
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:wait_for_chore(0)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    arg1:close()
end
ly.service_door = Object:create(ly, "/lytx120/door", 2.5296299, 4.0496202, 1.339, { range = 0.5 })
ly.service_door.use_pnt_x = 2.5390899
ly.service_door.use_pnt_y = 3.6882501
ly.service_door.use_pnt_z = 0.89999998
ly.service_door.use_rot_x = 0
ly.service_door.use_rot_y = 358.625
ly.service_door.use_rot_z = 0
ly.service_door.out_pnt_x = 2.53511
ly.service_door.out_pnt_y = 4.48
ly.service_door.out_pnt_z = 0.89999998
ly.service_door.out_rot_x = 0
ly.service_door.out_rot_y = 359.58701
ly.service_door.out_rot_z = 0
ly.service_door.touchable = FALSE
ly.service_door.passage = { "service_psg" }
ly.service_door.walkOut = function(arg1) -- line 2271
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y + 180, arg1.use_rot_z)
        manny:wait_for_message()
        ly.sheet:use()
    else
        if not ly.service_door.has_object_states then
            ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
            ly.service_door:set_object_state("ly_service_door.cos")
        end
        manny:walkto(2.56884, 3.85944, 0.9, 0, 16.9137, 0)
        manny:wait_for_actor()
        manny:play_chore(msb_reach_med, manny.base_costume)
        sleep_for(250)
        start_script(manny.backup, manny, 350)
        sleep_for(250)
        arg1:play_chore(0)
        arg1:wait_for_chore(0)
        arg1:open()
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        sleep_for(1000)
        arg1:play_chore(1)
        arg1:close()
    end
    END_CUT_SCENE()
    if manny.is_holding ~= ly.sheet then
        te:come_out_door(te.ly_door)
    end
end
ly.service_door.comeOut = function(arg1) -- line 2304
    START_CUT_SCENE()
    ly:switch_to_set()
    ly:current_setup(ly_lavha)
    if not ly.service_door.has_object_states then
        ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
        ly.service_door:set_object_state("ly_service_door.cos")
    end
    arg1:open()
    manny:put_in_set(ly)
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    if not manny.fancy then
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:play_chore(mcc_thunder_hand_off_obj, "mcc_thunder.cos")
    end
    arg1:play_chore(0)
    arg1:wait_for_chore(0)
    if not manny.fancy then
        manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
        manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:wait_for_chore(mcc_thunder_hand_off_obj, manny.base_costume)
        manny:stop_chore(mcc_thunder_hand_off_obj, manny.base_costume)
    end
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    manny:wait_for_actor()
    arg1:run_chore(1)
    arg1:close()
    END_CUT_SCENE()
end
ly.sh_door = Object:create(ly, "/lytx002/door", -0.098697402, -3.63239, 0.83999997, { range = 0.60000002 })
ly.sh_door.use_pnt_x = -0.098411702
ly.sh_door.use_pnt_y = -3.13359
ly.sh_door.use_pnt_z = 0.44999999
ly.sh_door.use_rot_x = 0
ly.sh_door.use_rot_y = 179.772
ly.sh_door.use_rot_z = 0
ly.sh_door.out_pnt_x = -0.097895198
ly.sh_door.out_pnt_y = -3.425
ly.sh_door.out_pnt_z = 0.44999999
ly.sh_door.out_rot_x = 0
ly.sh_door.out_rot_y = 179.772
ly.sh_door.out_rot_z = 0
ly.sh_door.touchable = FALSE
ly.sh_box = ly.sh_door
ly.sh_door.walkOut = function(arg1) -- line 2364
    START_CUT_SCENE()
    ResetMarioControls()
    manny:say_line("/doma165/")
    manny:walkto(-0.100971, -3.23397, 0.45, 0, 6.21033, 0)
    END_CUT_SCENE()
end
CheckFirstTime("_actors.lua")
system.actorCount = 0
system.actorTable = { }
system.actorTemplate = { name = "<unnamed>", hActor = nil }
Actor = system.actorTemplate
Actor.is_holding = nil
Actor.is_talking = nil
Actor.walk_chore = nil
Actor.default_look_rate = 200
Actor.last_chore = nil
Actor.last_play_chore = nil
CHORE_LOOP = TRUE
CHORE_NOLOOP = FALSE
MODE_BACKGROUND = TRUE
MODE_NORMAL = FALSE
Actor.hold_chore = nil
Actor.MARKER_LEFT_WALK = 10
Actor.MARKER_RIGHT_WALK = 15
Actor.MARKER_LEFT_RUN = 20
Actor.MARKER_RIGHT_RUN = 25
Actor.MARKER_LEFT_TURN = 30
Actor.MARKER_RIGHT_TURN = 35
Actor.idles_allowed = TRUE
Actor.last_chore_played = nil
Actor.last_cos_played = nil
Actor.base_costume = nil
Actor.create = function(arg1, arg2, arg3, arg4, arg5) -- line 73
    local local1 = { }
    local1.parent = arg1
    if arg5 then
        local1.name = arg5
    else
        local1.name = arg2
    end
    local1.hActor = LoadActor(arg5)
    local1.footsteps = nil
    local1.saylineTable = { }
    system.actorTable[local1.name] = local1
    system.actorCount = system.actorCount + 1
    system.actorTable[local1.hActor] = local1
    arg1.create_dialogStack(local1)
    return local1
end
Actor.getpos = function(arg1) -- line 103
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorPos(arg1.hActor)
    return local1
end
Actor.getrot = function(arg1) -- line 115
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorRot(arg1.hActor)
    return local1
end
Actor.get_positive_rot = function(arg1) -- line 126
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorRot(arg1.hActor)
    while local1.y < 0 do
        local1.y = local1.y + 360
    end
    while local1.y > 360 do
        local1.y = local1.y - 360
    end
    while local1.x < 0 do
        local1.x = local1.x + 360
    end
    while local1.x > 360 do
        local1.x = local1.z - 360
    end
    while local1.z < 0 do
        local1.z = local1.z + 360
    end
    while local1.z > 360 do
        local1.z = local1.z - 360
    end
    return local1
end
Actor.get_positive_yaw_to_point = function(arg1, arg2) -- line 160
    local local1 = GetActorYawToPoint(arg1.hActor, { x = arg2.x, y = arg2.y, z = arg2.z })
    while local1 < 0 do
        local1 = local1 + 360
    end
    while local1 > 360 do
        local1 = local1 - 360
    end
    return local1
end
Actor.setpos = function(arg1, arg2, arg3, arg4) -- line 179
    if type(arg2) == "table" then
        arg1:moveto(arg2.x, arg2.y, arg2.z)
    else
        arg1:moveto(arg2, arg3, arg4)
    end
end
Actor.set_softimage_pos = function(arg1, arg2, arg3, arg4) -- line 191
    if type(arg2) == "table" then
        arg1:moveto(arg2.x / 10, -arg2.z / 10, arg2.y / 10)
    else
        arg1:moveto(arg2 / 10, -arg4 / 10, arg3 / 10)
    end
end
Actor.get_softimage_pos = function(arg1) -- line 204
    local local1 = arg1:getpos()
    local1.y, local1.z = local1.z, -local1.y
    local1.x, local1.y, local1.z = local1.x * 10, local1.y * 10, local1.z * 10
    return local1
end
convert_softimage_pos = function(arg1, arg2, arg3) -- line 218
    local local1 = arg1 / 10
    local local2 = 0 - arg3 / 10
    local local3 = arg2 / 10
    return local1, local2, local3
end
Actor.turn_toward_entity = function(arg1, arg2, arg3, arg4) -- line 232
    if arg3 then
        while TurnActorTo(arg1.hActor, arg2, arg3, arg4) do
            break_here()
        end
    elseif arg2.use_pnt_x ~= nil then
        while TurnActorTo(arg1.hActor, arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z) do
            break_here()
        end
    else
        arg2, arg3, arg4 = arg2:getpos()
        while TurnActorTo(arg1.hActor, arg2, arg3, arg4) do
            break_here()
        end
    end
end
Actor.face_entity = function(arg1, arg2, arg3, arg4) -- line 260
    local local1
    local local2
    if type(arg2) == "table" then
        if arg2.interest_actor then
            local1 = arg2.interest_actor:getpos()
        elseif arg2.getpos then
            local1 = arg2:getpos()
        elseif arg2.x then
            local1 = arg2
        else
            PrintDebug("Actor:face_entity() -- invalid argument\n")
        end
    else
        local1 = { }
        local1.x = arg2
        local1.y = arg3
        local1.z = arg4
    end
    if local1 then
        local2 = GetActorYawToPoint(arg1.hActor, local1)
        arg1:setrot(0, local2, 0, TRUE)
    end
end
Actor.set_colormap = function(arg1, arg2) -- line 292
    SetActorColormap(arg1.hActor, arg2)
end
Actor.setrot = function(arg1, arg2, arg3, arg4, arg5) -- line 302
    if type(arg2) == "table" then
        SetActorRot(arg1.hActor, arg2.x, arg2.y, arg2.z, arg3)
    else
        SetActorRot(arg1.hActor, arg2, arg3, arg4, arg5)
    end
end
Actor.walkto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 319
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg1 == system.currentActor then
        ResetMarioControls()
    end
    if type(arg2) == "table" then
        return arg1:walkto_object(arg2, arg3)
    else
        SetActorConstrain(arg1.hActor, FALSE)
        if arg1 == system.currentActor then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
        end
        WalkActorTo(arg1.hActor, arg2, arg3, arg4)
        if arg5 then
            while arg1:is_moving() do
                break_here()
            end
            arg1:setrot(arg5, arg6, arg7, TRUE)
        end
    end
end
Actor.runto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 349
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg1 == system.currentActor then
        ResetMarioControls()
    end
    arg1:set_run(TRUE)
    if type(arg2) == "table" then
        arg1:walkto_object(arg2, arg3)
    else
        SetActorConstrain(arg1.hActor, FALSE)
        if arg1 == system.currentActor then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
        end
        WalkActorTo(arg1.hActor, arg2, arg3, arg4)
        if arg5 then
            while arg1:is_moving() do
                break_here()
            end
            arg1:setrot(arg5, arg6, arg7, TRUE)
        end
    end
    arg1:wait_for_actor()
    arg1:set_run(FALSE)
end
Actor.walk_and_face = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 386
    arg1:walkto(arg2, arg3, arg4)
    while arg1:is_moving() do
        break_here()
    end
    arg1:setrot(arg5, arg6, arg7, TRUE)
    arg1:wait_for_actor()
end
Actor.walk_forward = function(arg1) -- line 400
    WalkActorForward(arg1.hActor)
end
Actor.moveto = function(arg1, arg2, arg3, arg4) -- line 409
    if type(arg2) == "table" then
        PutActorAt(arg1.hActor, arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z)
    else
        PutActorAt(arg1.hActor, arg2, arg3, arg4)
    end
end
Actor.scale = function(arg1, arg2) -- line 421
    SetActorScale(arg1.hActor, arg2)
end
Actor.driveto = function(arg1, arg2, arg3, arg4) -- line 429
    DriveActorTo(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_run = function(arg1, arg2) -- line 433
end
Actor.force_auto_run = function(arg1, arg2) -- line 437
end
Actor.walkto_object = function(arg1, arg2, arg3) -- line 445
    local local1, local2, local3, local4, local5, local6, local7
    local local8, local9
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg2.parent == Ladder then
        if arg3 then
            local9 = arg2.base.out_pnt_z
            local8 = arg2.top.out_pnt_z
        else
            local9 = arg2.base.use_pnt_z
            local8 = arg2.top.use_pnt_z
        end
        local1 = arg1:getpos()
        if abs(local9 - local1.z) < abs(local8 - local1.z) then
            arg2 = arg2.base
        else
            arg2 = arg2.top
        end
    end
    if arg3 then
        local2 = arg2.out_pnt_x
        local3 = arg2.out_pnt_y
        local4 = arg2.out_pnt_z
        local5 = arg2.out_rot_x
        local6 = arg2.out_rot_y
        local7 = arg2.out_rot_z
    else
        local2 = arg2.use_pnt_x
        local3 = arg2.use_pnt_y
        local4 = arg2.use_pnt_z
        local5 = arg2.use_rot_x
        local6 = arg2.use_rot_y
        local7 = arg2.use_rot_z
    end
    if local2 then
        PrintDebug("Walking " .. arg1.name .. " to " .. arg2.name .. "\t" .. local2 .. "\t" .. local3 .. "\t" .. local4 .. "\n")
        PrintDebug("IndexFB_disabled: " .. tostring(indexFB_disabled) .. "\n")
        if arg1 == system.currentActor then
            stop_movement_scripts()
        end
        SetActorConstrain(arg1.hActor, FALSE)
        arg1:walkto(local2, local3, local4, local5, local6, local7)
        while arg1:is_moving() or arg1:is_turning() do
            break_here()
        end
        if arg1 == system.currentActor and MarioControl then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
            single_start_script(WalkManny)
        end
        local1 = object_proximity(arg2, arg3)
        if local1 <= MAX_PROX then
            PrintDebug("made it to the use/out point of " .. arg2.name .. "!\n")
            return TRUE
        else
            PrintDebug("Didn't make it to the use/out point of " .. arg2.name .. "!\n")
            return FALSE
        end
    else
        PrintDebug("Object has no use/out point!\n")
    end
end
Actor.walk_closeto_object = function(arg1, arg2, arg3) -- line 527
    local local1, local2, local3, local4, local5, local6, local7
    local local8 = 0
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    local2 = arg2.use_pnt_x
    local3 = arg2.use_pnt_y
    local4 = arg2.use_pnt_z
    local5 = arg2.use_rot_x
    local6 = arg2.use_rot_y
    local7 = arg2.use_rot_z
    if local2 then
        PrintDebug("Walking " .. arg1.name .. " to " .. arg2.name .. "\t" .. local2 .. "\t" .. local3 .. "\t" .. local4 .. " within " .. arg3 .. "\n")
        if arg1 == system.currentActor then
            stop_movement_scripts()
        end
        SetActorConstrain(arg1.hActor, FALSE)
        arg1:walkto(local2, local3, local4, local5, local6, local7)
        while arg1:is_moving() or arg1:is_turning() and local8 < 20000 do
            break_here()
            local8 = local8 + system.frameTime
        end
        if arg1 == system.currentActor and MarioControl then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
            single_start_script(WalkManny)
        end
        local1 = proximity(manny.hActor, local2, local3, local4)
        if local1 <= arg3 then
            PrintDebug("made it close to the use point of " .. arg2.name .. "!\n")
            return TRUE
        else
            PrintDebug("Didn't make it to the use point of " .. arg2.name .. ", proximity = " .. local1 .. "!\n")
            return FALSE
        end
    else
        PrintDebug("Object has no use/out point!\n")
    end
end
COLLISION_OFF = 0
COLLISION_BOX = 1
COLLISION_SPHERE = 2
Actor.set_collision_mode = function(arg1, arg2, arg3) -- line 585
    SetActorCollisionMode(arg1.hActor, arg2)
    if arg3 ~= nil and arg2 ~= COLLISION_OFF then
        SetActorCollisionScale(arg1.hActor, arg3)
    end
end
Actor.set_time_scale = function(arg1, arg2) -- line 592
    SetActorTimeScale(arg1.hActor, arg2)
end
Actor.offsetBy = function(arg1, arg2, arg3, arg4) -- line 601
    local local1
    local1 = arg1:getpos()
    if arg2 then
        local1.x = local1.x + arg2
    end
    if arg3 then
        local1.y = local1.y + arg3
    end
    if arg4 then
        local1.z = local1.z + arg4
    end
    arg1:setpos(local1.x, local1.y, local1.z)
end
Actor.turn_right = function(arg1, arg2) -- line 617
    local local1 = arg1:getrot()
    arg1:setrot(local1.x, local1.y - arg2, local1.z, TRUE)
end
Actor.turn_left = function(arg1, arg2) -- line 622
    local local1 = arg1:getrot()
    arg1:setrot(local1.x, local1.y + arg2, local1.z, TRUE)
end
Actor.teleport_out_of_hot_box = function(arg1) -- line 636
    local local1, local2, local3
    local local4 = { }
    local local5, local6
    local1, local2, local3 = arg1:find_sector_type(HOT)
    if local1 then
        if arg1.is_backward then
            local6 = arg1:getrot()
            arg1:setrot(local6.x, local6.y + 180, local6.z)
        end
        local4.x, local4.y, local4.z = GetSectorOppositeEdge(arg1.hActor, local2)
        if local4.x then
            arg1:setpos(local4.x, local4.y, local4.z)
            system.currentSet:force_camerachange()
        end
        if arg1.is_backward then
            arg1:setrot(local6.x, local6.y, local6.z)
        end
    end
end
Actor.play_chore = function(arg1, arg2, arg3) -- line 662
    if arg1:get_costume() and arg2 ~= nil then
        arg1.last_chore_played = arg2
        arg1.last_cos_played = arg3
        PlayActorChore(arg1.hActor, arg2, arg3)
    elseif arg2 == nil then
        PrintDebug("(" .. tostring(arg1.name) .. ")  Actor:play_chore() trying to play nil chore.\n")
    end
end
Actor.fade_in_chore = function(arg1, arg2, arg3, arg4) -- line 678
    FadeInChore(arg1.hActor, arg3, arg2, arg4)
end
Actor.fade_out_chore = function(arg1, arg2, arg3, arg4) -- line 686
    FadeOutChore(arg1.hActor, arg3, arg2, arg4)
end
Actor.blend = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 695
    if not arg5 then
        arg5 = arg1:get_costume()
    end
    if not arg6 then
        arg6 = arg5
    end
    start_script(arg1.fade_in_chore, arg1, arg2, arg5, arg4)
    if arg3 ~= nil then
        start_script(arg1.fade_out_chore, arg1, arg3, arg6, arg4)
    end
    sleep_for(arg4)
end
Actor.loop_chore_for = function(arg1, arg2, arg3, arg4, arg5) -- line 715
    arg1:play_chore_looping(arg2, arg3)
    sleep_for(rndint(arg4, arg5))
    arg1:set_chore_looping(arg2, FALSE, arg3)
    arg1:wait_for_chore(arg2, arg3)
    arg1:stop_chore(arg2, arg3)
end
Actor.run_chore = function(arg1, arg2, arg3) -- line 727
    arg1:play_chore(arg2, arg3)
    arg1:wait_for_chore(arg2, arg3)
end
Actor.play_chore_looping = function(arg1, arg2, arg3) -- line 736
    if arg1:get_costume() and arg2 ~= nil then
        PlayActorChoreLooping(arg1.hActor, arg2, arg3)
    elseif arg2 == nil then
        PrintDebug("Actor:play_chore_looping() trying to play nil chore.\n")
    end
end
Actor.stop_chore = function(arg1, arg2, arg3) -- line 749
    if arg1:get_costume() then
        StopActorChore(arg1.hActor, arg2, arg3)
    end
end
Actor.stop_looping_chore = function(arg1, arg2, arg3, arg4) -- line 760
    if arg1:is_choring(arg2, FALSE, arg3) then
        arg1:set_chore_looping(arg2, FALSE, arg3)
        arg1:wait_for_chore(arg2, arg3)
        if arg4 then
            arg1:stop_chore(arg2, arg3)
        end
    end
end
Actor.complete_chore = function(arg1, arg2, arg3) -- line 774
    if arg1:get_costume() and arg2 ~= nil then
        CompleteActorChore(arg1.hActor, arg2, arg3)
    end
end
Actor.set_chore_looping = function(arg1, arg2, arg3, arg4) -- line 785
    if arg1:get_costume() then
        SetActorChoreLooping(arg1.hActor, arg2, arg3, arg4)
    end
end
Actor.stamp = function(arg1, arg2, arg3) -- line 799
    if not Is3DHardwareEnabled() then
        if arg2 then
            arg1:complete_chore(arg2, arg3)
            while arg1:is_choring(arg2, FALSE, arg3) do
                break_here()
            end
        end
        ActorToClean(arg1.hActor)
        if arg2 then
            arg1:stop_chore(arg2, arg3)
        end
    end
end
Actor.unstamp = function(arg1) -- line 818
    ForceRefresh()
end
Actor.stamp_test = function(arg1, arg2) -- line 822
    while 1 do
        if arg2 then
            sleep_for(arg2)
        else
            sleep_for(1000)
        end
        ActorToClean(arg1.hActor)
    end
end
Actor.freeze = function(arg1, arg2, arg3, arg4) -- line 843
    local local1 = { }
    if Is3DHardwareEnabled() then
        arg1:complete_chore(arg3, arg4)
        return
    end
    if GetActorCostume(arg1.hActor) then
        if system.currentSet == nil then
            PrintDebug("Actor:freeze() -- no current set!\n")
            return
        end
        if system.currentSet.frozen_actors == nil then
            system.currentSet.frozen_actors = { }
        end
        local1.actor = arg1
        local1.pos = arg1:getpos()
        local1.rot = arg1:getrot()
        local1.preFreezeChore = arg2
        local1.postFreezeChore = arg3
        local1.freezeCostume = arg4
        system.currentSet.frozen_actors[arg1.hActor] = local1
        arg1:stamp(arg2, arg4)
        if arg3 then
            arg1:complete_chore(arg3, arg4)
        else
            arg1:put_in_set(nil)
        end
        arg1.frozen = system.currentSet
    end
end
Actor.refreeze = function(arg1) -- line 883
    local local1
    if arg1.frozen and arg1.frozen == system.currentSet then
        local1 = arg1.frozen.frozen_actors[arg1.hActor]
        if Is3DHardwareEnabled() then
            if local1.postFreezeChore then
                arg1:complete_chore(local1.postFreezeChore, local1.freezeCostume)
            end
        else
            arg1:put_in_set(arg1.frozen)
            arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
            arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
            arg1:stamp(local1.preFreezeChore, local1.freezeCostume)
            if local1.postFreezeChore then
                arg1:complete_chore(local1.postFreezeChore, local1.freezeCostume)
            else
                arg1:put_in_set(nil)
            end
        end
    end
end
Actor.thaw = function(arg1, arg2, arg3) -- line 916
    local local1
    if Is3DHardwareEnabled() and not arg3 then
        return
    end
    if GetActorCostume(arg1.hActor) then
        if not arg1.frozen then
            PrintDebug("Actor:thaw() -- Actor " .. arg1.name .. " isn't frozen!\n")
            return
        end
        arg1:put_in_set(arg1.frozen)
        local1 = arg1.frozen.frozen_actors[arg1.hActor]
        if local1 then
            arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
            arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
        end
        arg1.frozen.frozen_actors[arg1.hActor] = nil
        arg1.frozen = nil
        if arg2 then
            arg1:unstamp()
            system.currentSet:redraw_frozen_actors()
        end
    end
end
Actor.run_idle = function(arg1, arg2, arg3) -- line 950
    local local1 = arg3
    local local2
    local local3 = system.currentSet
    while system.currentSet == local3 and local1 do
        PlayActorChore(arg1.hActor, local1)
        arg1.last_chore = chore
        wait_for_actor(arg1.hActor)
        local2 = pick_from_weighted_table(arg2[local1])
        if local2 then
            local1 = local2
        end
    end
end
Actor.new_run_idle = function(arg1, arg2, arg3, arg4, arg5) -- line 985
    local local1
    local local2
    local local3 = system.currentSet
    local local4
    arg1.stop_idle = FALSE
    arg1.last_play_chore = nil
    if arg3 then
        local4 = arg3
    else
        local4 = arg1.idle_table
    end
    local1 = local4.root_name .. "_" .. arg2
    if arg5 then
        arg1:print_costumes()
        PrintDebug("***\n")
        PrintDebug("Starting new_run_idle() with\n")
        PrintDebug("\ttable.root_name = " .. local4.root_name .. "\n")
        PrintDebug("\tstarting_chore = " .. arg2 .. "\n")
        PrintDebug("\tidle_table = " .. tostring(arg3) .. "\n")
        PrintDebug("\tcos = " .. arg4 .. "\n")
        PrintDebug("\tcurrent_chore = " .. local4.root_name .. "_" .. arg2 .. "\n")
        PrintDebug("***\n")
    end
    while system.currentSet == local3 and local1 and not arg1.stop_idle do
        if arg5 then
            PrintDebug(arg1.name .. " -- current chore:" .. getglobal(local1) .. "\n")
        end
        arg1:play_chore(getglobal(local1), arg4)
        arg1.last_chore = getglobal(local1)
        break_here()
        arg1:wait_for_chore(arg1.last_chore, arg4)
        if not arg1.stop_idle then
            if arg1.last_play_chore then
                if local4[arg1.last_play_chore] then
                    local2 = arg1.last_play_chore
                    arg1.stop_idle = TRUE
                    arg1:play_chore(getglobal(local1), arg4)
                    arg1.last_chore = local1
                    break_here()
                    arg1:wait_for_chore(arg1.last_chore, arg4)
                else
                    repeat
                        local1 = arg1.stop_table[arg1.last_chore]
                        arg1:play_chore(local1, arg4)
                        arg1.last_chore = local1
                        arg1:wait_for_chore(arg1.last_chore, arg4)
                    until local1 == arg1.last_play_chore
                    arg1.stop_idle = TRUE
                end
            else
                local2 = pick_from_weighted_table(local4[local1])
            end
        end
        if local2 then
            local1 = local2
        end
    end
end
Actor.kill_idle = function(arg1, arg2) -- line 1063
    local local1
    if find_script(arg1.new_run_idle) then
        arg1.last_play_chore = arg2
        while find_script(arg1.new_run_idle) do
            break_here()
        end
    end
end
Actor.wait_here = function(arg1, arg2) -- line 1078
    repeat
        if arg1.stop_idle or arg1.is_talking then
            arg2 = 0
        else
            arg2 = arg2 - 1
            sleep_for(1000)
        end
    until arg2 <= 0
end
Actor.talk_randomly_from_weighted_table = function(arg1, arg2, arg3, arg4) -- line 1101
    local local1, local2
    local local3 = system.currentSet
    if arg3 then
        local2 = arg3
    else
        local2 = 2000
    end
    if not arg4 then
        arg4 = { background = TRUE, skip_log = TRUE }
    end
    if type(arg2) == "table" then
        while system.currentSet == local3 do
            local1 = pick_from_weighted_table(arg2)
            if local1 then
                arg1:say_line(local1, arg4)
                arg1:wait_for_message()
            end
            sleep_for(local2 * random())
        end
    end
end
Actor.wait_for_actor = function(arg1) -- line 1132
    while arg1:is_moving() or arg1:is_turning() or arg1:is_choring(nil, TRUE) do
        break_here()
    end
end
Actor.wait_for_chore = function(arg1, arg2, arg3) -- line 1144
    if not arg2 and not arg3 then
        arg2 = arg1.last_chore_played
        arg3 = arg1.last_cos_played
    end
    while arg1:is_choring(arg2, TRUE, arg3) do
        break_here()
    end
end
Actor.is_moving = function(arg1) -- line 1159
    return IsActorMoving(arg1.hActor)
end
Actor.is_choring = function(arg1, arg2, arg3, arg4) -- line 1170
    return IsActorChoring(arg1.hActor, arg2, arg3, arg4)
end
Actor.is_resting = function(arg1) -- line 1178
    return IsActorResting(arg1.hActor)
end
Actor.is_turning = function(arg1) -- line 1186
    return IsActorTurning(arg1.hActor)
end
Actor.set_costume = function(arg1, arg2) -- line 1197
    local local1, local2
    SetActorCostume(arg1.hActor, nil)
    arg1.base_costume = arg2
    local1 = SetActorCostume(arg1.hActor, arg2)
    return local1
end
Actor.is_walking = function(arg1) -- line 1209
    if arg1:is_choring(arg1.walk_chore, TRUE, arg1.base_costume) then
        return TRUE
    else
        return FALSE
    end
end
Actor.get_costume = function(arg1, arg2) -- line 1221
    return GetActorCostume(arg1.hActor, arg2)
end
Actor.print_costumes = function(arg1) -- line 1229
    PrintActorCostumes(arg1.hActor)
end
Actor.push_costume = function(arg1, arg2) -- line 1242
    PushActorCostume(arg1.hActor, arg2)
end
Actor.pop_costume = function(arg1) -- line 1254
    if GetActorCostumeDepth(arg1.hActor) > 1 then
        return PopActorCostume(arg1.hActor)
    else
        PrintDebug("WARNING!! Trying to pop off last costume in stack!\n")
        return FALSE
    end
end
Actor.get_costume = function(arg1) -- line 1268
    return GetActorCostume(arg1.hActor)
end
Actor.multi_pop_costume = function(arg1, arg2) -- line 1277
    local local1
    if arg2 then
        local1 = arg2
    else
        local1 = 1
    end
    while GetActorCostumeDepth(arg1.hActor) > local1 do
        arg1:pop_costume()
    end
end
Actor.set_talk_color = function(arg1, arg2) -- line 1295
    SetActorTalkColor(arg1.hActor, arg2)
end
Actor.set_walk_chore = function(arg1, arg2, arg3) -- line 1303
    arg1.walk_chore = arg2
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorWalkChore(arg1.hActor, arg2, arg3)
end
Actor.set_turn_chores = function(arg1, arg2, arg3, arg4) -- line 1314
    if not arg4 then
        arg4 = arg1.base_costume
    end
    SetActorTurnChores(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_rest_chore = function(arg1, arg2, arg3) -- line 1324
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorRestChore(arg1.hActor, arg2, arg3)
end
Actor.set_mumble_chore = function(arg1, arg2, arg3) -- line 1334
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorMumblechore(arg1.hActor, arg2, arg3)
end
Actor.set_talk_chore = function(arg1, arg2, arg3, arg4) -- line 1345
    if not arg4 then
        arg4 = arg1.base_costume
    end
    SetActorTalkChore(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_turn_rate = function(arg1, arg2) -- line 1355
    SetActorTurnRate(arg1.hActor, arg2)
end
Actor.set_walk_rate = function(arg1, arg2) -- line 1363
    SetActorWalkRate(arg1.hActor, arg2)
end
Actor.set_head = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 1372
    SetActorHead(arg1.hActor, arg2, arg3, arg4, arg5, arg6, arg7)
end
Actor.head_look_at = function(arg1, arg2, arg3) -- line 1381
    if type(arg2) == "table" then
        if arg2.interest_actor then
            ActorLookAt(arg1.hActor, arg2.interest_actor.hActor, arg3)
        else
            ActorLookAt(arg1.hActor, arg2.hActor, arg3)
        end
    else
        ActorLookAt(arg1.hActor, nil, arg3)
    end
end
Actor.head_look_at_point = function(arg1, arg2, arg3, arg4, arg5) -- line 1404
    if type(arg2) == "table" then
        ActorLookAt(arg1.hActor, arg2.x, arg2.y, arg2.z, arg3)
    else
        ActorLookAt(arg1.hActor, arg2, arg3, arg4, arg5)
    end
end
Actor.head_look_at_manny = function(arg1, arg2) -- line 1418
    local local1, local2, local3 = GetActorNodeLocation(manny.hActor, 6)
    arg1:head_look_at_point(local1, local2, local3, arg2)
end
Actor.head_follow_mesh = function(arg1, arg2, arg3, arg4) -- line 1427
    local local1, local2, local3
    repeat
        local1, local2, local3 = GetActorNodeLocation(arg2.hActor, arg3)
        if local1 then
            arg1:head_look_at_point(local1, local2, local3)
        end
        break_here()
    until arg4
end
Actor.kill_head_script = function(arg1) -- line 1442
    if arg1.head_script then
        if find_script(arg1.head_script) then
            stop_script(arg1.head_script)
        end
        arg1.head_script = nil
    end
end
Actor.set_look_rate = function(arg1, arg2) -- line 1456
    SetActorLookRate(arg1.hActor, arg2)
end
Actor.get_look_rate = function(arg1) -- line 1466
    return GetActorLookRate(arg1.hActor)
end
Actor.set_visibility = function(arg1, arg2) -- line 1475
    SetActorVisibility(arg1.hActor, arg2)
end
Actor.set_frustrum_culling = function(arg1, arg2) -- line 1489
    SetActorFrustrumCull(arg1.hActor, arg2)
end
Actor.set_selected = function(arg1) -- line 1498
    SetSelectedActor(arg1.hActor)
    system.currentActor = arg1
end
Actor.find_sector_name = function(arg1, arg2) -- line 1509
    return IsActorInSector(arg1.hActor, arg2)
end
Actor.find_sector_type = function(arg1, arg2) -- line 1519
    if arg2 == nil then
        return GetActorSector(arg1.hActor, WALK)
    else
        return GetActorSector(arg1.hActor, arg2)
    end
end
Actor.follow_boxes = function(arg1) -- line 1527
    SetActorFollowBoxes(arg1.hActor, TRUE)
    arg1.following_boxes = TRUE
end
Actor.ignore_boxes = function(arg1) -- line 1533
    SetActorFollowBoxes(arg1.hActor, FALSE)
    arg1.following_boxes = FALSE
end
Actor.put_in_set = function(arg1, arg2) -- line 1544
    if type(arg2) == "table" then
        doorman_in_hot_box = TRUE
        PutActorInSet(arg1.hActor, arg2.setFile)
    else
        PutActorInSet(arg1.hActor, nil)
    end
end
Actor.free = function(arg1) -- line 1557
    PrintDebug("Freed actor " .. arg1.name .. "!!\n")
    if arg1.frozen then
        arg1.frozen.frozen_actors[arg1.hActor] = nil
        arg1.frozen = nil
    end
    arg1:stop_chore(nil)
    arg1:set_costume(nil)
    arg1:put_in_set(nil)
end
Actor.stop_walk = function(arg1) -- line 1574
    local local1 = arg1:getpos()
    arg1:walkto(local1.x, local1.y, local1.z)
end
Actor.fake_walkto = function(arg1, arg2, arg3, arg4, arg5) -- line 1588
    local local1, local2, local3
    local local4 = GetActorWalkRate(arg1.hActor)
    local2 = { x = arg2, y = arg3, z = arg4 }
    local1 = GetActorYawToPoint(arg1.hActor, local2)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    arg1.bob_script = start_script(arg1.fake_bob_walk, arg1, arg5)
    local3 = proximity(arg1.hActor, arg2, arg3, arg4)
    repeat
        local3 = proximity(arg1.hActor, arg2, arg3, arg4)
        if local3 <= PerSecond(GetActorWalkRate(arg1.hActor)) then
            arg1:set_walk_rate(local3 - 0.0099999998)
        end
        WalkActorForward(arg1.hActor)
        break_here()
    until local3 <= 0.050000001
    stop_script(arg1.bob_script)
    arg1:setpos(arg2, arg3, arg4)
    arg1:set_walk_rate(local4)
end
Actor.fake_bob_walk = function(arg1, arg2) -- line 1612
    local local1, local2, local3
    if not arg2 then
        arg2 = 40
    end
    local1 = arg1:getpos()
    local2 = local1.z
    local3 = 10
    while TRUE do
        local1.z = local2 + sin(local3) / arg2
        arg1:setpos(local1.x, local1.y, local1.z)
        local3 = local3 + rndint(10, 20) * (GetActorWalkRate(arg1.hActor) * 10)
        if local3 > 360 then
            local3 = local3 - 360
        end
        break_here()
        local1 = arg1:getpos()
    end
end
Actor.put_at_interest = function(arg1) -- line 1638
    PutActorAtInterest(arg1.hActor)
end
Actor.put_at_object = function(arg1, arg2) -- line 1647
    if type(arg2) == "table" then
        PrintDebug("Putting " .. arg1.name .. " at object " .. arg2.name .. " in set " .. arg2.obj_set.name .. "\n")
        arg1:setpos(arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z)
        arg1:setrot(arg2.use_rot_x, arg2.use_rot_y, arg2.use_rot_z)
        arg1:put_in_set(arg2.obj_set)
    else
        PrintDebug("put_at_object():  invalid object!\n")
    end
end
Actor.clear_hands = function(arg1) -- line 1659
    if arg1.is_holding then
        arg1.is_holding:put_away()
    end
end
Actor.set_speech_mode = function(arg1, arg2) -- line 1673
    if not arg1.saylineTable then
        arg1.saylineTable = { }
    end
    arg1.saylineTable.background = arg2
end
Actor.skip_log = function(arg1, arg2) -- line 1686
    if not arg1.saylineTable then
        arg1.saylineTable = { }
    end
    arg1.saylineTable.skip_log = arg2
end
Actor.normal_say_line = function(arg1, arg2, arg3) -- line 1698
    local local1
    local1 = union_table(arg1.saylineTable, arg3)
    if not local1.background then
        system.lastActorTalking = arg1
    end
    SayLine(arg1.hActor, arg2, local1)
    if not local1.skip_log then
        dialog_log:log_say_line(arg1, arg2)
    end
end
Actor.underwater_say_line = function(arg1, arg2, arg3) -- line 1718
    local local1
    local1 = start_sfx("bubvox.imu")
    Actor.normal_say_line(arg1, arg2, arg3)
    start_script(arg1.wait_for_underwater_message, arg1, local1)
end
Actor.wait_for_underwater_message = function(arg1, arg2) -- line 1726
    while IsMessageGoing(arg1.hActor) do
        break_here()
    end
    stop_sound(arg2)
end
Actor.say_line = Actor.normal_say_line
Actor.wait_for_message = function(arg1) -- line 1736
    while IsMessageGoing(arg1.hActor) do
        break_here()
    end
end
Actor.wait_and_say_line = function(arg1, arg2) -- line 1742
    break_here()
    wait_for_message()
    arg1:say_line(arg2)
end
Actor.is_speaking = function(arg1) -- line 1748
    if IsMessageGoing(arg1.hActor) then
        return TRUE
    else
        return FALSE
    end
end
Actor.shut_up = function(arg1) -- line 1760
    ShutUpActor(arg1.hActor)
end
shut_up_everybody = function() -- line 1768
    local local1, local2
    local1, local2 = next(system.actorTable, nil)
    while local1 do
        if IsMessageGoing(local2.hActor) then
            ShutUpActor(local2.hActor)
        end
        local1, local2 = next(system.actorTable, local1)
    end
end
Actor.angle_to_actor = function(arg1, arg2) -- line 1785
    return GetAngleBetweenActors(arg1.hActor, arg2.hActor)
end
Actor.angle_to_object = function(arg1, arg2) -- line 1793
    return GetAngleBetweenActors(arg1.hActor, arg2.interest_actor.hActor)
end
Actor.voice_line = function(arg1, arg2, arg3, arg4, arg5) -- line 1805
    if 1 then
        arg1:say_line(arg2.text, arg1.talk_in_background)
    else
        if not arg3 then
            arg3 = 3.5
        end
        if not arg4 then
            arg4 = 3.5
        end
        if not arg5 then
            arg5 = 1
        end
        if text_mode == "Text Only" or text_mode == "Text and Voice" or not arg2.hSound then
            arg1:say_line(arg2.text, arg1.talk_in_background)
        end
        if arg2.hSound and text_mode ~= "Text Only" then
            PlaySoundAt(arg2.hSound, arg1.hActor, arg3, arg4, arg5)
            while IsSoundPlaying(arg2.hSound) do
                break_here()
            end
        end
        wait_for_message()
    end
end
Actor.has_any = function(arg1, arg2) -- line 1840
    local local1, local2 = next(arg2, nil)
    while local1 do
        if type(local2) == "table" then
            if local2.owner == arg1 then
                return TRUE
            end
        end
        local1, local2 = next(arg2, local1)
    end
    return FALSE
end
print_actor_coordinates = function(arg1) -- line 1863
    local local1, local2, local3
    local local4, local5
    if not arg1 then
        local4 = InputDialog("Actor Coordinates", "Enter name of actor (manny is the default):")
        if local4 == nil or local4 == "" then
            local4 = "manny"
        end
        local5 = getglobal(local4)
    else
        local5 = arg1
    end
    if local5 ~= nil and type(local5) == "table" then
        local1 = local5:getpos()
        local2 = local5:get_positive_rot()
        local3 = local5:get_softimage_pos()
        if abs(local1.z) < 1e-06 then
            local1.z = 0
        end
        PrintDebug(local4 .. ":setpos(" .. local1.x .. ", " .. local1.y .. ", " .. local1.z .. ")\n")
        PrintDebug(local4 .. ":setrot(" .. local2.x .. ", " .. local2.y .. ", " .. local2.z .. ")\n")
        PrintDebug(local4 .. ":set_softimage_pos(" .. local3.x .. ", " .. local3.y .. ", " .. local3.z .. ")\n")
        PrintDebug("start_script(" .. local4 .. ".walk_and_face," .. local4 .. "," .. local1.x .. ", " .. local1.y .. ", " .. local1.z .. ", " .. local2.x .. ", " .. local2.y .. ", " .. local2.z .. ")\n")
    else
        PrintDebug("Actor \"" .. local4 .. "\" not recognized!\n")
    end
end
system.idleTemplate = { }
Idle = system.idleTemplate
Idle.create = function(arg1, arg2) -- line 1906
    local local1 = { }
    local1.parent = arg1
    local1.root_name = arg2
    return local1
end
Idle.add_state = function(arg1, arg2, arg3) -- line 1913
    local local1, local2
    local local3, local4
    if type(arg3) ~= "table" then
        PrintDebug("Not a valid branch_table for new state " .. arg2 .. "\n")
        return nil
    end
    local1 = arg1.root_name .. "_" .. arg2
    arg1[local1] = { }
    local3, local4 = next(arg3, nil)
    while local3 do
        local2 = arg1.root_name .. "_" .. local3
        arg1[local1][local2] = local4
        local3, local4 = next(arg3, local3)
    end
end
run_idle = function(arg1, arg2, arg3) -- line 1945
    local local1 = arg3
    local local2
    local local3 = system.currentSet
    while system.currentSet == local3 and local1 do
        PlayActorChore(arg1.hActor, local1)
        wait_for_actor(arg1.hActor)
        local2 = pick_from_weighted_table(arg2[local1])
        if local2 then
            local1 = local2
        end
    end
end
Actor.spin = function(arg1) -- line 1975
    local local1, local2, local3
    local local4 = 1
    local1 = 1
    local2 = 360
    local3 = 1
    while 1 do
        arg1:setrot(local1, local2, local3)
        local4 = local4 + 10
        local1 = local1 + 10
        local2 = local2 - 10
        local3 = local3 + 10
        if local4 == 361 then
            local1 = 1
            local2 = 360
            local3 = 1
        end
        break_here()
    end
end
Actor.create_dialogStack = function(arg1) -- line 2013
    arg1.dialogStack = { }
    arg1.dialogStack.parseFunction = nil
    arg1.dialogStack.head = 0
    arg1.dialogStack.tail = 0
end
Actor.push_chore = function(arg1, arg2, arg3, arg4, arg5) -- line 2028
    if not arg2 then
        arg2 = "wait"
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = arg2, isLooping = arg3, fade_in_time = arg4, fade_out_time = arg5 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if not find_script(arg1.execute_dialogStack) then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
    PrintDebug("pushing chore " .. arg2 .. "\n")
end
Actor.push_chore_times = function(arg1, arg2, arg3) -- line 2051
    local local1
    local1 = 0
    while local1 < arg3 do
        arg1:push_chore(arg2, CHORE_NOLOOP)
        arg1:push_chore()
        local1 = local1 + 1
    end
end
Actor.push_break = function(arg1, arg2) -- line 2066
    if not arg2 then
        arg2 = 1
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = "break_here", frames = arg2 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if arg1.dialogStack.parseFunction == nil then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
end
Actor.push_sleep = function(arg1, arg2) -- line 2083
    if not arg2 then
        arg2 = 1000
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = "sleep_for", msecs = arg2 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if arg1.dialogStack.parseFunction == nil then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
end
Actor.execute_dialogStack = function(arg1) -- line 2107
    local local1, local2
    local local3 = arg1:get_costume(nil)
    local local4
    local1 = arg1.dialogStack[arg1.dialogStack.head]
    while local1 ~= nil do
        PrintDebug("dialogStack: " .. local1.chore .. "\n")
        if local1.chore == "wait" then
            arg1:wait_for_chore()
        elseif local1.chore == "break_here" then
            local2 = 0
            while local2 < local1.frames do
                break_here()
                local2 = local2 + 1
            end
        elseif local1.chore == "sleep_for" then
            sleep_for(local1.msecs)
        elseif local1.isLooping == CHORE_LOOP then
            arg1:play_chore_looping(local1.chore)
        elseif local1.fade_in_time then
            PrintDebug("Fading in chore " .. local1.chore .. "\n")
            if local4 then
                arg1:blend(local1.chore, local4.chore, local1.fade_in_time, local3)
            else
                FadeInChore(arg1.hActor, local3, local1.chore, local1.fade_in_time)
            end
        else
            PrintDebug("playing chore " .. local1.chore .. "\n")
            arg1:play_chore(local1.chore)
        end
        if local1.fade_out_time then
            arg1:wait_for_chore()
            PrintDebug("Fading out chore " .. local1.chore .. "\n")
            FadeOutChore(arg1.hActor, local3, local1.chore, local1.fade_in_time)
        end
        if local1.chore ~= "wait" and local1.chore ~= "break_here" and local1 ~= "sleep_for" then
            local4 = local1
        end
        arg1.dialogStack[arg1.dialogStack.head] = nil
        arg1.dialogStack.head = arg1.dialogStack.head + 1
        local1 = arg1.dialogStack[arg1.dialogStack.head]
    end
    arg1.dialogStack.head = 0
    arg1.dialogStack.tail = 0
    arg1.dialogStack.parseFunction = nil
end
Actor.play_sound_at = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 2176
    local local1
    if not arg5 then
        arg5 = IM_HIGH_PRIORITY
    end
    if not arg6 then
        arg6 = IM_GROUP_SFX
    end
    local1 = ImStartSound(arg2, arg5, arg6)
    SetSoundPosition(local1, arg1.hActor, arg3, arg4)
    return local1
end
Actor.move_sound_to = function(arg1, arg2, arg3, arg4) -- line 2196
    SetSoundPosition(arg2, arg1.hActor, arg3, arg4)
end
Actor.play_attached_sound = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 2211
    local local1
    if not arg5 then
        arg5 = IM_HIGH_PRIORITY
    end
    if not arg6 then
        arg6 = IM_GROUP_SFX
    end
    ImStartSound(arg2, arg5, arg6)
    local1 = start_script(arg1.attach_sound, arg1, arg2, arg3, arg4)
    wait_for_script(local1)
end
Actor.attach_sound = function(arg1, arg2, arg3, arg4) -- line 2233
    start_script(arg1.attach_sound_script, arg1, arg2, arg3, arg4)
end
Actor.attach_sound_script = function(arg1, arg2, arg3, arg4) -- line 2248
    while sound_playing(arg2) do
        SetSoundPosition(arg2, arg1.hActor, arg3, arg4)
    end
end
Actor.play_footstep_sfx = function(arg1, arg2, arg3, arg4) -- line 2263
    arg1:play_sound_at(arg2, arg3, arg4, IM_MED_PRIORITY)
end
Actor.costumeMarkerHandler = function(arg1, arg2, arg3) -- line 2274
    local local1 = system.actorTable[arg2]
    local local2 = FALSE
    if local1 ~= nil then
        if local1.costume_marker_handler then
            local2 = TRUE
            local1:costume_marker_handler(arg3)
        elseif local1.costume_marker_handler == bird_sound_monitor then
            local2 = TRUE
            local1:costume_marker_handler(arg3)
        end
    end
    if not local2 and local1 ~= nil and local1.footsteps ~= nil and not local1:is_resting() then
        local1:play_default_footstep(arg3)
    end
end
Actor.play_default_footstep = function(arg1, arg2, arg3) -- line 2298
    local local1
    local local2, local3
    local local4, local5
    if not arg3 then
        local1 = arg1.footsteps
    else
        local1 = arg3
    end
    local2 = local1.prefix
    local3 = nil
    local4 = 10
    local5 = 64
    if arg2 == Actor.MARKER_LEFT_WALK then
        local2 = local2 .. "wl"
        local3 = rndint(1, local1.left_walk)
    elseif arg2 == Actor.MARKER_RIGHT_WALK then
        local2 = local2 .. "wr"
        local3 = rndint(1, local1.right_walk)
    elseif arg2 == Actor.MARKER_LEFT_TURN then
        local2 = local2 .. "wl"
        local3 = rndint(1, local1.left_walk)
        local4 = 5
        local5 = 20
    elseif arg2 == Actor.MARKER_RIGHT_TURN then
        local2 = local2 .. "wr"
        local3 = rndint(1, local1.right_walk)
        local4 = 5
        local5 = 20
    elseif arg2 == Actor.MARKER_LEFT_RUN then
        if local1.left_run and local1.left_run > 0 then
            local2 = local2 .. "rl"
            local3 = rndint(1, local1.left_run)
        else
            local2 = local2 .. "wl"
            local3 = rndint(1, local1.left_walk)
        end
    elseif arg2 == Actor.MARKER_RIGHT_RUN then
        if local1.right_run and local1.right_run > 0 then
            local2 = local2 .. "rr"
            local3 = rndint(1, local1.right_run)
        else
            local2 = local2 .. "wr"
            local3 = rndint(1, local1.right_walk)
        end
    end
    if local3 then
        local2 = local2 .. local3 .. ".wav"
        arg1:play_footstep_sfx(local2, local4, local5)
    end
end
Actor.costumeOverrideHandler = function(arg1, arg2, arg3) -- line 2356
    if arg3 then
        arg1.idles_allowed = FALSE
    else
        arg1.idles_allowed = TRUE
    end
end
Actor.collisionHandler = function(arg1, arg2, arg3) -- line 2364
    local local1 = system.actorTable[arg2]
    local local2 = system.actorTable[arg3]
    if local1 ~= nil then
        if local1.collision_handler then
            PrintDebug(local1.name .. " has run into " .. local2.name)
            single_start_script(local1.collision_handler, local1, local2)
        end
    end
end
Actor.collision_handler = function(arg1, arg2) -- line 2376
end
system.costumeMarkerHandler = Actor
system.costumeOverrideHandler = Actor
system.collisionHandler = Actor
footsteps = { }
footsteps.concrete = { prefix = "fscon", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.dirt = { prefix = "fsdrt", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.gravel = { prefix = "fsgrv", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.creak = { prefix = "fscrk", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.marble = { prefix = "fsmar", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.metal = { prefix = "fsmet", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.pavement = { prefix = "fspav", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.rug = { prefix = "fsrug", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.sand = { prefix = "fssnd", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.snow = { prefix = "fssno", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.trapdoor = { prefix = "fstrp", left_walk = 1, right_walk = 1, left_run = 1, right_run = 1 }
footsteps.echo = { prefix = "fseko", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.reverb = { prefix = "fsrvb", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.metal2 = { prefix = "fs3mt", left_walk = 4, right_walk = 4, left_run = 2, right_run = 2 }
footsteps.wet = { prefix = "fswet", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.flowers = { prefix = "fsflw", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.glottis = { prefix = "fsglt", left_walk = 2, right_walk = 2 }
footsteps.jello = { prefix = "fsjll", left_walk = 2, right_walk = 2 }
footsteps.nick_virago = { prefix = "fsnic", left_walk = 2, right_walk = 2 }
footsteps.underwater = { prefix = "fswtr", left_walk = 3, right_walk = 3, left_run = 2, right_run = 2 }
footsteps.velasco = { prefix = "fsbcn", left_walk = 3, right_walk = 2 }
brennis = Actor:create(nil, nil, nil, "Tube-Switcher Guy")
brennis:set_talk_color(Red)
brennis.default = function(arg1) -- line 2441
    brennis:set_costume("brennis_fix_idle.cos")
    brennis:set_colormap("brennis.cmp")
    brennis:set_mumble_chore(brennis_fix_idle_mumble)
    brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
    brennis:set_talk_chore(2, brennis_fix_idle_a)
    brennis:set_talk_chore(3, brennis_fix_idle_c)
    brennis:set_talk_chore(4, brennis_fix_idle_e)
    brennis:set_talk_chore(5, brennis_fix_idle_f)
    brennis:set_talk_chore(6, brennis_fix_idle_l)
    brennis:set_talk_chore(7, brennis_fix_idle_m)
    brennis:set_talk_chore(8, brennis_fix_idle_o)
    brennis:set_talk_chore(9, brennis_fix_idle_t)
    brennis:set_talk_chore(10, brennis_fix_idle_u)
end
celso = Actor:create(nil, nil, nil, "Celso")
celso:set_talk_color(Yellow)
chepito = Actor:create(nil, nil, nil, "Chepito")
chepito.default = function(arg1) -- line 2463
    if not chepito.hCos then
        chepito.hCos = "chepito.cos"
    end
    chepito:set_visibility(TRUE)
    chepito:set_costume(chepito.hCos)
    chepito:set_talk_color(Green)
    chepito:set_walk_chore(chepito_walk)
    chepito:set_mumble_chore(chepito_mumble)
    chepito:set_talk_chore(1, chepito_m)
    chepito:set_talk_chore(2, chepito_a)
    chepito:set_talk_chore(3, chepito_c)
    chepito:set_talk_chore(4, chepito_e)
    chepito:set_talk_chore(5, chepito_f)
    chepito:set_talk_chore(6, chepito_l)
    chepito:set_talk_chore(7, chepito_m)
    chepito:set_talk_chore(8, chepito_o)
    chepito:set_talk_chore(9, chepito_t)
    chepito:set_talk_chore(10, chepito_u)
    chepito:set_head(3, 4, 5, 165, 28, 80)
end
domino = Actor:create(nil, nil, nil, "Domino")
domino:set_talk_color(Yellow)
domino.default = function(arg1) -- line 2490
    domino:set_colormap("domino.cmp")
    domino:set_talk_color(Yellow)
end
eva = Actor:create(nil, nil, nil, "/sytx088/")
eva:set_talk_color(Red)
eva.default = function(arg1, arg2) -- line 2497
    if arg2 == "sec" then
        eva:set_costume("eva_sec.cos")
        eva:set_mumble_chore(eva_sec_mumble, "eva_sec.cos")
        eva:set_talk_chore(1, eva_sec_mouth_m)
        eva:set_talk_chore(2, eva_sec_mouth_a)
        eva:set_talk_chore(3, eva_sec_mouth_c)
        eva:set_talk_chore(4, eva_sec_mouth_e)
        eva:set_talk_chore(5, eva_sec_mouth_f)
        eva:set_talk_chore(6, eva_sec_mouth_l)
        eva:set_talk_chore(7, eva_sec_mouth_m)
        eva:set_talk_chore(8, eva_sec_mouth_o)
        eva:set_talk_chore(9, eva_sec_mouth_t)
        eva:set_talk_chore(10, eva_sec_mouth_u)
    else
        eva:set_costume("ev_r_idles.cos")
    end
    eva:set_colormap("eva_sv.cmp")
    eva:set_talk_color(Red)
    eva:ignore_boxes()
end
manny = Actor:create(nil, nil, nil, "Manny")
manny.costume_state = "suit"
dofile("_manny.lua")
meche = Actor:create(nil, nil, nil, "Meche")
meche:set_talk_color(Green)
dofile("olivia_talks.lua")
olivia = Actor:create(nil, nil, nil, "Olivia")
olivia:set_talk_color(MakeColor(164, 18, 147))
olivia.default = function(arg1) -- line 2531
    olivia:set_costume(nil)
    olivia:set_costume("olivia_talks.cos")
    olivia:set_mumble_chore(olivia_talks_mumble, "olivia_talks.cos")
    olivia:set_talk_chore(1, olivia_talks_stop_talk)
    olivia:set_talk_chore(2, olivia_talks_a)
    olivia:set_talk_chore(3, olivia_talks_c)
    olivia:set_talk_chore(4, olivia_talks_e)
    olivia:set_talk_chore(5, olivia_talks_f)
    olivia:set_talk_chore(6, olivia_talks_l)
    olivia:set_talk_chore(7, olivia_talks_m)
    olivia:set_talk_chore(8, olivia_talks_o)
    olivia:set_talk_chore(9, olivia_talks_t)
    olivia:set_talk_chore(10, olivia_talks_u)
    olivia:push_costume("olivia_idles.cos")
    olivia:set_walk_chore(olivia_idles_walk, "olivia_idles.cos")
    olivia:set_head(5, 6, 7, 165, 28, 80)
    olivia:set_look_rate(110)
    olivia:set_collision_mode(COLLISION_SPHERE, 0.2)
end
salvador = Actor:create(nil, nil, nil, "/sytx198/")
salvador:set_talk_color(DarkGreen)
salvador.default = function(arg1) -- line 2556
    salvador:ignore_boxes()
    if not salvador.hCos then
        salvador.hCos = "sv_in_hq.cos"
    end
    salvador:set_costume(salvador.hCos)
    salvador:set_colormap("eva_sv.cmp")
    salvador:set_head(3, 4, 5, 165, 28, 80)
    salvador:set_look_rate(90)
end
toto = Actor:create(nil, nil, nil, "Toto")
toto.default = function(arg1) -- line 2568
    toto:set_colormap("toto.cmp")
    toto:set_talk_color(Yellow)
end
dofile("velasco.lua")
velasco = Actor:create(nil, nil, nil, "Velasco")
velasco.default = function(arg1) -- line 2575
    velasco:free()
    velasco:set_costume("velasco.cos")
    velasco:set_colormap("velasco.cmp")
    velasco:set_talk_color(Blue)
    velasco:set_head(3, 4, 5, 165, 28, 80)
    velasco:set_walk_rate(0.38)
    velasco:set_look_rate(180)
    velasco:set_mumble_chore(velasco_mumble)
    velasco:set_talk_chore(1, velasco_stop_talk)
    velasco:set_talk_chore(2, velasco_a)
    velasco:set_talk_chore(3, velasco_c)
    velasco:set_talk_chore(4, velasco_e)
    velasco:set_talk_chore(5, velasco_f)
    velasco:set_talk_chore(6, velasco_l)
    velasco:set_talk_chore(7, velasco_m)
    velasco:set_talk_chore(8, velasco_o)
    velasco:set_talk_chore(9, velasco_t)
    velasco:set_talk_chore(10, velasco_u)
    velasco:set_turn_rate(85)
    velasco:set_collision_mode(COLLISION_OFF)
    velasco:set_walk_chore(velasco_walk, "velasco.cos")
end
dofile("_actors1.lua")
dofile("_actors2.lua")
dofile("_actors3.lua")
dofile("_actors4.lua")
CheckFirstTime("nq.lua")
nq = Set:create("nq.set", "New Headquarters", { nq_intha = 0, nq_ovrhd = 1 })
dofile("ev_stand_idles.lua")
dofile("nq_tape.lua")
dofile("meche_ruba.lua")
dofile("meche_snow.lua")
nq.the_plan = function() -- line 17
    local local1 = { }
    START_CUT_SCENE()
    meche.footsteps = footsteps.concrete
    meche_idle_ok = FALSE
    manny:walkto_object(nq.meche_obj)
    manny:head_look_at(nil)
    eva:head_follow_mesh(meche, 6, TRUE)
    manny:say_line("/nqma031/")
    wait_for_message()
    manny:say_line("/nqma032/")
    wait_for_message()
    manny:say_line("/nqma033/")
    wait_for_message()
    meche:say_line("/nqmc034/")
    wait_for_message()
    stop_script(meche.head_follow_mesh)
    eva:say_line("/nqev035/")
    meche:head_follow_mesh(eva, 6, TRUE)
    wait_for_message()
    meche:head_look_at(nil)
    eva:head_look_at(nil)
    MakeSectorActive("meche_box", FALSE)
    meche:follow_boxes()
    meche:set_collision_mode(COLLISION_OFF)
    meche:head_look_at_manny()
    start_script(meche.walkto, meche, nq.lw_door, TRUE)
    sleep_for(1000)
    meche:say_line("/nqmc036/")
    meche:wait_for_actor()
    meche:free()
    eva:say_line("/nqev037/")
    manny:head_look_at(nil)
    local1 = eva:getpos()
    while TurnActorTo(manny.hActor, local1.x, local1.y, local1.z) do
        break_here()
    end
    eva:say_line("/nqev037/")
    wait_for_message()
    manny:say_line("/nqma038/")
    wait_for_message()
    manny:say_line("/nqma039/")
    wait_for_message()
    END_CUT_SCENE()
    nq.meche_obj:make_untouchable()
end
nq.bowlsley_cam = function() -- line 65
    if not bowlsley_in_hiding then
        if not nq.pigeon.en_route then
            START_CUT_SCENE("no head")
            system:lock_display()
            StartMovie("cam_cyc.snm", TRUE)
            manny:set_visibility(FALSE)
            meche:set_visibility(FALSE)
            eva:set_visibility(FALSE)
            if not little_manny.dead then
                little_manny:set_visibility(FALSE)
            end
            if not nq.picked_up_arm then
                arm_actor:set_visibility(FALSE)
            end
            nq.remains:play_chore(1)
            nq.tape_recorder:play_chore(nq_tape_gone)
            system:unlock_display()
            music_state:set_state(stateFVID)
            if not nq.seen_bowlsley then
                nq.seen_bowlsley = TRUE
                wait_for_message()
                sleep_for(1000)
                manny:say_line("/nqma040/")
                manny:wait_for_message()
                eva:say_line("/nqev041/")
                eva:wait_for_message()
                eva:say_line("/nqev042/")
                eva:wait_for_message()
                eva:say_line("/nqev043/")
                eva:wait_for_message()
                eva:say_line("/nqev044/")
                eva:wait_for_message()
                eva:say_line("/nqev045/")
                eva:wait_for_message()
                manny:say_line("/nqma046/")
                eva:wait_for_message()
                manny:say_line("/nqma047/")
                manny:wait_for_message()
                eva:say_line("/nqev048/")
                eva:wait_for_message()
                eva:say_line("/nqev049/")
                eva:wait_for_message()
                manny:say_line("/nqma050/")
                nq:restore_from_movie()
            else
                set_override(nq.esc_from_camera)
                sleep_for(1000)
                manny:say_line("/nqma051/")
                system.buttonHandler = camera_button_handler
            end
            END_CUT_SCENE()
        else
            cur_puzzle_state[52] = TRUE
            nq.pigeon.en_route = FALSE
            start_script(cut_scene.eatbird)
        end
    else
        nq.say_nothing_but()
    end
end
nq.esc_from_camera = function() -- line 149
    system.buttonHandler = SampleButtonHandler
    start_script(nq.restore_from_movie)
end
camera_button_handler = function(arg1, arg2, arg3) -- line 154
    if not CommonButtonHandler(arg1, arg2, arg3) then
        if arg2 then
            nq.esc_from_camera()
        end
    end
end
nq.restore_from_movie = function(arg1) -- line 162
    system:lock_display()
    StopMovie()
    break_here()
    ForceRefresh()
    manny:set_visibility(TRUE)
    meche:set_visibility(TRUE)
    eva:set_visibility(TRUE)
    if not little_manny.dead then
        little_manny:set_visibility(TRUE)
    end
    if not nq.picked_up_arm then
        arm_actor:set_visibility(TRUE)
    end
    nq.remains:play_chore(0)
    sleep_for(250)
    music_state:update()
    system:unlock_display()
end
nq.say_nothing_but = function() -- line 185
    manny:say_line("/nqma052/")
end
nq.dead_cam = function(arg1) -- line 190
    if not nq.seen_dead_cam then
        nq.seen_dead_cam = TRUE
        if not arg1.seen then
            arg1.seen = TRUE
            manny:say_line("/nqma053/")
            wait_for_message()
            manny:say_line("/nqma054/")
        else
            nq.say_nothing_but()
        end
    elseif not arg1.seen then
        arg1.seen = TRUE
        manny:say_line("/nqma055/")
        wait_for_message()
        manny:say_line("/nqma056/")
    else
        nq.say_nothing_but()
    end
end
nq.eva_idles = function(arg1) -- line 213
    local local1
    eva:play_chore(ev_stand_idle_stand_idle)
    while 1 do
        if not eva.stop_idle then
            local1 = rndint(1, 3)
            eva:play_chore(local1)
            eva:wait_for_chore()
            eva:wait_here(rnd(1, 3))
        end
        break_here()
    end
end
nq.idle_little_manny = function() -- line 227
    nq.pigeon_ilde_ok = TRUE
    while 1 do
        if nq.pigeon_ilde_ok then
            if rnd() then
                little_manny:play_chore(pigeon_idles_stopwalk_cycle)
            else
                little_manny:play_chore(pigeon_idles_head_turns)
            end
            if rnd() then
                little_manny:play_sound_at("pigeon3.wav")
            else
                little_manny:play_sound_at("wings4.wav")
            end
            little_manny:wait_for_chore()
            sleep_for(rnd(3000, 6000))
        else
            break_here()
        end
    end
end
nq.meche_arm_idle = function() -- line 249
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
    meche_idle_ok = TRUE
    while meche_idle_ok do
        meche:play_chore(meche_ruba_drop_hands)
        meche:wait_for_chore()
        vi.meche_hold(5, 9)
        meche:play_chore(meche_ruba_xarms)
        meche:wait_for_chore()
        vi.meche_hold(5, 9)
    end
    meche:play_chore(meche_ruba_drop_hands)
    meche:wait_for_chore()
end
nq.set_up_actors = function(arg1) -- line 268
    eva:set_costume("ev_stand_idles.cos")
    eva:put_in_set(nq)
    eva:ignore_boxes()
    eva:set_mumble_chore(ev_stand_idles_mumble)
    eva:set_talk_chore(1, ev_stand_idles_stop_talk)
    eva:set_talk_chore(2, ev_stand_idles_a)
    eva:set_talk_chore(3, ev_stand_idles_c)
    eva:set_talk_chore(4, ev_stand_idles_e)
    eva:set_talk_chore(5, ev_stand_idles_f)
    eva:set_talk_chore(6, ev_stand_idles_l)
    eva:set_talk_chore(7, ev_stand_idles_m)
    eva:set_talk_chore(8, ev_stand_idles_o)
    eva:set_talk_chore(9, ev_stand_idles_t)
    eva:set_talk_chore(10, ev_stand_idles_u)
    eva:setpos(-0.3296, -0.00454, 0)
    eva:setrot(0, -99.1731, 0)
    eva:set_head(3, 4, 5, 165, 28, 80)
    eva:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(eva.hActor, 0.3)
    start_script(nq.eva_idles)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.35)
    if not little_manny then
        little_manny = Actor:create(nil, nil, nil, "little manny")
    end
    if not little_manny.dead then
        little_manny:follow_boxes()
        little_manny:set_costume("pigeon_idles.cos")
        little_manny:set_colormap("pigeons.cmp")
        little_manny:put_in_set(nq)
        little_manny:ignore_boxes()
        little_manny:setpos(-0.342759, 0.825031, 0.522623)
        little_manny:setrot(0, 188, 0)
        start_script(nq.idle_little_manny)
    end
    if nq.meche_obj.touchable then
        box_on("meche_box")
        meche:set_costume(nil)
        meche:set_costume("meche_snow.cos")
        meche:set_mumble_chore(meche_snow_mumble, "meche_snow.cos")
        meche:set_talk_chore(1, meche_snow_stop_talk)
        meche:set_talk_chore(2, meche_snow_a)
        meche:set_talk_chore(3, meche_snow_c)
        meche:set_talk_chore(4, meche_snow_e)
        meche:set_talk_chore(5, meche_snow_f)
        meche:set_talk_chore(6, meche_snow_l)
        meche:set_talk_chore(7, meche_snow_m)
        meche:set_talk_chore(8, meche_snow_o)
        meche:set_talk_chore(9, meche_snow_t)
        meche:set_talk_chore(10, meche_snow_u)
        meche:set_head(5, 5, 5, 165, 28, 80)
        meche:set_walk_chore(meche_snow_walk, "meche_snow.cos")
        meche:set_look_rate(200)
        meche:put_in_set(nq)
        meche:ignore_boxes()
        meche:setpos(0.9, 1, 0)
        meche:setrot(0, -204, 0)
        meche:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(meche.hActor, 0.5)
        start_script(nq.meche_arm_idle)
        start_script(meche.head_follow_mesh, meche, manny, 5)
    else
        MakeSectorActive("meche_box", FALSE)
    end
    if not arm_actor then
        arm_actor = Actor:create(nil, nil, nil, "arm")
    end
    if not nq.picked_up_arm then
        arm_actor:set_costume("arm_actor.cos")
        arm_actor:put_in_set(nq)
        arm_actor:setpos({ x = 0.742541, y = -0.0746845, z = -0.007 })
        arm_actor:setrot(0, 90, 89)
        arm_actor:play_chore_looping(0)
    end
end
radio_table = { "radio1.wav", "radio2.wav", "radio3.wav", "cpuBeep1.wav", "cpuBeep2.wav", "cpuBeep3.wav", "cpuArrow.wav", "compBeep.wav", "intrCom.wav", "typeCr.wav" }
nq.radio_sfx = function(arg1) -- line 350
    local local1
    while 1 do
        sleep_for(15000)
        if not find_script(cut_scene.eatbird) then
            local1 = pick_from_nonweighted_table(radio_table, TRUE)
            start_sfx(local1, 32)
        end
    end
end
nq.enter = function(arg1) -- line 368
    nq:set_up_actors()
    NewObjectState(nq_intha, OBJSTATE_UNDERLAY, "nq_sprout.bm")
    nq.remains:set_object_state("nq_body.cos")
    nq.remains:play_chore(0)
    nq.tape_recorder.hObjectState = nq:add_object_state(nq_intah, "nq_tape.bm", nil, OBJSTATE_UNDERLAY, FALSE)
    nq.tape_recorder:set_object_state("nq_tape.cos")
    start_script(nq.radio_sfx)
    SetShadowColor(6, 6, 6)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 10)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(meche.hActor, 0)
    SetActorShadowPoint(meche.hActor, 0, 0, 10)
    SetActorShadowPlane(meche.hActor, "shadow1")
    AddShadowPlane(meche.hActor, "shadow1")
    SetActiveShadow(eva.hActor, 0)
    SetActorShadowPoint(eva.hActor, 0, 0, 10)
    SetActorShadowPlane(eva.hActor, "shadow1")
    AddShadowPlane(eva.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0, 0, 10)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(meche.hActor, 1)
    SetActorShadowPoint(meche.hActor, 0, 0, 10)
    SetActorShadowPlane(meche.hActor, "shadow2")
    AddShadowPlane(meche.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 0, 0, 10)
    SetActorShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow3")
    SetActiveShadow(meche.hActor, 2)
    SetActorShadowPoint(meche.hActor, 0, 0, 10)
    SetActorShadowPlane(meche.hActor, "shadow3")
    AddShadowPlane(meche.hActor, "shadow3")
end
nq.exit = function(arg1) -- line 421
    eva:free()
    stop_script(nq.radio_sfx)
    stop_script(nq.eva_idles)
    little_manny:free()
    stop_script(nq.idle_little_manny)
    manny:set_collision_mode(COLLISION_OFF)
    KillActorShadows(manny.hActor)
    KillActorShadows(meche.hActor)
    KillActorShadows(eva.hActor)
end
nq.meche_obj = Object:create(nq, "Meche", 0.91113698, 0.984411, 0.51099998, { range = 0.89999998 })
nq.meche_obj.use_pnt_x = 0.72313702
nq.meche_obj.use_pnt_y = 0.739411
nq.meche_obj.use_pnt_z = 0
nq.meche_obj.use_rot_x = 0
nq.meche_obj.use_rot_y = -1843.97
nq.meche_obj.use_rot_z = 0
nq.meche_obj.lookAt = function(arg1) -- line 457
    manny:say_line("/nqma058/")
end
nq.meche_obj.pickUp = function(arg1) -- line 461
    system.default_response("not now")
end
nq.meche_obj.use = function(arg1) -- line 465
    start_script(nq.the_plan)
end
nq.meche_obj.use_hand = function(arg1) -- line 469
    START_CUT_SCENE()
    manny:walkto(0.693852, 0.844436, -0.00303789, 0, 318.127, 0)
    manny:wait_for_actor()
    manny:wait_for_actor()
    manny:play_chore(msb_use_obj, manny.base_costume)
    manny:say_line("/lrma008/")
    manny:wait_for_message()
    meche:say_line("/nqmc059/")
    manny:wait_for_chore(msb_use_obj, manny.base_costume)
    manny:stop_chore(msb_use_obj, manny.base_costume)
    END_CUT_SCENE()
end
nq.meche_obj.use_lsa_photo = function(arg1) -- line 483
    meche:say_line("/nqmc060/")
end
nq.monitor1 = Object:create(nq, "/nqtx001/monitor", -0.59216201, 0.28474399, 0.47, { range = 0.60000002 })
nq.monitor1.use_pnt_x = -0.48111799
nq.monitor1.use_pnt_y = 0.28467101
nq.monitor1.use_pnt_z = 0
nq.monitor1.use_rot_x = 0
nq.monitor1.use_rot_y = -2793.6799
nq.monitor1.use_rot_z = 0
nq.monitor1.lookAt = function(arg1) -- line 496
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    start_script(nq.bowlsley_cam)
    END_CUT_SCENE()
end
nq.monitor1.pickUp = function(arg1) -- line 504
    system.default_response("attached")
end
nq.monitor1.use = nq.monitor1.lookAt
nq.monitor2 = Object:create(nq, "/nqtx008/monitor", -0.80216199, -0.045256399, 0.5, { range = 0.60000002 })
nq.monitor2.use_pnt_x = -0.63804001
nq.monitor2.use_pnt_y = -0.048541501
nq.monitor2.use_pnt_z = 0
nq.monitor2.use_rot_x = 0
nq.monitor2.use_rot_y = -2782.29
nq.monitor2.use_rot_z = 0
nq.monitor2.pickUp = function(arg1) -- line 518
    system.default_response("attached")
end
nq.monitor2.use = function(arg1) -- line 522
    start_script(nq.dead_cam, arg1)
end
nq.monitor2.lookAt = nq.monitor2.use
nq.monitor3 = Object:create(nq, "/nqtx009/monitor", -0.78216201, 0.55474401, 0.5, { range = 0.64999998 })
nq.monitor3.use_pnt_x = -0.56171501
nq.monitor3.use_pnt_y = 0.425107
nq.monitor3.use_pnt_z = 0
nq.monitor3.use_rot_x = 0
nq.monitor3.use_rot_y = -2813.8701
nq.monitor3.use_rot_z = 0
nq.monitor3.lookAt = function(arg1) -- line 536
    start_script(nq.dead_cam, arg1)
end
nq.monitor3.pickUp = function(arg1) -- line 540
    system.default_response("attached")
end
nq.monitor3.use = nq.monitor3.lookAt
nq.pigeon = Object:create(nq, "/nqtx010/pigeon", -0.33384299, 0.79816997, 0.61000001, { range = 0.85000002 })
nq.pigeon.use_pnt_x = -0.252049
nq.pigeon.use_pnt_y = 0.51655197
nq.pigeon.use_pnt_z = 0
nq.pigeon.use_rot_x = 0
nq.pigeon.use_rot_y = 6.4552002
nq.pigeon.use_rot_z = 0
nq.pigeon.lookAt = function(arg1) -- line 556
    if not arg1.noted then
        if arg1.bit then
            manny:say_line("/nqma014/")
        else
            manny:say_line("/nqma011/")
        end
    else
        manny:say_line("/nqma061/")
    end
end
nq.pigeon.pickUp = function(arg1) -- line 568
    if nq.pigeon.bit then
        system.default_response("got some")
    elseif manny:walkto_object(arg1) then
        START_CUT_SCENE()
        nq.pigeon.bit = TRUE
        nq.pigeon_ilde_ok = FALSE
        manny:say_line("/nqma012/")
        manny:wait_for_actor()
        manny:wait_for_message()
        manny:play_chore(msb_reach_high, manny.base_costume)
        sleep_for(1000)
        little_manny:play_chore(pigeon_idles_pecking)
        start_sfx("nqChomp.wav")
        wait_for_sound("nqChomp.wav")
        manny:say_line("/nqma013/")
        wait_for_message()
        manny:say_line("/nqma014/")
        manny:wait_for_chore()
        nq.pigeon_ilde_ok = TRUE
        END_CUT_SCENE()
    end
end
nq.pigeon.use = nq.pigeon.pickUp
nq.pigeon.use_note = function(arg1) -- line 596
    arg1.noted = TRUE
    START_CUT_SCENE()
    nq.pigeon_ilde_ok = FALSE
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:say_line("/nqma015/")
    wait_for_message()
    manny.is_holding = nil
    manny:stop_chore(msb_hold, manny.base_costume)
    if manny.fancy then
        manny:stop_chore(mcc_thunder_hold_note, manny.base_costume)
        manny:play_chore(mcc_thunder_activate_note, manny.base_costume)
    else
        manny:stop_chore(msb_hold_note, manny.base_costume)
        manny:play_chore(msb_activate_note, manny.base_costume)
    end
    manny:play_chore(msb_reach_high, manny.base_costume)
    manny:say_line("/nqma016/")
    sleep_for(1000)
    if manny.fancy then
        manny:stop_chore(mcc_thunder_activate_note, manny.base_costume)
    else
        manny:stop_chore(msb_activate_note, manny.base_costume)
    end
    start_sfx("tgPullNt.wav")
    manny:wait_for_chore()
    tg.note:free()
    nq.pigeon_ilde_ok = TRUE
    END_CUT_SCENE()
end
nq.pigeon_fly_sfx = function(arg1) -- line 629
    local local1
    while 1 do
        local1 = pick_one_of({ "wings1.wav", "wings2.wav", "wings3.wav", "wings4.wav", "wings5.wav", "wings6.wav", "wings7.wav", "wings8.wav" })
        start_sfx(local1)
        while sound_playing(local1) do
            break_here()
        end
    end
end
nq.pigeon.use_lsa_photo = function(arg1) -- line 642
    if not arg1.noted then
        manny:say_line("/nqma017/")
    else
        START_CUT_SCENE()
        stop_script(nq.idle_little_manny)
        little_manny.dead = TRUE
        arg1:make_untouchable()
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:say_line("/jbma078/")
        manny:play_chore(msb_reach_high, manny.base_costume)
        manny:wait_for_chore()
        manny:wait_for_message()
        nq.pigeon.en_route = TRUE
        music_state:set_sequence(seqPigeonFly)
        start_script(nq.pigeon_fly_sfx)
        little_manny:play_chore(pigeon_idles_short_takeoff)
        manny:play_chore(msb_reach_low, manny.base_costume)
        little_manny:wait_for_chore()
        little_manny:play_chore_looping(pigeon_idles_fly_cycle)
        manny:say_line("/nqma062/")
        little_manny:set_turn_rate(55)
        while TurnActorTo(little_manny.hActor, 0.518063, 1.62193, 0.522623) do
            little_manny:walk_forward()
            break_here()
        end
        manny:wait_for_chore()
        manny:stop_chore(msb_reach_low, manny.base_costume)
        repeat
            TurnActorTo(little_manny.hActor, -1.17, 2.12, 0.522623)
            little_manny:walk_forward()
            break_here()
        until little_manny:find_sector_name("little_manny")
        stop_script(nq.pigeon_fly_sfx)
        little_manny:free()
        nq.monitor1:lookAt()
        END_CUT_SCENE()
        manny:clear_hands()
    end
end
nq.pigeon.use_hand = function(arg1) -- line 688
    START_CUT_SCENE()
    manny:say_line("/nqma063/")
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:wait_for_message()
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_reach_high, manny.base_costume)
    sleep_for(1000)
    manny:say_line("/nqma064/")
    manny:wait_for_chore()
    manny:stop_chore(msb_reach_high, manny.base_costume)
    manny:play_chore_looping(msb_hold, manny.base_costume)
    END_CUT_SCENE()
end
nq.wastebasket = Object:create(nq, "/nqtx018/wastebasket", 0.216911, 0.86986101, 0.26499999, { range = 0.55000001 })
nq.wastebasket.use_pnt_x = 0.264595
nq.wastebasket.use_pnt_y = 0.71353102
nq.wastebasket.use_pnt_z = 0
nq.wastebasket.use_rot_x = 0
nq.wastebasket.use_rot_y = -317.17899
nq.wastebasket.use_rot_z = 0
nq.wastebasket.lookAt = function(arg1) -- line 713
    if not arg1.searched then
        START_CUT_SCENE("no head")
        manny:head_look_at(arg1)
        manny:walkto(arg1)
        manny:wait_for_actor()
        manny:play_chore(msb_reach_med, manny.base_costume)
        sleep_for(300)
        start_sfx("nqGarbCn.wav")
        sleep_for(450)
        manny:blend(msb_hold, msb_reach_med, 1000, manny.base_costume)
        manny:wait_for_chore()
        arg1.searched = TRUE
        nq.photo:get()
        manny:head_look_at(nil)
        manny.is_holding = nq.photo
        if manny.fancy then
            manny:play_chore_looping(mcc_thunder_activate_lsa_photo, manny.base_costume)
            manny.hold_chore = mcc_thunder_activate_lsa_photo
        else
            manny:play_chore_looping(msb_activate_lsa_photo, "msb.cos")
            manny.hold_chore = msb_activate_lsa_photo
        end
        manny:play_chore_looping(msb_hold, manny.base_costume)
        wait_for_sound("nqGarbCn.wav")
        manny:say_line("/nqma021/")
        manny:setrot(0, 81.2567, 0, TRUE)
        manny:wait_for_actor()
        look_at_item_in_hand(TRUE)
        manny:wait_for_message()
        END_CUT_SCENE()
    else
        manny:say_line("/nqma019/")
    end
end
nq.wastebasket.use = nq.wastebasket.lookAt
nq.wastebasket.searched = FALSE
nq.wastebasket.pickUp = function(arg1) -- line 753
    arg1:lookAt()
end
nq.wastebasket.use_note = function(arg1) -- line 757
    manny:say_line("/nqma065/")
end
nq.wastebasket.use_hand = function(arg1) -- line 761
    manny:say_line("/nqma066/")
end
nq.wastebasket.use_lsa_photo = function(arg1) -- line 765
    if little_manny.dead then
        manny:walkto(arg1)
        manny:say_line("/nqma067/")
        manny:wait_for_actor()
        manny:play_chore(msb_reach_med, manny.base_costume)
        manny:stop_chore(msb_hold, manny.base_costume)
        sleep_for(750)
        manny:stop_chore(manny.hold_chore, manny.base_costume)
        nq.photo:put_in_limbo()
        manny:wait_for_chore()
        manny.is_holding = nil
    else
        manny:say_line("/nqma068/")
    end
end
nq.photo = Object:create(nq, "/nqtx020/lsa_photo", 0, 0, 0, { range = 0 })
nq.photo.wav = "getCard.wav"
nq.photo.lookAt = function(arg1) -- line 786
    manny:say_line("/nqma021/")
end
nq.photo.use = nq.photo.lookAt
nq.photo.default_response = function(arg1) -- line 792
    manny:say_line("/nqma069/")
end
nq.radio = Object:create(nq, "/nqtx022/radio", 0.12, 0.210196, 0.33000001, { range = 0.60000002 })
nq.radio.use_pnt_x = 0.320077
nq.radio.use_pnt_y = 0.25619501
nq.radio.use_pnt_z = 0
nq.radio.use_rot_x = 0
nq.radio.use_rot_y = -3127.02
nq.radio.use_rot_z = 0
nq.radio.lookAt = function(arg1) -- line 804
    manny:say_line("/nqma023/")
end
nq.radio.pickUp = function(arg1) -- line 808
    system.default_response("martialed")
end
nq.radio.use = function(arg1) -- line 812
    if not arg1.tried then
        arg1.tried = TRUE
        manny:say_line("/nqma070/")
        wait_for_message()
        manny:say_line("/nqma024/")
        wait_for_message()
        salvador:say_line("/nqsa025/")
        wait_for_message()
        manny:say_line("/nqma026/")
        wait_for_message()
        olivia:say_line("/nqol027/")
    else
        manny:say_line("/nqma028/")
        wait_for_message()
        manny:say_line("/nqma029/")
    end
end
nq.memo = Object:create(nq, "/nqtx071/memo", 0.079999998, -0.28003299, 0.36000001, { range = 0.60000002 })
nq.memo.use_pnt_x = 0.28
nq.memo.use_pnt_y = -0.210033
nq.memo.use_pnt_z = 0
nq.memo.use_rot_x = 0
nq.memo.use_rot_y = 829.59497
nq.memo.use_rot_z = 0
nq.memo.lookAt = function(arg1) -- line 839
    manny:say_line("/nqma072/")
    wait_for_message()
    manny:say_line("/nqma073/")
    wait_for_message()
    manny:say_line("/nqma074/")
end
nq.memo.pickUp = function(arg1) -- line 847
    system.default_response("nah")
end
nq.memo.use = nq.memo.lookAt
nq.remains = Object:create(nq, "/nqtx075/remains", 0.628353, -0.083236001, 0, { range = 0.60000002 })
nq.remains.use_pnt_x = 0.72854501
nq.remains.use_pnt_y = -0.23227701
nq.remains.use_pnt_z = 0
nq.remains.use_rot_x = 0
nq.remains.use_rot_y = -325.54999
nq.remains.use_rot_z = 0
nq.remains.lookAt = function(arg1) -- line 862
    manny:say_line("/nqma076/")
end
nq.remains.pickUp = function(arg1) -- line 866
    START_CUT_SCENE()
    if not nq.picked_up_arm then
        nq.picked_up_arm = TRUE
        preload_sfx("nqArmRip.wav")
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:play_chore(msb_reach_low, manny.base_costume)
        sleep_for(1000)
        start_sfx("nqArmRip.wav")
        arm_actor:free()
        nq.picked_up_arm = TRUE
        nq.arm:get()
        manny:stop_chore(msb_reach_low, manny.base_costume)
        if manny.fancy then
            manny:play_chore_looping(mcc_thunder_activate_hand, manny.base_costume)
        else
            manny:play_chore_looping(msb_activate_hand, "msb.cos")
        end
        manny:play_chore_looping(msb_hold, manny.base_costume)
        manny:wait_for_chore(msb_reach_low, manny.base_costume)
        manny.is_holding = nq.arm
        manny.hold_chore = msb_activate_hand
        manny:say_line("/nqma077/")
    else
        manny:say_line("/nqma078/")
    end
    END_CUT_SCENE()
end
nq.remains.use_hand = function(arg1) -- line 899
    nq.wastebasket:use_hand()
end
nq.remains.use = nq.remains.pickUp
nq.arm = Object:create(nq, "/nqtx079/arm", 0, 0, 0, { range = 0 })
nq.arm.string_name = "hand"
nq.arm.wav = "getBone.wav"
nq.arm.lookAt = function(arg1) -- line 910
    manny:say_line("/nqma080/")
end
nq.arm.use = function(arg1) -- line 914
    START_CUT_SCENE()
    manny:say_line("/nqma081/")
    if manny.fancy then
        manny:stop_chore(mcc_thunder_activate_hand, manny.base_costume)
        manny:stop_chore(mcc_thunder_hold, manny.base_costume)
        manny:run_chore(mcc_thunder_salute, manny.base_costume)
        manny:stop_chore(mcc_thunder_salute, manny.base_costume)
        manny:play_chore(mcc_thunder_activate_hand, manny.base_costume)
        manny:play_chore_looping(mcc_thunder_hold, manny.base_costume)
    else
        manny:stop_chore(msb_activate_hand, manny.base_costume)
        manny:stop_chore(msb_hold, manny.base_costume)
        manny:run_chore(msb_salute, manny.base_costume)
        manny:stop_chore(msb_salute, manny.base_costume)
        manny:play_chore(msb_activate_hand, manny.base_costume)
        manny:play_chore_looping(msb_hold, manny.base_costume)
    end
    END_CUT_SCENE()
end
nq.arm.default_response = function(arg1) -- line 935
    manny:say_line("/nqma082/")
end
nq.tape_recorder = Object:create(nq, "/nqtx083/tape recorder", -0.76247901, -0.049222901, 0.30000001, { range = 0.60000002 })
nq.tape_recorder.use_pnt_x = -0.53847998
nq.tape_recorder.use_pnt_y = -0.025222899
nq.tape_recorder.use_pnt_z = 0
nq.tape_recorder.use_rot_x = 0
nq.tape_recorder.use_rot_y = 93.250999
nq.tape_recorder.use_rot_z = 0
nq.tape_recorder.lookAt = function(arg1) -- line 949
    manny:say_line("/nqma084/")
end
nq.tape_recorder.pickUp = function(arg1) -- line 953
    system.default_response("attached")
end
nq.tape_recorder.use = function(arg1) -- line 957
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(msb_hand_on_obj, manny.base_costume)
        manny:wait_for_chore()
        start_sfx("nqTapeOn.imu", 64)
        ImSetVoiceEffect("Intercom Filter")
        arg1:play_chore_looping(nq_tape_play)
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
        sleep_for(500)
        bowlsley:say_line("/nqbl085/")
        sleep_for(2000)
        manny:twist_head_gesture()
        wait_for_message()
        hector:say_line("/nqhe086/")
        wait_for_message()
        hector:say_line("/nqhe087/")
        wait_for_message()
        bowlsley:say_line("/nqbl088/")
        manny:play_chore(msb_hand_on_obj, manny.base_costume)
        manny:wait_for_chore()
        arg1:stop_chore(nq_tape_play)
        arg1:play_chore(nq_take_stop)
        stop_sound("nqTapeOn.imu", 64)
        start_sfx("nqTapeOf.wav", 64)
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
        manny:wait_for_chore()
        bowlsley:wait_for_message()
        ImSetVoiceEffect("OFF")
        END_CUT_SCENE()
    end
end
nq.eva_obj = Object:create(nq, "/nqtx089/Eva", -0.23578, -0.0184035, 0.42789999, { range = 0.60000002 })
nq.eva_obj.use_pnt_x = -0.52827197
nq.eva_obj.use_pnt_y = -0.22375099
nq.eva_obj.use_pnt_z = 0
nq.eva_obj.use_rot_x = 0
nq.eva_obj.use_rot_y = -56.860802
nq.eva_obj.use_rot_z = 0
nq.eva_obj.lookAt = function(arg1) -- line 1000
    manny:say_line("/nqma090/")
    wait_for_message()
    eva:say_line("/nqev091/")
end
nq.eva_obj.pickUp = function(arg1) -- line 1006
    if nq.meche_obj.touchable then
        manny:say_line("/nqma092/")
    else
        manny:say_line("/moma032/")
    end
end
nq.eva_obj.use = function(arg1) -- line 1015
    START_CUT_SCENE()
    manny:say_line("/nqma093/")
    wait_for_message()
    eva:say_line("/nqev094/")
    wait_for_message()
    eva:say_line("/nqev095/")
    END_CUT_SCENE()
end
nq.eva_obj.use_lsa_photo = function(arg1) -- line 1025
    eva:say_line("/nqev096/")
end
nq.eva_obj.use_hand = function(arg1) -- line 1029
    START_CUT_SCENE()
    manny:walkto(-0.448578, -0.172294, 0, 0, 325.747, 0)
    manny:wait_for_actor()
    manny:say_line("/lrma008/")
    manny:use_default()
    END_CUT_SCENE()
    eva:say_line("/nqev097/")
end
nq.lw_door = Object:create(nq, "/nqtx030/exit", 0.97356099, 2.04339, 0.40000001, { range = 0.89999998 })
nq.lw_door.use_pnt_x = 0.68856102
nq.lw_door.use_pnt_y = 2.1083901
nq.lw_door.use_pnt_z = -0.050000001
nq.lw_door.use_rot_x = 0
nq.lw_door.use_rot_y = -74.121902
nq.lw_door.use_rot_z = 0
nq.lw_door.out_pnt_x = 0.93735403
nq.lw_door.out_pnt_y = 2.14853
nq.lw_door.out_pnt_z = -0.050000001
nq.lw_door.out_rot_x = 0
nq.lw_door.out_rot_y = -88.498001
nq.lw_door.out_rot_z = 0
nq.lw_door:make_untouchable()
nq.lw_door.walkOut = function(arg1) -- line 1075
    if nq.meche_obj.touchable then
        nq.the_plan()
    else
        lw:come_out_door(lw.nq_door)
    end
end
CheckFirstTime("su.lua")
su = Set:create("su.set", "sunken lola", { su_chews = 0, su_ovrhd = 1 })
dofile("chepito.lua")
dofile("mn_ctm.lua")
dofile("mn_ctc.lua")
su.chepito_to_manny = function(arg1) -- line 16
    local local1 = manny:getpos()
    local local2 = chepito:getpos()
    while TurnActorTo(chepito.hActor, local1.x, local1.y, local1.z) do
        break_here()
    end
    chepito:head_look_at_manny()
    while TurnActorTo(manny.hActor, local2.x, local2.y, local2.z) do
        break_here()
    end
end
su.manny_to_chepito = function(arg1) -- line 62
    local local1 = { }
    local local2, local3
    local local4 = { x = 0.28582701, y = -0.142896, z = 0 }
    while 1 do
        local1 = chepito:getrot()
        local3 = RotateVector(local4, local1)
        local2 = chepito:getpos()
        local3.x = local3.x + local2.x
        local3.y = local3.y + local2.y
        local3.z = local3.z + local2.z
        chepito:setpos(manny:getpos())
        chepito:setrot(manny:getrot())
        break_here()
    end
end
su.chepito_proximity = function(arg1, arg2, arg3) -- line 83
    local local1 = chepito:getpos()
    local local2 = sqrt((local1.x - arg1) ^ 2 + (local1.y - arg2) ^ 2 + (local1.z - arg3) ^ 2)
    return local2
end
su.chepito_to_start = function() -- line 90
    while TurnActorTo(chepito.hActor, chepito.start_position.x, chepito.start_position.y, chepito.start_position.z) do
        break_here()
    end
    while su.chepito_proximity(chepito.start_position.x, chepito.start_position.y, chepito.start_position.z) >= 0.05 do
        PointActorAt(chepito.hActor, chepito.start_position.x, chepito.start_position.y, chepito.start_position.z)
        chepito:walk_forward()
        break_here()
    end
    chepito:setpos(chepito.start_position.x, chepito.start_position.y, chepito.start_position.z)
    chepito:follow_boxes()
end
su.sink_aftermath = function(arg1) -- line 107
    local local1 = 4.5
    START_CUT_SCENE()
    set_override(su.sink_aftermath_override)
    manny:default("nautical")
    manny:put_in_set(su)
    manny:ignore_boxes()
    glottis:set_costume("glottis_sailor.cos")
    glottis:set_talk_color(Orange)
    glottis:set_visibility(TRUE)
    glottis:set_head(3, 4, 4, 165, 28, 80)
    glottis:set_mumble_chore(glottis_sailor_mumble)
    glottis:set_talk_chore(1, glottis_sailor_stop_talk)
    glottis:set_talk_chore(2, glottis_sailor_a)
    glottis:set_talk_chore(3, glottis_sailor_c)
    glottis:set_talk_chore(4, glottis_sailor_e)
    glottis:set_talk_chore(5, glottis_sailor_f)
    glottis:set_talk_chore(6, glottis_sailor_l)
    glottis:set_talk_chore(7, glottis_sailor_m)
    glottis:set_talk_chore(8, glottis_sailor_o)
    glottis:set_talk_chore(9, glottis_sailor_t)
    glottis:set_talk_chore(10, glottis_sailor_u)
    glottis:push_costume("gl_sailor_fastwalk.cos")
    glottis:head_look_at(nil)
    glottis:set_walk_chore(0, "gl_sailor_fastwalk.cos")
    glottis:set_walk_rate(0.5)
    glottis:put_in_set(su)
    manny:ignore_boxes()
    glottis:ignore_boxes()
    glottis:setpos(100, 100, 100)
    manny:setpos(100, 100, 100)
    start_sfx("current.imu", IM_HIGH_PRIORITY, 0)
    fade_sfx("current.imu", 2000, 80)
    manny:push_costume("mn_jump_sub.cos")
    glottis:push_costume("gl_jump_sub.cos")
    break_here()
    PreRender(TRUE, FALSE)
    manny:play_chore(0, "mn_jump_sub.cos")
    glottis:play_chore(0, "gl_jump_sub.cos")
    break_here()
    manny:follow_boxes()
    manny:setpos(-0.536861, -4.0693498, 0)
    manny:setrot(0, 227, 0)
    glottis:setpos(-0.120987, -3.50214, 0)
    glottis:setrot(0, 180, 0)
    glottis:follow_boxes()
    sleep_for(6400)
    fade_sfx("current.imu", 800)
    sleep_for(6000)
    manny:wait_for_chore(0, "mn_jump_sub.cos")
    manny:pop_costume()
    glottis:blend(glottis_sailor_home_pose, 0, 800, "glottis_sailor.cos", "gl_jump_sub.cos")
    sleep_for(800)
    glottis:pop_costume()
    PreRender(TRUE, TRUE)
    ForceRefresh()
    start_script(su.glottis_follow_manny)
    glottis:say_line("/sugl091/")
    wait_for_message()
    glottis:say_line("/sugl092/")
    wait_for_message()
    glottis:say_line("/sugl093/")
    wait_for_message()
    glottis:say_line("/sugl094/")
    wait_for_message()
    glottis:say_line("/sugl095/")
    wait_for_message()
    manny:say_line("/suma096/")
    wait_for_message()
    glottis:say_line("/sugl097/")
    wait_for_message()
    manny:say_line("/suma098/")
    wait_for_message()
    manny:say_line("/suma099/")
    wait_for_message()
    END_CUT_SCENE()
    glottis:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(glottis.hActor, 0.5)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(chepito.hActor, 0.44999999)
    SetActorCollisionScale(manny.hActor, 0.34999999)
    kill_override()
end
su.sink_aftermath_override = function() -- line 202
    kill_override()
    PreRender(TRUE, TRUE)
    ForceRefresh()
    manny:put_in_set(su)
    manny:default("nautical")
    manny:follow_boxes()
    manny:setpos(-0.536861, -4.06935, 0)
    manny:setrot(0, 227, 0)
    glottis:set_costume("glottis_sailor.cos")
    glottis:set_talk_color(Orange)
    glottis:set_visibility(TRUE)
    glottis:set_head(3, 4, 4, 165, 28, 80)
    glottis:set_mumble_chore(glottis_sailor_mumble)
    glottis:set_talk_chore(1, glottis_sailor_stop_talk)
    glottis:set_talk_chore(2, glottis_sailor_a)
    glottis:set_talk_chore(3, glottis_sailor_c)
    glottis:set_talk_chore(4, glottis_sailor_e)
    glottis:set_talk_chore(5, glottis_sailor_f)
    glottis:set_talk_chore(6, glottis_sailor_l)
    glottis:set_talk_chore(7, glottis_sailor_m)
    glottis:set_talk_chore(8, glottis_sailor_o)
    glottis:set_talk_chore(9, glottis_sailor_t)
    glottis:set_talk_chore(10, glottis_sailor_u)
    glottis:push_costume("gl_sailor_fastwalk.cos")
    glottis:head_look_at(nil)
    glottis:set_walk_chore(0, "gl_sailor_fastwalk.cos")
    glottis:set_walk_rate(0.5)
    glottis:put_in_set(su)
    glottis:setpos(-0.120987, -3.50214, 0)
    glottis:setrot(0, 180, 0)
    glottis:follow_boxes()
    glottis:play_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
    glottis:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(glottis.hActor, 0.5)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(chepito.hActor, 0.45)
    SetActorCollisionScale(manny.hActor, 0.35)
    stop_sound("current.imu")
    start_script(su.glottis_follow_manny)
end
su.move_chepito_obj = function() -- line 249
    local local1 = { }
    while 1 do
        local1 = chepito:getpos()
        su.moving_chepito_obj.interest_actor:setpos(local1.x, local1.y, local1.z + 0.40000001)
        if hot_object == su.moving_chepito_obj then
            manny:head_look_at(su.moving_chepito_obj)
        end
        break_here()
    end
end
su.chepito_sing = function(arg1, arg2) -- line 262
    chepito.fade_cue = FALSE
    wait_for_message()
    chepito:say_line("/such100/")
    chepito:wait_for_message()
    chepito:say_line("/such101/")
    chepito:wait_for_message()
    chepito:say_line("/such102/")
    chepito:wait_for_message()
    chepito:say_line("/such103/")
    chepito:wait_for_message()
    chepito:say_line("/such104/")
    chepito:wait_for_message()
    chepito:say_line("/such105/")
    chepito.fade_cue = TRUE
    chepito:wait_for_message()
    chepito:say_line("/such107/")
    chepito:wait_for_message()
    chepito:say_line("/such108/")
    chepito:wait_for_message()
    chepito:say_line("/such109/")
    chepito:wait_for_message()
    chepito:say_line("/such110/")
    chepito:wait_for_message()
    chepito:say_line("/such111/")
    chepito:wait_for_message()
    chepito:say_line("/such112/")
    chepito:wait_for_message()
    chepito:say_line("/such113/")
    chepito:wait_for_message()
    if arg2 then
        start_script(su.glottis_sing)
        glottis:set_speech_mode(MODE_BACKGROUND)
    end
    chepito:say_line("/such121/")
    chepito:wait_for_message()
    chepito:say_line("/such122/")
    chepito:wait_for_message()
    chepito:say_line("/such123/")
    chepito:wait_for_message()
    chepito:say_line("/such125/")
    chepito:wait_for_message()
    chepito:say_line("/such126/")
    chepito:wait_for_message()
    chepito:say_line("/such127/")
    chepito:wait_for_message()
    sleep_for(3000)
    chepito:say_line("/such114/")
    chepito:wait_for_message()
    chepito:say_line("/such116/")
    chepito:wait_for_message()
    chepito:say_line("/such117/")
    chepito:wait_for_message()
    chepito:say_line("/such118/")
    chepito:wait_for_message()
    chepito:say_line("/such120/")
end
su.glottis_sing = function() -- line 334
    glottis:say_line("/sugl128/")
    glottis:wait_for_message()
    glottis:say_line("/sugl129/")
    glottis:wait_for_message()
    glottis:say_line("/sugl130/")
    glottis:wait_for_message()
    glottis:say_line("/sugl131/")
    glottis:wait_for_message()
    glottis:say_line("/sugl132/")
    glottis:wait_for_message()
    glottis:say_line("/sugl133/")
    glottis:wait_for_message()
    glottis:say_line("/sugl134/")
end
su.chepito_orbit = function() -- line 350
    while 1 do
        su.glottis_look_chepito = TRUE
        if not chepito.seen then
            start_sfx("rfPigMus.imu")
            chepito.seen = TRUE
            glottis:say_line("/sugl135/")
            wait_for_message()
            glottis:say_line("/sugl136/")
        end
        local local1 = 0
        if not chepito.just_talked then
            chepito.just_talked = FALSE
            repeat
                local1 = local1 + PerSecond(0.30000001)
                if local1 > 1 then
                    local1 = 1
                end
                SetLightIntensity("chepito_light", local1)
                break_here()
            until local1 == 1
        end
        chepito:walkto(3.8, -5.4790602, 0)
        while not chepito:find_sector_name("chepito_visible") and chepito:is_moving() do
            break_here()
        end
        if sound_playing("rfPigMus.imu") then
            fade_sfx("rfPigMus.imu")
        end
        su.moving_chepito_obj:make_touchable()
        while chepito:find_sector_name("chepito_visible") do
            break_here()
        end
        local local2 = 1
        local local3 = 127
        repeat
            local2 = local2 - PerSecond(0.33000001)
            local3 = local3 - PerSecond(42)
            if local2 < 0 then
                local2 = 0
            end
            SetLightIntensity("chepito_light", local2)
            chepito.saylineTable.vol = local3
            break_here()
        until local2 == 0
        su.glottis_look_chepito = FALSE
        su.moving_chepito_obj:make_untouchable()
        stop_script(su.chepito_sing)
        chepito.saylineTable.vol = nil
        su.chepito_mad = FALSE
        wait_for_message()
        if not chepito.met and not su.talked_spooky then
            su.talked_spooky = TRUE
            glottis:say_line("/sugl137/")
        end
        chepito:wait_for_actor()
        sleep_for(5000)
        chepito:setpos(7.8699999, 3.7, 0)
        chepito:walkto(3.0699999, 9.3500004, 0)
        chepito:wait_for_actor()
        chepito:setpos(-9.8000002, 39, 3)
        chepito:walkto(-26.799999, 38, 3)
        chepito:wait_for_actor()
        sleep_for(5000)
        chepito:default()
        chepito.knows_manny = FALSE
        chepito.just_talked = FALSE
        chepito:setpos({ x = -2.66886, y = -5.3533502, z = 0 })
        chepito:setrot(0, 448.375, 0)
    end
end
su.chepito_light = function(arg1) -- line 433
    local local1 = { }
    local local2, local3, local4
    while 1 do
        if GetActorRect(chepito.hActor) ~= nil then
            local2, local3, local4 = GetActorNodeLocation(chepito.hActor, 12)
            SetLightPosition("chepito_light", local2, local3, local4)
        else
            local1 = chepito:getpos()
            SetLightPosition("chepito_light", local1.x, local1.y, local1.z + 0.5)
        end
        break_here()
    end
end
su.stop_chepito = function(arg1) -- line 448
    if su.chepito_mad then
        manny:say_line("/suma138/")
        wait_for_message()
        chepito:say_line("/such139/")
    elseif find_script(su.dangle_bait) then
        stop_script(su.dangle_bait)
        stop_script(su.chepito_sing)
        su.lantern:make_untouchable()
        manny:say_line("/suma140/")
        Dialog:run("cp1", "dlg_chepito.lua")
    else
        manny:say_line("/suma141/")
        if proximity(manny, chepito) < 1.5 then
            stop_script(su.chepito_orbit)
            stop_script(su.move_chepito_obj)
            chepito:stop_walk()
            Dialog:run("cp1", "dlg_chepito.lua")
        else
            wait_for_message()
            manny:say_line("/suma142/")
        end
    end
end
su.dangle_bait = function() -- line 477
    local local1, local2, local3
    chepito:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    start_script(su.chepito_sing)
    chepito:walkto(0.77413899, -3.7153499, 0, 0, 135.5, 0)
    chepito:wait_for_actor()
    local local4 = 0
    stop_script(su.glottis_follow_manny)
    local1, local2, local3 = GetActorNodeLocation(chepito.hActor, 12)
    su.lantern:make_touchable()
    su.lantern.interest_actor:setpos(local1, local2, local3)
    su.moving_chepito_obj:make_untouchable()
    repeat
        glottis:head_look_at(chepito)
        chepito:play_chore(cheptio_2conv)
        sleep_for(2000)
        glottis:head_look_at_manny()
        chepito:play_chore(cheptio_2base)
        sleep_for(2000)
        local4 = local4 + 1
    until local4 == 3
    su.lantern:make_untouchable()
    chepito:walkto(1.31036, -5.4790602, 0)
    single_start_script(su.chepito_orbit)
    single_start_script(su.move_chepito_obj)
    single_start_script(su.glottis_follow_manny)
end
su.cpos = { }
su.crot = { }
su.grab_lantern = function() -- line 513
    local local1 = { }
    local local2
    START_CUT_SCENE()
    manny:walkto(0.44378, -3.6732299, 0, 0, -160.394, 0)
    manny:wait_for_actor()
    while chepito:is_moving() do
        break_here()
    end
    local local3 = start_script(su.glottis_to_manny)
    stop_script(su.dangle_bait)
    stop_script(su.chepito_sing)
    manny:push_costume("mn_ctm.cos")
    manny:play_chore(mn_ctm_grabs_ct)
    local1 = manny:getpos()
    local2 = manny:getrot()
    su.cpos = chepito:getpos()
    su.crot = chepito:getrot()
    chepito:setpos(local1)
    chepito:setrot(local2)
    chepito:push_costume("mn_ctc.cos")
    chepito:play_chore(mn_ctm_grabs_ct)
    manny:wait_for_chore()
    chepito:wait_for_chore()
    manny:stop_chore(mn_ctm_grabs_ct)
    chepito:stop_chore(mn_ctm_grabs_ct)
    manny:play_chore_looping(mn_ctm_hold_ct)
    chepito:play_chore_looping(mn_ctm_hold_ct)
    wait_for_script(local3)
    start_script(manny_head_look_at_glottis)
    su.lantern:make_untouchable()
    END_CUT_SCENE()
    lantern_save_handler = system.buttonHandler
    system.buttonHandler = suButtonHandler
    chepito:say_line("/such143/")
    wait_for_message()
    chepito:say_line("/such144/")
    wait_for_message()
    chepito:say_line("/such145/")
    wait_for_message()
    chepito:say_line("/such146/")
    wait_for_message()
    START_CUT_SCENE()
    su.moving_chepito_obj:make_untouchable()
    su.lantern:make_untouchable()
    chepito:set_chore_looping(mn_ctc_hold_ct, FALSE)
    manny:set_chore_looping(mn_ctm_hold_ct, FALSE)
    chepito:wait_for_chore()
    chepito:play_chore(mn_ctc_ct_struggle)
    manny:play_chore(mn_ctc_ct_struggle)
    chepito:wait_for_chore()
    chepito:setpos(su.cpos)
    chepito:setrot(su.crot)
    chepito:pop_costume()
    chepito:play_chore(chepito_break_free)
    sleep_for(900)
    manny:stop_chore(mn_ctc_ct_struggle)
    chepito:wait_for_chore()
    manny:pop_costume()
    if not su.tried_grab then
        su.tried_grab = TRUE
        chepito:say_line("/such147/")
    else
        chepito:say_line("/such148/")
    end
    wait_for_message()
    su.chepito_mad = TRUE
    chepito:walkto(1.31036, -5.4790602, 0)
    single_start_script(su.chepito_orbit)
    single_start_script(su.move_chepito_obj)
    chepito:say_line("/such149/")
    system.buttonHandler = lantern_save_handler
    END_CUT_SCENE()
end
su.give_chepito_to_glottis = function() -- line 598
    START_CUT_SCENE()
    stop_script(su.grab_lantern)
    stop_script(su.glottis_follow_manny)
    glottis:head_look_at(nil)
    glottis:stop_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
    glottis:push_costume("gl_grab_ct.cos")
    manny:set_chore_looping(mn_ctm_hold_ct, FALSE)
    chepito:set_chore_looping(mn_ctm_hold_ct, FALSE)
    manny:wait_for_chore()
    manny:stop_chore(mn_ctm_hold_ct)
    chepito:stop_chore(mn_ctm_hold_ct)
    manny:play_chore(mn_ctm_handoff_ct)
    chepito:play_chore(mn_ctm_handoff_ct)
    glottis:play_chore(0)
    chepito:say_line("/such172/")
    manny:wait_for_chore()
    manny:pop_costume()
    chepito:free()
    glottis:wait_for_chore()
    glottis:say_line("/sugl173/")
    wait_for_message()
    manny:say_line("/suma174/")
    MakeSectorActive("uber_sektor", TRUE)
    start_script(manny.walkto, manny, -3.52772, 0.790292, 0)
    wait_for_message()
    PreRender(TRUE, FALSE)
    glottis:set_walk_chore(2, "gl_grab_ct.cos")
    glottis:set_rest_chore(1, "gl_grab_ct.cos")
    start_script(glottis.walkto, glottis, -3.52772, 0.790292, 0)
    chepito:say_line("/such175/")
    wait_for_message()
    manny:say_line("/suma176/")
    wait_for_message()
    IrisDown(200, 345, 1000)
    sleep_for(1000)
    END_CUT_SCENE()
    system.buttonHandler = lantern_save_handler
    PreRender(TRUE, TRUE)
    start_script(cut_scene.thepearl)
end
su.turn_right = function() -- line 643
    START_CUT_SCENE()
    stop_script(su.grab_lantern)
    chepito:set_chore_looping(mn_ctc_hold_ct, FALSE)
    manny:set_chore_looping(mn_ctm_hold_ct, FALSE)
    chepito:wait_for_chore()
    chepito:play_chore(mn_ctc_ct_struggle)
    manny:play_chore(mn_ctc_ct_struggle)
    chepito:wait_for_chore()
    chepito:setpos(0.44378, -3.67323, 0)
    chepito:setrot(0, -160.394, 0)
    chepito:pop_costume()
    chepito:play_chore(chepito_break_free)
    sleep_for(900)
    manny:stop_chore(mn_ctc_ct_struggle)
    chepito:wait_for_chore()
    chepito:stop_chore(chepito_break_free)
    chepito:setpos(0.754139, -3.71535, 0)
    chepito:setrot(0, 150.5, 0)
    manny:pop_costume()
    if not su.tried_grab then
        su.tried_grab = TRUE
        chepito:say_line("/such147/")
    else
        chepito:say_line("/such148/")
    end
    wait_for_message()
    su.chepito_mad = TRUE
    chepito:walkto(1.31036, -5.47906, 0)
    single_start_script(su.chepito_orbit)
    single_start_script(su.move_chepito_obj)
    chepito:say_line("/such149/")
    system.buttonHandler = lantern_save_handler
    END_CUT_SCENE()
end
su.set_up_actors = function(arg1) -- line 685
    chepito:default()
    chepito:put_in_set(su)
    chepito:follow_boxes()
    chepito:setpos({ x = -2.66886, y = -5.35335, z = 0 })
    chepito:setrot(0, 448.375, 0)
    chepito:set_rest_chore(chepito_base)
    chepito.start_position = { }
end
suButtonHandler = function(arg1, arg2, arg3) -- line 696
    if arg1 == EKEY and controlKeyDown and arg2 then
        start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.TURN_RIGHT[arg1] and arg2 and cutSceneLevel <= 0 then
        start_script(su.give_chepito_to_glottis)
    elseif control_map.TURN_LEFT[arg1] and arg2 and cutSceneLevel <= 0 then
        start_script(su.give_chepito_to_glottis)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
manny_head_look_at_glottis = function() -- line 710
    local local1 = { }
    local1 = glottis:getpos()
    manny:head_look_at(local1.x, local1.y, local1.z + 1.2)
end
su.glottis_to_manny = function(arg1) -- line 717
    local local1 = { }
    local local2, local3
    local local4 = { x = 0.80189598, y = 0.00076497701, z = 0 }
    local1 = manny:getrot()
    local3 = RotateVector(local4, local1)
    local2 = manny:getpos()
    local3.x = local3.x + local2.x
    local3.y = local3.y + local2.y
    local3.z = local3.z + local2.z
    glottis:setrot(0, 190, 0)
end
su.glottis_follow_manny = function(arg1) -- line 736
    local local1 = { }
    while 1 do
        if su.glottis_look_chepito then
            glottis:head_look_at(chepito)
        else
            glottis:head_look_at_manny()
        end
        break_here()
    end
end
su.test = function() -- line 754
    chepito:default()
    chepito:ignore_boxes()
    manny:push_costume("chepito.cos")
    glottis:push_costume("mn_ctc.cos")
    chepito:play_chore_looping(chepito_break_free)
    while 1 do
        break_here()
    end
    manny:play_chore(2)
    chepito:play_chore(chepito_grabs)
    manny:wait_for_chore()
    manny:stop_chore(2)
    manny:play_chore(3)
    manny:wait_for_chore()
    manny:stop_chore(3)
    manny:play_chore(4)
    manny:wait_for_chore()
    manny:stop_chore(4)
    manny:play_chore(5)
    manny:wait_for_chore()
    manny:stop_chore(5)
    chepito:wait_for_chore()
end
su.enter = function(arg1) -- line 796
    su:set_up_actors()
    manny:put_in_set(su)
    manny:follow_boxes()
    MakeSectorActive("uber_sektor", FALSE)
    manny:setpos(-0.0379301, -3.35008, 0)
    manny:setrot(0, 176.765, 0)
    start_script(su.sink_aftermath)
    SetLightPosition("chepito_light", -0.326861, -5.15835, 0.564)
    SetLightIntensity("chepito_light", 0)
    su:add_ambient_sfx(underwater_ambience_list, underwater_ambience_parm_list)
end
su.exit = function(arg1) -- line 812
    chepito:free()
    stop_sound("bubvox.imu")
    stop_script(su.chepito_orbit)
    stop_script(su.move_chepito_obj)
    stop_script(su.chepito_light)
    stop_script(su.glottis_follow_manny)
end
su.ring1 = { }
su.ring1.walkOut = function(arg1) -- line 827
    START_CUT_SCENE("no head")
    MakeSectorActive("ring1", FALSE)
    MakeSectorActive("ring2", FALSE)
    MakeSectorActive("ring3", FALSE)
    MakeSectorActive("ring4", FALSE)
    MakeSectorActive("ring5", FALSE)
    MakeSectorActive("ring6", FALSE)
    MakeSectorActive("ring7", FALSE)
    MakeSectorActive("ring8", FALSE)
    MakeSectorActive("ring9", FALSE)
    MakeSectorActive("ring10", FALSE)
    glottis:say_line("/sugl150/")
    wait_for_message()
    manny:head_look_at(glottis)
    glottis:say_line("/sugl151/")
    wait_for_message()
    glottis:say_line("/sugl152/")
    wait_for_message()
    glottis:say_line("/sugl153/")
    wait_for_message()
    manny:head_look_at(nil)
    manny:shrug_gesture()
    manny:say_line("/suma154/")
    wait_for_message()
    manny:say_line("/suma155/")
    END_CUT_SCENE()
    enable_head_control(TRUE)
    sleep_for(5000)
    single_start_script(su.chepito_orbit)
    single_start_script(su.move_chepito_obj)
end
su.ring2 = su.ring1
su.ring3 = su.ring1
su.ring4 = su.ring1
su.ring5 = su.ring1
su.ring6 = su.ring1
su.ring7 = su.ring1
su.ring8 = su.ring1
su.ring9 = su.ring1
su.ring10 = su.ring1
su.lantern = Object:create(su, "/sutx156/lantern", 0, 0, 0, { range = 2 })
su.lantern:make_untouchable()
su.lantern.immediate = TRUE
su.lantern.lookAt = function(arg1) -- line 879
    manny:say_line("/suma157/")
end
su.lantern.pickUp = function(arg1) -- line 883
    start_script(su.grab_lantern)
end
su.lantern.use = su.lantern.pickUp
su.moving_chepito_obj = Object:create(su, "/sutx158/Chepito", 0, 0, 0, { range = 1.5 })
su.moving_chepito_obj.immediate = TRUE
su.moving_chepito_obj:make_untouchable()
su.moving_chepito_obj.lookAt = function(arg1) -- line 894
    manny:say_line("/suma159/")
end
su.moving_chepito_obj.use = function(arg1) -- line 898
    if find_script(su.dangle_bait) then
        su.lantern:pickUp()
    else
        start_script(su.stop_chepito)
    end
end
su.sunken_lola = Object:create(su, "/sutx160/Lola", 0.151732, -3.0110099, 1.63, { range = 1.7 })
su.sunken_lola.use_pnt_x = 0.33173099
su.sunken_lola.use_pnt_y = -3.0310099
su.sunken_lola.use_pnt_z = 0
su.sunken_lola.use_rot_x = 0
su.sunken_lola.use_rot_y = 4.5426698
su.sunken_lola.use_rot_z = 0
su.sunken_lola.lookAt = function(arg1) -- line 915
    manny:say_line("/suma161/")
end
su.sunken_lola.pickUp = function(arg1) -- line 919
    system.default_response("underwater")
end
su.sunken_lola.use = function(arg1) -- line 923
    manny:say_line("/suma162/")
    if not arg1.seen then
        arg1.seen = TRUE
        wait_for_message()
        glottis:say_line("/sugl163/")
        wait_for_message()
        manny:say_line("/suma164/")
        wait_for_message()
        glottis:say_line("/sugl165/")
    end
end
su.glottis_obj = Object:create(su, "/sutx166/Glottis", -0.162861, -3.8013501, 0.759, { range = 1 })
su.glottis_obj.use_pnt_x = -0.403806
su.glottis_obj.use_pnt_y = -3.8994901
su.glottis_obj.use_pnt_z = 0
su.glottis_obj.use_rot_x = 0
su.glottis_obj.use_rot_y = 51.2481
su.glottis_obj.use_rot_z = 0
su.glottis_obj.lookAt = function(arg1) -- line 944
    manny:say_line("/suma167/")
end
su.glottis_obj.pickUp = su.sunken_lola.pickUp
su.glottis_obj.use = function(arg1) -- line 950
    START_CUT_SCENE()
    manny:say_line("/suma168/")
    wait_for_message()
    glottis:say_line("/sugl169/")
    wait_for_message()
    glottis:say_line("/sugl170/")
    wait_for_message()
    manny:say_line("/suma171/")
    END_CUT_SCENE()
end
su.pearl = Object:create(su, "/sutx177/light", -6.7880802, 8.1357002, 1.08, { range = 13.3 })
su.pearl.use_pnt_x = -1.75808
su.pearl.use_pnt_y = -3.5142901
su.pearl.use_pnt_z = 0
su.pearl.use_rot_x = 0
su.pearl.use_rot_y = 45.6399
su.pearl.use_rot_z = 0
su.pearl.lookAt = function(arg1) -- line 972
    manny:say_line("/suma178/")
    wait_for_message()
    manny:say_line("/suma179/")
end
su.pearl.use = function(arg1) -- line 978
    manny:say_line("/suma180/")
end
su.pearl.pickUp = su.pearl.use
glottis_sailor_trans_rock = 0
glottis_sailor_ear_wax = 1
glottis_sailor_trans_home = 2
glottis_sailor_smart_ass = 3
glottis_sailor_rock_loop = 4
glottis_sailor_look_down = 5
glottis_sailor_home_pose = 6
glottis_sailor_flip_ears = 7
glottis_sailor_mumble = 8
glottis_sailor_c = 9
glottis_sailor_f = 10
glottis_sailor_e = 11
glottis_sailor_u = 12
glottis_sailor_t = 13
glottis_sailor_m = 14
glottis_sailor_a = 15
glottis_sailor_o = 16
glottis_sailor_stop_talk = 17
CheckFirstTime("tb.lua")
dofile("doug_idles.lua")
dofile("ma_photopass.lua")
tb = Set:create("tb.set", "track betting", { tb_fotws = 1, tb_strws = 0, tb_strws2 = 0, tb_strws3 = 0, tb_strws4 = 0, tb_overhead = 2 })
tb.show_room = function(arg1) -- line 17
    START_CUT_SCENE()
    cameraman_disabled = FALSE
    manny:walkto(-0.619026, -0.0328044, 0, 0, 272.47, 0)
    manny:wait_for_actor()
    manny:head_look_at_point({ x = 1.84646, y = -0.367253, z = 0.595 })
    manny:say_line("/lyma009/")
    manny:point_gesture()
    manny:wait_for_message()
    manny:walkto(0.723649, -0.690082, 0, 0, 306.381, 0)
    while point_proximity(0.723649, -0.690082, 0) > 0.4 do
        break_here()
    end
    tw:switch_to_set()
    manny:head_look_at(nil)
    manny:put_in_set(tw)
    manny:setpos(0.938004, -0.50864, 0)
    manny:setrot(0, 309.019, 0)
    manny:head_look_at(tw.track)
    manny:walkto(tw.track)
    manny:wait_for_actor()
    tw.track:lookAt()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
tb.crowd_cheer = function(arg1) -- line 43
    local local1
    if arg1 or rndint(100) < 40 then
        local1 = pick_one_of({ "tkCheer1.wav", "tkCheer2.wav", "tkCheer3.wav", "tkCheer4.wav" })
        if system.currentSet == tb then
            vol = 65
        elseif system.currentSet == tw then
            vol = 65
        elseif system.currentSet == ts then
            vol = 80
        elseif system.currentSet == ks then
            vol = 30
        elseif system.currentSet == kh then
            vol = 40
        else
            vol = 0
        end
        if vol > 0 then
            start_sfx(local1, IM_LOW_PRIORITY, vol)
            set_pan(local1, rndint(30, 100))
        end
    end
end
tb.off_screen_kittys = function() -- line 71
    local local1
    local local2
    while 1 do
        sleep_for(rnd(6000, 12000))
        if not cat_race_running then
            local1 = pick_one_of({ "kitty1.wav", "kitty2.wav", "kitty3.wav", "kitty4.wav", "kitty5.wav" })
            if system.currentSet == tb then
                local2 = 30
            elseif system.currentSet == tw then
                local2 = 30
            elseif system.currentSet == ts then
                local2 = 35
            elseif system.currentSet == ks then
                local2 = 45
            elseif system.currentSet == kh then
                local2 = 55
            else
                local2 = 0
            end
            if local2 > 0 then
                start_sfx(local1, IM_LOW_PRIORITY, local2)
                if rnd() then
                    set_pan(local1, 127)
                else
                    set_pan(local1, 1)
                end
            end
        end
        break_here()
    end
end
tb.init_cat_names = function() -- line 106
    local local1 = 0
    cat_names = { }
    repeat
        local1 = local1 + 1
        cat_names[local1] = { name = nil, racing = nil, odds = 3 }
    until local1 == 60
    cat_names[1].name = "/tbta066/"
    cat_names[2].name = "/tbta067/"
    cat_names[3].name = "/tbta068/"
    cat_names[4].name = "/tbta069/"
    cat_names[5].name = "/tbta070/"
    cat_names[6].name = "/tbta071/"
    cat_names[7].name = "/tbta072/"
    cat_names[8].name = "/tbta073/"
    cat_names[9].name = "/tbta074/"
    cat_names[10].name = "/tbta075/"
    cat_names[11].name = "/tbta076/"
    cat_names[12].name = "/tbta077/"
    cat_names[13].name = "/tbta078/"
    cat_names[14].name = "/tbta079/"
    cat_names[15].name = "/tbta080/"
    cat_names[16].name = "/tbta081/"
    cat_names[17].name = "/tbta082/"
    cat_names[18].name = "/tbta083/"
    cat_names[19].name = "/tbta084/"
    cat_names[20].name = "/tbta085/"
    cat_names[21].name = "/tbta086/"
    cat_names[22].name = "/tbta087/"
    cat_names[23].name = "/tbta088/"
    cat_names[24].name = "/tbta089/"
    cat_names[25].name = "/tbta090/"
    cat_names[26].name = "/tbta091/"
    cat_names[27].name = "/tbta092/"
    cat_names[28].name = "/tbta093/"
    cat_names[29].name = "/tbta094/"
    cat_names[30].name = "/tbta095/"
    cat_names[31].name = "/tbta096/"
    cat_names[32].name = "/tbta097/"
    cat_names[33].name = "/tbta098/"
    cat_names[34].name = "/tbta099/"
    cat_names[35].name = "/tbta100/"
    cat_names[36].name = "/tbta101/"
    cat_names[37].name = "/tbta102/"
    cat_names[38].name = "/tbta103/"
    cat_names[39].name = "/tbta104/"
    cat_names[40].name = "/tbta105/"
    cat_names[41].name = "/tbta106/"
    cat_names[42].name = "/tbta107/"
    cat_names[43].name = "/tbta108/"
    cat_names[44].name = "/tbta109/"
    cat_names[45].name = "/tbta110/"
    cat_names[46].name = "/tbta111/"
    cat_names[47].name = "/tbta112/"
    cat_names[48].name = "/tbta113/"
    cat_names[49].name = "/tbta114/"
    cat_names[50].name = "/tbta115/"
    cat_names[51].name = "/tbta116/"
    cat_names[52].name = "/tbta117/"
    cat_names[53].name = "/tbta118/"
    cat_names[54].name = "/tbta119/"
    cat_names[55].name = "/tbta120/"
    cat_names[56].name = "/tbta121/"
    cat_names[57].name = "/tbta122/"
    cat_names[58].name = "/tbta123/"
    cat_names[59].name = "/tbta124/"
    cat_names[60].name = "/tbta125/"
    local1 = 0
    cat_announcements = { }
    repeat
        local1 = local1 + 1
        cat_announcements[local1] = { say = nil, place = nil }
    until local1 == 44
    cat_announcements[1].say = "/tbta126/"
    cat_announcements[2].say = "/tbta127/"
    cat_announcements[3].say = "/tbta128/"
    cat_announcements[4].say = "/tbta129/"
    cat_announcements[5].say = "/tbta130/"
    cat_announcements[6].say = "/tbta131/"
    cat_announcements[7].say = "/tbta132/"
    cat_announcements[8].say = "/tbta133/"
    cat_announcements[9].say = "/tbta134/"
    cat_announcements[10].say = "/tbta135/"
    cat_announcements[11].say = "/tbta136/"
    cat_announcements[12].say = "/tbta137/"
    cat_announcements[13].say = "/tbta142/"
    cat_announcements[14].say = "/tbta143/"
    cat_announcements[15].say = "/tbta144/"
    cat_announcements[15].place = 1
    cat_announcements[16].say = "/tbta145/"
    cat_announcements[16].place = -8
    cat_announcements[17].say = "/tbta146/"
    cat_announcements[17].place = 3
    cat_announcements[18].say = "/tbta147/"
    cat_announcements[18].place = 1
    cat_announcements[19].say = "/tbta148/"
    cat_announcements[19].place = 2
    cat_announcements[20].say = "/tbta149/"
    cat_announcements[20].place = 3
    cat_announcements[21].say = "/tbta150/"
    cat_announcements[21].place = -5
    cat_announcements[22].say = "/tbta151/"
    cat_announcements[22].place = -3
    cat_announcements[23].say = "/tbta152/"
    cat_announcements[23].place = -1
    cat_announcements[24].say = "/tbta153/"
    cat_announcements[24].place = 2
    cat_announcements[25].say = "/tbta154/"
    cat_announcements[25].place = -1
    cat_announcements[26].say = "/tbta155/"
    cat_announcements[26].place = -8
    cat_announcements[27].say = "/tbta156/"
    cat_announcements[27].place = -8
    cat_announcements[28].say = "/tbta157/"
    cat_announcements[28].place = -8
    cat_announcements[29].say = "/tbta158/"
    cat_announcements[29].place = nil
    cat_announcements[30].say = "/tbta159/"
    cat_announcements[30].place = nil
    cat_announcements[31].say = "/tbta160/"
    cat_announcements[31].place = 97
    cat_announcements[32].say = "/tbta161/"
    cat_announcements[32].place = 98
    cat_announcements[33].say = "/tbta162/"
    cat_announcements[33].place = 3
    cat_announcements[34].say = "/tbta163/"
    cat_announcements[34].place = -1
    cat_announcements[35].say = "/tbta164/"
    cat_announcements[35].place = 1
    cat_announcements[36].say = "/tbta165/"
    cat_announcements[36].place = 2
    cat_announcements[37].say = "/tbta166/"
    cat_announcements[37].place = 3
    cat_announcements[38].say = "/tbta167/"
    cat_announcements[38].place = -1
    cat_announcements[39].say = "/tbta170/"
    cat_announcements[39].place = -2
    cat_announcements[40].say = "/tbta171/"
    cat_announcements[40].place = 3
    cat_announcements[41].say = "/tbta172/"
    cat_announcements[41].place = -1
    cat_announcements[42].say = "/tbta173/"
    cat_announcements[42].place = -1
end
time_announcements = { }
time_announcements[1] = "/tbta138/"
time_announcements[2] = "/tbta139/"
time_announcements[3] = "/tbta140/"
time_announcements[4] = "/tbta141/"
tb.NUMBER_OF_CATS = 8
track_announcer = Actor:create(nil, nil, nil, "announcer")
track_announcer.say_line = function(arg1, arg2) -- line 265
    local local1
    if system.currentSet == tb or system.currentSet == hh or system.currentSet == ts or system.currentSet == tw then
        arg1.sfx_boy = nil
        Actor.say_line(arg1, arg2, { background = TRUE, volume = announcer_volume, skip_log = TRUE })
    elseif system.currentSet == hl then
        arg2 = strsub(arg2, 2)
        local1 = strlen(arg2)
        arg2 = strsub(arg2, 1, local1 - 1)
        arg2 = arg2 .. ".wav"
        arg1.sfx_boy = start_sfx(arg2, IM_LOW_PRIORITY, announcer_volume)
    end
end
track_announcer.wait_for_message = function(arg1) -- line 280
    if arg1.sfx_boy then
        wait_for_sound(arg1.sfx_boy)
    else
        while IsMessageGoing(arg1.hActor) do
            break_here()
        end
    end
end
start_cat_sfx = function(arg1, arg2) -- line 291
    start_sfx(arg1)
    set_pan(arg1, 10)
    if system.currentSet == tb or system.currentSet == tw then
        set_vol(arg1, 100)
    elseif system.currentSet == ts then
        set_vol(arg1, 64)
    elseif system.currentSet == hl then
        set_vol(arg1, 20)
    else
        stop_sound(arg1)
    end
    if not arg2 then
        fade_pan_sfx(arg1, 1800, 100)
    end
end
announcer_volume_setting = function() -- line 309
    while 1 do
        if system.currentSet == tb then
            announcer_volume = 90
        elseif system.currentSet == tw then
            announcer_volume = 115
        elseif system.currentSet == ts then
            announcer_volume = 127
        elseif system.currentSet == hl or system.currentSet == hh then
            announcer_volume = 64
        end
        break_here()
    end
end
tb.cat_paws = function() -- line 325
    local local1 = system.currentSet
    local local2 = 0
    while cat_race_running do
        if system.currentSet == tb or system.currentSet == tw then
            local2 = 35
        elseif system.currentSet == ts then
            local2 = 25
        elseif system.currentSet == hl then
            local2 = 14
        else
            if local2 > 0 then
                fade_sfx("twRaceLp.IMU", 300, 0)
            end
            local2 = 0
        end
        if local2 > 0 then
            single_start_sfx("twRaceLp.IMU")
            set_vol("twRaceLp.imu", local2)
        end
        repeat
            break_here()
        until local1 ~= system.current_set
        local1 = system.currentSet
    end
    fade_sfx("twRaceLp.IMU", 500, 0)
end
tb.pre_race_timer = function() -- line 358
    local local1 = 0
    repeat
        local1 = local1 + 1
        tb.race_countdown_announcement = time_announcements[local1]
        sleep_for(60000)
    until local1 == 4
end
tb.init_cat_race = function() -- line 367
    local local1 = 0
    local local2
    local local3, local4
    local local5
    local local6
    cat_racers = { }
    repeat
        local1 = local1 + 1
        cat_racers[local1] = { name = nil, distance = 0, number = nil, odds = nil }
    until local1 == tb.NUMBER_OF_CATS
    local1 = 0
    repeat
        local1 = local1 + 1
        cat_names[local1].racing = nil
    until local1 == 60
    local1 = 0
    repeat
        local1 = local1 + 1
        repeat
            local2 = rndint(1, 60)
            if not cat_names[local2].racing then
                cat_names[local2].racing = TRUE
                cat_racers[local1].name = cat_names[local2].name
                cat_racers[local1].distance = 1
                cat_racers[local1].number = local2
                cat_racers[local1].odds = cat_names[local2].odds
            end
        until cat_racers[local1].name
    until local1 == tb.NUMBER_OF_CATS
end
tb.cat_race_simulator = function() -- line 404
    local local1 = 0
    local local2
    local local3, local4
    local local5
    local local6
    local local7, local8
    tb.miracle = FALSE
    calculate_cats = TRUE
    cat_race_running = TRUE
    while cat_race_running do
        if calculate_cats then
            local1 = 0
            repeat
                local1 = local1 + 1
                cat_racers[local1].distance = cat_racers[local1].distance + rnd(1, 5) + cat_racers[local1].odds
            until local1 == tb.NUMBER_OF_CATS
            local7 = rnd(1, 100)
            local8 = rnd(1, 100)
            if not tb.miracle and local7 == local8 then
                tb.miracle = TRUE
                cat_racers[tb.NUMBER_OF_CATS].distance = 1000000
                miracle_cat = cat_racers[tb.NUMBER_OF_CATS].name
            end
            local1 = 0
            repeat
                local1 = local1 + 1
                local3 = local1
                local4 = local3 + 1
                while cat_racers[local4] do
                    if cat_racers[local3].distance < cat_racers[local4].distance then
                        local5 = cat_racers[local3].name
                        local6 = cat_racers[local3].distance
                        cat_racers[local3].name = cat_racers[local4].name
                        cat_racers[local3].distnce = cat_racers[local4].distance
                        cat_racers[local4].name = local5
                        cat_racers[local4].distnce = local6
                    end
                    local3 = local3 + 1
                    local4 = local3 + 1
                end
            until local1 == tb.NUMBER_OF_CATS
        end
        break_here()
    end
end
tb.track_announcer = function() -- line 456
    local local1
    local local2 = 1
    local local3, local4
    local local5
    local local6 = FALSE
    while 1 do
        local2 = 1
        cat_race_running = FALSE
        local local7 = start_script(tb.pre_race_timer)
        while find_script(local7) do
            if tb.race_countdown_announcement then
                track_announcer:say_line(tb.race_countdown_announcement)
                tb.race_countdown_announcement = nil
            else
                track_announcer:say_line(cat_announcements[local2].say)
                local2 = local2 + 1
                if local2 == 13 then
                    local2 = 1
                end
            end
            track_announcer:wait_for_message()
            sleep_for(20000)
        end
        track_announcer:say_line(cat_announcements[13].say)
        track_announcer:wait_for_message()
        tb.init_cat_race()
        local2 = 0
        track_announcer:say_line("/tbta164/")
        repeat
            local2 = local2 + 1
            track_announcer:wait_for_message()
            track_announcer:say_line(cat_racers[local2].name)
            track_announcer:wait_for_message()
        until local2 == tb.NUMBER_OF_CATS
        local local8 = start_script(tb.cat_race_simulator)
        sleep_for(2000)
        start_cat_sfx("kittyBel.wav", TRUE)
        sleep_for(500)
        track_announcer:say_line(cat_announcements[14].say)
        tb.crowd_cheer(TRUE)
        single_start_script(tb.cat_paws)
        track_announcer:wait_for_message()
        local6 = FALSE
        local2 = 14
        repeat
            calculate_cats = FALSE
            local2 = local2 + 1
            if cat_announcements[local2].place then
                if tb.miracle and not local6 then
                    local6 = TRUE
                    local2 = local2 - 1
                    track_announcer:say_line(miracle_cat)
                    track_announcer:wait_for_message()
                    track_announcer:say_line("/tbta168/")
                    track_announcer:wait_for_message()
                    track_announcer:say_line("/tbta169/")
                    track_announcer:wait_for_message()
                    tb.crowd_cheer(TRUE)
                elseif cat_announcements[local2].place == 99 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place == 98 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place == 97 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place < 0 then
                    local5 = abs(cat_announcements[local2].place)
                    local3 = cat_racers[local5]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                else
                    local5 = abs(cat_announcements[local2].place)
                    local3 = cat_racers[local5]
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                end
            else
                track_announcer:say_line(cat_announcements[local2].say)
                track_announcer:wait_for_message()
            end
            tb.crowd_cheer()
            if local2 == 35 or local2 == 36 or local2 == 37 or local2 == 41 or local2 == 42 then
                if local2 == 35 then
                    start_cat_sfx("twCatBy.wav")
                    if system.currentSet == tw then
                        StartMovie("tb_kitty.snm", nil, 168, 398)
                    end
                end
                break_here()
            elseif local2 == 24 then
                start_cat_sfx("twCatBy.wav")
                if system.currentSet == tw then
                    StartMovie("tb_kitty.snm", nil, 168, 398)
                end
            else
                calculate_cats = TRUE
                sleep_for(3000)
            end
        until local2 == 42
        cat_race_running = FALSE
        start_cat_sfx("kittyBel.wav", TRUE)
        tb.crowd_cheer(TRUE)
        if rnd() then
            track_announcer:say_line("/tbta177/")
            track_announcer:wait_for_message()
            track_announcer:say_line("/tbta178/")
            track_announcer:wait_for_message()
            sleep_for(5000)
        end
        track_announcer:say_line("/tbta174/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[1].name)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta175/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[2].name)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta176/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[3].name)
        track_announcer:wait_for_message()
        sleep_for(5000)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta179/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[1].name)
        track_announcer:wait_for_message()
        local2 = 1
        track_announcer:say_line("/tbta166/")
        repeat
            local2 = local2 + 1
            track_announcer:wait_for_message()
            track_announcer:say_line(cat_racers[local2].name)
            track_announcer:wait_for_message()
            cat_names[cat_racers[local2].number].racing = nil
            if local2 == 1 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 3
            elseif local2 == 2 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 2
            elseif local2 == 3 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 1
            elseif local2 == 4 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 0.5
            elseif local2 == 5 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 1
            elseif local2 == 6 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 1.5
            elseif local2 == 7 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 2
            end
        until local2 == tb.NUMBER_OF_CATS
        sleep_for(2000)
        track_announcer:say_line("/tbta180/")
        sleep_for(30000)
    end
end
tb.goodbye_doug = function(arg1) -- line 654
    if not tb.double_doug then
        tb.double_doug = TRUE
        START_CUT_SCENE()
        stop_script(tb.track_announcer)
        manny:set_visibility(FALSE)
        if arg1 == tb.ts_door then
            doug.look_point = { x = 0.118851, y = -0.539676, z = -0.116 }
            doug.look_point2 = { x = 0.118851, y = 0.875324, z = -0.145 }
        else
            doug.look_point = { x = -0.567064, y = -1.00833, z = 0.495 }
            doug.look_point2 = { x = -0.175, y = 1.4, z = 0.494 }
        end
        tb:current_setup(tb_fotws)
        doug:setpos(-0.0520684, -1.72162, 0)
        doug:setrot(0, -353, 0)
        doug:play_chore(doug_idles_rest, "doug_idles.cos")
        doug:head_look_at_point(doug.look_point, 300)
        sleep_for(1000)
        doug:say_line("/tbdu061/")
        doug:wait_for_message()
        doug:head_look_at(nil)
        doug:say_line("/tbdu062/")
        doug:wait_for_message()
        tb:current_setup(tb_strws)
        sleep_for(2000)
        tb:current_setup(tb_fotws)
        break_here()
        doug:head_look_at_point(doug.look_point, 120)
        sleep_for(1000)
        doug:head_look_at(nil, 120)
        sleep_for(750)
        doug:say_line("/tbdu063/")
        doug:wait_for_message()
        tb:current_setup(tb_strws)
        sleep_for(1500)
        doug:setpos(0.102557, 1.84044, 0)
        doug:fake_walkto(0, 1.63993, 0)
        doug:wait_for_actor()
        doug:setrot(0, -160, 0, TRUE)
        doug:wait_for_actor()
        doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
        doug:say_line("/tbdu064/")
        sleep_for(500)
        doug:head_look_at_point(doug.look_point2, 100)
        sleep_for(750)
        doug:head_look_at(nil, 130)
        doug:wait_for_message()
        doug:say_line("/tbdu065/")
        sleep_for(1300)
        doug:head_look_at_point({ x = 0.077, y = 1.4, z = 0.494 }, 130)
        doug:wait_for_message()
        doug:head_look_at(nil, 130)
        sleep_for(1000)
        END_CUT_SCENE()
        manny:set_visibility(TRUE)
    end
end
tb.search_pockets_for_winning_ticket = function(arg1) -- line 722
    local local1, local2 = next(cn.tickets, nil)
    while local1 do
        if local2.race == 6 and local2.week == 2 and local2.day == 2 and local2.owner == manny then
            return TRUE
        else
            local1, local2 = next(cn.tickets, local1)
        end
    end
    return FALSE
end
tb.get_photo = function(arg1) -- line 738
    if cn.ticket.owner == manny then
        if cn.ticket.race == 6 and cn.ticket.week == 2 and cn.ticket.day == 2 then
            tb.right_photo = TRUE
        else
            tb.right_photo = FALSE
        end
    end
    START_CUT_SCENE()
    doug:say_line("/tbdu001/")
    doug:wait_for_message()
    END_CUT_SCENE()
    if not tb.tried_photo then
        tb.tried_photo = TRUE
        START_CUT_SCENE()
        manny:say_line("/tbma002/")
        manny:wait_for_message()
        doug:say_line("/tbdu003/")
        doug:wait_for_message()
        manny:say_line("/tbma004/")
        manny:wait_for_message()
        doug:say_line("/tbdu005/")
        doug:wait_for_message()
        END_CUT_SCENE()
    end
    if cn.ticket.owner ~= manny then
        START_CUT_SCENE()
        manny:say_line("/tbma006/")
        manny:wait_for_message()
        doug:say_line("/tbdu008/")
        doug:wait_for_message()
        doug:say_line("/tbdu009/")
        doug:fake_walkto(-0.487359, -1.81429, 0)
        doug:wait_for_actor()
        manny:play_chore(ma_photopass_from_cntr)
        manny:wait_for_chore()
        manny:pop_costume()
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        cn.ticket:free()
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:stop_chore(mc_hold, "mc.cos")
        manny:stop_chore(mc_activate_ticket, "mc.cos")
        manny.is_holding = nil
        manny:say_line("/tbma010/")
        manny:wait_for_message()
        manny:stop_chore()
        manny:play_chore(ma_photopass_give_stub)
        doug:play_chore(doug_idles_take_stub)
        cn.ticket:free()
        doug:wait_for_chore()
        if not tb.given_ticket then
            tb.given_ticket = TRUE
            doug:say_line("/tbdu011/")
            doug:wait_for_message()
            manny:say_line("/tbma012/")
            manny:wait_for_message()
        end
        doug:play_chore(doug_idles_rid_stub)
        doug:say_line("/tbdu013/")
        doug:wait_for_message()
        doug:wait_for_chore()
        doug:play_chore(doug_idles_get_photo)
        doug:say_line("/tbdu014/")
        doug:wait_for_message()
        doug:wait_for_chore()
        doug:say_line("/tbdu015/")
        doug:play_chore(doug_idles_give_photo)
        manny:head_look_at(nil)
        manny:play_chore(ma_photopass_take_envelope)
        manny:wait_for_chore()
        doug:wait_for_chore()
        manny:wait_for_chore()
        if tb.right_photo and si.photofinish.owner == manny then
            cur_puzzle_state[32] = TRUE
            tb.time_to_say_goodbye = TRUE
            manny:say_line("/tbma016/")
            manny:wait_for_message()
            doug:say_line("/tbdu017/")
            doug:wait_for_message()
            manny:head_look_at(nil)
            manny:play_chore(ma_photopass_photo_switch)
            manny:say_line("/tbma018/")
            manny:wait_for_message()
            manny:wait_for_chore()
            manny:wait_for_chore(ma_photopass_photo_switch, "ma_photopass.cos")
            manny:play_chore(ma_photopass_return_photo)
            doug:play_chore(doug_idles_take_photo)
            manny:say_line("/tbma019/")
            manny:wait_for_message()
            doug:say_line("/tbdu020/")
            doug:wait_for_chore()
            doug:fake_walkto(-0.387359, -1.81429, 0)
            doug:wait_for_actor()
            tb.blackmail_photo:get()
            si.photofinish:free()
        else
            if not tb.got_wrong_photo then
                tb.got_wrong_photo = TRUE
                manny:say_line("/tbma021/")
                manny:wait_for_message()
                doug:say_line("/tbdu022/")
                doug:wait_for_message()
                manny:say_line("/tbma023/")
            else
                manny:say_line("/tbma024/")
            end
            manny:wait_for_message()
            manny:play_chore(ma_photopass_return_photo)
            doug:say_line("/tbdu025/")
            doug:play_chore(doug_idles_take_photo)
            doug:wait_for_message()
            doug:wait_for_chore()
            doug:fade_out_chore(doug_idles_take_photo, "doug_idles.cos", 500)
            doug:say_line("/tbdu026/")
            manny:wait_for_chore()
            doug:fake_walkto(-0.387359, -1.81429, 0)
            doug:wait_for_actor()
        end
        manny:pop_costume()
        manny:setpos({ x = 0.031, y = -1.19456, z = 0 })
        manny:head_look_at(nil)
        END_CUT_SCENE()
    end
end
tb.set_up_actors = function() -- line 880
    if not doug then
        doug = Actor:create(nil, nil, nil, "Doug")
    end
    doug:set_talk_color(Green)
    doug:set_costume("doug_idles.cos")
    doug:follow_boxes()
    doug:set_walk_rate(0.5)
    doug:put_in_set(tb)
    doug:set_mumble_chore(doug_idles_mumble)
    doug:set_talk_chore(1, doug_idles_stop_talk)
    doug:set_talk_chore(2, doug_idles_a)
    doug:set_talk_chore(3, doug_idles_c)
    doug:set_talk_chore(4, doug_idles_e)
    doug:set_talk_chore(5, doug_idles_f)
    doug:set_talk_chore(6, doug_idles_l)
    doug:set_talk_chore(7, doug_idles_m)
    doug:set_talk_chore(8, doug_idles_o)
    doug:set_talk_chore(9, doug_idles_t)
    doug:set_talk_chore(10, doug_idles_u)
    doug:setpos(0.102557, 1.84044, 0)
    doug:set_head(3, 4, 5, 165, 28, 80)
    if tb.needs_intro and not tb.seen_intro then
        tb.needs_intro = FALSE
        tb.seen_intro = TRUE
        start_script(tb.show_room)
    end
end
tb.enter = function(arg1) -- line 913
    start_script(tb.off_screen_kittys)
    if not find_script(tb.track_announcer) then
        tb.init_cat_names()
        start_script(tb.track_announcer)
    end
    tb.set_up_actors()
end
tb.exit = function() -- line 922
    stop_script(tb.off_screen_kittys)
    doug:free()
end
tb.photo_window = Object:create(tb, "/tbtx028/Window", -0.065300003, -1.5262001, 0.5, { range = 0.80000001 })
tb.photo_window.use_pnt_x = 0
tb.photo_window.use_pnt_y = -1.16456
tb.photo_window.use_pnt_z = 0
tb.photo_window.use_rot_x = 0
tb.photo_window.use_rot_y = 180
tb.photo_window.use_rot_z = 0
tb.photo_window.lookAt = function(arg1) -- line 940
    if not tb.photo_window.tried then
        system.default_response("nobody")
    else
        manny:say_line("/tbma029/")
    end
end
tb.photo_window.use = function(arg1) -- line 948
    tb.photo_window.tried = TRUE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("ma_photopass.cos")
    if manny.is_holding then
        manny:blend(ma_photopass_to_counter, ms_hold, 500, "ma_photopass.cos", manny.base_costume)
        sleep_for(500)
        manny:stop_chore(ms_hold, "mc.cos")
    else
        manny:play_chore(ma_photopass_to_counter)
    end
    manny:say_line("/tbma030/")
    manny:wait_for_message()
    manny:wait_for_chore()
    doug:setpos(-0.387359, -1.81429, 0)
    doug:fake_walkto(-0.0520684, -1.72162, 0)
    doug:wait_for_actor()
    doug:setrot(0, -353, 0, TRUE)
    doug:wait_for_actor()
    doug:stop_chore()
    doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
    doug:say_line("/tbdu031/")
    doug:wait_for_message()
    END_CUT_SCENE()
    tb:get_photo()
end
tb.photo_window.use_ticket = tb.photo_window.use
tb.bet_window = Object:create(tb, "/tbtx032/window", 0, 1.49, 0.44999999, { range = 0.80000001 })
tb.bet_window.use_pnt_x = -0.086491302
tb.bet_window.use_pnt_y = 1.08706
tb.bet_window.use_pnt_z = 0
tb.bet_window.use_rot_x = 0
tb.bet_window.use_rot_y = 1440.04
tb.bet_window.use_rot_z = 0
tb.bet_window.lookAt = function(arg1) -- line 988
    if not tb.bet_window.tried then
        system.default_response("nobody")
    else
        manny:say_line("/tbma033/")
    end
end
tb.bet_window.use = function(arg1) -- line 996
    local local1
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("ma_photopass.cos")
    if manny.is_holding then
        manny:blend(ma_photopass_to_counter, ms_hold, 500, "ma_photopass.cos", manny.base_costume)
        sleep_for(500)
        manny:stop_chore(ms_hold, "mc.cos")
    else
        manny:play_chore(ma_photopass_to_counter)
    end
    manny:say_line("/tbma034/")
    manny:wait_for_message()
    doug:setpos(0.102557, 1.84044, 0)
    doug:fake_walkto(0, 1.63993, 0)
    doug:wait_for_actor()
    doug:setrot(0, -160, 0, TRUE)
    doug:wait_for_actor()
    doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
    if not arg1.tried then
        arg1.tried = TRUE
        doug:say_line("/tbdu035/")
        sleep_for(800)
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:wait_for_message()
        manny:say_line("/tbma036/")
        manny:wait_for_message()
        doug:say_line("/tbdu037/")
        doug:wait_for_message()
        manny:say_line("/tbma038/")
        manny:wait_for_message()
        doug:say_line("/tbdu039/")
        doug:push_chore(doug_idles_nod)
        doug:push_chore()
        doug:push_chore(doug_idles_nod)
        doug:push_chore()
        doug:wait_for_message()
        manny:say_line("/tbma040/")
        manny:wait_for_message()
        doug:say_line("/tbdu041/")
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:wait_for_message()
        if cn.ticket.owner == manny then
            manny:say_line("/tbma042/")
        else
            manny:say_line("/tbma043/")
        end
        manny:wait_for_message()
    else
        doug:say_line("/tbdu044/")
        doug:wait_for_message()
    end
    local1 = "rest"
    if cn.ticket.owner == manny then
        local1 = "rid"
        cn.ticket:free()
        manny:say_line("/tbma045/")
        manny:wait_for_message()
        manny:play_chore(ma_photopass_give_stub)
        doug:play_chore(doug_idles_take_stub)
        doug:wait_for_chore()
        doug:say_line("/tbdu046/")
        doug:wait_for_message()
        doug:play_chore(doug_idles_rid_stub)
        if tb.tried_fake then
            doug:say_line("/tbdu047/")
        else
            tb.tried_fake = TRUE
            doug:say_line("/tbdu048/")
            doug:wait_for_message()
            manny:say_line("/tbma049/")
        end
        doug:wait_for_chore()
    end
    manny:wait_for_message()
    if local1 == "rest" then
        doug:fade_out_chore(doug_idles_rest, "doug_idles.cos", 500)
    else
        doug:fade_out_chore(doug_idles_rid_stub, "doug_idles.cos", 500)
    end
    doug:say_line("/tbdu050/")
    doug:wait_for_message()
    manny:play_chore(ma_photopass_from_cntr)
    doug:fake_walkto(0.102557, 1.84044, 0)
    doug:wait_for_actor()
    manny:wait_for_chore(ma_photopass_from_cntr, "ma_photopass.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
tb.bet_window.use_ticket = tb.bet_window.use
tb.blackmail_photo = Object:create(tb, "/tbtx051/incriminating photo", 0, 0, 0, { range = 0 })
tb.blackmail_photo.string_name = "blackmail"
tb.blackmail_photo.wav = "getcard.wav"
tb.blackmail_photo.lookAt = function(arg1) -- line 1104
    manny:say_line("/tbma052/")
end
tb.blackmail_photo.use = tb.blackmail_photo.lookAt
tb.blackmail_photo.default_response = function(arg1) -- line 1110
    manny:say_line("/tbma053/")
end
tb.bet_obj = Object:create(tb, "", -0.173969, 1.63993, 0, { range = 0 })
tb.bet_obj.use_pnt_x = -0.173969
tb.bet_obj.use_pnt_y = 1.63993
tb.bet_obj.use_pnt_z = 0
tb.bet_obj.use_rot_x = 0
tb.bet_obj.use_rot_y = -160.77299
tb.bet_obj.use_rot_z = 0
tb.photo_obj = Object:create(tb, "", 0.072068401, -1.72162, 0, { range = 0 })
tb.photo_obj.use_pnt_x = 0.072068401
tb.photo_obj.use_pnt_y = -1.72162
tb.photo_obj.use_pnt_z = 0
tb.photo_obj.use_rot_x = 0
tb.photo_obj.use_rot_y = -352.745
tb.photo_obj.use_rot_z = 0
tb.ts_door = Object:create(tb, "/tbtx056/door", 0.80000001, 0, -0.1, { range = 0 })
tb.ts_door.use_pnt_x = 0.33327299
tb.ts_door.use_pnt_y = -0.0051976298
tb.ts_door.use_pnt_z = -0.26751199
tb.ts_door.use_rot_x = 0
tb.ts_door.use_rot_y = -87.913498
tb.ts_door.use_rot_z = 0
tb.ts_door.out_pnt_x = 0.68868601
tb.ts_door.out_pnt_y = 0.01196
tb.ts_door.out_pnt_z = -0.45457199
tb.ts_door.out_rot_x = 0
tb.ts_door.out_rot_y = -87.913498
tb.ts_door.out_rot_z = 0
tb.ts_box = tb.ts_door
tb.ts_door.walkOut = function(arg1) -- line 1160
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    ts:come_out_door(ts.tb_door)
end
tb.hh_door = Object:create(tb, "/tbtx057/door", -0.80000001, 2.2, 0.54000002, { range = 0 })
tb.hh_door.use_pnt_x = -0.82007802
tb.hh_door.use_pnt_y = 1.23658
tb.hh_door.use_pnt_z = -3.7268402e-09
tb.hh_door.use_rot_x = 0
tb.hh_door.use_rot_y = -0.674227
tb.hh_door.use_rot_z = 0
tb.hh_door.out_pnt_x = -0.81631702
tb.hh_door.out_pnt_y = 1.5407701
tb.hh_door.out_pnt_z = 0.103325
tb.hh_door.out_rot_x = 0
tb.hh_door.out_rot_y = -0.674227
tb.hh_door.out_rot_z = 0
tb.hh_box = tb.hh_door
tb.hh_door.walkOut = function(arg1) -- line 1185
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    hh:come_out_door(hh.tb_door)
end
tb.gt_door = Object:create(tb, "/tbtx058/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.gt_door.use_pnt_x = -1.73559
tb.gt_door.use_pnt_y = 0.057845
tb.gt_door.use_pnt_z = 0.206
tb.gt_door.use_rot_x = 0
tb.gt_door.use_rot_y = -2071.6899
tb.gt_door.use_rot_z = 0
tb.gt_door.out_pnt_x = -3.5209701
tb.gt_door.out_pnt_y = 0.0504007
tb.gt_door.out_pnt_z = 0.98903102
tb.gt_door.out_rot_x = 0
tb.gt_door.out_rot_y = -2057.8101
tb.gt_door.out_rot_z = 0
tb.gt_box = tb.gt_door
tb.gt_door.walkOut = function(arg1) -- line 1211
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    gt:come_out_door(gt.tb_door)
end
tb.tw_door = Object:create(tb, "/tbtx059/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.tw_door.use_pnt_x = 0
tb.tw_door.use_pnt_y = 0
tb.tw_door.use_pnt_z = 0
tb.tw_door.use_rot_x = 0
tb.tw_door.use_rot_y = 0
tb.tw_door.use_rot_z = 0
tb.tw_door.out_pnt_x = 0
tb.tw_door.out_pnt_y = 0
tb.tw_door.out_pnt_z = 0
tb.tw_door.out_rot_x = 0
tb.tw_door.out_rot_y = 0
tb.tw_door.out_rot_z = 0
tb.tw_box = tb.tw_door
tb.tw_door.walkOut = function(arg1) -- line 1235
    local local1, local2, local3
    START_CUT_SCENE()
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    tw:switch_to_set()
    PutActorInSet(system.currentActor.hActor, tw.setFile)
    PutActorAt(system.currentActor.hActor, local1, local2, local3)
    END_CUT_SCENE()
end
tb.tw1_door = Object:create(tb, "/tbtx060/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.tw1_door.use_pnt_x = 0
tb.tw1_door.use_pnt_y = 0
tb.tw1_door.use_pnt_z = 0
tb.tw1_door.use_rot_x = 0
tb.tw1_door.use_rot_y = 0
tb.tw1_door.use_rot_z = 0
tb.tw1_door.out_pnt_x = 0
tb.tw1_door.out_pnt_y = 0
tb.tw1_door.out_pnt_z = 0
tb.tw1_door.out_rot_x = 0
tb.tw1_door.out_rot_y = 0
tb.tw1_door.out_rot_z = 0
tb.tw1_box = tb.tw1_door
tb.tw1_door.walkOut = function(arg1) -- line 1262
    local local1, local2, local3
    START_CUT_SCENE()
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    tw:switch_to_set()
    PutActorInSet(system.currentActor.hActor, tw.setFile)
    PutActorAt(system.currentActor.hActor, local1, local2, local3)
    END_CUT_SCENE()
end
CheckFirstTime("me.lua")
me = Set:create("me.set", "meadow exterior", { me_carla = 0, me_carla2 = 0, me_carla3 = 0, me_carla4 = 0, me_carla5 = 0, me_carla6 = 0, me_carla7 = 0, me_pmpws = 1, me_pmpws2 = 1, me_pmpws3 = 1, me_pmpws4 = 1, me_pmpws5 = 1, me_pmpws6 = 1, me_shtgh = 2, me_shtgh2 = 2, me_rerws = 3, me_ovrhd = 4, me_rerha = 5, me_rerha2 = 5, me_rerha3 = 5, me_rerha4 = 5, me_salcu = 6, me_olvms = 7, me_sptcu = 8, me_dorcu = 9 })
me.cheat_boxes = { cheat1 = 0 }
dofile("ol_gun.lua")
dofile("ol_suitcase.lua")
dofile("ol_dies.lua")
dofile("md_search_sal.lua")
dofile("md_gun.lua")
dofile("md_shooting.lua")
dofile("md_green_door.lua")
dofile("me_backdoor.lua")
dofile("me_frontdoor.lua")
dofile("md_hold_tix.lua")
dofile("he_greenhouse.lua")
dofile("me_trunk.lua")
dofile("shootout.lua")
me.olivia_talk_count = 0
me.flower_point = { x = 18.3018, y = -21.0012, z = -7.61071 }
me.olivia_hector_point = { x = 16.213, y = -19.2214, z = -7.18187 }
me.suitcase_point1 = { x = 18.8761, y = -19.781, z = -7.67824 }
me.suitcase_point2 = { x = 18.9601, y = -19.946, z = -7.67824 }
me.ol_run_point = { x = 17.3648, y = -20.7248, z = -7.22155 }
me.sal_music = FALSE
me.shootout_music = FALSE
me.end_music = FALSE
me.greenhouse_approach_music = FALSE
me.water_pump_vol = 20
me.water_pump_pan = 20
me.olivia_searching = function() -- line 60
    me.heard_olivia_search = TRUE
    olivia:say_line("/meol013/")
    wait_for_message()
    olivia:say_line("/meol014/")
    sleep_for(2000)
    olivia:say_line("/meol015/")
end
olivia.meadow_default = function(arg1) -- line 70
    olivia:free()
    olivia:set_costume("olivia_talks.cos")
    olivia:set_mumble_chore(olivia_talks_mumble)
    olivia:set_talk_chore(1, olivia_talks_stop_talk)
    olivia:set_talk_chore(2, olivia_talks_a)
    olivia:set_talk_chore(3, olivia_talks_c)
    olivia:set_talk_chore(4, olivia_talks_e)
    olivia:set_talk_chore(5, olivia_talks_f)
    olivia:set_talk_chore(6, olivia_talks_l)
    olivia:set_talk_chore(7, olivia_talks_m)
    olivia:set_talk_chore(8, olivia_talks_o)
    olivia:set_talk_chore(9, olivia_talks_t)
    olivia:set_talk_chore(10, olivia_talks_u)
    olivia:push_costume("ol_gun.cos")
    olivia:ignore_boxes()
    olivia:set_head(5, 6, 7, 165, 28, 80)
    olivia:set_look_rate(110)
    olivia:set_visibility(TRUE)
end
me.pester_olivia = function() -- line 91
    START_CUT_SCENE()
    me.olivia_talk_count = me.olivia_talk_count + 1
    manny:stop_walk()
    start_script(manny.turn_toward_entity, manny, me.olivia_obj)
    manny:head_look_at(me.olivia_obj)
    olivia:play_chore(ol_gun_threaten, "ol_gun.cos")
    if me.olivia_talk_count == 1 then
        wait_for_message()
        olivia:say_line("/meol006/")
        wait_for_message()
        manny:say_line("/mema007/")
        wait_for_message()
        olivia:say_line("/meol008/")
        wait_for_message()
        olivia:say_line("/meol009/")
    elseif me.olivia_talk_count == 2 then
        olivia:say_line("/meol010/")
    elseif me.olivia_talk_count == 3 then
        olivia:say_line("/meol011/")
    else
        olivia:say_line("/meol012/")
    end
    olivia:wait_for_message()
    manny:head_look_at(nil)
    stop_script(manny.turn_toward_entity)
    manny:walk_and_face(15.0038, -19.01, -7.97882, 0, 67.2536, 0)
    END_CUT_SCENE()
end
me.olivia_search_idles = function() -- line 122
    while 1 do
        olivia:play_chore(ol_suitcase_suitcase, "ol_suitcase.cos")
        if rnd() then
            sleep_for(2000 * random())
            olivia:play_chore(ol_suitcase_suitcase_hold, "ol_suitcase.cos")
            olivia:fade_out_chore(ol_suitcase_suitcase, "ol_suitcase.cos", 500)
        else
            olivia:wait_for_chore(ol_suitcase_suitcase, "ol_suitcase.cos")
        end
        repeat
            olivia:head_look_at_point(me.suitcase_point1)
            sleep_for(1000 + 3000 * random())
            olivia:head_look_at_point(me.suitcase_point2)
            sleep_for(1000 + 3000 * random())
        until rnd()
        olivia:head_look_at(nil)
    end
end
me.ol_scoot_in = function(arg1) -- line 150
    local local1
    repeat
        olivia:offsetBy(0, 0.050000001, 0)
        break_here()
        local1 = olivia:getpos()
    until local1.y >= -19.4884
end
me.ol_scoot_out = function(arg1) -- line 161
    local local1
    stop_script(me.ol_scoot_in)
    manny:play_chore_looping(md_back_off, "md.cos")
    manny:ignore_boxes()
    repeat
        local1 = 0 - PerSecond(0.30000001)
        olivia:offsetBy(0, local1, 0)
        manny:offsetBy(0, local1, 0)
        break_here()
        ol_pos = olivia:getpos()
    until ol_pos.y <= -19.700001
end
me.salvador_goodbye = function(arg1) -- line 182
    salvador.sprouted = TRUE
    START_CUT_SCENE()
    set_override(me.salvador_goodbye_override)
    olivia:set_visibility(TRUE)
    stop_script(me.olivia_search_idles)
    manny:wait_for_message()
    salvador:play_chore(ol_dies_sal_eyes_open, "ol_dies.cos")
    sleep_for(500)
    salvador:say_line("/hisa001/")
    manny:walk_and_face(17.6867, -19.4394, -7.84747, 0, 340.695, 0)
    wait_for_message()
    salvador:say_line("/hisa002/")
    wait_for_message()
    salvador:say_line("/hisa003/")
    wait_for_message()
    manny:say_line("/hima004/")
    manny:nod_head_gesture()
    wait_for_message()
    salvador:say_line("/hisa005/")
    wait_for_message()
    salvador:say_line("/hisa006/")
    wait_for_message()
    salvador:say_line("/hisa007/")
    wait_for_message()
    manny:say_line("/hima008/")
    manny:tilt_head_gesture()
    manny:hand_gesture()
    sleep_for(500)
    music_state:set_state(stateEND)
    olivia:meadow_default()
    olivia:pop_costume()
    olivia:push_costume("ol_dies.cos")
    olivia:put_in_set(me)
    olivia:setpos(16.8976, -19.5694, -7.787)
    olivia:setrot(0, 160.021, 0)
    olivia:play_chore(ol_dies_stickup_manny, "ol_dies.cos")
    start_script(me.ol_scoot_in)
    manny:wait_for_message()
    olivia:say_line("/hiol009/")
    wait_for_script(me.ol_scoot_in)
    start_script(me.ol_scoot_out)
    olivia:wait_for_message()
    salvador:say_line("/hisa010/")
    salvador:wait_for_message()
    wait_for_script(me.ol_scoot_out)
    system:lock_display()
    olivia:setpos(16.9006, -19.8874, -7.689)
    olivia:setrot(0, 191.438, 0)
    manny:put_in_set(nil)
    me:current_setup(me_olvms)
    olivia:play_chore(ol_dies_push_ma_out, "ol_dies.cos")
    system:unlock_display()
    olivia:wait_for_chore(ol_dies_push_ma_out, "ol_dies.cos")
    olivia:say_line("/hiol011/")
    olivia:run_chore(ol_dies_get_sal_head, "ol_dies.cos")
    olivia:play_chore(ol_dies_obtained_head, "ol_dies.cos")
    olivia:wait_for_message()
    olivia:wait_for_chore(ol_dies_obtained_head, "ol_dies.cos")
    sleep_for(500)
    olivia:say_line("/hiol012/")
    system:lock_display()
    me:current_setup(me_sptcu)
    olivia:setpos(16.8196, -20.1124, -7.602)
    olivia:setrot(0, 204.316, 0)
    olivia:play_chore(ol_dies_talk2sal, "ol_dies.cos")
    system:unlock_display()
    sleep_for(500)
    olivia:run_chore(ol_dies_prespit, "ol_dies.cos")
    olivia:wait_for_message()
    salvador:ignore_boxes()
    salvador:setpos(16.8196, -20.1124, -7.602)
    salvador:setrot(0, 204.316, 0)
    salvador:play_chore(ol_dies_sal_talk_hold2, "ol_dies.cos")
    olivia:play_chore(ol_dies_talk_hold2, "ol_dies.cos")
    salvador:say_line("/hisa013/")
    music_state:set_sequence(seqSalvadorDeath)
    me.sal_music = FALSE
    music_state:update(system.currentSet)
    salvador:wait_for_message()
    salvador:say_line("/hisa014/")
    salvador:wait_for_message()
    salvador:set_visibility(FALSE)
    salvador:set_speech_mode(MODE_BACKGROUND)
    salvador:say_line("/hisa013b/")
    olivia:play_chore(ol_dies_spit, "ol_dies.cos")
    sleep_for(500)
    olivia:say_line("/hiol015/")
    salvador:say_line("/hisa016/")
    olivia:wait_for_chore(ol_dies_spit, "ol_dies.cos")
    olivia:play_chore(ol_dies_run, "ol_dies.cos")
    start_sfx("zw_trail.wav")
    manny:put_in_set(me)
    manny:setpos(17.6851, -20.1075, -7.80871)
    manny:setrot(0, 42.4447, 0)
    manny:default()
    manny:follow_boxes()
    manny:head_look_at_point(me.ol_run_point)
    manny:set_walk_rate(0.5)
    start_script(manny.walk_and_face, manny, 17.3648, -19.7388, -7.84155, 0, 175.622, 0)
    sleep_for(2000)
    start_sfx("salSprt.wav")
    me.salvador_obj:onGround()
    manny:head_look_at(me.salvador_obj)
    sleep_for(500)
    olivia:wait_for_message()
    olivia:say_line("/hiol017/")
    sleep_for(1000)
    system:lock_display()
    me:current_setup(me_carla)
    olivia:setpos(17.0536, -20.7594, -7.798)
    olivia:setrot(0, 226.5, 0)
    me.salflowers:here()
    me.suitcase:setUp()
    system:unlock_display()
    olivia:play_chore(ol_dies_run, "ol_dies.cos")
    olivia:wait_for_chore(ol_dies_run, "ol_dies.cos")
    olivia:wait_for_message()
    END_CUT_SCENE()
    me.setup_part3()
end
me.salvador_goodbye_override = function() -- line 326
    kill_override()
    salvador.sprouted = TRUE
    stop_script(me.olivia_search_idles)
    stop_script(me.ol_scoot_in)
    stop_script(me.ol_scoot_out)
    me:setup_part3()
    manny:default()
    manny:setpos(17.3648, -19.7388, -7.84155)
    manny:setrot(0, 175.622, 0)
    me:current_setup(me_carla)
    system:unlock_display()
end
Atest = function() -- line 340
    local local1, local2, local3, local4
    if not me.sals_body.act then
        me.sals_body:setup()
    end
    while 1 do
        local1 = manny:get_positive_yaw_to_point({ x = me.sals_body.obj_x, y = me.sals_body.obj_y, z = me.sals_body.obj_z })
        local4 = manny:get_positive_rot()
        local3 = local4.y
        local2 = abs(local1 - local3)
        if local2 > 180 then
            local2 = 360 - local2
        end
        ExpireText()
        print_temporary("gpytp:" .. local1 .. ", posrot: " .. local3 .. ", diff: " .. local2)
        break_here()
    end
end
Xangle_to_obj = function(arg1) -- line 362
    local local1, local2, local3, local4
    local1 = manny:get_positive_yaw_to_point({ x = arg1.obj_x, y = arg1.obj_y, z = arg1.obj_z })
    local4 = manny:get_positive_rot()
    local3 = local4.y
    local2 = abs(local1 - local3)
    if local2 > 180 then
        local2 = 360 - local2
    end
    return local2
end
me.sal_detector = function() -- line 376
    local local1, local2
    while 1 do
        if object_proximity(me.salvador_obj) < 0.89999998 then
            if abs(Xangle_to_obj(me.salvador_obj)) < 90 then
                me.ticket:activated(me.salvador_obj)
                if not me.detected_head then
                    me.detected_head = TRUE
                    me.ticket:lookAt(me.salvador_obj)
                end
            else
                me.ticket:dormant()
            end
        else
            local1 = object_proximity(me.sals_body)
            if local1 < 3 then
                if GetAngleBetweenActors(manny.hActor, me.sals_body.interest_actor.hActor) < 35 then
                    if local1 < 0.5 then
                        start_script(me.tix_fly_to_body)
                    else
                        me.ticket:activated(me.sals_body)
                    end
                    if not me.detected_body then
                        me.detected_body = TRUE
                        me.ticket:lookAt()
                    end
                else
                    me.ticket:dormant()
                end
            else
                me.ticket:dormant()
            end
        end
        break_here()
    end
end
me.tix_fly_to_body = function() -- line 427
    local local1, local2, local3 = GetActorNodeLocation(manny.hActor, 12)
    local local4
    local local5 = manny:getpos()
    stop_script(me.sal_detector)
    START_CUT_SCENE()
    me.ticket:put_in_limbo()
    me.ticket.active = FALSE
    fade_sfx("tixvibe.imu")
    me.ticket:dormant(TRUE)
    if not sals_ticket then
        sals_ticket = Actor:create()
    end
    sals_ticket:ignore_boxes()
    sals_ticket:set_costume("tix.cos")
    sals_ticket:put_in_set(me)
    sals_ticket:setpos(local1, local2, local3)
    sals_ticket:setrot(manny:getrot())
    sals_ticket:play_chore_looping(0)
    manny:stop_chore(md_activate_ticket, "md.cos")
    manny:stop_chore(md_activate_tix_nowig, "md.cos")
    repeat
        break_here()
        sals_ticket:offsetBy(0, 0, -0.050000001)
        local4 = sals_ticket:getpos()
        manny:head_look_at(sals_ticket)
    until local4.z <= local5.z
    manny:stop_chore(md_hand_on_obj, "md.cos")
    manny:stop_chore(md_hold, "md.cos")
    sals_ticket:follow_boxes()
    sals_ticket:set_walk_rate(0.40000001)
    start_script(sals_ticket.walkto, sals_ticket, me.sals_body.obj_x, me.sals_body.obj_y, me.sals_body.obj_z)
    while find_script(sals_ticket.walkto) do
        manny:head_look_at(sals_ticket)
        break_here()
    end
    sals_ticket:wait_for_actor()
    sals_ticket:ignore_boxes()
    sals_ticket:offsetBy(0, 0, 0.050000001)
    manny:head_look_at(sals_ticket)
    END_CUT_SCENE()
    me:cut_flowers()
end
me.cut_flowers = function(arg1) -- line 480
    START_CUT_SCENE()
    manny:walkto_object(me.sals_body)
    manny:wait_for_actor()
    manny:set_rest_chore(nil)
    manny:run_chore(md_takeout_scythe, "md.cos")
    stop_sound("tixvibe.imu")
    start_script(cut_scene.cut_flowers)
    me.sals_body:setup()
    wait_for_script(cut_scene.cut_flowers)
    manny:stop_chore(md_takeout_scythe, "md.cos")
    manny:run_chore(md_putback_scythe, "md.cos")
    manny:stop_chore(md_putback_scythe, "md.cos")
    manny:set_rest_chore(md_rest, "md.cos")
    END_CUT_SCENE()
end
me.search_salvador = function(arg1) -- line 500
    START_CUT_SCENE()
    salvador.searched = TRUE
    manny:push_costume("md_search_sal.cos")
    manny:run_chore(md_search_sal_search, "md_search_sal.cos")
    manny:stop_chore(md_search_sal_search, "md_search_sal.cos")
    manny:pop_costume()
    manny:generic_pickup(me.key)
    me.key:lookAt()
    END_CUT_SCENE()
    me.car:setup()
end
me.kill_hector = function() -- line 520
    me.hector_dying = TRUE
    cur_puzzle_state[60] = TRUE
    hector.dying = TRUE
    me.shootout_music = TRUE
    music_state:update()
    START_CUT_SCENE()
    manny:wait_for_actor()
    start_script(me.manny_shoot)
    sleep_for(200)
    manny:set_visibility(FALSE)
    StartMovie("me_tank.snm")
    sleep_for(100)
    start_sfx("me_gun.wav", nil, 100)
    sleep_for(200)
    start_sfx("me_gun.wav", nil, 127)
    sleep_for(300)
    start_sfx("me_gun.wav", nil, 80)
    sleep_for(200)
    start_sfx("me_gun.wav", nil, 127)
    while sound_playing("me_gun.wav") do
        break_here()
    end
    wait_for_movie()
    me.darts:play_chore(0)
    manny:set_visibility(TRUE)
    music_state:update()
    start_sfx("me_tank3.wav", IM_HIGH_PRIORITY, 127)
    set_pan("me_tank3.wav", 0)
    fade_pan_sfx("me_tank3.wav", 7000, 80)
    fade_sfx("me_tank3.wav", 7000, 50)
    sleep_for(1000)
    manny:head_look_at_point({ x = -3.55053, y = -15.6068, z = -5.94586 }, 40)
    sleep_for(1000)
    manny:head_look_at_point({ x = -3.50753, y = -13.8818, z = -5.94186 }, 40)
    sleep_for(3000)
    manny:head_look_at_point({ x = -3.91453, y = -8.2748, z = -2.72986 }, 40)
    sleep_for(3000)
    wait_for_sound("me_tank3.wav")
    set_vol("mePump.imu", 0)
    start_script(cut_scene.hecgetit)
    me.gun:put_away()
    manny:head_look_at(me.greenhouse)
    wait_for_script(cut_scene.hecgetit)
    set_vol("mePump.imu", me.water_pump_vol)
    me.end_music = TRUE
    music_state:update()
    hector:say_line("/mehe040/", { volume = 25 })
    wait_for_message()
    sleep_for(750)
    hector:say_line("/mehe041/", { volume = 25 })
    wait_for_message()
    manny:turn_toward_entity(me.greenhouse)
    stop_script(hector.run_around_nervously)
    start_script(hector.part_1_idle)
    END_CUT_SCENE()
    hector:say_line("/mehe042/", { volume = 25 })
    wait_for_message()
    if not manny:is_moving() then
        manny:twist_head_gesture()
    end
    manny:say_line("/tuma048/")
    manny:head_look_at(nil)
end
me.blow_hector_up = function() -- line 611
    START_CUT_SCENE("no head")
    stop_script(hector.run_around_nervously)
    stop_script(hector.part_1_idle)
    cameraman_disabled = TRUE
    me:current_setup(me_dorcu)
    manny:put_at_object(me.door)
    manny:push_costume("md_green_door.cos")
    manny:push_costume("md_green_door.cos")
    if manny.is_holding ~= me.gun then
        manny:run_chore(md_take_out_get, "md.cos")
        manny:stop_chore(md_take_out_get, "md.cos")
        manny:complete_chore(md_activate_gun, "md.cos")
        manny:run_chore(md_takeout_big, "md.cos")
        manny.is_holding = he.gun
    end
    manny:complete_chore(md_green_door_show_gun, "md_green_door.cos")
    manny:set_time_scale(0.2)
    manny:play_chore(md_green_door_open_door, "md_green_door.cos")
    sleep_for(2000)
    me:current_setup(me_shtgh)
    manny:play_chore(md_green_door_open_door, "md_green_door.cos")
    sleep_for(3000)
    me:current_setup(me_dorcu)
    manny:set_time_scale(1)
    fade_sfx("scaryMus.imu", 700, 0)
    play_movie("me_splat.snm", 135, 30)
    wait_for_movie()
    PreRender(FALSE, FALSE)
    stop_script(TrackManny)
    manny:free()
    hector:free()
    start_script(cut_scene.hecdie, cut_scene)
    wait_for_script(cut_scene.hecdie)
    wait_for_movie()
    start_script(cut_scene.byebye, cut_scene)
    END_CUT_SCENE()
end
hector.part_1_idle = function() -- line 650
    hector:meadow_default()
    hector:put_in_set(me)
    hector:follow_boxes()
    hector:setpos(-2.65024, 0.658079, 0.266058)
    hector:setrot(0, 72.3787, 0)
    hector:complete_chore(he_greenhouse_hide_gun, "he_greenhouse.cos")
    while 1 do
        hector:setrot(0, 65 + 14 * random(), 0, TRUE)
        hector:fade_in_chore(he_greenhouse_shoot_to_aim, "he_greenhouse.cos")
        sleep_for(1000 + 3000 * random())
        hector:setrot(0, 65 + 14 * random(), 0, TRUE)
        hector:fade_out_chore(he_greenhouse_shoot_to_aim, "he_greenhouse.cos")
        sleep_for(1000 + 3000 * random())
        hector:setrot(0, 65 + 14 * random(), 0, TRUE)
        hector:fade_in_chore(he_greenhouse_aim_pos, "he_greenhouse.cos")
        sleep_for(1000 + 3000 * random())
        hector:setrot(0, 65 + 14 * random(), 0, TRUE)
        hector:fade_out_chore(he_greenhouse_aim_pos, "he_greenhouse.cos", 2000)
        sleep_for(1000 + 3000 * random())
    end
end
me.meadow_setup = function() -- line 679
    me.seen_intro = TRUE
    START_CUT_SCENE()
    mo.scythe:free()
    me.greenhouse_approach_music = TRUE
    music_state:update()
    box_off("return_trigger")
    cameraman_disabled = TRUE
    LoadCostume("md.cos")
    LoadCostume("ol_gun.cos")
    LoadCostume("md_out_car.cos")
    me:switch_to_set()
    me:current_setup(me_carla)
    olivia:free()
    manny:put_in_set(nil)
    IrisDown(447, 333, 0)
    me.brakeson:complete_chore(0)
    IrisUp(447, 333, 750)
    start_sfx("me_idlof.wav", nil, 0)
    set_pan("me_idlof.wav", 80)
    fade_sfx("me_idlof.wav", 500, 127)
    sleep_for(2000)
    me.brakeson:complete_chore(1)
    sleep_for(1000)
    set_override(me.meadow_setup_override)
    olivia:meadow_default()
    olivia:setpos(16.9008, -19.0563, -7.83171)
    olivia:setrot(0, 76.592, 0)
    olivia:put_in_set(me)
    manny:ignore_boxes()
    if manny:get_costume() ~= "md_out_car.cos" then
        manny:push_costume("md_out_car.cos")
    end
    manny:setpos(17.3898, -19.8948, -7.73594)
    manny:setrot(0, 121.281, 0)
    manny:set_rest_chore(nil)
    olivia:play_chore(ol_gun_exit_car, "ol_gun.cos")
    sleep_for(2000)
    start_script(me.meadow_setup_lines)
    sleep_for(3000)
    manny:put_in_set(me)
    manny:play_chore(0)
    sleep_for(3000)
    manny:wait_for_chore(0)
    manny:default()
    manny:setpos(17.5089, -19.8846, -7.82701)
    manny:setrot(0, 114.323, 0)
    me:current_setup(me_olvms)
    cameraman_disabled = TRUE
    manny:say_line("/mema003/")
    sleep_for(1500)
    manny:setrot(0, 163.216, 0, TRUE)
    manny:wait_for_message()
    olivia:say_line("/meol004/")
    sleep_for(1000)
    manny:walkto(17.2124, -20.0749, -7.84546)
    manny:wait_for_actor()
    manny:walkto(16.5468, -19.9913, -7.90947)
    manny:wait_for_actor()
    manny:setpos(15.7866, -19.4642, -8.01275)
    manny:setrot(0, 59.4728, 0)
    me:current_setup(me_carla)
    me.backdoor:play_chore(me_backdoor_closing)
    manny:walkto(14.8248, -18.9458, -8.11348)
    olivia:play_chore(ol_gun_gesture, "ol_gun.cos")
    olivia:wait_for_message()
    manny:head_look_at(me.olivia_obj)
    olivia:say_line("/meol005/")
    olivia:wait_for_message()
    me:current_setup(me_carla)
    manny:default()
    manny:head_look_at(nil)
    olivia:head_look_at(nil)
    stop_script(manny.walk_and_face)
    manny:setpos(15.0038, -19.01, -8.09936)
    manny:setrot(0, 277.84, 0, TRUE)
    box_on("return_trigger")
    cameraman_disabled = FALSE
    END_CUT_SCENE()
end
hector.meadow_default = function(arg1) -- line 775
    hector:free()
    hector:set_costume("he_praise.cos")
    hector:set_mumble_chore(he_praise_mumble)
    hector:set_talk_chore(1, he_praise_stop_talk)
    hector:set_talk_chore(2, he_praise_a)
    hector:set_talk_chore(3, he_praise_c)
    hector:set_talk_chore(4, he_praise_e)
    hector:set_talk_chore(5, he_praise_f)
    hector:set_talk_chore(6, he_praise_l)
    hector:set_talk_chore(7, he_praise_m)
    hector:set_talk_chore(8, he_praise_o)
    hector:set_talk_chore(9, he_praise_t)
    hector:set_talk_chore(10, he_praise_u)
    hector:push_costume("he_greenhouse.cos")
    hector:set_walk_chore(he_greenhouse_run_cycle, "he_greenhouse.cos")
    hector:set_head(5, 6, 7, 165, 28, 80)
    hector:set_walk_rate(1.5)
    hector:set_turn_rate(360)
    hector:set_rest_chore(he_greenhouse_crouch_rest, "he_greenhouse.cos")
end
me.meadow_setup_override = function() -- line 797
    stop_script(me.meadow_setup_lines)
    kill_override()
    me:switch_to_set()
    me:current_setup(me_carla)
    olivia:meadow_default()
    olivia:setpos(16.9008, -19.0563, -7.83171)
    olivia:setrot(0, 76.592, 0)
    olivia:put_in_set(me)
    olivia:play_chore(ol_gun_defpose, "ol_gun.cos")
    olivia:head_look_at(nil)
    single_start_script(hector.part_1_idle)
    me.brakeson:complete_chore(1)
    manny:default()
    manny:setpos(15.0038, -19.01, -7.97882)
    manny:setrot(0, 67.2536, 0)
    manny:head_look_at(nil)
    me.backdoor:complete_chore(me_backdoor_closed)
    me.frontdoor:complete_chore(me_frontdoor_closed)
    box_on("return_trigger")
    box_off("me_salcu")
    cameraman_disabled = FALSE
    system:unlock_display()
end
me.meadow_setup_lines = function() -- line 822
    olivia:say_line("/meol001/")
    wait_for_message()
    olivia:say_line("/meol002/")
end
me.setup_part2 = function() -- line 828
    single_start_script(hector.part_1_idle)
    manny.healed = TRUE
    me.backdoor:play_chore(me_backdoor_open)
    olivia:meadow_default()
    olivia:push_costume("ol_suitcase.cos")
    olivia:setpos(18.5508, -19.8835, -7.81814)
    olivia:setrot(0, 288.887, 0)
    olivia:put_in_set(me)
    me.olivia_obj:behindCar()
    salvador:free()
    salvador:set_costume("ol_dies.cos")
    salvador:set_mumble_chore(ol_dies_mumble)
    salvador:set_talk_chore(1, ol_dies_no_talk)
    salvador:set_talk_chore(2, ol_dies_a)
    salvador:set_talk_chore(3, ol_dies_c)
    salvador:set_talk_chore(4, ol_dies_e)
    salvador:set_talk_chore(5, ol_dies_f)
    salvador:set_talk_chore(6, ol_dies_l)
    salvador:set_talk_chore(7, ol_dies_m)
    salvador:set_talk_chore(8, ol_dies_o)
    salvador:set_talk_chore(9, ol_dies_t)
    salvador:set_talk_chore(10, ol_dies_u)
    salvador:complete_chore(ol_dies_just_head, "ol_dies.cos")
    salvador:ignore_boxes()
    salvador:setpos(16.988, -19.828, -7.74)
    salvador:setrot(0, 190.282, 0)
    salvador:complete_chore(ol_dies_sal_eyes_closed, "ol_dies.cos")
    salvador:put_in_set(me)
    me.salvador_obj:make_touchable()
    box_off("ol_car1")
    box_off("ol_car2")
    box_off("ol_car3")
    box_off("ol_car4")
    box_off("ol_car5")
    box_off("ol_car6")
    box_off("ol_car65")
    box_off("ol_car7")
    box_off("ol_car8")
    box_off("ol_car9")
    box_off("ol_car10")
    box_off("ol_car11")
    box_off("ol_car12")
    box_off("ol_car13")
    box_off("suitcase1")
    box_off("suitcase2")
    box_off("backdoor_box")
    box_off("return_trigger")
    box_on("me_salcu")
    if not me.door_flowers.hObjectState then
        me.door_flowers.hObjectState = me:add_object_state(me_carla, "me_door_flowers.bm", "me_door_flowers.zbm", OBJSTATE_STATE, TRUE)
        me.door_flowers:set_object_state("me_door_flowers.cos")
    end
    start_script(me.olivia_search_idles)
end
me.salcu_setup = function(arg1) -- line 894
    manny:setpos(17.6867, -19.4394, -7.84747)
    me.sal_music = TRUE
    music_state:update(system.currentSet)
end
me.setup_part3 = function() -- line 902
    if me.gun.owner == manny then
        me.setup_shootout()
    end
    if me.shootout_begun then
        stop_script(hector.part_1_idle)
    else
        single_start_script(hector.part_1_idle)
    end
    stop_script(me.olivia_search_idles)
    olivia:free()
    me.olivia_obj:make_untouchable()
    manny.healed = TRUE
    salvador.sprouted = TRUE
    box_off("return_trigger")
    me.backdoor:complete_chore(me_backdoor_open)
    box_off("backdoor_box")
    if me.ticket_free and not me.plucked_ticket then
        me.salflowers:haveTicket()
    else
        me.salflowers:noTicket()
    end
    salvador:free()
    me.salvador_obj:onGround()
    if not me.scy then
        me.scy = Actor:create()
    end
    me.scy:set_costume("scythe_folded.cos")
    me.scy:put_in_set(me)
    me.scy:ignore_boxes()
    me.scy:set_visibility(TRUE)
    me.scy:setpos(18.6811, -19.8932, -7.73316)
    me.scy:setrot(80, 180, 120)
    me.suitcase:setUp()
    me.car:setup()
    box_on("ol_car1")
    box_on("ol_car2")
    box_on("ol_car3")
    box_on("ol_car4")
    box_on("ol_car5")
    box_on("ol_car6")
    box_on("ol_car65")
    box_on("ol_car7")
    box_on("ol_car8")
    box_on("ol_car9")
    box_on("ol_car10")
    box_on("ol_car11")
    box_on("ol_car12")
    box_on("ol_car13")
    box_on("me_salcu")
    box_off("suitcase1")
    box_off("suitcase2")
    box_off("me_salcu")
    me.salflowers:here()
end
me.update_meadow_states = function() -- line 967
    if manny.healed then
        if salvador.sprouted then
            me.setup_part3()
        else
            me.setup_part2()
        end
    else
        me.meadow_setup_override()
    end
end
me.pm = function() -- line 979
    me:current_setup(me_carla)
    manny:setpos(15.0038, -19.01, -7.97882)
    manny:setrot(0, 67.2536, 0)
end
me.update_music_state = function(arg1) -- line 990
    if me.end_music then
        return stateEND
    elseif me.shootout_music then
        return stateSHOOT
    elseif me.greenhouse_approach_music then
        return stateGE
    elseif me.sal_music then
        return stateHI
    else
        return stateME
    end
end
me.enter = function(arg1) -- line 1004
    box_off("return_trigger")
    if salvador.sprouted then
        me.olivia_obj:make_untouchable()
        me.suitcase:make_touchable()
    end
    me.backdoor.hObjectState = me:add_object_state(me_carla, "me_backdoor.bm", "me_backdoor.zbm", OBJSTATE_STATE, FALSE)
    me.backdoor:set_object_state("me_backdoor.cos")
    me.salflowers.hObjectState = me:add_object_state(me_carla, "me_salflowers.bm", "me_salflowers.zbm", OBJSTATE_STATE, TRUE)
    me.salflowers:set_object_state("me_salflowers.cos")
    me.brakeson.hObjectState = me:add_object_state(me_carla, "me_brakeson.bm", nil, OBJSTATE_STATE, FALSE)
    me.brakeson:set_object_state("me_brakeson.cos")
    me.frontdoor.hObjectState = me:add_object_state(me_carla, "me_frontdoor.bm", nil, OBJSTATE_STATE, FALSE)
    me.frontdoor:set_object_state("me_frontdoor.cos")
    me.update_meadow_states()
    if me:current_setup() == me_pmpws then
        start_sfx("mePump.imu", IM_HIGH_PRIORITY, me.water_pump_vol)
        set_pan("mePump.imu", me.water_pump_pan)
    end
    start_script(me.get_nitro, me)
    SetShadowColor(10, 10, 18)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 16.7109, -18.3754, -5.18197)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 16.7109, -18.3754, -5.18197)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 16.7109, -18.3754, -5.18197)
    SetActorShadowPlane(manny.hActor, "shadow21")
    AddShadowPlane(manny.hActor, "shadow21")
end
me.get_nitro = function(arg1) -- line 1054
    break_here()
    si.nitrogen:get()
end
me.exit = function(arg1) -- line 1059
    if sound_playing("mePump.imu") then
        stop_sound("mePump.imu")
    end
    if sound_playing("scaryMus.imu") then
        stop_sound("scaryMus.imu")
    end
    KillActorShadows(manny.hActor)
    stop_script(me.olivia_search_idles)
end
me.camerachange = function(arg1, arg2, arg3) -- line 1073
    if arg3 == me_salcu and cutSceneLevel == 0 and not salvador.sprouted and manny.healed then
        me:salcu_setup()
    end
    if arg3 == me_shtgh then
        hector:set_visibility(TRUE)
    else
        hector:set_visibility(FALSE)
    end
    if me.sals_body.touchable then
        if arg3 == me_rerha then
            me.sals_body.act:set_visibility(TRUE)
        else
            me.sals_body.act:set_visibility(FALSE)
        end
    end
    if arg3 == me_carla and hector.dying then
        manny:say_line("/mema055/I can't leave until I know Hector is finished.")
    end
    if arg3 == me_pmpws then
        start_sfx("mePump.imu", IM_HIGH_PRIORITY, me.water_pump_vol)
        set_pan("mePump.imu", me.water_pump_pan)
    elseif sound_playing("mePump.imu") then
        fade_sfx("mePump.imu")
    end
    if arg3 == me_dorcu and me.hector_dying then
        start_sfx("scaryMus.imu")
    end
    music_state:update()
end
me.door_flowers = Object:create(me, "", 0, 0, 0, { range = 0 })
me.door_flowers:make_untouchable()
me.door_flowers.here = function(arg1) -- line 1124
    if not me.door_flowers.hObjectState then
        me.door_flowers.hObjectState = me:add_object_state(me_carla, "me_door_flowers.bm", "me_door_flowers.zbm", OBJSTATE_STATE, TRUE)
        me.door_flowers:set_object_state("me_door_flowers.cos")
    end
    SendObjectToFront(me.door_flowers.hObjectState)
    me.door_flowers:complete_chore(0)
    ForceRefresh()
end
me.darts = Object:create(me, "", 0, 0, 0, { range = 0 })
me.darts:make_untouchable()
me.backdoor = Object:create(me, "", 0, 0, 0, { range = 0 })
me.brakeson = Object:create(me, "", 0, 0, 0, { range = 0 })
me.frontdoor = Object:create(me, "", 0, 0, 0, { range = 0 })
me.salflowers = Object:create(me, "", 0, 0, 0, { range = 0 })
me.salflowers.here = function(arg1) -- line 1143
    arg1:complete_chore(0)
    box_off("flower_box1")
    box_off("flower_box2")
    box_off("flower_box3")
    box_off("flower_box4")
    break_here()
    me.door_flowers:here()
end
me.salflowers.haveTicket = function(arg1) -- line 1153
    if not sals_ticket then
        sals_ticket = Actor:create()
    end
    sals_ticket:set_costume("tix.cos")
    sals_ticket:put_in_set(me)
    sals_ticket:ignore_boxes()
    sals_ticket:set_visibility(TRUE)
    sals_ticket:setpos(17.1435, -19.8446, -7.74288)
    sals_ticket:setrot(0, 0, 0)
    sals_ticket:play_chore_looping(0, "tix.cos")
end
me.salflowers.noTicket = function(arg1) -- line 1171
    if not sals_ticket then
        sals_ticket = Actor:create()
    end
    sals_ticket:free()
end
me.leave_cu = { }
me.leave_cu.walkOut = function(arg1) -- line 1177
    me:current_setup(me_carla)
    manny:setpos(17.376, -20.0511, -7.8316)
end
me.return_trigger = { }
me.return_trigger.walkOut = function(arg1) -- line 1185
    if not manny.shot then
        start_script(me.pester_olivia)
    elseif not salvador.sprouted then
        start_script(me.setup_part2)
    elseif hi.ticket.owner == manny then
        start_script(me.ticket_radar)
    end
end
me.key = Object:create(me, "/metx043/trunk key", 0, 0, 0, { range = 0 })
me.key.string_name = "key"
me.key.wav = "getmekey.wav"
me.key.lookAt = function(arg1) -- line 1199
    manny:say_line("/mema044/")
end
me.key.use = function(arg1) -- line 1203
    manny:say_line("/mema045/")
end
me.key.default_response = me.key.use
me.gun = Object:create(me, "/metx046/gun", 0, 0, 0, { range = 0 })
me.gun.wav = "fi_grbgn.wav"
me.gun.lookAt = function(arg1) -- line 1211
    manny:say_line("/fima074/")
end
me.gun.use = function(arg1) -- line 1215
    if me:current_setup() == me_rerha then
        system.default_response("not here")
    elseif me:current_setup() == me_shtgh then
        single_start_script(me.shootout)
    else
        START_CUT_SCENE()
        manny:push_costume("md_shooting.cos")
        manny:stop_chore(md_activate_gun, "md.cos")
        manny:stop_chore(md_hold, "md.cos")
        manny:run_chore(md_shooting_pose, "md_shooting.cos")
        manny:say_line("/fima070/")
        manny:wait_for_message()
        manny:blend(md_shooting_pose_down, md_shooting_pose, 750, "md_shooting.cos")
        manny:say_line("/atma011/")
        start_script(manny.blend, manny, md_activate_gun, md_shooting_pose_down, 500, "md.cos", "md_shooting.cos")
        sleep_for(200)
        manny:play_chore(md_hold, "md.cos")
        manny:pop_costume()
        END_CUT_SCENE()
    end
end
me.gun.default_response = function(arg1) -- line 1239
    manny:say_line("/fima071/")
end
me.gun.get = function(arg1) -- line 1243
    me.setup_shootout()
    Object.get(me.gun)
end
me.suitcase = Object:create(me, "/metx047/suitcase", 18.7031, -19.8342, -7.7641602, { range = 0.60000002 })
me.suitcase.use_pnt_x = 18.479099
me.suitcase.use_pnt_y = -19.8132
me.suitcase.use_pnt_z = -7.8141599
me.suitcase.use_rot_x = 0
me.suitcase.use_rot_y = 262.80801
me.suitcase.use_rot_z = 0
me.suitcase:make_untouchable()
me.suitcase.setUp = function(arg1) -- line 1269
    if not arg1.act then
        arg1.act = Actor:create()
    end
    arg1.act:set_costume("ol_suitcase.cos")
    arg1.act:put_in_set(me)
    arg1.act:setpos(18.5508, -19.8835, -7.81814)
    arg1.act:setrot(0, 288.887, 0)
    arg1.act:play_chore(ol_suitcase_suitcase_closed)
    arg1:make_touchable()
end
me.suitcase.lookAt = function(arg1) -- line 1279
    manny:say_line("/mema048/")
end
me.suitcase.pickUp = function(arg1) -- line 1283
    manny:say_line("/mema049/")
end
me.suitcase.open = function(arg1) -- line 1287
    arg1.act:play_chore(ol_suitcase_suitcase_open, "ol_suitcase.cos")
end
me.suitcase.use = function(arg1) -- line 1291
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        if not me.ticket_free then
            me.ticket_free = TRUE
            LoadCostume("tix_hop.cos")
            manny:walkto(arg1)
            manny:wait_for_actor()
            manny:play_chore(md_reach_low, "md.cos")
            sleep_for(1000)
            arg1:open()
            manny:wait_for_chore(md_reach_low, "md.cos")
            manny:stop_chore(md_reach_low, "md.cos", 500)
            manny:say_line("/lyma009/")
            wait_for_message()
            manny:say_line("/mnma043/")
            manny:play_chore(md_reach_low, "md.cos")
            sleep_for(1000)
            start_script(me.ticket.hop_out_of_suitcase)
            manny:complete_chore(md_activate_folded_scythe, "md.cos")
            me.scy:free()
            sleep_for(1000)
            manny:wait_for_chore(md_reach_low, "md.cos")
            manny:stop_chore(md_reach_low, "md.cos")
            manny:head_look_at(me.salvador_obj)
            manny:turn_toward_entity(me.salvador_obj)
            wait_for_script(me.ticket.hop_out_of_suitcase)
            manny:say_line("/mema050/")
            manny:fade_in_chore(md_putback_small, "md.cos", 750)
            sleep_for(750)
            manny:stop_chore(md_activate_folded_scythe, "md.cos")
            manny:wait_for_chore(md_putback_small, "md.cos")
            manny:stop_chore(md_putback_small, "md.cos")
            manny:run_chore(md_takeout_empty, "md.cos")
            manny:fade_out_chore(md_takeout_empty, "md.cos")
            mo.scythe:get()
            wait_for_message()
            manny:stop_chore()
        else
            manny:twist_head_gesture()
            manny:say_line("/mema051/")
        end
        END_CUT_SCENE()
    end
end
me.olivia_obj = Object:create(me, "/metx052/Olivia", 16.499001, -19.1306, -7.3317099, { range = 0.80000001 })
me.olivia_obj.use_pnt_x = 15.7885
me.olivia_obj.use_pnt_y = -19.087601
me.olivia_obj.use_pnt_z = -7.7867098
me.olivia_obj.use_rot_x = 0
me.olivia_obj.use_rot_y = -54.771801
me.olivia_obj.use_rot_z = 0
me.olivia_obj.behindCar = function(arg1) -- line 1352
    me.olivia_obj.obj_x = 18.8026
    me.olivia_obj.obj_y = -20.2137
    me.olivia_obj.obj_z = -7.77
    me.olivia_obj.use_pnt_x = 18.0926
    me.olivia_obj.use_pnt_y = -20.2137
    me.olivia_obj.use_pnt_z = -7.77
    me.olivia_obj.use_rot_x = 0
    me.olivia_obj.use_rot_y = 264.264
    me.olivia_obj.use_rot_z = 0
    arg1:update_look_point()
end
me.olivia_obj.lookAt = function(arg1) -- line 1365
    manny:twist_head_gesture()
end
me.olivia_obj.pickUp = me.olivia_obj.lookAt
me.olivia_obj.use = me.olivia_obj.lookAt
me.car = Object:create(me, "/metx053/car", 18.214199, -19.6425, -7.36904, { range = 0.60000002 })
me.car.use_pnt_x = 18.4792
me.car.use_pnt_y = -19.8685
me.car.use_pnt_z = -7.81704
me.car.use_rot_x = 0
me.car.use_rot_y = 60.502602
me.car.use_rot_z = 0
me.car.lookAt = function(arg1) -- line 1379
    manny:say_line("/mema054/")
end
me.car.setup = function(arg1) -- line 1383
    if salvador.searched and not arg1.hObjectState then
        arg1.hObjectState = me:add_object_state(me_carla, "me_trunk.bm", nil, OBJSTATE_STATE, FALSE)
        arg1:set_object_state("me_trunk.cos")
    end
end
me.car.test = function(arg1) -- line 1390
    me.setup_part3()
    me.pm()
    salvador.searched = TRUE
    me.car:setup()
    me.gun:free()
    manny:generic_pickup(me.key)
    me.car:play_chore(me_trunk_closed)
end
me.car.use = function(arg1) -- line 1400
    if me.key.owner == manny then
        arg1:use_key()
    else
        START_CUT_SCENE()
        manny:walkto(arg1)
        manny:wait_for_actor()
        manny:run_chore(md_reach_med, "md.cos")
        manny:stop_chore(md_reach_med, "md.cos")
        END_CUT_SCENE()
        system.default_response("locked")
    end
end
me.car.use_key = function(arg1) -- line 1415
    if me.gun.owner == manny then
        manny:say_line("/fima074/")
    elseif manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        manny:stop_chore(nil, "md.cos")
        manny:play_chore(md_reach_med, "md.cos")
        sleep_for(300)
        start_sfx("me_keyin.wav")
        sleep_for(750)
        start_sfx("me_kytrn.wav")
        sleep_for(100)
        me.car:play_chore(me_trunk_open)
        sleep_for(750)
        manny:wait_for_chore(md_reach_med, "md.cos")
        manny:stop_chore(md_reach_med, "md.cos")
        manny:say_line("/mema056/")
        sleep_for(2000)
        manny:run_chore(md_use_obj)
        manny:stop_chore(md_use_obj)
        manny:play_chore(md_reach_high, "md.cos")
        sleep_for(1000)
        me.car:play_chore(me_trunk_close)
        manny:wait_for_chore(md_reach_high, "md.cos")
        manny:stop_chore(md_reach_high, "md.cos")
        me.key:put_in_limbo()
        manny.is_holding = nil
        manny:generic_pickup(me.gun)
        manny:turn_left(150)
        manny:head_look_at(nil)
        sleep_for(500)
        me.gun:use()
        END_CUT_SCENE()
        me.setup_shootout()
    end
end
me.car.pickUp = function(arg1) -- line 1454
    system.default_response("tow")
end
me.greenhouse = Object:create(me, "/metx057/greenhouse", -0.130422, -0.047307599, 2.8800001, { range = 10 })
me.greenhouse.use_pnt_x = 4.7495799
me.greenhouse.use_pnt_y = -3.86731
me.greenhouse.use_pnt_z = -2
me.greenhouse.use_rot_x = 0
me.greenhouse.use_rot_y = 398.32401
me.greenhouse.use_rot_z = 0
me.greenhouse.lookAt = function(arg1) -- line 1467
    if hector.dying then
        me.door:lookAt()
    elseif not me.shootout_begun then
        manny:say_line("/mema058/")
    else
        manny:say_line("/mema059/")
    end
end
me.greenhouse.use = function(arg1) -- line 1479
    me.door:use()
end
me.greenhouse.use_gun = function(arg1) -- line 1483
    me.gun:use()
end
me.door = Object:create(me, "/metx060/door", -0.025450001, -1.9213001, 0.49643999, { range = 0.60000002 })
me.door.use_pnt_x = -0.025450001
me.door.use_pnt_y = -2.2802999
me.door.use_pnt_z = -0.0022370601
me.door.use_rot_x = 0
me.door.use_rot_y = 326.013
me.door.use_rot_z = 0
me.door.lookAt = function(arg1) -- line 1496
    if not hector.dying then
        manny:say_line("/mema061/")
    else
        manny:say_line("/mema062/")
    end
end
me.door.use = function(arg1) -- line 1504
    if me.hector_dying == TRUE then
        if manny:walkto_object(arg1) then
            start_script(me.blow_hector_up)
        end
    elseif not manny.shot then
        if manny:walkto_object(arg1) then
            START_CUT_SCENE()
            me:current_setup(me_dorcu)
            manny:push_costume("md_green_door.cos")
            if manny.is_holding == me.gun then
                manny:complete_chore(md_green_door_show_gun, "md_green_door.cos")
            else
                manny:complete_chore(md_green_door_hide_gun, "md_green_door.cos")
            end
            manny:run_chore(md_green_door_touch_knob, "md_green_door.cos")
            END_CUT_SCENE()
            stop_script(hector.part_1_idle)
            me.greenhouse_approach_music = FALSE
            start_script(cut_scene.greenhse)
        end
    else
        soft_script()
        if me.gun.owner ~= manny then
            manny:say_line("/mema063/")
        else
            manny:say_line("/mema064/")
            wait_for_message()
            manny:say_line("/mema065/")
        end
    end
end
me.door.use_gun = me.door.use
me.tanks = Object:create(me, "/metx066/tanks", -3.50053, -15.7738, -5.7848601, { range = 1.2 })
me.tanks.use_pnt_x = -3.01353
me.tanks.use_pnt_y = -15.3618
me.tanks.use_pnt_z = -6.4458599
me.tanks.use_rot_x = 0
me.tanks.use_rot_y = 111.67
me.tanks.use_rot_z = 0
me.tanks.lookAt = function(arg1) -- line 1551
    soft_script()
    manny:say_line("/mema067/")
    wait_for_message()
    manny:say_line("/mema068/")
end
me.tanks.pickUp = function(arg1) -- line 1558
    system.default_response("right")
end
me.tanks.use = function(arg1) -- line 1562
    manny:say_line("/mema069/")
end
me.tanks.use_gun = function(arg1) -- line 1566
    if me.hector_dying then
        system.default_response("already")
    elseif manny:walkto(arg1) then
        start_script(me.kill_hector)
    end
end
me.salvador_obj = Object:create(me, "/hitx018/Salvador's head", 17.8153, -19.1085, -7.50105, { range = 0.89999998 })
me.salvador_obj.use_pnt_x = 17.6513
me.salvador_obj.use_pnt_y = -19.4725
me.salvador_obj.use_pnt_z = -7.7960501
me.salvador_obj.use_rot_x = 0
me.salvador_obj.use_rot_y = -25.660601
me.salvador_obj.use_rot_z = 0
me.salvador_obj.onGround = function(arg1) -- line 1585
    me.salvador_obj.obj_x = 17.0943
    me.salvador_obj.obj_y = -19.7879
    me.salvador_obj.obj_z = -7.85808
    me.salvador_obj.use_pnt_x = 17.2323
    me.salvador_obj.use_pnt_y = -19.8669
    me.salvador_obj.use_pnt_z = -7.85808
    me.salvador_obj.use_rot_x = 0
    me.salvador_obj.use_rot_y = 778.924
    me.salvador_obj.use_rot_z = 0
    arg1:update_look_point()
end
me.salvador_obj.lookAt = function(arg1) -- line 1599
    if me.ticket_free and not me.plucked_ticket then
        manny:say_line("/hima019/")
    else
        manny:say_line("/hima020/")
        if not salvador.sprouted then
            arg1:wakeUp()
        end
    end
end
me.salvador_obj.wakeUp = function(arg1) -- line 1610
    if not salvador.sprouted then
        START_CUT_SCENE()
        wait_for_message()
        END_CUT_SCENE()
        single_start_script(me.salvador_goodbye)
    end
end
me.salvador_obj.pickUp = function(arg1) -- line 1619
    if me.ticket_free and not me.plucked_ticket then
        START_CUT_SCENE()
        manny:walkto(arg1)
        manny:wait_for_actor()
        manny:play_chore(md_reach_low, "md.cos")
        me.salflowers:noTicket()
        me.plucked_ticket = TRUE
        me.ticket.active = TRUE
        manny:generic_pickup(me.ticket)
        manny:wait_for_chore(md_reach_low, "md.cos")
        manny:stop_chore(md_reach_low, "md.cos")
        me.ticket:dormant()
        manny:setrot(0, 1.07562, 0)
        manny:backup(750)
        start_script(me.sal_detector)
        END_CUT_SCENE()
    elseif salvador.sprouted then
        manny:say_line("/rema065/")
    else
        manny:say_line("/hima021/")
        arg1:wakeUp()
    end
end
me.salvador_obj.use = function(arg1) -- line 1646
    if salvador.sprouted then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        manny:say_line("/lwma014/")
        manny:wait_for_message()
        END_CUT_SCENE()
        single_start_script(me.salvador_goodbye)
    end
end
me.sals_body = Object:create(me, "/metx099/Salvador's body", -0.69341803, 2.9798601, -0.47968701, { range = 0.60000002 })
me.sals_body.use_pnt_x = -0.55507398
me.sals_body.use_pnt_y = 2.74944
me.sals_body.use_pnt_z = -0.413986
me.sals_body.use_rot_x = 0
me.sals_body.use_rot_y = 28.913
me.sals_body.use_rot_z = 0
me.sals_body.touchable = FALSE
me.sals_body.setup = function(arg1) -- line 1674
    if sals_ticket then
        sals_ticket:free()
    end
    if not arg1.act then
        arg1.act = Actor:create()
    end
    arg1.act:put_in_set(me)
    arg1.act:setpos(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z - 0.09)
    arg1.act:setrot(0, 0, 0)
    arg1.act:set_costume("sal_dead.cos")
    arg1.act:play_chore(0)
    arg1:make_touchable()
end
me.sals_body.lookAt = function(arg1) -- line 1685
    if salvador.searched then
        arg1:use()
    else
        manny:say_line("/sgma053/")
    end
end
me.sals_body.pickUp = function(arg1) -- line 1693
    manny:say_line("/rema065/")
end
me.sals_body.use = function(arg1) -- line 1697
    if salvador.searched then
        manny:say_line("/sima098/")
    elseif manny:walkto_object(arg1) then
        me:search_salvador()
    end
end
me.ticket = Object:create(me, "/hitx022/Double-N ticket", 0, 0, 0, { range = 0 })
me.ticket.wav = "getCard.wav"
me.ticket.string_name = "ticket"
me.ticket.lookAt = function(arg1) -- line 1713
    if arg1.owner == manny then
        if arg1.active then
            if arg1.activator == me.salvador_obj then
                manny:say_line("/hima019/")
            else
                manny:say_line("/hima024/")
            end
        else
            manny:say_line("/hima025/")
        end
    else
        manny:say_line("/hima023/")
    end
end
me.ticket.use = me.ticket.lookAt
me.ticket.hop_out_of_suitcase = function(arg1) -- line 1731
    if not sals_ticket then
        sals_ticket = Actor:create()
    end
    sals_ticket:set_costume("tix_hop.cos")
    sals_ticket:setpos(18.6235, -20.0066, -7.61188)
    sals_ticket:setrot(351.075, 182.103, 103.151)
    sals_ticket:put_in_set(me)
    sals_ticket:play_chore(0)
    sals_ticket:wait_for_chore(0)
    me.salflowers:haveTicket()
end
me.ticket.activated = function(arg1, arg2) -- line 1742
    arg1.activator = arg2
    if not arg1.active or arg1.to_update then
        arg1.active = TRUE
        arg1.to_update = FALSE
        manny:stop_chore(md_hold, "md.cos")
        manny:stop_chore(md_activate_tix_nowig, "md.cos")
        manny:play_chore_looping(md_activate_ticket, "md.cos")
        manny:play_chore(md_hand_on_obj, "md.cos")
        start_script(me.ticket.sound_monitor, me.ticket)
    end
end
me.ticket.sound_monitor = function(arg1) -- line 1755
    local local1, local2, local3
    single_start_sfx("tixvibe.imu", nil, 0)
    PrintDebug("starting sfx!\n")
    fade_sfx("tixvibe.imu", 500, 60)
    while 1 do
        local1 = object_proximity(me.salvador_obj)
        local2 = object_proximity(me.sals_body)
        if local1 > local2 then
            local1 = local2
        end
        if local1 < 1 then
            local1 = 1
        end
        local3 = 4 * 35 / local1
        if local3 > 64 then
            local3 = 64
        end
        if local3 < 5 then
            local3 = 5
        end
        set_vol("tixvibe.imu", local3)
        break_here()
    end
end
me.ticket.dormant = function(arg1) -- line 1777
    arg1.activator = nil
    if arg1.active or arg1.to_update then
        arg1.active = FALSE
        arg1.to_update = FALSE
        stop_script(me.ticket.sound_monitor)
        PrintDebug("stopping sfx!\n")
        fade_sfx("tixvibe.imu")
        manny:stop_chore(md_hand_on_obj, "md.cos")
        manny:stop_chore(md_activate_ticket, "md.cos")
        manny:play_chore_looping(md_hold, "md.cos")
        manny:play_chore_looping(md_activate_tix_nowig, "md.cos")
    end
end
me.ticket.takeout_flag = function(arg1) -- line 1792
    PrintDebug("starting sal_detector!\n")
    single_start_script(me.sal_detector)
    wait_for_script(close_inventory)
    arg1.to_update = TRUE
end
me.ticket.putback_flag = function(arg1) -- line 1799
    PrintDebug("stopping sal_detector!\n")
    stop_script(me.sal_detector)
    stop_script(me.ticket.sound_monitor)
    fade_sfx("tixvibe.imu")
    manny:stop_chore(md_activate_tix_nowig, "md.cos")
    manny:stop_chore(md_hand_on_obj, "md.cos")
    manny:play_chore_looping(md_activate_ticket, "md.cos")
end
CheckFirstTime("ly.lua")
dofile("br_idles.lua")
dofile("cc_taplook.lua")
dofile("cc_play_slot.lua")
dofile("meche_seduction.lua")
dofile("cc_seduction.lua")
dofile("unicycle_man.lua")
dofile("ly_slot_door.lua")
dofile("msb_msb_sheet.lua")
dofile("meche_ruba.lua")
dofile("cc_toga.lua")
dofile("mi_with_cc_toga.lua")
dofile("ly_cc_sheet.lua")
ly = Set:create("ly.set", "le mans lobby", { ly_top = 0, ly_intha = 1, ly_intha1 = 1, ly_intha2 = 1, ly_intha3 = 1, ly_intha4 = 1, ly_intha5 = 1, ly_intha6 = 1, ly_intha7 = 1, ly_sltha = 2, ly_chaws = 3, ly_elems = 4, ly_kenla = 5, ly_lavha = 6 })
ly.unicycle_roll_min_vol = 5
ly.unicycle_roll_max_vol = 20
slot_wheel = { parent = Actor }
slot_wheel.pitch = { }
slot_wheel.pitch[1] = { 30, 105, 175, 280 }
slot_wheel.pitch[2] = { 140, 210, 315 }
slot_wheel.pitch[3] = { 65, 245 }
slot_wheel.pitch[4] = { 350 }
slot_wheel.create = function(arg1) -- line 42
    local local1
    local local2
    local1 = Actor:create(nil, nil, nil, "slot wheel")
    local1.parent = arg1
    local2 = rndint(1, 4)
    local1.cur_pitch = arg1.pitch[local2][1]
    local1.slot = FALSE
    return local1
end
slot_wheel.default = function(arg1) -- line 55
    arg1:set_costume("ly_slotwheel.cos")
    arg1:put_in_set(ly)
    arg1:setrot(arg1.cur_pitch, 270, 90)
end
slot_wheel.spin = function(arg1) -- line 61
    local local1
    local local2
    local local3
    local local4 = { "ly_wlsp1.WAV", "ly_wlsp2.WAV", "ly_wlsp3.WAV" }
    local2 = arg1:get_positive_rot()
    local1 = 10
    arg1.slot = nil
    while arg1.slot == nil do
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        arg1.cur_pitch = arg1.cur_pitch - local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        if local1 < 60 then
            local1 = local1 + 1
        end
        break_here()
    end
    local3 = FALSE
    while not local3 do
        if local1 > 5 then
            local1 = local1 - 1
        end
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
    arg1:play_sound_at(pick_one_of(local4, TRUE))
end
slot_wheel.scramble_to_win = function(arg1) -- line 107
    local local1
    local local2, local3
    arg1.slot = 4
    local2 = arg1:get_positive_rot()
    if rnd(5) then
        local1 = 5
    else
        local1 = -5
    end
    local3 = FALSE
    arg1.cur_pitch = local2.x
    while not local3 do
        arg1.cur_pitch = arg1.cur_pitch + local1
        if arg1.cur_pitch < 0 then
            arg1.cur_pitch = arg1.cur_pitch + 360
        end
        if arg1.cur_pitch > 360 then
            arg1.cur_pitch = arg1.cur_pitch - 360
        end
        arg1:setrot(arg1.cur_pitch, local2.y, local2.z)
        if arg1:check_match() then
            local3 = TRUE
        else
            break_here()
        end
    end
end
slot_wheel.check_match = function(arg1) -- line 137
    local local1, local2
    local local3
    local3 = FALSE
    local1, local2 = next(arg1.pitch[arg1.slot], nil)
    while local1 and not local3 do
        if abs(local2 - arg1.cur_pitch) < 5 then
            local3 = TRUE
        end
        local1, local2 = next(arg1.pitch[arg1.slot], local1)
    end
    return local3
end
slot_machine = { }
slot_machine.create = function(arg1) -- line 156
    local local1
    local1 = { }
    local1.parent = arg1
    local1.actors = { }
    local1.pos = { }
    local1.rot = nil
    local1.spinning = FALSE
    return local1
end
slot_machine.create_wheels = function(arg1) -- line 169
    local local1
    if not arg1.actors then
        arg1.actors = { }
    end
    local1 = 1
    while local1 <= 3 do
        if not arg1.actors[local1] then
            arg1.actors[local1] = slot_wheel:create()
        end
        local1 = local1 + 1
    end
end
slot_machine.free = function(arg1) -- line 185
    if arg1.actors then
        if arg1.actors[1] then
            arg1.actors[1]:free()
        end
        if arg1.actors[2] then
            arg1.actors[2]:free()
        end
        if arg1.actors[3] then
            arg1.actors[3]:free()
        end
    end
    arg1.actors = nil
end
slot_machine.default = function(arg1) -- line 200
    local local1
    arg1:create_wheels()
    local1 = 1
    while local1 <= 3 do
        arg1.actors[local1]:default()
        arg1.actors[local1]:setpos(arg1.pos[local1].x, arg1.pos[local1].y, arg1.pos[local1].z)
        if arg1.rot then
            arg1.actors[local1]:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
        end
        local1 = local1 + 1
    end
end
slot_machine.spin = function(arg1) -- line 216
    arg1.spin_scripts = { }
    arg1.spinning = TRUE
    arg1.wheel_sound = arg1.actors[1]:play_sound_at("ly_wheel.IMU", 10, 80)
    arg1.spin_scripts[1] = start_script(arg1.actors[1].spin, arg1.actors[1])
    break_here()
    arg1.spin_scripts[2] = start_script(arg1.actors[2].spin, arg1.actors[2])
    break_here()
    arg1.spin_scripts[3] = start_script(arg1.actors[3].spin, arg1.actors[3])
end
slot_machine.scramble_to_win = function(arg1) -- line 229
    local local1, local2, local3
    local1 = start_script(arg1.actors[1].scramble_to_win, arg1.actors[1])
    local2 = start_script(arg1.actors[2].scramble_to_win, arg1.actors[2])
    local3 = start_script(arg1.actors[3].scramble_to_win, arg1.actors[3])
    wait_for_script(local1)
    wait_for_script(local2)
    wait_for_script(local3)
end
slot_machine.stop = function(arg1, arg2) -- line 239
    local local1
    local local2
    if arg1.spinning then
        local1 = FALSE
        local2 = { }
        repeat
            local2[1] = rndint(1, 4)
            local2[2] = rndint(1, 4)
            local2[3] = rndint(1, 4)
            if not arg2 then
                if local2[1] == local2[2] and local2[2] == local2[3] then
                    local1 = FALSE
                else
                    local1 = TRUE
                end
            elseif local2[1] == local2[2] and local2[2] == local2[3] then
                local1 = TRUE
            else
                local1 = FALSE
            end
            if not local1 then
                break_here()
            end
        until local1
        arg1.actors[1].slot = local2[1]
        if arg1.spin_scripts[1] then
            wait_for_script(arg1.spin_scripts[1])
        end
        sleep_for(100)
        arg1.actors[2].slot = local2[2]
        if arg1.spin_scripts[2] then
            wait_for_script(arg1.spin_scripts[2])
        end
        sleep_for(100)
        arg1.actors[3].slot = local2[3]
        if arg1.spin_scripts[3] then
            wait_for_script(arg1.spin_scripts[3])
        end
    end
    arg1.spinning = FALSE
    stop_sound("ly_wheel.IMU")
    arg1.spin_scripts = nil
end
slot_machine.freeze = function(arg1) -- line 295
    arg1.actors[1]:freeze()
    arg1.actors[2]:freeze()
    arg1.actors[3]:freeze()
end
slot_machine.thaw = function(arg1, arg2) -- line 301
    arg1.actors[1]:thaw(arg2)
    arg1.actors[2]:thaw(arg2)
    arg1.actors[3]:thaw(arg2)
end
ly.slot_handle = { }
ly.slot_handle.parent = Actor
ly.slot_handle.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 312
    local local1
    local1 = Actor:create(nil, nil, nil, "handle")
    local1.parent = ly.slot_handle
    if arg2 then
        local1.pos = { }
        local1.pos.x = arg2
        local1.pos.y = arg3
        local1.pos.z = arg4
    end
    if arg5 then
        local1.rot = { }
        local1.rot.x = arg5
        local1.rot.y = arg6
        local1.rot.z = arg7
    end
    return local1
end
ly.slot_handle.default = function(arg1) -- line 333
    arg1:put_in_set(ly)
    arg1:set_costume("ly_slothandle.cos")
    arg1:play_chore(1)
    if arg1.pos then
        arg1:setpos(arg1.pos.x, arg1.pos.y, arg1.pos.z)
    end
    if arg1.rot then
        arg1:setrot(arg1.rot.x, arg1.rot.y, arg1.rot.z)
    end
end
ly.slot_handle.init = function(arg1) -- line 345
    if not arg1[1] then
        arg1[1] = ly.slot_handle:create(0.63847, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[2] then
        arg1[2] = ly.slot_handle:create(1.05447, 0.401519, 0.006, 0, 0, 0)
    end
    if not arg1[3] then
        arg1[3] = ly.slot_handle:create(1.82115, -0.135567, 0.015, 0, 270, 0)
    end
    if not arg1[4] then
        arg1[4] = ly.slot_handle:create(1.82285, -0.541493, 0.013, 0, 270, 0)
    end
    arg1[1]:default()
    arg1[2]:default()
    arg1[3]:default()
    arg1[4]:default()
    arg1[4]:set_visibility(FALSE)
    arg1[1]:freeze()
    arg1[2]:freeze()
end
ly.slot_handle.free = function(arg1) -- line 369
    if arg1[1] then
        arg1[1]:free()
    end
    if arg1[2] then
        arg1[2]:free()
    end
    if arg1[3] then
        arg1[3]:free()
    end
end
charlies_slot = slot_machine:create()
charlies_slot.pos[1] = { x = 2.1475301, y = -0.416738, z = 0.44400001 }
charlies_slot.pos[2] = { x = 2.1475301, y = -0.492737, z = 0.44400001 }
charlies_slot.pos[3] = { x = 2.1475301, y = -0.569736, z = 0.44400001 }
mannys_slot = slot_machine:create()
mannys_slot.pos[1] = { x = 2.1358399, y = -0.0144972, z = 0.44499999 }
mannys_slot.pos[2] = { x = 2.1358399, y = -0.0924972, z = 0.44499999 }
mannys_slot.pos[3] = { x = 2.1358399, y = -0.169497, z = 0.44499999 }
ly.keno_actor = Actor:create(nil, nil, nil, "keno board")
ly.keno_actor.current_number = nil
ly.keno_actor.current_game = nil
ly.keno_actor.game_index = 1
ly.keno_actor.game_paused = FALSE
ly.keno_actor.default = function(arg1) -- line 417
    arg1:set_costume("ly_keno.cos")
    arg1:put_in_set(ly)
    arg1:setpos(-0.0558433, -0.0978411, 2.801)
    arg1:set_visibility(TRUE)
end
ly.keno_actor.game = function(arg1) -- line 424
    while TRUE do
        arg1:clear_game()
        while arg1.game_index < 10 do
            if not arg1.game_paused then
                arg1:choose_number()
            end
            sleep_for(15000)
        end
        break_here()
    end
end
ly.keno_actor.clear_game = function(arg1) -- line 437
    arg1.current_game = { }
    arg1.game_index = 0
    arg1.current_number = nil
    arg1:complete_chore(32)
end
ly.keno_actor.choose_number = function(arg1) -- line 444
    local local1, local2
    local2 = TRUE
    while local2 do
        local1 = rndint(1, 32)
        if not arg1:find_number(local1) then
            local2 = FALSE
        else
            break_here()
        end
    end
    arg1.game_index = arg1.game_index + 1
    arg1.current_game[arg1.game_index] = local1
    arg1.current_number = local1
    arg1:complete_chore(local1 - 1)
    arg1:play_sound_at("ly_keno.wav", 10, 70)
end
ly.keno_actor.find_number = function(arg1, arg2) -- line 463
    local local1, local2
    local2 = FALSE
    local1 = 1
    while local1 <= arg1.game_index and not local2 do
        if arg1.current_game[local1] == arg2 then
            local2 = TRUE
        end
        local1 = local1 + 1
    end
    return local2
end
unicycle_man.point = { }
unicycle_man.point[0] = { }
unicycle_man.point[0].pos = { x = 0.89800102, y = 0.39131901, z = 0 }
unicycle_man.point[0].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point[1] = { }
unicycle_man.point[1].pos = { x = 0.49000099, y = 0.394319, z = 0 }
unicycle_man.point[1].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.mid = { }
unicycle_man.point["mid"].pos = { x = 0.74000102, y = 0.090319097, z = 0 }
unicycle_man.point["mid"].rot = { x = 0, y = 0, z = 0 }
unicycle_man.point.charlie = { }
unicycle_man.point["charlie"].pos = { x = 1.84929, y = -0.39064199, z = 0 }
unicycle_man.point["charlie"].rot = { x = 0, y = 270.01999, z = 0 }
unicycle_man.cur_point = 0
unicycle_man.save_pos = function(arg1) -- line 499
    arg1.current_pos = arg1:getpos()
    arg1.current_rot = arg1:getrot()
end
unicycle_man.restore_pos = function(arg1) -- line 504
    local local1
    if arg1.current_pos then
        arg1:setpos(arg1.current_pos.x, arg1.current_pos.y, arg1.current_pos.z)
        arg1:setrot(arg1.current_rot.x, arg1.current_rot.y, arg1.current_rot.z)
    else
        local1 = arg1.point[arg1.cur_point]
        arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
        arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
    end
end
unicycle_man.cycle_to = function(arg1, arg2, arg3) -- line 517
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg1.point.mid.pos)
    local1 = local1 + 180
    arg1:set_turn_rate(120)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:setrot(0, local1, 0, TRUE)
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(-0.30000001)
    while proximity(arg1.hActor, arg1.point.mid.pos.x, arg1.point.mid.pos.y, arg1.point.mid.pos.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:stop_chore(unicycle_man_roll)
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    arg1:stop_chore(unicycle_man_idles)
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.cycle_straight_to = function(arg1, arg2, arg3) -- line 564
    local local1
    local1 = GetActorYawToPoint(arg1.hActor, arg2)
    arg1:set_turn_rate(120)
    arg1:stop_chore(unicycle_man_idles)
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    arg1:play_chore_looping(unicycle_man_roll)
    arg1:set_walk_rate(0.30000001)
    arg1:setrot(0, local1, 0, TRUE)
    while proximity(arg1.hActor, arg2.x, arg2.y, arg2.z) > 0.1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
    arg1:setpos(arg2.x, arg2.y, arg2.z)
    arg1:stop_chore(unicycle_man_roll)
    stop_sound("um_roll.IMU")
    arg1:play_chore_looping(unicycle_man_idles)
    arg1:setrot(arg3.x, arg3.y, arg3.z, TRUE)
end
unicycle_man.turn_to_manny = function(arg1) -- line 591
    local local1, local2
    local2 = manny:getpos()
    if not sound_playing("um_roll.IMU") then
        arg1:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
    end
    local1 = GetActorYawToPoint(arg1.hActor, local2)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    stop_sound("um_roll.IMU")
end
ly.agent_talk_count = 0
ly.talk_to_agent = function(arg1) -- line 610
    local local1 = TRUE
    local local2 = FALSE
    local local3, local4
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    manny:set_collision_mode(COLLISION_OFF)
    ly.agent_talk_count = ly.agent_talk_count + 1
    if ly.agent_talk_count == 1 then
        ly.met_agent = TRUE
        manny:say_line("/lyma066/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum067/")
        unicycle_man:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:say_line("/lyum068/")
        unicycle_man:wait_for_message()
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        manny:tilt_head_gesture(TRUE)
        manny:point_gesture(TRUE)
        manny:say_line("/lyma069/")
        manny:wait_for_message()
        unicycle_man:say_line("/lyum070/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum071/")
        unicycle_man:wait_for_message()
    elseif ly.agent_talk_count == 2 then
        manny:say_line("/lyma072/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        unicycle_man:turn_to_manny()
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        unicycle_man:say_line("/lyum073/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum074/")
        unicycle_man:wait_for_message()
        manny:say_line("/lyma075/")
    elseif ly.meche_talk_count < 2 then
        manny:say_line("/lyma076/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        local3 = unicycle_man:getpos()
        local4 = GetActorYawToPoint(manny.hActor, local3)
        manny:setrot(0, local4, 0, TRUE)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum077/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum078/")
        unicycle_man:wait_for_message()
        local2 = TRUE
    elseif not ly.charlie_on_floor then
        manny:say_line("/lyma079/")
        manny:wait_for_message()
        wait_for_script(ly.unicycle_stop_idles)
        ly:track_unicycle_man()
        manny:head_look_at(ly.unicycle_man)
        unicycle_man:turn_to_manny()
        unicycle_man:say_line("/lyum080/")
        unicycle_man:wait_for_message()
        unicycle_man:say_line("/lyum081/")
        unicycle_man:wait_for_message()
    else
        local1 = FALSE
        start_script(ly.charlies_jackpot)
    end
    END_CUT_SCENE()
    manny:set_collision_mode(COLLISION_OFF)
    if local1 then
        start_script(ly.unicycle_idles, ly, local2)
    end
end
ly.unicycle_idles = function(arg1, arg2) -- line 708
    local local1, local2
    unicycle_man.in_machine = FALSE
    unicycle_man.rolling = FALSE
    while TRUE do
        break_here()
        ly:track_unicycle_man()
        if not arg2 then
            local1 = unicycle_man.cur_point + 1
            if not unicycle_man.point[local1] then
                local1 = 0
            end
            unicycle_man.cur_point = local1
            unicycle_man.rolling = TRUE
            start_script(unicycle_man.cycle_to, unicycle_man, unicycle_man.point[local1].pos, unicycle_man.point[local1].rot)
            while find_script(unicycle_man.cycle_to) do
                break_here()
                ly:track_unicycle_man()
            end
            unicycle_man.rolling = FALSE
            sleep_for(10000)
        else
            local1 = unicycle_man.cur_point
            unicycle_man:setrot(unicycle_man.point[local1].rot.x, unicycle_man.point[local1].rot.y, unicycle_man.point[local1].rot.z, TRUE)
            unicycle_man:wait_for_actor()
        end
        unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
        unicycle_man:wait_for_chore(unicycle_man_idles)
        unicycle_man.in_machine = TRUE
        unicycle_man:run_chore(unicycle_man_crawl_slot)
        start_script(ly.unicycle_slot_sfx)
        sleep_for(rndint(6000, 9000))
        unicycle_man:play_sound_at("ly_pyoff.IMU", 80, 110)
        unicycle_man:run_chore(unicycle_man_out_slot)
        fade_sfx("ly_pyoff.IMU", 200)
        unicycle_man:play_chore_looping(unicycle_man_idles)
        unicycle_man.in_machine = FALSE
        sleep_for(10000)
    end
end
ly.unicycle_stop_idles = function(arg1) -- line 762
    stop_sound("ly_pyoff.IMU")
    stop_script(ly.unicycle_idles)
    if unicycle_man.rolling then
        while find_script(unicycle_man.cycle_to) do
            break_here()
            ly:track_unicycle_man()
        end
        unicycle_man.rolling = FALSE
    elseif unicycle_man.in_machine then
        if unicycle_man:is_choring(unicycle_man_crawl_slot) then
            unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
            unicycle_man:run_chore(unicycle_man_out_slot)
        elseif unicycle_man:is_choring(unicycle_man_out_slot) then
            unicycle_man:wait_for_chore(unicycle_man_out_slot)
        else
            unicycle_man:run_chore(unicycle_man_out_slot)
        end
    end
    unicycle_man:play_chore_looping(unicycle_man_idles)
end
ly.track_unicycle_man = function(arg1) -- line 788
    local local1
    local1 = unicycle_man:getpos()
    ly.unicycle_man.obj_x = local1.x
    ly.unicycle_man.obj_y = local1.y
    ly.unicycle_man.obj_z = local1.z + 0.40000001
    ly.unicycle_man.interest_actor:put_in_set(ly)
    ly.unicycle_man.interest_actor:setpos(ly.unicycle_man.obj_x, ly.unicycle_man.obj_y, ly.unicycle_man.obj_z)
    if hot_object == ly.unicycle_man then
        system.currentActor:head_look_at(ly.unicycle_man)
    end
end
ly.unicycle_slot_sfx = function(arg1) -- line 802
    local local1 = { "um_swit1.wav", "um_swit2.wav", "um_swit3.wav" }
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
    sleep_for(rndint(1000, 2000))
    unicycle_man:play_sound_at(pick_one_of(local1, TRUE), 100, 127)
end
ly.brennis_idle_table = Idle:create("br_idles")
idt = ly.brennis_idle_table
idt:add_state("rest", { rest = 0.97000003, looks = 0.0099999998, moves_head = 0.0099999998, scrtch_chst = 0.0099999998 })
idt:add_state("looks", { rest = 1 })
idt:add_state("moves_head", { rest = 1 })
idt:add_state("scrtch_chst", { rest = 1 })
ly.brennis_talk_count = 0
ly.brennis_stop_idle = function(arg1) -- line 830
    stop_script(brennis.ly_idle_script)
    brennis.ly_idle_script = nil
    brennis:wait_for_chore()
    brennis:play_chore(br_idles_rest)
end
ly.brennis_start_idle = function(arg1) -- line 837
    brennis:stop_chore()
    brennis.ly_idle_script = start_script(brennis.new_run_idle, brennis, "rest", ly.brennis_idle_table, "br_idles.cos")
end
ly.talk_clothes_with_brennis = function(arg1) -- line 842
    START_CUT_SCENE()
    ly.brennis_talk_count = ly.brennis_talk_count + 1
    start_script(ly.brennis_stop_idle, ly)
    if ly.brennis_talk_count == 1 then
        ly:current_setup(ly_kenla)
        sleep_for(1500)
        manny:tilt_head_gesture()
        manny:say_line("/lyma012/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs013/")
        brennis:wait_for_message()
        brennis:say_line("/lybs014/")
    elseif ly.brennis_talk_count == 2 then
        ly:current_setup(ly_kenla)
        manny:shrug_gesture()
        manny:say_line("/lyma015/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_scrtch_chst, "br_idles.cos")
        brennis:say_line("/lybs016/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma017/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs018/")
    elseif ly.brennis_talk_count == 3 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma019/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs020/")
        brennis:wait_for_message()
        brennis:say_line("/lybs021/")
        brennis:wait_for_message()
        brennis:say_line("/lybs022/")
        brennis:wait_for_message()
    elseif ly.brennis_talk_count == 4 then
        ly:current_setup(ly_kenla)
        manny:hand_gesture()
        manny:say_line("/lyma023/")
        manny:wait_for_message()
        manny:tilt_head_gesture()
        manny:say_line("/lyma024/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:play_chore(br_idles_bar_door, "br_idles.cos")
        brennis:say_line("/lybs025/")
        brennis:wait_for_message()
        brennis:say_line("/lybs026/")
        brennis:wait_for_chore(br_idles_bar_door, "br_idles.cos")
    elseif ly.brennis_talk_count == 5 then
        ly:current_setup(ly_kenla)
        manny:point_gesture()
        manny:say_line("/lyma027/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs028/")
        brennis:wait_for_message()
        brennis:say_line("/lybs029/")
        brennis:wait_for_message()
        brennis:say_line("/lybs030/")
        brennis:wait_for_message()
        ly:current_setup(ly_kenla)
        manny:say_line("/lyma031/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs032/")
    else
        ly:current_setup(ly_kenla)
        manny:twist_head_gesture()
        manny:say_line("/lyma033/")
        manny:wait_for_message()
        ly:current_setup(ly_elems)
        brennis:say_line("/lybs034/")
    end
    END_CUT_SCENE()
    brennis:wait_for_chore()
    ly:brennis_start_idle()
end
ly.meche_talk_count = 0
ly.gun_control = function() -- line 947
    while TRUE do
        break_here()
        if manny.is_holding == fi.gun and system.currentSet == ly then
            START_CUT_SCENE()
            wait_for_script(open_inventory)
            wait_for_script(close_inventory)
            manny:clear_hands()
            manny:say_line("/lyma003/")
            manny:wait_for_message()
            manny:say_line("/lyma004/")
            END_CUT_SCENE()
        end
    end
end
ly.playslots = function(arg1, arg2) -- line 963
    START_CUT_SCENE()
    manny:walkto(1.8283, -0.263458, 0, 0, 292.582, 0)
    manny:wait_for_actor()
    manny:head_look_at(nil)
    ly.slot_handle[3]:thaw(TRUE)
    mannys_slot:thaw(TRUE)
    ly.slot_handle[3]:play_chore(0)
    sleep_for(50)
    manny:play_chore(msb_reach_cabinet, manny.base_costume)
    sleep_for(500)
    mannys_slot:spin()
    sleep_for(500)
    manny:head_look_at(ly.slot1)
    if not ly.played then
        ly.played = TRUE
        manny:say_line("/lyma006/")
        wait_for_message()
        manny:say_line("/lyma007/")
        wait_for_message()
    end
    manny:wait_for_chore(msb_reach_cabinet, manny.base_costume)
    manny:stop_chore(msb_reach_cabinet, manny.base_costume)
    manny:head_look_at(ly.slot1)
    ly.slot_handle[3]:wait_for_chore(0)
    ly.slot_handle[3]:freeze()
    if rnd() then
        mannys_slot:stop(FALSE)
        if not ly.lost then
            ly.lost = TRUE
            manny:say_line("/lyma008/")
        end
    else
        mannys_slot:stop(TRUE)
        manny:say_line("/lyma009/")
        if not ly.won then
            ly.won = TRUE
            manny:wait_for_message()
            manny:head_look_at_point(1.89026, -0.0954438, 0)
            manny:say_line("/lyma010/")
            manny:wait_for_message()
            manny:say_line("/lyma011/")
        end
    end
    END_CUT_SCENE()
    manny:head_look_at(nil)
    mannys_slot:freeze()
end
ly.talk_clothes_with_meche = function(arg1) -- line 1019
    START_CUT_SCENE()
    if ly.charlie_on_floor then
        meche:say_line("/lymc005/")
    else
        ly.meche_talk_count = ly.meche_talk_count + 1
        if ly.meche_talk_count == 1 then
            single_start_script(ly.seduce_charlie, ly)
            manny:say_line("/lyma035/")
            manny:wait_for_message()
            meche:say_line("/lymc036/")
        elseif ly.meche_talk_count == 2 then
            manny:walkto_object(ly.meche_obj)
            manny:wait_for_actor()
            if find_script(ly.seduce_charlie) and ly.meche_obj.touchable then
                stop_script(ly.seduce_charlie)
            end
            manny:say_line("/lyma037/")
            manny:wait_for_message()
            while not ly.meche_obj.touchable do
                break_here()
            end
            meche:say_line("/lymc038/")
            meche:wait_for_message()
            meche:say_line("/lymc039/")
            meche:wait_for_message()
            meche:say_line("/lymc040/")
            ly:manny_take_sheet_from_meche()
        elseif ly.meche_talk_count == 3 then
            manny:say_line("/lyma041/")
            manny:wait_for_message()
            meche:say_line("/lymc042/")
            meche:wait_for_message()
            meche:say_line("/lymc043/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
            meche:wait_for_message()
            manny:say_line("/lyma044/")
        else
            manny:say_line("/lyma045/")
            manny:wait_for_message()
            meche:say_line("/lymc046/")
            if manny.is_holding ~= ly.sheet then
                ly:manny_take_sheet_from_meche()
            end
        end
    end
    END_CUT_SCENE()
end
ly.manny_take_sheet_from_meche = function(arg1) -- line 1071
    manny:walkto_object(ly.meche_obj)
    manny:wait_for_actor()
    if meche:is_choring(meche_seduction_mec_sed_ch, FALSE, "meche_seduction.cos") then
        meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    end
    stop_script(ly.seduce_charlie)
    stop_script(ly.meche_idles)
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(0, "mi_msb_sheet.cos")
    manny:push_costume("msb_msb_sheet.cos")
    manny:setrot(0, 231.446, 0)
    manny:play_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    ly.sheet:get()
    manny.is_holding = ly.sheet
    meche:wait_for_chore(0, "mi_msb_sheet.cos")
    meche:stop_chore(0, "mi_msb_sheet.cos")
    meche:play_chore(meche_ruba_hands_down_hold, "meche_ruba.cos")
    manny:wait_for_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_pass_sheet, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:stop_chore(msb_msb_sheet_to_hold_pos, "msb_msb_sheet.cos")
    manny:run_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    meche.holding_sheet = FALSE
    inventory_disabled = TRUE
    ly.ready_to_seduce = FALSE
    single_start_script(ly.meche_idles)
end
ly.talk_toga_with_charlie = function(arg1) -- line 1101
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    manny:walkto_object(ly.charlie_obj)
    if ly.meche_talk_count < 3 then
        manny:say_line("/lyma047/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc048/")
        charlie:run_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    else
        manny:say_line("/lyma049/")
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        if find_script(ly.seduce_charlie) then
            while ly.ready_to_seduce do
                break_here()
            end
        end
        manny:wait_for_message()
        charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlie:push_costume("cc_taplook.cos")
        charlie:run_chore(cc_taplook_turn2mn, "cc_taplook.cos")
        charlie:say_line("/lycc050/")
        charlie:wait_for_message()
        charlie:play_chore(cc_taplook_turn2slots, "cc_taplook.cos")
        charlie:say_line("/lycc051/")
        charlie:wait_for_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    end
    if not find_script(charlies_slot.stop) then
        charlies_slot:stop()
    else
        wait_for_script(charlies_slot.stop)
    end
    charlie:stop_chore(cc_taplook_turn2slots, "cc_taplook.cos")
    charlie:pop_costume()
    start_script(ly.charlie_idles, ly)
    END_CUT_SCENE()
end
ly.throw_sheet = function(arg1) -- line 1149
    START_CUT_SCENE()
    stop_script(ly.charlie_idles)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    stop_script(charlies_slot.stop)
    stop_sound("ly_wheel.IMU")
    stop_script(slot_wheel.spin)
    if not ly.sheet_on_floor.has_object_states then
        ly:add_object_state(ly_sltha, "ly_cc_sheet.bm", "ly_cc_sheet.zbm", OBJSTATE_STATE, TRUE)
        ly.sheet_on_floor:set_object_state("ly_cc_sheet.cos")
        ly.sheet_on_floor.interest_actor:put_in_set(ly)
    end
    ly.sheet:free()
    ly.charlie_on_floor = TRUE
    ly.charlie_obj:make_untouchable()
    box_off("charlie_box")
    box_off("mannys_slot")
    manny.is_holding = nil
    manny:stop_chore(msb_msb_sheet_hold_sheet, "msb_msb_sheet.cos")
    inventory_disabled = FALSE
    manny:pop_costume()
    manny:setpos(1.50568, -0.210109, 0)
    manny:setrot(0, 176.891, 0)
    charlie:stop_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
    charlie:set_visibility(FALSE)
    ly.sheet_on_floor:play_chore(ly_cc_sheet_here)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_sheet_toss.snm")
    sleep_for(500)
    start_sfx("cc_shtts.WAV")
    ly.slot_handle[4]:set_visibility(TRUE)
    sleep_for(1000)
    if not ly.sheeted then
        ly.sheeted = TRUE
        charlie:say_line("/lycc052/")
    else
        charlie:say_line("/lycc053/")
    end
    sleep_for(4600)
    start_sfx("ccsheet1.wav")
    sleep_for(1250)
    start_sfx("cc_falls.wav")
    charlie:wait_for_message()
    charlie:say_line("/lycc054/")
    charlie:wait_for_message()
    ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
    wait_for_movie()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    start_script(ly.charlie_struggle)
    start_script(ly.charlie_get_up_timer)
    END_CUT_SCENE()
end
ly.charlie_struggle = function(arg1) -- line 1226
    local local1
    local local2 = { "/lycc055/", "/lycc056/", "/lycc057/", "/lycc058/", "/lycc059/", "/lycc060/", "/lycc061/", "/lycc062/", "/lycc063/" }
    while TRUE do
        sleep_for(2000)
        ly.sheet_on_floor:play_chore(ly_cc_sheet_protest)
        local1 = pick_one_of({ "ccsheet1.wav", "ccsheet2.wav", "ccsheet3.wav", "ccsheet4.wav", "ccsheet5.wav", "ccsheet6.wav" })
        start_sfx(local1, IM_HIGH_PRIORITY, 100)
        charlie:say_line(pick_one_of(local2, TRUE), { background = TRUE, skip_log = TRUE, volume = 80 })
        charlie:wait_for_message()
    end
end
ly.charlie_get_up_timer = function(arg1) -- line 1248
    sleep_for(25000)
    stop_script(ly.charlie_struggle)
    while cutSceneLevel > 0 do
        break_here()
    end
    START_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.charlie_obj:make_touchable()
    box_on("charlie_box")
    box_on("mannys_slot")
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_getup.snm")
    charlie:set_visibility(TRUE)
    ly.slot_handle[4]:set_visibility(FALSE)
    stop_script(ly.meche_idles)
    charlie:push_costume("cc_seduction.cos")
    charlie:play_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche.holding_sheet = TRUE
    sleep_for(2000)
    start_sfx("ccsheet1.wav")
    sleep_for(2500)
    start_sfx("cc_shtof.WAV")
    charlie:say_line("/lycc064/", { volume = 90 })
    wait_for_movie()
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    if not unicycle_man.in_machine then
        if not unicycle_man.rolling then
        elseif not sound_playing("um_roll.IMU") then
            unicycle_man:play_sound_at("um_roll.IMU", ly.unicycle_roll_min_vol, ly.unicycle_roll_max_vol)
        end
    end
    charlie:wait_for_message()
    charlie:say_line("/lycc065/")
    charlie:wait_for_message()
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    END_CUT_SCENE()
    start_script(ly.charlie_idles, ly)
    start_script(ly.meche_idles, ly)
end
ly.charlies_jackpot = function(arg1) -- line 1310
    local local1
    local local2
    local local3, local4
    stop_script(ly.charlie_get_up_timer)
    stop_script(ly.charlie_idles)
    stop_script(ly.meche_idles)
    START_CUT_SCENE()
    start_script(ly.unicycle_stop_idles, ly)
    if not find_script(charlies_slot.stop) then
        start_script(charlies_slot.stop, charlies_slot, FALSE)
    end
    ly:add_object_state(ly_chaws, "ly_slot_door.bm", "ly_slot_door.zbm", OBJSTATE_STATE)
    ly.charlie_obj:set_object_state("ly_slot_door.cos")
    ly.charlie_obj.interest_actor:set_visibility(TRUE)
    ly.charlie_obj.interest_actor:put_in_set(ly)
    manny:walkto(0.60399699, -0.122419, 0, 0, 324.94, 0)
    manny:say_line("/lyma082/")
    manny:wait_for_message()
    wait_for_script(ly.unicycle_stop_idles)
    unicycle_man:turn_to_manny()
    local1 = GetActorYawToPoint(manny.hActor, unicycle_man.point["charlie"].pos)
    manny:setrot(0, local1, 0, TRUE)
    manny:point_gesture()
    manny:say_line("/lyma083/")
    manny:wait_for_message()
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point["charlie"].pos, unicycle_man.point["charlie"].rot)
    unicycle_man:say_line("/lyum084/")
    unicycle_man:wait_for_message()
    wait_for_script(unicycle_man.cycle_straight_to)
    unicycle_man:wait_for_actor()
    unicycle_man:setpos(1.90781, -0.36290601, 0)
    unicycle_man:setrot(0, 270, 0)
    ly:current_setup(ly_chaws)
    meche:set_visibility(FALSE)
    unicycle_man:set_chore_looping(unicycle_man_idles, FALSE)
    unicycle_man:wait_for_chore(unicycle_man_idles)
    unicycle_man:play_chore(unicycle_man_crawl_slot)
    stop_sound("um_roll.IMU")
    sleep_for(3500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    sleep_for(3300)
    unicycle_man:play_chore(unicycle_man_hide_body)
    unicycle_man:wait_for_chore(unicycle_man_crawl_slot)
    start_script(ly.unicycle_slot_sfx)
    ly.charlie_obj:run_chore(ly_slot_door_close)
    sleep_for(1000)
    charlies_slot:scramble_to_win()
    local3 = Actor:create(nil, nil, nil, "Money")
    local3:set_costume("coin_pile.cos")
    local3:put_in_set(ly)
    local3:setpos(1.99385, -0.48749301, 0.16)
    local3:setrot(0, 0, 0)
    local4 = 0.1
    start_sfx("ly_pyoff.IMU")
    while local4 <= 1 do
        SetActorScale(local3.hActor, local4)
        break_here()
        local4 = local4 + 0.050000001
    end
    fade_sfx("ly_pyoff.IMU", 1000)
    sleep_for(2500)
    ly.charlie_obj:run_chore(ly_slot_door_open)
    unicycle_man:play_chore(unicycle_man_out_slot_no_grab)
    sleep_for(500)
    unicycle_man:play_chore(unicycle_man_show_body)
    sleep_for(4000)
    ly.charlie_obj:play_chore(ly_slot_door_close)
    unicycle_man:wait_for_chore(unicycle_man_out_slot_no_grab)
    ly:current_setup(ly_sltha)
    meche:set_visibility(TRUE)
    start_script(unicycle_man.cycle_straight_to, unicycle_man, unicycle_man.point[0].pos, unicycle_man.point[0].rot)
    sleep_for(3000)
    stop_script(ly.charlie_struggle)
    ly.sheet_on_floor.interest_actor:put_in_set(ly)
    ly.sheet_on_floor.interest_actor:stop_chore()
    stop_script(unicycle_man.cycle_straight_to)
    stop_sound("um_roll.IMU")
    StartFullscreenMovie("ly_win.snm")
    sleep_for(3000)
    start_sfx("cc_shtof.WAV")
    wait_for_movie()
    ly:current_setup(ly_sltha)
    unicycle_man:setpos(unicycle_man.point[0].pos.x, unicycle_man.point[0].pos.y, unicycle_man.point[0].pos.z)
    unicycle_man:setrot(unicycle_man.point[0].rot.x, unicycle_man.point[0].rot.y, unicycle_man.point[0].rot.z)
    unicycle_man:stop_chore(unicycle_man_roll)
    unicycle_man:play_chore_looping(unicycle_man_idles)
    charlie:stop_chore(nil, "cc_play_slot.cos")
    charlie:play_chore(cc_play_slot_hide_handle, "cc_play_slot.cos")
    charlie:push_costume("cc_seduction.cos")
    charlie:setpos(1.49489, -0.50857699, -0.119)
    charlie:setrot(0, 260, 0)
    charlie:set_visibility(TRUE)
    meche:setpos(1.44189, -0.845577, 0)
    meche:setrot(0, 330, 0)
    meche:stop_chore(nil, "meche_ruba.cos")
    meche:stop_chore(nil, "meche_seduction.cos")
    meche:stop_chore(nil, "mi_msb_sheet.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
    meche:set_visibility(TRUE)
    charlie:play_chore(cc_seduction_take_money, "cc_seduction.cos")
    ly.sheet_on_floor.interest_actor:stop_chore()
    ly.sheet_on_floor:complete_chore(ly_cc_sheet_gone)
    ForceRefresh()
    charlie:say_line("/lycc085/")
    sleep_for(3200)
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    charlie:wait_for_message()
    meche:say_line("/lymc086/")
    while local4 >= 0.1 and charlie:is_speaking() do
        local4 = local4 - 0.1
        SetActorScale(local3.hActor, local4)
        break_here()
    end
    local3:free()
    local3 = nil
    charlie:wait_for_chore(cc_seduction_take_money, "cc_seduction.cos")
    box_on("charlie_box")
    box_on("mannys_slot")
    box_on("meche_box")
    music_state:set_sequence(seqChowchillaBye)
    IrisDown(450, 320, 1000)
    sleep_for(1500)
    ly:current_setup(ly_lavha)
    unicycle_man:free()
    stop_sound("um_roll.IMU")
    manny:setpos(2.22596, 3.59653, 0.89999998)
    manny:setrot(0, 102.462, 0)
    manny:set_collision_mode(COLLISION_OFF)
    meche:set_costume(nil)
    meche:set_costume("meche_ruba.cos")
    meche:set_mumble_chore(meche_ruba_mumble)
    meche:set_talk_chore(1, meche_ruba_stop_talk)
    meche:set_talk_chore(2, meche_ruba_a)
    meche:set_talk_chore(3, meche_ruba_c)
    meche:set_talk_chore(4, meche_ruba_e)
    meche:set_talk_chore(5, meche_ruba_f)
    meche:set_talk_chore(6, meche_ruba_l)
    meche:set_talk_chore(7, meche_ruba_m)
    meche:set_talk_chore(8, meche_ruba_o)
    meche:set_talk_chore(9, meche_ruba_t)
    meche:set_talk_chore(10, meche_ruba_u)
    meche:push_costume("mi_with_cc_toga.cos")
    meche:set_collision_mode(COLLISION_OFF)
    meche:setpos(2.03021, 3.5079, 0.90061998)
    meche:setrot(0, 306.86899, 0)
    meche:play_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    charlie:set_costume(nil)
    charlie:set_costume("cc_toga.cos")
    charlie:set_mumble_chore(cc_toga_mumble)
    charlie:set_talk_chore(1, cc_toga_stop_talk)
    charlie:set_talk_chore(2, cc_toga_a)
    charlie:set_talk_chore(3, cc_toga_c)
    charlie:set_talk_chore(4, cc_toga_e)
    charlie:set_talk_chore(5, cc_toga_f)
    charlie:set_talk_chore(6, cc_toga_l)
    charlie:set_talk_chore(7, cc_toga_m)
    charlie:set_talk_chore(8, cc_toga_o)
    charlie:set_talk_chore(9, cc_toga_t)
    charlie:set_talk_chore(10, cc_toga_u)
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:set_walk_chore(cc_toga_walk)
    charlie:set_walk_rate(0.25)
    charlie:set_head(7, 8, 9, 120, 80, 80)
    charlie:set_look_rate(100)
    ly.mens_room:open()
    charlie:setpos(1.89022, 4.5444798, 0.89999998)
    charlie:setrot(0, 180.181, 0)
    charlie:follow_boxes()
    charlie.footsteps = footsteps.marble
    if not ly.mens_room.has_object_states then
        ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
        ly.mens_room:set_object_state("ly_bath_door.cos")
    end
    IrisUp(125, 325, 1000)
    sleep_for(500)
    manny:head_look_at(nil)
    meche:head_look_at(nil)
    manny:head_forward_gesture()
    manny:say_line("/lyma087/")
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/lyma088/")
    manny:wait_for_message()
    meche:play_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    meche:say_line("/lymc089/")
    meche:wait_for_message()
    meche:wait_for_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    ly.mens_room:play_chore(0)
    start_sfx("ly_batho.WAV")
    manny:head_look_at_point(1.94195, 3.9626, 1.302)
    charlie:walkto(1.95579, 3.78863, 0.89999998)
    sleep_for(500)
    start_script(manny.backup, manny, 1000)
    while charlie:is_moving() do
        if not charlie:find_sector_name("bath_psg") then
            charlie.footsteps = footsteps.rug
        end
        break_here()
    end
    charlie.footsteps = footsteps.rug
    ly.mens_room:play_chore(1)
    start_sfx("ly_bathc.WAV")
    ly.mens_room:close()
    charlie:say_line("/lycc090/", { x = 160, y = 30 })
    meche:stop_chore(meche_ruba_xarm_hold, "meche_ruba.cos")
    meche:stop_chore(meche_ruba_drop_hands, "meche_ruba.cos")
    mi_with_cc_done_turning = FALSE
    meche:play_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    sleep_for(1000)
    charlie:head_look_at(meche)
    sleep_for(2400)
    charlie:head_look_at(nil)
    charlie:setrot(0, 100, 0, TRUE)
    charlie:fade_in_chore(cc_toga_take_meche, "cc_toga.cos", 500)
    charlie:wait_for_chore(cc_toga_take_meche, "cc_toga.cos")
    charlie:play_chore(cc_toga_hold_meche, "cc_toga.cos")
    while mi_with_cc_done_turning < 1 do
        break_here()
    end
    while meche:is_choring(mi_with_cc_toga_to_cc_toga, FALSE, "mi_with_cc_toga.cos") do
        WalkActorForward(charlie.hActor)
        break_here()
    end
    meche:wait_for_chore(mi_with_cc_toga_to_cc_toga, "mi_with_cc_toga.cos")
    manny:head_look_at(nil)
    END_CUT_SCENE()
    ly.charlie_on_floor = FALSE
    ly.sheet_on_floor:make_untouchable()
    ly.charlie_obj:make_untouchable()
    ly.meche_obj:make_untouchable()
    ly.unicycle_man:make_untouchable()
    ly.charlie_gone = TRUE
    music_state:update()
    cur_puzzle_state[56] = TRUE
    charlie:free()
    meche:free()
end
ly.charlie_idles = function(arg1) -- line 1596
    while system.currentSet == ly do
        ly.ready_to_seduce = FALSE
        charlie:play_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        sleep_for(1000)
        charlies_slot:spin()
        charlie:wait_for_chore(cc_play_slot_play_slots, "cc_play_slot.cos")
        charlies_slot:stop(FALSE)
        if find_script(ly.seduce_charlie) then
            ly.ready_to_seduce = TRUE
            while ly.ready_to_seduce do
                break_here()
            end
        end
        break_here()
    end
end
ly.meche_idles = function(arg1) -- line 1614
    local local1 = FALSE
    while system.currentSet == ly do
        if meche.holding_sheet then
            if rnd(8) and not find_script(ly.seduce_charlie) then
                if cutSceneLevel <= 0 then
                    start_script(ly.seduce_charlie, ly)
                    wait_for_script(ly.seduce_charlie)
                end
            end
        elseif rnd(5) then
            if local1 then
                meche:run_chore(meche_ruba_drop_hands, "meche_ruba.cos")
                local1 = FALSE
                sleep_for(rndint(1000, 5000))
            else
                meche:run_chore(meche_ruba_xarms, "meche_ruba.cos")
                local1 = TRUE
                sleep_for(rndint(5000, 10000))
            end
        end
        break_here()
    end
end
ly.seduce_charlie = function(arg1) -- line 1642
    while not ly.ready_to_seduce do
        break_here()
    end
    ly.meche_obj:make_untouchable()
    charlie:set_collision_mode(COLLISION_SPHERE, 0.8)
    meche:play_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    sleep_for(1000)
    charlie:push_costume("cc_seduction.cos")
    charlie:fade_in_chore(cc_seduction_sed_by_mec, "cc_seduction.cos", 500)
    sleep_for(6000)
    ly.meche_obj:make_touchable()
    charlie:set_collision_mode(COLLISION_OFF)
    charlie:wait_for_chore(cc_seduction_sed_by_mec, "cc_seduction.cos")
    charlie:pop_costume()
    ly.ready_to_seduce = FALSE
    meche:wait_for_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:stop_chore(meche_seduction_mec_sed_ch, "meche_seduction.cos")
    meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
end
ly.set_up_actors = function(arg1) -- line 1665
    ly.keno_actor:default()
    ly.slot_handle:init()
    charlies_slot:default()
    mannys_slot:default()
    mannys_slot:freeze()
    brennis:put_in_set(ly)
    brennis:default()
    brennis:push_costume("br_idles.cos")
    brennis:setpos(-0.0427321, 4.02445, 0.9)
    brennis:setrot(0, -2343.65, 0)
    ly:brennis_start_idle()
    if not ly.charlie_gone then
        charlie:set_costume(nil)
        charlie:set_costume("ccharlie.cos")
        charlie:set_mumble_chore(ccharlie_mumble)
        charlie:set_talk_chore(1, ccharlie_no_talk)
        charlie:set_talk_chore(2, ccharlie_a)
        charlie:set_talk_chore(3, ccharlie_c)
        charlie:set_talk_chore(4, ccharlie_e)
        charlie:set_talk_chore(5, ccharlie_f)
        charlie:set_talk_chore(6, ccharlie_l)
        charlie:set_talk_chore(7, ccharlie_m)
        charlie:set_talk_chore(8, ccharlie_o)
        charlie:set_talk_chore(9, ccharlie_t)
        charlie:set_talk_chore(10, ccharlie_u)
        charlie:push_costume("cc_play_slot.cos")
        charlie:put_in_set(ly)
        charlie:ignore_boxes()
        charlie:setpos(1.83869, -0.508564, 0.014)
        charlie:setrot(0, 260, 0)
        start_script(ly.charlie_idles, ly)
        meche:set_costume(nil)
        meche:set_costume("meche_ruba.cos")
        meche:set_mumble_chore(meche_ruba_mumble)
        meche:set_talk_chore(1, meche_ruba_stop_talk)
        meche:set_talk_chore(2, meche_ruba_a)
        meche:set_talk_chore(3, meche_ruba_c)
        meche:set_talk_chore(4, meche_ruba_e)
        meche:set_talk_chore(5, meche_ruba_f)
        meche:set_talk_chore(6, meche_ruba_l)
        meche:set_talk_chore(7, meche_ruba_m)
        meche:set_talk_chore(8, meche_ruba_o)
        meche:set_talk_chore(9, meche_ruba_t)
        meche:set_talk_chore(10, meche_ruba_u)
        meche:put_in_set(ly)
        meche:ignore_boxes()
        meche:setpos(1.4388, -0.679984, 0)
        meche:setrot(0, 313.314, 0)
        meche:push_costume("meche_seduction.cos")
        meche:push_costume("mi_msb_sheet.cos")
        meche:play_chore(meche_seduction_rest_pos, "meche_seduction.cos")
        meche.holding_sheet = TRUE
        start_script(ly.meche_idles, ly)
        unicycle_man:default()
        unicycle_man:put_in_set(ly)
        unicycle_man:restore_pos()
        start_script(ly.unicycle_idles, ly)
    else
        charlie:free()
        meche:free()
        unicycle_man:free()
    end
end
ly.set_up_object_states = function(arg1) -- line 1737
    ly:add_object_state(ly_kenla, "ly_keno_1.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_2.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_3.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_kenla, "ly_keno_32.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_4.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_5.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_6.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_7.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_8.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_9.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_10.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_11.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_12.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_13.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_14.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_15.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_16.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_17.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_18.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_19.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_20.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_21.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_22.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_23.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_24.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_25.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_26.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_27.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_28.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_29.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_30.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_31.bm", nil, OBJSTATE_UNDERLAY)
    ly:add_object_state(ly_intha, "ly_keno_t_32.bm", nil, OBJSTATE_UNDERLAY)
end
ly.cameraman = function(arg1) -- line 1804
    local local1, local2
    local local3
    cameraman_watching_set = arg1
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead and cutSceneLevel <= 0 then
        local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
        if cameraman_box_name then
            local3 = getglobal(cameraman_box_name)
            if local3 ~= nil and ly:current_setup() ~= local3 then
                ly:current_setup(local3)
            end
        elseif ly:current_setup() ~= "ly_intha" then
            ly:current_setup(ly_intha)
        end
    end
end
ly.manny_collisions = function(arg1) -- line 1826
    while system.currentSet == ly do
        if manny:find_sector_name("slot_box") or manny:find_sector_name("mannys_slot") or manny:find_sector_name("charlie_box") or manny:find_sector_name("meche_box") then
            manny:set_collision_mode(COLLISION_SPHERE, 0.35)
        else
            manny:set_collision_mode(COLLISION_OFF)
        end
        break_here()
    end
end
ly.update_music_state = function(arg1) -- line 1843
    if ly.charlie_gone then
        return stateLY_BREN
    else
        return stateLY
    end
end
ly.enter = function(arg1) -- line 1852
    ly:set_up_object_states()
    ly:set_up_actors()
    start_script(ly.gun_control)
    start_script(ly.keno_actor.game, ly.keno_actor)
    start_script(ly.manny_collisions, ly)
    ly:add_ambient_sfx({ "lyAmb1.wav", "lyAmb2.wav", "lyAmb3.wav", "lyAmb4.wav" }, { min_volume = 40, max_volume = 127, min_delay = 6000, max_delay = 10000 })
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -4, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
ly.exit = function(arg1) -- line 1872
    stop_script(ly.manny_collisions)
    manny:set_collision_mode(COLLISION_OFF)
    stop_script(slot_wheel.spin)
    stop_script(ly.unicycle_idles)
    stop_script(ly.unicycle_slot_sfx)
    stop_script(ly.keno_actor.game)
    ly.keno_actor:free()
    charlies_slot:free()
    mannys_slot:free()
    stop_script(ly.charlie_idles)
    charlie:free()
    meche:free()
    if brennis.ly_idle_script then
        stop_script(brennis.ly_idle_script)
        brennis.ly_idle_script = nil
    end
    brennis:free()
    unicycle_man:save_pos()
    unicycle_man:free()
    stop_script(ly.gun_control)
    stop_script(ly.charlie_struggle)
    stop_script(ly.charlie_get_up_timer)
    ly.sheet_on_floor.interest_actor:set_costume(nil)
    ly.sheet_on_floor.has_object_states = FALSE
    ly.mens_room.interest_actor:set_costume(nil)
    ly.mens_room.has_object_states = FALSE
    ly.service_door.interest_actor:set_costume(nil)
    ly.service_door.has_object_states = FALSE
    stop_sound("um_roll.IMU")
    stop_sound("ly_pyoff.IMU")
    stop_sound("ly_wheel.IMU")
    KillActorShadows(manny.hActor)
end
ly.sheet = Object:create(ly, "/lytx091/sheet", 0, 0, 0, { range = 0 })
ly.sheet.use = function(arg1) -- line 1928
    manny:say_line("/lyma092/")
end
ly.sheet.lookAt = function(arg1) -- line 1932
    manny:say_line("/lyma093/")
end
ly.sheet.default_response = ly.sheet.use
ly.brennis_obj = Object:create(ly, "/lytx094/elevator demon", -0.048044398, 3.9284, 1.51, { range = 0.80000001 })
ly.brennis_obj.use_pnt_x = -0.12957799
ly.brennis_obj.use_pnt_y = 3.47597
ly.brennis_obj.use_pnt_z = 0.89999998
ly.brennis_obj.use_rot_x = 0
ly.brennis_obj.use_rot_y = 349.754
ly.brennis_obj.use_rot_z = 0
ly.brennis_obj.person = TRUE
ly.brennis_obj.demon = TRUE
ly.brennis_obj.lookAt = function(arg1) -- line 1951
    manny:say_line("/lyma095/")
end
ly.brennis_obj.pickUp = function(arg1) -- line 1955
    system.default_response("right")
end
ly.brennis_obj.use = function(arg1) -- line 1959
    if not manny.fancy then
        if manny:walkto_object(arg1) then
            start_script(ly.talk_clothes_with_brennis)
        end
    elseif fi.gun.owner ~= manny then
        manny:turn_left(180)
        manny:say_line("/lyma096/")
    else
        Dialog:run("br2", "dlg_brennis2.lua")
    end
end
ly.brennis_obj.use_sheet = function(arg1) -- line 1974
    START_CUT_SCENE()
    manny:say_line("/lyma097/")
    wait_for_message()
    brennis:say_line("/lybs098/")
    END_CUT_SCENE()
end
ly.statue = Object:create(ly, "/lytx099/statue", 3.34677, -2.6134701, 2.5899999, { range = 1.6 })
ly.statue.use_pnt_x = 3.34677
ly.statue.use_pnt_y = -1.78347
ly.statue.use_pnt_z = 0.44999999
ly.statue.use_rot_x = 0
ly.statue.use_rot_y = 922.95398
ly.statue.use_rot_z = 0
ly.statue.lookAt = function(arg1) -- line 1992
    manny:say_line("/lyma100/")
end
ly.statue.pickUp = function(arg1) -- line 1996
    system.default_response("right")
end
ly.statue.use = function(arg1) -- line 2000
    manny:say_line("/lyma101/")
end
ly.statue.use_sheet = function(arg1) -- line 2004
    manny:say_line("/lyma102/")
end
ly.charlie_obj = Object:create(ly, "/lytx103/Chowchilla Charlie", 1.82118, -0.51648003, 0.37200001, { range = 0.60000002 })
ly.charlie_obj.use_pnt_x = 1.61446
ly.charlie_obj.use_pnt_y = -0.26686499
ly.charlie_obj.use_pnt_z = 0
ly.charlie_obj.use_rot_x = 0
ly.charlie_obj.use_rot_y = 220.021
ly.charlie_obj.use_rot_z = 0
ly.charlie_obj.person = TRUE
ly.charlie_obj.lookAt = function(arg1) -- line 2019
    if not arg1.seen then
        START_CUT_SCENE()
        arg1.seen = TRUE
        manny:say_line("/lyma104/")
        manny:wait_for_message()
        manny:say_line("/lyma105/")
        END_CUT_SCENE()
    else
        manny:say_line("/lyma106/")
    end
end
ly.charlie_obj.pickUp = function(arg1) -- line 2032
    manny:say_line("/lyma107/")
end
ly.charlie_obj.use = function(arg1) -- line 2036
    start_script(ly.talk_toga_with_charlie)
end
ly.charlie_obj.use_sheet = function(arg1) -- line 2040
    start_script(ly.throw_sheet)
end
ly.meche_obj = Object:create(ly, "/lytx108/Meche", 1.52403, -0.63770503, 0.47499999, { range = 0.80000001 })
ly.meche_obj.use_pnt_x = 1.65277
ly.meche_obj.use_pnt_y = -0.32719201
ly.meche_obj.use_pnt_z = 0
ly.meche_obj.use_rot_x = 0
ly.meche_obj.use_rot_y = 153.737
ly.meche_obj.use_rot_z = 0
ly.meche_obj.person = TRUE
ly.meche_obj.lookAt = function(arg1) -- line 2055
    manny:say_line("/lyma109/")
end
ly.meche_obj.pickUp = function(arg1) -- line 2059
    system.default_response("not now")
end
ly.meche_obj.use = function(arg1) -- line 2063
    start_script(ly.talk_clothes_with_meche)
end
ly.meche_obj.use_sheet = function(arg1) -- line 2067
    if ly.meche_talk_count < 4 then
        arg1:use()
    else
        manny:say_line("/lyma110/")
        manny:wait_for_message()
        meche:say_line("/lymc111/")
    end
end
ly.slot1 = Object:create(ly, "/lytx112/slot machine", 1.98998, -0.113677, 0.47, { range = 0.60000002 })
ly.slot1.use_pnt_x = 1.63983
ly.slot1.use_pnt_y = -0.272295
ly.slot1.use_pnt_z = 0
ly.slot1.use_rot_x = 0
ly.slot1.use_rot_y = 280.24301
ly.slot1.use_rot_z = 0
ly.slot1.lookAt = function(arg1) -- line 2087
    manny:say_line("/lyma113/")
end
ly.slot1.pickUp = function(arg1) -- line 2091
    system.default_response("portable")
end
ly.slot1.use = function(arg1) -- line 2095
    if manny:find_sector_name("mannys_slot") then
        start_script(ly.playslots, ly, arg1)
    elseif manny:walkto_object(arg1) then
        start_script(ly.playslots, ly, arg1)
    end
end
ly.slot1.use_sheet = function(arg1) -- line 2103
    manny:say_line("/lyma114/")
end
ly.sheet_on_floor = Object:create(ly, "/lytx115/sheet", 1.7376, -0.488377, 0, { range = 0.60000002 })
ly.sheet_on_floor.use_pnt_x = 1.5376
ly.sheet_on_floor.use_pnt_y = -0.62837702
ly.sheet_on_floor.use_pnt_z = 0
ly.sheet_on_floor.use_rot_x = 0
ly.sheet_on_floor.use_rot_y = -33.944099
ly.sheet_on_floor.use_rot_z = 0
ly.sheet_on_floor:make_untouchable()
ly.sheet_on_floor.lookAt = function(arg1) -- line 2118
    manny:say_line("/lyma116/")
end
ly.sheet_on_floor.pickUp = function(arg1) -- line 2122
    arg1:make_untouchable()
    ly.sheet:hold()
end
ly.sheet_on_floor.use = ly.sheet_on_floor.pickUp
ly.unicycle_man = Object:create(ly, "/lytx117/gambler", 1.05716, 0.50252402, 0.40000001, { range = 0.80000001 })
ly.unicycle_man.use_pnt_x = 1.2671601
ly.unicycle_man.use_pnt_y = 0.25252399
ly.unicycle_man.use_pnt_z = 0
ly.unicycle_man.use_rot_x = 0
ly.unicycle_man.use_rot_y = 1495.33
ly.unicycle_man.use_rot_z = 0
ly.unicycle_man.person = TRUE
ly.unicycle_man.lookAt = function(arg1) -- line 2140
    if not ly.met_agent then
        manny:say_line("/lyma118/")
    else
        manny:say_line("/lyma119/")
    end
end
ly.unicycle_man.pickUp = function(arg1) -- line 2148
    system.default_response("think")
end
ly.unicycle_man.use = function(arg1) -- line 2152
    start_script(ly.talk_to_agent)
end
ly.mens_room = Object:create(ly, "/lytx120/door", 2.03262, 4.2983999, 1.39, { range = 0.5 })
ly.mens_room.use_pnt_x = 1.9454401
ly.mens_room.use_pnt_y = 3.98
ly.mens_room.use_pnt_z = 0.89999998
ly.mens_room.use_rot_x = 0
ly.mens_room.use_rot_y = 14.326
ly.mens_room.use_rot_z = 0
ly.mens_room.out_pnt_x = 1.76959
ly.mens_room.out_pnt_y = 4.6870298
ly.mens_room.out_pnt_z = 0.89999998
ly.mens_room.out_rot_x = 0
ly.mens_room.out_rot_y = 4.1866498
ly.mens_room.out_rot_z = 0
ly.mens_room.passage = { "bath_psg" }
ly.mens_room.lookAt = function(arg1) -- line 2175
    manny:say_line("/lyma121/")
end
ly.mens_room.walkOut = function(arg1) -- line 2179
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
        manny:wait_for_message()
        ly.sheet:use()
    elseif not manny.fancy then
        if not ly.mens_room.has_object_states then
            ly:add_object_state(ly_lavha, "ly_bath.bm", "ly_bath.zbm", OBJSTATE_STATE)
            ly.mens_room:set_object_state("ly_bath_door.cos")
        end
        if not ly.charlie_gone then
            if not ly.peed then
                ly.peed = TRUE
                arg1:open_door_and_enter()
                manny:say_line("/lyma122/")
                manny:wait_for_message()
                manny:say_line("/lyma123/")
            else
                manny:say_line("/lyma124/")
            end
        else
            manny.fancy = TRUE
            arg1:open_door_and_enter()
            manny:shrug_gesture()
            manny:say_line("/lyma125/")
        end
    else
        manny:say_line("/lyma126/")
    end
    END_CUT_SCENE()
end
ly.mens_room.open_door_and_enter = function(arg1) -- line 2216
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y, arg1.use_rot_z)
    manny:play_chore(msb_hand_on_obj, manny.base_costume)
    sleep_for(200)
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:open()
    manny:wait_for_chore(msb_hand_on_obj, manny.base_costume)
    manny:stop_chore(msb_hand_on_obj, manny.base_costume)
    manny:play_chore(msb_hand_off_obj, manny.base_costume)
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
    manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    if manny.fancy then
        sleep_for(3000)
        manny:default("thunder")
    else
        sleep_for(4000)
        start_sfx("ly_urinl.WAV")
    end
    arg1:play_chore(0)
    start_sfx("ly_batho.WAV")
    arg1:wait_for_chore(0)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    manny:walkto(1.96305, 3.77355, 0.9, 0, 184.876, 0)
    manny:wait_for_actor()
    arg1:play_chore(1)
    start_sfx("ly_bathc.WAV")
    arg1:close()
end
ly.service_door = Object:create(ly, "/lytx120/door", 2.5296299, 4.0496202, 1.339, { range = 0.5 })
ly.service_door.use_pnt_x = 2.5390899
ly.service_door.use_pnt_y = 3.6882501
ly.service_door.use_pnt_z = 0.89999998
ly.service_door.use_rot_x = 0
ly.service_door.use_rot_y = 358.625
ly.service_door.use_rot_z = 0
ly.service_door.out_pnt_x = 2.53511
ly.service_door.out_pnt_y = 4.48
ly.service_door.out_pnt_z = 0.89999998
ly.service_door.out_rot_x = 0
ly.service_door.out_rot_y = 359.58701
ly.service_door.out_rot_z = 0
ly.service_door.touchable = FALSE
ly.service_door.passage = { "service_psg" }
ly.service_door.walkOut = function(arg1) -- line 2271
    START_CUT_SCENE()
    if manny.is_holding == ly.sheet then
        system.default_response("no")
        manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z, arg1.use_rot_x, arg1.use_rot_y + 180, arg1.use_rot_z)
        manny:wait_for_message()
        ly.sheet:use()
    else
        if not ly.service_door.has_object_states then
            ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
            ly.service_door:set_object_state("ly_service_door.cos")
        end
        manny:walkto(2.56884, 3.85944, 0.9, 0, 16.9137, 0)
        manny:wait_for_actor()
        manny:play_chore(msb_reach_med, manny.base_costume)
        sleep_for(250)
        start_script(manny.backup, manny, 350)
        sleep_for(250)
        arg1:play_chore(0)
        arg1:wait_for_chore(0)
        arg1:open()
        manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
        sleep_for(1000)
        arg1:play_chore(1)
        arg1:close()
    end
    END_CUT_SCENE()
    if manny.is_holding ~= ly.sheet then
        te:come_out_door(te.ly_door)
    end
end
ly.service_door.comeOut = function(arg1) -- line 2304
    START_CUT_SCENE()
    ly:switch_to_set()
    ly:current_setup(ly_lavha)
    if not ly.service_door.has_object_states then
        ly:add_object_state(ly_lavha, "ly_service.bm", "ly_service.zbm", OBJSTATE_STATE)
        ly.service_door:set_object_state("ly_service_door.cos")
    end
    arg1:open()
    manny:put_in_set(ly)
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    if not manny.fancy then
        manny:play_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:play_chore(mcc_thunder_hand_off_obj, "mcc_thunder.cos")
    end
    arg1:play_chore(0)
    arg1:wait_for_chore(0)
    if not manny.fancy then
        manny:wait_for_chore(msb_hand_off_obj, manny.base_costume)
        manny:stop_chore(msb_hand_off_obj, manny.base_costume)
    else
        manny:wait_for_chore(mcc_thunder_hand_off_obj, manny.base_costume)
        manny:stop_chore(mcc_thunder_hand_off_obj, manny.base_costume)
    end
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    manny:wait_for_actor()
    arg1:run_chore(1)
    arg1:close()
    END_CUT_SCENE()
end
ly.sh_door = Object:create(ly, "/lytx002/door", -0.098697402, -3.63239, 0.83999997, { range = 0.60000002 })
ly.sh_door.use_pnt_x = -0.098411702
ly.sh_door.use_pnt_y = -3.13359
ly.sh_door.use_pnt_z = 0.44999999
ly.sh_door.use_rot_x = 0
ly.sh_door.use_rot_y = 179.772
ly.sh_door.use_rot_z = 0
ly.sh_door.out_pnt_x = -0.097895198
ly.sh_door.out_pnt_y = -3.425
ly.sh_door.out_pnt_z = 0.44999999
ly.sh_door.out_rot_x = 0
ly.sh_door.out_rot_y = 179.772
ly.sh_door.out_rot_z = 0
ly.sh_door.touchable = FALSE
ly.sh_box = ly.sh_door
ly.sh_door.walkOut = function(arg1) -- line 2364
    START_CUT_SCENE()
    ResetMarioControls()
    manny:say_line("/doma165/")
    manny:walkto(-0.100971, -3.23397, 0.45, 0, 6.21033, 0)
    END_CUT_SCENE()
end
CheckFirstTime("cn.lua")
dofile("bogen.lua")
dofile("spinner.lua")
dofile("turbanman.lua")
dofile("fatlady.lua")
dofile("caneman.lua")
dofile("mc_booth_idles.lua")
dofile("cc_booth_idles.lua")
dofile("ccharlie.lua")
cn = Set:create("cn.set", "casino interior", { cn_top = 0, cn_cchms = 1, cn_rulws = 2 })
cn.shrinkable = 0.043
bogen.idle_table = Idle:create("bogen")
bogen.idle_table:add_state("hands_side_to_bk", { rocking = 0.8, hands_bk_to_side = 0.2 })
bogen.idle_table:add_state("hands_to_hips", { hands_on_hips = 1 })
bogen.idle_table:add_state("rocking", { hands_bk_to_side = 1 })
bogen.idle_table:add_state("brush_jacket", { stand = 1 })
bogen.idle_table:add_state("hands_from_hips", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("hands_bk_to_side", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("stand", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("hands_on_hips", { hands_on_hips = 0.85, hands_from_hips = 0.15 })
manny.say_number = function(arg1, arg2) -- line 35
    if arg2 == 1 then
        manny:say_line("/cnma001/")
    elseif arg2 == 2 then
        manny:say_line("/cnma002/")
    elseif arg2 == 3 then
        manny:say_line("/cnma003/")
    elseif arg2 == 4 then
        manny:say_line("/cnma004/")
    elseif arg2 == 5 then
        manny:say_line("/cnma005/")
    elseif arg2 == 6 then
        manny:say_line("/cnma006/")
    elseif arg2 == 7 then
        manny:say_line("/cnma007/")
    elseif arg2 == 8 then
        manny:say_line("/cnma008/")
    elseif arg2 == 9 then
        manny:say_line("/cnma009/")
    elseif arg2 == 10 then
        manny:say_line("/cnma010/")
    elseif arg2 == 11 then
        manny:say_line("/cnma011/")
    elseif arg2 == 12 then
        manny:say_line("/cnma012/")
    elseif arg2 == 13 then
        manny:say_line("/cnma013/")
    elseif arg2 == 14 then
        manny:say_line("/cnma014/")
    elseif arg2 == 15 then
        manny:say_line("/cnma015/")
    elseif arg2 == 16 then
        manny:say_line("/cnma016/")
    elseif arg2 == 17 then
        manny:say_line("/cnma017/")
    elseif arg2 == 18 then
        manny:say_line("/cnma018/")
    elseif arg2 == 19 then
        manny:say_line("/cnma019/")
    elseif arg2 == 20 then
        manny:say_line("/cnma020/")
    elseif arg2 == 21 then
        manny:say_line("/cnma021/")
    elseif arg2 == 22 then
        manny:say_line("/cnma022/")
    elseif arg2 == 23 then
        manny:say_line("/cnma023/")
    elseif arg2 == 24 then
        manny:say_line("/cnma024/")
    elseif arg2 == 25 then
        manny:say_line("/cnma025/")
    elseif arg2 == 26 then
        manny:say_line("/cnma026/")
    elseif arg2 == 27 then
        manny:say_line("/cnma027/")
    elseif arg2 == 28 then
        manny:say_line("/cnma028/")
    elseif arg2 == 29 then
        manny:say_line("/cnma029/")
    elseif arg2 == 30 then
        manny:say_line("/cnma030/")
    elseif arg2 == 31 then
        manny:say_line("/cnma031/")
    elseif arg2 == 32 then
        manny:say_line("/cnma032/")
    elseif arg2 == 33 then
        manny:say_line("/cnma033/")
    elseif arg2 == 34 then
        manny:say_line("/cnma034/")
    elseif arg2 == 35 then
        manny:say_line("/cnma035/")
    elseif arg2 == 36 then
        manny:say_line("/cnma036/")
    end
end
croupier.say_english_number = function(arg1, arg2) -- line 75
    if arg2 == 0 then
        croupier:say_line("/cncr037/")
    elseif arg2 == 1 then
        croupier:say_line("/cncr038/")
    elseif arg2 == 2 then
        croupier:say_line("/cncr039/")
    elseif arg2 == 3 then
        croupier:say_line("/cncr040/")
    elseif arg2 == 4 then
        croupier:say_line("/cncr041/")
    elseif arg2 == 5 then
        croupier:say_line("/cncr042/")
    elseif arg2 == 6 then
        croupier:say_line("/cncr043/")
    elseif arg2 == 7 then
        croupier:say_line("/cncr044/")
    elseif arg2 == 8 then
        croupier:say_line("/cncr045/")
    elseif arg2 == 9 then
        croupier:say_line("/cncr046/")
    elseif arg2 == 10 then
        croupier:say_line("/cncr047/")
    elseif arg2 == 11 then
        croupier:say_line("/cncr048/")
    elseif arg2 == 12 then
        croupier:say_line("/cncr049/")
    elseif arg2 == 13 then
        croupier:say_line("/cncr050/")
    elseif arg2 == 14 then
        croupier:say_line("/cncr051/")
    elseif arg2 == 15 then
        croupier:say_line("/cncr052/")
    elseif arg2 == 16 then
        croupier:say_line("/cncr053/")
    elseif arg2 == 17 then
        croupier:say_line("/cncr054/")
    elseif arg2 == 18 then
        croupier:say_line("/cncr055/")
    elseif arg2 == 19 then
        croupier:say_line("/cncr056/")
    elseif arg2 == 20 then
        croupier:say_line("/cncr057/")
    elseif arg2 == 21 then
        croupier:say_line("/cncr058/")
    elseif arg2 == 22 then
        croupier:say_line("/cncr059/")
    elseif arg2 == 23 then
        croupier:say_line("/cncr060/")
    elseif arg2 == 24 then
        croupier:say_line("/cncr061/")
    elseif arg2 == 25 then
        croupier:say_line("/cncr062/")
    elseif arg2 == 26 then
        croupier:say_line("/cncr063/")
    elseif arg2 == 27 then
        croupier:say_line("/cncr064/")
    elseif arg2 == 28 then
        croupier:say_line("/cncr065/")
    elseif arg2 == 29 then
        croupier:say_line("/cncr066/")
    elseif arg2 == 30 then
        croupier:say_line("/cncr067/")
    elseif arg2 == 31 then
        croupier:say_line("/cncr068/")
    elseif arg2 == 32 then
        croupier:say_line("/cncr069/")
    elseif arg2 == 33 then
        croupier:say_line("/cncr070/")
    elseif arg2 == 34 then
        croupier:say_line("/cncr071/")
    elseif arg2 == 35 then
        croupier:say_line("/cncr072/")
    elseif arg2 == 36 then
        croupier:say_line("/cncr073/")
    end
end
croupier.say_french_number = function(arg1, arg2) -- line 116
    if arg2 == 0 then
        croupier:say_line("/cncr074/")
    elseif arg2 == 1 then
        croupier:say_line("/cncr075/")
    elseif arg2 == 2 then
        croupier:say_line("/cncr076/")
    elseif arg2 == 3 then
        croupier:say_line("/cncr077/")
    elseif arg2 == 4 then
        croupier:say_line("/cncr078/")
    elseif arg2 == 5 then
        croupier:say_line("/cncr079/")
    elseif arg2 == 6 then
        croupier:say_line("/cncr080/")
    elseif arg2 == 7 then
        croupier:say_line("/cncr081/")
    elseif arg2 == 8 then
        croupier:say_line("/cncr082/")
    elseif arg2 == 9 then
        croupier:say_line("/cncr083/")
    elseif arg2 == 10 then
        croupier:say_line("/cncr084/")
    elseif arg2 == 11 then
        croupier:say_line("/cncr085/")
    elseif arg2 == 12 then
        croupier:say_line("/cncr086/")
    elseif arg2 == 13 then
        croupier:say_line("/cncr087/")
    elseif arg2 == 14 then
        croupier:say_line("/cncr088/")
    elseif arg2 == 15 then
        croupier:say_line("/cncr089/")
    elseif arg2 == 16 then
        croupier:say_line("/cncr090/")
    elseif arg2 == 17 then
        croupier:say_line("/cncr091/")
    elseif arg2 == 18 then
        croupier:say_line("/cncr092/")
    elseif arg2 == 19 then
        croupier:say_line("/cncr093/")
    elseif arg2 == 20 then
        croupier:say_line("/cncr094/")
    elseif arg2 == 21 then
        croupier:say_line("/cncr095/")
    elseif arg2 == 22 then
        croupier:say_line("/cncr096/")
    elseif arg2 == 23 then
        croupier:say_line("/cncr097/")
    elseif arg2 == 24 then
        croupier:say_line("/cncr098/")
    elseif arg2 == 25 then
        croupier:say_line("/cncr099/")
    elseif arg2 == 26 then
        croupier:say_line("/cncr100/")
    elseif arg2 == 27 then
        croupier:say_line("/cncr101/")
    elseif arg2 == 28 then
        croupier:say_line("/cncr102/")
    elseif arg2 == 29 then
        croupier:say_line("/cncr103/")
    elseif arg2 == 30 then
        croupier:say_line("/cncr104/")
    elseif arg2 == 31 then
        croupier:say_line("/cncr105/")
    elseif arg2 == 32 then
        croupier:say_line("/cncr106/")
    elseif arg2 == 33 then
        croupier:say_line("/cncr107/")
    elseif arg2 == 34 then
        croupier:say_line("/cncr108/")
    elseif arg2 == 35 then
        croupier:say_line("/cncr109/")
    elseif arg2 == 36 then
        croupier:say_line("/cncr110/")
    end
end
croupier.say_line = function(arg1, arg2) -- line 157
    local local1
    local local2
    if not cn.pause_spinning then
        if system.currentSet == cn and cn:current_setup() == cn_rulws then
            Actor.say_line(arg1, arg2, { background = TRUE, volume = 100 })
        elseif system.currentSet == cf and cf:current_setup() == cf_pnlcu then
            local1 = tostring(strsub(arg2, 1, 8) .. "a" .. strsub(arg2, 9, strlen(arg2)))
            local1 = arg2
            Actor.say_line(arg1, local1, { background = TRUE })
        end
    end
end
croupier.say_line_manny = function(arg1, arg2) -- line 180
    Actor.say_line(arg1, arg2, { background = TRUE, volume = 100 })
end
croupier.turn_to_table = function(arg1, arg2) -- line 184
    croupier:set_turn_rate(15)
    if system.currentSet == cn then
        if arg2 == rtable1 then
            croupier:setrot(0, 0, 0, TRUE)
        elseif arg2 == rtable2 then
            croupier:setrot(0, 260, 0, TRUE)
        else
            croupier:setrot(0, 120, 0, TRUE)
        end
        while croupier:is_turning() and system.currentSet == cn do
            break_here()
        end
    end
end
bogen.say_line = function(arg1, arg2) -- line 202
    local local1
    if system.currentSet == cn and cn:current_setup() == cn_rulws then
        SayLine(arg1.hActor, arg2, TRUE)
    elseif system.currentSet == cf and cf:current_setup() == cf_pnlcu then
        local1 = tostring(strsub(arg2, 1, 8) .. "a" .. strsub(arg2, 9, strlen(arg2)))
        local1 = arg2
        SayLine(arg1.hActor, local1, TRUE)
    end
end
croupier.say_color_french = function(arg1, arg2) -- line 215
    local local1 = croupier:pick_color(arg2)
    if local1 == "red" then
        croupier:say_line("/cncr111/")
    elseif local1 == "black" then
        croupier:say_line("/cncr112/")
    end
end
croupier.say_color_english = function(arg1, arg2) -- line 225
    local local1 = croupier:pick_color(arg2)
    if local1 == "red" then
        croupier:say_line("/cncr113/")
    elseif local1 == "black" then
        croupier:say_line("/cncr114/")
    end
end
croupier.pick_color = function(arg1, arg2) -- line 235
    if arg2 == 0 then
        return "zero"
    elseif arg2 == 1 or arg2 == 3 or arg2 == 5 or arg2 == 7 or arg2 == 9 or arg2 == 12 or arg2 == 14 or arg2 == 16 or arg2 == 18 or arg2 == 19 or arg2 == 21 or arg2 == 23 or arg2 == 25 or arg2 == 27 or arg2 == 30 or arg2 == 32 or arg2 == 34 or arg2 == 36 then
        return "red"
    else
        return "black"
    end
end
croupier.even_odd_manque_passe = function(arg1, arg2) -- line 263
    if floor(mod(arg2, 2)) == 0 then
        if arg2 > 18 then
            croupier:say_line("/cncr115/")
        else
            croupier:say_line("/cncr116/")
        end
    elseif arg2 > 18 then
        croupier:say_line("/cncr117/")
    else
        croupier:say_line("/cncr118/")
    end
end
cn.BET = 0
cn.SPIN = 1
cn.WIN = 2
cn.bets = { }
cn.bets[1] = "red"
cn.bets[2] = "black"
cn.bets[3] = "zero"
cn.bets[4] = "num"
cn.casino_patrons = function(arg1, arg2) -- line 290
    local local1 = { }
    local local2 = { }
    local local3
    local2[1] = turbanman
    local2[2] = caneman
    local2[3] = fatlady
    if bogen.pissed and not cn.bogens_in_the_house_again then
        if arg2 == rtable1 then
            local1[1] = turbanman
        elseif arg2 == rtable2 then
            local1[1] = caneman
        elseif arg2 == rtable3 then
            local1[1] = fatlady
        end
    elseif arg2 == rtable1 then
        local1[1] = turbanman
    elseif arg2 == rtable3 then
        local1[1] = caneman
        local1[2] = fatlady
    end
    local3 = 1
    while local1[local3] do
        local1[local3]:thaw(TRUE)
        if arg1 == cn.BET then
            local1[local3].bet = pick_from_nonweighted_table(cn.bets)
            if local1[local3].bet == "num" then
                local1[local3].bet = rndint(0, 36)
            end
            if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
                if rnd() then
                    local1[local3]:play_chore(1)
                else
                    local1[local3]:play_chore(2)
                end
            end
        elseif arg1 == cn.SPIN and system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:play_chore(3)
        elseif arg1 == cn.WIN and system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:play_chore(4)
        elseif system.currentSet ~= cn then
            sleep_for(2000)
        end
        if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:wait_for_chore()
            local1[local3]:freeze()
        end
        local3 = local3 + 1
    end
end
determine_winner = function(arg1) -- line 345
    local local1 = { }
    local local2 = { }
    local local3
    local local4
    local2[1] = turbanman
    local2[2] = caneman
    local2[3] = fatlady
    if bogen.pissed and not cn.bogens_in_the_house_again then
        if arg1 == rtable1 then
            local1[1] = turbanman
        elseif arg1 == rtable2 then
            local1[1] = caneman
        elseif arg1 == rtable3 then
            local1[1] = fatlady
        end
    elseif arg1 == rtable1 then
        local1[1] = turbanman
    elseif arg1 == rtable3 then
        local1[1] = caneman
        local1[2] = fatlady
    end
    local3 = 1
    while local1[local3] do
        if type(local1[local3].bet) == "number" then
            if local1[local3].bet == arg1.current_value then
                return TRUE
            end
        else
            local4 = croupier:pick_color(arg1.current_value)
            if local1[local3].bet == local4 then
                return TRUE
            end
        end
        local3 = local3 + 1
    end
    return FALSE
end
roulette_tables = { }
current_roulette_table = nil
gambling_table_number = nil
cn.roulette_game_simulator = function() -- line 394
    local local1, local2
    local local3
    local local4
    local local5 = FALSE
    if not rtable1 then
        rtable1 = Roulette:create("table 1")
        rtable1.currrent_value = rndint(0, 36)
        rtable2 = Roulette:create("table 2")
        rtable2.currrent_value = rndint(0, 36)
        rtable3 = Roulette:create("table 3")
        rtable3.currrent_value = rndint(0, 36)
        roulette_tables[1] = rtable1
        roulette_tables[2] = rtable2
        roulette_tables[3] = rtable3
        gambling_table_number, local3 = next(roulette_tables, nil)
    end
    if system.currentSet == cn then
        rtable1:init_actor()
        rtable2:init_actor()
        rtable3:init_actor()
        turbanman:freeze()
        caneman:freeze()
        fatlady:freeze()
        rtable1.actor:setpos(-0.29497501, -0.16027699, 0.3238)
        rtable2.actor:setpos(0.0019249, -0.67287701, 0.3238)
        rtable3.actor:setpos(-0.58057499, -0.66287702, 0.3238)
        bogen_in_cn = TRUE
        rtable2:magnetize(2)
    end
    if not current_roulette_table then
        bogen_table = rtable2
        current_roulette_table = rtable1
        local4 = rtable3
        rtable1:spin()
        rtable2:spin()
        rtable3:spin()
    end
    sleep_for(1000)
    while 1 do
        if current_roulette_table == bogen_table and bogen_in_cn then
            current_roulette_table:magnetize(2)
        end
        local2 = start_script(current_roulette_table.stop, current_roulette_table)
        if system.currentSet == cn then
            local1 = start_script(croupier.turn_to_table, croupier, current_roulette_table)
            wait_for_script(local1)
        else
            sleep_for(3000)
        end
        wait_for_script(local2)
        if system.currentSet == cn then
        end
        start_script(cn.casino_patrons, cn.SPIN, local4)
        if current_roulette_table == bogen_table and bogen_in_cn and current_roulette_table.current_value == 2 then
            if system.currentSet == cn then
                croupier:thaw(TRUE)
            end
            croupier:say_line("/cncr125/")
            wait_for_message()
            croupier:say_line("/cncr126/")
            wait_for_message()
            croupier:say_line("/cncr127/")
            if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
                croupier:play_chore(1)
                croupier:wait_for_chore()
            end
            wait_for_message()
            if system.currentSet == cn then
            end
            bogen:say_line(pick_one_of({ "/cnbo128/", "/cnbo129/", "/cnbo130/", "/cnbo131/", "/cnbo132/", "/cnbo133/", "/cnbo134/" }))
            wait_for_message()
        else
            if system.currentSet == cn then
                croupier:thaw(TRUE)
            end
            croupier:say_line("/cncr135/")
            wait_for_message()
            croupier:say_french_number(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_color_french(current_roulette_table.current_value)
            wait_for_message()
            croupier:even_odd_manque_passe(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_english_number(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_color_english(current_roulette_table.current_value)
            wait_for_message()
            if current_roulette_table == bogen_table and bogen_in_cn then
                if not bogen.pissed then
                    local1 = start_script(cf.piss_off_bogen)
                    wait_for_script(local1)
                    bogen:free()
                    bogen_in_cn = FALSE
                else
                    start_script(cf.really_piss_off_bogen)
                    return TRUE
                end
            else
                local5 = determine_winner(current_roulette_table)
                if local5 then
                    local5 = FALSE
                    croupier:say_line("/cncr136/")
                    wait_for_message()
                    croupier:say_line("/cncr137/")
                    wait_for_message()
                end
                if system.currentSet == cn then
                end
                local1 = start_script(cn.casino_patrons, cn.WIN, current_roulette_table)
                wait_for_script(local1)
            end
        end
        sleep_for(1000)
        if system.currentSet == cn then
            croupier:thaw(TRUE)
        end
        croupier:say_line("/cncr119/")
        wait_for_message()
        croupier:say_line("/cncr120/")
        wait_for_message()
        if system.currentSet == cn then
        end
        local1 = start_script(cn.casino_patrons, cn.BET, current_roulette_table)
        wait_for_script(local1)
        if system.currentSet == cn then
            croupier:thaw(TRUE)
        end
        croupier:say_line("/cncr121/")
        wait_for_message()
        croupier:say_line("/cncr122/")
        wait_for_message()
        croupier:say_line("/cncr123/")
        wait_for_message()
        croupier:say_line("/cncr124/")
        croupier:wait_for_message()
        if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            croupier:play_chore(1)
            sleep_for(600)
            start_sfx("cnRoulet.imu")
            sleep_for(1008)
        end
        current_roulette_table:spin()
        local4 = current_roulette_table
        gambling_table_number, local3 = next(roulette_tables, gambling_table_number)
        if not local3 then
            gambling_table_number, local3 = next(roulette_tables, nil)
        end
        current_roulette_table = local3
        if system.currentSet == cn then
            croupier:wait_for_chore()
        end
    end
end
cn.charlie_idles = function() -- line 570
    local local1
    charlie.stop_idle = FALSE
    charlie:stop_chore(cc_booth_idles_sit_pose)
    while not charlie.stop_idle do
        charlie:play_chore(cc_booth_idles_smoke)
        charlie:wait_for_chore()
        local1 = rndint(10, 30)
        repeat
            sleep_for(10)
            local1 = local1 - 1
        until local1 < 0 or charlie.stop_idle
    end
end
cn.set_up_actors = function(arg1) -- line 587
    if bogen.pissed then
        if cn.bogens_in_the_house_again then
            cn.bogen_obj:make_touchable()
            bogen:set_costume("bogen.cos")
            bogen:put_in_set(cn)
            bogen:setpos(0.370565, -0.611363, 0)
            bogen:set_mumble_chore(bogen_mumble)
            bogen:set_talk_chore(1, bogen_stop_talk)
            bogen:set_talk_chore(2, bogen_a)
            bogen:set_talk_chore(3, bogen_c)
            bogen:set_talk_chore(4, bogen_e)
            bogen:set_talk_chore(5, bogen_f)
            bogen:set_talk_chore(6, bogen_l)
            bogen:set_talk_chore(7, bogen_m)
            bogen:set_talk_chore(8, bogen_o)
            bogen:set_talk_chore(9, bogen_t)
            bogen:set_talk_chore(10, bogen_u)
            start_script(bogen.new_run_idle, bogen, "stand", bogen.idle_table)
            bogen_in_cn = TRUE
            rtable2:magnetize(2)
        else
            cn.bogen_obj:make_untouchable()
        end
    else
        bogen_in_cn = TRUE
        if not bogen.hCos then
            bogen.hCos = "bogen.cos"
        end
        bogen:set_costume(bogen.hCos)
        bogen:put_in_set(cn)
        bogen:setpos(0.370565, -0.611363, 0)
        bogen:setrot(0, 160, 0)
        bogen:set_mumble_chore(bogen_mumble)
        bogen:set_talk_chore(1, bogen_stop_talk)
        bogen:set_talk_chore(2, bogen_a)
        bogen:set_talk_chore(3, bogen_c)
        bogen:set_talk_chore(4, bogen_e)
        bogen:set_talk_chore(5, bogen_f)
        bogen:set_talk_chore(6, bogen_l)
        bogen:set_talk_chore(7, bogen_m)
        bogen:set_talk_chore(8, bogen_o)
        bogen:set_talk_chore(9, bogen_t)
        bogen:set_talk_chore(10, bogen_u)
        start_script(bogen.new_run_idle, bogen, "stand", bogen.idle_table, "bogen.cos")
    end
    if not tix_printer then
        tix_printer = Actor:create(nil, nil, nil, "printer")
    end
    if cn.printer.owner ~= manny then
        tix_printer:set_costume("mc_booth_idles.cos")
        tix_printer:setpos(0.863729, -0.142364, 0.00900003)
        tix_printer:setrot(0, 0.29, 0)
        tix_printer:set_visibility(FALSE)
        tix_printer:put_in_set(cn)
        tix_printer:play_chore(mc_booth_idles_printer_only)
    end
    croupier:set_costume("spinner.cos")
    croupier:set_mumble_chore(spinner_mumble)
    croupier:set_talk_chore(1, spinner_stop_talk)
    croupier:set_talk_chore(2, spinner_a)
    croupier:set_talk_chore(3, spinner_c)
    croupier:set_talk_chore(4, spinner_e)
    croupier:set_talk_chore(5, spinner_f)
    croupier:set_talk_chore(6, spinner_l)
    croupier:set_talk_chore(7, spinner_m)
    croupier:set_talk_chore(8, spinner_o)
    croupier:set_talk_chore(9, spinner_t)
    croupier:set_talk_chore(10, spinner_u)
    croupier:set_head(3, 4, 5, 200, 28, 80)
    croupier:set_turn_chores(spinner_swvl_left, spinner_swvl_right)
    croupier:set_turn_rate(15)
    croupier:put_in_set(cn)
    croupier:follow_boxes()
    croupier:setpos(-0.199975, -0.468877, 0)
    if hh.union_card.owner == manny then
        cn.charlie_obj:make_untouchable()
    else
        charlie:set_costume("ccharlie.cos")
        charlie:set_mumble_chore(ccharlie_mumble)
        charlie:set_talk_chore(1, ccharlie_no_talk)
        charlie:set_talk_chore(2, ccharlie_a)
        charlie:set_talk_chore(3, ccharlie_c)
        charlie:set_talk_chore(4, ccharlie_e)
        charlie:set_talk_chore(5, ccharlie_f)
        charlie:set_talk_chore(6, ccharlie_l)
        charlie:set_talk_chore(7, ccharlie_m)
        charlie:set_talk_chore(8, ccharlie_o)
        charlie:set_talk_chore(9, ccharlie_t)
        charlie:set_talk_chore(10, ccharlie_u)
        charlie:push_costume("cc_booth_idles.cos")
        charlie:put_in_set(cn)
        charlie:setpos(0.917252, 0.259107, -0.0515)
        charlie:setrot(0, 180, 0)
        start_script(cn.charlie_idles)
    end
    if not turbanman then
        turbanman = Actor:create(nil, nil, nil, "turbanman")
        caneman = Actor:create(nil, nil, nil, "caneman")
        fatlady = Actor:create(nil, nil, nil, "fatlady")
    end
    turbanman:set_costume("turbanman.cos")
    turbanman:put_in_set(cn)
    turbanman:setpos(-0.510075, 0.124623, 0)
    turbanman:setrot(0, 220, 0)
    turbanman:play_chore(turbanman_base_pose)
    caneman:set_costume("caneman.cos")
    caneman:put_in_set(cn)
    if bogen.pissed and not cn.bogens_in_the_house_again then
        caneman:setpos(-0.0635751, -0.992476, 0)
        caneman:setrot(0, 300, 0)
    else
        caneman:setpos(-0.695394, -0.293976, 0)
        caneman:setrot(0, 180, 0)
    end
    caneman:play_chore(caneman_base_pose)
    fatlady:set_costume("fatlady.cos")
    fatlady:put_in_set(cn)
    fatlady:setpos(-0.915694, -0.588876, 0)
    fatlady:setrot(0, 215, 0)
    fatlady:play_chore(fatlady_base_pose)
    if rtable1 then
        rtable1:init_actor()
        rtable2:init_actor()
        rtable3:init_actor()
        rtable1.actor:setpos(-0.294975, -0.160277, 0.3238)
        rtable2.actor:setpos(0.0019249, -0.672877, 0.3238)
        rtable3.actor:setpos(-0.580575, -0.662877, 0.3238)
        if current_roulette_table == rtable1 then
            croupier:setrot(0, 0, 0)
        elseif current_roulette_table == rtable2 then
            croupier:setrot(0, 260, 0)
        else
            croupier:setrot(0, 120, 0)
        end
    end
end
cn.return_bogen = function() -- line 743
    made_vacancy = TRUE
    hh.union_card.owner = manny
    dd.strike_on = TRUE
end
cn.enter = function(arg1) -- line 749
    cn.pause_spinning = FALSE
    if made_vacancy and hh.union_card.owner == manny and dd.strike_on then
        cn.bogens_in_the_house_again = TRUE
    end
    if not find_script(cn.roulette_game_simulator) then
        start_script(cn.roulette_game_simulator)
    end
    cn:set_up_actors()
    preload_sfx("cnRoulet.imu")
    preload_sfx("cnRouStp.wav")
end
cn.exit = function(arg1) -- line 764
    bogen:free()
    croupier:free()
    charlie:free()
    caneman:free()
    turbanman:free()
    fatlady:free()
    rtable1.actor:free()
    rtable2.actor:free()
    rtable3.actor:free()
    stop_script(cn.charlie_idles)
    stop_sound("cnRoulet.imu")
    stop_sound("cnRouStp.wav")
    tix_printer:free()
end
cn.charlie_obj = Object:create(cn, "Charlie", 0.85364002, 0.21664301, 0.38, { range = 0.80000001 })
cn.charlie_obj.use_pnt_x = 0.92835897
cn.charlie_obj.use_pnt_y = -0.266837
cn.charlie_obj.use_pnt_z = 0
cn.charlie_obj.use_rot_x = 0
cn.charlie_obj.use_rot_y = 378.05701
cn.charlie_obj.use_rot_z = 0
cn.charlie_obj.lookAt = function(arg1) -- line 792
    manny:say_line("/cnma138/")
end
cn.charlie_obj.pickUp = function(arg1) -- line 796
    manny:say_line("/cnma139/")
end
cn.charlie_obj.use = function(arg1) -- line 800
    if arg1.talked_out then
        manny:say_line("/drma001/")
    else
        START_CUT_SCENE()
        charlie.stop_idle = TRUE
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        wait_for_script(cn.charlie_idles)
        Dialog:run("ch1", "dlg_charlie.lua")
        END_CUT_SCENE()
    end
end
cn.printer = Object:create(cn, "printer", 0, 0, 0, { range = 0 })
cn.printer.lookAt = function(arg1) -- line 818
    if tb.tried_ticket then
        manny:say_line("/cnma140/")
    else
        manny:say_line("/cnma141/")
    end
end
cn.printer.use = function(arg1) -- line 826
    if cn.ticket.owner == manny then
        START_CUT_SCENE()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.ticket
        close_inventory()
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:stop_chore(mc_hold, "mc.cos")
        manny.is_holding = nil
        cn.ticket:free()
        manny:play_chore(mc_toss_stub, "mc.cos")
        manny:wait_for_chore()
        manny:fade_out_chore(mc_toss_stub, "mc.cos", 300)
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.printer
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
    end
    inventory_save_set = system.currentSet
    inventory_save_setup = system.currentSet:current_setup()
    inventory_save_pos = manny:getpos()
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = tpButtonHandler
    tp:switch_to_set()
end
cn.printer.default_response = function(arg1) -- line 858
    if tb.tried_ticket then
        manny:say_line("/cnma142/")
    else
        manny:say_line("/cnma143/")
    end
end
cn.ticket = Object:create(cn, "betting stub", 0, 0, 0, { range = 0 })
cn.ticket.string_name = "ticket"
cn.ticket.temp_id_number = 0
cn.ticket.wav = "getCard.wav"
cn.ticket.lookAt = function(arg1) -- line 871
    START_CUT_SCENE()
    manny:say_line("/cnma144/")
    manny:wait_for_message()
    if arg1.day == 1 then
        manny:say_line("/cnma145/")
    elseif arg1.day == 2 then
        manny:say_line("/cnma146/")
    elseif arg1.day == 3 then
        manny:say_line("/cnma147/")
    elseif arg1.day == 4 then
        manny:say_line("/cnma148/")
    elseif arg1.day == 5 then
        manny:say_line("/cnma149/")
    elseif arg1.day == 6 then
        manny:say_line("/cnma150/")
    elseif arg1.day == 7 then
        manny:say_line("/cnma151/")
    end
    manny:wait_for_message()
    manny:say_line("/cnma152/")
    manny:wait_for_message()
    manny:say_number(arg1.week)
    manny:wait_for_message()
    manny:say_line("/cnma153/")
    manny:wait_for_message()
    manny:say_number(arg1.race)
    END_CUT_SCENE()
end
cn.ticket.use = cn.ticket.lookAt
cn.pass = Object:create(cn, "V.I.P. pass", 0, 0, 0, { range = 0 })
cn.pass.string_name = "pass"
cn.pass.wav = "getCard.wav"
cn.pass.lookAt = function(arg1) -- line 900
    soft_script()
    manny:say_line("/cnma154/")
    wait_for_message()
    manny:say_line("/bima075/")
end
cn.pass.use = function(arg1) -- line 908
    manny:say_line("/cnma155/")
end
cn.pass.default_response = cn.pass.use
cn.croupier_obj = Object:create(cn, "Roulette croupier", -0.22641701, -0.450957, 0.41999999, { range = 0.60000002 })
cn.croupier_obj.use_pnt_x = 0.063582897
cn.croupier_obj.use_pnt_y = -0.30095699
cn.croupier_obj.use_pnt_z = 0
cn.croupier_obj.use_rot_x = 0
cn.croupier_obj.use_rot_y = -229.771
cn.croupier_obj.use_rot_z = 0
cn.croupier_obj.lookAt = function(arg1) -- line 922
    soft_script()
    manny:say_line("/cnma156/")
    wait_for_message()
    manny:say_line("/cnma157/")
end
cn.croupier_obj.use = function(arg1) -- line 929
    START_CUT_SCENE()
    cn.pause_spinning = TRUE
    manny:walkto_object(arg1)
    croupier:wait_for_message()
    manny:say_line("/cnma158/")
    wait_for_message()
    croupier:head_look_at_manny()
    if bogen.pissed then
        if not cn.bogens_in_the_house_again then
            croupier:say_line_manny("/cncr159/")
            wait_for_message()
            manny:say_line("/cnma160/")
            wait_for_message()
            croupier:say_line_manny("/cncr161/")
        else
            croupier:say_line_manny("/cncr162/")
            wait_for_message()
            croupier:say_line_manny("/cncr163/")
        end
    else
        croupier:say_line_manny("/cncr164/")
    end
    croupier:head_look_at(nil)
    wait_for_message()
    sleep_for(500)
    cn.pause_spinning = FALSE
    END_CUT_SCENE()
end
cn.gamblers = Object:create(cn, "gamblers", -0.531515, 0.110031, 0.38999999, { range = 0.80000001 })
cn.gamblers.use_pnt_x = 0.0084851598
cn.gamblers.use_pnt_y = 0.110031
cn.gamblers.use_pnt_z = 0
cn.gamblers.use_rot_x = 0
cn.gamblers.use_rot_y = 129.875
cn.gamblers.use_rot_z = 0
cn.gamblers.lookAt = function(arg1) -- line 969
    manny:say_line("/cnma165/")
    wait_for_message()
    manny:say_line("/cnma166/")
end
cn.gamblers.pickUp = function(arg1) -- line 975
    manny:say_line("/cnma167/")
end
cn.gamblers.use = function(arg1) -- line 979
    manny:say_line("/cnma168/")
end
cn.bogen_obj = Object:create(cn, "Bogen", 0.370565, -0.61136299, 0.34999999, { range = 0.60000002 })
cn.bogen_obj.use_pnt_x = 0.41056499
cn.bogen_obj.use_pnt_y = -0.30136299
cn.bogen_obj.use_pnt_z = 0
cn.bogen_obj.use_rot_x = 0
cn.bogen_obj.use_rot_y = 185.45
cn.bogen_obj.use_rot_z = 0
cn.bogen_obj.lookAt = function(arg1) -- line 991
    soft_script()
    manny:say_line("/cnma169/")
    wait_for_message()
    manny:say_line("/cnma170/")
end
cn.bogen_obj.pickUp = cn.gamblers.pickUp
cn.bogen_obj.use = function(arg1) -- line 1000
    START_CUT_SCENE()
    if cn.bogens_in_the_house_again and bogen.pissed then
        manny:say_line("/cnma171/")
        wait_for_message()
        bogen:say_line("/cnbo172/")
    else
        manny:say_line("/cnma173/")
        wait_for_message()
        bogen:say_line("/cnbo174/")
    end
    END_CUT_SCENE()
end
cn.bogen_obj.use_key = function(arg1) -- line 1015
    soft_script()
    manny:say_line("/slma205/")
    manny:wait_for_message()
    manny:say_line("/slma206/")
end
cn.ci_door = Object:create(cn, "/cntx249/door", -0.58838499, 1.69042, 0.63999999, { range = 0.60000002 })
cn.ci_door.use_pnt_x = -0.640468
cn.ci_door.use_pnt_y = 0.35423601
cn.ci_door.use_pnt_z = 0
cn.ci_door.use_rot_x = 0
cn.ci_door.use_rot_y = 2.3106101
cn.ci_door.use_rot_z = 0
cn.ci_door.out_pnt_x = -0.62948501
cn.ci_door.out_pnt_y = 1.61693
cn.ci_door.out_pnt_z = 0.1
cn.ci_door.out_rot_x = 0
cn.ci_door.out_rot_y = 8.0328197
cn.ci_door.out_rot_z = 0
cn.ci_box = cn.ci_door
cn.ci_door.walkOut = function(arg1) -- line 1044
    START_CUT_SCENE()
    manny:walkto_object(cn.ci_door, TRUE)
    manny:wait_for_actor()
    END_CUT_SCENE()
    ci:come_out_door(ci.cn_door)
end

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

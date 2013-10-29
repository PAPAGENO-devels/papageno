CheckFirstTime("hq.lua")
hq = Set:create("hq.set", "headquarters", { hq_bgbrd = 0, hq_bgbrd1 = 0, hq_ovrhd = 1, hq_elews = 2 })
hq.camera_adjusts = { 330, 10 }
hq.radio_volume = 30
hq.shrinkable = 0.03
dofile("sv_in_hq.lua")
dofile("sv_hq_idles.lua")
dofile("ev_r_idles.lua")
dofile("ma_wheel_stuck.lua")
dofile("hq_slideshow.lua")
dofile("ev_get_mp.lua")
hq.leave_town = function(arg1) -- line 23
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    hq:current_setup(hq_bgbrd1)
    manny:walkto_object(hq.salvador_obj)
    manny:wait_for_actor()
    salvador:push_chore(sv_hq_idles_head_turn_left)
    salvador:push_chore()
    salvador:say_line("/hqsa102/")
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
    wait_for_message()
    salvador:play_chore(sv_hq_idles_talk_stand_up)
    salvador:wait_for_chore()
    salvador:say_line("/hqsa103/")
    wait_for_message()
    END_CUT_SCENE()
    if DEMO then
        hq:demo_closing()
    else
        stop_script(hq.eva_radio_noise)
        stop_script(hq.static)
        stop_sound("projectr.imu")
        stop_script(hq.lsa_slideshow)
        start_script(cut_scene.stump, cut_scene)
    end
end
hq.eva_mover = function(arg1) -- line 52
    if hq:current_setup() == hq_elews then
        eva:setpos(-0.557415, -0.414567, -0.07)
        eva:setrot(0, 172, 0)
    else
        eva:setpos(-0.563042, -0.421926, -0.08)
        eva:setrot(0, 178, 0)
    end
    while 1 do
        if hq.cameraChange then
            if hq:current_setup() == hq_elews then
                eva:setpos(-0.557415, -0.414567, -0.07)
                eva:setrot(0, 172, 0)
                hq.radio_volume = 100
            else
                eva:setpos(-0.563042, -0.421926, -0.08)
                eva:setrot(0, 177, 0)
                hq.radio_volume = 30
            end
        end
        break_here()
    end
end
ge = function() -- line 77
    rf.eggs:get()
    dom.mouthpiece:get()
    dom.mouthpiece.bonded = TRUE
    dom.mouthpiece.molded = TRUE
end
hq.demo_opening = function(arg1) -- line 84
    START_CUT_SCENE()
    set_override(hq.demo_opening_override, hq)
    ImSetState(STATE_NULL)
    if not PL_MODE then
        StartFullscreenMovie("demo_frontend.san")
        wait_for_movie()
    end
    manny:setpos(0.608613, -0.19144, 0)
    manny:setrot(0, 88.8016, 0)
    hq:init_hq()
    salvador:setpos(-0.861, -0.201, 0)
    salvador:setrot(0, 272.255, 0)
    start_script(hq.salvador_walks)
    wait_for_script(hq.salvador_walks)
    eva:setpos(-0.563042, -0.421926, -0.08)
    eva:setrot(0, 177, 0)
    END_CUT_SCENE()
    hq:demo_opening_override()
end
hq.demo_opening_override = function(arg1, arg2) -- line 116
    if arg2 then
        kill_override()
        break_here()
    end
    manny:setpos(0.608613, -0.19144, 0)
    manny:setrot(0, 88.8016, 0)
    stop_script(hq.salvador_walks)
    stop_script(hq.sal_turn_home)
    salvador:follow_boxes()
    salvador:ignore_boxes()
    salvador:stop_chore(sv_in_hq_walk)
    salvador:stop_chore(sv_in_hq_begin_walk)
    salvador:stop_chore(sv_in_hq_end_walk)
    salvador:setrot(0, -200, 0)
    salvador:setpos(-0.825013, 0.391542, 0)
    hq:current_setup(hq_bgbrd)
    eva:setpos(-0.563042, -0.421926, -0.08)
    eva:setrot(0, 177, 0)
    hq:init_hq()
end
hq.demo_closing = function(arg1) -- line 145
    START_CUT_SCENE()
    ImSetState(STATE_NULL)
    ImStopAllSounds()
    set_override(hq.demo_closing_override, hq)
    pause_scripts()
    if not PL_MODE then
        RunFullscreenMovie("demo_backend.san")
    end
    END_CUT_SCENE()
    exit()
end
hq.demo_closing_override = function(arg1) -- line 158
    unpause_scripts()
    kill_override()
    exit()
end
hq.sal_turn_home = function() -- line 164
    while TurnActorTo(salvador.hActor, -0.825013, 0.391542, 0) do
        break_here()
    end
end
hq.salvador_walks = function() -- line 170
    stop_script(hq.salvador_idles)
    START_CUT_SCENE()
    hq:current_setup(hq_elews)
    sleep_for(500)
    salvador:set_walk_rate(0.5)
    start_script(hq.sal_turn_home, hq)
    salvador:play_chore(sv_in_hq_begin_walk)
    salvador:wait_for_chore()
    wait_for_script(hq.sal_turn_home)
    salvador:set_walk_chore(sv_in_hq_walk)
    salvador:walkto(-0.825013, 0.391542, 0)
    sleep_for(1600)
    salvador:stop_walk()
    salvador:set_walk_chore(nil)
    salvador:stop_chore(sv_in_hq_walk)
    salvador:setpos(-0.781387, 0.36856, 0.01)
    salvador:setrot(0, 180, 0)
    set_override(nil)
    salvador:push_costume("sv_hq_idles.cos")
    salvador:play_chore(sv_hq_idles_hold, "sv_hq_idles.cos")
    salvador:wait_for_chore()
    salvador:pop_costume()
    hq:current_setup(hq_bgbrd)
    END_CUT_SCENE()
end
hq.salvador_idles = function() -- line 204
    local local1
    local local2
    salvador:setpos(-0.78138697, 0.36855999, 0.0099999998)
    salvador:setrot(0, 180, 0)
    salvador:push_costume("sv_hq_idles.cos")
    salvador:play_chore(sv_hq_idles_hold, "sv_hq_idles.cos")
    salvador.stop_idle = FALSE
    while 1 do
        while not salvador.stop_idle do
            salvador:play_chore(sv_hq_idles_hold)
            salvador:wait_here(rnd(1, 3))
            salvador:head_look_at(nil)
            if rnd() then
                hq.salvador_scratching = FALSE
                salvador:wait_here(rnd(2, 4))
            else
                hq.salvador_scratching = TRUE
                salvador:stop_chore(sv_hq_idles_hold)
                if not salvador.stop_idle then
                    salvador:play_chore_looping(sv_hq_idles_scratch_chin)
                    salvador:wait_here(rnd(1, 3))
                    salvador:set_chore_looping(sv_hq_idles_scratch_chin, FALSE)
                    salvador:wait_for_chore()
                end
            end
            salvador:play_chore(sv_hq_idles_hold)
        end
        break_here()
    end
end
salvador.wait_here = function(arg1, arg2) -- line 238
    repeat
        if arg1.stop_idle then
            arg2 = 0
        else
            arg2 = arg2 - 1
            sleep_for(500)
        end
    until arg2 <= 0
end
hq.salvador_look_at_manny = function() -- line 253
    hq.salvador_look = FALSE
    while not hq.done_looking do
        break_here()
    end
    salvador:head_look_at_manny()
end
hq.radio_sfx = { }
hq.radio_sfx[1] = "blip1.wav"
hq.radio_sfx[2] = "blip2.wav"
hq.radio_sfx[3] = "blip3.wav"
hq.radio_sfx[4] = "blip4.wav"
hq.radio_sfx[5] = "blip5.wav"
hq.radio_sfx[6] = "blip6.wav"
hq.radio_sfx[7] = "blip7.wav"
hq.radio_sfx[8] = "blip8.wav"
hq.radio_sfx[9] = "blip9.wav"
hq.radio_sfx[10] = "blip10.wav"
hq.radio_sfx[11] = "blip11.wav"
hq.radio_sfx[12] = "blip12.wav"
hq.radio_sfx[13] = "blip13.wav"
hq.radio_sfx[14] = "blip14.wav"
hq.radio_sfx[15] = "blip15.wav"
hq.static = function() -- line 280
    while 1 do
        eva:play_sound_at("static.wav")
        wait_for_sound("static.wav")
    end
end
hq.eva_radio_noise = function() -- line 288
    local local1, local2, local3
    while 1 do
        local1 = eva:is_choring()
        if local1 == ev_r_idles_m_tune_radio then
            local2 = pick_from_nonweighted_table(hq.radio_sfx)
            local3 = pick_from_nonweighted_table(hq.radio_sfx)
            start_sfx(local2, nil, hq.radio_volume)
            sleep_for(rnd(25, 100))
            start_sfx(local3, nil, hq.radio_volume)
            wait_for_sound(local2)
            wait_for_sound(local3)
            sleep_for(rnd(50, 300))
            break_here()
        end
        break_here()
    end
end
hq.set_up_actors = function(arg1) -- line 310
    salvador:default()
    salvador:put_in_set(hq)
    salvador:set_mumble_chore(sv_in_hq_mumble)
    salvador:set_talk_chore(1, sv_in_hq_stop_talk)
    salvador:set_talk_chore(2, sv_in_hq_a)
    salvador:set_talk_chore(3, sv_in_hq_c)
    salvador:set_talk_chore(4, sv_in_hq_e)
    salvador:set_talk_chore(5, sv_in_hq_f)
    salvador:set_talk_chore(6, sv_in_hq_l)
    salvador:set_talk_chore(7, sv_in_hq_m)
    salvador:set_talk_chore(8, sv_in_hq_o)
    salvador:set_talk_chore(9, sv_in_hq_t)
    salvador:set_talk_chore(10, sv_in_hq_u)
    eva:default()
    eva.idle_table = nil
    eva.idle_table = Idle:create("ev_r_idles")
    eva.idle_table:add_state("l_toward_ma", { hold_to_ma = 1 })
    eva.idle_table:add_state("hold_to_ma", { hold_to_ma = 0.85, turn_bk = 0.15 })
    eva.idle_table:add_state("turn_bk", { l_toward_ma = 0.2, m_tune_radio = 0.45, m_turn_l_to_ma = 0.35 })
    eva.idle_table:add_state("turn_back", { l_toward_ma = 0.05, m_tune_radio = 0.45, listen = 0.45, m_turn_l_to_ma = 0.05 })
    eva.idle_table:add_state("m_tune_radio", { m_tune_radio = 0.45, listen = 0.45, m_turn_l_to_ma = 0.1 })
    eva.idle_table:add_state("listen", { m_tune_radio = 0.45, m_turn_l_to_ma = 0.05 })
    eva.idle_table:add_state("m_distracted", { m_distracted = 0.5, turn_back = 0.5 })
    eva.idle_table:add_state("m_turn_l_to_ma", { turn_back = 1 })
    eva.stop_table = { }
    eva.stop_table[ev_r_idles_l_toward_ma] = ev_r_idles_turn_bk
    eva.stop_table[ev_r_idles_hold_to_ma] = ev_r_idles_turn_bk
    eva.stop_table[ev_r_idles_turn_bk] = ev_r_idles_m_turn_l_to_ma
    eva.stop_table[ev_r_idles_turn_back] = ev_r_idles_m_turn_l_to_ma
    eva.stop_table[ev_r_idles_m_tune_radio] = ev_r_idles_m_turn_l_to_ma
    eva.stop_table[ev_r_idles_listen] = ev_r_idles_m_turn_l_to_ma
    eva.stop_table[ev_r_idles_m_distracted] = ev_r_idles_turn_bk
    if not er_radio_cos then
        er_radio_cos = "ev_r_idles.cos"
    end
    eva:put_in_set(hq)
    eva:set_mumble_chore(ev_r_idles_mumble)
    eva:set_talk_chore(1, ev_r_idles_stop_talk)
    eva:set_talk_chore(2, ev_r_idles_a)
    eva:set_talk_chore(3, ev_r_idles_c)
    eva:set_talk_chore(4, ev_r_idles_e)
    eva:set_talk_chore(5, ev_r_idles_f)
    eva:set_talk_chore(6, ev_r_idles_l)
    eva:set_talk_chore(7, ev_r_idles_m)
    eva:set_talk_chore(8, ev_r_idles_o)
    eva:set_talk_chore(9, ev_r_idles_t)
    eva:set_talk_chore(10, ev_r_idles_u)
    eva:set_turn_rate(40)
    eva:set_head(3, 4, 5, 165, 28, 80)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 0.29)
    SetActorShadowPlane(manny.hActor, "slide_shadow")
    AddShadowPlane(manny.hActor, "slide_shadow")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 100, 0, 100)
    SetActorShadowPlane(manny.hActor, "door_shadow")
    AddShadowPlane(manny.hActor, "door_shadow")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 0, 10, 100)
    SetActorShadowPlane(manny.hActor, "wheel_shadow")
    AddShadowPlane(manny.hActor, "wheel_shadow")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, 1, -6, 35)
    SetActorShadowPlane(manny.hActor, "eva_shadow")
    AddShadowPlane(manny.hActor, "eva_shadow")
    salvador:setrot(0, -200, 0)
    salvador:setpos(-0.825013, 0.391542, 0)
end
hq.lsa_slideshow = function(arg1) -- line 390
    local local1 = { }
    local local2, local3
    local1[0] = hq_slideshow_slide1
    local1[1] = hq_slideshow_slide2
    hq.slideshow_displayed = FALSE
    local2, local3 = next(local1, nil)
    while TRUE do
        hq.slideshow_displayed = TRUE
        hq.plans:play_chore(local3)
        sleep_for(10000)
        hq.slideshow_displayed = FALSE
        hq.plans:play_chore(hq_slideshow_no_slide)
        start_sfx("slidechg.wav")
        sleep_for(500)
        local2, local3 = next(local1, local2)
        if local2 == nil then
            local2, local3 = next(local1, nil)
        end
    end
end
hq.enter = function(arg1) -- line 421
    eva:set_visibility(TRUE)
    LoadCostume("ma_wheel_stuck.cos")
    hq.plans:set_object_state("hq_slideshow.cos")
    NewObjectState(0, 3, "hq_slideshow.bm", nil)
    if DEMO and not hq.run_demo_opening then
        hq.run_demo_opening = TRUE
        dofile("sv_helps.lua")
        start_script(hq.demo_opening, hq)
    else
        hq:init_hq()
    end
end
hq.init_hq = function(arg1) -- line 437
    manny.footsteps = footsteps.marble
    hq.al_door:open(TRUE)
    single_start_sfx("projectr.imu")
    set_vol("projectr.imu", 50)
    single_start_script(hq.lsa_slideshow, hq)
    start_script(hq.eva_radio_noise)
    hq:set_up_actors()
    single_start_script(hq.track_shadows, hq)
    single_start_script(eva.new_run_idle, eva, "m_tune_radio")
    single_start_script(hq.eva_mover)
    single_start_script(hq.salvador_idles)
end
hq.exit = function(arg1) -- line 455
    salvador:free()
    eva:free()
    stop_script(hq.eva_radio_noise)
    stop_script(hq.static)
    stop_script(hq.eva_mover)
    stop_script(hq.salvador_idles)
    stop_sound("projectr.imu")
    stop_script(hq.lsa_slideshow)
    stop_script(hq.track_shadows)
    KillActorShadows(manny.hActor)
    hq.slideshow_displayed = FALSE
    stop_script(hq.salvador_look_at_manny)
end
hq.track_shadows = function(arg1) -- line 472
    local local1 = { }
    local local2 = { }
    local local3 = { }
    local local4
    local2.x = 3
    local2.y = 0
    local2.z = 0.5
    local3.x = 3
    local3.y = 0
    local3.z = 0.5
    while TRUE do
        local1 = manny:getpos()
        if local1.x < -0.33000001 and local1.y > 0 then
            ActivateActorShadow(manny.hActor, 0, TRUE)
        else
            ActivateActorShadow(manny.hActor, 0, nil)
        end
        break_here()
    end
end
hq.salvador_obj = Object:create(hq, "/hqtx104/Salvador", -0.83501297, 0.46154201, 0.43000001, { range = 0.80000001 })
hq.salvador_obj.use_pnt_x = -0.29821101
hq.salvador_obj.use_pnt_y = 0.24349201
hq.salvador_obj.use_pnt_z = 0
hq.salvador_obj.use_rot_x = 0
hq.salvador_obj.use_rot_y = 83.460403
hq.salvador_obj.use_rot_z = 0
hq.salvador_obj.lookAt = function(arg1) -- line 516
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    END_CUT_SCENE()
    manny:say_line("/hqma105/")
end
hq.salvador_obj.pickUp = function(arg1) -- line 524
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    END_CUT_SCENE()
    manny:say_line("/hqma106/")
end
hq.salvador_obj.use = function(arg1) -- line 532
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    END_CUT_SCENE()
    Dialog:run("sa2", "dlg_sal2.lua")
end
hq.salvador_obj.use_eggs = function(arg1) -- line 541
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    manny:walkto_object(arg1)
    manny:say_line("/alma010/")
    manny:wait_for_actor()
    END_CUT_SCENE()
    START_CUT_SCENE()
    salvador.got_eggs = TRUE
    rf.eggs:put_in_limbo()
    wait_for_message()
    salvador:push_chore(sv_hq_idles_gets_up)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_grab_n_sit)
    salvador:say_line("/hqsa107/")
    wait_for_message()
    salvador:say_line("/hqsa108/")
    wait_for_message()
    salvador:say_line("/hqsa109/")
    wait_for_message()
    salvador:wait_for_chore(sv_hq_idles_grab_n_sit)
    salvador:pop_costume()
    salvador:play_chore_looping(sv_in_hq_hide_eggs)
    manny:stop_chore(ms_hold, "ms.cos")
    manny:stop_chore(manny.hold_chore, "ms.cos")
    manny.is_holding = nil
    manny.hold_chore = nil
    salvador:head_look_at(manny)
    salvador:play_chore(sv_in_hq_to_salute)
    salvador:setrot(0, 190, 0, TRUE)
    salvador:wait_for_chore()
    salvador:play_chore_looping(sv_in_hq_hold_salute)
    salvador:say_line("/hqsa110/")
    wait_for_message()
    salvador:stop_chore(sv_in_hq_hold_salute)
    salvador:play_chore(sv_in_hq_done_salute)
    salvador:setrot(0, 180, 0, TRUE)
    salvador:wait_for_chore()
    salvador:head_look_at(nil)
    salvador:push_costume("sv_hq_idles.cos")
    salvador:play_chore_looping(sv_hq_idles_hide_the_damn_eggs)
    if DEMO then
        END_CUT_SCENE()
        hq:leave_town()
    elseif eva.got_teeth then
        hq:leave_town()
    else
        manny:say_line("/hqma111/")
        wait_for_message()
        salvador:say_line("/hqsa112/")
        wait_for_message()
        salvador:say_line("/hqsa113/")
        start_script(hq.salvador_idles)
    end
    END_CUT_SCENE()
    salvador:stop_chore(sv_in_hq_hide_eggs)
end
hq.salvador_obj.use_mouthpiece = function(arg1) -- line 607
    START_CUT_SCENE()
    start_script(hq.salvador_look_at_manny)
    END_CUT_SCENE()
    START_CUT_SCENE()
    salvador:say_line("/hqsa114/")
    wait_for_message()
    salvador:say_line("/hqsa115/")
    END_CUT_SCENE()
    start_script(hq.salvador_idles)
end
hq.salvador_obj.kill_idle = function(arg1) -- line 619
    salvador.stop_idle = TRUE
    wait_for_script(hq.salvador_idles)
end
hq.eva_obj = Object:create(hq, "/hqtx116/Eva", -0.54741502, -0.49456701, 0.43000001, { range = 0.60000002 })
hq.eva_obj.use_pnt_x = -0.64592803
hq.eva_obj.use_pnt_y = -0.175311
hq.eva_obj.use_pnt_z = 0
hq.eva_obj.use_rot_x = 0
hq.eva_obj.use_rot_y = 169.146
hq.eva_obj.use_rot_z = 0
hq.eva_obj.lookAt = function(arg1) -- line 635
    soft_script()
    manny:say_line("/hqma117/")
    wait_for_message()
    eva:say_line("/hqev118/")
end
hq.eva_obj.pickUp = function(arg1) -- line 642
    soft_script()
    manny:say_line("/hqma119/")
    wait_for_message()
    eva:say_line("/hqev120/")
end
hq.eva_obj.use = function(arg1) -- line 649
    if manny:walkto(arg1) then
        START_CUT_SCENE()
        start_script(eva.kill_idle, eva, ev_r_idles_m_turn_l_to_ma)
        eva:head_look_at(manny)
        END_CUT_SCENE()
        Dialog:run("ev2", "dlg_eva2.lua")
    end
end
hq.eva_obj.use_eggs = function(arg1) -- line 659
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:say_line("/alma010/")
    start_script(eva.kill_idle, eva, ev_r_idles_m_turn_l_to_ma)
    eva:head_look_at(manny)
    wait_for_message()
    END_CUT_SCENE()
    eva:say_line("/hqev121/")
    start_script(eva.new_run_idle, eva, "turn_back")
    eva:head_look_at(nil)
end
hq.eva_obj.use_mouthpiece = function(arg1) -- line 674
    if dom.mouthpiece.bonded then
        if dom.mouthpiece.molded then
            START_CUT_SCENE()
            manny:walkto_object(arg1)
            stop_script(eva.new_run_idle)
            manny:wait_for_actor()
            eva:stop_chore(nil)
            eva:push_costume("ev_get_mp.cos")
            eva.got_teeth = TRUE
            dom.mouthpiece:put_in_limbo()
            eva:play_chore(ev_get_mp_get_mp)
            sleep_for(1541)
            sleep_for(871)
            eva:wait_for_chore()
            eva:stop_chore(ev_get_mp_get_mp)
            eva:play_chore(ev_get_mp_hqev122)
            eva:say_line("/hqev122/")
            start_sfx("evagrbmp.WAV")
            manny:stop_chore(manny.hold_chore, "ms.cos")
            manny:stop_chore(ms_hold, "ms.cos")
            manny.is_holding = nil
            wait_for_message()
            eva:wait_for_chore()
            eva:stop_chore(ev_get_mp_hqev122)
            eva:play_chore(ev_get_mp_hqev123)
            eva:say_line("/hqev123/")
            wait_for_message()
            salvador:say_line("/hqsa124/")
            salvador:wait_for_message()
            eva:pop_costume()
            start_script(eva.new_run_idle, eva, "m_tune_radio")
            if salvador.got_eggs then
                hq:leave_town()
            elseif salvador.talked_pigeons then
                manny:say_line("/hqma125/")
                wait_for_message()
                salvador:say_line("/hqsa126/")
            end
            END_CUT_SCENE()
        else
            START_CUT_SCENE()
            eva:say_line("/hqev127/")
            wait_for_message()
            manny:say_line("/hqma128/")
            wait_for_message()
            eva:say_line("/hqev129/")
            END_CUT_SCENE()
        end
    else
        START_CUT_SCENE()
        eva:say_line("/hqev130/")
        wait_for_message()
        manny:say_line("/hqma131/")
        wait_for_message()
        eva:say_line("/hqev132/")
        wait_for_message()
        END_CUT_SCENE()
    end
end
hq.plans = Object:create(hq, "/hqtx133/plans", -0.99760002, 0.0470002, 0.46000001, { range = 0.60000002 })
hq.plans.use_pnt_x = -0.63136101
hq.plans.use_pnt_y = 0.15371899
hq.plans.use_pnt_z = 0
hq.plans.use_rot_x = 0
hq.plans.use_rot_y = 96.810303
hq.plans.use_rot_z = 0
hq.plans.lookAt = function(arg1) -- line 746
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    manny:walkto_object(arg1)
    manny:say_line("/hqma134/")
    wait_for_message()
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:say_line("/hqsa135/")
    salvador:wait_for_message()
    salvador:play_chore(sv_hq_idles_head_turn_right)
    salvador.stop_idle = FALSE
    END_CUT_SCENE()
end
hq.plans.use = function(arg1) -- line 760
    manny:say_line("/hqma136/")
end
hq.projector = Object:create(hq, "/hqtx137/slide projector", -0.0575996, -0.0129997, 0.25999999, { range = 0.5 })
hq.projector.use_pnt_x = 0.1228
hq.projector.use_pnt_y = 0.237
hq.projector.use_pnt_z = 0
hq.projector.use_rot_x = 0
hq.projector.use_rot_y = 173.099
hq.projector.use_rot_z = 0
hq.projector.lookAt = function(arg1) -- line 773
    manny:say_line("/hqma138/")
end
hq.projector.pickUp = function(arg1) -- line 777
    manny:say_line("/hqma139/")
end
hq.projector.use = function(arg1) -- line 781
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    manny:walkto(arg1)
    while not hq.slideshow_displayed do
        break_here()
    end
    stop_script(hq.lsa_slideshow)
    manny:play_chore(ms_hand_on_obj, "ms.cos")
    manny:wait_for_chore(ms_hand_on_obj, "ms.cos")
    hq.plans:play_chore(hq_slideshow_no_slide)
    start_sfx("slidechg.wav")
    manny:head_look_at(hq.plans)
    manny:play_chore(ms_hand_off_obj, "ms.cos")
    manny:wait_for_chore(ms_hand_off_obj, "ms.cos")
    salvador:say_line("/hqsa140/")
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:wait_for_message()
    manny:head_look_at(arg1)
    manny:play_chore(ms_hand_on_obj, "ms.cos")
    manny:wait_for_chore(ms_hand_on_obj, "ms.cos")
    start_sfx("slidechg.wav")
    start_script(hq.lsa_slideshow, hq)
    salvador:play_chore(sv_hq_idles_head_turn_right)
    salvador.stop_idle = FALSE
    manny:play_chore(ms_hand_off_obj, "ms.cos")
    manny:wait_for_chore(ms_hand_off_obj, "ms.cos")
    END_CUT_SCENE()
end
hq.hatch = Object:create(hq, "/hqtx141/hatch", 0.51239997, 0.79699999, 0.41, { range = 0.69999999 })
hq.hatch.use_pnt_x = 0.465
hq.hatch.use_pnt_y = 0.63999999
hq.hatch.use_pnt_z = 0
hq.hatch.use_rot_x = 0
hq.hatch.use_rot_y = -356.53601
hq.hatch.use_rot_z = 0
hq.hatch.lookAt = function(arg1) -- line 824
    START_CUT_SCENE()
    salvador.stop_idle = TRUE
    manny:say_line("/hqma142/")
    wait_for_message()
    salvador:say_line("/hqsa143/")
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:wait_for_message()
    salvador:play_chore(sv_hq_idles_head_turn_right)
    salvador.stop_idle = FALSE
    hq.hatch:members_only()
    END_CUT_SCENE()
end
hq.hatch.members_only = function(arg1) -- line 839
    salvador:say_line("/hqsa144/")
end
hq.hatch.use = function(arg1) -- line 844
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:push_costume("ma_wheel_stuck.cos")
    manny:play_chore(ma_wheel_stuck_hands_on_wheel, "ma_wheel_stuck.cos")
    manny:wait_for_chore(ma_wheel_stuck_hands_on_wheel, "ma_wheel_stuck.cos")
    manny:play_chore(ma_wheel_stuck_turn_stuck_wheel, "ma_wheel_stuck.cos")
    manny:play_sound_at("valvtwst.wav")
    manny:wait_for_chore(ma_wheel_stuck_turn_stuck_wheel, "ma_wheel_stuck.cos")
    manny:say_line("/hqma145/")
    manny:play_chore(ma_wheel_stuck_hands_off_wheel, "ma_wheel_stuck.cos")
    manny:wait_for_chore(ma_wheel_stuck_hands_off_wheel, "ma_wheel_stuck.cos")
    manny:pop_costume()
    wait_for_message()
    hq.hatch:members_only()
    END_CUT_SCENE()
end
hq.hatch.pickUp = hq.hatch.use
hq.computer = Object:create(hq, "/hqtx146/computer", -0.41760001, 0.56699997, 0.34, { range = 0.5 })
hq.computer.use_pnt_x = -0.39300001
hq.computer.use_pnt_y = 0.26100001
hq.computer.use_pnt_z = 0
hq.computer.use_rot_x = 0
hq.computer.use_rot_y = -356.67001
hq.computer.use_rot_z = 0
hq.computer.lookAt = function(arg1) -- line 873
    manny:say_line("/hqma147/")
    if not arg1.seen then
        arg1.seen = TRUE
        START_CUT_SCENE()
        salvador.stop_idle = TRUE
        wait_for_message()
        salvador:play_chore(sv_hq_idles_head_turn_left)
        salvador:say_line("/hqsa148/")
        wait_for_message()
        salvador:play_chore(sv_hq_idles_head_turn_right)
        salvador.stop_idle = FALSE
        if not eva.got_teeth and not DEMO then
            salvador:say_line("/hqsa149/")
            wait_for_message()
            manny:say_line("/hqma150/")
            wait_for_message()
            salvador:say_line("/hqsa151/")
        end
        END_CUT_SCENE()
    end
end
hq.computer.pickUp = function(arg1) -- line 896
    system.default_response("not portable")
end
hq.computer.use = hq.computer.lookAt
hq.proj_spot_1 = { x = -0.83501399, y = -0.23845799, z = 0.60000002 }
hq.proj_spot_2 = { x = -0.99501401, y = -0.87501401, z = 0.0115416 }
hq.proj_spot_3 = { x = -0.98501402, y = 0.0515416, z = 0.33000001 }
hq.slide_items = { }
hq.slide_items[1] = hq.proj_spot_1
hq.slide_items[2] = hq.proj_spot_2
hq.slide_items[3] = hq.proj_spot_3
hq.scratch_spot1 = { x = -0.995013, y = 0.101542, z = 0.61000001 }
hq.scratch_spot2 = { x = -0.995013, y = 0.101542, z = 0.58999997 }
hq.scratch_spot3 = { x = -1.01501, y = -0.0284584, z = 0.58999997 }
hq.scratch_items = { }
hq.scratch_items[1] = hq.scratch_spot1
hq.scratch_items[2] = hq.scratch_spot2
hq.scratch_items[3] = hq.scratch_spot3
hq.al_door = Object:create(hq, "/hqtx152/elevator", 1.0524, 0.046999998, 0.5, { range = 0.1 })
hq.hq_al_box = hq.al_door
hq.al_door.use_pnt_x = 0.89461601
hq.al_door.use_pnt_y = -0.0153875
hq.al_door.use_pnt_z = 0
hq.al_door.use_rot_x = 0
hq.al_door.use_rot_y = -92.425797
hq.al_door.use_rot_z = 0
hq.al_door.out_pnt_x = 1.3379101
hq.al_door.out_pnt_y = -0.00312
hq.al_door.out_pnt_z = 0
hq.al_door.out_rot_x = 0
hq.al_door.out_rot_y = 90
hq.al_door.out_rot_z = 0
hq.al_door.passage = { "hq_elev_box" }
hq.al_door.lookAt = function(arg1) -- line 944
    manny:say_line("/hqma153/")
end
hq.al_door.walkOut = function(arg1) -- line 948
    START_CUT_SCENE()
    set_override(hq.al_door.skip_walkout, hq.al_door)
    manny:walkto_object(arg1, TRUE)
    ImSetState(STATE_NULL)
    play_movie("hq_close.snm", 193, 173)
    wait_for_movie()
    al:switch_to_set()
    al.hq_door:open()
    al.ga_door_obj.interest_actor:put_in_set(al)
    al.ga_door_obj:play_chore(0)
    SendObjectToBack(al.hDoorObj)
    ForceRefresh()
    manny:put_in_set(al)
    manny:setpos(0.075089, 2.08581, 0)
    manny:setrot(0, 260, 0)
    manny:walkto(0.45573, 2.02417, 0)
    sleep_for(100)
    manny:head_look_at_point(0.442081, 1.96215, 0)
    manny:wait_for_actor()
    al.hq_door:close()
    al.ga_door_obj:play_chore(1)
    SendObjectToBack(al.hDoorObj)
    ImSetState(STATE_NULL)
    play_movie("al_close.snm", 0, 64)
    manny:head_look_at(nil)
    manny:walkto(0.467088, 1.52067, 0)
    wait_for_movie()
    al.ga_door_obj:play_chore(0)
    SendObjectToBack(al.hDoorObj)
    ForceRefresh()
    manny:wait_for_actor()
    music_state:set_state(stateAL)
    END_CUT_SCENE()
end
hq.al_door.skip_walkout = function(arg1) -- line 988
    kill_override()
    break_here()
    al:switch_to_set()
    al.hq_door:close()
    manny:put_in_set(al)
    manny:setpos(0.467088, 1.52067, 0)
    manny:setrot(0, 62, 0)
    manny:head_look_at(nil)
    al.ga_door_obj:play_chore(0)
    ForceRefresh()
    music_state:set_state(stateAL)
end
hq.al_door.open = function(arg1, arg2) -- line 1002
    if not arg2 then
        START_CUT_SCENE()
        ImSetState(STATE_NULL)
        wait_for_movie()
        music_state:set_state(stateHQ)
        END_CUT_SCENE()
    end
    Object.open(arg1)
end
hq.al_door.close = function(arg1, arg2) -- line 1015
    if not arg2 then
        START_CUT_SCENE()
        ImSetState(STATE_NULL)
        wait_for_movie()
        music_state:set_state(stateHQ)
        END_CUT_SCENE()
    end
    Object.close(arg1)
end

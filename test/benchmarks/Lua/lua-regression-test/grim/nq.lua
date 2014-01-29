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

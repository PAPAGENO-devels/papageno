CheckFirstTime("hf.lua")
dofile("the_floreses.lua")
dofile("he_praise.lua")
hf = Set:create("hf.set", "hectors foyer", { hf_top = 0, hf_intha = 1, hf_intha1 = 1, hf_diaws = 2 })
hf.shrinkable = 0.04
hf.hector_pos = { x = -0.06602, y = 0.49406, z = 0 }
hf.hector_rot = { x = 0, y = 180, z = 0 }
hector.default_praise = function(arg1) -- line 24
    arg1:set_costume(nil)
    arg1:set_costume("he_praise.cos")
    arg1:set_mumble_chore(he_praise_mumble)
    arg1:set_talk_chore(1, he_praise_stop_talk)
    arg1:set_talk_chore(2, he_praise_a)
    arg1:set_talk_chore(3, he_praise_c)
    arg1:set_talk_chore(4, he_praise_e)
    arg1:set_talk_chore(5, he_praise_f)
    arg1:set_talk_chore(6, he_praise_l)
    arg1:set_talk_chore(7, he_praise_m)
    arg1:set_talk_chore(8, he_praise_o)
    arg1:set_talk_chore(9, he_praise_t)
    arg1:set_talk_chore(10, he_praise_u)
    arg1:put_in_set(hf)
    arg1:setpos(hf.hector_pos.x, hf.hector_pos.y, hf.hector_pos.z)
    arg1:setrot(hf.hector_rot.x, hf.hector_rot.y, hf.hector_rot.z)
end
hf.flores_idles = function(arg1) -- line 48
    while 1 do
        celso:play_chore(the_floreses_default)
        sleep_for(3000)
        if rnd(7) then
            celso:run_chore(the_floreses_to_whsper)
            celso:play_chore(the_floreses_whsper_hld)
            celso.whispering = TRUE
            sleep_for(rndint(5000, 8000))
            celso:run_chore(the_floreses_whspr_2dflt)
            celso.whispering = FALSE
        elseif rnd(7) then
            celso:run_chore(the_floreses_lovey)
            celso:play_chore(the_floreses_lov_hld)
            celso.lovey = TRUE
            sleep_for(rndint(5000, 8000))
            celso:run_chore(the_floreses_lov_2dflt)
            celso.lovey = FALSE
        end
    end
end
hf.flores_stop_idles = function(arg1) -- line 71
    stop_script(hf.flores_idles)
    celso:wait_for_chore()
    if celso.whispering then
        celso:run_chore(the_floreses_whspr_2dflt)
    end
    if celso.lovey then
        celso:run_chore(the_floreses_lov_2dflt)
    end
    celso:play_chore(the_floreses_default)
end
hf.meet_hector = function(arg1) -- line 87
    START_CUT_SCENE()
    if not hf.met_hector then
        sleep_for(500)
        manny:shrug_gesture()
        manny:say_line("/hfma002/")
        manny:wait_for_message()
        manny:knock_on_door_anim()
        start_script(manny.backup, manny, 500)
        sleep_for(500)
        manny:setrot(0, 45, 0, TRUE)
        sleep_for(500)
        hector:default_praise()
        hector:say_line("/hfhe003/")
        hf.hectors_door:play_chore(0)
        hf.hectors_door:wait_for_chore(0)
        hector:run_chore(he_praise_enter)
        hector:wait_for_message()
        hector:say_line("/hfhe004/")
        hector:wait_for_message()
        manny:wait_for_actor()
        manny:play_chore(ms_takeout_get, manny.base_costume)
        manny:say_line("/hfma005/")
        manny:wait_for_message()
    else
        manny:say_line("/hfma006/")
        manny:wait_for_message()
        manny:knock_on_door_anim()
        start_script(manny.backup, manny, 500)
        sleep_for(500)
        manny:setrot(0, 45, 0, TRUE)
        sleep_for(500)
        manny:wait_for_actor()
        manny:play_chore(ms_takeout_get, manny.base_costume)
        hector:default_praise()
        hf.hectors_door:play_chore(0)
        hf.hectors_door:wait_for_chore(0)
        hector:run_chore(he_praise_enter)
        hector:say_line("/hfhe007/")
        hector:wait_for_message()
    end
    hector:say_line("/hfhe008/")
    hector:wait_for_message()
    hector:run_chore(he_praise_exit)
    start_sfx("hecdoors.WAV")
    hf.hectors_door:play_chore(1)
    hf.hectors_door:wait_for_chore(1)
    manny:play_chore(ms_takeout_empty, manny.base_costume)
    if not hf.met_hector then
        hf.met_hector = TRUE
        wait_for_message()
        celso:say_line("/hfce009/")
        sleep_for(500)
        manny:head_look_at(hf.couple)
        manny:turn_toward_entity(hf.couple)
        celso:wait_for_message()
        celso:say_line("/hfce010/")
        celso:wait_for_message()
    end
    manny:wait_for_chore(ms_takeout_empty, manny.base_costume)
    manny:stop_chore(ms_takeout_empty, manny.base_costume)
    END_CUT_SCENE()
end
hf.celso_buy_ticket = function(arg1) -- line 154
    START_CUT_SCENE()
    celso.sold = TRUE
    hf.couple:make_untouchable()
    celso:play_chore(the_floreses_lovey)
    celso:say_line("/hfce069/")
    manny:head_look_at(nil)
    start_script(hf.manny_knock_and_back_off, hf)
    celso:wait_for_message()
    celso:play_chore(the_floreses_lov_2dflt)
    celso:say_line("/hfce070/")
    celso:wait_for_chore(the_floreses_love_2dflt)
    wait_for_script(hf.manny_knock_and_back_off)
    hf:current_setup(hf_intha)
    hector:default_praise()
    hf.hectors_door:play_chore(0)
    hf.hectors_door:wait_for_chore(0)
    hector:run_chore(he_praise_enter)
    celso:say_line("/hfce011/")
    celso:wait_for_message()
    hector:play_chore(he_praise_nod_talk)
    hector:say_line("/hfhe012/")
    hector:wait_for_message()
    celso:play_chore(the_floreses_walk_away)
    hector:say_line("/hfhe013/")
    hector:wait_for_message()
    celso:say_line("/hfce014/")
    hector:play_chore(he_praise_exit)
    hector:wait_for_chore()
    sleep_for(1000)
    hf:current_setup(hf_diaws)
    celso:wait_for_chore()
    celso:put_in_set(nil)
    celso:wait_for_message()
    hector:say_line("/hfhe015/")
    manny:shrug_gesture()
    hector:wait_for_message()
    hector:say_line("/hfhe016/")
    hector:wait_for_message()
    start_sfx("hecdoorc.WAV")
    hf.hectors_door:play_chore(1)
    hf.hectors_door:wait_for_chore(1)
    sleep_for(500)
    manny:tilt_head_gesture()
    manny:say_line("/hfma017/")
    manny:wait_for_message()
    manny:say_line("/hfma018/")
    manny:wait_for_message()
    END_CUT_SCENE()
    box_on("celso_box")
end
hf.goto_oldjob = function(arg1) -- line 209
    cur_puzzle_state[58] = TRUE
    th.grinder_actor:free()
    START_CUT_SCENE()
    manny:stop_walk()
    hf:current_setup(hf_intha)
    hector:default_praise()
    hf.hectors_door:play_chore(0)
    hf.hectors_door:wait_for_chore(0)
    hector:run_chore(he_praise_enter)
    hector:say_line("/hfhe019/")
    manny:head_look_at(hf.hectors_door)
    start_script(manny.turn_toward_entity, manny, hf.hectors_door)
    hector:wait_for_message()
    hector:play_chore(he_praise_nod_talk)
    hector:say_line("/hfhe020/")
    hector:wait_for_message()
    hector:say_line("/hfhe021/")
    hector:wait_for_message()
    END_CUT_SCENE()
    nq.photo:free()
    sh.remote:free()
    manny:head_look_at(nil)
    manny:default("reaper")
    start_script(cut_scene.oldjob, cut_scene)
end
hf.manny_knock_and_back_off = function(arg1) -- line 237
    manny:walkto(-0.00817938, -0.518114, 0)
    manny:wait_for_actor()
    manny:walkto_object(hf.hectors_door)
    manny:wait_for_actor()
    manny:knock_on_door_anim()
    manny:backup(3000)
end
hf.first_time_in = function(arg1) -- line 246
    START_CUT_SCENE()
    hf:switch_to_set()
    manny:put_in_set(hf)
    manny:setpos(hf.ly_door.out_pnt_x, hf.ly_door.out_pnt_y, hf.ly_door.out_pnt_z)
    manny:setrot(0, hf.ly_door.out_rot_y + 180, 0)
    hf:current_setup(hf_intha)
    hf.ly_door:play_chore(0)
    hf.ly_door:wait_for_chore(0)
    manny:walkto(hf.ly_door.use_pnt_x, hf.ly_door.use_pnt_y, hf.ly_door.use_pnt_z)
    manny:wait_for_actor()
    hf.ly_door:play_chore(1)
    hf.ly_door:wait_for_chore(1)
    END_CUT_SCENE()
end
hf.set_up_actors = function(arg1) -- line 268
    if not celso.sold then
        celso:set_costume(nil)
        celso:set_costume("the_floreses.cos")
        celso:set_talk_color(Yellow)
        celso:set_mumble_chore(the_floreses_mumble)
        celso:set_talk_chore(1, the_floreses_no_talk)
        celso:set_talk_chore(2, the_floreses_a)
        celso:set_talk_chore(3, the_floreses_c)
        celso:set_talk_chore(4, the_floreses_e)
        celso:set_talk_chore(5, the_floreses_f)
        celso:set_talk_chore(6, the_floreses_l)
        celso:set_talk_chore(7, the_floreses_m)
        celso:set_talk_chore(8, the_floreses_o)
        celso:set_talk_chore(9, the_floreses_t)
        celso:set_talk_chore(10, the_floreses_u)
        celso:put_in_set(hf)
        celso:setpos(0.7579, -0.63158, 0.00559)
        celso:setrot(0, 88.3265, 0)
        celso:play_chore(the_floreses_default)
        start_script(hf.flores_idles)
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -0.5, 10)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(celso.hActor, 0)
    SetActorShadowPoint(celso.hActor, 0, -0.5, 10)
    SetActorShadowPlane(celso.hActor, "shadow1")
    AddShadowPlane(celso.hActor, "shadow1")
end
hf.enter = function(arg1) -- line 307
    hf:add_object_state(hf_intha, "hf_hectors_door.bm", "hf_hectors_door.zbm", OBJSTATE_STATE)
    hf:add_object_state(hf_intha, "hf_elevator_door.bm", nil, OBJSTATE_UNDERLAY)
    hf.hectors_door:set_object_state("hf_hectors_door.cos")
    hf.ly_door:set_object_state("hf_elevator_door.cos")
    hf:set_up_actors()
    if celso.sold then
        hf.couple:make_untouchable()
        box_on("celso_box")
    else
        box_off("celso_box")
    end
end
hf.exit = function(arg1) -- line 324
    KillActorShadows(manny.hActor)
    KillActorShadows(celso.hActor)
    stop_script(hf.flores_idles)
    celso:free()
end
hf.oldjob_trig = { }
hf.oldjob_trig.walkOut = function(arg1) -- line 338
    if celso.sold then
        start_script(hf.goto_oldjob)
    end
end
hf.couple = Object:create(hf, "/hftx022/couple", 0.75774002, -0.65548301, 0.41, { range = 0.80000001 })
hf.couple.use_pnt_x = 0.58999997
hf.couple.use_pnt_y = -0.48113099
hf.couple.use_pnt_z = 0
hf.couple.use_rot_x = 0
hf.couple.use_rot_y = 234.54401
hf.couple.use_rot_z = 0
hf.couple.person = TRUE
hf.couple.lookAt = function(arg1) -- line 355
    manny:say_line("/hfma023/")
end
hf.couple.use = function(arg1) -- line 359
    if manny:walkto_object(arg1) then
        Dialog:run("ce2", "dlg_celso2.lua")
    end
end
hf.hectors_door = Object:create(hf, "/hftx024/door", -0.034597199, 0.228605, 0.47999999, { range = 0.80000001 })
hf.hectors_door.use_pnt_x = 0.027194999
hf.hectors_door.use_pnt_y = 0.080907501
hf.hectors_door.use_pnt_z = 0
hf.hectors_door.use_rot_x = 0
hf.hectors_door.use_rot_y = 10
hf.hectors_door.use_rot_z = 0
hf.hectors_door.lookAt = function(arg1) -- line 374
    manny:say_line("/hfma025/")
    manny:wait_for_message()
    manny:say_line("/hfma026/")
end
hf.hectors_door.use = function(arg1) -- line 381
    if manny:walkto_object(arg1) then
        start_script(hf.meet_hector)
    end
end
hf.floor = Object:create(hf, "/hftx027/monogram", 0.00056155602, -0.56940001, 0, { range = 0.60000002 })
hf.floor.use_pnt_x = -0.00199996
hf.floor.use_pnt_y = -0.67832702
hf.floor.use_pnt_z = 0
hf.floor.use_rot_x = 0
hf.floor.use_rot_y = 259.224
hf.floor.use_rot_z = 0
hf.floor.lookAt = function(arg1) -- line 396
    manny:say_line("/hfma028/")
    wait_for_message()
    manny:say_line("/hfma029/")
end
hf.floor.use = function(arg1) -- line 402
    local local1 = FALSE
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        if manny:get_costume() ~= "mcc_thunder_wait_idles.cos" then
            manny:push_costume("mcc_thunder_wait_idles.cos")
            local1 = TRUE
        end
        manny:run_chore(manny_idles_smoke1, "mcc_thunder_wait_idles.cos")
        manny:stop_chore(manny_idles_smoke1, "mcc_thunder_wait_idles.cos")
        manny:run_chore(manny_idles_smoke_stomp, "mcc_thunder_wait_idles.cos")
        manny:stop_chore(manny_idles_smoke_stomp, "mcc_thunder_wait_idles.cos")
        if local1 then
            manny:pop_costume()
        end
        END_CUT_SCENE()
    end
end
hf.ly_door = Object:create(hf, "/hftx001/door", 0.0068063699, -1.85392, 0.60000002, { range = 0.60000002 })
hf.ly_door.use_pnt_x = -0.106329
hf.ly_door.use_pnt_y = -0.94224101
hf.ly_door.use_pnt_z = 0
hf.ly_door.use_rot_x = 0
hf.ly_door.use_rot_y = 183
hf.ly_door.use_rot_z = 0
hf.ly_door.out_pnt_x = -0.119464
hf.ly_door.out_pnt_y = -1.3
hf.ly_door.out_pnt_z = 0
hf.ly_door.out_rot_x = 0
hf.ly_door.out_rot_y = 183
hf.ly_door.out_rot_z = 0
hf.ly_box = hf.ly_door
hf.ly_door.walkOut = function(arg1) -- line 446
    START_CUT_SCENE()
    manny:walkto(-0.00724274, -1.08005, 0)
    manny:wait_for_actor()
    manny:say_line("/hfma030/")
    END_CUT_SCENE()
end

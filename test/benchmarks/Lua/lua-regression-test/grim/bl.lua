CheckFirstTime("bl.lua")
bl = Set:create("bl.set", "beach lower", { bl_lamst = 0, bl_noshp = 1, bl_ovrhd = 2 })
dofile("pu_tag.lua")
dofile("bibi_tag.lua")
bibi.play_sounds = { "/blbi001/", "/blbi002/", "/blbi003/", "/blbi004/", "/blbi005/", "/blbi006/", "/blbi007/", "/blbi008/", "/blbi009/", "/blbi010/", "/blbi012/" }
pugsy.play_sounds = { "/blpu013/", "/blpu014/", "/blpu015/", "/blpu016/", "/blpu017/", "/blpu018/", "/blpu019/", "/blpu020/", "/blpu021/", "/blpu022/", "/blpu024/" }
bl.pugsy_play_sounds = function() -- line 39
    while 1 do
        pugsy:wait_for_message()
        if not find_script(bl.everybodys_here) and not find_script(bl.talk_reef) then
            pugsy:say_line(pick_one_of(pugsy.play_sounds, TRUE))
        end
        sleep_for(3000 * random() + 1000)
    end
end
bl.bibi_play_sounds = function() -- line 49
    while 1 do
        bibi:wait_for_message()
        if not find_script(bl.everybodys_here) and not find_script(bl.talk_reef) then
            bibi:say_line(pick_one_of(bibi.play_sounds, TRUE))
        end
        sleep_for(3000 * random() + 1000)
    end
end
bl.set_up_angelitos = function(arg1) -- line 59
    pugsy:free()
    pugsy:set_costume("pu_talk_idles.cos")
    pugsy:set_mumble_chore(pu_talk_idles_mumble, "pu_talk_idles.cos")
    pugsy:set_talk_chore(1, pu_talk_idles_stop_talk)
    pugsy:set_talk_chore(2, pu_talk_idles_a)
    pugsy:set_talk_chore(3, pu_talk_idles_c)
    pugsy:set_talk_chore(4, pu_talk_idles_e)
    pugsy:set_talk_chore(5, pu_talk_idles_f)
    pugsy:set_talk_chore(6, pu_talk_idles_l)
    pugsy:set_talk_chore(7, pu_talk_idles_m)
    pugsy:set_talk_chore(8, pu_talk_idles_o)
    pugsy:set_talk_chore(9, pu_talk_idles_t)
    pugsy:set_talk_chore(10, pu_talk_idles_u)
    pugsy:push_costume("pu_tag.cos")
    pugsy:set_head(6, 7, 8, 165, 28, 80)
    pugsy:set_look_rate(180)
    pugsy:put_in_set(bl)
    pugsy:setpos(3.25797, -27.2651, 3.071)
    pugsy:setrot(0, 250, 0)
    SetActiveShadow(pugsy.hActor, 0)
    SetActorShadowPoint(pugsy.hActor, 0, 0, 100)
    SetActorShadowPlane(pugsy.hActor, "shadow1")
    AddShadowPlane(pugsy.hActor, "shadow1")
    pugsy:set_speech_mode(MODE_BACKGROUND)
    pugsy.say_line = nil
    bibi:free()
    bibi:set_costume("bibi_talk_idles.cos")
    bibi:set_mumble_chore(bibi_talk_idles_mumble, "bibi_talk_idles.cos")
    bibi:set_talk_chore(1, bibi_talk_idles_stop_talk)
    bibi:set_talk_chore(2, bibi_talk_idles_a)
    bibi:set_talk_chore(3, bibi_talk_idles_c)
    bibi:set_talk_chore(4, bibi_talk_idles_e)
    bibi:set_talk_chore(5, bibi_talk_idles_f)
    bibi:set_talk_chore(6, bibi_talk_idles_l)
    bibi:set_talk_chore(7, bibi_talk_idles_m)
    bibi:set_talk_chore(8, bibi_talk_idles_o)
    bibi:set_talk_chore(9, bibi_talk_idles_t)
    bibi:set_talk_chore(10, bibi_talk_idles_u)
    bibi:push_costume("bibi_tag.cos")
    bibi:set_head(6, 7, 8, 165, 28, 80)
    bibi:set_look_rate(180)
    bibi:put_in_set(bl)
    bibi:setpos(3.52097, -26.9561, 3.071)
    bibi:setrot(0, 250, 0)
    SetActiveShadow(bibi.hActor, 0)
    SetActorShadowPoint(bibi.hActor, 0, 0, 100)
    SetActorShadowPlane(bibi.hActor, "shadow1")
    AddShadowPlane(bibi.hActor, "shadow1")
    bibi:set_speech_mode(MODE_BACKGROUND)
    bibi.say_line = nil
end
bl.play_tag = function(arg1) -- line 118
    local local1, local2
    bibi:stop_chore(bibi_tag_ccw_hover, "bibi_tag.cos")
    pugsy:stop_chore(pu_tag_ccw_hover, "pu_tag.cos")
    bibi:head_look_at(nil, 200)
    pugsy:head_look_at(nil, 200)
    start_script(meche.head_follow_mesh, meche, bibi, 1)
    start_script(bl.bibi_play_sounds)
    while 1 do
        pugsy:play_chore(pu_tag_cw_loop, "pu_tag.cos")
        bibi:run_chore(bibi_tag_cw_hover_to_loop, "bibi_tag.cos")
        bibi:play_chore(bibi_tag_cw_loop, "bibi_tag.cos")
        local1 = ceil(6 * random())
        local2 = 0
        while local2 <= local1 do
            pugsy:wait_for_chore(pu_tag_cw_loop, "pu_tag.cos")
            pugsy:play_chore(pu_tag_cw_loop, "pu_tag.cos")
            bibi:wait_for_chore(bibi_tag_cw_loop, "bibi_tag.cos")
            bibi:play_chore(bibi_tag_cw_loop, "bibi_tag.cos")
            pugsy:wait_for_chore(pu_tag_cw_loop, "pu_tag.cos")
            local2 = local2 + 1
        end
        pugsy:play_chore(pu_tag_cw_loop_to_hover, "pu_tag.cos")
        stop_script(bl.bibi_play_sounds)
        bibi:wait_for_chore(bibi_tag_cw_loop, "bibi_tag.cos")
        if not find_script(bl.everybodys_here) and not find_script(bl.talk_reef) then
            bibi:say_line("/blbi011/")
        end
        start_script(bl.bibi_play_sounds)
        bibi:run_chore(bibi_tag_tag_cw, "bibi_tag.cos")
        bibi:play_chore(bibi_tag_ccw_loop, "bibi_tag.cos")
        pugsy:run_chore(pu_tag_ccw_hover_to_loop, "pu_tag.cos")
        pugsy:play_chore(pu_tag_ccw_loop, "pu_tag.cos")
        local1 = ceil(6 * random())
        local2 = 0
        while local2 <= local1 do
            bibi:wait_for_chore(bibi_tag_ccw_loop, "bibi_tag.cos")
            bibi:play_chore(bibi_tag_ccw_loop, "bibi_tag.cos")
            pugsy:wait_for_chore(pu_tag_ccw_loop, "pu_tag.cos")
            pugsy:play_chore(pu_tag_ccw_loop, "pu_tag.cos")
            local2 = local2 + 1
        end
        bibi:wait_for_chore(bibi_tag_ccw_loop, "bibi_tag.cos")
        bibi:play_chore(bibi_tag_ccw_loop_to_hover, "bibi_tag.cos")
        stop_script(bl.pugsy_play_sounds)
        pugsy:wait_for_chore(pu_tag_ccw_loop, "pu_tag.cos")
        if not find_script(bl.everybodys_here) and not find_script(bl.talk_reef) then
            pugsy:say_line("/blpu023/")
        end
        start_script(bl.pugsy_play_sounds)
        pugsy:run_chore(pu_tag_tag_ccw, "pu_tag.cos")
    end
end
bl.kids_hover = function(arg1) -- line 187
    bibi:play_chore_looping(bibi_tag_ccw_hover, "bibi_tag.cos")
    pugsy:play_chore_looping(pu_tag_ccw_hover, "pu_tag.cos")
end
bl.set_up_meche = function(arg1) -- line 192
    meche:set_costume("meche_in_vi.cos")
    meche:put_in_set(bl)
    meche:setpos(3.80106, -25.5288, 1.3)
    meche:setrot(0, 188.749, 0)
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
    meche:set_look_rate(180)
    SetActiveShadow(meche.hActor, 0)
    SetActorShadowPoint(meche.hActor, 0, 0, 100)
    SetActorShadowPlane(meche.hActor, "shadow1")
    AddShadowPlane(meche.hActor, "shadow1")
    meche:set_collision_mode(COLLISION_BOX, 0.4)
    start_script(vi.meche_head_idle)
    start_script(vi.meche_arm_idle)
end
bl.set_up_glottis = function(arg1, arg2) -- line 222
    glottis:default("sailor")
    glottis:put_in_set(bl)
    glottis:setpos(3.1507, -26.493, 1.3)
    glottis:setrot(0, 320.074, 0)
    glottis:play_chore(glottis_sailor_home_pose, "glottis_sailor.cos")
    SetActiveShadow(glottis.hActor, 0)
    SetActorShadowPoint(glottis.hActor, 0, 0, 100)
    SetActorShadowPlane(glottis.hActor, "shadow1")
    AddShadowPlane(glottis.hActor, "shadow1")
    glottis:set_collision_mode(COLLISION_BOX, 0.5)
    if arg2 then
        bl:start_glottis_idle()
    end
end
bl.start_glottis_idle = function(arg1) -- line 240
    start_script(glottis.new_run_idle, glottis, "home_pose", glottis.idle_table, "glottis_sailor.cos")
end
bl.passengers_before_boat = function() -- line 244
    START_CUT_SCENE()
    bl.glottis_here = FALSE
    bl.meche_here = TRUE
    raised_lamancha = FALSE
    bl:switch_to_set()
    manny:put_in_set(bl)
    manny:put_at_object(bl.glottis_obj)
    manny:set_run(FALSE)
    manny:force_auto_run(FALSE)
    manny:stop_chore(mn2_run, "mn2.cos")
    stop_movement_scripts()
    IrisUp(355, 245, 1000)
    manny:head_look_at(bl.meche_obj)
    meche:head_look_at_manny()
    sleep_for(1500)
    manny:say_line("/blma025/")
    manny:hand_gesture()
    wait_for_message()
    meche:say_line("/blmc026/")
    wait_for_message()
    manny:say_line("/blma027/")
    manny:tilt_head_gesture()
    wait_for_message()
    manny:head_look_at(nil)
    start_script(manny.walk_and_face, manny, 3.28397, -28.1131, 1.3, 0, 172.214, 0)
    meche:say_line("/blmc028/")
    wait_for_message()
    sleep_for(500)
    manny:wait_for_actor()
    if gh.been_there then
        manny:say_line("/blma030/")
        wait_for_message()
        manny:say_line("/blma031/")
    else
        manny:say_line("/blma032/")
        manny:shrug_gesture()
        wait_for_message()
        sleep_for(500)
        manny:say_line("/blma033/")
        wait_for_message()
        manny:say_line("/blma034/")
        manny:twist_head_gesture()
    end
    END_CUT_SCENE()
    start_script(meche.get_kids)
end
meche.get_kids = function() -- line 303
    while system.currentSet and (system.currentSet == bl or system.currentSet == bu or inInventorySet()) do
        break_here()
    end
    meche.got_kids = TRUE
end
bl.talk_kids = function() -- line 310
    bl.talked_kids = TRUE
    START_CUT_SCENE()
    bl:kids_hover()
    sleep_for(500)
    bibi:head_look_at_manny()
    pugsy:head_look_at_manny()
    meche:head_look_at_manny()
    bibi:say_line("/blbi035/")
    wait_for_message()
    pugsy:say_line("/blpu036/")
    wait_for_message()
    bibi:say_line("/blbi037/")
    wait_for_message()
    pugsy:say_line("/blpu038/")
    wait_for_message()
    manny:say_line("/blma039/")
    wait_for_message()
    meche:say_line("/blmc040/")
    bibi:head_look_at(meche)
    pugsy:head_look_at(meche)
    wait_for_message()
    meche:say_line("/blmc041/")
    wait_for_message()
    manny:say_line("/blma044/")
    wait_for_message()
    bibi:say_line("/blbi042/")
    pugsy:say_line("/blpu043/")
    bibi:head_look_at_manny()
    pugsy:head_look_at_manny()
    meche:head_look_at_manny()
    bibi:wait_for_message()
    pugsy:wait_for_message()
    start_script(bl.play_tag)
    END_CUT_SCENE()
end
bl.everybodys_here = function() -- line 347
    START_CUT_SCENE()
    bl.glottis_here = TRUE
    bl.meche_here = TRUE
    meche.got_kids = TRUE
    bl.talked_kids = TRUE
    bl:switch_to_set()
    manny:put_in_set(bl)
    manny:put_at_object(bl.glottis_obj)
    manny:set_run(FALSE)
    manny:force_auto_run(FALSE)
    manny:stop_chore(mn2_run, "mn2.cos")
    stop_movement_scripts()
    IrisUp(355, 245, 1000)
    meche:head_look_at(bl.glottis_obj)
    glottis:head_look_at(bl.meche_obj)
    manny:head_look_at(bl.meche_obj)
    sleep_for(1000)
    meche:say_line("/blmc045/")
    wait_for_message()
    glottis:head_look_at(nil)
    glottis:play_chore(glottis_sailor_head_flick, "glottis_sailor.cos")
    glottis:say_line("/blgl046/")
    wait_for_message()
    if crusher_free then
        manny:head_look_at(bl.glottis_obj)
        manny:say_line("/blma047/")
        wait_for_message()
        glottis:say_line("/blgl048/")
        glottis:head_look_at_manny()
        wait_for_message()
        glottis:say_line("/blgl049/")
        glottis:head_look_at(nil)
        glottis:play_chore(glottis_sailor_head_flick, "glottis_sailor.cos")
        wait_for_message()
        stop_script(bl.pugsy_play_sounds)
        stop_script(bl.bibi_play_sounds)
        stop_sound("lolawatr.IMU")
        start_script(cut_scene.exodus)
    elseif bl.talked_reef then
        manny:head_look_at(bl.ship)
        glottis:head_look_at(nil)
        meche:head_look_at(nil)
        manny:say_line("/blma050/")
        wait_for_message()
        bl:start_glottis_idle()
    else
        bl.talk_reef()
    end
    END_CUT_SCENE()
end
bl.boat_before_passengers = function() -- line 401
    START_CUT_SCENE()
    bl.glottis_here = TRUE
    bl.meche_here = FALSE
    bl.angelitos_here = FALSE
    raised_lamancha = TRUE
    bl:switch_to_set()
    manny:put_in_set(bl)
    manny:put_at_object(bl.glottis_obj)
    manny:set_run(FALSE)
    manny:force_auto_run(FALSE)
    manny:stop_chore(mn2_run, "mn2.cos")
    stop_movement_scripts()
    bl.talk_reef()
    END_CUT_SCENE()
end
bl.talk_reef = function() -- line 418
    bl.talked_reef = TRUE
    manny:head_look_at(bl.ship)
    glottis:head_look_at(bl.ship)
    sleep_for(1000)
    manny:say_line("/blma051/")
    wait_for_message()
    glottis:say_line("/blgl052/")
    wait_for_message()
    glottis:head_look_at_manny()
    glottis:say_line("/blgl053/")
    wait_for_message()
    manny:head_look_at(bl.glottis_obj)
    manny:say_line("/blma054/")
    wait_for_message()
    manny:head_look_at(nil)
    if crusher_free then
        manny:tilt_head_gesture()
        manny:say_line("/blma055/")
        wait_for_message()
        if meche_freed then
            stop_sound("lolawatr.imu")
            start_script(cut_scene.exodus)
        else
            start_script(bu.thatll_do)
        end
    else
        manny:nod_head_gesture()
        manny:say_line("/blma056/")
        wait_for_message()
        glottis:head_look_at(nil)
        bl:start_glottis_idle()
    end
end
bl.set_up_actors = function(arg1) -- line 453
    if bl.glottis_here then
        bl.glottis_obj:make_touchable()
        if not find_script(bl.boat_before_passengers) and not find_script(bl.everybodys_here) then
            bl:set_up_glottis(TRUE)
        else
            bl:set_up_glottis(FALSE)
        end
    else
        bl.glottis_obj:make_untouchable()
        glottis:free()
    end
    if bl.meche_here then
        meche_freed = TRUE
        bl.meche_obj:make_touchable()
        bl:set_up_meche()
    else
        bl.meche_obj:make_untouchable()
        meche:free()
    end
end
bl.update_music_state = function(arg1) -- line 481
    if raised_lamancha then
        return stateBL_BOAT
    else
        return stateBL
    end
end
bl.enter = function(arg1) -- line 489
    if raised_lamancha then
        bl:current_setup(bl_lamst)
        bl.ship:make_touchable()
        play_movie_looping("bl_lam_ocean.snm", 176, 13)
        start_sfx("lolawatr.imu", IM_HIGH_PRIORITY, 32)
        set_pan("lolawatr.imu", 85)
    else
        bl:current_setup(bl_noshp)
        bl.ship:make_untouchable()
        play_movie_looping("bl_ocean.snm", 176, 169)
    end
    bl:set_up_actors()
    if meche.got_kids then
        bl:set_up_angelitos()
        if not bl.talked_kids then
            start_script(bl.talk_kids)
        else
            start_script(bl.play_tag)
        end
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
bl.exit = function(arg1) -- line 519
    StopMovie()
    stop_script(vi.meche_head_idle)
    stop_script(vi.meche_arm_idle)
    stop_script(glottis.new_run_idle)
    stop_script(bl.play_tag)
    stop_script(bl.pugsy_play_sounds)
    stop_script(bl.bibi_play_sounds)
    stop_script(meche.head_follow_mesh)
    bibi:free()
    meche:free()
    pugsy:free()
    glottis:free()
    KillActorShadows(manny.hActor)
    KillActorShadows(glottis.hActor)
    KillActorShadows(meche.hActor)
    KillActorShadows(pugsy.hActor)
    KillActorShadows(bibi.hActor)
    stop_sound("lolawatr.imu")
end
bl.glottis_obj = Object:create(bl, "/bltx057/Glottis", 3.5220001, -26.3699, 2.0439999, { range = 1.6 })
bl.glottis_obj.use_pnt_x = 4.072
bl.glottis_obj.use_pnt_y = -26.2549
bl.glottis_obj.use_pnt_z = 1.3
bl.glottis_obj.use_rot_x = 0
bl.glottis_obj.use_rot_y = -656.66199
bl.glottis_obj.use_rot_z = 0
bl.glottis_obj:make_untouchable()
bl.glottis_obj.lookAt = function(arg1) -- line 559
    manny:say_line("/blma058/")
end
bl.glottis_obj.pickUp = function(arg1) -- line 563
    manny:say_line("/blma059/")
end
bl.glottis_obj.use = function(arg1) -- line 567
    START_CUT_SCENE()
    manny:say_line("/blma060/")
    wait_for_message()
    glottis:say_line("/blgl061/")
    wait_for_message()
    manny:say_line("/blma062/")
    END_CUT_SCENE()
end
bl.meche_obj = Object:create(bl, "/bltx063/Meche", 3.8310001, -25.5049, 1.779, { range = 1.5 })
bl.meche_obj.use_pnt_x = 4.072
bl.meche_obj.use_pnt_y = -26.2549
bl.meche_obj.use_pnt_z = 1.3
bl.meche_obj.use_rot_x = 0
bl.meche_obj.use_rot_y = -1016.66
bl.meche_obj.use_rot_z = 0
bl.meche_obj:make_untouchable()
bl.meche_obj.lookAt = function(arg1) -- line 587
    soft_script()
    manny:say_line("/blma064/")
    wait_for_message()
    manny:say_line("/blma065/")
end
bl.meche_obj.pickUp = function(arg1) -- line 594
    manny:say_line("/blma066/")
end
bl.meche_obj.use = function(arg1) -- line 598
    soft_script()
    if raised_lamancha then
        manny:say_line("/blma067/")
        wait_for_message()
        meche:say_line("/blmc068/")
        wait_for_message()
        glottis:say_line("/blgl069/")
    else
        manny:say_line("/blma070/")
        wait_for_message()
        if meche.got_kids then
            meche:say_line("/blmc071/")
        else
            meche:say_line("/blmc028/")
        end
    end
end
bl.ship = Object:create(bl, "/bltx072/ship", 8.7324305, 1.32003, 4.2399998, { range = 28.8599 })
bl.ship.use_pnt_x = 2.5724299
bl.ship.use_pnt_y = -19.799999
bl.ship.use_pnt_z = 1.3
bl.ship.use_rot_x = 0
bl.ship.use_rot_y = -56.756401
bl.ship.use_rot_z = 0
bl.ship:make_untouchable()
bl.ship.lookAt = function(arg1) -- line 627
    manny:say_line("/blma073/")
end
bl.ship.pickUp = function(arg1) -- line 631
    manny:say_line("/blma074/")
end
bl.ship.use = function(arg1) -- line 635
    manny:say_line("/blma075/")
end
bl.bu_door = Object:create(bl, "/bltx076/beach", 1, -28.885, 1.86, { range = 0.60000002 })
bl.bu_door.use_pnt_x = 1
bl.bu_door.use_pnt_y = -28.475
bl.bu_door.use_pnt_z = 1.3
bl.bu_door.use_rot_x = 0
bl.bu_door.use_rot_y = 143.674
bl.bu_door.use_rot_z = 0
bl.bu_door.out_pnt_x = 1
bl.bu_door.out_pnt_y = -28.475
bl.bu_door.out_pnt_z = 1.3
bl.bu_door.out_rot_x = 0
bl.bu_door.out_rot_y = 143.674
bl.bu_door.out_rot_z = 0
bl.bu_box1 = bl.bu_door
bl.bu_box2 = bl.bu_door
bl.bu_door.walkOut = function(arg1) -- line 660
    bu:come_out_door(bu.bl_door)
end

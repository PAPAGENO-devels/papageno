CheckFirstTime("mt.lua")
mt = Set:create("mt.set", "mayan train station", { mt_diaha = 0, mt_diaha2 = 0, mt_diaha3 = 0, mt_diats = 1, mt_gltcu = 2, mt_gltrv = 3, mt_gltrv2 = 3, mt_ovrhd = 4 })
mt.chepito_here = TRUE
mt.chepito_sun = { x = 0.0288381, y = 1.63639, z = 0.25 }
mt.far_walk_vol = 15
mt.med_walk_vol = 30
mt.near_walk_vol = 80
mt.march_chepito = function() -- line 20
    chepito:setpos(0.289326, 1.45675, 0.25)
    chepito:setrot(0, 180, 0)
    SetActorReflection(chepito.hActor, 90)
    while 1 do
        WalkActorForward(chepito.hActor)
        break_here()
    end
end
mt.bye_chepito = function() -- line 33
    mt.chepito_here = FALSE
    mt.chepito_obj:make_untouchable()
    mt.fountain:make_touchable()
    START_CUT_SCENE("no head")
    set_override(mt.bye_chepito_override)
    manny:say_line("/mtma001/")
    manny:hand_gesture()
    start_script(manny.head_follow_mesh, manny, chepito, 7)
    wait_for_message()
    chepito:say_line("/mtch002/")
    sleep_for(1000)
    mt:current_setup(mt_diats)
    start_script(manny.walk_and_face, manny, -0.491129, 0.488721, 0.25, 0, 319.714, 0)
    wait_for_message()
    chepito:say_line("/mtch003/")
    wait_for_message()
    manny:say_line("/mtma004/")
    manny:wait_for_actor()
    manny:shrug_gesture()
    wait_for_message()
    chepito:say_line("/mtch005/")
    wait_for_message()
    chepito:say_line("/mtch006/")
    wait_for_message()
    stop_script(mt.march_chepito)
    box_on("font_fill")
    start_script(chepito.walk_and_face, chepito, -0.0607934, 1.24531, 0.265, 0, 271.449, 0)
    chepito:say_line("/mtch007/")
    chepito:wait_for_actor()
    start_sfx("mtChepCl.wav", nil, 70)
    fade_sfx("mtChepWk.IMU", 500, 0)
    chepito:push_costume("ct_step_out.cos")
    chepito:run_chore(0, "ct_step_out.cos")
    chepito:pop_costume()
    chepito:setpos(-0.00179346, 0.773308, 0.255)
    chepito:setrot(0, 185.921, 0)
    chepito.costume_marker_handler = chepito.mt_footstep_handler
    box_off("font_fill")
    chepito:follow_boxes()
    start_script(chepito.walk_and_face, chepito, -0.725158, 1.07797, 0.25, 0, 225.501, 0)
    chepito:wait_for_message()
    manny:say_line("/mtma008/")
    wait_for_message()
    chepito:say_line("/mtch009/")
    wait_for_message()
    chepito:wait_for_actor()
    chepito:play_chore(chepito_2conv, "chepito.cos")
    chepito:say_line("/mtch010/")
    sleep_for(2000)
    chepito:run_chore(chepito_2base, "chepito.cos")
    chepito:stop_chore(chepito_2base, "chepito.cos")
    start_script(chepito.walk_and_face, chepito, -4.17773, 4.63688, 0, 0, 36.6931, 0)
    manny:turn_toward_entity(mt.tunnel_trigger)
    chepito:wait_for_message()
    sleep_for(1000)
    start_script(mt.chepito_sing)
    chepito:wait_for_actor()
    system_prefs:set_voice_effect("Basic Reverb")
    mt:current_setup(mt_gltcu)
    start_script(mt.chepito_down_tunnel)
    sleep_for(4000)
    stop_script(mt.chepito_sing)
    repeat
        break_here()
    until chepito.fade_cue
    chepito:wait_for_message()
    END_CUT_SCENE()
    system_prefs:set_voice_effect("OFF")
    mt.mural:stop_chore(0)
    mt.mural:play_chore(1)
    mt:current_setup(mt_diats)
    manny:setrot(0, 44.0814, 0)
    stop_script(manny.head_follow_mesh)
    manny:head_look_at(nil)
    stop_script(mt.chepito_down_tunnel)
    chepito:put_in_set(nil)
    music_state:update(system.currentSet)
end
mt.bye_chepito_override = function() -- line 119
    kill_override()
    mt.mural:stop_chore(0)
    mt.mural:play_chore(1)
    system_prefs:set_voice_effect("OFF")
    mt:current_setup(mt_diats)
    stop_script(manny.head_follow_mesh)
    manny:head_look_at(nil)
    manny:setpos(-0.491129, 0.488721, 0.25)
    manny:setrot(0, 44.0814, 0)
    stop_script(mt.march_chepito)
    box_off("font_fill")
    stop_script(mt.chepito_down_tunnel)
    chepito:put_in_set(nil)
    stop_script(mt.chepito_sing)
    mt:force_camerachange()
end
mt.chepito_down_tunnel = function() -- line 137
    chepito:default()
    chepito:put_in_set(mt)
    chepito:ignore_boxes()
    chepito:setpos(-4.75543, 5.55237, 0)
    chepito:setrot(0, 33.6737, 0)
    chepito:set_turn_rate(15)
    repeat
        TurnActorTo(chepito.hActor, -6.47461, 5.98099, 0)
        WalkActorForward(chepito.hActor)
        break_here()
    until proximity(chepito.hActor, -6.47461, 5.98099, 0) < 0.1
    while 1 do
        TurnActorTo(chepito.hActor, -11.7088, 6.41531, 0)
        WalkActorForward(chepito.hActor)
        break_here()
    end
end
chepito.mt_footstep_handler = function(arg1, arg2) -- line 159
    if arg2 == Actor.MARKER_LEFT_WALK then
        arg1:play_sound_at("fsChpl1.WAV", 0, 60)
    else
        arg1:play_sound_at("fsChpr1.WAV", 0, 60)
    end
end
mt.set_up_actors = function() -- line 167
    box_off("font_fill")
    if mt.chepito_here then
        chepito:default()
        chepito:set_walk_rate(0.35)
        chepito:follow_boxes()
        chepito:put_in_set(mt)
        chepito:setpos(-0.145178, 1.63608, 0.2)
        chepito:setrot(0, 510.423, 0)
        mt.mural:play_chore_looping(0)
        LoadCostume("ct_step_out.cos")
        start_script(mt.march_chepito)
        mt.chepito_obj:make_touchable()
        start_sfx("mtChepWk.IMU", IM_HIGH_PRIORITY, mt.far_walk_vol)
    else
        chepito:put_in_set(nil)
        mt.chepito_obj:make_untouchable()
        mt.mural:play_chore(1)
    end
end
mt.update_music_state = function(arg1) -- line 193
    if mt.chepito_here then
        return stateMT_CHEPITO
    else
        return stateMT
    end
end
mt.enter = function(arg1) -- line 202
    NewObjectState(mt_diaha, OBJSTATE_UNDERLAY, "mt_0_water.bm")
    NewObjectState(mt_diats, OBJSTATE_UNDERLAY, "mt_1_water.bm")
    mt.mural:set_object_state("mt_water.cos")
    box_off("font_fill")
    mt.set_up_actors()
    SetShadowColor(20, 20, 20)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow10")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow20")
    AddShadowPlane(manny.hActor, "shadow20")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow41")
    AddShadowPlane(manny.hActor, "shadow41")
    AddShadowPlane(manny.hActor, "shadow42")
    SetActiveShadow(chepito.hActor, 0)
    SetActorShadowPoint(chepito.hActor, 0, 0, 6000)
    SetActorShadowPlane(chepito.hActor, "shadow1")
    AddShadowPlane(chepito.hActor, "shadow1")
    AddShadowPlane(chepito.hActor, "shadow2")
    AddShadowPlane(chepito.hActor, "shadow3")
    AddShadowPlane(chepito.hActor, "shadow10")
    SetActiveShadow(chepito.hActor, 1)
    SetActorShadowPoint(chepito.hActor, 0, 0, 6000)
    SetActorShadowPlane(chepito.hActor, "shadow20")
    AddShadowPlane(chepito.hActor, "shadow20")
    SetActiveShadow(chepito.hActor, 2)
    SetActorShadowPoint(chepito.hActor, 0, 0, 6000)
    SetActorShadowPlane(chepito.hActor, "shadow41")
    AddShadowPlane(chepito.hActor, "shadow41")
    AddShadowPlane(chepito.hActor, "shadow42")
end
mt.exit = function(arg1) -- line 251
    stop_script(mt.march_chepito)
    chepito:free()
    fade_sfx("mtChepWk.IMU")
    KillActorShadows(manny.hActor)
    KillActorShadows(chepito.hActor)
end
mt.camerachange = function(arg1, arg2, arg3) -- line 260
    if mt.chepito_here then
        if arg3 == mt_gltrv then
            set_vol("mtChepWk.IMU", mt.far_walk_vol)
        elseif arg3 == mt_gltcu then
            set_vol("mtChepWk.IMU", mt.med_walk_vol)
        elseif arg3 == mt_diaha then
            set_vol("mtChepWk.IMU", mt.med_walk_vol)
        elseif arg3 == mt_diats then
            set_vol("mtChepWk.IMU", mt.near_walk_vol)
        end
    end
end
mt.chepito_obj = Object:create(mt, "/mttx011/Chepito", 0.033523701, 1.4510601, 0.57999998, { range = 1 })
mt.chepito_obj.use_pnt_x = -0.50647599
mt.chepito_obj.use_pnt_y = 0.98106098
mt.chepito_obj.use_pnt_z = 0.25
mt.chepito_obj.use_rot_x = 0
mt.chepito_obj.use_rot_y = 640.36401
mt.chepito_obj.use_rot_z = 0
mt.chepito_obj.lookAt = function(arg1) -- line 290
    manny:say_line("/mtma012/")
end
mt.chepito_obj.pickUp = function(arg1) -- line 294
    manny:say_line("/mtma013/")
end
mt.chepito_obj.use = function(arg1) -- line 298
    start_script(mt.bye_chepito)
end
mt.chepito_obj.use_note = function(arg1) -- line 302
    START_CUT_SCENE()
    manny:say_line("/mtma014/")
    wait_for_message()
    chepito:say_line("/mtch015/")
    wait_for_message()
    tg.note:lookAt()
    wait_for_message()
    chepito:say_line("/mtch016/")
    wait_for_message()
    chepito:say_line("/mtch017/")
    END_CUT_SCENE()
end
mt.fountain = Object:create(mt, "/mttx032/fountain", 0.033523701, 1.4510601, 0.57999998, { range = 0.89999998 })
mt.fountain.use_pnt_x = -0.50647599
mt.fountain.use_pnt_y = 0.98106098
mt.fountain.use_pnt_z = 0.25
mt.fountain.use_rot_x = 0
mt.fountain.use_rot_y = 640.36401
mt.fountain.use_rot_z = 0
mt.fountain:make_untouchable()
mt.fountain.lookAt = function(arg1) -- line 328
    soft_script()
    manny:say_line("/mtma033/")
    wait_for_message()
    manny:say_line("/mtma034/")
end
mt.fountain.use = function(arg1) -- line 335
    soft_script()
    manny:say_line("/mtma035/")
    wait_for_message()
    manny:say_line("/mtma036/")
end
mt.mural = Object:create(mt, "/mttx018/mural", -1.19041, 8.97614, 1.33, { range = 4.6900001 })
mt.mural.use_pnt_x = -1.47041
mt.mural.use_pnt_y = 4.7161398
mt.mural.use_pnt_z = 0
mt.mural.use_rot_x = 0
mt.mural.use_rot_y = 707.99902
mt.mural.use_rot_z = 0
mt.mural.lookAt = function(arg1) -- line 351
    manny:say_line("/mtma019/")
    wait_for_message()
    manny:say_line("/mtma020/")
end
mt.mural.pickUp = function(arg1) -- line 357
    manny:say_line("/mtma021/")
end
mt.mural.use = function(arg1) -- line 361
    manny:say_line("/mtma022/")
end
mt.tunnel_trigger = Object:create(mt, "/mttx023/tunnel", -10.8212, 6.8014002, 0.97399998, { range = 4.5900002 })
mt.tunnel_trigger.use_pnt_x = -8.2421904
mt.tunnel_trigger.use_pnt_y = 6.7714
mt.tunnel_trigger.use_pnt_z = 0
mt.tunnel_trigger.use_rot_x = 0
mt.tunnel_trigger.use_rot_y = -278.73099
mt.tunnel_trigger.use_rot_z = 0
mt.tunnel_trigger.lookAt = function(arg1) -- line 375
    manny:say_line("/mtma024/")
    wait_for_message()
    manny:say_line("/mtma025/")
end
mt.tunnel_trigger.use = function(arg1) -- line 381
    if not arg1.tried then
        arg1.tried = TRUE
        START_CUT_SCENE()
        manny:say_line("/mtma026/")
        wait_for_message()
        manny:say_line("/mtma027/")
        wait_for_message()
        manny:say_line("/mtma028/")
        wait_for_message()
        END_CUT_SCENE()
    end
    manny:say_line("/mtma029/")
end
mt.tunnel_trigger.walkOut = mt.tunnel_trigger.use
mt.tg_door = Object:create(mt, "/mttx030/doorway", 4.1970701, 4.1256499, 0.46000001, { range = 0.60000002 })
mt.tg_door.use_pnt_x = 3.84707
mt.tg_door.use_pnt_y = 4.1256499
mt.tg_door.use_pnt_z = 0
mt.tg_door.use_rot_x = 0
mt.tg_door.use_rot_y = 631.23297
mt.tg_door.use_rot_z = 0
mt.tg_door.out_pnt_x = 4.0831399
mt.tg_door.out_pnt_y = 4.3487802
mt.tg_door.out_pnt_z = 0
mt.tg_door.out_rot_x = 0
mt.tg_door.out_rot_y = -78.290298
mt.tg_door.out_rot_z = 0
mt.tg_door.walkOut = function(arg1) -- line 417
    tg:come_out_door(tg.mt_door)
end
mt.tg_door.lookAt = function(arg1) -- line 421
    manny:say_line("/mtma031/")
end
mt.chepito_sing = function(arg1) -- line 426
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

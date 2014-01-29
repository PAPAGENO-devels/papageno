CheckFirstTime("xb.lua")
xb = Set:create("xb.set", "extend o bridge", { xb_docws = 0, xb_overhead = 1, xb_newcu = 2, xb_newws = 3, xb_trkws = 4 })
dofile("xbridge.lua")
dofile("mc_bridge.lua")
harbor_ambience_list = { "EkoBell1.wav", "EkoBell2.wav", "EkoBell3.wav", "EkoHorn1.wav", "EkoHorn2.wav" }
harbor_ambience_parm_list = { min_delay = 12000, max_delay = 24000, min_volume = 80, max_volume = 110 }
xb.set_up_actors = function(arg1) -- line 19
    local local1 = 0
    if not xbridge then
        xbridge = Actor:create()
    end
    xbridge:put_in_set(xb)
    xbridge:set_costume("xbridge.cos")
    xbridge:set_softimage_pos(286.75562, 10.0125, 113.5474)
    xbridge:setrot(0, 306.73831, 0)
    if xb.bridge.extended then
        box_on("bridge_box")
        xbridge:play_chore(xbridge_extended)
    else
        box_off("bridge_box")
        xbridge:play_chore(xbridge_retracted)
    end
    repeat
        local1 = local1 + 1
        if not table_actor[local1] then
            table_actor[local1] = Actor:create(nil, nil, nil, "table" .. local1)
        end
        table_actor[local1]:set_costume("x_spot.cos")
        table_actor[local1]:set_visibility(FALSE)
        table_actor[local1]:put_in_set(xb)
        table_actor[local1]:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(table_actor[local1].hActor, 0.2)
        if local1 == 1 then
            table_actor[local1]:free()
        elseif local1 == 2 then
            table_actor[local1]:free()
        elseif local1 == 3 then
            table_actor[local1]:setpos(28.159901, -11.87, 1.3252)
        elseif local1 == 4 then
            table_actor[local1]:setpos(28.343599, -12.3121, 1.3252)
        elseif local1 == 5 then
            table_actor[local1]:setpos(28.3428, -14.0969, 1.3252)
        elseif local1 == 6 then
            table_actor[local1]:setpos(27.8255, -14.0969, 1.3252)
        elseif local1 == 7 then
            table_actor[local1]:setpos(28.3214, -15.2278, 1.3252)
        elseif local1 == 8 then
            table_actor[local1]:setpos(28.365601, -15.8559, 1.3252)
        elseif local1 == 9 then
            table_actor[local1]:setpos(27.768, -15.8463, 1.3252)
        elseif local1 == 10 then
            table_actor[local1]:setpos(28.638901, -13.3773, 1.01983)
            SetActorCollisionScale(table_actor[local1].hActor, 0.050000001)
        elseif local1 == 11 then
            table_actor[local1]:setpos(28.671499, -12.9782, 1.01983)
            SetActorCollisionScale(table_actor[local1].hActor, 0.050000001)
        end
    until local1 == 11
end
xb.lighthouse = function(arg1) -- line 76
    while 1 do
        if xb:current_setup() == xb_trkws then
            if not find_script(cut_scene.coffrock) then
                StartMovie("sd_li.snm", TRUE, 320, 169)
            end
            while xb:current_setup() == xb_trkws do
                break_here()
            end
            StopMovie()
        end
        break_here()
    end
end
xb.pop_actors = function(arg1) -- line 91
    local local1 = { }
    while 1 do
        if xb:current_setup() == xb_newws then
            local1 = xbridge:getpos()
            xbridge:setpos(local1.x, local1.y, local1.z - 0.14)
            if in_year_four then
                local1 = glottis:getpos()
                glottis:setpos(local1.x, local1.y, local1.z - 0.14)
                local1 = meche:getpos()
                meche:setpos(local1.x, local1.y, local1.z - 0.14)
            end
            while xb:current_setup() == xb_newws do
                break_here()
            end
            local1 = xbridge:getpos()
            xbridge:setpos(local1.x, local1.y, local1.z + 0.14)
            if in_year_four then
                local1 = glottis:getpos()
                glottis:setpos(local1.x, local1.y, local1.z + 0.14)
                local1 = meche:getpos()
                meche:setpos(local1.x, local1.y, local1.z + 0.14)
            end
        else
            break_here()
        end
    end
end
xb.meche_arm_idle = function() -- line 120
    meche:set_rest_chore(nil)
    while 1 do
        meche:play_chore(meche_ruba_drop_hands)
        meche:wait_for_chore()
        sleep_for(rnd(1500, 3000))
        meche:play_chore(meche_ruba_xarms)
        meche:wait_for_chore()
        sleep_for(rnd(1500, 3000))
        break_here()
    end
end
xb.glottis_look_meche = function() -- line 134
    while 1 do
        glottis:head_look_at(meche)
        sleep_for(rnd(1500, 3000))
        glottis:head_look_at(nil)
        sleep_for(rnd(1500, 3000))
    end
end
locate = function() -- line 148
    local local1 = { }
    local local2 = { }
    local local3 = { }
    local local4 = { x = -0.01163, y = 0.77678001, z = 0 }
    local1 = glottis:getrot()
    local3 = RotateVector(local4, local1)
    local2 = glottis:getpos()
    local3.x = local3.x + local2.x
    local3.y = local3.y + local2.y
    local3.z = local3.z + local2.z
    manny:setpos(local3.x, local3.y, local3.z)
end
xb.camerachange = function(arg1, arg2, arg3) -- line 162
    if arg3 == xb_newws then
        start_sfx("blimp.imu", IM_HIGH_PRIORITY, 4)
    elseif sound_playing("blimp.imu") then
        fade_sfx("blimp.imu", 500, 0)
    end
end
xb.update_music_state = function(arg1) -- line 173
    if in_year_four then
        return stateXB_YEAR4
    else
        return stateXB
    end
end
xb.enter = function(arg1) -- line 183
    manny:set_collision_mode(COLLISION_SPHERE)
    if xb.triggered_track then
        MakeSectorActive("track_trigger", FALSE)
    end
    if in_year_four then
        meche:set_costume("meche_snow.cos")
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
        meche:set_head(5, 5, 5, 165, 28, 80)
        meche:set_walk_chore(meche_ruba_walk)
        meche:set_rest_chore(meche_ruba_hands_down_hold)
        meche:set_look_rate(200)
        meche:ignore_boxes()
        meche:put_in_set(xb)
        meche:setpos({ x = 28.2727, y = -13.8664, z = 1 })
        meche:setrot(0, 0, 0)
        meche:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(meche.hActor, 0.35)
        NewObjectState(xb_docws, OBJSTATE_UNDERLAY, "xb_0_open.bm")
        jello = NewObjectState(xb_docws, OBJSTATE_UNDERLAY, "xb_0_jello.bm")
        xb.jb_door:set_object_state("xb_jb.cos")
        xb.jb_door:play_chore(0)
        xb.jello:set_object_state("xb_jello.cos")
        SendObjectToFront(jello)
        if jb.frozen then
            xb.jello:play_chore(1)
        elseif jb.poured then
            xb.jello:play_chore(0)
        else
            xb.jello:play_chore(2)
        end
        box_on("jb_door")
        xb.jb_door.walkOut = xb.jb_door.year_four_walkOut
        xb.meche_obj:make_touchable()
        xb.glottis_obj:make_touchable()
        xb.bridge.extended = FALSE
        xb.glottis_obj.parent = jb.glottis_obj
        glottis:default()
        glottis:put_in_set(xb)
        glottis:setpos(28.7635, -13.2831, 1)
        if glottis.nauseated and not jb.poured then
            glottis:setrot(0, 180, 0)
            start_sfx("glNausea.WAV")
            xb.glottis_obj.obj_x = 28.8643
            xb.glottis_obj.obj_y = -13.7211
            xb.glottis_obj.obj_z = 1.83774
            xb.glottis_obj.interest_actor:setpos({ x = 28.8643, y = -13.7211, z = 1.83774 })
            xb.glottis_obj:make_touchable()
            xb.glottis_obj.interest_actor:put_in_set(xb)
        else
            glottis:setrot(0, 90, 0)
            xb.glottis_obj.obj_x = 28.029
            xb.glottis_obj.obj_y = -13.0451
            xb.glottis_obj.obj_z = 1.66
            xb.glottis_obj.interest_actor:setpos(28.029, -13.0451, 1.66)
        end
        glottis:play_chore_looping(glottis_flip_ears)
        glottis:set_head(3, 4, 4, 165, 28, 80)
        glottis:set_mumble_chore(glottis_mumble)
        glottis:set_talk_chore(1, glottis_stop_talk)
        glottis:set_talk_chore(2, glottis_a)
        glottis:set_talk_chore(3, glottis_c)
        glottis:set_talk_chore(4, glottis_e)
        glottis:set_talk_chore(5, glottis_f)
        glottis:set_talk_chore(6, glottis_l)
        glottis:set_talk_chore(7, glottis_m)
        glottis:set_talk_chore(8, glottis_o)
        glottis:set_talk_chore(9, glottis_t)
        glottis:set_talk_chore(10, glottis_u)
        glottis:push_costume("gl_fastwalk.cos")
        glottis:head_look_at(nil)
        glottis:set_walk_chore(0, "gl_sailor_fastwalk.cos")
        glottis:set_walk_rate(0.5)
        glottis:set_turn_rate(0.2)
        if lm.bottle.owner == manny then
            LoadCostume("msb_shooter.cos")
            LoadCostume("gl_shooter.cos")
            LoadCostume("gl_shake.cos")
        end
        glottis:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(glottis.hActor, 0.5)
        SetActorCollisionScale(manny.hActor, 0.35)
        if glottis.nauseated and not jb.poured then
            start_script(jb.glottis_nauseated_reminder)
        end
        if not find_script(cut_scene.coffrock) then
            start_script(xb.meche_arm_idle)
            start_script(xb.glottis_look_meche)
        end
    else
        xb.meche_obj:make_untouchable()
        xb.glottis_obj:make_untouchable()
        SetActorCollisionScale(manny.hActor, 1)
        box_off("jb_door")
    end
    LoadCostume("mc_bridge.cos")
    xb:set_up_actors()
    start_script(foghorn_sfx)
    start_script(xb.lighthouse)
    start_script(xb.pop_actors)
    xb:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    if xb:current_setup() == xb_newws then
        start_sfx("blimp.imu", IM_HIGH_PRIORITY, 4)
    end
end
xb.exit = function(arg1) -- line 317
    stop_script(foghorn_sfx)
    local local1 = 0
    repeat
        local1 = local1 + 1
        table_actor[local1]:free()
    until local1 == 11
    stop_script(xb.lighthouse)
    stop_script(xb.pop_actors)
    glottis:free()
    meche:free()
    manny:set_collision_mode(COLLISION_OFF)
    meche:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    if glottis.nauseated and not jb.poured then
        stop_script(jb.glottis_nauseated_reminder)
    end
    stop_sound("glNausea.WAV")
    if in_year_four then
        stop_script(xb.meche_arm_idle)
        stop_script(xb.glottis_look_meche)
    end
    stop_sound("blimp.imu")
    xbridge:free()
end
xb.jello = Object:create(xb, "jello", 0, 0, 0, { range = 0 })
xb.gate = Object:create(xb, "/xbtx001/gate", 27.656099, -16.4168, 1.5, { range = 0.69999999 })
xb.gate.use_pnt_x = 27.9979
xb.gate.use_pnt_y = -16.420099
xb.gate.use_pnt_z = 1
xb.gate.use_rot_x = 0
xb.gate.use_rot_y = 107.867
xb.gate.use_rot_z = 0
xb.gate.lookAt = function(arg1) -- line 360
    if not in_year_four then
        START_CUT_SCENE()
        manny:say_line("/xbma002/")
        wait_for_message()
        manny:say_line("/xbma003/")
        END_CUT_SCENE()
    else
        manny:say_line("/xbma009/")
    end
end
xb.gate.pickUp = xb.gate.lookAt
xb.gate.use = function(arg1) -- line 374
    START_CUT_SCENE()
    manny:say_line("/xbma004/")
    wait_for_message()
    END_CUT_SCENE()
    arg1:lookAt()
end
xb.gate.use_key = function(arg1) -- line 382
    manny:say_line("/xbma005/")
end
xb.glottis_obj = Object:create(xb, "/xbtx010/Glottis", 28.028999, -13.0451, 1.66, { range = 1.5 })
xb.glottis_obj.use_pnt_x = 28.149
xb.glottis_obj.use_pnt_y = -13.3851
xb.glottis_obj.use_pnt_z = 1
xb.glottis_obj.use_rot_x = 0
xb.glottis_obj.use_rot_y = -349.40799
xb.glottis_obj.use_rot_z = 0
xb.meche_obj = Object:create(xb, "/xbtx011/Meche", 28.184, -13.722, 1.48, { range = 0.60000002 })
xb.meche_obj.use_pnt_x = 28.214001
xb.meche_obj.use_pnt_y = -13.442
xb.meche_obj.use_pnt_z = 1
xb.meche_obj.use_rot_x = 0
xb.meche_obj.use_rot_y = -171.696
xb.meche_obj.use_rot_z = 0
xb.meche_obj.lookAt = function(arg1) -- line 404
    manny:say_line("/xbma012/")
end
xb.meche_obj.pickUp = function(arg1) -- line 408
    system.default_response("not now")
end
xb.meche_obj.use = function(arg1) -- line 412
    soft_script()
    if not xb.meche_obj.talked_dom then
        xb.meche_obj.talked_dom = TRUE
        START_CUT_SCENE()
        manny:say_line("/xbma013/")
        wait_for_message()
        meche:say_line("/xbmc014/")
        wait_for_message()
        manny:say_line("/xbma015/")
        END_CUT_SCENE()
    else
        soft_script()
        manny:say_line("/xbma016/")
        wait_for_message()
        meche:say_line("/xbmc017/")
    end
end
xb.bridge = Object:create(xb, "/xbtx025/extendo bridge", 28.829, -11.1978, 1.226, { range = 1.6 })
xb.bridge.use_pnt_x = 28.6756
xb.bridge.use_pnt_y = -11.3651
xb.bridge.use_pnt_z = 1
xb.bridge.use_rot_x = 0
xb.bridge.use_rot_y = -53.2281
xb.bridge.use_rot_z = 0
xb.bridge.extended = FALSE
xb.bridge.lookAt = function(arg1) -- line 443
    soft_script()
    manny:say_line("/xbma018/")
    if in_year_four then
        wait_for_message()
        manny:say_line("/xbma019/")
    end
end
xb.bridge.use = function(arg1) -- line 452
    if arg1.extended then
        arg1:retract()
    else
        arg1:extend()
    end
end
xb.bridge.extend = function(arg1) -- line 460
    if manny:walkto(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        if in_year_four then
            arg1.extended = FALSE
            manny:push_costume("msb_bridge.cos")
            break_here()
            manny:play_chore(mc_bridge_pull_level, "msb_bridge.cos")
            xbridge:run_chore(xbridge_pull_and_return, "xbridge.cos")
            start_sfx("xbGrind.wav")
            sleep_for(2500)
            manny:pop_costume()
            start_script(manny.backup, manny, 1000)
            manny:say_line("/xbma020/")
        else
            manny:push_costume("mc_bridge.cos")
            break_here()
            manny:play_chore(mc_bridge_pull_level, "mc_bridge.cos")
            arg1.extended = TRUE
            xbridge:run_chore(xbridge_lever_pull, "xbridge.cos")
            manny:pop_costume()
            start_script(manny.backup, manny, 1000)
            xbridge:run_chore(xbridge_extend, "xbridge.cos")
            box_on("bridge_box")
        end
        END_CUT_SCENE()
    end
end
xb.bridge.retract = function(arg1) -- line 490
    if manny:walkto_object(arg1) then
        arg1.extended = FALSE
        START_CUT_SCENE()
        manny:setrot(0, 259.565, 0, TRUE)
        manny:wait_for_actor()
        manny:run_chore(mc_reach_med, "mc.cos")
        start_script(manny.walk_and_face, manny, 28.7311, -11.8849, 1, 0, 197.307, 0)
        xbridge:run_chore(xbridge_retract, "xbridge.cos")
        box_off("bridge_box")
        END_CUT_SCENE()
    end
end
xb.track = Object:create(xb, "", 36.164501, -13.1014, 2.87784, { range = 10 })
xb.track.use_pnt_x = 37.019501
xb.track.use_pnt_y = -13.7274
xb.track.use_pnt_z = 1.54784
xb.track.use_rot_x = 0
xb.track.use_rot_y = 9.6220303
xb.track.use_rot_z = 0
xb.track:make_untouchable()
xb.track_trigger = xb.track
xb.track.walkOut = function(arg1) -- line 517
    xb.triggered_track = TRUE
    MakeSectorActive("track_trigger", FALSE)
    if not in_year_four then
        START_CUT_SCENE()
        xb.track:make_touchable()
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:head_look_at_point(36.1645, -13.1014, 2.87784)
        manny:say_line("/sdma003/")
        manny:wait_for_message()
        manny:say_line("/sdma004/")
        manny:wait_for_message()
        manny:head_look_at(nil)
        xb.track:make_untouchable()
        END_CUT_SCENE()
    end
end
xb.hb_door = Object:create(xb, "/xbtx007/bridge", 30.6709, -17.761999, 2.0699999, { range = 0 })
xb.hb_door.use_pnt_x = 30.6035
xb.hb_door.use_pnt_y = -17.2269
xb.hb_door.use_pnt_z = 1.607
xb.hb_door.use_rot_x = 0
xb.hb_door.use_rot_y = 192.12801
xb.hb_door.use_rot_z = 0
xb.hb_door.out_pnt_x = 30.683599
xb.hb_door.out_pnt_y = -17.6
xb.hb_door.out_pnt_z = 1.607
xb.hb_door.out_rot_x = 0
xb.hb_door.out_rot_y = 192.12801
xb.hb_door.out_rot_z = 0
xb.hb_box = xb.hb_door
xb.hb_door:make_untouchable()
xb.hb_door.walkOut = function(arg1) -- line 561
    hb:come_out_door(hb.xb_door)
end
xb.tx_door = Object:create(xb, "/xbtx026/bridge", 28.6411, -9.2664099, 1.47, { range = 0 })
xb.tx_door.use_pnt_x = 28.6411
xb.tx_door.use_pnt_y = -10.132
xb.tx_door.use_pnt_z = 1
xb.tx_door.use_rot_x = 0
xb.tx_door.use_rot_y = -360.832
xb.tx_door.use_rot_z = 0
xb.tx_door.out_pnt_x = 28.654301
xb.tx_door.out_pnt_y = -9.2025099
xb.tx_door.out_pnt_z = 1
xb.tx_door.out_rot_x = 0
xb.tx_door.out_rot_y = -360.832
xb.tx_door.out_rot_z = 0
xb.tx_box = xb.tx_door
xb.tx_door:make_untouchable()
xb.tx_door.walkOut = function(arg1) -- line 586
    tx:come_out_door(tx.xb_door)
end
xb.jb_door = Object:create(xb, "/xbtx021/doors", 27.549999, -13.1334, 1.61, { range = 1 })
xb.jb_door.use_pnt_x = 27.8496
xb.jb_door.use_pnt_y = -13.132
xb.jb_door.use_pnt_z = 1
xb.jb_door.use_rot_x = 0
xb.jb_door.use_rot_y = 77.278099
xb.jb_door.use_rot_z = 0
xb.jb_door.lookAt = function(arg1) -- line 599
    if in_year_four then
        manny:say_line("/xbma022/")
    else
        manny:say_line("/xbma023/")
    end
end
xb.jb_door.use = function(arg1) -- line 607
    manny:say_line("/xbma024/")
end
xb.jb_door.year_four_walkOut = function(arg1) -- line 611
    jb:come_out_door(jb.xb_door)
end
xb.se_door = Object:create(xb, "door", 40.260502, -12.8684, 1.01, { range = 0 })
xb.se_box = xb.se_door
xb.se_door.use_pnt_x = 39.785599
xb.se_door.use_pnt_y = -12.877
xb.se_door.use_pnt_z = 1.01
xb.se_door.use_rot_x = 0
xb.se_door.use_rot_y = 261.487
xb.se_door.use_rot_z = 0
xb.se_door.out_pnt_x = 41.291901
xb.se_door.out_pnt_y = -12.85
xb.se_door.out_pnt_z = 0.68217498
xb.se_door.out_rot_x = 0
xb.se_door.out_rot_y = -89.106697
xb.se_door.out_rot_z = 0
xb.se_door.touchable = FALSE
xb.se_door.walkOut = function(arg1) -- line 635
    START_CUT_SCENE()
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    END_CUT_SCENE()
    se:come_out_door(se.sd_door)
end
xb.sd_start = Object:create(xb, "", 38.625, -13.65, 1, { range = 0 })
xb.sd_start.use_pnt_x = 38.625
xb.sd_start.use_pnt_y = -13.65
xb.sd_start.use_pnt_z = 1
xb.sd_start.use_rot_x = 0
xb.sd_start.use_rot_y = -431.17499
xb.sd_start.use_rot_z = 0
xb.sd_start:make_untouchable()
xb.sd_exit = Object:create(xb, "", 38.919201, -13.5496, 1, { range = 0 })
xb.sd_exit.use_pnt_x = 38.919201
xb.sd_exit.use_pnt_y = -13.5496
xb.sd_exit.use_pnt_z = 1
xb.sd_exit.use_rot_x = 0
xb.sd_exit.use_rot_y = -431.17499
xb.sd_exit.use_rot_z = 0
xb.sd_exit:make_untouchable()
xb.sd_ws1 = xb.sd_exit
xb.sd_ws2 = xb.sd_exit
xb.sd_ws3 = xb.sd_exit
xb.sd_exit.walkOut = function(arg1) -- line 672
    START_CUT_SCENE()
    manny:setpos(xb.ws_start.use_pnt_x, xb.ws_start.use_pnt_y, xb.ws_start.use_pnt_z)
    manny:setrot(0, xb.ws_exit.use_rot_y + 180, 0)
    xb:current_setup(xb_newws)
    manny:walkto(xb.ws_exit.use_pnt_x, xb.ws_exit.use_pnt_y, xb.ws_exit.use_pnt_z)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
xb.ws_start = Object:create(xb, "", 39.849998, -13.3752, 1.8200001, { range = 0 })
xb.ws_start.use_pnt_x = 39.849998
xb.ws_start.use_pnt_y = -13.3752
xb.ws_start.use_pnt_z = 1.8200001
xb.ws_start.use_rot_x = 0
xb.ws_start.use_rot_y = -629.64801
xb.ws_start.use_rot_z = 0
xb.ws_start:make_untouchable()
xb.ws_exit = Object:create(xb, "", 39.365501, -13.3811, 1.77341, { range = 0 })
xb.ws_exit.use_pnt_x = 39.365501
xb.ws_exit.use_pnt_y = -13.3811
xb.ws_exit.use_pnt_z = 1.77341
xb.ws_exit.use_rot_x = 0
xb.ws_exit.use_rot_y = -629.64801
xb.ws_exit.use_rot_z = 0
xb.ws_exit:make_untouchable()
xb.ws_sd_box = xb.ws_exit
xb.ws_exit.walkOut = function(arg1) -- line 703
    START_CUT_SCENE()
    manny:setpos(xb.sd_start.use_pnt_x, xb.sd_start.use_pnt_y, xb.sd_start.use_pnt_z)
    manny:setrot(0, xb.sd_exit.use_rot_y + 180, 0)
    xb:current_setup(xb_trkws)
    manny:walkto(xb.sd_exit.use_pnt_x, xb.sd_exit.use_pnt_y, xb.sd_exit.use_pnt_z)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
xb.ws_far_start = Object:create(xb, "", 34.650002, -13.8858, 1.3200001, { range = 0 })
xb.ws_far_start.use_pnt_x = 34.650002
xb.ws_far_start.use_pnt_y = -13.8858
xb.ws_far_start.use_pnt_z = 1.3200001
xb.ws_far_start.use_rot_x = 0
xb.ws_far_start.use_rot_y = -453.60501
xb.ws_far_start.use_rot_z = 0
xb.ws_far_start:make_untouchable()
xb.ws_far_exit = Object:create(xb, "", 34.9631, -13.9057, 1.3501101, { range = 0 })
xb.ws_far_exit.use_pnt_x = 34.9631
xb.ws_far_exit.use_pnt_y = -13.9057
xb.ws_far_exit.use_pnt_z = 1.3501101
xb.ws_far_exit.use_rot_x = 0
xb.ws_far_exit.use_rot_y = -453.60501
xb.ws_far_exit.use_rot_z = 0
xb.ws_far_exit:make_untouchable()
xb.ws_ns_box = xb.ws_far_exit
xb.ws_far_exit.walkOut = function(arg1) -- line 735
    START_CUT_SCENE()
    manny:setpos(xb.ns_start.use_pnt_x, xb.ns_start.use_pnt_y, xb.ns_start.use_pnt_z)
    manny:setrot(0, xb.ns_start.use_rot_y + 180, 0)
    xb:current_setup(xb_docws)
    manny:walkto(xb.ns_exit.use_pnt_x, xb.ns_exit.use_pnt_y, xb.ns_exit.use_pnt_z)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
xb.ns_start = Object:create(xb, "", 31.127199, -13.2817, 1, { range = 0 })
xb.ns_start.use_pnt_x = 31.127199
xb.ns_start.use_pnt_y = -13.2817
xb.ns_start.use_pnt_z = 1
xb.ns_start.use_rot_x = 0
xb.ns_start.use_rot_y = -285.87601
xb.ns_start.use_rot_z = 0
xb.ns_start:make_untouchable()
xb.ns_exit = Object:create(xb, "", 31.0802, -13.8597, 1, { range = 0 })
xb.ns_exit.use_pnt_x = 31.0802
xb.ns_exit.use_pnt_y = -13.8597
xb.ns_exit.use_pnt_z = 1
xb.ns_exit.use_rot_x = 0
xb.ns_exit.use_rot_y = -252.892
xb.ns_exit.use_rot_z = 0
xb.ns_exit:make_untouchable()
xb.ns_ws_box = xb.ns_exit
xb.ns_exit.walkOut = function(arg1) -- line 767
    START_CUT_SCENE()
    manny:setpos(xb.ws_far_start.use_pnt_x, xb.ws_far_start.use_pnt_y, xb.ws_far_start.use_pnt_z)
    manny:setrot(0, xb.ws_far_start.use_rot_y + 180, 0)
    xb:current_setup(xb_newws)
    manny:walkto(xb.ws_far_exit.use_pnt_x, xb.ws_far_exit.use_pnt_y, xb.ws_far_exit.use_pnt_z)
    manny:wait_for_actor()
    END_CUT_SCENE()
end

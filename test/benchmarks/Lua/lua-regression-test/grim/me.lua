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

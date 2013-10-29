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

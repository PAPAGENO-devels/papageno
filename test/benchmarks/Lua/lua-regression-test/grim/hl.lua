CheckFirstTime("hl.lua")
dofile("raoul_bored.lua")
dofile("nick_idles.lua")
dofile("gl_gamble.lua")
hl = Set:create("hl.set", "high roller lounge", { hl_dorrv = 0, hl_dorrv2 = 0, hl_elews = 1, hl_elews2 = 1, hl_glot = 2, hl_ovrhd = 3, hl_nikcu = 4 })
hl.raoul_idle_in_view = FALSE
hl.talking_to_nick = FALSE
hl.nick_leaves = function() -- line 23
    hl.nick_gone = TRUE
    hl.virago_obj:make_untouchable()
    START_CUT_SCENE()
    virago:wait_for_chore(nick_idles_tap_loop)
    virago:stop_chore(nick_idles_tap_loop)
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_stnd_walk)
    virago:wait_for_chore()
    virago:set_costume("nick_walk.cos")
    virago:set_walk_chore(0, "nick_walk.cos")
    virago:setpos(2.41821, -2.65785, 0)
    virago:setrot(0, -20, 0)
    virago:follow_boxes()
    hl:current_setup(0)
    MakeSectorActive("nick_walk", FALSE)
    END_CUT_SCENE()
    virago:walkto(1.26668, 2.64996, 0)
    while virago:is_moving() and hl:current_setup() == hl_dorrv do
        break_here()
    end
    virago:free()
    MakeSectorActive("nick_walk", TRUE)
end
hl.talk_about_terry = function(arg1) -- line 49
    START_CUT_SCENE()
    manny:say_line("/hlma094/")
    manny:wait_for_message()
    if manny.is_holding then
        put_away_held_item()
    end
    END_CUT_SCENE()
    start_script(cut_scene.puzl39, cut_scene)
end
hl.blackmail_virago = function(arg1) -- line 60
    hl.virago_blackmailed = TRUE
    START_CUT_SCENE()
    manny:say_line("/hlma095/")
    if not manny.is_holding then
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = tb.blackmail_photo
        close_inventory()
    end
    manny:play_chore(mc_use_obj, manny.base_costume)
    virago:stop_chore(nick_idles_pprwrk_base)
    virago:play_chore(nick_idles_lkma)
    sleep_for(1000)
    wait_for_message()
    manny:wait_for_chore(mc_use_obj, manny.base_costume)
    manny:say_line("/hlma096/")
    manny:wait_for_message()
    manny:clear_hands()
    shrinkBoxesEnabled = TRUE
    virago:say_line("/hlvi097/")
    virago:wait_for_message()
    END_CUT_SCENE()
    if dd.terry_arrested then
        hl.talk_about_terry()
        return TRUE
    else
        START_CUT_SCENE()
        manny:say_line("/hlma098/")
        manny:wait_for_message()
        manny:say_line("/hlma099/")
        manny:wait_for_message()
        END_CUT_SCENE()
    end
    virago:wait_for_message()
    virago:stop_chore(nick_idles_lkma)
    virago:play_chore(nick_idles_lkma_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_lkma_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(hl_dorrv)
end
hl.virago_idles = function() -- line 104
    local local1
    local local2
    if hl.current_setup == hl_nikcu then
        hl:current_setup(hl_dorrv)
    end
    virago.down = TRUE
    virago.stop_idle = FALSE
    while not virago.stop_idle do
        local1 = rndint(2)
        virago:stop_chore(nick_idles_pprwrk_base)
        if local1 == 0 then
            virago:play_chore(nick_idles_pprwrk_smoke)
            virago:wait_for_chore()
            virago:stop_chore(nick_idles_pprwrk_smoke)
            virago:play_chore(nick_idles_pprwrk_2smk_hld2)
            virago:wait_for_chore()
            virago:play_chore(nick_idles_pprwrk_2smk_hld2)
            virago:play_chore(nick_idles_pprwrk_smk2base)
            virago:wait_for_chore()
            virago:wait_here(rndint(1, 4))
            virago:stop_chore(nick_idles_pprwrk_smk2base)
        elseif local1 == 1 then
            virago:play_chore(nick_idles_nod)
            virago:wait_for_chore()
            virago:stop_chore(nick_idles_nod)
        else
            virago:play_chore(nick_idles_lkma)
            virago:wait_for_chore()
            virago:wait_here(rndint(2))
            virago:play_chore(nick_idles_lkma_nod_lp)
            virago:wait_for_chore()
            virago:stop_chore(nick_idles_lkma_nod_lp)
            virago:play_chore(nick_idles_lkma_2pprwrk)
            virago:wait_for_chore()
            virago:stop_chore(nick_idles_lkma_2pprwrk)
        end
        virago:play_chore(nick_idles_pprwrk_base)
        virago:wait_here(rndint(3))
        virago:head_look_at(nil)
    end
end
glottis.gambles = { }
glottis.gambles["/hlgl100/"] = 0.050000001
glottis.gambles["/hlgl101/"] = 0.050000001
glottis.gambles["/hlgl102/"] = 0.050000001
glottis.gambles["/hlgl103/"] = 0.050000001
glottis.gambles["/hlgl104/"] = 0.050000001
glottis.gambles["/hlgl105/"] = 0.050000001
glottis.gambles["/hlgl106/"] = 0.050000001
glottis.gambles["/hlgl107/"] = 0.050000001
glottis.gambles["/hlgl108/"] = 0.050000001
glottis.gambles["/hlgl109/"] = 0.050000001
glottis.gambles["/hlgl110/"] = 0.050000001
glottis.gambles["/hlgl111/"] = 0.050000001
glottis.gambles["/hlgl112/"] = 0.050000001
glottis.gambles["/hlgl113/"] = 0.050000001
glottis.gambles["/hlgl114/"] = 0.025
glottis.gambles["/hlgl115/"] = 0.025
glottis.gambles["/hlgl116/"] = 0.050000001
glottis.gambles["/hlgl117/"] = 0.050000001
glottis.gambles["/hlgl118/"] = 0.025
glottis.gambles["/hlgl119/"] = 0.050000001
glottis.gambles["/hlgl120/"] = 0.025
glottis.gambles["/hlgl121/"] = 0.025
glottis.gambles["/hlgl122/"] = 0.025
glottis.gambling_volume = 100
glottis.gambling_pan = 64
hl.glottis_idle = function(arg1) -- line 185
    local local1
    local local2
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
    local2 = 7
    break_here()
    while TRUE do
        while local2 <= 15 do
            hl:check_glottis_volume(hl:current_setup())
            local1 = pick_from_weighted_table(glottis.gambles)
            if rnd(5) then
                start_script(hl.glottis_ramble, hl)
            else
                glottis:play_chore(glottis_tux_blink, "glottis_tux.cos")
            end
            if IsMessageGoing() then
                glottis:say_line(local1, { background = TRUE, volume = 10, pan = glottis.gambling_pan, skip_log = TRUE })
            else
                glottis:say_line(local1, { background = TRUE, volume = glottis.gambling_volume, pan = glottis.gambling_pan, skip_log = TRUE })
            end
            if rnd(7) and not hk.raoul_trapped then
                sleep_for(rndint(1000, 2000))
                glottis:wait_for_message()
                hl:glottis_drink()
            end
            sleep_for(3000 + 3000 * random())
            local2 = local2 + 1
        end
        local2 = 1
        if not hk.raoul_trapped then
            hl:check_glottis_volume(hl:current_setup())
            hl:glottis_look_back()
            hl:glottis_look_back_talk()
            glottis:say_line(pick_one_of({ "/hlgl123/", "/hlgl124/", "/hlgl125/", "/hlgl126/", "/hlgl127/", "/hlgl128/", "/hlgl129/", "/hlgl130/", "/hlgl131/", "/hlgl132/", "/hlgl133/", "/hlgl134/", "/hlgl135/", "/hlgl136/" }), { background = TRUE, volume = glottis.gambling_volume, pan = glottis.gambling_pan })
            glottis:wait_for_message()
            hl:glottis_stop_look_back_talk()
            hl:check_glottis_volume(hl:current_setup())
            glottis:say_line("/hlgl137/", { background = TRUE, volume = glottis.gambling_volume, pan = glottis.gambling_pan })
            glottis:wait_for_message()
            hl:glottis_stop_look_back()
            if rnd(8) then
                sleep_for(2000)
                hl:glottis_look_back()
                hl:glottis_look_back_talk()
                hl:check_glottis_volume(hl:current_setup())
                glottis:say_line("/hlgl138/", { background = TRUE, volume = glottis.gambling_volume, pan = glottis.gambling_pan })
                glottis:wait_for_message()
                hl:glottis_stop_look_back_talk()
                hl:glottis_stop_look_back()
            end
            sleep_for(1000)
        end
    end
end
hl.glottis_look_left = function(arg1) -- line 265
    glottis:wait_for_chore()
    glottis:play_chore(glottis_tux_right_smirk, "glottis_tux.cos")
    sleep_for(1000)
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_lk_left, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_lk_left, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_lk_left, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_left_hold, "gl_gamble.cos")
end
hl.glottis_stop_look_left = function(arg1) -- line 276
    stop_script(hl.glottis_look_left)
    glottis:stop_chore(gl_gamble_left_hold, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_left_back_rest_gambling, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_left_back_rest_gambling, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_left_back_rest_gambling, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
end
hl.glottis_look_back = function(arg1) -- line 285
    glottis:wait_for_chore()
    glottis:play_chore(glottis_tux_left_smirk, "glottis_tux.cos")
    sleep_for(1000)
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_speak_pos2, "gl_gamble.cos")
end
hl.glottis_stop_look_back = function(arg1) -- line 296
    stop_script(hl.glottis_look_back)
    if glottis:is_choring(gl_gamble_talks_drunk, FALSE, "gl_gamble.cos") then
        hl:glottis_stop_look_back_talk()
    end
    glottis:stop_chore(gl_gamble_speak_pos2, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
end
hl.glottis_look_back_talk = function(arg1) -- line 308
    glottis:wait_for_chore()
    if not glottis:is_choring(gl_gamble_speak_pos2, FALSE, "gl_gamble.cos") then
        hl:glottis_look_back()
    end
    glottis:stop_chore(gl_gamble_speak_pos2, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_talks_drunk, "gl_gamble.cos")
end
hl.glottis_stop_look_back_talk = function(arg1) -- line 317
    glottis:set_chore_looping(gl_gamble_talks_drunk, FALSE, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_speak_pos2, "gl_gamble.cos")
end
hl.glottis_ramble = function(arg1) -- line 324
    glottis:wait_for_chore()
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(glottis_tux_eye_buldge, "glottis_tux.cos")
    glottis:play_chore(gl_gamble_drunk_rambles, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_drunk_rambles, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_drunk_rambles, "gl_gamble.cos")
    glottis:play_chore(glottis_tux_blink, "glottis_tux.cos")
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
end
hl.glottis_drink = function(arg1) -- line 335
    if find_script(hl.glottis_ramble) then
        wait_for_script(hl.glottis_ramble)
    end
    if hl:current_setup() == hl_glot then
        hl.slurp_vol = 127
    else
        hl.slurp_vol = 64
    end
    glottis:stop_chore(gl_gamble_drunk_rambles, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(glottis_tux_stop_talk, "glottis_tux.cos")
    glottis:play_chore(glottis_tux_blink, "glottis_tux.cos")
    glottis:play_chore(gl_gamble_drink_wine, "gl_gamble.cos")
    sleep_for(1250)
    start_sfx(pick_one_of({ "glSlurp1.WAV", "glSlurp2.WAV", "glSlurp3.WAV", "glSlurp4.WAV" }), nil, hl.slurp_vol)
    glottis:wait_for_chore(gl_gamble_drink_wine, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_drink_wine, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
end
raoul.idle_table = Idle:create("raoul_bored")
raoul.idle_table:add_state("shakes_ankle", { shakes_ankle = 0.80000001, scratches_head = 0.1, cigarette_drag = 0.1 })
raoul.idle_table:add_state("scratches_head", { shakes_ankle = 1 })
raoul.idle_table:add_state("cigarette_drag", { shakes_ankle = 1 })
hl.raoul_paths = { }
hl.raoul_paths.num_paths = 0
hl.raoul_paths.add_path = function(arg1, arg2, arg3, arg4) -- line 376
    local local1
    arg1.num_paths = arg1.num_paths + 1
    local1 = arg1.num_paths
    arg1[local1] = { }
    arg1[local1].setup = arg2
    arg1[local1].next_setup = arg3
    arg1[local1].points = { }
    arg1[local1].num_points = 0
    if not arg4 then
        arg1[local1].delay = 10000
    else
        arg1[local1].delay = arg4
    end
    return arg1[local1]
end
hl.raoul_paths.add_point = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 396
    arg2.num_points = arg2.num_points + 1
    arg2.points[arg2.num_points] = { }
    arg2.points[arg2.num_points].x = arg3
    arg2.points[arg2.num_points].y = arg4
    arg2.points[arg2.num_points].z = arg5
    arg2.points[arg2.num_points].yaw = arg6
end
hl.raoul_paths.init = function(arg1) -- line 405
    local local1
    if not arg1.initialized then
        arg1.initialized = TRUE
        local1 = hl.raoul_paths:add_path(hl_glot, hl_elews, 5000)
        hl.raoul_paths:add_point(local1, 0.76425099, 4.2552299, 1.9, 76)
        hl.raoul_paths:add_point(local1, -1.22183, 4.2641301, 1.9, 97)
        local1 = hl.raoul_paths:add_path(hl_glot, hl_elews, 10000)
        hl.raoul_paths:add_point(local1, -1.4281, 1.4573801, 1.9, 12)
        hl.raoul_paths:add_point(local1, -1.69583, 3.0841401, 1.9, 48)
        local1 = hl.raoul_paths:add_path(hl_dorrv, hl_elews)
        hl.raoul_paths:add_point(local1, -2.6301501, -2.2046499, 0, 1)
        hl.raoul_paths:add_point(local1, -2.6401701, -0.238925, 0, 355)
        local1 = hl.raoul_paths:add_path(hl_dorrv, hl_elews)
        hl.raoul_paths:add_point(local1, 1.93304, 2.12763, 0, 56)
        hl.raoul_paths:add_point(local1, 1.0224, 2.6998, 0, 90)
        local1 = hl.raoul_paths:add_path(hl_elews, hl_dorrv, 15000)
        hl.raoul_paths:add_point(local1, 0.329593, 3.18448, 0.38685301, 186)
        hl.raoul_paths:add_point(local1, 0.52750099, 2.54091, 0, 270)
        hl.raoul_paths:add_point(local1, 1.8327, 2.5434201, 0, 270)
        local1 = hl.raoul_paths:add_path(hl_elews, hl_dorrv, 15000)
        hl.raoul_paths:add_point(local1, -2.63662, -0.190025, 0, 155)
        hl.raoul_paths:add_point(local1, -2.68909, -0.99633098, 0, 202)
        local1 = hl.raoul_paths:add_path(hl_elews, hl_glot, 15000)
        hl.raoul_paths:add_point(local1, -1.00367, 1.00269, 0, 84)
        hl.raoul_paths:add_point(local1, -1.79219, 1.02162, 0, 89)
        hl.raoul_paths:add_point(local1, -1.6125, 2.37696, 0, 248)
        hl.raoul_paths:add_point(local1, 0.053780999, 2.00248, 0, 270)
        hl.raoul_paths.setup_paths = { }
        hl.raoul_paths.setup_paths[hl_glot] = { 1 }
        hl.raoul_paths.setup_paths[hl_dorrv] = { 3, 4 }
        hl.raoul_paths.setup_paths[hl_elews] = { 2, 5, 6 }
        arg1.cur_setup = hl_glot
    end
end
hl.raoul_paths.run_path = function(arg1, arg2) -- line 455
    local local1, local2
    local1, local2 = next(arg2.points, nil)
    if local1 then
        raoul:default("walks")
        raoul:put_in_set(hl)
        raoul:setpos(local2.x, local2.y, local2.z)
        raoul:setrot(0, local2.yaw, 0)
        raoul:set_collision_mode(COLLISION_SPHERE, 0.40000001)
        manny.collision_handler = manny.hl_collision_handler
        local1, local2 = next(arg2.points, local1)
        while local1 ~= nil and not arg1.finish_run_path do
            raoul:walkto(local2.x, local2.y, local2.z)
            while raoul:is_moving() and not arg1.finish_run_path do
                break_here()
            end
            local1, local2 = next(arg2.points, local1)
        end
        raoul:put_in_set(nil)
        arg1.cur_setup = arg2.next_setup
        arg1.finish_run_path = FALSE
    end
end
manny.hl_collision_handler = function(arg1, arg2) -- line 482
    if arg2 == raoul then
        hk:raoul_collision()
        raoul:wait_for_message()
    end
end
hl.raoul_paths.gambling_tour = function(arg1) -- line 489
    local local1, local2
    local local3
    arg1.pause_gambling_tour = FALSE
    while TRUE do
        if arg1.cur_setup == hl_glot then
            local2 = rndint(1, 2)
        elseif arg1.cur_setup == hl_dorrv then
            local2 = rndint(3, 4)
        elseif arg1.cur_setup == hl_elews then
            local2 = rndint(5, 6)
        end
        local1 = arg1[local2]
        local3 = 0
        while local3 < local1.delay and not arg1.pause_gambling_tour do
            break_here()
            local3 = local3 + system.frameTime
        end
        if arg1.pause_gambling_tour then
            while arg1.pause_gambling_tour do
                break_here()
            end
        else
            arg1.cur_setup = local1.next_setup
        end
    end
end
hl.raoul_paths.check_for_raoul_setup = function(arg1, arg2) -- line 524
    local local1, local2
    local local3, local4
    local local5, local6
    local local7, local8
    local local9
    if find_script(arg1.glimpse_raoul) then
        arg1.finish_run_path = TRUE
    elseif find_script(arg1.gambling_tour) then
        if arg1.cur_setup then
            local2 = arg1.setup_paths[arg2]
            if local2 then
                local3 = 0
                local9 = nil
                local6, local5 = next(local2, nil)
                while local6 do
                    local1 = arg1[local5]
                    if local1 ~= nil and local1.setup == arg1.cur_setup then
                        local7, local8 = next(local1.points, nil)
                        local4 = proximity(manny.hActor, local8.x, local8.y, local8.z)
                        if local4 > local3 then
                            local3 = local4
                            local9 = local1
                        end
                    end
                    local6, local5 = next(local2, local6)
                end
                if local9 then
                    single_start_script(arg1.glimpse_raoul, arg1, local9)
                end
            end
        end
    end
end
hl.raoul_paths.glimpse_raoul = function(arg1, arg2) -- line 563
    arg1.pause_gambling_tour = TRUE
    arg1:run_path(arg2)
    arg1.pause_gambling_tour = FALSE
end
hl.raoul_paths.leave_kitchen = function(arg1) -- line 569
    arg1.pause_gambling_tour = TRUE
    hk.raoul_in_kitchen = FALSE
    arg1:run_path(arg1[7])
    single_start_script(arg1.gambling_tour, arg1)
end
hl.set_up_actors = function(arg1) -- line 581
    hk.cask_actor:default()
    hk.cask_actor:put_in_set(hl)
    hk.cask_actor:setpos(-0.358381, 0.906964, 0)
    hk.cask_actor:setrot(0, 268.437, 0)
    if not cigcase_actor then
        cigcase_actor = Actor:create(nil, nil, nil, "cigcase")
    end
    cigcase_actor:set_costume("cigcase.cos")
    cigcase_actor:setpos({ x = 2.44585, y = -4.67677, z = 0.265 })
    cigcase_actor:setrot(0, 140.125, 0)
    cigcase_actor:put_in_set(hl)
    if hl.case.touchable then
        cigcase_actor:set_visibility(TRUE)
    else
        cigcase_actor:set_visibility(FALSE)
    end
    if hl.nick_gone then
        hl.virago_obj:make_untouchable()
    else
        virago:set_costume("nick_idles.cos")
        virago:set_head(3, 4, 5, 165, 28, 80)
        virago:set_mumble_chore(nick_idles_mumble)
        virago:set_talk_chore(1, nick_idles_no_talk)
        virago:set_talk_chore(2, nick_idles_a)
        virago:set_talk_chore(3, nick_idles_c)
        virago:set_talk_chore(4, nick_idles_e)
        virago:set_talk_chore(5, nick_idles_f)
        virago:set_talk_chore(6, nick_idles_l)
        virago:set_talk_chore(7, nick_idles_m)
        virago:set_talk_chore(8, nick_idles_o)
        virago:set_talk_chore(9, nick_idles_t)
        virago:set_talk_chore(10, nick_idles_u)
        virago:put_in_set(hl)
        virago:ignore_boxes()
        virago:set_softimage_pos(22.11, -0.0066, 46.3082)
        virago:setrot(0, -31.8202, 0)
        start_script(hl.virago_idles)
        hl.virago_obj:make_touchable()
    end
    if hl.glottis_gambling then
        glottis:set_costume(nil)
        glottis:put_in_set(hl)
        glottis:set_costume("glottis_tux.cos")
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
        glottis:push_costume("gl_gamble.cos")
        glottis:ignore_boxes()
        glottis:setpos(-0.975807, 0.551755, 1.9)
        glottis:setrot(0, 177.456, 0)
        hl.glottis_obj:make_touchable()
        if not find_script(hk.stowaway) then
            start_script(hl.glottis_idle)
        end
        hl.raoul_obj:make_untouchable()
        if not hk.raoul_quit then
            if not hk.raoul_trapped and not hk.raoul_in_kitchen then
                single_start_script(hl.raoul_paths.gambling_tour, hl.raoul_paths)
            elseif not hk.raoul_trapped and hk.raoul_in_kitchen and not hk.raoul_in_pantry then
                single_start_script(hl.raoul_paths.leave_kitchen, hl.raoul_paths)
            end
        end
    else
        hl.glottis_obj:make_untouchable()
        if not hk.raoul_quit then
            if not hk.raoul_trapped and not hk.raoul_in_kitchen and not hh.raoul_in_elevator then
                raoul:default("bored")
                raoul:put_in_set(hl)
                raoul:setpos(-2.30389, 0.138841, -0.05)
                raoul:setrot(0, 33.4643, 0)
                raoul:set_collision_mode(COLLISION_OFF)
                if hl:current_setup() == hl_elews then
                    start_script(raoul.new_run_idle, raoul, "shakes_ankle")
                end
                hl.raoul_idle_in_view = TRUE
                hl.raoul_obj:make_touchable()
            elseif not hk.raoul_trapped and hk.raoul_in_kitchen and not hk.raoul_in_pantry and not hh.raoul_in_elevator then
                hl.raoul_obj:make_untouchable()
                single_start_script(hl.raoul_paths.leave_kitchen, hl.raoul_paths)
            else
                hl.raoul_obj:make_untouchable()
            end
        end
    end
end
hl.check_glottis_volume = function(arg1, arg2) -- line 684
    if arg2 == hl_dorrv then
        glottis.gambling_volume = 20
        glottis.gambling_pan = 100
    elseif arg2 == hl_elews then
        glottis.gambling_volume = 80
        glottis.gambling_pan = 64
    elseif arg2 == hl_glot then
        glottis.gambling_volume = 120
        glottis.gambling_pan = 50
    elseif arg2 == hl_nikcu then
        glottis.gambling_volume = 10
        glottis.gambling_pan = 120
    end
end
hl.enter = function(arg1) -- line 706
    hl.raoul_paths:init()
    if hk.pantry:is_open() then
        hl:add_object_state(hl_elews, "hl_hpopn.bm", nil, OBJSTATE_UNDERLAY)
        if not hl.pantry_actor then
            hl.pantry_actor = Actor:create(nil, nil, nil, "pantry")
        end
        hl.pantry_actor:set_costume("hl_pantry.cos")
        hl.pantry_actor:put_in_set(hl)
        hl.pantry_actor:play_chore(0)
    elseif hk.pantry:is_locked() then
        if not hl.pantry_actor then
            hl.pantry_actor = Actor:create(nil, nil, nil, "pantry")
        end
        hl.pantry_actor:set_costume("mc_pantry.cos")
        hl.pantry_actor:put_in_set(hl)
        hl.pantry_actor:play_chore(mc_pantry_scythe_end)
        hl.pantry_actor:setpos(0.0209391, 0.495896, -0.024)
        hl.pantry_actor:setrot(0, 270, 0)
    elseif hl.pantry_actor then
        hl.pantry_actor:put_in_set(nil)
    end
    if hk.raoul_in_kitchen and system.lastSet ~= hk then
        hk.raoul_in_kitchen = FALSE
    end
    if dd.strike_on then
        hl.nick_gone = TRUE
    elseif tb.blackmail_photo.owner == manny then
        hl.nick_gone = FALSE
    elseif not bi.seen_kiss then
        hl.nick_gone = TRUE
    end
    hl:set_up_actors()
    NewObjectState(hl_elews, OBJSTATE_STATE, "hl_elev.bm", "hl_elev.zbm")
    hl.hh_door:set_object_state("hl_elev.cos")
    MakeSectorActive("hl_elev", FALSE)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.14, 0.45, 5)
    SetActorShadowPlane(manny.hActor, "shadow_top")
    AddShadowPlane(manny.hActor, "shadow_top")
    SetActorShadowValid(manny.hActor, -1)
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -0.14, 0.45, 15)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActorShadowValid(manny.hActor, -1)
end
hl.exit = function(arg1) -- line 766
    stop_script(hl.virago_idles)
    stop_script(hl.glottis_idle)
    glottis:shut_up()
    glottis:free()
    cigcase_actor:free()
    if hl.pantry_actor then
        hl.pantry_actor:free()
    end
    stop_script(hl.raoul_paths.gambling_tour)
    stop_script(hl.raoul_paths.glimpse_raoul)
    stop_script(hl.raoul_paths.leave_kitchen)
    stop_script(raoul.new_run_idle)
    raoul:free()
    raoul:set_collision_mode(COLLISION_OFF)
    manny.collision_handler = nil
    hl.raoul_idle_in_view = FALSE
    virago:free()
    hk.cask_actor:free()
    hh.raoul_in_elevator = FALSE
    KillActorShadows(manny.hActor)
end
hl.update_music_state = function(arg1) -- line 795
    if hl.glottis_gambling and not hl.talking_to_nick then
        return stateHL_GLOT
    else
        return stateHL
    end
end
hl.camerachange = function(arg1, arg2, arg3) -- line 803
    hl.raoul_paths:check_for_raoul_setup(arg3)
    if arg3 == hl_elews then
        if hl.raoul_idle_in_view then
            start_script(raoul.new_run_idle, raoul, "shakes_ankle")
        end
    else
        stop_script(raoul.new_run_idle)
    end
    hl:check_glottis_volume(arg3)
end
hl.glottis_obj = Object:create(hl, "/hltx139/Glottis", -0.97711599, 0.52448601, 2.4344001, { range = 1.08 })
hl.glottis_obj.use_pnt_x = -0.32935801
hl.glottis_obj.use_pnt_y = 0.219381
hl.glottis_obj.use_pnt_z = 1.9
hl.glottis_obj.use_rot_x = 0
hl.glottis_obj.use_rot_y = 68.153198
hl.glottis_obj.use_rot_z = 0
hl.glottis_obj.lookAt = function(arg1) -- line 835
    manny:twist_head_gesture()
    manny:say_line("/hlma140/")
end
hl.glottis_obj.use = function(arg1) -- line 840
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    stop_script(hl.glottis_idle)
    if lm.ready_to_sail then
        if not hl.bugged_glottis then
            hl.bugged_glottis = TRUE
            manny:head_forward_gesture()
            manny:say_line("/hlma141/")
            manny:wait_for_message()
            manny:point_gesture()
            manny:say_line("/hlma142/")
            manny:wait_for_message()
            hl:glottis_look_left()
            sleep_for(3000)
            glottis:say_line("/hlgl143/")
            glottis:wait_for_message()
            start_script(hl.glottis_stop_look_left, hl)
            glottis:say_line("/hlgl144/")
        else
            manny:head_forward_gesture()
            manny:say_line("/hlma145/")
            manny:wait_for_message()
            hl:glottis_look_left()
            sleep_for(1000)
            hl:glottis_stop_look_left()
            start_script(hl.glottis_look_back_talk, hl)
            glottis:say_line("/hlgl146/")
            glottis:wait_for_message()
            hl:glottis_stop_look_back()
        end
    elseif not hl.talked_glottis then
        hl.talked_glottis = TRUE
        manny:tilt_head_gesture()
        manny:say_line("/hlma147/")
        manny:wait_for_message()
        start_script(hl.glottis_look_left, hl)
        glottis:say_line("/hlgl148/")
        glottis:wait_for_message()
        hl:glottis_stop_look_left()
        glottis:say_line("/hlgl149/")
        hl:glottis_look_back()
        hl:glottis_look_back_talk()
        glottis:wait_for_message()
        hl:glottis_stop_look_back_talk()
        hl:glottis_stop_look_back()
    else
        manny:tilt_head_gesture()
        manny:say_line("/hlma150/")
        manny:wait_for_message()
        if not hl.talked_glottis_twice then
            hl.talked_glottis_twice = TRUE
            start_script(hl.glottis_look_left, hl)
            glottis:say_line("/hlgl151/")
            glottis:wait_for_message()
            hl:glottis_stop_look_left()
        else
            glottis:play_chore(glottis_tux_right_smirk, "glottis_tux.cos")
            glottis:say_line("/hlgl153/")
            wait_for_message()
            glottis:play_chore(glottis_tux_blink, "glottis_tux.cos")
            glottis:say_line("/hlgl154/")
            glottis:wait_for_message()
        end
        glottis:wait_for_message()
    end
    wait_for_message()
    sleep_for(1000)
    END_CUT_SCENE()
    start_script(hl.glottis_idle)
end
hl.glottis_obj.use_suitcase = function(arg1) -- line 917
    START_CUT_SCENE()
    manny:say_line("/hlma152/")
    manny:wait_for_message()
    start_script(hl.glottis_ramble, hl)
    glottis:say_line("/hlgl153/")
    wait_for_message()
    start_script(hl.glottis_ramble, hl)
    glottis:say_line("/hlgl154/")
    END_CUT_SCENE()
end
hl.stair_bot_box = { }
hl.stair_bot_box.walkOut = function(arg1) -- line 932
    START_CUT_SCENE()
    manny:setpos(-1.93073, 2.99635, 1.9)
    manny:setrot(0, -598.875, 0)
    manny:walkto(-1.43425, 2.58847, 1.9)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
hl.stair_top_box = { }
hl.stair_top_box.walkOut = function(arg1) -- line 943
    START_CUT_SCENE()
    manny:setpos(0.282199, 3.01702, 0.177527)
    manny:setrot(0, -1277.41, 0)
    manny:walkto(0.443163, 2.63761, 0)
    manny:wait_for_actor()
    END_CUT_SCENE()
end
hl.gold_cat = Object:create(hl, "/hltx155/statue", 0.45471901, -3.0049601, 1.6, { range = 1.72 })
hl.gold_cat.use_pnt_x = 0.78492397
hl.gold_cat.use_pnt_y = -3.27125
hl.gold_cat.use_pnt_z = 0
hl.gold_cat.use_rot_x = 0
hl.gold_cat.use_rot_y = 47.954201
hl.gold_cat.use_rot_z = 0
hl.gold_cat.lookAt = function(arg1) -- line 961
    soft_script()
    manny:say_line("/hlma156/")
    manny:wait_for_message()
    manny:say_line("/hlma157/")
end
hl.gold_cat.pickUp = function(arg1) -- line 968
    manny:say_line("/hlma158/")
end
hl.gold_cat.use = function(arg1) -- line 972
    manny:say_line("/hlma159/")
end
hl.monitor = Object:create(hl, "/hltx160/monitor", -0.217647, 2.62235, 3.4200001, { range = 2 })
hl.monitor.use_pnt_x = -0.137954
hl.monitor.use_pnt_y = 1.6886801
hl.monitor.use_pnt_z = 1.9
hl.monitor.use_rot_x = 0
hl.monitor.use_rot_y = 348.70499
hl.monitor.use_rot_z = 0
hl.monitor.lookAt = function(arg1) -- line 984
    manny:say_line("/hlma161/")
end
hl.monitor.use = function(arg1) -- line 988
    manny:say_line("/hlma162/")
end
hl.virago_obj = Object:create(hl, "/hltx163/Virago", 2.2216599, -4.7417798, 0.44999999, { range = 1.5 })
hl.virago_obj.use_pnt_x = 2.3670101
hl.virago_obj.use_pnt_y = -4.1946502
hl.virago_obj.use_pnt_z = 0
hl.virago_obj.use_rot_x = 0
hl.virago_obj.use_rot_y = 162.526
hl.virago_obj.use_rot_z = 0
hl.virago_obj.lookAt = function(arg1) -- line 999
    if bi.seen_kiss then
        manny:say_line("/hlma164/")
    else
        manny:say_line("/hlma165/")
    end
end
hl.virago_obj.use = function(arg1) -- line 1007
    START_CUT_SCENE()
    hl.talking_to_nick = TRUE
    music_state:update()
    virago.stop_idle = TRUE
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    hl:current_setup(hl_nikcu)
    wait_for_script(hl.virago_idles)
    END_CUT_SCENE()
    if hl.virago_blackmailed then
        if dd.terry_arrested then
            hl:talk_about_terry()
        else
            START_CUT_SCENE()
            manny:say_line("/hlma166/")
            virago:stop_chore(nick_idles_pprwrk_base)
            virago:play_chore(nick_idles_lkma)
            virago:wait_for_chore()
            virago:wait_for_message()
            virago:say_line("/hlvi167/")
            virago:wait_for_message()
            manny:say_line("/hlma168/")
            manny:wait_for_message()
            manny:say_line("/hlma169/")
            manny:wait_for_message()
            virago:say_line("/hlvi170/")
            virago:wait_for_message()
            virago:stop_chore(nick_idles_lkma)
            virago:play_chore(nick_idles_lkma_2pprwrk)
            virago:wait_for_chore()
            virago:stop_chore(nick_idles_lkma_2pprwrk)
            END_CUT_SCENE()
            hl:current_setup(hl_dorrv)
            start_script(hl.virago_idles)
        end
    elseif tb.blackmail_photo.owner == manny then
        hl:blackmail_virago()
    else
        Dialog:run("vi1", "dlg_virago.lua")
    end
    hl.talking_to_nick = FALSE
    music_state:update()
end
hl.virago_obj.use_blackmail = hl.virago_obj.use
hl.nicks_papers = Object:create(hl, "/hltx171/papers", 2.44472, -4.6549602, 0.25, { range = 0.60000002 })
hl.nicks_papers.use_pnt_x = 2.0894201
hl.nicks_papers.use_pnt_y = -4.4724998
hl.nicks_papers.use_pnt_z = 0
hl.nicks_papers.use_rot_x = 0
hl.nicks_papers.use_rot_y = -134.922
hl.nicks_papers.use_rot_z = 0
hl.nicks_papers:make_untouchable()
hl.nicks_papers.lookAt = function(arg1) -- line 1067
    manny:say_line("/hlma172/")
end
hl.nicks_papers.pickUp = function(arg1) -- line 1071
    manny:say_line("/hlma173/")
end
hl.nicks_papers.use = hl.nicks_papers.pickUp
hl.case = Object:create(hl, "/hltx174/case", 2.4152501, -4.6474199, 0.255, { range = 0.60000002 })
hl.case.use_pnt_x = 2.0894201
hl.case.use_pnt_y = -4.4724998
hl.case.use_pnt_z = 0
hl.case.use_rot_x = 0
hl.case.use_rot_y = -134.922
hl.case.use_rot_z = 0
hl.case.string_name = "cigcase"
hl.case:make_untouchable()
hl.case.lookAt = function(arg1) -- line 1087
    manny:say_line("/hlma175/")
end
hl.case.pickUp = function(arg1) -- line 1091
    if hl.nick_gone then
        START_CUT_SCENE()
        manny:walkto(2.36201, -4.21565, 0, 0, 208.7, 0)
        manny:wait_for_actor()
        manny:say_line("/hlma176/")
        manny:play_chore(mc_get_case, "mc.cos")
        sleep_for(737)
        hl.case:get()
        cigcase_actor:set_visibility(FALSE)
        manny:generic_pickup(arg1)
        manny:wait_for_chore(mc_get_case, "mc.cos")
        manny:stop_chore(mc_get_case, "mc.cos")
        manny:wait_for_message()
        hl.nicks_papers:make_touchable()
        END_CUT_SCENE()
    else
        manny:say_line("/sima172/")
    end
end
hl.case.use = function(arg1) -- line 1112
    START_CUT_SCENE()
    if hl.case.owner ~= manny then
        hl.case:pickUp()
    end
    if hl.nick_gone then
        manny:stop_chore(mc_hold, "mc.cos")
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:push_costume("manny_open_cig_case.cos")
        manny:play_chore(2)
        manny:wait_for_chore(2, "manny_open_cig_case.cos")
        manny:play_chore(0)
        manny:wait_for_chore()
        start_sfx("hlRattle.wav")
        wait_for_sound("hlRattle.wav")
        if not arg1.tried then
            arg1.tried = TRUE
            manny:say_line("/hlma177/")
            manny:wait_for_message()
            manny:say_line("/hlma178/")
        else
            manny:say_line("/hlma179/")
            manny:wait_for_message()
            manny:say_line("/hlma180/")
        end
        manny:play_chore(1)
        manny:wait_for_chore()
        manny:play_chore(3)
        manny:wait_for_chore(3, "manny_open_cig_case.cos")
        manny:pop_costume()
        manny:play_chore_looping(ms_hold, "mc.cos")
        manny:play_chore_looping(manny.hold_chore, "mc.cos")
    end
    END_CUT_SCENE()
end
hl.case.default_response = function(arg1) -- line 1149
    manny:say_line("/hlma181/")
end
hl.raoul_obj = Object:create(hl, "Raoul", -2.2569301, 0.107943, 0.5, { range = 0.80000001 })
hl.raoul_obj.use_pnt_x = -2.5109601
hl.raoul_obj.use_pnt_y = 0.54952401
hl.raoul_obj.use_pnt_z = 0
hl.raoul_obj.use_rot_x = 0
hl.raoul_obj.use_rot_y = 173.485
hl.raoul_obj.use_rot_z = 0
hl.raoul_obj.lookAt = function(arg1) -- line 1163
    START_CUT_SCENE()
    manny:say_line("/hama052/")
    manny:wait_for_message()
    raoul:say_line("/hkra029/")
    END_CUT_SCENE()
end
hl.raoul_obj.pickUp = function(arg1) -- line 1171
    system.default_response("nah")
end
hl.raoul_obj.use = hl.raoul_obj.lookAt
hl.hk_door = Object:create(hl, "/hltx182/door", -1.08233, 0.85732001, 0.5, { range = 0 })
hl.hk_box = hl.hk_door
hl.hk_door.use_pnt_x = -1.35155
hl.hk_door.use_pnt_y = 0.86664999
hl.hk_door.use_pnt_z = 0
hl.hk_door.use_rot_x = 0
hl.hk_door.use_rot_y = -447.897
hl.hk_door.use_rot_z = 0
hl.hk_door.out_pnt_x = -0.92223698
hl.hk_door.out_pnt_y = 0.88242
hl.hk_door.out_pnt_z = 0
hl.hk_door.out_rot_x = 0
hl.hk_door.out_rot_y = -447.897
hl.hk_door.out_rot_z = 0
hl.hk_door.walkOut = function(arg1) -- line 1203
    hk:come_out_door(hk.hl_door)
end
hl.mx_door = Object:create(hl, "/hltx183/door", -4.1039, -1.09201, 0.42699999, { range = 1 })
hl.mx_door.use_pnt_x = -3.5099001
hl.mx_door.use_pnt_y = -1.56601
hl.mx_door.use_pnt_z = 0
hl.mx_door.use_rot_x = 0
hl.mx_door.use_rot_y = -292.67001
hl.mx_door.use_rot_z = 0
hl.mx_door.out_pnt_x = -4.0453701
hl.mx_door.out_pnt_y = -1.19244
hl.mx_door.out_pnt_z = 0
hl.mx_door.out_rot_x = 0
hl.mx_door.out_rot_y = -294.27399
hl.mx_door.out_rot_z = 0
hl.mx_door:make_untouchable()
hl.mx_door.walkOut = function(arg1) -- line 1226
    if hl.nick_gone and not dd.strike_on and bi.seen_kiss == TRUE then
        manny:say_line("/hlma185/")
    else
        mx:come_out_door(mx.hl_door)
    end
end
hl.hh_door = Object:create(hl, "/hltx184/door", -0.98232698, 2.7573199, 0.40000001, { range = 0 })
hl.hh_door.use_pnt_x = -0.67500001
hl.hh_door.use_pnt_y = 2.95
hl.hh_door.use_pnt_z = 0
hl.hh_door.use_rot_x = 0
hl.hh_door.use_rot_y = -172.914
hl.hh_door.use_rot_z = 0
hl.hh_door.out_pnt_x = -0.67500001
hl.hh_door.out_pnt_y = 2.95
hl.hh_door.out_pnt_z = 0
hl.hh_door.out_rot_x = 0
hl.hh_door.out_rot_y = -172.914
hl.hh_door.out_rot_z = 0
hl.hh_door.walkOut = function(arg1) -- line 1252
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    if manny.is_holding then
        put_away_held_item()
    end
    arg1:close()
    hh.hl_door:comeOut()
    END_CUT_SCENE()
end
hl.hh_door.open = function(arg1) -- line 1266
    if not arg1:is_open() then
        arg1:play_chore(0)
        arg1:wait_for_chore()
        Object.open(arg1)
    end
end
hl.hh_door.close = function(arg1) -- line 1275
    if arg1:is_open() then
        arg1:play_chore(1)
        arg1:wait_for_chore()
        Object.close(arg1)
    end
end
hl.elev_open = { }
hl.elev_open.walkOut = function(arg1) -- line 1288
    MakeSectorActive("hl_elev", TRUE)
    hl.hh_door:open()
    while manny:find_sector_name("elev_open") do
        break_here()
    end
    if manny:find_sector_name("hh_box") then
        hl.hh_door:walkOut()
    else
        hl.hh_door:close()
        MakeSectorActive("hl_elev", FALSE)
    end
end
hl.elev_open.comeOut = function(arg1) -- line 1302
    START_CUT_SCENE()
    hl:switch_to_set()
    hl:current_setup(hl_elews)
    manny:put_in_set(hl)
    manny:setpos(-0.675, 2.95, 0)
    manny:setrot(0, -172.914, 0)
    hl.hh_door:open()
    MakeSectorActive("hl_elev", TRUE)
    manny:walkto(-0.675601, 2.69798, 0)
    manny:wait_for_actor()
    hl.hh_door:close()
    MakeSectorActive("hl_elev", FALSE)
    END_CUT_SCENE()
end

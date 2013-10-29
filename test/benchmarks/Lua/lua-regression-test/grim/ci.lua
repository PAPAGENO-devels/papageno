CheckFirstTime("ci.lua")
ci = Set:create("ci.set", "cafe interior", { ci_stpws = 0, ci_stpws1 = 0, ci_stpws2 = 0, ci_barws = 1, ci_widha = 2, ci_widha1 = 2, ci_glotk = 3, ci_ovrhd = 4, ci_ovrhd = 5 })
dofile("glottis_tux.lua")
dofile("glottis_piano.lua")
dofile("mc_drink.lua")
dofile("gl_hrpass.lua")
dofile("mc_railslide.lua")
gold_actor = Actor:create()
ci.lamp_point = { x = 0.533434, y = 0.676165, z = -0.4055 }
ci.bar_point = { x = 0.168434, y = 0.531765, z = -1.0075 }
ci.other_point = { x = 1.33023, y = 0.977164, z = -1.2006 }
RAIL_Y = 0.279443
EARLY_SLIDE_STOP_X = 2.3
FINAL_SLIDE_STOP_X = 2.8
ci.bannister_acceleration = function(arg1) -- line 30
    local local1 = arg1
    local local2 = 0
    ci.chute_deployed = FALSE
    while 1 do
        local1 = arg1 * (0.003 * local2)
        manny:set_walk_rate(local1)
        local2 = local2 + system.frameTime
        mpos = manny:getpos()
        if mpos.x >= EARLY_SLIDE_STOP_X and local1 >= 2.4000001 or mpos.x >= FINAL_SLIDE_STOP_X then
            ci.chute_deployed = TRUE
            PrintDebug("chute deployed at slide_rate = " .. local1)
        end
        break_here()
    end
end
ci.slide_down_bannister = function() -- line 52
    local local1 = manny:getpos()
    local local2 = 0
    START_CUT_SCENE()
    ci:current_setup(ci_stpws)
    box_off("rail_trigger")
    box_on("rail_box")
    if manny.is_holding then
        manny.is_holding:put_away()
    end
    manny:walkto(local1.x, RAIL_Y, local1.z)
    manny:setrot(0, 270, 0)
    manny:set_rest_chore(nil)
    manny:stop_chore()
    manny:push_costume("mc_railslide.cos")
    manny:play_chore(mc_railslide_on_rail, "mc_railslide.cos")
    manny:set_walk_chore(mc_railslide_on_rail, "mc_railslide.cos")
    start_sfx("ciSlide.WAV", IM_HIGH_PRIORITY, 5)
    fade_sfx("ciSlide.WAV", 2000, 127)
    local2 = 0
    repeat
        break_here()
        local2 = local2 + system.frameTime
    until local2 > 500 or ci.chute_deployed
    manny:offsetBy(0, 0, 0.059999999)
    ci.chute_deployed = FALSE
    start_script(ci.bannister_acceleration, 1)
    start_script(manny.walkto, manny, 3.3208799, 0.224655, -1.33788)
    while not ci.chute_deployed and manny:is_choring(mc_railslide_on_rail, TRUE, "mc_railslide.cos") do
        PrintDebug("jumping on rail!\n")
        break_here()
        local1 = manny:getpos()
    end
    if not ci.chute_deployed then
        manny:set_walk_chore(mc_railslide_sllide, "mc_railslide.cos")
        manny:play_chore_looping(mc_railslide_sllide, "mc_railslide.cos")
        repeat
            PrintDebug("sliding down rail!\n")
            break_here()
        until ci.chute_deployed
        manny:set_walk_chore(nil)
    end
    stop_sound("ciSlide.WAV")
    manny:stop_chore()
    manny:play_chore(mc_railslide_off_rail, "mc_railslide.cos")
    sleep_for(250)
    manny:offsetBy(0, 0, -0.059999999)
    manny:wait_for_chore(mc_railslide_off_rail, "mc_railslide.cos")
    stop_script(ci.bannister_acceleration)
    box_off("rail_box")
    box_on("rail_trigger")
    manny:set_rest_chore(mc_rest)
    manny:default()
    END_CUT_SCENE()
    if not ci.hello_tripped then
        ci.hello_trigger:walkOut()
    end
end
ci.look_around = function() -- line 119
    manny:set_look_rate(125)
    manny:head_look_at_point(ci.lamp_point)
    sleep_for(2000)
    manny:head_look_at_point(ci.other_point)
    sleep_for(2000)
    manny:head_look_at_point(ci.bar_point)
    sleep_for(2000)
    manny:twist_head_gesture()
    manny:set_look_rate(manny.default_look_rate)
end
ci.give_pass = function() -- line 131
    START_CUT_SCENE()
    if manny.is_holding ~= cn.pass then
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.pass
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
        end
    end
    start_script(manny.walkto, manny, 2.59454, 1.18761, -1.4, 0, 29.0819, 0)
    if not ci.said_check_out then
        manny:say_line("/cima001/")
        manny:wait_for_message()
    end
    manny:say_line("/cima002/")
    manny:wait_for_actor()
    manny:wait_for_chore()
    manny:stop_chore(ms_hold, "mc.cos")
    manny:play_chore(mc_give_hrpass, "mc.cos")
    glottis:push_costume("gl_hrpass.cos")
    glottis:stop_chore(glottis_piano_piano_loop, "glottis_piano.cos")
    glottis:play_chore(gl_hrpass_to_get_hrpass)
    glottis:wait_for_chore()
    glottis:play_chore(gl_hrpass_take_hrpass)
    manny:wait_for_chore()
    manny.is_holding = nil
    cn.pass:free()
    manny:stop_chore(manny.hold_chore, "mc.cos")
    manny:run_chore(mc_hrpass_rtrn2base, "mc.cos")
    manny:stop_chore()
    manny:turn_left(60)
    manny:head_look_at(nil)
    manny:default()
    wait_for_message()
    manny:say_line("/cima003/")
    start_script(manny.walkto, manny, 1.55211, 1.33205, -1.39908)
    sleep_for(1000)
    ci:current_setup(ci_barws)
    manny:head_look_at(nil)
    manny:push_costume("mc_hand_gesture.cos")
    manny:setpos(1.55211, 1.33205, -1.39908)
    manny:setrot(0, 107.58, 0)
    manny:run_chore(0, "mc_hand_gesture.cos")
    manny:wait_for_message()
    glottis:say_line("/cigl004/")
    sleep_for(500)
    start_script(ci.look_around)
    wait_for_message()
    manny:say_line("/cima005/")
    manny:shrug_gesture()
    wait_for_message()
    glottis:say_line("/cigl006/")
    wait_for_message()
    glottis:say_line("/cigl007/")
    wait_for_message()
    glottis:say_line("/cigl008/")
    hl.glottis_gambling = TRUE
    music_state:update()
    wait_for_message()
    start_sfx("ciGlRun.WAV")
    manny:head_look_at(ci.glottis_obj)
    glottis:free()
    ci.glottis_obj:make_untouchable()
    wait_for_sound("ciGlRun.WAV")
    manny:say_line("/cima009/")
    wait_for_message()
    manny:pop_costume()
    ci:current_setup(ci_stpws)
    manny:turn_left(90)
    manny:walkto(1.80843, 1.30685, -1.4, 0, 276.598, 0)
    manny:say_line("/cima010/")
    manny:wait_for_message()
    END_CUT_SCENE()
    cur_puzzle_state[18] = TRUE
    music_state:set_state(stateCI_EMPTY)
    ci.piano:make_touchable()
    ci:set_boxes()
    break_here()
    ci:current_setup(ci_stpws)
    manny:head_look_at(nil)
end
ci.glottis_sing_at = function(arg1, arg2) -- line 224
    local local1
    local local2
    local1 = sleep_for(arg2)
    local2 = GetSpeechMode()
    if local2 == VOICE_ONLY or local2 == VOICE_AND_TEXT then
        dialog_log:log_say_line(glottis, arg1)
    else
        glottis:say_line(arg1)
    end
    return local1 + arg2
end
ci.stop_glottis_near_conclusion = function() -- line 241
    sleep_for(82500)
    glottis:set_chore_looping(glottis_piano_piano_loop, FALSE, "glottis_piano.cos")
    glottis:play_chore(glottis_piano_pause_playing, "glottis_piano.cos")
    glottis:head_look_at_manny()
end
ci.rusty_anchor_song = function() -- line 249
    local local1
    local local2
    set_override(ci.skip_song)
    START_CUT_SCENE()
    glottis:head_look_at_manny()
    glottis:say_line("/cigl011/")
    wait_for_message()
    glottis:say_line("/cigl012/")
    wait_for_message()
    glottis:say_line("/cigl013/")
    wait_for_message()
    glottis:say_line("/cigl014/")
    wait_for_message()
    glottis:say_line("/cigl015/")
    wait_for_message()
    glottis:say_line("/cigl016/")
    wait_for_message()
    glottis:set_head(3, 4, 4, 165, 28, 80)
    glottis:head_look_at_point(3.43297, 1.2381099, -1.12)
    music_state:pause()
    glottis:set_mumble_chore(glottis_tux_mumble_slow)
    glottis:set_time_scale(2)
    start_script(ci.stop_glottis_near_conclusion)
    local1 = GetSpeechMode()
    if local1 == VOICE_ONLY or local1 == VOICE_AND_TEXT then
        glottis:say_line("/cigl017a/")
    else
        ImSetState(stateCI_SONG)
    end
    local2 = ci.glottis_sing_at("/cigl017/", 5766)
    local2 = local2 + ci.glottis_sing_at("/cigl018/", 9133 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl019/", 11666 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl020/", 15000 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl021/", 19033 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl022/", 22533 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl023/", 25166 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl024/", 29200 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl025/", 36700 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl026/", 39766 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl027/", 42666 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl028/", 46300 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl033/", 50533 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl034/", 54033 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl035/", 56733 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl036/", 60033 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl037/", 63933 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl038/", 67433 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl039/", 70100 - local2)
    local2 = local2 + ci.glottis_sing_at("/cigl040/", 74200 - local2)
    local1 = GetSpeechMode()
    if local1 == VOICE_ONLY or local1 == VOICE_AND_TEXT then
        wait_for_message()
    else
        sleep_for(89000 - local2)
    end
    glottis:set_time_scale(1)
    glottis:complete_chore(glottis_tux_stop_talk, "glottis_tux.cos")
    glottis:set_mumble_chore(glottis_tux_mumble)
    glottis:say_line("/cigl041/")
    wait_for_message()
    manny:say_line("/cima042/")
    wait_for_message()
    glottis:say_line("/cigl043/")
    wait_for_message()
    ci.skip_song()
    END_CUT_SCENE()
end
ci.skip_song = function() -- line 349
    kill_override()
    stop_script(ci.stop_glottis_near_conclusion)
    glottis:set_time_scale(1)
    glottis:complete_chore(glottis_tux_stop_talk, "glottis_tux.cos")
    glottis:set_mumble_chore(glottis_tux_mumble)
    glottis:play_chore(glottis_piano_resume_playing, "glottis_piano.cos")
    glottis:play_chore_looping(glottis_piano_piano_loop, "glottis_piano.cos")
    music_state:unpause()
    glottis:head_look_at_point(3.43297, 1.23811, -1.12)
end
table_actor = { }
ci.set_up_tables = function(arg1) -- line 366
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not table_actor[local1] then
            table_actor[local1] = Actor:create(nil, nil, nil, "table" .. local1)
        end
        table_actor[local1]:set_costume("x_spot.cos")
        table_actor[local1]:set_visibility(FALSE)
        table_actor[local1]:put_in_set(ci)
        table_actor[local1]:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(table_actor[local1].hActor, 0.89999998)
        if local1 == 1 then
            table_actor[local1]:setpos(2.9061899, 0.94430399, -1.1864001)
        elseif local1 == 2 then
            table_actor[local1]:setpos(2.0600901, 1.2569, -1.1864001)
        elseif local1 == 3 then
            table_actor[local1]:setpos(1.50089, 1.5663, -1.1864001)
        elseif local1 == 4 then
            table_actor[local1]:setpos(1.33079, 0.92940402, -1.1864001)
            SetActorCollisionScale(table_actor[local1].hActor, 1.15)
        end
    until local1 == 4
end
ci.set_up_actors = function(arg1) -- line 392
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.35)
    if hl.glottis_gambling then
        glottis:free()
        ci.glottis_obj:make_untouchable()
    else
        glottis:default()
        glottis:put_in_set(ci)
        glottis:set_costume("glottis_tux.cos")
        glottis:set_mumble_chore(glottis_tux_mumble, "glottis_tux.cos")
        glottis:set_talk_chore(1, glottis_tux_stop_talk)
        glottis:set_talk_chore(2, glottis_tux_a)
        glottis:set_talk_chore(3, glottis_tux_c)
        glottis:set_talk_chore(4, glottis_tux_e)
        glottis:set_talk_chore(5, glottis_tux_f)
        glottis:set_talk_chore(6, glottis_tux_l)
        glottis:set_talk_chore(7, glottis_tux_m)
        glottis:set_talk_chore(8, glottis_tux_o)
        glottis:set_talk_chore(9, glottis_tux_t)
        glottis:set_talk_chore(10, glottis_tux_u)
        glottis:push_costume("glottis_piano.cos")
        glottis:set_head(3, 4, 4, 165, 28, 80)
        glottis:set_look_rate(90)
        glottis:head_look_at(nil)
        glottis:setpos(2.64, 1.91, -1.39)
        glottis:setrot(0, -130.15, 0)
        glottis:play_chore_looping(glottis_piano_piano_loop)
    end
    if ci.liqueur.owner ~= manny then
        if not gold_actor then
            gold_actor = Actor:create(nil, nil, nil, "gold")
        end
        gold_actor:set_costume("gold.cos")
        gold_actor:put_in_set(ci)
        gold_actor:setpos(0.2337, 0.554473, -1.0143)
        gold_actor:setrot(0, 90, 0)
    else
        gold_actor:free()
    end
end
ci.set_boxes = function(arg1) -- line 437
    box_off("ci_glotk")
    if hl.glottis_gambling then
        box_on("glot_box1")
        box_on("glot_box3")
        box_on("glot_box4")
        box_on("glot_box5")
    else
        box_off("glot_box1")
        box_off("glot_box3")
        box_off("glot_box4")
        box_off("glot_box5")
    end
end
ci.enter = function(arg1) -- line 461
    ci:set_up_actors()
    ci:set_boxes()
    if cn.pass.owner == manny then
        LoadCostume("mc_hand_gesture.cos")
        preload_sfx("ciGlRun.WAV")
    end
    SetShadowColor(0, 0, 0)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 100)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
    LoadCostume("mc_railslide.cos")
    if hl.glottis_gambling or ci.hello_tripped then
        box_off("hello_trigger")
    end
end
ci.camerachange = function(arg1, arg2, arg3) -- line 483
    if ci.liqueur.owner ~= manny then
        if arg3 == ci_stpws then
            gold_actor:setpos(0.668839, 0.600597, -0.97278)
        else
            gold_actor:setpos(0.2337, 0.554473, -1.0143)
        end
    end
    music_state:update()
end
ci.exit = function(arg1) -- line 496
    glottis:free()
    manny:set_collision_mode(COLLISION_OFF)
    local local1 = 0
    repeat
        local1 = local1 + 1
    until local1 == 4
    gold_actor:free()
    KillActorShadows(manny.hActor)
end
ci.update_music_state = function(arg1) -- line 510
    if hl.glottis_gambling then
        return stateCI_EMPTY
    elseif ci:current_setup() == ci_widha then
        return stateCI_WIDHA
    elseif ci:current_setup() == ci_barws then
        return stateCI_BARWS
    else
        return stateCI_NOODLE
    end
end
ci.rail_trigger = { }
ci.rail_trigger.walkOut = function(arg1) -- line 532
    local local1 = manny:get_positive_rot()
    if local1.y < 10 or local1.y > 90 then
        ci.slide_down_bannister()
    end
end
ci.hello_trigger = { }
ci.hello_trigger.walkOut = function(arg1) -- line 541
    if not hl.glottis_gambling and not ci.hello_tripped then
        START_CUT_SCENE()
        ci.hello_tripped = TRUE
        glottis:head_look_at_manny()
        glottis:say_line("/cigl044/")
        local local1 = glottis:getpos()
        start_script(manny.turn_toward_entity, manny, local1.x, local1.y, local1.z)
        wait_for_message()
        glottis:head_look_at(nil)
        manny:say_line("/lyma047/")
        wait_for_message()
        box_off("hello_trigger")
        END_CUT_SCENE()
    end
end
ci.glottis_obj = Object:create(ci, "/citx045/Glottis", 2.8558199, 1.74634, -0.80000001, { range = 1 })
ci.glottis_obj.use_pnt_x = 2.594542
ci.glottis_obj.use_pnt_y = 1.18761
ci.glottis_obj.use_pnt_z = -1.4
ci.glottis_obj.use_rot_x = 0
ci.glottis_obj.use_rot_y = 29.0819
ci.glottis_obj.use_rot_z = 0
ci.glottis_obj.lookAt = function(arg1) -- line 568
    manny:say_line("/cima046/")
end
ci.glottis_obj.use = function(arg1) -- line 572
    manny:wait_for_message()
    if manny:walkto_object(arg1) then
        ci.talked_to_glottis = TRUE
        Dialog:run("gl2", "dlg_glot2.lua")
    end
end
ci.glottis_obj.use_pass = function(arg1) -- line 580
    START_CUT_SCENE()
    manny:wait_for_message()
    ci:give_pass()
    END_CUT_SCENE()
end
ci.glottis_obj.use_paper = function(arg1) -- line 587
    START_CUT_SCENE()
    manny:wait_for_message()
    start_script(ci.rusty_anchor_song)
    END_CUT_SCENE()
end
ci.glottis_obj.lookUp = function(arg1) -- line 594
    arg1.looking_up = TRUE
    glottis:set_chore_looping(glottis_piano_piano_loop, FALSE)
    glottis:wait_for_chore()
    glottis:play_chore(glottis_piano_turn_head)
    glottis:wait_for_chore()
end
ci.glottis_obj.lookDn = function(arg1) -- line 602
    arg1.looking_up = FALSE
    glottis:wait_for_chore()
    glottis:play_chore(glottis_piano_turn_head_back)
    glottis:wait_for_chore()
    glottis:play_chore_looping(glottis_piano_piano_loop)
end
ci.liqueur = Object:create(ci, "/citx047/bottle of gold flake liqueur", 0.237665, 0.556952, -1.0427001, { range = 0.60000002 })
ci.liqueur.use_pnt_x = 0.34766501
ci.liqueur.use_pnt_y = 0.618352
ci.liqueur.use_pnt_z = -1.4
ci.liqueur.use_rot_x = 0
ci.liqueur.use_rot_y = -244.09
ci.liqueur.use_rot_z = 0
ci.liqueur.string_name = "liqueur"
ci.liqueur.wav = "getBotl.wav"
ci.liqueur.lookAt = function(arg1) -- line 620
    manny:say_line("/cima048/")
    if not arg1.seen then
        arg1.seen = TRUE
        START_CUT_SCENE()
        if arg1.owner ~= manny then
            manny:wait_for_message()
            manny:say_line("/cima049/")
            wait_for_message()
            manny:say_line("/cima050/")
        end
        END_CUT_SCENE()
    end
end
ci.liqueur.pickUp = function(arg1) -- line 637
    if manny:walkto(arg1) then
        START_CUT_SCENE()
        manny:wait_for_actor()
        if not arg1.seen then
            arg1.seen = TRUE
            manny:say_line("/cima048/")
            manny:wait_for_message()
        end
        manny:say_line("/cima051/")
        manny:play_chore(ms_hand_on_obj, manny.base_costume)
        manny:wait_for_chore()
        start_sfx("botlUp.wav")
        manny.is_holding = arg1
        manny.hold_chore = mc_activate_liqueur
        manny:play_chore_looping(manny.hold_chore, manny.base_costume)
        gold_actor:free()
        manny:play_chore(ms_hand_off_obj, manny.base_costume)
        manny:wait_for_chore()
        manny:play_chore_looping(mc_hold, manny.base_costume)
        END_CUT_SCENE()
        ci.liqueur:get()
    end
end
ci.liqueur.use = function(arg1) -- line 664
    if arg1.owner ~= manny then
        arg1:pickUp()
    elseif manny.golden then
        manny:say_line("/cima052/")
    else
        START_CUT_SCENE()
        manny.golden = TRUE
        look_at_item_in_hand(TRUE)
        manny:say_line("/cima053/")
        wait_for_message()
        manny:head_look_at(nil)
        manny:push_costume("mc_drink.cos")
        manny:play_chore(mc_drink_drink, "mc_drink.cos")
        sleep_for(1700)
        manny:say_line("/cima054/")
        manny:wait_for_chore(mc_drink_drink, "mc_drink.cos")
        manny:wait_for_message()
        manny:pop_costume()
        END_CUT_SCENE()
        start_script(ci.liqueur.timer)
    end
end
ci.liqueur.timer = function(arg1) -- line 690
    sleep_for(10000)
    while cutSceneLevel > 0 do
        break_here()
    end
    manny:wait_for_message()
    manny.golden = FALSE
    manny:run_chore(mc_belch, "mc.cos")
    manny:stop_chore(mc_belch, "mc.cos")
    manny:shut_up()
end
ci.piano = Object:create(ci, "/citx056/piano", 2.8558199, 1.64634, -1.2, { range = 0.60000002 })
ci.piano.use_pnt_x = 2.7943699
ci.piano.use_pnt_y = 1.7085
ci.piano.use_pnt_z = -1.397
ci.piano.use_rot_x = 0
ci.piano.use_rot_y = 237.854
ci.piano.use_rot_z = 0
ci.piano:make_untouchable()
ci.piano.lookAt = function(arg1) -- line 719
    manny:say_line("/cima057/")
end
ci.piano.pickUp = function(arg1) -- line 723
    manny:say_line("/cima058/")
end
ci.piano.use = function(arg1) -- line 727
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    music_state:set_sequence(seqMannySingMeche)
    manny:say_line("/cima059/")
    sleep_for(500)
    manny:head_look_at(ci.other_keys)
    wait_for_message()
    manny:say_line("/cima060/")
    manny:head_look_at(ci.piano)
    sleep_for(500)
    manny:head_look_at(ci.other_keys)
    sleep_for(500)
    manny:head_look_at(ci.piano)
    sleep_for(500)
    manny:head_look_at(ci.other_keys)
    wait_for_message()
    manny:say_line("/cima061/")
    manny:head_look_at(ci.ceiling)
    wait_for_message()
    manny:head_look_at(ci.lupe_obj)
    start_sfx("lupeClap.wav")
    set_pan("lupeClap.wav", 10)
    sleep_for(1000)
    lupe:say_line("/cilu062/")
    wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
ci.lupe_obj = Object:create(ci, "", 0.155819, 0.64633799, 0.30000001, { range = 0 })
ci.ceiling = Object:create(ci, "", 2.9358201, 1.56634, -0.5, { range = 0 })
ci.other_keys = Object:create(ci, "", 2.9558201, 1.64634, -1.2, { range = 0 })
ci.cn_door = Object:create(ci, "/citx065/door", -0.05212, 1.66897, -1, { range = 0.60000002 })
ci.cn_door.use_pnt_x = 0.34983
ci.cn_door.use_pnt_y = 1.74863
ci.cn_door.use_pnt_z = -1.397
ci.cn_door.use_rot_x = 0
ci.cn_door.use_rot_y = 813.35199
ci.cn_door.use_rot_z = 0
ci.cn_door.out_pnt_x = -0.057112701
ci.cn_door.out_pnt_y = 1.72479
ci.cn_door.out_pnt_z = -1.397
ci.cn_door.out_rot_x = 0
ci.cn_door.out_rot_y = 813.35199
ci.cn_door.out_rot_z = 0
ci.cn_door:make_untouchable()
ci.cn_box = ci.cn_door
ci.cn_door.walkOut = function(arg1) -- line 786
    START_CUT_SCENE()
    cn:come_out_door(cn.ci_door)
    END_CUT_SCENE()
end
ci.cc_door = Object:create(ci, "/citx066/door", -0.05212, 0.568968, 0.30000001, { range = 0.60000002 })
ci.cc_door.use_pnt_x = 0.237735
ci.cc_door.use_pnt_y = 0.55941498
ci.cc_door.use_pnt_z = -2.6016099e-07
ci.cc_door.use_rot_x = 0
ci.cc_door.use_rot_y = 450.698
ci.cc_door.use_rot_z = 0
ci.cc_door.out_pnt_x = 0.000552463
ci.cc_door.out_pnt_y = 0.55652201
ci.cc_door.out_pnt_z = -1.98446e-07
ci.cc_door.out_rot_x = 0
ci.cc_door.out_rot_y = 450.698
ci.cc_door.out_rot_z = 0
ci.cc_door:make_untouchable()
ci.cc_box = ci.cc_door
ci.cc_door.walkOut = function(arg1) -- line 813
    cc:come_out_door(cc.ci_door)
end

CheckFirstTime("fe.lua")
fe = Set:create("fe.set", "festival", { fe_tntws = 0, fe_ovrhd = 1 })
fe.camera_adjusts = { 35 }
dofile("fe_crowd_idle.lua")
dofile("fe_crowd_balloons.lua")
dofile("balloonman.lua")
dofile("balloon_loop.lua")
clown = Actor:create(nil, nil, nil, "/fetx051/")
clown.groundPoint = { x = 0.605183, y = 1.50183, z = -0.1 }
clown.upPoint = { x = 0.605183, y = 1.50183, z = 0.33 }
clown.default = function(arg1) -- line 29
    clown:set_costume("balloonman.cos")
    clown:set_colormap("ballman.cmp")
    clown:ignore_boxes()
    clown:put_in_set(fe)
    clown:setpos(0.600189, 1.53804, -0.1)
    clown.is_standing = FALSE
    clown:setrot(0, 277.042, 0)
    clown:set_head(17, 18, 19, 165, 28, 80)
    clown:head_look_at_point(clown.upPoint, 200)
    clown:set_mumble_chore(balloonman_mumble)
    clown:set_talk_chore(1, balloonman_stop_talk)
    clown:set_talk_chore(2, balloonman_a)
    clown:set_talk_chore(3, balloonman_c)
    clown:set_talk_chore(4, balloonman_e)
    clown:set_talk_chore(5, balloonman_f)
    clown:set_talk_chore(6, balloonman_l)
    clown:set_talk_chore(7, balloonman_m)
    clown:set_talk_chore(8, balloonman_o)
    clown:set_talk_chore(9, balloonman_t)
    clown:set_talk_chore(10, balloonman_u)
    clown.idling = FALSE
end
clown.idle = function(arg1) -- line 54
    if not arg1.idling then
        arg1.idling = TRUE
        if arg1.is_standing then
            arg1:stop_chore(balloonman_stand, "balloonman.cos")
            arg1:push_costume("balloon_loop.cos")
            arg1:play_chore(balloon_loop_stand_to_cycle)
            arg1:wait_for_chore(balloon_loop_stand_to_cycle)
            arg1:stop_chore(balloon_loop_stand_to_cycle)
            arg1.is_standing = FALSE
        else
            arg1:stop_chore(balloonman_end_tie, "balloonman.cos")
            arg1:play_chore(balloonman_takeout_balloon, "balloonman.cos")
            arg1:wait_for_chore(balloonman_takeout_balloon, "balloonman.cos")
            arg1:play_chore(balloonman_begin_tie, "balloonman.cos")
            arg1:wait_for_chore(balloonman_begin_tie, "balloonman.cos")
            arg1:stop_chore(balloonman_begin_tie, "balloonman.cos")
            arg1:push_costume("balloon_loop.cos")
        end
        arg1:play_chore_looping(0, "balloon_loop.cos")
        arg1:head_look_at_point(arg1.groundPoint)
    end
end
clown.stop_idle = function(arg1, arg2) -- line 78
    if not arg1.is_idling then
        arg1.idling = FALSE
        stop_script(arg1.idle)
        if not arg2 then
            arg1:set_chore_looping(0, FALSE)
            arg1:wait_for_chore(0, "balloon_loop.cos")
        end
        arg1:stop_chore(0, "balloon_loop.cos")
        arg1:head_look_at(manny)
        arg1:play_chore(balloon_loop_cycle_to_stand, "balloon_loop.cos")
        arg1:wait_for_chore(balloon_loop_cycle_to_stand, "balloon_loop.cos")
        if GetActorCostumeDepth(clown.hActor) > 1 then
            arg1:pop_costume()
            arg1:play_chore(balloonman_stand, "balloonman.cos")
            arg1.is_standing = TRUE
        end
    else
        arg1:head_look_at(manny)
    end
end
fe.balloon_sfx = { }
fe.balloon_sfx[1] = "balloon1.wav"
fe.balloon_sfx[2] = "balloon2.wav"
fe.balloon_sfx[3] = "balloon3.wav"
fe.balloon_sfx[4] = "balloon4.wav"
fe.balloon_sfx[5] = "balloon5.wav"
fe.balloon_sfx[6] = "balloon6.wav"
fe.balloon_sfx[7] = "balloon7.wav"
fe.balloon_sfx[8] = "balloon8.wav"
fe.balloon_sfx[9] = "balloon9.wav"
fe.squeaky_chores = { }
fe.squeaky_chores[1] = balloonman_end_tie
fe.squeaky_chores[2] = balloonman_begin_tie
fe.squeaky_chores[3] = balloonman_tie_balloon
fe.squeaky_chores[4] = balloonman_give_big
fe.squeaky_chores[5] = balloonman_give_small
fe.squeaky_chores[6] = balloonman_takeout_spin_dingo
fe.squeaky_chores[7] = balloonman_takeout_spin_cat
fe.squeaky_chores[8] = balloonman_takeout_spin_rfrost
fe.squeaky_chores[9] = 0
clown.squeak = function(arg1) -- line 126
    local local1
    local local2
    while 1 do
        local2 = clown:is_choring()
        if in(local2, fe.squeaky_chores) then
            local1 = pick_from_nonweighted_table(fe.balloon_sfx)
            clown:play_sound_at(local1)
            wait_for_sound(local1)
            sleep_for(rnd(500, 1000))
            break_here()
        end
        break_here()
    end
end
clown.twist_balloon = function(arg1, arg2) -- line 142
    local local1 = "balloon_" .. arg2
    local local2
    local local3, local4, local5, local6
    local local7, local8
    while find_script(arg1.stop_idle) do
        break_here()
    end
    START_CUT_SCENE()
    if local1 == "balloon_worm" then
        local2 = alloc_object_from_table(fe.balloons)
        if local2 then
            local2:get()
            local2.wav = "getEmBln.wav"
            if clown.given_worm then
                clown:say_line("/fecl052/")
                clown:wait_for_message()
                clown:stop_chore(balloonman_stand, "balloonman.cos")
                clown.is_standing = FALSE
                clown:play_chore(balloonman_bm_takeout_small)
                clown:wait_for_chore(balloonman_bm_takeout_small)
                clown:play_chore_looping(balloonman_hold_small)
                manny:play_chore(ms_hand_on_obj, "ms.cos")
                sleep_for(335)
                manny:stop_chore(ms_hand_on_obj, "ms.cos")
                clown:stop_chore(balloonman_hold_small)
                clown:play_chore(balloonman_give_small)
                manny:play_chore_looping(ms_activate_mt_balloon, "ms.cos")
                manny:play_chore(ms_hand_off_obj, "ms.cos")
                clown:wait_for_chore(balloonman_give_small)
                manny:wait_for_chore(ms_hand_off_obj, "ms.cos")
            else
                clown.given_worm = TRUE
                clown:say_line("/fecl053/")
                wait_for_message()
                clown:stop_chore(balloonman_stand, "balloonman.cos")
                clown:play_chore(balloonman_bm_takeout_small)
                clown.is_standing = FALSE
                clown:wait_for_chore(balloonman_bm_takeout_small)
                clown:play_chore_looping(balloonman_hold_small)
                manny:play_chore(ms_hand_on_obj, "ms.cos")
                sleep_for(335)
                manny:stop_chore(ms_hand_on_obj, "ms.cos")
                clown:stop_chore(balloonman_hold_small)
                clown:play_chore(balloonman_give_small)
                manny:play_chore_looping(ms_activate_mt_balloon, "ms.cos")
                manny:play_chore(ms_hand_off_obj, "ms.cos")
                clown:wait_for_chore(balloonman_give_small)
                manny:wait_for_chore(ms_hand_off_obj, "ms.cos")
                clown:say_line("/fecl054/")
            end
            manny:play_chore_looping(ms_hold, "ms.cos")
            manny.hold_chore = ms_activate_mt_balloon
            manny.is_holding = local2
        else
            clown:say_line("/fecl055/")
            wait_for_message()
            manny:say_line("/fema056/")
            wait_for_message()
            clown:say_line("/fecl057/")
            wait_for_message()
            manny:say_line("/fema058/")
            wait_for_message()
            clown:say_line("/fecl059/")
        end
    else
        if arg2 == "cat" then
            local3 = balloonman_takeout_cat
            local4 = balloonman_hold_cat
            local5 = ms_activate_cat_balloon
        elseif arg2 == "dingo" then
            local3 = balloonman_takeout_dingo
            local4 = balloonman_hold_dingo
            local5 = ms_activate_dingo_balloon
        elseif arg2 == "frost" then
            local3 = balloonman_takeout_rfrost
            local4 = balloonman_hold_rfrost
            local5 = ms_activate_frost_balloon
        end
        clown.is_standing = FALSE
        clown:stop_chore(balloonman_stand, "balloonman.cos")
        clown:play_chore(local3)
        sleep_for(1500)
        local7, local8 = next(fe.balloon_sfx, nil)
        while local7 do
            clown:play_sound_at(local8, 10, 127, 64)
            sleep_for(75)
            local7, local8 = next(fe.balloon_sfx, local7)
        end
        clown:wait_for_chore(local3)
        clown:play_chore(local4)
        clown:head_look_at(manny)
        clown:say_line("/fecl060/")
        wait_for_message()
        manny:play_chore(ms_hand_on_obj, "ms.cos")
        manny:wait_for_chore(ms_hand_on_obj, "ms.cos")
        clown:play_chore(balloonman_give_big)
        manny:play_chore(ms_hand_off_obj, "ms.cos")
        manny:play_chore_looping(local5, "ms.cos")
        clown:wait_for_chore(balloonman_give_big)
        manny:wait_for_chore(ms_hand_off_obj, "ms.cos")
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny.hold_chore = local5
        clown:stop_chore(balloonman_give_big)
        fe[local1]:get()
        manny.is_holding = fe[local1]
    end
    END_CUT_SCENE()
    if not clown.idling then
        start_script(clown.idle, clown)
    end
end
clown.check_balloon = function(arg1, arg2) -- line 261
    local local1 = "balloon_" .. arg2
    PrintDebug("Checking " .. local1 .. "\n")
    PrintDebug("\t(name = " .. tostring(fe[local1].name) .. ")\n")
    if fe[local1].owner == manny or fe[local1].owner == rf.dish then
        PrintDebug("Already has a " .. local1 .. "\n")
        clown:say_line("/fecl061/")
        wait_for_message()
        manny:say_line("/fema062/")
        wait_for_message()
        clown:say_line("/fecl063/")
        return FALSE
    else
        return TRUE
    end
end
fe.NUMBER_OF_PIGEONS = 2
fe.pop_trigger = FALSE
fe.init_pigeons = function() -- line 290
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not pigeons[local1] then
            pigeons[local1] = Actor:create(nil, nil, nil, "pigeon" .. local1)
        end
        pigeons[local1]:set_costume("pigeon_idles.cos")
        pigeons[local1]:set_colormap("pigeons.cmp")
        pigeons[local1]:set_walk_rate(0.80000001)
        pigeons[local1]:set_turn_rate(60)
        pigeons[local1]:ignore_boxes()
        pigeons[local1]:put_in_set(fe)
        if local1 == 1 then
            pigeons[local1]:setpos(0.62441403, 0.050000001, 0.57999998)
        else
            pigeons[local1]:setpos(0.524414, 0.142143, 0.57999998)
        end
        pigeons[local1]:setrot(0, -61, 0)
        start_script(fe.pigeon_brain, pigeons[local1])
    until local1 == fe.NUMBER_OF_PIGEONS
end
fe.wait_here = function(arg1, arg2) -- line 317
    repeat
        if fe.pop_trigger then
            arg2 = 0
        else
            arg2 = arg2 - 1
            sleep_for(100)
        end
    until arg2 <= 0
end
fe.pigeon_turn = function(arg1) -- line 330
    arg1:play_chore(pigeon_idles_jump_for_turn)
    if rnd() then
        arg1:turn_right(90)
    else
        arg1:turn_left(90)
    end
    while not fe.pop_trigger and arg1:is_choring(pigeon_idles_jump_for_turn) do
        break_here()
    end
    arg1:stop_chore(pigeon_idles_jump_for_turn)
end
fe.pigeon_brain = function(arg1) -- line 343
    local local1, local2
    while not fe.pop_trigger do
        if not arg1:is_choring(pigeon_idles_pecking) then
            local1 = start_script(fe.wait_here, arg1, rnd(5, 20))
            if rnd(7) then
                local2 = start_script(fe.pigeon_turn, arg1)
                wait_for_script(local2)
            end
            wait_for_script(local1)
            arg1:play_chore(pigeon_idles_pecking)
        end
        break_here()
    end
    arg1:stop_chore(pigeon_idles_pecking)
    fe.pigeon_obj:make_untouchable()
    local1 = start_script(bird_climb, arg1, 1.25, 2, pigeon_idles_scared_takeoff)
    wait_for_script(local1)
    arg1:put_in_set(nil)
    arg1:stop_chore(nil)
    arg1:set_costume(nil)
end
fe.crowd_idle_script = function(arg1) -- line 370
    fe.crowd_balloons_obj.interest_actor:play_chore_looping(fe_crowd_balloons_idle)
    fe.crowd_obj:play_chore(fe_crowd_idle_here)
    while TRUE do
        fe.crowd_obj:play_chore(fe_crowd_idle_idle)
        fe.crowd_obj:wait_for_chore()
        sleep_for(floor(rnd(500, 3000)))
    end
end
fe.set_up_actors = function(arg1) -- line 382
    fe.crowd_obj:set_object_state("fe_crowd_idle.cos")
    fe.crowd_obj:make_untouchable()
    fe.crowd_balloons_obj:set_object_state("fe_crowd_balloons.cos")
    fe.crowd_balloons_obj:make_untouchable()
    start_script(fe.crowd_idle_script, fe)
    if not fe.pop_trigger then
        fe.init_pigeons()
    else
        fe.pigeon_obj:make_untouchable()
    end
    clown:put_in_set(fe)
    clown:set_talk_color(Cyan)
end
fe.enter = function(arg1) -- line 408
    fe:add_object_state(fe_tntws, "fe_balloon1.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_crowd.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_crowd_balloons.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_foot1.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_foot2.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_foot3.bm", nil, OBJSTATE_UNDERLAY)
    fe:add_object_state(fe_tntws, "fe_foot3top.bm", nil, OBJSTATE_UNDERLAY)
    LoadCostume("ma_reachin_drwr.cos")
    manny.footsteps = footsteps.pavement
    fe:set_up_actors()
    clown:default()
    start_script(clown.idle, clown)
    start_script(clown.squeak, clown)
    fe.clown_obj.interest_actor:put_in_set(fe)
end
fe.exit = function(arg1) -- line 427
    local local1 = 0
    stop_script(fe.pigeon_brain)
    stop_script(fe.wait_here)
    repeat
        local1 = local1 + 1
        pigeons[local1]:free()
    until local1 == fe.NUMBER_OF_PIGEONS
    stop_script(clown.idle)
    stop_script(clown.squeak)
    clown:free()
    stop_script(fe.crowd_idle_script)
    fe.crowd_balloons_obj.interest_actor:set_chore_looping(fe_crowd_balloons_idle, FALSE)
    fe.crowd_balloons_obj.interest_actor:stop_chore(fe_crowd_balloons_idle)
    fe.crowd_obj.interest_actor:set_chore_looping(fe_crowd_idle_idle, FALSE)
    fe.crowd_obj.interest_actor:stop_chore(fe_crowd_idle_idle)
end
fe.clown_obj = Object:create(fe, "/fetx064/clown", 0.60518301, 1.50183, 0.33000001, { range = 1 })
fe.clown_obj.use_pnt_x = 0.96518302
fe.clown_obj.use_pnt_y = 1.5418299
fe.clown_obj.use_pnt_z = -0.1
fe.clown_obj.use_rot_x = 0
fe.clown_obj.use_rot_y = 93.649803
fe.clown_obj.use_rot_z = 0
fe.clown_obj.lookAt = function(arg1) -- line 483
    manny:say_line("/fema065/")
end
fe.clown_obj.use = function(arg1) -- line 487
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if not cl1 then
        if not dofile("dlg_clown.lua") then
            cl1:init()
        end
    else
        cl1:init()
    end
end
fe.clown_obj.use_cat_balloon = function(arg1) -- line 500
    soft_script()
    clown:say_line("/fecl066/")
    wait_for_message()
    clown:say_line("/fecl066b/")
end
fe.clown_obj.use_dingo_balloon = fe.clown_obj.use_cat_balloon
fe.clown_obj.use_frost_balloon = fe.clown_obj.use_cat_balloon
fe.balloon_cat = Object:create(fe, "/fetx067/balloon cat", 0, 0, 0, { range = 0 })
fe.balloon_cat.string_name = "cat_balloon"
fe.balloon_cat.wav = "getBloon.wav"
fe.balloon_cat.lookAt = function(arg1) -- line 516
    manny:say_line("/fema068/")
end
fe.balloon_cat.use = function(arg1) -- line 520
    start_script(ha.random_squeaks, 2)
    manny:use_default()
end
fe.balloon_cat.default_response = function(arg1) -- line 524
    arg1:use()
end
fe.balloon_dingo = Object:create(fe, "/fetx069/balloon dingo", 0, 0, 0, { range = 0 })
fe.balloon_dingo.wav = "getBloon.wav"
fe.balloon_dingo.lookAt = function(arg1) -- line 533
    manny:say_line("/fema070/")
end
fe.balloon_dingo.string_name = "dingo_balloon"
fe.balloon_dingo.use = function(arg1) -- line 538
    start_script(ha.random_squeaks, 2)
    manny:use_default()
end
fe.balloon_dingo.default_response = function(arg1) -- line 543
    arg1:use()
end
fe.balloon_frost = Object:create(fe, "/fetx071/balloon Robert Frost", 0, 0, 0, { range = 0 })
fe.balloon_frost.string_name = "frost_balloon"
fe.balloon_frost.wav = "getBloon.wav"
fe.balloon_frost.lookAt = function(arg1) -- line 552
    manny:say_line("/fema072/")
end
fe.balloon_frost.use = function(arg1) -- line 556
    start_script(ha.random_squeaks, 2)
    manny:use_default()
end
fe.balloon_frost.default_response = function(arg1) -- line 561
    arg1:use()
end
fe.balloons = { }
fe.balloons.balloon1 = Object:create(fe, "/fetx073/red balloon", 0, 0, 0, { range = 0 })
fe.balloons.balloon1.owner = clown
fe.balloons.balloon1.string_name = "mt_balloon"
fe.balloons.balloon1.lookAt = function(arg1) -- line 572
    manny:say_line("/fema074/")
end
fe.balloons.balloon1.use = function(arg1) -- line 575
    manny:say_line("/fema075/")
end
fe.balloons.balloon1.default_response = function(arg1) -- line 578
    manny:say_line("/fema076/")
end
fe.balloons.balloon2 = Object:create(fe, "/fetx077/blue balloon", 0, 0, 0, { range = 0 })
fe.balloons.balloon2.parent = fe.balloons.balloon1
fe.balloons.balloon2.owner = clown
fe.balloons.balloon2.string_name = "mt_balloon"
fe.balloons.balloon3 = Object:create(fe, "/fetx078/green balloon", 0, 0, 0, { range = 0 })
fe.balloons.balloon3.parent = fe.balloons.balloon1
fe.balloons.balloon3.owner = clown
fe.balloons.balloon3.string_name = "mt_balloon"
fe.balloons.balloon4 = Object:create(fe, "/fetx079/orange balloon", 0, 0, 0, { range = 0 })
fe.balloons.balloon4.parent = fe.balloons.balloon1
fe.balloons.balloon4.owner = clown
fe.balloons.balloon4.string_name = "mt_balloon"
fe.balloons.balloon5 = Object:create(fe, "/fetx080/yellow balloon", 0, 0, 0, { range = 0 })
fe.balloons.balloon5.parent = fe.balloons.balloon1
fe.balloons.balloon5.owner = clown
fe.balloons.balloon5.string_name = "mt_balloon"
fe.basket = Object:create(fe, "/fetx081/bread", 0.23299199, 0.53279799, 0.162, { range = 0.69999999 })
fe.basket.use_pnt_x = 0.484375
fe.basket.use_pnt_y = 0.53571498
fe.basket.use_pnt_z = -0.1
fe.basket.use_rot_x = 0
fe.basket.use_rot_y = 106.41
fe.basket.use_rot_z = 0
fe.basket.lookAt = function(arg1) -- line 611
    manny:say_line("/fema082/")
end
fe.basket.pickUp = function(arg1) -- line 616
    local local1
    local1 = alloc_object_from_table(fe.breads)
    if local1 then
        START_CUT_SCENE()
        if not fe.bread_taken then
            fe.bread_taken = TRUE
            manny:say_line("/fema083/")
        else
            manny:say_line("/fema084/")
        end
        manny:walkto_object(arg1)
        manny:push_costume("ma_reachin_drwr.cos")
        manny:play_chore(ma_reachin_drwr_reach_in_grab, "ma_reachin_drwr.cos")
        sleep_for(600)
        manny:play_sound_at("getbread.wav")
        sleep_for(400)
        manny:pop_costume()
        local1:get()
        local1.wav = "getBread.wav"
        manny.is_holding = local1
        manny.hold_chore = ms_activate_bread
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny:play_chore_looping(ms_activate_bread, "ms.cos")
        END_CUT_SCENE()
    else
        manny:say_line("/fema085/")
    end
end
fe.basket.use = fe.basket.pickUp
fe.breads = { }
fe.breads.bread1 = Object:create(fe, "/fetx086/bread", 0, 0, 0, { range = 0.5 })
fe.breads.bread1.big = TRUE
fe.breads.bread1.lookAt = fe.basket.lookAt
fe.breads.bread1.shrink_radius = 0.02
fe.breads.bread1.use = function(arg1) -- line 658
    manny:say_line("/fema087/")
end
fe.breads.bread1.default_response = function(arg1) -- line 662
    manny:say_line("/fema088/")
end
fe.breads.bread2 = Object:create(sp, "/sptx025/bread", 0, 0, 0, { range = 0 })
fe.breads.bread2.parent = fe.breads.bread1
fe.breads.bread2.owner = fe.basket
fe.breads.bread2.big = TRUE
fe.breads.bread2.shrink_radius = 0.02
fe.breads.bread3 = Object:create(sp, "/sptx026/bread", 0, 0, 0, { range = 0 })
fe.breads.bread3.parent = fe.breads.bread1
fe.breads.bread3.owner = fe.basket
fe.breads.bread3.big = TRUE
fe.breads.bread3.shrink_radius = 0.02
fe.breads.bread4 = Object:create(sp, "/sptx027/bread", 0, 0, 0, { range = 0 })
fe.breads.bread4.parent = fe.breads.bread1
fe.breads.bread4.owner = fe.basket
fe.breads.bread4.shrink_radius = 0.02
fe.breads.bread4.big = TRUE
fe.breads.bread5 = Object:create(sp, "/sptx028/bread", 0, 0, 0, { range = 0 })
fe.breads.bread5.parent = fe.breads.bread1
fe.breads.bread5.owner = fe.basket
fe.breads.bread5.shrink_radius = 0.02
fe.breads.bread5.big = TRUE
fe.crates = Object:create(fe, "/fetx093/crates", 0.62469202, 2.34111, 0.25, { range = 0.80000001 })
fe.crates.use_pnt_x = 0.81169498
fe.crates.use_pnt_y = 1.7
fe.crates.use_pnt_z = -0.1
fe.crates.use_rot_x = 0
fe.crates.use_rot_y = -356.51199
fe.crates.use_rot_z = 0
fe.crates.lookAt = function(arg1) -- line 700
    soft_script()
    manny:say_line("/fema094/")
    wait_for_message()
    manny:say_line("/fema095/")
end
fe.crates.pickUp = function(arg1) -- line 707
    system.default_response("hernia")
end
fe.crates.use = function(arg1) -- line 711
    manny:say_line("/fema096/")
end
fe.pigeon_obj = Object:create(fe, "/fetx097/pigeon", 0.52977502, 0.148156, 0.62127602, { range = 0.80000001 })
fe.pigeon_obj.use_pnt_x = 1.2297699
fe.pigeon_obj.use_pnt_y = 0.358156
fe.pigeon_obj.use_pnt_z = -0.098723799
fe.pigeon_obj.use_rot_x = 0
fe.pigeon_obj.use_rot_y = 76.703201
fe.pigeon_obj.use_rot_z = 0
fe.pigeon_obj.lookAt = function(arg1) -- line 725
    rf.pigeons1:use()
end
fe.pigeon_obj.pickUp = function(arg1) -- line 729
    rf.pigeons1:pickUp()
end
fe.pigeon_obj.use = function(arg1) -- line 733
    rf.pigeons1:pickUp()
end
fe.pigeon_obj.use_bread = function(arg1) -- line 738
    rf.pigeons1:use_bread()
end
fe.crowd_obj = Object:create(fe, "crowd", 0.21868201, 2.3699999, 0.34999999, { range = 0.60000002 })
fe.crowd_obj.use_pnt_x = 0.72868198
fe.crowd_obj.use_pnt_y = 1.7
fe.crowd_obj.use_pnt_z = -0.1
fe.crowd_obj.use_rot_x = 0
fe.crowd_obj.use_rot_y = 33.619701
fe.crowd_obj.use_rot_z = 0
fe.crowd_balloons_obj = Object:create(fe, "balloons", 0.21868201, 2.3699999, 0.34999999, { range = 0.60000002 })
fe.crowd_balloons_obj.use_pnt_x = 0.72868198
fe.crowd_balloons_obj.use_pnt_y = 1.7
fe.crowd_balloons_obj.use_pnt_z = -0.1
fe.crowd_balloons_obj.use_rot_x = 0
fe.crowd_balloons_obj.use_rot_y = 33.619701
fe.crowd_balloons_obj.use_rot_z = 0
fe.st_door = Object:create(fe, "/fetx089/street", 2.3952601, 0.41424999, 0.33000001, { range = 0 })
fe.fe_st_box1 = fe.st_door
fe.fe_st_box2 = fe.st_door
fe.fe_st_box3 = fe.st_door
fe.st_door.use_pnt_x = 1.903
fe.st_door.use_pnt_y = 0.546
fe.st_door.use_pnt_z = -0.097999997
fe.st_door.use_rot_x = 0
fe.st_door.use_rot_y = -107.593
fe.st_door.use_rot_z = 0
fe.st_door.out_pnt_x = 2.076
fe.st_door.out_pnt_y = 0.62400001
fe.st_door.out_pnt_z = -0.097999997
fe.st_door.out_rot_x = 0
fe.st_door.out_rot_y = -71.818398
fe.st_door.out_rot_z = 0
fe.st_door:open(TRUE)
fe.st_door.walkOut = function(arg1) -- line 810
    local local1, local2, local3
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    st:switch_to_set()
    manny:put_in_set(st)
    manny:setpos(local1, local2, 0)
    if manny:find_sector_name("curb1") then
        manny:setpos(1.5, 2, 0.60000002)
    end
end

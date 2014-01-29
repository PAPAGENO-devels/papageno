CheckFirstTime("mx.lua")
mx = Set:create("mx.set", "maximinos office", { mx_ofcws = 0, mx_ofcws1 = 0, mx_ofcws2 = 0, mx_diarv = 1, mx_manny = 1, mx_maxcu = 2, mx_max = 2, mx_ovrhd = 3 })
mx.shrinkable = 0.015
dofile("dlg_maximino.lua")
dofile("maximino_idles.lua")
dofile("max_walk.lua")
mx.set_up_actors = function(arg1) -- line 18
    if not maximino then
        maximino = Actor:create(nil, nil, nil, "Maximino")
    end
    maximino:set_costume("maximino_idles.cos")
    maximino:put_in_set(mx)
    maximino:setpos(0, -0.75, 0.2)
    maximino.stop_idle = FALSE
    maximino:set_mumble_chore(maximino_idles_mumble)
    maximino:set_talk_chore(1, maximino_idles_no_talk)
    maximino:set_talk_chore(2, maximino_idles_a)
    maximino:set_talk_chore(3, maximino_idles_c)
    maximino:set_talk_chore(4, maximino_idles_e)
    maximino:set_talk_chore(5, maximino_idles_f)
    maximino:set_talk_chore(6, maximino_idles_l)
    maximino:set_talk_chore(7, maximino_idles_m)
    maximino:set_talk_chore(8, maximino_idles_o)
    maximino:set_talk_chore(9, maximino_idles_t)
    maximino:set_talk_chore(10, maximino_idles_u)
    maximino:set_turn_rate(120)
    maximino:follow_boxes()
    maximino:setrot(0, 180, 0)
    start_script(mx.maximino_idles)
    start_sfx("DorOfOp.WAV", nil, 60)
end
mx.maximino_idles = function(arg1) -- line 44
    local local1
    local local2
    local local3 = maximino:getrot()
    maximino.stop_idle = FALSE
    if arg1 then
        maximino:push_costume("max_walk.cos")
        maximino:play_chore_looping(max_walk_walk)
        maximino:setrot(0, 180, 0, TRUE)
        maximino:wait_for_actor()
        maximino:stop_chore(max_walk_walk)
        maximino:pop_costume()
    end
    while not maximino.stop_idle do
        local2 = rndint(2)
        if local2 == 0 then
            maximino:play_chore(maximino_idles_look_left)
            maximino:wait_for_chore(maximino_idles_look_left)
            maximino:stop_chore(maximino_idles_look_left)
            maximino:play_chore_looping(maximino_idles_hold_left)
            local1 = rndint(8)
            repeat
                sleep_for(500)
                local1 = local1 - 1
            until local1 <= 0 or maximino.stop_idle
            maximino:stop_chore(maximino_idles_hold_left)
            maximino:play_chore(maximino_idles_left_forward)
            maximino:wait_for_chore(maximino_idles_left_forward)
        elseif local2 == 1 then
            maximino:play_chore(maximino_idles_look_right)
            maximino:wait_for_chore(maximino_idles_look_right)
            maximino:stop_chore(maximino_idles_look_right)
            maximino:play_chore_looping(maximino_idles_hold_right)
            local1 = rndint(8)
            repeat
                sleep_for(500)
                local1 = local1 - 1
            until local1 <= 0 or maximino.stop_idle
            maximino:stop_chore(maximino_idles_hold_right)
            maximino:play_chore(maximino_idles_right_forward)
            maximino:wait_for_chore(maximino_idles_right_forward)
        else
            maximino:play_chore(maximino_idles_to_smoke)
            maximino:wait_for_chore(maximino_idles_to_smoke)
            maximino:stop_chore(maximino_idles_to_smoke)
            maximino:play_chore_looping(maximino_idles_smoke)
            local1 = rndint(8)
            repeat
                sleep_for(500)
                local1 = local1 - 1
            until local1 <= 0 or maximino.stop_idle
            maximino:stop_chore(maximino_idles_smoke)
            maximino:play_chore(maximino_idles_smoke_done)
            maximino:wait_for_chore(maximino_idles_smoke_done)
        end
        local1 = rndint(8)
        repeat
            sleep_for(500)
            local1 = local1 - 1
        until local1 <= 0 or maximino.stop_idle
        maximino:stop_chore(maximino_idles_right_forward)
        maximino:stop_chore(maximino_idles_left_forward)
    end
    maximino:push_costume("max_walk.cos")
    maximino:play_chore_looping(max_walk_walk)
    maximino:setrot(0, 380, 0, TRUE)
    maximino:wait_for_actor()
    maximino:stop_chore(max_walk_walk)
    maximino:pop_costume()
    maximino:play_chore(maximino_idles_forward_hold)
end
mx.footstep_monitor = function(arg1) -- line 123
    while system.currentSet == mx do
        if manny:find_sector_name("carpet_box") then
            if manny.footsteps ~= footsteps.rug then
                manny.footsteps = footsteps.rug
            end
        elseif manny:find_sector_name("marble_box") then
            if manny.footsteps ~= footsteps.marble then
                manny.footsteps = footsteps.marble
            end
        end
        break_here()
    end
end
mx.enter = function(arg1) -- line 138
    start_script(mx.footstep_monitor, mx)
    mx:set_up_actors()
end
mx.exit = function(arg1) -- line 143
    stop_script(mx.footstep_monitor)
    maximino:free()
    stop_script(mx.maximino_idles)
end
mx.intro_trigger = { }
mx.intro_trigger.walkOut = function(arg1) -- line 155
    START_CUT_SCENE()
    MakeSectorActive("intro_trigger", FALSE)
    mx.met_max = TRUE
    maximino.stop_idle = TRUE
    manny:walkto(-0.176439, 0.512355, 0.2, 0, -158.102, 0)
    manny:say_line("/mxma052/")
    wait_for_message()
    mx:current_setup(mx_maxcu)
    sleep_for(300)
    maximino:say_line("/mxmx053/")
    maximino:wait_for_message()
    maximino:say_line("/mxmx054/")
    maximino:wait_for_message()
    wait_for_script(mx.maximino_idles)
    manny:say_line("/mxma055/")
    maximino:play_chore(maximino_idles_to_smoke)
    maximino:wait_for_chore(maximino_idles_to_smoke)
    maximino:stop_chore(maximino_idles_to_smoke)
    maximino:play_chore(maximino_idles_smoke_done)
    maximino:wait_for_chore(maximino_idles_smoke_done)
    manny:wait_for_message()
    maximino:say_line("/mxmx056/")
    maximino:play_chore(maximino_idles_cig_gesture)
    maximino:wait_for_message()
    maximino:say_line("/mxmx057/")
    maximino:wait_for_chore()
    maximino:wait_for_message()
    END_CUT_SCENE()
    Dialog:run("mx1", "dlg_maximino.lua")
end
mx.trophies1 = Object:create(mx, "/mxtx058/trophies", -1.245, 1.55, 0.55000001, { range = 0.80000001 })
mx.trophies1.use_pnt_x = -0.82483399
mx.trophies1.use_pnt_y = 1.29995
mx.trophies1.use_pnt_z = 0.2
mx.trophies1.use_rot_x = 0
mx.trophies1.use_rot_y = -982.16699
mx.trophies1.use_rot_z = 0
mx.trophies1.lookAt = function(arg1) -- line 196
    if not mx.trophies1.seen then
        mx.trophies1.seen = TRUE
        START_CUT_SCENE()
        manny:say_line("/mxma059/")
        wait_for_message()
        time_to_look = FALSE
        manny:head_look_at(mx.max_obj)
        maximino:say_line("/mxmx072/")
        wait_for_message()
        END_CUT_SCENE()
        if not mx.met_max then
            mx.intro_trigger:walkOut()
        end
        time_to_look = TRUE
    else
        manny:say_line("/mxma061/")
    end
end
mx.trophies1.pickUp = function(arg1) -- line 217
    manny:say_line("/mxma062/")
    mx.trophies1.know_max()
end
mx.trophies1.know_max = function(arg1) -- line 222
    START_CUT_SCENE()
    wait_for_message()
    time_to_look = FALSE
    manny:head_look_at(mx.max_obj)
    maximino:say_line("/mxmx063/")
    wait_for_message()
    END_CUT_SCENE()
    if not mx.met_max then
        mx.intro_trigger:walkOut()
    end
    time_to_look = TRUE
end
mx.trophies1.use = mx.trophies1.pickUp
mx.silver_cup = Object:create(mx, "/mxtx064/silver cup", -1.325, 1.58, 0.97000003, { range = 1 })
mx.silver_cup.use_pnt_x = -0.82483399
mx.silver_cup.use_pnt_y = 1.29995
mx.silver_cup.use_pnt_z = 0.2
mx.silver_cup.use_rot_x = 0
mx.silver_cup.use_rot_y = -982.16699
mx.silver_cup.use_rot_z = 0
mx.silver_cup.parent = mx.trophies1
mx.gold_cups = Object:create(mx, "/mxtx065/gold cups", -1.325, 1.58, 1.27, { range = 1.3 })
mx.gold_cups.use_pnt_x = -0.82483399
mx.gold_cups.use_pnt_y = 1.29995
mx.gold_cups.use_pnt_z = 0.2
mx.gold_cups.use_rot_x = 0
mx.gold_cups.use_rot_y = -982.16699
mx.gold_cups.use_rot_z = 0
mx.gold_cups.parent = mx.trophies1
mx.gold_cat = Object:create(mx, "/mxtx066/statue", -1.115, 0.99000001, 1.08, { range = 1.1 })
mx.gold_cat.use_pnt_x = -0.82483399
mx.gold_cat.use_pnt_y = 1.29995
mx.gold_cat.use_pnt_z = 0.2
mx.gold_cat.use_rot_x = 0
mx.gold_cat.use_rot_y = -935.56097
mx.gold_cat.use_rot_z = 0
mx.gold_cat.lookAt = function(arg1) -- line 266
    manny:say_line("/mxma067/")
    if not mx.met_max then
        mx.trophies1.know_max()
    end
end
mx.gold_cat.pickUp = mx.trophies1.pickUp
mx.gold_cat.use = mx.trophies1.pickUp
mx.max_obj = Object:create(mx, "/mxtx068/Maximino", 0.138988, -0.42385501, 0.700001, { range = 1.2 })
mx.max_obj.use_pnt_x = -0.29101199
mx.max_obj.use_pnt_y = 0.146145
mx.max_obj.use_pnt_z = 0.2
mx.max_obj.use_rot_x = 0
mx.max_obj.use_rot_y = -1199.86
mx.max_obj.use_rot_z = 0
mx.max_obj.lookAt = function(arg1) -- line 285
    manny:say_line("/mxma069/")
end
mx.max_obj.use = function(arg1) -- line 289
    if hl.glottis_gambling and not mx1[90].said then
        mx1[90].off = FALSE
        mx1.talked_out = FALSE
    end
    if not mx1.talked_out then
        maximino.stop_idle = TRUE
        START_CUT_SCENE()
        manny:walkto(-0.176439, 0.512355, 0.2, 0, -158.102, 0)
        END_CUT_SCENE()
    end
    Dialog:run("mx1", "dlg_maximino.lua")
end
mx.max_obj.use_blackmail = function(arg1) -- line 303
    START_CUT_SCENE()
    manny:say_line("/hlma176/")
    manny:twist_head_gesture()
    manny:wait_for_message()
    manny:walkto(arg1)
    sleep_for(500)
    manny:walkto(-0.0844607, 0.390257, 0.2, 0, 5.6355, 0)
    manny:wait_for_actor()
    manny:say_line("/moma034/")
    manny:clear_hands()
    END_CUT_SCENE()
end
mx.hl_door = Object:create(mx, "/mxtx070/door", -0.0068274802, 2.6709199, 0.44999999, { range = 0.60000002 })
mx.hl_door.use_pnt_x = -0.0068274802
mx.hl_door.use_pnt_y = 2.4509201
mx.hl_door.use_pnt_z = 0
mx.hl_door.use_rot_x = 0
mx.hl_door.use_rot_y = 0.56473798
mx.hl_door.use_rot_z = 0
mx.hl_door.out_pnt_x = -0.0082965503
mx.hl_door.out_pnt_y = 2.5999999
mx.hl_door.out_pnt_z = 0
mx.hl_door.out_rot_x = 0
mx.hl_door.out_rot_y = 0.56473798
mx.hl_door.out_rot_z = 0
mx.hl_box = mx.hl_door
mx.hl_door.lookAt = function(arg1) -- line 339
    manny:say_line("/mxma071/")
end
mx.hl_door.walkOut = function(arg1) -- line 343
    start_sfx("DorOfOp.WAV", nil, 60)
    hl:come_out_door(hl.mx_door)
end

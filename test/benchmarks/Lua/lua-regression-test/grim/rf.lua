CheckFirstTime("rf.lua")
dofile("pigeon_idles.lua")
dofile("ma_crumble_bread.lua")
rf = Set:create("rf.set", "Roof", { rf_nstoh = 0, rf_rufha = 1, rf_rufha2 = 1, rf_rufha3 = 1, rf_rufws = 2, rf_rufws2 = 2, rf_overhead = 3, rf_pigeon = 4 })
rf.camera_adjusts = { 320, 340, 25 }
rf.cheat_boxes = { rf_cheat_box_1 = 1, rf_cheat_box_2 = 2 }
rf.set_up_actors = function(arg1) -- line 34
    if not ma_crumble_bread_cos then
        ma_crumble_bread_cos = "ma_crumble_bread.cos"
    end
    rf.escape_point_1:set_object_state("le_copals_windows.cos")
    rf.escape_point_2:set_object_state("le_open_doms_window.cos")
    rf.escape_point_1.interest_actor:play_chore(0)
    rf.escape_point_2.interest_actor:complete_chore(0)
    rf.escape_point_1.touchable = FALSE
    rf.escape_point_2.touchable = FALSE
    if rf.pigeons_gone then
        MakeSectorActive("bird_threshhold", TRUE)
        MakeSectorActive("rf_nstoh", TRUE)
        rf.pigeons1:stop_chore(0)
        rf.pigeons1:play_chore(1)
        rf.pigeons1:make_untouchable()
        rf.pigeons2:make_untouchable()
        rf.pigeons3:make_untouchable()
    else
        rf.init_pigeons()
        rf.pigeons1:set_object_state("pigeon_os.cos")
        rf.pigeons1:play_chore_looping(0)
        MakeSectorActive("bird_threshhold", FALSE)
        MakeSectorActive("rf_nstoh", FALSE)
    end
    if not rf.egg_actor then
        rf.egg_actor = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor1 = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor2 = Actor:create(nil, nil, nil, "egg_actor")
        rf.egg_actor3 = Actor:create(nil, nil, nil, "egg_actor")
    end
    if rf.eggs.owner ~= manny then
        rf.egg_actor:put_in_set(rf)
        rf.egg_actor:setpos(-13.43, 11.2, 4.28)
        rf.egg_actor:setrot(0, -334.498, 0)
        rf.egg_actor:set_costume("eggs.cos")
    end
    rf.egg_actor1:put_in_set(rf)
    rf.egg_actor1:setpos(-13.4255, 11.3217, 4.3)
    rf.egg_actor1:setrot(0, 210, 0)
    rf.egg_actor1:set_costume("eggs.cos")
    rf.egg_actor2:put_in_set(rf)
    rf.egg_actor2:setpos(-13.5055, 11.3117, 4.29)
    rf.egg_actor2:setrot(0, 90, 0)
    rf.egg_actor2:set_costume("eggs.cos")
    rf.egg_actor3:put_in_set(rf)
    rf.egg_actor3:setpos(-13.4602, 11.245, 4.31)
    rf.egg_actor3:setrot(0, -334.498, 0)
    rf.egg_actor3:set_costume("eggs.cos")
end
rf.balloon_placement = { }
rf.balloon_placement.cat = { }
rf.balloon_placement.dingo = { }
rf.balloon_placement.frost = { }
rf.balloon_placement["cat"].x = -11.3502
rf.balloon_placement["cat"].y = 7.77496
rf.balloon_placement["cat"].z = 3.8199999
rf.balloon_placement["cat"].cos = "cat_balloon.cos"
rf.balloon_placement["cat"]["r"] = -54.182598
rf.balloon_placement["dingo"].x = -11.3502
rf.balloon_placement["dingo"].y = 7.77496
rf.balloon_placement["dingo"].z = 3.77
rf.balloon_placement["dingo"]["r"] = -57.493099
rf.balloon_placement["dingo"].cos = "dingo_balloon.cos"
rf.balloon_placement["frost"].x = -11.3802
rf.balloon_placement["frost"].y = 7.7449598
rf.balloon_placement["frost"].z = 3.8199999
rf.balloon_placement["frost"]["r"] = -57.493099
rf.balloon_placement["frost"].cos = "frost_balloon.cos"
rf.update_states = function(arg1) -- line 127
    local local1
    if not dish_item_actor then
        dish_item_actor = Actor:create(nil, nil, nil, "dish item")
    end
    if rf.dish.contains then
        if rf.dish.contains == fe.balloon_cat then
            local1 = "cat"
        elseif rf.dish.contains == fe.balloon_dingo then
            local1 = "dingo"
        elseif rf.dish.contains == fe.balloon_frost then
            local1 = "frost"
        end
        dish_item_actor:set_costume(rf.balloon_placement[local1].cos)
        dish_item_actor:put_in_set(rf)
        dish_item_actor:setpos(rf.balloon_placement[local1].x, rf.balloon_placement[local1].y, rf.balloon_placement[local1].z)
        dish_item_actor:setrot(0, rf.balloon_placement[local1].r, 0)
        dish_item_actor:scale(0.80000001)
        dish_item_actor:set_colormap("items_more.cmp")
    else
        dish_item_actor:free()
    end
    if rf.pigeons_gone then
        MakeSectorActive("bird_threshhold", TRUE)
        MakeSectorActive("rf_nstoh", TRUE)
        rf.pigeons1.touchable = FALSE
        rf.pigeons2.touchable = FALSE
        rf.pigeons3.touchable = FALSE
        rf.pigeons1:stop_chore(0)
        rf.pigeons1:play_chore(1)
    else
        rf.pigeons1.touchable = TRUE
        rf.pigeons2.touchable = TRUE
        rf.pigeons3.touchable = TRUE
        rf.pigeons1:play_chore_looping(0)
    end
end
rf.pigeon_liftoff = function(arg1) -- line 174
    while 1 do
        arg1:offsetBy(0, 0, rnd(0.008, 0.03))
        break_here()
    end
end
rf.pigeon_mover = function(arg1) -- line 181
    local local1 = 0
    local local2 = { }
    arg1.costume_marker_handler = nil
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    sleep_for(rnd(500, 1000))
    repeat
        arg1:setpos(-1, 4.5, 4.54)
        local2 = arg1:getpos()
        PointActorAt(arg1.hActor, 4.1999998, rnd(3.5, 6), 4.54)
        arg1:play_sound_at("flockFly.wav")
        while local2.x <= 2 do
            arg1:walk_forward()
            break_here()
            local2 = arg1:getpos()
        end
        local1 = local1 + 1
    until local1 == 3
end
rf.pigeons_eat_bread = function() -- line 201
    local local1 = 1
    START_CUT_SCENE()
    cur_puzzle_state[9] = TRUE
    if rf.dish_contains then
        rf.dish_contains:free()
    end
    rf.pigeons_gone = TRUE
    rf.dish.contains = nil
    stop_script(rf.pigeon_brain)
    stop_script(rf.pigeon_attack)
    stop_script(rf.fly_fly_fly)
    stop_script(rf.pigeon_eat)
    stop_script(rf.turn_toward_home)
    stop_script(bird_climb)
    stop_script(rf.pigeon_walk)
    stop_sound("flockeat.imu")
    sleep_for(100)
    start_sfx("bloonpop.wav")
    prop_pigeon:stop_chore(nil)
    prop_pigeon:push_chore(pigeon_idles_scared_takeoff)
    prop_pigeon:push_chore()
    dish_item_actor:free()
    start_script(rf.pigeon_liftoff, prop_pigeon)
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:play_chore(pigeon_idles_scared_takeoff)
        sleep_for(rnd(50, 150))
        start_script(rf.pigeon_liftoff, pigeons[local1])
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    local1 = 1
    sleep_for(1500)
    prop_pigeon:stop_chore(nil)
    prop_pigeon:put_in_set(nil)
    stop_script(rf.pigeon_liftoff)
    le:init_ropes()
    rf.pigeons1:stop_chore(0)
    rf.pigeons1:play_chore(1)
    rf:current_setup(rf_pigeon)
    local1 = 1
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:set_walk_rate(rnd(1, 2))
        start_script(rf.pigeon_mover, pigeons[local1])
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    sleep_for(6000)
    rf:set_up_actors()
    rf:current_setup(rf_rufws)
    rf.pigeons1:stop_chore(0)
    rf.pigeons1:play_chore(1)
    stop_script(rf.pigeon_mover)
    local1 = 1
    repeat
        pigeons[local1]:stop_chore(nil)
        pigeons[local1]:put_in_set(nil)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    break_here()
    rf.sky:make_touchable()
    manny:head_look_at(rf.sky)
    wait_for_message()
    music_state:set_sequence(seqLedgepeckers)
    sleep_for(3000)
    manny:say_line("/rfma054/")
    wait_for_message()
    rf.pigeons1:free_object_state()
    rf.sky:make_untouchable()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
rf.show_eggs = function(arg1) -- line 296
    local local1 = 1
    START_CUT_SCENE()
    set_override(rf.show_eggs_override, rf)
    rf:current_setup(rf_nstoh)
    local1 = 1
    repeat
        pigeons[local1]:moveto(rnd(-13, -12.575), rnd(10.35, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    sleep_for(3000)
    rf:current_setup(rf_rufha)
    break_here()
    local1 = 1
    repeat
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    END_CUT_SCENE()
end
rf.show_eggs_override = function(arg1) -- line 321
    local local1 = 1
    repeat
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), 3.72)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
end
rf.show_eggs_override = function(arg1, arg2) -- line 329
    rf:current_setup(rf_rufha)
    local local1 = 1
    repeat
        pigeons[local1]:set_chore_looping(pigeon_idles_pecking, FALSE)
        pigeons[local1]:set_chore_looping(pigeon_idles_jump_for_turn, FALSE)
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    if arg2 then
        kill_override()
    end
end
BZ_X = -13.25
BZ_7 = 10.45
BZ_Z = 3.72
rf.NUMBER_OF_PIGEONS = 7
FLY_SPEED = 0.80000001
PIGEON_GLIDE_SPEED = 0.5
PIGEON_WALK_SPEED = 0.1
pigeons = { }
birdidle = { }
birdidle[1] = pigeon_idles_pecking
birdidle[2] = pigeon_idles_lead_to_walk
birdidle[3] = pigeon_idles_jump_for_turn
birdidle[4] = pigeon_idles_head_turns
rf.all_pigeons_pecking = nil
rf.kill_pigeons = nil
rf.seen_birds = nil
rf.no_attack_manny = FALSE
rf.default_pigeon = function(arg1, arg2) -- line 383
    arg1:set_costume("pigeon_idles.cos")
    arg1:set_colormap("pigeons.cmp")
    arg1:set_walk_rate(PIGEON_WALK_SPEED)
    arg1:set_turn_rate(90)
    arg1:ignore_boxes()
end
rf.pigeon_walk = function(arg1) -- line 398
    arg1:play_chore(pigeon_idles_lead_to_walk)
    arg1:wait_for_chore()
    arg1:play_chore(pigeon_idles_walk_cycle)
    while arg1:is_choring() do
        arg1:walk_forward()
        break_here()
    end
    arg1:play_chore(pigeon_idles_stopwalk_cycle)
    while arg1:is_choring() do
        arg1:walk_forward()
        break_here()
    end
    if not arg1:find_sector_name("bird_zone") then
        repeat
            PointActorAt(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z)
            arg1:play_chore(pigeon_idles_lead_to_walk)
            arg1:wait_for_chore()
            arg1:play_chore(pigeon_idles_walk_cycle)
            while arg1:is_choring() do
                arg1:walk_forward()
                break_here()
            end
            arg1:play_chore(pigeon_idles_stopwalk_cycle)
            while arg1:is_choring() do
                arg1:walk_forward()
                break_here()
            end
        until arg1:find_sector_name("bird_zone")
    end
end
rf.turn_toward_home = function(arg1) -- line 439
    arg1:set_turn_rate(90)
    while TurnActorTo(arg1.hActor, arg1.start_pnt.x, arg1.start_pnt.y, arg1.start_pnt.z) do
        arg1:walk_forward()
        break_here()
    end
    while 1 do
        arg1:walk_forward()
        break_here()
    end
end
rf.fly_fly_fly = function(arg1) -- line 461
    arg1:set_turn_rate(250)
    while 1 do
        while TurnActorTo(arg1.hActor, manny.hActor) do
            arg1:walk_forward()
            if proximity(arg1, manny) < 0.65 then
                if not find_script(rf.manny_flee) then
                    start_script(rf.manny_flee)
                end
            end
            break_here()
        end
        arg1:walk_forward()
        break_here()
    end
end
rf.pigeon_attack = function(arg1) -- line 488
    local local1
    local local2
    local local3 = { }
    if not inventory_disabled then
        inventory_disabled = TRUE
    end
    arg1:set_walk_rate(FLY_SPEED)
    local1 = start_script(rf.fly_fly_fly, arg1)
    foo2 = start_script(bird_climb, arg1, arg1.height, 1.6, pigeon_idles_scared_takeoff)
    wait_for_script(foo2)
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    while manny:find_sector_name("attack_zone") or manny:find_sector_name("attack_box") do
        break_here()
    end
    stop_sound("rfPigMus.imu")
    if inventory_disabled then
        inventory_disabled = FALSE
    end
    repeat
        local3 = arg1:getpos()
        local2 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (1 - 1) ^ 2)
        break_here()
    until local2 > 2
    stop_script(local1)
    local1 = start_script(rf.turn_toward_home, arg1)
    arg1:set_chore_looping(pigeon_idles_fly_cycle, FALSE)
    arg1:wait_for_chore()
    SetActorWalkRate(arg1.hActor, PIGEON_GLIDE_SPEED)
    arg1:play_chore(pigeon_idles_glide_hook_up)
    arg1:wait_for_chore()
    arg1:play_chore_looping(pigeon_idles_glide)
    repeat
        local3 = arg1:getpos()
        local2 = sqrt((local3.x - arg1.start_pnt.x) ^ 2 + (local3.y - arg1.start_pnt.y) ^ 2 + (1 - 1) ^ 2)
        if local3.z > 3.95 then
            arg1:setpos(local3.x, local3.y, local3.z - 0.0040000002)
        end
        break_here()
    until local2 < 1
    arg1:set_chore_looping(pigeon_idles_glide, FALSE)
    foo2 = start_script(bird_climb, arg1, arg1.start_pnt.z, 1, pigeon_idles_landing)
    wait_for_script(foo2)
    stop_script(local1)
    local3 = arg1:getpos()
    arg1:setpos(local3.x, local3.y, BZ_Z)
    arg1:set_walk_rate(PIGEON_WALK_SPEED)
end
rf.turn_to_food = function(arg1) -- line 558
    arg1:set_turn_rate(250)
    while TurnActorTo(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z) do
        arg1:walk_forward()
        break_here()
    end
    while 1 do
        arg1:walk_forward()
        break_here()
    end
end
rf.pigeon_eat = function(arg1) -- line 577
    local local1, local2
    local local3
    local local4 = { }
    local local5
    local local6
    local local7 = FALSE
    arg1.height = 4.0999999
    arg1:set_walk_rate(FLY_SPEED)
    local1 = start_script(rf.turn_to_food, arg1)
    local2 = start_script(bird_climb, arg1, arg1.height, 1.6, pigeon_idles_scared_takeoff)
    wait_for_script(local2)
    arg1:play_chore_looping(pigeon_idles_fly_cycle)
    repeat
        local4 = arg1:getpos()
        local3 = sqrt((local4.x - arg1.eat_pnt.x) ^ 2 + (local4.y - arg1.eat_pnt.y) ^ 2)
        break_here()
    until local3 < 1.5
    stop_script(local1)
    local4 = arg1:getpos()
    while local3 >= 0.050000001 do
        if not TurnActorTo(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z) then
            PointActorAt(arg1.hActor, arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
        end
        local3 = sqrt((local4.x - arg1.eat_pnt.x) ^ 2 + (local4.y - arg1.eat_pnt.y) ^ 2)
        local5 = tan(15) * local3
        local5 = local5 + arg1.eat_pnt.z
        local6 = GetActorWalkRate(arg1.hActor)
        if local6 >= local3 then
            if not local7 then
                local7 = TRUE
                arg1:stop_chore(pigeon_idles_fly_cycle)
                arg1:play_chore(pigeon_idles_landing)
            end
        end
        if PerSecond(local6) > local3 then
            arg1:set_walk_rate(local3)
        end
        arg1:walk_forward()
        local4 = arg1:getpos()
        arg1:setpos(local4.x, local4.y, local5)
        break_here()
        if local7 and not arg1:is_choring(pigeon_idles_landing) then
            arg1:setpos(arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
            arg1:setrot(arg1.eat_rot.x, arg1.eat_rot.y, arg1.eat_rot.z)
        end
    end
    arg1:setpos(arg1.eat_pnt.x, arg1.eat_pnt.y, arg1.eat_pnt.z)
    arg1:setrot(arg1.eat_rot.x, arg1.eat_rot.y, arg1.eat_rot.z)
    arg1:wait_for_chore()
    arg1:play_chore_looping(pigeon_idles_pecking)
    arg1.eating = TRUE
    while not rf.all_pigeons_pecking do
        break_here()
    end
    arg1:set_chore_looping(pigeon_idles_pecking, FALSE)
    arg1:wait_for_chore()
    arg1.height = arg1.height + 0.0099999998
    local1 = start_script(rf.pigeon_attack, arg1)
    wait_for_script(local1)
    arg1.eating = FALSE
end
rf.wait_for_pigeons = function() -- line 660
    local local1 = 1
    local local2 = 0
    local local3
    rf.all_pigeons_pecking = FALSE
    repeat
        if pigeons[local1].eating then
            if local1 == 1 then
                start_sfx("flockeat.imu")
                local3 = start_script(rf.diminish_bread_pile)
            end
            local1 = local1 + 1
        else
            break_here()
        end
        local2 = local2 + 1
    until local1 > rf.NUMBER_OF_PIGEONS or local2 > 500
    if not local3 then
        local3 = start_script(rf.diminish_bread_pile)
    end
    wait_for_script(local3)
    rf.all_pigeons_pecking = TRUE
    rf.dish_contains = nil
    if rf.kill_pigeons then
        stop_script(rf.pigeon_brain)
        stop_script(rf.pigeon_eat)
        stop_script(rf.pigeon_attack)
        start_script(rf.pigeons_eat_bread)
    end
end
pigeon_coo_sfx = { "pigeon1.wav", "pigeon2.wav", "pigeon3.wav", "pigeon4.wav", "pigeon5.wav", "pigeon6.wav", "pigeon7.wav", "pigeon8.wav" }
rf.pigeon_brain = function(arg1) -- line 703
    local local1
    local local2
    local local3
    arg1.start_pnt = arg1:getpos()
    break_here()
    while TRUE do
        if manny:find_sector_name("attack_zone") or manny:find_sector_name("attack_box") and not rf.no_attack_manny then
            single_start_sfx("rfPigMus.imu")
            arg1.height = arg1.start_pnt.z + rnd(0.51999998, 0.62)
            local2 = start_script(rf.pigeon_attack, arg1)
            wait_for_script(local2)
            arg1:play_chore(pigeon_idles_standing)
        elseif find_script(rf.wait_for_pigeons) then
            local2 = start_script(rf.pigeon_eat, arg1)
            wait_for_script(local2)
            rf:update_states()
        else
            local1 = pick_from_nonweighted_table(birdidle)
            if local1 == pigeon_idles_lead_to_walk then
                local2 = start_script(rf.pigeon_walk, arg1)
                wait_for_script(local2)
            elseif local1 == pigeon_idles_jump_for_turn then
                if rnd() then
                    arg1:turn_right(90)
                else
                    arg1:turn_left(90)
                end
            end
            if rnd() then
                local3 = pick_one_of(pigeon_coo_sfx, TRUE)
                if rnd() then
                    single_start_sfx(local3)
                end
            end
            arg1:play_chore(local1)
            arg1:wait_for_chore()
        end
    end
end
rf.init_pigeons = function() -- line 764
    local local1 = 0
    local local2
    repeat
        local1 = local1 + 1
        if not pigeons[local1] then
            pigeons[local1] = Actor:create(nil, nil, nil, "pigeon" .. local1)
        end
        pigeons[local1].costume_marker_handler = bird_sound_monitor
        pigeons[local1].eat_pnt = { }
        pigeons[local1].eat_rot = { }
        pigeons[local1].start_pnt = { }
        if local1 == 1 then
            pigeons[local1].eat_pnt.x = -11.4224
            pigeons[local1].eat_pnt.y = 7.7199998
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 2 then
            pigeons[local1].eat_pnt.x = -11.4524
            pigeons[local1].eat_pnt.y = 7.8200002
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -89.845901
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 3 then
            pigeons[local1].eat_pnt.x = -11.4324
            pigeons[local1].eat_pnt.y = 7.77
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -56.6021
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 4 then
            pigeons[local1].eat_pnt.x = -11.3824
            pigeons[local1].eat_pnt.y = 7.9099998
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -89.845901
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 5 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 6 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        elseif local1 == 7 then
            pigeons[local1].eat_pnt.x = -11.3024
            pigeons[local1].eat_pnt.y = 7.9000001
            pigeons[local1].eat_pnt.z = 3.8
            pigeons[local1].eat_rot.x = 0
            pigeons[local1].eat_rot.y = -123.455
            pigeons[local1].eat_rot.z = 0
        end
        rf.default_pigeon(pigeons[local1], local1)
        pigeons[local1].start_pnt.x = nil
        pigeons[local1].start_pnt.y = nil
        pigeons[local1].start_pnt.z = nil
        pigeons[local1].height = nil
        pigeons[local1].eating = nil
        pigeons[local1]:put_in_set(rf)
        pigeons[local1]:setpos(-1 * rnd(12.575, 13.925), rnd(9.8249998, 11), BZ_Z)
        start_script(rf.pigeon_brain, pigeons[local1])
    until local1 == rf.NUMBER_OF_PIGEONS
    if not prop_pigeon then
        prop_pigeon = Actor:create(nil, nil, nil, "prop pigeon")
    end
    rf.default_pigeon(prop_pigeon, 6)
    prop_pigeon:put_in_set(rf)
    prop_pigeon:setpos(-13.4947, 11.19, 4.6799998)
    prop_pigeon:setrot(0, -179.218, 0)
    prop_pigeon:play_chore_looping(pigeon_idles_pecking)
end
rf.manny_flee = function() -- line 859
    local local1, local2
    stop_script(monitor_run)
    START_CUT_SCENE()
    manny:set_walk_backwards(FALSE)
    manny:set_turn_rate(360)
    rf.pigeons1.count = rf.pigeons1.count + 1
    if rf.pigeons1.count == 1 then
        manny:say_line("/rfma044/")
    elseif rf.pigeons1.count == 2 then
        manny:say_line("/rfma045/")
    elseif rf.pigeons1.count == 3 then
        manny:say_line("/rfma046/")
    elseif rf.pigeons1.count == 4 then
        manny:say_line("/rfma047/")
    elseif rf.pigeons1.count == 5 then
        manny:say_line("/rfma048/")
    elseif rf.pigeons1.count == 6 then
        manny:say_line("/rfma049/")
    else
        manny:say_line("/rfma050/")
    end
    local1 = object_proximity(rf.escape_point_1)
    local2 = object_proximity(rf.escape_point_2)
    if local1 <= local2 then
        local2 = object_proximity(rf.escape_point_3)
        if local1 <= local2 then
            manny:runto(rf.escape_point_1.use_pnt_x, rf.escape_point_1.use_pnt_y, rf.escape_point_1.use_pnt_z)
        else
            manny:runto(rf.escape_point_3.use_pnt_x, rf.escape_point_3.use_pnt_y, rf.escape_point_3.use_pnt_z)
        end
    else
        local2 = object_proximity(rf.escape_point_4)
        if local1 <= local2 then
            manny:runto(rf.escape_point_2.use_pnt_x, rf.escape_point_2.use_pnt_y, rf.escape_point_2.use_pnt_z)
        else
            manny:runto(rf.escape_point_4.use_pnt_x, rf.escape_point_4.use_pnt_y, rf.escape_point_4.use_pnt_z)
        end
    end
    fade_sfx("rfPigMus.imu")
    manny:wait_for_actor()
    manny:set_run(FALSE)
    manny:wait_for_message()
    break_here()
    manny:turn_toward_entity(rf.pigeons1)
    END_CUT_SCENE()
    if inventory_disabled then
        inventory_disabled = FALSE
    end
end
rf.manny_follow_birds = function() -- line 916
    while 1 do
        manny:head_look_at(pigeons[1])
        break_here()
    end
end
rf.grow_bread_pile = function() -- line 929
    local local1 = 0.1
    local local2 = { }
    if not bread_pile_actor then
        bread_pile_actor = Actor:create(nil, nil, nil, "bread pile actor")
    end
    bread_pile_actor:put_in_set(rf)
    bread_pile_actor:set_costume("bread_pile.cos")
    bread_pile_actor:setpos(-11.3908, 7.7994599, 3.76)
    bread_pile_actor:setrot(0, 0, 0)
    bread_pile_actor:scale(local1)
    repeat
        local2 = bread_pile_actor:getpos()
        local1 = local1 + PerSecond(0.21250001)
        local2.z = local2.z + PerSecond(0.003)
        bread_pile_actor:scale(local1)
        bread_pile_actor:setpos(local2.x, local2.y, local2.z)
        break_here()
    until local1 >= 1.7
end
rf.diminish_bread_pile = function() -- line 954
    local local1 = 1.7
    local local2 = { }
    repeat
        local2 = bread_pile_actor:getpos()
        local1 = local1 - PerSecond(0.42500001)
        local2.z = local2.z - PerSecond(0.0060000001)
        SetActorScale(bread_pile_actor.hActor, local1)
        bread_pile_actor:setpos(local2.x, local2.y, local2.z)
        break_here()
    until local1 <= 0.1
    stop_sound("flockeat.imu")
    bread_pile_actor:free()
end
rf.enter = function(arg1) -- line 978
    LoadCostume("ma_crumble_bread.cos")
    NewObjectState(rf_rufws, OBJSTATE_UNDERLAY, "flock_ws_comp.bm", nil, TRUE)
    NewObjectState(rf_rufws, OBJSTATE_UNDERLAY, "flock_ws1_comp.bm", nil, TRUE)
    NewObjectState(rf_rufha, OBJSTATE_UNDERLAY, "flock_ha_comp.bm", nil, TRUE)
    NewObjectState(rf_pigeon, OBJSTATE_OVERLAY, "le_cl_.bm")
    manny.footsteps = footsteps.gravel
    manny:put_in_set(rf)
    rf:set_up_actors()
    rf:update_states()
    rf:camerachange()
    SetShadowColor(15, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 1000, 1000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
rf.exit = function(arg1) -- line 1002
    local local1 = 1
    stop_script(rf.pigeon_brain)
    stop_script(rf.pigeon_attack)
    stop_script(rf.fly_fly_fly)
    stop_script(rf.pigeon_eat)
    stop_script(rf.turn_toward_home)
    stop_script(bird_climb)
    stop_script(rf.pigeon_walk)
    prop_pigeon:free()
    repeat
        pigeons[local1]:free()
        local1 = local1 + 1
    until local1 > rf.NUMBER_OF_PIGEONS
    KillActorShadows(manny.hActor)
    rf.pigeons1:free_object_state()
    rf.pigeons2:free_object_state()
    rf.pigeons3:free_object_state()
    dish_item_actor:free()
    rf.egg_actor:free()
    rf.egg_actor1:free()
    rf.egg_actor2:free()
    rf.egg_actor3:free()
    rf.escape_point_1:free_object_state()
    rf.escape_point_2:free_object_state()
end
rf.ladder_object = Object:create(rf, "/rftx002/ladder", -4.2644401, 3.6105299, 4.6999998, { range = 0 })
rf.rf_ladder_box = rf.ladder_object
rf.ladder_object.use_pnt_x = -2.306
rf.ladder_object.use_pnt_y = 4.7729998
rf.ladder_object.use_pnt_z = 3.72
rf.ladder_object.use_rot_x = 0
rf.ladder_object.use_rot_y = -545.13
rf.ladder_object.use_rot_z = 0
rf.ladder_object.out_pnt_x = -2.3640001
rf.ladder_object.out_pnt_y = 4.138
rf.ladder_object.out_pnt_z = 3.72
rf.ladder_object.out_rot_x = 0
rf.ladder_object.out_rot_y = -545.13
rf.ladder_object.out_rot_z = 0
rf.ladder_object.walkOut = function(arg1) -- line 1061
    manny:clear_hands()
    le:switch_to_set()
    manny:put_in_set(le)
    le:current_setup(le_alloh)
    manny:follow_boxes()
    manny:setpos(le.rope_up.use_pnt_x, le.rope_up.use_pnt_y, le.rope_up.use_pnt_z)
    manny:setrot(le.rope_up.use_rot_x, le.rope_up.use_rot_y, le.rope_up.use_rot_z)
end
rf.dish = Object:create(rf, "", -11.5502, 7.79496, 3.72, { range = 1 })
rf.dish.use_pnt_x = -11.55
rf.dish.use_pnt_y = 7.7964301
rf.dish.use_pnt_z = 3.72
rf.dish.use_rot_x = 0
rf.dish.use_rot_y = -88.131897
rf.dish.use_rot_z = 0
rf.dish.contains = nil
rf.dish.walk_to_me = function(arg1) -- line 1084
    local local1
    local local2 = 9999
    START_CUT_SCENE()
    repeat
        TurnActorTo(manny.hActor, -11.36, 7.7849598, 3.72)
        local1 = local2
        manny:walk_forward()
        break_here()
        local2 = point_proximity(-11.325, 7.8000002, 3.72)
    until local2 >= local1
    while TurnActorTo(manny.hActor, -11.36, 7.7849598, 3.72) do
        break_here()
    end
    END_CUT_SCENE()
end
rf.dish.lookAt = function(arg1) -- line 1101
    if arg1.contains == nil then
        if rf.pigeons_gone then
            manny:say_line("/rfma004/")
        else
            manny:say_line("/rfma005/")
        end
    elseif arg1.contains == fe.balloon_cat or arg1.contains == fe.balloon_dingo or arg1.contains == fe.balloon_frost then
        manny:say_line("/rfma006/")
    else
        manny:say_line("/rfma007/")
    end
end
rf.dish.pickUp = function(arg1) -- line 1116
    local local1 = arg1.contains
    local local2
    if arg1.contains then
        START_CUT_SCENE()
        arg1:walk_to_me()
        if local1 == fe.balloon_cat then
            local2 = ms_activate_cat_balloon
        elseif local1 == fe.balloon_dingo then
            local2 = ms_activate_dingo_balloon
        elseif local1 == fe.balloon_frost then
            local2 = ms_activate_frost_balloon
        end
        manny:play_chore(ms_reach_med, "ms.cos")
        sleep_for(603)
        arg1.contains:get()
        arg1.contains = nil
        rf:update_states()
        manny:play_chore_looping(local2, "ms.cos")
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny.is_holding = local1
        manny.hold_chore = local2
        manny:wait_for_chore(ms_reach_med, "ms.cos")
        manny:stop_chore(ms_reach_med, "ms.cos")
        END_CUT_SCENE()
    else
        manny:say_line("/rfma008/")
    end
end
rf.dish.use = function(arg1) -- line 1147
    arg1:walk_to_me()
    if arg1.contains then
        arg1:pickUp()
    else
        manny:say_line("/rfma009/")
    end
end
rf.dish.use_eggs = function(arg1) -- line 1157
    arg1:walk_to_me()
    manny:say_line("/rfma010/")
end
rf.dish.add_item = function(arg1, arg2) -- line 1162
    local local1 = arg1.contains
    local local2
    rf.no_attack_manny = TRUE
    arg1:walk_to_me()
    if not rf.pigeons_gone then
        if arg2 == fe.breads.bread1 or arg2 == fe.breads.bread2 or arg2 == fe.breads.bread3 or arg2 == fe.breads.bread4 or arg2 == fe.breads.bread5 then
            arg2:free()
            arg2.owner = fe.basket
            START_CUT_SCENE("no head")
            manny:stop_chore(ms_hold_bread, "ms.cos")
            manny:push_costume(ma_crumble_bread_cos)
            manny:play_chore(ma_crumble_bread_crumble_bread, ma_crumble_bread_cos)
            manny:play_sound_at("breadbrk.wav")
            manny:play_sound_at("breadpor.wav")
            start_script(rf.grow_bread_pile)
            manny:wait_for_chore(ma_crumble_bread_crumble_bread, ma_crumble_bread_cos)
            manny:pop_costume()
            manny.move_in_reverse = TRUE
            start_script(move_actor_backward, system.currentActor.hActor)
            sleep_for(1000)
            stop_script(move_actor_backward)
            system.currentActor:set_walk_backwards(FALSE)
            manny.move_in_reverse = FALSE
            manny:walkto(-11.9406, 7.3115101, 3.72)
            manny:wait_for_actor()
            manny:turn_toward_entity(rf.dish)
            start_script(rf.manny_follow_birds)
            if rf.dish.contains then
                rf.kill_pigeons = TRUE
            end
            rf.dish.foo = start_script(rf.wait_for_pigeons)
            wait_for_script(rf.dish.foo)
            wait_for_script(rf.pigeon_eat)
            stop_script(rf.manny_follow_birds)
            END_CUT_SCENE()
        else
            START_CUT_SCENE()
            if arg1.contains then
                if local1 == fe.balloon_cat then
                    local2 = ms_activate_cat_balloon
                elseif local1 == fe.balloon_dingo then
                    local2 = ms_activate_dingo_balloon
                elseif local1 == fe.balloon_frost then
                    local2 = ms_activate_frost_balloon
                end
                manny:stop_chore(ms_hold, "ms.cos")
                manny:play_chore(ms_reach_med, "ms.cos")
                sleep_for(603)
                arg2:free()
                arg1.contains:get()
                arg1.contains = arg2
                arg2.owner = rf.dish
                rf:update_states()
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny:play_chore_looping(local2, "ms.cos")
                manny:play_chore_looping(ms_hold, "ms.cos")
                manny.is_holding = local1
                manny.hold_chore = local2
                manny:wait_for_chore(ms_reach_med, "ms.cos")
            else
                manny:stop_chore(ms_hold, "ms.cos")
                manny:play_chore(ms_reach_med, "ms.cos")
                sleep_for(603)
                arg2:free()
                arg1.contains = arg2
                arg2.owner = rf.dish
                rf:update_states()
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny.hold_chore = nil
                manny.is_holding = nil
                manny:wait_for_chore(ms_reach_med, "ms.cos")
            end
            END_CUT_SCENE()
            if not rf.tried_scary_balloon then
                rf.tried_scary_balloon = TRUE
                manny:say_line("/rfma011/")
            end
        end
        rf.no_attack_manny = FALSE
    elseif arg2 == fe.breads.bread1 or arg2 == fe.breads.bread2 or arg2 == fe.breads.bread3 or arg2 == fe.breads.bread4 or arg2 == fe.breads.bread5 then
        arg2:default_response()
    else
        arg2:use()
    end
end
rf.dish.use_cat_balloon = function(arg1, arg2) -- line 1260
    arg1:add_item(arg2)
end
rf.dish.use_dingo_balloon = function(arg1, arg2) -- line 1264
    arg1:add_item(arg2)
end
rf.dish.use_frost_balloon = function(arg1, arg2) -- line 1268
    arg1:add_item(arg2)
end
rf.dish.use_bread = function(arg1, arg2) -- line 1272
    arg1:add_item(arg2)
end
rf.eggs = Object:create(rf, "/rftx012/eggs", 0, 0, 0, { range = 0 })
rf.eggs.lookAt = function(arg1) -- line 1281
    manny:say_line("/rfma013/")
end
rf.eggs.use = function(arg1) -- line 1285
    manny:say_line("/rfma014/")
end
rf.eggs.default_response = function(arg1) -- line 1289
    manny:say_line("/rfma015/")
end
rf.nest = Object:create(rf, "/rftx016/nest", -13.4724, 11.2718, 4.27, { range = 0.69999999 })
rf.nest.use_pnt_x = -13.4422
rf.nest.use_pnt_y = 11.0513
rf.nest.use_pnt_z = 3.72
rf.nest.use_rot_x = 0
rf.nest.use_rot_y = 12.124
rf.nest.use_rot_z = 0
rf.nest.contains = rf.eggs
rf.nest.use_eggs = function(arg1) -- line 1305
    manny:say_line("/rfma010/")
end
rf.nest.lookAt = function(arg1) -- line 1309
    if arg1.contains == rf.eggs then
        manny:say_line("/rfma017/")
    else
        manny:say_line("/rfma018/")
    end
end
rf.nest.pickUp = function(arg1) -- line 1317
    if arg1.contains == rf.eggs then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:say_line("/rfma019/")
        manny:play_chore(ms_reach_high, "ms.cos")
        sleep_for(1407)
        start_sfx("getEggs.wav")
        rf.egg_actor:free()
        arg1.contains = nil
        rf.eggs:get()
        rf.eggs.wav = "getEggs.wav"
        manny:play_chore_looping(ms_activate_eggs, "ms.cos")
        sleep_for(704)
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny.hold_chore = ms_activate_eggs
        manny.is_holding = rf.eggs
        manny:wait_for_chore(ms_reach_high, "ms.cos")
        manny:stop_chore(ms_reach_high, "ms.cos")
        manny:head_look_at(nil)
        END_CUT_SCENE()
    else
        arg1:lookAt()
    end
end
rf.nest.use = rf.nest.pickUp
rf.pigeons1 = Object:create(rf, "/rftx021/pigeons", -13.3372, 10.6634, 3.72, { range = 3.5999999 })
rf.pigeons1.use_pnt_x = -10.4459
rf.pigeons1.use_pnt_y = 8.5341501
rf.pigeons1.use_pnt_z = 3.72
rf.pigeons1.use_rot_x = 0
rf.pigeons1.use_rot_y = -320.36401
rf.pigeons1.use_rot_z = 0
rf.pigeons1.look_count = 0
rf.pigeons1.count = 0
rf.pigeons1.lookAt = function(arg1) -- line 1362
    rf.pigeons1.look_count = rf.pigeons1.look_count + 1
    if rf.pigeons1.look_count == 1 then
        manny:say_line("/rfma022/")
    elseif rf.pigeons1.look_count == 2 then
        manny:say_line("/rfma023/")
    elseif rf.pigeons1.look_count == 3 then
        manny:say_line("/rfma024/")
    elseif rf.pigeons1.look_count == 4 then
        manny:say_line("/rfma025/")
    elseif rf.pigeons1.look_count == 5 then
        manny:say_line("/rfma026/")
    else
        arg1:use()
    end
end
rf.pigeons1.pickUp = function(arg1) -- line 1380
    manny:say_line("/rfma027/")
    if salvador.talked_pigeons then
        START_CUT_SCENE()
        wait_for_message()
        manny:say_line("/rfma028/")
        END_CUT_SCENE()
    end
end
rf.pigeons1.use = function(arg1) -- line 1391
    manny:say_line("/rfma029/")
end
rf.pigeons1.not_working = function(arg1) -- line 1395
    manny:say_line("/rfma030/")
    wait_for_message()
end
rf.pigeons1.use_cat_balloon = function(arg1) -- line 1400
    START_CUT_SCENE()
    fe.balloon_cat:use()
    wait_for_message()
    rf.pigeons1:not_working()
    manny:say_line("/rfma031/")
    END_CUT_SCENE()
end
rf.pigeons1.use_dingo_balloon = function(arg1) -- line 1409
    START_CUT_SCENE()
    fe.balloon_dingo:use()
    wait_for_message()
    manny:say_line("/rfma032/")
    END_CUT_SCENE()
end
rf.pigeons1.use_frost_balloon = function(arg1) -- line 1416
    START_CUT_SCENE()
    fe.balloon_frost:use()
    wait_for_message()
    manny:say_line("/rfma033/")
    END_CUT_SCENE()
end
rf.pigeons1.use_scythe = function(arg1) -- line 1437
    START_CUT_SCENE()
    manny:say_line("/rfma037/")
    wait_for_message()
    mo.scythe:use()
    sleep_for(500)
    manny:say_line("/rfma038/")
    END_CUT_SCENE()
end
rf.pigeons1.use_mouthpiece = function(arg1) -- line 1447
    manny:say_line("/rfma039/")
    wait_for_message()
    manny:say_line("/rfma040/")
    wait_for_message()
    manny:say_line("/rfma041/")
end
rf.pigeons1.use_bread = function(arg1) -- line 1455
    manny:say_line("/rfma042/")
end
rf.pigeons2 = Object:create(rf, "/rftx051/pigeons", -13.3372, 10.6634, 3.72, { range = 0 })
rf.pigeons2.use_pnt_x = -10.4459
rf.pigeons2.use_pnt_y = 8.5341501
rf.pigeons2.use_pnt_z = 3.72
rf.pigeons2.use_rot_x = 0
rf.pigeons2.use_rot_y = -320.36401
rf.pigeons2.use_rot_z = 0
rf.pigeons2.parent = rf.pigeons1
rf.pigeons3 = Object:create(rf, "/rftx051/pigeons", -13.3372, 10.6634, 3.72, { range = 0 })
rf.pigeons3.use_pnt_x = -10.4459
rf.pigeons3.use_pnt_y = 8.5341501
rf.pigeons3.use_pnt_z = 3.72
rf.pigeons3.use_rot_x = 0
rf.pigeons3.use_rot_y = -320.36401
rf.pigeons3.use_rot_z = 0
rf.pigeons3.parent = rf.pigeons1
rf.sky = Object:create(rf, "/rftx053/sky", -12.9724, 9.50179, 5.5999999, { range = 0.5 })
rf.sky.use_pnt_x = -10.83
rf.sky.use_pnt_y = 7.934
rf.sky.use_pnt_z = 3.72
rf.sky.use_rot_x = 0
rf.sky.use_rot_y = -303.345
rf.sky.use_rot_z = 0
rf.sky:make_untouchable()
rf.sky.lookAt = function(arg1) -- line 1493
end
rf.sky.pickUp = function(arg1) -- line 1496
end
rf.sky.use = function(arg1) -- line 1499
end
rf.escape_point_1 = Object:create(rf, "/rftx055/x", -10.1976, 9.35886, 3.72, { range = 0 })
rf.escape_point_1.use_pnt_x = -10.1976
rf.escape_point_1.use_pnt_y = 9.35886
rf.escape_point_1.use_pnt_z = 3.72
rf.escape_point_1.use_rot_x = 0
rf.escape_point_1.use_rot_y = -78.999199
rf.escape_point_1.use_rot_z = 0
rf.escape_point_2 = Object:create(rf, "/rftx056/x", -12.7606, 6.9607301, 3.72, { range = 0 })
rf.escape_point_2.use_pnt_x = -12.7606
rf.escape_point_2.use_pnt_y = 6.9607301
rf.escape_point_2.use_pnt_z = 3.72
rf.escape_point_2.use_rot_x = 0
rf.escape_point_2.use_rot_y = 200.63
rf.escape_point_2.use_rot_z = 0
rf.escape_point_3 = Object:create(rf, "", -10.5521, 7.8463898, 3.72, { range = 0 })
rf.escape_point_3.use_pnt_x = -10.5521
rf.escape_point_3.use_pnt_y = 7.8463898
rf.escape_point_3.use_pnt_z = 3.72
rf.escape_point_3.use_rot_x = 0
rf.escape_point_3.use_rot_y = -41.502998
rf.escape_point_3.use_rot_z = 0
rf.escape_point_3:make_untouchable()
rf.escape_point_4 = Object:create(rf, "", -11.4381, 6.9501801, 3.72, { range = 0 })
rf.escape_point_4.use_pnt_x = -11.4381
rf.escape_point_4.use_pnt_y = 6.9501801
rf.escape_point_4.use_pnt_z = 3.72
rf.escape_point_4.use_rot_x = 0
rf.escape_point_4.use_rot_y = -469.336
rf.escape_point_4.use_rot_z = 0
rf.escape_point_4:make_untouchable()

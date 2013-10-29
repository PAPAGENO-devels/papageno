dofile("bee_barrel.lua")
dofile("bee_flavor.lua")
dofile("bee_strike.lua")
dofile("bee_works.lua")
dofile("bee_stamp.lua")
dofile("tm_manifesto.lua")
dofile("tm_pace.lua")
sea_bee = { }
sea_bee.parent = system.actorTemplate
sea_bee.create = function(arg1, arg2) -- line 23
    local local1
    local1 = Actor:create(nil, nil, nil, arg2)
    local1.parent = arg1
    local1.body = nil
    return local1
end
sea_bee.default = function(arg1, arg2, arg3) -- line 38
    if not arg2 then
        arg2 = bee_flavor_bee1
    end
    arg1:set_costume(nil)
    arg1:set_costume("bee_flavor.cos")
    arg1:set_colormap("seabees.cmp")
    arg1:set_mumble_chore(bee_flavor_mumble)
    arg1:set_talk_chore(1, bee_flavor_stop_talk)
    arg1:set_talk_chore(2, bee_flavor_a)
    arg1:set_talk_chore(3, bee_flavor_c)
    arg1:set_talk_chore(4, bee_flavor_e)
    arg1:set_talk_chore(5, bee_flavor_f)
    arg1:set_talk_chore(6, bee_flavor_l)
    arg1:set_talk_chore(7, bee_flavor_m)
    arg1:set_talk_chore(8, bee_flavor_o)
    arg1:set_talk_chore(9, bee_flavor_t)
    arg1:set_talk_chore(10, bee_flavor_u)
    arg1:play_chore(bee_flavor_no_flap, "bee_flavor.cos")
    arg1:complete_chore(arg2, "bee_flavor.cos")
    arg1:set_turn_rate(60)
    arg1:set_walk_rate(0.4)
    arg1.upper_hands_state = "base"
    arg1.lookdir = "center"
    arg1.look_script = nil
    arg1.shufflepos = 0
    arg1.stop_idle = FALSE
    if not arg3 then
        arg3 = "barrel"
    end
    if arg3 == "strike" or arg3 == "barrel" then
        if not arg1.body then
            arg1.body = Actor:create(nil, nil, nil, arg1.name .. " Body")
        end
        arg1.body:set_costume(nil)
        arg1.body:set_costume("bee_flavor.cos")
        arg1.body:set_colormap("seabees.cmp")
        arg1.body:complete_chore(arg2, "bee_flavor.cos")
        arg1.body:push_costume("bee_stamp.cos")
    end
    if arg3 == "works" then
        arg1:push_costume("bee_works.cos")
    elseif arg3 == "strike" then
        arg1:push_costume("bee_stamp.cos")
        arg1:push_costume("bee_strike.cos")
        arg1.body:push_costume("bee_strike.cos")
    elseif arg3 == "pace" then
        arg1:push_costume("tm_pace.cos")
    else
        arg1:push_costume("bee_stamp.cos")
        arg1:push_costume("bee_barrel.cos")
        arg1.body:push_costume("bee_barrel.cos")
    end
end
sea_bee.free = function(arg1) -- line 97
    if arg1.body then
        arg1.body:free()
    end
    Actor.free(arg1)
end
sea_bee.put_in_set = function(arg1, arg2) -- line 104
    if arg1.body then
        arg1.body:put_in_set(arg2)
    end
    Actor.put_in_set(arg1, arg2)
end
sea_bee.worker_chores = { }
sea_bee.worker_chores[0] = { chore = bee_flavor_bee3, used = FALSE }
sea_bee.worker_chores[1] = { chore = bee_flavor_bee4, used = FALSE }
sea_bee.worker_chores[2] = { chore = bee_flavor_bee5, used = FALSE }
sea_bee.choose_worker_flavor = function(arg1, arg2) -- line 118
    local local1 = rndint(0, 2)
    if arg1.flavor then
        sea_bee.worker_chores[arg1.flavor].used = FALSE
        arg1.flavor = nil
    end
    while sea_bee.worker_chores[local1].used and local1 ~= arg1.flavor do
        local1 = rndint(0, 2)
    end
    arg1.flavor = local1
    sea_bee.worker_chores[local1].used = TRUE
    sea_bee.default(arg1, sea_bee.worker_chores[local1].chore, arg2)
end
angry_bees = sea_bee:create("Angry Bees")
angry_bees.default = function(arg1, arg2) -- line 142
    sea_bee.default(arg1, bee_flavor_bee5, arg2)
    angry_bees:set_talk_color(Red)
end
bee1 = sea_bee:create("First Barrel Bee")
bee1.default = function(arg1, arg2) -- line 148
    sea_bee.default(arg1, bee_flavor_bee1, arg2)
    bee1:set_talk_color(Green)
end
bee2 = sea_bee:create("Second Barrel Bee")
bee2.default = function(arg1, arg2) -- line 154
    sea_bee.default(arg1, bee_flavor_bee2, arg2)
    bee2:set_talk_color(Blue)
end
terry = sea_bee:create("Terry")
terry.default = function(arg1, arg2) -- line 160
    sea_bee.default(arg1, bee_flavor_terry, arg2)
    if arg2 == "barrel" or arg2 == nil then
        arg1:push_costume("tm_manifesto.cos")
        arg1.body:push_costume("tm_manifesto.cos")
    end
    arg1:set_talk_color(Yellow)
end
worker_bee1 = sea_bee:create("First Worker Bee")
worker_bee1.flavor = nil
worker_bee1.default = function(arg1, arg2) -- line 171
    if not arg2 then
        arg2 = "works"
    end
    arg1:choose_worker_flavor(arg2)
end
worker_bee2 = sea_bee:create("Second Worker Bee")
worker_bee2.flavor = nil
worker_bee2.default = function(arg1, arg2) -- line 179
    if not arg2 then
        arg2 = "works"
    end
    arg1:choose_worker_flavor(arg2)
end
sea_bee.barrel_upper_idle_table = { start_warm_upr_hands = 0.69999999, warm_base = 0.2, to_scrtch_hd = 0.050000001, to_scrtch_chin = 0.050000001 }
sea_bee.barrel_lower_idle_table = { warm_lwr_hands = 0.40000001, warm_base = 0.27000001, move_wing = 0.2, rub_lwr_hands = 0.1, one_foot = 0.0099999998, step_right = 0.0099999998, step_left = 0.0099999998 }
sea_bee.run_barrel_upper_idles = function(arg1) -- line 204
    while not arg1.stop_idle do
        if not arg1.frozen then
            arg1.is_upper_idling = TRUE
            if rnd(9) then
                if arg1.upper_hands_state == "hands" then
                    arg1.upper_hands_state = "base"
                    arg1:set_chore_looping(bee_barrel_warm_upr_hands, FALSE, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_warm_upr_hands, "bee_barrel.cos")
                    arg1:play_chore(bee_barrel_stop_warm_upr_hands, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_stop_warm_upr_hands, "bee_barrel.cos")
                else
                    arg1.upper_hands_state = "hands"
                    arg1:play_chore(bee_barrel_start_warm_upr_hands, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_start_warm_upr_hands, "bee_barrel.cos")
                    arg1:play_chore_looping(bee_barrel_warm_upr_hands, "bee_barrel.cos")
                end
                if not arg1.stop_idle then
                    sleep_for(rndint(1000, 3000))
                end
            elseif rnd(8) then
                if arg1.upper_hands_state == "hands" then
                    arg1:play_chore(bee_barrel_to_scrtch_hd, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_to_scrtch_hd, "bee_barrel.cos")
                    arg1:play_chore_looping(bee_barrel_sctrch_head, "bee_barrel.cos")
                    sleep_for(500)
                    start_sfx("beehead.wav", IM_MED_PRIORITY, 100)
                    sleep_for(rndint(500, 1000))
                    arg1:stop_chore(bee_barrel_sctrch_head, "bee_barrel.cos")
                    arg1:play_chore(bee_barrel_stp_sctrch_hd, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_stp_sctrch_hd, "bee_barrel.cos")
                else
                    arg1:play_chore(bee_barrel_to_scrtch_chin, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_to_scrtch_chin, "bee_barrel.cos")
                    arg1:play_chore_looping(bee_barrel_scrtch_chin, "bee_barrel.cos")
                    sleep_for(500)
                    start_sfx("beehead.wav", IM_MED_PRIORITY, 100)
                    sleep_for(rndint(500, 1000))
                    arg1:stop_chore(bee_barrel_scrtch_chin, "bee_barrel.cos")
                    arg1:play_chore(bee_barrel_frm_scrtch_chin, "bee_barrel.cos")
                    arg1:wait_for_chore(bee_barrel_frm_scrtch_chin, "bee_barrel.cos")
                    arg1:stop_chore(bee_barrel_frm_scrtch_chin, "bee_barrel.cos")
                end
            end
            arg1.is_upper_idling = FALSE
            if not arg1.stop_idle then
                sleep_for(rndint(500, 1000))
            end
        else
            break_here()
        end
    end
    arg1.barrel_upper_idle_script = nil
end
sea_bee.run_barrel_lower_idles = function(arg1) -- line 259
    local local1, local2
    while not arg1.stop_idle do
        local1 = pick_from_weighted_table(sea_bee.barrel_lower_idle_table)
        local2 = getglobal("bee_barrel_" .. local1)
        if local2 and not arg1.frozen then
            arg1.is_lower_idling = TRUE
            if local2 == bee_barrel_step_left then
                if arg1.shufflepos > -1 and arg1 ~= terry then
                    arg1:shuffle(bee_barrel_step_left)
                    arg1.shufflepos = arg1.shufflepos - 1
                end
            elseif local2 == bee_barrel_step_right then
                if arg1.shufflepos < 1 and arg1 ~= terry then
                    arg1:shuffle(bee_barrel_step_right)
                    arg1.shufflepos = arg1.shufflepos + 1
                end
            elseif local2 == bee_barrel_one_foot then
                arg1:remove_barrel_stamp()
                arg1:run_chore(local2, "bee_barrel.cos")
                if local2 ~= bee_barrel_warm_base then
                    arg1:stop_chore(local2, "bee_barrel.cos")
                end
                arg1:replace_barrel_stamp()
            else
                if local2 == bee_barrel_move_wing then
                    start_sfx(pick_one_of({ "beeflap1.wav", "beeflap2.wav", "beeflap3.wav" }), IM_MED_PRIORITY, 100)
                end
                arg1:play_chore(local2, "bee_barrel.cos")
                arg1:wait_for_chore(local2, "bee_barrel.cos")
                if local2 ~= bee_barrel_warm_base then
                    arg1:stop_chore(local2, "bee_barrel.cos")
                end
            end
            arg1.is_lower_idling = FALSE
            if not arg1.stop_idle then
                sleep_for(rndint(100, 1000))
            end
        else
            break_here()
        end
    end
    arg1.barrel_lower_idle_script = nil
end
sea_bee.shuffle = function(arg1, arg2) -- line 307
    local local1, local2, local3, local4, local5, local6, local7
    arg1:remove_barrel_stamp()
    local2 = { x = 0, y = 0.1, z = 0 }
    if arg2 == bee_barrel_step_left then
        local6 = 11
        local2.y = 0.029999999
    elseif arg2 == bee_barrel_step_right then
        local6 = 7
        local2.y = 0.02
    elseif arg2 == tm_manifesto_step_left then
        local6 = 18
        local2.y = 0.02
    elseif arg2 == tm_manifesto_step_right then
        local6 = 20
        local2.y = 0.029999999
    end
    local1 = arg1:getrot()
    if arg2 == bee_barrel_step_left or arg2 == tm_manifesto_step_left then
        local1.y = local1.y - 90
    else
        local1.y = local1.y + 90
    end
    local2 = RotateVector(local2, local1)
    local3 = arg1:getpos()
    local2.x = local2.x + local3.x
    local2.y = local2.y + local3.y
    local2.z = local3.z
    local4 = (local2.x - local3.x) / local6
    local5 = (local2.y - local3.y) / local6
    arg1:play_chore(arg2, "bee_barrel.cos")
    local7 = 0
    while local7 < local6 do
        local3.x = local3.x + local4
        local3.y = local3.y + local5
        arg1:setpos(local3.x, local3.y, local3.z)
        local7 = local7 + 1
        break_here()
    end
    arg1:stop_chore(arg2, "bee_barrel.cos")
    arg1:replace_barrel_stamp()
end
sea_bee.barrel_idles = function(arg1) -- line 357
    arg1.stop_idle = FALSE
    if not arg1.barrel_lower_idle_script then
        arg1.barrel_lower_idle_script = start_script(arg1.run_barrel_lower_idles, arg1)
    end
    if not arg1.barrel_upper_idle_script then
        arg1.barrel_upper_idle_script = start_script(arg1.run_barrel_upper_idles, arg1)
    end
end
sea_bee.init_barrel_stuff = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 368
    start_script(arg1.do_init_barrel, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
end
sea_bee.do_init_barrel = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 372
    system:lock_display()
    arg1:play_chore_looping(bee_barrel_warm_base, "bee_barrel.cos")
    if not arg8 then
        arg1.body:play_chore_looping(bee_barrel_warm_base, "bee_barrel.cos")
        arg1.body:setpos(arg2, arg3, arg4)
        arg1.body:setrot(arg5, arg6, arg7)
    end
    arg1:setpos(arg2, arg3, arg4)
    arg1:setrot(arg5, arg6, arg7)
    if not arg8 then
        arg1:complete_chore(bee_stamp_wings_and_arms, "bee_stamp.cos")
        arg1.body:complete_chore(bee_stamp_body_and_head, "bee_stamp.cos")
        arg1.body:complete_chore(bee_stamp_hide_wings, "bee_stamp.cos")
    end
    break_here()
    if not arg8 then
        arg1.body:freeze()
        arg1:barrel_idles()
    else
        arg1:freeze()
    end
    system:unlock_display()
end
sea_bee.remove_barrel_stamp = function(arg1) -- line 409
    arg1.body:thaw(TRUE)
    arg1.body:put_in_set(nil)
    arg1:complete_chore(bee_stamp_show_head, "bee_stamp.cos")
    arg1:complete_chore(bee_stamp_show_body, "bee_stamp.cos")
end
sea_bee.replace_barrel_stamp = function(arg1) -- line 421
    local local1, local2
    local1 = arg1:getpos()
    local2 = arg1:getrot()
    arg1.body:put_in_set(dd)
    arg1.body:setpos(local1.x, local1.y, local1.z)
    arg1.body:setrot(local2.x, local2.y, local2.z)
    arg1.body:complete_chore(bee_stamp_body_and_head, "bee_stamp.cos")
    arg1.body:freeze()
    arg1:complete_chore(bee_stamp_wings_and_arms, "bee_stamp.cos")
end
sea_bee.thaw_head = function(arg1) -- line 440
    system:lock_display()
    arg1:complete_chore(bee_stamp_show_head, "bee_stamp.cos")
    arg1.body:thaw(TRUE)
    arg1.body:complete_chore(bee_stamp_hide_head, "bee_stamp.cos")
    break_here()
    arg1.body:freeze()
    system:unlock_display()
end
sea_bee.work_idles = function(arg1) -- line 450
    if not arg1.work_idle_script then
        arg1.work_idle_script = start_script(arg1.work_idle_movement, arg1)
    end
end
sea_bee.look_center = function(arg1) -- line 456
    if arg1.look_script then
        while arg1.look_script ~= nil do
            break_here()
        end
    end
    arg1.look_script = start_script(arg1.set_look_dir, arg1, "center")
end
sea_bee.look_left = function(arg1) -- line 466
    if arg1.look_script then
        while arg1.look_script ~= nil do
            break_here()
        end
    end
    if arg1.lookdir == "right" then
        arg1.look_script = start_script(arg1.set_look_dir, arg1, "center")
        while arg1.look_script do
            break_here()
        end
    end
    arg1.look_script = start_script(arg1.set_look_dir, arg1, "left")
end
sea_bee.look_right = function(arg1) -- line 482
    if arg1.look_script then
        while arg1.look_script ~= nil do
            break_here()
        end
    end
    if arg1.lookdir == "left" then
        arg1.look_script = start_script(arg1.set_look_dir, arg1, "center")
        while arg1.look_script do
            break_here()
        end
    end
    arg1.look_script = start_script(arg1.set_look_dir, arg1, "right")
end
sea_bee.set_look_dir = function(arg1, arg2) -- line 502
    if arg2 ~= arg1.lookdir then
        if arg2 == "center" then
            if arg1.lookdir == "right" then
                arg1:stop_chore(bee_barrel_lk_rt_hold, "bee_barrel.cos")
                arg1:play_chore(bee_barrel_lk_rt_to_ctr, "bee_barrel.cos")
                arg1:wait_for_chore(bee_barrel_lk_rt_to_ctr, "bee_barrel.cos")
                arg1:stop_chore(bee_barrel_lk_rt_to_ctr, "bee_barrel.cos")
            else
                arg1:stop_chore(bee_barrel_lk_lft_hold, "bee_barrel.cos")
                arg1:play_chore(bee_barrel_lk_lft_to_ctr, "bee_barrel.cos")
                arg1:wait_for_chore(bee_barrel_lk_lft_to_ctr, "bee_barrel.cos")
                arg1:stop_chore(bee_barrel_lk_lft_to_ctr, "bee_barrel.cos")
            end
            arg1.lookdir = "center"
        elseif arg2 == "left" then
            arg1:play_chore(bee_barrel_lk_lft, "bee_barrel.cos")
            arg1:wait_for_chore(bee_barrel_lk_lft, "bee_barrel.cos")
            arg1:stop_chore(bee_barrel_lk_lft, "bee_barrel.cos")
            arg1:play_chore_looping(bee_barrel_lk_lft_hold, "bee_barrel.cos")
            arg1.lookdir = "left"
        else
            arg1:play_chore(bee_barrel_lk_rt, "bee_barrel.cos")
            arg1:wait_for_chore(bee_barrel_lk_rt, "bee_barrel.cos")
            arg1:stop_chore(bee_barrel_lk_rt, "bee_barrel.cos")
            arg1:play_chore_looping(bee_barrel_lk_rt_hold, "bee_barrel.cos")
            arg1.lookdir = "right"
        end
    end
    arg1.look_script = nil
end
sea_bee.stop_idles = function(arg1) -- line 535
    if arg1.barrel_upper_idle_script then
        stop_script(arg1.barrel_upper_idle_script)
        arg1.barrel_upper_idle_script = nil
    end
    if arg1.barrel_lower_idle_script then
        stop_script(arg1.barrel_lower_idle_script)
        arg1.barrel_lower_idle_script = nil
    end
    if arg1.work_idle_script then
        stop_script(arg1.work_idle_script)
        arg1.work_idle_script = nil
    end
    if arg1.movement_script then
        stop_script(arg1.movement_script)
        arg1.movement_script = nil
    end
    if arg1.strike_idle_script then
        stop_script(arg1.strike_idle_script)
        arg1.strike_idle_script = nil
    end
    if arg1.strike_rotate then
        stop_script(arg1.strike_rotate)
    end
    if arg1.frozen then
        arg1:thaw()
    end
end
terry.do_init_barrel = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 569
    system:lock_display()
    arg1:complete_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    if not arg8 then
        arg1.body:complete_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
        arg1.body:setpos(arg2, arg3, arg4)
        arg1.body:setrot(arg5, arg6, arg7)
    end
    arg1:setpos(arg2, arg3, arg4)
    arg1:setrot(arg5, arg6, arg7)
    if not arg8 then
        arg1:complete_chore(bee_stamp_wings_and_arms, "bee_stamp.cos")
        arg1.body:complete_chore(bee_stamp_body_and_head, "bee_stamp.cos")
        arg1.body:complete_chore(bee_stamp_hide_wings, "bee_stamp.cos")
    end
    break_here()
    if not arg8 then
        arg1.body:freeze()
        arg1:barrel_idles()
    else
        arg1:freeze()
    end
    system:unlock_display()
    if not arg1.saylineTable then
        arg1.saylineTable = { }
    end
    arg1.saylineTable.x = 500
    arg1.saylineTable.y = 170
end
terry.free = function(arg1) -- line 600
    arg1.saylineTable.x = nil
    arg1.saylineTable.y = nil
    if arg1.body then
        arg1.body:free()
    end
    Actor.free(arg1)
end
terry.barrel_idles = function(arg1) -- line 609
    arg1.stop_idle = FALSE
    if not arg1.barrel_upper_idle_script then
        arg1.barrel_upper_idle_script = start_script(arg1.run_barrel_upper_idles, arg1)
    end
end
terry.run_barrel_upper_idles = function(arg1) -- line 617
    arg1:play_chore_looping(tm_manifesto_warm_hands, "tm_manifesto.cos")
    while not arg1.stop_idle do
        break_here()
    end
    arg1:set_chore_looping(tm_manifesto_warm_hands, FALSE, "tm_manifesto.cos")
    arg1:wait_for_chore(tm_manifesto_warm_hands, "tm_manifesto.cos")
    arg1:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
    arg1.barrel_upper_idle_script = nil
end
terry.stop_barrel_idles = function(arg1) -- line 628
    arg1.stop_idle = TRUE
    while arg1.barrel_upper_idle_script do
        break_here()
    end
end
terry.strike_idles = function(arg1) -- line 635
    terry.body:put_in_set(nil)
    terry.body:free()
    terry:push_costume("bee_barrel.cos")
    terry:play_chore_looping(bee_strike_hover, "bee_strike.cos")
    terry:set_turn_rate(20)
    terry.stop_rotate = FALSE
    single_start_script(terry.strike_rotate, terry)
end
terry.strike_rotate = function(arg1) -- line 648
    local local1, local2, local3, local4, local5, local6
    arg1:wait_for_actor()
    local1 = arg1:getrot()
    local2 = 3
    while TRUE and not arg1.stop_rotate do
        while local1.y < 45 and local2 > 0.001 and not arg1.stop_rotate do
            local1.y = local1.y + local2
            if local1.y > 30 then
                local2 = local2 - local2 / 6
            elseif local2 < 3 then
                local2 = local2 + 1
            end
            arg1:setrot(local1.x, local1.y, local1.z)
            break_here()
        end
        local4 = 0
        while local4 < 2000 and not arg1.stop_rotate do
            break_here()
            local4 = local4 + system.frameTime
        end
        local2 = -1
        while local1.y > 0 and local2 < -0.001 and not arg1.stop_rotate do
            local1.y = local1.y + local2
            if local1.y < 10 then
                local2 = local2 + abs(local2) / 6
            elseif local2 > -3 then
                local2 = local2 - 1
            end
            arg1:setrot(local1.x, local1.y, local1.z)
            break_here()
        end
        local4 = 0
        while local4 < 2000 and not arg1.stop_rotate do
            break_here()
            local4 = local4 + system.frameTime
        end
        local2 = 1
    end
    local5 = manny:getpos()
    local6 = GetActorYawToPoint(arg1.hActor, local5)
    arg1:setrot(local1.x, local6, local1.z, TRUE)
    arg1:wait_for_actor()
    arg1.stop_rotate = FALSE
end
terry.head_left = function(arg1) -- line 702
    terry:run_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_head_base, "tm_manifesto.cos")
end
terry.stop_head_left = function(arg1) -- line 708
    terry:stop_chore(tm_manifesto_head_base, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_head_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_head_to_base, "tm_manifesto.cos")
end
terry.head_nod = function(arg1) -- line 714
    if find_script(arg1.head_left) then
        wait_for_script(arg1.head_left)
    end
    terry:wait_for_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_head_base, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_head_nod, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_head_nod, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_head_base, "tm_manifesto.cos")
end
terry.head_wag = function(arg1) -- line 726
    if find_script(arg1.head_left) then
        wait_for_script(arg1.head_left)
    end
    terry:wait_for_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_to_head_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_head_base, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_head_wag, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_head_wag, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_head_base, "tm_manifesto.cos")
end
terry.gesture1 = function(arg1, arg2) -- line 738
    terry:stop_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_gesture1, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_gesture1, "tm_manifesto.cos")
    if arg2 then
        terry:play_chore_looping(tm_manifesto_gesture_cycle, "tm_manifesto.cos")
    else
        terry:play_chore_looping(tm_manifesto_gesture1_hold, "tm_manifesto.cos")
    end
end
terry.gesture2 = function(arg1) -- line 749
    if terry:is_choring(tm_manifesto_gesture_cycle, FALSE, "tm_manifesto.cos") then
        terry:set_chore_looping(tm_manifesto_gesture_cycle, FALSE, "tm_manifesto.cos")
        terry:wait_for_chore(tm_manifesto_gesture_cycle, "tm_manifesto.cos")
        terry:stop_chore(tm_manifesto_gesture_cycle, "tm_manifesto.cos")
    else
        terry:stop_chore(tm_manifesto_gesture1_hold, "tm_manifesto.cos")
    end
    terry:run_chore(tm_manifesto_gesture2, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_gesture2, "tm_manifesto.cos")
    terry:play_chore(tm_manifesto_gesture2_hold, "tm_manifesto.cos")
end
terry.stop_gesture = function(arg1) -- line 762
    if terry:is_choring(tm_manifesto_gesture2, FALSE, "tm_manifesto.cos") then
        terry:wait_for_chore(tm_manifesto_gesture2, "tm_manifesto.cos")
        terry:stop_chore(tm_manifesto_gesture2, "tm_manifesto.cos")
    end
    terry:stop_chore(tm_manifesto_gesture2_hold, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_gesture_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_gesture_to_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
end
terry.lefthand_out = function(arg1) -- line 773
    terry:stop_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_lefthand_out, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_lefthand_out, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_lefthand_hold, "tm_manifesto.cos")
end
terry.stop_lefthand_out = function(arg1) -- line 780
    terry:stop_chore(tm_manifesto_lefthand_hold, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_lhand_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_lhand_to_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
end
terry.shrug = function(arg1) -- line 787
    terry:stop_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_base_to_shrug, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_base_to_shrug, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_shrug_hold, "tm_manifesto.cos")
end
terry.stop_shrug = function(arg1) -- line 794
    terry:stop_chore(tm_manifesto_shrug_hold, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_shrug_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_shrug_to_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
end
terry.point = function(arg1) -- line 801
    terry:stop_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_to_point, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_to_point, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_point_cycle, "tm_manifesto.cos")
end
terry.stop_point = function(arg1) -- line 808
    terry:set_chore_looping(tm_manifesto_point_cycle, FALSE, "tm_manifesto.cos")
    terry:wait_for_chore(tm_manifesto_point_cycle, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_point_cycle, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_point_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_point_to_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
end
terry.point_once = function(arg1) -- line 817
    terry:stop_chore(tm_manifesto_base_pose, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_to_point, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_to_point, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_point_cycle, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_point_cycle, "tm_manifesto.cos")
    terry:run_chore(tm_manifesto_point_to_base, "tm_manifesto.cos")
    terry:stop_chore(tm_manifesto_point_to_base, "tm_manifesto.cos")
    terry:play_chore_looping(tm_manifesto_base_pose, "tm_manifesto.cos")
end
terry.start_pace = function(arg1) -- line 828
    terry:play_chore_looping(bee_flavor_wings_flap, "bee_flavor.cos")
    terry:run_chore(tm_pace_start_scratch, "tm_pace.cos")
    terry:play_chore_looping(tm_pace_pace, "tm_pace.cos")
end
terry.stop_pace = function(arg1) -- line 834
    terry:stop_chore(tm_pace_pace, "tm_pace.cos")
    terry:run_chore(tm_pace_stop_scratch, "tm_pace.cos")
    terry:stop_chore(bee_flavor_wings_flap, "bee_flavor.cos")
    terry:play_chore(bee_flavor_no_flap, "bee_flavor.cos")
end
terry.fake_hover = function(arg1) -- line 841
    local local1, local2, local3, local4, local5
    local1 = arg1:getpos()
    local2 = local1.z
    local3 = 10
    local4 = 5
    local5 = 90
    while TRUE do
        local1 = arg1:getpos()
        local1.z = local2 + sin(local3) / 20
        local3 = local3 + local4
        if local4 < 0 then
            local4 = rndint(5, 10)
            local4 = -local4
        else
            local4 = rndint(5, 10)
        end
        if local5 >= 70 and local3 >= local5 then
            local4 = -local4
            local3 = local5 - 1
            local5 = rndint(70, 90)
        elseif local5 <= 20 and local3 < local5 then
            local4 = -local4
            local3 = local5
            local5 = rndint(5, 20)
        end
        arg1:setpos(local1.x, local1.y, local1.z)
        break_here()
    end
end
sea_bee.fly_condition = function(arg1, arg2, arg3, arg4) -- line 880
    if arg4 then
        if arg2 < arg3 then
            return TRUE
        else
            return FALSE
        end
    elseif arg2 > arg3 then
        return TRUE
    else
        return FALSE
    end
end
sea_bee.fly_to = function(arg1, arg2, arg3, arg4, arg5) -- line 896
    local local1, local2, local3, local4, local5
    local local6, local7, local8, local9, local10, local11
    local1 = arg1:getpos()
    arg1.near_destination = FALSE
    local10 = FALSE
    local11 = FALSE
    if arg5 then
        local3 = 0.050000001
        local2 = 0.02
        local5 = 6
        local4 = 8
        local6 = 0.15000001
        local7 = 0.1
    else
        local2 = 0.050000001
        local3 = 0.02
        local5 = 8
        local4 = 6
        local6 = 0.1
        local7 = 0.15000001
    end
    if local1.z < arg4 then
        local9 = TRUE
    else
        local9 = FALSE
        local2 = -local2
    end
    if local1.y < arg3 then
        local8 = TRUE
    else
        local8 = FALSE
        local3 = -local3
    end
    while arg1:fly_condition(local1.z, arg4, local9) or arg1:fly_condition(local1.y, arg3, local8) do
        if arg1:fly_condition(local1.z, arg4, local9) then
            if not local11 then
                local1.z = local1.z + local2
                if abs(local2) < local7 then
                    local2 = abs(local2) + abs(local2) / local4
                    if not local9 then
                        local2 = -local2
                    end
                end
            else
                if abs(local2) > 0.0099999998 then
                    local2 = abs(local2) - abs(local2) / local5
                    if local2 < 0.0099999998 then
                        local2 = 0.0099999998
                    end
                    if not local9 then
                        local2 = -local2
                    end
                end
                local1.z = local1.z + local2
            end
        end
        if arg1:fly_condition(local1.y, arg3, local8) then
            if not local10 then
                local1.y = local1.y + local3
                if abs(local3) < local6 then
                    local3 = abs(local3) + abs(local3) / local5
                    if not local8 then
                        local3 = -local3
                    end
                end
            else
                if abs(local3) > 0.0099999998 then
                    local3 = abs(local3) - abs(local3) / local4
                    if local3 < 0.0099999998 then
                        local3 = 0.0099999998
                    end
                    if not local8 then
                        local3 = -local3
                    end
                end
                local1.y = local1.y + local3
            end
        end
        arg1:setpos(local1.x, local1.y, local1.z)
        if abs(local1.y - arg3) < abs(local3 * 4) then
            local10 = TRUE
        end
        if abs(local1.z - arg4) < abs(local2 * 4) then
            local11 = TRUE
        end
        if local10 and local11 then
            arg1.near_destination = TRUE
        end
        break_here()
    end
end
sea_bee.work_idle_table = { to_hammer = 0.40000001, weld = 0.34999999, neutral_to_drill = 0.2, big_hammer = 0.050000001 }
sea_bee.worker_positions = { }
sea_bee.check_proximity = function(arg1, arg2) -- line 1008
    local local1, local2, local3, local4
    local3 = FALSE
    local1, local2 = next(sea_bee.worker_positions, nil)
    while local1 and not local3 do
        local4 = sqrt((arg2.x - local2.x) ^ 2 + (arg2.y - local2.y) ^ 2 + (arg2.z - local2.z) ^ 2)
        if local4 < 1.5 then
            local3 = TRUE
        end
        local1, local2 = next(sea_bee.worker_positions, local1)
    end
    return local3
end
sea_bee.work_idle_movement = function(arg1) -- line 1024
    local local1, local2, local3, local4
    local local5, local6
    local local7, local8
    arg1:set_visibility(FALSE)
    sleep_for(rndint(3000, 5000))
    local4 = nil
    while TRUE do
        sleep_for(rndint(1000, 5000))
        local5 = pick_from_weighted_table(sea_bee.work_idle_table)
        local6 = getglobal("bee_works_" .. local5)
        if local6 == bee_works_to_hammer then
            local1 = sea_bee.work_points
        elseif local6 == bee_works_neutral_to_drill then
            local1 = sea_bee.drill_points
        elseif local6 == bee_works_weld then
            local1 = sea_bee.weld_points
        elseif local6 == bee_works_big_hammer then
            local1 = sea_bee.big_hammer_points
        end
        local3 = rndint(0, local1.count)
        if not local1[local3].used and local3 ~= local4 and not sea_bee:check_proximity(local1[local3].finish) then
            local1[local3].used = TRUE
            local4 = local3
            local2 = local1[local3]
            sea_bee.worker_positions[arg1.hActor] = local1[local3].finish
            arg1:default()
            arg1:play_chore_looping(bee_flavor_wings_flap, "bee_flavor.cos")
            if local6 == bee_works_to_hammer then
                arg1:play_chore(bee_works_show_hmmr_wrnch, "bee_works.cos")
            elseif local6 == bee_works_neutral_to_drill then
                arg1:play_chore(bee_works_show_drill, "bee_works.cos")
            elseif local6 == bee_works_weld then
                arg1:play_chore_looping(bee_works_weld, "bee_works.cos")
            elseif local6 == bee_works_big_hammer then
                arg1:play_chore(bee_works_show_big_hmr, "bee_works.cos")
                arg1:play_chore_looping(bee_works_hold_big_hammer, "bee_works.cos")
            end
            arg1:setpos(local2.start.x, local2.start.y, local2.start.z)
            arg1:setrot(local2.start.pitch, local2.start.yaw, local2.start.roll)
            arg1:set_visibility(TRUE)
            if not sound_playing("beewing.IMU") then
                start_sfx("beewing.IMU", IM_MED_PRIORITY, 0)
                fade_sfx("beewing.IMU", 1000, 70)
                set_pan("beewing.IMU", 100)
            end
            if local6 == bee_works_weld or local6 == bee_works_big_hammer then
                arg1.movement_script = start_script(arg1.fly_to, arg1, local2.finish.x, local2.finish.y, local2.finish.z, FALSE)
                wait_for_script(arg1.movement_script)
                arg1.movement_script = nil
            else
                arg1:play_chore(bee_works_strt_forward, "bee_works.cos")
                arg1.movement_script = start_script(arg1.fly_to, arg1, local2.finish.x, local2.finish.y, local2.finish.z, FALSE)
                arg1:wait_for_chore(bee_works_strt_forward, "bee_works.cos")
                arg1:play_chore_looping(bee_works_fly_forward, "bee_works.cos")
                while not arg1.near_destination do
                    break_here()
                end
                arg1:stop_chore(bee_works_fly_forward, "bee_works.cos")
                arg1:play_chore(bee_works_stop_forward, "bee_works.cos")
                wait_for_script(arg1.movement_script)
                arg1.movement_script = nil
                arg1:wait_for_chore(bee_works_stop_forward, "bee_works.cos")
                arg1:stop_chore(bee_works_stop_forward, "bee_works.cos")
            end
            if local6 == bee_works_to_hammer then
                local7 = 0
                local8 = rndint(1, 3)
                while local7 < local8 do
                    arg1:play_chore(bee_works_show_hmmr_wrnch, "bee_works.cos")
                    arg1:loop_chore_for(bee_works_hover, "bee_works.cos", 500, 1500)
                    arg1:play_chore(bee_works_show_hmmr_wrnch, "bee_works.cos")
                    arg1:play_chore(bee_works_to_hammer, "bee_works.cos")
                    arg1:wait_for_chore(bee_works_to_hammer, "bee_works.cos")
                    arg1:loop_chore_for(bee_works_hammer, "bee_works.cos", 1000, 2000)
                    arg1:play_chore(bee_works_show_hmmr_wrnch, "bee_works.cos")
                    arg1:play_chore(bee_works_stp_hammer, "bee_works.cos")
                    arg1:wait_for_chore(bee_works_stp_hammer, "bee_works.cos")
                    arg1:stop_chore(bee_works_stp_hammer, "bee_works.cos")
                    local7 = local7 + 1
                end
                arg1:play_chore(bee_works_show_hmmr_wrnch, "bee_works.cos")
            elseif local6 == bee_works_neutral_to_drill then
                arg1:play_chore(bee_works_hover, "bee_works.cos")
                arg1:run_chore(bee_works_start_adj_drill, "bee_works.cos")
                arg1:wait_for_chore(bee_works_hover, "bee_works.cos")
                arg1:stop_chore(bee_works_hover, "bee_works.cos")
                arg1:loop_chore_for(bee_works_adj_drill, "bee_works.cos", 1000, 3000)
                arg1:play_chore(bee_works_stop_adj_drill, "bee_works.cos")
                local7 = 0
                local8 = rndint(1, 3)
                while local7 < local8 do
                    arg1:run_chore(bee_works_neutral_to_drill, "bee_works.cos")
                    arg1:loop_chore_for(bee_works_drill_loop, "bee_works.cos", 3000, 5000)
                    arg1:run_chore(bee_works_stop_drill, "bee_works.cos")
                    arg1:run_chore(bee_works_drill_to_neutral, "bee_works.cos")
                    local7 = local7 + 1
                end
                arg1:run_chore(bee_works_hover, "bee_works.cos")
            elseif local6 == bee_works_weld then
                sleep_for(rndint(5000, 6000))
            elseif local6 == bee_works_big_hammer then
                arg1:stop_chore(bee_works_hold_big_hammer, "bee_works.cos")
                local7 = 0
                local8 = rndint(3, 6)
                while local7 < local8 do
                    arg1:run_chore(bee_works_big_hammer, "bee_works.cos")
                    local7 = local7 + 1
                end
            end
            fade_sfx("beewing.IMU", 2000, 0)
            if local6 == bee_works_weld then
                arg1:play_chore(bee_works_stop_weld, "bee_works.cos")
                arg1.movement_script = start_script(arg1.fly_to, arg1, local2.start.x, local2.start.y, local2.start.z, TRUE)
                arg1:wait_for_chore(bee_works_stop_weld, "bee_works.cos")
                arg1:stop_chore(bee_works_stop_weld, "bee_works.cos")
                arg1:play_chore_looping(bee_works_fly_back_hold, "bee_works.cos")
                while not arg1.near_destination do
                    break_here()
                end
                arg1:stop_chore(bee_works_fly_back_hold, "bee_works.cos")
                arg1:run_chore(bee_works_fly_to_neutral, "bee_works.cos")
                arg1:stop_chore(bee_works_fly_to_neutral, "bee_works.cos")
                wait_for_script(arg1.movement_script)
            elseif local6 == bee_works_big_hammer then
                arg1:play_chore_looping(bee_works_hold_big_hammer, "bee_works.cos")
                arg1:fly_to(local2.start.x, local2.start.y, local2.start.z, TRUE)
                arg1:stop_chore(bee_works_hold_big_hammer, "bee_works.cos")
            else
                arg1:play_chore(bee_works_fly_back, "bee_works.cos")
                arg1.movement_script = start_script(arg1.fly_to, arg1, local2.start.x, local2.start.y, local2.start.z, TRUE)
                arg1:wait_for_chore(bee_works_fly_back, "bee_works.cos")
                arg1:stop_chore(bee_works_fly_back, "bee_works.cos")
                arg1:play_chore_looping(bee_works_fly_back_hold, "bee_works.cos")
                while not arg1.near_destination do
                    break_here()
                end
                arg1:stop_chore(bee_works_fly_back_hold, "bee_works.cos")
                arg1:run_chore(bee_works_fly_to_neutral, "bee_works.cos")
                arg1:stop_chore(bee_works_fly_to_neutral, "bee_works.cos")
                wait_for_script(arg1.movement_script)
            end
            arg1.movement_script = nil
            sea_bee.worker_positions[arg1.hActor] = nil
            local1[local3].used = FALSE
            arg1:set_visibility(FALSE)
        end
        break_here()
    end
end
sea_bee.strike_idle_table = Idle:create("bee_strike")
idt = sea_bee.strike_idle_table
idt:add_state("sign_lo", { sign_lo = 0.30000001, hold_lo = 0.30000001, to_sign_hi = 0.30000001, to_akimbo = 0.1 })
idt:add_state("sign_hi", { sign_hi = 0.5, hi_to_lo = 0.5 })
idt:add_state("shake_fist", { shake_fist = 0.5, fist_to_akimbo = 0.5 })
idt:add_state("hold_lo", { sign_lo = 0.2, hold_lo = 0.5, to_sign_hi = 0.1, to_akimbo = 0.2 })
idt:add_state("hi_to_lo", { sign_lo = 0.60000002, hold_lo = 0.2, to_sign_hi = 0.1, to_akimbo = 0.1 })
idt:add_state("fist_to_akimbo", { akimbo_hold = 0.60000002, akimbo_to_lo = 0.30000001, to_fist = 0.1 })
idt:add_state("akimbo_hold", { akimbo_hold = 0.60000002, akimbo_to_lo = 0.30000001, to_fist = 0.1 })
idt:add_state("to_sign_hi", { sign_hi = 0.89999998, hi_to_lo = 0.1 })
idt:add_state("to_fist", { shake_fist = 0.80000001, fist_to_akimbo = 0.2 })
idt:add_state("to_akimbo", { akimbo_hold = 0.80000001, to_fist = 0.2 })
idt:add_state("akimbo_to_lo", { sign_lo = 0.40000001, hold_lo = 0.5, to_sign_hi = 0.050000001, to_akimbo = 0.050000001 })
sea_bee.strike_actor = nil
sea_bee.strike_idles = function(arg1) -- line 1251
    local local1
    local1 = rndint(0, 2)
    if local1 == 0 then
        arg1.strike_idle_script = start_script(arg1.run_strike_idles, arg1, "sign_lo")
    elseif local1 == 1 then
        arg1.strike_idle_script = start_script(arg1.run_strike_idles, arg1, "shake_fist")
    else
        arg1.strike_idle_script = start_script(arg1.run_strike_idles, arg1, "sign_hi")
    end
end
sea_bee.init_strike_stuff = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 1264
    start_script(arg1.do_init_strike, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
sea_bee.do_init_strike = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 1268
    local local1 = rndint(0, 2)
    system:lock_display()
    arg1:setpos(arg2, arg3, arg4)
    arg1:setrot(arg5, arg6, arg7)
    arg1.body:setpos(arg2, arg3, arg4)
    arg1.body:setrot(arg5, arg6, arg7)
    if local1 == 0 then
        local1 = bee_strike_sign_lo
    elseif local1 == 1 then
        local1 = bee_strike_shake_fist
    else
        local1 = bee_strike_sign_hi
    end
    arg1:play_chore(local1, "bee_strike.cos")
    arg1:play_chore(bee_flavor_no_flap, "bee_flavor.cos")
    if arg1 == angry_bees or arg1 == bee1 then
        arg1:complete_chore(bee_stamp_head_only, "bee_stamp.cos")
        arg1.body:play_chore(local1, "bee_strike.cos")
        arg1.body:play_chore(bee_flavor_no_flap, "bee_flavor.cos")
        arg1.body:complete_chore(bee_stamp_hide_head, "bee_stamp.cos")
        break_here()
        arg1.body:freeze()
    elseif arg1 == bee2 then
        arg1.body:free()
        break_here()
        arg1:freeze()
    end
    system:unlock_display()
end
sea_bee.run_strike_idles = function(arg1, arg2) -- line 1310
    local local1
    local local2
    local local3 = system.currentSet
    local local4 = sea_bee.strike_idle_table
    local local5, local6
    arg1.stop_idle = FALSE
    arg1.last_play_chore = nil
    break_here()
    break_here()
    local1 = local4.root_name .. "_" .. arg2
    while system.currentSet == local3 and local1 and not arg1.stop_idle do
        if sea_bee.strike_actor == nil then
            sea_bee.strike_actor = arg1.hActor
            local5 = rndint(20, 30)
            local6 = 0
            if arg1.body then
                arg1.body:thaw(TRUE)
            else
                arg1:thaw(TRUE)
            end
            while local6 < local5 and local1 and not arg1.stop_idle do
                arg1:play_chore(getglobal(local1))
                if arg1.body then
                    arg1.body:play_chore(getglobal(local1))
                end
                arg1.last_chore = getglobal(local1)
                break_here()
                arg1:wait_for_chore()
                if not arg1.stop_idle then
                    if arg1.last_play_chore then
                        if local4[arg1.last_play_chore] then
                            local2 = arg1.last_play_chore
                            arg1.stop_idle = TRUE
                            arg1:play_chore(getglobal(local1))
                            if arg1.body then
                                arg1.body:play_chore(getglobal(local1))
                            end
                            arg1.last_chore = local1
                            break_here()
                            arg1:wait_for_chore()
                        else
                            repeat
                                local1 = arg1.stop_table[arg1.last_chore]
                                arg1:play_chore(local1)
                                if arg1.body then
                                    arg1.body:play_chore(getglobal(local1))
                                end
                                arg1.last_chore = local1
                                arg1:wait_for_chore()
                            until local1 == arg1.last_play_chore
                            arg1.stop_idle = TRUE
                        end
                    else
                        local2 = pick_from_weighted_table(local4[local1])
                    end
                end
                if local2 then
                    local1 = local2
                end
                local6 = local6 + 1
            end
            sea_bee.strike_actor = nil
            if arg1.body then
                arg1.body:freeze()
            else
                arg1:freeze()
            end
        end
        break_here()
    end
end
angry_bees.say_line = function(arg1, arg2) -- line 1394
    Actor.say_line(arg1, arg2)
    start_script(bee1.syncrho_say_line, bee1, arg2, arg1)
end
sea_bee.syncrho_say_line = function(arg1, arg2, arg3) -- line 1399
    arg1:play_chore_looping(bee_flavor_mumble, "bee_flavor.cos")
    while arg3:is_speaking() do
        break_here()
    end
    arg1:stop_chore(bee_flavor_mumble, "bee_flavor.cos")
    arg1:complete_chore(bee_flavor_stop_talk, "bee_flavor.cos")
end
sea_bee.work_points = { }
sea_bee.work_points.count = 13
sea_bee.work_points[0] = { start = { x = 2.8907199, y = -1.73743, z = 4.4555001, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 2.8907199, y = -3.45013, z = 1.9954, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.work_points[1] = { start = { x = 3.80022, y = -1.74993, z = 9.5015001, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.80022, y = -3.43993, z = 2.0090001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.work_points[2] = { start = { x = 4.26262, y = -2.2062299, z = 4.4759998, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 4.26262, y = -2.8482299, z = 2.7046001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.work_points[3] = { start = { x = 5.6776199, y = -2.0313301, z = 4.9797001, pitch = 0, yaw = 160, roll = 0 }, finish = { x = 5.6776199, y = -3.67293, z = 2.3039999, pitch = 0, yaw = 160, roll = 0 } }
sea_bee.work_points[4] = { start = { x = 5.7941198, y = -2.28473, z = 6.0089998, pitch = 0, yaw = 160, roll = 0 }, finish = { x = 5.7941198, y = -4.1632299, z = 2.0706, pitch = 0, yaw = 160, roll = 0 } }
sea_bee.work_points[5] = { start = { x = 10.3385, y = -7.91013, z = 8.7849998, pitch = 0, yaw = 90, roll = 0 }, finish = { x = 10.3385, y = -7.91013, z = 4.9541001, pitch = 0, yaw = 90, roll = 0 } }
sea_bee.work_points[6] = { start = { x = 2.28562, y = -8.1475296, z = 4.9993, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 2.28562, y = -6.8860302, z = 3.2130001, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.work_points[7] = { start = { x = 2.49492, y = -7.4598298, z = 5.2233901, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 2.49492, y = -6.90733, z = 2.6178, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.work_points[8] = { start = { x = 2.49492, y = -4.9109201, z = 4.8497901, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 2.49492, y = -4.4145198, z = 2.0402901, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.work_points[9] = { start = { x = 3.0417199, y = -5.0980201, z = 5.0261898, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 3.0417199, y = -4.23242, z = 2.7037899, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.work_points[10] = { start = { x = 3.5262201, y = -8.3116198, z = 6.0753899, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 3.5262201, y = -6.7236199, z = 2.7533901, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.work_points[11] = { start = { x = 3.2148199, y = -4.9864202, z = 4.0039902, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.2148199, y = -5.6419201, z = 2.93999, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.work_points[12] = { start = { x = 4.8689098, y = -5.4816198, z = 5.6519899, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 4.8689098, y = -5.4950199, z = 3.0330901, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.work_points[13] = { start = { x = 3.92501, y = -1.79282, z = 5.76369, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.92501, y = -4.2494202, z = 1.6821899, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.big_hammer_points = { }
sea_bee.big_hammer_points.count = 4
sea_bee.big_hammer_points[0] = { start = { x = 2.2492299, y = -5.5011201, z = 5.4967899, pitch = 0, yaw = 300, roll = 0 }, finish = { x = 2.2492299, y = -5.5011201, z = 2.7767899, pitch = 0, yaw = 300, roll = 0 } }
sea_bee.big_hammer_points[1] = { start = { x = 3.3292301, y = -7.3206301, z = 5.7274799, pitch = 0, yaw = 30, roll = 0 }, finish = { x = 3.3292301, y = -6.3261299, z = 3.6459799, pitch = 0, yaw = 30, roll = 0 } }
sea_bee.big_hammer_points[2] = { start = { x = 3.39203, y = -4.04213, z = 5.9975801, pitch = 0, yaw = 100, roll = 0 }, finish = { x = 3.39203, y = -4.04213, z = 2.91608, pitch = 0, yaw = 100, roll = 0 } }
sea_bee.big_hammer_points[3] = { start = { x = 3.84533, y = -4.5699301, z = 5.3148799, pitch = 0, yaw = 100, roll = 0 }, finish = { x = 3.84533, y = -4.5699301, z = 2.45228, pitch = 0, yaw = 100, roll = 0 } }
sea_bee.big_hammer_points[4] = { start = { x = 5.9882302, y = -5.45753, z = 8.12008, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 5.9882302, y = -5.45753, z = 4.1080799, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.drill_points = { }
sea_bee.drill_points.count = 9
sea_bee.drill_points[0] = { start = { x = 2.8103199, y = -1.74883, z = 5.0798998, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 2.8103199, y = -3.1138301, z = 2.0854001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[1] = { start = { x = 3.77191, y = -1.92143, z = 5.5978999, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.77191, y = -3.13503, z = 2.1189001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[2] = { start = { x = 4.68891, y = -1.67203, z = 5.7294002, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 4.68891, y = -3.18203, z = 2.2434001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[3] = { start = { x = 5.4423199, y = -2.0043299, z = 5.7424002, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 5.4423199, y = -3.35023, z = 2.3643999, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[4] = { start = { x = 3.7167201, y = -1.1689301, z = 5.5096002, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.7167201, y = -2.82303, z = 2.5515001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[5] = { start = { x = 3.90222, y = -1.60593, z = 5.5855999, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.90222, y = -3.9981301, z = 1.8295, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.drill_points[6] = { start = { x = 7.1019301, y = -4.5686302, z = 8.3982, pitch = 0, yaw = 90, roll = 0 }, finish = { x = 7.1019301, y = -4.5686302, z = 3.3901999, pitch = 0, yaw = 90, roll = 0 } }
sea_bee.drill_points[7] = { start = { x = 8.2294302, y = -6.2635198, z = 8.6535997, pitch = 0, yaw = 90, roll = 0 }, finish = { x = 8.2294302, y = -6.2635198, z = 3.2031, pitch = 0, yaw = 90, roll = 0 } }
sea_bee.drill_points[8] = { start = { x = 3.5317299, y = -8.91222, z = 5.8316002, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 3.5317299, y = -7.39012, z = 2.8211999, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.drill_points[9] = { start = { x = 4.5858202, y = -10.1919, z = 7.1627998, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 4.5858202, y = -7.4458199, z = 4.3002, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.weld_points = { }
sea_bee.weld_points.count = 9
sea_bee.weld_points[0] = { start = { x = 2.4005201, y = -2.34902, z = 5.7907, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 2.4005201, y = -3.64292, z = 2.0611999, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.weld_points[1] = { start = { x = 2.7706201, y = -1.86502, z = 5.2820001, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 2.7706201, y = -3.72402, z = 1.816, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.weld_points[2] = { start = { x = 2.7706201, y = -1.46202, z = 5.5728002, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 2.7706201, y = -3.3210199, z = 2.4913001, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.weld_points[3] = { start = { x = 3.46662, y = -1.99172, z = 5.4166002, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 3.46662, y = -3.6458199, z = 2.0386, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.weld_points[4] = { start = { x = 5.4868202, y = -1.99902, z = 5.1738, pitch = 0, yaw = 180, roll = 0 }, finish = { x = 5.4868202, y = -3.8580201, z = 2.2874, pitch = 0, yaw = 180, roll = 0 } }
sea_bee.weld_points[5] = { start = { x = 6.5672202, y = -4.4411201, z = 6.4329, pitch = 0, yaw = 90, roll = 0 }, finish = { x = 6.5672202, y = -4.4411201, z = 3.2693999, pitch = 0, yaw = 90, roll = 0 } }
sea_bee.weld_points[6] = { start = { x = 7.1017199, y = -6.3796301, z = 8.6829004, pitch = 0, yaw = 90, roll = 0 }, finish = { x = 7.1017199, y = -6.3796301, z = 3.6749001, pitch = 0, yaw = 90, roll = 0 } }
sea_bee.weld_points[7] = { start = { x = 2.3273201, y = -7.8400302, z = 5.9288001, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 2.3273201, y = -6.35953, z = 2.4428, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.weld_points[8] = { start = { x = 4.2172198, y = -9.3459301, z = 7.23949, pitch = 0, yaw = 0, roll = 0 }, finish = { x = 4.2172198, y = -7.7080302, z = 3.4085901, pitch = 0, yaw = 0, roll = 0 } }
sea_bee.weld_points[9] = { start = { x = 6.0967302, y = -4.91502, z = 9.7298899, pitch = 0, yaw = 270, roll = 0 }, finish = { x = 6.0967302, y = -4.91502, z = 3.3143899, pitch = 0, yaw = 270, roll = 0 } }

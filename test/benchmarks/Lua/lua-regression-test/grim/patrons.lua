CheckFirstTime("patrons.lua")
dofile("slisko.lua")
dofile("slisko_meshes.lua")
dofile("gunar.lua")
dofile("gunar_meshes.lua")
dofile("alexi.lua")
dofile("alexi_meshes.lua")
dofile("hooka_guys.lua")
dofile("skinny_girl.lua")
dofile("cig_girl.lua")
slisko.alexi_point = { x = 0.96459, y = -0.956689, z = 0.37 }
slisko.gunnar_point = { x = 0.93819, y = -0.718089, z = 0.4238 }
slisko.manny_point = { x = 0.66149, y = -1.12069, z = 0.3396 }
gunnar.gaze_point = { x = 1.14935, y = -1.53968, z = 0.6306 }
gunnar.say_line = function(arg1, arg2) -- line 28
    gunnar:head_look_at_point(gunnar.gaze_point)
    Actor.say_line(gunnar, arg2)
    gunnar:wait_for_message()
    gunnar:head_look_at(nil)
end
gunnar.default = function(arg1) -- line 35
    gunnar:set_costume(nil)
    gunnar:set_costume("gunar.cos")
    gunnar:set_mumble_chore(gunar_mumble, "gunar.cos")
    gunnar:set_talk_chore(1, gunar_m)
    gunnar:set_talk_chore(2, gunar_a)
    gunnar:set_talk_chore(3, gunar_c)
    gunnar:set_talk_chore(4, gunar_e)
    gunnar:set_talk_chore(5, gunar_f)
    gunnar:set_talk_chore(6, gunar_l)
    gunnar:set_talk_chore(7, gunar_m)
    gunnar:set_talk_chore(8, gunar_o)
    gunnar:set_talk_chore(9, gunar_t)
    gunnar:set_talk_chore(10, gunar_u)
    gunnar:push_costume("gunar_meshes.cos")
    gunnar:set_head(3, 4, 5, 360, 360, 360)
    gunnar:set_look_rate(120)
    gunnar:put_in_set(bi)
    gunnar:setpos(0.86396, -1.0802, -0.01048)
    gunnar:setrot(0, -180.046, 0)
    gunnar:play_chore(gunar_rest, "gunar.cos")
    if not gunnar.body then
        gunnar.body = Actor:create(nil, nil, nil, "gunnar body")
    end
    gunnar.body:set_costume(nil)
    gunnar.body:set_costume("gunar.cos")
    gunnar.body:set_mumble_chore(gunar_mumble, "gunar.cos")
    gunnar.body:set_talk_chore(1, gunar_m)
    gunnar.body:set_talk_chore(2, gunar_a)
    gunnar.body:set_talk_chore(3, gunar_c)
    gunnar.body:set_talk_chore(4, gunar_e)
    gunnar.body:set_talk_chore(5, gunar_f)
    gunnar.body:set_talk_chore(6, gunar_l)
    gunnar.body:set_talk_chore(7, gunar_m)
    gunnar.body:set_talk_chore(8, gunar_o)
    gunnar.body:set_talk_chore(9, gunar_t)
    gunnar.body:set_talk_chore(10, gunar_u)
    gunnar.body:push_costume("gunar_meshes.cos")
    gunnar.body:set_head(3, 4, 5, 360, 360, 360)
    gunnar.body:set_look_rate(120)
    gunnar.body:put_in_set(bi)
    gunnar.body:setpos(0.86396, -1.0802, -0.01048)
    gunnar.body:setrot(0, -180.046, 0)
    gunnar.body:play_chore(gunar_rest, "gunar.cos")
end
gunnar.free = function(arg1) -- line 82
    if gunnar.body then
        gunnar.body:free()
    end
    Actor.free(arg1)
end
slisko.default = function(arg1) -- line 90
    slisko:set_costume(nil)
    slisko:set_costume("slisko.cos")
    slisko:set_mumble_chore(slisko_mumble, "slisko.cos")
    slisko:set_talk_chore(1, slisko_m)
    slisko:set_talk_chore(2, slisko_a)
    slisko:set_talk_chore(3, slisko_c)
    slisko:set_talk_chore(4, slisko_e)
    slisko:set_talk_chore(5, slisko_f)
    slisko:set_talk_chore(6, slisko_l)
    slisko:set_talk_chore(7, slisko_m)
    slisko:set_talk_chore(8, slisko_o)
    slisko:set_talk_chore(9, slisko_t)
    slisko:set_talk_chore(10, slisko_u)
    slisko:push_costume("slisko_meshes.cos")
    slisko:set_head(3, 4, 5, 165, 28, 80)
    slisko:set_talk_color(MakeColor(240, 240, 259))
    slisko:put_in_set(bi)
    slisko:setpos(0.70873, -0.759, 0)
    slisko:setrot(0, 118.693, 0)
    slisko:play_chore(slisko_rest, "slisko.cos")
    if not slisko.body then
        slisko.body = Actor:create(nil, nil, nil, "slisko body")
    end
    slisko.body:set_costume(nil)
    slisko.body:set_costume("slisko.cos")
    slisko.body:set_mumble_chore(slisko_mumble, "slisko.cos")
    slisko.body:set_talk_chore(1, slisko_m)
    slisko.body:set_talk_chore(2, slisko_a)
    slisko.body:set_talk_chore(3, slisko_c)
    slisko.body:set_talk_chore(4, slisko_e)
    slisko.body:set_talk_chore(5, slisko_f)
    slisko.body:set_talk_chore(6, slisko_l)
    slisko.body:set_talk_chore(7, slisko_m)
    slisko.body:set_talk_chore(8, slisko_o)
    slisko.body:set_talk_chore(9, slisko_t)
    slisko.body:set_talk_chore(10, slisko_u)
    slisko.body:push_costume("slisko_meshes.cos")
    slisko.body:set_head(3, 4, 5, 165, 28, 80)
    slisko.body:set_talk_color(MakeColor(240, 240, 259))
    slisko.body:put_in_set(bi)
    slisko.body:setpos(0.70873, -0.759, 0)
    slisko.body:setrot(0, 118.693, 0)
    slisko.body:play_chore(slisko_rest, "slisko.cos")
end
slisko.free = function(arg1) -- line 137
    if slisko.body then
        slisko.body:free()
    end
    Actor.free(arg1)
end
slisko.start_jivin = function(arg1) -- line 144
    start_script(slisko.hand_jive, slisko)
end
slisko.hand_jive = function(arg1) -- line 148
    slisko:stop_chore(slisko_foot_bounce, "slisko.cos")
    slisko:run_chore(slisko_gesture4, "slisko.cos")
    while 1 do
        slisko:run_chore(slisko_hold_hand, "slisko.cos")
        slisko:run_chore(slisko_hold_hand2, "slisko.cos")
    end
end
slisko.stop_jivin = function(arg1) -- line 157
    stop_script(slisko.hand_jive)
    slisko:play_chore(slisko_back_to_rest, "slisko.cos")
end
slisko.start_pointing = function(arg1) -- line 162
    start_script(slisko.point_loop, slisko)
end
slisko.point_loop = function(arg1) -- line 166
    slisko:stop_chore(slisko_foot_bounce, "slisko.cos")
    slisko:run_chore(slisko_gesture1, "slisko.cos")
    while 1 do
        slisko:run_chore(slisko_point, "slisko.cos")
        sleep_for(500 * random())
    end
end
slisko.stop_pointing = function(arg1) -- line 175
    start_script(slisko.wait_for_pointing, slisko)
end
slisko.wait_for_pointing = function(arg1) -- line 179
    stop_script(slisko.point_loop)
    slisko:wait_for_chore(slisko_point, "slisko.cos")
    slisko:play_chore(slisko_back_to_rest, "slisko.cos")
end
slisko.hand_up = function(arg1) -- line 185
    slisko:play_chore(slisko_talk_to_the_hand, "slisko.cos")
end
slisko.hand_down = function(arg1) -- line 189
    slisko:play_chore(slisko_back_to_rest, "slisko.cos")
end
alexi.default = function(arg1) -- line 194
    alexi:set_costume(nil)
    alexi:set_costume("alexi.cos")
    alexi:set_mumble_chore(alexi_mumble, "alexi.cos")
    alexi:set_talk_chore(1, alexi_m)
    alexi:set_talk_chore(2, alexi_a)
    alexi:set_talk_chore(3, alexi_c)
    alexi:set_talk_chore(4, alexi_e)
    alexi:set_talk_chore(5, alexi_f)
    alexi:set_talk_chore(6, alexi_l)
    alexi:set_talk_chore(7, alexi_m)
    alexi:set_talk_chore(8, alexi_o)
    alexi:set_talk_chore(9, alexi_t)
    alexi:set_talk_chore(10, alexi_u)
    alexi:push_costume("alexi_meshes.cos")
    alexi:put_in_set(bi)
    alexi:setpos(0.44737, -1.06348, -0.13499)
    alexi:setrot(0.1937, 155, 3.7804)
    alexi:play_chore(alexi_rest, "alexi.cos")
    if not alexi.body then
        alexi.body = Actor:create(nil, nil, nil, "alexi body")
    end
    alexi.body:set_costume(nil)
    alexi.body:set_costume("alexi.cos")
    alexi.body:set_mumble_chore(alexi_mumble, "alexi.cos")
    alexi.body:set_talk_chore(1, alexi_m)
    alexi.body:set_talk_chore(2, alexi_a)
    alexi.body:set_talk_chore(3, alexi_c)
    alexi.body:set_talk_chore(4, alexi_e)
    alexi.body:set_talk_chore(5, alexi_f)
    alexi.body:set_talk_chore(6, alexi_l)
    alexi.body:set_talk_chore(7, alexi_m)
    alexi.body:set_talk_chore(8, alexi_o)
    alexi.body:set_talk_chore(9, alexi_t)
    alexi.body:set_talk_chore(10, alexi_u)
    alexi.body:push_costume("alexi_meshes.cos")
    alexi.body:put_in_set(bi)
    alexi.body:setpos(0.44737, -1.06348, -0.13499)
    alexi.body:setrot(0.1937, 155, 3.7804)
    alexi.body:play_chore(alexi_rest, "alexi.cos")
end
alexi.free = function(arg1) -- line 239
    if alexi.body then
        alexi.body:free()
    end
    Actor.free(arg1)
end
bi.idle_reds = function() -- line 246
    bi.alexi_pause_idles = FALSE
    if not alexi.frozen then
        if alexi.body.frozen then
            alexi.body:thaw(TRUE)
            break_here()
        end
        alexi.body:set_visibility(FALSE)
        alexi:complete_chore(alexi_meshes_show_all, "alexi_meshes.cos")
        alexi:freeze()
    end
    if slisko.frozen or gunnar.frozen or slisko.body.frozen or gunnar.body.frozen then
        slisko:thaw()
        slisko.body:thaw()
        slisko.body:set_visibility(TRUE)
        gunnar:thaw()
        gunnar.body:thaw(TRUE)
        gunnar.body:set_visibility(TRUE)
        break_here()
    end
    slisko.body:set_visibility(TRUE)
    slisko.body:complete_chore(slisko_meshes_all_but_head_foot, "slisko_meshes.cos")
    slisko.body:freeze()
    slisko:complete_chore(slisko_meshes_just_head_foot, "slisko_meshes.cos")
    gunnar.body:set_visibility(TRUE)
    gunnar.body:complete_chore(gunar_meshes_all_but_head_hand, "gunar_meshes.cos")
    gunnar.body:freeze()
    gunnar:complete_chore(gunar_meshes_just_hand_head, "gunar_meshes.cos")
    break_here()
    slisko:play_chore_looping(slisko_foot_bounce, "slisko.cos")
    gunnar:play_chore_looping(gunar_tap_cycle, "gunar.cos")
    while TRUE do
        sleep_for(5000 + 5000 * random())
        if not bi.alexi_pause_idles then
            alexi:thaw(TRUE)
            alexi:complete_chore(alexi_meshes_show_all, "alexi_meshes.cos")
            alexi.body:thaw(TRUE)
            alexi.body:set_visibility(FALSE)
            if rnd() then
                break_here()
                alexi:run_chore(alexi_gesture8, "alexi.cos")
                alexi:loop_chore_for(alexi_chin_cycle, "alexi.cos", 3000, 5000)
                alexi:run_chore(alexi_gesture9, "alexi.cos")
                alexi:run_chore(alexi_gesture10, "alexi.cos")
                alexi:run_chore(alexi_gesture11, "alexi.cos")
            else
                alexi.body:set_visibility(TRUE)
                alexi.body:complete_chore(alexi_meshes_all_but_head, "alexi_meshes.cos")
                alexi:complete_chore(alexi_meshes_just_head, "alexi_meshes.cos")
                break_here()
                alexi.body:freeze()
                alexi:run_chore(alexi_look_at_gunar, "alexi.cos")
                sleep_for(2000 + 3000 * random())
                alexi:run_chore(alexi_gesture1, "alexi.cos")
                alexi:play_chore(alexi_rest, "alexi.cos")
            end
        end
        break_here()
        if not bi.alexi_pause_idles then
            alexi:freeze()
        end
    end
end
bi.alexi_talking = function() -- line 319
    bi.alexi_pause_idles = TRUE
    alexi:thaw(TRUE)
    alexi.body:thaw(TRUE)
    alexi.body:set_visibility(FALSE)
    alexi:complete_chore(alexi_meshes_show_all, "alexi_meshes.cos")
    break_here()
end
bi.alexi_not_talking = function() -- line 329
    bi.alexi_pause_idles = FALSE
end
bi.idle_beats = function() -- line 333
    local local1
    while TRUE do
        sleep_for(3000 * random())
        if system.frameTime < 66 then
            local1 = rndint(1, 4)
            if local1 == 1 then
                hooka_guy1:thaw(TRUE)
                if rnd() then
                    hooka_guy1:run_chore(hooka_guys_gesture1, "hooka_guys.cos")
                    sleep_for(1000)
                    hooka_guy1:run_chore(hooka_guys_gesture2, "hooka_guys.cos")
                else
                    hooka_guy1:run_chore(hooka_guys_gesture3, "hooka_guys.cos")
                    sleep_for(1000)
                    hooka_guy1:run_chore(hooka_guys_back_to_rest, "hooka_guys.cos")
                end
                hooka_guy1:freeze()
            elseif local1 == 2 then
                hooka_guy2:thaw(TRUE)
                if rnd() then
                    hooka_guy2:run_chore(hooka_guys_gesture1, "hooka_guys.cos")
                    sleep_for(1000)
                    hooka_guy2:run_chore(hooka_guys_gesture2, "hooka_guys.cos")
                else
                    hooka_guy2:run_chore(hooka_guys_gesture3, "hooka_guys.cos")
                    sleep_for(1000)
                    hooka_guy2:run_chore(hooka_guys_back_to_rest, "hooka_guys.cos")
                end
                hooka_guy2:freeze()
            elseif local1 == 3 then
                cig_girl:thaw(TRUE)
                if rnd() then
                    cig_girl:run_chore(cig_girl_gesture3, "cig_girl.cos")
                    sleep_for(1000)
                    cig_girl:run_chore(cig_girl_gesture1, "cig_girl.cos")
                else
                    cig_girl:run_chore(cig_girl_gesture3, "cig_girl.cos")
                    cig_girl:run_chore(cig_girl_gesture4, "cig_girl.cos")
                    sleep_for(1000)
                    cig_girl:run_chore(cig_girl_gesture5, "cig_girl.cos")
                    cig_girl:run_chore(cig_girl_gesture1, "cig_girl.cos")
                end
                cig_girl:freeze()
            elseif local1 == 4 and not skinny_girl.passed_out then
                skinny_girl:thaw(TRUE)
                if rnd() then
                    skinny_girl:run_chore(skinny_girl_gesture1, "skinny_girl.cos")
                    sleep_for(1000)
                    skinny_girl:run_chore(skinny_girl_gesture2, "skinny_girl.cos")
                else
                    skinny_girl:run_chore(skinny_girl_gesture3, "skinny_girl.cos")
                    sleep_for(1000)
                    skinny_girl:run_chore(skinny_girl_back_to_rest, "skinny_girl.cos")
                end
                skinny_girl:freeze()
            end
        end
    end
end
bi.freeze_all_beatniks = function() -- line 396
    stop_script(bi.idle_reds)
    stop_script(bi.idle_beats)
    skinny_girl:freeze()
    cig_girl:freeze()
    hooka_guy1:freeze()
    hooka_guy2:freeze()
    alexi:freeze()
    alexi.body:freeze()
    gunnar:freeze()
    gunnar.body:freeze()
    slisko:freeze()
    slisko.body:freeze()
end
bi.snap_sfx = function() -- line 411
    local local1
    while 1 do
        if rndint(4) == 3 then
            start_sfx(pick_one_of({ "bisnp1.wav", "bisnp2.wav", "bisnp3.wav" }), nil, 80)
        end
        local1 = single_start_sfx("beatsnap.imu", IM_LOW_PRIORITY)
        set_vol(local1, rndint(50, 120))
        sleep_for(rnd(100, 250))
        fade_sfx("beatsnap.imu", 100, 0)
    end
end
bi.snap = function() -- line 427
    start_script(bi.snap_sfx)
    stop_script(bi.idle_reds)
    stop_script(bi.idle_beats)
    alexi:thaw(TRUE)
    alexi:complete_chore(alexi_meshes_show_all, "alexi_meshes.cos")
    alexi.body:thaw(TRUE)
    alexi.body:set_visibility(FALSE)
    alexi:stop_chore(nil, "alexi.cos")
    alexi:play_chore(alexi_rest, "alexi.cos")
    if slisko.frozen then
        slisko:thaw(TRUE)
        slisko:complete_chore(slisko_meshes_show_everything, "slisko_meshes.cos")
        slisko.body:thaw(TRUE)
        slisko.body:set_visibility(FALSE)
    end
    slisko:stop_chore(slisko_foot_bounce, "slisko.cos")
    slisko:complete_chore(slisko_rest, "slisko.cos")
    if hooka_guy1.frozen then
        hooka_guy1:thaw(TRUE)
    end
    if hooka_guy2.frozen then
        hooka_guy2:thaw(TRUE)
    end
    break_here()
    slisko:play_chore(slisko_begin_snap, "slisko.cos")
    alexi:play_chore(alexi_begin_snap, "alexi.cos")
    hooka_guy2:play_chore(hooka_guys_begin_snap, "hooka_guys.cos")
    hooka_guy1:play_chore(hooka_guys_begin_snap, "hooka_guys.cos")
    slisko:wait_for_chore(slisko_begin_snap, "slisko.cos")
    slisko:play_chore_looping(slisko_snap_cycle, "slisko.cos")
    alexi:wait_for_chore(alexi_begin_snap, "alexi.cos")
    alexi:play_chore_looping(alexi_snap_cycle, "alexi.cos")
    hooka_guy2:wait_for_chore(hooka_guys_begin_snap, "hooka_guys.cos")
    hooka_guy2:play_chore_looping(hooka_guys_snap_cycle, "hooka_guys.cos")
    hooka_guy1:wait_for_chore(hooka_guys_begin_snap, "hooka_guys.cos")
    hooka_guy1:play_chore_looping(hooka_guys_snap_cycle, "hooka_guys.cos")
    sleep_for(2000)
    hooka_guy1:stop_chore(hooka_guys_snap_cycle, "hooka_guys.cos")
    hooka_guy1:play_chore(hooka_guys_end_snap, "hooka_guys.cos")
    hooka_guy2:stop_chore(hooka_guys_snap_cycle, "hooka_guys.cos")
    hooka_guy2:play_chore(hooka_guys_end_snap, "hooka_guys.cos")
    alexi:stop_chore(alexi_snap_cycle, "alexi.cos")
    alexi:play_chore(alexi_end_snap, "alexi.cos")
    slisko:stop_chore(slisko_snap_cycle, "slisko.cos")
    slisko:play_chore(slisko_end_snap, "slisko.cos")
    hooka_guy1:wait_for_chore(hooka_guys_end_snap, "hooka_guys.cos")
    hooka_guy2:wait_for_chore(hooka_guys_end_snap, "hooka_guys.cos")
    alexi:wait_for_chore(alexi_end_snap, "alexi.cos")
    slisko:wait_for_chore(slisko_end_snap, "slisko.cos")
    hooka_guy1:freeze()
    hooka_guy2:freeze()
    start_script(bi.idle_reds)
    stop_script(bi.snap_sfx)
    fade_sfx("beatsnap.imu")
end
bi.manny_follow_conversation = function() -- line 502
    local local1
    while system.currentSet == bi do
        local1 = system.lastActorTalking
        if local1 == slisko then
            manny:head_look_at(bi.commies)
        elseif local1 == gunnar then
            manny:head_look_at_point({ x = 0.89162898, y = -1.08314, z = 0.46200001 })
        elseif local1 == alexi then
            manny:head_look_at(bi.commies2)
        end
        while local1 == system.lastActorTalking do
            break_here()
        end
    end
end
bi.one_hiss = function(arg1) -- line 517
    break_here()
    slisko:say_line("/bisl131/")
end

CheckFirstTime("hk.lua")
dofile("aitor_cask.lua")
dofile("aitor_idles.lua")
dofile("cask.lua")
dofile("hk_pantry.lua")
dofile("mc_pantry.lua")
dofile("gl_cask.lua")
dofile("manny_cut_cask.lua")
dofile("raoul_cask.lua")
dofile("mc_cask.lua")
hk = Set:create("hk.set", "high roller kitchen", { hk_cskws = 0, hk_ovrhd = 1 })
hk.cask_actor = Actor:create(nil, nil, nil, "Cask")
hk.cask_actor.default = function(arg1) -- line 24
    arg1:set_costume("cask.cos")
    arg1:put_in_set(hk)
    arg1:set_softimage_pos(-6.0836, 0, -2.8973)
    arg1:setrot(0, 268.437, 0)
    arg1:set_visibility(TRUE)
    arg1:play_chore(cask_show, "cask.cos")
end
hk.scythe_actor = Actor:create(nil, nil, nil, "Scythe in pantry")
hk.scythe_actor.default = function(arg1) -- line 34
    arg1:set_costume("mc_pantry.cos")
    arg1:put_in_set(hk)
    arg1:setpos(-0.19374, -0.11101, 0)
    arg1:setrot(0, 270, 0)
end
hk.manny_pull_in_scythe = function(arg1) -- line 41
    manny:ignore_boxes()
    manny:put_in_set(hk)
    manny:set_visibility(TRUE)
    manny:setpos(0.0757646, 1.04339, 0.5602)
    manny:setrot(0, 163.017, 0)
    manny:push_costume("mc_cask.cos")
    glottis:play_chore(gl_cask_hide_scythe, "gl_cask.cos")
    manny:play_chore(mc_cask_cask_scythe, "mc_cask.cos")
    manny:wait_for_chore(mc_cask_cask_scythe, "mc_cask.cos")
    manny:stop_chore(mc_cask_cask_scythe, "mc_cask.cos")
    manny:pop_costume()
end
hk.stowaway = function(arg1) -- line 55
    hk.raoul_trapped = TRUE
    hl.glottis_gambling = TRUE
    START_CUT_SCENE()
    cur_puzzle_state[20] = TRUE
    set_override(hk.skip_stowaway, hk)
    manny:walkto(0.10168, 0.28562, 0.78821, 0, 6.394, 0)
    manny:wait_for_actor()
    break_here()
    manny:push_costume("manny_cut_cask.cos")
    manny:play_chore(manny_cut_cask_into_cask, "manny_cut_cask.cos")
    manny:wait_for_chore(manny_cut_cask_into_cask, "manny_cut_cask.cos")
    manny:stop_chore(manny_cut_cask_into_cask, "manny_cut_cask.cos")
    manny:pop_costume()
    manny:put_in_set(nil)
    IrisDown(355, 245, 1000)
    sleep_for(1500)
    hl:switch_to_set()
    hl:current_setup(hl_glot)
    stop_script(hl.glottis_idle)
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    IrisUp(215, 280, 1000)
    glottis:say_line("/hkgl001/")
    sleep_for(1500)
    glottis:wait_for_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:wait_for_message()
    sleep_for(1000)
    break_here()
    glottis:stop_chore(gl_gamble_talks_drunk, "gl_gamble.cos")
    hk.pantry:unlock()
    hk:switch_to_set()
    hk.cask_actor:set_visibility(FALSE)
    glottis:put_in_set(hk)
    glottis:set_costume(nil)
    glottis:set_costume("glottis_tux.cos")
    glottis:set_mumble_chore(glottis_mumble)
    glottis:set_talk_color(Orange)
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
    glottis:setpos(-0.606111, 0.330135, 0)
    glottis:setrot(0, 268.446, 0)
    glottis:push_costume("gl_cask.cos")
    raoul:set_costume(nil)
    raoul:set_costume("raoul_cask.cos")
    raoul:set_talk_color(Red)
    raoul:set_mumble_chore(raoul_cask_mumble)
    raoul:set_talk_chore(1, raoul_cask_no_talk)
    raoul:set_talk_chore(2, raoul_cask_a)
    raoul:set_talk_chore(3, raoul_cask_c)
    raoul:set_talk_chore(4, raoul_cask_e)
    raoul:set_talk_chore(5, raoul_cask_f)
    raoul:set_talk_chore(6, raoul_cask_l)
    raoul:set_talk_chore(7, raoul_cask_m)
    raoul:set_talk_chore(8, raoul_cask_o)
    raoul:set_talk_chore(9, raoul_cask_t)
    raoul:set_talk_chore(10, raoul_cask_u)
    raoul:ignore_boxes()
    raoul:put_in_set(hk)
    raoul:setpos(0.325089, -0.0250647, 0)
    raoul:setrot(0, 90, 0)
    raoul:set_visibility(FALSE)
    glottis:play_chore(gl_cask_to_cask, "gl_cask.cos")
    glottis:wait_for_chore(gl_cask_to_cask, "gl_cask.cos")
    hk.cask_actor:set_visibility(FALSE)
    glottis:stop_chore(gl_cask_to_cask, "gl_cask.cos")
    glottis:play_chore(gl_cask_to_closet, "gl_cask.cos")
    sleep_for(1000)
    music_state:set_sequence(seqGlottNoWine)
    glottis:say_line("/hkgl002/")
    glottis:wait_for_message()
    sleep_for(200)
    hk:manny_knocked_around()
    sleep_for(1500)
    glottis:say_line("/hkgl003/")
    sleep_for(1300)
    hk:manny_knocked_around()
    glottis:wait_for_message()
    glottis:wait_for_chore(gl_cask_to_closet, "gl_cask.cos")
    glottis:stop_chore(gl_cask_to_closet, "gl_cask.cos")
    glottis:play_chore(gl_cask_to_out_raoul, "gl_cask.cos")
    glottis:say_line("/hkgl004/")
    glottis:wait_for_message()
    glottis:wait_for_chore(gl_cask_to_out_raoul, "gl_cask.cos")
    glottis:stop_chore(gl_cask_to_out_raoul, "gl_cask.cos")
    raoul:set_visibility(TRUE)
    glottis:play_chore(gl_cask_out_raoul, "gl_cask.cos")
    raoul:play_chore(raoul_cask_fall, "raoul_cask.cos")
    sleep_for(100)
    hk.pantry:open_anim()
    raoul:say_line("/hkra005/")
    raoul:wait_for_message()
    raoul:wait_for_chore(raoul_cask_fall, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_fall, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_fall_hold, "raoul_cask.cos")
    glottis:say_line("/hkgl006/")
    raoul:wait_for_chore(raoul_cask_fall_hold, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_fall_hold, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_out, "raoul_cask.cos")
    glottis:wait_for_message()
    glottis:say_line("/hkgl007/")
    raoul:wait_for_chore(raoul_cask_out, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_out, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_to_feet, "raoul_cask.cos")
    glottis:wait_for_message()
    raoul:wait_for_chore(raoul_cask_to_feet, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_to_feet, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_head_hold, "raoul_cask.cos")
    raoul:say_line("/hkra008/")
    glottis:wait_for_chore(gl_cask_out_raoul, "gl_cask.cos")
    glottis:play_chore(gl_cask_hide_glottis, "gl_cask.cos")
    raoul:wait_for_message()
    raoul:say_line("/hkra009/")
    raoul:wait_for_chore(raoul_cask_head_hold, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_head_hold, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_turn_back, "raoul_cask.cos")
    raoul:wait_for_message()
    start_script(hk.manny_pull_in_scythe, hk)
    raoul:say_line("/hkra010/")
    raoul:wait_for_chore(raoul_cask_turn_back, "raoul_cask.cos")
    raoul:stop_chore(raoul_cask_turn_back, "raoul_cask.cos")
    raoul:play_chore(raoul_cask_turn_back_hold, "raoul_cask.cos")
    raoul:wait_for_message()
    raoul:say_line("/hkra011/")
    raoul:wait_for_message()
    raoul:say_line("/hkra012/")
    raoul:wait_for_message()
    raoul:wait_for_chore(raoul_cask_turn_back_hold, "raoul_cask.cos")
    IrisDown(380, 300, 1000)
    sleep_for(1500)
    he.aitor_downstairs = TRUE
    wc.de_door:open()
    wc:switch_to_set()
    hk.cask_actor:default()
    hk.cask_actor:put_in_set(wc)
    hk.cask_actor:set_visibility(TRUE)
    hk.cask_actor:setpos(2.07433, 0.1397, -0.3473)
    hk.cask_actor:setrot(0, 180, 0)
    aitor:set_costume(nil)
    aitor:set_costume("aitor_cask.cos")
    aitor:stop_chore()
    aitor:put_in_set(wc)
    aitor:ignore_boxes()
    aitor:set_collision_mode(COLLISION_OFF)
    aitor:setpos(1.10153, -2.2523, 0.5211)
    aitor:setrot(0, 180, 0)
    de.forklift_actor:default()
    de.forklift_actor:put_in_set(wc)
    de.forklift_actor:setpos(0.934834, -2.1862, 0)
    de.forklift_actor:setrot(0, 14.7653, 0)
    de.forklift_actor:play_chore(forklift_down_hold)
    aitor:stop_chore(aitor_cask_in_elev, "aitor_cask.cos")
    IrisUp(200, 330, 1000)
    aitor:play_chore(aitor_cask_out_forklift_roll, "aitor_cask.cos")
    sleep_for(7300)
    hk.cask_actor:set_visibility(FALSE)
    sleep_for(200)
    start_sfx("wcCaskDn.WAV")
    sleep_for(900)
    start_sfx("hkCaskRl.IMU")
    sleep_for(500)
    fade_sfx("hkCaskRl.IMU", 500)
    start_sfx("hkCskBnc.WAV")
    sleep_for(2000)
    wc.de_door:play_chore(wc_door_close)
    aitor:wait_for_chore(aitor_cask_out_forklift_roll, "aitor_cask.cos")
    stop_sound("hkCaskRl.IMU")
    wc.de_door:wait_for_chore(wc_door_close)
    wc.de_door:close()
    aitor:put_in_set(nil)
    aitor:stop_chore(aitor_cask_out_forklift_roll, "aitor_cask.cos")
    manny:put_in_set(wc)
    manny:ignore_boxes()
    manny:setpos(-0.70697, -1.30588, 0.8022)
    manny:setrot(0, 688.391, 0)
    manny:set_visibility(TRUE)
    manny:push_costume("manny_cut_cask.cos")
    manny:play_chore(manny_cut_cask_cask_out, "manny_cut_cask.cos")
    manny:wait_for_chore(manny_cut_cask_cask_out, "manny_cut_cask.cos")
    manny:stop_chore(manny_cut_cask_cask_out, "manny_cut_cask.cos")
    manny:pop_costume()
    manny:follow_boxes()
    manny:setpos(-0.46517, -0.93618, 0.0210001)
    manny:setrot(0, 320, 0)
    if mo.scythe.owner ~= manny then
        mo.scythe:get()
    end
    hk.raoul_quit = TRUE
    hk.pantry:unlock()
    hk.pantry:open()
    aitor:free()
    END_CUT_SCENE()
end
hk.skip_stowaway = function(arg1) -- line 288
    kill_override()
    stop_sound("hkCaskRl.IMU")
    he.aitor_downstairs = TRUE
    hk.raoul_quit = TRUE
    hk.pantry:unlock()
    hk.pantry:open()
    if mo.scythe.owner ~= manny then
        mo.scythe:get()
    end
    raoul:free()
    aitor:free()
    glottis:free()
    wc:switch_to_set()
    wc.de_door:close()
    stop_sound("hkCaskRl.IMU")
    IrisUp(0, 0, 1)
    manny:default("cafe")
    manny:put_in_set(wc)
    manny:follow_boxes()
    manny:set_visibility(TRUE)
    manny:setpos(-0.46517, -0.93618, 0.0210001)
    manny:setrot(0, 320, 0)
end
hk.manny_knocked_around = function(arg1) -- line 317
    manny:say_line(pick_one_of({ "/hkma013/", "/hkma014/Ah!", "/hkma015/Uh!" }), { background = TRUE, skip_log = TRUE })
end
hk.remove_scythe = function(arg1) -- line 321
    START_CUT_SCENE()
    manny:walkto(-0.19374, -0.11101, 0, 0, 270, 0)
    manny:wait_for_actor()
    break_here()
    manny:stop_chore()
    manny:set_costume(nil)
    manny:set_costume("mc_pantry.cos")
    manny:play_chore(mc_pantry_scythe_unblock, "mc_pantry.cos")
    hk.scythe_actor:put_in_set(nil)
    manny:wait_for_chore(mc_pantry_scythe_unblock, "mc_pantry.cos")
    manny:stop_chore(mc_pantry_scythe_unblock, "mc_pantry.cos")
    manny:default("cafe")
    mo.scythe:get()
    manny.is_holding = mo.scythe
    manny:play_chore_looping(mc_hold_scythe, "mc.cos")
    END_CUT_SCENE()
    hk.pantry:unlock()
end
hk.put_up_new_cask = function(arg1) -- line 341
    local local1
    hk.seen_swap = TRUE
    START_CUT_SCENE()
    he.aitor_downstairs = TRUE
    set_override(hk.skip_put_up_cask, hk)
    aitor:default()
    aitor:put_in_set(hk)
    aitor:setpos(-0.63693899, 0.64820302, 0)
    aitor:setrot(0, 1.7168, 0)
    aitor:set_turn_rate(10)
    aitor:play_chore(aitor_cask_roll_cask, "aitor_cask.cos")
    start_sfx("hkCaskRl.imu")
    sleep_for(600)
    local1 = 1
    while local1 < 27 do
        local1 = local1 + 1
        aitor:setrot(0, local1, 0)
        break_here()
    end
    while aitor:is_turning() do
        break_here()
    end
    stop_sound("hkCaskRl.imu")
    he:switch_to_set()
    aitor:put_in_set(he)
    aitor:setpos(-0.57912201, -1.4167, 0)
    aitor:setrot(0, 167.819, 0)
    aitor:stop_chore(aitor_cask_roll_cask, "aitor_cask.cos")
    aitor:play_chore(aitor_cask_roll_cask, "aitor_cask.cos")
    start_sfx("hkCaskRl.imu")
    sleep_for(3000)
    stop_sound("hkCaskRl.imu")
    aitor:wait_for_chore(aitor_cask_roll_cask, "aitor_cask.cos")
    he.elevator:play_chore(0, "he_door.cos")
    he.elevator:wait_for_chore(0, "he_door.cos")
    aitor:play_chore(aitor_cask_in_elev, "aitor_cask.cos")
    sleep_for(500)
    start_sfx("hkCaskRl.imu")
    sleep_for(500)
    fade_sfx("hkCaskRl.imu", 200, 0)
    start_sfx("hkCskBnc.WAV")
    sleep_for(2500)
    he.elevator:play_chore(1, "he_door.cos")
    he.elevator:wait_for_chore(1, "he_door.cos")
    hk:switch_to_set()
    manny:put_in_set(hk)
    manny:setpos(-1.2446899, 0.178395, 0)
    stop_sound("hkCaskRl.IMU")
    manny:setrot(0, 222.498, 0)
    END_CUT_SCENE()
end
hk.skip_put_up_cask = function(arg1) -- line 404
    kill_override()
    aitor:stop_chore(nil, "aitor_cask.cos")
    aitor:put_in_set(nil)
    he.elevator:complete_chore(1, "he_door.cos")
    hk:switch_to_set()
    manny:put_in_set(hk)
    manny:setpos(-1.24469, 0.178395, 0)
    manny:setrot(0, 222.498, 0)
    stop_sound("hkCaskRl.IMU")
end
hk.look_meat = function(arg1) -- line 418
    soft_script()
    if not hk.cans1.seen then
        hk.cans1.seen = TRUE
        manny:say_line("/hkma016/")
        wait_for_message()
        manny:say_line("/hkma017/")
    else
        manny:say_line("/hkma018/")
    end
end
hk.spill_wine = function() -- line 430
    stop_script(hk.raoul_in_the_kitchen)
    START_CUT_SCENE()
    manny:walkto_object(hk.spigot)
    manny:play_chore(mc_hand_on_obj, "mc.cos")
    manny:wait_for_chore(mc_hand_on_obj, "mc.cos")
    hk.cask_actor:play_chore(cask_start_pour, "cask.cos")
    hk.cask_actor:wait_for_chore(cask_start_pour, "cask.cos")
    hk.cask_actor:play_chore(cask_pour_loop, "cask.cos")
    hk.cask_actor:play_chore(cask_floor_spill_start, "cask.cos")
    hk.cask_actor:wait_for_chore(cask_floor_spill_start, "cask.cos")
    hk.cask_actor:play_chore_looping(cask_spill_loop, "cask.cos")
    sleep_for(2000)
    if hk.raoul_in_kitchen and not hk.pantry:is_open() then
        hk.pantry:open_anim()
        hk.pantry:open()
    end
    if not hk.spilled_wine then
        hk.spilled_wine = TRUE
        if not hk.raoul_in_kitchen then
            raoul:default()
        end
        raoul:say_line("/hkra019/", { x = 100, y = 60 })
        sleep_for(500)
        manny:head_look_at_point(-1.38276, -0.127603, 0.4706)
        wait_for_message()
        if not hk.raoul_in_kitchen then
            raoul:put_in_set(hk)
            raoul:setpos(-1.525, 0.2219, 0)
            raoul:setrot(0, 290.017, 0)
            raoul:walkto(-1.0506, 0.2219, 0)
        else
            MakeSectorActive("pantry_box", TRUE)
            raoul:follow_boxes()
            if find_script(hk.raoul_leave_pantry) then
                stop_script(hk.raoul_leave_pantry)
            end
            hk.raoul_in_pantry = FALSE
            if hk.pantry:is_open() then
                box_on("pantry_box")
            end
            raoul:walkto(-1.0506, 0.2219, 0, 0, 290.017, 0)
        end
        manny:play_chore(mc_hand_off_obj, "mc.cos")
        hk.cask_actor:play_chore(cask_end_pour, "cask.cos")
        sleep_for(500)
        manny:setrot(0, 120.11, 0, TRUE)
        manny:wait_for_chore(mc_hand_off_obj, "mc.cos")
        manny:stop_chore(mc_hand_off_obj, "mc.cos")
        manny:wait_for_actor()
        hk.cask_actor:stop_chore(cask_spill_loop, "cask.cos")
        hk.cask_actor:play_chore(cask_spill_done, "cask.cos")
        manny:shrug_gesture()
        manny:say_line("/hkma020/")
        wait_for_message()
        raoul:say_line("/hkra021/")
        wait_for_message()
        raoul:say_line("/hkra022/")
        wait_for_message()
        manny:hand_gesture()
        manny:say_line("/hkma023/")
        wait_for_message()
        if hk.glottis_gambling then
            raoul:say_line("/hkra024/")
        else
            raoul:say_line("/hkra025/")
            wait_for_message()
            raoul:say_line("/hkra026/")
        end
    else
        raoul:say_line("/hkra027/")
        sleep_for(500)
        if not hk.raoul_in_kitchen then
            raoul:default()
            raoul:put_in_set(hk)
            raoul:setpos(-1.525, 0.2219, 0)
            raoul:setrot(0, 290.017, 0)
            raoul:walkto(-1.0506, 0.2219, 0)
        else
            MakeSectorActive("pantry_box", TRUE)
            raoul:follow_boxes()
            if find_script(hk.raoul_leave_pantry) then
                stop_script(hk.raoul_leave_pantry)
            end
            hk.raoul_in_pantry = FALSE
            if hk.pantry:is_open() then
                box_on("pantry_box")
            end
            raoul:walkto(-1.0506, 0.2219, 0, 0, 290.017, 0)
        end
        manny:head_look_at_point(-1.38276, -0.127603, 0.4706)
        wait_for_message()
        manny:play_chore(mc_hand_off_obj, "mc.cos")
        hk.cask_actor:play_chore(cask_end_pour, "cask.cos")
        sleep_for(500)
        manny:setrot(0, 120.11, 0, TRUE)
        manny:wait_for_chore(mc_hand_off_obj, "mc.cos")
        manny:stop_chore(mc_hand_off_obj, "mc.cos")
        manny:wait_for_actor()
        hk.cask_actor:stop_chore(cask_spill_loop, "cask.cos")
        hk.cask_actor:play_chore(cask_spill_done, "cask.cos")
        manny:shrug_gesture()
        manny:say_line("/hkma028/")
        wait_for_message()
        raoul:say_line("/hkra029/")
    end
    MakeSectorActive("pantry_box", FALSE)
    manny:walkto(hk.hl_door, TRUE)
    manny:wait_for_actor()
    wait_for_message()
    hk.raoul_in_kitchen = TRUE
    hl:switch_to_set()
    hl:current_setup(hl_elews)
    manny:put_in_set(hl)
    manny:setpos(-2.00906, 0.587105, 0)
    manny:setrot(0, 56.5524, 0)
    END_CUT_SCENE()
end
hk.change_casks = function() -- line 565
    START_CUT_SCENE()
    raoul:say_line("/hkra030/")
    wait_for_message()
    raoul:say_line("/hkra031/")
    wait_for_message()
    raoul:say_line("/hkra032/")
    wait_for_message()
    raoul:say_line("/hkra033/")
    wait_for_message()
    raoul:say_line("/hkra034/")
    END_CUT_SCENE()
end
hk.raoul_collision = function(arg1) -- line 579
    raoul:say_line(pick_one_of({ "/hkra035/", "/hkra036/", "/hkra037/", "/hkra038/", "/hkra039/", "/hkra040/", "/hkra041/", "/hkra042/", "/hkra043/", "/hkra044/", "/hkra045/", "/hkra046/", "/hkra047/", "/hkra048/" }, { background = TRUE, skip_log = TRUE }))
end
hk.raoul_in_the_kitchen = function() -- line 598
    local local1
    local local2, local3, local4, local5
    local local6
    while TRUE do
        local1 = 20000 + random() * 7000
        sleep_for(local1)
        while cutSceneLevel > 0 or system.currentSet ~= hk do
            break_here()
        end
        START_CUT_SCENE()
        hk.raoul_in_kitchen = TRUE
        raoul:default("walks")
        raoul:put_in_set(hk)
        raoul:setpos(-1.525, 0.2219, 0)
        raoul:setrot(0, 290.017, 0)
        if manny:find_sector_name("hit_raoul_box") and (not manny:find_sector_name("hkladder") and not manny:find_sector_name("pantry_top")) then
            manny:head_look_at_point(-1.525, 0.2219, 0.5)
            manny:walkto(-0.64321899, -0.38552901, 0)
        end
        if not hk.caught then
            hk.caught = TRUE
            raoul:say_line("/hkra049/", { background = TRUE, x = 100, y = 60 })
            sleep_for(500)
            raoul:walkto(-1.0506001, 0.2219, 0)
            raoul:wait_for_actor()
            local4 = manny:getpos()
            local2 = GetActorYawToPoint(raoul.hActor, local4)
            raoul:setrot(0, local2, 0, TRUE)
            local4 = raoul:getpos()
            local3 = GetActorYawToPoint(manny.hActor, local4)
            manny:setrot(0, local3, 0, TRUE)
            manny:head_look_at_point(local4.x, local4.y, local4.z + 0.5)
            raoul:wait_for_message()
            raoul:say_line("/hkra050/")
            wait_for_message()
            raoul:say_line("/hkra051/")
            wait_for_message()
            raoul:say_line("/hkra052/")
            wait_for_message()
            manny:head_look_at(nil)
            manny:head_forward_gesture()
            manny:say_line("/hkma053/")
            wait_for_message()
            raoul:say_line("/hkra054/")
        else
            raoul:say_line(pick_one_of({ "/hkra055/", "/hkra056/", "/hkra057/", "/hkra058/", "/hkra059/", "/hkra060/" }, { background = TRUE, x = 100, y = 60 }))
            sleep_for(500)
            raoul:walkto(-1.0506001, 0.2219, 0)
            raoul:wait_for_actor()
            local4 = manny:getpos()
            local2 = GetActorYawToPoint(raoul.hActor, local4)
            raoul:setrot(0, local2, 0, TRUE)
            local4 = raoul:getpos()
            local3 = GetActorYawToPoint(manny.hActor, local4)
            manny:head_look_at_point(local4.x, local4.y, local4.z + 0.5)
            manny:setrot(0, local3, 0, TRUE)
        end
        raoul:wait_for_message()
        raoul:walkto(-0.30647701, -0.0536948, 0, 0, 269.98001, 0)
        raoul:wait_for_actor()
        if not hk.pantry:is_open() then
            if hk.pantry.locked then
                raoul:say_line("/hkra061/")
                manny:head_look_at(hk.pantry)
                raoul:wait_for_message()
                raoul:set_walk_rate(-GetActorWalkRate(raoul.hActor))
                local5 = 0
                while local5 < 15 do
                    WalkActorForward(raoul.hActor)
                    break_here()
                    local5 = local5 + 1
                end
                raoul:set_walk_rate(-GetActorWalkRate(raoul.hActor))
                hk.pantry:use()
                wait_for_message()
                manny:wait_for_actor()
                manny:head_look_at(nil)
                manny:walkto(-0.263825, -0.641334, 0, 0, 3.35269, 0)
                raoul:say_line("/hkra062/")
                raoul:wait_for_message()
            end
            raoul:walkto(-0.263951, -0.0593265, 0.0099999998, 0, 227.842, 0)
            raoul:wait_for_actor()
            raoul:set_rest_chore(-1)
            raoul:stop_chore(ra_walks_idle, "ra_walks.cos")
            raoul:play_chore(ra_walks_open_pantry, "ra_walks.cos")
            sleep_for(700)
            hk.pantry:open_anim()
            raoul:wait_for_chore(ra_walks_open_pantry, "ra_walks.cos")
            raoul:set_rest_chore(ra_walks_idle, "ra_walks.cos")
        end
        hk.pantry:close()
        hk.pantry.opened = TRUE
        MakeSectorActive("door1_box", FALSE)
        MakeSectorActive("door2_box", FALSE)
        hk.raoul_in_pantry = TRUE
        MakeSectorActive("pantry_box", TRUE)
        raoul:walkto(0.22499999, -0.0155022, 0, 0, 270.021, 0)
        raoul:wait_for_actor()
        raoul:ignore_boxes()
        MakeSectorActive("pantry_box", FALSE)
        manny:head_look_at(nil)
        END_CUT_SCENE()
        single_start_script(hk.raoul_leave_pantry)
        while find_script(hk.raoul_leave_pantry) do
            break_here()
        end
    end
end
hk.raoul_leave_pantry = function() -- line 732
    local local1
    local local2
    local local3
    sleep_for(25000)
    while cutSceneLevel > 0 do
        break_here()
    end
    if not hk.pantry:is_open() then
        if hk.pantry:is_locked() then
            if not find_script(hk.trap_raoul) then
                start_script(hk.trap_raoul)
            end
        else
            hk:almost_trap_raoul()
            hk.raoul_in_kitchen = FALSE
        end
    else
        hk.raoul_in_pantry = FALSE
        hk.raoul_in_kitchen = FALSE
        START_CUT_SCENE()
        if manny:find_sector_name("hit_raoul_box") and not manny:find_sector_name("hkladder") and not manny:find_sector_name("pantry_top") then
            manny:head_look_at(hk.pantry)
            manny:walkto(-0.64321899, -0.38552901, 0)
            sleep_for(500)
        end
        MakeSectorActive("pantry_box", TRUE)
        raoul:follow_boxes()
        raoul:default("walks")
        raoul:put_in_set(hk)
        raoul:setpos(0.22499999, -0.0155022, 0)
        raoul:setrot(0, 270.021, 0)
        raoul:walkto(-1.0506001, 0.2219, 0)
        manny:head_look_at(nil)
        while raoul:is_moving() do
            local3 = raoul:getpos()
            local1 = GetActorYawToPoint(manny.hActor, local3)
            manny:setrot(0, local1, 0, TRUE)
            break_here()
        end
        local3 = manny:getpos()
        local2 = GetActorYawToPoint(raoul.hActor, local3)
        raoul:setrot(0, local2, 0, TRUE)
        raoul:say_line("/hkra063/")
        raoul:wait_for_message()
        raoul:walkto(-1.525, 0.2219, 0)
        raoul:wait_for_actor()
        raoul:put_in_set(nil)
        MakeSectorActive("pantry_box", FALSE)
        hk.pantry:open()
        END_CUT_SCENE()
    end
end
hk.almost_trap_raoul = function() -- line 793
    local local1, local2
    while system.currentSet == cafe_inv or cutSceneLevel > 0 do
        break_here()
    end
    if system.currentSet == hk then
        START_CUT_SCENE()
        if manny:find_sector_name("hit_raoul_box") and not manny:find_sector_name("hkpantry") and not manny:find_sector_name("pantry_top") then
            manny:head_look_at(hk.pantry)
            manny:walkto(-0.64321899, -0.38552901, 0)
            sleep_for(500)
        end
        MakeSectorActive("pantry_box", TRUE)
        hk.pantry.opened = TRUE
        hk.raoul_in_pantry = FALSE
        wait_for_message()
        hk.pantry:open_anim()
        raoul:follow_boxes()
        raoul:default("walks")
        raoul:put_in_set(hk)
        raoul:follow_boxes()
        raoul:setpos(0.22499999, -0.0155022, 0)
        raoul:setrot(0, 270.021, 0)
        raoul:walkto(-0.30647701, -0.0536948, 0)
        raoul:wait_for_actor()
        local2 = manny:getpos()
        local1 = GetActorYawToPoint(raoul.hActor, local2)
        raoul:setrot(0, local1, 0)
        local2 = raoul:getpos()
        local1 = GetActorYawToPoint(manny.hActor, local2)
        raoul:say_line("/hkra064/")
        sleep_for(500)
        manny:setrot(0, local1, 0, TRUE)
        if not hk.tried_trapping then
            hk.tried_trapping = TRUE
            wait_for_message()
            raoul:say_line("/hkra065/")
            wait_for_message()
            raoul:say_line("/hkra066/")
            wait_for_message()
            raoul:say_line("/hkra067/")
        end
        raoul:wait_for_message()
        END_CUT_SCENE()
        raoul:walkto(-1.525, 0.2219, 0)
        raoul:wait_for_actor()
        raoul:put_in_set(nil)
        MakeSectorActive("door1_box", FALSE)
        MakeSectorActive("door2_box", FALSE)
    else
        hk.pantry.opened = TRUE
        MakeSectorActive("door1_box", FALSE)
        MakeSectorActive("door2_box", FALSE)
        hk.raoul_in_pantry = FALSE
        raoul:put_in_set(nil)
    end
end
hk.trap_raoul = function() -- line 859
    stop_script(hk.raoul_in_the_kitchen)
    hk.raoul_trapped = TRUE
    cur_puzzle_state[19] = TRUE
    START_CUT_SCENE()
    wait_for_message()
    manny:head_look_at(nil)
    set_override(hk.skip_trap_raoul, hk)
    manny:walkto(-1.525, 0.236379, 0, 0, 82.7411, 0)
    manny:wait_for_actor()
    manny:put_in_set(nil)
    start_sfx("hpknock1.wav")
    wait_for_sound("hpknock1.wav")
    raoul:say_line("/hkra068/")
    wait_for_message()
    start_sfx("hpknock1.wav")
    raoul:say_line("/hkra069/")
    wait_for_message()
    raoul:say_line("/hkra070/")
    wait_for_message()
    start_sfx("hpknock2.WAV")
    wait_for_sound("hpknock2.WAV")
    raoul:say_line("/hkra071/")
    wait_for_message()
    start_sfx("hpknock2.wav")
    raoul:say_line("/hkra072/")
    wait_for_message()
    raoul:say_line("/hkra073/")
    wait_for_message()
    start_sfx("hpknock3.wav")
    raoul:say_line("/hkra074/")
    wait_for_message()
    start_sfx("hpknock3.wav")
    raoul:say_line("/hkra075/")
    wait_for_message()
    hp:switch_to_set()
    raoul:stop_chore()
    raoul:set_costume(nil)
    raoul:set_costume("ra_bonked.cos")
    raoul:ignore_boxes()
    raoul:put_in_set(hp)
    raoul:setpos(-0.01509, -0.32876, 0)
    raoul:setrot(0, 541.536, 0)
    music_state:set_sequence(seqRaoulKO)
    raoul:play_chore(ra_bonked_knock_out, "ra_bonked.cos")
    raoul:say_line("/hkra076/")
    wait_for_message()
    raoul:say_line("/hkra077/")
    wait_for_message()
    sleep_for(500)
    hl:switch_to_set()
    hl:current_setup(hl_glot)
    sleep_for(1000)
    stop_script(hl.glottis_idle)
    wait_for_message()
    glottis:stop_chore(nil, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    sleep_for(500)
    glottis:stop_chore(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:say_line("/hkgl078/")
    glottis:wait_for_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_turn_speak, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:wait_for_message()
    sleep_for(1000)
    glottis:set_chore_looping(gl_gamble_talks_drunk, FALSE, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_talks_drunk, "gl_gamble.cos")
    glottis:play_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:wait_for_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:stop_chore(gl_gamble_speak_to_rest_gambling, "gl_gamble.cos")
    glottis:play_chore_looping(gl_gamble_rest_gambling2, "gl_gamble.cos")
    glottis:say_line("/hkgl079/")
    glottis:wait_for_message()
    hk:switch_to_set()
    glottis:put_in_set(hk)
    glottis:set_softimage_pos(-6.0836, 0, -2.8973)
    glottis:setrot(0, 268.402, 0)
    glottis:stop_chore()
    glottis:set_costume(nil)
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
    glottis:push_costume("gl_cask.cos")
    glottis:play_chore(gl_cask_to_cask, "gl_cask.cos")
    glottis:wait_for_chore(gl_cask_to_cask, "gl_cask.cos")
    glottis:stop_chore(gl_cask_to_cask, "gl_cask.cos")
    hk.cask_actor:set_visibility(FALSE)
    music_state:set_sequence(seqGlottDrinkWine)
    glottis:play_chore(gl_cask_drink_cask, "gl_cask.cos")
    sleep_for(4500)
    glottis:say_line("/hkgl110/")
    sleep_for(6500)
    glottis:say_line("/hkgl080/")
    glottis:wait_for_message()
    glottis:wait_for_chore(gl_cask_drink_cask, "gl_cask.cos")
    glottis:put_in_set(nil)
    glottis:pop_costume()
    hk.cask_actor:set_visibility(TRUE)
    sleep_for(2000)
    manny:put_in_set(hk)
    manny:setpos(-1.525, 0.236379, 0)
    manny:setrot(0, 82.7411, 0)
    manny:walkto(-1.0506, 0.2219, 0)
    END_CUT_SCENE()
    hk.cask_empty = TRUE
end
hk.skip_trap_raoul = function(arg1) -- line 990
    kill_override()
    stop_script(hk.pantry.use_scythe)
    stop_script(hk.almost_trap_raoul)
    stop_script(hk.raoul_leave_pantry)
    hk.cask_empty = TRUE
    raoul:free()
    glottis:free()
    hk:switch_to_set()
    hk.cask_actor:set_visibility(TRUE)
    manny:default()
    manny:put_in_set(hk)
    manny:setpos(-1.0506, 0.2219, 0)
    manny:setrot(0, 262, 0)
end
hk.set_up_baster = function(arg1) -- line 1010
    if hk.turkey_baster.touchable then
        if not hk.baster_actor then
            hk.baster_actor = Actor:create(nil, nil, nil, "turkey baster")
        end
        hk.baster_actor:set_costume("baster.cos")
        hk.baster_actor:put_in_set(hk)
        hk.baster_actor:setpos(-1.29752, -1.45604, 0.1859)
        hk.baster_actor:setrot(0, 133.475, 90)
        hk.baster_actor:set_visibility(TRUE)
    elseif hk.baster_actor then
        hk.baster_actor:set_costume(nil)
    end
end
hk.set_up_pantry_and_cask = function(arg1) -- line 1027
    NewObjectState(hk_cskws, OBJSTATE_STATE, "hk_pantry_doors.bm", "hk_pantry_doors.zbm")
    hk.pantry:set_object_state("hk_pantry.cos")
    if hk.pantry:is_open() then
        MakeSectorActive("pantry_box", TRUE)
        hk.pantry:play_chore(hk_pantry_set_open)
        MakeSectorActive("door1_box", FALSE)
        MakeSectorActive("door2_box", FALSE)
    else
        MakeSectorActive("pantry_box", FALSE)
        hk.pantry:play_chore(hk_pantry_set_closed)
        MakeSectorActive("door1_box", TRUE)
        MakeSectorActive("door2_box", TRUE)
    end
    if hk.pantry:is_locked() then
        hk.scythe_actor:default()
        hk.scythe_actor:play_chore(mc_pantry_scythe_end, "mc_pantry.cos")
    end
    hk.cask_actor:default()
end
hk.ladder_monitor = function(arg1) -- line 1050
    local local1
    local local2
    while hk.bMonitorLadder do
        if manny:find_sector_name("hkladder") then
            local1 = TRUE
            if manny.is_running then
                manny:set_run(FALSE)
                manny:force_auto_run(FALSE)
                stop_script(monitor_run)
                manny.is_running = FALSE
            end
            local2 = find_stair_chore()
            manny:set_walk_chore(local2)
            manny:set_turn_chores(-1, -1)
            if manny.is_backward then
                manny:set_walk_rate(-0.25)
            else
                manny:set_walk_rate(0.25)
            end
            manny:set_time_scale(0.75)
        elseif local1 then
            local1 = FALSE
            manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
            if manny.is_backward then
                manny:set_walk_rate(-0.40000001)
            else
                manny:set_walk_rate(0.40000001)
            end
            if manny.is_running then
                manny:set_walk_chore(ms_run)
            elseif not manny.is_backward then
                manny:set_walk_chore(ms_walk)
            end
            manny:set_time_scale(1)
        end
        if manny:find_sector_name("pantry_top") or manny:find_sector_name("hkladder") then
            if not hk.upper_cask.touchable then
                hk.upper_cask:make_touchable()
            end
            if hk.lower_cask.touchable then
                hk.lower_cask:make_untouchable()
            end
        else
            if hk.upper_cask.touchable then
                hk.upper_cask:make_untouchable()
            end
            if not hk.lower_cask.touchable then
                hk.lower_cask:make_touchable()
            end
        end
        break_here()
    end
    manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
    if manny.is_backward then
        manny:set_walk_rate(-0.40000001)
    else
        manny:set_walk_rate(0.40000001)
    end
    if manny.is_running then
        manny:set_walk_chore(ms_run)
    elseif not manny.is_backward then
        manny:set_walk_chore(ms_walk)
    end
    manny:set_time_scale(1)
end
hk.enter = function(arg1) -- line 1132
    if system.lastSet ~= hp and system.lastSet ~= he then
        he.aitor_downstairs = FALSE
    end
    if not hk.raoul_quit and not hk.raoul_trapped and hl.glottis_gambling then
        if hk.raoul_in_pantry then
            start_script(hk.raoul_leave_pantry)
        elseif not find_script(hk.raoul_in_the_kitchen) then
            start_script(hk.raoul_in_the_kitchen)
        end
    end
    if not hk.seen_swap then
        start_script(hk.put_up_new_cask, hk)
    end
    start_script(hk.set_up_pantry_and_cask)
    hk.upper_cask:make_touchable()
    hk.lower_cask:make_untouchable()
    hk.bMonitorLadder = TRUE
    start_script(hk.ladder_monitor, hk)
    hk:set_up_baster()
    start_sfx("he_hk_hp.imu", nil, 90)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.6, -0.4, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(aitor.hActor, 0)
    SetActorShadowPoint(aitor.hActor, 0, 0.4, 4)
    SetActorShadowPlane(aitor.hActor, "shadow1")
    AddShadowPlane(aitor.hActor, "shadow1")
    SetActiveShadow(glottis.hActor, 0)
    SetActorShadowPoint(glottis.hActor, 0, 0.4, 4)
    SetActorShadowPlane(glottis.hActor, "shadow1")
    AddShadowPlane(glottis.hActor, "shadow1")
end
hk.exit = function() -- line 1179
    raoul:free()
    glottis:free()
    hk.cask_actor:free()
    hk.scythe_actor:free()
    stop_script(hk.raoul_in_the_kitchen)
    stop_script(hk.raoul_leave_pantry)
    if hk.raoul_in_pantry and hk.pantry:is_open() then
        hk.raoul_in_pantry = FALSE
    end
    hk.bMonitorLadder = FALSE
    stop_sound("he_hk_hp.imu")
    stop_sound("hkCaskRl.imu")
    KillActorShadows(manny.hActor)
    KillActorShadows(aitor.hActor)
    KillActorShadows(glottis.hActor)
end
hk.pantry = Object:create(hk, "/hktx081/pantry", 0.15539999, -0.107379, 0.40560001, { range = 0.89999998 })
hk.pantry.use_pnt_x = -0.15346
hk.pantry.use_pnt_y = -0.099749997
hk.pantry.use_pnt_z = 0
hk.pantry.use_rot_x = 0
hk.pantry.use_rot_y = 269.978
hk.pantry.use_rot_z = 0
hk.pantry.passage = { "pantry_box" }
Object.close(hk.pantry)
hk.pantry.lookAt = function(arg1) -- line 1222
    if hk.raoul_quit then
        manny:say_line("/hkma084/")
    elseif hk.raoul_trapped then
        manny:say_line("/hkma082/")
    elseif hk.raoul_in_pantry then
        manny:say_line("/hkma083/")
    else
        manny:say_line("/hkma084/")
    end
end
hk.pantry.open = function(arg1) -- line 1238
    if not hk.pantry.locked then
        if not hk.raoul_in_pantry then
            MakeSectorActive("pantry_box", TRUE)
        end
        MakeSectorActive("door1_box", FALSE)
        MakeSectorActive("door2_box", FALSE)
        hk.pantry.opened = TRUE
    end
end
hk.pantry.close = function(arg1) -- line 1249
    arg1.opened = FALSE
    MakeSectorActive("pantry_box", FALSE)
    MakeSectorActive("door1_box", TRUE)
    MakeSectorActive("door2_box", TRUE)
end
hk.pantry.use = function(arg1) -- line 1257
    if arg1.opened then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        hk.pantry:manny_close()
        arg1:close()
        END_CUT_SCENE()
    elseif not hk.pantry.locked then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        hk.pantry:manny_open()
        END_CUT_SCENE()
        arg1:open()
    elseif hk.raoul_trapped and not hk.raoul_quit then
        manny:say_line("/hkma085/")
    else
        START_CUT_SCENE()
        hk:remove_scythe()
        END_CUT_SCENE()
    end
end
hk.pantry.use_scythe = function(arg1) -- line 1283
    if hk.raoul_in_kitchen and not hk.raoul_in_pantry then
        system.default_response("hes watching")
    else
        START_CUT_SCENE()
        hk.pantry:lock()
        manny:wait_for_actor()
        if hk.pantry:is_open() then
            manny:clear_hands()
            hk.pantry:use()
            manny.is_holding = mo.scythe
            close_inventory()
        end
        manny:wait_for_actor()
        manny:walkto(-0.19374, -0.11101, 0, 0, 270, 0)
        manny:wait_for_actor()
        break_here()
        manny:set_costume(nil)
        manny:set_costume("mc_pantry.cos")
        manny:play_chore(mc_pantry_scythe_block, "mc_pantry.cos")
        manny:wait_for_chore(mc_pantry_scythe_block, "mc_pantry.cos")
        manny:stop_chore(mc_pantry_scythe_block, "mc_pantry.cos")
        mo.scythe:put_in_limbo()
        hk.scythe_actor:default()
        hk.scythe_actor:play_chore(mc_pantry_scythe_end, "mc_pantry.cos")
        manny:default("cafe")
        if not hk.raoul_in_pantry then
            manny:say_line("/hkma086/")
        end
        END_CUT_SCENE()
        if hk.raoul_in_pantry and not hk.raoul_quit then
            if not find_script(hk.trap_raoul) then
                start_script(hk.trap_raoul)
            end
        end
    end
end
hk.pantry.manny_open = function(arg1) -- line 1323
    manny:push_costume("mc_pantry.cos")
    manny:play_chore(mc_pantry_open_pantry, "mc_pantry.cos")
    sleep_for(1000)
    arg1:open_anim()
    manny:wait_for_chore(mc_pantry_open_pantry, "mc_pantry.cos")
    manny:pop_costume()
end
hk.pantry.manny_close = function(arg1) -- line 1332
    manny:push_costume("mc_pantry.cos")
    manny:play_chore(mc_pantry_close_pantry, "mc_pantry.cos")
    sleep_for(800)
    arg1:close_anim()
    manny:wait_for_chore(mc_pantry_close_pantry, "mc_pantry.cos")
    manny:pop_costume()
end
hk.pantry.open_anim = function(arg1, arg2) -- line 1341
    arg1:play_chore(hk_pantry_open)
    if arg2 then
        arg1:wait_for_chore(hk_pantry_open)
    end
end
hk.pantry.close_anim = function(arg1, arg2) -- line 1348
    arg1:play_chore(hk_pantry_close)
    if arg2 then
        arg1:wait_for_chore(hk_pantry_close)
    end
end
hk.turkey_baster = Object:create(hk, "/hktx087/turkey baster", -1.31265, -1.46042, 0.2122, { range = 0.69999999 })
hk.turkey_baster.use_pnt_x = -1.17172
hk.turkey_baster.use_pnt_y = -1.4248101
hk.turkey_baster.use_pnt_z = 0
hk.turkey_baster.use_rot_x = 0
hk.turkey_baster.use_rot_y = 97.965897
hk.turkey_baster.use_rot_z = 0
hk.turkey_baster.string_name = "turkey_baster"
hk.turkey_baster.full = FALSE
hk.turkey_baster.lookAt = function(arg1) -- line 1369
    arg1.seen = TRUE
    if arg1.full then
        manny:say_line("/hkma088/")
    else
        manny:say_line("/hkma089/")
    end
end
hk.turkey_baster.pickUp = function(arg1) -- line 1378
    START_CUT_SCENE()
    preload_sfx("tkBstEmp.wav")
    box_on("baster_box")
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(mc_reach_med, "mc.cos")
    sleep_for(200)
    start_sfx("pikUpSm1.wav")
    sleep_for(300)
    hk.baster_actor:put_in_set(nil)
    hk.baster_actor:free()
    manny:generic_pickup(hk.turkey_baster)
    sleep_for(500)
    if not arg1.seen then
        arg1:lookAt()
    end
    manny:walkto(-1.01433, -1.2922, 0.01, 0, 277.703, 0)
    manny:wait_for_actor()
    box_off("baster_box")
    END_CUT_SCENE()
end
hk.turkey_baster.use = function(arg1) -- line 1401
    if arg1.owner ~= manny then
        arg1:pickUp()
    elseif arg1.full then
        manny:say_line("/hkma090/")
    else
        system.default_response("empty")
    end
end
hk.cans1 = Object:create(hk, "/hktx091/cans", -0.81084001, 1.285, 0.75, { range = 0.89999998 })
hk.cans1.use_pnt_x = -0.57084101
hk.cans1.use_pnt_y = 1.075
hk.cans1.use_pnt_z = 0
hk.cans1.use_rot_x = 0
hk.cans1.use_rot_y = -339.52399
hk.cans1.use_rot_z = 0
hk.cans1.lookAt = function(arg1) -- line 1422
    start_script(hk.look_meat)
end
hk.cans1.pickUp = function(arg1) -- line 1426
    if not hk.cans1.seen then
        soft_script()
        start_script(hk.cans1.lookAt)
        wait_for_message()
    end
    manny:say_line("/hkma092/")
end
hk.cans1.use = hk.cans1.pickUp
hk.cans2 = Object:create(hk, "/hktx093/cans", -0.23084, 1.285, 0.75, { range = 0.89999998 })
hk.cans2.parent = hk.cans1
hk.lower_cask = Object:create(hk, "/hktx094/cask", -0.202126, 0.60840797, 0.47, { range = 0.56800002 })
hk.lower_cask.use_pnt_x = -0.44212601
hk.lower_cask.use_pnt_y = 0.60840797
hk.lower_cask.use_pnt_z = 0
hk.lower_cask.use_rot_x = 0
hk.lower_cask.use_rot_y = -90.2407
hk.lower_cask.use_rot_z = 0
hk.lower_cask.lookAt = function(arg1) -- line 1452
    if not hk.cask_empty then
        manny:say_line("/hkma095/")
    else
        manny:say_line("/hkma096/")
    end
end
hk.lower_cask.pickUp = function(arg1) -- line 1460
    system.default_response("hernia")
end
hk.lower_cask.use = function(arg1) -- line 1464
    hk.spigot:use()
end
hk.upper_cask = Object:create(hk, "/hktx097/cask top", 0.042674098, 0.495, 1.09, { range = 0.80000001 })
hk.upper_cask.use_pnt_x = 0.192674
hk.upper_cask.use_pnt_y = 0.27500001
hk.upper_cask.use_pnt_z = 0.79000002
hk.upper_cask.use_rot_x = 0
hk.upper_cask.use_rot_y = 19.224001
hk.upper_cask.use_rot_z = 0
hk.upper_cask.lookAt = function(arg1) -- line 1476
    if arg1:is_open() then
        manny:say_line("/hkma098/")
    else
        manny:say_line("/hkma099/")
    end
end
hk.upper_cask.pickUp = function(arg1) -- line 1484
    system.default_response("hernia")
end
hk.upper_cask.use = function(arg1) -- line 1488
    if hk.upper_cask:is_open() then
        if hk.raoul_quit then
            system.default_response("already")
        else
            hk:stowaway()
        end
    else
        manny:say_line("/hkma100/")
    end
end
hk.upper_cask.use_opener = function(arg1) -- line 1500
    if hk.cask_empty then
        arg1:open()
        ks.opener:put_in_limbo()
        START_CUT_SCENE()
        manny:walkto(0.10168, 0.28562, 0.78821, 0, 6.394, 0)
        manny:wait_for_actor()
        break_here()
        manny:push_costume("manny_cut_cask.cos")
        manny.is_holding = nil
        manny:stop_chore(mc_hold, "mc.cos")
        manny:stop_chore(mc_activate_opener, "mc.cos")
        manny:play_chore(manny_cut_cask_open_cask, "manny_cut_cask.cos")
        manny:wait_for_chore(manny_cut_cask_open_cask, "manny_cut_cask.cos")
        manny:stop_chore(manny_cut_cask_open_cask, "manny_cut_cask.cos")
        manny:pop_costume()
        start_sfx("canodrop.wav")
        END_CUT_SCENE()
    else
        manny:say_line("/hkma101/")
        wait_for_message()
        manny:say_line("/hkma102/")
    end
end
hk.spigot = Object:create(hk, "/hktx103/spigot", -0.25212499, 0.75840801, 0.40000001, { range = 0.60000002 })
hk.spigot.use_pnt_x = -0.50125802
hk.spigot.use_pnt_y = 0.45089701
hk.spigot.use_pnt_z = 0
hk.spigot.use_rot_x = 0
hk.spigot.use_rot_y = 328.70599
hk.spigot.use_rot_z = 0
hk.spigot.lookAt = function(arg1) -- line 1534
    if hk.cask_empty then
        manny:say_line("/hkma104/")
    else
        manny:say_line("/hkma105/")
    end
end
hk.spigot.use = function(arg1) -- line 1542
    if hk.cask_empty then
        START_CUT_SCENE()
        manny:walkto_object(hk.spigot)
        manny:play_chore(mc_hand_on_obj, "mc.cos")
        manny:wait_for_chore(mc_hand_on_obj, "mc.cos")
        sleep_for(1000)
        manny:say_line("/hkma106/")
        manny:play_chore(mc_hand_off_obj, "mc.cos")
        manny:wait_for_chore(mc_hand_off_obj, "mc.cos")
        manny:stop_chore(mc_hand_off_obj, "mc.cos")
        END_CUT_SCENE()
    else
        hk.spill_wine()
    end
end
hk.hl_door = Object:create(hk, "/hktx107/door", -1.53781, 0.247998, 0.5, { range = 0.60000002 })
hk.hl_box = hk.hl_door
hk.hl_door.use_pnt_x = -1.3292
hk.hl_door.use_pnt_y = 0.34085199
hk.hl_door.use_pnt_z = 0
hk.hl_door.use_rot_x = 0
hk.hl_door.use_rot_y = -996.15698
hk.hl_door.use_rot_z = 0
hk.hl_door.out_pnt_x = -1.525
hk.hl_door.out_pnt_y = 0.36189801
hk.hl_door.out_pnt_z = 0
hk.hl_door.out_rot_x = 0
hk.hl_door.out_rot_y = -996.15698
hk.hl_door.out_rot_z = 0
hk.hl_door.touchable = FALSE
hk.hl_door.walkOut = function(arg1) -- line 1586
    hl:come_out_door(hl.hk_door)
end
hk.hl_door.lookAt = function(arg1) -- line 1590
    hk:stowaway()
end
hk.he_door = Object:create(hk, "/hktx108/door", 0.66874599, -1.1433901, 0.46000001, { range = 0.60000002 })
hk.he_box = hk.he_door
hk.he_door.use_pnt_x = 0.34310499
hk.he_door.use_pnt_y = -1.22596
hk.he_door.use_pnt_z = 0
hk.he_door.use_rot_x = 0
hk.he_door.use_rot_y = -114.147
hk.he_door.use_rot_z = 0
hk.he_door.out_pnt_x = 0.45079899
hk.he_door.out_pnt_y = -1.2742
hk.he_door.out_pnt_z = 0
hk.he_door.out_rot_x = 0
hk.he_door.out_rot_y = -114.147
hk.he_door.out_rot_z = 0
hk.he_door.touchable = FALSE
hk.he_door.walkOut = function(arg1) -- line 1616
    he:come_out_door(he.hk_door)
end
hk.hp_door = Object:create(hk, "/hktx109/pantry", 0.0021869901, -0.132002, 0.46000001, { range = 0 })
hk.hp_door.use_pnt_x = -0.12865099
hk.hp_door.use_pnt_y = -0.088504396
hk.hp_door.use_pnt_z = 0
hk.hp_door.use_rot_x = 0
hk.hp_door.use_rot_y = -82.705704
hk.hp_door.use_rot_z = 0
hk.hp_door.out_pnt_x = 0.14630499
hk.hp_door.out_pnt_y = -0.0533056
hk.hp_door.out_pnt_z = 0
hk.hp_door.out_rot_x = 0
hk.hp_door.out_rot_y = -82.705704
hk.hp_door.out_rot_z = 0
hk.hp_door:make_untouchable()
hk.hp_box = hk.hp_door
hk.hp_door.walkOut = function(arg1) -- line 1644
    if not manny:find_sector_name("pantry_top") then
        hp:come_out_door(hp.hk_door)
    end
end

CheckFirstTime("glottis_scripts.lua")
dofile("glottis.lua")
dofile("gl_akimbo_idles.lua")
dofile("glottis_sailor.lua")
glottis = Actor:create(nil, nil, nil, "Glottis")
glottis:set_talk_color(Orange)
glottis:set_look_rate(200)
glottis.start_rocking = function(arg1) -- line 17
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:run_chore(glottis_trans_rock, "glottis.cos")
    glottis:head_look_at(nil, 60)
    glottis:play_chore_looping(glottis_rock_loop, "glottis.cos")
end
glottis.stop_rocking = function(arg1, arg2) -- line 24
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:stop_looping_chore(glottis_rock_loop, "glottis.cos")
    glottis:play_chore(glottis_trans_home, "glottis.cos")
    glottis:head_look_at_manny(50)
    if arg2 then
        glottis:wait_for_chore(glottis_trans_home, "glottis.cos")
    end
end
glottis.pick_wax = function(arg1) -- line 34
    glottis:head_look_at(nil)
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:run_chore(glottis_ear_wax, "glottis.cos")
    glottis:head_look_at_manny()
end
glottis.smart_ass = function(arg1, arg2) -- line 41
    glottis:head_look_at(nil)
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:play_chore(glottis_smart_ass, "glottis.cos")
    sleep_for(2000)
    glottis:head_look_at_manny(60)
    if arg2 then
        glottis:wait_for_chore(glottis_smart_ass, "glottis.cos")
    end
end
glottis.look_down = function(arg1, arg2) -- line 52
    glottis:head_look_at(nil, 80)
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:play_chore(glottis_look_down, "glottis.cos")
    sleep_for(1200)
    glottis:head_look_at(manny, 80)
    if arg2 then
        glottis:wait_for_chore(glottis_look_down, "glottis.cos")
    end
end
glottis.home_pose = function(arg1) -- line 63
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    glottis:stop_chore(nil, "glottis.cos")
    glottis:play_chore(glottis_home_pose, "glottis.cos")
end
glottis.flip_ears = function(arg1, arg2, arg3) -- line 69
    start_script(glottis.ear_flipper, glottis, arg2)
    if arg3 then
        wait_for_script(glottis.ear_flipper)
    end
end
glottis.ear_flipper = function(arg1, arg2) -- line 76
    local local1 = 0
    glottis:complete_chore(gl_akimbo_idles_default_keys, "gl_akimbo_idles.cos")
    if not arg2 then
        arg2 = 1
    end
    repeat
        glottis:run_chore(glottis_flip_ears, "glottis.cos")
        local1 = local1 + 1
    until local1 >= arg2
end
glottis.akimbo = function(arg1) -- line 88
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_default_akimbo, "gl_akimbo_idles.cos")
end
glottis.hand_on_chest = function(arg1, arg2) -- line 93
    glottis:head_look_at(nil)
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_hand_on_chest, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_hand_on_chest, "gl_akimbo_idles.cos")
    end
end
glottis.hand_off_chest = function(arg1, arg2) -- line 102
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_hand_chest_akimbo, "gl_akimbo_idles.cos")
    glottis:head_look_at_manny(50)
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_hand_chest_akimbo, "gl_akimbo_idles.cos")
    end
end
glottis.head_flick = function(arg1, arg2) -- line 111
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_head_flick, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_chore(gl_akimbo_idles_head_flick, "gl_akimbo_idles.cos")
    end
end
glottis.shrug = function(arg1, arg2) -- line 119
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_shrug, "gl_akimbo_idles.cos")
    end
end
glottis.pick_wedgie = function(arg1, arg2) -- line 127
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_pick_wedgie, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_pick_wedgie, "gl_akimbo_idles.cos")
    end
end
glottis.shake_head = function(arg1, arg2) -- line 135
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_shake_head, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_shake_head, "gl_akimbo_idles.cos")
    end
end
glottis.nod = function(arg1, arg2) -- line 143
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_nod, "gl_akimbo_idles.cos")
end
glottis.lean_in_talk = function(arg1, arg2) -- line 148
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_lean_in_talk, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_lean_in_talk, "gl_akimbo_idles.cos")
    end
end
glottis.arms_head_down = function(arg1, arg2) -- line 156
    glottis:head_look_at(nil, 90)
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_arms_headdown, "gl_akimbo_idles.cos")
end
glottis.arms_head_up = function(arg1, arg2) -- line 162
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_arms_headdown_akimbo, "gl_akimbo_idles.cos")
    glottis:head_look_at_manny(40)
end
glottis.on_right_hand = function(arg1, arg2) -- line 168
    glottis:head_look_at(nil)
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_on_right_hand, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_on_right_hand, "gl_akimbo_idles.cos")
    end
end
glottis.on_left_hand = function(arg1, arg2) -- line 176
    glottis:head_look_at(nil)
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_on_left_hand, "gl_akimbo_idles.cos")
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_on_left_hand, "gl_akimbo_idles.cos")
    end
end
glottis.hands_down = function(arg1, arg2) -- line 184
    glottis:complete_chore(glottis_default_keys, "glottis.cos")
    glottis:play_chore(gl_akimbo_idles_hands_to_akimbo, "gl_akimbo_idles.cos")
    sleep_for(500)
    glottis:head_look_at_manny(50)
    if arg2 then
        glottis:wait_for_chore(gl_akimbo_idles_hands_to_akimbo, "gl_akimbo_idles.cos")
    end
end
glottis.default = function(arg1, arg2) -- line 195
    glottis:stop_chore()
    glottis:free()
    if arg2 == "sailor" then
        glottis:set_costume("glottis_sailor.cos")
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
    else
        glottis:set_costume("glottis.cos")
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
    end
    glottis:set_colormap("glottis.cmp")
    glottis:set_talk_color(Orange)
    glottis:set_visibility(TRUE)
    glottis:set_head(3, 4, 4, 165, 35, 80)
end
glottis.idle_to_home = function(arg1) -- line 234
    while glottis.last_chore ~= glottis_home_pose do
        break_here()
    end
    stop_script(glottis.new_run_idle)
    glottis:stop_chore()
    glottis:play_chore(glottis_home_pose, "glottis.cos")
end
glottis.idle_table = Idle:create("glottis")
idt = glottis.idle_table
idt:add_state("trans_rock", { rock_loop = 1 })
idt:add_state("ear_wax", { trans_rock = 0.1, smart_ass = 0, look_down = 0.050000001, home_pose = 0.40000001, flip_ears = 0.44999999 })
idt:add_state("trans_home", { home_pose = 1 })
idt:add_state("smart_ass", { home_pose = 1 })
idt:add_state("rock_loop", { rock_loop = 0.69999999, trans_home = 0.30000001 })
idt:add_state("look_down", { look_down = 0, trans_rock = 0.1, home_pose = 0.5, flip_ears = 0.40000001 })
idt:add_state("home_pose", { home_pose = 0.60000002, trans_rock = 0.1, smart_ass = 0, look_down = 0.050000001, flip_ears = 0.2, ear_wax = 0.050000001 })
idt:add_state("flip_ears", { flip_ears = 0.69999999, home_pose = 0.30000001 })
glottis.start_gesture_chore = function(arg1, arg2, arg3) -- line 284
    if not arg3 then
        wait_for_script(arg1.play_gesture_chore)
    end
    start_script(arg1.play_gesture_chore, arg1, arg2)
end
glottis.play_gesture_chore = function(arg1, arg2) -- line 291
    arg1:push_costume("gl_akimbo_idles.cos")
    arg1:play_chore(arg2, "gl_akimbo_idles.cos")
    arg1:wait_for_chore()
    arg1:pop_costume()
end

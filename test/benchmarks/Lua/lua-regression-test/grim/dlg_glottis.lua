CheckFirstTime("dlg_glottis.lua")
gl1 = Dialog:create()
gl1.intro = function(arg1) -- line 11
    arg1.node = "first_glottis_node"
end
gl1[50] = { text = "/gama001/", first_glottis_node = TRUE, gesture = manny.point_gesture }
gl1[50].response = function(arg1) -- line 16
    arg1.off = TRUE
    glottis:say_line("/gagl002/")
    glottis:hand_on_chest()
    glottis:head_look_at_manny(200)
    wait_for_message()
    glottis:say_line("/gagl003/")
    glottis:head_look_at(nil)
    wait_for_message()
    glottis:hand_off_chest()
    glottis:say_line("/gagl004/")
    glottis:wait_for_chore(gl_akimbo_idles_hand_chest_akimbo, "gl_akimbo_idles.cos")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl005/")
    wait_for_message()
    glottis:say_line("/gagl006/")
end
gl1[60] = { text = "/gama007/", first_glottis_node = TRUE, gesture = manny.head_forward_gesture }
gl1[60].response = function(arg1) -- line 36
    arg1.off = TRUE
    if do1 then
        do1[50].off = FALSE
    end
    gl1[70].off = FALSE
    gl1[300].off = FALSE
    glottis.introduced = TRUE
    glottis:say_line("/gagl008/")
    glottis:start_rocking()
    wait_for_message()
    glottis:say_line("/gagl009/")
    sleep_for(1000)
    glottis:stop_rocking()
    glottis:arms_head_down()
    wait_for_message()
    glottis:say_line("/gagl010/")
    wait_for_message()
    glottis:on_right_hand()
    glottis:say_line("/gagl011/")
    wait_for_message()
    glottis:on_left_hand()
    glottis:say_line("/gagl012/")
    wait_for_message()
    glottis:say_line("/gagl013/")
    glottis:hands_down()
    glottis:flip_ears(4)
    wait_for_message()
    manny:say_line("/gama014/")
    wait_for_message()
    glottis:say_line("/gagl015/")
    glottis:shrug()
end
gl1[70] = { text = "/gama016/", first_glottis_node = TRUE, gesture = manny.twist_head_gesture }
gl1[70].off = TRUE
gl1[70].response = function(arg1) -- line 73
    arg1.off = TRUE
    gl1[80].off = FALSE
    glottis:say_line("/gagl017/")
    glottis:arms_head_down()
    wait_for_message()
    glottis:flip_ears()
    sleep_for(500)
    glottis:say_line("/gagl018/")
    glottis:hand_on_chest()
    wait_for_message()
    glottis:say_line("/gagl019/")
    wait_for_message()
    glottis:hand_off_chest()
    glottis:say_line("/gagl020/")
    glottis:wait_for_chore(gl_akimbo_idles_hand_chest_akimbo, "gl_akimbo_idles.cos")
    glottis:pick_wax()
    wait_for_message()
    glottis:say_line("/gagl021/")
    glottis:wait_for_chore(glottis_ear_wax, "glottis.cos")
    glottis:nod()
end
gl1[80] = { text = "/gama022/", first_glottis_node = TRUE, gesture = manny.point_gesture }
gl1[80].off = TRUE
gl1[80].response = function(arg1) -- line 99
    arg1.off = TRUE
    gl1[90].off = FALSE
    glottis:say_line("/gagl023/")
    glottis:look_down()
    wait_for_message()
    glottis:say_line("/gagl024/")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl025/")
    wait_for_message()
    glottis:say_line("/gagl026/")
    glottis:head_flick()
end
gl1[90] = { text = "/gama027/", first_glottis_node = TRUE, gesture = { manny.hand_gesture } }
gl1[90].off = TRUE
gl1[90].response = function(arg1) -- line 116
    gl1.node = "beg_node"
    glottis:shake_head()
    if arg1.said then
        glottis:say_line("/gagl028/")
    else
        arg1.said = TRUE
        glottis:say_line("/gagl029/")
    end
    wait_for_message()
    glottis:say_line("/gagl030/")
    glottis:shrug()
end
gl1[200] = { text = "/gama031/", beg_node = TRUE, gesture = manny.twist_head_gesture }
gl1[200].response = function(arg1) -- line 131
    arg1.off = TRUE
    glottis:say_line("/gagl032/")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl033/")
    glottis:shrug()
end
gl1[210] = { text = "/gama034/", beg_node = TRUE, gesture = manny.hand_gesture }
gl1[210].response = function(arg1) -- line 141
    arg1.off = TRUE
    glottis:say_line("/gagl035/")
    glottis:flip_ears(5)
    wait_for_message()
    manny:say_line("/gama036/")
    manny:hand_gesture()
    wait_for_message()
    manny:say_line("/gama037/")
    manny:twist_head_gesture()
    wait_for_message()
    manny:say_line("/gama038/")
    manny:nod_head_gesture()
    wait_for_message()
    manny:say_line("/gama039/")
    manny:point_gesture()
    wait_for_message()
    glottis:say_line("/gagl040/")
    glottis:hand_on_chest()
    glottis:head_look_at_manny()
    sleep_for(2500)
    glottis:hand_off_chest(TRUE)
    glottis:on_right_hand()
    wait_for_message()
    glottis:say_line("/gagl041/")
    glottis:on_left_hand(TRUE)
    glottis:hands_down(TRUE)
    glottis:lean_in_talk(TRUE)
    glottis:smart_ass()
    glottis:wait_for_message()
    glottis:blend(gl_akimbo_idles_default_akimbo, glottis_smart_ass, 500, "gl_akimbo_idles.cos", "glottis.cos")
end
gl1[220] = { text = "/gama042/", beg_node = TRUE, gesture = manny.hand_gesture }
gl1[220].response = function(arg1) -- line 175
    glottis.recruited = TRUE
    cur_puzzle_state[1] = TRUE
    ga.crash.triggered = TRUE
    gl1.node = "exit_dialog"
    arg1.off = TRUE
    glottis:say_line("/gagl043/")
    glottis:head_flick()
    wait_for_message()
    glottis:say_line("/gagl044/")
    glottis:arms_head_down()
    glottis:flip_ears(5)
    wait_for_message()
    glottis:arms_head_up()
    glottis:say_line("/gagl045/")
    glottis:play_chore(glottis_right_smirk, "glottis.cos")
    glottis:start_rocking()
    sleep_for(3000)
    glottis:play_chore(glottis_left_smirk, "glottis.cos")
    wait_for_message()
    glottis:play_chore(glottis_open_eyes, "glottis.cos")
    glottis:say_line("/gagl046/")
    glottis:stop_rocking(TRUE)
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl047/")
    glottis:look_down()
    wait_for_message()
    manny:say_line("/gama048/")
    wait_for_message()
    glottis:kill_head_script()
    glottis.head_script = start_script(glottis.head_follow_mesh, glottis, manny, 6)
    glottis:say_line("/gagl049/")
    start_script(glottis.hand_work_order)
    wait_for_message()
    glottis:say_line("/gagl050/")
    glottis:flip_ears(5)
    glottis:wait_for_message()
    manny:say_line("/gama051/")
    manny:kill_head_script()
    manny:turn_toward_entity(ga.gs_door)
    manny:wait_for_message()
    manny:head_look_at(nil)
    manny:say_line("/gama052/")
    manny:wait_for_message()
    glottis:kill_head_script()
    glottis:say_line("/gagl053/")
    glottis:nod()
    sleep_for(2500)
    glottis:head_look_at(nil)
    glottis:shake_head()
    glottis:wait_for_message()
    glottis:say_line("/gagl054/")
    glottis:play_chore(glottis_right_smirk, "glottis.cos")
    glottis:wait_for_message()
    glottis:play_chore(glottis_open_eyes, "glottis.cos")
    music_state:set_sequence(seqGlottisOK)
    music_state:set_state(stateGA)
end
gl1[230] = { text = "/gama055/", beg_node = TRUE, gesture = manny.tilt_head_gesture }
gl1[230].response = function(arg1) -- line 237
    arg1.off = TRUE
    glottis:say_line("/gagl056/")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl057/")
    sleep_for(2000)
    glottis:head_flick()
end
gl1[240] = { text = "/gama058/", beg_node = TRUE, gesture = manny.shrug_gesture }
gl1[240].response = function(arg1) -- line 248
    arg1.off = TRUE
    glottis:say_line("/gagl059/")
    glottis:shrug()
    wait_for_message()
    glottis:say_line("/gagl060/")
    glottis:lean_in_talk()
    wait_for_message()
    manny:say_line("/gama061/")
    manny:nod_head_gesture()
end
gl1.exit_lines.beg_node = { text = "/gama062/", beg_node = TRUE, gesture = manny.twist_head_gesture }
gl1.exit_lines.beg_node.response = function(arg1) -- line 261
    gl1.node = "exit_dialog"
    glottis:say_line("/gagl063/")
    glottis:look_down()
end
gl1[300] = { text = "/gama064/", first_glottis_node = TRUE, gesture = manny.twist_head_gesture }
gl1[300].off = TRUE
gl1[300].response = function(arg1) -- line 269
    arg1.off = TRUE
    glottis:say_line("/gagl065/")
    glottis:shake_head(TRUE)
    glottis:flip_ears(4)
    wait_for_message()
    glottis:say_line("/gagl066/")
    glottis:hand_on_chest()
    sleep_for(3000)
    glottis:hand_off_chest(TRUE)
    glottis:start_rocking()
    wait_for_message()
    manny:tilt_head_gesture()
    glottis:stop_rocking(TRUE)
    glottis:say_line("/gagl067/")
    glottis:lean_in_talk()
    manny:backup(100)
    wait_for_message()
    glottis:say_line("/gagl068/")
    glottis:flip_ears(5)
    glottis:on_right_hand()
    sleep_for(2000)
    glottis:on_left_hand()
    glottis:wait_for_message()
    glottis:hands_down()
    start_script(manny.walk_and_face, manny, 1.43663, 8.85144, 0, 0, 53.4055, 0)
end
gl1[310] = { text = "/gama069/", first_glottis_node = TRUE, gesture = manny.nod_head_gesture }
gl1[310].response = function(arg1) -- line 298
    arg1.off = TRUE
    gl1[320].off = FALSE
    glottis:say_line("/gagl070/")
    glottis:look_down(TRUE)
    glottis:lean_in_talk(TRUE)
    glottis:hand_on_chest(TRUE)
    glottis:hand_off_chest(TRUE)
end
gl1[320] = { text = "/gama071/", first_glottis_node = TRUE, gesture = manny.hand_gesture }
gl1[320].off = TRUE
gl1[320].response = function(arg1) -- line 310
    arg1.off = TRUE
    glottis:say_line("/gagl072/")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl073/")
    glottis:look_down()
    wait_for_message()
    glottis:say_line("/gagl074/")
    glottis:shrug()
    sleep_for(5000)
    glottis:head_flick()
    manny:play_chore(manny_idles_smoke1, "manny_idles.cos")
    wait_for_message()
    glottis:look_down()
    manny:say_line("/gama075/")
    manny:wait_for_message()
    manny:fade_out_chore(manny_idles_smoke1, "manny_idles.cos")
end
gl1[330] = { text = "/gama076/", first_glottis_node = TRUE, gesture = manny.head_forward_gesture }
gl1[330].off = TRUE
gl1[330].response = function(arg1) -- line 332
    glottis:say_line("/gagl077/")
    glottis:shake_head()
    wait_for_message()
    glottis:say_line("/gagl078/")
    glottis:look_down()
    wait_for_message()
    manny:say_line("/gama079/")
    manny:twist_head_gesture()
end
gl1.exit_lines.first_glottis_node = { text = "/gama080/", gesture = manny.point_gesture }
gl1.exit_lines.first_glottis_node.response = function(arg1) -- line 344
    gl1.node = "exit_dialog"
    glottis:say_line("/gagl081/")
    sleep_for(200)
    glottis:lean_in_talk()
end
gl1.outro = function(arg1) -- line 352
    glottis:kill_head_script()
    manny:kill_head_script()
    cameraman_disabled = FALSE
    manny:head_look_at(nil)
    if glottis.is_outside then
        glottis:demerge()
    end
end
gl1[999] = "EOD"

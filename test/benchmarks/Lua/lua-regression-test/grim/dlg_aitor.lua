CheckFirstTime("dlg_aitor.lua")
ai1 = Dialog:create()
ai1.intro = function(arg1) -- line 11
    ai1.node = "first_aitor_node"
    if not hl.glottis_gambling then
        ai1[190].off = TRUE
    elseif not ai1[190].said then
        ai1[190].off = FALSE
    end
    wait_for_message()
    stop_script(he.aitor_snore_idles, he)
    wait_for_message()
    aitor:set_speech_mode(MODE_NORMAL)
    aitor:stop_chore(aitor_idles_head_down, "aitor_idles.cos")
    aitor:shut_up()
    aitor:play_chore(aitor_idles_head_to_up, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_eyes_open, "aitor_idles.cos")
    aitor:say_line("/heai001/")
    aitor:play_chore(aitor_idles_eyes_open, "aitor_idles.cos")
    aitor:wait_for_chore(aitor_idles_head_to_up, "aitor_idles.cos")
    manny:head_look_at(he.aitor_obj)
    manny:walkto_object(he.aitor_obj)
    aitor:wait_for_message()
    aitor:stop_chore(aitor_idles_head_to_up, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:say_line("/heai002/")
end
ai1[100] = { text = "/hema003/", first_aitor_node = TRUE, gesture = manny.shrug_gesture }
ai1[100].response = function(arg1) -- line 38
    arg1.off = TRUE
    ai1[120].off = FALSE
    aitor:say_line("/heai004/")
    wait_for_message()
    manny:say_line("/hema005/")
    wait_for_message()
    aitor:say_line("/heai006/")
end
ai1[110] = { text = "/hema007/", first_aitor_node = TRUE, gesture = manny.hand_gesture }
ai1[110].response = function(arg1) -- line 49
    arg1.off = TRUE
    if not ai1[130].said then
        ai1[130].off = FALSE
    end
    aitor:say_line("/heai008/")
    wait_for_message()
    aitor:say_line("/heai009/")
end
ai1[120] = { text = "/hema010/", first_aitor_node = TRUE, gesture = manny.tilt_head_gesture }
ai1[120].off = TRUE
ai1[120].response = function(arg1) -- line 61
    arg1.off = TRUE
    if not ai1[130].said then
        ai1[130].off = FALSE
    end
    aitor:say_line("/heai011/")
    wait_for_message()
    aitor:say_line("/heai012/")
end
ai1[130] = { text = "/hema013/", first_aitor_node = TRUE, gesture = manny.point_gesture }
ai1[130].off = TRUE
ai1[130].response = function(arg1) -- line 73
    arg1.off = TRUE
    arg1.said = TRUE
    ai1[140].off = FALSE
    aitor:say_line("/heai014/")
    wait_for_message()
    aitor:say_line("/heai015/")
end
ai1[140] = { text = "/hema016/", first_aitor_node = TRUE, gesture = manny.twist_head_gesture }
ai1[140].off = TRUE
ai1[140].response = function(arg1) -- line 84
    arg1.off = TRUE
    ai1[150].off = FALSE
    ai1[160].off = FALSE
    aitor:stop_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:say_line("/heai017/")
    aitor:wait_for_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:wait_for_message()
    aitor:say_line("/heai018/")
    aitor:stop_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
end
ai1[150] = { text = "/hema019/", first_aitor_node = TRUE, gesture = manny.shrug_gesture }
ai1[150].off = TRUE
ai1[150].response = function(arg1) -- line 100
    arg1.off = TRUE
    aitor:say_line("/heai020/")
end
ai1[160] = { text = "/hema021/", first_aitor_node = TRUE, gesture = manny.hand_gesture }
ai1[160].off = TRUE
ai1[160].response = function(arg1) -- line 107
    arg1.off = TRUE
    ai1[170].off = FALSE
    ai1[180].off = FALSE
    aitor:say_line("/heai022/")
end
ai1[170] = { text = "/hema023/", first_aitor_node = TRUE, gesture = manny.twist_head_gesture }
ai1[170].off = TRUE
ai1[170].response = function(arg1) -- line 116
    arg1.off = TRUE
    aitor:say_line("/heai024/")
end
ai1[180] = { text = "/hema025/", first_aitor_node = TRUE, gesture = manny.hand_gesture }
ai1[180].off = TRUE
ai1[180].response = function(arg1) -- line 123
    arg1.off = TRUE
    ai1[180].off = FALSE
    aitor:say_line("/heai026/")
    wait_for_message()
    aitor:stop_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:say_line("/heai027/")
    wait_for_message()
    manny:head_forward_gesture()
    manny:say_line("/hema028/")
    wait_for_message()
    aitor:stop_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:say_line("/heai029/")
    wait_for_message()
    aitor:say_line("/heai030/")
end
ai1[180] = { text = "/hema031/", first_aitor_node = TRUE, gesture = manny.tilt_head_gesture }
ai1[180].off = TRUE
ai1[180].response = function(arg1) -- line 145
    arg1.off = TRUE
    aitor:say_line("/heai032/")
    wait_for_message()
    aitor:say_line("/heai033/")
end
ai1[190] = { text = "/hema034/", first_aitor_node = TRUE, gesture = manny.hand_gesture }
ai1[190].response = function(arg1) -- line 154
    arg1.off = TRUE
    arg1.said = TRUE
    aitor:stop_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:say_line("/heai035/")
    wait_for_message()
    aitor:say_line("/heai036/")
    wait_for_message()
    aitor:stop_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:say_line("/heai037/")
end
ai1[200] = { text = "/hema038/", first_aitor_node = TRUE, gesture = manny.head_forward_gesture }
ai1[200].response = function(arg1) -- line 169
    arg1.off = TRUE
    aitor:say_line("/heai039/")
    wait_for_message()
    aitor:say_line("/heai040/")
end
ai1.exit_lines.first_aitor_node = { text = "/hema041/", gesture = manny.shrug_gesture }
ai1.exit_lines.first_aitor_node.response = function(arg1) -- line 177
    ai1.node = "exit_dialog"
    aitor:say_line("/heai042/")
    aitor:stop_chore(aitor_idles_from_up_to_left, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:wait_for_chore(aitor_idles_back_to_sit, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_head_to_down, "aitor_idles.cos")
    aitor:wait_for_chore(aitor_idles_head_to_down, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_head_down, "aitor_idles.cos")
    aitor:play_chore(aitor_idles_eyes_shut, "aitor_idles.cos")
    start_script(he.aitor_snore_idles, he)
end
ai1.aborts.first_aitor_node = function(arg1) -- line 190
    ai1:clear()
    ai1:execute_line(ai1.exit_lines.first_aitor_node)
end

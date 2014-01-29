CheckFirstTime("dlg_maximino.lua")
mx1 = Dialog:create()
mx1.display_lines = function(arg1) -- line 11
    maximino:wait_for_message()
    manny:wait_for_message()
    mx:current_setup(mx_maxcu)
    arg1.parent.display_lines(mx1)
end
mx1.execute_line = function(arg1, arg2) -- line 19
    if type(arg2) == "table" then
        print_table(arg2)
    else
        PrintDebug(arg2)
    end
    mx:current_setup(mx_diarv)
    Dialog.execute_line(mx1, arg2)
end
mx1.intro = function(arg1) -- line 30
    if bi.seen_kiss and mx1[130].said and not mx1[140].said then
        mx1[140].off = FALSE
        mx1.talked_out = FALSE
    end
    if hl.glottis_gambling and not mx1[90].said then
        mx1[90].off = FALSE
        mx1.talked_out = FALSE
    end
    if mx1.talked_out then
        mx1.node = "exit_dialog"
        manny:say_line("/mxma001/")
    else
        manny:clear_hands()
        mx1.node = "first_max_node"
    end
end
mx1[90] = { text = "/mxma073/", first_max_node = TRUE, gesture = manny.hand_gesture }
mx1[90].off = TRUE
mx1[90].response = function(arg1) -- line 52
    arg1.off = TRUE
    arg1.said = TRUE
    mx1.node = "exit_dialog"
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx074/")
    maximino:play_chore(maximino_idles_shake_head)
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:say_line("/mxma075/")
    manny:shrug_gesture(TRUE)
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx076/")
    maximino:play_chore(maximino_idles_cig_gesture)
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:say_line("/mxma077/")
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx078/")
    maximino:play_chore(maximino_idles_dunno)
    wait_for_message()
    break_here()
    maximino:say_line("/mxmx079/")
end
mx1[100] = { text = "/mxma002/", first_max_node = TRUE }
mx1[100].gesture = manny.hand_gesture
mx1[100].response = function(arg1) -- line 86
    arg1.off = TRUE
    mx1[110].off = FALSE
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx003/")
    maximino:play_chore(maximino_idles_shift_weight)
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:say_line("/mxma004/")
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_bk_to_restpos1)
    maximino:say_line("/mxmx005/")
end
mx1[110] = { text = "/mxma006/", first_max_node = TRUE }
mx1[110].off = TRUE
mx1[110].gesture = manny.shrug_gesture
mx1[110].response = function(arg1) -- line 107
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_shake_head)
    maximino:say_line("/mxmx007/")
    wait_for_message()
    maximino:say_line("/mxmx008/")
    maximino:wait_for_chore()
    maximino:play_chore(maximino_idles_cig_gesture)
end
mx1[120] = { text = "/mxma009/", first_max_node = TRUE }
mx1[120].gesture = manny.nod_head_gesture
mx1[120].response = function(arg1) -- line 122
    arg1.off = TRUE
    mx1[130].off = FALSE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_shift_weight)
    maximino:say_line("/mxmx010/")
    wait_for_message()
    maximino:play_chore(maximino_idles_bk_to_restpos1)
    maximino:say_line("/mxmx011/")
end
mx1[130] = { text = "/mxma012/", first_max_node = TRUE }
mx1[130].off = TRUE
mx1[130].gesture = manny.tilt_head_gesture
mx1[130].response = function(arg1) -- line 138
    arg1.off = TRUE
    arg1.said = TRUE
    if bi.seen_kiss then
        mx1[140].off = FALSE
    end
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx013/")
    maximino:play_chore(maximino_idles_dunno)
    wait_for_message()
    maximino:say_line("/mxmx014/")
end
mx1[140] = { text = "/mxma015/", first_max_node = TRUE }
mx1[140].off = TRUE
mx1[140].gesture = manny.head_forward_gesture
mx1[140].response = function(arg1) -- line 157
    arg1.off = TRUE
    arg1.said = TRUE
    mx1[150].off = FALSE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_cig_gesture)
    maximino:say_line("/mxmx016/")
    wait_for_message()
    maximino:say_line("/mxmx017/")
end
mx1[150] = { text = "/mxma018/", first_max_node = TRUE }
mx1[150].off = TRUE
mx1[150].gesture = manny.point_gesture
mx1[150].response = function(arg1) -- line 173
    arg1.off = TRUE
    mx1[160].off = FALSE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_shift_weight)
    maximino:say_line("/mxmx019/")
    wait_for_message()
    maximino:play_chore(maximino_idles_bk_to_restpos1)
    maximino:say_line("/mxmx020/")
    wait_for_message()
    maximino:play_chore(maximino_idles_shake_head)
    maximino:say_line("/mxmx021/")
end
mx1[160] = { text = "/mxma022/", first_max_node = TRUE }
mx1[160].off = TRUE
mx1[160].gesture = manny.twist_head_gesture
mx1[160].response = function(arg1) -- line 192
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_db_arm_gesture)
    maximino:say_line("/mxmx023/")
    wait_for_message()
    maximino:say_line("/mxmx024/")
end
mx1[180] = { text = "/mxma025/", first_max_node = TRUE }
mx1[180].gesture = manny.hand_gesture
mx1[180].response = function(arg1) -- line 206
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_shake_head)
    maximino:say_line("/mxmx026/")
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:twist_head_gesture(TRUE)
    manny:say_line("/mxma027/")
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_laugh)
    maximino:say_line("/mxmx028/")
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:point_gesture(TRUE)
    manny:say_line("/mxma029/")
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:tilt_head_gesture(TRUE)
    manny:say_line("/mxma030/")
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_cig_gesture)
    maximino:say_line("/mxmx031/")
    wait_for_message()
    maximino:say_line("/mxmx032/")
    maximino:wait_for_chore()
    maximino:play_chore(maximino_idles_laugh)
    wait_for_message()
    mx:current_setup(mx_manny)
    break_here()
    manny:say_line("/mxma033/")
    manny:nod_head_gesture()
    manny:wait_for_chore()
end
mx1[190] = { text = "/mxma034/", first_max_node = TRUE }
mx1[190].response = function(arg1) -- line 251
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:say_line("/mxmx035/")
    maximino:play_chore(maximino_idles_db_arm_gesture)
    wait_for_message()
    maximino:say_line("/mxmx036/")
    wait_for_message()
    maximino:play_chore(maximino_idles_cig_gesture)
    maximino:say_line("/mxmx037/")
end
mx1[195] = { text = "/mxma038/", first_max_node = TRUE }
mx1[195].gesture = manny.point_gesture
mx1[195].response = function(arg1) -- line 266
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_dunno)
    maximino:say_line("/mxmx039/")
    wait_for_message()
    maximino:say_line("/mxmx040/")
    maximino:play_chore(maximino_idles_shift_weight)
    maximino:wait_for_chore()
    maximino:play_chore(maximino_idles_bk_to_restpos1)
    wait_for_message()
    maximino:say_line("/mxmx041/")
    maximino:play_chore(maximino_idles_db_arm_gesture)
    wait_for_message()
    maximino:say_line("/mxmx042/")
    maximino:play_chore(maximino_idles_shake_head)
    maximino:wait_for_chore()
end
mx1[200] = { text = "/mxma043/", first_max_node = TRUE }
mx1[200].response = function(arg1) -- line 289
    arg1.off = TRUE
    mx1[210].off = FALSE
    manny:shrug_gesture(TRUE)
    manny:say_line("/mxma044/")
    wait_for_message()
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_dunno)
    maximino:say_line("/mxmx045/")
    wait_for_message()
    maximino:play_chore(maximino_idles_shake_head)
    maximino:say_line("/mxmx046/")
end
mx1[210] = { text = "/mxma047/", first_max_node = TRUE }
mx1[210].off = TRUE
mx1[210].gesture = manny.point_gesture
mx1[210].response = function(arg1) -- line 307
    arg1.off = TRUE
    mx:current_setup(mx_max)
    break_here()
    maximino:play_chore(maximino_idles_shift_weight)
    maximino:say_line("/mxmx048/")
    wait_for_message()
    maximino:play_chore(maximino_idles_bk_to_restpos1)
    maximino:say_line("/mxmx049/")
end
mx1.exit_lines.first_max_node = { text = "/mxma050/" }
mx1.exit_lines.first_max_node.response = function(arg1) -- line 320
    mx1.exit_lines.first_max_node.gesture = manny.tilt_head_gesture
    mx1.node = "exit_dialog"
    mx:current_setup(mx_ofcws)
    break_here()
    maximino:play_chore(maximino_idles_dunno)
    maximino:say_line("/mxmx051/")
end
mx1.aborts.first_max_node = function(arg1) -- line 329
    mx1:clear()
    mx1.talked_out = TRUE
    mx1:execute_line(mx1.exit_lines.first_max_node)
end
mx1.outro = function(arg1) -- line 335
    mx:current_setup(mx_ofcws)
    start_script(mx.maximino_idles, TRUE)
    manny:head_look_at(nil)
end

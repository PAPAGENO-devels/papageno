CheckFirstTime("dlg_mechanics.lua")
mm1 = Dialog:create()
mm1.intro = function(arg1, arg2) -- line 9
    enable_head_control(FALSE)
    manny:head_look_at(my.mechanic)
end
mm1[100] = { text = "/myma104/", n1 = TRUE }
mm1[100].response = function(arg1) -- line 15
    arg1.off = TRUE
    mm1[130].off = FALSE
    single_start_script(my.mechanics_face_manny, my)
    mechanic1:say_line("/mym1105/")
    mechanic1:wait_for_message()
    manny:hand_gesture()
    manny:say_line("/myma106/")
    manny:wait_for_message()
    wait_for_script(my.mechanics_face_manny)
    mechanic1:say_line("/mym1107/")
    mechanic1:wait_for_message()
    mechanic2:say_line("/mym2108/")
    mechanic2:wait_for_message()
    manny:hand_gesture()
    manny:say_line("/myma109/")
    manny:wait_for_message()
    manny:head_look_at(my.glottis_obj)
    manny:setrot(0, my.glottis_obj.use_rot_y, 0, TRUE)
    manny:say_line("/myma110/")
    manny:wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/myma111/")
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/myma112/")
    manny:wait_for_message()
    sleep_for(500)
    manny:head_look_at(my.mechanic)
    manny:setrot(0, my.mechanic.use_rot_y, 0, TRUE)
end
mm1[120] = { text = "/myma113/", n1 = TRUE, gesture = manny.hand_gesture }
mm1[120].response = function(arg1) -- line 48
    arg1.off = TRUE
    single_start_script(my.mechanics_face_manny, my)
    mechanic1:say_line("/mym1114/")
    wait_for_message()
    mechanic2:say_line("/mym2115/")
    wait_for_message()
    my:mechanics_stop_face_manny()
    mechanic1:say_line("/mym1116/", { background = TRUE })
    mechanic2:say_line("/mym2117/", { background = TRUE })
end
mm1[130] = { text = "/myma118/", n1 = TRUE }
mm1[130].off = TRUE
mm1[130].response = function(arg1) -- line 62
    arg1.off = TRUE
    single_start_script(my.mechanics_face_manny, my)
    mechanic1:say_line("/mym1119/")
    wait_for_message()
    mechanic2:say_line("/mym2120/")
    wait_for_message()
    mechanic2:say_line("/mym2121/", { background = TRUE })
    mechanic1:say_line("/mym1122/", { background = TRUE })
end
mm1[140] = { text = "/myma123/", n1 = TRUE, gesture = manny.shrug_gesture }
mm1[140].response = function(arg1) -- line 74
    arg1.off = TRUE
    single_start_script(my.mechanics_face_manny, my)
    mechanic1:say_line("/mym1124/", { background = TRUE })
    mechanic2:say_line("/mym2125/", { background = TRUE })
    wait_for_message()
    mechanic1:say_line("/mym1126/")
    wait_for_message()
    mechanic2:say_line("/mym2127/")
    wait_for_message()
    my:mechanics_stop_face_manny()
    mechanic1:say_line("/mym1128/", { background = TRUE })
    mechanic2:say_line("/mym2129/", { background = TRUE })
end
mm1.exit_lines.n1 = { text = "/myma130/", n1 = TRUE }
mm1.exit_lines.n1.response = function(arg1) -- line 90
    mm1.node = "exit_dialog"
    mechanic1:say_line("/mym1131/")
    mechanic1:wait_for_message()
    single_start_script(my.mechanics_stop_face_manny, my)
    mechanic2:say_line("/mym2132/")
    manny:head_look_at(nil)
end
mm1.aborts.n1 = function(arg1) -- line 99
    mm1:clear()
    mm1:execute_line(mm1.exit_lines.n1)
    single_start_script(my.mechanics_stop_face_manny, my)
    manny:head_look_at(nil)
end

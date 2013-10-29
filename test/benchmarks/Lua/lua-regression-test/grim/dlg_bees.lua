CheckFirstTime("dlg_bees.lua")
be1 = Dialog:create()
be1.focus = dd.barrel_bees
be1.intro = function(arg1) -- line 13
    be1.node = "first_bee_node"
    break_here()
    break_here()
    terry:remove_barrel_stamp()
    if hh.union_card.owner == manny then
        be1[190].off = TRUE
    elseif lm.talked_union and not be1[190].said then
        be1[190].off = FALSE
    end
    if lm.talked_naranja and not be1[200].said then
        be1[200].off = FALSE
    end
    if lm.talked_tools and not be1[170].said then
        be1[170].off = FALSE
    end
    if not be1.talked then
        be1.talked = 1
        manny:head_look_at_point(0.432771, -2.99192, 0.4396)
        manny:say_line("/ddma074/")
        wait_for_message()
        terry:say_line("/ddte075/")
        terry:stop_barrel_idles()
        terry:head_left()
        start_script(terry.head_nod, terry)
        wait_for_message()
    else
        manny:head_look_at_point(0.432771, -2.99192, 0.4396)
        manny:say_line("/ddma076/")
        wait_for_message()
        be1.talked = be1.talked + 1
        terry:stop_barrel_idles()
        terry:head_left()
        if be1.talked == 2 then
            terry:say_line("/ddte077/")
            wait_for_message()
            start_script(terry.stop_head_left, terry)
            terry:say_line("/ddte078/")
            wait_for_message()
            start_script(terry.head_left, terry)
            terry:say_line("/ddte079/")
        elseif be1.talked == 3 then
            terry:say_line("/ddte080/")
            wait_for_message()
            terry:say_line("/ddte081/")
            wait_for_message()
            start_script(terry.head_wag, terry)
            terry:say_line("/ddte082/")
        elseif be1.talked == 4 then
            terry:say_line("/ddte083/")
            wait_for_message()
            start_script(terry.stop_head_left, terry)
            terry:say_line("/ddte084/")
            wait_for_message()
            start_script(terry.head_left, terry)
            terry:say_line("/ddte085/")
        else
            start_script(terry.lefthand_out, terry)
            terry:say_line("/ddte086/")
            wait_for_message()
            start_script(terry.stop_lefthand_out, terry)
            terry:say_line("/ddte087/")
        end
    end
end
be1[100] = { text = "/ddma088/", first_bee_node = TRUE, gesture = manny.shrug_gesture }
be1[100].response = function(arg1) -- line 87
    arg1.off = TRUE
    be1[110].off = FALSE
    if not be1[140].said then
        be1[140].off = FALSE
    end
    be1[180].off = FALSE
    be1.exit_lines.first_bee_node = be1.delayed_exit_line
    terry:say_line("/ddte089/")
    terry:shrug()
    wait_for_message()
    terry:say_line("/ddte090/")
    terry:head_wag()
    start_script(terry.stop_shrug, terry)
    wait_for_message()
    terry:say_line("/ddte091/")
    wait_for_message()
    start_script(terry.lefthand_out, terry)
    terry:say_line("/ddte092/")
    terry:wait_for_message()
    start_script(terry.stop_lefthand_out, terry)
end
be1[110] = { text = "/ddma093/", first_bee_node = TRUE, gesture = manny.head_forward_gesture }
be1[110].off = TRUE
be1[110].response = function(arg1) -- line 112
    arg1.off = TRUE
    terry:say_line("/ddte094/")
    wait_for_message()
    manny:point_gesture()
    manny:say_line("/ddma095/")
    wait_for_message()
    terry:say_line("/ddte096/")
    wait_for_message()
    terry:say_line("/ddte097/")
    terry:gesture1()
    terry:gesture2()
    wait_for_message()
    terry:say_line("/ddte098/")
    terry:stop_gesture()
end
be1[120] = { text = "/ddma099/", first_bee_node = TRUE, gesture = manny.tilt_head_gesture }
be1[120].response = function(arg1) -- line 130
    arg1.off = TRUE
    be1[130].off = FALSE
    if not be1[140].said then
        be1[140].off = FALSE
    end
    if not be1[150].said then
        be1[150].off = FALSE
    end
    be1[160].off = FALSE
    be1.exit_lines.first_bee_node = be1.delayed_exit_line
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte100/")
    wait_for_message()
    start_script(terry.lefthand_out, terry)
    terry:say_line("/ddte101/")
    wait_for_message()
    start_script(terry.stop_lefthand_out, terry)
    terry:say_line("/ddte102/")
end
be1[130] = { text = "/ddma103/", first_bee_node = TRUE, gesture = manny.shrug_gesture }
be1[130].off = TRUE
be1[130].response = function(arg1) -- line 153
    arg1.off = TRUE
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte104/")
    wait_for_message()
    terry:say_line("/ddte105/")
    terry:stop_head_left()
    wait_for_message()
    start_script(terry.head_left, terry)
    terry:say_line("/ddte106/")
    wait_for_message()
    terry:say_line("/ddte107/")
    sleep_for(1000)
    start_script(terry.shrug, terry)
    wait_for_message()
    start_script(terry.stop_shrug, terry)
    manny:head_forward_gesture()
    manny:say_line("/ddma108/")
    wait_for_message()
    start_script(terry.head_nod, terry)
    terry:say_line("/ddte109/")
end
be1[140] = { text = "/ddma110/", first_bee_node = TRUE, gesture = manny.tilt_head_gesture }
be1[140].off = TRUE
be1[140].response = function(arg1) -- line 178
    arg1.off = TRUE
    arg1.said = TRUE
    start_sfx("beeflap1.wav")
    terry:play_chore_looping(bee_barrel_move_wing, "bee_barrel.cos")
    start_script(terry.stop_head_left, terry)
    terry:say_line("/ddte111/")
    wait_for_message()
    start_sfx("beeflap2.wav")
    terry:say_line("/ddte112/")
    terry:head_left()
    start_sfx("beeflap3.wav")
    terry:wait_for_message()
    terry:stop_chore(bee_barrel_move_wing, "bee_barrel.cos")
    terry:say_line("/ddte112b/")
end
be1[150] = { text = "/ddma113/", first_bee_node = TRUE, gesture = manny.head_forward_gesture }
be1[150].off = TRUE
be1[150].response = function(arg1) -- line 197
    arg1.off = TRUE
    arg1.said = TRUE
    start_script(terry.shrug, terry)
    terry:say_line("/ddte114/")
    wait_for_message()
    terry:say_line("/ddte115/")
    wait_for_message()
    start_script(terry.stop_shrug, terry)
    terry:say_line("/ddte116/")
end
be1[160] = { text = "/ddma117/", first_bee_node = TRUE, gesture = manny.twist_head_gesture }
be1[160].off = TRUE
be1[160].response = function(arg1) -- line 211
    arg1.off = TRUE
    terry:say_line("/ddte118/")
    terry:head_wag()
    wait_for_message()
    start_script(terry.stop_head_left, terry)
    terry:say_line("/ddte119/")
    wait_for_message()
    terry:say_line("/ddte120/")
    terry:head_left()
    terry:gesture1()
    terry:gesture2()
    terry:stop_gesture()
    wait_for_message()
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte121/")
end
be1[170] = { text = "/ddma122/", first_bee_node = TRUE, gesture = manny.hand_gesture }
be1[170].off = TRUE
be1[170].response = function(arg1) -- line 231
    arg1.off = TRUE
    arg1.said = TRUE
    start_script(terry.lefthand_out, terry)
    terry:say_line("/ddte123/")
    wait_for_message()
    start_script(terry.stop_lefthand_out, terry)
    manny:say_line("/ddma124/")
    wait_for_message()
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte125/")
end
be1[180] = { text = "/ddma126/", first_bee_node = TRUE, gesture = manny.tilt_head_gesture }
be1[180].off = TRUE
be1[180].response = function(arg1) -- line 246
    arg1.off = TRUE
    start_script(terry.shrug, terry)
    terry:say_line("/ddte127/")
    wait_for_message()
    start_script(terry.stop_shrug, terry)
    terry:say_line("/ddte128/")
    wait_for_message()
    terry:say_line("/ddte129/")
    wait_for_message()
    terry:say_line("/ddte130/")
    terry:gesture1()
    terry:gesture2()
    terry:stop_gesture()
end
be1[190] = { text = "/ddma131/", first_bee_node = TRUE, gesture = manny.point_gesture }
be1[190].off = TRUE
be1[190].response = function(arg1) -- line 264
    arg1.off = TRUE
    arg1.said = TRUE
    dd.talked_charlie = TRUE
    cn.charlie_obj.talked_out = FALSE
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte132/")
    wait_for_message()
    terry:say_line("/ddte133/")
    terry:shrug()
    start_script(terry.stop_shrug, terry)
end
be1[200] = { text = "/ddma134/", first_bee_node = TRUE }
be1[200].off = TRUE
be1[200].response = function(arg1) -- line 279
    arg1.off = TRUE
    arg1.said = TRUE
    start_script(terry.head_wag, terry)
    terry:say_line("/ddte135/")
    wait_for_message()
    manny:point_gesture()
    manny:say_line("/ddma136/")
    wait_for_message()
    start_script(terry.head_nod, terry)
    terry:say_line("/ddte137/")
end
be1.delayed_exit_line = { text = "/ddma138/", gesture = manny.twist_head_gesture }
be1.delayed_exit_line.response = function(arg1) -- line 293
    be1.node = "exit_dialog"
end
be1.aborts.first_bee_node = function(arg1) -- line 297
    be1:clear()
    be1.node = "exit_dialog"
    manny:head_forward_gesture()
    manny:say_line("/ddma139/")
    wait_for_message()
end
be1.outro = function(arg1) -- line 305
    if not be1.outroed then
        be1.outroed = TRUE
        start_script(terry.head_wag, terry)
        terry:say_line("/ddte140/")
        wait_for_message()
        terry:say_line("/ddte141/")
        terry:gesture1()
        terry:gesture2()
        wait_for_message()
        terry:say_line("/ddte142/")
        terry:stop_gesture()
        wait_for_message()
        terry:say_line("/ddte143/")
        start_script(terry.stop_head_left, terry)
        wait_for_message()
        start_script(terry.lefthand_out, terry)
        terry:say_line("/ddte144/")
        wait_for_message()
        start_script(terry.head_left, terry)
        start_script(terry.stop_lefthand_out, terry)
        terry:say_line("/ddte145/")
        wait_for_message()
        terry:say_line("/ddte146/")
        terry:head_wag()
    else
        terry:say_line("/ddte147/")
        terry:head_wag()
    end
    terry:stop_head_left()
    wait_for_message()
    terry:replace_barrel_stamp()
    terry:barrel_idles()
end

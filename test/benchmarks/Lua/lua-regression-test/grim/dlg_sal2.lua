sa2 = Dialog:create()
sa2.focus = hq.salvador_obj
sa2.intro = function(arg1) -- line 12
    sa2.node = "first_sal_node"
    if rf.eggs.owner == manny then
        sa2[100].off = FALSE
    end
    if salvador.got_eggs then
        sa2[100] = FALSE
        sa2[140] = FALSE
        sa2[210] = FALSE
        sa2[220] = FALSE
        sa2[230] = FALSE
        sa2[240] = FALSE
    end
    if sa2.talked_out then
        if rf.eggs.owner == manny then
            sa2[100].off = FALSE
        else
            sa2.node = "exit_dialog"
            if salvador.got_eggs then
                manny:say_line("/hqma045/")
                wait_for_message()
                salvador:say_line("/hqsa046/")
            else
                manny:hand_gesture()
                manny:say_line("/hqma047/")
                wait_for_message()
                wait_for_message()
                salvador:say_line("/hqsa049/")
                salvador:push_chore(sv_hq_idles_turn_l_hand_out)
                salvador:push_chore()
                wait_for_message()
                salvador:push_chore(sv_hq_idles_turn_back)
                salvador:push_chore()
                manny:shrug_gesture()
                manny:say_line("/hqma050/")
            end
        end
    end
end
sa2[100] = { text = "/hqma051/", first_sal_node = TRUE }
sa2[100].off = TRUE
sa2[100].response = function(arg1) -- line 57
    arg1.off = TRUE
    sa2.node = "exit_dialog"
    sa2.outro = nil
    manny:play_chore(ms_takeout_get, "ms.cos")
    sleep_for(500)
    manny:stop_chore(ms_takeout_get, "ms.cos")
    manny:play_chore(ms_takeout_eggs, "ms.cos")
    manny:wait_for_chore(ms_takeout_eggs, "ms.cos")
    manny:play_chore_looping(ms_hold_eggs, "ms.cos")
    manny.hold_chore = ms_hold_eggs
    manny.is_holding = rf.eggs
    start_script(hq.salvador_obj.use_eggs, hq.salvador_obj)
end
sa2[130] = { text = "/hqma052/", first_sal_node = TRUE }
sa2[130].response = function(arg1) -- line 75
    arg1.off = TRUE
    sa2[135].off = FALSE
    salvador:say_line("/hqsa053/")
end
sa2[140] = { text = "/hqma054/", first_sal_node = TRUE, gesture = manny.tilt_head_gesture }
sa2[140].response = function(arg1) -- line 82
    arg1.off = TRUE
    sa2[210]:response()
end
sa2[135] = { text = "/hqma055/", first_sal_node = TRUE, gesture = manny.twist_head_gesture }
sa2[135].off = TRUE
sa2[135].response = function(arg1) -- line 89
    arg1.off = TRUE
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:say_line("/hqsa056/")
    wait_for_message()
    salvador:play_chore(sv_hq_idles_head_turn_right)
    salvador:say_line("/hqsa057/")
end
sa2[160] = { text = "/hqma058/", first_sal_node = TRUE, gesture = manny.tilt_head_gesture }
sa2[160].response = function(arg1) -- line 101
    arg1.off = TRUE
    sa2[170].off = FALSE
    salvador:push_chore(sv_hq_idles_turn_l_hand_out)
    salvador:push_chore()
    salvador:say_line("/hqsa059/")
    wait_for_message()
    salvador:say_line("/hqsa060/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_turn_back)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_head_turn_left)
    manny:nod_head_gesture()
    manny:say_line("/hqma061/")
    wait_for_message()
    salvador:say_line("/hqsa062/")
    wait_for_message()
    salvador:say_line("/hqsa063/")
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_screen_gest)
    salvador:push_chore()
    wait_for_message()
    manny:hand_gesture()
    manny:say_line("/hqma064/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_turn_l_hand_out)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_turn_back)
    salvador:push_chore()
    salvador:say_line("/hqsa154/")
    salvador:wait_for_message()
end
sa2[170] = { text = "/hqma066/", first_sal_node = TRUE }
sa2[170].off = TRUE
sa2[170].response = function(arg1) -- line 137
    arg1.off = TRUE
    sa2[180].off = FALSE
    salvador:push_chore(sv_hq_idles_talk_stand_up)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    salvador:say_line("/hqsa067/")
    wait_for_message()
    salvador:say_line("/hqsa068/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_talk_stand_down)
    salvador:push_chore()
    salvador:say_line("/hqsa069/")
    salvador:wait_for_message()
end
sa2[180] = { text = "/hqma070/", first_sal_node = TRUE, gesture = manny.shrug_gesture }
sa2[180].off = TRUE
sa2[180].response = function(arg1) -- line 156
    arg1.off = TRUE
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:push_chore()
    salvador:say_line("/hqsa071/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
    salvador:say_line("/hqsa072/")
    salvador:push_chore(sv_hq_idles_hand_forw)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_oh_well)
    salvador:push_chore()
    wait_for_message()
    salvador:say_line("/hqsa073/")
    salvador:play_chore(sv_hq_idles_head_turn_left)
    salvador:push_chore()
    salvador:wait_for_message()
    salvador:play_chore(sv_hq_idles_head_turn_right)
    salvador:wait_for_chore()
end
sa2[190] = { text = "/hqma074/", first_sal_node = TRUE, gesture = manny.tilt_head_gesture }
sa2[190].off = TRUE
sa2[190].response = function(arg1) -- line 180
    arg1.off = TRUE
    sa2[200].off = FALSE
    salvador:push_chore(sv_hq_idles_talk_stand_up)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    salvador:say_line("/hqsa075/")
    wait_for_message()
    salvador:head_look_at_point(hq.proj_spot_2)
    salvador:say_line("/hqsa076/")
    wait_for_message()
    manny:say_line("/hqma077/")
    salvador:head_look_at(manny)
    wait_for_message()
    salvador:say_line("/hqsa078/")
    wait_for_message()
    salvador:say_line("/hqsa079/")
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_talk_stand_down)
    salvador:push_chore()
    wait_for_message()
    salvador:head_look_at(nil)
    manny:say_line("/hqma080/")
end
sa2[200] = { text = "/hqma081/", first_sal_node = TRUE }
sa2[200].off = TRUE
sa2[200].response = function(arg1) -- line 209
    arg1.off = TRUE
    salvador:say_line("/hqsa082/")
    wait_for_message()
    salvador:say_line("/hqsa083/")
end
sa2[210] = { text = "/hqma084/", first_sal_node = TRUE, gesture = manny.shrug_gesture }
sa2[210].response = function(arg1) -- line 218
    arg1.off = TRUE
    sa2[130].off = TRUE
    sa2[140].off = TRUE
    sa2[135].off = TRUE
    sa2[220].off = FALSE
    salvador:say_line("/hqsa085/")
    salvador:push_chore(sv_hq_idles_talk_stand_up)
    salvador:push_chore()
    wait_for_message()
    salvador:say_line("/hqsa086/")
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_hand_up_down)
    salvador:push_chore()
    wait_for_message()
    salvador:say_line("/hqsa087/")
    salvador:push_chore(sv_hq_idles_talk_stand_down)
    salvador:push_chore()
    salvador:wait_for_message()
end
sa2[220] = { text = "/hqma088/", first_sal_node = TRUE, gesture = manny.tilt_head_gesture }
sa2[220].off = TRUE
sa2[220].response = function(arg1) -- line 242
    arg1.off = TRUE
    sa2[230].off = FALSE
    salvador:push_chore(sv_hq_idles_turn_l_hand_out)
    salvador:push_chore()
    salvador:say_line("/hqsa089/")
    wait_for_message()
    salvador:say_line("/hqsa090/")
    salvador:push_chore(sv_hq_idles_turn_back)
    salvador:push_chore()
    wait_for_message()
    salvador:say_line("/hqsa091/")
    salvador:wait_for_message()
end
sa2[230] = { text = "/hqma092/", first_sal_node = TRUE }
sa2[230].off = TRUE
sa2[230].response = function(arg1) -- line 260
    arg1.off = TRUE
    sa2[240].off = FALSE
    salvador.talked_eggs = TRUE
    salvador:push_chore(sv_hq_idles_head_turn_left)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
    salvador:say_line("/hqsa093/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_hand_forw)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_oh_well)
    salvador:push_chore()
    salvador:say_line("/hqsa094/")
end
sa2[240] = { text = "/hqma095/", first_sal_node = TRUE, gesture = manny.twist_head_gesture }
sa2[240].off = TRUE
sa2[240].response = function(arg1) -- line 280
    arg1.off = TRUE
    salvador:say_line("/hqsa096/")
    wait_for_message()
    salvador:push_chore(sv_hq_idles_head_turn_left)
    salvador:push_chore()
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
    salvador:say_line("/hqsa097/")
end
sa2.exit_lines.first_sal_node = { text = "/hqma098/" }
sa2.exit_lines.first_sal_node.response = function(arg1) -- line 293
    sa2.node = "exit_dialog"
    salvador:say_line("/hqsa099/")
    wait_for_message()
end
sa2.aborts.first_sal_node = function(arg1) -- line 299
    sa2:clear()
    sa2.node = "exit_dialog"
    sa2.talked_out = TRUE
    salvador:push_chore(sv_hq_idles_head_turn_left)
    salvador:say_line("/hqsa100/")
    wait_for_message()
    salvador:wait_for_chore()
    salvador:push_chore(sv_hq_idles_head_turn_right)
    salvador:push_chore()
end
sa2.outro = function(arg1) -- line 312
    salvador:say_line("/hqsa101/")
    salvador.stop_idle = FALSE
end
sa2[999] = "EOD"

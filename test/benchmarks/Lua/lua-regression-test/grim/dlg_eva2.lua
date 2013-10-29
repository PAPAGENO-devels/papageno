CheckFirstTime("dlg_eva2.lua")
ev2 = Dialog:create()
ev2.focus = hq.eva_obj
ev2.intro = function(arg1) -- line 13
    if not eva.got_teeth then
        if dom.mouthpiece.bonded then
            ev2[90].off = FALSE
        end
        if not eva.talked_out_again then
            ev2.node = "first_eva_node"
            if not ev2.talked then
                ev2.talked = TRUE
                manny:point_gesture()
                manny:say_line("/hqma001/")
                wait_for_message()
                eva:say_line("/hqev002/")
                wait_for_message()
                manny:shrug_gesture()
                manny:say_line("/hqma003/")
            end
        elseif not DEMO then
            ev2.node = "exit_dialog"
            manny:say_line("/hqma004/")
            wait_for_message()
            eva:say_line("/hqev005/")
        else
            manny:say_line("/hqma006/")
            wait_for_message()
            eva:say_line("/hqev007/")
        end
    else
        ev2.node = "exit_dialog"
        manny:say_line("/hqma006/")
        wait_for_message()
        eva:say_line("/hqev007/")
        single_start_script(eva.new_run_idle, eva, "turn_back")
    end
end
ev2[90] = { text = "/hqma008/", first_eva_node = TRUE }
ev2[90].off = TRUE
ev2[90].response = function(arg1) -- line 52
    arg1.off = TRUE
    ev2.node = "exit_dialog"
    manny:pull_out_item(dom.mouthpiece)
    start_script(hq.eva_obj.use_mouthpiece, hq.eva_obj)
end
ev2[100] = { text = "/hqma009/", first_eva_node = TRUE }
ev2[100].response = function(arg1) -- line 61
    arg1.off = TRUE
    eva:say_line("/hqev010/")
    wait_for_message()
    manny:say_line("/hqma011/")
    sleep_for(100)
    manny:shrug_gesture()
    wait_for_message()
    eva:say_line("/hqev012/")
end
ev2[110] = { text = "/hqma013/", first_eva_node = TRUE, gesture = manny.hand_gesture }
ev2[110].response = function(arg1) -- line 74
    arg1.off = TRUE
    eva.talked_teeth = TRUE
    eva:say_line("/hqev014/")
    wait_for_message()
    if not DEMO then
        eva:say_line("/hqev015/")
        wait_for_message()
        eva:say_line("/hqev016/")
        wait_for_message()
        manny:tilt_head_gesture()
        manny:say_line("/hqma017/")
        wait_for_message()
        manny:say_line("/hqma018/")
        wait_for_message()
        manny:shrug_gesture()
        manny:say_line("/hqma019/")
        wait_for_message()
        eva:say_line("/hqev020/")
        wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/hqma021/")
        wait_for_message()
        eva:say_line("/hqev022/")
        wait_for_message()
    end
    eva:say_line("/hqev023/")
    eva:head_look_at(nil)
    if not find_script(eva.new_run_idle) then
        start_script(eva.new_run_idle, eva, "turn_back")
    end
end
ev2[120] = { text = "/hqma024/", first_eva_node = TRUE, gesture = manny.tilt_head_gesture }
ev2[120].response = function(arg1) -- line 109
    arg1.off = TRUE
    eva:say_line("/hqev025/")
    wait_for_message()
    eva:say_line("/hqev026/")
    wait_for_message()
    stop_script(hq.salvador_idles)
    salvador:stop_chore(nil)
    salvador:push_costume("sv_helps.cos")
    salvador:setpos(-0.597382, 0.661287, 0)
    salvador:setrot(0, 135.673, 0)
    salvador:play_chore(sv_helps_peek)
    salvador:wait_for_chore()
    salvador:say_line("/hqsa027/")
    sleep_for(1000)
    manny:head_look_at(salvador)
    wait_for_message()
    manny:head_look_at(nil)
    salvador:play_chore(sv_helps_hide)
    salvador:wait_for_chore()
    salvador:stop_chore(nil)
    salvador:pop_costume()
    salvador:setpos(-0.825013, 0.391542, 0)
    salvador:setrot(0, -200, 0)
    start_script(hq.salvador_idles)
end
ev2[130] = { text = "/hqma031/", first_eva_node = TRUE, gesture = manny.tilt_head_gesture }
ev2[130].response = function(arg1) -- line 149
    arg1.off = TRUE
    eva:say_line("/hqev032/")
    wait_for_message()
    eva:say_line("/hqev033/")
end
ev2[140] = { text = "/hqma034/", first_eva_node = TRUE, gesture = manny.hand_gesture }
ev2[140].response = function(arg1) -- line 158
    arg1.off = TRUE
    eva:say_line("/hqev035/")
    wait_for_message()
    eva:say_line("/hqev036/")
    wait_for_message()
    eva:say_line("/hqev037/")
    wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/hqma038/")
    wait_for_message()
    eva:say_line("/hqev039/")
end
ev2.exit_lines.first_eva_node = { text = "/hqma040/" }
ev2.exit_lines.first_eva_node.response = function(arg1) -- line 174
    ev2.node = "exit_dialog"
    eva:say_line("/hqev041/")
    eva:head_look_at(nil)
    if not find_script(eva.new_run_idle) then
        start_script(eva.new_run_idle, eva, "turn_back")
    end
end
ev2.aborts.first_eva_node = function(arg1) -- line 183
    ev2:clear()
    ev2.node = "exit_dialog"
    eva.talked_out_again = TRUE
    manny:hand_gesture()
    manny:say_line("/hqma042/")
    wait_for_message()
    if DEMO then
        eva:say_line("/hqev023/")
    else
        eva:say_line("/hqev043/")
        wait_for_message()
        eva:say_line("/hqev044/")
    end
    eva:head_look_at(nil)
    if not find_script(eva.new_run_idle) then
        start_script(eva.new_run_idle, eva, "turn_back")
    end
end
ev2.outro = function(arg1) -- line 203
    manny:head_look_at(nil)
end
ev2[999] = "EOD"

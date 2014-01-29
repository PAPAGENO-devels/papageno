CheckFirstTime("dlg_brennis.lua")
br1 = Dialog:create()
br1.focus = tu.brennis_obj
br1.intro = function() -- line 13
    br1.node = "first_brennis_node"
    START_CUT_SCENE()
    if not brennis.met then
        brennis.met = TRUE
        manny:hand_gesture()
        manny:say_line("/tuma001/")
        brennis:start_talking()
        manny:wait_for_message()
        brennis:say_line("/tubs002/")
        brennis:wait_for_message()
        brennis:say_line("/tubs003/")
        brennis:wait_for_message()
        brennis:say_line("/tubs004/")
    elseif brennis.chatted_out then
        br1.node = "exit_dialog"
        manny:hand_gesture()
        manny:say_line("/tuma005/")
        manny:wait_for_message()
        brennis:say_line("/tubs006/")
    end
    END_CUT_SCENE()
end
br1[85] = { text = "/tuma007/", first_brennis_node = TRUE, gesture = manny.tilt_head_gesture }
br1[85].response = function(arg1) -- line 41
    arg1.off = TRUE
    br1[87].off = FALSE
    brennis:say_line("/tubs008/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs009/")
end
br1[87] = { text = "/tuma010/", first_brennis_node = TRUE, gesture = manny.shrug_gesture }
br1[87].off = TRUE
br1[87].response = function(arg1) -- line 52
    arg1.off = TRUE
    br1[130].off = FALSE
    brennis:say_line("/tubs011/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs012/")
    brennis:wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/tuma013/")
    manny:wait_for_message()
    brennis:say_line("/tubs014/")
end
br1[90] = { text = "/tuma015/", first_brennis_node = TRUE, gesture = { manny.point_gesture, manny.head_forward_gesture } }
br1[90].response = function(arg1) -- line 67
    arg1.off = TRUE
    br1[95].off = FALSE
    brennis:say_line("/tubs016/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs017/")
    brennis:wait_for_message()
    brennis:say_line("/tubs018/")
end
br1[95] = { text = "/tuma019/", first_brennis_node = TRUE, gesture = manny.shrug_gesture }
br1[95].off = TRUE
br1[95].response = function(arg1) -- line 80
    arg1.off = TRUE
    brennis:say_line("/tubs020/")
    brennis:start_talking()
    brennis:wait_for_message()
    manny:say_line("/tuma021/")
    sleep_for(200)
    manny:point_gesture()
    manny:nod_head_gesture(TRUE)
    manny:wait_for_message()
    manny:say_line("/tuma022/")
    manny:wait_for_message()
    brennis:say_line("/tubs023/")
    brennis:wait_for_message()
    brennis:say_line("/tubs024/")
end
br1[100] = { text = "/tuma025/", gesture = { manny.hand_gesture, manny.tilt_head_gesture } }
br1[100].response = function(arg1) -- line 98
    arg1.off = TRUE
    brennis:say_line("/tubs026/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs027/")
end
br1[110] = { text = "/tuma028/", first_brennis_node = TRUE, gesture = { manny.shrug_gesture, manny.twist_head_gesture } }
br1[110].response = function(arg1) -- line 108
    arg1.off = TRUE
    brennis:say_line("/tubs029/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs030/")
    brennis:wait_for_message()
    brennis:say_line("/tubs031/")
end
br1[130] = { text = "/tuma032/", first_brennis_node = TRUE, gesture = { manny.shrug_gesture, manny.head_forward_gesture } }
br1[130].off = TRUE
br1[130].response = function(arg1) -- line 120
    arg1.off = TRUE
    brennis:say_line("/tubs033/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs034/")
    brennis:wait_for_message()
    brennis:say_line("/tubs035/")
    brennis:wait_for_message()
    manny:nod_head_gesture()
    manny:say_line("/tuma036/")
end
br1[140] = { text = "/tuma037/", first_brennis_node = TRUE, gesture = manny.point_gesture }
br1[140].response = function(arg1) -- line 135
    arg1.off = TRUE
    brennis:say_line("/tubs038/")
    brennis:start_talking()
    brennis:wait_for_message()
    brennis:say_line("/tubs039/")
    brennis:wait_for_message()
    brennis:say_line("/tubs040/")
end
br1.exit_lines.first_brennis_node = { text = "/tuma041/", gesture = manny.shrug_gesture }
br1.exit_lines.first_brennis_node.response = function(arg1) -- line 147
    br1.node = "exit_dialog"
    brennis:say_line("/tubs042/")
end
br1.aborts.first_brennis_node = function(arg1) -- line 152
    br1:clear()
    br1.node = exit
    brennis.chatted_out = TRUE
    brennis:start_talking()
    brennis:say_line("/tubs043/")
    brennis:wait_for_message()
    brennis:say_line("/tubs044/")
    brennis:wait_for_message()
    manny:point_gesture()
    manny:say_line("/tuma045/")
end
br1.outro = function(arg1) -- line 165
    START_CUT_SCENE()
    brennis:stop_talking()
    if not brennis.burnt then
        brennis:burn()
    end
    END_CUT_SCENE()
end
br1[999] = "EOD"

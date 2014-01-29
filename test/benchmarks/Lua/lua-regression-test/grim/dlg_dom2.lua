CheckFirstTime("dlg_domino.lua")
do2 = Dialog:create()
do2.display_lines = function(arg1) -- line 11
    start_script(dr.smoke_idles, TRUE)
    arg1.parent.display_lines(do2)
end
do2.no_smoking = function(arg1) -- line 16
    stop_script(dr.smoke_idles)
    if domino.smoking then
        domino:play_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
        domino:blend(dom_isle_idles_idle, dom_isle_idles_smoke_no_headphone, 750, "dom_isle_idles.cos")
        sleep_for(750)
        domino:stop_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
        domino:play_chore(dom_isle_idles_idle, "dom_isle_idles.cos")
    end
end
do2.execute_line = function(arg1, arg2) -- line 27
    start_script(do2.no_smoking)
    Dialog.execute_line(do2, arg2)
end
do2.intro = function(arg1) -- line 32
    do2.node = "n1"
    stop_script(dr.smoke_idles)
    if meche.locked_up and not do2[90].said and not vd.heard_meche then
        do2[90].off = FALSE
    else
        do2[90].off = TRUE
    end
    if meche.locked_up and not do2[100].said and vd.heard_meche then
        do2[100].off = FALSE
    else
        do2[100].off = TRUE
    end
    if dr.talked_out then
        do2.node = "exit_dialog"
        manny:say_line("/drma001/")
    else
        domino.wearing_headphones = FALSE
        if not do2.initiated then
            manny:say_line("/drma002/")
            wait_for_message()
        end
        manny:walkto_object(dr.domino_obj)
        manny:push_costume("mn_hit_desk.cos")
        manny:play_chore(0)
        sleep_for(500)
        manny:say_line("/drma003/")
        sleep_for(500)
        start_script(dr.phones_off)
        manny:wait_for_chore()
        manny:pop_costume()
        domino:wait_for_chore(dom_isle_idles_takeoff_headphone, "dom_isle_idles.cos")
        wait_for_message()
        if not do2.initiated then
            do2.initiated = TRUE
            domino:say_line("/drdo004/")
            wait_for_message()
            manny:say_line("/drma005/")
            manny:point_gesture()
            wait_for_message()
            domino:say_line("/drdo006/")
            domino:blend(dom_isle_idles_idle, dom_isle_idles_takeoff_headphone, 1000, "dom_isle_idles.cos")
            domino:play_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
        else
            domino:say_line("/drdo007/")
            domino:blend(dom_isle_idles_idle, dom_isle_idles_takeoff_headphone, 1000, "dom_isle_idles.cos")
        end
    end
end
do2[90] = { text = "/drma008/", n1 = TRUE }
do2[90].off = TRUE
do2[90].response = function(arg1) -- line 88
    arg1.off = TRUE
    domino:say_line("/drdo009/")
    sleep_for(1000)
    domino:play_chore(dom_isle_idles_doublehand, "dom_isle_idles.cos")
    wait_for_message()
    domino:play_chore(dom_isle_idles_doublehand2idle, "dom_isle_idles.cos")
end
do2[100] = { text = "/drma010/", n1 = TRUE, gesture = manny.tilt_head_gesture }
do2[100].off = TRUE
do2[100].response = function(arg1) -- line 100
    arg1.off = TRUE
    domino:say_line("/drdo011/")
    wait_for_message()
    manny:say_line("/drma012/")
    wait_for_message()
    domino:say_line("/drdo013/")
    domino:play_chore(dom_isle_idles_dom_isle_idles_shrug, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo014/")
end
do2[110] = { text = "/drma015/", n1 = TRUE, gesture = manny.point_gesture }
do2[110].response = function(arg1) -- line 113
    arg1.off = TRUE
    domino:say_line("/drdo016/")
    wait_for_message()
    domino:play_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
    domino:say_line("/drdo017/")
    sleep_for(2000)
    domino:run_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    sleep_for(400)
    domino:run_chore(dom_isle_idles_count1, "dom_isle_idles.cos")
    sleep_for(700)
    domino:run_chore(dom_isle_idles_count2, "dom_isle_idles.cos")
    sleep_for(500)
    domino:play_chore(dom_isle_idles_countdown, "dom_isle_idles.cos")
    domino:wait_for_message()
    domino:say_line("/drdo018/")
    domino:wait_for_chore(dom_isle_idles_countdown, "dom_isle_idles.cos")
    domino:play_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
end
do2[120] = { text = "/drma019/", n1 = TRUE, gesture = manny.shrug_gesture }
do2[120].response = function(arg1) -- line 134
    arg1.off = TRUE
    do2[170].off = FALSE
    domino:say_line("/drdo020/")
    domino:play_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo021/")
    domino:play_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    domino:wait_for_message()
    domino:play_chore(dom_isle_idles_thumb2idle, "dom_isle_idles.cos")
end
do2[130] = { text = "/drma022/", n1 = TRUE, gesture = manny.twist_head_gesture }
do2[130].response = function(arg1) -- line 147
    arg1.off = TRUE
    domino:say_line("/drdo023/")
end
do2[140] = { text = "/drma024/", n1 = TRUE, gesture = manny.hand_gesture }
do2[140].response = function(arg1) -- line 153
    arg1.off = TRUE
    do2[150].off = FALSE
    domino:say_line("/drdo025/")
    wait_for_message()
    domino:say_line("/drdo026/")
    domino:run_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
    domino:run_chore(dom_isle_idles_shrug, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo027/")
    sleep_for(1000)
    domino:run_chore(dom_isle_idles_doublehand, "dom_isle_idles.cos")
    wait_for_message()
    domino:run_chore(dom_isle_idles_doublehand2idle, "dom_isle_idles.cos")
end
do2[150] = { text = "/drma028/", n1 = TRUE, gesture = manny.twist_head_gesture }
do2[150].off = TRUE
do2[150].response = function(arg1) -- line 171
    arg1.off = TRUE
    do2[160].off = FALSE
    domino:say_line("/drdo029/")
    wait_for_message()
    domino:say_line("/drdo030/")
    sleep_for(3000)
    domino:run_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo031/")
end
do2[160] = { text = "/drma032/", n1 = TRUE }
do2[160].off = TRUE
do2[160].response = function(arg1) -- line 185
    arg1.off = TRUE
    domino:say_line("/drdo033/")
    domino:play_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    sleep_for(3000)
    domino:play_chore(dom_isle_idles_count1, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo034/")
    domino:play_chore(dom_isle_idles_count2, "dom_isle_idles.cos")
    wait_for_message()
    domino:run_chore(dom_isle_idles_countdown, "dom_isle_idles.cos")
    domino:say_line("/drdo035/")
    domino:play_chore(dom_isle_idles_shrug, "dom_isle_idles.cos")
end
do2[170] = { text = "/drma036/", n1 = TRUE }
do2[170].off = TRUE
do2[170].response = function(arg1) -- line 202
    arg1.off = TRUE
    do2[180].off = FALSE
    domino:say_line("/drdo037/")
    domino:play_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo038/")
    domino:play_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo039/")
    wait_for_message()
    domino:play_chore(dom_isle_idles_thumb2idle, "dom_isle_idles.cos")
    domino:say_line("/drdo040/")
end
do2[180] = { text = "/drma041/", n1 = TRUE, gesture = manny.head_forward_gesture }
do2[180].off = TRUE
do2[180].response = function(arg1) -- line 219
    arg1.off = TRUE
    do2[190].off = FALSE
    do2[210].off = FALSE
    domino:say_line("/drdo042/")
    wait_for_message()
    domino:say_line("/drdo043/")
    domino:play_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo044/")
    domino:play_chore(dom_isle_idles_count1, "dom_isle_idles.cos")
    sleep_for(3000)
    domino:run_chore(dom_isle_idles_count2, "dom_isle_idles.cos")
    wait_for_message()
    domino:run_chore(dom_isle_idles_countdown, "dom_isle_idles.cos")
end
do2[190] = { text = "/drma045/", n1 = TRUE, gesture = manny.tilt_head_gesture }
do2[190].off = TRUE
do2[190].response = function(arg1) -- line 238
    arg1.off = TRUE
    do2[195].off = FALSE
    domino:say_line("/drdo046/")
    wait_for_message()
    domino:say_line("/drdo047/")
    domino:play_chore(dom_isle_idles_thumb_at_ma, "dom_isle_idles.cos")
    wait_for_message()
    domino:run_chore(dom_isle_idles_thumb2idle, "dom_isle_idles.cos")
    domino:say_line("/drdo048/")
    domino:play_chore(dom_isle_idles_head_shake, "dom_isle_idles.cos")
end
do2[195] = { text = "/drma049/", n1 = TRUE }
do2[195].off = TRUE
do2[195].response = function(arg1) -- line 254
    arg1.off = TRUE
    domino:say_line("/drdo050/")
    wait_for_message()
    domino:say_line("/drdo051/")
end
do2[200] = { text = "/drma052/", n1 = TRUE }
do2[200].response = function(arg1) -- line 263
    arg1.off = TRUE
    domino:say_line("/drdo053/")
    wait_for_message()
    domino:say_line("/drdo054/")
    sleep_for(3000)
    domino:play_chore(dom_isle_idles_shrug, "dom_isle_idles.cos")
end
do2[210] = { text = "/drma055/", n1 = TRUE, gesture = manny.shrug_gesture }
do2[210].off = TRUE
do2[210].response = function(arg1) -- line 274
    arg1.off = TRUE
    do2[220].off = FALSE
    domino:say_line("/drdo056/")
    domino:play_chore(dom_isle_idles_shake_head, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo057/")
    wait_for_message()
    domino:say_line("/drdo058/")
end
do2[220] = { text = "/drma059/", n1 = TRUE }
do2[220].off = TRUE
do2[220].response = function(arg1) -- line 287
    arg1.off = TRUE
    domino:say_line("/drdo060/")
    sleep_for(2000)
    domino:run_chore(dom_isle_idles_shrug, "dom_isle_idles.cos")
end
do2[230] = { text = "/drma061/", n1 = TRUE, gesture = manny.hand_gesture }
do2[230].response = function(arg1) -- line 295
    arg1.off = TRUE
    domino:say_line("/drdo062/")
    wait_for_message()
    domino:say_line("/drdo063/")
    wait_for_message()
    domino:say_line("/drdo064/")
    domino:run_chore(dom_isle_idles_point, "dom_isle_idles.cos")
    wait_for_message()
    manny:say_line("/drma065/")
    domino:run_chore(dom_isle_idles_point2idle, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo066/")
    wait_for_message()
    domino:say_line("/drdo067/")
    domino:run_chore(dom_isle_idles_point, "dom_isle_idles.cos")
    wait_for_message()
    domino:say_line("/drdo068/")
    domino:run_chore(dom_isle_idles_point2idle, "dom_isle_idles.cos")
    domino:wait_for_message()
end
do2.exit_lines.n1 = { text = "/drma069/", gesture = manny.tilt_head_gesture }
do2.exit_lines.n1.response = function(arg1) -- line 318
    do2.node = "exit_dialog"
    domino:say_line("/drdo070/")
    domino:run_chore(dom_isle_idles_laugh, "dom_isle_idles.cos")
    domino:wait_for_message()
end
do2.aborts.n1 = function(arg1) -- line 325
    dr.talked_out = TRUE
    do2:clear()
    do2:execute_line(do2.exit_lines.n1)
end
do2.outro = function(arg1) -- line 331
    domino:wait_for_chore()
    if not domino.wearing_headphones then
        start_script(dr.phones_on)
    end
    stop_script(dr.smoke_idles)
    start_script(dr.smoke_idles, FALSE)
end

CheckFirstTime("dlg_vel2.lua")
ve2 = Dialog:create()
ve2.focus = lm.velasco_obj
ve2.intro = function(arg1) -- line 13
    ve2.node = "first_vel_node"
    music_state:set_state(stateLM_TALK)
    if lm.talked_union and lm.talked_naranja and lm.talked_tools then
        ve2[90].off = FALSE
    end
    if made_vacancy and hh.union_card.owner == manny and dd.strike_on then
        ve2[90].off = TRUE
    end
    if made_vacancy then
        ve2[100].off = FALSE
        ve2[180].off = TRUE
        ve2[110].off = TRUE
        ve2[120].off = TRUE
        ve2[130].off = TRUE
        if not ve2[140].said then
            ve2[140].off = FALSE
        end
        ve2[150].off = TRUE
        ve2[160].off = TRUE
        ve2[190].off = TRUE
    end
    if hh.union_card.owner == manny then
        ve2[100].off = FALSE
        ve2[150].off = TRUE
        ve2[160].off = TRUE
        ve2[200].off = TRUE
        ve2[210].off = TRUE
    end
    if dd.strike_on then
        ve2[100].off = FALSE
        ve2[160].off = TRUE
        ve2[165].off = TRUE
        ve2[170].off = TRUE
    end
    manny:head_look_at(arg1.focus)
    break_here()
    manny:head_look_at(arg1.focus)
end
ve2.execute_line = function(arg1, arg2) -- line 56
    if not velasco.facing_manny then
        start_script(velasco.face_manny)
    end
    ve2.parent.execute_line(ve2, arg2)
end
ve2[90] = { text = "/lmma001/", first_vel_node = TRUE }
ve2[90].off = TRUE
ve2[90].response = function(arg1) -- line 65
    local local1 = made_vacancy
    local local2 = hh.union_card.owner == manny
    local local3 = dd.strike_on
    lm.talked_naranja = TRUE
    lm.talked_union = TRUE
    lm.talked_tools = TRUE
    ve2.node = "exit_dialog"
    lm:talk_progress(local1, local2, local3)
end
ve2[100] = { text = "/lmma002/", first_vel_node = TRUE }
ve2[100].response = function(arg1) -- line 80
    arg1.off = TRUE
    if made_vacancy or hh.union_card.owner == manny or dd.strike_on then
        ve2[90]:response()
    else
        ve2[110].off = FALSE
        velasco:say_line("/lmve003/")
        wait_for_message()
        manny:say_line("/lmma004/")
        wait_for_message()
        velasco:say_line("/lmve005/")
        wait_for_message()
        velasco:say_line("/lmve007/")
    end
end
ve2[110] = { text = "/lmma008/", first_vel_node = TRUE, gesture = manny.shrug_gesture }
ve2[110].off = TRUE
ve2[110].response = function(arg1) -- line 100
    arg1.off = TRUE
    ve2[120].off = FALSE
    ve2[165].off = FALSE
    lm.talked_tools = TRUE
    velasco:say_line("/lmve009/")
    wait_for_message()
    manny:head_forward_gesture()
    manny:say_line("/lmma010/")
    wait_for_message()
    velasco:say_line("/lmve011/")
    velasco:run_chore(ve_talks_to_ma_thinking, "ve_talks_to_ma.cos")
    wait_for_message()
    manny:say_line("/lmma012/")
    wait_for_message()
    velasco:say_line("/lmve013/")
    wait_for_message()
    velasco:say_line("/lmve014/")
end
ve2[120] = { text = "/lmma015/", first_vel_node = TRUE, gesture = manny.hand_gesture }
ve2[120].off = TRUE
ve2[120].response = function(arg1) -- line 123
    arg1.off = TRUE
    ve2[130].off = FALSE
    velasco:say_line("/lmve016/")
    wait_for_message()
    velasco:say_line("/lmve017/")
    wait_for_message()
    velasco:say_line("/lmve018/")
    wait_for_message()
    velasco:say_line("/lmve019/")
    wait_for_message()
    velasco:head_look_at(lm.bottle)
    velasco:say_line("/lmve020/")
    wait_for_message()
    velasco:set_look_rate(120)
    velasco:head_look_at(nil)
end
ve2[130] = { text = "/lmma021/", first_vel_node = TRUE }
ve2[130].off = TRUE
ve2[130].response = function(arg1) -- line 143
    arg1.off = TRUE
    ve2[140].off = FALSE
    if not made_vacancy then
        ve2[150].off = FALSE
        ve2[190].off = FALSE
    end
    lm.talked_naranja = TRUE
    velasco:say_line("/lmve022/")
end
ve2[140] = { text = "/lmma023/", first_vel_node = TRUE }
ve2[140].off = TRUE
ve2[140].response = function(arg1) -- line 156
    arg1.off = TRUE
    arg1.said = TRUE
    velasco:say_line("/lmve024/")
    wait_for_message()
    manny:nod_head_gesture()
    manny:say_line("/lmma025/")
    wait_for_message()
    velasco:say_line("/lmve026/")
end
ve2[150] = { text = "/lmma027/", first_vel_node = TRUE }
ve2[150].off = TRUE
ve2[150].response = function(arg1) -- line 169
    arg1.off = TRUE
    ve2[160].off = FALSE
    if not hh.union_card.owner == manny then
        ve2[200].off = FALSE
    end
    lm.talked_union = TRUE
    cn.charlie_obj.talked_out = FALSE
    velasco:say_line("/lmve028/")
    wait_for_message()
    manny:point_gesture()
    manny:tilt_head_gesture(TRUE)
    manny:say_line("/lmma029/")
    wait_for_message()
    velasco:say_line("/lmve030/")
    wait_for_message()
    velasco:say_line("/lmve031/")
    wait_for_message()
    velasco:say_line("/lmve032/")
    wait_for_message()
    velasco:say_line("/lmve033/")
end
ve2[160] = { text = "/lmma034/", first_vel_node = TRUE, gesture = manny.head_forward_gesture }
ve2[160].off = TRUE
ve2[160].response = function(arg1) -- line 194
    arg1.off = TRUE
    manny:say_line("/lmma035/")
    wait_for_message()
    velasco:say_line("/lmve036/")
    wait_for_message()
    manny:hand_gesture()
    manny:say_line("/lmma037/")
    wait_for_message()
    velasco:say_line("/lmve038/")
    wait_for_message()
    manny:say_line("/lmma039/")
    wait_for_message()
    velasco:say_line("/lmve040/")
    wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/lmma041/")
    wait_for_message()
    velasco:say_line("/lmve042/")
    velasco:head_look_at(lm.bottle)
    wait_for_message()
    sleep_for(2000)
    velasco:head_look_at_manny()
    velasco:say_line("/lmve043/")
end
ve2[165] = { text = "/lmma044/", first_vel_node = TRUE }
ve2[165].off = TRUE
ve2[165].response = function(arg1) -- line 222
    arg1.off = TRUE
    ve2[170].off = FALSE
    velasco:say_line("/lmve045/")
end
ve2[170] = { text = "/lmma046/", first_vel_node = TRUE, gesture = manny.shrug_gesture }
ve2[170].off = TRUE
ve2[170].response = function(arg1) -- line 230
    arg1.off = TRUE
    velasco:say_line("/lmve047/")
    wait_for_message()
    velasco:say_line("/lmve048/")
    wait_for_message()
    velasco:say_line("/lmve049/")
end
ve2[180] = { text = "/lmma050/", first_vel_node = TRUE }
ve2[180].off = TRUE
ve2[180].response = function(arg1) -- line 241
    arg1.off = TRUE
    if si.naranja_out then
        velasco:say_line("/lmve051/")
        wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/lmma052/")
        wait_for_message()
        velasco:say_line("/lmve053/")
    else
        velasco:say_line("/lmve054/")
    end
end
ve2[190] = { text = "/lmma055/", first_vel_node = TRUE }
ve2[190].off = TRUE
ve2[190].response = function(arg1) -- line 257
    arg1.off = TRUE
    velasco:say_line("/lmve056/")
end
ve2[200] = { text = "/lmma057/", first_vel_node = TRUE }
ve2[200].off = TRUE
ve2[200].response = function(arg1) -- line 264
    arg1.off = TRUE
    ve2[210].off = FALSE
    velasco:say_line("/lmve058/")
    wait_for_message()
    velasco:say_line("/lmve059/")
    wait_for_message()
    velasco:say_line("/lmve060/")
    wait_for_message()
    velasco:say_line("/lmve061/")
    wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/lmma062/")
end
ve2[210] = { text = "/lmma063/", first_vel_node = TRUE }
ve2[210].off = TRUE
ve2[210].response = function(arg1) -- line 281
    arg1.off = TRUE
    velasco:say_line("/lmve064/")
    wait_for_message()
    manny:point_gesture()
    manny:say_line("/lmma065/")
    wait_for_message()
    velasco:say_line("/lmve066/")
    wait_for_message()
    velasco:say_line("/lmve067/")
    wait_for_message()
    velasco:say_line("/lmve068/")
end
ve2[220] = { text = "/lmma069/", first_vel_node = TRUE }
ve2[220].response = function(arg1) -- line 296
    arg1.off = TRUE
    velasco:say_line("/lmve070/")
    velasco:head_look_at(lm.bottle)
    manny:head_look_at(lm.bottle)
    wait_for_message()
    velasco:say_line("/lmve071/")
    wait_for_message()
    manny:head_look_at(lm.velasco_obj)
    manny:say_line("/lmma072/")
    wait_for_message()
    sleep_for(1000)
    velasco:head_look_at_manny()
    sleep_for(1000)
    velasco:say_line("/lmve073/")
    wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/lmma074/")
end
ve2.exit_lines.first_vel_node = { text = "/lmma075/" }
ve2.exit_lines.first_vel_node.response = function(arg1) -- line 318
    ve2.node = "exit_dialog"
    single_start_script(velasco.face_bottle, velasco)
    velasco:say_line("/lmve076/")
end
ve2.aborts.first_vel_node = function(arg1) -- line 324
    ve2:execute_line(ve2.exit_lines.first_vel_node)
end
ve2.outro = function(arg1) -- line 328
    music_state:set_state(stateLM)
    if velasco.facing_manny then
        single_start_script(velasco.face_bottle, velasco)
    end
end
ve2[999] = "EOD"

CheckFirstTime("dlg_velasco.lua")
ve1 = Dialog:create()
ve1.focus = re.velasco_obj
ve1.track_conversation = function(arg1) -- line 12
    local local1
    while system.currentSet == re do
        local1 = system.lastActorTalking
        if local1 == velasco then
            manny:head_look_at(re.velasco_obj)
        elseif local1 == glottis then
            manny:head_look_at_point({ x = 0.82182503, y = -4.5329499, z = -2.6559999 })
        end
        while local1 == system.lastActorTalking do
            break_here()
        end
    end
end
ve1.intro = function(arg1, arg2) -- line 27
    ve1.node = "first_velasco_node"
    stop_script(re.fake_conversation)
    re.in_dialog = TRUE
    start_script(ve1.track_conversation)
    wait_for_script(re.car_talk_intro)
    velasco:shut_up()
    glottis:shut_up()
    stop_script(re.vel_look_around)
    velasco:head_look_at_manny()
    stop_script(velasco.new_run_idle)
    velasco:play_chore(velasco_idles_back_to_rest, "velasco_idles.cos")
    manny:face_entity(re.velasco_obj)
    if arg2 == "photo" then
        if not ve1.seen_picture then
            ve1.seen_picture = TRUE
            ve1.talked_out = FALSE
            ve1[90].off = FALSE
            manny:say_line("/rema001/")
            wait_for_message()
            velasco:say_line("/reve002/")
            wait_for_message()
            velasco:say_line("/reve003/")
            wait_for_message()
            velasco:say_line("/reve004/")
            sleep_for(1000)
            manny:clear_hands()
        elseif ve1.got_logbook then
            ve1.node = "exit_dialog"
            velasco:say_line("/reve003/")
            wait_for_message()
            velasco:say_line("/reve016/")
            wait_for_message()
            manny:clear_hands()
        end
    elseif ve1.talked_out then
        ve1.node = "exit_dialog"
        manny:say_line("/rema005/")
        wait_for_message()
        velasco:say_line("/reve006/")
        wait_for_message()
        velasco:say_line("/reve007/")
    elseif not ve1.introduced then
        ve1.introduced = TRUE
        re:more_car_talk()
        wait_for_message()
        manny:say_line("/lyma047/")
        glottis:head_look_at_manny()
        wait_for_message()
        glottis:say_line("/regl008/")
        wait_for_message()
        glottis:say_line("/regl009/")
        wait_for_message()
        velasco:say_line("/reve010/")
        glottis:head_follow_mesh(velasco, 6, TRUE)
        wait_for_message()
        glottis:head_look_at_manny()
        glottis:say_line("/regl011/")
        wait_for_message()
        velasco:say_line("/reve012/")
        glottis:head_follow_mesh(velasco, 6, TRUE)
        wait_for_message()
    else
        manny:say_line("/rema013/")
        wait_for_message()
        velasco:say_line("/reve014/")
    end
end
ve1[90] = { text = "/rema015/", first_velasco_node = TRUE, gesture = manny.twist_head_gesture }
ve1[90].off = TRUE
ve1[90].response = function(arg1) -- line 106
    arg1.off = TRUE
    ve1.got_logbook = TRUE
    velasco:say_line("/reve016/")
    wait_for_message()
    velasco:head_look_at(nil)
    velasco:say_line("/reve017/")
    manny:clear_hands()
    manny:walkto(0.462738, -4.19471, -3.4, 0, 301.02, 0)
    manny:wait_for_actor()
    velasco:stop_chore(velasco_idles_back_to_rest, "velasco_idles.cos")
    velasco:play_chore(velasco_idles_give_logbook, "velasco_idles.cos")
    manny:play_chore(ma_reach_med, "ma.cos")
    sleep_for(1000)
    manny:generic_pickup(re.logbook)
    velasco:wait_for_chore(velasco_idles_give_logbook, "velasco_idles.cos")
    manny:fade_out_chore(ma_reach_med, "ma.cos", 500)
    velasco:play_chore(velasco_idles_stop_give_logbook, "velasco_idles.cos")
    velasco:wait_for_chore(velasco_idles_stop_give_logbook, "velasco_idles.cos")
    velasco:play_chore(velasco_idles_standing, "velasco_idles.cos")
    velasco:wait_for_message()
    look_at_item_in_hand(TRUE)
    velasco:say_line("/reve018/")
    wait_for_message()
    manny:head_look_at(nil)
    manny:clear_hands()
    velasco:say_line("/reve019/")
end
ve1[100] = { text = "/rema020/", first_velasco_node = TRUE, gesture = manny.head_forward_gesture }
ve1[100].response = function(arg1) -- line 136
    arg1.off = TRUE
    velasco:say_line("/reve021/")
    wait_for_message()
    velasco:say_line("/reve022/")
    wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/rema023/")
    wait_for_message()
    velasco:say_line("/reve024/")
    wait_for_message()
    velasco:say_line("/reve025/")
end
ve1[110] = { text = "/rema026/", first_velasco_node = TRUE, gesture = manny.hand_gesture }
ve1[110].response = function(arg1) -- line 152
    arg1.off = TRUE
    velasco:say_line("/reve027/")
    wait_for_message()
    velasco:say_line("/reve028/")
end
ve1[120] = { text = "/rema029/", first_velasco_node = TRUE, gesture = manny.shrug_gesture }
ve1[120].response = function(arg1) -- line 160
    arg1.off = TRUE
    ve1[130].off = FALSE
    velasco:say_line("/reve030/")
    wait_for_message()
    velasco:say_line("/reve031/")
    wait_for_message()
    velasco:say_line("/reve032/")
    wait_for_message()
    glottis:say_line("/regl033/")
    wait_for_message()
    glottis:head_look_at_manny()
    glottis:say_line("/regl034/")
    wait_for_message()
    glottis:head_follow_mesh(velasco, 6, TRUE)
end
ve1[130] = { text = "/rema035/", first_velasco_node = TRUE, gesture = manny.point_gesture }
ve1[130].off = TRUE
ve1[130].response = function(arg1) -- line 179
    arg1.off = TRUE
    manny:tilt_head_gesture()
    manny:say_line("/rema036/")
    wait_for_message()
    velasco:say_line("/reve037/")
    wait_for_message()
    velasco:say_line("/reve038/")
    wait_for_message()
    velasco:say_line("/reve039/")
end
ve1.exit_lines.first_velasco_node = { text = "/rema047/" }
ve1.exit_lines.first_velasco_node.response = function(arg1) -- line 193
    ve1.node = "exit_dialog"
    if not ve1.seen_picture or (ve1.seen_picture and ve1.talked_lamancha) then
        velasco:say_line("/reve048/")
        wait_for_message()
        velasco:say_line("/reve049/")
    end
end
ve1.aborts.first_velasco_node = function(arg1) -- line 202
    ve1:clear()
    ve1.node = "exit_dialog"
    ve1.talked_out = TRUE
    glottis:head_look_at_manny()
    glottis:say_line("/regl050/")
    wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/rema051/")
    manny:wait_for_message()
end
ve1.outro = function(arg1) -- line 214
    if ve1.seen_picture and not ve1.talked_lamancha then
        ve1.talked_lamancha = TRUE
        wait_for_message()
        velasco:say_line("/reve052/")
        wait_for_message()
        velasco:say_line("/reve053/")
        wait_for_message()
        velasco:say_line("/reve054/")
        wait_for_message()
        manny:say_line("/rema055/")
        wait_for_message()
        velasco:say_line("/reve056/")
        wait_for_message()
        velasco:say_line("/reve057/")
    end
    stop_script(ve1.track_conversation)
    manny:head_look_at(nil)
    velasco:head_look_at_point(re.bw_look2)
    single_start_script(velasco.new_run_idle, velasco, "standing")
    single_start_script(re.vel_look_around)
    glottis:head_follow_mesh(velasco, 6, TRUE)
    re.in_dialog = FALSE
    start_script(re.fake_conversation)
end
ve1[999] = "EOD"

CheckFirstTime("dlg_clown.lua")
cl1 = Dialog:create()
cl1.intro = function(arg1) -- line 11
    cl1.node = "first_clown_node"
    if DEMO then
        cl1[104].off = TRUE
    end
    if not cl1.been_there then
        cl1.been_there = TRUE
        manny:hand_gesture()
        manny:say_line("/fema001/")
        wait_for_message()
        clown:head_look_at(manny)
        clown:say_line("/fecl002/")
        wait_for_message()
        clown:head_look_at(clown.groundPoint)
        clown:say_line("/fecl003/")
    end
end
cl1.outro = function(arg1) -- line 29
    if not clown.idling then
        while find_script(clown.stop_idle) do
            break_here()
        end
        start_script(clown.idle, clown)
    end
end
cl1[50] = { text = "/fema004/", first_clown_node = TRUE, gesture = manny.shrug_gesture }
cl1[50].response = function(arg1) -- line 40
    arg1.off = TRUE
    cl1[60].off = FALSE
    clown:say_line("/fecl005/")
end
cl1[60] = { text = "/fema006/", first_clown_node = TRUE, gesture = manny.tilt_head_gesture }
cl1[60].off = TRUE
cl1[60].response = function(arg1) -- line 48
    arg1.off = TRUE
    cl1[63].off = FALSE
    start_script(clown.stop_idle, clown, TRUE)
    clown:say_line("/fecl007/")
    wait_for_script(clown.stop_idle)
    clown:stop_chore(balloonman_stand, "balloonman.cos")
    clown:push_costume("balloon_loop.cos")
    clown:play_chore(balloon_loop_twist_this, "balloon_loop.cos")
    clown:wait_for_chore(balloon_loop_twist_this)
    clown:pop_costume()
    clown:play_chore_looping(balloonman_stand, "balloonman.cos")
    start_script(clown.idle, clown)
end
cl1[63] = { text = "/fema008/", first_clown_node = TRUE, gesture = manny.point_gesture }
cl1[63].off = TRUE
cl1[63].response = function(arg1) -- line 65
    arg1.off = TRUE
    cl1[64].off = FALSE
    cl1.node = "twist_node"
    cl1:reset_twist_node()
    start_script(clown.stop_idle, clown, TRUE)
    clown:head_look_at(manny)
    clown:say_line("/fecl009/")
    clown:wait_for_message()
    clown:say_line("/fecl010/")
    wait_for_message()
    clown:say_line("/fecl012/")
    clown:play_chore(balloonman_point, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_point_loop, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_point_loop, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_back_to_idle, "balloonman.cos")
    clown:wait_for_chore()
    wait_for_message()
    wait_for_script(clown.stop_idle)
    clown:wait_for_chore(balloonman_back_to_idle)
    clown:stop_chore(balloonman_back_to_idle)
end
cl1[64] = { text = "/fema013/", first_clown_node = TRUE, gesture = manny.tilt_head_gesture }
cl1[64].off = TRUE
cl1[64].response = function(arg1) -- line 96
    cl1.node = "twist_node"
    cl1:reset_twist_node()
    clown:head_look_at(manny)
    clown:say_line("/fecl014/")
    start_script(clown.stop_idle, clown)
end
cl1[70] = { text = "/fema015/", first_clown_node = TRUE, gesture = manny.hand_gesture }
cl1[70].response = function(arg1) -- line 106
    arg1.off = TRUE
    clown:say_line("/fecl016/")
end
cl1[80] = { text = "/fema017/", first_clown_node = TRUE }
cl1[80].response = function(arg1) -- line 112
    arg1.off = TRUE
    clown:say_line("/fecl018/")
    wait_for_message()
    clown:say_line("/fecl019/")
    if not clown.is_standing then
        start_script(clown.stop_idle, clown)
    end
    wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/fema020/")
    wait_for_message()
    wait_for_script(clown.stop_idle)
    clown:say_line("/fecl021/")
    clown:play_chore(balloonman_point, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_point_loop, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_point_loop, "balloonman.cos")
    clown:wait_for_chore()
    clown:play_chore(balloonman_back_to_idle, "balloonman.cos")
    clown:wait_for_chore()
    clown:wait_for_message()
    clown:wait_for_chore(balloonman_back_to_idle)
    clown:stop_chore(balloonman_back_to_idle)
    start_script(clown.idle, clown)
end
cl1[90] = { text = "/fema022/", first_clown_node = TRUE, gesture = manny.hand_gesture }
cl1[90].response = function(arg1) -- line 141
    arg1.off = TRUE
    clown:say_line("/fecl023/")
    local local1 = start_script(clown.stop_idle, clown)
    wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/fema024/")
    wait_for_message()
    clown:say_line("/fecl025/")
    wait_for_script(local1)
    start_script(clown.idle, clown)
end
cl1[95] = { text = "/fema026/", first_clown_node = TRUE }
cl1[95].response = function(arg1) -- line 155
    arg1.off = TRUE
    fe.pop_trigger = TRUE
    clown:play_sound_at("bloonpop.wav")
    stop_script(clown.idle)
    if GetActorCostumeDepth(clown.hActor) > 1 then
        clown:pop_costume()
        clown:stop_chore(0)
        clown.idling = FALSE
    end
    clown:play_chore(balloonman_pop_balloon, "balloonman.cos")
    clown:head_look_at(manny)
    clown:say_line("/fecl027/")
    wait_for_message()
    clown:say_line("/fecl028/")
    clown:wait_for_message()
    start_script(clown.idle, clown)
end
cl1.exit_lines.first_clown_node = { text = "/fema029/", gesture = manny.twist_head_gesture }
cl1.exit_lines.first_clown_node.response = function(arg1) -- line 177
    cl1.node = "exit_dialog"
    clown:say_line("/fecl030/")
end
cl1.reset_twist_node = function(arg1) -- line 182
    cl1[100].off = FALSE
    cl1[102].off = FALSE
    if not DEMO then
        cl1[104].off = FALSE
    end
    cl1[100].off = FALSE
end
cl1[100] = { text = "/fema031/", twist_node = TRUE, gesture = manny.tilt_head_gesture }
cl1[100].response = function(arg1) -- line 190
    cl1[100].text = "/fema032/"
    if clown:check_balloon("cat") then
        cl1.node = "exit_dialog"
        clown:say_line("/fecl034/")
        wait_for_message()
        clown:twist_balloon("cat")
    else
        arg1.off = TRUE
    end
end
cl1[102] = { text = "/fema036/", twist_node = TRUE, gesture = manny.head_forward_gesture }
cl1[102].response = function(arg1) -- line 205
    cl1[102].text = "/fema037/"
    if clown:check_balloon("dingo") then
        cl1.node = "exit_dialog"
        clown:say_line("/fecl039/")
        wait_for_message()
        clown:twist_balloon("dingo")
    else
        arg1.off = TRUE
    end
end
cl1[104] = { text = "/fema041/", twist_node = TRUE }
cl1[104].response = function(arg1) -- line 218
    cl1.node = "exit_dialog"
    if reaped_meche then
        arg1.off = TRUE
        clown:say_line("/fecl042/")
        wait_for_message()
        clown:say_line("/fecl043/")
    else
        cl1[104].text = "/fema044/"
        clown:twist_balloon("worm")
    end
end
cl1[106] = { text = "/fema046/", twist_node = TRUE }
cl1[106].response = function(arg1) -- line 232
    cl1[106].text = "/fema047/"
    if clown:check_balloon("frost") then
        cl1.node = "exit_dialog"
        clown:say_line("/fecl049/")
        wait_for_message()
        clown:twist_balloon("frost")
    else
        arg1.off = TRUE
    end
end
cl1.aborts.twist_node = function(arg1) -- line 244
    cl1.node = "first_clown_node"
    if cl1.current_choices[1] then
        cl1:execute_line(cl1.current_choices[1])
    else
        cl1:clear()
    end
end
cl1[999] = "EOD"

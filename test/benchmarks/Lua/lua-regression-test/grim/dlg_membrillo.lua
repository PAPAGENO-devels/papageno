CheckFirstTime("dlg_membrillo.lua")
mb1 = Dialog:create()
mb1.intro = function(arg1) -- line 12
    mb1.node = "first_membrillo_node"
    wait_for_message()
    start_script(mg.membrillo_stop_at_corpse_2, mg)
    if not mb1.talked then
        mb1.talked = TRUE
        manny:twist_head_gesture(TRUE)
        manny:hand_gesture(TRUE)
        manny:say_line("/mgma001/")
        manny:wait_for_message()
        membrillo:say_line("/mgme003/")
    end
    wait_for_script(mg.membrillo_stop_at_corpse_2)
end
mb1[100] = { text = "/mgma004/", first_membrillo_node = TRUE }
mb1[100].response = function(arg1) -- line 29
    arg1.off = TRUE
    membrillo:say_line("/mgme005/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme006/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme007/")
end
mb1[110] = { text = "/mgma008/", first_membrillo_node = TRUE, gesture = manny.head_forward_gesture }
mb1[110].response = function(arg1) -- line 39
    arg1.off = TRUE
    mb1[140].off = FALSE
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
    end
    membrillo:say_line("/mgme009/")
    if not membrillo.detecting then
        membrillo:run_chore(membrillo_rest_to_work, "membrillo.cos")
    end
    membrillo:wait_for_message()
    membrillo:say_line("/mgme010/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_rest_to_work, "membrillo.cos")
        membrillo:play_chore(membrillo_work_start_to_end, "membrillo.cos")
    end
    membrillo:wait_for_message()
    membrillo:say_line("/mgme011/")
    membrillo:wait_for_message()
    if membrillo.detecting then
        membrillo:say_line("/mgme012/")
    else
        membrillo:wait_for_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:say_line("/mgme013/")
        membrillo:run_chore(membrillo_wk_to_lk_tool, "membrillo.cos")
        membrillo:wait_for_message()
        membrillo:stop_chore(membrillo_wk_to_lk_tool, "membrillo.cos")
        membrillo:run_chore(membrillo_lktl_to_rest, "membrillo.cos")
        membrillo:stop_chore(membrillo_lktl_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    end
end
mb1[120] = { text = "/mgma014/", first_membrillo_node = TRUE, gesture = manny.shrug_gesture }
mb1[120].response = function(arg1) -- line 77
    local local1, local2, local3
    arg1.off = TRUE
    mb1[130].off = FALSE
    membrillo:say_line("/mgme015/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_work, "membrillo.cos")
        membrillo:stop_chore(membrillo_rest_to_work, "membrillo.cos")
        membrillo:play_chore(membrillo_work_start_to_end, "membrillo.cos")
    end
    membrillo:wait_for_message()
    manny:head_forward_gesture()
    sleep_for(1000)
    local1, local2, local3 = GetActorNodeLocation(membrillo.hActor, 20)
    manny:head_look_at_point(local1, local2, local3)
    sleep_for(1000)
    if not membrillo.detecting then
        membrillo:wait_for_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:run_chore(membrillo_wkend_to_rest, "membrillo.cos")
    end
    membrillo:say_line("/mgme016/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_wkend_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    end
    membrillo:wait_for_message()
    manny:head_look_at(mg.membrillo_obj)
    manny:twist_head_gesture()
    manny:say_line("/mgma017/")
    manny:wait_for_message()
    membrillo:say_line("/mgme018/")
end
mb1[130] = { text = "/mgma019/", first_membrillo_node = TRUE }
mb1[130].off = TRUE
mb1[130].response = function(arg1) -- line 117
    arg1.off = TRUE
    membrillo:say_line("/mgme020/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme021/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme022/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
    end
    membrillo:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/mgma023/")
    manny:wait_for_message()
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lkma_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
    end
    membrillo:say_line("/mgme024/")
    if not membrillo.detecting then
        membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    end
end
mb1[140] = { text = "/mgma025/", first_membrillo_node = TRUE }
mb1[140].off = TRUE
mb1[140].response = function(arg1) -- line 145
    arg1.off = TRUE
    membrillo:say_line("/mgme026/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme027/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
        membrillo:stop_chore(membrillo_lkma_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_work, "membrillo.cos")
    end
    membrillo:wait_for_message()
    membrillo:say_line("/mgme028/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_rest_to_work, "membrillo.cos")
        membrillo:run_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:run_chore(membrillo_wkend_to_rest, "membrillo.cos")
    end
    membrillo:wait_for_message()
    membrillo:say_line("/mgme029/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_wkend_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    end
    membrillo:wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/mgma030/")
    manny:wait_for_message()
    manny:say_line("/mgma031/")
end
mb1[150] = { text = "/mgma032/", first_membrillo_node = TRUE, gesture = manny.hand_gesture }
mb1[150].response = function(arg1) -- line 181
    arg1.off = TRUE
    mb1[160].off = FALSE
    manny:shrug_gesture()
    manny:say_line("/mgma033/")
    manny:wait_for_message()
    membrillo:say_line("/mgme034/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme035/")
end
mb1[160] = { text = "/mgma036/", first_membrillo_node = TRUE, gesture = manny.head_forward_gesture }
mb1[160].off = TRUE
mb1[160].response = function(arg1) -- line 194
    arg1.off = TRUE
    membrillo:say_line("/mgme037/")
    if not membrillo.detecting then
        membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
        membrillo:run_chore(membrillo_rest_to_work, "membrillo.cos")
        membrillo:play_chore(membrillo_work_start_to_end, "membrillo.cos")
    end
    membrillo:wait_for_message()
    manny:hand_gesture(TRUE)
    manny:tilt_head_gesture(TRUE)
    manny:say_line("/mgma038/")
    manny:wait_for_message()
    membrillo:say_line("/mgme039/")
    if not membrillo.detecting then
        membrillo:wait_for_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
        membrillo:run_chore(membrillo_wkend_to_rest, "membrillo.cos")
        membrillo:stop_chore(membrillo_wkend_to_rest, "membrillo.cos")
    end
    membrillo:wait_for_message()
    membrillo:say_line("/mgme040/")
    if not membrillo.detecting then
        membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
        membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    end
end
mb1.exit_lines.first_membrillo_node = { text = "/mgma041/" }
mb1.exit_lines.first_membrillo_node.response = function(arg1) -- line 225
    mb1.node = "exit_dialog"
    if find_script(mg.membrillo_face_manny) then
        wait_for_script(mg.membrillo_face_manny)
    end
    membrillo.facing_manny = TRUE
    start_script(mg.membrillo_stop_face_manny, mg)
    membrillo:say_line("/mgme042/")
    membrillo.stop_walking = FALSE
end
mb1.aborts.first_membrillo_node = function(arg1) -- line 236
    mb1:clear()
    mb1:execute_line(mb1.exit_lines.first_membrillo_node)
end

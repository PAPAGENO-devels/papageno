CheckFirstTime("dlg_bomb.lua")
bo1 = Dialog:create()
bo1.intro = function(arg1) -- line 11
    bo1.node = "bomb_node"
    enable_head_control(FALSE)
    manny:head_look_at(sl.carla_obj)
    if not bo1.tried then
        bo1.tried = TRUE
        carla:say_line("/slca001/")
    else
        carla:say_line("/slca002/")
    end
end
bo1[100] = { text = "/slma003/", bomb_node = TRUE }
bo1[100].response = function(arg1) -- line 24
    arg1.off = TRUE
    bo1.node = "exit_dialog"
    if sl.carla_scorned then
        bo1:make_nice()
    else
        carla:say_line("/slca004/")
    end
end
bo1.make_nice = function(arg1) -- line 34
    carla:say_line("/slca005/")
end
bo1[110] = { text = "/slma006/", bomb_node = TRUE }
bo1[110].response = function(arg1) -- line 40
    arg1.off = TRUE
    bo1.node = "exit_dialog"
    carla:say_line("/slca007/")
    wait_for_message()
    manny:say_line("/slma008/")
    wait_for_message()
    carla:say_line("/slca009/")
end
bo1[120] = { text = "/slma010/", bomb_node = TRUE }
bo1[120].response = function(arg1) -- line 51
    arg1.off = TRUE
    bo1.node = "exit_dialog"
    if sl.carla_scorned then
        bo1:make_nice()
    else
        carla:say_line("/slca011/")
        wait_for_message()
        carla:say_line("/slca012/")
        wait_for_message()
        carla:say_line("/slca013/")
    end
end
bo1[300] = { text = "/slma014/", bomb_node = TRUE }
bo1[300].response = function(arg1) -- line 66
    arg1.off = TRUE
    bo1.node = "unattended"
    carla:say_line("/slca015/")
end
bo1[400] = { text = "/slma016/", unattended = TRUE, gesture = manny.nod_head_gesture }
bo1[400].response = function(arg1) -- line 73
    local local1
    bo1.node = "exit_dialog"
    arg1.off = TRUE
    stop_script(sl.carla_idle)
    start_script(carla.stand_up, carla)
    wait_for_message()
    carla:say_line("/slca017/")
    carla:wait_for_message()
    local1 = 0
    while not carla:is_choring(carla_stand, TRUE, sl.search_cos) and local1 < 1800 do
        break_here()
        local1 = local1 + system.frameTime
    end
    MakeSectorActive("carlawalk1", TRUE)
    carla:follow_boxes()
    carla:say_line("/slca018/")
    carla:set_walk_rate(0.2)
    Actor.walkto(carla, 0.83329999, -0.77146, 0, 0, 101.0174, 0)
    wait_for_script(carla.stand_up)
    carla:wait_for_message()
    carla:say_line("/slca019/")
    carla:wait_for_actor()
    carla:play_chore(carla_stand_hold, sl.search_chore)
    carla:wait_for_message()
    enable_head_control(TRUE)
    start_script(sl.blow_up_case)
end
bo1[410] = { text = "/slma020/", unattended = TRUE, gesture = manny.twist_head_gesture }
bo1[410].response = bo1[400].response
bo1.aborts.bomb_node = function(arg1) -- line 108
    bo1:clear()
    bo1:execute_line(bo1[300])
    enable_head_control(TRUE)
end

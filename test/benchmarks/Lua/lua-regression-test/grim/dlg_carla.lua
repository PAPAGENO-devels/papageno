CheckFirstTime("dlg_carla.lua")
ca1 = Dialog:create()
ca1.focus = sl.carla_obj
ca1.intro = function(arg1, arg2) -- line 13
    if arg2 == "detector" then
        ca1:execute_line(ca1[40])
    else
        ca1.node = "first_carla_node"
    end
    stop_script(sl.carla_idle)
    manny:wait_for_actor()
    sl:current_setup(sl_diams)
    manny:push_costume("ma_charmer.cos")
    manny:play_chore(ma_charmer_start_charm, "ma_charmer.cos")
    start_script(carla.go_to_prop, carla)
    manny:wait_for_chore(ma_charmer_start_charm, "ma_charmer.cos")
    manny:stop_chore(ma_charmer_start_charm, "ma_charmer.cos")
    manny:play_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
    manny:wait_for_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
    if sl.bomb_detonated and not ca1.talked_bomb then
        ca1.talked_bomb = TRUE
        manny:say_line("/slma139/")
        manny:wait_for_message()
        carla:say_line("/slca140/")
    end
end
ca1[20] = { text = "/slma141/", first_carla_node = TRUE }
ca1[20].response = function(arg1) -- line 41
    arg1.off = TRUE
    carla:say_line("/slca142/")
    carla:wait_for_message()
    start_script(carla.prop_tilt_head, carla)
    carla:say_line("/slca143/")
    carla:wait_for_message()
    start_script(carla.prop_end_tilt_head, carla)
    carla:say_line("/slca144/")
end
ca1[30] = { text = "/slma145/", first_carla_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[30].response = function(arg1) -- line 53
    arg1.off = TRUE
    carla:say_line("/slca146/")
    carla:wait_for_message()
    carla:say_line("/slca147/")
end
ca1[40] = { text = "/slma148/", first_carla_node = TRUE, gesture = manny.charm_point_gesture }
ca1[40].response = function(arg1) -- line 61
    sl.talked_detectors = TRUE
    arg1.off = TRUE
    ca1.node = "detector_node"
    carla:say_line("/slca149/")
end
ca1[50] = { text = "/slma150/", detector_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[51] = { text = "/slma151/", detector_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[52] = { text = "/slma152/", detector_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[53] = { text = "/slma153/", detector_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[50].response = function(arg1) -- line 73
    ca1.node = "first_carla_node"
    ca1[60].off = FALSE
    ca1[100].off = FALSE
    carla:say_line("/slca154/")
end
ca1[51].response = ca1[50].response
ca1[52].response = ca1[50].response
ca1[53].response = ca1[50].response
ca1[60] = { text = "/slma155/", first_carla_node = TRUE, gesture = manny.charm_point_gesture }
ca1[60].off = TRUE
ca1[60].response = function(arg1) -- line 85
    arg1.off = TRUE
    wait_for_message()
    carla:say_line("/slca156/")
    carla:wait_for_message()
    manny:say_line("/slma157/")
    manny:wait_for_message()
    start_script(carla.go_to_sit, carla)
    carla:say_line("/slca158/")
    carla:wait_for_message()
    carla:say_line("/slca159/")
end
ca1[100] = { text = "/slma160/", first_carla_node = TRUE }
ca1[100].off = TRUE
ca1[100].response = function(arg1) -- line 100
    arg1.off = TRUE
    ca1[110].off = FALSE
    manny:say_line("/slma161/")
    manny:wait_for_message()
    manny:charm_nod_gesture()
    manny:say_line("/slma162/")
    manny:wait_for_message()
    start_script(carla.go_to_sit, carla)
    carla:say_line("/slca163/")
end
ca1[110] = { text = "/slma164/", first_carla_node = TRUE }
ca1[110].off = TRUE
ca1[110].response = function(arg1) -- line 114
    arg1.off = TRUE
    ca1[120].off = FALSE
    carla:say_line("/slca165/")
end
ca1[120] = { text = "/slma166/", first_carla_node = TRUE, gesture = manny.charm_nod_gesture }
ca1[120].off = TRUE
ca1[120].response = function(arg1) -- line 122
    arg1.off = TRUE
    ca1.node = "exit_dialog"
    start_script(carla.go_to_prop, carla)
    carla:say_line("/slca167/")
    carla:wait_for_message()
    carla:say_line("/slca168/")
    carla:wait_for_message()
    carla:head_look_at(nil)
    carla:say_line("/slca169/")
    manny:head_look_at(sl.they1)
    sleep_for(500)
    manny:head_look_at(sl.they2)
    sleep_for(500)
    wait_for_message()
    manny:play_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:wait_for_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:head_look_at(sl.gate)
    sleep_for(1000)
    manny:default("cafe")
    manny:head_look_at(nil)
    sl:current_setup(sl_intha)
    manny:shrug_gesture()
    manny:say_line("/slma170/")
    manny:wait_for_message()
    manny:walkto(0.154136, -0.296585, 0)
    manny:wait_for_actor()
end
ca1[130] = { text = "/slma171/", first_carla_node = TRUE, gesture = manny.charm_point_gesture }
ca1[130].response = function(arg1) -- line 152
    arg1.off = TRUE
    start_script(carla.go_to_prop, carla)
    carla:say_line("/slca172/")
    carla:wait_for_message()
    carla:say_line("/slca173/")
    carla:wait_for_message()
    manny:say_line("/slma174/")
end
ca1.exit_lines.first_carla_node = { text = "/slma175/" }
ca1.exit_lines.first_carla_node.response = function(arg1) -- line 163
    ca1.node = "exit_dialog"
    carla:say_line("/slca176/")
end
ca1.aborts.first_carla_node = function(arg1) -- line 168
    ca1:clear()
    ca1.node = "exit_dialog"
    manny:say_line("/slma177/")
    manny:wait_for_message()
    start_script(carla.go_to_prop)
    carla:say_line("/slca178/")
    carla:wait_for_message()
    manny:stop_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
    manny:play_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:wait_for_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:pop_costume()
    manny:default("cafe")
    manny:head_look_at(nil)
    carla:say_line("/slca179/")
    sl:current_setup(sl_intha)
    single_start_script(sl.carla_idle)
end
ca1.outro = function(arg1) -- line 187
    manny:stop_chore(ma_charmer_hand_to_chin2, "ma_charmer.cos")
    manny:play_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:wait_for_chore(ma_charmer_back_to_idle, "ma_charmer.cos")
    manny:default("cafe")
    manny:head_look_at(nil)
    sl:current_setup(sl_intha)
    single_start_script(sl.carla_idle)
end
ca1[999] = "EOD"

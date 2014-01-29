CheckFirstTime("dlg_celso2.lua")
ce2 = Dialog:create()
ce2.intro = function(arg1) -- line 11
    ce2.node = "n1"
    if not ce2.introduced then
        ce2.introduced = TRUE
        manny:head_forward_gesture()
        manny:say_line("/hfma031/")
        manny:wait_for_message()
        start_script(hf.flores_stop_idles, hf)
        manny:say_line("/hfma032/")
        manny:wait_for_message()
        celso:say_line("/hfce033/")
        celso:wait_for_message()
        celso:play_chore(the_floreses_to_susp)
        celso:say_line("/hfce034/")
        celso:wait_for_chore(the_floreses_to_susp)
        celso:run_chore(the_floreses_susp_cyc)
        celso:run_chore(the_floreses_susp_2dflt)
    else
        manny:tilt_head_gesture()
        manny:say_line("/hfma035/")
        manny:wait_for_message()
        hf:flores_stop_idles()
        celso:play_chore(the_floreses_to_shrug)
        celso:say_line("/hfce036/")
        celso:wait_for_chore(the_floreses_to_shrug)
        celso:run_chore(the_floreses_shg_2dflt)
        celso:play_chore(the_floreses_default)
    end
end
ce2[100] = { text = "/hfma037/", n1 = TRUE }
ce2[100].response = function(arg1) -- line 44
    arg1.off = TRUE
    celso:play_chore(the_floreses_to_explain)
    celso:say_line("/hfce038/")
    celso:wait_for_chore(the_floreses_to_explain)
    celso:wait_for_message()
    celso:play_chore(the_floreses_exp2dflt)
    celso:say_line("/hfce039/")
    celso:wait_for_chore(the_floreses_exp2dflt)
    celso:play_chore(the_floreses_default)
end
ce2[110] = { text = "/hfma040/", n1 = TRUE }
ce2[110].response = function(arg1) -- line 57
    arg1.off = TRUE
    ce2[120].off = FALSE
    ce2.node = "pitch"
    celso:play_chore(the_floreses_let_me)
    sleep_for(200)
    celso:say_line("/hfce041/")
    celso:wait_for_chore(the_floreses_let_me)
    celso:play_chore(the_floreses_default)
    wait_for_message()
    celso:say_line("/hfce042/")
    celso:wait_for_message()
    celso:say_line("/hfce043/")
end
ce2[120] = { text = "/hfma044/", n1 = TRUE, gesture = manny.tilt_head_gesture }
ce2[120].off = TRUE
ce2[120].response = function(arg1) -- line 74
    ce2.node = "pitch"
    celso:say_line("/hfce045/")
end
ce2[130] = { text = "/hfma046/", pitch = TRUE, gesture = manny.head_forward_gesture }
ce2[130].response = function(arg1) -- line 80
    arg1.off = TRUE
    celso:play_chore(the_floreses_to_susp)
    celso:say_line("/hfce047/")
    celso:wait_for_chore(the_floreses_to_susp)
    celso:play_chore_looping(the_floreses_susp_cyc)
    celso:wait_for_message()
    celso:say_line("/hfce048/")
    celso:set_chore_looping(the_floreses_susp_cyc, FALSE)
    celso:wait_for_chore(the_floreses_susp_cyc)
    celso:play_chore(the_floreses_susp_2dflt)
    celso:wait_for_chore(the_floreses_susp_2dflt)
end
ce2[140] = { text = "/hfma049/", pitch = TRUE, gesture = manny.hand_gesture }
ce2[140].response = function(arg1) -- line 95
    arg1.off = TRUE
    celso:play_chore(the_floreses_to_cs_shake)
    celso:say_line("/hfce050/")
    celso:wait_for_chore(the_floreses_to_cs_shake)
    celso:run_chore(the_floreses_cs_shake)
    celso:run_chore(the_floreses_shk_2dflt)
    celso:play_chore(the_floreses_default)
end
ce2[150] = { text = "/hfma051/", pitch = TRUE, gesture = manny.point_gesture }
ce2[150].response = function(arg1) -- line 106
    arg1.off = TRUE
    celso:say_line("/hfce052/")
end
ce2[160] = { text = "/hfma053/", pitch = TRUE, gesture = manny.shrug_gesture }
ce2[160].response = function(arg1) -- line 112
    arg1.off = TRUE
    manny:say_line("/hfma054/")
    manny:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/hfma055/")
    wait_for_message()
    celso:play_chore(the_floreses_to_shrug)
    celso:say_line("/hfce056/")
    celso:wait_for_chore(the_floreses_to_shrug)
    celso:run_chore(the_floreses_shg_2dflt)
    celso:play_chore(the_floreses_default)
end
ce2[170] = { text = "/hfma057/", pitch = TRUE, gesture = manny.hand_gesture }
ce2[170].response = function(arg1) -- line 127
    ce2.node = "problems"
    celso:run_chore(the_floreses_to_whsper)
    celso:play_chore(the_floreses_to_cstalk)
    celso:say_line("/hfce058/")
    celso:wait_for_chore(the_floreses_to_cstalk)
    celso:run_chore(the_floreses_cstalk1_cyc)
    celso:run_chore(the_floreses_cstalk2_cyc)
    celso:run_chore(the_floreses_cstalk2_2whspr)
    celso:run_chore(the_floreses_whspr_2dflt)
end
ce2[180] = { text = "/hfma059/", problems = TRUE }
ce2[180].response = function(arg1) -- line 140
    arg1.off = TRUE
    celso:say_line("/hfce060/")
end
ce2[190] = { text = "/hfma061/", problems = TRUE }
ce2[190].response = function(arg1) -- line 146
    arg1.off = TRUE
    celso:say_line("/hfce062/")
end
ce2[200] = { text = "/hfma063/", problems = TRUE }
ce2[200].response = function(arg1) -- line 152
    arg1.off = TRUE
    ce2.node = "exit_dialog"
    ce2.solved = TRUE
    celso:play_chore(the_floreses_to_explain)
    celso:say_line("/hfce064/")
    celso:wait_for_chore(the_floreses_to_explain)
    celso:run_chore(the_floreses_exp2dflt)
    celso:play_chore(the_floreses_default)
    wait_for_message()
    manny:hand_gesture()
    manny:say_line("/hfma065/")
    wait_for_message()
    music_state:set_sequence(seqYr4Iris)
    IrisDown(320, 250, 2000)
    manny:say_line("/hfma066/")
    wait_for_message()
    IrisUp(320, 250, 2000)
    sleep_for(1000)
    celso:say_line("/hfce067/")
    wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/hfma068/")
    wait_for_message()
end
ce2[210] = { text = "/hfma071/", problems = TRUE, gesture = manny.twist_head_gesture }
ce2[210].response = function(arg1) -- line 181
    ce2.node = "n1"
    ce2[225].off = FALSE
    celso:say_line("/hfce072/")
end
ce2[220] = { text = "/hfma073/", n1 = TRUE, gesture = manny.hand_gesture }
ce2[220].response = function(arg1) -- line 188
    arg1.off = TRUE
    celso:say_line("/hfce074/")
    wait_for_message()
    celso:play_chore(the_floreses_lovey)
    celso:say_line("/hfce075/")
    celso:wait_for_message()
    celso:run_chore(the_floreses_lov_2dflt)
end
ce2[225] = { text = "/hfma076/", n1 = TRUE, gesture = manny.tilt_head_gesture }
ce2[225].off = TRUE
ce2[225].response = function(arg1) -- line 200
    ce2.node = "problems"
    celso:play_chore(the_floreses_to_explain)
    celso:play_chore(the_floreses_mf_shake)
    celso:say_line("/hfce077/")
    celso:wait_for_chore(the_floreses_mf_shake)
    celso:wait_for_chore(the_floreses_to_explain)
    celso:play_chore(the_floreses_exp2dflt)
    celso:wait_for_chore()
end
ce2.exit_lines.n1 = { text = "/hfma078/" }
ce2.exit_lines.n1.response = function(arg1) -- line 213
    ce2.node = "exit_dialog"
    celso:say_line("/hfce079/")
end
ce2.exit_lines.pitch = ce2.exit_lines.n1
ce2.outro = function(arg1) -- line 220
    if ce2.solved then
        start_script(hf.celso_buy_ticket)
    else
        start_script(hf.flores_idles, hf)
    end
end

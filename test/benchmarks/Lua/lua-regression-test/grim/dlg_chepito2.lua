CheckFirstTime("dlg_chepito2.lua")
cp2 = Dialog:create()
cp2.intro = function(arg1) -- line 11
    stop_script(chepito.talk_randomly_from_weighted_table)
    stop_script(mn.chepito_hums)
    manny:head_forward_gesture()
    manny:say_line("/mnma001/")
    sleep_for(500)
    start_script(mn.chepito_stop_idle, mn)
    if chepito.happy then
        cp2[120].off = TRUE
        cp2[130].off = FALSE
        cp2[280].off = TRUE
        chepito:say_line("/mnch002/", { background = TRUE })
        chepito:wait_for_message()
        chepito:say_line("/mnch003/")
        mn:chepito_face_manny()
        if not cp2.met then
            cp2.met = TRUE
            chepito:say_line("/mnch005/")
            chepito:wait_for_message()
            chepito:say_line("/mnch006/")
            chepito:wait_for_message()
            chepito:say_line("/mnch007/")
        end
    else
        manny:wait_for_message()
        chepito:say_line("/mnch004/")
        chepito:wait_for_message()
        mn:chepito_face_manny()
        if not cp2.met then
            cp2.met = TRUE
            chepito:say_line("/mnch005/")
            chepito:wait_for_message()
            chepito:say_line("/mnch006/")
            chepito:wait_for_message()
            chepito:say_line("/mnch007/")
        else
            chepito:say_line("/mnch008/")
        end
    end
end
cp2[100] = { text = "/mnma009/", n1 = TRUE, gesture = manny.shrug_gesture }
cp2[100].setup = function(arg1) -- line 57
    arg1.off = TRUE
end
cp2[100].response = function(arg1) -- line 60
    arg1.off = TRUE
    chepito:say_line("/mnch010/")
end
cp2[110] = { text = "/mnma011/", n1 = TRUE, gesture = manny.hand_gesture }
cp2[110].response = function(arg1) -- line 66
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch012/")
    chepito:wait_for_message()
    start_script(mn.chepito_stop_face_manny, mn, TRUE)
    chepito:say_line("/mnch013/")
    chepito:wait_for_message()
    chepito:say_line("/mnch014/")
    chepito:wait_for_message()
    chepito:say_line("/mnch015/")
end
cp2[120] = { text = "/mnma016/", n1 = TRUE, gesture = manny.point_gesture }
cp2[120].response = function(arg1) -- line 80
    arg1.off = TRUE
    cp2[130].off = FALSE
    mn:chepito_face_manny()
    chepito:say_line("/mnch017/")
    chepito:wait_for_message()
    chepito:say_line("/mnch018/")
    chepito:wait_for_message()
    chepito:say_line("/mnch019/")
    chepito:wait_for_message()
    chepito:say_line("/mnch020/")
    chepito:wait_for_message()
    chepito:say_line("/mnch021/")
end
cp2[130] = { text = "/mnma022/", n1 = TRUE, gesture = manny.tilt_head_gesture }
cp2[130].off = TRUE
cp2[130].response = function(arg1) -- line 102
    arg1.off = TRUE
    cp2[140].off = FALSE
    cp2[160].off = FALSE
    mn:chepito_face_manny()
    chepito:say_line("/mnch023/")
    chepito:wait_for_message()
    chepito:say_line("/mnch024/")
    chepito:wait_for_message()
    chepito:say_line("/mnch025/")
end
cp2[140] = { text = "/mnma026/", n1 = TRUE, gesture = manny.head_forward_gesture }
cp2[140].off = TRUE
cp2[140].response = function(arg1) -- line 116
    arg1.off = TRUE
    cp2[150].off = FALSE
    mn:chepito_face_manny()
    chepito:say_line("/mnch027/")
    chepito:wait_for_message()
    chepito:say_line("/mnch028/")
    chepito:wait_for_message()
    chepito:say_line("/mnch029/")
end
cp2[150] = { text = "/mnma030/", n1 = TRUE, gesture = manny.hand_gesture }
cp2[150].off = TRUE
cp2[150].response = function(arg1) -- line 129
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch031/")
    chepito:wait_for_message()
    manny:say_line("/mnma032/")
    manny:wait_for_message()
    chepito:say_line("/mnch033/")
end
cp2[160] = { text = "/mnma034/", n1 = TRUE }
cp2[160].off = TRUE
cp2[160].response = function(arg1) -- line 141
    arg1.off = TRUE
    cp2.node = "desire"
    mn:chepito_face_manny()
    chepito:say_line("/mnch035/")
    chepito:wait_for_message()
    chepito:say_line("/mnch036/")
end
cp2[170] = { text = "/mnma037/", desire = TRUE }
cp2[170].response = function(arg1) -- line 151
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch038/")
    chepito:wait_for_message()
    chepito:say_line("/mnch039/")
end
cp2[180] = { text = "/mnma040/", desire = TRUE }
cp2[180].response = function(arg1) -- line 160
    arg1.off = TRUE
    chepito.talked_gun = TRUE
    cp2.node = "trade"
    mn:chepito_face_manny()
    chepito:say_line("/mnch041/")
    chepito:wait_for_message()
    chepito:say_line("/mnch042/")
end
cp2[190] = { text = "/mnma043/", trade = TRUE }
cp2[190].response = function(arg1) -- line 171
    arg1.off = TRUE
    cp2.node = "exit_dialog"
    mn:chepito_face_manny()
    chepito:say_line("/mnch044/")
    chepito:wait_for_message()
    manny:say_line("/mnma045/")
    cp2:come_again()
end
cp2[200] = { text = "/mnma046/", trade = TRUE }
cp2[200].response = function(arg1) -- line 182
    arg1.off = TRUE
    cp2.node = "exit_dialog"
    mn:chepito_face_manny()
    chepito:say_line("/mnch047/")
    chepito:wait_for_message()
    chepito:say_line("/mnch048/")
    chepito:wait_for_message()
    manny:say_line("/mnma049/")
    manny:wait_for_message()
    chepito:say_line("/mnch050/")
    chepito:wait_for_message()
    manny:say_line("/mnma051/")
    cp2:come_again()
end
cp2[210] = { text = "/mnma052/", trade = TRUE, gesture = manny.tilt_head_gesture }
cp2[210].response = function(arg1) -- line 199
    arg1.off = TRUE
    cp2.node = "exit_dialog"
    mn:chepito_face_manny()
    chepito:say_line("/mnch053/")
    chepito:wait_for_message()
    cp2:come_again()
end
cp2.come_again = function(arg1) -- line 209
    cp2.node = "exit_dialog"
    wait_for_message()
    mn:chepito_face_manny()
    chepito:say_line("/mnch055/")
    chepito:wait_for_message()
    chepito:say_line("/mnch056/")
    start_script(mn.chepito_stop_face_manny, mn)
end
cp2[220] = { text = "/mnma057/", desire = TRUE, gesture = manny.head_forward_gesture }
cp2[220].response = function(arg1) -- line 220
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch058/")
    chepito:wait_for_message()
    chepito:say_line("/mnch059/")
end
cp2[230] = { text = "/mnma060/", desire = TRUE }
cp2[230].response = function(arg1) -- line 229
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch061/")
    chepito:wait_for_message()
    chepito:say_line("/mnch062/")
end
cp2[240] = { text = "/mnma063/", desire = TRUE }
cp2[240].response = function(arg1) -- line 238
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch064/")
end
cp2[250] = { text = "/mnma065/", desire = TRUE, gesture = manny.shrug_gesture }
cp2[250].response = function(arg1) -- line 245
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch066/")
    chepito:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/mnma067/")
    manny:wait_for_message()
    chepito:say_line("/mnch068/")
    chepito:wait_for_message()
    chepito:say_line("/mnch069/")
    chepito:wait_for_message()
    chepito:say_line("/mnch070/")
    chepito:wait_for_message()
    chepito:say_line("/mnch071/")
end
cp2[260] = { text = "/mnma072/", desire = TRUE }
cp2[260].response = function(arg1) -- line 263
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch073/")
    chepito:wait_for_message()
    chepito:say_line("/mnch074/")
    chepito:wait_for_message()
    chepito:say_line("/mnch075/")
end
cp2[270] = { text = "/mnma076/", desire = TRUE }
cp2[270].response = function(arg1) -- line 274
    cp2.node = "n1"
    mn:chepito_face_manny()
    chepito:say_line("/mnch077/")
end
cp2.aborts.desire = function(arg1) -- line 282
    cp2.node = "n1"
    cp2:clear()
    mn:chepito_face_manny()
    manny:say_line("/mnma079/")
    manny:wait_for_message()
    chepito:say_line("/mnch080/")
    chepito:wait_for_message()
    manny:say_line("/mnma081/")
    manny:wait_for_message()
    chepito:say_line("/mnch082/")
end
cp2[280] = { text = "/mnma083/", n1 = TRUE }
cp2[280].response = function(arg1) -- line 297
    arg1.off = TRUE
    mn:chepito_face_manny()
    chepito:say_line("/mnch084/")
    chepito:wait_for_message()
    chepito:say_line("/mnch085/")
    chepito:play_chore(chepito_drill_mn2drill, "chepito_drill.cos")
    chepito:wait_for_chore(chepito_drill_mn2drill, "chepito_drill.cos")
    start_sfx("chisel_c.IMU", IM_MED_PRIORITY, chepito.chisel_volume)
    chepito:play_chore_looping(chepito_drill_drill, "chepito_drill.cos")
    chepito.facing_manny = FALSE
    chepito:wait_for_message()
    sleep_for(1000)
    manny:shrug_gesture()
    manny:say_line("/mnma086/")
end
cp2.exit_lines.n1 = { text = "/mnma087/" }
cp2.exit_lines.n1.response = function(arg1) -- line 315
    cp2.node = "exit_dialog"
    start_script(mn.chepito_stop_face_manny, mn)
    chepito:say_line("/mnch088/")
end
cp2.aborts.n1 = function(arg1) -- line 321
    cp2:clear()
    cp2.node = "exit_dialog"
    start_script(mn.chepito_stop_face_manny, mn)
    chepito:say_line("/mnch089/")
    wait_for_message()
    manny:hand_gesture()
    manny:say_line("/mnma090/")
    wait_for_message()
end
cp2.outro = function(arg1) -- line 332
    single_start_script(mn.chepito_stop_face_manny, mn)
end

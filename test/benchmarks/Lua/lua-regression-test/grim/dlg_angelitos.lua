CheckFirstTime("dlg_angelitos.lua")
an1 = Dialog:create()
an1.execute_line = function(arg1, arg2) -- line 10
    Dialog.execute_line(an1, arg2, bDontWait)
end
an1.intro = function(arg1) -- line 15
    an1.node = "n1"
    start_script(manny.walkto_object, manny, fo.pugsy_obj)
    if bibi.crying then
        an1[95].off = FALSE
    else
        an1[95].off = TRUE
    end
    if fo.fighting then
        stop_script(fo.fight)
        bibi:shut_up()
        pugsy:shut_up()
        arg1:force_line(75)
    else
        an1[75].off = TRUE
        if ar.talked_gun and not an1[80].said then
            an1.talked_out = FALSE
            an1[80].off = FALSE
        end
        if meche.locked_up and not an1[60].said then
            an1[60].off = FALSE
        end
        if pugsy.work_task then
            start_script(pugsy.kill_idle, pugsy)
        end
        if bibi.work_task then
            start_script(bibi.kill_idle, bibi)
        end
        if not an1.talked_out then
            manny:say_line("/foma001/")
            manny:wait_for_message()
            if not an1.met then
                an1.met = TRUE
                sleep_for(1000)
                wait_for_script(pugsy.kill_idle)
                pugsy:point_hammer()
                pugsy:say_line("/fopu002/")
                pugsy:wait_for_message()
                bibi:head_look_at(fo.pugsy_obj)
                wait_for_script(bibi.kill_idle)
                bibi:say_line("/fobi003/")
                bibi:wait_for_message()
                bibi:say_line("/fobi004/")
            else
                pugsy:say_line("/fopu005/")
            end
        else
            manny:say_line("/foma006/")
            manny:wait_for_message()
            bibi:head_look_at_manny()
            bibi:say_line("/fobi007/")
            bibi:wait_for_message()
            manny:say_line("/foma008/")
        end
        bibi:head_look_at_manny()
        manny:wait_for_message()
    end
end
an1[60] = { text = "/foma009/", n1 = TRUE, gesture = manny.hand_gesture }
an1[60].off = TRUE
an1[60].response = function(arg1) -- line 81
    arg1.off = TRUE
    arg1.said = TRUE
    bibi:play_chore(bibi_talk_idles_start_fear, "bibi_talk_idles.cos")
    bibi:say_line("/fobi010/")
    pugsy:say_line("/fopu011/")
    bibi:wait_for_chore(bibi_talk_idles_start_fear, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    bibi:stop_chore(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_end_fear, "bibi_talk_idles.cos")
    pugsy:start_crying()
    bibi:start_crying()
end
an1[75] = { text = "/foma012/", n1 = TRUE, gesture = manny.point_gesture }
an1[75].off = TRUE
an1[75].response = function(arg1) -- line 98
    arg1.off = TRUE
    fo.exit_fight()
    bibi:say_line("/fobi013/")
    pugsy:say_line("/fopu014/")
    pugsy:wait_for_message()
    bibi:head_look_at(pugsy)
    pugsy:head_look_at(bibi)
    bibi:say_line("/fobi015/")
    pugsy:say_line("/fopu016/")
    pugsy:wait_for_message()
    bibi:say_line("/fobi017/")
    pugsy:say_line("/fopu018/")
    pugsy:wait_for_message()
    bibi:head_look_at_manny()
    pugsy:head_look_at_manny()
    manny:say_line("/foma019/")
    manny:wait_for_message()
end
an1[80] = { text = "/foma020/", n1 = TRUE, gesture = manny.shrug_gesture }
an1[80].off = TRUE
an1[80].response = function(arg1) -- line 120
    arg1.off = TRUE
    arg1.said = TRUE
    an1.node = "exit_dialog"
    bibi:head_look_at(fo.pugsy_obj)
    pugsy:say_line("/fopu021/")
    pugsy:wait_for_message()
    pugsy:point_hammer()
    pugsy:say_line("/fopu022/")
    pugsy:wait_for_message()
    manny:say_line("/foma023/")
    manny:wait_for_message()
    bibi:head_look_at_manny()
    bibi:say_line("/fobi024/")
    sleep_for(500)
    pugsy:head_look_at(fo.bibi_obj)
    pugsy:wait_for_message()
    fo.fighting = TRUE
    start_script(fo.fight)
end
an1[95] = { text = "/foma025/", n1 = TRUE, gesture = manny.twist_head_gesture }
an1[95].off = TRUE
an1[95].response = function(arg1) -- line 144
    arg1.off = TRUE
    arg1.said = TRUE
    manny:say_line("/foma026/")
    manny:wait_for_message()
    manny:say_line("/foma027/")
    manny:wait_for_message()
    manny:say_line("/foma028/")
    manny:wait_for_message()
end
an1[100] = { text = "/foma029/", n1 = TRUE, gesture = manny.shrug_gesture }
an1[100].response = function(arg1) -- line 156
    arg1.off = TRUE
    pugsy:roll_head()
    pugsy:say_line("/fopu030/")
    pugsy:wait_for_message()
    bibi:say_line("/fobi031/")
    bibi:wait_for_message()
    pugsy:jut_chin()
    pugsy:say_line("/fopu032/")
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
end
an1[105] = { text = "/foma103/", n1 = TRUE, gesture = { manny.tilt_head_gesture, manny.point_gesture } }
an1[105].response = function(arg1) -- line 171
    arg1.off = TRUE
    bibi:head_look_at(fo.pugsy_obj)
    pugsy:head_look_at(fo.bibi_obj)
    bibi:say_line("/fobi104/")
    pugsy:say_line("/fopu105/")
    pugsy:wait_for_message()
    pugsy:head_look_at(nil)
    bibi:head_look_at(nil)
    sleep_for(500)
    pugsy:start_crying()
    sleep_for(500)
    bibi:start_crying()
end
an1[110] = { text = "/foma033/", n1 = TRUE, gesture = manny.head_forward_gesture }
an1[110].response = function(arg1) -- line 187
    arg1.off = TRUE
    an1[120].off = FALSE
    an1[140].off = FALSE
    an1[250].off = FALSE
    pugsy:point_hammer()
    pugsy:say_line("/fopu034/")
    pugsy:wait_for_message()
    pugsy:say_line("/fopu035/")
    pugsy:wait_for_message()
    bibi:play_chore(bibi_talk_idles_start_angelic, "bibi_talk_idles.cos")
    bibi:say_line("/fobi036/")
    bibi:wait_for_message()
    bibi:play_chore(bibi_talk_idles_end_angelic, "bibi_talk_idles.cos")
end
an1[120] = { text = "/foma037/", n1 = TRUE, gesture = manny.twist_head_gesture }
an1[120].off = TRUE
an1[120].response = function(arg1) -- line 205
    arg1.off = TRUE
    an1[130].off = FALSE
    pugsy:roll_head()
    pugsy:say_line("/fopu038/")
    sleep_for(2000)
    pugsy:point_hammer()
    pugsy:wait_for_message()
    bibi:say_line("/fobi039/")
    bibi:wait_for_message()
end
an1[130] = { text = "/foma040/", n1 = TRUE, gesture = manny.point_gesture }
an1[130].off = TRUE
an1[130].response = function(arg1) -- line 219
    arg1.off = TRUE
    manny:say_line("/foma041/")
    manny:head_forward_gesture()
    manny:wait_for_message()
    manny:say_line("/foma042/")
    manny:hand_gesture()
    manny:wait_for_message()
    pugsy:head_look_at(fo.bibi_obj)
    bibi:head_look_at(fo.pugsy_obj)
    manny:say_line("/foma043/")
    manny:tilt_head_gesture()
    manny:wait_for_message()
    pugsy:head_look_at(nil)
    bibi:head_look_at_manny()
    bibi:say_line("/fobi044/")
    bibi:wait_for_message()
    pugsy:roll_head()
    pugsy:say_line("/fopu045/")
    pugsy:wait_for_message()
    bibi:say_line("/fobi046/")
    bibi:wait_for_message()
end
an1[140] = { text = "/foma047/", n1 = TRUE, gesture = { manny.twist_head_gesture, manny.head_forward_gesture } }
an1[140].off = TRUE
an1[140].response = function(arg1) -- line 245
    arg1.off = TRUE
    pugsy:say_line("/fopu048/")
    pugsy:wait_for_message()
    bibi:play_chore(bibi_talk_idles_start_angelic, "bibi_talk_idles.cos")
    bibi:say_line("/fobi049/")
    sleep_for(1000)
    manny:twist_head_gesture()
    bibi:wait_for_message()
    bibi:play_chore(bibi_talk_idles_end_angelic, "bibi_talk_idles.cos")
    pugsy:say_line("/fopu050/")
    sleep_for(2000)
    pugsy:jut_chin()
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
end
an1[150] = { text = "/foma051/", n1 = TRUE, gesture = manny.shrug_gesture }
an1[150].response = function(arg1) -- line 264
    arg1.off = TRUE
    bibi:say_line("/fobi052/")
    bibi:wait_for_message()
    pugsy:roll_head()
    pugsy:say_line("/fopu053/")
    pugsy:wait_for_message()
    pugsy:roll_head()
    pugsy:say_line("/fopu054/")
    pugsy:wait_for_message()
end
an1[160] = { text = "/foma055/", n1 = TRUE, gesture = manny.hand_gesture }
an1[160].response = function(arg1) -- line 277
    arg1.off = TRUE
    an1[170].off = FALSE
    an1[180].off = FALSE
    bibi:say_line("/fobi056/")
    bibi:wait_for_message()
    pugsy:point_hammer()
    pugsy:say_line("/fopu057/")
    pugsy:wait_for_message()
end
an1[170] = { text = "/foma058/", n1 = TRUE, gesture = manny.head_forward_gesture }
an1[170].off = FALSE
an1[170].response = function(arg1) -- line 290
    arg1.off = TRUE
    pugsy:jut_chin()
    pugsy:say_line("/fopu059/")
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
    pugsy:head_look_at(fo.bibi_obj)
    pugsy:say_line("/fopu060/")
    pugsy:wait_for_message()
    bibi:head_look_at(fo.pugsy_obj)
    bibi:say_line("/fobi061/")
    bibi:wait_for_message()
    bibi:head_look_at_manny()
    pugsy:head_look_at(nil)
    bibi:say_line("/fobi062/")
    bibi:wait_for_message()
end
an1[180] = { text = "/foma063/", n1 = TRUE, gesture = manny.twist_head_gesture }
an1[180].off = TRUE
an1[180].response = function(arg1) -- line 310
    arg1.off = TRUE
    an1.node = "help"
    an1[190].off = FALSE
    pugsy:jut_chin()
    pugsy:say_line("/fopu064/")
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
end
an1[190] = { text = "/foma065/", n1 = TRUE, gesture = manny.head_forward_gesture }
an1[190].off = TRUE
an1[190].response = function(arg1) -- line 322
    an1.node = "help"
    an1[240].text = "/foma066/"
    pugsy:roll_head()
    pugsy:say_line("/fopu067/")
    pugsy:wait_for_message()
end
an1[200] = { text = "/foma068/", help = TRUE, gesture = manny.point_gesture }
an1[200].response = function(arg1) -- line 331
    arg1.off = TRUE
    arg1.said = TRUE
    bibi:head_look_at(nil)
    bibi:play_chore(bibi_talk_idles_talk2scream, "bibi_talk_idles.cos")
    bibi:say_line("/fobi069/")
    bibi:wait_for_message()
    bibi:play_chore(bibi_talk_idles_end_scream, "bibi_talk_idles.cos")
    bibi:head_look_at_manny()
    pugsy:head_look_at(fo.bibi_obj)
    pugsy:say_line("/fopu070/")
    pugsy:wait_for_message()
    pugsy:head_look_at(nil)
end
an1[210] = { text = "/foma071/", help = TRUE, gesture = manny.hand_gesture }
an1[210].response = function(arg1) -- line 347
    arg1.off = TRUE
    arg1.said = TRUE
    fo.hammer:make_touchable()
    fo.hammer_thrown = TRUE
    if an1[230].said and an1[200].said then
        an1.talked_help_out = TRUE
        an1[190].off = TRUE
    end
    an1.node = "n1"
    an1[145].off = FALSE
    pugsy:say_line("/fopu072/")
    sleep_for(500)
    start_script(pugsy.throw_hammer, pugsy)
    sleep_for(500)
    start_script(bibi.start_giggle, bibi)
    bibi:say_line("/fobi075/")
    wait_for_script(pugsy.throw_hammer)
    start_script(pugsy.start_laugh, pugsy, TRUE)
    pugsy:say_line("/fopu073/")
    bibi:wait_for_message()
    start_script(bibi.giggle_to_laugh, bibi)
    bibi:say_line("/fobi076/")
    pugsy:wait_for_message()
    start_script(pugsy.start_laugh, pugsy, TRUE)
    pugsy:say_line("/fopu074/")
    pugsy:wait_for_message()
    start_script(pugsy.start_laugh, pugsy, TRUE)
    pugsy:say_line("/fopu077/")
    pugsy:wait_for_message()
    pugsy:end_laugh()
    bibi:wait_for_message()
    start_script(bibi.end_laugh, bibi)
    bibi:say_line("/fobi078/")
    pugsy:complete_chore(pu_work_idles_hide_hammer, "pu_work_idles.cos")
    bibi:wait_for_message()
end
an1[230] = { text = "/foma079/", help = TRUE, gesture = { manny.tilt_head_gesture, manny.twist_head_gesture } }
an1[230].response = function(arg1) -- line 393
    arg1.off = TRUE
    arg1.said = TRUE
    bibi:say_line("/fobi080/")
    bibi:wait_for_message()
    bibi:head_look_at(fo.pugsy_obj)
    pugsy:head_look_at(fo.bibi_obj)
    pugsy:say_line("/fopu081/")
    sleep_for(1500)
    pugsy:roll_head()
    pugsy:wait_for_message()
    bibi:head_look_at_manny()
    pugsy:head_look_at(nil)
end
an1[240] = { text = "/foma082/", help = TRUE, gesture = manny.twist_head_gesture }
an1[240].response = function(arg1) -- line 409
    arg1.off = TRUE
    arg1.said = TRUE
    an1.node = "n1"
    pugsy:head_look_at(fo.bibi_obj)
    bibi:say_line("/fobi083/")
    bibi:wait_for_message()
    bibi:say_line("/fobi084/")
    pugsy:head_look_at(nil)
    bibi:wait_for_message()
end
an1.aborts.help = function(arg1) -- line 421
    an1.node = "n1"
    an1.talked_help_out = TRUE
    an1[190].off = TRUE
    an1:execute_line(an1.current_choices[1])
end
an1[145] = { text = "/foma085/", n1 = TRUE, gesture = { manny.twist_head_gesture, manny.head_forward_gesture } }
an1[145].off = TRUE
an1[145].response = function(arg1) -- line 430
    arg1.off = TRUE
    sleep_for(500)
    start_script(bibi.start_giggle, bibi)
    bibi:say_line("/fobi086/")
    start_script(pugsy.start_laugh, pugsy, TRUE)
    pugsy:say_line("/fopu087/")
    sleep_for(1000)
    manny:say_line("/foma088/")
    bibi:wait_for_message()
    bibi:giggle_to_laugh()
    bibi:say_line("/fobi089/")
    pugsy:wait_for_message()
    start_script(pugsy.start_laugh, pugsy, TRUE)
    pugsy:say_line("/fopu090/")
    bibi:wait_for_message()
    start_script(bibi.end_laugh, bibi)
end
an1[250] = { text = "/foma091/", n1 = TRUE, gesture = manny.nod_head_gesture }
an1[250].off = TRUE
an1[250].response = function(arg1) -- line 451
    arg1.off = TRUE
    an1[170].off = FALSE
    bibi:play_chore(bibi_talk_idles_start_fear, "bibi_talk_idles.cos")
    bibi:say_line("/fobi092/")
    bibi:wait_for_chore(bibi_talk_idles_start_fear, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:jut_chin()
    pugsy:say_line("/fopu093/")
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
    pugsy:head_look_at(fo.bibi_obj)
    bibi:say_line("/fobi094/")
    bibi:wait_for_message()
    bibi:say_line("/fobi095/")
    bibi:wait_for_message()
    bibi:stop_looping_chore(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_end_fear, "bibi_talk_idles.cos")
    pugsy:head_look_at(nil)
    bibi:start_crying()
    sleep_for(1000)
    pugsy:start_crying()
end
an1[270] = { text = "/foma096/", n1 = TRUE, gesture = { manny.nod_head_gesture, manny.shrug_gesture } }
an1[270].off = TRUE
an1[270].response = function(arg1) -- line 478
    arg1.off = TRUE
    if bibi.crying then
        start_script(bibi.exit_cry, bibi)
    end
    if pugsy.crying then
        pugsy:exit_cry()
    end
    wait_for_message()
    pugsy:jut_chin()
    pugsy:say_line("/fopu097/")
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
    bibi:say_line("/fobi098/")
    pugsy:head_look_at(fo.bibi_obj)
    sleep_for(2000)
    bibi:run_chore(bibi_talk_idles_start_angelic, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_angelic_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:head_look_at(nil)
    pugsy:say_line("/fopu099/")
    pugsy:wait_for_message()
    bibi:play_chore_looping(bibi_talk_idles_sway_loop, "bibi_talk_idles.cos")
    pugsy:head_look_at(fo.bibi_obj)
    bibi:say_line("/fobi100/")
    bibi:wait_for_message()
    pugsy:head_look_at(nil)
    manny:say_line("/foma101/")
    manny:wait_for_message()
    manny:say_line("/foma102/")
    bibi:stop_looping_chore(bibi_talk_idles_sway_loop, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_end_sway, "bibi_talk_idles.cos")
    manny:wait_for_message()
end
an1[290] = { text = "/foma106/", n1 = TRUE, gesture = manny.nod_head_gesture }
an1[290].response = function(arg1) -- line 511
    arg1.off = TRUE
    pugsy:say_line("/fopu107/")
    sleep_for(1000)
    pugsy:jut_chin()
    pugsy:wait_for_message()
    pugsy:un_jut_chin()
    pugsy:head_look_at(fo.bibi_obj)
    bibi:say_line("/fobi108/")
    bibi:run_chore(bibi_talk_idles_start_fear, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:head_look_at(nil)
    pugsy:jut_chin()
    pugsy:say_line("/fopu109/")
    bibi:stop_looping_chore(bibi_talk_idles_fear_loop, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_end_fear, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:un_jut_chin()
end
an1.exit_lines.n1 = { text = "/foma110/", gesture = manny.nod_head_gesture }
an1.exit_lines.n1.response = function(arg1) -- line 533
    an1.node = "exit_dialog"
    pugsy:roll_head()
    pugsy:say_line("/fopu111/")
    pugsy:wait_for_message()
end
an1.n1 = function(arg1) -- line 540
    local local1 = an1.current_choices[arg1]
    if local1 ~= an1[95] and local1 ~= an1.exit_lines_n1 then
        if bibi.crying then
            start_script(bibi.exit_cry, bibi)
        end
        if pugsy.crying then
            start_script(pugsy.exit_cry, pugsy)
        end
        stop_script(fo.fight)
        an1[95].off = TRUE
    end
end
an1.aborts.n1 = function(arg1) -- line 551
    an1:clear()
    an1.talked_out = TRUE
    an1.node = "exit_dialog"
    manny:say_line("/foma112/")
    manny:point_gesture()
    manny:wait_for_message()
    bibi:say_line("/fobi113/")
    bibi:wait_for_message()
end
an1.outro = function(arg1) -- line 562
    if bibi.crying then
        bibi:kill_crying()
    end
    if pugsy.crying then
        pugsy:kill_crying()
    end
    if not fo.fighting then
        if not bibi.crying then
            bibi:start_work()
        end
        if not pugsy.crying then
            pugsy:start_work()
        end
    end
    manny:set_look_rate(fo.former_lookrate)
end

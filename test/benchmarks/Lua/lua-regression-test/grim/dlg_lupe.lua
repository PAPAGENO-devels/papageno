CheckFirstTime("dlg_lupe.lua")
lu1 = Dialog:create()
lu1.intro = function(arg1, arg2) -- line 11
    lu1.node = "lun1"
    START_CUT_SCENE()
    if not bogen.pissed and not lu1[140].said and not cn.been_there then
        lu1[140].off = FALSE
    end
    if bogen.pissed or cn.been_there then
        lu1[140].off = TRUE
    end
    if bogen.pissed and not lu1[150].said then
        lu1[150].off = FALSE
    end
    manny:say_line("/ccma084/")
    start_script(lupe.kill_idle, lupe, lupe_idles_forward_to_talk)
    manny:wait_for_message()
    PrintDebug("param = " .. arg2)
    if arg2 ~= "grabbed" then
        PrintDebug("In here!\n")
        while lupe.last_chore ~= lupe_idles_jumps_greeting and find_script(lupe.kill_idle) do
            break_here()
        end
        lupe:say_line("/cclu086/")
    end
    lupe:head_look_at_manny()
    wait_for_script(lupe.kill_idle)
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    if not cc.met_lupe then
        cc.met_lupe = TRUE
        wait_for_message()
        lupe:say_line("/cclu088/")
        lupe:push_chore(lupe_idles_forward_shake_hands)
        lupe:push_chore()
        lupe:push_chore(lupe_idles_forward_to_talk)
        lupe:push_chore()
    elseif bi.seen_kiss and not cc.talked_note then
        lu1.node = "exit_dialog"
        cc:talk_note()
    end
    END_CUT_SCENE()
end
lu1.execute_line = function(arg1, arg2) -- line 64
    lupe:head_look_at_manny()
    Dialog.execute_line(lu1, arg2)
end
lu1[100] = { text = "/ccma089/", lun1 = TRUE }
lu1[100].response = function(arg1) -- line 70
    arg1.off = TRUE
    lu1.node = "say"
    lu1[135].off = FALSE
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:say_line("/cclu090/")
    wait_for_message()
    lupe:say_line("/cclu091/")
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
end
lu1[110] = { text = "/ccma092/", say = TRUE }
lu1[110].response = function(arg1) -- line 85
    lu1.node = "lun1"
    lu1.answer = "tonight"
    lupe:say_line("/cclu093/")
    wait_for_message()
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_forward_shake_hands)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
    lupe:say_line("/cclu094/")
end
lu1[120] = { text = "/ccma095/", say = TRUE }
lu1[120].response = function(arg1) -- line 100
    lu1.node = "lun1"
    lu1.answer = "encourage"
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    lupe:say_line("/cclu096/")
    wait_for_message()
    manny:say_line("/ccma097/")
    lu1[130]:response()
end
lu1[130] = { text = "/ccma098/", say = TRUE }
lu1[130].response = function(arg1) -- line 116
    lu1.node = "lun1"
    wait_for_message()
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_karate)
    lupe:push_chore()
    lupe:say_line("/cclu099/")
    wait_for_message()
    lupe:say_line("/cclu100/")
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
end
lu1[135] = { text = "/ccma101/", lun1 = TRUE }
lu1[135].off = TRUE
lu1[135].response = function(arg1) -- line 135
    arg1.off = TRUE
    if lu1.answer == "tonight" then
        lupe:push_chore(lupe_idles_main_pose)
        lupe:push_chore()
        lupe:push_chore(lupe_idles_forward_to_talk)
        lupe:push_chore()
        lupe:say_line("/cclu102/")
    elseif lu1.answer == "encourage" then
        lupe:push_chore(lupe_idles_head_right)
        lupe:push_chore()
        lupe:push_chore(lupe_idles_head_return_pose)
        lupe:push_chore()
        lupe:say_line("/cclu103/")
    else
        lupe:say_line("/cclu104/")
    end
    wait_for_message()
    manny:say_line("/ccma105/")
    wait_for_message()
    manny:say_line("/ccma106/")
    wait_for_message()
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    lupe:say_line("/cclu107/")
end
lu1[140] = { text = "/ccma108/", lun1 = TRUE }
lu1[140].off = TRUE
lu1[140].response = function(arg1) -- line 168
    arg1.off = TRUE
    arg1.said = TRUE
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    lupe:say_line("/cclu109/")
end
lu1[150] = { text = "/ccma110/", lun1 = TRUE }
lu1[150].off = TRUE
lu1[150].response = function(arg1) -- line 180
    arg1.off = TRUE
    arg1.said = TRUE
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    lupe:say_line("/cclu111/")
    wait_for_message()
    manny:say_line("/ccma112/")
    wait_for_message()
    lupe:say_line("/cclu113/")
end
lu1[160] = { text = "/ccma114/", lun1 = TRUE }
lu1[160].response = function(arg1) -- line 195
    arg1.off = TRUE
    lupe:say_line("/cclu115/")
    wait_for_message()
    lupe:say_line("/cclu116/")
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu117/")
    wait_for_message()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    lupe:say_line("/cclu118/")
    wait_for_message()
    manny:say_line("/ccma119/")
    wait_for_message()
    lupe:say_line("/cclu120/")
end
lu1[170] = { text = "/ccma121/", lun1 = TRUE }
lu1[170].response = function(arg1) -- line 215
    arg1.off = TRUE
    lupe:say_line("/cclu122/")
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu123/")
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_forward_shake_hands)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu124/")
    wait_for_message()
    lupe:say_line("/cclu125/")
    lupe:push_chore(lupe_idles_clapping)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
    if not lupe.talked_system then
        wait_for_message()
        lupe:say_line("/cclu126/")
    end
end
lu1[190] = { text = "/ccma127/", lun1 = TRUE }
lu1[190].response = function(arg1) -- line 244
    cc.lupe_music = TRUE
    music_state:update()
    arg1.off = TRUE
    lu1[200].off = FALSE
    lupe.talked_system = TRUE
    lupe:say_line("/cclu128/")
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_clapping)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu129/")
    lupe:push_chore(lupe_idles_karate)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu130/")
    lupe:push_chore(lupe_idles_forward_shake_hands)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu131/")
    manny:head_look_at(cc.distraction1)
    sleep_for(1000)
    manny:head_look_at(cc.distraction2)
    sleep_for(2000)
    manny:head_look_at(cc.lupe_obj)
    break_here()
    manny:head_look_at(cc.distraction1)
    sleep_for(1500)
    cc.lupe_music = FALSE
    music_state:update()
    sleep_for(1500)
    manny:head_look_at(cc.lupe_obj)
    lupe:head_look_at(manny)
    break_here()
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
    manny:head_look_at(cc.distraction2)
    sleep_for(1000)
    wait_for_message()
    lupe:say_line("/cclu132/")
    manny:head_look_at(cc.lupe_obj)
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu133/")
    wait_for_message()
    lupe:say_line("/cclu134/")
    wait_for_message()
    manny:say_line("/ccma135/")
    wait_for_message()
    lupe:say_line("/cclu136/")
    wait_for_message()
    lupe:say_line("/cclu137/")
    lupe:head_look_at(nil)
    wait_for_message()
    manny:say_line("/ccma138/")
    wait_for_message()
    lupe:say_line("/cclu139/")
    wait_for_message()
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
    lupe:say_line("/cclu140/")
    wait_for_message()
    lupe:say_line("/cclu141/")
end
lu1[200] = { text = "/ccma142/", lun1 = TRUE }
lu1[200].off = TRUE
lu1[200].response = function(arg1) -- line 318
    arg1.off = TRUE
    lupe:push_chore(lupe_idles_head_right)
    lupe:push_chore()
    lupe:say_line("/cclu143/")
    wait_for_message()
    lupe:push_chore(lupe_idles_head_return_pose)
    lupe:push_chore()
end
lu1.exit_lines.lun1 = { text = "/ccma144/" }
lu1.exit_lines.lun1.response = function(arg1) -- line 330
    lu1.node = "exit_dialog"
    if not lupe.talked_system then
        lupe:say_line("/cclu145/")
        lupe:push_chore(lupe_idles_main_pose)
        lupe:push_chore()
        wait_for_message()
        manny:say_line("/ccma146/")
        wait_for_message()
    end
    lupe:say_line("/cclu147/")
end
lu1.aborts.lun1 = function(arg1) -- line 346
    lu1:clear()
    lu1:execute_line(lu1.exit_lines.lun1)
end
lu1.outro = function(arg1) -- line 351
    lupe:head_look_at(nil)
    start_script(lupe.new_run_idle, lupe, "jump_back")
    if not cc.met_lupe or (bi.seen_kiss and not cc.talked_note) then
        cc.lupe_waiting = TRUE
    else
        cc.lupe_waiting = FALSE
    end
end

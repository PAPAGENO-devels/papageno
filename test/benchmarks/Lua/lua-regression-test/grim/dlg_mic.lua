CheckFirstTime("dlg_mic.lua")
mi1 = Dialog:create()
mi1.focus = bi.mic
mi1.display_lines = function(arg1) -- line 13
    local local1
    local local2 = 0
    local local3 = { }
    local local4
    local local5 = arg1.node
    local local6 = arg1.exit_lines[local5]
    if local5 ~= "poem_node" then
        Dialog.display_lines(mi1)
    else
        arg1.selected_line = 1
        arg1.next_line = 1
        arg1.ypos = arg1.start_y
        if local6 then
            local4 = arg1.max_line
        else
            local4 = arg1.max_line + 1
        end
        repeat
            local1 = pick_from_nonweighted_table(mi1.poetry_lines)
            if not local3[local1] then
                local3[local1] = TRUE
                local1.response = mi1.poetry_response
                arg1:set_line(local1)
                local2 = local2 + 1
            end
        until arg1.next_line >= local4
        if local6 then
            arg1:set_line(local6)
        end
        system.buttonHandler = arg1
    end
end
mi1.intro = function(arg1) -- line 51
    mi1.node = "first_mic_node"
    manny:say_line("/bima106/")
    enable_head_control(FALSE)
    manny:head_look_at(nil)
    if si.been_there then
        mi1[140].off = TRUE
    end
    if got_tools then
        mi1[130].off = TRUE
    end
    if got_union_card then
        mi1[150].off = TRUE
    end
end
mi1.outro = function(arg1) -- line 69
    enable_head_control(FALSE)
end
mi1[100] = { text = "/bima107/", first_mic_node = TRUE, gesture = manny.hand_gesture }
mi1[100].response = function(arg1) -- line 74
    arg1.off = TRUE
    music_state:set_state(stateBI_POE)
    manny:head_look_at(bi.patrons3)
    sleep_for(1000)
    manny:head_look_at(bi.patrons1)
    sleep_for(1000)
    manny:head_look_at(bi.patrons2)
    sleep_for(1000)
    manny:head_look_at(bi.mic)
    manny:say_line("/bima108/")
    wait_for_message()
    manny:head_look_at(nil)
    music_state:update()
end
mi1[110] = { text = "/bima109/", first_mic_node = TRUE, gesture = manny.head_forward_gesture }
mi1[110].response = function(arg1) -- line 92
    music_state:set_state(stateBI_POE)
    arg1.text = "/bima110/"
    if bi.last_poem and not bi.commies.befriended then
        start_script(bi.one_hiss)
    end
    bi.last_poem = { }
    bi.poem_line = 0
    mi1.node = "poem_node"
end
mi1[120] = { text = "/bima111/", first_mic_node = TRUE, gesture = manny.hand_gesture }
mi1[120].response = function(arg1) -- line 104
    arg1.off = TRUE
    bi:alexi_talking()
    alexi:say_line("/bial113/")
    wait_for_message()
    manny:shrug_gesture()
    manny:say_line("/bima112/")
    wait_for_message()
    bi:alexi_not_talking()
    gunnar:say_line("/bigu114/")
    wait_for_message()
    slisko:say_line("/bisl115/")
    wait_for_message()
    slisko:say_line("/bisl116/")
end
mi1[130] = { text = "/bima117/", first_mic_node = TRUE, gesture = manny.head_forward_gesture }
mi1[130].response = function(arg1) -- line 121
    arg1.off = TRUE
    if bi.commies.befriended then
        gunnar:say_line("/bigu118/")
    else
        bi:alexi_talking()
        alexi:say_line("/bial119/")
        wait_for_message()
        bi:alexi_not_talking()
        slisko:say_line("/bisl120/")
    end
end
mi1[140] = { text = "/bima121/", first_mic_node = TRUE }
mi1[140].response = function(arg1) -- line 135
    arg1.off = TRUE
    gunnar:say_line("/bigu122/")
    wait_for_message()
    alexi:say_line("/bial123/")
end
mi1[150] = { text = "/bima124/", first_mic_node = TRUE, gesture = manny.tilt_head_gesture }
mi1[150].response = function(arg1) -- line 143
    arg1.off = TRUE
    gunnar:say_line("/bigu125/")
    wait_for_message()
    bi:alexi_talking()
    alexi:say_line("/bial126/")
    wait_for_message()
    bi:alexi_not_talking()
end
mi1.exit_lines.first_mic_node = { text = "/bima127/", gesture = manny.hand_gesture }
mi1.exit_lines.first_mic_node.response = function(arg1) -- line 154
    arg1.off = TRUE
    mi1.node = "exit_dialog"
end
mi1.exit_lines.poem_node = { text = "/bima128/" }
mi1.exit_lines.poem_node.response = function(arg1) -- line 160
    arg1.off = TRUE
    mi1.node = "exit_dialog"
    bi.just_read_poem = TRUE
    bi.copied_last_poem = FALSE
    bi.play_bongos(TRUE)
    if bi.commies.befriended then
        start_script(bi.snap)
        gunnar:say_line("/bigu129/")
    else
        slisko:say_line("/bisl131/", { background = TRUE })
        sleep_for(200)
        gunnar:say_line("/bigu133/", { background = TRUE })
        sleep_for(300)
        manny:hand_gesture()
        manny:say_line("/bima132/")
        alexi:say_line("/bial130/", { background = TRUE })
        alexi:wait_for_message()
        alexi:say_line("/bial130/", { background = TRUE })
    end
    music_state:update()
    wait_for_message()
end
mi1.poetry_lines = { { text = "/bima133/", line_num = 1 }, { text = "/bima134/", line_num = 2 }, { text = "/bima135/", line_num = 3 }, { text = "/bima136/", line_num = 4 }, { text = "/bima137/", line_num = 5 }, { text = "/bima138/", line_num = 6 }, { text = "/bima139/", line_num = 7 }, { text = "/bima140/", line_num = 8 }, { text = "/bima141/", line_num = 9 }, { text = "/bima142/", line_num = 10 }, { text = "/bima143/", line_num = 11 }, { text = "/bima144/", line_num = 12 }, { text = "/bima145/", line_num = 13 }, { text = "/bima146/", line_num = 14 }, { text = "/bima147/", line_num = 15 }, { text = "/bima148/", line_num = 16 }, { text = "/bima149/", line_num = 17 }, { text = "/bima150/", line_num = 18 }, { text = "/bima151/", line_num = 19 }, { text = "/bima152/", line_num = 20 }, { text = "/bima153/", line_num = 21 }, { text = "/bima154/", line_num = 22 }, { text = "/bima155/", line_num = 23 }, { text = "/bima156/", line_num = 24 }, { text = "/bima157/", line_num = 25 }, { text = "/bima158/", line_num = 26 }, { text = "/bima159/", line_num = 27 }, { text = "/bima160/", line_num = 28 }, { text = "/bima161/", line_num = 29 }, { text = "/bima162/", line_num = 30 }, { text = "/bima163/", line_num = 31 }, { text = "/bima164/", line_num = 32 }, { text = "/bima165/", line_num = 33 }, { text = "/bima166/", line_num = 34 }, { text = "/bima167/", line_num = 35 }, { text = "/bima168/", line_num = 36 }, { text = "/bima169/", line_num = 37 }, { text = "/bima170/", line_num = 38 }, { text = "/bima171/", line_num = 39 }, { text = "/bima172/", line_num = 40 }, { text = "/bima173/", line_num = 41 }, { text = "/bima174/", line_num = 42 }, { text = "/bima175/", line_num = 43 }, { text = "/bima176/", line_num = 44 }, { text = "/bima177/", line_num = 45 }, { text = "/bima178/", line_num = 46 }, { text = "/bima179/", line_num = 47 }, { text = "/bima180/", line_num = 48 }, { text = "/bima181/", line_num = 49 }, { text = "/bima182/", line_num = 50 }, { text = "/bima183/", line_num = 51 }, { text = "/bima184/", line_num = 52 }, { text = "/bima185/", line_num = 53 }, { text = "/bima186/", line_num = 54 }, { text = "/bima187/", line_num = 55 }, { text = "/bima188/", line_num = 56 }, { text = "/bima189/", line_num = 57 }, { text = "/bima190/", line_num = 58 }, { text = "/bima191/", line_num = 59 }, { text = "/bima192/", line_num = 60 }, { text = "/bima194/", line_num = 61 }, { text = "/bima195/", line_num = 62 }, { text = "/bima196/", line_num = 63 }, { text = "/bima197/", line_num = 64 }, { text = "/bima198/", line_num = 65 }, { text = "/bima199/", line_num = 66 }, { text = "/bima200/", line_num = 67 }, { text = "/bima201/", line_num = 68 }, { text = "/bima202/", line_num = 69 }, { text = "/bima203/", line_num = 70 }, { text = "/bima204/", line_num = 71 }, { text = "/bima205/", line_num = 72 }, { text = "/bima206/", line_num = 73 }, { text = "/bima207/", line_num = 74 }, { text = "/bima208/", line_num = 75 }, { text = "/bima209/", line_num = 76 }, { text = "/bima210/", line_num = 77 }, { text = "/bima211/", line_num = 78 }, { text = "/bima212/", line_num = 79 }, { text = "/bima213/", line_num = 80 }, { text = "/bima214/", line_num = 81 }, { text = "/bima215/", line_num = 82 }, { text = "/bima216/", line_num = 83 }, { text = "/bima217/", line_num = 84 }, { text = "/bima218/", line_num = 85 }, { text = "/bima219/", line_num = 86 } }
mi1.poetry_response = function(arg1) -- line 273
    bi.last_poem[bi.poem_line] = arg1.line_num
    bi.poem_line = bi.poem_line + 1
    if arg1.line_num == 57 and skinny_girl.passed_out then
        manny:head_look_at(bi.patrons2)
        start_script(bi.patrons2.wake_up, bi.patrons2)
        sleep_for(3000)
        manny:head_look_at(nil)
    end
    if rndint(2) == 1 then
        bi.play_bongos(TRUE)
    end
end
mi1[999] = "EOD"

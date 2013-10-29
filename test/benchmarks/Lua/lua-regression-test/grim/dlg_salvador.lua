CheckFirstTime("dlg_salvador.lua")
sa1 = Dialog:create()
sa1.focus = gs.ga_door
sa1.asked_out = 0
sa1.intro = function() -- line 15
    sa1.node = "first_sal_node"
    enable_head_control(FALSE)
    if not sa1.talked then
        manny:say_line("/gsma001/")
    else
        manny:say_line("/gsma002/")
    end
    manny:wait_for_message()
    salvador:set_chore_looping(sv_helps_hidden, FALSE)
    salvador:play_chore(sv_helps_peek)
    salvador:wait_for_chore()
    salvador:play_chore_looping(sv_helps_peek_talk)
    salvador:set_rest_chore(-1)
    manny:walkto(gs.window)
    manny:head_look_at(gs.window)
    if not sa1.talked then
        sa1.talked = TRUE
        salvador:say_line("/gssa003/")
        wait_for_message()
        salvador:say_line("/gssa004/")
        if not sa1[120].said then
            sa1[120].off = FALSE
        else
            sa1[130].off = FALSE
        end
        if not sa1[150].said then
            sa1[150].off = FALSE
        end
    else
        salvador:say_line("/gssa005/")
        if not sa1[110].said then
            sa1[110].off = FALSE
        elseif not sa1[120].said then
            sa1[120].off = FALSE
        else
            sa1[130].off = FALSE
        end
        if not sa1[140].said then
            sa1[140].off = TRUE
        end
    end
end
sa1[100] = { text = "/gsma006/", first_sal_node = TRUE, gesture = manny.point_gesture }
sa1[100].response = function(arg1) -- line 64
    arg1.off = TRUE
    salvador:say_line("/gssa007/")
    wait_for_message()
    salvador:say_line("/gssa008/")
    wait_for_message()
    manny:head_forward_gesture()
    manny:say_line("/gsma009/")
end
sa1[105] = { text = "/gsma011/", first_sal_node = TRUE }
sa1[105].off = TRUE
sa1[105].response = function(arg1) -- line 76
    arg1.off = TRUE
    arg1.said = TRUE
    salvador:say_line("/gssa012/")
    wait_for_message()
    manny:hand_gesture()
    manny:say_line("/gsma013/")
end
sa1[110] = { text = "/gsma014/", first_sal_node = TRUE }
sa1[110].off = TRUE
sa1[110].setup = function(arg1) -- line 88
    arg1.off = TRUE
end
sa1[110].response = function(arg1) -- line 91
    arg1.off = TRUE
    arg1.said = TRUE
    arg1.text = "/gsma015/"
    sa1:back_in()
end
sa1.back_in = function(arg1) -- line 98
    sa1.node = "fold_node"
    sa1[170].off = FALSE
    sa1.asked_out = sa1.asked_out + 1
    if sa1.asked_out == 1 then
        salvador:say_line("/gssa016/")
        wait_for_message()
        salvador:say_line("/gssa017/")
        wait_for_message()
        salvador:say_line("/gssa018/")
    elseif sa1.asked_out == 2 then
        salvador:say_line("/gssa019/")
        wait_for_message()
        manny:say_line("/gsma020/")
    elseif sa1.asked_out == 3 then
        manny:say_line("/gsma021/")
        wait_for_message()
        salvador:say_line("/gssa022/")
    else
        salvador:say_line("/gssa023/")
    end
end
sa1[120] = { text = "/gsma024/", first_sal_node = TRUE }
sa1[120].off = TRUE
sa1[120].response = function(arg1) -- line 124
    arg1.off = TRUE
    sa1:back_in()
end
sa1[130] = { text = "/gsma025/", first_sal_node = TRUE, gesture = manny.nod_head_gesture }
sa1[130].off = TRUE
sa1[130].response = function(arg1) -- line 131
    sa1[130].said = TRUE
    sa1:back_in()
end
sa1[140] = { text = "/gsma026/", first_sal_node = TRUE, gesture = manny.shrug_gesture }
sa1[140].off = TRUE
sa1[140].response = function(arg1) -- line 138
    arg1.off = TRUE
    arg1.said = TRUE
    sa1:back_in()
end
sa1[150] = { text = "/gsma027/", first_sal_node = TRUE, gesture = manny.shrug_gesture }
sa1[150].off = TRUE
sa1[150].response = function(arg1) -- line 147
    arg1.off = TRUE
    arg1.said = TRUE
    sa1:back_in()
end
sa1[155] = { text = "/gsma028/", first_sal_node = TRUE, gesture = manny.tilt_head_gesture }
sa1[155].response = function(arg1) -- line 154
    arg1.off = TRUE
    sa1[160].off = FALSE
    sa1.node = "sprout_node"
    salvador:say_line("/gssa029/")
    wait_for_message()
    salvador:say_line("/gssa030/")
end
sa1[160] = { text = "/gsma031/", first_sal_node = TRUE }
sa1[160].off = TRUE
sa1[160].response = function(arg1) -- line 165
    salvador:say_line("/gssa032/")
    wait_for_message()
    sa1:tell_sprouting()
end
sa1[170] = { text = "/gsma033/", first_sal_node = TRUE, gesture = manny.hand_gesture }
sa1[170].off = TRUE
sa1[170].response = sa1.back_in
sa1.exit_lines.first_sal_node = { text = "/gsma034/", gesture = manny.twist_head_gesture }
sa1.exit_lines.first_sal_node.response = function(arg1) -- line 178
    sa1.node = "exit_dialog"
    if not sa1.told_off then
        sa1.told_off = TRUE
        salvador:say_line("/gssa035/")
        wait_for_message()
    end
    salvador:say_line("/gssa036/")
    wait_for_message()
end
sa1[200] = { text = "/gsma037/", fold_node = TRUE, gesture = manny.point_gesture }
sa1[200].setup = function(arg1) -- line 190
    arg1.off = TRUE
end
sa1[200].response = function(arg1) -- line 193
    salvador:say_line("/gssa038/")
    wait_for_message()
    salvador:say_line("/gssa039/")
end
sa1[210] = { text = "/gsma040/", fold_node = TRUE, gesture = manny.shrug_gesture }
sa1[210].response = function(arg1) -- line 200
    sa1.node = "exit_dialog"
    salvador:say_line("/gssa041/")
    wait_for_message()
    salvador:say_line("/gssa042/")
end
sa1[220] = { text = "/gsma043/", fold_node = TRUE, gesture = manny.head_forward_gesture }
sa1[220].response = function(arg1) -- line 208
    sa1.node = "angry_node"
    if not sa1.heard_anger then
        sa1.heard_anger = TRUE
        salvador:say_line("/gssa044/")
        wait_for_message()
        salvador:say_line("/gssa045/")
    else
        salvador:say_line("/gssa046/")
        wait_for_message()
        salvador:say_line("/gssa047/")
    end
end
sa1[230] = { text = "/gsma048/", fold_node = TRUE, gesture = manny.shrug_gesture }
sa1[230].response = function(arg1) -- line 223
    arg1.off = TRUE
    sa1[200]:response()
end
sa1[240] = { text = "/gsma049/", fold_node = TRUE, gesture = manny.twist_head_gesture }
sa1[240].response = function(arg1) -- line 229
    arg1.off = TRUE
    sa1.node = "exit_dialog"
    salvador:say_line("/gssa050/")
    wait_for_message()
    salvador:say_line("/gssa051/")
    wait_for_message()
    salvador:say_line("/gssa052/")
end
sa1[300] = { text = "/gsma053/", sprout_node = TRUE, gesture = manny.twist_head_gesture }
sa1[300].response = function(arg1) -- line 240
    arg1.off = TRUE
    salvador:say_line("/gssa054/")
    wait_for_message()
    sa1:tell_sprouting()
end
sa1[310] = { text = "/gsma055/", sprout_node = TRUE, gesture = manny.nod_head_gesture }
sa1[310].response = function(arg1) -- line 248
    arg1.off = TRUE
    salvador:say_line("/gssa056/")
    wait_for_message()
    sa1:tell_sprouting()
end
sa1[320] = { text = "/gsma057/", sprout_node = TRUE, gesture = manny.tilt_head_gesture }
sa1[320].response = sa1[300].response
sa1[330] = { text = "/gsma058/", sprout_node = TRUE, gesture = manny.twist_head_gesture }
sa1[330].response = sa1[300].response
sa1.tell_sprouting = function(arg1) -- line 260
    sa1.node = "first_sal_node"
    salvador:say_line("/gssa059/")
    wait_for_message()
    salvador:say_line("/gssa060/")
    wait_for_message()
    salvador:say_line("/gssa061/")
    wait_for_message()
    salvador:say_line("/gssa062/")
    wait_for_message()
    salvador:say_line("/gssa063/")
    wait_for_message()
    salvador:say_line("/gssa064/")
    wait_for_message()
    salvador:say_line("/gssa065/")
    wait_for_message()
    salvador:say_line("/gssa066/")
    wait_for_message()
    if not sa1.heard_story then
        sa1.heard_story = TRUE
        manny:say_line("/gsma067/")
        wait_for_message()
        salvador:say_line("/gssa068/")
        wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/gsma069/")
    else
        manny:say_line("/gsma070/")
    end
end
sa1[400] = { text = "/gsma071/", angry_node = TRUE, gesture = manny.head_forward_gesture }
sa1[400].response = function(arg1) -- line 292
    sa1.node = "exit_dialog"
    salvador:say_line("/gssa072/")
    wait_for_message()
    salvador:set_chore_looping(sv_helps_peek_talk, FALSE)
    salvador:play_chore(sv_helps_hide)
    salvador:wait_for_chore()
    salvador:setpos(0.8703, 9.6567, 0)
    salvador:setrot(0, 25.0015, 0)
    salvador:set_colormap("eva_sv.cmp")
    ResetTextures()
    salvador:set_head(3, 4, 5, 165, 28, 80)
    gs.ga_door:play_chore(gs_ga_door_open, "gs_ga_door.cos")
    salvador:head_look_at_manny()
    salvador:play_chore(sv_helps_open_door)
    manny:head_look_at(gs.ga_door)
    manny:setrot(0, 259.61, 0, TRUE)
    salvador:wait_for_chore()
    gs.ga_door:wait_for_chore(gs_ga_door_open)
    gs.is_jail = FALSE
    cur_puzzle_state[7] = TRUE
    salvador:say_line("/gssa073/")
    wait_for_message()
    start_script(cut_scene.lsahq)
end
sa1[410] = { text = "/gsma074/", angry_node = TRUE, gesture = manny.tilt_head_gesture }
sa1[410].response = function(arg1) -- line 322
    sa1.node = "exit_dialog"
    salvador:say_line("/gssa075/")
end
sa1[420] = { text = "/gsma076/", angry_node = TRUE, gesture = manny.hand_gesture }
sa1[420].response = sa1[410].response
sa1.outro = function(arg1) -- line 330
    if sa1[100].off and not sa1[105].said then
        sa1[105].off = FALSE
    end
    if gs.is_jail then
        salvador:set_chore_looping(sv_helps_peek_talk, FALSE)
        salvador:play_chore(sv_helps_hide)
        salvador:wait_for_chore()
        salvador:play_chore_looping(sv_helps_hidden)
        manny:head_look_at(nil)
    end
end
sa1[999] = "EOD"

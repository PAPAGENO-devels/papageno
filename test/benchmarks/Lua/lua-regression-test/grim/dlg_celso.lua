CheckFirstTime("dlg_celso.lua")
ce1 = Dialog:create()
ce1.intro = function(arg1) -- line 10
    ce1.node = "first_celso_node"
    manny:head_look_at(ri.celso_obj)
    if not ce1.introduced then
        ce1.introduced = TRUE
        manny:head_look_at(ri.celso_obj)
        manny:say_line("/rima001/")
        wait_for_message()
        manny:head_look_at(ri.celso_obj)
        start_script(celso.face_manny, celso)
        manny:say_line("/rima002/")
        wait_for_message()
        celso:say_line("/rice003/")
        wait_for_message()
        celso:say_line("/rice004/")
        wait_for_message()
        celso:say_line("/rice005/")
        celso:head_look_at_point(3.0496, 0.3054, 0.6586)
        wait_for_message()
        celso:head_look_at_point(ri.manny_point)
    elseif ce1.talked_out then
        ce1.node = "exit_dialog"
        if ce1.talked_out == 1 then
            manny:say_line("/rima006/")
            wait_for_message()
            celso:say_line("/rice007/")
        elseif ce1.talked_out == 2 then
            manny:say_line("/rima008/")
            wait_for_message()
            celso:say_line("/rice009/")
        elseif ce1.talked_out == 3 then
            manny:say_line("/rima010/")
            wait_for_message()
            celso:say_line("/rice011/")
        elseif ce1.talked_out == 4 then
            manny:say_line("/rima012/")
            wait_for_message()
            celso:say_line("/rice013/")
        else
            manny:say_line("/rima014/")
            wait_for_message()
            celso:say_line("/rice015/")
            start_script(celso.face_manny, celso)
            wait_for_message()
            celso:say_line("/rice016/")
            sleep_for(500)
        end
        ce1.talked_out = ce1.talked_out + 1
    end
end
ce1.execute_line = function(arg1, arg2) -- line 64
    if not celso.facing_manny then
        start_script(celso.face_manny, celso)
    end
    Dialog.execute_line(ce1, arg2)
end
ce1.display_lines = function(arg1) -- line 74
    if celso.facing_manny then
        celso:face_mop()
    end
    Dialog.display_lines(ce1)
end
ce1[100] = { text = "/rima017/", first_celso_node = TRUE }
ce1[100].response = function(arg1) -- line 82
    arg1.off = TRUE
    celso:say_line("/rice018/")
end
ce1[110] = { text = "/rima021/", first_celso_node = TRUE }
ce1[110].response = function(arg1) -- line 92
    arg1.off = TRUE
    if not ce1.talked_wife then
        ce1[120].off = FALSE
    end
    celso:say_line("/rice022/")
    wait_for_message()
    celso:say_line("/rice023/")
end
ce1[120] = { text = "/rima024/", first_celso_node = TRUE }
ce1[120].off = TRUE
ce1[120].response = function(arg1) -- line 104
    ce1[120].off = TRUE
    ce1[130].off = TRUE
    ce1[123].off = FALSE
    ce1[125].off = FALSE
    ce1[135].off = FALSE
    ce1.talked_wife = TRUE
    celso:head_look_at_point(ri.mop_point)
    celso:say_line("/rice025/")
    celso:head_look_at_point(ri.mop_point)
    wait_for_message()
    celso:head_look_at_point(ri.mop_point)
    celso:say_line("/rice026/")
    sleep_for(2000)
    celso:head_look_at_point(ri.manny_point)
    wait_for_message()
    celso:say_line("/rice027/")
    wait_for_message()
end
ce1[123] = { text = "/rima091/", first_celso_node = TRUE }
ce1[123].off = TRUE
ce1[123].response = function(arg1) -- line 126
    arg1.off = TRUE
    celso:say_line("/rice092/")
    wait_for_message()
    celso:say_line("/rice093/")
end
ce1[125] = { text = "/rima028/", first_celso_node = TRUE }
ce1[125].off = TRUE
ce1[125].response = function(arg1) -- line 135
    arg1.off = TRUE
    celso:say_line("/rice029/")
end
ce1[130] = { text = "/rima030/", first_celso_node = TRUE }
ce1[130].response = ce1[120].response
ce1[135] = { text = "/rima031/", first_celso_node = TRUE }
ce1[135].triggers_photo = TRUE
ce1[135].off = TRUE
ce1[135].response = function(arg1) -- line 146
    arg1.off = TRUE
    ri.photo:get()
    celso:say_line("/rice032/")
    sleep_for(500)
    start_script(celso.hand_photo)
    wait_for_message()
    celso:say_line("/rice033/")
    wait_for_message()
    celso:say_line("/rice034/")
    wait_for_message()
    manny:say_line("/rima035/")
    manny:blend(ma_read_note, ma_hold, 500, "ma.cos")
    wait_for_message()
    celso:say_line("/rice036/")
    sleep_for(500)
    manny:blend(ma_hold, ma_read_note, 500, "ma.cos")
    manny:wait_for_chore()
    manny:clear_hands()
end
ce1[140] = { text = "/rima037/", first_celso_node = TRUE }
ce1[140].response = function(arg1) -- line 168
    arg1.off = TRUE
    ce1[150].off = FALSE
    ce1[160].off = FALSE
    celso:say_line("/rice038/")
    wait_for_message()
    manny:say_line("/rima039/")
    wait_for_message()
    celso:say_line("/rice040/")
end
ce1[150] = { text = "/rima041/", first_celso_node = TRUE }
ce1[150].off = TRUE
ce1[150].response = function(arg1) -- line 181
    arg1.off = TRUE
    celso:say_line("/rice042/")
    wait_for_message()
    manny:say_line("/rima043/")
    wait_for_message()
    celso:say_line("/rice044/")
    wait_for_message()
    celso:say_line("/rice045/")
end
ce1[160] = { text = "/rima046/", first = TRUE }
ce1[160].off = TRUE
ce1[160].response = function(arg1) -- line 194
    arg1.off = TRUE
    ce1[170].off = FALSE
    celso:say_line("/rice094/")
    wait_for_message()
    manny:say_line("/rima048/")
end
ce1[170] = { text = "/rima049/", first_celso_node = TRUE }
ce1[170].off = TRUE
ce1[170].response = function(arg1) -- line 204
    arg1.off = TRUE
    celso:say_line("/rice050/")
    wait_for_message()
    celso:say_line("/rice051/")
    wait_for_message()
    celso:say_line("/rice052/")
end
ce1.exit_lines.first_celso_node = { text = "/rima053/" }
ce1.exit_lines.first_celso_node.response = function(arg1) -- line 214
    ce1.node = "exit_dialog"
    celso:say_line("/rice054/")
end
ce1.aborts.first_celso_node = function(arg1) -- line 219
    ce1:clear()
    ce1.node = "exit_dialog"
    ce1.talked_out = 1
    celso:say_line("/rice055/")
    wait_for_message()
    manny:say_line("/rima056/")
    wait_for_message()
    celso:say_line("/rice057/")
end
ce1[999] = "EOD"
ce1.outro = function(arg1) -- line 233
    if celso.facing_manny then
        celso:face_mop()
    end
end

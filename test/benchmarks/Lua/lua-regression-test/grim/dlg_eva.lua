CheckFirstTime("dlg_eva.lua")
ev1 = Dialog:create()
ev1.focus = ha.eva_obj
ev1.intro = function(arg1, arg2) -- line 7
    ev1.node = "first_eva_node"
    ha:current_setup(ha_evaws)
    stop_script(ha.elevator_door_timer)
    stop_script(ha.elevator_open_too_long)
    manny:turn_toward_entity(ha.eva_obj.obj_x, ha.eva_obj.obj_y, ha.eva_obj.obj_z)
    if reaped_bruno then
        if not ev1.talked_bruno then
            ev1[3].off = FALSE
        end
        ev1[8].off = TRUE
        ev1[10].off = TRUE
        ev1[2].off = TRUE
        ev1[12].off = TRUE
        ev1[14].off = TRUE
        met_eva = TRUE
    end
    if arg2 == "work_order" then
        ev1:execute_line(ev1[2])
    else
        if not met_eva then
            met_eva = TRUE
            manny:say_line("/hama001/")
            wait_for_message()
            eva:say_line("/haev002/")
            wait_for_message()
        end
        if ga.been_there and not met_glottis and not ev1[14].said then
            ev1[14].off = FALSE
        else
            ev1[14].off = TRUE
        end
        if co.been_there and not ev1.talked_don and not reaped_bruno then
            ev1[4].off = FALSE
        end
        if ga.work_order.owner == manny and not reaped_bruno then
            ev1[2].off = FALSE
        end
    end
end
manny.hand_order = function() -- line 66
    manny:walkto(ha.eva_obj)
    if manny.is_holding ~= ga.work_order then
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = ga.work_order
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
        end
    end
end
ev1[2] = { text = "/hama003/", first_eva_node = TRUE, gesture = manny.hand_order }
ev1[2].off = TRUE
ev1[2].response = function(arg1) -- line 82
    ev1.node = "exit_dialog"
    stop_script(run_idle)
    eva:say_line("/haev004/")
    eva:play_chore(eva_sec_prepare_to_buzz, "eva_sec.cos")
    sleep_for(1000)
    eva:wait_for_message()
    eva:play_chore(eva_sec_buzz, "eva_sec.cos")
    sleep_for(750)
    start_sfx("intrcom.wav")
    wait_for_sound("intrcom.wav")
    start_sfx("intrbuzz.wav")
    wait_for_sound("intrbuzz.wav")
    if co.computer.set_to_sign then
        cur_puzzle_state[2] = TRUE
        start_script(cut_scene.lol, cut_scene)
    else
        eva:say_line("/haev005/")
        eva:wait_for_message()
        co.computer:respond()
        wait_for_message()
        eva:say_line("/haev006/")
        eva:play_chore(eva_sec_s_buzz_back, "eva_sec.cos")
        eva:wait_for_message()
        eva:say_line("/haev007/")
        eva:wait_for_message()
        start_script(put_away_held_item)
        if not buzzed_don then
            buzzed_don = TRUE
            eva:say_line("/haev008/")
            wait_for_message()
            manny:say_line("/hama009/")
            wait_for_message()
            eva:say_line("/haev010/")
        end
        eva:blend(eva_sec_read_loop, eva_sec_s_buzz_back, 1000, "eva_sec.cos")
        start_script(run_idle, eva, eva.idle_table, eva_sec_read_loop)
    end
end
ev1[3] = { text = "/hama011/", first_eva_node = TRUE }
ev1[3].off = TRUE
ev1[3].response = function(arg1) -- line 127
    arg1.off = TRUE
    ev1.talked_bruno = TRUE
    eva:say_line("/haev012/")
    wait_for_message()
    eva:say_line("/haev013/")
    wait_for_message()
    manny:say_line("/hama014/")
    wait_for_message()
    eva:say_line("/haev015/")
end
ev1[4] = { text = "/hama017/", first_eva_node = TRUE }
ev1[4].off = TRUE
ev1[4].response = function(arg1) -- line 141
    arg1.off = TRUE
    ev1.talked_don = TRUE
    eva:say_line("/haev018/")
    wait_for_message()
    manny:say_line("/hama019/")
    wait_for_message()
    eva:say_line("/haev020/")
    wait_for_message()
    eva:say_line("/haev021/")
end
ev1[5] = { text = "/hama022/", first_eva_node = TRUE }
ev1[5].off = TRUE
ev1[5].response = function(arg1) -- line 155
    if ev1.explained_all then
        ev1:explain_choice()
    else
        ev1.node = "explain2_node"
        eva:say_line("/haev023/")
    end
end
ev1[8] = { text = "/hama024/", first_eva_node = TRUE }
ev1[8].response = function(arg1) -- line 165
    arg1.off = TRUE
    ev1[10].off = FALSE
    eva:say_line("/haev025/")
    wait_for_message()
    eva:say_line("/haev026/")
end
ev1[10] = { text = "/hama027/", first_eva_node = TRUE }
ev1[10].off = TRUE
ev1[10].response = function(arg1) -- line 175
    arg1.off = TRUE
    ev1[12].off = FALSE
    eva:say_line("/haev028/")
end
ev1[12] = { text = "/hama030/", first_eva_node = TRUE }
ev1[12].off = TRUE
ev1[12].response = function(arg1) -- line 185
    ev1:explain_choice()
end
ev1[14] = { text = "/hama031/", first_eva_node = TRUE }
ev1[14].off = TRUE
ev1[14].response = function(arg1) -- line 192
    arg1.off = TRUE
    arg1.said = TRUE
    ev1:explain_choice()
end
ev1.explain_choice = function(arg1) -- line 198
    if ev1.explained_all then
        ev1[12].off = TRUE
        ev1[5].off = TRUE
        ev1.node = "first_eva_node"
        eva:say_line("/haev032/")
        wait_for_message()
        eva:say_line("/haev033/")
    else
        ev1.node = "explain_node"
        eva:say_line("/haev034/")
    end
end
ev1.done_explaining = function(arg1) -- line 212
end
ev1[15] = { text = "/hama035/", first_eva_node = TRUE }
ev1[15].response = function(arg1) -- line 216
    arg1.off = TRUE
    ev1[20].off = FALSE
    eva:say_line("/haev036/")
    wait_for_message()
    manny:say_line("/hama037/")
    wait_for_message()
    eva:say_line("/haev038/")
    wait_for_message()
    eva:say_line("/haev039/")
    wait_for_message()
    eva:say_line("/haev040/")
    wait_for_message()
    eva:say_line("/haev041/")
    wait_for_message()
    manny:say_line("/hama042/")
end
ev1[20] = { text = "/hama043/", first_eva_node = TRUE }
ev1[20].off = TRUE
ev1[20].response = function(arg1) -- line 236
    arg1.off = TRUE
    ev1[30].off = FALSE
    eva:say_line("/haev044/")
    wait_for_message()
    eva:say_line("/haev045/")
    wait_for_message()
    eva:say_line("/haev046/")
end
ev1[30] = { text = "/hama047/", first_eva_node = TRUE }
ev1[30].off = TRUE
ev1[30].response = function(arg1) -- line 248
    arg1.off = TRUE
    eva:say_line("/haev048/")
    wait_for_message()
    eva:say_line("/haev049/")
    wait_for_message()
    manny:say_line("/hama050/")
    wait_for_message()
    eva:say_line("/haev051/")
end
ev1[35] = { text = "/hama052/", first_eva_node = TRUE }
ev1[35].response = function(arg1) -- line 260
    arg1.off = TRUE
    eva:say_line("/haev053/")
    wait_for_message()
    manny:say_line("/hama054/")
end
ev1[40] = { text = "/hama055/", first_eva_node = TRUE }
ev1[40].response = function(arg1) -- line 268
    arg1.off = TRUE
    ev1[43].off = FALSE
    eva:say_line("/haev056/")
    wait_for_message()
    manny:say_line("/hama057/")
    wait_for_message()
    eva:say_line("/haev058/")
    wait_for_message()
    eva:say_line("/haev059/")
end
ev1[43] = { text = "/hama060/", first_eva_node = TRUE }
ev1[43].off = TRUE
ev1[43].response = function(arg1) -- line 282
    arg1.off = TRUE
    eva:say_line("/haev061/")
    wait_for_message()
    eva:say_line("/haev062/")
    wait_for_message()
    manny:say_line("/hama063/")
    wait_for_message()
    eva:say_line("/haev064/")
    wait_for_message()
    if reaped_bruno then
        manny:say_line("/hama065/")
    else
        manny:say_line("/hama066/")
        wait_for_message()
        eva:say_line("/haev067/")
    end
end
ev1[50] = { text = "/hama068/", first_eva_node = TRUE }
ev1[50].response = function(arg1) -- line 302
    arg1.off = TRUE
    eva:say_line("/haev069/")
    wait_for_message()
    eva:say_line("/haev070/")
end
ev1[60] = { text = "/hama071/", first_eva_node = TRUE }
ev1[60].response = function(arg1) -- line 310
    arg1.off = TRUE
    eva:say_line("/haev072/")
    wait_for_message()
    manny:say_line("/hama073/")
    wait_for_message()
    eva:say_line("/haev074/")
    wait_for_message()
    manny:say_line("/hama075/")
end
ev1[70] = { text = "/hama076/", explain_node = TRUE }
ev1[70].response = function(arg1) -- line 322
    ev1.node = "explain2_node"
    ev1[5].off = FALSE
    eva:say_line("/haev077/")
    wait_for_message()
    manny:say_line("/hama078/")
    wait_for_message()
    eva:say_line("/haev079/")
    wait_for_message()
    eva:say_line("/haev080/")
    wait_for_message()
    eva:say_line("/haev081/")
    wait_for_message()
    eva:say_line("/haev082/")
    wait_for_message()
    eva:say_line("/haev083/")
    wait_for_message()
    eva:say_line("/haev084/")
end
ev1[75] = { text = "/hama085/", explain_node = TRUE }
ev1[75].response = ev1[70].response
ev1[80] = { text = "/hama086/", explain_node = TRUE }
ev1[80].response = function(arg1) -- line 346
    ev1.node = "page_node"
    eva:say_line("/haev087/")
end
ev1[90] = { text = "/hama088/", page_node = TRUE }
ev1[90].response = function(arg1) -- line 352
    eva:say_line("/haev089/")
    ev1:search_line()
end
ev1[95] = { text = "/hama090/", page_node = TRUE }
ev1[95].response = function(arg1) -- line 358
    eva:say_line("/haev091/")
    ev1:search_line()
end
ev1.search_line = function(arg1) -- line 363
    ev1.node = "explain2_node"
    ev1[105].off = FALSE
    wait_for_message()
    eva:say_line("/haev092/")
end
ev1[100] = { text = "/hama093/", explain2_node = TRUE }
ev1[100].response = function(arg1) -- line 371
    arg1.off = TRUE
    eva:say_line("/haev094/")
end
ev1[105] = { text = "/hama095/", explain2_node = TRUE }
ev1[105].off = TRUE
ev1[105].response = function(arg1) -- line 378
    arg1.off = TRUE
    eva:say_line("/haev096/")
    wait_for_message()
    eva:say_line("/haev097/")
    wait_for_message()
    manny:say_line("/hama098/")
end
ev1[110] = { text = "/hama099/", explain2_node = TRUE }
ev1[110].response = function(arg1) -- line 388
    arg1.off = TRUE
    manny:say_line("/hama100/")
    wait_for_message()
    eva:say_line("/haev101/")
    wait_for_message()
    manny:say_line("/hama102/")
    wait_for_message()
    eva:say_line("/haev103/")
    wait_for_message()
    manny:say_line("/hama104/")
    wait_for_message()
    eva:say_line("/haev105/")
    wait_for_message()
    eva:say_line("/haev106/")
end
ev1[120] = { text = "/hama107/", explain2_node = TRUE }
ev1[120].response = function(arg1) -- line 406
    arg1.off = TRUE
    eva:say_line("/haev108/")
    wait_for_message()
    manny:say_line("/hama109/")
    wait_for_message()
    eva:say_line("/haev110/")
end
ev1[130] = { text = "/hama111/", expain2_node = TRUE }
ev1[130].response = function(arg1) -- line 416
    arg1.off = TRUE
    eva:say_line("/haev112/")
    wait_for_message()
    eva:say_line("/haev113/")
    wait_for_message()
    eva:say_line("/haev114/")
    wait_for_message()
    eva:say_line("/haev115/")
    wait_for_message()
end
ev1[140] = { text = "/hama116/", explain2_node = TRUE }
ev1[140].response = function(arg1) -- line 429
    arg1.off = TRUE
    eva:say_line("/haev117/")
end
ev1.exit_lines.first_eva_node = { text = "/hama118/" }
ev1.exit_lines.first_eva_node.response = function(arg1) -- line 435
    if not ev1.taught_bricks then
        ev1.taught_bricks = TRUE
        eva:say_line("/haev119/")
    end
    ev1.node = "exit_dialog"
end
ev1.exit_lines.explain2_node = ev1.exit_lines.first_eva_node
ev1.aborts.first_eva_node = function(arg1) -- line 444
    ev1:clear()
    ev1.node = "exit_dialog"
    eva:say_line("/haev120/")
    wait_for_message()
    manny:say_line("/hama121/")
end
ev1.aborts.explain2_node = function(arg1) -- line 452
    ev1:clear()
    ev1.explained_all = TRUE
    ev1.node = "first_eva_node"
end
ev1.outro = function(arg1) -- line 458
    system.currentSet:force_camerachange()
end
ev1[999] = "EOD"

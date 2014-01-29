CheckFirstTime("dlg_charlie.lua")
manny.line_189 = function(arg1) -- line 9
    manny:blend(mc_booth_idles_line189, mc_booth_idles_sit_pose, 800)
    sleep_for(800)
end
manny.line246 = function(arg1) -- line 14
    manny:blend(mc_booth_idles_line246, mc_booth_idles_sit_pose, 500)
    sleep_for(500)
end
ch1 = Dialog:create()
ch1.intro = function(arg1) -- line 21
    ch1.node = "first_charlie_node"
    start_script(manny.head_follow_mesh, manny, charlie, 7)
    cn:current_setup(cn_cchms)
    manny:push_costume("mc_booth_idles.cos")
    manny:set_rest_chore(nil)
    manny:ignore_boxes()
    manny:setpos(0.90526, -0.14379, 0.02462)
    manny:setrot(0, 0, 0)
    manny:play_chore(mc_booth_idles_scootch)
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_smoke, 500)
    if charlie.talked_union then
        charlie:say_line("/cncc175/")
        charlie:play_chore(cc_booth_idles_gesture1)
        charlie:wait_for_chore()
        charlie:wait_for_message()
        manny:say_line("/cnma176/")
        manny:wait_for_message()
        charlie:say_line("/cncc177/")
        charlie:stop_chore(cc_booth_idles_gesture1)
        charlie:play_chore(cc_booth_idles_gesture2)
        charlie:wait_for_chore()
        charlie:wait_for_message()
        manny:say_line("/cnma178/")
        manny:wait_for_message()
        manny:say_line("/cnma179/")
        manny:wait_for_message()
    else
        if lm.talked_union or dd.talked_charlie and cn.printer.owner == manny then
            if not ch1[160].said then
                ch1[160].off = FALSE
            else
                ch1[130].off = FALSE
            end
        end
        if not ch1.met then
            ch1.met = TRUE
            manny:say_line("/cnma180/")
            manny:wait_for_message()
            charlie:say_line("/cncc181/")
            charlie:blend(cc_booth_idles_line181, cc_booth_idles_sit_pose, 500)
            charlie:wait_for_chore(cc_booth_idles_line181)
            charlie:wait_for_message()
            charlie:say_line("/cncc182/")
            charlie:blend(cc_booth_idles_line182, cc_booth_idles_line181, 500)
            charlie:wait_for_message()
            charlie:wait_for_chore(cc_booth_idles_line182)
            charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_line182, 500)
        else
            charlie:blend(cc_booth_idles_nod, cc_booth_idles_sit_pose, 500)
            charlie:say_line("/cncc183/")
            charlie:wait_for_message()
            charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_nod, 800)
        end
    end
    manny:wait_for_chore()
    manny:stop_chore(mc_booth_idles_scootch)
    manny:play_chore(mc_booth_idles_sit_pose)
end
ch1.first_charlie_node = function() -- line 88
    if not ch1[100].off then
        ch1[100].off = TRUE
        ch1[110].off = FALSE
    end
end
ch1[100] = { text = "/cnma184/", first_charlie_node = TRUE }
ch1[100].gesture = manny.line_189
ch1[100].response = function(arg1) -- line 98
    ch1[100].off = TRUE
    ch1[110].off = TRUE
    ch1[120].off = FALSE
    manny:say_line("/cnma185/")
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_line189, 500)
    manny:wait_for_message()
    manny:wait_for_chore(mc_booth_idles_line190, "mc_booth_idles.cos")
    charlie:say_line("/cncc186/")
    sleep_for(500)
    manny:stop_chore(mc_booth_idles_line189)
    charlie:push_chore(cc_booth_idles_line188)
    charlie:push_chore()
    charlie:push_chore(cc_booth_idles_explain_loop, nil, 800)
    charlie:push_chore()
    charlie:wait_for_message()
    charlie:wait_for_chore(cc_booth_idles_explain_loop)
    charlie:say_line("/cncc187/")
    charlie:blend(cc_booth_idles_smoke_shake, cc_booth_idles_explain_loop, 800)
    charlie:stop_chore(cc_booth_idles_explain_loop)
    charlie:wait_for_message()
    charlie:say_line("/cncc188/")
    charlie:blend(cc_booth_idles_line188, cc_booth_idles_smoke_shake, 500)
    charlie:wait_for_chore(cc_both_idles_line188)
    charlie:blend(cc_booth_idles_sit_pose, cc_both_idles_line188, 800)
    charlie:wait_for_chore()
end
ch1[110] = { text = "/cnma189/", first_charlie_node = TRUE }
ch1[110].off = TRUE
ch1[110].gesture = manny.line_189
ch1[110].response = ch1[100].response
ch1[120] = { text = "/cnma190/", first_charlie_node = TRUE }
ch1[120].off = TRUE
ch1[120].response = function(arg1) -- line 136
    arg1.off = TRUE
    ch1[130].off = FALSE
    cn.printer:get()
    music_state:set_sequence(seqChowchillaBye)
    charlie:say_line("/cncc191/")
    charlie:play_chore(cc_booth_idles_takeout_printer)
    charlie:wait_for_chore()
    tix_printer:set_visibility(TRUE)
    charlie:wait_for_message()
    charlie:say_line("/cncc192/")
    charlie:play_chore(cc_booth_idles_stroke)
    charlie:wait_for_message()
    charlie:say_line("/cncc193/")
    charlie:wait_for_chore()
    charlie:blend(cc_booth_idles_stare, cc_booth_idles_stroke, 800)
    charlie:wait_for_chore(cc_booth_idles_stare)
    sleep_for(2000)
    charlie:blend(cc_booth_idles_gesture1, cc_booth_idles_stare, 500)
    charlie:wait_for_message()
    charlie:say_line("/cncc194/")
    charlie:wait_for_message()
    manny:say_line("/cnma195/")
    manny:stop_chore(mc_booth_idles_sit_pose)
    manny:play_chore(mc_booth_idles_get_printer)
    sleep_for(670)
    tix_printer:set_visibility(FALSE)
    sleep_for(375)
    charlie:blend(cc_booth_idles_bad_grab, cc_booth_idles_stare, 300)
    manny:wait_for_chore()
    manny:stop_chore(mc_booth_idles_get_printer)
    manny:play_chore(mc_booth_idles_sit_pose)
    charlie:wait_for_chore(cc_booth_idles_bad_grab)
    charlie:play_chore_looping(cc_booth_idles_bad_grab)
    manny:wait_for_message()
    charlie:say_line("/cncc196/")
    charlie:wait_for_message()
    manny:wait_for_chore()
    manny:say_line("/cnma197/")
    manny:blend(mc_booth_idles_nod, mc_booth_idles_sit_pose, 300)
    charlie:stop_looping_chore(cc_booth_idles_bad_grab)
    manny:wait_for_message()
    charlie:blend(cc_booth_idles_sad, cc_booth_idles_bad_grab, 500)
    charlie:wait_for_chore()
    manny:wait_for_message()
    charlie:say_line("/cncc198/")
    charlie:wait_for_message()
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_nod, 300)
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_sad, 800)
end
ch1[130] = { text = "/cnma199/", first_charlie_node = TRUE }
ch1[130].off = TRUE
ch1[130].gesture = manny.line_189
ch1[130].response = function(arg1) -- line 196
    ch1.node = "counterfeit"
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_line189, 500)
    charlie:say_line("/cncc200/")
    charlie:push_chore(cc_booth_idles_line200)
    charlie:push_chore()
    charlie:wait_for_message()
    charlie:say_line("/cncc201/")
    charlie:push_chore(cc_booth_idles_line201)
    charlie:push_chore()
    charlie:push_chore(cc_booth_idles_sit_pose, nil, 500)
    if lm.talked_union or dd.talked_charlie then
        if not ch1[160].said then
            ch1[160].off = FALSE
        end
    end
end
ch1[140] = { text = "/cnma202/", counterfeit = TRUE }
ch1[140].response = function(arg1) -- line 215
    arg1.off = TRUE
    charlie:say_line("/cncc203/")
    charlie:push_chore(cc_booth_idles_smoke_shake)
    charlie:push_chore()
    charlie:push_chore(cc_booth_idles_sit_pose, nil, 500)
    charlie:wait_for_message()
    charlie:say_line("/cncc204/")
    charlie:blend(cc_booth_idles_shake_head, cc_booth_idles_sit_pose, 800)
    charlie:push_chore()
    charlie:wait_for_message()
    charlie:say_line("/cncc205/")
    manny:blend(mc_booth_idles_nod, mc_booth_idles_sit_pose, 300)
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_shake_head, 800)
    charlie:wait_for_message()
    manny:say_line("/cnma206/")
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_nod, 300)
    manny:wait_for_message()
    charlie:say_line("/cncc207/")
    charlie:blend(cc_booth_idles_gesture2, cc_booth_idles_sit_pose, 800)
    charlie:wait_for_chore()
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_gesture2, 800)
end
ch1[150] = { text = "/cnma208/", counterfeit = TRUE }
ch1[150].response = function(arg1) -- line 243
    arg1.off = TRUE
    charlie:say_line("/cncc209/")
    charlie:blend(cc_booth_idles_gesture2, cc_booth_idles_sit_pose, 800)
    charlie:wait_for_message()
    charlie:wait_for_chore(cc_booth_idles_gesture2)
    charlie:say_line("/cncc210/")
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_gesture2, 800)
    charlie:wait_for_message()
end
ch1[160] = { text = "/cnma211/", counterfeit = TRUE, first_charlie_node = TRUE }
ch1[160].off = TRUE
ch1[160].gesture = manny.line_189
ch1[160].response = function(arg1) -- line 258
    arg1.off = TRUE
    arg1.said = TRUE
    ch1.node = "exit_dialog"
    cn.pass:get()
    charlie.talked_union = TRUE
    charlie:say_line("/cncc212/")
    charlie:blend(cc_booth_idles_shake_head, cc_booth_idles_sit_pose, 800)
    charlie:wait_for_message()
    charlie:say_line("/cncc213/")
    charlie:wait_for_chore()
    charlie:blend(cc_booth_idles_gesture1, cc_booth_idles_shake_head, 800)
    charlie:wait_for_message()
    manny:blend(mc_booth_idles_line190, mc_booth_idles_line189, 500)
    manny:say_line("/cnma214/")
    manny:wait_for_message()
    charlie:say_line("/cncc215/")
    charlie:wait_for_message()
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_line190, 300)
    charlie:say_line("/cncc216/")
    charlie:wait_for_chore()
    charlie:blend(cc_booth_idles_nod, cc_booth_idles_gesture1, 800)
    charlie:wait_for_message()
    charlie:say_line("/cncc217/")
    charlie:wait_for_chore()
    charlie:blend(cc_booth_idles_stare, cc_booth_idles_nod, 500)
    charlie:wait_for_message()
    manny:say_line("/cnma218/")
    manny:wait_for_message()
    charlie:say_line("/cncc219/")
    charlie:blend(cc_booth_idles_smoke_shake, cc_booth_idles_stare, 800)
    charlie:wait_for_message()
    charlie:say_line("/cncc220/")
    charlie:blend(cc_booth_idles_burst, cc_booth_idles_smoke_shake, 500)
    charlie:wait_for_message()
    charlie:say_line("/cncc221/")
    charlie:blend(cc_booth_idles_line221, cc_booth_idles_burst, 500)
    sleep_for(4500)
    manny:stop_chore(mc_booth_idles_sit_pose)
    manny:play_chore(mc_booth_idles_miss_pass)
    charlie:wait_for_chore()
    charlie:wait_for_message()
    charlie:say_line("/cncc222/")
    charlie:blend(cc_booth_idles_line222, cc_booth_idles_line221, 500)
    manny:play_chore(mc_booth_idles_miss_pass)
    charlie:wait_for_chore()
    charlie:wait_for_message()
    charlie:say_line("/cncc223/")
    charlie:blend(cc_booth_idles_line223, cc_booth_idles_line222, 500)
    charlie:wait_for_chore()
    manny:play_chore(mc_booth_idles_miss_pass)
    charlie:wait_for_message()
    manny:say_line("/cnma224/")
    manny:wait_for_message()
    charlie:say_line("/cncc225/")
    charlie:blend(cc_booth_idles_line225, cc_booth_idles_line223, 500)
    sleep_for(2600)
    manny:play_chore(mc_booth_idles_miss_pass)
    charlie:wait_for_chore()
    charlie:wait_for_message()
    manny:stop_chore(mc_booth_idles_miss_pass)
    manny:play_chore(mc_booth_idles_take_pass)
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_line225, 800)
    manny:wait_for_chore()
    manny:blend(mc_booth_idles_sit_pose, mc_booth_idles_take_pass, 800)
    sleep_for(800)
    cc_246 = FALSE
end
ch1.exit_lines.counterfeit = { text = "/cnma226/", counterfeit = TRUE }
ch1.exit_lines.counterfeit.response = function(arg1) -- line 329
    ch1.node = "first_charlie_node"
    charlie:blend(cc_booth_idles_shake_head, cc_booth_idles_sit_pose, 800)
    charlie:say_line("/cncc227/")
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_shake_head, 800)
    charlie:wait_for_chore(cc_booth_idles_sit_pose)
end
ch1.aborts.counterfeit = function(arg1) -- line 338
    ch1[130].off = TRUE
    ch1:execute_line(ch1.exit_lines.counterfeit)
end
ch1[180] = { text = "/cnma228/", first_charlie_node = TRUE }
ch1[180].response = function(arg1) -- line 345
    arg1.off = TRUE
    ch1.node = "slot_machines"
    ch1[190].off = FALSE
    ch1[200].off = FALSE
    ch1[210].off = FALSE
    ch1[220].off = FALSE
    charlie:say_line("/cncc229/")
    charlie:blend(cc_booth_idles_smoke_shake, cc_booth_idles_sit_pose, 800)
    charlie:wait_for_message()
    charlie:say_line("/cncc230/")
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_smoke_shake, 800)
    charlie:wait_for_message()
    charlie:say_line("/cncc231/")
    charlie:blend(cc_booth_idles_nod, cc_booth_idles_sit_pose, 500)
    charlie:wait_for_chore(cc_booth_idles_nod)
    charlie:blend(cc_booth_idles_gesture2, cc_booth_idles_nod, 500)
    charlie:wait_for_chore(cc_booth_idles_gesture2)
    charlie:blend(cc_booth_idles_nod, cc_booth_idles_gesture2, 500)
    charlie:wait_for_chore(cc_booth_idles_nod)
    charlie:wait_for_message()
    charlie:say_line("/cncc232/")
    charlie:blend(cc_booth_idles_explain_loop, cc_booth_idles_nod, 500)
    charlie:wait_for_chore(cc_booth_idles_explain_loop)
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_explain_loop, 800)
    charlie:wait_for_message()
end
ch1[190] = { text = "/cnma233/", slot_machines = TRUE }
ch1[190].off = TRUE
ch1[190].response = function(arg1) -- line 375
    arg1.off = TRUE
    ch1.node = "first_charlie_node"
    charlie:blend(cc_booth_idles_gesture2, cc_booth_idles_sit_pose, 800)
    charlie:say_line("/cncc234/")
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_gesture2, 800)
end
ch1[200] = { text = "/cnma235/", slot_machines = TRUE, first_charlie_node = TRUE }
ch1[200].off = TRUE
ch1[200].response = function(arg1) -- line 386
    arg1.off = TRUE
    ch1.node = "first_charlie_node"
    charlie:blend(cc_booth_idles_nod, cc_booth_idles_sit_pose, 800)
    charlie:say_line("/cncc236/")
    charlie:wait_for_message()
    manny:say_line("/cnma237/")
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_nod, 800)
end
ch1[210] = { text = "/cnma238/", slot_machines = TRUE, first_charlie_node = TRUE }
ch1[210].off = TRUE
ch1[210].response = function(arg1) -- line 398
    arg1.off = TRUE
    ch1.node = "first_charlie_node"
    charlie:say_line("/cncc239/")
    charlie:wait_for_message()
    charlie:say_line("/cncc240/")
end
ch1[220] = { text = "/cnma241/", slot_machines = TRUE, first_charlie_node = TRUE }
ch1[220].off = TRUE
ch1[220].response = function(arg1) -- line 408
    arg1.off = TRUE
    ch1.node = "first_charlie_node"
    charlie:say_line("/cncc243/")
    charlie:blend(cc_booth_idles_line188, cc_booth_idles_sit_pose, 500)
    charlie:wait_for_message()
    charlie:say_line("/cncc244/")
    charlie:blend(cc_booth_idles_line244, cc_booth_idles_line188, 800)
    charlie:wait_for_chore(cc_booth_idles_line244)
    charlie:blend(cc_booth_idles_burst, cc_booth_idles_line244, 500)
    charlie:wait_for_message()
    manny:say_line("/cnma245/")
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_burst, 800)
end
ch1.exit_lines.first_charlie_node = { text = "/cnma246/" }
ch1.exit_lines.first_charlie_node.gesture = manny.line246
ch1.exit_lines.first_charlie_node.response = function(arg1) -- line 425
    ch1.node = "exit_dialog"
    charlie:blend(cc_booth_idles_gesture1, cc_booth_idles_sit_pose, 800)
    if charlie.talked_union then
        charlie:say_line("/cncc247/")
    else
        charlie:say_line("/cncc248/")
    end
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_gesture1, 800)
    cc_246 = TRUE
end
ch1[230] = { text = "/cnma250/", first_charlie_node = TRUE }
ch1[230].response = function(arg1) -- line 439
    arg1.off = TRUE
    charlie:blend(cc_booth_idles_smoke_shake, cc_booth_idles_sit_pose, 800)
    charlie:say_line("/cncc251/")
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_nod, cc_booth_idles_smoke_shake, 800)
    charlie:say_line("/cncc252/")
    charlie:wait_for_message()
    charlie:blend(cc_booth_idles_sit_pose, cc_booth_idles_nod, 800)
end
ch1.aborts.first_charlie_node = function(arg1) -- line 452
    cn.charlie_obj.talked_out = TRUE
    ch1:execute_line(ch1.exit_lines.first_charlie_node)
end
ch1.aborts.slot_machines = function(arg1) -- line 457
    ch1:clear()
    ch1.node = "first_charlie_node"
end
ch1.outro = function(arg1) -- line 463
    stop_script(manny.head_follow_mesh)
    manny:head_look_at(nil)
    manny:print_costumes()
    if cc_246 then
        manny:blend(mc_booth_idles_outro, mc_booth_idles_line246, 800)
        manny:print_costumes()
    else
        manny:stop_chore(mc_booth_idles_sit_pose)
        manny:play_chore(mc_booth_idles_outro)
        manny:print_costumes()
    end
    manny:wait_for_chore(mc_booth_idles_outro, "mc_booth_idles.cos")
    manny:print_costumes()
    manny:pop_costume()
    manny:set_rest_chore(mc_rest, "mc.cos")
    manny:setpos(0.928359, -0.266837, 0)
    manny:setrot(0, 378.057, 0)
    manny:follow_boxes()
    cn:current_setup(cn_rulws)
    start_script(cn.charlie_idles)
end

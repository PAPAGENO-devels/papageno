CheckFirstTime("dlg_virago.lua")
vi1 = Dialog:create()
vi1.focus = hl.virago_obj
vi1.intro = function(arg1) -- line 13
    vi1.node = "first_virago_node"
    if dd.terry_arrested and not vi1[110].said then
        vi1[110].off = FALSE
    end
    if bi.seen_kiss and not vi1[280].said then
        vi1[280].off = FALSE
    end
    manny:head_look_at(hl.virago_obj)
    if vi1.joke_time then
        vi1.joke_time = FALSE
        manny:say_line("/hlma001/")
        manny:wait_for_message()
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        manny:say_line("/hlma002/")
        manny:wait_for_message()
        virago:say_line("/hlvi003/")
        virago:wait_for_chore()
        virago:wait_for_message()
        virago.down = FALSE
    elseif not vi1.introduced then
        vi1.introduced = TRUE
        manny:say_line("/hlma007/")
        manny:wait_for_message()
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        manny:say_line("/hlma008/")
        manny:wait_for_message()
        virago:say_line("/hlvi009/")
        virago:wait_for_chore()
        virago.down = FALSE
    else
        manny:say_line("/hlma010/")
        manny:wait_for_message()
        virago:say_line("/hlvi011/")
        virago.down = TRUE
    end
    if bi.seen_kiss and not vi1.talked_kiss then
        if virago.down then
            virago:stop_chore(nick_idles_pprwrk_base)
            virago:push_chore(nick_idles_pprwrk2kckbk)
            virago:push_chore()
            virago:push_chore(nick_idles_kckbk_hld)
        end
        virago:wait_for_message()
        vi1.talked_kiss = TRUE
        manny:say_line("/hlma004/")
        manny:wait_for_message()
        virago:wait_for_chore(nick_idles_kckbk_hld)
        virago:stop_chore(nick_idles_kckbk_hld)
        virago:play_chore(nick_idles_dropkey)
        sleep_for(4154)
        virago:say_line("/hlvi005/")
        sleep_for(12906)
        virago:say_line("/hlvi006/")
        sleep_for(2200)
        cigcase_actor:set_visibility(TRUE)
        hl.case.interest_actor:put_in_set(hl)
        hl.case:make_touchable()
        hl.nicks_papers:make_untouchable()
        manny:wait_for_message()
        virago:wait_for_chore()
        virago.down = FALSE
    end
end
vi1[100] = { text = "/hlma012/", first_virago_node = TRUE }
vi1[100].response = function(arg1) -- line 91
    arg1.off = TRUE
    vi1[240].off = FALSE
    vi1.node = "trouble_node"
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:stop_chore(nick_idles_kckbk_hld)
        virago:push_chore(nick_idles_kckbk_nod)
        virago:push_chore()
    end
    if not vi1.talked_lawyer then
        vi1.talked_lawyer = TRUE
        virago:say_line("/hlvi013/")
    else
        virago:say_line("/hlvi014/")
    end
end
vi1[110] = { text = "/hlma015/", trouble_node = TRUE }
vi1[110].off = TRUE
vi1[110].response = function(arg1) -- line 117
    arg1.said = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    end
    virago:say_line("/hlvi016/")
    vi1:good_question()
end
vi1[120] = { text = "/hlma017/", trouble_node = TRUE }
vi1[120].response = function(arg1) -- line 134
    arg1.off = TRUE
    vi1.node = "exit_dialog"
    virago:say_line("/hlvi018/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[130] = { text = "/hlma019/", trouble_node = TRUE }
vi1[130].response = function(arg1) -- line 148
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:stop_chore(nick_idles_kckbk_hld)
        virago:push_chore(nick_idles_kckbk_nod)
        virago:push_chore()
    end
    virago:say_line("/hlvi020/")
    virago:wait_for_message()
    manny:say_line("/hlma021/")
    vi1:good_question()
end
vi1[140] = { text = "/hlma022/", trouble_node = TRUE }
vi1[140].response = function(arg1) -- line 170
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:push_chore(nick_idles_smoke)
        virago:push_chore()
    end
    virago:say_line("/hlvi023/")
    virago:wait_for_message()
    manny:say_line("/hlma024/")
    manny:wait_for_message()
    virago:say_line("/hlvi025/")
    vi1:good_question()
end
vi1[150] = { text = "/hlma026/", trouble_node = TRUE }
vi1[150].response = function(arg1) -- line 194
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:push_chore(nick_idles_smoke)
        virago:push_chore()
    end
    virago:say_line("/hlvi027/")
    virago:wait_for_message()
    manny:push_costume("mc_tap_head.cos")
    manny:play_chore(0)
    manny:say_line("/hlma028/")
    manny:wait_for_message()
    manny:say_line("/hlma029/")
    manny:wait_for_message()
    manny:wait_for_chore()
    manny:pop_costume()
    virago:say_line("/hlvi030/")
    virago:push_chore(nick_idles_kckbk_nod)
    vi1:good_question()
end
vi1.good_question = function() -- line 224
    vi1.node = "good_node"
    manny:wait_for_message()
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
    end
    if vi1.asked_good then
        virago:say_line("/hlvi031/")
        virago:wait_for_message()
    else
        vi1.asked_good = TRUE
    end
    virago:say_line("/hlvi032/")
    virago:wait_for_message()
    virago:wait_for_chore()
end
vi1[160] = { text = "/hlma034/", good_node = TRUE }
vi1[160].response = function(arg1) -- line 247
    vi1.node = "exit_dialog"
    virago:say_line("/hlvi035/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[170] = { text = "/hlma036/", good_node = TRUE }
vi1[170].response = function(arg1) -- line 260
    vi1.node = "excellent_node"
    virago:say_line("/hlvi037/")
end
vi1[180] = { text = "/hlma038/", excellent_node = TRUE }
vi1[180].response = function(arg1) -- line 266
    virago:say_line("/hlvi039/")
    virago:wait_for_message()
    manny:say_line("/hlma040/")
    manny:wait_for_message()
    vi1[190]:response()
end
vi1[190] = { text = "/hlma041/", excellent_node = TRUE }
vi1[190].response = function(arg1) -- line 275
    vi1.node = "best_node"
    virago:say_line("/hlvi042/")
    virago:wait_for_message()
    virago:say_line("/hlvi043/")
end
vi1[200] = { text = "/hlma044/", best_node = TRUE }
vi1[200].response = function(arg1) -- line 283
    vi1.node = "exit_dialog"
    vi1.refused_already = TRUE
    virago:push_chore(nick_idles_smoke)
    virago:say_line("/hlvi045/")
    virago:wait_for_message()
    virago:say_line("/hlvi046/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[210] = { text = "/hlma047/", best_node = TRUE }
vi1[210].response = function(arg1) -- line 302
    arg1.off = TRUE
    vi1.node = "exit_dialog"
    vi1.joke_time = TRUE
    virago:say_line("/hlvi048/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:push_chore(nick_idles_kckbk_nod)
    virago:push_chore()
    virago:wait_for_message()
    virago:say_line("/hlvi049/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_message()
    virago:say_line("/hlvi050/")
    virago:wait_for_message()
    virago:say_line("/hlvi051/")
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[220] = { text = "/hlma052/", best_node = TRUE }
vi1[220].response = function(arg1) -- line 327
    arg1.off = TRUE
    vi1.node = "exit_dialog"
    virago:say_line("/hlvi053/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[230] = { text = "/hlma054/", best_node = TRUE }
vi1[230].response = function(arg1) -- line 342
    vi1.node = "exit_dialog"
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    end
    hl:current_setup(0)
    virago:say_line("/hlvi055/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_message()
    virago:say_line("/hlvi056/")
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    manny:head_look_at(nil)
end
vi1[240] = { text = "/hlma057/", first_virago_node = TRUE }
vi1[240].off = TRUE
vi1[240].response = function(arg1) -- line 369
    if virago.down then
        virago.down = FALSE
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
    else
        virago:push_chore(nick_idles_kckbk_nod)
        virago:push_chore()
    end
    if vi1.refused_already then
        vi1.node = "threats_node"
        virago:say_line("/hlvi058/")
    else
        vi1.node = "trouble_node"
        virago:say_line("/hlvi059/")
    end
    virago:wait_for_chore()
end
vi1[250] = { text = "/hlma060/", threats_node = TRUE }
vi1[250].response = function(arg1) -- line 394
    arg1.off = TRUE
    virago:say_line("/hlvi061/")
end
vi1[260] = { text = "/hlma062/", threats_node = TRUE }
vi1[260].response = function(arg1) -- line 400
    arg1.off = TRUE
    virago:say_line("/hlvi063/")
    virago:push_chore(nick_idles_smoke)
    virago:wait_for_message()
    virago:say_line("/hlvi064/")
end
vi1[270] = { text = "/hlma065/", threats_node = TRUE }
vi1[270].response = function(arg1) -- line 410
    arg1.off = TRUE
    virago:say_line("/hlvi066/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:push_chore(nick_idles_tap_loop)
    virago:push_chore()
    virago:push_chore(nick_idles_tap_loop)
    virago:push_chore()
    virago:wait_for_message()
    virago:say_line("/hlvi067/")
end
vi1[280] = { text = "/hlma068/", threats_node = TRUE }
vi1[280].off = TRUE
vi1[280].response = function(arg1) -- line 424
    arg1.off = TRUE
    arg1.said = TRUE
    vi1.node = "exit_dialog"
    vi1.tried_blackmail = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:run_chore(nick_idles_pprwrk2kckbk)
        virago:run_chore(nick_idles_kckbk_hld)
    end
    virago:say_line("/hlvi069/")
    virago:wait_for_message()
    virago:say_line("/hlvi070/")
    virago:wait_for_message()
    virago:push_chore(nick_idles_smoke)
    virago:push_chore()
    virago:push_chore(nick_idles_tap_loop)
    virago:push_chore()
    virago:push_chore(nick_idles_tap_loop)
    virago:push_chore()
    manny:say_line("/hlma071/")
    manny:wait_for_message()
    virago:say_line("/hlvi072/")
    virago:wait_for_message()
    virago:say_line("/hlvi073/")
    virago:wait_for_message()
    virago:say_line("/hlvi074/")
    virago:wait_for_message()
    virago:say_line("/hlvi075/")
    virago:wait_for_message()
    start_script(hl.nick_leaves)
end
vi1[290] = { text = "/hlma076/", threats_node = TRUE }
vi1[290].response = function(arg1) -- line 460
    arg1.off = TRUE
    vi1.node = "exit_dialog"
    virago:say_line("/hlvi077/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1[300] = { text = "/hlma078/", first_virago_node = TRUE }
vi1[300].response = function(arg1) -- line 474
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:stop_chore(nick_idles_pprwrk_base)
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:stop_chore(nick_idles_kckbk_hld)
        virago:push_chore(nick_idles_kckbk_nod)
        virago:push_chore()
    end
    virago:say_line("/hlvi079/")
end
vi1[310] = { text = "/hlma080/", first_virago_node = TRUE }
vi1[310].response = function(arg1) -- line 493
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:push_chore(nick_idles_tap_loop)
        virago:push_chore()
        virago:push_chore(nick_idles_tap_loop)
        virago:push_chore()
        virago:push_chore(nick_idles_smoke)
        virago:push_chore()
    end
    virago:say_line("/hlvi081/")
    virago:wait_for_message()
    manny:say_line("/hlma082/")
    manny:wait_for_message()
    virago:say_line("/hlvi083/")
    virago:wait_for_message()
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:push_chore(nick_idles_kckbk_nod)
    virago:push_chore()
    virago:say_line("/hlvi084/")
    virago:wait_for_chore()
end
vi1[320] = { text = "/hlma085/", first_virago_node = TRUE }
vi1[320].response = function(arg1) -- line 525
    arg1.off = TRUE
    if virago.down then
        virago.down = FALSE
        virago:push_chore(nick_idles_pprwrk2kckbk)
        virago:push_chore()
        virago:push_chore(nick_idles_kckbk_hld)
        virago:wait_for_chore()
    else
        virago:push_chore(nick_idles_kckbk_nod)
        virago:push_chore()
    end
    virago:say_line("/hlvi086/")
end
vi1.exit_lines.first_virago_node = { text = "/hlma087/" }
vi1.exit_lines.first_virago_node.response = function(arg1) -- line 543
    vi1.node = "exit_dialog"
    virago:say_line("/hlvi088/")
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1.aborts.first_virago_node = function(arg1) -- line 555
    vi1:clear()
    vi1.node = "exit_dialog"
    virago:stop_chore(nick_idles_kckbk_hld)
    virago:play_chore(nick_idles_2pprwrk)
    virago:wait_for_chore()
    virago:stop_chore(nick_idles_2pprwrk)
    start_script(hl.virago_idles)
    hl:current_setup(0)
    manny:head_look_at(nil)
end
vi1.aborts.trouble_node = function(arg1) -- line 567
    if vi1.current_choices[1] then
        vi1:execute_line(vi1.current_choices[1])
    else
        vi1:clear()
        vi1.node = "exit_dialog"
        virago:say_line("/hlvi089/")
        virago:wait_for_message()
        virago:say_line("/hlvi090/")
        virago:wait_for_message()
        virago:say_line("/hlvi091/")
        virago:wait_for_message()
        virago:say_line("/hlvi092/")
        hl:current_setup(0)
    end
    manny:head_look_at(nil)
end
vi1.aborts.threats_node = function(arg1) -- line 585
    if vi1.current_choices[1] then
        vi1:execute_line(vi1.current_choices[1])
    else
        vi1:clear()
        vi1.node = "exit_dialog"
        virago:say_line("/hlvi093/")
        virago:stop_chore(nick_idles_kckbk_hld)
        virago:play_chore(nick_idles_2pprwrk)
        virago:wait_for_chore()
        virago:stop_chore(nick_idles_2pprwrk)
        start_script(hl.virago_idles)
        hl:current_setup(0)
        manny:head_look_at(nil)
    end
end

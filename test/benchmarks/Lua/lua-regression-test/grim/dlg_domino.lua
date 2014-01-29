CheckFirstTime("dlg_domino.lua")
do1 = Dialog:create()
do1.talk_domino_count = 0
do1.intro = function(arg1) -- line 8
    do1.node = "first_domino_node"
    break_here()
    dom:current_setup(do_dorws)
    break_here()
    do1.exit_lines.first_domino_node = fdn_exit_1
    if not domino.met then
        domino.met = TRUE
        manny:say_line("/doma001/")
        manny:tilt_head_gesture()
        sleep_for(500)
        if do1[5].said then
            start_script(domino.face_manny, domino, TRUE)
        end
        wait_for_message()
        domino:say_line("/dodo002/")
    else
        do1.talk_domino_count = do1.talk_domino_count + 1
        manny:say_line("/doma003/")
        manny:head_forward_gesture()
        sleep_for(500)
        if do1.talk_domino_count < 3 and do1[5].said then
            start_script(domino.face_manny, domino, FALSE)
        end
        sleep_for(1500)
        wait_for_message()
        domino:say_line("/dodo004/")
    end
    wait_for_message()
end
do1[5] = { text = "/doma005/", first_domino_node = TRUE, gesture = manny.hand_gesture }
do1[5].response = function(arg1) -- line 46
    arg1.off = TRUE
    arg1.said = TRUE
    do1.node = "bruno_node"
    if not domino.facing_manny then
        start_script(domino.face_manny, domino, TRUE)
    end
    sleep_for(500)
    domino:say_line("/dodo006/")
    wait_for_message()
    sleep_for(1000)
    manny:tilt_head_gesture()
    wait_for_script(domino.face_manny)
    domino:say_line("/dodo007/")
    wait_for_message()
    manny:say_line("/doma008/")
    manny:point_gesture()
    wait_for_message()
    domino:say_line("/dodo009/")
    wait_for_message()
    manny:say_line("/doma010/")
    manny:twist_head_gesture()
    wait_for_message()
    domino:say_line("/dodo011/")
    wait_for_message()
    domino:face_bag()
    domino:say_line("/dodo012/")
end
do1[10] = { text = "/doma013/", first_domino_node = TRUE }
do1[10].response = function(arg1) -- line 76
    asked_questions = TRUE
    do1[10].text = "/doma014/"
    do1.node = "question_domino_node"
    do1.exit_lines.question_domino_node = qdn_exit_1
    domino:say_line("/dodo015/")
end
do1[20] = { text = "/doma016/", first_domino_node = TRUE, gesture = manny.nod_gesture }
do1[20].response = function(arg1) -- line 85
    do1.node = "tell_domino_node"
    do1.exit_lines.tell_domino_node = tdn_exit_1
    if made_statements then
        domino:say_line("/dodo017/")
    else
        made_statements = TRUE
        do1[20].text = "/doma018/"
        domino:say_line("/dodo019/")
        wait_for_message()
        domino:say_line("/dodo020/")
    end
end
do1[30] = { text = "/doma021/", first_domino_node = TRUE, gesture = manny.point_gesture }
do1[30].response = function(arg1) -- line 100
    do1[30].off = TRUE
    do1[40].off = FALSE
    domino:say_line("/dodo022/")
end
do1[40] = { text = "/doma024/", first_domino_node = TRUE, off = TRUE, gesture = manny.shrug_gesture }
do1[40].response = function(arg1) -- line 109
    arg1.off = TRUE
    domino:say_line("/dodo025/")
    wait_for_message()
    domino:say_line("/dodo026/")
end
do1[50] = { text = "/doma027/", first_domino_node = TRUE, gesture = manny.twist_head_gesture }
do1[50].response = function(arg1) -- line 118
    arg1.off = TRUE
    domino:say_line("/dodo028/")
    wait_for_message()
    domino:say_line("/dodo029/")
end
fdn_exit_1 = { text = "/doma030/", gesture = manny.hand_gesture }
fdn_exit_1.setup = function(arg1) -- line 126
    do1.exit_lines.first_domino_node = fdn_exit_2
end
fdn_exit_1.response = function(arg1) -- line 129
    do1.node = "exit_dialog"
    domino:say_line("/dodo031/")
    if domino.facing_manny then
        start_script(domino.face_bag, domino)
    end
    wait_for_message()
    domino:say_line("/dodo032/")
end
fdn_exit_2 = { text = "/doma033/", gesture = manny.hand_gesture }
fdn_exit_2.response = fdn_exit_1.response
do1.aborts.first_domino_node = function(arg1) -- line 142
    do1:clear()
    do1.node = "end_dialog"
    manny:say_line("/doma034/")
    manny:nod_head_gesture()
    wait_for_message()
    domino:say_line("/dodo035/")
end
do1.outro = function() -- line 151
    domino:play_chore(dominoboxing_to_box)
    domino:wait_for_chore()
    domino:play_chore_looping(dominoboxing_boxing)
end
do1[50] = { text = "/doma036/", question_domino_node = TRUE, gesture = manny.point_gesture }
do1[50].off = TRUE
do1[50].response = function(arg1) -- line 160
    arg1.off = TRUE
    domino:say_line("/dodo037/")
    wait_for_message()
    domino:say_line("/dodo038/")
end
do1[60] = { text = "/doma039/", question_domino_node = TRUE, gesture = manny.shrug_gesture }
do1[60].response = function(arg1) -- line 168
    arg1.off = TRUE
    domino:say_line("/dodo040/")
    wait_for_message()
    domino:say_line("/dodo041/")
end
do1[70] = { text = "/doma042/", question_domino_node = TRUE, gesture = manny.point_gesture }
do1[70].response = function(arg1) -- line 176
    arg1.off = TRUE
    domino:say_line("/dodo043/")
    wait_for_message()
    domino:say_line("/dodo044/")
    wait_for_message()
    manny:say_line("/doma045/")
    wait_for_message()
    manny:say_line("/doma046/")
    manny:head_forward_gesture()
end
do1[80] = { text = "/doma047/", question_domino_node = TRUE, gesture = manny.shrug_gesture }
do1[80].response = function(arg1) -- line 189
    arg1.off = TRUE
    domino:say_line("/dodo048/")
    wait_for_message()
    domino:say_line("/dodo049/")
    wait_for_message()
    manny:say_line("/doma050/")
    manny:twist_head_gesture()
end
do1[90] = { text = "/doma051/", question_domino_node = TRUE }
do1[90].response = function(arg1) -- line 200
    arg1.off = TRUE
    domino:say_line("/dodo052/")
    wait_for_message()
    manny:say_line("/doma053/")
    manny:twist_head_gesture()
    wait_for_message()
    manny:say_line("/doma054/")
    sleep_for(2000)
    manny:hand_gesture()
    wait_for_message()
    domino:say_line("/dodo055/")
    wait_for_message()
    manny:say_line("/doma056/")
    manny:shrug_gesture()
    wait_for_message()
    domino:say_line("/dodo057/")
end
qdn_exit_1 = { text = "/doma058/" }
qdn_exit_1.setup = function(arg1) -- line 220
    do1.exit_lines.question_domino_node = qdn_exit_2
end
qdn_exit_1.response = function(arg1) -- line 223
    do1.node = "first_domino_node"
    if domino.facing_manny then
        start_script(domino.face_bag, domino)
    end
    domino:say_line("/dodo059/")
    wait_for_message()
    domino:say_line("/dodo060/")
    sleep_for(500)
    wait_for_script(domino.face_bag)
    if not domino.facing_manny then
        start_script(domino.face_manny, domino)
    end
    wait_for_message()
    sleep_for(1000)
    domino:say_line("/dodo061/")
    wait_for_message()
    wait_for_script(domino.face_manny)
    domino:say_line("/dodo062/")
    sleep_for(1000)
    domino:face_bag()
end
qdn_exit_2 = { text = "/doma063/" }
qdn_exit_2.response = function(arg1) -- line 247
    do1.node = "first_domino_node"
    domino:say_line("/dodo064/")
end
do1.aborts.question_domino_node = function(arg1) -- line 261
    do1:clear()
    do1[10].off = TRUE
    do1.node = "first_domino_node"
end
do1[110] = { text = "/doma065/", tell_domino_node = TRUE, gesture = manny.nod_head_gesture }
do1[110].response = function(arg1) -- line 268
    arg1.off = TRUE
    do1[120].off = FALSE
    domino:say_line("/dodo066/")
    wait_for_message()
    domino:say_line("/dodo067/")
end
do1[120] = { text = "/doma068/", tell_domino_node = TRUE, off = TRUE }
do1[120].response = function(arg1) -- line 281
    arg1.off = TRUE
    domino:say_line("/dodo069/")
end
do1[130] = { text = "/doma070/", tell_domino_node = TRUE, gesture = manny.head_forward_gesture }
do1[130].response = function(arg1) -- line 287
    arg1.off = TRUE
    domino:say_line("/dodo071/")
    wait_for_message()
    domino:say_line("/dodo072/")
end
do1[140] = { text = "/doma073/", tell_domino_node = TRUE, gesture = manny.tilt_head_gesture }
do1[140].response = function(arg1) -- line 295
    arg1.off = TRUE
    domino:say_line("/dodo074/")
    wait_for_message()
    domino:say_line("/dodo075/")
    wait_for_message()
    manny:say_line("/doma076/")
    manny:twist_head_gesture()
    wait_for_message()
    manny:stop_chore(nil, "manny_gestures.cos")
    manny:say_line("/doma077/")
end
tdn_exit_1 = { text = "/doma078/", gesture = manny.twist_head_gesture }
tdn_exit_1.setup = function(arg1) -- line 309
    do1.exit_lines.tell_domino_node = tdn_exit_2
end
tdn_exit_1.response = function(arg1) -- line 312
    do1.node = "first_domino_node"
    domino:say_line("/dodo079/")
end
tdn_exit_2 = { text = "/doma080/", gesture = manny.nod_head_gesture }
tdn_exit_2.response = tdn_exit_1.response
do1.aborts.tell_domino_node = function(arg1) -- line 320
    do1:clear()
    do1.node = "first_domino_node"
    do1[20].off = TRUE
end
do1[200] = { text = "/doma081/", bruno_node = TRUE, gesture = manny.nod_head_gesture }
do1[200].response = function(arg1) -- line 327
    do1.node = "first_domino_node"
    domino:say_line("/dodo082/")
    wait_for_message()
    manny:say_line("/doma083/")
    manny:shrug_gesture()
    sleep_for(3000)
    manny:tilt_head_gesture()
end
do1[210] = { text = "/doma084/", bruno_node = TRUE, gesture = manny.nod_head_gesture }
do1[210].response = function(arg1) -- line 338
    do1.node = "first_domino_node"
    domino:say_line("/dodo085/")
    wait_for_message()
    manny:say_line("/doma086/")
end
do1[220] = { text = "/doma087/", bruno_node = TRUE, gesture = manny.twist_head_gesture }
do1[220].response = function(arg1) -- line 346
    do1.node = "first_domino_node"
    domino:say_line("/dodo088/")
end
do1[230] = { text = "/doma090/", bruno_node = TRUE, gesture = manny.twist_head_gesture }
do1[230].response = function(arg1) -- line 354
    do1.node = "first_domino_node"
    domino:say_line("/dodo091/")
    wait_for_message()
    domino:say_line("/dodo092/")
end
do1.outro = function(arg1) -- line 361
    do1.hold_button_handler = SampleButtonHandler
    if domino.facing_manny then
        wait_for_script(domino.face_manny)
        domino:face_bag()
    end
    dom:force_camerachange()
end
do1[999] = "EOD"

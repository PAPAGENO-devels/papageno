CheckFirstTime("dlg_glot2.lua")
gl2 = Dialog:create()
gl2.execute_line = function(arg1, arg2) -- line 11
    if not ci.glottis_obj.looking_up then
        start_script(ci.glottis_obj.lookUp, ci.glottis_obj)
    end
    Dialog.execute_line(gl2, arg2)
end
gl2.intro = function(arg1) -- line 18
    gl2.node = "first_glot_node"
    if cn.pass.owner == manny then
        gl2[80].off = FALSE
    end
    if meche.shanghaid then
        gl2[110].off = TRUE
        gl2[140].off = TRUE
        if not gl2[100].said then
            gl2[100].off = FALSE
        end
    end
    if ci.sung_rusty_anchor and not gl2[90].said then
        gl2[90].off = FALSE
    end
    if bogen.pissed and not gl2.talked_bogen then
        gl2.talked_bogen = TRUE
        glottis:say_line("/cigl067/")
        wait_for_message()
        glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
        glottis:say_line("/cigl068/")
        wait_for_message()
        manny:say_line("/cima069/")
        wait_for_message()
        manny:say_line("/cima070/")
        wait_for_message()
        glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
        glottis:say_line("/cigl071/")
        wait_for_message()
        manny:say_line("/cima072/")
    end
end
gl2[80] = { text = "/cima001/", first_glot_node = TRUE }
gl2[80].off = TRUE
gl2[80].response = function(arg1) -- line 53
    arg1.off = TRUE
    gl2.node = "exit dialog"
    ci.said_check_out = TRUE
    start_script(ci.give_pass)
end
gl2[90] = { text = "/cima073/", first_glot_node = TRUE }
gl2[90].off = TRUE
gl2[90].response = function(arg1) -- line 62
    arg1.off = TRUE
    wait_for_message()
    glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
    glottis:say_line("/cigl074/")
    wait_for_message()
    glottis:say_line("/cigl075/")
    wait_for_message()
    glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
    glottis:say_line("/cigl076/")
    wait_for_message()
    manny:say_line("/cima077/")
    wait_for_message()
    glottis:say_line("/cigl078/")
end
gl2[100] = { text = "/cima079/", first_glot_node = TRUE }
gl2[100].off = TRUE
gl2[100].response = function(arg1) -- line 80
    arg1.off = TRUE
    glottis:say_line("/cigl080/")
    wait_for_message()
    manny:say_line("/cima081/")
    wait_for_message()
    manny:say_line("/cima082/")
    wait_for_message()
    glottis:say_line("/cigl083/")
    wait_for_message()
    manny:say_line("/cima084/")
    wait_for_message()
    glottis:say_line("/cigl085/")
    glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl086/")
    wait_for_message()
    glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
    glottis:say_line("/cigl087/")
end
gl2[110] = { text = "/cima088/", first_glot_node = TRUE }
gl2[110].response = function(arg1) -- line 103
    arg1.off = TRUE
    glottis:say_line("/cigl089/")
    sleep_for(750)
    glottis:run_chore(glottis_piano_turnhead, "glottis_piano.cos")
    glottis:run_chore(glottis_piano_turnhead, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl090/")
    wait_for_message()
    glottis:say_line("/cigl091/")
    glottis:run_chore(glottis_piano_091, "glottis_piano.cos")
end
gl2[120] = { text = "/cima092/", first_glot_node = TRUE }
gl2[120].response = function(arg1) -- line 117
    arg1.off = TRUE
    gl2.special_lady = TRUE
    gl2[130].off = FALSE
    glottis:say_line("/cigl093/")
    wait_for_message()
    glottis:say_line("/cigl094/")
    glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl095/")
    sleep_for(750)
    glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
end
gl2[130] = { text = "/cima096/", first_glot_node = TRUE }
gl2[130].off = TRUE
gl2[130].response = function(arg1) -- line 133
    arg1.off = TRUE
    glottis:say_line("/cigl097/")
    wait_for_message()
    music_state:set_sequence(seqGlottSingBone)
    glottis:say_line("/cigl098/")
    glottis:run_chore(glottis_piano_098, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl099/")
    glottis:run_chore(glottis_piano_099a, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl100/")
    glottis:run_chore(glottis_piano_099b, "glottis_piano.cos")
    wait_for_message()
    manny:say_line("/cima101/")
end
gl2[140] = { text = "/cima102/", first_glot_node = TRUE }
gl2[140].response = function(arg1) -- line 151
    arg1.off = TRUE
    if gl2.special_lady then
        glottis:say_line("/cigl103/")
        wait_for_message()
        manny:say_line("/cima104/")
        wait_for_message()
    end
    glottis:say_line("/cigl105/")
    glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl106/")
    wait_for_message()
    glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
    glottis:say_line("/cigl107/")
end
gl2[150] = { text = "/cima108/", first_glot_node = TRUE }
gl2[150].response = function(arg1) -- line 169
    arg1.off = TRUE
    glottis:say_line("/cigl109/")
    glottis:run_chore(glottis_piano_091, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl110/")
    wait_for_message()
    glottis:say_line("/cigl111/")
    glottis:play_chore(glottis_piano_turn_head_back, "glottis_piano.cos")
    wait_for_message()
    glottis:say_line("/cigl112/")
    glottis:play_chore(glottis_piano_112, "glottis_piano.cos")
    wait_for_message()
    glottis:play_chore(glottis_piano_turn_head, "glottis_piano.cos")
    manny:say_line("/cima113/")
    wait_for_message()
    manny:say_line("/cima114/")
    wait_for_message()
    glottis:say_line("/cigl115/")
    glottis:run_chore(glottis_piano_turnhead, "glottis_piano.cos")
    glottis:run_chore(glottis_piano_turnhead, "glottis_piano.cos")
end
gl2.exit_lines.first_glot_node = { text = "/cima116/" }
gl2.exit_lines.first_glot_node.response = function(arg1) -- line 193
    gl2.node = "exit_dialog"
    glottis:say_line("/cigl117/")
end
gl2.aborts.first_glot_node = function(arg1) -- line 198
    gl2:clear()
    gl2.node = "exit_dialog"
    if not gl2.talked_out then
        gl2.talked_out = TRUE
        manny:say_line("/cima118/")
        wait_for_message()
        glottis:say_line("/cigl119/")
        sleep_for(3000)
        glottis:run_chore(glottis_piano_091, "glottis_piano.cos")
        wait_for_message()
    else
        manny:say_line("/cima121/")
        wait_for_message()
        glottis:say_line("/cigl122/")
    end
end
gl2.outro = function(arg1) -- line 217
    if ci.glottis_obj.looking_up then
        start_script(ci.glottis_obj.lookDn, ci.glottis_obj)
    end
end

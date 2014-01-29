CheckFirstTime("dlg_glot3.lua")
gl3 = Dialog:create()
gl3.intro = function(arg1) -- line 10
    if glottis.fainted then
        gl3.node = "exit_dialog"
        manny:say_line("/myma073/")
        manny:wait_for_message()
        manny:shrug_gesture()
        manny:say_line("/myma074/")
        manny:wait_for_message()
        glottis:say_line("/mygl052/")
        glottis:wait_for_message()
    else
        my:mechanics_kill_idles()
        if not my.said_sorry then
            my.said_sorry = TRUE
            manny:hand_gesture()
            manny:say_line("/myma075/")
            manny:wait_for_message()
            glottis:say_line("/mygl076/")
        end
    end
end
gl3[100] = { text = "/myma077/", n1 = TRUE, gesture = manny.twist_head_gesture }
gl3[100].response = function(arg1) -- line 40
    arg1.off = TRUE
    glottis:say_line("/mygl078/")
    wait_for_message()
    glottis:say_line("/mygl079/")
end
gl3[105] = { text = "/myma080/", n1 = TRUE, gesture = manny.tilt_head_gesture }
gl3[105].response = function(arg1) -- line 48
    arg1.off = TRUE
    glottis:say_line("/mygl081/")
end
gl3[110] = { text = "/myma082/", n1 = TRUE, gesture = manny.hand_gesture }
gl3[110].response = function(arg1) -- line 54
    arg1.off = TRUE
    gl3[120].off = FALSE
    glottis:say_line("/mygl083/")
    wait_for_message()
    glottis:say_line("/mygl084/")
    wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/myma085/")
    wait_for_message()
    glottis:say_line("/mygl086/")
end
gl3[125] = { text = "/myma101/", n1 = TRUE, gesture = manny.twist_head_gesture }
gl3[125].response = function(arg1) -- line 68
    arg1.off = TRUE
    glottis:say_line("/mygl102/")
    glottis:wait_for_message()
    glottis:say_line("/mygl103/")
end
gl3[120] = { text = "/myma087/", n1 = TRUE, gesture = manny.hand_gesture }
gl3[120].off = TRUE
gl3[120].response = function(arg1) -- line 77
    glottis.fainted = TRUE
    gl3.node = "exit_dialog"
    my.blueprints:make_touchable()
    if seen_hell_train then
        stop_script(meche.w_glottis_idle)
        meche:play_chore(meche_w_gl_gl_talks, "meche_w_gl.cos")
    end
    glottis:play_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
    glottis:say_line("/mygl088/")
    glottis:wait_for_message()
    music_state:set_sequence(seqSproutAha)
    music_state:set_state(stateMT_CHEPITO)
    glottis:say_line("/mygl089/")
    glottis:wait_for_message()
    manny:setrot(0, 100, 0, TRUE)
    manny:head_look_at(my.gondola)
    manny:wait_for_actor()
    manny:shrug_gesture()
    manny:say_line("/myma090/")
    manny:wait_for_message()
    glottis:say_line("/mygl091/")
    glottis:wait_for_message()
    glottis:wait_for_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
    if seen_hell_train then
        meche:wait_for_chore(meche_w_gl_gl_talks, "meche_w_gl.cos")
        meche.w_glottis_idle = start_script(meche.new_run_idle, meche, "base", my.meche_w_glottis_table, "meche_w_gl.cos")
    end
    manny:setrot(0, 325, 0, TRUE)
    manny:head_look_at(my.glottis_obj)
    glottis:say_line("/mygl092/")
    sleep_for(500)
    mechanic1:play_chore(mechanic_idles_tip_toes)
    mechanic2:play_chore(mechanic_idles_tip_toes)
    glottis:wait_for_message()
    glottis:say_line("/mygl093/")
    glottis:wait_for_message()
    music_state:set_sequence(seqRocketIdea)
    music_state:update()
    IrisDown(320, 200, 1000)
    sleep_for(1500)
    my.blueprints:play_chore(0)
    mechanic1:setpos(-0.60037, 2.04926, 0.8)
    mechanic1:setrot(0, 350, 0)
    mechanic2:setpos(-0.11137, 2.32426, 0.8)
    mechanic2:setrot(0, 10, 0)
    my:set_up_mechanic_objects()
    IrisUp(320, 200, 1000)
    sleep_for(500)
    if seen_hell_train then
        stop_script(meche.w_glottis_idle)
        meche:play_chore(meche_w_gl_gl_talks, "meche_w_gl.cos")
    end
    glottis:play_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
    glottis:say_line("/mygl094/")
    glottis:wait_for_message()
    glottis:say_line("/mygl095/")
    glottis:wait_for_message()
    glottis:say_line("/mygl096/")
    glottis:wait_for_message()
    glottis:say_line("/mygl097/")
    glottis:wait_for_message()
    glottis:say_line("/mygl098/")
    glottis:wait_for_message()
    glottis:say_line("/mygl099/")
    glottis:wait_for_message()
    manny:tilt_head_gesture()
    manny:say_line("/myma100/")
    manny:wait_for_message()
    manny:say_line("/myma148/")
    if seen_hell_train then
        meche.w_glottis_idle = start_script(meche.new_run_idle, meche, "base", my.meche_w_glottis_table, "meche_w_gl.cos")
    end
end
gl3.aborts.n1 = function(arg1) -- line 155
    if gl3.current_choices[1] then
        gl3:execute_line(gl3.current_choices[1])
    end
end
gl3.outro = function(arg1) -- line 161
    if not glottis.frozen then
        glottis:stop_chore(gl_pass_out_talk_out, "gl_pass_out.cos")
        glottis:play_chore(gl_pass_out_passed_out, "gl_pass_out.cos")
    end
    if not glottis.fainted then
        if mechanic1.frozen then
            mechanic1:thaw(TRUE)
        end
        if mechanic2.frozen then
            mechanic2:thaw(TRUE)
        end
        mechanic1.worship_idle_script = start_script(mechanic1.new_run_idle, mechanic1, "base", my.worship_idle_table, "mechanic_idles.cos")
        mechanic2.worship_idle_script = start_script(mechanic2.new_run_idle, mechanic2, "base", my.worship_idle_table, "mechanic_idles.cos")
    end
end

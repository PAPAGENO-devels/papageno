CheckFirstTime("dlg_olivia.lua")
ol1 = Dialog:create()
ol1.focus = bi.olivia_obj
ol1.poem_count = 0
ol1.execute_line = function(arg1, arg2) -- line 14
    if arg1.current_choices[arg2] == ol1[134] then
        ol1[134].text = "/bima242/"
    end
    start_script(Dialog.execute_line, ol1, arg2)
    manny:wait_for_message()
    while olivia.last_chore ~= olivia_idles_gest do
        break_here()
    end
    single_start_script(olivia.new_run_idle, olivia, "gest", olivia.dialog_idle_table, "olivia_idles.cos")
end
ol1.display_lines = function(arg1) -- line 26
    arg1.parent.display_lines(ol1)
    while olivia.last_chore ~= olivia_idles_gest do
        break_here()
    end
    stop_script(olivia.new_run_idle)
end
ol1.intro = function(arg1) -- line 38
    ol1.node = "first_olivia_node"
    bi:current_setup(bi_olvcu)
    start_script(olivia.head_follow_mesh, olivia, manny, 6)
    manny:walk_closeto_object(bi.olivia_obj, 0.2)
end
ol1[100] = { text = "/bima224/", first_olivia_node = TRUE }
ol1[100].response = function(arg1) -- line 48
    arg1.off = TRUE
    ol1[110].off = FALSE
    olivia:say_line("/biol225/")
end
ol1[110] = { text = "/bima226/", first_olivia_node = TRUE }
ol1[110].off = TRUE
ol1[110].response = function(arg1) -- line 56
    arg1.off = TRUE
    olivia:say_line("/biol227/")
    wait_for_message()
    olivia:say_line("/biol228/")
end
ol1[120] = { text = "/bima229/", first_olivia_node = TRUE }
ol1[120].response = function(arg1) -- line 64
    arg1.off = TRUE
    ol1[130].off = FALSE
    olivia:say_line("/biol230/")
    wait_for_message()
    olivia:say_line("/biol231/")
    wait_for_message()
    olivia:say_line("/biol232/")
end
ol1[130] = { text = "/bima233/", first_olivia_node = TRUE }
ol1[130].off = TRUE
ol1[130].response = function(arg1) -- line 76
    arg1.off = TRUE
    olivia:say_line("/biol234/")
end
ol1[131] = { text = "/bima235/", first_olivia_node = TRUE }
ol1[131].response = function(arg1) -- line 82
    arg1.off = TRUE
    ol1[132].off = FALSE
    olivia:say_line("/biol236/")
    wait_for_message()
end
ol1[132] = { text = "/bima237/", first_olivia_node = TRUE }
ol1[132].off = TRUE
ol1[132].response = function(arg1) -- line 91
    arg1.off = TRUE
    ol1[134].off = FALSE
    olivia:say_line("/biol238/")
    wait_for_message()
    olivia:say_line("/biol239/")
    wait_for_message()
    olivia:say_line("/biol240/")
end
ol1[134] = { text = "/bima241/", first_olivia_node = TRUE }
ol1[134].off = TRUE
ol1[134].response = function(arg1) -- line 103
    arg1.off = TRUE
    ol1[136].off = FALSE
    ol1:read_poem()
end
ol1[136] = { text = "/bima243/", first_olivia_node = TRUE }
ol1[136].off = TRUE
ol1[136].response = function(arg1) -- line 111
    if ol1.poemed_out then
        ol1.poemed_out = FALSE
        ol1.poem_count = 0
        olivia:say_line("/biol244/")
        wait_for_message()
        manny:say_line("/bima245/")
        wait_for_message()
        olivia:say_line("/biol246/")
        wait_for_message()
    end
    ol1:read_poem()
end
ol1[140] = { text = "/bima247/", first_olivia_node = TRUE }
ol1[140].response = function(arg1) -- line 126
    arg1.off = TRUE
    olivia:say_line("/biol248/")
    wait_for_message()
    manny:say_line("/bima249/")
end
ol1[150] = { text = "/bima250/", first_olivia_node = TRUE }
ol1[150].response = function(arg1) -- line 134
    arg1.off = TRUE
    ol1[160].off = FALSE
    olivia:say_line("/biol251/")
    wait_for_message()
    olivia:say_line("/biol252/")
end
ol1[160] = { text = "/bima253/", first_olivia_node = TRUE }
ol1[160].off = TRUE
ol1[160].response = function(arg1) -- line 144
    arg1.off = TRUE
    ol1.node = "leaving"
    olivia:say_line("/biol254/")
    wait_for_message()
    olivia:say_line("/biol255/")
    wait_for_message()
    olivia:say_line("/biol256/")
end
ol1[170] = { text = "/bima257/", leaving = TRUE }
ol1[170].response = function(arg1) -- line 155
    olivia:say_line("/biol258/")
    wait_for_message()
    olivia:say_line("/biol259/")
    wait_for_message()
    ol1[180]:response()
end
ol1[180] = { text = "/bima260/", leaving = TRUE }
ol1[180].response = function(arg1) -- line 164
    ol1.node = "first_olivia_node"
    olivia:say_line("/biol261/")
    wait_for_message()
    olivia:say_line("/biol262/")
    wait_for_message()
    sleep_for(500)
    olivia:say_line("/biol263/")
end
ol1.exit_lines.first_olivia_node = { text = "/bima264/", first_olivia_node = TRUE }
ol1.exit_lines.first_olivia_node.response = function(arg1) -- line 175
    ol1.node = "exit_dialog"
    olivia:say_line("/biol265/")
end
ol1.aborts.first_olivia_node = function(arg1) -- line 180
    ol1:clear()
    ol1:execute_line(ol1.exit_lines.first_olivia_node)
end
ol1.read_poem = function(arg1) -- line 185
    local local1 = 0
    olivia:say_line("/biol266/")
    wait_for_message()
    bi.olivia_takes_stage()
    break_here()
    music_state:set_state(stateBI_POE)
    if bi.just_read_poem and not bi.copied_last_poem and bi.poem_line > 0 then
        bi.olivia_just_copied = TRUE
        bi.copied_last_poem = TRUE
        repeat
            olivia:say_line(ol1.poetry_lines[bi.last_poem[local1]])
            wait_for_message()
            if rndint(2) == 1 then
                bi.play_bongos()
                sleep_for(750)
            end
            if bi.last_poem[local1] == 57 and skinny_girl.passed_out then
                olivia:head_look_at(bi.patrons2)
                start_script(bi.patrons2.wake_up, bi.patrons2)
                sleep_for(3000)
                olivia:head_look_at(nil)
            end
            local1 = local1 + 1
            sleep_for(800 * random())
        until local1 >= bi.poem_line
    else
        ol1.poem_count = ol1.poem_count + 1
        if ol1.poem_count == 1 then
            olivia:say_line("/biol267/")
            wait_for_message()
            olivia:say_line("/biol268/")
            wait_for_message()
            olivia:say_line("/biol269/")
            wait_for_message()
            bi.play_bongos()
            sleep_for(750)
            olivia:say_line("/biol270/")
            wait_for_message()
            olivia:say_line("/biol271/")
            wait_for_message()
            olivia:say_line("/biol272/")
            wait_for_message()
            olivia:say_line("/biol273/")
            wait_for_message()
            olivia:say_line("/biol274/")
            bi.play_bongos()
            sleep_for(750)
        elseif ol1.poem_count == 2 then
            olivia:say_line("/biol275/")
            wait_for_message()
            olivia:say_line("/biol276/")
            wait_for_message()
            olivia:say_line("/biol277/")
            wait_for_message()
            olivia:say_line("/biol278/")
            wait_for_message()
            olivia:say_line("/biol279/")
            wait_for_message()
            olivia:say_line("/biol280/")
            wait_for_message()
            olivia:say_line("/biol281/")
            wait_for_message()
            olivia:say_line("/biol282/")
            wait_for_message()
            bi.play_bongos()
            sleep_for(750)
            olivia:say_line("/biol283/")
            wait_for_message()
            olivia:say_line("/biol284/")
            wait_for_message()
            olivia:say_line("/biol285/")
            wait_for_message()
            olivia:say_line("/biol286/")
        elseif ol1.poem_count == 3 then
            olivia:say_line("/biol287/")
            wait_for_message()
            olivia:say_line("/biol288/")
            wait_for_message()
            bi.play_bongos()
            sleep_for(750)
            olivia:say_line("/biol289/")
            wait_for_message()
            olivia:say_line("/biol290/")
            wait_for_message()
            olivia:say_line("/biol291/")
        elseif ol1.poem_count == 4 then
            ol1.poemed_out = TRUE
            olivia:say_line("/biol292/")
            wait_for_message()
            sleep_for(1000)
            olivia:say_line("/biol293/")
            wait_for_message()
            olivia:say_line("/biol294/")
            wait_for_message()
            olivia:say_line("/biol295/")
            wait_for_message()
            bi.play_bongos()
            sleep_for(750)
            olivia:say_line("/biol296/")
            wait_for_message()
            olivia:say_line("/biol297/")
            wait_for_message()
            olivia:say_line("/biol298/")
            wait_for_message()
            olivia:say_line("/biol299/")
            wait_for_message()
            bi.play_bongos()
            sleep_for(750)
            olivia:say_line("/biol300/")
        end
    end
    stop_script(olivia.new_run_idle)
    olivia:wait_for_message()
    olivia:stop_chore(nil, "olivia_idles.cos")
    start_script(bi.snap)
    break_here()
    olivia:follow_boxes()
    olivia:walkto(-0.207802, -1.84426, 0.151924, 0, 170.47501, 0)
    wait_for_script(bi.snap)
    bi.olivia_leaves_stage()
    sleep_for(500)
    music_state:update()
    if bi.olivia_just_copied then
        bi.olivia_just_copied = FALSE
        if not bi.copy_count then
            bi.copy_count = 0
        end
        bi.copy_count = bi.copy_count + 1
        manny:say_line("/bima391/")
        wait_for_message()
        if bi.copy_count == 1 then
            olivia:say_line("/biol392/")
        elseif bi.copy_count == 2 then
            olivia:say_line("/biol393/")
        elseif bi.copy_count == 3 then
            olivia:say_line("/biol394/")
        else
            olivia:say_line("/biol395/")
        end
    else
        manny:say_line("/bima301/")
        wait_for_message()
        if not ol1.poemed_out then
            olivia:say_line("/biol302/")
        else
            olivia:say_line("/biol303/")
        end
    end
end
ol1.poetry_lines = { }
ol1.poetry_lines[1] = "/biol304/"
ol1.poetry_lines[2] = "/biol305/"
ol1.poetry_lines[3] = "/biol306/"
ol1.poetry_lines[4] = "/biol307/"
ol1.poetry_lines[5] = "/biol308/"
ol1.poetry_lines[6] = "/biol309/"
ol1.poetry_lines[7] = "/biol310/"
ol1.poetry_lines[8] = "/biol311/"
ol1.poetry_lines[9] = "/biol312/"
ol1.poetry_lines[10] = "/biol313/"
ol1.poetry_lines[11] = "/biol314/"
ol1.poetry_lines[12] = "/biol315/"
ol1.poetry_lines[13] = "/biol316/"
ol1.poetry_lines[14] = "/biol317/"
ol1.poetry_lines[15] = "/biol318/"
ol1.poetry_lines[16] = "/biol319/"
ol1.poetry_lines[17] = "/biol320/"
ol1.poetry_lines[18] = "/biol321/"
ol1.poetry_lines[19] = "/biol322/"
ol1.poetry_lines[20] = "/biol323/"
ol1.poetry_lines[21] = "/biol324/"
ol1.poetry_lines[22] = "/biol325/"
ol1.poetry_lines[23] = "/biol326/"
ol1.poetry_lines[24] = "/biol327/"
ol1.poetry_lines[25] = "/biol328/"
ol1.poetry_lines[26] = "/biol329/"
ol1.poetry_lines[27] = "/biol330/"
ol1.poetry_lines[28] = "/biol331/"
ol1.poetry_lines[29] = "/biol332/"
ol1.poetry_lines[30] = "/biol333/"
ol1.poetry_lines[31] = "/biol334/"
ol1.poetry_lines[32] = "/biol335/"
ol1.poetry_lines[33] = "/biol336/"
ol1.poetry_lines[34] = "/biol337/"
ol1.poetry_lines[35] = "/biol338/"
ol1.poetry_lines[36] = "/biol339/"
ol1.poetry_lines[37] = "/biol340/"
ol1.poetry_lines[38] = "/biol341/"
ol1.poetry_lines[39] = "/biol342/"
ol1.poetry_lines[40] = "/biol343/"
ol1.poetry_lines[41] = "/biol344/"
ol1.poetry_lines[42] = "/biol345/"
ol1.poetry_lines[43] = "/biol346/"
ol1.poetry_lines[44] = "/biol347/"
ol1.poetry_lines[45] = "/biol348/"
ol1.poetry_lines[46] = "/biol349/"
ol1.poetry_lines[47] = "/biol350/"
ol1.poetry_lines[48] = "/biol351/"
ol1.poetry_lines[49] = "/biol352/"
ol1.poetry_lines[50] = "/biol353/"
ol1.poetry_lines[51] = "/biol354/"
ol1.poetry_lines[52] = "/biol355/"
ol1.poetry_lines[53] = "/biol356/"
ol1.poetry_lines[54] = "/biol357/"
ol1.poetry_lines[55] = "/biol358/"
ol1.poetry_lines[56] = "/biol359/"
ol1.poetry_lines[57] = "/biol360/"
ol1.poetry_lines[58] = "/biol361/"
ol1.poetry_lines[59] = "/biol362/"
ol1.poetry_lines[60] = "/biol363/"
ol1.poetry_lines[61] = "/biol365/"
ol1.poetry_lines[62] = "/biol366/"
ol1.poetry_lines[63] = "/biol367/"
ol1.poetry_lines[64] = "/biol368/"
ol1.poetry_lines[65] = "/biol369/"
ol1.poetry_lines[66] = "/biol370/"
ol1.poetry_lines[67] = "/biol371/"
ol1.poetry_lines[68] = "/biol372/"
ol1.poetry_lines[69] = "/biol373/"
ol1.poetry_lines[70] = "/biol374/"
ol1.poetry_lines[71] = "/biol375/"
ol1.poetry_lines[72] = "/biol376/"
ol1.poetry_lines[73] = "/biol377/"
ol1.poetry_lines[74] = "/biol378/"
ol1.poetry_lines[75] = "/biol379/"
ol1.poetry_lines[76] = "/biol380/"
ol1.poetry_lines[77] = "/biol381/"
ol1.poetry_lines[78] = "/biol382/"
ol1.poetry_lines[79] = "/biol383/"
ol1.poetry_lines[80] = "/biol384/"
ol1.poetry_lines[81] = "/biol385/"
ol1.poetry_lines[82] = "/biol386/"
ol1.poetry_lines[83] = "/biol387/"
ol1.poetry_lines[84] = "/biol388/"
ol1.poetry_lines[85] = "/biol389/"
ol1.poetry_lines[86] = "/biol390/"
ol1.outro = function(arg1) -- line 439
    bi:current_setup(bi_kitdr)
    single_start_script(bi.idle_reds)
    single_start_script(bi.idle_beats)
    cameraman_disabled = FALSE
    stop_script(olivia.head_follow_mesh)
    olivia:switch_to_standing()
    olivia:head_look_at(nil)
end

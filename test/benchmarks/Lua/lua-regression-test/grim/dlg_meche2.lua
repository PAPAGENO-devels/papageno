CheckFirstTime("dlg_meche2.lua")
me2 = Dialog:create()
me2.intro = function(arg1) -- line 11
    ar:current_setup(ar_mecla)
    if ar.talked_gun then
        manny:say_line("/arma057/")
        wait_for_message()
        meche:say_line("/armc058/")
        wait_for_message()
        manny:say_line("/arma059/")
        wait_for_message()
        meche:say_line("/armc060/")
    elseif gh.reunited then
        me2.exit_lines.n1 = me2.after_boat_exit
        if not meche.talked_boat then
            meche.talked_boat = TRUE
            manny:say_line("/arma061/")
            wait_for_message()
            meche:say_line("/armc062/")
            wait_for_message()
            manny:say_line("/arma063/")
            wait_for_message()
            meche:say_line("/armc064/")
            wait_for_message()
            manny:say_line("/arma065/")
            wait_for_message()
            manny:say_line("/arma066/")
            wait_for_message()
            manny:head_look_at(ar.ashtray)
            manny:say_line("/arma067/")
            wait_for_message()
            manny:head_look_at(ar.meche_obj)
        end
    end
end
me2[100] = { text = "/arma068/", n1 = TRUE }
me2[100].response = function(arg1) -- line 46
    arg1.off = TRUE
    me2[110].off = FALSE
    meche:say_line("/armc069/")
    wait_for_message()
    meche:say_line("/armc070/")
end
me2[110] = { text = "/arma071/", n1 = TRUE }
me2[110].off = TRUE
me2[110].response = function(arg1) -- line 56
    arg1.off = TRUE
    me2[120].off = FALSE
    meche:say_line("/armc072/")
end
me2[120] = { text = "/arma073/", n1 = TRUE }
me2[120].off = TRUE
me2[120].response = function(arg1) -- line 64
    arg1.off = TRUE
    me2[130].off = FALSE
    meche:say_line("/armc074/")
    wait_for_message()
    meche:say_line("/armc075/")
end
me2[130] = { text = "/arma076/", n1 = TRUE }
me2[130].off = TRUE
me2[130].response = function(arg1) -- line 75
    arg1.off = TRUE
    ar.talked_gun = TRUE
    me2.node = "n2"
    me2[135].off = FALSE
    me2[137].off = FALSE
    meche:say_line("/armc077/")
    wait_for_message()
    meche:say_line("/armc078/")
    wait_for_message()
    manny:say_line("/arma079/")
    wait_for_message()
    meche:say_line("/armc080/")
end
me2[135] = { text = "/arma081/", n1 = TRUE }
me2[135].off = TRUE
me2[135].response = function(arg1) -- line 92
    arg1.off = TRUE
    me2.node = "exit_dialog"
    meche:say_line("/armc082/")
    wait_for_message()
    meche:say_line("/armc083/")
    wait_for_message()
    me2:deal_straight()
end
me2[137] = { text = "/arma084/", n1 = TRUE }
me2[137].off = TRUE
me2[137].response = function(arg1) -- line 104
    arg1.off = TRUE
    me2.node = "exit_dialog"
    meche:say_line("/armc085/")
    wait_for_message()
    meche:say_line("/armc086/")
    wait_for_message()
    manny:say_line("/arma087/")
    wait_for_message()
    me2:deal_straight()
end
me2.deal_straight = function(arg1) -- line 116
    meche:say_line("/armc088/")
end
me2[140] = { text = "/arma089/", n2 = TRUE }
me2[140].response = function(arg1) -- line 122
    me2.node = "n1"
    meche:say_line("/armc090/")
    wait_for_message()
    meche:say_line("/armc091/")
end
me2[150] = { text = "/arma092/", n2 = TRUE }
me2[150].response = function(arg1) -- line 130
    me2.node = "n1"
    meche:say_line("/armc093/")
end
me2[160] = { text = "/arma094/", n2 = TRUE }
me2[160].response = function(arg1) -- line 136
    me2.node = "n1"
    manny:run_chore(mn2_takeout_get, "mn2.cos")
    sleep_for(1000)
    manny:play_chore(mn2_takeout_empty, "mn2.cos")
    wait_for_message()
    manny:say_line("/arma095/")
    wait_for_message()
    manny:stop_chore(mn2_takeout_empty, "mn2.cos")
    meche:say_line("/armc096/")
    wait_for_message()
    me2[140]:response()
end
me2[170] = { text = "/arma097/", n1 = TRUE }
me2[170].response = function(arg1) -- line 151
    arg1.off = TRUE
    me2[180].off = FALSE
    me2[190].off = FALSE
    meche:say_line("/armc098/")
end
me2[180] = { text = "/arma099/", n1 = TRUE }
me2[180].off = TRUE
me2[180].response = function(arg1) -- line 160
    arg1.off = TRUE
    meche:say_line("/armc100/")
    wait_for_message()
    meche:say_line("/armc101/")
end
me2[190] = { text = "/arma102/", n1 = TRUE }
me2[190].off = TRUE
me2[190].response = function(arg1) -- line 169
    arg1.off = TRUE
    me2.node = "n3"
    me2[200].off = FALSE
    meche:say_line("/armc103/")
    wait_for_message()
    meche:say_line("/armc104/")
end
me2[200] = { text = "/arma105/", n1 = TRUE }
me2[200].off = TRUE
me2[200].response = function(arg1) -- line 180
    me2.node = "n3"
    meche:say_line("/armc106/")
end
me2[210] = { text = "/arma107/", n3 = TRUE }
me2[210].response = function(arg1) -- line 186
    arg1.off = TRUE
    meche:say_line("/armc108/")
    wait_for_message()
    meche:say_line("/armc109/")
    wait_for_message()
    manny:say_line("/arma110/")
    wait_for_message()
    meche:say_line("/armc111/")
end
me2[220] = { text = "/arma112/", n3 = TRUE }
me2[220].response = function(arg1) -- line 198
    arg1.off = TRUE
    meche:say_line("/armc113/")
end
me2[230] = { text = "/arma114/", n3 = TRUE }
me2[230].response = function(arg1) -- line 204
    arg1.off = TRUE
    me2[240].off = FALSE
    meche:say_line("/armc115/")
end
me2[240] = { text = "/arma116/", n3 = TRUE }
me2[240].off = TRUE
me2[240].response = function(arg1) -- line 212
    arg1.off = TRUE
    meche:say_line("/armc117/")
    wait_for_message()
    meche:say_line("/armc118/")
    wait_for_message()
    meche:say_line("/armc119/")
end
me2[250] = { text = "/arma120/", n3 = TRUE }
me2[250].response = function(arg1) -- line 222
    arg1.off = TRUE
    meche:say_line("/armc121/")
end
me2[260] = { text = "/arma122/", n3 = TRUE }
me2[260].response = function(arg1) -- line 228
    arg1.off = TRUE
    meche:say_line("/armc123/")
    wait_for_message()
    manny:say_line("/arma124/")
    wait_for_message()
    meche:say_line("/armc125/")
end
me2[270] = { text = "/arma126/", n3 = TRUE }
me2[270].response = function(arg1) -- line 238
    arg1.off = TRUE
    meche:say_line("/armc127/")
    wait_for_message()
    meche:say_line("/armc128/")
end
me2.delayed_n3_exit = { text = "/arma129/" }
me2.delayed_n3_exit.response = function(arg1) -- line 246
    me2.node = "n1"
    meche:say_line("/armc130/")
    if not me2.cologne_joke then
        me2.cologne_joke = TRUE
        wait_for_message()
        manny:say_line("/arma131/")
    end
end
me2.n3 = function(arg1) -- line 256
    me2.exit_lines.n3 = me2.delayed_n3_exit
end
me2.aborts.n3 = function(arg1) -- line 260
    me2:clear()
    me2:execute_line(me2.exit_lines.n3)
    me2[200].off = TRUE
end
me2.exit_lines.n1 = { text = "/arma132/" }
me2.exit_lines.n1.response = function(arg1) -- line 267
    me2.node = "exit_dialog"
    meche:say_line("/armc133/")
end
me2.after_boat_exit = { text = "/arma134/" }
me2.after_boat_exit.response = function(arg1) -- line 273
    me2.node = "exit_dialog"
    meche:say_line("/armc135/")
end
me2.aborts.n1 = function(arg1) -- line 278
    me2:clear()
    me2.node = "exit_dialog"
    manny:say_line("/arma136/")
    wait_for_message()
    meche:say_line("/armc137/")
end
me2.outro = function(arg1) -- line 286
    ar:force_camerachange()
end

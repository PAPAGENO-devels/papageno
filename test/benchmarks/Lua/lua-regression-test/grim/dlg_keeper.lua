CheckFirstTime("dlg_keeper.lua")
gk1 = Dialog:create()
gk1.intro = function() -- line 12
    if manny.knows_glottis_is_dying and not tg.talked_glottis then
        gk1[140].off = FALSE
    else
        gk1[140].off = TRUE
    end
end
gk1[100] = { text = "/tgma046/", n1 = TRUE }
gk1[100].response = function(arg1) -- line 21
    arg1.off = TRUE
    gate_keeper:say_line("/tggk047/")
    gate_keeper:cross_arms()
    wait_for_message()
    gate_keeper:say_line("/tggk048/")
    gate_keeper:shake_cycle()
    gate_keeper:wait_for_message()
    gate_keeper:stop_shake()
    gate_keeper:uncross_arms()
end
gk1[110] = { text = "/tgma049/", n1 = TRUE }
gk1[110].response = function(arg1) -- line 34
    arg1.off = TRUE
    gk1[120].off = FALSE
    gate_keeper:say_line("/tggk050/")
    gate_keeper:cross_arms()
    wait_for_message()
    gate_keeper:say_line("/tggk051/")
    gate_keeper:shake_cycle()
    gate_keeper:wait_for_message()
    gate_keeper:stop_shake()
    gate_keeper:uncross_arms()
end
gk1[120] = { text = "/tgma052/", n1 = TRUE }
gk1[120].off = TRUE
gk1[120].response = function(arg1) -- line 49
    arg1.off = TRUE
    gk1[130].off = FALSE
    gate_keeper:say_line("/tggk053/")
    gate_keeper:say_what_in()
    wait_for_message()
    gate_keeper:say_line("/tggk054/")
    gate_keeper:say_what_out()
end
gk1[130] = { text = "/tgma055/", n1 = TRUE }
gk1[130].off = TRUE
gk1[130].response = function(arg1) -- line 61
    arg1.off = TRUE
    gate_keeper:say_line("/tggk056/")
    gate_keeper:arms_out()
    wait_for_message()
    gate_keeper:say_line("/tggk057/")
end
gk1[140] = { text = "/tgma058/", n1 = TRUE }
gk1[140].response = function(arg1) -- line 70
    arg1.off = TRUE
    tg.talked_glottis = TRUE
    gate_keeper:say_line("/tggk059/")
    gate_keeper:raise_hands()
    wait_for_message()
    gate_keeper:say_line("/tggk060/")
    wait_for_message()
    gate_keeper:say_line("/tggk062/")
    wait_for_message()
    gate_keeper:say_line("/tggk063/")
    gate_keeper:say_what_in()
    gate_keeper:wait_for_message()
    gate_keeper:say_what_out()
end
gk1.exit_lines.n1 = { text = "/tgma064/", n1 = TRUE }
gk1.exit_lines.n1.response = function(arg1) -- line 91
    gk1.node = "exit_dialog"
    gate_keeper:say_line("/tggk065/")
    gate_keeper:arms_out()
    wait_for_message()
    gate_keeper:wait_for_chore(gatekeeper_points, "gatekeeper.cos")
    gate_keeper:say_line("/tggk066/")
    gate_keeper:fade_out_chore(gatekeeper_points, "gatekeeper.cos")
    gate_keeper:cross_arms()
    wait_for_message()
    gate_keeper:say_line("/tggk067/")
    gate_keeper:wait_for_chore()
    gate_keeper:shake_cycle()
    gate_keeper:wait_for_message()
    gate_keeper:stop_shake()
    gate_keeper:uncross_arms()
end
gk1.aborts.n1 = function(arg1) -- line 109
    gk1:clear()
    manny:say_line("/tgma068/")
    wait_for_message()
    gk1.exit_lines.n1:response()
end

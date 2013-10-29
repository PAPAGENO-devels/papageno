CheckFirstTime("angelito_scripts.lua")
pugsy.look_away_point = { x = -0.100499, y = -0.320847, z = 0.4725 }
pugsy.work_idle_table = Idle:create("pu_work_idles")
idt = pugsy.work_idle_table
idt:add_state("work_idle", { start_hammer = 1 })
idt:add_state("start_hammer", { hammer_cycle = 1 })
idt:add_state("hammer_cycle", { hammer_cycle = 0.95, end_hammer = 0.05 })
idt:add_state("blow", { start_chisel = 1 })
idt:add_state("start_chisel", { chisel_cycle = 1 })
idt:add_state("chisel_cycle", { chisel_cycle = 0.95, putdown_chisel = 0.05 })
idt:add_state("putdown_chisel", { work_idle = 0.6, look_coral = 0.4 })
idt:add_state("look_coral", { chisel2 = 1 })
idt:add_state("chisel2", { start_chisel = 1 })
idt:add_state("end_hammer", { work_idle = 0.6, blow = 0.4 })
pugsy.no_hammer_idle_table = Idle:create("pu_work_idles")
idt = pugsy.no_hammer_idle_table
idt:add_state("blow", { start_chisel = 1 })
idt:add_state("start_chisel", { chisel_cycle = 1 })
idt:add_state("chisel_cycle", { chisel_cycle = 0.95, putdown_chisel = 0.05 })
idt:add_state("putdown_chisel", { look_coral = 1 })
idt:add_state("look_coral", { chisel2 = 1 })
idt:add_state("chisel2", { start_chisel = 1 })
bibi.work_idle_table = Idle:create("bibi_work_idles")
idt = bibi.work_idle_table
idt:add_state("work_idle", { start_hammer = 1 })
idt:add_state("start_hammer", { hammer_cycle = 1 })
idt:add_state("hammer_cycle", { hammer_cycle = 0.95, end_hammer = 0.05 })
idt:add_state("blow", { start_chisel = 1 })
idt:add_state("start_chisel", { chisel_cycle = 1 })
idt:add_state("chisel_cycle", { chisel_cycle = 0.95, putdown_chisel = 0.05 })
idt:add_state("putdown_chisel", { work_idle = 0.4, look_coral = 0.6 })
idt:add_state("look_coral", { chisel2 = 1 })
idt:add_state("chisel2", { start_chisel = 1 })
idt:add_state("end_hammer", { work_idle = 0.4, blow = 0.6 })
pugsy.kill_idle = function(arg1, arg2) -- line 69
    stop_script(pugsy.work_task)
    pugsy.work_task = nil
    if arg2 then
        pugsy:stop_chore(nil, "pu_work_idles.cos")
        pugsy:play_chore(pu_work_idles_work2talk, "pu_work_idles.cos")
    else
        pugsy:wait_for_chore(nil, "pu_work_idles.cos")
        if pugsy.last_chore == pu_work_idles_start_hammer then
            pugsy:run_chore(pu_work_idles_end_hammer, "pu_work_idles.cos")
        elseif pugsy.last_chore == pu_work_idles_hammer_cycle then
            pugsy:run_chore(pu_work_idles_end_hammer, "pu_work_idles.cos")
        elseif pugsy.last_chore == pu_work_idles_start_chisel then
            pugsy:run_chore(pu_work_idles_putdown_chisel, "pu_work_idles.cos")
        elseif pugsy.last_chore == pu_work_idles_chisel_cycle then
            pugsy:run_chore(pu_work_idles_putdown_chisel, "pu_work_idles.cos")
        elseif pugsy.last_chore == pu_work_idles_blow then
            pugsy:run_chore(pu_work_idles_putdown_chisel, "pu_work_idles.cos")
        end
        pugsy:run_chore(pu_work_idles_work_idle, "pu_work_idles.cos")
        pugsy:run_chore(pu_work_idles_work2talk, "pu_work_idles.cos")
    end
end
bibi.kill_idle = function(arg1, arg2) -- line 97
    stop_script(bibi.work_task)
    bibi.work_task = nil
    if arg2 then
        bibi:complete_chore(bibi_work_idles_work_idle, "bibi_work_idles.cos")
        bibi_stuff:complete_chore(bibi_work_idles_stick_coral_only, "bibi_work_idles.cos")
        bibi:stop_chore(bibi_work_idles_work_idle, "bibi_work_idles.cos")
        bibi:play_chore(bibi_talk_idles_work2talk, "bibi_talk_idles.cos")
    else
        bibi:wait_for_chore(nil, "bibi_work_idles.cos")
        if bibi.last_chore == bibi_work_idles_start_hammer then
            bibi:run_chore(bibi_work_idles_end_hammer, "bibi_work_idles.cos")
        elseif bibi.last_chore == bibi_work_idles_hammer_cycle then
            bibi:run_chore(bibi_work_idles_end_hammer, "bibi_work_idles.cos")
        elseif bibi.last_chore == bibi_work_idles_start_chisel then
            bibi:run_chore(bibi_work_idles_putdown_chisel, "bibi_work_idles.cos")
        elseif bibi.last_chore == bibi_work_idles_chisel_cycle then
            bibi:run_chore(bibi_work_idles_putdown_chisel, "bibi_work_idles.cos")
        elseif bibi.last_chore == bibi_work_idles_blow then
            bibi:run_chore(bibi_work_idles_putdown_chisel, "bibi_work_idles.cos")
        end
        bibi:run_chore(bibi_work_idles_work_idle, "bibi_work_idles.cos")
        bibi_stuff:complete_chore(bibi_work_idles_stick_coral_only, "bibi_work_idles.cos")
        bibi:stop_chore(bibi_work_idles_work_idle, "bibi_work_idles.cos")
        bibi:run_chore(bibi_talk_idles_work2talk, "bibi_talk_idles.cos")
    end
end
bibi.start_work = function(arg1, arg2) -- line 130
    bibi:head_look_at(nil)
    if bibi.work_task then
        stop_script(bibi.work_task)
    end
    if not arg2 then
        bibi:run_chore(bibi_talk_idles_talk2work, "bibi_talk_idles.cos")
        bibi:stop_chore(bibi_talk_idles_talk2work, "bibi_talk_idles.cos")
    end
    bibi.work_task = start_script(bibi.new_run_idle, bibi, "work_idle", bibi.work_idle_table, "bibi_work_idles.cos")
end
pugsy.start_work = function(arg1, arg2) -- line 142
    pugsy:head_look_at(nil)
    if pugsy.work_task then
        stop_script(pugsy.work_task)
    end
    if not arg2 then
        pugsy:run_chore(pu_talk_idles_gesture6, "pu_talk_idles.cos")
        pugsy:stop_chore(pu_talk_idles_gesture6, "pu_talk_idles.cos")
    end
    if fo.hammer_thrown then
        pugsy.work_task = start_script(pugsy.new_run_idle, pugsy, "blow", pugsy.no_hammer_idle_table, "pu_work_idles.cos")
    else
        pugsy.work_task = start_script(pugsy.new_run_idle, pugsy, "work_idle", pugsy.work_idle_table, "pu_work_idles.cos")
    end
end
pugsy.say_line = function(arg1, arg2) -- line 160
    Actor.say_line(pugsy, arg2)
    sleep_for(250)
    manny:head_look_at(pugsy, 100)
end
bibi.say_line = function(arg1, arg2) -- line 166
    Actor.say_line(bibi, arg2)
    sleep_for(250)
    manny:head_look_at(bibi, 100)
end
pugsy.throw_hammer = function(arg1) -- line 172
    manny:push_costume("mn_ham_react.cos")
    pugsy:stop_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:stop_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:stop_chore(pu_talk_idles_gesture3, "pu_talk_idles.cos")
    pugsy:stop_chore(pu_talk_idles_gesture2, "pu_talk_idles.cos")
    pugsy:play_chore(pu_work_idles_throw_pickaxe, "pu_work_idles.cos")
    manny:play_chore(1, "mn_ham_react.cos")
    sleep_for(1750)
    start_sfx("foHmrFal.wav")
    pugsy:wait_for_chore(pu_work_idles_throw_pickaxe, "pu_work_idles.cos")
    pugsy:stop_chore(pu_work_idles_throw_pickaxe, "pu_work_idles.cos")
    pugsy:play_chore(pu_talk_idles_talkpos2, "pu_talk_idles.cos")
    fo.hammer:set_up_actor()
    manny:wait_for_chore(1, "mn_ham_react.cos")
    manny:pop_costume()
end
bibi.start_giggle = function(arg1) -- line 198
    bibi:play_chore(bibi_talk_idles_start_giggle, "bibi_talk_idles.cos")
    bibi:wait_for_chore(bibi_talk_idles_start_giggle, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_giggle_loop, "bibi_talk_idles.cos")
end
bibi.end_giggle = function(arg1) -- line 204
    bibi:stop_looping_chore(bibi_talk_idles_giggle_loop, "bibi_talk_idles.cos")
    bibi:run_chore(bibi_talk_idles_end_giggle, "bibi_talk_idles.cos")
end
bibi.start_laugh = function(arg1) -- line 209
    bibi:play_chore(bibi_talk_idles_talk2laugh, "bibi_talk_idles.cos")
    bibi:wait_for_chore(bibi_talk_idles_start_laugh, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_laugh_loop, "bibi_talk_idles.cos")
end
bibi.giggle_to_laugh = function(arg1) -- line 215
    bibi:stop_looping_chore(bibi_talk_idles_giggle_loop, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_laugh_loop, "bibi_talk_idles.cos")
end
bibi.end_laugh = function(arg1) -- line 220
    bibi:set_chore_looping(bibi_talk_idles_laugh_loop, FALSE, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_talk, "bibi_talk_idles.cos")
    bibi:fade_out_chore(bibi_talk_idles_laugh_loop, "bibi_talk_idles.cos")
end
pugsy.start_laugh = function(arg1, arg2) -- line 226
    pugsy:play_chore_looping(pu_talk_idles_laugh, "pu_talk_idles.cos")
    if arg2 then
        pugsy:wait_for_message()
        pugsy:end_laugh()
    end
end
pugsy.end_laugh = function(arg1) -- line 234
    pugsy:set_chore_looping(pu_talk_idles_laugh, FALSE, "pu_talk_idles.cos")
    pugsy:play_chore(pu_talk_idles_talkpos2, "pu_talk_idles.cos")
    pugsy:fade_out_chore(pu_talk_idles_laugh, "pu_talk_idles.cos", 750)
end
bibi.exit_cry = function(arg1, arg2) -- line 246
    if bibi.crying then
        stop_script(bibi.cry_script)
        bibi.cry_script = nil
        if not arg2 then
            bibi:wait_for_message()
        end
        if bibi.cry_state == "sniffle" then
            bibi:stop_chore(bibi_talk_idles_sniff_loop, "bibi_talk_idles.cos")
            bibi:run_chore(bibi_talk_idles_end_sniff, "bibi_talk_idles.cos")
        elseif bibi.cry_state == "small" then
            bibi:stop_chore(bibi_talk_idles_smcry_loop, "bibi_talk_idles.cos")
            bibi:run_chore(bibi_talk_idles_end_smcry, "bibi_talk_idles.cos")
        elseif bibi.cry_state == "big" then
            bibi:stop_chore(bibi_talk_idles_bigcry_loop, "bibi_talk_idles.cos")
            bibi:run_chore(bibi_talk_idles_end_cry, "bibi_talk_idles.cos")
        end
        bibi.cry_state = nil
        bibi.crying = FALSE
        bibi:kill_cry_chores()
    end
end
bibi.kill_cry_loops = function(arg1) -- line 269
    bibi:set_chore_looping(bibi_talk_idles_sniff_loop, FALSE, "bibi_talk_idles.cos")
    bibi:set_chore_looping(bibi_talk_idles_smcry_loop, FALSE, "bibi_talk_idles.cos")
    bibi:set_chore_looping(bibi_talk_idles_bigcry_loop, FALSE, "bibi_talk_idles.cos")
end
bibi.kill_cry_chores = function(arg1) -- line 275
    bibi:stop_chore(bibi_talk_idles_sniff_loop, "bibi_talk_idles.cos")
    bibi:stop_chore(bibi_talk_idles_smcry_loop, "bibi_talk_idles.cos")
    bibi:stop_chore(bibi_talk_idles_bigcry_loop, "bibi_talk_idles.cos")
    bibi:play_chore(bibi_work_idles_work_idle, "bibi_work_idles.cos")
end
bibi.sniffle = function(arg1, arg2) -- line 282
    if bibi.cry_state == "sniffle" then
        bibi:say_line(arg2)
    else
        bibi:kill_cry_loops()
        bibi.cry_state = "sniffle"
        bibi:say_line(arg2)
        bibi:run_chore(bibi_talk_idles_talk2sniff, "bibi_talk_idles.cos")
        bibi:play_chore_looping(bibi_talk_idles_sniff_loop, "bibi_talk_idles.cos")
    end
end
bibi.big_cry = function(arg1, arg2) -- line 294
    if bibi.cry_state == "big" then
        bibi:say_line(arg2)
    else
        bibi:kill_cry_loops()
        bibi.cry_state = "big"
        bibi:say_line(arg2)
        bibi:run_chore(bibi_talk_idles_talk2bigcry, "bibi_talk_idles.cos")
        bibi:play_chore_looping(bibi_talk_idles_bigcry_loop, "bibi_talk_idles.cos")
    end
end
bibi.small_cry = function(arg1, arg2) -- line 306
    if bibi.cry_state == "small" then
        bibi:say_line(arg2)
    else
        bibi:kill_cry_loops()
        bibi.cry_state = "small"
        bibi:say_line(arg2)
        bibi:run_chore(bibi_talk_idles_talk2smcry, "bibi_talk_idles.cos")
        bibi:play_chore_looping(bibi_talk_idles_smcry_loop, "bibi_talk_idles.cos")
    end
end
fo.bibi_cry = function() -- line 318
    local local1
    local local2, local3
    if not bibi.crying then
        bibi.crying = TRUE
        bibi:head_look_at(nil)
        if an1 then
            if not an1[95].said then
                an1[95].off = FALSE
            end
        end
        bibi.cry_state = nil
        while 1 do
            repeat
                local2 = rndint(1, 6)
            until local2 ~= local3
            if local2 == 1 then
                bibi:small_cry("/fobi141/")
            elseif local2 == 2 then
                bibi:small_cry("/fobi142/")
            elseif local2 == 3 then
                bibi:sniffle("/fobi143/")
            elseif local2 == 4 then
                bibi:big_cry("/fobi144/")
            elseif local2 == 5 then
                bibi:big_cry("/fobi145/")
            else
                bibi:big_cry("/fobi146/")
            end
            local3 = local2
            bibi:wait_for_message()
        end
    end
end
pugsy.setup_crying = function(arg1) -- line 356
    pugsy:head_look_at(nil)
    pugsy:run_chore(pu_talk_idles_gesture4, "pu_talk_idles.cos")
    pugsy:run_chore(pu_talk_idles_start_cry, "pu_talk_idles.cos")
    pugsy:play_chore(pu_talk_idles_cry_loop, "pu_talk_idles.cos")
end
fo.pugsy_cry = function() -- line 363
    local local1
    if not pugsy.crying then
        pugsy.crying = TRUE
        start_script(pugsy.setup_crying)
        while 1 do
            pugsy:say_line(pick_one_of({ "/fopu147/", "/fopu148/", "/fopu149/", "/fopu150/", "/fopu151/", "/fopu152/" }))
            pugsy:wait_for_message()
            break_here()
        end
    end
end
pugsy.exit_cry = function(arg1, arg2) -- line 383
    if pugsy.crying then
        stop_script(pugsy.cry_script)
        pugsy.cry_script = nil
        if not arg2 then
            pugsy:wait_for_message()
        end
        pugsy:stop_chore(pu_talk_idles_cry_loop, "pu_talk_idles.cos")
        pugsy:run_chore(pu_talk_idles_end_cry, "pu_talk_idles.cos")
        pugsy:run_chore(pu_talk_idles_gesture5, "pu_talk_idles.cos")
        pugsy.crying = nil
    end
end
pugsy.start_crying = function(arg1) -- line 395
    if not pugsy.cry_script then
        pugsy.cry_script = start_script(fo.pugsy_cry)
    end
end
bibi.start_crying = function(arg1) -- line 401
    if not bibi.cry_script then
        bibi.cry_script = start_script(fo.bibi_cry)
    end
end
pugsy.kill_crying = function(arg1) -- line 407
    if pugsy.cry_script then
        stop_script(pugsy.cry_script)
    end
    pugsy.cry_script = nil
    pugsy.crying = FALSE
    pugsy:shut_up()
end
bibi.kill_crying = function(arg1) -- line 416
    if bibi.cry_script then
        stop_script(bibi.cry_script)
    end
    bibi.cry_script = nil
    bibi.crying = FALSE
    bibi.cry_state = nil
    bibi:shut_up()
end
fo.fight = function() -- line 432
    fo.fighting = TRUE
    if pugsy.work_task then
        start_script(pugsy.kill_idle, pugsy)
    end
    if bibi.work_task then
        start_script(bibi.kill_idle, bibi)
    end
    wait_for_script(pugsy.kill_idle)
    wait_for_script(bibi.kill_idle)
    wait_for_message()
    pugsy:push_costume("pu_argue.cos")
    bibi:push_costume("bibi_argue.cos")
    bibi:stop_chore(nil, "bibi_talk_idles.cos")
    bibi:stop_chore(nil, "bibi_work_idles.cos")
    bibi:play_chore(bibi_argue_talk, "bibi_argue.cos")
    bibi:head_look_at(nil)
    pugsy:stop_chore(nil, "pu_talk_idles.cos")
    pugsy:stop_chore(nil, "pu_work_idles.cos")
    pugsy:play_chore(pu_argue_2look_bibi, "pu_argue.cos")
    pugsy:head_look_at(nil)
    pugsy:say_line("/fopu120/")
    sleep_for(500)
    bibi:play_chore(bibi_argue_2look_pu, "bibi_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi121/")
    bibi:wait_for_message()
    pugsy:say_line("/fopu122/")
    pugsy:play_chore(pu_argue_2argue, "pu_argue.cos")
    pugsy:wait_for_message()
    pugsy:play_chore(pu_argue_argue2look_bibi, "pu_argue.cos")
    bibi:say_line("/fobi123/")
    bibi:run_chore(bibi_argue_2argue, "bibi_argue.cos")
    bibi:play_chore_looping(bibi_argue_argue, "bibi_argue.cos")
    bibi:wait_for_message()
    pugsy:say_line("/fopu124/")
    pugsy:fade_in_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:wait_for_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:fade_out_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi125/")
    bibi:wait_for_message()
    pugsy:say_line("/fopu126/")
    pugsy:fade_in_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:wait_for_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:fade_out_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi127/")
    bibi:stop_looping_chore(bibi_argue_argue, "bibi_argue.cos")
    bibi:run_chore(bibi_argue_look_pu2talk, "bibi_argue.cos")
    bibi:stop_chore(nil, "bibi_argue.cos")
    bibi:pop_costume()
    bibi:run_chore(bibi_talk_idles_talk2work, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:say_line("/fopu128/")
    pugsy:run_chore(pu_argue_2yell, "pu_argue.cos")
    pugsy:play_chore_looping(pu_argue_yell, "pu_argue.cos")
    sleep_for(1000)
    bibi:run_chore(bibi_talk_idles_work2talk, "bibi_talk_idles.cos")
    bibi:stop_chore(nil, "bibi_talk_idles.cos")
    bibi:push_costume("bibi_argue.cos")
    bibi:play_chore(bibi_argue_2look_pu, "bibi_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi129/")
    pugsy:stop_looping_chore(pu_argue_yell, "pu_argue.cos")
    pugsy:play_chore(pu_argue_yell2look_bibi, "pu_argue.cos")
    bibi:wait_for_message()
    pugsy:say_line("/fopu130/")
    pugsy:run_chore(pu_argue_2argue, "pu_argue.cos")
    pugsy:play_chore_looping(pu_argue_argue, "pu_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi131/")
    bibi:run_chore(bibi_argue_2yell, "bibi_argue.cos")
    bibi:wait_for_message()
    pugsy:stop_looping_chore(pu_argue_argue, "pu_argue.cos")
    pugsy:say_line("/fopu132/")
    pugsy:run_chore(pu_argue_argue2look_bibi, "pu_argue.cos")
    pugsy:run_chore(pu_argue_look_bibi2talk, "pu_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi133/")
    bibi:play_chore_looping(bibi_argue_yell, "bibi_argue.cos")
    bibi:wait_for_message()
    pugsy:say_line("/fopu134/")
    sleep_for(1000)
    pugsy:run_chore(pu_argue_2look_bibi, "pu_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi135/")
    bibi:stop_looping_chore(bibi_argue_yell, "bibi_argue.cos")
    bibi:run_chore(bibi_argue_look_pu2talk, "bibi_argue.cos")
    bibi:stop_chore(nil, "bibi_argue.cos")
    bibi:pop_costume()
    bibi:run_chore(bibi_talk_idles_start_angelic, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:say_line("/fopu136/")
    pugsy:run_chore(pu_argue_look_bibi2talk, "pu_argue.cos")
    pugsy:head_look_at_point(pugsy.look_away_point)
    pugsy:wait_for_message()
    bibi:say_line("/fobi137/")
    bibi:play_chore_looping(bibi_talk_idles_angelic_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    pugsy:head_look_at(nil)
    pugsy:say_line("/fopu138/")
    pugsy:run_chore(pu_argue_2look_bibi, "pu_argue.cos")
    pugsy:run_chore(pu_argue_2argue, "pu_argue.cos")
    pugsy:wait_for_message()
    bibi:say_line("/fobi139/")
    bibi:stop_looping_chore(bibi_talk_idles_angelic_loop, "bibi_talk_idles.cos")
    bibi:run_chore(bibi_talk_idles_end_angelic, "bibi_talk_idles.cos")
    bibi:stop_chore(bibi_talk_idles_end_angelic, "bibi_talk_idles.cos")
    bibi:push_costume("bibi_argue.cos")
    bibi:run_chore(bibi_argue_2look_pu, "bibi_argue.cos")
    bibi:run_chore(bibi_argue_2yell, "bibi_argue.cos")
    bibi:wait_for_message()
    manny:say_line("/foma140/")
    pugsy:head_look_at_manny()
    bibi:head_look_at_manny()
    bibi:play_chore(bibi_argue_yell2look_pu, "bibi_argue.cos")
    pugsy:play_chore(pu_argue_yell2look_bibi, "pu_argue.cos")
    bibi:wait_for_chore(bibi_argue_yell2look_pu, "bibi_argue.cos")
    bibi:play_chore(bibi_argue_look_pu2talk, "bibi_argue.cos")
    pugsy:wait_for_chore(pu_argue_yell2look_bibi, "pu_argue.cos")
    pugsy:run_chore(pu_argue_2talk, "pu_argue.cos")
    pugsy:pop_costume()
    pugsy:play_chore(pu_talk_idles_talkpos2, "pu_talk_idles.cos")
    bibi:wait_for_chore(bibi_argue_look_pu2talk, "bibi_argue.cos")
    bibi:pop_costume()
    bibi:play_chore(bibi_talk_idles_talk, "bibi_talk_idles.cos")
    pugsy:head_look_at_manny()
    bibi:head_look_at_manny()
    wait_for_message()
    sleep_for(1000)
    bibi:head_look_at(nil)
    bibi:start_crying()
    sleep_for(500)
    pugsy:head_look_at(nil)
    pugsy:start_crying()
    fo.fighting = FALSE
end
fo.exit_fight = function(arg1) -- line 581
    stop_script(fo.fight)
    if fo.fighting then
        fo.fighting = FALSE
        if not arg1 then
            bibi:wait_for_message()
            pugsy:wait_for_message()
        else
            bibi:shut_up()
            pugsy:shut_up()
        end
        bibi:stop_chore(nil, "bibi_argue.cos")
        bibi:play_chore(bibi_talk_idles_work_idle, "bibi_talk_idles.cos")
        pugsy:stop_chore(nil, "pu_argue.cos")
        pugsy:play_chore(pu_talk_idles_talkpos2, "pu_talk_idles.cos")
        bibi:pop_costume()
        pugsy:pop_costume()
    end
end
fo.kids_scream = function(arg1) -- line 607
    if bibi.work_task then
        start_script(bibi.kill_idle, bibi, TRUE)
    end
    if pugsy.work_task then
        start_script(pugsy.kill_idle, pugsy, TRUE)
    end
    if bibi.crying then
        start_script(bibi.exit_cry, bibi)
    end
    if pugsy.crying then
        start_script(bibi.exit_cry, bibi)
    end
    if fo.fighting then
        fo.exit_fight(TRUE)
    end
    start_script(pugsy.scream)
    start_script(bibi.scream)
end
pugsy.scream = function(arg1) -- line 617
    pugsy.screaming = TRUE
    pugsy:play_chore_looping(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:say_line("/fopu115/")
    pugsy:wait_for_message()
    pugsy:stop_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:play_chore_looping(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:say_line("/fopu117/")
    pugsy:wait_for_message()
    pugsy:stop_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:play_chore_looping(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:say_line("/fopu119/")
    pugsy:wait_for_message()
    pugsy.screaming = FALSE
    pugsy:stop_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
    pugsy:stop_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
    pugsy:start_crying()
end
bibi.scream = function(arg1) -- line 636
    bibi.screaming = TRUE
    bibi:say_line("/fobi114/")
    bibi:fade_in_chore(bibi_talk_idles_talk2scream, "bibi_talk_idles.cos")
    bibi:play_chore_looping(bibi_talk_idles_scream_loop, "bibi_talk_idles.cos")
    bibi:wait_for_message()
    bibi:say_line("/fobi116/")
    bibi:wait_for_message()
    bibi:say_line("/fobi118/")
    bibi:wait_for_message()
    bibi:say_line("/fobi114/")
    bibi:wait_for_message()
    bibi:say_line("/fobi116/")
    bibi:wait_for_message()
    bibi:say_line("/fobi118/")
    bibi:wait_for_message()
    bibi:set_chore_looping(bibi_talk_idles_scream_loop, FALSE, "bibi_talk_idles.cos")
    bibi:fade_out_chore(bibi_talk_idles_scream_loop, "bibi_talk_idles.cos")
    bibi.screaming = FALSE
    bibi:start_crying()
end
fo.stop_scream = function() -- line 660
    stop_script(fo.kids_scream)
    stop_script(bibi.scream)
    stop_script(pugsy.scream)
    pugsy.screaming = FALSE
    bibi.screaming = FALSE
    pugsy:play_chore(pu_talk_idles_talkpos2, "pu_talk_idles.cos")
    bibi:play_chore(bibi_talk_idles_talk, "bibi_talk_idles.cos")
end
pugsy.jut_chin = function(arg1) -- line 676
    pugsy:play_chore(pu_talk_idles_gesture2, "pu_talk_idles.cos")
end
pugsy.un_jut_chin = function(arg1) -- line 680
    pugsy:play_chore(pu_talk_idles_gesture3, "pu_talk_idles.cos")
end
pugsy.point_hammer = function(arg1) -- line 684
    pugsy:play_chore(pu_talk_idles_cocky2, "pu_talk_idles.cos")
end
pugsy.roll_head = function(arg1) -- line 688
    pugsy:play_chore(pu_talk_idles_cocky, "pu_talk_idles.cos")
end

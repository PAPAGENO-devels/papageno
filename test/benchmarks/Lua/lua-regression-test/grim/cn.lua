CheckFirstTime("cn.lua")
dofile("bogen.lua")
dofile("spinner.lua")
dofile("turbanman.lua")
dofile("fatlady.lua")
dofile("caneman.lua")
dofile("mc_booth_idles.lua")
dofile("cc_booth_idles.lua")
dofile("ccharlie.lua")
cn = Set:create("cn.set", "casino interior", { cn_top = 0, cn_cchms = 1, cn_rulws = 2 })
cn.shrinkable = 0.043
bogen.idle_table = Idle:create("bogen")
bogen.idle_table:add_state("hands_side_to_bk", { rocking = 0.8, hands_bk_to_side = 0.2 })
bogen.idle_table:add_state("hands_to_hips", { hands_on_hips = 1 })
bogen.idle_table:add_state("rocking", { hands_bk_to_side = 1 })
bogen.idle_table:add_state("brush_jacket", { stand = 1 })
bogen.idle_table:add_state("hands_from_hips", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("hands_bk_to_side", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("stand", { brush_jacket = 0.1, hands_to_hips = 0.1, hands_side_to_bk = 0.1, stand = 0.7 })
bogen.idle_table:add_state("hands_on_hips", { hands_on_hips = 0.85, hands_from_hips = 0.15 })
manny.say_number = function(arg1, arg2) -- line 35
    if arg2 == 1 then
        manny:say_line("/cnma001/")
    elseif arg2 == 2 then
        manny:say_line("/cnma002/")
    elseif arg2 == 3 then
        manny:say_line("/cnma003/")
    elseif arg2 == 4 then
        manny:say_line("/cnma004/")
    elseif arg2 == 5 then
        manny:say_line("/cnma005/")
    elseif arg2 == 6 then
        manny:say_line("/cnma006/")
    elseif arg2 == 7 then
        manny:say_line("/cnma007/")
    elseif arg2 == 8 then
        manny:say_line("/cnma008/")
    elseif arg2 == 9 then
        manny:say_line("/cnma009/")
    elseif arg2 == 10 then
        manny:say_line("/cnma010/")
    elseif arg2 == 11 then
        manny:say_line("/cnma011/")
    elseif arg2 == 12 then
        manny:say_line("/cnma012/")
    elseif arg2 == 13 then
        manny:say_line("/cnma013/")
    elseif arg2 == 14 then
        manny:say_line("/cnma014/")
    elseif arg2 == 15 then
        manny:say_line("/cnma015/")
    elseif arg2 == 16 then
        manny:say_line("/cnma016/")
    elseif arg2 == 17 then
        manny:say_line("/cnma017/")
    elseif arg2 == 18 then
        manny:say_line("/cnma018/")
    elseif arg2 == 19 then
        manny:say_line("/cnma019/")
    elseif arg2 == 20 then
        manny:say_line("/cnma020/")
    elseif arg2 == 21 then
        manny:say_line("/cnma021/")
    elseif arg2 == 22 then
        manny:say_line("/cnma022/")
    elseif arg2 == 23 then
        manny:say_line("/cnma023/")
    elseif arg2 == 24 then
        manny:say_line("/cnma024/")
    elseif arg2 == 25 then
        manny:say_line("/cnma025/")
    elseif arg2 == 26 then
        manny:say_line("/cnma026/")
    elseif arg2 == 27 then
        manny:say_line("/cnma027/")
    elseif arg2 == 28 then
        manny:say_line("/cnma028/")
    elseif arg2 == 29 then
        manny:say_line("/cnma029/")
    elseif arg2 == 30 then
        manny:say_line("/cnma030/")
    elseif arg2 == 31 then
        manny:say_line("/cnma031/")
    elseif arg2 == 32 then
        manny:say_line("/cnma032/")
    elseif arg2 == 33 then
        manny:say_line("/cnma033/")
    elseif arg2 == 34 then
        manny:say_line("/cnma034/")
    elseif arg2 == 35 then
        manny:say_line("/cnma035/")
    elseif arg2 == 36 then
        manny:say_line("/cnma036/")
    end
end
croupier.say_english_number = function(arg1, arg2) -- line 75
    if arg2 == 0 then
        croupier:say_line("/cncr037/")
    elseif arg2 == 1 then
        croupier:say_line("/cncr038/")
    elseif arg2 == 2 then
        croupier:say_line("/cncr039/")
    elseif arg2 == 3 then
        croupier:say_line("/cncr040/")
    elseif arg2 == 4 then
        croupier:say_line("/cncr041/")
    elseif arg2 == 5 then
        croupier:say_line("/cncr042/")
    elseif arg2 == 6 then
        croupier:say_line("/cncr043/")
    elseif arg2 == 7 then
        croupier:say_line("/cncr044/")
    elseif arg2 == 8 then
        croupier:say_line("/cncr045/")
    elseif arg2 == 9 then
        croupier:say_line("/cncr046/")
    elseif arg2 == 10 then
        croupier:say_line("/cncr047/")
    elseif arg2 == 11 then
        croupier:say_line("/cncr048/")
    elseif arg2 == 12 then
        croupier:say_line("/cncr049/")
    elseif arg2 == 13 then
        croupier:say_line("/cncr050/")
    elseif arg2 == 14 then
        croupier:say_line("/cncr051/")
    elseif arg2 == 15 then
        croupier:say_line("/cncr052/")
    elseif arg2 == 16 then
        croupier:say_line("/cncr053/")
    elseif arg2 == 17 then
        croupier:say_line("/cncr054/")
    elseif arg2 == 18 then
        croupier:say_line("/cncr055/")
    elseif arg2 == 19 then
        croupier:say_line("/cncr056/")
    elseif arg2 == 20 then
        croupier:say_line("/cncr057/")
    elseif arg2 == 21 then
        croupier:say_line("/cncr058/")
    elseif arg2 == 22 then
        croupier:say_line("/cncr059/")
    elseif arg2 == 23 then
        croupier:say_line("/cncr060/")
    elseif arg2 == 24 then
        croupier:say_line("/cncr061/")
    elseif arg2 == 25 then
        croupier:say_line("/cncr062/")
    elseif arg2 == 26 then
        croupier:say_line("/cncr063/")
    elseif arg2 == 27 then
        croupier:say_line("/cncr064/")
    elseif arg2 == 28 then
        croupier:say_line("/cncr065/")
    elseif arg2 == 29 then
        croupier:say_line("/cncr066/")
    elseif arg2 == 30 then
        croupier:say_line("/cncr067/")
    elseif arg2 == 31 then
        croupier:say_line("/cncr068/")
    elseif arg2 == 32 then
        croupier:say_line("/cncr069/")
    elseif arg2 == 33 then
        croupier:say_line("/cncr070/")
    elseif arg2 == 34 then
        croupier:say_line("/cncr071/")
    elseif arg2 == 35 then
        croupier:say_line("/cncr072/")
    elseif arg2 == 36 then
        croupier:say_line("/cncr073/")
    end
end
croupier.say_french_number = function(arg1, arg2) -- line 116
    if arg2 == 0 then
        croupier:say_line("/cncr074/")
    elseif arg2 == 1 then
        croupier:say_line("/cncr075/")
    elseif arg2 == 2 then
        croupier:say_line("/cncr076/")
    elseif arg2 == 3 then
        croupier:say_line("/cncr077/")
    elseif arg2 == 4 then
        croupier:say_line("/cncr078/")
    elseif arg2 == 5 then
        croupier:say_line("/cncr079/")
    elseif arg2 == 6 then
        croupier:say_line("/cncr080/")
    elseif arg2 == 7 then
        croupier:say_line("/cncr081/")
    elseif arg2 == 8 then
        croupier:say_line("/cncr082/")
    elseif arg2 == 9 then
        croupier:say_line("/cncr083/")
    elseif arg2 == 10 then
        croupier:say_line("/cncr084/")
    elseif arg2 == 11 then
        croupier:say_line("/cncr085/")
    elseif arg2 == 12 then
        croupier:say_line("/cncr086/")
    elseif arg2 == 13 then
        croupier:say_line("/cncr087/")
    elseif arg2 == 14 then
        croupier:say_line("/cncr088/")
    elseif arg2 == 15 then
        croupier:say_line("/cncr089/")
    elseif arg2 == 16 then
        croupier:say_line("/cncr090/")
    elseif arg2 == 17 then
        croupier:say_line("/cncr091/")
    elseif arg2 == 18 then
        croupier:say_line("/cncr092/")
    elseif arg2 == 19 then
        croupier:say_line("/cncr093/")
    elseif arg2 == 20 then
        croupier:say_line("/cncr094/")
    elseif arg2 == 21 then
        croupier:say_line("/cncr095/")
    elseif arg2 == 22 then
        croupier:say_line("/cncr096/")
    elseif arg2 == 23 then
        croupier:say_line("/cncr097/")
    elseif arg2 == 24 then
        croupier:say_line("/cncr098/")
    elseif arg2 == 25 then
        croupier:say_line("/cncr099/")
    elseif arg2 == 26 then
        croupier:say_line("/cncr100/")
    elseif arg2 == 27 then
        croupier:say_line("/cncr101/")
    elseif arg2 == 28 then
        croupier:say_line("/cncr102/")
    elseif arg2 == 29 then
        croupier:say_line("/cncr103/")
    elseif arg2 == 30 then
        croupier:say_line("/cncr104/")
    elseif arg2 == 31 then
        croupier:say_line("/cncr105/")
    elseif arg2 == 32 then
        croupier:say_line("/cncr106/")
    elseif arg2 == 33 then
        croupier:say_line("/cncr107/")
    elseif arg2 == 34 then
        croupier:say_line("/cncr108/")
    elseif arg2 == 35 then
        croupier:say_line("/cncr109/")
    elseif arg2 == 36 then
        croupier:say_line("/cncr110/")
    end
end
croupier.say_line = function(arg1, arg2) -- line 157
    local local1
    local local2
    if not cn.pause_spinning then
        if system.currentSet == cn and cn:current_setup() == cn_rulws then
            Actor.say_line(arg1, arg2, { background = TRUE, volume = 100 })
        elseif system.currentSet == cf and cf:current_setup() == cf_pnlcu then
            local1 = tostring(strsub(arg2, 1, 8) .. "a" .. strsub(arg2, 9, strlen(arg2)))
            local1 = arg2
            Actor.say_line(arg1, local1, { background = TRUE })
        end
    end
end
croupier.say_line_manny = function(arg1, arg2) -- line 180
    Actor.say_line(arg1, arg2, { background = TRUE, volume = 100 })
end
croupier.turn_to_table = function(arg1, arg2) -- line 184
    croupier:set_turn_rate(15)
    if system.currentSet == cn then
        if arg2 == rtable1 then
            croupier:setrot(0, 0, 0, TRUE)
        elseif arg2 == rtable2 then
            croupier:setrot(0, 260, 0, TRUE)
        else
            croupier:setrot(0, 120, 0, TRUE)
        end
        while croupier:is_turning() and system.currentSet == cn do
            break_here()
        end
    end
end
bogen.say_line = function(arg1, arg2) -- line 202
    local local1
    if system.currentSet == cn and cn:current_setup() == cn_rulws then
        SayLine(arg1.hActor, arg2, TRUE)
    elseif system.currentSet == cf and cf:current_setup() == cf_pnlcu then
        local1 = tostring(strsub(arg2, 1, 8) .. "a" .. strsub(arg2, 9, strlen(arg2)))
        local1 = arg2
        SayLine(arg1.hActor, local1, TRUE)
    end
end
croupier.say_color_french = function(arg1, arg2) -- line 215
    local local1 = croupier:pick_color(arg2)
    if local1 == "red" then
        croupier:say_line("/cncr111/")
    elseif local1 == "black" then
        croupier:say_line("/cncr112/")
    end
end
croupier.say_color_english = function(arg1, arg2) -- line 225
    local local1 = croupier:pick_color(arg2)
    if local1 == "red" then
        croupier:say_line("/cncr113/")
    elseif local1 == "black" then
        croupier:say_line("/cncr114/")
    end
end
croupier.pick_color = function(arg1, arg2) -- line 235
    if arg2 == 0 then
        return "zero"
    elseif arg2 == 1 or arg2 == 3 or arg2 == 5 or arg2 == 7 or arg2 == 9 or arg2 == 12 or arg2 == 14 or arg2 == 16 or arg2 == 18 or arg2 == 19 or arg2 == 21 or arg2 == 23 or arg2 == 25 or arg2 == 27 or arg2 == 30 or arg2 == 32 or arg2 == 34 or arg2 == 36 then
        return "red"
    else
        return "black"
    end
end
croupier.even_odd_manque_passe = function(arg1, arg2) -- line 263
    if floor(mod(arg2, 2)) == 0 then
        if arg2 > 18 then
            croupier:say_line("/cncr115/")
        else
            croupier:say_line("/cncr116/")
        end
    elseif arg2 > 18 then
        croupier:say_line("/cncr117/")
    else
        croupier:say_line("/cncr118/")
    end
end
cn.BET = 0
cn.SPIN = 1
cn.WIN = 2
cn.bets = { }
cn.bets[1] = "red"
cn.bets[2] = "black"
cn.bets[3] = "zero"
cn.bets[4] = "num"
cn.casino_patrons = function(arg1, arg2) -- line 290
    local local1 = { }
    local local2 = { }
    local local3
    local2[1] = turbanman
    local2[2] = caneman
    local2[3] = fatlady
    if bogen.pissed and not cn.bogens_in_the_house_again then
        if arg2 == rtable1 then
            local1[1] = turbanman
        elseif arg2 == rtable2 then
            local1[1] = caneman
        elseif arg2 == rtable3 then
            local1[1] = fatlady
        end
    elseif arg2 == rtable1 then
        local1[1] = turbanman
    elseif arg2 == rtable3 then
        local1[1] = caneman
        local1[2] = fatlady
    end
    local3 = 1
    while local1[local3] do
        local1[local3]:thaw(TRUE)
        if arg1 == cn.BET then
            local1[local3].bet = pick_from_nonweighted_table(cn.bets)
            if local1[local3].bet == "num" then
                local1[local3].bet = rndint(0, 36)
            end
            if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
                if rnd() then
                    local1[local3]:play_chore(1)
                else
                    local1[local3]:play_chore(2)
                end
            end
        elseif arg1 == cn.SPIN and system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:play_chore(3)
        elseif arg1 == cn.WIN and system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:play_chore(4)
        elseif system.currentSet ~= cn then
            sleep_for(2000)
        end
        if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            local1[local3]:wait_for_chore()
            local1[local3]:freeze()
        end
        local3 = local3 + 1
    end
end
determine_winner = function(arg1) -- line 345
    local local1 = { }
    local local2 = { }
    local local3
    local local4
    local2[1] = turbanman
    local2[2] = caneman
    local2[3] = fatlady
    if bogen.pissed and not cn.bogens_in_the_house_again then
        if arg1 == rtable1 then
            local1[1] = turbanman
        elseif arg1 == rtable2 then
            local1[1] = caneman
        elseif arg1 == rtable3 then
            local1[1] = fatlady
        end
    elseif arg1 == rtable1 then
        local1[1] = turbanman
    elseif arg1 == rtable3 then
        local1[1] = caneman
        local1[2] = fatlady
    end
    local3 = 1
    while local1[local3] do
        if type(local1[local3].bet) == "number" then
            if local1[local3].bet == arg1.current_value then
                return TRUE
            end
        else
            local4 = croupier:pick_color(arg1.current_value)
            if local1[local3].bet == local4 then
                return TRUE
            end
        end
        local3 = local3 + 1
    end
    return FALSE
end
roulette_tables = { }
current_roulette_table = nil
gambling_table_number = nil
cn.roulette_game_simulator = function() -- line 394
    local local1, local2
    local local3
    local local4
    local local5 = FALSE
    if not rtable1 then
        rtable1 = Roulette:create("table 1")
        rtable1.currrent_value = rndint(0, 36)
        rtable2 = Roulette:create("table 2")
        rtable2.currrent_value = rndint(0, 36)
        rtable3 = Roulette:create("table 3")
        rtable3.currrent_value = rndint(0, 36)
        roulette_tables[1] = rtable1
        roulette_tables[2] = rtable2
        roulette_tables[3] = rtable3
        gambling_table_number, local3 = next(roulette_tables, nil)
    end
    if system.currentSet == cn then
        rtable1:init_actor()
        rtable2:init_actor()
        rtable3:init_actor()
        turbanman:freeze()
        caneman:freeze()
        fatlady:freeze()
        rtable1.actor:setpos(-0.29497501, -0.16027699, 0.3238)
        rtable2.actor:setpos(0.0019249, -0.67287701, 0.3238)
        rtable3.actor:setpos(-0.58057499, -0.66287702, 0.3238)
        bogen_in_cn = TRUE
        rtable2:magnetize(2)
    end
    if not current_roulette_table then
        bogen_table = rtable2
        current_roulette_table = rtable1
        local4 = rtable3
        rtable1:spin()
        rtable2:spin()
        rtable3:spin()
    end
    sleep_for(1000)
    while 1 do
        if current_roulette_table == bogen_table and bogen_in_cn then
            current_roulette_table:magnetize(2)
        end
        local2 = start_script(current_roulette_table.stop, current_roulette_table)
        if system.currentSet == cn then
            local1 = start_script(croupier.turn_to_table, croupier, current_roulette_table)
            wait_for_script(local1)
        else
            sleep_for(3000)
        end
        wait_for_script(local2)
        if system.currentSet == cn then
        end
        start_script(cn.casino_patrons, cn.SPIN, local4)
        if current_roulette_table == bogen_table and bogen_in_cn and current_roulette_table.current_value == 2 then
            if system.currentSet == cn then
                croupier:thaw(TRUE)
            end
            croupier:say_line("/cncr125/")
            wait_for_message()
            croupier:say_line("/cncr126/")
            wait_for_message()
            croupier:say_line("/cncr127/")
            if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
                croupier:play_chore(1)
                croupier:wait_for_chore()
            end
            wait_for_message()
            if system.currentSet == cn then
            end
            bogen:say_line(pick_one_of({ "/cnbo128/", "/cnbo129/", "/cnbo130/", "/cnbo131/", "/cnbo132/", "/cnbo133/", "/cnbo134/" }))
            wait_for_message()
        else
            if system.currentSet == cn then
                croupier:thaw(TRUE)
            end
            croupier:say_line("/cncr135/")
            wait_for_message()
            croupier:say_french_number(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_color_french(current_roulette_table.current_value)
            wait_for_message()
            croupier:even_odd_manque_passe(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_english_number(current_roulette_table.current_value)
            wait_for_message()
            croupier:say_color_english(current_roulette_table.current_value)
            wait_for_message()
            if current_roulette_table == bogen_table and bogen_in_cn then
                if not bogen.pissed then
                    local1 = start_script(cf.piss_off_bogen)
                    wait_for_script(local1)
                    bogen:free()
                    bogen_in_cn = FALSE
                else
                    start_script(cf.really_piss_off_bogen)
                    return TRUE
                end
            else
                local5 = determine_winner(current_roulette_table)
                if local5 then
                    local5 = FALSE
                    croupier:say_line("/cncr136/")
                    wait_for_message()
                    croupier:say_line("/cncr137/")
                    wait_for_message()
                end
                if system.currentSet == cn then
                end
                local1 = start_script(cn.casino_patrons, cn.WIN, current_roulette_table)
                wait_for_script(local1)
            end
        end
        sleep_for(1000)
        if system.currentSet == cn then
            croupier:thaw(TRUE)
        end
        croupier:say_line("/cncr119/")
        wait_for_message()
        croupier:say_line("/cncr120/")
        wait_for_message()
        if system.currentSet == cn then
        end
        local1 = start_script(cn.casino_patrons, cn.BET, current_roulette_table)
        wait_for_script(local1)
        if system.currentSet == cn then
            croupier:thaw(TRUE)
        end
        croupier:say_line("/cncr121/")
        wait_for_message()
        croupier:say_line("/cncr122/")
        wait_for_message()
        croupier:say_line("/cncr123/")
        wait_for_message()
        croupier:say_line("/cncr124/")
        croupier:wait_for_message()
        if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
            croupier:play_chore(1)
            sleep_for(600)
            start_sfx("cnRoulet.imu")
            sleep_for(1008)
        end
        current_roulette_table:spin()
        local4 = current_roulette_table
        gambling_table_number, local3 = next(roulette_tables, gambling_table_number)
        if not local3 then
            gambling_table_number, local3 = next(roulette_tables, nil)
        end
        current_roulette_table = local3
        if system.currentSet == cn then
            croupier:wait_for_chore()
        end
    end
end
cn.charlie_idles = function() -- line 570
    local local1
    charlie.stop_idle = FALSE
    charlie:stop_chore(cc_booth_idles_sit_pose)
    while not charlie.stop_idle do
        charlie:play_chore(cc_booth_idles_smoke)
        charlie:wait_for_chore()
        local1 = rndint(10, 30)
        repeat
            sleep_for(10)
            local1 = local1 - 1
        until local1 < 0 or charlie.stop_idle
    end
end
cn.set_up_actors = function(arg1) -- line 587
    if bogen.pissed then
        if cn.bogens_in_the_house_again then
            cn.bogen_obj:make_touchable()
            bogen:set_costume("bogen.cos")
            bogen:put_in_set(cn)
            bogen:setpos(0.370565, -0.611363, 0)
            bogen:set_mumble_chore(bogen_mumble)
            bogen:set_talk_chore(1, bogen_stop_talk)
            bogen:set_talk_chore(2, bogen_a)
            bogen:set_talk_chore(3, bogen_c)
            bogen:set_talk_chore(4, bogen_e)
            bogen:set_talk_chore(5, bogen_f)
            bogen:set_talk_chore(6, bogen_l)
            bogen:set_talk_chore(7, bogen_m)
            bogen:set_talk_chore(8, bogen_o)
            bogen:set_talk_chore(9, bogen_t)
            bogen:set_talk_chore(10, bogen_u)
            start_script(bogen.new_run_idle, bogen, "stand", bogen.idle_table)
            bogen_in_cn = TRUE
            rtable2:magnetize(2)
        else
            cn.bogen_obj:make_untouchable()
        end
    else
        bogen_in_cn = TRUE
        if not bogen.hCos then
            bogen.hCos = "bogen.cos"
        end
        bogen:set_costume(bogen.hCos)
        bogen:put_in_set(cn)
        bogen:setpos(0.370565, -0.611363, 0)
        bogen:setrot(0, 160, 0)
        bogen:set_mumble_chore(bogen_mumble)
        bogen:set_talk_chore(1, bogen_stop_talk)
        bogen:set_talk_chore(2, bogen_a)
        bogen:set_talk_chore(3, bogen_c)
        bogen:set_talk_chore(4, bogen_e)
        bogen:set_talk_chore(5, bogen_f)
        bogen:set_talk_chore(6, bogen_l)
        bogen:set_talk_chore(7, bogen_m)
        bogen:set_talk_chore(8, bogen_o)
        bogen:set_talk_chore(9, bogen_t)
        bogen:set_talk_chore(10, bogen_u)
        start_script(bogen.new_run_idle, bogen, "stand", bogen.idle_table, "bogen.cos")
    end
    if not tix_printer then
        tix_printer = Actor:create(nil, nil, nil, "printer")
    end
    if cn.printer.owner ~= manny then
        tix_printer:set_costume("mc_booth_idles.cos")
        tix_printer:setpos(0.863729, -0.142364, 0.00900003)
        tix_printer:setrot(0, 0.29, 0)
        tix_printer:set_visibility(FALSE)
        tix_printer:put_in_set(cn)
        tix_printer:play_chore(mc_booth_idles_printer_only)
    end
    croupier:set_costume("spinner.cos")
    croupier:set_mumble_chore(spinner_mumble)
    croupier:set_talk_chore(1, spinner_stop_talk)
    croupier:set_talk_chore(2, spinner_a)
    croupier:set_talk_chore(3, spinner_c)
    croupier:set_talk_chore(4, spinner_e)
    croupier:set_talk_chore(5, spinner_f)
    croupier:set_talk_chore(6, spinner_l)
    croupier:set_talk_chore(7, spinner_m)
    croupier:set_talk_chore(8, spinner_o)
    croupier:set_talk_chore(9, spinner_t)
    croupier:set_talk_chore(10, spinner_u)
    croupier:set_head(3, 4, 5, 200, 28, 80)
    croupier:set_turn_chores(spinner_swvl_left, spinner_swvl_right)
    croupier:set_turn_rate(15)
    croupier:put_in_set(cn)
    croupier:follow_boxes()
    croupier:setpos(-0.199975, -0.468877, 0)
    if hh.union_card.owner == manny then
        cn.charlie_obj:make_untouchable()
    else
        charlie:set_costume("ccharlie.cos")
        charlie:set_mumble_chore(ccharlie_mumble)
        charlie:set_talk_chore(1, ccharlie_no_talk)
        charlie:set_talk_chore(2, ccharlie_a)
        charlie:set_talk_chore(3, ccharlie_c)
        charlie:set_talk_chore(4, ccharlie_e)
        charlie:set_talk_chore(5, ccharlie_f)
        charlie:set_talk_chore(6, ccharlie_l)
        charlie:set_talk_chore(7, ccharlie_m)
        charlie:set_talk_chore(8, ccharlie_o)
        charlie:set_talk_chore(9, ccharlie_t)
        charlie:set_talk_chore(10, ccharlie_u)
        charlie:push_costume("cc_booth_idles.cos")
        charlie:put_in_set(cn)
        charlie:setpos(0.917252, 0.259107, -0.0515)
        charlie:setrot(0, 180, 0)
        start_script(cn.charlie_idles)
    end
    if not turbanman then
        turbanman = Actor:create(nil, nil, nil, "turbanman")
        caneman = Actor:create(nil, nil, nil, "caneman")
        fatlady = Actor:create(nil, nil, nil, "fatlady")
    end
    turbanman:set_costume("turbanman.cos")
    turbanman:put_in_set(cn)
    turbanman:setpos(-0.510075, 0.124623, 0)
    turbanman:setrot(0, 220, 0)
    turbanman:play_chore(turbanman_base_pose)
    caneman:set_costume("caneman.cos")
    caneman:put_in_set(cn)
    if bogen.pissed and not cn.bogens_in_the_house_again then
        caneman:setpos(-0.0635751, -0.992476, 0)
        caneman:setrot(0, 300, 0)
    else
        caneman:setpos(-0.695394, -0.293976, 0)
        caneman:setrot(0, 180, 0)
    end
    caneman:play_chore(caneman_base_pose)
    fatlady:set_costume("fatlady.cos")
    fatlady:put_in_set(cn)
    fatlady:setpos(-0.915694, -0.588876, 0)
    fatlady:setrot(0, 215, 0)
    fatlady:play_chore(fatlady_base_pose)
    if rtable1 then
        rtable1:init_actor()
        rtable2:init_actor()
        rtable3:init_actor()
        rtable1.actor:setpos(-0.294975, -0.160277, 0.3238)
        rtable2.actor:setpos(0.0019249, -0.672877, 0.3238)
        rtable3.actor:setpos(-0.580575, -0.662877, 0.3238)
        if current_roulette_table == rtable1 then
            croupier:setrot(0, 0, 0)
        elseif current_roulette_table == rtable2 then
            croupier:setrot(0, 260, 0)
        else
            croupier:setrot(0, 120, 0)
        end
    end
end
cn.return_bogen = function() -- line 743
    made_vacancy = TRUE
    hh.union_card.owner = manny
    dd.strike_on = TRUE
end
cn.enter = function(arg1) -- line 749
    cn.pause_spinning = FALSE
    if made_vacancy and hh.union_card.owner == manny and dd.strike_on then
        cn.bogens_in_the_house_again = TRUE
    end
    if not find_script(cn.roulette_game_simulator) then
        start_script(cn.roulette_game_simulator)
    end
    cn:set_up_actors()
    preload_sfx("cnRoulet.imu")
    preload_sfx("cnRouStp.wav")
end
cn.exit = function(arg1) -- line 764
    bogen:free()
    croupier:free()
    charlie:free()
    caneman:free()
    turbanman:free()
    fatlady:free()
    rtable1.actor:free()
    rtable2.actor:free()
    rtable3.actor:free()
    stop_script(cn.charlie_idles)
    stop_sound("cnRoulet.imu")
    stop_sound("cnRouStp.wav")
    tix_printer:free()
end
cn.charlie_obj = Object:create(cn, "Charlie", 0.85364002, 0.21664301, 0.38, { range = 0.80000001 })
cn.charlie_obj.use_pnt_x = 0.92835897
cn.charlie_obj.use_pnt_y = -0.266837
cn.charlie_obj.use_pnt_z = 0
cn.charlie_obj.use_rot_x = 0
cn.charlie_obj.use_rot_y = 378.05701
cn.charlie_obj.use_rot_z = 0
cn.charlie_obj.lookAt = function(arg1) -- line 792
    manny:say_line("/cnma138/")
end
cn.charlie_obj.pickUp = function(arg1) -- line 796
    manny:say_line("/cnma139/")
end
cn.charlie_obj.use = function(arg1) -- line 800
    if arg1.talked_out then
        manny:say_line("/drma001/")
    else
        START_CUT_SCENE()
        charlie.stop_idle = TRUE
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        wait_for_script(cn.charlie_idles)
        Dialog:run("ch1", "dlg_charlie.lua")
        END_CUT_SCENE()
    end
end
cn.printer = Object:create(cn, "printer", 0, 0, 0, { range = 0 })
cn.printer.lookAt = function(arg1) -- line 818
    if tb.tried_ticket then
        manny:say_line("/cnma140/")
    else
        manny:say_line("/cnma141/")
    end
end
cn.printer.use = function(arg1) -- line 826
    if cn.ticket.owner == manny then
        START_CUT_SCENE()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.ticket
        close_inventory()
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:stop_chore(mc_hold, "mc.cos")
        manny.is_holding = nil
        cn.ticket:free()
        manny:play_chore(mc_toss_stub, "mc.cos")
        manny:wait_for_chore()
        manny:fade_out_chore(mc_toss_stub, "mc.cos", 300)
        open_inventory(TRUE, TRUE)
        manny.is_holding = cn.printer
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
    end
    inventory_save_set = system.currentSet
    inventory_save_setup = system.currentSet:current_setup()
    inventory_save_pos = manny:getpos()
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = tpButtonHandler
    tp:switch_to_set()
end
cn.printer.default_response = function(arg1) -- line 858
    if tb.tried_ticket then
        manny:say_line("/cnma142/")
    else
        manny:say_line("/cnma143/")
    end
end
cn.ticket = Object:create(cn, "betting stub", 0, 0, 0, { range = 0 })
cn.ticket.string_name = "ticket"
cn.ticket.temp_id_number = 0
cn.ticket.wav = "getCard.wav"
cn.ticket.lookAt = function(arg1) -- line 871
    START_CUT_SCENE()
    manny:say_line("/cnma144/")
    manny:wait_for_message()
    if arg1.day == 1 then
        manny:say_line("/cnma145/")
    elseif arg1.day == 2 then
        manny:say_line("/cnma146/")
    elseif arg1.day == 3 then
        manny:say_line("/cnma147/")
    elseif arg1.day == 4 then
        manny:say_line("/cnma148/")
    elseif arg1.day == 5 then
        manny:say_line("/cnma149/")
    elseif arg1.day == 6 then
        manny:say_line("/cnma150/")
    elseif arg1.day == 7 then
        manny:say_line("/cnma151/")
    end
    manny:wait_for_message()
    manny:say_line("/cnma152/")
    manny:wait_for_message()
    manny:say_number(arg1.week)
    manny:wait_for_message()
    manny:say_line("/cnma153/")
    manny:wait_for_message()
    manny:say_number(arg1.race)
    END_CUT_SCENE()
end
cn.ticket.use = cn.ticket.lookAt
cn.pass = Object:create(cn, "V.I.P. pass", 0, 0, 0, { range = 0 })
cn.pass.string_name = "pass"
cn.pass.wav = "getCard.wav"
cn.pass.lookAt = function(arg1) -- line 900
    soft_script()
    manny:say_line("/cnma154/")
    wait_for_message()
    manny:say_line("/bima075/")
end
cn.pass.use = function(arg1) -- line 908
    manny:say_line("/cnma155/")
end
cn.pass.default_response = cn.pass.use
cn.croupier_obj = Object:create(cn, "Roulette croupier", -0.22641701, -0.450957, 0.41999999, { range = 0.60000002 })
cn.croupier_obj.use_pnt_x = 0.063582897
cn.croupier_obj.use_pnt_y = -0.30095699
cn.croupier_obj.use_pnt_z = 0
cn.croupier_obj.use_rot_x = 0
cn.croupier_obj.use_rot_y = -229.771
cn.croupier_obj.use_rot_z = 0
cn.croupier_obj.lookAt = function(arg1) -- line 922
    soft_script()
    manny:say_line("/cnma156/")
    wait_for_message()
    manny:say_line("/cnma157/")
end
cn.croupier_obj.use = function(arg1) -- line 929
    START_CUT_SCENE()
    cn.pause_spinning = TRUE
    manny:walkto_object(arg1)
    croupier:wait_for_message()
    manny:say_line("/cnma158/")
    wait_for_message()
    croupier:head_look_at_manny()
    if bogen.pissed then
        if not cn.bogens_in_the_house_again then
            croupier:say_line_manny("/cncr159/")
            wait_for_message()
            manny:say_line("/cnma160/")
            wait_for_message()
            croupier:say_line_manny("/cncr161/")
        else
            croupier:say_line_manny("/cncr162/")
            wait_for_message()
            croupier:say_line_manny("/cncr163/")
        end
    else
        croupier:say_line_manny("/cncr164/")
    end
    croupier:head_look_at(nil)
    wait_for_message()
    sleep_for(500)
    cn.pause_spinning = FALSE
    END_CUT_SCENE()
end
cn.gamblers = Object:create(cn, "gamblers", -0.531515, 0.110031, 0.38999999, { range = 0.80000001 })
cn.gamblers.use_pnt_x = 0.0084851598
cn.gamblers.use_pnt_y = 0.110031
cn.gamblers.use_pnt_z = 0
cn.gamblers.use_rot_x = 0
cn.gamblers.use_rot_y = 129.875
cn.gamblers.use_rot_z = 0
cn.gamblers.lookAt = function(arg1) -- line 969
    manny:say_line("/cnma165/")
    wait_for_message()
    manny:say_line("/cnma166/")
end
cn.gamblers.pickUp = function(arg1) -- line 975
    manny:say_line("/cnma167/")
end
cn.gamblers.use = function(arg1) -- line 979
    manny:say_line("/cnma168/")
end
cn.bogen_obj = Object:create(cn, "Bogen", 0.370565, -0.61136299, 0.34999999, { range = 0.60000002 })
cn.bogen_obj.use_pnt_x = 0.41056499
cn.bogen_obj.use_pnt_y = -0.30136299
cn.bogen_obj.use_pnt_z = 0
cn.bogen_obj.use_rot_x = 0
cn.bogen_obj.use_rot_y = 185.45
cn.bogen_obj.use_rot_z = 0
cn.bogen_obj.lookAt = function(arg1) -- line 991
    soft_script()
    manny:say_line("/cnma169/")
    wait_for_message()
    manny:say_line("/cnma170/")
end
cn.bogen_obj.pickUp = cn.gamblers.pickUp
cn.bogen_obj.use = function(arg1) -- line 1000
    START_CUT_SCENE()
    if cn.bogens_in_the_house_again and bogen.pissed then
        manny:say_line("/cnma171/")
        wait_for_message()
        bogen:say_line("/cnbo172/")
    else
        manny:say_line("/cnma173/")
        wait_for_message()
        bogen:say_line("/cnbo174/")
    end
    END_CUT_SCENE()
end
cn.bogen_obj.use_key = function(arg1) -- line 1015
    soft_script()
    manny:say_line("/slma205/")
    manny:wait_for_message()
    manny:say_line("/slma206/")
end
cn.ci_door = Object:create(cn, "/cntx249/door", -0.58838499, 1.69042, 0.63999999, { range = 0.60000002 })
cn.ci_door.use_pnt_x = -0.640468
cn.ci_door.use_pnt_y = 0.35423601
cn.ci_door.use_pnt_z = 0
cn.ci_door.use_rot_x = 0
cn.ci_door.use_rot_y = 2.3106101
cn.ci_door.use_rot_z = 0
cn.ci_door.out_pnt_x = -0.62948501
cn.ci_door.out_pnt_y = 1.61693
cn.ci_door.out_pnt_z = 0.1
cn.ci_door.out_rot_x = 0
cn.ci_door.out_rot_y = 8.0328197
cn.ci_door.out_rot_z = 0
cn.ci_box = cn.ci_door
cn.ci_door.walkOut = function(arg1) -- line 1044
    START_CUT_SCENE()
    manny:walkto_object(cn.ci_door, TRUE)
    manny:wait_for_actor()
    END_CUT_SCENE()
    ci:come_out_door(ci.cn_door)
end

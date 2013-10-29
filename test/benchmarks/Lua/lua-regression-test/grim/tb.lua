CheckFirstTime("tb.lua")
dofile("doug_idles.lua")
dofile("ma_photopass.lua")
tb = Set:create("tb.set", "track betting", { tb_fotws = 1, tb_strws = 0, tb_strws2 = 0, tb_strws3 = 0, tb_strws4 = 0, tb_overhead = 2 })
tb.show_room = function(arg1) -- line 17
    START_CUT_SCENE()
    cameraman_disabled = FALSE
    manny:walkto(-0.619026, -0.0328044, 0, 0, 272.47, 0)
    manny:wait_for_actor()
    manny:head_look_at_point({ x = 1.84646, y = -0.367253, z = 0.595 })
    manny:say_line("/lyma009/")
    manny:point_gesture()
    manny:wait_for_message()
    manny:walkto(0.723649, -0.690082, 0, 0, 306.381, 0)
    while point_proximity(0.723649, -0.690082, 0) > 0.4 do
        break_here()
    end
    tw:switch_to_set()
    manny:head_look_at(nil)
    manny:put_in_set(tw)
    manny:setpos(0.938004, -0.50864, 0)
    manny:setrot(0, 309.019, 0)
    manny:head_look_at(tw.track)
    manny:walkto(tw.track)
    manny:wait_for_actor()
    tw.track:lookAt()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
tb.crowd_cheer = function(arg1) -- line 43
    local local1
    if arg1 or rndint(100) < 40 then
        local1 = pick_one_of({ "tkCheer1.wav", "tkCheer2.wav", "tkCheer3.wav", "tkCheer4.wav" })
        if system.currentSet == tb then
            vol = 65
        elseif system.currentSet == tw then
            vol = 65
        elseif system.currentSet == ts then
            vol = 80
        elseif system.currentSet == ks then
            vol = 30
        elseif system.currentSet == kh then
            vol = 40
        else
            vol = 0
        end
        if vol > 0 then
            start_sfx(local1, IM_LOW_PRIORITY, vol)
            set_pan(local1, rndint(30, 100))
        end
    end
end
tb.off_screen_kittys = function() -- line 71
    local local1
    local local2
    while 1 do
        sleep_for(rnd(6000, 12000))
        if not cat_race_running then
            local1 = pick_one_of({ "kitty1.wav", "kitty2.wav", "kitty3.wav", "kitty4.wav", "kitty5.wav" })
            if system.currentSet == tb then
                local2 = 30
            elseif system.currentSet == tw then
                local2 = 30
            elseif system.currentSet == ts then
                local2 = 35
            elseif system.currentSet == ks then
                local2 = 45
            elseif system.currentSet == kh then
                local2 = 55
            else
                local2 = 0
            end
            if local2 > 0 then
                start_sfx(local1, IM_LOW_PRIORITY, local2)
                if rnd() then
                    set_pan(local1, 127)
                else
                    set_pan(local1, 1)
                end
            end
        end
        break_here()
    end
end
tb.init_cat_names = function() -- line 106
    local local1 = 0
    cat_names = { }
    repeat
        local1 = local1 + 1
        cat_names[local1] = { name = nil, racing = nil, odds = 3 }
    until local1 == 60
    cat_names[1].name = "/tbta066/"
    cat_names[2].name = "/tbta067/"
    cat_names[3].name = "/tbta068/"
    cat_names[4].name = "/tbta069/"
    cat_names[5].name = "/tbta070/"
    cat_names[6].name = "/tbta071/"
    cat_names[7].name = "/tbta072/"
    cat_names[8].name = "/tbta073/"
    cat_names[9].name = "/tbta074/"
    cat_names[10].name = "/tbta075/"
    cat_names[11].name = "/tbta076/"
    cat_names[12].name = "/tbta077/"
    cat_names[13].name = "/tbta078/"
    cat_names[14].name = "/tbta079/"
    cat_names[15].name = "/tbta080/"
    cat_names[16].name = "/tbta081/"
    cat_names[17].name = "/tbta082/"
    cat_names[18].name = "/tbta083/"
    cat_names[19].name = "/tbta084/"
    cat_names[20].name = "/tbta085/"
    cat_names[21].name = "/tbta086/"
    cat_names[22].name = "/tbta087/"
    cat_names[23].name = "/tbta088/"
    cat_names[24].name = "/tbta089/"
    cat_names[25].name = "/tbta090/"
    cat_names[26].name = "/tbta091/"
    cat_names[27].name = "/tbta092/"
    cat_names[28].name = "/tbta093/"
    cat_names[29].name = "/tbta094/"
    cat_names[30].name = "/tbta095/"
    cat_names[31].name = "/tbta096/"
    cat_names[32].name = "/tbta097/"
    cat_names[33].name = "/tbta098/"
    cat_names[34].name = "/tbta099/"
    cat_names[35].name = "/tbta100/"
    cat_names[36].name = "/tbta101/"
    cat_names[37].name = "/tbta102/"
    cat_names[38].name = "/tbta103/"
    cat_names[39].name = "/tbta104/"
    cat_names[40].name = "/tbta105/"
    cat_names[41].name = "/tbta106/"
    cat_names[42].name = "/tbta107/"
    cat_names[43].name = "/tbta108/"
    cat_names[44].name = "/tbta109/"
    cat_names[45].name = "/tbta110/"
    cat_names[46].name = "/tbta111/"
    cat_names[47].name = "/tbta112/"
    cat_names[48].name = "/tbta113/"
    cat_names[49].name = "/tbta114/"
    cat_names[50].name = "/tbta115/"
    cat_names[51].name = "/tbta116/"
    cat_names[52].name = "/tbta117/"
    cat_names[53].name = "/tbta118/"
    cat_names[54].name = "/tbta119/"
    cat_names[55].name = "/tbta120/"
    cat_names[56].name = "/tbta121/"
    cat_names[57].name = "/tbta122/"
    cat_names[58].name = "/tbta123/"
    cat_names[59].name = "/tbta124/"
    cat_names[60].name = "/tbta125/"
    local1 = 0
    cat_announcements = { }
    repeat
        local1 = local1 + 1
        cat_announcements[local1] = { say = nil, place = nil }
    until local1 == 44
    cat_announcements[1].say = "/tbta126/"
    cat_announcements[2].say = "/tbta127/"
    cat_announcements[3].say = "/tbta128/"
    cat_announcements[4].say = "/tbta129/"
    cat_announcements[5].say = "/tbta130/"
    cat_announcements[6].say = "/tbta131/"
    cat_announcements[7].say = "/tbta132/"
    cat_announcements[8].say = "/tbta133/"
    cat_announcements[9].say = "/tbta134/"
    cat_announcements[10].say = "/tbta135/"
    cat_announcements[11].say = "/tbta136/"
    cat_announcements[12].say = "/tbta137/"
    cat_announcements[13].say = "/tbta142/"
    cat_announcements[14].say = "/tbta143/"
    cat_announcements[15].say = "/tbta144/"
    cat_announcements[15].place = 1
    cat_announcements[16].say = "/tbta145/"
    cat_announcements[16].place = -8
    cat_announcements[17].say = "/tbta146/"
    cat_announcements[17].place = 3
    cat_announcements[18].say = "/tbta147/"
    cat_announcements[18].place = 1
    cat_announcements[19].say = "/tbta148/"
    cat_announcements[19].place = 2
    cat_announcements[20].say = "/tbta149/"
    cat_announcements[20].place = 3
    cat_announcements[21].say = "/tbta150/"
    cat_announcements[21].place = -5
    cat_announcements[22].say = "/tbta151/"
    cat_announcements[22].place = -3
    cat_announcements[23].say = "/tbta152/"
    cat_announcements[23].place = -1
    cat_announcements[24].say = "/tbta153/"
    cat_announcements[24].place = 2
    cat_announcements[25].say = "/tbta154/"
    cat_announcements[25].place = -1
    cat_announcements[26].say = "/tbta155/"
    cat_announcements[26].place = -8
    cat_announcements[27].say = "/tbta156/"
    cat_announcements[27].place = -8
    cat_announcements[28].say = "/tbta157/"
    cat_announcements[28].place = -8
    cat_announcements[29].say = "/tbta158/"
    cat_announcements[29].place = nil
    cat_announcements[30].say = "/tbta159/"
    cat_announcements[30].place = nil
    cat_announcements[31].say = "/tbta160/"
    cat_announcements[31].place = 97
    cat_announcements[32].say = "/tbta161/"
    cat_announcements[32].place = 98
    cat_announcements[33].say = "/tbta162/"
    cat_announcements[33].place = 3
    cat_announcements[34].say = "/tbta163/"
    cat_announcements[34].place = -1
    cat_announcements[35].say = "/tbta164/"
    cat_announcements[35].place = 1
    cat_announcements[36].say = "/tbta165/"
    cat_announcements[36].place = 2
    cat_announcements[37].say = "/tbta166/"
    cat_announcements[37].place = 3
    cat_announcements[38].say = "/tbta167/"
    cat_announcements[38].place = -1
    cat_announcements[39].say = "/tbta170/"
    cat_announcements[39].place = -2
    cat_announcements[40].say = "/tbta171/"
    cat_announcements[40].place = 3
    cat_announcements[41].say = "/tbta172/"
    cat_announcements[41].place = -1
    cat_announcements[42].say = "/tbta173/"
    cat_announcements[42].place = -1
end
time_announcements = { }
time_announcements[1] = "/tbta138/"
time_announcements[2] = "/tbta139/"
time_announcements[3] = "/tbta140/"
time_announcements[4] = "/tbta141/"
tb.NUMBER_OF_CATS = 8
track_announcer = Actor:create(nil, nil, nil, "announcer")
track_announcer.say_line = function(arg1, arg2) -- line 265
    local local1
    if system.currentSet == tb or system.currentSet == hh or system.currentSet == ts or system.currentSet == tw then
        arg1.sfx_boy = nil
        Actor.say_line(arg1, arg2, { background = TRUE, volume = announcer_volume, skip_log = TRUE })
    elseif system.currentSet == hl then
        arg2 = strsub(arg2, 2)
        local1 = strlen(arg2)
        arg2 = strsub(arg2, 1, local1 - 1)
        arg2 = arg2 .. ".wav"
        arg1.sfx_boy = start_sfx(arg2, IM_LOW_PRIORITY, announcer_volume)
    end
end
track_announcer.wait_for_message = function(arg1) -- line 280
    if arg1.sfx_boy then
        wait_for_sound(arg1.sfx_boy)
    else
        while IsMessageGoing(arg1.hActor) do
            break_here()
        end
    end
end
start_cat_sfx = function(arg1, arg2) -- line 291
    start_sfx(arg1)
    set_pan(arg1, 10)
    if system.currentSet == tb or system.currentSet == tw then
        set_vol(arg1, 100)
    elseif system.currentSet == ts then
        set_vol(arg1, 64)
    elseif system.currentSet == hl then
        set_vol(arg1, 20)
    else
        stop_sound(arg1)
    end
    if not arg2 then
        fade_pan_sfx(arg1, 1800, 100)
    end
end
announcer_volume_setting = function() -- line 309
    while 1 do
        if system.currentSet == tb then
            announcer_volume = 90
        elseif system.currentSet == tw then
            announcer_volume = 115
        elseif system.currentSet == ts then
            announcer_volume = 127
        elseif system.currentSet == hl or system.currentSet == hh then
            announcer_volume = 64
        end
        break_here()
    end
end
tb.cat_paws = function() -- line 325
    local local1 = system.currentSet
    local local2 = 0
    while cat_race_running do
        if system.currentSet == tb or system.currentSet == tw then
            local2 = 35
        elseif system.currentSet == ts then
            local2 = 25
        elseif system.currentSet == hl then
            local2 = 14
        else
            if local2 > 0 then
                fade_sfx("twRaceLp.IMU", 300, 0)
            end
            local2 = 0
        end
        if local2 > 0 then
            single_start_sfx("twRaceLp.IMU")
            set_vol("twRaceLp.imu", local2)
        end
        repeat
            break_here()
        until local1 ~= system.current_set
        local1 = system.currentSet
    end
    fade_sfx("twRaceLp.IMU", 500, 0)
end
tb.pre_race_timer = function() -- line 358
    local local1 = 0
    repeat
        local1 = local1 + 1
        tb.race_countdown_announcement = time_announcements[local1]
        sleep_for(60000)
    until local1 == 4
end
tb.init_cat_race = function() -- line 367
    local local1 = 0
    local local2
    local local3, local4
    local local5
    local local6
    cat_racers = { }
    repeat
        local1 = local1 + 1
        cat_racers[local1] = { name = nil, distance = 0, number = nil, odds = nil }
    until local1 == tb.NUMBER_OF_CATS
    local1 = 0
    repeat
        local1 = local1 + 1
        cat_names[local1].racing = nil
    until local1 == 60
    local1 = 0
    repeat
        local1 = local1 + 1
        repeat
            local2 = rndint(1, 60)
            if not cat_names[local2].racing then
                cat_names[local2].racing = TRUE
                cat_racers[local1].name = cat_names[local2].name
                cat_racers[local1].distance = 1
                cat_racers[local1].number = local2
                cat_racers[local1].odds = cat_names[local2].odds
            end
        until cat_racers[local1].name
    until local1 == tb.NUMBER_OF_CATS
end
tb.cat_race_simulator = function() -- line 404
    local local1 = 0
    local local2
    local local3, local4
    local local5
    local local6
    local local7, local8
    tb.miracle = FALSE
    calculate_cats = TRUE
    cat_race_running = TRUE
    while cat_race_running do
        if calculate_cats then
            local1 = 0
            repeat
                local1 = local1 + 1
                cat_racers[local1].distance = cat_racers[local1].distance + rnd(1, 5) + cat_racers[local1].odds
            until local1 == tb.NUMBER_OF_CATS
            local7 = rnd(1, 100)
            local8 = rnd(1, 100)
            if not tb.miracle and local7 == local8 then
                tb.miracle = TRUE
                cat_racers[tb.NUMBER_OF_CATS].distance = 1000000
                miracle_cat = cat_racers[tb.NUMBER_OF_CATS].name
            end
            local1 = 0
            repeat
                local1 = local1 + 1
                local3 = local1
                local4 = local3 + 1
                while cat_racers[local4] do
                    if cat_racers[local3].distance < cat_racers[local4].distance then
                        local5 = cat_racers[local3].name
                        local6 = cat_racers[local3].distance
                        cat_racers[local3].name = cat_racers[local4].name
                        cat_racers[local3].distnce = cat_racers[local4].distance
                        cat_racers[local4].name = local5
                        cat_racers[local4].distnce = local6
                    end
                    local3 = local3 + 1
                    local4 = local3 + 1
                end
            until local1 == tb.NUMBER_OF_CATS
        end
        break_here()
    end
end
tb.track_announcer = function() -- line 456
    local local1
    local local2 = 1
    local local3, local4
    local local5
    local local6 = FALSE
    while 1 do
        local2 = 1
        cat_race_running = FALSE
        local local7 = start_script(tb.pre_race_timer)
        while find_script(local7) do
            if tb.race_countdown_announcement then
                track_announcer:say_line(tb.race_countdown_announcement)
                tb.race_countdown_announcement = nil
            else
                track_announcer:say_line(cat_announcements[local2].say)
                local2 = local2 + 1
                if local2 == 13 then
                    local2 = 1
                end
            end
            track_announcer:wait_for_message()
            sleep_for(20000)
        end
        track_announcer:say_line(cat_announcements[13].say)
        track_announcer:wait_for_message()
        tb.init_cat_race()
        local2 = 0
        track_announcer:say_line("/tbta164/")
        repeat
            local2 = local2 + 1
            track_announcer:wait_for_message()
            track_announcer:say_line(cat_racers[local2].name)
            track_announcer:wait_for_message()
        until local2 == tb.NUMBER_OF_CATS
        local local8 = start_script(tb.cat_race_simulator)
        sleep_for(2000)
        start_cat_sfx("kittyBel.wav", TRUE)
        sleep_for(500)
        track_announcer:say_line(cat_announcements[14].say)
        tb.crowd_cheer(TRUE)
        single_start_script(tb.cat_paws)
        track_announcer:wait_for_message()
        local6 = FALSE
        local2 = 14
        repeat
            calculate_cats = FALSE
            local2 = local2 + 1
            if cat_announcements[local2].place then
                if tb.miracle and not local6 then
                    local6 = TRUE
                    local2 = local2 - 1
                    track_announcer:say_line(miracle_cat)
                    track_announcer:wait_for_message()
                    track_announcer:say_line("/tbta168/")
                    track_announcer:wait_for_message()
                    track_announcer:say_line("/tbta169/")
                    track_announcer:wait_for_message()
                    tb.crowd_cheer(TRUE)
                elseif cat_announcements[local2].place == 99 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place == 98 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place == 97 then
                    local3 = cat_racers[1]
                    local4 = cat_racers[2]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local4.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                elseif cat_announcements[local2].place < 0 then
                    local5 = abs(cat_announcements[local2].place)
                    local3 = cat_racers[local5]
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                else
                    local5 = abs(cat_announcements[local2].place)
                    local3 = cat_racers[local5]
                    track_announcer:say_line(cat_announcements[local2].say)
                    track_announcer:wait_for_message()
                    track_announcer:say_line(local3.name)
                    track_announcer:wait_for_message()
                end
            else
                track_announcer:say_line(cat_announcements[local2].say)
                track_announcer:wait_for_message()
            end
            tb.crowd_cheer()
            if local2 == 35 or local2 == 36 or local2 == 37 or local2 == 41 or local2 == 42 then
                if local2 == 35 then
                    start_cat_sfx("twCatBy.wav")
                    if system.currentSet == tw then
                        StartMovie("tb_kitty.snm", nil, 168, 398)
                    end
                end
                break_here()
            elseif local2 == 24 then
                start_cat_sfx("twCatBy.wav")
                if system.currentSet == tw then
                    StartMovie("tb_kitty.snm", nil, 168, 398)
                end
            else
                calculate_cats = TRUE
                sleep_for(3000)
            end
        until local2 == 42
        cat_race_running = FALSE
        start_cat_sfx("kittyBel.wav", TRUE)
        tb.crowd_cheer(TRUE)
        if rnd() then
            track_announcer:say_line("/tbta177/")
            track_announcer:wait_for_message()
            track_announcer:say_line("/tbta178/")
            track_announcer:wait_for_message()
            sleep_for(5000)
        end
        track_announcer:say_line("/tbta174/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[1].name)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta175/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[2].name)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta176/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[3].name)
        track_announcer:wait_for_message()
        sleep_for(5000)
        track_announcer:wait_for_message()
        track_announcer:say_line("/tbta179/")
        track_announcer:wait_for_message()
        track_announcer:say_line(cat_racers[1].name)
        track_announcer:wait_for_message()
        local2 = 1
        track_announcer:say_line("/tbta166/")
        repeat
            local2 = local2 + 1
            track_announcer:wait_for_message()
            track_announcer:say_line(cat_racers[local2].name)
            track_announcer:wait_for_message()
            cat_names[cat_racers[local2].number].racing = nil
            if local2 == 1 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 3
            elseif local2 == 2 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 2
            elseif local2 == 3 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds + 1
            elseif local2 == 4 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 0.5
            elseif local2 == 5 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 1
            elseif local2 == 6 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 1.5
            elseif local2 == 7 then
                cat_names[cat_racers[local2].number].odds = cat_names[cat_racers[local2].number].odds - 2
            end
        until local2 == tb.NUMBER_OF_CATS
        sleep_for(2000)
        track_announcer:say_line("/tbta180/")
        sleep_for(30000)
    end
end
tb.goodbye_doug = function(arg1) -- line 654
    if not tb.double_doug then
        tb.double_doug = TRUE
        START_CUT_SCENE()
        stop_script(tb.track_announcer)
        manny:set_visibility(FALSE)
        if arg1 == tb.ts_door then
            doug.look_point = { x = 0.118851, y = -0.539676, z = -0.116 }
            doug.look_point2 = { x = 0.118851, y = 0.875324, z = -0.145 }
        else
            doug.look_point = { x = -0.567064, y = -1.00833, z = 0.495 }
            doug.look_point2 = { x = -0.175, y = 1.4, z = 0.494 }
        end
        tb:current_setup(tb_fotws)
        doug:setpos(-0.0520684, -1.72162, 0)
        doug:setrot(0, -353, 0)
        doug:play_chore(doug_idles_rest, "doug_idles.cos")
        doug:head_look_at_point(doug.look_point, 300)
        sleep_for(1000)
        doug:say_line("/tbdu061/")
        doug:wait_for_message()
        doug:head_look_at(nil)
        doug:say_line("/tbdu062/")
        doug:wait_for_message()
        tb:current_setup(tb_strws)
        sleep_for(2000)
        tb:current_setup(tb_fotws)
        break_here()
        doug:head_look_at_point(doug.look_point, 120)
        sleep_for(1000)
        doug:head_look_at(nil, 120)
        sleep_for(750)
        doug:say_line("/tbdu063/")
        doug:wait_for_message()
        tb:current_setup(tb_strws)
        sleep_for(1500)
        doug:setpos(0.102557, 1.84044, 0)
        doug:fake_walkto(0, 1.63993, 0)
        doug:wait_for_actor()
        doug:setrot(0, -160, 0, TRUE)
        doug:wait_for_actor()
        doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
        doug:say_line("/tbdu064/")
        sleep_for(500)
        doug:head_look_at_point(doug.look_point2, 100)
        sleep_for(750)
        doug:head_look_at(nil, 130)
        doug:wait_for_message()
        doug:say_line("/tbdu065/")
        sleep_for(1300)
        doug:head_look_at_point({ x = 0.077, y = 1.4, z = 0.494 }, 130)
        doug:wait_for_message()
        doug:head_look_at(nil, 130)
        sleep_for(1000)
        END_CUT_SCENE()
        manny:set_visibility(TRUE)
    end
end
tb.search_pockets_for_winning_ticket = function(arg1) -- line 722
    local local1, local2 = next(cn.tickets, nil)
    while local1 do
        if local2.race == 6 and local2.week == 2 and local2.day == 2 and local2.owner == manny then
            return TRUE
        else
            local1, local2 = next(cn.tickets, local1)
        end
    end
    return FALSE
end
tb.get_photo = function(arg1) -- line 738
    if cn.ticket.owner == manny then
        if cn.ticket.race == 6 and cn.ticket.week == 2 and cn.ticket.day == 2 then
            tb.right_photo = TRUE
        else
            tb.right_photo = FALSE
        end
    end
    START_CUT_SCENE()
    doug:say_line("/tbdu001/")
    doug:wait_for_message()
    END_CUT_SCENE()
    if not tb.tried_photo then
        tb.tried_photo = TRUE
        START_CUT_SCENE()
        manny:say_line("/tbma002/")
        manny:wait_for_message()
        doug:say_line("/tbdu003/")
        doug:wait_for_message()
        manny:say_line("/tbma004/")
        manny:wait_for_message()
        doug:say_line("/tbdu005/")
        doug:wait_for_message()
        END_CUT_SCENE()
    end
    if cn.ticket.owner ~= manny then
        START_CUT_SCENE()
        manny:say_line("/tbma006/")
        manny:wait_for_message()
        doug:say_line("/tbdu008/")
        doug:wait_for_message()
        doug:say_line("/tbdu009/")
        doug:fake_walkto(-0.487359, -1.81429, 0)
        doug:wait_for_actor()
        manny:play_chore(ma_photopass_from_cntr)
        manny:wait_for_chore()
        manny:pop_costume()
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        cn.ticket:free()
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:stop_chore(mc_hold, "mc.cos")
        manny:stop_chore(mc_activate_ticket, "mc.cos")
        manny.is_holding = nil
        manny:say_line("/tbma010/")
        manny:wait_for_message()
        manny:stop_chore()
        manny:play_chore(ma_photopass_give_stub)
        doug:play_chore(doug_idles_take_stub)
        cn.ticket:free()
        doug:wait_for_chore()
        if not tb.given_ticket then
            tb.given_ticket = TRUE
            doug:say_line("/tbdu011/")
            doug:wait_for_message()
            manny:say_line("/tbma012/")
            manny:wait_for_message()
        end
        doug:play_chore(doug_idles_rid_stub)
        doug:say_line("/tbdu013/")
        doug:wait_for_message()
        doug:wait_for_chore()
        doug:play_chore(doug_idles_get_photo)
        doug:say_line("/tbdu014/")
        doug:wait_for_message()
        doug:wait_for_chore()
        doug:say_line("/tbdu015/")
        doug:play_chore(doug_idles_give_photo)
        manny:head_look_at(nil)
        manny:play_chore(ma_photopass_take_envelope)
        manny:wait_for_chore()
        doug:wait_for_chore()
        manny:wait_for_chore()
        if tb.right_photo and si.photofinish.owner == manny then
            cur_puzzle_state[32] = TRUE
            tb.time_to_say_goodbye = TRUE
            manny:say_line("/tbma016/")
            manny:wait_for_message()
            doug:say_line("/tbdu017/")
            doug:wait_for_message()
            manny:head_look_at(nil)
            manny:play_chore(ma_photopass_photo_switch)
            manny:say_line("/tbma018/")
            manny:wait_for_message()
            manny:wait_for_chore()
            manny:wait_for_chore(ma_photopass_photo_switch, "ma_photopass.cos")
            manny:play_chore(ma_photopass_return_photo)
            doug:play_chore(doug_idles_take_photo)
            manny:say_line("/tbma019/")
            manny:wait_for_message()
            doug:say_line("/tbdu020/")
            doug:wait_for_chore()
            doug:fake_walkto(-0.387359, -1.81429, 0)
            doug:wait_for_actor()
            tb.blackmail_photo:get()
            si.photofinish:free()
        else
            if not tb.got_wrong_photo then
                tb.got_wrong_photo = TRUE
                manny:say_line("/tbma021/")
                manny:wait_for_message()
                doug:say_line("/tbdu022/")
                doug:wait_for_message()
                manny:say_line("/tbma023/")
            else
                manny:say_line("/tbma024/")
            end
            manny:wait_for_message()
            manny:play_chore(ma_photopass_return_photo)
            doug:say_line("/tbdu025/")
            doug:play_chore(doug_idles_take_photo)
            doug:wait_for_message()
            doug:wait_for_chore()
            doug:fade_out_chore(doug_idles_take_photo, "doug_idles.cos", 500)
            doug:say_line("/tbdu026/")
            manny:wait_for_chore()
            doug:fake_walkto(-0.387359, -1.81429, 0)
            doug:wait_for_actor()
        end
        manny:pop_costume()
        manny:setpos({ x = 0.031, y = -1.19456, z = 0 })
        manny:head_look_at(nil)
        END_CUT_SCENE()
    end
end
tb.set_up_actors = function() -- line 880
    if not doug then
        doug = Actor:create(nil, nil, nil, "Doug")
    end
    doug:set_talk_color(Green)
    doug:set_costume("doug_idles.cos")
    doug:follow_boxes()
    doug:set_walk_rate(0.5)
    doug:put_in_set(tb)
    doug:set_mumble_chore(doug_idles_mumble)
    doug:set_talk_chore(1, doug_idles_stop_talk)
    doug:set_talk_chore(2, doug_idles_a)
    doug:set_talk_chore(3, doug_idles_c)
    doug:set_talk_chore(4, doug_idles_e)
    doug:set_talk_chore(5, doug_idles_f)
    doug:set_talk_chore(6, doug_idles_l)
    doug:set_talk_chore(7, doug_idles_m)
    doug:set_talk_chore(8, doug_idles_o)
    doug:set_talk_chore(9, doug_idles_t)
    doug:set_talk_chore(10, doug_idles_u)
    doug:setpos(0.102557, 1.84044, 0)
    doug:set_head(3, 4, 5, 165, 28, 80)
    if tb.needs_intro and not tb.seen_intro then
        tb.needs_intro = FALSE
        tb.seen_intro = TRUE
        start_script(tb.show_room)
    end
end
tb.enter = function(arg1) -- line 913
    start_script(tb.off_screen_kittys)
    if not find_script(tb.track_announcer) then
        tb.init_cat_names()
        start_script(tb.track_announcer)
    end
    tb.set_up_actors()
end
tb.exit = function() -- line 922
    stop_script(tb.off_screen_kittys)
    doug:free()
end
tb.photo_window = Object:create(tb, "/tbtx028/Window", -0.065300003, -1.5262001, 0.5, { range = 0.80000001 })
tb.photo_window.use_pnt_x = 0
tb.photo_window.use_pnt_y = -1.16456
tb.photo_window.use_pnt_z = 0
tb.photo_window.use_rot_x = 0
tb.photo_window.use_rot_y = 180
tb.photo_window.use_rot_z = 0
tb.photo_window.lookAt = function(arg1) -- line 940
    if not tb.photo_window.tried then
        system.default_response("nobody")
    else
        manny:say_line("/tbma029/")
    end
end
tb.photo_window.use = function(arg1) -- line 948
    tb.photo_window.tried = TRUE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("ma_photopass.cos")
    if manny.is_holding then
        manny:blend(ma_photopass_to_counter, ms_hold, 500, "ma_photopass.cos", manny.base_costume)
        sleep_for(500)
        manny:stop_chore(ms_hold, "mc.cos")
    else
        manny:play_chore(ma_photopass_to_counter)
    end
    manny:say_line("/tbma030/")
    manny:wait_for_message()
    manny:wait_for_chore()
    doug:setpos(-0.387359, -1.81429, 0)
    doug:fake_walkto(-0.0520684, -1.72162, 0)
    doug:wait_for_actor()
    doug:setrot(0, -353, 0, TRUE)
    doug:wait_for_actor()
    doug:stop_chore()
    doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
    doug:say_line("/tbdu031/")
    doug:wait_for_message()
    END_CUT_SCENE()
    tb:get_photo()
end
tb.photo_window.use_ticket = tb.photo_window.use
tb.bet_window = Object:create(tb, "/tbtx032/window", 0, 1.49, 0.44999999, { range = 0.80000001 })
tb.bet_window.use_pnt_x = -0.086491302
tb.bet_window.use_pnt_y = 1.08706
tb.bet_window.use_pnt_z = 0
tb.bet_window.use_rot_x = 0
tb.bet_window.use_rot_y = 1440.04
tb.bet_window.use_rot_z = 0
tb.bet_window.lookAt = function(arg1) -- line 988
    if not tb.bet_window.tried then
        system.default_response("nobody")
    else
        manny:say_line("/tbma033/")
    end
end
tb.bet_window.use = function(arg1) -- line 996
    local local1
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("ma_photopass.cos")
    if manny.is_holding then
        manny:blend(ma_photopass_to_counter, ms_hold, 500, "ma_photopass.cos", manny.base_costume)
        sleep_for(500)
        manny:stop_chore(ms_hold, "mc.cos")
    else
        manny:play_chore(ma_photopass_to_counter)
    end
    manny:say_line("/tbma034/")
    manny:wait_for_message()
    doug:setpos(0.102557, 1.84044, 0)
    doug:fake_walkto(0, 1.63993, 0)
    doug:wait_for_actor()
    doug:setrot(0, -160, 0, TRUE)
    doug:wait_for_actor()
    doug:fade_in_chore(doug_idles_rest, "doug_idles.cos", 800)
    if not arg1.tried then
        arg1.tried = TRUE
        doug:say_line("/tbdu035/")
        sleep_for(800)
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:wait_for_message()
        manny:say_line("/tbma036/")
        manny:wait_for_message()
        doug:say_line("/tbdu037/")
        doug:wait_for_message()
        manny:say_line("/tbma038/")
        manny:wait_for_message()
        doug:say_line("/tbdu039/")
        doug:push_chore(doug_idles_nod)
        doug:push_chore()
        doug:push_chore(doug_idles_nod)
        doug:push_chore()
        doug:wait_for_message()
        manny:say_line("/tbma040/")
        manny:wait_for_message()
        doug:say_line("/tbdu041/")
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:push_chore(doug_idles_shake_left)
        doug:push_chore()
        doug:wait_for_message()
        if cn.ticket.owner == manny then
            manny:say_line("/tbma042/")
        else
            manny:say_line("/tbma043/")
        end
        manny:wait_for_message()
    else
        doug:say_line("/tbdu044/")
        doug:wait_for_message()
    end
    local1 = "rest"
    if cn.ticket.owner == manny then
        local1 = "rid"
        cn.ticket:free()
        manny:say_line("/tbma045/")
        manny:wait_for_message()
        manny:play_chore(ma_photopass_give_stub)
        doug:play_chore(doug_idles_take_stub)
        doug:wait_for_chore()
        doug:say_line("/tbdu046/")
        doug:wait_for_message()
        doug:play_chore(doug_idles_rid_stub)
        if tb.tried_fake then
            doug:say_line("/tbdu047/")
        else
            tb.tried_fake = TRUE
            doug:say_line("/tbdu048/")
            doug:wait_for_message()
            manny:say_line("/tbma049/")
        end
        doug:wait_for_chore()
    end
    manny:wait_for_message()
    if local1 == "rest" then
        doug:fade_out_chore(doug_idles_rest, "doug_idles.cos", 500)
    else
        doug:fade_out_chore(doug_idles_rid_stub, "doug_idles.cos", 500)
    end
    doug:say_line("/tbdu050/")
    doug:wait_for_message()
    manny:play_chore(ma_photopass_from_cntr)
    doug:fake_walkto(0.102557, 1.84044, 0)
    doug:wait_for_actor()
    manny:wait_for_chore(ma_photopass_from_cntr, "ma_photopass.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
tb.bet_window.use_ticket = tb.bet_window.use
tb.blackmail_photo = Object:create(tb, "/tbtx051/incriminating photo", 0, 0, 0, { range = 0 })
tb.blackmail_photo.string_name = "blackmail"
tb.blackmail_photo.wav = "getcard.wav"
tb.blackmail_photo.lookAt = function(arg1) -- line 1104
    manny:say_line("/tbma052/")
end
tb.blackmail_photo.use = tb.blackmail_photo.lookAt
tb.blackmail_photo.default_response = function(arg1) -- line 1110
    manny:say_line("/tbma053/")
end
tb.bet_obj = Object:create(tb, "", -0.173969, 1.63993, 0, { range = 0 })
tb.bet_obj.use_pnt_x = -0.173969
tb.bet_obj.use_pnt_y = 1.63993
tb.bet_obj.use_pnt_z = 0
tb.bet_obj.use_rot_x = 0
tb.bet_obj.use_rot_y = -160.77299
tb.bet_obj.use_rot_z = 0
tb.photo_obj = Object:create(tb, "", 0.072068401, -1.72162, 0, { range = 0 })
tb.photo_obj.use_pnt_x = 0.072068401
tb.photo_obj.use_pnt_y = -1.72162
tb.photo_obj.use_pnt_z = 0
tb.photo_obj.use_rot_x = 0
tb.photo_obj.use_rot_y = -352.745
tb.photo_obj.use_rot_z = 0
tb.ts_door = Object:create(tb, "/tbtx056/door", 0.80000001, 0, -0.1, { range = 0 })
tb.ts_door.use_pnt_x = 0.33327299
tb.ts_door.use_pnt_y = -0.0051976298
tb.ts_door.use_pnt_z = -0.26751199
tb.ts_door.use_rot_x = 0
tb.ts_door.use_rot_y = -87.913498
tb.ts_door.use_rot_z = 0
tb.ts_door.out_pnt_x = 0.68868601
tb.ts_door.out_pnt_y = 0.01196
tb.ts_door.out_pnt_z = -0.45457199
tb.ts_door.out_rot_x = 0
tb.ts_door.out_rot_y = -87.913498
tb.ts_door.out_rot_z = 0
tb.ts_box = tb.ts_door
tb.ts_door.walkOut = function(arg1) -- line 1160
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    ts:come_out_door(ts.tb_door)
end
tb.hh_door = Object:create(tb, "/tbtx057/door", -0.80000001, 2.2, 0.54000002, { range = 0 })
tb.hh_door.use_pnt_x = -0.82007802
tb.hh_door.use_pnt_y = 1.23658
tb.hh_door.use_pnt_z = -3.7268402e-09
tb.hh_door.use_rot_x = 0
tb.hh_door.use_rot_y = -0.674227
tb.hh_door.use_rot_z = 0
tb.hh_door.out_pnt_x = -0.81631702
tb.hh_door.out_pnt_y = 1.5407701
tb.hh_door.out_pnt_z = 0.103325
tb.hh_door.out_rot_x = 0
tb.hh_door.out_rot_y = -0.674227
tb.hh_door.out_rot_z = 0
tb.hh_box = tb.hh_door
tb.hh_door.walkOut = function(arg1) -- line 1185
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    hh:come_out_door(hh.tb_door)
end
tb.gt_door = Object:create(tb, "/tbtx058/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.gt_door.use_pnt_x = -1.73559
tb.gt_door.use_pnt_y = 0.057845
tb.gt_door.use_pnt_z = 0.206
tb.gt_door.use_rot_x = 0
tb.gt_door.use_rot_y = -2071.6899
tb.gt_door.use_rot_z = 0
tb.gt_door.out_pnt_x = -3.5209701
tb.gt_door.out_pnt_y = 0.0504007
tb.gt_door.out_pnt_z = 0.98903102
tb.gt_door.out_rot_x = 0
tb.gt_door.out_rot_y = -2057.8101
tb.gt_door.out_rot_z = 0
tb.gt_box = tb.gt_door
tb.gt_door.walkOut = function(arg1) -- line 1211
    if tb.time_to_say_goodbye and not tb.said_goodbye then
        tb.goodbye_doug(arg1)
    end
    gt:come_out_door(gt.tb_door)
end
tb.tw_door = Object:create(tb, "/tbtx059/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.tw_door.use_pnt_x = 0
tb.tw_door.use_pnt_y = 0
tb.tw_door.use_pnt_z = 0
tb.tw_door.use_rot_x = 0
tb.tw_door.use_rot_y = 0
tb.tw_door.use_rot_z = 0
tb.tw_door.out_pnt_x = 0
tb.tw_door.out_pnt_y = 0
tb.tw_door.out_pnt_z = 0
tb.tw_door.out_rot_x = 0
tb.tw_door.out_rot_y = 0
tb.tw_door.out_rot_z = 0
tb.tw_box = tb.tw_door
tb.tw_door.walkOut = function(arg1) -- line 1235
    local local1, local2, local3
    START_CUT_SCENE()
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    tw:switch_to_set()
    PutActorInSet(system.currentActor.hActor, tw.setFile)
    PutActorAt(system.currentActor.hActor, local1, local2, local3)
    END_CUT_SCENE()
end
tb.tw1_door = Object:create(tb, "/tbtx060/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tb.tw1_door.use_pnt_x = 0
tb.tw1_door.use_pnt_y = 0
tb.tw1_door.use_pnt_z = 0
tb.tw1_door.use_rot_x = 0
tb.tw1_door.use_rot_y = 0
tb.tw1_door.use_rot_z = 0
tb.tw1_door.out_pnt_x = 0
tb.tw1_door.out_pnt_y = 0
tb.tw1_door.out_pnt_z = 0
tb.tw1_door.out_rot_x = 0
tb.tw1_door.out_rot_y = 0
tb.tw1_door.out_rot_z = 0
tb.tw1_box = tb.tw1_door
tb.tw1_door.walkOut = function(arg1) -- line 1262
    local local1, local2, local3
    START_CUT_SCENE()
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    tw:switch_to_set()
    PutActorInSet(system.currentActor.hActor, tw.setFile)
    PutActorAt(system.currentActor.hActor, local1, local2, local3)
    END_CUT_SCENE()
end

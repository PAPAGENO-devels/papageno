CheckFirstTime("fo.lua")
fo = Set:create("fo.set", "foremans office", { fo_berws = 0, fo_berws2 = 0, fo_berws3 = 0, fo_berws4 = 0, fo_bercu = 1, fo_bercu2 = 1, fo_bercu3 = 1, fo_ovrhd = 2 })
fo.shrinkable = 0.018
dofile("bibi_work_idles.lua")
dofile("bibi_talk_idles.lua")
dofile("pu_work_idles.lua")
dofile("pu_talk_idles.lua")
dofile("pu_argue.lua")
dofile("bibi_argue.lua")
dofile("angelito_scripts.lua")
dofile("fo_door.lua")
fo.random_hammer_sound = function(arg1, arg2) -- line 24
    arg2:play_sound_at(pick_one_of({ "foHamr1.WAV", "foHamr2.WAV", "foHamr3.WAV", "foHamr4.WAV" }), 10, 100)
end
fo.random_chisel_sound = function(arg1, arg2) -- line 28
    arg2:play_sound_at(pick_one_of({ "foFile1.WAV", "foFile2.WAV", "foFile3.WAV", "foFile4.WAV" }), 10, 60)
end
fo.watch_costume_events = function(arg1) -- line 32
    while 1 do
        if pu_work_idles_event then
            if pu_work_idles_event == 0 then
                pugsy_stuff:complete_chore(pu_work_idles_show_nothing, "pu_work_idles.cos")
            elseif pu_work_idles_event == 1 then
                pugsy_stuff:complete_chore(pu_work_idles_stick_only, "pu_work_idles.cos")
            elseif pu_work_idles_event == 2 then
                pugsy_stuff:complete_chore(pu_work_idles_scrap_only, "pu_work_idles.cos")
            elseif pu_work_idles_event == 3 then
                pugsy_stuff:complete_chore(pu_work_idles_coral_only, "pu_work_idles.cos")
            elseif pu_work_idles_event == 4 then
                pugsy_stuff:complete_chore(pu_work_idles_stick_coral_only, "pu_work_idles.cos")
            elseif pu_work_idles_event == 5 then
                pugsy_stuff:complete_chore(pu_work_idles_axe_only, "pu_work_idles.cos")
            elseif pu_work_idles_event == 6 then
                pugsy:play_chore(pu_talk_idles_a, "pu_talk_idles.cos")
            elseif pu_work_idles_event == 7 then
                pugsy:play_chore(pu_talk_idles_u, "pu_talk_idles.cos")
            elseif pu_work_idles_event == 8 then
                pugsy:play_chore(pu_talk_idles_stop_talk, "pu_talk_idles.cos")
            elseif pu_work_idles_event == 9 then
                fo:random_hammer_sound(pugsy)
            elseif pu_work_idles_event == 10 then
                fo:random_chisel_sound(pugsy)
            else
                PrintDebug("Unknown event for pu_work_idles!\n")
            end
            pu_work_idles_event = nil
        end
        if bibi_work_idles_event then
            if bibi_work_idles_event == 0 then
                bibi_stuff:complete_chore(bibi_work_idles_show_nothing, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 1 then
                bibi_stuff:complete_chore(bibi_work_idles_stick_only, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 2 then
                bibi_stuff:complete_chore(bibi_work_idles_scrap_only, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 3 then
                bibi_stuff:complete_chore(bibi_work_idles_coral_only, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 4 then
                bibi_stuff:complete_chore(bibi_work_idles_stick_coral_only, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 5 then
                fo.ricochet:play_chore(bibi_work_idles_ricochet, "bibi_work_idles.cos")
            elseif bibi_work_idles_event == 6 then
                bibi:play_chore(bibi_talk_idles_a, "bibi_talk_idles.cos")
            elseif bibi_work_idles_event == 7 then
                bibi:play_chore(bibi_talk_idles_u, "bibi_talk_idles.cos")
            elseif bibi_work_idles_event == 8 then
                bibi:play_chore(bibi_talk_idles_stop_talk, "bibi_talk_idles.cos")
            elseif bibi_work_idles_event == 9 then
                fo:random_hammer_sound(bibi)
            elseif bibi_work_idles_event == 10 then
                fo:random_chisel_sound(bibi)
            else
                PrintDebug("Unknown event for bibi_work_idles!\n")
            end
            bibi_work_idles_event = nil
        end
        break_here()
    end
end
fo.set_up_actors = function(arg1) -- line 100
    if meche_freed then
        bibi:free()
        pugsy:free()
        fo.pugsy_obj:make_untouchable()
        fo.bibi_obj:make_untouchable()
    else
        bibi:put_in_set(fo)
        bibi:setpos(0.085, -0.155, 0.66)
        pugsy:free()
        pugsy:put_in_set(fo)
        pugsy:set_costume("pu_talk_idles.cos")
        pugsy:set_mumble_chore(pu_talk_idles_mumble, "pu_talk_idles.cos")
        pugsy:set_talk_chore(1, pu_talk_idles_stop_talk)
        pugsy:set_talk_chore(2, pu_talk_idles_a)
        pugsy:set_talk_chore(3, pu_talk_idles_c)
        pugsy:set_talk_chore(4, pu_talk_idles_e)
        pugsy:set_talk_chore(5, pu_talk_idles_f)
        pugsy:set_talk_chore(6, pu_talk_idles_l)
        pugsy:set_talk_chore(7, pu_talk_idles_m)
        pugsy:set_talk_chore(8, pu_talk_idles_o)
        pugsy:set_talk_chore(9, pu_talk_idles_t)
        pugsy:set_talk_chore(10, pu_talk_idles_u)
        pugsy:push_costume("pu_work_idles.cos")
        pugsy:set_head(6, 7, 8, 165, 28, 80)
        pugsy:set_look_rate(130)
        pugsy:setpos(-0.07735, -0.17651, 0.32896)
        pugsy:setrot(0, 250.13, 0)
        if not pugsy_stuff then
            pugsy_stuff = Actor:create()
        end
        pugsy_stuff:set_costume("pu_work_idles.cos")
        pugsy_stuff:put_in_set(fo)
        pugsy_stuff:setpos(-0.07735, -0.17651, 0.32896)
        pugsy_stuff:setrot(0, 250.13, 0)
        pugsy_stuff:complete_chore(pu_work_idles_show_nothing, "pu_work_idles.cos")
        if fo.hammer_thrown then
            pugsy:complete_chore(pu_work_idles_hide_hammer, "pu_work_idles.cos")
        else
            pugsy:complete_chore(pu_work_idles_show_hammer, "pu_work_idles.cos")
        end
        bibi:free()
        bibi:put_in_set(fo)
        bibi:set_costume("bibi_talk_idles.cos")
        bibi:set_mumble_chore(bibi_talk_idles_mumble, "bibi_talk_idles.cos")
        bibi:set_talk_chore(1, bibi_talk_idles_stop_talk)
        bibi:set_talk_chore(2, bibi_talk_idles_a)
        bibi:set_talk_chore(3, bibi_talk_idles_c)
        bibi:set_talk_chore(4, bibi_talk_idles_e)
        bibi:set_talk_chore(5, bibi_talk_idles_f)
        bibi:set_talk_chore(6, bibi_talk_idles_l)
        bibi:set_talk_chore(7, bibi_talk_idles_m)
        bibi:set_talk_chore(8, bibi_talk_idles_o)
        bibi:set_talk_chore(9, bibi_talk_idles_t)
        bibi:set_talk_chore(10, bibi_talk_idles_u)
        bibi:push_costume("bibi_work_idles.cos")
        bibi:set_head(6, 7, 8, 165, 28, 80)
        bibi:set_look_rate(125)
        bibi:setpos(0.05654, -0.09785, 0.58611)
        bibi:setrot(0, 210, 0)
        if not bibi_stuff then
            bibi_stuff = Actor:create()
        end
        bibi_stuff:set_costume("bibi_work_idles.cos")
        bibi_stuff:put_in_set(fo)
        bibi_stuff:setpos(0.05654, -0.09785, 0.58611)
        bibi_stuff:setrot(0, 210, 0)
        bibi_stuff:complete_chore(bibi_work_idles_show_nothing, "bibi_work_idles.cos")
        if not fo.ricochet then
            fo.ricochet = Actor:create()
        end
        fo.ricochet:set_costume("bibi_work_idles.cos")
        fo.ricochet:put_in_set(fo)
        fo.ricochet:setpos(0.413341, -0.0173069, 0.2904)
        fo.ricochet:setrot(0, 21.6747, 0)
        fo.ricochet:complete_chore(bibi_work_idles_show_nothing, "bibi_work_idles.cos")
        bibi:set_speech_mode(MODE_BACKGROUND)
        pugsy:set_speech_mode(MODE_BACKGROUND)
        pu_work_idles_event = nil
        bibi_work_idles_event = nil
        start_script(fo.watch_costume_events)
        pugsy:start_work(TRUE)
        bibi:start_work(TRUE)
        if fo.hammer.touchable then
            fo.hammer:set_up_actor()
        end
        fo.cage_door:complete_chore(fo_door_closed)
    end
end
fo.use_chisel = function(arg1) -- line 203
    if meche_freed then
        mn.chisel:operate()
    else
        fo.pugsy_obj:use_chisel()
    end
end
fo.enter = function(arg1) -- line 217
    LoadCostume("mn_ham_react.cos")
    dr.reunited = TRUE
    fo:set_up_actors()
    fo.cage_door.hObjectState = fo:add_object_state(fo_bercu, "fo_door.bm", "fo_door.zbm", OBJSTATE_STATE, FALSE)
    fo.cage_door:set_object_state("fo_door.cos")
    fh.fo_door.opened = TRUE
    fh.fo_door:set_new_out_point()
    LoadCostume("pu_argue.cos")
    LoadCostume("bibi_argue.cos")
    preload_sfx("foHamr1.WAV")
    preload_sfx("foHamr2.WAV")
    preload_sfx("foHamr3.WAV")
    preload_sfx("foHamr4.WAV")
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.65, 0.15, 1.84)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    arg1.former_lookrate = manny:get_look_rate()
end
fo.exit = function(arg1) -- line 246
    KillActorShadows(manny.hActor)
    if not meche_freed then
        stop_script(fo.watch_costume_events)
        bibi:free()
        bibi_stuff:free()
        pugsy:free()
        pugsy_stuff:free()
        pugsy:kill_crying()
        bibi:kill_crying()
        fo.ricochet:free()
        if fo.fighting then
            fo.fighting = FALSE
            stop_script(fo.fight)
        end
        if pugsy.work_task then
            stop_script(pugsy.work_task)
            pugsy.work_task = nil
        end
        if bibi.work_task then
            stop_script(bibi.work_task)
            bibi.work_task = nil
        end
        if bibi.screaming then
            bibi.screaming = FALSE
            stop_script(bibi.scream)
        end
        if pugsy.screaming then
            pugsy.screaming = FALSE
            stop_script(pugsy.screaming)
        end
    end
    manny:set_look_rate(arg1.former_lookrate)
end
fo.hammer = Object:create(fo, "/fotx153/hammer", 0.23377, -0.64950001, 0.040899999, { range = 0.60000002 })
fo.hammer.use_pnt_x = 0.32216999
fo.hammer.use_pnt_y = -0.67309999
fo.hammer.use_pnt_z = 0
fo.hammer.use_rot_x = 0
fo.hammer.use_rot_y = -639.77698
fo.hammer.use_rot_z = 0
fo.hammer.string_name = "hammer"
fo.hammer:make_untouchable()
fo.hammer.lookAt = function(arg1) -- line 302
    manny:say_line("/foma154/")
end
fo.hammer.pickUp = function(arg1) -- line 306
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    break_here()
    manny:play_chore(mn2_reach_low, "mn2.cos")
    sleep_for(750)
    manny:generic_pickup(arg1)
    arg1.act:free()
    manny:wait_for_chore(mn2_reach_low, "mn2.cos")
    manny:stop_chore(mn2_reach_low, "mn2.cos")
    END_CUT_SCENE()
end
fo.hammer.use = function(arg1) -- line 319
    if arg1.owner == manny then
        manny:say_line("/foma155/")
    else
        arg1:pickUp()
    end
end
fo.hammer.set_up_actor = function(arg1) -- line 327
    if not arg1.act then
        arg1.act = Actor:create()
    end
    arg1.act:set_costume("pu_work_idles.cos")
    arg1.act:put_in_set(fo)
    arg1.act:setpos(0.331482, -0.0681313, 0.2443)
    arg1.act:setrot(0, 160.498, 100)
    arg1.act:complete_chore(pu_work_idles_axe_only, "pu_work_idles.cos")
    arg1:make_touchable()
end
fo.desk = Object:create(fo, "/fotx156/desk", -0.0499998, -0.81999999, 0.17, { range = 0.40000001 })
fo.desk.use_pnt_x = -0.0499998
fo.desk.use_pnt_y = -1
fo.desk.use_pnt_z = 0
fo.desk.use_rot_x = 0
fo.desk.use_rot_y = 748.37097
fo.desk.use_rot_z = 0
fo.desk.lookAt = function(arg1) -- line 347
    manny:say_line("/foma157/")
end
fo.desk.pickUp = function(arg1) -- line 351
    system.default_response("furniture")
end
fo.desk.use = function(arg1) -- line 355
    manny:say_line("/foma158/")
end
fo.pugsy_obj = Object:create(fo, "/fotx159/angelito", -0.02, -0.15000001, 0.41, { range = 0.60000002 })
fo.pugsy_obj.use_pnt_x = 0.161847
fo.pugsy_obj.use_pnt_y = -0.51618898
fo.pugsy_obj.use_pnt_z = 0
fo.pugsy_obj.use_rot_x = 0
fo.pugsy_obj.use_rot_y = 31.872601
fo.pugsy_obj.use_rot_z = 0
fo.pugsy_obj.lookAt = function(arg1) -- line 368
    if not fo.pugsy_obj.seen then
        fo.pugsy_obj.seen = TRUE
        manny:say_line("/foma160/")
    else
        manny:say_line("/foma161/")
    end
end
fo.pugsy_obj.pickUp = function(arg1) -- line 377
    soft_script()
    manny:say_line("/foma162/")
    manny:wait_for_message()
    manny:say_line("/foma163/")
end
fo.pugsy_obj.use = function(arg1) -- line 384
    Dialog:run("an1", "dlg_angelitos.lua")
end
fo.pugsy_obj.use_gun = function(arg1) -- line 388
    manny:say_line("/foma164/")
end
fo.pugsy_obj.use_chisel = function(arg1) -- line 392
    START_CUT_SCENE()
    manny:walkto(arg1)
    manny:wait_for_actor()
    if pugsy.work_task then
        start_script(pugsy.kill_idle, pugsy)
    end
    if bibi.work_task then
        start_script(bibi.kill_idle, bibi)
    end
    if fo.fighting then
        start_script(exit_fight)
    end
    manny:say_line("/foma165/")
    manny:wait_for_message()
    manny:say_line("/foma166/")
    manny:wait_for_message()
    start_script(mn.chisel.operate, mn.chisel)
    sleep_for(650)
    start_sfx("ChisCage.wav")
    sleep_for(350)
    start_script(fo.kids_scream)
    wait_for_script(mn.chisel.operate)
    wait_for_script(bibi.scream)
    wait_for_script(pugsy.scream)
    END_CUT_SCENE()
end
fo.pugsy_obj.use_hammer = function(arg1) -- line 414
    START_CUT_SCENE()
    manny:say_line("/foma167/")
    manny:wait_for_message()
    pugsy:say_line("/fopu168/")
    END_CUT_SCENE()
end
fo.pugsy_obj.use_stockings = function(arg1) -- line 422
    START_CUT_SCENE()
    if pugsy.work_task then
        start_script(pugsy.kill_idle, pugsy)
    end
    if bibi.work_task then
        start_script(bibi.kill_idle, bibi)
    end
    if fo.fighting then
        start_script(exit_fight)
    end
    manny:say_line("/foma169/")
    sleep_for(1000)
    bibi:head_look_at_manny()
    pugsy:head_look_at_manny()
    manny:play_chore(mn2_use_obj, "mn2.cos")
    sleep_for(1000)
    manny:twist_head_gesture()
    manny:wait_for_message()
    pugsy:say_line("/fopu170/")
    pugsy:wait_for_message()
    bibi:start_crying()
    sleep_for(500)
    pugsy:start_crying()
    sleep_for(1500)
    manny:say_line("/foma171/")
    start_script(pugsy.exit_cry, pugsy)
    bibi:exit_cry()
    manny:wait_for_message()
    bibi:wait_for_message()
    bibi.cry_state = "sniffle"
    bibi:sniffle("/fobi172/")
    bibi:exit_cry()
    bibi:start_work()
    wait_for_script(pugsy.exit_cry)
    pugsy:start_work()
    END_CUT_SCENE()
end
fo.bibi_obj = Object:create(fo, "/fotx173/angelita", 0.1, -0.16, 0.67000002, { range = 0.80000001 })
fo.bibi_obj.parent = fo.pugsy_obj
fo.cage_door = Object:create(fo, "/fotx174/cage door", 0.31002301, -0.33708701, 0.333, { range = 0.40000001 })
fo.cage_door.use_pnt_x = 0.44502199
fo.cage_door.use_pnt_y = -0.354761
fo.cage_door.use_pnt_z = 0
fo.cage_door.use_rot_x = 0
fo.cage_door.use_rot_y = -632.69501
fo.cage_door.use_rot_z = 0
fo.cage_door.lookAt = function(arg1) -- line 468
    soft_script()
    manny:say_line("/foma175/")
    wait_for_message()
    if not meche_freed then
        pugsy:say_line("/fopu176/")
    end
end
fo.cage_door.use = function(arg1) -- line 477
    if meche_freed then
        system.default_response("nobody")
    else
        START_CUT_SCENE("no head")
        fo:current_setup(fo_bercu)
        manny:walkto_object(arg1)
        break_here()
        manny:play_chore(mn2_reach_med, "mn2.cos")
        sleep_for(500)
        arg1:run_chore(fo_door_opening)
        manny:head_look_at(bibi)
        if not fo.cage_door.tried then
            fo.cage_door.tried = TRUE
            manny:head_look_at(fo.bibi_obj)
            manny:say_line("/foma177/")
            manny:wait_for_message()
            pugsy:say_line("/fopu178/")
            pugsy:wait_for_message()
            bibi:say_line("/fobi179/")
            bibi:wait_for_message()
        else
            manny:say_line("/foma180/")
            if not pugsy.crying and not bibi.crying and not pugsy.screaming and not bibi.screaming and not fo.fighting then
                manny:wait_for_message()
                pugsy:say_line("/fopu181/")
                pugsy:wait_for_message()
                bibi:say_line("/fobi182/")
                sleep_for(750)
                pugsy:say_line("/fopu183/")
                bibi:wait_for_message()
                bibi:say_line("/fobi184/")
                pugsy:wait_for_message()
                pugsy:say_line("/fopu185/")
            end
        end
        manny:wait_for_chore(mn2_reach_med, "mn2.cos")
        manny:stop_chore(mn2_reach_med, "mn2.cos")
        manny:play_chore(mn2_reach_high, "mn2.cos")
        sleep_for(1000)
        arg1:play_chore(fo_door_closing)
        manny:say_line("/foma186/")
        manny:wait_for_message()
        bibi:say_line("/fobi187/")
        manny:wait_for_chore(mn2_reach_high, "mn2.cos")
        manny:stop_chore(mn2_reach_high, "mn2.cos")
        END_CUT_SCENE()
    end
end
fo.cage_door.use_chisel = function(arg1) -- line 530
    manny:say_line("/foma188/")
end
fo.cage_door.pickUp = fo.cage_door.use
fo.fh_door = Object:create(fo, "/fotx189/door", 0.77249801, 0.120142, 0.44999999, { range = 0.60000002 })
fo.fh_door.use_pnt_x = 0.68870902
fo.fh_door.use_pnt_y = 0.0556878
fo.fh_door.use_pnt_z = 0
fo.fh_door.use_rot_x = 0
fo.fh_door.use_rot_y = -16.683201
fo.fh_door.use_rot_z = 0
fo.fh_door.out_pnt_x = 0.77249801
fo.fh_door.out_pnt_y = 0.120142
fo.fh_door.out_pnt_z = 0
fo.fh_door.out_rot_x = 0
fo.fh_door.out_rot_y = -364.56
fo.fh_door.out_rot_z = 0
fo.fh_box = fo.fh_door
fo.fh_door.walkOut = function(arg1) -- line 562
    fh:come_out_door(fh.fo_door)
end
fo.fh_door.lookAt = function(arg1) -- line 566
    system.default_response("way out")
end

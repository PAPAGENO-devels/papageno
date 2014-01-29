CheckFirstTime("fi.lua")
fi = Set:create("fi.set", "florist interior", { fi_top = 0, fi_intha = 1 })
fi.shrinkable = 0.02
dofile("bs_idles.lua")
dofile("msb_react.lua")
dofile("fi_bell.lua")
bowlsley.rants = { }
bowlsley.rants.max = 0
bowlsley.rants[1] = "/fibl001/"
bowlsley.rants[2] = "/fibl002/"
bowlsley.rants[3] = "/fibl003/"
bowlsley.rants[4] = "/fibl004/"
bowlsley.rants[5] = "/fibl005/"
bowlsley.rants[6] = "/fibl006/"
bowlsley.rants[7] = "/fibl007/"
bowlsley.rants[8] = "/fibl008/"
bowlsley.rants[9] = "/fibl009/"
bowlsley.rants[10] = "/fibl010/"
bowlsley.rants[11] = "/fibl011/"
bowlsley.rants[12] = "/fibl012/"
bowlsley.rants[13] = "/fibl013/"
bowlsley.rants[14] = "/fibl014/"
bowlsley.rants[15] = "/fibl015/"
bowlsley.rants[16] = "/fibl016/"
bowlsley.rants[17] = "/fibl017/"
bowlsley.rants[18] = "/fibl018/"
bowlsley.rants[19] = "/fibl019/"
bowlsley.rants[20] = "/fibl020/"
bowlsley.rants[21] = "/fibl021/"
bowlsley.rants[22] = "/fibl022/"
bowlsley.rants[23] = "/fibl023/"
bowlsley.rants[24] = "/fibl024/"
bowlsley.rants[25] = "/fibl025/"
bowlsley.rants[26] = "/fibl026/"
bowlsley.rants[27] = "/fibl027/"
bowlsley.rants[28] = "/fibl028/"
bowlsley.rants[29] = "/fibl029/"
bowlsley.rants[30] = "/fibl030/"
bowlsley.rants[31] = "/fibl031/"
bowlsley.rants[32] = "/fibl032/"
bowlsley.rants[33] = "/fibl033/"
bowlsley.rants[34] = "/fibl034/"
bowlsley.rants[35] = "/fibl035/"
bowlsley.rants[36] = "/fibl036/"
bowlsley.rants[37] = "/fibl037/"
bowlsley.rants[38] = "/fibl038/"
bowlsley.rants[39] = "/fibl039/"
bowlsley.rants[40] = "/fibl040/"
bowlsley.rants[41] = "/fibl041/"
bowlsley.rants[42] = "/fibl042/"
bowlsley.rants[43] = "/fibl043/"
fi.added_rant = { }
fi.add_rant = function(arg1) -- line 66
    if not fi.added_rant[arg1] then
        fi.added_rant[arg1] = TRUE
        bowlsley.rants.max = bowlsley.rants.max + 1
        bowlsley.rants.pointer = bowlsley.rants.max
        bowlsley.rants[bowlsley.rants.pointer] = arg1
    end
end
fi.insane_ranting = function() -- line 75
    local local1
    while 1 do
        local1 = 3000 * random()
        sleep_for(local1)
        bowlsley:wait_for_message()
        bowlsley:say_line(pick_from_ordered_table(bowlsley.rants))
        bowlsley:wait_for_message()
    end
end
fi.talk_count = 0
fi.talk_down_bowlsley = function() -- line 88
    stop_script(fi.insane_ranting)
    bowlsley:wait_for_message()
    fi.talk_count = fi.talk_count + 1
    START_CUT_SCENE()
    if fi.talk_count == 1 then
        manny:say_line("/fima044/")
        manny:wait_for_message()
        fi.add_rant("/fibl045/")
    elseif fi.talk_count == 2 then
        manny:say_line("/fima046/")
        manny:wait_for_message()
        fi.add_rant("/fibl047/")
    elseif fi.talk_count == 3 then
        manny:say_line("/fima048/")
        manny:wait_for_message()
        fi.add_rant("/fibl049/")
    else
        manny:say_line("/fima050/")
    end
    manny:wait_for_message()
    END_CUT_SCENE()
    start_script(fi.insane_ranting)
end
fi.too_close = function() -- line 116
    START_CUT_SCENE()
    stop_script(fi.insane_ranting)
    bowlsley:stop_chore(bs_idles_idle)
    bowlsley:play_chore(bs_idles_react)
    if not fi.warned then
        fi.warned = TRUE
        bowlsley:say_line("/fibl051/")
        bowlsley:wait_for_message()
        bowlsley:wait_for_chore()
        bowlsley:stop_chore(bs_idles_react)
        bowlsley:play_chore_looping(bs_idles_shiver)
        if manny.fancy then
            manny:push_costume("mccthund_react.cos")
        else
            manny:push_costume("msb_react.cos")
        end
        manny:play_chore(msb_react_standback)
        bowlsley:say_line("/fibl052/")
        bowlsley:wait_for_message()
        bowlsley:say_line("/fibl053/")
        bowlsley:wait_for_message()
        bowlsley:set_chore_looping(bs_idles_shiver, FALSE)
        bowlsley:wait_for_chore()
        bowlsley:say_line("/fibl054/")
    else
        bowlsley:wait_for_chore()
        if manny.fancy then
            manny:push_costume("mccthund_react.cos")
        else
            manny:push_costume("msb_react.cos")
        end
        manny:play_chore(msb_react_standback)
        bowlsley:say_line("/fibl055/")
        bowlsley:stop_chore(bs_idles_react)
        bowlsley:play_chore_looping(bs_idles_shiver)
        bowlsley:wait_for_message()
    end
    manny:setpos({ x = -0.332293, y = -0.278123, z = 0 })
    manny:pop_costume()
    manny:head_look_at(nil)
    END_CUT_SCENE()
    bowlsley:stop_chore(bs_idles_shiver)
    bowlsley:play_chore(bs_idles_retreat)
    bowlsley:wait_for_chore()
    bowlsley:stop_chore(bs_idles_retreat)
    bowlsley:play_chore_looping(bs_idles_idle)
    start_script(fi.insane_ranting)
end
fi.wait_gun = function(arg1) -- line 172
    sleep_for(6600)
    bowlsley:play_chore(bs_idles_hide_gun)
end
fi.happy_bowlsley = function() -- line 177
    fi.gun:get()
    fi.sproutella:get()
    START_CUT_SCENE()
    bowlsley:set_chore_looping(bs_idles_idle, FALSE)
    bowlsley:say_line("/fibl056/")
    start_script(manny.walkto, manny, -0.216634, -0.172976, 0, 0, 593.826, 0)
    bowlsley:wait_for_message()
    bowlsley:wait_for_chore()
    bowlsley:say_line("/fibl057/")
    bowlsley:play_chore(bs_idles_handoff1)
    bowlsley:wait_for_message()
    manny:say_line("/fima058/")
    manny:wait_for_message()
    manny:say_line("/fima059/")
    manny:wait_for_message()
    manny:wait_for_actor()
    if manny.fancy then
        manny:push_costume("mccthund_react.cos")
    else
        manny:push_costume("msb_react.cos")
    end
    manny:play_chore(msb_react_get_gun)
    start_script(fi.wait_gun)
    bowlsley:say_line("/fibl060/")
    bowlsley:play_chore(bs_idles_handoff2)
    bowlsley:wait_for_message()
    manny:wait_for_chore()
    manny:ignore_boxes()
    manny:setpos({ x = 0.0103987, y = -0.309207, z = 0 })
    manny:setrot(0, -126.704, 0)
    manny:pop_costume()
    if manny.fancy then
        manny:play_chore_looping(mcc_thunder_activate_gun, manny.base_costume)
        manny:play_chore_looping(mcc_thunder_hold, manny.base_costume)
        manny.hold_chore = mcc_thunder_activate_gun
        manny:play_chore(mcc_thunder_no_talk, "mcc_thunder.cos")
    else
        manny:play_chore_looping(msb_activate_gun, manny.base_costume)
        manny:play_chore_looping(msb_hold, manny.base_costume)
        manny.hold_chore = msb_activate_gun
    end
    manny.is_holding = fi.gun
    bowlsley:say_line("/fibl061/")
    put_away_held_item()
    bowlsley:wait_for_message()
    manny:say_line("/fima062/")
    manny:wait_for_message()
    bowlsley:say_line("/fibl063/")
    manny:setpos(-0.216634, -0.172976, 0)
    manny:setrot(0, 593.826, 0)
    if manny.fancy then
        manny:push_costume("mccthund_react.cos")
    else
        manny:push_costume("msb_react.cos")
    end
    manny:play_chore(msb_react_get_can)
    sleep_for(734)
    bowlsley:play_chore(bs_idles_hide_gun)
    manny:wait_for_chore()
    manny:setpos({ x = 0.0103987, y = -0.309207, z = 0 })
    manny:setrot(0, -126.704, 0)
    manny:pop_costume()
    bowlsley:play_chore(bs_idles_hide_can)
    if manny.fancy then
        manny:play_chore_looping(mcc_thunder_activate_sproutella, manny.base_costume)
        manny.hold_chore = mcc_thunder_activate_sproutella
    else
        manny:play_chore_looping(msb_activate_sproutella, manny.base_costume)
        manny.hold_chore = msb_activate_sproutella
    end
    manny:play_chore_looping(msb_hold, manny.base_costume)
    manny.is_holding = fi.sproutella
    if manny.fancy then
        manny:play_chore(ms_stop_talk, manny.base_costume)
    end
    put_away_held_item()
    bowlsley:say_line("/fibl064/")
    start_script(fi.bs_follow_manny)
    manny:backup(1000)
    bowlsley:wait_for_message()
    manny:follow_boxes()
    manny:walkto_object(fi.fp_door)
    manny:wait_for_actor()
    music_state:set_sequence(seqYr4Iris)
    IrisDown(320, 200, 1000)
    sleep_for(1100)
    sh:switch_to_set()
    MakeSectorActive("glottis_here", TRUE)
    MakeSectorActive("glottis_gone", TRUE)
    start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 80)
    if manny.costume_state == "thunder" then
        if manny.fancy then
            glottis:set_costume("bonewagon_cc.cos")
        else
            glottis:set_costume("bonewagon_thunder.cos")
        end
    else
        glottis:set_costume("bonewagon_alb.cos")
    end
    glottis:put_in_set(sh)
    glottis:set_visibility(TRUE)
    glottis:set_mumble_chore(bonewagon_gl_gl_mumble)
    glottis:set_talk_chore(1, bonewagon_gl_stop_talk)
    glottis:set_talk_chore(2, bonewagon_gl_a)
    glottis:set_talk_chore(3, bonewagon_gl_c)
    glottis:set_talk_chore(4, bonewagon_gl_e)
    glottis:set_talk_chore(5, bonewagon_gl_f)
    glottis:set_talk_chore(6, bonewagon_gl_l)
    glottis:set_talk_chore(7, bonewagon_gl_m)
    glottis:set_talk_chore(8, bonewagon_gl_o)
    glottis:set_talk_chore(9, bonewagon_gl_t)
    glottis:set_talk_chore(10, bonewagon_gl_u)
    glottis:play_chore(bonewagon_alb_gl_drive)
    glottis:play_chore(bonewagon_alb_ma_sit)
    glottis:follow_boxes()
    glottis:setpos(2.39009, 1.6486, 0)
    glottis:setrot(0, -191.033, 0)
    glottis:set_walk_rate(0.4)
    start_script(glottis.walkto, glottis, 2.04434, -0.128071, 0, 0, -191.033, 0)
    IrisUp(320, 200, 800)
    glottis:wait_for_actor()
    stop_sound("bwIdle.IMU")
    glottis:play_chore(bonewagon_alb_ma_jump_out)
    glottis:wait_for_chore()
    single_start_script(sg.glottis_roars, sg, glottis)
    manny:setpos(1.53579, 1.66838, 0)
    manny:put_in_set(sh)
    manny:walkto(0.957532, 0.0707181, 0, 0, 161.368, 0)
    glottis:ignore_boxes()
    MakeSectorActive("glottis_gone", FALSE)
    END_CUT_SCENE()
    cur_puzzle_state[54] = TRUE
    sh.remote:free()
    glottis.in_at = FALSE
end
fi.bs_follow_manny = function() -- line 320
    while system.currentSet == fi do
        bowlsley:head_look_at_manny()
        break_here()
    end
end
fi.enter_from_fp = function(arg1) -- line 327
    START_CUT_SCENE()
    fi:switch_to_set()
    manny:put_in_set(fi)
    fi:current_setup(fi_intha)
    if not fi.bell.unbound then
        fi.bell:play_chore(fi_bell_tape_here)
    else
        fi.bell:play_chore(fi_bell_bell_here)
    end
    manny:setpos(-0.025, 0.6656, 0)
    manny:setrot(0, 180, 0)
    fi.fp_door:play_chore(0)
    if fi.bell.unbound then
        fi.bell:play_chore(fi_bell_ring_bell)
    end
    sleep_for(1000)
    manny:pop_costume()
    END_CUT_SCENE()
    if not fi.bell.unbound then
        start_script(fi.insane_ranting)
    else
        start_script(fi.happy_bowlsley)
    end
end
fi.set_up_actors = function(arg1) -- line 354
    bowlsley:put_in_set(fi)
    bowlsley:setpos(0.23649, -0.32308, 0)
    bowlsley:setrot(0, 180, 0)
    bowlsley:set_costume("bs_idles.cos")
    bowlsley:set_mumble_chore(bs_idles_mumble)
    bowlsley:set_talk_chore(1, bs_idles_no_talk)
    bowlsley:set_talk_chore(2, bs_idles_a)
    bowlsley:set_talk_chore(3, bs_idles_c)
    bowlsley:set_talk_chore(4, bs_idles_e)
    bowlsley:set_talk_chore(5, bs_idles_f)
    bowlsley:set_talk_chore(6, bs_idles_l)
    bowlsley:set_talk_chore(7, bs_idles_m)
    bowlsley:set_talk_chore(8, bs_idles_o)
    bowlsley:set_talk_chore(9, bs_idles_t)
    bowlsley:set_talk_chore(10, bs_idles_u)
    bowlsley:set_head(3, 4, 5, 165, 28, 80)
    bowlsley:set_speech_mode(MODE_BACKGROUND)
    fi.fp_door:set_object_state("fi_door.cos")
    fi.fp_door:complete_chore(1)
    fi.bell:set_object_state("fi_bell.cos")
    bowlsley:play_chore_looping(bs_idles_idle)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.6, -0.4, 3)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(bowlsley.hActor, 0)
    SetActorShadowPoint(bowlsley.hActor, 0.6, -0.4, 2)
    SetActorShadowPlane(bowlsley.hActor, "shadow1")
    AddShadowPlane(bowlsley.hActor, "shadow1")
end
fi.untape_bell = function() -- line 394
    cur_puzzle_state[50] = TRUE
    START_CUT_SCENE()
    stop_script(fi.insane_ranting)
    fi.bell.unbound = TRUE
    manny:walkto(-0.15856, 0.36836, 0, 0, -14.7573, 0)
    manny:wait_for_actor()
    if manny.fancy then
        manny:push_costume("mccthund_react.cos")
    else
        manny:push_costume("msb_react.cos")
    end
    manny:stop_chore(msb_hold_scythe, manny.base_costume)
    manny:stop_chore(msb_hold, manny.base_costume)
    manny:play_chore(msb_react_ring_bell)
    sleep_for(2150)
    fi.bell:play_chore(fi_bell_remove_tape)
    music_state:set_state(stateFVID)
    manny:wait_for_chore()
    manny:pop_costume()
    if manny.fancy then
        manny:play_chore(ms_stop_talk, "mcc_thunder.cos")
    end
    manny:play_chore_looping(msb_hold_scythe, manny.base_costume)
    bowlsley:say_line("/fibl065/")
    sleep_for(500)
    manny:head_look_at(bowlsley)
    start_script(manny.turn_right, manny, 160)
    bowlsley:wait_for_message()
    bowlsley:say_line("/fibl066/")
    bowlsley:wait_for_message()
    bowlsley:say_line("/fibl067/")
    sleep_for(750)
    manny:head_look_at(nil)
    manny:walkto(-0.0264367, 0.725, 0, 0, 2.24411, 0)
    bowlsley:wait_for_message()
    manny:wait_for_actor()
    END_CUT_SCENE()
    fp:come_out_door(fp.fi_door)
    start_sfx("DorOfCls.wav")
    start_sfx("fi_drbel.wav")
end
fi.update_music_state = function(arg1) -- line 444
    if fi.bell.unbound then
        return stateFI_OK
    else
        return stateFI
    end
end
fi.enter = function(arg1) -- line 453
    fi:set_up_actors()
    NewObjectState(fi_intha, OBJSTATE_OVERLAY, "fi_bell.bm", nil, TRUE)
    NewObjectState(fi_intha, OBJSTATE_STATE, "fi_door.bm", "fi_door_open.zbm")
    NewObjectState(fi_intha, OBJSTATE_UNDERLAY, "fi_tapeball.bm", nil, TRUE)
end
fi.exit = function(arg1) -- line 462
    KillActorShadows(manny.hActor)
    KillActorShadows(bowlsley.hActor)
    stop_script(sg.glottis_roars)
    bowlsley:free()
    stop_script(fi.insane_ranting)
end
fi.gun = Object:create(fi, "/fitx068/gun", 0, 0, 0, { range = 0 })
fi.gun.wav = "fi_grbgn.wav"
fi.gun.lookAt = function(arg1) -- line 480
    manny:say_line("/fima069/")
end
fi.gun.use = function(arg1) -- line 484
    manny:say_line("/fima070/")
end
fi.gun.default_response = function(arg1) -- line 488
    manny:say_line("/fima071/")
end
fi.sproutella = Object:create(fi, "/fitx072/can of sproutella", 0, 0, 0, { range = 0 })
fi.sproutella.string_name = "sproutella"
fi.sproutella.lookAt = function(arg1) -- line 494
end
fi.sproutella.use = function(arg1) -- line 498
    manny:say_line("/fima074/")
end
fi.sproutella.lookAt = function(arg1) -- line 502
    manny:say_line("/fima073/")
end
fi.sproutella.default_response = function(arg1, arg2) -- line 506
    if arg2.person then
        manny:say_line("/fima075/")
    else
        manny:say_line("/fima076/")
    end
end
fi.window_display = Object:create(fi, "/fitx077/window_display", 0.68077302, 0.75999999, 0.30000001, { range = 0.60000002 })
fi.window_display.use_pnt_x = 0.47077301
fi.window_display.use_pnt_y = 0.44999999
fi.window_display.use_pnt_z = 0
fi.window_display.use_rot_x = 0
fi.window_display.use_rot_y = 1035.42
fi.window_display.use_rot_z = 0
fi.window_display.lookAt = function(arg1) -- line 522
    manny:say_line("/fima078/")
    manny:wait_for_message()
    fi.add_rant("/fibl079/")
end
fi.window_display.use = function(arg1) -- line 528
    manny:say_line("/fima080/")
    manny:wait_for_message()
    fi.add_rant("/fibl081/")
end
fi.window_display.pickUp = fi.window_display.use
fi.fridge1 = Object:create(fi, "/fitx082/refrigerator", -0.81, 0.244504, 0.38999999, { range = 0.60000002 })
fi.fridge1.use_pnt_x = -0.60000002
fi.fridge1.use_pnt_y = 0.244504
fi.fridge1.use_pnt_z = 0
fi.fridge1.use_rot_x = 0
fi.fridge1.use_rot_y = -622.55902
fi.fridge1.use_rot_z = 0
fi.fridge1.lookAt = function(arg1) -- line 545
    manny:say_line("/fima083/")
    manny:wait_for_message()
    fi.add_rant("/fibl084/")
end
fi.fridge1.use = function(arg1) -- line 551
    system.default_response("locked")
    if not fi.bell.unbound then
        soft_script()
        wait_for_message()
        bowlsley:say_line("/fibl085/")
        wait_for_message()
        fi.add_rant("/fibl086/")
    end
end
fi.fridge2 = Object:create(fi, "/fitx087/refrigerator", -0.49252799, 0.68000001, 0.47999999, { range = 0.60000002 })
fi.fridge2.use_pnt_x = -0.50252801
fi.fridge2.use_pnt_y = 0.44999999
fi.fridge2.use_pnt_z = 0
fi.fridge2.use_rot_x = 0
fi.fridge2.use_rot_y = -702.95898
fi.fridge2.use_rot_z = 0
fi.fridge2.parent = fi.fridge1
fi.bell = Object:create(fi, "/fitx088/ball of tape", 0.148376, 0.60232902, 0.72000003, { range = 0.81 })
fi.bell.use_pnt_x = -0.00162365
fi.bell.use_pnt_y = 0.42232901
fi.bell.use_pnt_z = 0
fi.bell.use_rot_x = 0
fi.bell.use_rot_y = -8.7921
fi.bell.use_rot_z = 0
fi.bell.lookAt = function(arg1) -- line 580
    if not arg1.unbound then
        manny:say_line("/fima089/")
        manny:wait_for_message()
        fi.add_rant("/fibl090/")
    else
        manny:say_line("/fima091/")
    end
end
fi.bell.use = function(arg1) -- line 590
    system.default_response("reach")
end
fi.bell.pickUp = fi.bell.use
fi.bell.use_scythe = function(arg1) -- line 596
    if not arg1.unbound then
        start_script(fi.untape_bell)
    else
        bowlsley:say_line("/fibl092/")
    end
end
fi.cases = Object:create(fi, "/fitx093/cases", -0.19301701, -0.61475497, 0.23, { range = 0.60000002 })
fi.cases.string_name = "sproutella"
fi.cases.use_pnt_x = -0.28029299
fi.cases.use_pnt_y = -0.28812301
fi.cases.use_pnt_z = 0
fi.cases.use_rot_x = 0
fi.cases.use_rot_y = 188.959
fi.cases.use_rot_z = 0
fi.cases.lookAt = function(arg1) -- line 614
    manny:say_line("/fima094/")
    if not arg1.seen then
        START_CUT_SCENE()
        arg1.seen = TRUE
        manny:wait_for_message()
        bowlsley:say_line("/fibl095/")
        bowlsley:wait_for_message()
        bowlsley:say_line("/fibl096/")
        END_CUT_SCENE()
    end
    wait_for_message()
    fi.add_rant("/fibl097/")
    fi.add_rant("/fibl098/")
end
fi.cases.pickUp = function(arg1) -- line 632
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(ms_reach_med, manny.base_costume)
    if not fi.bell.unbound then
        start_script(fi.too_close)
        sleep_for(500)
        start_script(manny.turn_left, manny, 70)
        manny:head_look_at(bowlsley)
    else
        bowlsley:say_line("/fibl099/")
    end
    END_CUT_SCENE()
end
fi.cases.use = fi.cases.pickUp
fi.bowlsley_obj = Object:create(fi, "/fitx100/Bowlsley", 0.31698301, -0.464755, 0.23, { range = 0.60000002 })
fi.bowlsley_obj.use_pnt_x = -0.043950599
fi.bowlsley_obj.use_pnt_y = -0.22471599
fi.bowlsley_obj.use_pnt_z = 0
fi.bowlsley_obj.use_rot_x = 0
fi.bowlsley_obj.use_rot_y = 552.328
fi.bowlsley_obj.use_rot_z = 0
fi.bowlsley_obj.lookAt = function(arg1) -- line 659
    if not fi.bell.unbound then
        manny:say_line("/fima101/")
    else
        manny:say_line("/fima102/")
        manny:wait_for_message()
        bowlsley:say_line("/fibl103/")
    end
end
fi.bowlsley_obj.pickUp = function(arg1) -- line 669
    if fi.bell.unbound then
        bowlsley:say_line("/fibl104/")
    else
        START_CUT_SCENE()
        manny:walkto_object(fi.cases)
        manny:wait_for_actor()
        manny:play_chore(ms_reach_med, manny.base_costume)
        if not fi.bell.unbound then
            start_script(fi.too_close)
            sleep_for(500)
            start_script(manny.turn_left, manny, 70)
            manny:head_look_at(bowlsley)
        end
        END_CUT_SCENE()
    end
end
fi.bowlsley_obj.use = function(arg1) -- line 687
    start_script(fi.talk_down_bowlsley)
end
fi.bowlsley_obj.use_gun = function(arg1) -- line 695
    START_CUT_SCENE()
    manny:say_line("/fima105/")
    manny:wait_for_message()
    bowlsley:say_line("/fibl106/")
    bowlsley:wait_for_message()
    bowlsley:say_line("/fibl107/")
    END_CUT_SCENE()
end
fi.fp_door = Object:create(fi, "/fitx108/door", -0.00162365, 0.63232899, 0.38, { range = 0.60000002 })
fi.fp_door.use_pnt_x = -0.00162365
fi.fp_door.use_pnt_y = 0.42232901
fi.fp_door.use_pnt_z = 0
fi.fp_door.use_rot_x = 0
fi.fp_door.use_rot_y = 6.3978701
fi.fp_door.use_rot_z = 0
fi.fp_door.out_pnt_x = -0.021545099
fi.fp_door.out_pnt_y = 0.60000002
fi.fp_door.out_pnt_z = 0
fi.fp_door.out_rot_x = 0
fi.fp_door.out_rot_y = 6.3972702
fi.fp_door.out_rot_z = 0
fi.fp_box = fi.fp_door
fi.fp_door.lookAt = function(arg1) -- line 728
    if fi.bell.unbound then
        system.default_response("way out")
    else
        manny:say_line("/fima109/")
        manny:wait_for_message()
        fi.add_rant("/fibl110/")
    end
end
fi.fp_door.walkOut = function(arg1) -- line 738
    if fi.bell.unbound then
        START_CUT_SCENE()
        bowlsley:say_line("/fibl111/")
        bowlsley:wait_for_message()
        END_CUT_SCENE()
    end
    fp:come_out_door(fp.fi_door)
end

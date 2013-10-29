CheckFirstTime("year_1.lua")
cut_scene.intro = function(arg1) -- line 8
    START_CUT_SCENE()
    manny.idles_allowed = FALSE
    manny:setpos(1.39601, 1.48653, 0)
    manny:setrot(0, 50.3818, 0)
    mo:current_setup(mo_ddtws)
    set_override(cut_scene.intro_override, cut_scene)
    cutscene_menu:enable_cutscene("intro")
    RunFullscreenMovie("intro.snm")
    start_script(manny.walk_and_face, manny, 1.32737, 1.59881, 0, 0, 50.3818, 0)
    EngineDisplay(FALSE)
    break_here()
    EngineDisplay(TRUE)
    StartMovie("mo_ts.snm", nil, 0, 256)
    wait_for_movie()
    music_state:update(system.currentSet)
    wait_for_script(manny.walk_and_face)
    END_CUT_SCENE()
    manny:say_line("/intma39/")
    manny.idles_allowed = TRUE
end
cut_scene.intro_override = function(arg1) -- line 32
    kill_override()
    manny:setpos(1.32737, 1.59881, 0)
    manny:setrot(0, 50.3818, 0)
    EngineDisplay(TRUE)
    manny.idles_allowed = TRUE
    ImSetState(stateMO)
end
cut_scene.lol = function(arg1) -- line 43
    ga.work_order:free()
    mo.tube.contains = nil
    mo.memo:free()
    cutscene_menu:enable_cutscene("lol")
    stop_script(run_idle)
    eva:stop_chore()
    eva:free()
    stop_sound("keyboard.imu")
    set_override(cut_scene.lol_override, cut_scene)
    START_CUT_SCENE()
    RunFullscreenMovie("lol.snm")
    END_CUT_SCENE()
    set_override(nil)
    start_script(lr.walk_in)
end
cut_scene.lol_override = function(arg1) -- line 63
    kill_override()
    music_state:unpause()
    single_start_script(lr.walk_in)
end
cut_scene.brunopk = function(arg1) -- line 69
    reaped_bruno = TRUE
    inventory_disabled = FALSE
    cutscene_menu:enable_cutscene("brunopk")
    START_CUT_SCENE("no head")
    lo:switch_to_set()
    lo:current_setup(lo_pckws)
    manny:put_in_set(lo)
    manny:setpos(2.19, -1.81481, 0)
    manny:setrot(0, 82.9565, 0)
    set_override(cut_scene.brunopk_override, cut_scene)
    RunFullscreenMovie("brunopk.snm")
    END_CUT_SCENE()
    start_script(cut_scene.brunopk_override)
end
cut_scene.brunopk_override = function(arg1, arg2) -- line 91
    if arg2 then
        PrintDebug("brunopk override hit!\n")
        kill_override()
    end
    START_CUT_SCENE()
    EngineDisplay(FALSE)
    lo:switch_to_set()
    lo:current_setup(lo_pckws)
    manny:put_in_set(lo)
    manny:setpos(2.19, -1.81481, 0)
    manny:setrot(0, 82.9565, 0)
    break_here()
    start_script(manny.walkto, manny, 0.68697, -2.93948, 0, 0, 170, 0)
    EngineDisplay(TRUE)
    sleep_for(500)
    manny:say_line("/syma218/")
    wait_for_message()
    manny:wait_for_actor()
    manny:say_line("/syma219/")
    manny:wait_for_message()
    EngineDisplay(FALSE)
    stop_script(manny.walkto)
    manny:stop_walk()
    manny:stop_chore()
    ha:switch_to_set()
    manny:put_in_set(ha)
    manny:setpos(ha.lo_door.out_pnt_x, ha.lo_door.out_pnt_y, ha.lo_door.out_pnt_z)
    manny:setrot(ha.lo_door.out_rot_x, ha.lo_door.out_rot_y + 180, ha.lo_door.out_rot_z)
    break_here()
    EngineDisplay(TRUE)
    ha.lo_door:open()
    END_CUT_SCENE()
    manny:walkto(7.12676, 2.55694, 0)
end
cut_scene.bonewgn = function(arg1) -- line 143
    reaped_bruno = TRUE
    reaped_meche = TRUE
    fe.balloons.balloon1:put_in_limbo()
    fe.balloons.balloon2:put_in_limbo()
    fe.balloons.balloon3:put_in_limbo()
    fe.balloons.balloon4:put_in_limbo()
    fe.balloons.balloon5:put_in_limbo()
    pk.balloons.balloon1:put_in_limbo()
    pk.balloons.balloon2:put_in_limbo()
    pk.balloons.balloon3:put_in_limbo()
    pk.balloons.balloon4:put_in_limbo()
    pk.balloons.balloon5:put_in_limbo()
    cutscene_menu:enable_cutscene("repmec1c")
    START_CUT_SCENE()
    set_override(cut_scene.bonewgn_override)
    RunFullscreenMovie("repmec1c.snm")
    END_CUT_SCENE()
    start_script(mo.manny_meche_dialog)
end
cut_scene.bonewgn_override = function() -- line 166
    kill_override()
    music_state:unpause()
    single_start_script(mo.manny_meche_dialog)
end
cut_scene.reapmec3 = function(arg1) -- line 172
    reaped_bruno = TRUE
    reaped_meche = TRUE
    cutscene_menu:enable_cutscene("repmec3c")
    START_CUT_SCENE()
    set_override(cut_scene.reapmec3_override)
    system:unlock_display()
    RunFullscreenMovie("repmec3c.snm")
    END_CUT_SCENE()
    stop_script(run_idle)
    eva:stop_chore()
    eva:free()
    single_start_script(gs.set_up_prison)
end
cut_scene.reapmec3_override = function() -- line 191
    kill_override()
    music_state:unpause()
    stop_script(run_idle)
    eva:stop_chore()
    eva:free()
    single_start_script(gs.set_up_prison)
end
cut_scene.lsahq = function() -- line 200
    START_CUT_SCENE()
    gs.is_jail = FALSE
    reaped_bruno = TRUE
    reaped_meche = TRUE
    cutscene_menu:enable_cutscene("lsahq")
    set_override(cut_scene.lsahq_override)
    RunFullscreenMovie("lsahq.snm")
    EngineDisplay(FALSE)
    hq:switch_to_set()
    manny:put_in_set(hq)
    manny:setpos(0.608613, -0.19144, 0)
    manny:setrot(0, 88.8016, 0)
    hq:init_hq()
    salvador:setpos(-0.861, -0.201, 0)
    salvador:setrot(0, 272.255, 0)
    EngineDisplay(TRUE)
    start_script(hq.salvador_walks)
    wait_for_script(hq.salvador_walks)
    eva:setpos(-0.563042, -0.421926, -0.08)
    eva:setrot(0, 177, 0)
    END_CUT_SCENE()
    start_script(hq.demo_opening_override)
end
cut_scene.lsahq_override = function() -- line 234
    if override_hit then
        StopMovie()
    else
        kill_override()
    end
    music_state:unpause()
    hq:switch_to_set()
    manny:put_in_set(hq)
    EngineDisplay(TRUE)
    start_script(hq.demo_opening_override)
end
cut_scene.stump = function(arg1) -- line 247
    mo.cards:put_in_limbo()
    mo.one_card:put_in_limbo()
    fe.balloon_cat:put_in_limbo()
    fe.balloon_dingo:put_in_limbo()
    fe.balloon_frost:put_in_limbo()
    fe.breads.bread1:put_in_limbo()
    fe.breads.bread2:put_in_limbo()
    fe.breads.bread3:put_in_limbo()
    fe.breads.bread4:put_in_limbo()
    fe.breads.bread5:put_in_limbo()
    fe.balloons.balloon1:put_in_limbo()
    fe.balloons.balloon2:put_in_limbo()
    fe.balloons.balloon3:put_in_limbo()
    fe.balloons.balloon4:put_in_limbo()
    fe.balloons.balloon5:put_in_limbo()
    pk.balloons.balloon1:put_in_limbo()
    pk.balloons.balloon2:put_in_limbo()
    pk.balloons.balloon3:put_in_limbo()
    pk.balloons.balloon4:put_in_limbo()
    pk.balloons.balloon5:put_in_limbo()
    if bd.extinguisher.owner ~= manny then
        bd.extinguisher:get()
    end
    cutscene_menu:enable_cutscene("stump1c")
    START_CUT_SCENE()
    set_override(cut_scene.skip_stump, cut_scene)
    RunFullscreenMovie("stump1c.snm")
    END_CUT_SCENE()
    cut_scene:skip_stump()
end
cut_scene.skip_stump = function(arg1, arg2) -- line 283
    if arg2 then
        kill_override()
        StopMovie()
    end
    manny.costume_state = "action"
    sm:climb_out_stump()
end
cut_scene.glotlive = function(arg1) -- line 294
    glottis.ripped_heart = TRUE
    glottis.heartless = TRUE
    if bd.extinguisher.owner ~= manny then
        bd.extinguisher:get()
    end
    sg:switch_to_set()
    sg:current_setup(sg_spdws)
    manny:put_in_set(sg)
    manny:put_at_interest()
    start_script(sg.replace_heart)
end
cut_scene.sp06a = function(arg1) -- line 307
    cutscene_menu:enable_cutscene("stump3c")
    START_CUT_SCENE()
    set_override(cut_scene.skip_sp06a, cut_scene)
    RunFullscreenMovie("stump3c.snm")
    sg:switch_to_set()
    sg:current_setup(sg_spdws)
    sp.web.contains = sp.heart
    sg:current_setup(sg_gltoh)
    END_CUT_SCENE()
end
cut_scene.skip_sp06a = function(arg1) -- line 322
    kill_override()
    music_state:unpause()
    sg:switch_to_set()
    sg:current_setup(sg_spdws)
    sp.web.contains = sp.heart
    sg:current_setup(sg_gltoh)
end
cut_scene.copaldie = function(arg1) -- line 333
    cutscene_menu:enable_cutscene("copaldie")
    reaped_bruno = TRUE
    reaped_meche = TRUE
    START_CUT_SCENE()
    set_override(cut_scene.skip_copaldie, cut_scene)
    le:switch_to_set()
    le:current_setup(le_rufla)
    manny:set_visibility(FALSE)
    IrisUp(320, 240, 1000)
    sleep_for(3000)
    RunFullscreenMovie("copaldie.snm")
    END_CUT_SCENE()
    arg1:skip_copaldie()
end
cut_scene.skip_copaldie = function(arg1, arg2) -- line 354
    if arg2 then
        kill_override()
    end
    sg:switch_to_set()
    sg:current_setup(sg_sgnha)
    glottis:put_in_set(sg)
    manny:put_in_set(sg)
    manny:set_visibility(TRUE)
    start_script(sg.get_in_BW, sg)
end
cut_scene.puzl19c = function(arg1) -- line 368
    tr:switch_to_set()
    tr:set_up_aftermath()
    cutscene_menu:enable_cutscene("getshcks")
    START_CUT_SCENE()
    set_override(cut_scene.skip_puzl19c, cut_scene)
    RunFullscreenMovie("getshcks.snm")
    END_CUT_SCENE()
    tr:solve_mod()
end
cut_scene.skip_puzl19c = function(arg1) -- line 382
    kill_override()
    music_state:unpause()
    tr:solve_mod()
end
cut_scene.puzl16c = function(arg1) -- line 388
    if not bd.bone_wagon.touchable then
        sg.bone_wagon:make_untouchable()
        na.bone_wagon:make_untouchable()
        lb.bone_wagon:make_untouchable()
        bd.bone_wagon:make_touchable()
    end
    START_CUT_SCENE()
    bd:switch_to_set()
    print_temporary("anim: manny runs out on fire, Glottis sprays him with a fire extinguisher.")
    wait_for_message()
    manny:say_line("/syma092/")
    wait_for_message()
    manny:say_line("/syma093/")
    wait_for_message()
    glottis:say_line("/sygl094/")
    wait_for_message()
    manny:say_line("/syma095/")
    END_CUT_SCENE()
    bd.extinguisher:get()
end
cut_scene.outofpf = function(arg1) -- line 412
    if not bd.all_beavers_dead then
        bd.all_beavers_dead = TRUE
        bv:switch_to_set()
        break_here()
    end
    set_override(cut_scene.skip_outofpf, cut_scene)
    START_CUT_SCENE()
    IrisDown(320, 200, 1000)
    bd:switch_to_set()
    bd:current_setup(bd_damha)
    manny:push_costume("bonewagon_gl.cos")
    manny:put_in_set(bd)
    manny:set_walk_rate(0.2)
    manny:play_chore(bonewagon_gl_stay_up)
    manny:play_chore(bonewagon_gl_ma_sit)
    manny:play_chore(bonewagon_gl_gl_drive)
    manny:setpos(4.51662, 0.58792, 0.13)
    manny:setrot(0, -91.5959, 0)
    start_script(bd.leave_drive)
    start_script(bd.set_roll)
    start_script(bd.set_pitch)
    start_sfx("bwIdle.IMU", IM_HIGH_PRIORITY, 80)
    IrisUp(320, 200, 1000)
    sleep_for(800)
    glottis:say_line("/bdgl012/")
    wait_for_message()
    manny:say_line("/bdma013/")
    wait_for_message()
    glottis:say_line("/bdgl014/")
    wait_for_message()
    manny:say_line("/bdma015/")
    wait_for_message()
    manny:say_line("/bdma016/")
    wait_for_message()
    glottis:say_line("/bdgl017/")
    wait_for_message()
    END_CUT_SCENE()
    manny:pop_costume()
    stop_sound("bwIdle.IMU")
    stop_script(bd.leave_drive)
    stop_script(bd.set_roll)
    stop_script(bd.set_pitch)
    manny.is_holding = nil
    manny:stop_chore(manny.hold_chore, manny.base_costume)
    manny:stop_chore(ms_hold, manny.base_costume)
    manny.hold_chore = nil
    bd.extinguisher:free()
    sp.bones.bone1:free()
    sp.bones.bone2:free()
    sp.bones.bone3:free()
    sp.bones.bone4:free()
    sp.bones.bone5:free()
    lb.key:free()
    cut_scene:heloruba()
end
cut_scene.skip_outofpf = function(arg1) -- line 475
    kill_override()
    manny:default("action")
    stop_sound("bwIdle.IMU")
    stop_script(bd.leave_drive)
    stop_script(bd.set_roll)
    stop_script(bd.set_pitch)
    manny.is_holding = nil
    manny:stop_chore(manny.hold_chore, manny.base_costume)
    manny:stop_chore(ms_hold, manny.base_costume)
    manny.hold_chore = nil
    bd.extinguisher:free()
    sp.bones.bone1:free()
    sp.bones.bone2:free()
    sp.bones.bone3:free()
    sp.bones.bone4:free()
    sp.bones.bone5:free()
    lb.key:free()
    cut_scene:heloruba()
end
cut_scene.heloruba = function(arg1) -- line 496
    cutscene_menu:enable_cutscene("heloruba")
    START_CUT_SCENE()
    set_override(cut_scene.skip_heloruba, cut_scene)
    fc:switch_to_set()
    RunFullscreenMovie("heloruba.snm")
    re:switch_to_set()
    re:current_setup(re_lotws)
    END_CUT_SCENE()
    start_script(re.heloruba_outro)
end
cut_scene.skip_heloruba = function(arg1) -- line 512
    kill_override()
    music_state:unpause()
    re:switch_to_set()
    re:current_setup(re_lotws)
    single_start_script(re.heloruba_outro, re)
end
cut_scene.plunge = function(arg1) -- line 520
    cutscene_menu:enable_cutscene("plunge")
    START_CUT_SCENE()
    set_override(cut_scene.skip_plunge, cut_scene)
    RunFullscreenMovie("plunge.snm")
    re:switch_to_set()
    END_CUT_SCENE()
    start_script(re.velasco_intro)
end
cut_scene.skip_plunge = function(arg1) -- line 532
    kill_override()
    music_state:unpause()
    single_start_script(re.velasco_intro)
end
cut_scene.year2int = function(arg1) -- line 538
    re.logbook:put_in_limbo()
    ri.photo:put_in_limbo()
    cutscene_menu:enable_cutscene("yr2intro")
    START_CUT_SCENE()
    set_override(cut_scene.skip_year2int, cut_scene)
    RunFullscreenMovie("yr2intro.snm")
    END_CUT_SCENE()
    cut_scene:skip_year2int(FALSE)
end
cut_scene.skip_year2int = function(arg1, arg2) -- line 553
    if arg2 then
        kill_override()
        music_state:unpause()
    end
    manny:free()
    NukeResources()
    GetSystemFonts()
    CheckForCD("bi.set", TRUE)
    cb:switch_to_set()
    cb:current_setup(cb_intha)
    manny:put_in_set(cb)
    manny:setpos(-0.154667, -0.453814, 1.77)
    manny:setrot(0, 251.954, 0)
    if not track_announcer then
        track_announcer = Actor:create(nil, nil, nil, "announcer")
    end
    track_announcer:set_talk_color(Red)
    if not find_script(tb.track_announcer) then
        tb.init_cat_names()
        start_script(tb.track_announcer)
        start_script(announcer_volume_setting)
    end
    start_script(cb.alex_derek_and_steves_idea)
end
BundleResource("sv_in_hq.cos")
BundleResource("eva_sec.cos")
BundleResource("brennis_fix_idle.cos")
BundleResource("pigeon1.WAV")
BundleResource("pigeon2.WAV")
BundleResource("pigeon3.WAV")
BundleResource("pigeon4.WAV")
BundleResource("pigeon5.WAV")
BundleResource("pigeon6.WAV")
BundleResource("pigeon7.WAV")
BundleResource("pigeon8.WAV")
BundleResource("wingfly1.WAV")
BundleResource("wingfly2.WAV")
BundleResource("wingfly3.WAV")
BundleResource("wingfly4.WAV")
BundleResource("wingfly5.WAV")
BundleResource("wings1.WAV")
BundleResource("wings2.WAV")
BundleResource("wings3.WAV")
BundleResource("wings4.WAV")
BundleResource("wings5.WAV")
BundleResource("wings6.WAV")
BundleResource("wings7.WAV")
BundleResource("wings8.WAV")
BundleResource("suit_inv.set")
BundleResource("action_inv.set")

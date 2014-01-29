CheckFirstTime("dd.lua")
dofile("sea_bees.lua")
dd = Set:create("dd.set", "dry dock", { dd_estws = 0, dd_estws2 = 0, dd_barla = 1, dd_overhead = 2 })
dd.camera_adjusts = { 0, 60 }
dd.no_chant = 999
dd.chant_table = { }
dd.chant_table[0] = { terry = "/ddte001/", angry_bees = "/ddab002/", manny = "/ddma023/", length = 2090 }
dd.chant_table[1] = { terry = "/ddte003/", angry_bees = "/ddab004/", manny = "/ddma024/", length = 2080 }
dd.chant_table[2] = { terry = "/ddte005/", angry_bees = "/ddab006/", manny = "/ddma025/", length = 2440 }
dd.chant_table[3] = { terry = "/ddte007/", angry_bees = "/ddab008/", manny = "/ddma026/", length = 2570 }
dd.chant_table[4] = { terry = "/ddte009/", angry_bees = "/ddab010/", manny = "/ddma027/", length = 1580 }
dd.chant_table[5] = { terry = "/ddte011/", angry_bees = "/ddab012/", manny = "/ddma028/", length = 1510 }
dd.chant_table[6] = { terry = "/ddte013/", angry_bees = "/ddab014/", manny = "/ddma029/", length = 1040, bee_delay = 0 }
dd.chant_table[7] = { terry = "/ddte015/", angry_bees = "/ddab016/", manny = "/ddma030/", length = 860, bee_delay = 0 }
dd.chant_table[8] = { terry = "/ddte017/", angry_bees = "/ddab018/", manny = "/ddma033/", length = 2010, bee_delay = 1700 }
dd.chant_table[9] = { terry = "/ddte019/", angry_bees = "/ddab020/", manny = "/ddma031/", length = 2410 }
dd.chant_table[10] = { terry = "/ddte021/", angry_bees = "/ddab022/", manny = "/ddma032/", length = 2290 }
dd.chant_table.sequence = { 0, 1, 0, 1, 2, 3, 2, 3, 4, 5, 4, 5, 6, 7, 8, 6, 7, 8, 9, 10, 9, 10 }
dd.chant_table.score = 0
dd.chant_table.cur_index = 1
dd.chant_table.num_entries = 18
dd.chant_table.special_num_entries = 22
dd.chant_table.time_for_manny = FALSE
dd.chanting_bees = function(arg1) -- line 85
    local local1
    while 1 do
        local1 = dd.chant_table.sequence[dd.chant_table.cur_index]
        dd:bees_chant_once(local1)
        dd.chant_table.cur_index = dd.chant_table.cur_index + 1
        if dd.chant_table.score >= dd.chant_table.num_entries then
            if dd.chant_table.cur_index > dd.chant_table.special_num_entries then
                dd.chant_table.cur_index = 1
            end
        elseif dd.chant_table.cur_index > dd.chant_table.num_entries then
            dd.chant_table.cur_index = 1
        end
        break_here()
    end
end
dd.bees_chant_once = function(arg1, arg2) -- line 107
    local local1, local2
    if dd.chant_table[arg2].bee_delay then
        local2 = dd.chant_table[arg2].bee_delay
    else
        local2 = dd.chant_table[arg2].length - 500
        if local2 < 500 then
            local2 = 500
        end
    end
    dd.chant_table.time_for_manny = FALSE
    terry:say_line(dd.chant_table[arg2].terry, { background = TRUE, skip_log = TRUE })
    if dd.chant_table[arg2].bee_delay then
        if local2 > 0 then
            sleep_for(local2)
        end
    else
        local1 = 0
        while local1 < local2 and terry:is_speaking() do
            break_here()
            local1 = local1 + system.frameTime
        end
    end
    dd.chant_table.time_for_manny = TRUE
    if dd.chant_table[arg2].bee_delay == nil then
        terry:wait_for_message()
    end
    angry_bees:say_line(dd.chant_table[arg2].angry_bees, { background = TRUE, skip_log = TRUE })
    local2 = 2000
    local1 = 0
    while local1 < local2 and angry_bees:is_speaking() do
        break_here()
        local1 = local1 + system.frameTime
    end
    dd.chant_table.time_for_manny = FALSE
    angry_bees:wait_for_message()
end
dd.manny_chant = function(arg1) -- line 155
    local local1, local2
    local1 = dd.chant_table.sequence[dd.chant_table.cur_index]
    manny:say_line(dd.chant_table[local1].manny)
    if dd.chant_table.time_for_manny then
        if dd.chant_table.score <= dd.chant_table.num_entries then
            dd.chant_table.score = dd.chant_table.score + 1
        end
    else
        dd.chant_table.score = 0
        dd.chant_table.cur_index = 1
        START_CUT_SCENE()
        stop_script(dd.chanting_bees)
        manny:wait_for_message()
        terry.stop_rotate = TRUE
        terry:play_chore(bee_barrel_lk_lft, "bee_barrel.cos")
        terry:say_line("/ddte034/", { background = TRUE })
        terry:wait_for_chore(bee_barrel_lk_lft, "bee_barrel.cos")
        terry:stop_chore(bee_barrel_lk_lft, "bee_barrel.cos")
        terry:play_chore_looping(bee_barrel_lk_lft_hold, "bee_barrel.cos")
        terry:wait_for_message()
        wait_for_message()
        local2 = 0
        while find_script(terry.strike_rotate) and local2 < 5000 do
            break_here()
            local2 = local2 + system.frameTime
        end
        terry:say_line("/ddte035/", { background = TRUE })
        terry:wait_for_message()
        manny:shrug_gesture()
        manny:say_line("/ddma036/", { background = TRUE })
        terry:wait_for_message()
        terry:setrot(0, 20, 0, TRUE)
        terry:stop_chore(bee_barrel_lk_lft_hold, "bee_barrel.cos")
        terry:run_chore(bee_barrel_lk_lft_to_ctr, "bee_barrel.cos")
        terry:say_line("/ddte037/")
        terry:wait_for_message()
        single_start_script(terry.strike_rotate, terry)
        END_CUT_SCENE()
        start_script(dd.chanting_bees, dd)
    end
end
dd.grumble = function(arg1, arg2) -- line 204
end
dd.set_up_barrel_bees = function(arg1) -- line 221
    bee1:default()
    bee1:put_in_set(dd)
    bee1:init_barrel_stuff(0.744106, -2.74781, 0, 0, 92.3754, 0, TRUE)
    bee2:default()
    bee2:put_in_set(dd)
    bee2:init_barrel_stuff(0.279684, -2.23932, 0, 0, 180, 0)
end
dd.set_up_actors = function(arg1) -- line 231
    if in_year_four then
        terry:put_in_set(nil)
        angry_bees:put_in_set(nil)
        bee1:put_in_set(nil)
        bee2:put_in_set(nil)
    elseif not dd.strike_on then
        if not dd.terry_arrested then
            terry:default()
            terry:put_in_set(dd)
            terry:init_barrel_stuff(0.20409, -3.14569, 0, 0, 33.323, 0)
        end
        dd:set_up_barrel_bees()
        worker_bee1:default()
        worker_bee1:put_in_set(dd)
        worker_bee1:work_idles()
    else
        worker_bee1:put_in_set(nil)
        worker_bee2:put_in_set(nil)
        if not dd.terry_arrested then
            terry:default("strike")
            terry:put_in_set(dd)
            terry:setpos(0.295176, -2.88143, 0.3485)
            terry:setrot(0, 16.9407, 0)
            terry:strike_idles()
        end
        bee1:default("strike")
        bee1:put_in_set(dd)
        bee1:init_strike_stuff(0.694405, -2.6637, 0, 0, 90, 0)
        angry_bees:default("strike")
        angry_bees:put_in_set(dd)
        angry_bees:init_strike_stuff(0.401905, -2.302, 0, 0, 140, 0)
        angry_bees:strike_idles()
        bee2:default("strike")
        bee2:put_in_set(dd)
        bee2:init_strike_stuff(-0.0665543, -2.65247, 0, 0, 250, 0)
        bee2:strike_idles()
    end
end
dd.enter = function(arg1) -- line 285
    if in_year_four then
        dd.barrel_bees:make_untouchable()
        dd.worker_bees:make_untouchable()
        dd.tools:make_untouchable()
        dd.striking_bees:make_untouchable()
        dd.dry_docks:make_touchable()
        dd.terry_obj:make_untouchable()
        box_on("notools_box1")
        box_on("notools_box2")
    elseif dd.strike_on then
        MakeSectorActive("strikebox1", FALSE)
        MakeSectorActive("strikebox2", FALSE)
        dd.barrel_bees:make_untouchable()
        dd.worker_bees:make_untouchable()
        dd.striking_bees:make_touchable()
        angry_bees:set_speech_mode(TRUE)
        dd.terry_obj:make_untouchable()
        dd.tools:make_touchable()
        box_off("notools_box1")
        box_off("notools_box2")
        dd:add_object_state(dd_estws, "dd_0_tools.bm", "dd_0_tools.zbm", OBJSTATE_STATE)
        dd:add_object_state(dd_barla, "dd_1_tools.bm", nil, OBJSTATE_STATE)
        dd.tools:set_object_state("dd_tools.cos")
        dd.tools.interest_actor:put_in_set(dd)
        dd.tools.interest_actor:set_visibility(TRUE)
        dd.tools.interest_actor:play_chore(0)
        start_script(dd.chanting_bees)
    else
        MakeSectorActive("strikebox1", TRUE)
        MakeSectorActive("strikebox2", TRUE)
        dd.striking_bees:make_untouchable()
        dd.tools:make_untouchable()
        box_on("notools_box1")
        box_on("notools_box2")
        if not dd.terry_arrested then
            dd.terry_obj:make_touchable()
            dd.barrel_bees.use_pnt_x = 0.00822388
            dd.barrel_bees.use_pnt_y = -2.40578
            dd.barrel_bees.use_pnt_z = 0
            dd.barrel_bees.use_rot_x = 0
            dd.barrel_bees.use_rot_y = 200.292
            dd.barrel_bees.use_rot_z = 0
            dd.barrel_bees.obj_x = 0.152738
            dd.barrel_bees.obj_y = -2.81556
            dd.barrel_bees.obj_z = 0.4603
            dd.barrel_bees:make_touchable()
        else
            dd.terry_obj:make_untouchable()
            dd.barrel_bees.obj_x = 0.453461
            dd.barrel_bees.obj_y = -2.6785
            dd.barrel_bees.obj_z = 0.427
            dd.barrel_bees:make_touchable()
            dd.barrel_bees.use_pnt_x = -0.0515388
            dd.barrel_bees.use_pnt_y = -2.6785
            dd.barrel_bees.use_pnt_z = 0
            dd.barrel_bees.use_rot_x = 0
            dd.barrel_bees.use_rot_y = 297.799
            dd.barrel_bees.use_rot_z = 0
        end
    end
    if dd.terry_obj.touchable or dd.strike_on then
        box_off("no_terry_box")
        box_off("no_terry_box2")
    else
        box_on("no_terry_box")
        box_on("no_terry_box2")
    end
    if in_year_four then
        box_on("nobees_box")
    else
        box_off("nobees_box")
    end
    dd:set_up_actors()
    dd:current_setup(dd_barla)
    start_script(foghorn_sfx)
    dd:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.349614, -2.8997, 3.645)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    if dd.strike_on then
        SetActiveShadow(terry.hActor, 0)
        SetActorShadowPoint(terry.hActor, 0.349614, -2.8997, 3.645)
        SetActorShadowPlane(terry.hActor, "shadow1")
        AddShadowPlane(terry.hActor, "shadow1")
    end
end
dd.exit = function(arg1) -- line 388
    StopMovie()
    stop_script(foghorn_sfx)
    stop_script(dd.chanting_bees)
    stop_script(dd.manny_chant)
    sea_bee.strike_actor = nil
    terry:stop_idles()
    stop_script(terry.fake_hover)
    bee1:stop_idles()
    bee2:stop_idles()
    worker_bee1:stop_idles()
    worker_bee2:stop_idles()
    angry_bees:stop_idles()
    shut_up_everybody()
    terry:free()
    angry_bees:free()
    bee1:free()
    bee2:free()
    worker_bee1:free()
    worker_bee2:free()
    stop_sound("dd_frdrm.IMU")
    stop_sound("beewing.imu")
    KillActorShadows(manny.hActor)
    if dd.strike_on then
        KillActorShadows(terry.hActor)
    end
end
dd.camerachange = function(arg1, arg2, arg3) -- line 424
    if arg3 == dd_estws then
        play_movie_looping("dd_lx.snm", 0, 107)
    else
        StopMovie()
    end
    if arg3 == dd_barla then
        dd.barrel_bees.interest_actor:play_sound_at("dd_frdrm.IMU", 100, 127)
    else
        stop_sound("dd_frdrm.IMU")
    end
end
dd.update_music_state = function(arg1) -- line 438
    if dd.strike_on and not dd.terry_arrested then
        return stateDD_STRIKE
    else
        return stateDD
    end
end
dd.barrel_bees = Object:create(dd, "/ddtx046/dock workers", 0.152738, -2.8155601, 0.4603, { range = 1.2 })
dd.barrel_bees.use_pnt_x = 0.0082238801
dd.barrel_bees.use_pnt_y = -2.4057801
dd.barrel_bees.use_pnt_z = 0
dd.barrel_bees.use_rot_x = 0
dd.barrel_bees.use_rot_y = 200.29201
dd.barrel_bees.use_rot_z = 0
dd.barrel_bees.lookAt = function(arg1) -- line 459
    if dd.terry_arrested then
        manny:say_line("/ddma047/")
    else
        manny:say_line("/ddma048/")
    end
end
dd.barrel_bees.use_paper = function(arg1) -- line 467
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if not dd.terry_arrested then
        manny:head_look_at(dd.terry_obj)
    else
        manny:head_look_at(dd.barrel_bees)
    end
    manny:say_line("/ddma049/")
    manny:wait_for_message()
    if not dd.terry_arrested then
        terry:remove_barrel_stamp()
        terry:stop_barrel_idles()
        terry:head_left()
        terry:say_line("/ddte050/")
        terry:head_wag()
        terry:point_once()
        wait_for_message()
        terry:say_line("/ddte051/")
        wait_for_message()
        terry:say_line("/ddte052/")
        terry:head_nod()
        terry:stop_head_left()
        wait_for_message()
        terry:say_line("/ddte053/")
        terry:head_left()
        terry:gesture1()
        terry:gesture2()
        terry:stop_gesture()
        wait_for_message()
        dd:grumble("agreement")
        terry:stop_head_left()
        sleep_for(1000)
        terry:head_left()
        terry:say_line("/ddte054/")
        terry:head_wag()
        terry:wait_for_message()
        terry:stop_head_left()
        terry:replace_barrel_stamp()
        terry:barrel_idles()
    end
    END_CUT_SCENE()
end
dd.barrel_bees.use = function(arg1) -- line 511
    if dd.terry_arrested then
        START_CUT_SCENE()
        manny:say_line("/ddma055/")
        wait_for_message()
        sleep_for(2000)
        wait_for_message()
        manny:say_line("/ddma056/")
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:head_look_at(dd.terry_obj)
        END_CUT_SCENE()
        Dialog:run("be1", "dlg_bees.lua")
    end
end
dd.barrel_bees.use_book = function(arg1) -- line 530
    bi.book:free()
    cur_puzzle_state[28] = TRUE
    START_CUT_SCENE()
    terry:remove_barrel_stamp()
    terry:stop_barrel_idles()
    manny:walkto(0.00433837, -2.60886, 0, 0, 178.631, 0)
    manny:wait_for_actor()
    manny:head_look_at(dd.terry_obj)
    manny:stop_chore(mc_hold, "mc.cos")
    manny:play_chore(mc_give_book_from_hold, "mc.cos")
    manny:say_line("/ddma057/")
    manny:wait_for_message()
    manny:wait_for_chore(mc_give_book_from_hold, "mc.cos")
    terry:play_chore(tm_manifesto_read_book, "tm_manifesto.cos")
    sleep_for(2000)
    manny:stop_chore(mc_activate_book, "mc.cos")
    manny:stop_chore(mc_give_book_from_hold, "mc.cos")
    manny:play_chore(mc_stop_give_book, "mc.cos")
    manny:wait_for_chore(mc_stop_give_book, "mc.cos")
    manny.is_holding = nil
    manny:stop_chore(mc_stop_give_book, "mc.cos")
    terry:say_line("/nretm02a/")
    terry:wait_for_message()
    terry:say_line("/nretm02b/")
    terry:wait_for_message()
    music_state:set_sequence(seqYr4Iris)
    IrisDown(490, 290, 2500)
    terry:say_line("/nretm02c/")
    sleep_for(2500)
    terry:wait_for_message()
    END_CUT_SCENE()
    stop_script(foghorn_sfx)
    stop_sound("beewing.IMU")
    stop_sound("dd_frdrm.IMU")
    terry:stop_idles()
    bee1:stop_idles()
    bee2:stop_idles()
    worker_bee1:stop_idles()
    worker_bee2:stop_idles()
    worker_bee1:stop_chore()
    worker_bee2:stop_chore()
    worker_bee1:free()
    worker_bee2:free()
    terry:free()
    IrisUp(480, 285, 1)
    start_script(cut_scene.normarae, cut_scene)
end
dd.terry_obj = Object:create(dd, "terry", 0.1937, -3.0701001, 0.44400001, { range = 1.4 })
dd.terry_obj.use_pnt_x = 0.0082238801
dd.terry_obj.use_pnt_y = -2.4057801
dd.terry_obj.use_pnt_z = 0
dd.terry_obj.use_rot_x = 0
dd.terry_obj.use_rot_y = 200.29201
dd.terry_obj.use_rot_z = 0
dd.terry_obj.lookAt = dd.barrel_bees.lookAt
dd.terry_obj.use_paper = dd.barrel_bees.use_paper
dd.terry_obj.use = dd.barrel_bees.use
dd.terry_obj.use_book = dd.barrel_bees.use_book
dd.worker_bees = Object:create(dd, "/ddtx058/workers", 3.02299, -3.70382, 2.1996, { range = 3 })
dd.worker_bees.use_pnt_x = -0.0046294299
dd.worker_bees.use_pnt_y = -2.76352
dd.worker_bees.use_pnt_z = 0
dd.worker_bees.use_rot_x = 0
dd.worker_bees.use_rot_y = 258.01999
dd.worker_bees.use_rot_z = 0
dd.worker_bees.lookAt = function(arg1) -- line 603
    if dd.terry_arrested then
        manny:say_line("/ddma059/")
    else
        manny:say_line("/ddma060/")
    end
end
dd.worker_bees.use = function(arg1) -- line 611
    if dd.terry_arrested then
        manny:say_line("/ddma061/")
    else
        manny:say_line("/ddma062/")
    end
end
dd.dry_docks = Object:create(dd, "/ddtx058/dry docks", 1.9107, -3.1161001, 1.3, { range = 1.8 })
dd.dry_docks.use_pnt_x = 1.91521
dd.dry_docks.use_pnt_y = -2.3505399
dd.dry_docks.use_pnt_z = 0
dd.dry_docks.use_rot_x = 0
dd.dry_docks.use_rot_y = 186.147
dd.dry_docks.use_rot_z = 0
dd.dry_docks:make_untouchable()
dd.dry_docks.lookAt = function(arg1) -- line 630
    manny:say_line("/ddma148/")
end
dd.dry_docks.use = function(arg1) -- line 634
    manny:say_line("/ddma149/")
end
dd.tools = Object:create(dd, "/ddtx063/tools", 3.42729, -1.84909, 0, { range = 1 })
dd.tools.use_pnt_x = 2.02548
dd.tools.use_pnt_y = -1.99537
dd.tools.use_pnt_z = 0
dd.tools.use_rot_x = 0
dd.tools.use_rot_y = 73.664398
dd.tools.use_rot_z = 0
dd.tools.touchable = FALSE
dd.tools.lookAt = function(arg1) -- line 648
    manny:say_line("/ddma064/")
end
dd.tools.pickUp = function(arg1) -- line 652
    START_CUT_SCENE()
    manny:say_line("/ddma065/")
    wait_for_message()
    manny:say_line("/ddma066/")
    wait_for_message()
    manny:head_look_at(dd.striking_bees)
    END_CUT_SCENE()
    manny:say_line("/ddma067/")
end
dd.tools.use = dd.tools.pickUp
dd.striking_bees = Object:create(dd, "/ddtx068/striking bees", 0.358307, -2.75442, 0.44569999, { range = 1.2 })
dd.striking_bees.use_pnt_x = 0.099768102
dd.striking_bees.use_pnt_y = -3.1134501
dd.striking_bees.use_pnt_z = 0
dd.striking_bees.use_rot_x = 0
dd.striking_bees.use_rot_y = 300.14401
dd.striking_bees.use_rot_z = 0
dd.striking_bees.lookAt = function(arg1) -- line 673
    manny:say_line("/ddma069/")
end
dd.striking_bees.use = function(arg1) -- line 677
    if not find_script(dd.manny_chant) then
        start_script(dd.manny_chant)
    end
end
dd.bw_door = Object:create(dd, "/ddtx070/door", 6.4823899, -1.10084, 0.2, { range = 0 })
dd.bw_door.use_pnt_x = 6.0623498
dd.bw_door.use_pnt_y = -0.73478502
dd.bw_door.use_pnt_z = 0
dd.bw_door.use_rot_x = 0
dd.bw_door.use_rot_y = 294.05499
dd.bw_door.use_rot_z = 0
dd.bw_door.out_pnt_x = 6.3910699
dd.bw_door.out_pnt_y = -0.58802199
dd.bw_door.out_pnt_z = 0
dd.bw_door.out_rot_x = 0
dd.bw_door.out_rot_y = 294.05499
dd.bw_door.out_rot_z = 0
dd.bw_door.touchable = FALSE
dd.bw_box = dd.bw_door
dd.bw_door.walkOut = function(arg1) -- line 704
    bw:come_out_door(bw.dd_door)
end
dd.hb_door = Object:create(dd, "/ddtx071/bridge", 7.2923799, -2.8808401, 0.36000001, { range = 0 })
dd.hb_door.use_pnt_x = 6.9554601
dd.hb_door.use_pnt_y = -2.84039
dd.hb_door.use_pnt_z = 0
dd.hb_door.use_rot_x = 0
dd.hb_door.use_rot_y = -84.0373
dd.hb_door.use_rot_z = 0
dd.hb_door.out_pnt_x = 7.51475
dd.hb_door.out_pnt_y = -2.78197
dd.hb_door.out_pnt_z = 0
dd.hb_door.out_rot_x = 0
dd.hb_door.out_rot_y = -84.0373
dd.hb_door.out_rot_z = 0
dd.hb_door.touchable = FALSE
dd.hb_box = dd.hb_door
dd.hb_door.walkOut = function(arg1) -- line 732
    hb:come_out_door(hb.dd_door)
end
dd.lx_door = Object:create(dd, "/ddtx150/door", -0.87710798, -2.7339499, 0.41999999, { range = 0 })
dd.lx_door.use_pnt_x = -0.227108
dd.lx_door.use_pnt_y = -2.7339499
dd.lx_door.use_pnt_z = 0
dd.lx_door.use_rot_x = 0
dd.lx_door.use_rot_y = -253.263
dd.lx_door.use_rot_z = 0
dd.lx_door.out_pnt_x = -0.089898802
dd.lx_door.out_pnt_y = -3.0886199
dd.lx_door.out_pnt_z = 0
dd.lx_door.out_rot_x = 0
dd.lx_door.out_rot_y = -49.1357
dd.lx_door.out_rot_z = 0
dd.lx_door.touchable = FALSE
dd.lx_box = dd.lx_door
dd.lx_door.walkOut = function(arg1) -- line 754
    lx:come_out_door(lx.dd_door)
end

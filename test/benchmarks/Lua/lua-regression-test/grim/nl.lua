CheckFirstTime("nl.lua")
dofile("md_sproutella.lua")
nl = Set:create("nl.set", "Neon Ledge", { nl_hndws = 0, nl_legla = 1, nl_neoha = 2, nl_neoha2 = 2, nl_ovrhd = 3, nl_fallen = 4 })
nl.jump_off_ledge = function(arg1) -- line 14
    local local1, local2
    START_CUT_SCENE()
    ResetMarioControls()
    local1 = manny:getpos()
    manny:walkto(local1.x, 1.5984499, 4.1100001, 0, 0, 0)
    manny:wait_for_actor()
    manny:clear_hands()
    manny:set_costume(nil)
    manny:set_rest_chore(-1)
    manny:set_costume("md_sproutella.cos")
    manny:play_chore(md_sproutella_jump_down, "md_sproutella.cos")
    manny:wait_for_chore(md_sproutella_jump_down, "md_sproutella.cos")
    manny:default("reaper")
    manny:setpos(local1.x, 1.84796, 3.71)
    manny:setrot(0, 0, 0)
    local2 = 0
    while manny:find_sector_type(HOT) or local2 < 500 do
        manny:walk_forward()
        break_here()
        local2 = local2 + system.frameTime
    end
    END_CUT_SCENE()
end
nl.jump_on_ledge = function(arg1) -- line 39
    local local1, local2
    START_CUT_SCENE()
    ResetMarioControls()
    local1 = manny:getpos()
    manny:walkto(local1.x, 1.84796, 3.71, 0, 180, 0)
    manny:wait_for_actor()
    manny:clear_hands()
    manny:set_costume(nil)
    manny:set_rest_chore(-1)
    manny:set_costume("md_sproutella.cos")
    manny:play_chore(md_sproutella_climb_up, "md_sproutella.cos")
    manny:wait_for_chore(md_sproutella_climb_up, "md_sproutella.cos")
    manny:default("reaper")
    manny:setpos(local1.x, 1.5984499, 4.1100001)
    manny:setrot(0, 180, 0)
    local2 = 0
    while manny:find_sector_type(HOT) or local2 < 500 do
        manny:walk_forward()
        break_here()
        local2 = local2 + system.frameTime
    end
    END_CUT_SCENE()
end
nl.drop_lady = function(arg1) -- line 65
    nl.sign_down = TRUE
    nl.gargoyle:make_untouchable()
    nl.arm:make_untouchable()
    nl.window1:make_untouchable()
    cur_puzzle_state[59] = TRUE
    START_CUT_SCENE()
    nl:current_setup(nl_legla)
    RunFullscreenMovie("neonlady.snm")
    nl:current_setup(nl_fallen)
    music_state:update()
    manny.is_holding = nil
    manny:stop_chore(md_hold, "md.cos")
    manny:stop_chore(md_activate_sproutella, "md.cos")
    manny:setpos(-4.26557, 3.24848, 3.71)
    manny:setrot(0, 185.693, 0)
    manny:head_look_at_point(-4.26557, 0.993478, 6.25)
    sleep_for(2000)
    manny:say_line("/nlma001/")
    manny:wait_for_message()
    END_CUT_SCENE()
end
nl.cowabunga = function(arg1) -- line 91
    START_CUT_SCENE()
    manny:walkto_object(nl.sign_ladder)
    manny:wait_for_actor()
    StartFullscreenMovie("legslide.snm")
    sleep_for(200)
    manny:say_line("/nlma002/")
    wait_for_movie()
    END_CUT_SCENE()
    stop_sound("fluorLp.IMU")
    start_script(cut_scene.eldepot)
end
nl.enter = function(arg1) -- line 111
    sh.remote:free()
    nq.photo:free()
    start_sfx("fluorLp.IMU", IM_MED_PRIORITY, 7)
    set_vol("fluorLp.IMU", 7)
end
nl.exit = function(arg1) -- line 120
    stop_sound("fluorLp.IMU")
end
nl.camerachange = function(arg1, arg2, arg3) -- line 124
    if nl.sign_down and (arg3 == nl_neoha or arg3 == nl_hndws) then
        arg1:current_setup(nl_fallen)
    end
    if not find_script(cut_scene.eldepot) then
        if arg3 == nl_hndws then
            set_vol("fluorLp.IMU", 20)
        else
            set_vol("fluorLp.IMU", 7)
        end
    end
end
nl.ledge_to_roof = { }
nl.ledge_to_roof.walkOut = function(arg1) -- line 146
    ResetMarioControls()
    manny:setpos(-1.90523, 3.43174, 3.71)
    manny:setrot(0, -298.134, 0)
    manny:walkto(-2.6969, 3.85474, 3.71)
    if not nl.talked_pigeons then
        nl.talked_pigeons = TRUE
        soft_script()
        manny:wait_for_actor()
        manny:say_line("/nlma003/")
        wait_for_message()
        manny:say_line("/nlma004/")
    end
end
nl.roof_to_ledge = { }
nl.roof_to_ledge.walkOut = function(arg1) -- line 166
    if not nl.sign_down then
        ResetMarioControls()
        manny:setpos(0.113097, 1.31475, -0.02)
        manny:setrot(0, -430.209, 0)
        manny:walkto(0.127614, 1.11551, -0.02)
    end
end
nl.retreat = { }
nl.retreat.walkOut = function(arg1) -- line 179
    ResetMarioControls()
    manny:walkto(-4.42962, 0.328149, -0.02)
    manny:say_line("/nlma005/")
end
nl.gargoyle = Object:create(nl, "/nltx006/gargoyle", -8.2358103, 1.04679, 4.0900002, { range = 1 })
nl.gargoyle.use_pnt_x = -8.2952805
nl.gargoyle.use_pnt_y = 1.46986
nl.gargoyle.use_pnt_z = 4.1100001
nl.gargoyle.use_rot_x = 0
nl.gargoyle.use_rot_y = 180.963
nl.gargoyle.use_rot_z = 0
nl.gargoyle.lookAt = function(arg1) -- line 194
    manny:say_line("/nlma007/")
end
nl.gargoyle.use = function(arg1) -- line 198
    manny:say_line("/nlma008/")
end
nl.gargoyle.pickUp = nl.gargoyle.use
nl.gargoyle.use_grinder = function(arg1) -- line 204
    if not arg1.boned then
        if manny:walkto_object(arg1) then
            arg1.boned = TRUE
            START_CUT_SCENE()
            th.grinder:use()
            manny:stop_chore(md_activate_grinder_full, "md.cos")
            manny:play_chore(md_activate_grinder_empty, "md.cos")
            manny:say_line("/nlma009/")
            manny:clear_hands()
            th.grinder.has_bone = FALSE
            END_CUT_SCENE()
        end
    else
        th.grinder:use()
    end
end
nl.gargoyle.use_sproutella = function(arg1) -- line 222
    if not arg1.boned then
        manny:say_line("/nlma010/")
    else
        if manny:walkto_object(arg1) then
            START_CUT_SCENE()
            music_state:set_state(STATE_NULL)
            manny:set_costume(nil)
            manny:set_costume("md_sproutella.cos")
            manny:play_chore(md_sproutella_sproutella, "md_sproutella.cos")
            sleep_for(4000)
            play_movie("nl_crush.snm", 272, 0)
            wait_for_movie()
            manny:wait_for_chore(md_sproutella_sproutella, "md_sproutella.cos")
            manny:stop_chore(md_sproutella_sproutella, "md_sproutella.cos")
            manny.is_holding = nil
            manny.hold_chore = nil
            manny:default("reaper")
            END_CUT_SCENE()
        end
        start_script(nl.drop_lady)
    end
end
nl.arm = Object:create(nl, "/nltx011/arm", -7.2958102, 0.43678999, 4.8099999, { range = 1.9 })
nl.arm.use_pnt_x = -8.0358105
nl.arm.use_pnt_y = 1.50679
nl.arm.use_pnt_z = 3.71
nl.arm.use_rot_x = 0
nl.arm.use_rot_y = -171.75999
nl.arm.use_rot_z = 0
nl.arm.lookAt = function(arg1) -- line 256
    manny:say_line("/nlma012/")
end
nl.arm.use = function(arg1) -- line 260
    manny:say_line("/nlma013/")
end
nl.sign_ladder = Object:create(nl, "/nltx014/ladder", -3.45877, 3.1797099, 4.71, { range = 1.1 })
nl.sign_ladder.use_pnt_x = -3.6687701
nl.sign_ladder.use_pnt_y = 3.1597099
nl.sign_ladder.use_pnt_z = 3.71
nl.sign_ladder.use_rot_x = 0
nl.sign_ladder.use_rot_y = -85.556503
nl.sign_ladder.use_rot_z = 0
nl.sign_ladder.lookAt = function(arg1) -- line 272
    system.default_response("ladder")
end
nl.sign_ladder.use = function(arg1) -- line 275
    if not nl.sign_down then
        START_CUT_SCENE()
        ResetMarioControls()
        manny:ignore_boxes()
        manny:setpos(-2.6008, 1.93349, 10.6008)
        manny:setrot(0, 229.159, 0)
        nl:current_setup(nl_legla)
        SetAmbientLight(1)
        sleep_for(300)
        manny:say_line("/nlma015/")
        wait_for_message()
        manny:say_line("/nlma016/")
        wait_for_message()
        SetAmbientLight(0)
        nl:current_setup(nl_hdnws)
        manny:setpos(-3.69755, 3.17402, 3.71)
        manny:setrot(0, 108.567, 0)
        manny:follow_boxes()
        END_CUT_SCENE()
        nl:current_setup(nl_hndws)
    else
        start_script(nl.cowabunga)
    end
end
nl.window1 = Object:create(nl, "/nltx017/window", -0.132181, 0.529369, 0.43000001, { range = 0.60000002 })
nl.window1.use_pnt_x = 0.157819
nl.window1.use_pnt_y = 0.56936902
nl.window1.use_pnt_z = -0.02
nl.window1.use_rot_x = 0
nl.window1.use_rot_y = 66.351501
nl.window1.use_rot_z = 0
nl.window1.lookAt = function(arg1) -- line 311
    manny:say_line("/nlma018/")
end
nl.window1.use = function(arg1) -- line 315
    manny:say_line("/nlma019/")
end
nl.sign = Object:create(nl, "/nltx020/sign", -4.2684898, 2.27632, 9.79, { range = 0.60000002 })
nl.sign.use_pnt_x = -4.8284898
nl.sign.use_pnt_y = 4.9663301
nl.sign.use_pnt_z = 3.71
nl.sign.use_rot_x = 0
nl.sign.use_rot_y = 169.44901
nl.sign.use_rot_z = 0
nl.sign.lookAt = function(arg1) -- line 327
    if not nl.sign_down then
        manny:say_line("/nlma021/")
    else
        manny:say_line("/nlma022/")
    end
end
nl.sign.pickUp = function(arg1) -- line 335
    system.default_response("bolted")
end
nl.sign.use = function(arg1) -- line 339
    start_script(Sentence, "use", nl.sign_ladder)
end
nl.climbup_box = { name = "climb up" }
nl.climbup_box.walkOut = function(arg1) -- line 351
    if not nl.sign_down then
        nl:jump_on_ledge()
    end
end
nl.climbdown_box = { name = "climb down" }
nl.climbdown_box.walkOut = function(arg1) -- line 358
    nl:jump_off_ledge()
end

CheckFirstTime("sp.lua")
sp = Set:create("sp.set", "spiderweb", { sp_webws = 0, sp_entla = 1, sp_top = 2 })
dofile("spiders.lua")
dofile("ma_scythe_web.lua")
dofile("sp_web.lua")
dofile("ma_throw_bone.lua")
sp.NUMBER_OF_SPIDERS = 6
sp.heartbeat_vol_close = 127
sp.heartbeat_vol_medium = 25
sp.heartbeat_vol_far = 15
shazam = function(arg1) -- line 23
    manny:set_costume(nil)
    manny:set_costume("sp_idles.cos")
    manny:set_walk_chore(sp_idles_walk_cycle)
    manny:set_turn_chores(nil, nil)
    manny:set_rest_chore(sp_idles_idle)
    if not arg1 then
        ActorPuckOrient(manny.hActor, TRUE)
    else
        ActorPuckOrient(manny.hActor, FALSE)
    end
    manny.running_chore = sp_idles_walk_cycle
    manny.costume_state = "spider"
end
newbug = function() -- line 38
    if not tbug then
        tbug = Actor:create()
    end
    tbug:set_costume(nil)
    tbug:put_in_set(system.currentSet)
    tbug:set_costume("sp_idles.cos")
    tbug:set_walk_chore(sp_idles_walk_cycle)
    tbug:set_turn_chores(nil, nil)
    tbug:set_rest_chore(sp_idles_idle)
    ActorPuckOrient(tbug.hActor, TRUE)
    tbug.running_chore = sp_idles_walk_cycle
    tbug.costume_state = "spider"
    tbug:put_at_interest()
    if not spotfinder_active then
        toggle_spotfinder()
    end
    spotfinder:put_at_interest()
    spotfinder.pos = tbug:getpos()
    spotfinder.attached_actor = tbug
end
sp.turn_spider = function(arg1, arg2, arg3, arg4) -- line 56
    while 1 do
        TurnActorTo(arg1.hActor, arg2, arg3, arg4)
        break_here()
    end
end
sp.reverse_spider = function(arg1) -- line 63
    arg1:set_walk_rate(-0.2)
    while 1 do
        WalkActorForward(arg1.hActor)
        break_here()
    end
end
sp.intro = function() -- line 71
    START_CUT_SCENE()
    box_on("intro_box")
    sp.seen_intro = TRUE
    sp:current_setup(sp_entla)
    manny:setpos(-5.4008002, 6.66644, 0)
    manny:setrot(0, 160.00301, 0)
    local local1 = Actor:create(nil, nil, nil, "bug1")
    local1:set_costume("sp_idles.cos")
    local1:set_walk_rate(0.40000001)
    local1:set_turn_rate(160)
    ActorPuckOrient(local1.hActor, TRUE)
    local1:set_walk_chore(nil)
    local1:set_turn_chores(nil, nil)
    local1:set_rest_chore(nil)
    local1:play_chore_looping(sp_idles_leg_cycle)
    local1:setpos(0.053610999, -0.35915199, 0.073643699)
    local1:setrot(46.889, 107.174, 297.168)
    local1:put_in_set(sp)
    local1:follow_boxes()
    break_here()
    local1:setrot(46.889, 107.174, 297.168)
    local1:wait_for_actor()
    manny:walkto(-5.5293298, 5.3671699, 0, 0, 224.472, 0)
    manny:wait_for_actor()
    manny:say_line("/lwma016/")
    wait_for_message()
    local1:stop_chore(sp_idles_leg_cycle)
    local1:play_chore_looping(sp_idles_walk_cycle)
    local1:wait_for_actor()
    local1:setrot(46.889, 107.174, 297.168)
    local1:walkto(-0.14880399, -0.442743, 0.247565, 46.889, 107.174, 297.168)
    local1:wait_for_actor()
    local1:stop_chore(sp_idles_walk_cycle)
    local1:run_chore(sp_idles_leg_enter)
    local1:play_chore_looping(sp_idles_leg_cycle)
    manny:wait_for_message()
    manny:say_line("/slma058/")
    manny:wait_for_message()
    sleep_for(500)
    manny:say_line("/rfma029/")
    start_script(manny.runto, manny, -3.5230601, 3.3424799, 0)
    local1:stop_chore(sp_idles_leg_cycle)
    local1:run_chore(sp_idles_leg_exit)
    local1:play_chore_looping(sp_idles_walk_cycle)
    start_script(sp.reverse_spider, local1)
    sleep_for(500)
    stop_script(sp.reverse_spider, local1)
    local1:set_walk_rate(0.5)
    start_script(sp.turn_spider, local1, -0.074399903, -0.1399, 0.83999902)
    sleep_for(1000)
    stop_script(sp.turn_spider)
    local1:walkto(-0.074399903, -0.1399, 0.83999902)
    local1:wait_for_actor()
    sleep_for(500)
    local1:free()
    box_off("intro_box")
    manny:set_run(FALSE)
    END_CUT_SCENE()
end
sp.watch_manny = function() -- line 155
    while 1 do
        if manny:find_sector_name("sp_cheat_box2") then
            system:lock_display()
            manny:setpos(-0.981346, -0.461838, 0)
            break_here()
            system:unlock_display()
        elseif manny:find_sector_name("sp_cheat_box1") then
            system:lock_display()
            manny:setpos(-3.48742, 1.94589, 0)
            break_here()
            system:unlock_display()
        end
        break_here()
    end
end
sp.hide_spiders = function() -- line 174
    local local1
    while 1 do
        if sp:current_setup() == sp_entla then
            local1 = 1
            repeat
                spider_actors[local1]:set_visibility(FALSE)
                local1 = local1 + 1
            until local1 > sp.NUMBER_OF_SPIDERS
            repeat
                break_here()
            until sp:current_setup() ~= sp_entla
            local1 = 1
            repeat
                spider_actors[local1]:set_visibility(TRUE)
                local1 = local1 + 1
            until local1 > sp.NUMBER_OF_SPIDERS
        end
        break_here()
    end
end
sp.set_up_actors = function() -- line 198
    spiders.init_spiders(sp.NUMBER_OF_SPIDERS)
end
sp.pull_heart = function() -- line 202
    START_CUT_SCENE()
    manny:set_rest_chore(nil)
    manny:stop_chore(ma_rest, "ma.cos")
    manny:walkto(-0.285213, -0.552777, 0, 0, 53.099, 0)
    manny:wait_for_actor()
    manny:push_costume("ma_pull_heart.cos")
    manny:play_chore(0, "ma_pull_heart.cos")
    if sp.web.has_bone then
        manny:play_chore(1, "ma_pull_heart.cos")
    end
    sleep_for(975)
    sp.heart_actor:set_visibility(FALSE)
    if sp.web.has_bone then
        sp.bone_actor:set_visibility(FALSE)
    end
    sleep_for(1000)
    manny:say_line("/spma011/")
    sleep_for(500)
    sp.heart_actor:set_visibility(TRUE)
    if sp.web.has_bone then
        sp.bone_actor:set_visibility(TRUE)
    end
    sleep_for(200)
    sp.web:complete_chore(sp_web_no_web)
    sp.web:play_chore(sp_web_web)
    ForceRefresh()
    manny:wait_for_chore(0, "ma_pull_heart.cos")
    manny:stop_chore(0, "ma_pull_heart.cos")
    manny:default("action")
    END_CUT_SCENE()
end
sp.slice_web = function() -- line 239
    local local1
    START_CUT_SCENE("no head")
    manny:walkto_object(sp.web)
    manny:push_costume("ma_scythe_web.cos")
    manny:stop_chore(ma_hold_scythe, "ma.cos")
    manny:play_chore(ma_scythe_web_cut_web, "ma_scythe_web.cos")
    sleep_for(670)
    sp.web:play_chore(sp_web_cut_web)
    start_sfx("spWebSlc.wav")
    manny:wait_for_chore()
    manny:pop_costume()
    manny:play_chore_looping(ma_hold_scythe, "ma.cos")
    start_script(manny.clear_hands, manny)
    manny:say_line("/jbma038/")
    sleep_for(1400)
    local1 = start_script(spiders.uber_spider, spiders)
    sleep_for(2000)
    manny.head_script = start_script(manny.head_follow_mesh, manny, sp.uber_spider, 1)
    manny:setrot(0, 94.519402, 0, TRUE)
    sleep_for(1000)
    manny:say_line("/spma020/")
    sleep_for(500)
    manny:setrot(0, 100, 0)
    manny:backup(2000)
    wait_for_script(local1)
    sleep_for(500)
    manny:kill_head_script()
    system.default_response("no work")
    manny:twist_head_gesture()
    END_CUT_SCENE()
end
sp.throw_bone = function(arg1) -- line 275
    sp.web.has_bone = TRUE
    arg1:free()
    arg1.owner = sp.bone_pile
    START_CUT_SCENE()
    manny:walkto(0.33919, -0.6035, 0, 0, 54.523, 0)
    manny:wait_for_actor()
    manny:stop_chore(manny.hold_chore, manny.base_costume)
    manny:stop_chore(ms_hold, manny.base_costume)
    manny.is_holding = nil
    manny:push_costume("ma_throw_bone.cos")
    manny:play_chore(ma_throw_bone_bone_throw)
    manny:say_line("/spma008/")
    manny:wait_for_chore(ma_throw_bone_bone_throw, "ma_throw_bone.cos")
    manny:pop_costume()
    if not sp.bone_actor then
        sp.bone_actor = Actor:create(nil, nil, nil, "bone")
    end
    sp.bone_actor:put_in_set(sp)
    sp.bone_actor:set_costume("bone.cos")
    sp.bone_actor:setpos(-0.24901, -0.248, 0.4609)
    sp.bone_actor:setrot(0, 30, 104)
    set_override(sp.skip_bone)
    manny:turn_left(180)
    manny:head_look_at(spider_actors[1])
    manny:wait_for_actor()
    manny:say_line("/mgma043/")
    manny:wait_for_message()
    manny:head_look_at(spider_actors[3])
    manny:say_line("/spma018/")
    manny:wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
sp.skip_bone = function() -- line 314
    kill_override()
    manny:head_look_at(nil)
end
sp.test = function() -- line 319
    sp.freed_heart = FALSE
    manny.is_holding = mo.scythe
    manny:play_chore(ma_hold_scythe, "ma.cos")
    manny:put_at_object(sp.web)
    sp.web.has_bone = TRUE
    sp.web.contains = sp.heart
    if not sp.bone_actor then
        sp.bone_actor = Actor:create(nil, nil, nil, "bone")
    end
    sp.bone_actor:put_in_set(sp)
    sp.bone_actor:set_costume("bone.cos")
    sp.bone_actor:setpos(-0.24901, -0.248, 0.4609)
    sp.bone_actor:setrot(0, 30, 104)
    sp.heart_actor:set_costume("sp_glottis_heart.cos")
    sp.heart_actor:put_in_set(sp)
    sp.heart_actor:setpos({ x = -0.39533, y = -0.30642, z = 0.373 })
    sp.heart_actor:setrot(0, 180, 0)
    sp.heart_actor:play_chore_looping(0, "sp_glottis_heart.cos")
    start_sfx("glHrtBt.imu", IM_HIGH_PRIORITY, sp.heartbeat_vol)
    preload_sfx("sgHrtLnd.wav")
end
sp.evacuate_spiders = function() -- line 342
    local local1, local2
    if spider_actors[4] then
        spider_actors[4]:set_walk_rate(0.60000002)
        spider_actors[4]:walkto(-1.40558, -0.80676198, 0.029999999)
    end
    if spider_actors[5] and spider_actors[6] then
        local1 = spider_actors[5]:getpos()
        local2 = spider_actors[6]:getpos()
        while local1.z < 3.5 and system.currentSet == sp do
            spider_actors[5]:setpos(local1.x, local1.y, local1.z + 0.02)
            spider_actors[6]:setpos(local2.x, local2.y, local2.z + 0.02)
            sleep_for(66)
            local1 = spider_actors[5]:getpos()
            local2 = spider_actors[6]:getpos()
        end
    end
end
sp.manny_hook_n_fling_web = function() -- line 366
    START_CUT_SCENE()
    sp.tree_mask:play_chore(0)
    start_script(sp.evacuate_spiders)
    SetObjectType(sp.web.bone_hObject_state, OBJSTATE_OVERLAY, TRUE)
    manny:walkto_object(sp.web)
    manny:wait_for_actor()
    manny:stop_chore(ma_hold_scythe, "ma.cos")
    manny:push_costume("ma_scythe_web.cos")
    manny:play_chore(ma_scythe_web_hook_n_fling, "ma_scythe_web.cos")
    kill_heart_n_bone = nil
    music_state:set_sequence(seqSlingshotBone)
    repeat
        break_here()
    until kill_heart_n_bone
    sp.heart_actor:free()
    sp.bone_actor:free()
    sleep_for(2204)
    start_sfx("spWebSnp.wav")
    sleep_for(400)
    stop_sound("glHrtBt.imu")
    sleep_for(200)
    start_sfx("spWbShot.wav")
    sleep_for(200)
    sp.web:complete_chore(sp_web_no_web)
    sp.web:complete_chore(sp_web_web)
    ForceRefresh()
    manny:wait_for_chore(ma_scythe_web_hook_n_fling, "ma_scythe_web.cos")
    manny:stop_chore(ma_scythe_web_hook_n_fling, "ma_scythe_web.cos")
    manny:pop_costume()
    manny:head_look_at_point({ x = -2.20033, y = 0.64458, z = 1.024 })
    manny:play_chore_looping(ma_hold_scythe, "ma.cos")
    MakeSectorActive("cheater_sector", TRUE)
    manny:setpos(0.25247, -0.96592, 0)
    manny:walkto_object(sp.web)
    start_sfx("sgHrtLnd.wav")
    set_pan("sgHrtLnd.wav", 1)
    manny:wait_for_actor()
    sp.tree_mask:play_chore(1)
    wait_for_sound("sgHrtLnd.wav")
    manny:head_look_at(spider_actors[1])
    manny:turn_left(180)
    start_script(manny.clear_hands, manny)
    manny:say_line("/spma005/")
    sleep_for(2000)
    manny:head_look_at(spider_actors[3])
    manny:wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
    box_off("cheater_sector")
    sp.web.contains = nil
    sp.freed_heart = TRUE
    sg.heart:make_touchable()
end
sp.enter = function(arg1) -- line 467
    if not sp.freed_heart then
        sp.web.contains = sp.heart
        glottis.heartless = TRUE
        sp:add_object_state(sp.webws, "sp_tree_mask.bm", "sp_tree_mask.zbm", OBJSTATE_STATE, TRUE)
        sp.tree_mask:set_object_state("sp_tree_mask.cos")
    end
    sp.set_up_actors()
    MakeSectorActive("cheater_sector", FALSE)
    NewObjectState(sp_webws, OBJSTATE_STATE, "sp_web_cut.bm")
    sp:add_object_state(sp_webws, "sp_web_1.bm", "sp_web_1.zbm", OBJSTATE_STATE, FALSE)
    sp:add_object_state(sp_webws, "sp_web_pull.bm", "sp_web_pull.zbm", OBJSTATE_STATE, FALSE)
    sp:add_object_state(sp_webws, "sp_web_snap.bm", nil, OBJSTATE_OVERLAY, TRUE)
    local local1 = sp:add_object_state(sp_webws, "sp_web_rest.bm", nil, OBJSTATE_OVERLAY, FALSE)
    SendObjectToFront(local1)
    sp.web.bone_hObject_state = sp:add_object_state(sp_webws, "sp_bone.bm", nil, OBJSTATE_UNDERLAY, TRUE)
    SendObjectToFront(sp.web.bone_hObject_state)
    sp.web:set_object_state("sp_web.cos")
    sp.web:play_chore(0)
    if not sp.heart_actor then
        sp.heart_actor = Actor:create(nil, nil, nil, "heart")
    end
    if sp.web.contains == sp.heart then
        sp.heart_actor:set_costume("sp_glottis_heart.cos")
        sp.heart_actor:put_in_set(sp)
        sp.heart_actor:setpos({ x = -0.39533001, y = -0.30642, z = 0.373 })
        sp.heart_actor:setrot(0, 180, 0)
        sp.heart_actor:play_chore_looping(0, "sp_glottis_heart.cos")
        start_sfx("glHrtBt.imu", IM_HIGH_PRIORITY, sp.heartbeat_vol)
        preload_sfx("sgHrtLnd.wav")
    end
    if sp.web.has_bone then
        if not sp.bone_actor then
            sp.bone_actor = Actor:create(nil, nil, nil, "bone")
        end
        sp.bone_actor:put_in_set(sp)
        sp.bone_actor:set_costume("bone.cos")
        sp.bone_actor:setpos(-0.24901, -0.248, 0.46090001)
        sp.bone_actor:setrot(0, 30, 104)
    end
    preload_sfx("spWbStr1.wav")
    preload_sfx("spWbStr2.wav")
    preload_sfx("spWbShot.wav")
    preload_sfx("spSktr1.wav")
    preload_sfx("spSktr2.wav")
    preload_sfx("spHop1.wav")
    preload_sfx("spHop2.wav")
    preload_sfx("spHop3.wav")
    preload_sfx("spFlap1.wav")
    preload_sfx("spFlap2.wav")
    preload_sfx("spFlap3.wav")
    preload_sfx("spFlap4.wav")
    preload_sfx("spFlap5.wav")
    start_script(sp.hide_spiders)
    start_script(sp.watch_manny)
    sp:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
    sp:camerachange(nil, sp:current_setup())
    if sp.intro_flag then
        sp.intro_flag = FALSE
        start_script(sp.intro)
    end
    sp.heart:make_untouchable()
    sp.bone_in_web:make_untouchable()
end
sp.update_music_state = function(arg1, arg2) -- line 545
    if not arg2 then
        arg2 = sp:current_setup()
    end
    if arg2 == sp_entla then
        return stateSP_ENTLA
    else
        return stateSP_WEBWS
    end
end
sp.camerachange = function(arg1, arg2, arg3) -- line 557
    music_state:set_state(sp:update_music_state(arg3))
    if sound_playing("glHrtBt.imu") then
        if arg3 == sp_entla then
            set_vol("glHrtBt.imu", sp.heartbeat_vol_close)
        else
            set_vol("glHrtBt.imu", sp.heartbeat_vol_medium)
        end
    end
end
sp.exit = function(arg1) -- line 571
    stop_script(spiders.spider_ganglia)
    stop_script(spiders.prop_spider_ganglia)
    stop_script(sp.hide_spiders)
    stop_script(sp.watch_manny)
    stop_script(sp.spider_leg)
    stop_script(sp.spider_walk)
    stop_script(sp.spider_wing)
    local local1 = 1
    repeat
        spider_actors[local1]:free()
        local1 = local1 + 1
    until local1 > sp.NUMBER_OF_SPIDERS
    if sp.bone_actor then
        sp.bone_actor:free()
    end
    if sp.heart_actor then
        sp.heart_actor:free()
    end
    sp.web:free_object_state()
    stop_sound("glHrtBt.imu")
end
sp.tree_mask = Object:create(sp, "", 0, 0, 0, { range = 1.5 })
sp.tree_mask:make_untouchable()
sp.web = Object:create(sp, "/sptx001/web", -0.3926, -0.3906, 0.33000001, { range = 1.5 })
sp.web.use_pnt_x = 0.05367
sp.web.use_pnt_y = -0.63642001
sp.web.use_pnt_z = 0
sp.web.use_rot_x = 0
sp.web.use_rot_y = 52.459999
sp.web.use_rot_z = 0
sp.web.lookAt = function(arg1) -- line 618
    if not sp.freed_heart then
        manny:say_line("/spma002/")
        if arg1.has_bone then
            soft_script()
            wait_for_message()
            manny:say_line("/spma003/")
        end
    else
        manny:say_line("/spma004/")
    end
end
sp.web.use = function(arg1) -- line 631
    if not sp.freed_heart then
        start_script(sp.pull_heart)
    else
        manny:say_line("/spma006/")
    end
end
sp.web.pickUp = sp.web.use
sp.web.use_bone = function(arg1, arg2) -- line 641
    if not sp.freed_heart then
        if arg1.has_bone then
            manny:say_line("/spma007/")
        else
            start_script(sp.throw_bone, arg2)
        end
    else
        manny:say_line("/voma015/")
    end
end
sp.web.use_scythe = function(arg1) -- line 653
    if not sp.freed_heart then
        if arg1.has_bone then
            start_script(sp.manny_hook_n_fling_web)
        elseif not arg1.sliced then
            arg1.sliced = TRUE
            start_script(sp.slice_web)
        else
            system.default_response("already")
        end
    else
        manny:say_line("/voma015/")
    end
end
sp.heart = Object:create(sp, "/sptx009/heart", -0.1926, -0.22059999, 0.31999999, { range = 0.69999999 })
sp.heart.use_pnt_x = -0.050000001
sp.heart.use_pnt_y = -0.40599999
sp.heart.use_pnt_z = 0
sp.heart.use_rot_x = 0
sp.heart.use_rot_y = 51.57
sp.heart.use_rot_z = 0
sp.heart:make_untouchable()
sp.bone_pile = Object:create(sp, "/sptx012/pile of bones", 0.50739998, -0.3906, 0.0099999998, { range = 0.5 })
sp.bone_pile.use_pnt_x = 0.24061
sp.bone_pile.use_pnt_y = -0.56109798
sp.bone_pile.use_pnt_z = 0
sp.bone_pile.use_rot_x = 0
sp.bone_pile.use_rot_y = 309.198
sp.bone_pile.use_rot_z = 0
sp.bone_pile.lookAt = function(arg1) -- line 716
    manny:say_line("/spma013/")
end
sp.bone_pile.pickUp = function(arg1) -- line 720
    local local1
    if manny:walkto_object(arg1) then
        local1 = alloc_object_from_table(sp.bones)
        if local1 then
            START_CUT_SCENE()
            preload_sfx("getBone.wav")
            if not sp.said_spare then
                sp.said_spare = TRUE
                manny:say_line("/spma014/")
            end
            manny:wait_for_actor()
            manny:play_chore(ma_reach_low, "ma.cos")
            sleep_for(864)
            start_sfx("getBone.wav")
            local1:get()
            local1.wav = "getBone.wav"
            manny.is_holding = local1
            manny:play_chore_looping(ma_hold, "ma.cos")
            manny:play_chore_looping(ma_activate_bone, "ma.cos")
            manny.hold_chore = ma_activate_bone
            manny:wait_for_chore(ma_reach_low, "ma.cos")
            manny:stop_chore(ma_reach_low, "ma.cos")
            END_CUT_SCENE()
        else
            manny:say_line("/spma015/")
        end
    end
end
sp.bone_pile.use = sp.bone_pile.pickUp
sp.bone_pile.use_bone = function(arg1, arg2) -- line 753
    PrintDebug("Freeing bone" .. arg2.name .. "\n")
    arg2:free()
    arg2.owner = sp.bone_pile
    START_CUT_SCENE()
    if not sp.said_drop then
        sp.said_drop = TRUE
        manny:say_line("/spma016/")
    end
    preload_sfx("getBone.wav")
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(ma_reach_low, "ma.cos")
    sleep_for(864)
    start_sfx("getBone.wav")
    manny.is_holding = nil
    manny:stop_chore(ma_hold, "ma.cos")
    manny:stop_chore(ma_activate_bone, "ma.cos")
    manny.hold_chore = nil
    manny:wait_for_chore(ma_reach_low, "ma.cos")
    manny:stop_chore(ma_reach_low, "ma.cos")
    END_CUT_SCENE()
end
sp.bone_in_web = Object:create(sp, "/sptx017/bone", -0.24433, -0.22341999, 0.45199999, { range = 0.5 })
sp.bone_in_web.use_pnt_x = -0.041000001
sp.bone_in_web.use_pnt_y = -0.39899999
sp.bone_in_web.use_pnt_z = 0
sp.bone_in_web.use_rot_x = 0
sp.bone_in_web.use_rot_y = 33.615002
sp.bone_in_web.use_rot_z = 0
sp.bone_in_web:make_untouchable()
sp.bones = { }
sp.bones.bone1 = Object:create(sp, "/sptx021/bone1", 0, 0, 0, { range = 0 })
sp.bones.bone1.string_name = "bone"
sp.bones.bone1.owner = sp.bone_pile
sp.bones.bone1.wav = "getBone.wav"
sp.bones.bone1.lookAt = function(arg1) -- line 814
    manny:say_line("/spma022/")
end
sp.bones.bone1.use = function(arg1) -- line 817
    manny:say_line("/spma023/")
end
sp.bones.bone1.default_response = function(arg1) -- line 821
    manny:say_line("/spma024/")
end
sp.bones.bone2 = Object:create(sp, "/sptx025/bone2", 0, 0, 0, { range = 0 })
sp.bones.bone2.parent = sp.bones.bone1
sp.bones.bone2.owner = sp.bone_pile
sp.bones.bone2.string_name = "bone"
sp.bones.bone2.wav = "getBone.wav"
sp.bones.bone3 = Object:create(sp, "/sptx026/bone3", 0, 0, 0, { range = 0 })
sp.bones.bone3.parent = sp.bones.bone1
sp.bones.bone3.owner = sp.bone_pile
sp.bones.bone3.string_name = "bone"
sp.bones.bone3.wav = "getBone.wav"
sp.bones.bone4 = Object:create(sp, "/sptx027/bone4", 0, 0, 0, { range = 0 })
sp.bones.bone4.parent = sp.bones.bone1
sp.bones.bone4.owner = sp.bone_pile
sp.bones.bone4.string_name = "bone"
sp.bones.bone4.wav = "getBone.wav"
sp.bones.bone5 = Object:create(sp, "/sptx028/bone5", 0, 0, 0, { range = 0 })
sp.bones.bone5.parent = sp.bones.bone1
sp.bones.bone5.owner = sp.bone_pile
sp.bones.bone5.string_name = "bone"
sp.bones.bone5.wav = "getBone.wav"
sp.pbo = function() -- line 849
    local local1, local2 = next(sp.bones, nil)
    while local2 do
        sp.obo(local2)
        local1, local2 = next(sp.bones, local1)
    end
end
sp.obo = function(arg1) -- line 858
    if arg1.owner == manny then
        PrintDebug(arg1.name .. ".owner = Manny\n")
    elseif arg1.owner == IN_THE_ROOM then
        PrintDebug(arg1.name .. ".owner = IN_THE_ROOM\n")
    elseif arg1.owner == IN_LIMBO then
        PrintDebug(arg1.name .. ".owner = IN_LIMBO\n")
    elseif arg1.owner == nil then
        PrintDebug(arg1.name .. ".owner = nil\n")
    else
        PrintDebug(arg1.name .. ".owner = " .. tostring(arg1.owner) .. "\n")
    end
end
sp.sg_door = Object:create(sp, "/sptx029/door", -0.86260003, -0.4806, 0, { range = 0 })
sp.sg_box = sp.sg_door
sp.sg_door.use_pnt_x = -5.2046399
sp.sg_door.use_pnt_y = 5.14048
sp.sg_door.use_pnt_z = 0
sp.sg_door.use_rot_x = 0
sp.sg_door.use_rot_y = 5
sp.sg_door.use_rot_z = 0
sp.sg_door.out_pnt_x = -5.4932098
sp.sg_door.out_pnt_y = 6.4337502
sp.sg_door.out_pnt_z = 0
sp.sg_door.out_rot_x = 0
sp.sg_door.out_rot_y = 0
sp.sg_door.out_rot_z = 0
sp.sg_door.walkOut = function(arg1) -- line 896
    sg:come_out_door(sg.sp_door)
    sg:current_setup(sg_spdws)
end

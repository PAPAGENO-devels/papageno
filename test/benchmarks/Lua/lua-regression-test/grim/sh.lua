CheckFirstTime("sh.lua")
dofile("msb_ladder_generic.lua")
sh = Set:create("sh.set", "sewer hub", { sh_intws = 0, sh_ovrhd = 1 })
sewer_drip = function() -- line 14
    local local1
    while 1 do
        sleep_for(rnd(10000, 25000))
        local1 = pick_one_of({ "swrDrop1.wav", "swrDrop2.wav", "swrDrop3.wav", "swrDrop4.wav" })
        start_sfx(local1, IM_LOW_PRIORITY)
    end
end
sh.glottis_bounce = function() -- line 35
    glottis_bounce_okay = TRUE
    while glottis_bounce_okay do
        sleep_for(500)
        start_sfx("bwRmClik.wav")
        start_sfx("bwShock.wav")
        glottis:play_chore(bonewagon_gl_shocks)
        glottis:wait_for_chore()
        sleep_for(500)
        start_sfx("bwRmClik.wav")
        start_sfx("bwShock.wav")
        glottis:play_chore(bonewagon_gl_down)
        glottis:wait_for_chore()
    end
end
sh.get_remote = function(arg1) -- line 51
    local local1 = start_script(sh.glottis_bounce)
    START_CUT_SCENE()
    if manny.is_holding then
        put_away_held_item()
    end
    manny:walkto(1.83951, -1.40749, 0, 0, 19.8526, 0)
    manny:wait_for_actor()
    glottis_bounce_okay = FALSE
    wait_for_script(local1)
    manny:say_line("/syma093/")
    manny:play_chore(msb_reach_high, manny.base_costume)
    sleep_for(700)
    start_sfx("slHndCse.wav")
    manny:wait_for_chore()
    manny:generic_pickup(sh.remote)
    END_CUT_SCENE()
    start_script(sg.glottis_roars, sg, glottis)
end
manny_grind = function() -- line 80
    local local1 = { x = 0, y = 0.42699999, z = 0 }
    local local2 = { }
    local local3 = { }
    local local4 = { }
    local local5 = 0.0099999998
    local local6 = 0
    local local7 = FALSE
    START_CUT_SCENE()
    if not grind_boy then
        grind_boy = Actor:create(nil, nil, nil, "grind boy")
    end
    local3 = manny:getrot()
    local4 = RotateVector(local1, local3)
    local2 = manny:getpos()
    local4.x = local4.x + local2.x
    local4.y = local4.y + local2.y
    local4.z = local4.z + local2.z
    grind_boy:put_in_set(system.currentSet)
    grind_boy:follow_boxes()
    grind_boy:setpos(local4)
    if manny.fancy then
        manny:stop_chore(mcc_thunder_hold, "mcc_thunder.cos")
        manny:stop_chore(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
        manny:play_chore_looping(mcc_thunder_hold_grinder, "mcc_thunder.cos")
        manny:play_chore_looping(mcc_thunder_use_grinder, "mcc_thunder.cos")
    else
        manny:stop_chore(msb_activate_grinder_full, "msb.cos")
        manny:play_chore_looping(msb_use_grinder, "msb.cos")
    end
    break_here()
    start_sfx("grinder.IMU")
    if grind_boy:find_sector_name("trail") or grind_boy:find_sector_name("find_zod") or grind_boy:find_sector_name("bowlsley_puddle") and not local7 then
        if grind_boy:find_sector_name("find_zod") then
            local7 = TRUE
        end
        trail_actor:set_costume("flower_trail.cos")
        trail_actor:put_in_set(system.currentSet)
        local2 = grind_boy:getpos()
        local2.z = local2.z + 0.025
        trail_actor:setpos(local2)
        trail_actor:play_chore(1)
        start_sfx("zw_trail.WAV")
        trail_actor:scale(local5)
        trail_actor:setrot(0, rnd(0, 360), 0)
        if system.currentSet == sh then
            repeat
                local5 = local5 + PerSecond(5)
                if local5 >= 3.5 then
                    local5 = 3.5
                end
                trail_actor:scale(local5)
                break_here()
            until local5 == 3.5
        else
            repeat
                local5 = local5 + PerSecond(5)
                if local5 >= 2.5 then
                    local5 = 2.5
                end
                trail_actor:scale(local5)
                break_here()
            until local5 == 2.5
        end
        trail_actor["i"] = trail_actor.i + 1
        if trail_actor.i == 100 then
            trail_actor["i"] = 1
        end
        if not trail_actor.instances[trail_actor.i] then
            trail_actor.instances[trail_actor.i] = { object = { }, actor = { }, set = { }, pos = { }, rot = { } }
        end
        trail_actor.instances[trail_actor.i].object = Object:create(system.currentSet, "trail" .. local6, local2.x, local2.y, local2.z, { range = 0.60000002 })
        trail_actor.instances[trail_actor.i].object.parent = sh.flower_trail_obj
        trail_actor.instances[trail_actor.i].actor = trail_actor.instances[trail_actor.i].object.interest_actor
        trail_actor.instances[trail_actor.i].set = system.currentSet
        trail_actor.instances[trail_actor.i].pos = trail_actor:getpos()
        trail_actor.instances[trail_actor.i].rot = trail_actor:getrot()
        if Is3DHardwareEnabled() then
            trail_actor.instances[trail_actor.i].actor:set_costume("flower_trail.cos")
            trail_actor.instances[trail_actor.i].actor:setrot(trail_actor.instances[trail_actor.i].rot)
            trail_actor.instances[trail_actor.i].actor:scale(2.5)
            trail_actor.instances[trail_actor.i].actor:play_chore(1)
            trail_actor.instances[trail_actor.i].actor:set_visibility(TRUE)
        else
            trail_actor:stamp()
        end
        local5 = 0.0099999998
        trail_actor:free()
        if manny.fancy then
            manny:set_chore_looping(mcc_thunder_use_grinder, FALSE)
        else
            manny:set_chore_looping(msb_use_grinder, FALSE)
        end
        if not exclaimed_tears then
            start_script(sh.exclaim_tears)
        end
    else
        sleep_for(1000)
    end
    fade_sfx("grinder.IMU", 400, 0)
    if manny.fancy then
        manny:stop_chore(mcc_thunder_hold_grinder, "mcc_thunder.cos")
        manny:stop_chore(mcc_thunder_use_grinder, "mcc_thunder.cos")
        manny:play_chore_looping(mcc_thunder_hold, "mcc_thunder.cos")
        manny:play_chore_looping(mcc_thunder_takeout_grinder_full, "mcc_thunder.cos")
    else
        manny:wait_for_chore(msb_use_grinder, "msb.cos")
        manny:stop_chore(msb_use_grinder, "msb.cos")
        manny:play_chore_looping(msb_activate_grinder_full, "msb.cos")
    end
    sleep_for(400)
    END_CUT_SCENE()
    if local7 and not manny.been_in_at then
        manny.been_in_at = TRUE
        start_script(cut_scene.albinizod)
    end
    grind_boy:free()
end
sh.mount_ladder = function(arg1) -- line 205
    START_CUT_SCENE()
    sh:switch_to_set()
    manny:put_in_set(sh)
    manny:setpos(-0.388315, 0.121017, 2.95)
    manny:setrot(0, 266.267, 0)
    if manny.is_holding then
        manny:clear_hands()
    end
    manny:walkto(0.263604, 0.0531176, 2.95, 0, 254.052, 0)
    manny:wait_for_actor()
    manny:walkto(0.495525, 0.035114, 2.95, 0, 90, 0)
    manny:wait_for_actor()
    manny:start_climb_ladder(sh.te_ladder)
    manny:play_chore(msb_ladder_generic_mount_ladder)
    manny:wait_for_chore(msb_ladder_generic_mount_ladder)
    manny:stop_chore(msb_ladder_generic_mount_ladder)
    manny:setpos(0.606632, -0.0489547, 2.356)
    manny:setrot(0, 90, 0)
    manny:climb_down()
    END_CUT_SCENE()
end
sh.unmount_ladder = function(arg1) -- line 231
    START_CUT_SCENE()
    stop_script(manny.climb_up)
    stop_script(manny.climb_down)
    stop_script(climb_actor_up)
    stop_script(climb_actor_down)
    manny:stop_chore(ma_ladder_generic_climb1)
    manny:stop_chore(ma_ladder_generic_climb2)
    manny:stop_chore(ma_ladder_generic_climb_down1)
    manny:stop_chore(ma_ladder_generic_climb_down2)
    manny:setpos(0.495525, 0.035114, 2.95)
    manny:setrot(0, 90, 0)
    manny:play_chore(msb_ladder_generic_unmount_ladder)
    manny:wait_for_chore(msb_ladder_generic_unmount_ladder)
    manny:setpos(0.495525, 0.035114, 2.95)
    manny:stop_climb_ladder()
    manny:walkto(-0.360079, -0.0644043, 2.95, 0, 84.0209, 0)
    te:come_out_door(te.sh_door)
    END_CUT_SCENE()
end
sh.exclaim_tears = function() -- line 256
    local local1
    START_CUT_SCENE()
    exclaimed_tears = TRUE
    music_state:set_sequence(seqSproutAha)
    manny:say_line("/syma159/")
    manny:wait_for_message()
    if system.currentSet == sh then
        manny:walkto(2.99928, -0.492008, 0, 0, 66.599998, 0)
        manny:wait_for_actor()
        local local2 = start_script(manny_grind)
        wait_for_script(local2)
        manny:walkto(3.2314, -0.492008, 0, 0, 66.599998, 0)
        manny:wait_for_actor()
        local local3 = start_script(manny_grind)
        wait_for_script(local3)
        manny:walkto(3.55, -0.492008, 0, 0, 66.599998, 0)
        manny:wait_for_actor()
        local local4 = start_script(manny_grind)
        wait_for_script(local4)
    end
    manny:say_line("/shma015/")
    wait_for_message()
    manny:say_line("/shma016/")
    wait_for_message()
    END_CUT_SCENE()
end
sh.set_up_flowers = function(arg1) -- line 291
    local local1 = 1
    local local2 = { }
    system:lock_display()
    break_here()
    if trail_actor.i > 0 then
        repeat
            if trail_actor.instances[local1].set == system.currentSet then
                trail_actor.instances[local1].object:make_touchable()
                trail_actor.instances[local1].actor:set_costume("flower_trail.cos")
                trail_actor.instances[local1].actor:put_in_set(system.currentSet)
                trail_actor.instances[local1].actor:setpos(trail_actor.instances[local1].pos)
                trail_actor.instances[local1].actor:setrot(trail_actor.instances[local1].rot)
                if system.currentSet == sh then
                    trail_actor.instances[local1].actor:scale(3.5)
                else
                    trail_actor.instances[local1].actor:scale(2.5)
                end
                trail_actor.instances[local1].actor:play_chore(1)
                trail_actor.instances[local1].actor:set_visibility(TRUE)
                if not Is3DHardwareEnabled() then
                    break_here()
                    trail_actor.instances[local1].actor:stamp()
                    trail_actor.instances[local1].actor:set_costume(nil)
                end
            end
            local1 = local1 + 1
        until local1 > trail_actor.i
    end
    system:unlock_display()
end
sh.set_up_actors = function(arg1) -- line 323
    if bowlsley_in_hiding and not glottis.in_at then
        MakeSectorActive("glottis_here", TRUE)
        MakeSectorActive("glottis_gone", FALSE)
        glottis:set_costume("bonewagon_gl.cos")
        glottis:put_in_set(sh)
        glottis:ignore_boxes()
        glottis:setpos(2.04434, -0.128071, 0)
        glottis:setrot(0, -191.033, 0)
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
        glottis:play_chore(bonewagon_gl_drive)
        if sh.remote.raised then
            glottis:complete_chore(bonewagon_gl_stay_up)
        end
        glottis:set_collision_mode(COLLISION_OFF)
    else
        MakeSectorActive("glottis_here", FALSE)
        MakeSectorActive("glottis_gone", TRUE)
    end
    if not trail_actor then
        trail_actor = Actor:create(nil, nil, nil, "trail")
        trail_actor["i"] = 0
        trail_actor.instances = { }
    end
end
sh.crush_manny = function() -- line 365
    START_CUT_SCENE()
    stop_script(sg.glottis_roars)
    glottis:play_chore(bonewagon_gl_down)
    sleep_for(250)
    start_sfx("atBWlnd.wav")
    manny:say_line("/bdma006B/")
    glottis:wait_for_chore()
    manny:wait_for_message()
    glottis:wait_for_message()
    start_sfx("bwShock.wav")
    glottis:play_chore(bonewagon_gl_shocks)
    glottis:wait_for_chore()
    glottis:say_line("/sugl165/")
    glottis:wait_for_message()
    start_script(sg.glottis_roars, sg, glottis)
    END_CUT_SCENE()
end
sh.enter = function(arg1) -- line 384
    NewObjectState(sh_intws, OBJSTATE_UNDERLAY, "sh_0_nopuddle.bm")
    sh.zw_door:set_object_state("sh_puddle.cos")
    sh:set_up_actors()
    start_script(sewer_drip)
    if bowlsley_in_hiding then
        sh.puddle:make_touchable()
        sh.zw_door:play_chore(1)
    else
        sh.zw_door:play_chore(0)
    end
    if trail_actor then
        start_script(sh.set_up_flowers)
    end
    if sh.remote.owner == manny and not glottis.in_at and not find_script(fi.happy_bowlsley) then
        single_start_script(sg.glottis_roars, sg, glottis)
    elseif bowlsley_in_hiding and not sh.stolen_remote then
        sh.stolen_remote = TRUE
        start_script(sh.get_remote)
    end
    if bowlsley_in_hiding and not glottis.in_at then
        sh.glottis_obj:make_touchable()
    else
        sh.glottis_obj:make_untouchable()
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 2.6, -0.5, 2.6)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    MakeSectorActive("bw_up1", FALSE)
    MakeSectorActive("bw_up2", FALSE)
    MakeSectorActive("bw_up3", FALSE)
end
sh.exit = function(arg1) -- line 426
    local local1 = 1
    stop_script(sg.glottis_roars)
    stop_script(sewer_drip)
    glottis:free()
    if trail_actor.i > 0 then
        repeat
            trail_actor.instances[local1].actor:free()
            local1 = local1 + 1
        until local1 > trail_actor.i
    end
    trail_actor:free()
    KillActorShadows(manny.hActor)
end
sh.glottis_obj = Object:create(sh, "glottis", 1.93088, -0.87330699, 1.012, { range = 2.5 })
sh.glottis_obj.use_pnt_x = 2.0242801
sh.glottis_obj.use_pnt_y = -1.17633
sh.glottis_obj.use_pnt_z = 0
sh.glottis_obj.use_rot_x = 0
sh.glottis_obj.use_rot_y = -333.151
sh.glottis_obj.use_rot_z = 0
sh.glottis_obj.touchable = FALSE
sh.glottis_obj.lookAt = function(arg1) -- line 458
    manny:say_line("/lbma005/")
end
sh.flower_trail_obj = Object:create(sh, "master flower trail", 0, 0, 0, { range = 0 })
sh.flower_trail_obj.lookAt = function(arg1) -- line 465
    manny:say_line("/zwma012/")
end
sh.flower_trail_obj.pickUp = function(arg1) -- line 469
    system.default_response("mittens")
end
sh.flower_trail_obj.use = sh.flower_trail_obj.pickUp
sh.remote = Object:create(sh, "/shtx002/remote control", 0, 0, 0, { range = 0 })
sh.remote.string_name = "remote"
sh.remote.lookAt = function(arg1) -- line 478
    manny:say_line("/shma003/")
end
sh.remote.raise = function(arg1) -- line 482
    if albinizod_pinned then
        system.default_response("right")
    else
        if system.currentSet == at then
            glottis:thaw()
            ForceRefresh()
        end
        START_CUT_SCENE()
        start_sfx("bwRmClik.wav")
        start_sfx("bwShock.wav")
        glottis.bonewagon_up = TRUE
        stop_script(sg.glottis_roars)
        glottis:play_chore(bonewagon_gl_shocks)
        glottis:wait_for_chore()
        arg1.raised = TRUE
        if system.currentSet == sh then
            MakeSectorActive("bw_up1", TRUE)
            MakeSectorActive("bw_up2", TRUE)
            MakeSectorActive("bw_up3", TRUE)
            glottis:wait_for_message()
            glottis:say_line("/shgl004/")
            glottis:wait_for_message()
            start_script(sg.glottis_roars, sg, glottis)
        elseif system.currentSet == at then
            glottis:freeze()
        end
        END_CUT_SCENE()
    end
end
sh.remote.lower = function(arg1) -- line 513
    START_CUT_SCENE()
    if system.currentSet == sh and (manny:find_sector_name("bw_up1") or manny:find_sector_name("bw_up2")) then
        END_CUT_SCENE()
        return nil
    else
        start_sfx("bwRmClik.wav")
        start_sfx("bwShock.wav")
        if system.currentSet == at then
            glottis:thaw()
            ForceRefresh()
        end
        glottis.bonewagon_up = FALSE
        stop_script(sg.glottis_roars)
        if zod_set_to_pin then
            preload_sfx("atBWLnd.wav")
            at:current_setup(at_albcu)
            start_sfx("atBWLnd.wav")
        end
        if manny:find_sector_name("bw_up3") then
            start_script(sh.crush_manny)
            END_CUT_SCENE()
            return nil
        end
        glottis:play_chore(bonewagon_gl_down)
        glottis:wait_for_chore()
        arg1.raised = FALSE
        if system.currentSet == sh then
            MakeSectorActive("bw_up1", FALSE)
            MakeSectorActive("bw_up2", FALSE)
            MakeSectorActive("bw_up3", FALSE)
            glottis:wait_for_message()
            glottis:say_line("/shgl005/")
            glottis:wait_for_message()
            start_script(sg.glottis_roars, sg, glottis)
        elseif system.currentSet == at then
            glottis:freeze()
        end
        if zod_set_to_pin then
            start_script(at.solve_puzzle)
        end
    end
    END_CUT_SCENE()
end
sh.remote.use = function(arg1) -- line 562
    if sh.remote.raised then
        sh.remote:lower()
    else
        sh.remote:raise()
    end
end
sh.remote.use_gator = sh.remote.use
sh.remote.use_at_wagon = sh.remote.use
sh.remote.use_glottis_obj = sh.remote.use
sh.glottis_obj.use_remote = sh.remote.use
at.bone_wagon.use_remote = sh.remote.use
sh.storm_drain = Object:create(sh, "/shtx008/storm drain", 0, 0, 0, { range = 0 })
sh.storm_drain.look_out = function(arg1) -- line 625
    manny:say_line("/shma009/")
end
sh.te_ladder = Ladder:create(le, "/shtx010/", 0.51663202, -0.048954699, 0.92000002, { range = 1 })
sh.ladderup_box = sh.te_ladder
sh.ladderdn_box = sh.te_ladder
sh.te_ladder.base.use_pnt_x = 0.60663199
sh.te_ladder.base.use_pnt_y = -0.048954699
sh.te_ladder.base.use_pnt_z = 0
sh.te_ladder.base.use_rot_x = 0
sh.te_ladder.base.use_rot_y = 84
sh.te_ladder.base.use_rot_z = 0
sh.te_ladder.base.out_pnt_x = 0.84414202
sh.te_ladder.base.out_pnt_y = -0.073743597
sh.te_ladder.base.out_pnt_z = 0
sh.te_ladder.base.out_rot_x = 0
sh.te_ladder.base.out_rot_y = 264.01999
sh.te_ladder.base.out_rot_z = 0
sh.te_ladder.top.use_pnt_x = 0.60663199
sh.te_ladder.top.use_pnt_y = -0.048954699
sh.te_ladder.top.use_pnt_z = 2.95
sh.te_ladder.top.use_rot_x = 0
sh.te_ladder.top.use_rot_y = 84
sh.te_ladder.top.use_rot_z = 0
sh.te_ladder.top.out_pnt_x = 0.047309
sh.te_ladder.top.out_pnt_y = -0.106915
sh.te_ladder.top.out_pnt_z = 2.95
sh.te_ladder.top.out_rot_x = 0
sh.te_ladder.top.out_rot_y = 84
sh.te_ladder.top.out_rot_z = 0
sh.te_ladder.touchable = FALSE
sh.te_ladder.base.box = "ladderup_box"
sh.te_ladder.top.box = "ladderdn_box"
sh.te_ladder.minz = 0
sh.te_ladder.maxz = 2.3559999
sh.te_ladder.climbOut = function(arg1, arg2) -- line 674
    if arg2 == arg1.top.box then
        single_start_script(sh.unmount_ladder, sh)
    else
        Ladder.climbOut(arg1, arg2)
    end
end
sh.te_ladder.walkOut = function(arg1, arg2) -- line 682
end
sh.puddle = Object:create(sh, "/shtx012/puddle", 2.4706399, -0.217572, 0, { range = 0.60000002 })
sh.puddle.use_pnt_x = 2.4706399
sh.puddle.use_pnt_y = 0.202428
sh.puddle.use_pnt_z = 0
sh.puddle.use_rot_x = 0
sh.puddle.use_rot_y = 188.48
sh.puddle.use_rot_z = 0
sh.puddle:make_untouchable()
sh.puddle.lookAt = function(arg1) -- line 738
    manny:say_line("/shma013/")
    wait_for_message()
    manny:say_line("/shma014/")
end
sh.puddle.pickUp = function(arg1) -- line 744
    system.default_response("mittens")
end
sh.puddle.use = sh.puddle.pickUp
sh.puddle.use_bone = function(arg1) -- line 750
    soft_script()
    manny:say_line("/shma017/")
    wait_for_message()
    manny:say_line("/shma018/")
end
sh.zw_door = Object:create(sh, "/shtx019/sewer", 3.7567101, 1.7472301, 0.49000001, { range = 0 })
sh.zw_door.use_pnt_x = 3.33671
sh.zw_door.use_pnt_y = 1.26723
sh.zw_door.use_pnt_z = 0
sh.zw_door.use_rot_x = 0
sh.zw_door.use_rot_y = -7242.3599
sh.zw_door.use_rot_z = 0
sh.zw_door.out_pnt_x = 3.66871
sh.zw_door.out_pnt_y = 1.68056
sh.zw_door.out_pnt_z = 0
sh.zw_door.out_rot_x = 0
sh.zw_door.out_rot_y = -7237.9399
sh.zw_door.out_rot_z = 0
sh.zw_box = sh.zw_door
sh.zw_door.walkOut = function(arg1) -- line 778
    zw:come_out_door(zw.sh_door)
    if bowlsley_in_hiding and not zw.talked_bowlsley then
        start_script(zw.talk_bowlsley)
    end
end
sh.lw_door = Object:create(sh, "/shtx020/sewer", 2.0725801, -3.85025, 0.44999999, { range = 1.5 })
sh.lw_door.use_pnt_x = 2.0725801
sh.lw_door.use_pnt_y = -2.7802501
sh.lw_door.use_pnt_z = 0
sh.lw_door.use_rot_x = 0
sh.lw_door.use_rot_y = -7379.2002
sh.lw_door.use_rot_z = 0
sh.lw_door.out_pnt_x = 2.0743799
sh.lw_door.out_pnt_y = -2.9058599
sh.lw_door.out_pnt_z = 0
sh.lw_door.out_rot_x = 0
sh.lw_door.out_rot_y = -7379.2002
sh.lw_door.out_rot_z = 0
sh.lw_door:make_untouchable()
sh.lw_door.walkOut = function(arg1) -- line 804
    lw:come_out_door(lw.sh_door)
end
sh.te_door = Object:create(sh, "/shtx021/corridor", -0.46466601, -0.065484896, 3.48, { range = 0 })
sh.te_door.use_pnt_x = -0.24216101
sh.te_door.use_pnt_y = -0.065622203
sh.te_door.use_pnt_z = 2.95
sh.te_door.use_rot_x = 0
sh.te_door.use_rot_y = 81.121101
sh.te_door.use_rot_z = 0
sh.te_door.out_pnt_x = -0.34338301
sh.te_door.out_pnt_y = -0.129418
sh.te_door.out_pnt_z = 2.95
sh.te_door.out_rot_x = 0
sh.te_door.out_rot_y = 95.169601
sh.te_door.out_rot_z = 0
sh.te_door:make_untouchable()
sh.te_door.walkOut = function(arg1) -- line 826
    te:come_out_door(te.sh_door)
end
bonewagon_gl_no_shocks = 0
bonewagon_gl_shocks = 1
bonewagon_gl_stay_up = 2
bonewagon_gl_turn_rt = 3
bonewagon_gl_hold_rt = 4
bonewagon_gl_rt_to_ctr = 5
bonewagon_gl_hold_ctr = 6
bonewagon_gl_turn_lft = 7
bonewagon_gl_hold_lft = 8
bonewagon_gl_lft_to_ctr = 9
bonewagon_gl_down = 10
bonewagon_gl_ma_jump_in = 11
bonewagon_gl_ma_sit = 12
bonewagon_gl_ma_jump_out = 13
bonewagon_gl_hide_ma = 14
bonewagon_gl_backup = 15
bonewagon_gl_gl_drive = 16
bonewagon_gl_gl_hands_out = 17
bonewagon_gl_gl_2hands_out = 18
bonewagon_gl_gl_cvr_eyes_shocks = 19
bonewagon_gl_gl_cvr_eyes_hold = 20
bonewagon_gl_gl_cvr_eyes_fwd = 21
bonewagon_gl_gl_cvr_eyes_dn = 22
bonewagon_gl_gl_cvr_eyes_bk = 23
bonewagon_gl_gl_cvr_eyes = 24
bonewagon_gl_gl_mumble = 25
bonewagon_gl_c = 26
bonewagon_gl_f = 27
bonewagon_gl_e = 28
bonewagon_gl_u = 29
bonewagon_gl_t = 30
bonewagon_gl_m = 31
bonewagon_gl_a = 32
bonewagon_gl_o = 33
bonewagon_gl_stop_talk = 34
bonewagon_gl_drive = 35
bonewagon_gl_tormbl = 36
bonewagon_gl_rmbl = 37
bonewagon_gl_rmbl2drv = 38
bonewagon_gl_tovrm_lft = 39
bonewagon_gl_vrm_lft_hld = 40
bonewagon_gl_vrm2drv = 41
bonewagon_gl_mck_shft = 42
bonewagon_gl_sc_hook = 43
bonewagon_gl_sc_rmbl = 44
bonewagon_gl_sc2steer = 45
bonewagon_gl_sc_steer = 46
bonewagon_gl_sc2drv = 47
bonewagon_gl_rx2rmbl = 48
bonewagon_gl_rx_rmbl = 49
bonewagon_gl_rx_2steer = 50
bonewagon_gl_rx_steer = 51
bonewagon_gl_rx_hook = 52
bonewagon_gl_rx2drv = 53
bonewagon_gl_wp_mouth = 54
bonewagon_gl_putaway_remote = 55
bonewagon_gl_takeout_remote = 56
bonewagon_gl_hold_remote = 57
bonewagon_gl_hide_bw = 58
bonewagon_gl_gl_stop_hands_out = 59
bonewagon_gl_gl_uncover_eyes = 60
bonewagon_gl_hide_gl = 61
bonewagon_gl_l = 62
bonewagon_alb_no_shocks = 0
bonewagon_alb_shocks = 1
bonewagon_alb_stay_up = 2
bonewagon_alb_turn_rt = 3
bonewagon_alb_hold_rt = 4
bonewagon_alb_rt_to_ctr = 5
bonewagon_alb_hold_ctr = 6
bonewagon_alb_turn_lft = 7
bonewagon_alb_hold_lft = 8
bonewagon_alb_lft_to_ctr = 9
bonewagon_alb_down = 10
bonewagon_alb_ma_jump_in = 11
bonewagon_alb_ma_sit = 12
bonewagon_alb_ma_jump_out = 13
bonewagon_alb_hide_ma = 14
bonewagon_alb_backup = 15
bonewagon_alb_gl_drive = 16
bonewagon_alb_gl_hands_out = 17
bonewagon_alb_gl_2hands_out = 18
bonewagon_alb_gl_cvr_eyes_shocks = 19
bonewagon_alb_gl_cvr_eyes_hold = 20
bonewagon_alb_gl_cvr_eyes_fwd = 21
bonewagon_alb_gl_cvr_eyes_dn = 22
bonewagon_alb_gl_cvr_eyes_bk = 23
bonewagon_alb_gl_cvr_eyes = 24
bonewagon_alb_gl_mumble = 25
bonewagon_alb_c = 26
bonewagon_alb_f = 27
bonewagon_alb_e = 28
bonewagon_alb_u = 29
bonewagon_alb_t = 30
bonewagon_alb_m = 31
bonewagon_alb_a = 32
bonewagon_alb_o = 33
bonewagon_alb_stop_talk = 34
bonewagon_alb_drive = 35
bonewagon_alb_tormbl = 36
bonewagon_alb_rmbl = 37
bonewagon_alb_rmbl2drv = 38
bonewagon_alb_tovrm_lft = 39
bonewagon_alb_vrm_lft_hld = 40
bonewagon_alb_vrm2drv = 41
bonewagon_alb_mck_shft = 42
bonewagon_alb_sc_hook = 43
bonewagon_alb_sc_rmbl = 44
bonewagon_alb_sc2steer = 45
bonewagon_alb_sc_steer = 46
bonewagon_alb_sc2drv = 47
bonewagon_alb_rx2rmbl = 48
bonewagon_alb_rx_rmbl = 49
bonewagon_alb_rx_2steer = 50
bonewagon_alb_rx_steer = 51
bonewagon_alb_rx_hook = 52
bonewagon_alb_rx2drv = 53
bonewagon_alb_wp_mouth = 54
bonewagon_alb_putaway_remote = 55
bonewagon_alb_takeout_remote = 56
bonewagon_alb_hold_remote = 57
bonewagon_cc_no_shocks = 0
bonewagon_cc_shocks = 1
bonewagon_cc_stay_up = 2
bonewagon_cc_turn_rt = 3
bonewagon_cc_hold_rt = 4
bonewagon_cc_rt_to_ctr = 5
bonewagon_cc_hold_ctr = 6
bonewagon_cc_turn_lft = 7
bonewagon_cc_hold_lft = 8
bonewagon_cc_lft_to_ctr = 9
bonewagon_cc_down = 10
bonewagon_cc_ma_jump_in = 11
bonewagon_cc_ma_sit = 12
bonewagon_cc_ma_jump_out = 13
bonewagon_cc_hide_ma = 14
bonewagon_cc_backup = 15
bonewagon_cc_gl_drive = 16
bonewagon_cc_gl_hands_out = 17
bonewagon_cc_gl_2hands_out = 18
bonewagon_cc_gl_cvr_eyes_shocks = 19
bonewagon_cc_gl_cvr_eyes_hold = 20
bonewagon_cc_gl_cvr_eyes_fwd = 21
bonewagon_cc_gl_cvr_eyes_dn = 22
bonewagon_cc_gl_cvr_eyes_bk = 23
bonewagon_cc_gl_cvr_eyes = 24
bonewagon_cc_gl_mumble = 25
bonewagon_cc_c = 26
bonewagon_cc_f = 27
bonewagon_cc_e = 28
bonewagon_cc_u = 29
bonewagon_cc_t = 30
bonewagon_cc_m = 31
bonewagon_cc_a = 32
bonewagon_cc_o = 33
bonewagon_cc_stop_talk = 34
bonewagon_cc_drive = 35
bonewagon_cc_tormbl = 36
bonewagon_cc_rmbl = 37
bonewagon_cc_rmbl2drv = 38
bonewagon_cc_tovrm_lft = 39
bonewagon_cc_vrm_lft_hld = 40
bonewagon_cc_vrm2drv = 41
bonewagon_cc_mck_shft = 42
bonewagon_cc_sc_hook = 43
bonewagon_cc_sc_rmbl = 44
bonewagon_cc_sc2steer = 45
bonewagon_cc_sc_steer = 46
bonewagon_cc_sc2drv = 47
bonewagon_cc_rx2rmbl = 48
bonewagon_cc_rx_rmbl = 49
bonewagon_cc_rx_2steer = 50
bonewagon_cc_rx_steer = 51
bonewagon_cc_rx_hook = 52
bonewagon_cc_rx2drv = 53
bonewagon_cc_wp_mouth = 54
bonewagon_cc_putaway_remote = 55
bonewagon_cc_takeout_remote = 56
bonewagon_cc_hold_remote = 57
bonewagon_cc_gl_stop_hands_out = 58
bonewagon_cc_gl_uncover_eyes = 59
bonewagon_thunder_no_shocks = 0
bonewagon_thunder_shocks = 1
bonewagon_thunder_stay_up = 2
bonewagon_thunder_turn_rt = 3
bonewagon_thunder_hold_rt = 4
bonewagon_thunder_rt_to_ctr = 5
bonewagon_thunder_hold_ctr = 6
bonewagon_thunder_turn_lft = 7
bonewagon_thunder_hold_lft = 8
bonewagon_thunder_lft_to_ctr = 9
bonewagon_thunder_down = 10
bonewagon_thunder_ma_jump_in = 11
bonewagon_thunder_ma_sit = 12
bonewagon_thunder_ma_jump_out = 13
bonewagon_thunder_hide_ma = 14
bonewagon_thunder_backup = 15
bonewagon_thunder_gl_drive = 16
bonewagon_thunder_gl_hands_out = 17
bonewagon_thunder_gl_2hands_out = 18
bonewagon_thunder_gl_cvr_eyes_shocks = 19
bonewagon_thunder_gl_cvr_eyes_hold = 20
bonewagon_thunder_gl_cvr_eyes_fwd = 21
bonewagon_thunder_gl_cvr_eyes_dn = 22
bonewagon_thunder_gl_cvr_eyes_bk = 23
bonewagon_thunder_gl_cvr_eyes = 24
bonewagon_thunder_gl_mumble = 25
bonewagon_thunder_c = 26
bonewagon_thunder_f = 27
bonewagon_thunder_e = 28
bonewagon_thunder_u = 29
bonewagon_thunder_t = 30
bonewagon_thunder_m = 31
bonewagon_thunder_a = 32
bonewagon_thunder_o = 33
bonewagon_thunder_stop_talk = 34
bonewagon_thunder_drive = 35
bonewagon_thunder_tormbl = 36
bonewagon_thunder_rmbl = 37
bonewagon_thunder_rmbl2drv = 38
bonewagon_thunder_tovrm_lft = 39
bonewagon_thunder_vrm_lft_hld = 40
bonewagon_thunder_vrm2drv = 41
bonewagon_thunder_mck_shft = 42
bonewagon_thunder_sc_hook = 43
bonewagon_thunder_sc_rmbl = 44
bonewagon_thunder_sc2steer = 45
bonewagon_thunder_sc_steer = 46
bonewagon_thunder_sc2drv = 47
bonewagon_thunder_rx2rmbl = 48
bonewagon_thunder_rx_rmbl = 49
bonewagon_thunder_rx_2steer = 50
bonewagon_thunder_rx_steer = 51
bonewagon_thunder_rx_hook = 52
bonewagon_thunder_rx2drv = 53
bonewagon_thunder_wp_mouth = 54
bonewagon_thunder_putaway_remote = 55
bonewagon_thunder_takeout_remote = 56
bonewagon_thunder_hold_remote = 57
bonewagon_thunder_gl_stop_hands_out = 58
bonewagon_thunder_gl_uncover_eyes = 59

CheckFirstTime("ks.lua")
ks = Set:create("ks.set", "kitty stable", { ks_intws = 0, ks_overhead = 1 })
dofile("mc_litter.lua")
ks.opener_actor = Actor:create(nil, nil, nil, "opener")
ks.opener_actor.default = function(arg1) -- line 16
    arg1:set_costume("ks_opener.cos")
    arg1:put_in_set(ks)
    arg1:play_chore(0)
    arg1:setpos(0.283674, 1.404, 0.365)
    arg1:setrot(0, 270, 0)
end
ks.opener_actor.spin = function(arg1) -- line 24
    local local1 = { x = -0.282998, y = 0, z = 0 }
    local local2 = { x = 0.44025901, y = 1.55282, z = 0.36000001 }
    local local3
    local local4
    local4 = 360
    while local4 > 0 do
        arg1:setrot(0, local4, 0)
        local3 = RotateVector(local1, { x = 0, y = local4, z = 0 })
        arg1:setpos(local2.x + local3.x, local2.y + local3.y, local2.z)
        local4 = local4 - 2
        break_here()
    end
    local4 = 0
    arg1:setrot(0, local4, 0)
    local3 = RotateVector(local1, { x = 0, y = local4, z = 0 })
    arg1:setpos(local2.x + local3.x, local2.y + local3.y, local2.z)
end
ks.far_box_point = { x = -0.87086898, y = 0.68475401, z = 0.2282 }
ks.near_box_point = { x = -0.57376897, y = -0.64934599, z = 0.2282 }
ks.proximity = function(arg1, arg2, arg3, arg4) -- line 50
    local local1, local2, local3
    local local4, local5, local6
    local local7
    local local8
    if not arg3 then
        if not arg1 then
            PrintDebug("No valid actor in proximity calculation.\n")
            return nil
        end
        if type(arg1) == "table" then
            arg1 = arg1.hActor
        end
        if type(arg2) == "table" then
            arg2 = arg2.hActor
        end
        if not arg2 then
            arg2 = system.currentActor.hActor
        end
        local4, local5, local6 = GetActorPos(arg2)
    else
        local4 = arg2
        local5 = arg3
        local6 = arg4
    end
    if type(arg1) == "table" then
        local7 = arg1:getpos()
        local1, local2, z1 = local7.x, local7.y, local7.z
    else
        local1, local2, z1 = GetActorPos(arg1)
    end
    local8 = sqrt((local1 - local4) ^ 2 + (local2 - local5) ^ 2 + (z1 - local6) ^ 2)
    return local8
end
ks.smell = function(arg1) -- line 93
    START_CUT_SCENE()
    ks.smelled = TRUE
    manny:twist_head_gesture()
    manny:say_line("/ksma001/")
    wait_for_message()
    manny:say_line("/ksma002/")
    if sl.detector.in_catbox then
        manny:wait_for_message()
        sleep_for(1500)
    end
    END_CUT_SCENE()
end
ks.say_eyw = function(arg1) -- line 107
    START_CUT_SCENE()
    ks.repulsed = TRUE
    manny:wait_for_actor()
    manny:wait_for_message()
    manny:head_look_at(ks.sky)
    manny:say_line("/ksma003/")
    wait_for_message()
    manny:head_look_at(ks.litter3)
    manny:say_line("/ksma004/")
    manny:wait_for_message()
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
ks.scythe_detector_monitor = function(arg1) -- line 123
    local local1, local2
    if sl.detector.in_catbox then
        while TRUE do
            if manny.is_holding == mo.scythe then
                local1 = proximity(manny.hActor, 0.0016740001, -0.072999999, 0)
                local2 = 127 - local1 * 100
                if local2 > 80 then
                    local2 = 80
                elseif local2 < 0 then
                    local2 = 10
                end
                if not sound_playing("mdSand.IMU") and local2 > 0 then
                    start_sfx("mdSand.IMU", IM_HIGH_PRIORITY, local2)
                elseif local2 == 0 then
                    stop_sound("mdSand.IMU")
                else
                    set_vol("mdSand.IMU", local2)
                end
            elseif sound_playing("mdSand.IMU") then
                stop_sound("mdSand.IMU")
            end
            break_here()
        end
    end
end
ks.use_scythe = function(arg1) -- line 155
    local local1
    local local2 = manny:find_sector_name("temp_treasure")
    if sl.detector.in_catbox then
        if sl.detector.retrieved then
            manny:say_line("/ksma014/")
        else
            START_CUT_SCENE()
            if local2 then
                manny:walk_and_face(0.053943299, -0.175, 0, 0, 188.138, 0)
            else
                if ks.proximity(manny, ks.far_box_point.x, ks.far_box_point.y, ks.far_box_point.z) < ks.proximity(manny, ks.near_box_point.x, ks.near_box_point.y, ks.near_box_point.z) then
                    local1 = ks.far_box_point
                else
                    local1 = ks.near_box_point
                end
                manny:turn_toward_entity(local1.x, local1.y, local1.z)
            end
            manny:wait_for_actor()
            break_here()
            manny:stop_chore(nil, "mc.cos")
            manny:set_costume(nil)
            manny:set_costume("mc_litter.cos")
            manny:run_chore(mc_litter_scan_in, "mc_litter.cos")
            manny:stop_chore(mc_litter_scan_in, "mc_litter.cos")
            manny:play_chore_looping(mc_litter_scan_loop, "mc_litter.cos")
            if local2 then
                stop_script(ks.scythe_detector_monitor)
                break_here()
                if not sound_playing("mdSand.IMU") then
                    start_sfx("mdSand.IMU")
                end
                set_vol("mdSand.IMU", 127)
                sleep_for(600)
                manny:say_line("/ksma015/")
                wait_for_message()
            else
                sleep_for(3000)
            end
            manny:set_chore_looping(mc_litter_scan_loop, FALSE, "mc_litter.cos")
            manny:wait_for_chore(mc_litter_scan_loop, "mc_litter.cos")
            manny:stop_chore(mc_litter_scan_loop, "mc_litter.cos")
            manny:run_chore(mc_litter_scan_out, "mc_litter.cos")
            manny:stop_chore(mc_litter_scan_out, "mc_litter.cos")
            if not local2 then
                manny:default()
                manny.is_holding = mo.scythe
                manny:play_chore(mc_hold_scythe, "mc.cos")
            else
                sl.detector.retrieved = TRUE
                sl.detector.in_catbox = FALSE
                if not sound_playing("mdSand.IMU") then
                    start_sfx("mdSand.IMU")
                end
                manny:play_chore(mc_litter_digout_detector, "mc_litter.cos")
                sleep_for(3000)
                stop_sound("mdSand.IMU")
                start_sfx("mdBeep.IMU")
                manny:wait_for_chore(mc_litter_digout_detector, "mc_litter.cos")
                manny:stop_chore()
                music_state:set_sequence(seqFindDetector)
                if not sl.detector.actor then
                    sl.detector.actor = Actor:create()
                end
                sl.detector.actor:set_costume(nil)
                sl.detector.actor:set_costume("mc_litter.cos")
                sl.detector.actor:put_in_set(ks)
                sl.detector.actor:set_visibility(TRUE)
                sl.detector.actor:play_chore(mc_litter_detector_only, "mc_litter.cos")
                sl.detector.actor:setpos(0.053943299, -0.175, 0)
                sl.detector.actor:setrot(0, 188.138, 0)
                stop_sound("mdBeep.IMU")
                manny:default()
                manny.is_holding = mo.scythe
                manny:play_chore(mc_hold_scythe, "mc.cos")
                mo.scythe:put_away()
                manny:head_look_at_point({ x = -0.43777201, y = -0.218685, z = 0.020099999 })
                manny:walk_and_face(-0.28027201, -0.166685, 0, 0, 153.159, 0)
                manny:play_chore(mc_reach_low, "mc.cos")
                sleep_for(300)
                manny:blend(mc_activate_detector, mc_reach_low, 500)
                sl.detector.actor:free()
                sleep_for(500)
                manny:generic_pickup(sl.detector)
                manny:say_line("/ksma016/")
                manny:wait_for_chore(mc_reach_low, "mc.cos")
                manny:stop_chore(mc_reach_low, "mc.cos")
            end
            END_CUT_SCENE()
            if local2 then
                cur_puzzle_state[27] = TRUE
            end
        end
    else
        manny:say_line("/ksma017/")
    end
end
ks.open_can = function(arg1) -- line 263
    START_CUT_SCENE()
    manny:play_chore(mc_give_hrpass, "mc.cos")
    manny:wait_for_chore(mc_give_hrpass, "mc.cos")
    manny:stop_chore(mc_activate_opener, "mc.cos")
    manny:stop_chore(mc_hold, "mc.cos")
    manny:stop_chore(mc_give_hrpass, "mc.cos")
    manny:play_chore(mc_hrpass_rtrn2base, "mc.cos")
    ks:add_object_state(ks_intws, "ks_can.bm", nil, OBJSTATE_UNDERLAY)
    ks.cat_food:set_object_state("ks_can.cos")
    start_sfx("hkCskOp1.wav")
    wait_for_sound("hkCskOp1.wav")
    start_sfx("hkCskOp2.WAV")
    ks.opener_actor:default()
    start_script(ks.opener_actor.spin, ks.opener_actor)
    sleep_for(1000)
    start_sfx("hkCskOp2.WAV")
    sleep_for(1350)
    ks.cat_food:play_chore(0)
    wait_for_script(ks.opener_actor.spin)
    manny:stop_chore(mc_hrpass_rtrn2base, "mc.cos")
    manny:play_chore(mc_give_hrpass, "mc.cos")
    sleep_for(250)
    start_sfx("ksGetOp.wav")
    manny:wait_for_chore(mc_give_hrpass, "mc.cos")
    ks.opener_actor:play_chore(1)
    manny:stop_chore(mc_give_hrpass, "mc.cos")
    manny:play_chore(mc_activate_opener, "mc.cos")
    manny:play_chore(mc_hrpass_rtrn2base, "mc.cos")
    manny:blend(mc_hold, mc_hrpass_rtrn2base, 150, "mc.cos", "mc.cos")
    manny.hold_chore = mc_activate_opener
    sleep_for(150)
    manny:stop_chore(mc_hrpass_rtrn2base, "mc.cos")
    END_CUT_SCENE()
end
ks.footstep_monitor = function(arg1) -- line 309
    while TRUE do
        if manny:find_sector_name("metal_box") then
            if manny.footsteps ~= footsteps.metal then
                manny.footsteps = footsteps.metal
            end
        elseif manny:find_sector_name("concrete_box") then
            if manny.footsteps ~= footsteps.concrete then
                manny.footsteps = footsteps.concrete
            end
        end
        break_here()
    end
end
ks.enter = function(arg1) -- line 324
    single_start_script(ks.scythe_detector_monitor, ks)
    if ks.cat_food.opened then
        ks:add_object_state(ks_intws, "ks_can.bm", nil, OBJSTATE_UNDERLAY)
        ks.cat_food:set_object_state("ks_can.cos")
        ks.cat_food:play_chore(1)
    end
    start_script(tb.off_screen_kittys)
    start_script(ks.footstep_monitor, ks)
    if sl.detector.in_catbox then
        LoadCostume("mc_litter.cos")
    end
    if ks.opener.touchable then
        ks.opener_actor:default()
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow5")
    AddShadowPlane(manny.hActor, "shadow6")
    AddShadowPlane(manny.hActor, "shadow7")
end
ks.exit = function(arg1) -- line 358
    stop_script(ks.scythe_detector_monitor)
    stop_sound("mdSand.IMU")
    stop_sound("mdBeep.IMU")
    stop_script(tb.off_screen_kittys)
    stop_script(ks.footstep_monitor)
    ks.opener_actor:free()
    KillActorShadows(manny.hActor)
end
ks.sky = Object:create(ks, "/kstx005/sky", -0.59832603, 0.85008001, 3.5999999, { range = 0 })
ks.sky.touchable = FALSE
ks.litter1 = Object:create(ks, "/kstx006/litter", -0.69832599, 0.85008001, -0.1, { range = 0.60000002 })
ks.litter1.use_pnt_x = -0.478434
ks.litter1.use_pnt_y = 1.37518
ks.litter1.use_pnt_z = 0
ks.litter1.use_rot_x = 0
ks.litter1.use_rot_y = -173.452
ks.litter1.use_rot_z = 0
ks.litter1.lookAt = function(arg1) -- line 387
    if not ks.litter1.seen then
        ks.litter1.seen = TRUE
        manny:say_line("/ksma007/")
        wait_for_message()
    end
    manny:say_line("/ksma008/")
end
ks.litter1.pickUp = function(arg1) -- line 396
    START_CUT_SCENE()
    manny:say_line("/ksma009/")
    wait_for_message()
    manny:say_line("/ksma010/")
    wait_for_message()
    manny:head_look_at(ks.sky)
    manny:say_line("/ksma011/")
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
ks.litter1.use = function(arg1) -- line 408
    if not ks.litter1.tried then
        ks.litter1.tried = TRUE
        manny:say_line("/ksma012/")
    else
        manny:say_line("/ksma013/")
    end
end
ks.litter1.use_scythe = function(arg1) -- line 417
    ks:use_scythe()
end
ks.litter1.use_detector = function(arg1) -- line 421
    sl.detector:use()
end
ks.litter2 = Object:create(ks, "/kstx018/litter", -0.098325998, -0.64991999, -0.1, { range = 0.60000002 })
ks.litter2.use_pnt_x = 0.121652
ks.litter2.use_pnt_y = -0.00296139
ks.litter2.use_pnt_z = 0
ks.litter2.use_rot_x = 0
ks.litter2.use_rot_y = -156.511
ks.litter2.use_rot_z = 0
ks.litter2.parent = ks.litter1
ks.litter3 = Object:create(ks, "/kstx019/litter", 0.80167401, -0.16992, -0.22, { range = 0.60000002 })
ks.litter3.use_pnt_x = 0.121652
ks.litter3.use_pnt_y = -0.00296139
ks.litter3.use_pnt_z = 0
ks.litter3.use_rot_x = 0
ks.litter3.use_rot_y = -156.511
ks.litter3.use_rot_z = 0
ks.litter3.parent = ks.litter1
ks.cat_food = Object:create(ks, "/kstx022/big can", 0.64767402, 1.585, 0.34200001, { range = 0.80000001 })
ks.cat_food.use_pnt_x = -0.035240699
ks.cat_food.use_pnt_y = 1.5549001
ks.cat_food.use_pnt_z = 0
ks.cat_food.use_rot_x = 0
ks.cat_food.use_rot_y = 285.60699
ks.cat_food.use_rot_z = 0
ks.cat_food.lookAt = function(arg1) -- line 491
    manny:say_line("/ksma023/")
end
ks.cat_food.pickUp = function(arg1) -- line 495
    system.default_response("hernia")
end
ks.cat_food.use = function(arg1) -- line 499
    if not arg1.opened then
        manny:say_line("/ksma024/")
    else
        manny:say_line("/ksma025/")
    end
end
ks.cat_food.use_opener = function(arg1) -- line 507
    if arg1.opened then
        manny:say_line("/ksma026/")
    elseif manny:walkto_object(arg1) then
        arg1.opened = TRUE
        ks:open_can()
        manny:say_line("/ksma027/")
    end
end
ks.cat_food.use_detector = function(arg1) -- line 516
    sl.detector:use()
end
ks.opener = Object:create(ks, "/kstx028/opener", 0.226364, 1.54373, 0.34200001, { range = 0.60000002 })
ks.opener.use_pnt_x = -0.035240699
ks.opener.use_pnt_y = 1.5549001
ks.opener.use_pnt_z = 0
ks.opener.use_rot_x = 0
ks.opener.use_rot_y = 285.60699
ks.opener.use_rot_z = 0
ks.opener.wav = "getMetl.wav"
ks.opener.lookAt = function(arg1) -- line 530
    arg1.seen = TRUE
    manny:say_line("/ksma029/")
end
ks.opener.pickUp = function(arg1) -- line 535
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:play_chore(mc_give_hrpass, "mc.cos")
        manny:wait_for_chore(mc_give_hrpass, "mc.cos")
        start_sfx("ksGetOp.wav")
        manny:generic_pickup(ks.opener)
        ks.opener_actor:play_chore(1)
        manny:stop_chore(mc_give_hrpass, "mc.cos")
        manny:play_chore(mc_hrpass_rtrn2base, "mc.cos")
        sleep_for(100)
        manny:fade_out_chore(mc_hrpass_rtrn2base, "mc.cos", 500)
        if not ks.opener.seen then
            ks.opener:lookAt()
        end
        END_CUT_SCENE()
    end
end
ks.opener.use = function(arg1) -- line 554
    if arg1.owner ~= manny then
        arg1:pickUp()
    else
        START_CUT_SCENE()
        look_at_item_in_hand(TRUE)
        start_sfx("hkCskOp2.WAV")
        wait_for_sound("hkCskOp2.WAV")
        manny:head_look_at(nil)
        END_CUT_SCENE()
    end
end
ks.opener.default_response = function(arg1) -- line 567
    manny:say_line("/ksma030/")
end
ks.kh_door = Object:create(ks, "/kstx031/door", -0.39832601, 2.35008, 0.44, { range = 0.60000002 })
ks.kh_door.use_pnt_x = -0.40721899
ks.kh_door.use_pnt_y = 1.90771
ks.kh_door.use_pnt_z = 0
ks.kh_door.use_rot_x = 0
ks.kh_door.use_rot_y = -719.79199
ks.kh_door.use_rot_z = 0
ks.kh_door.out_pnt_x = -0.40870199
ks.kh_door.out_pnt_y = 2.3161099
ks.kh_door.out_pnt_z = 0
ks.kh_door.out_rot_x = 0
ks.kh_door.out_rot_y = -719.79199
ks.kh_door.out_rot_z = 0
ks.kh_door.walkOut = function(arg1) -- line 592
    kh:come_out_door(kh.ks_door)
end
ks.kh_door.lookAt = function(arg1) -- line 596
    manny:say_line("/ksma032/")
end
ks.kh_door.comeOut = function(arg1) -- line 600
    Object.come_out_door(arg1)
    if not ks.smelled then
        ks:smell()
    end
    if sl.detector.in_catbox then
        if not ks.repulsed then
            ks:say_eyw()
        end
    end
end

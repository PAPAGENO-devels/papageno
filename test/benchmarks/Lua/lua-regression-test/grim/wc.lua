CheckFirstTime("wc.lua")
dofile("wc_door.lua")
KevTest = function() -- line 11
    de.forklift_actor:update_object()
    wc.lever:use()
end
wc = Set:create("wc.set", "wine cellar", { wc_frkha = 0, wc_ovrhd = 1 })
prop_forklift.wc_pt = { x = 1.55391, y = 0.952362, z = 0 }
prop_forklift.default_wc = function(arg1) -- line 20
    local local1
    arg1:free()
    arg1:set_costume("forklift.cos")
    arg1:put_in_set(wc)
    arg1:setpos(arg1.wc_pt.x, arg1.wc_pt.y, arg1.wc_pt.z)
    local1 = de.forklift_actor:getrot()
    arg1:setrot(local1.x, local1.y + 90, local1.z)
    if de.forklift_actor.blades_up then
        arg1:play_chore(forklift_up_hold)
    else
        arg1:play_chore(forklift_down_hold)
    end
    arg1:set_collision_mode(COLLISION_BOX, 1)
end
wc.manny_cask = Actor:create(nil, nil, nil, "Mannys cask")
wc.manny_cask.default = function(arg1) -- line 39
    arg1:set_costume("cask.cos")
    arg1:put_in_set(wc)
    arg1:setpos(-0.0913699, -1.12098, 0.4234)
    arg1:setrot(90, 325, 0)
    SetActorPitch(arg1.hActor, 90)
end
wc.cask_actor = Actor:create(nil, nil, nil, "Other cask")
wc.cask_actor.default = function(arg1) -- line 49
    arg1:set_costume("cask.cos")
    arg1:put_in_set(wc)
    arg1:setpos(-1.36187, -1.58688, -0.289399)
    arg1:setrot(0, 268.437, 0)
end
wc.set_up_actors = function(arg1) -- line 57
    wc.manny_cask:default()
    wc.manny_cask:complete_chore(cask_show)
    wc.cask_actor:default()
    wc.cask_actor:complete_chore(cask_show)
end
wc.drive_in = function(arg1) -- line 65
    local local1
    START_CUT_SCENE()
    wc:switch_to_set()
    de.forklift_actor:put_in_set(wc)
    de.forklift_actor:setpos(1.42453, 0.593548, 0)
    de.forklift_actor:face_entity(1.36286, -1.11754, 0)
    wc.de_door:play_chore(wc_door_open)
    wc.de_door:wait_for_chore()
    wc.de_door:open()
    de.forklift_actor:driveto(1.36286, -1.11754, 0)
    de.forklift_actor.currentSet = wc
    de.forklift_actor.current_pos = { x = 1.36286, y = -1.11754, z = 0 }
    END_CUT_SCENE()
end
wc.drive_out = function(arg1) -- line 82
    START_CUT_SCENE()
    de.forklift_actor:setrot(0, 0, 0, TRUE)
    while not de.forklift_actor:find_sector_name("fork_box3") do
        de.forklift_actor:set_walk_chore(-1)
        de.forklift_actor:set_turn_chores(-1, -1)
        de.forklift_actor:set_walk_rate(0.4)
        WalkActorForward(de.forklift_actor.hActor)
        break_here()
    end
    wc.de_door:play_chore(wc_door_close)
    wc.de_door:wait_for_chore()
    wc.de_door:close()
    de.forklift_actor.currentSet = de
    END_CUT_SCENE()
    de:drive_in()
end
wc.activate_forklift_boxes = function(arg1, arg2) -- line 100
    local local1, local2
    local1 = 1
    while local1 <= 9 do
        local2 = "box" .. local1
        MakeSectorActive(local2, not arg2)
        local1 = local1 + 1
    end
    local1 = 1
    while local1 <= 3 do
        local2 = "fork_box" .. local1
        MakeSectorActive(local2, arg2)
        local1 = local1 + 1
    end
    MakeSectorActive("fork_de_trigger", arg2)
    if arg2 then
        MakeSectorActive("wc_de_psg", FALSE)
    elseif wc.de_door:is_open() then
        MakeSectorActive("wc_de_psg", TRUE)
    else
        MakeSectorActive("wc_de_psg", FALSE)
    end
end
wc.enter = function(arg1) -- line 135
    NewObjectState(wc_frkha, OBJSTATE_STATE, "wc_door.bm", "wc_door.zbm")
    wc.de_door:set_object_state("wc_door.cos")
    if wc.de_door:is_open() then
        wc.de_door:play_chore(wc_door_set_open)
    else
        wc.de_door:play_chore(wc_door_set_closed)
    end
    he.elevator:unlock()
    de.forklift_actor:initialize()
    if de.forklift_actor.currentSet == wc then
        wc.forklift:make_touchable()
        wc.lever:make_touchable()
        de.forklift_actor:default()
        de.forklift_actor:put_in_set(wc)
        de.forklift_actor:setpos(de.forklift_actor.current_pos.x, de.forklift_actor.current_pos.y, de.forklift_actor.current_pos.z)
        de.forklift_actor:setrot(de.forklift_actor.current_rot.x, de.forklift_actor.current_rot.y, de.forklift_actor.current_rot.z)
    else
        wc.forklift:make_untouchable()
        wc.lever:make_untouchable()
        if not manny.is_driving then
            prop_forklift:default_wc()
        end
    end
    wc:activate_forklift_boxes(manny.is_driving)
    wc:set_up_actors()
    manny:set_collision_mode(COLLISION_SPHERE, 0.35)
    if manny.is_driving then
        manny.say_line = manny.forklift_say_line
        start_sfx("forkIdle.IMU")
    end
    single_start_script(de.forklift_actor.monitor_objects, de.forklift_actor)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(de.forklift_actor.hActor, 0)
    SetActorShadowPoint(de.forklift_actor.hActor, 0, 0, 6000)
    SetActorShadowPlane(de.forklift_actor.hActor, "shadow1")
    AddShadowPlane(de.forklift_actor.hActor, "shadow1")
end
wc.exit = function(arg1) -- line 190
    stop_sound("forkIdle.IMU")
    stop_sound("forkDriv.IMU")
    stop_sound("forkBkup.IMU")
    stop_sound("hkCaskRl.imu")
    manny:set_collision_mode(COLLISION_OFF)
    prop_forklift:free()
    stop_script(de.forklift_actor.monitor_objects)
    KillActorShadows(manny.hActor)
    KillActorShadows(de.forklift_actor.hActor)
end
wc.keg1 = Object:create(wc, "/wctx001/casks", 2.7376299, -3.98564, 3.1800001, { range = 0.60000002 })
wc.keg1.use_pnt_x = 2.4576299
wc.keg1.use_pnt_y = -3.05564
wc.keg1.use_pnt_z = 1.7
wc.keg1.use_rot_x = 0
wc.keg1.use_rot_y = -137.00999
wc.keg1.use_rot_z = 0
wc.keg1.lookAt = function(arg1) -- line 219
    manny:say_line("/wcma002/")
end
wc.keg1.pickUp = wc.keg1.lookAt
wc.keg1.use = wc.keg1.lookAt
wc.keg2 = Object:create(wc, "/wctx003/casks", 3.39763, -3.4256401, 3.1800001, { range = 0.60000002 })
wc.keg2.use_pnt_x = 2.4576299
wc.keg2.use_pnt_y = -3.05564
wc.keg2.use_pnt_z = 1.7
wc.keg2.use_rot_x = 0
wc.keg2.use_rot_y = -137.00999
wc.keg2.use_rot_z = 0
wc.keg2.parent = wc.keg1
wc.keg3 = Object:create(wc, "/wctx004/casks", 0.91763401, -3.2156401, 1.8200001, { range = 0.60000002 })
wc.keg3.use_pnt_x = 1.67123
wc.keg3.use_pnt_y = -2.9198501
wc.keg3.use_pnt_z = 1.7
wc.keg3.use_rot_x = 0
wc.keg3.use_rot_y = -231.541
wc.keg3.use_rot_z = 0
wc.keg3.parent = wc.keg1
wc.keg4 = Object:create(wc, "/wctx005/casks", 0.69763398, -2.4156401, 2.1600001, { range = 0.60000002 })
wc.keg4.use_pnt_x = 1.67123
wc.keg4.use_pnt_y = -2.9198501
wc.keg4.use_pnt_z = 1.7
wc.keg4.use_rot_x = 0
wc.keg4.use_rot_y = -231.541
wc.keg4.use_rot_z = 0
wc.keg4.parent = wc.keg1
wc.forklift = Object:create(wc, "/wctx006/forklift", 0.80051398, -2.07038, 0.36399999, { range = 1 })
wc.forklift.use_pnt_x = 1.37956
wc.forklift.use_pnt_y = -2.4616301
wc.forklift.use_pnt_z = 0
wc.forklift.use_rot_x = 0
wc.forklift.use_rot_y = 102
wc.forklift.use_rot_z = 0
wc.forklift.in_set = wc
wc.forklift.lookAt = function(arg1) -- line 266
    manny:say_line("/wcma007/")
end
wc.forklift.use = function(arg1) -- line 270
    start_script(de.forklift_actor.mount, de.forklift_actor)
end
wc.forklift.lower_blades = function(arg1) -- line 274
    de.forklift:lower_blades()
end
wc.forklift.raise_blades = function(arg1) -- line 278
    de.forklift:raise_blades()
end
wc.forklift.pickUp = function(arg1) -- line 282
    manny:say_line("/wcma008/")
end
wc.lever = Object:create(wc, "/wctx009/lever", 1.58596, -2.5836999, 2.0899999, { range = 0.80000001 })
wc.lever.use_pnt_x = 0.51390499
wc.lever.use_pnt_y = -2.29303
wc.lever.use_pnt_z = 0
wc.lever.use_rot_x = 0
wc.lever.use_rot_y = 281.76801
wc.lever.use_rot_z = 0
wc.lever.lookAt = function(arg1) -- line 295
    manny:say_line("/wcma010/")
end
wc.lever.use = function(arg1) -- line 299
    if de.forklift_actor.blades_up then
        wc.forklift:lower_blades()
    else
        wc.forklift:raise_blades()
    end
end
wc.de_door = Object:create(wc, "/wctx011/door", 1.61893, -0.304995, 1, { range = 0.60000002 })
wc.de_door.use_pnt_x = 1.31914
wc.de_door.use_pnt_y = -0.68162102
wc.de_door.use_pnt_z = 0
wc.de_door.use_rot_x = 0
wc.de_door.use_rot_y = 7.5090699
wc.de_door.use_rot_z = 0
wc.de_door.out_pnt_x = 1.27844
wc.de_door.out_pnt_y = 0.037629001
wc.de_door.out_pnt_z = 0
wc.de_door.out_rot_x = 0
wc.de_door.out_rot_y = 7.5090699
wc.de_door.out_rot_z = 0
wc.de_door.passage = { "wc_de_psg" }
wc.de_box = wc.de_door
wc.de_door.touchable = FALSE
wc.de_door.walkOut = function(arg1) -- line 333
    if manny.is_driving then
        start_script(wc.drive_out, wc)
    else
        wc.de_door:play_chore(wc_door_close)
        wc.de_door:wait_for_chore()
        wc.de_door:close()
        de:come_out_door(de.grating)
    end
end
wc.de_door.open = function(arg1) -- line 344
    local local1
    local1 = Object.open(arg1)
    if manny.is_driving then
        box_off("wc_de_psg")
    end
    return local1
end
wc.wc_de_trigger = { name = "wc_de_trigger" }
wc.wc_de_trigger.walkOut = function(arg1) -- line 356
    if not wc.de_door:is_open() then
        wc.de_door:play_chore(wc_door_open)
        wc.de_door:wait_for_chore()
        wc.de_door:open()
        de.grating:open()
    end
end
wc.fork_de_trigger = { name = "fork_de_trigger" }
wc.fork_de_trigger.walkOut = function(arg1) -- line 367
    if manny.is_driving then
        START_CUT_SCENE()
        wc.wc_de_trigger:walkOut()
        start_script(wc.drive_out, wc)
        END_CUT_SCENE()
    end
end

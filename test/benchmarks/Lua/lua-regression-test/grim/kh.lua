CheckFirstTime("kh.lua")
kh = Set:create("kh.set", "Kitty Hallway", { kh_estha = 0, kh_estha1 = 0, kh_estha2 = 0, kh_sansp = 1 })
kh.camerachange = function(arg1, arg2, arg3) -- line 19
    if arg3 == kh_sansp then
        music_state:set_state(stateKH_SANS)
    else
        music_state:set_state(stateKH)
    end
end
kh.enter = function(arg1) -- line 28
    start_script(tb.off_screen_kittys)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -2, 1.2, 3)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -0.4, -1.7, 2)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
end
kh.exit = function(arg1) -- line 45
    KillActorShadows(manny.hActor)
    stop_script(tb.off_screen_kittys)
end
kh.sanspoof = Object:create(kh, "/khtx014/stuffed cat", -1.80769, 1.11782, 1.4299999, { range = 2 })
kh.sanspoof.use_pnt_x = -1.50769
kh.sanspoof.use_pnt_y = 0.0278158
kh.sanspoof.use_pnt_z = 0
kh.sanspoof.use_rot_x = 0
kh.sanspoof.use_rot_y = -2.5418601
kh.sanspoof.use_rot_z = 0
kh.sanspoof.lookAt = function(arg1) -- line 60
    manny:say_line("/khma002/")
end
kh.sanspoof.pickUp = function(arg1) -- line 64
    system.default_response("dont need")
end
kh.sanspoof.use = function(arg1) -- line 68
    manny:say_line("/khma003/")
end
kh.plaque = Object:create(kh, "/khtx015/plaque", -1.53769, 0.277816, 0.46000001, { range = 0.60000002 })
kh.plaque.use_pnt_x = -1.50769
kh.plaque.use_pnt_y = 0.0278158
kh.plaque.use_pnt_z = 0
kh.plaque.use_rot_x = 0
kh.plaque.use_rot_y = -2.5418601
kh.plaque.use_rot_z = 0
kh.plaque.lookAt = function(arg1) -- line 81
    START_CUT_SCENE()
    kh:current_setup(kh_sansp)
    music_state:set_state(stateKH_SANS)
    manny:say_line("/khma005/")
    wait_for_message()
    manny:say_line("/khma006/")
    wait_for_message()
    manny:say_line("/khma007/")
    wait_for_message()
    manny:say_line("/khma008/")
    wait_for_message()
    manny:say_line("/khma009/")
    wait_for_message()
    manny:say_line("/khma016/")
    manny:wait_for_message()
    kh:current_setup(kh_estha)
    music_state:set_state(stateKH)
    END_CUT_SCENE()
end
kh.plaque.pickUp = function(arg1) -- line 104
    system.default_response("attached")
end
kh.plaque.use = kh.plaque.lookAt
kh.stable_door1 = Object:create(kh, "/khtx010/door", 0, 0, 0, { range = 0 })
kh.stable_door1.lookAt = function(arg1) -- line 118
    manny:say_line("/khma011/")
end
kh.stable_door1.walkOut = function(arg1) -- line 122
    system.default_response("locked")
end
kh.ks_door = Object:create(kh, "door", -3.6500001, 0.062084101, 0, { range = 0 })
kh.ks_door.use_pnt_x = -0.484523
kh.ks_door.use_pnt_y = -1.12301
kh.ks_door.use_pnt_z = 0
kh.ks_door.use_rot_x = 0
kh.ks_door.use_rot_y = 181.105
kh.ks_door.use_rot_z = 0
kh.ks_door.out_pnt_x = -0.47855401
kh.ks_door.out_pnt_y = -1.4325
kh.ks_door.out_pnt_z = 0
kh.ks_door.out_rot_x = 0
kh.ks_door.out_rot_y = 181.105
kh.ks_door.out_rot_z = 0
kh.ks_box = kh.ks_door
kh.ks_door.lookAt = function(arg1) -- line 145
    manny:say_line("/khma012/")
end
kh.ks_door.walkOut = function(arg1) -- line 149
    ks:come_out_door(ks.kh_door)
end
kh.ts_door = Object:create(kh, "door", 0.125, -0.125, 0, { range = 0 })
kh.ts_door.use_pnt_x = -3.6500001
kh.ts_door.use_pnt_y = 0.062084101
kh.ts_door.use_pnt_z = 0
kh.ts_door.use_rot_x = 0
kh.ts_door.use_rot_y = -270.923
kh.ts_door.use_rot_z = 0
kh.ts_door.out_pnt_x = -3.6500001
kh.ts_door.out_pnt_y = 0.062084101
kh.ts_door.out_pnt_z = 0
kh.ts_door.out_rot_x = 0
kh.ts_door.out_rot_y = -270.923
kh.ts_door.out_rot_z = 0
kh.ts_box = kh.ts_door
kh.ts_door.lookAt = function(arg1) -- line 170
    manny:say_line("/khma013/")
end
kh.ts_door.walkOut = function(arg1) -- line 173
    ts:come_out_door(ts.kh_door)
end

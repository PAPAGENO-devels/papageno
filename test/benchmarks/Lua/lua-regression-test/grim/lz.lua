CheckFirstTime("lz.lua")
lz = Set:create("lz.set", "lola zapata", { lz_top = 0, lz_intha = 1, lz_dorcu = 2 })
lz.call_count = 0
lz.call_down_pipe = function(arg1) -- line 14
    lz.call_count = lz.call_count + 1
    system_prefs:set_voice_effect("Basic Reverb")
    break_here()
    if lz.call_count == 1 then
        manny:say_line("/lzma001/")
        wait_for_message()
        sleep_for(1000)
        system_prefs:set_voice_effect("OFF")
        manny:say_line("/lzma002/")
    elseif lz.call_count == 2 then
        manny:say_line("/lzma003/")
    elseif lz.call_count == 3 then
        manny:say_line("/lzma004/")
    elseif lz.call_count == 4 then
        manny:say_line("/lzma005/")
    elseif lz.call_count == 5 then
        manny:say_line("/lzma006/")
    elseif lz.call_count == 6 then
        manny:say_line("/lzma007/")
    elseif lz.call_count == 7 then
        manny:say_line("/lzma008/")
    else
        manny:say_line("/lzma009/")
    end
    manny:wait_for_message()
    system_prefs:set_voice_effect("OFF")
end
lz.enter = function(arg1) -- line 69
    lz:current_setup(lz_intha)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -1000, -800, 1000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -1000, -800, 1000)
    SetActorShadowPlane(manny.hActor, "shadow_slant")
    AddShadowPlane(manny.hActor, "shadow_slant")
    AddShadowPlane(manny.hActor, "shadow_slant1")
end
lz.camerachange = function(arg1, arg2, arg3) -- line 90
    if arg3 == lz_intha then
        StartMovie("lz.snm", TRUE, 0, 170)
    else
        StopMovie()
    end
end
lz.exit = function(arg1) -- line 98
    StopMovie()
    KillActorShadows(manny.hActor)
end
lz.port_pipe = Object:create(lz, "vent", 5.13587, 3.31918, 2.76, { range = 0.89999998 })
lz.port_pipe.use_pnt_x = 5.0358701
lz.port_pipe.use_pnt_y = 2.9891801
lz.port_pipe.use_pnt_z = 2.23
lz.port_pipe.use_rot_x = 0
lz.port_pipe.use_rot_y = 2502.5801
lz.port_pipe.use_rot_z = 0
lz.port_pipe.lookAt = function(arg1) -- line 118
    manny:say_line("/lzma010/")
end
lz.port_pipe.pickUp = function(arg1) -- line 122
    system.default_response("attached")
end
lz.port_pipe.use = function(arg1) -- line 126
    if manny:walkto(arg1) then
        lz:call_down_pipe()
    end
end
lz.starboard_pipe1 = Object:create(lz, "vent", 1.77544, 3.3091099, 2.77, { range = 0.89999998 })
lz.starboard_pipe1.use_pnt_x = 1.77544
lz.starboard_pipe1.use_pnt_y = 2.8891101
lz.starboard_pipe1.use_pnt_z = 2.23
lz.starboard_pipe1.use_rot_x = 0
lz.starboard_pipe1.use_rot_y = 2886.77
lz.starboard_pipe1.use_rot_z = 0
lz.starboard_pipe1.parent = lz.port_pipe
lz.starboard_pipe2 = Object:create(lz, "vent", 1.8003401, 5.5474801, 2.8399999, { range = 0.89999998 })
lz.starboard_pipe2.use_pnt_x = 1.66034
lz.starboard_pipe2.use_pnt_y = 5.2174802
lz.starboard_pipe2.use_pnt_z = 2.23
lz.starboard_pipe2.use_rot_x = 0
lz.starboard_pipe2.use_rot_y = 2890.72
lz.starboard_pipe2.use_rot_z = 0
lz.starboard_pipe2.parent = lz.port_pipe
lz.cleat1 = Object:create(lz, "cleat", 1.64306, 0.26737201, 2.6500001, { range = 1 })
lz.cleat1.use_pnt_x = 2.08306
lz.cleat1.use_pnt_y = -0.36262801
lz.cleat1.use_pnt_z = 2.23
lz.cleat1.use_rot_x = 0
lz.cleat1.use_rot_y = 2641.4199
lz.cleat1.use_rot_z = 0
lz.cleat1.lookAt = function(arg1) -- line 163
    soft_script()
    manny:say_line("/lzma011/")
    wait_for_message()
    manny:say_line("/lzma012/")
    wait_for_message()
    manny:say_line("/lzma013/")
end
lz.cleat1.use = function(arg1) -- line 172
    manny:say_line("/lzma014/")
end
lz.cleat1.pickUp = lz.cleat1.use
lz.cleat2 = Object:create(lz, "cleat", 1.96306, -1.1926301, 2.51, { range = 1 })
lz.cleat2.use_pnt_x = 2.08306
lz.cleat2.use_pnt_y = -0.36262801
lz.cleat2.use_pnt_z = 2.23
lz.cleat2.use_rot_x = 0
lz.cleat2.use_rot_y = 2641.4199
lz.cleat2.use_rot_z = 0
lz.cleat2.parent = lz.cleat1
lz.il_door = Object:create(lz, "door", 2.7634599, 6.99156, 3.6600001, { range = 0 })
lz.il_door.use_pnt_x = 2.7634599
lz.il_door.use_pnt_y = 6.99156
lz.il_door.use_pnt_z = 3.6600001
lz.il_door.use_rot_x = 0
lz.il_door.use_rot_y = -84.268204
lz.il_door.use_rot_z = 0
lz.il_door.out_pnt_x = 2.7634599
lz.il_door.out_pnt_y = 6.99156
lz.il_door.out_pnt_z = 3.6600001
lz.il_door.out_rot_x = 0
lz.il_door.out_rot_y = -84.268204
lz.il_door.out_rot_z = 0
lz.il_box = lz.il_door
lz.il_door.walkOut = function(arg1) -- line 209
    il:come_out_door(il.lz_door)
end

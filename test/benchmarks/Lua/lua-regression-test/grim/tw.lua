CheckFirstTime("tw.lua")
tw = Set:create("tw.set", "track window", { tw_trkvw = 0, tw_overhead = 1 })
tw.enter = function(arg1) -- line 18
    start_script(tb.off_screen_kittys)
end
tw.exit = function(arg1) -- line 22
    stop_script(tb.off_screen_kittys)
end
tw.track = Object:create(tw, "track", 1.48673, -0.12816, 0, { range = 1.5 })
tw.track.use_pnt_x = 1.11973
tw.track.use_pnt_y = -0.047159601
tw.track.use_pnt_z = 0
tw.track.use_rot_x = 0
tw.track.use_rot_y = -86.362198
tw.track.use_rot_z = 0
tw.track.lookAt = function(arg1) -- line 40
    manny:say_line("/tbma054/")
    manny:nod_head_gesture()
end
tw.track.use = function(arg1) -- line 45
    manny:say_line("/slma243/")
end
tw.tb_door = Object:create(tw, "/twtx001/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tw.tb_door.use_pnt_x = 0
tw.tb_door.use_pnt_y = 0
tw.tb_door.use_pnt_z = 0
tw.tb_door.use_rot_x = 0
tw.tb_door.use_rot_y = 0
tw.tb_door.use_rot_z = 0
tw.tb_door.out_pnt_x = 0
tw.tb_door.out_pnt_y = 0
tw.tb_door.out_pnt_z = 0
tw.tb_door.out_rot_x = 0
tw.tb_door.out_rot_y = 0
tw.tb_door.out_rot_z = 0
tw.tb1_box = tw.tb_door
tw.tb_door.walkOut = function(arg1) -- line 74
    local local1, local2, local3
    START_CUT_SCENE()
    local1, local2, local3 = GetActorPos(system.currentActor.hActor)
    tb:switch_to_set()
    tb:current_setup(tb_strws)
    PutActorInSet(system.currentActor.hActor, tb.setFile)
    manny:setpos(0.76057202, 0.74956697, 0)
    END_CUT_SCENE()
end
tw.tb1_door = Object:create(tw, "/twtx002/door", -4.0999999, 0, 1.8, { range = 0.60000002 })
tw.tb1_door.use_pnt_x = 0
tw.tb1_door.use_pnt_y = 0
tw.tb1_door.use_pnt_z = 0
tw.tb1_door.use_rot_x = 0
tw.tb1_door.use_rot_y = 0
tw.tb1_door.use_rot_z = 0
tw.tb1_door.out_pnt_x = 0
tw.tb1_door.out_pnt_y = 0
tw.tb1_door.out_pnt_z = 0
tw.tb1_door.out_rot_x = 0
tw.tb1_door.out_rot_y = 0
tw.tb1_door.out_rot_z = 0
tw.tb2_box = tw.tb1_door
tw.tb1_door.walkOut = function(arg1) -- line 102
    START_CUT_SCENE()
    tb:switch_to_set()
    tb:current_setup(tb_fotws)
    PutActorInSet(system.currentActor.hActor, tb.setFile)
    manny:setpos(0.777762, -0.786979, 0)
    END_CUT_SCENE()
end

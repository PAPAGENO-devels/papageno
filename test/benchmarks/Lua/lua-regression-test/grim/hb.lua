CheckFirstTime("hb.lua")
hb = Set:create("hb.set", "temp hub room", { na_top = 0, na_intha = 1, na_intws = 2 })
hb.enter = function(arg1) -- line 18
    start_script(foghorn_sfx)
    hb:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    StartMovie("hb.snm", TRUE, 0, 0)
end
hb.exit = function(arg1) -- line 24
    StopMovie()
    stop_script(foghorn_sfx)
end
hb.dd_door = Object:create(hb, "/hbtx001/door", -0.131596, -4.20928, 1.1, { range = 0.60000002 })
hb.dd_door.use_pnt_x = -2.7476599
hb.dd_door.use_pnt_y = 1.88727
hb.dd_door.use_pnt_z = 1.258
hb.dd_door.use_rot_x = 0
hb.dd_door.use_rot_y = -1008.75
hb.dd_door.use_rot_z = 0
hb.dd_door.out_pnt_x = -3.12497
hb.dd_door.out_pnt_y = 2.0151701
hb.dd_door.out_pnt_z = 1.258
hb.dd_door.out_rot_x = 0
hb.dd_door.out_rot_y = -1008.75
hb.dd_door.out_rot_z = 0
hb.dd_box = hb.dd_door
hb.dd_door:make_untouchable()
hb.dd_door.walkOut = function(arg1) -- line 58
    dd:come_out_door(dd.hb_door)
end
hb.bw_door = Object:create(hb, "/hbtx002/door", 0.76840401, 3.99072, 1.7, { range = 0.60000002 })
hb.bw_door.use_pnt_x = 0.659536
hb.bw_door.use_pnt_y = 3.3587201
hb.bw_door.use_pnt_z = 1.258
hb.bw_door.use_rot_x = 0
hb.bw_door.use_rot_y = -1093.17
hb.bw_door.use_rot_z = 0
hb.bw_door.out_pnt_x = 0.75928998
hb.bw_door.out_pnt_y = 3.78582
hb.bw_door.out_pnt_z = 1.258
hb.bw_door.out_rot_x = 0
hb.bw_door.out_rot_y = -1093.17
hb.bw_door.out_rot_z = 0
hb.bw_box = hb.bw_door
hb.bw_door:make_untouchable()
hb.bw_door.walkOut = function(arg1) -- line 81
    bw:come_out_door(bw.hb_door)
end
hb.xb_door = Object:create(hb, "/hbtx003/door", -3.1315999, 2.1907201, 1.5, { range = 0.60000002 })
hb.xb_door.use_pnt_x = -0.069325402
hb.xb_door.use_pnt_y = -3.2717299
hb.xb_door.use_pnt_z = 0.815
hb.xb_door.use_rot_x = 0
hb.xb_door.use_rot_y = -887.39502
hb.xb_door.use_rot_z = 0
hb.xb_door.out_pnt_x = 0.0077585201
hb.xb_door.out_pnt_y = -3.61642
hb.xb_door.out_pnt_z = 0.815
hb.xb_door.out_rot_x = 0
hb.xb_door.out_rot_y = -887.39502
hb.xb_door.out_rot_z = 0
hb.xb_box = hb.xb_door
hb.xb_door:make_untouchable()
hb.xb_door.walkOut = function(arg1) -- line 105
    xb:come_out_door(xb.hb_door)
end
hb.lm_door = Object:create(hb, "/hbtx004/door", 3.3684001, -0.0092823096, 0.89999998, { range = 0.60000002 })
hb.lm_door.use_pnt_x = 2.7368801
hb.lm_door.use_pnt_y = -0.0227677
hb.lm_door.use_pnt_z = 0.815
hb.lm_door.use_rot_x = 0
hb.lm_door.use_rot_y = -1162.86
hb.lm_door.use_rot_z = 0
hb.lm_door.out_pnt_x = 3.2635601
hb.lm_door.out_pnt_y = 0.043249998
hb.lm_door.out_pnt_z = 0.815
hb.lm_door.out_rot_x = 0
hb.lm_door.out_rot_y = -1162.86
hb.lm_door.out_rot_z = 0
hb.lm_box = hb.lm_door
hb.lm_door:make_untouchable()
hb.lm_door.walkOut = function(arg1) -- line 128
    lm:come_out_door(lm.hb_door)
    if in_year_four and not lm.velasco_gone then
        start_script(lm.reunion)
    end
end

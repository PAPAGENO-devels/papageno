CheckFirstTime("ea.lua")
dofile("ea_door.lua")
ea = Set:create("ea.set", "exterior airlock", { ea_widha = 0, ea_ovrhd = 1 })
ea.cheat_boxes = { pole_cheat = 0 }
ea.arrive = function() -- line 16
    START_CUT_SCENE()
    ew:switch_to_set()
    sleep_for(5000)
    mn:switch_to_set()
    play_movie("mn_sub.snm", 107, 0)
    wait_for_movie()
    sleep_for(1000)
    ea:switch_to_set()
    play_movie("ea_sub.snm", 0, 128)
    wait_for_movie()
    manny:put_in_set(ea)
    manny:ignore_boxes()
    glottis:default("sailor")
    glottis:put_in_set(ea)
    manny:push_costume("mn_jump_sub.cos")
    manny:set_softimage_pos(-3.2175, -0.0112, 98.4986)
    manny:setrot(0, -74.461, 0)
    glottis:push_costume("gl_jump_sub.cos")
    glottis:set_softimage_pos(7.1378, 0, 99.9097)
    glottis:setrot(0, 2.527, 0)
    start_sfx("current.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("current.IMU", 1000, 127)
    manny:play_chore(0, "mn_jump_sub.cos")
    glottis:play_chore(0, "gl_jump_sub.cos")
    sleep_for(6000)
    fade_sfx("current.IMU", 500, 0)
    manny:wait_for_chore(0, "mn_jump_sub.cos")
    manny:pop_costume()
    glottis:say_line("/eagl001/")
    wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/eama002/")
    wait_for_message()
    glottis:wait_for_chore(0, "gl_jump_sub.cos")
    glottis:pop_costume()
    manny:follow_boxes()
    ea.glottis_obj.touchable = TRUE
    END_CUT_SCENE()
end
ea.set_up_actors = function() -- line 63
    if not dr.reunited then
        if not find_script(ea.arrive) and not find_script(cut_scene.subjacked) then
            glottis:default("sailor")
            glottis:put_in_set(ea)
            glottis:set_softimage_pos(7.1378, 0, 99.9097)
            glottis:setrot(0, 2.527, 0)
        end
        ea.glottis_obj:make_touchable()
    else
        glottis:put_in_set(nil)
        ea.glottis_obj:make_untouchable()
    end
end
ea.enter = function(arg1) -- line 84
    ea.fh_door.hObjectState = ea:add_object_state(ea_widha, "ea_door.bm", nil, OBJSTATE_UNDERLAY)
    ea.fh_door:set_object_state("ea_door.cos")
    start_script(ea.set_up_actors)
    ea:add_ambient_sfx(underwater_ambience_list, underwater_ambience_parm_list)
end
ea.exit = function(arg1) -- line 93
    glottis:free()
    stop_sound("bubvox.imu")
end
ea.darkness1 = { }
ea.darkness2 = ea.darkness1
ea.darkness1.walkOut = function(arg1) -- line 108
    manny:say_line("/eama003/")
end
ea.glottis_obj = Object:create(ea, "/eatx004/Glottis", 0.68710399, -10.0523, 0.72960001, { range = 1 })
ea.glottis_obj.use_pnt_x = 0.32505101
ea.glottis_obj.use_pnt_y = -9.4310799
ea.glottis_obj.use_pnt_z = 0
ea.glottis_obj.use_rot_x = 0
ea.glottis_obj.use_rot_y = 206.12399
ea.glottis_obj.use_rot_z = 0
ea.glottis_obj.touchable = FALSE
ea.glottis_obj.lookAt = function(arg1) -- line 124
    manny:say_line("/eama005/")
end
ea.glottis_obj.pickUp = function(arg1) -- line 128
    system.default_response("underwater")
end
ea.glottis_obj.use = function(arg1) -- line 132
    START_CUT_SCENE()
    manny:say_line("/eama006/")
    wait_for_message()
    glottis:say_line("/eagl007/")
    wait_for_message()
    glottis:say_line("/eagl008/")
    END_CUT_SCENE()
end
ea.mn_door = Object:create(ea, "/eatx009/lit pathway", -2.69999, -9.8492899, 0.51999998, { range = 1 })
ea.mn_door.use_pnt_x = -2.3099899
ea.mn_door.use_pnt_y = -9.7892904
ea.mn_door.use_pnt_z = 0
ea.mn_door.use_rot_x = 0
ea.mn_door.use_rot_y = 119.254
ea.mn_door.use_rot_z = 0
ea.mn_door.out_pnt_x = -2.5891199
ea.mn_door.out_pnt_y = -9.9456701
ea.mn_door.out_pnt_z = 0
ea.mn_door.out_rot_x = 0
ea.mn_door.out_rot_y = 119.254
ea.mn_door.out_rot_z = 0
ea.mn_box = ea.mn_door
ea.mn_door.lookAt = function(arg1) -- line 165
    manny:say_line("/eama010/")
end
ea.mn_door.walkOut = function(arg1) -- line 169
    mn:come_out_door(mn.ea_door)
end
ea.cy_door = Object:create(ea, "lit pathway", 5.0538101, -3.96085, 0.51999998, { range = 1.5 })
ea.cy_door.use_pnt_x = 5.1205502
ea.cy_door.use_pnt_y = -3.6636901
ea.cy_door.use_pnt_z = 0
ea.cy_door.use_rot_x = 0
ea.cy_door.use_rot_y = 312.728
ea.cy_door.use_rot_z = 0
ea.cy_door.out_pnt_x = 5.5071602
ea.cy_door.out_pnt_y = -3.30352
ea.cy_door.out_pnt_z = 0
ea.cy_door.out_rot_x = 0
ea.cy_door.out_rot_y = 311.811
ea.cy_door.out_rot_z = 0
ea.cy_box = ea.cy_door
ea.cy_door.lookAt = function(arg1) -- line 190
    manny:say_line("/eama011/")
end
ea.cy_door.walkOut = function(arg1) -- line 194
    cy:come_out_door(cy.ea_door)
end
ea.fh_door = Object:create(ea, "/eatx018/door", 0.075093001, -2.7922699, 0.46059999, { range = 0.60000002 })
ea.fh_door.use_pnt_x = -0.033969998
ea.fh_door.use_pnt_y = -3.7019999
ea.fh_door.use_pnt_z = 0
ea.fh_door.use_rot_x = 0
ea.fh_door.use_rot_y = 0
ea.fh_door.use_rot_z = 0
ea.fh_door.out_pnt_x = -0.0350269
ea.fh_door.out_pnt_y = -2.825
ea.fh_door.out_pnt_z = 0
ea.fh_door.out_rot_x = 0
ea.fh_door.out_rot_y = 0
ea.fh_door.out_rot_z = 0
ea.fh_box = ea.fh_door
ea.fh_box.passage = { "fh_psg" }
ea.fh_door.walkOut = function(arg1) -- line 218
    if not fh.been_there then
        START_CUT_SCENE()
        set_override(ea.fh_door.skipWalkOut, ea.fh_door)
        manny:face_entity(ea.glottis_obj)
        manny:head_look_at(ea.glottis_obj)
        manny:say_line("/eama012/")
        manny:wait_for_message()
        glottis:say_line("/eagl013/")
        glottis:wait_for_message()
        manny:say_line("/eama014/")
        manny:wait_for_message()
        manny:setrot(arg1.out_rot_x, arg1.out_rot_y, arg1.out_rot_z, TRUE)
        glottis:say_line("/eagl015/")
        glottis:wait_for_message()
        glottis:say_line("/eagl016/")
        glottis:wait_for_message()
        END_CUT_SCENE()
    end
    START_CUT_SCENE()
    set_override(ea.fh_door.skipWalkOut, ea.fh_door)
    manny:clear_hands()
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    ea.fh_door:close()
    END_CUT_SCENE()
    fh:come_out_door(fh.ea_door)
end
ea.fh_door.skipWalkOut = function(arg1) -- line 249
    kill_override()
    manny:clear_hands()
    ea.fh_door:close()
    fh:come_out_door(fh.ea_door)
end
ea.fh_door.lookAt = function(arg1) -- line 256
    manny:say_line("/eama017/")
end
ea.fh_door.comeOut = function(arg1) -- line 260
    START_CUT_SCENE()
    arg1:open()
    arg1:complete_chore(ea_door_set_open)
    manny:put_in_set(ea)
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    END_CUT_SCENE()
end
ea.fh_trigger = { }
ea.fh_trigger.walkOut = function(arg1) -- line 274
    if not ea.fh_door.opened then
        start_sfx("eadoorop.wav")
        ea.fh_door:play_chore(ea_door_open)
        ea.fh_door:wait_for_chore(ea_door_open)
        ea.fh_door:open()
    end
    start_script(ea.fh_trigger.wait_to_close)
end
ea.fh_trigger.wait_to_close = function(arg1) -- line 284
    while system.currentSet == ea and manny:find_sector_name("fh_trigger") do
        break_here()
    end
    if system.currentSet == ea then
        if not manny:find_sector_name("to_airlock") then
            ea.fh_door:close()
            start_sfx("eadoorcl.wav")
            ea.fh_door:play_chore(ea_door_close)
            ea.fh_door:wait_for_chore(ea_door_close)
        end
    end
end

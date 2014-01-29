CheckFirstTime("cu.lua")
cu = Set:create("cu.set", "crane crusher", { cu_crust = 0, cu_overhead = 1 })
cu.music_counter = 0
cu.spill_chain = function(arg1) -- line 14
    ew.crane_down = TRUE
    if not crusher_free then
        START_CUT_SCENE()
        set_override(cu.skip_spill_chain, cu)
        cu:switch_to_set()
        cu.crusher:play_chore(1)
        stop_sound("custrain.IMU")
        play_movie("cu_tg.snm", 198, 0)
        wait_for_movie()
        END_CUT_SCENE()
        ew:switch_to_set()
    else
        start_sfx("cuChnMt.WAV")
        sleep_for(500)
    end
end
cu.skip_spill_chain = function(arg1) -- line 33
    kill_override()
    ew:switch_to_set()
end
cu.free_crusher = function(arg1) -- line 38
    ew.crane_down = FALSE
    if not crusher_free then
        START_CUT_SCENE()
        cu:switch_to_set()
        stop_sound("custrain.IMU")
        stop_sound("cu_cy.IMU")
        play_movie("cu_rp.snm", 0, 0)
        wait_for_movie()
        END_CUT_SCENE()
        crusher_free = TRUE
        bu.fallen_crusher:make_touchable()
        cu.crusher:make_untouchable()
        if raised_lamancha then
            ew:exit_crane(TRUE)
            start_script(bu.thatll_do)
        else
            ew:switch_to_set()
        end
    else
        start_sfx("cuChnMt.WAV")
        sleep_for(500)
    end
end
cu.exit_crane = function(arg1) -- line 63
    cutSceneLevel = 0
    cu:switch_to_set()
    manny:put_in_set(cu)
    manny:setpos(-4.98284, -9.74319, 8.69)
    manny:setrot(0, 277.679, 0)
    manny:walkto(-1.71286, -9.79415, 8.69)
    manny:wait_for_actor()
end
cu.update_music_state = function(arg1) -- line 78
    if cu.music_counter > 2 then
        return stateCUV_LATER
    else
        return stateCU
    end
end
cu.enter = function(arg1) -- line 86
    cu:add_object_state(cu_crust, "cu_tg.bm", nil, OBJSTATE_UNDERLAY)
    cu.crusher:set_object_state("cu_tg.cos")
    if ew.crane_down and ew.crane_pos == ew.at_crusher and not crusher_free and ew.crane_broken then
        cu.crusher:play_chore(0)
        start_sfx("custrain.IMU")
    elseif not crusher_free and cu.crusher.touchable then
        play_movie_looping("cu_cy.snm", 198, 254)
        start_sfx("cu_cy.IMU", nil, 80)
    end
    ew.crane_actor.cur_point = ew.at_crusher
    cu.music_counter = cu.music_counter + 1
end
cu.exit = function(arg1) -- line 103
    stop_sound("custrain.IMU")
    stop_sound("cu_cy.IMU")
    StopMovie()
end
cu.crane = Object:create(cu, "/cutx001/crane", -1.54735, -7.35425, 9.4499998, { range = 4 })
cu.crane.use_pnt_x = -1.54735
cu.crane.use_pnt_y = -9.6642504
cu.crane.use_pnt_z = 6.8299999
cu.crane.use_rot_x = 0
cu.crane.use_rot_y = 376.767
cu.crane.use_rot_z = 0
cu.crane.lookAt = function(arg1) -- line 122
    cv.crane:lookAt()
end
cu.crane.pickUp = function(arg1) -- line 126
    cv.crane:pickUp()
end
cu.crane.use = function(arg1) -- line 130
    ew.crane_pos = ew.at_crusher
    start_script(ew.operate_crane)
end
cu.crusher = Object:create(cu, "/cutx002/coral crusher", 0.0127845, -11.5118, 6.3621202, { range = 2.5 })
cu.crusher.use_pnt_x = -1.63002
cu.crusher.use_pnt_y = -11.6002
cu.crusher.use_pnt_z = 6.18189
cu.crusher.use_rot_x = 0
cu.crusher.use_rot_y = -114.906
cu.crusher.use_rot_z = 0
cu.crusher.lookAt = function(arg1) -- line 143
    soft_script()
    if bl.talked_reef then
        manny:say_line("/cuma003/")
        wait_for_message()
        manny:say_line("/cuma004/")
    else
        manny:say_line("/cuma005/")
        wait_for_message()
        manny:say_line("/cuma006/")
    end
end
cu.crusher.pickUp = function(arg1) -- line 156
    manny:say_line("/cuma007/")
end
cu.crusher.use = function(arg1) -- line 160
    manny:say_line("/cuma008/")
    wait_for_message()
    manny:say_line("/cuma009/")
end
cu.ew_door = Object:create(cu, "/cutx010/cabin", -5.5131302, -8.3999996, 10.04, { range = 2 })
cu.ew_door.use_pnt_x = -5.5131302
cu.ew_door.use_pnt_y = -8.3999996
cu.ew_door.use_pnt_z = 10.04
cu.ew_door.use_rot_x = 0
cu.ew_door.use_rot_y = 6.4301
cu.ew_door.use_rot_z = 0
cu.crane_box = cu.ew_door
cu.ew_door.walkOut = function(arg1) -- line 182
    ew.crane_pos = ew.at_crusher
    start_script(ew.operate_crane, ew)
end
cu.ew_door.lookAt = function(arg1) -- line 187
    cv.ew_door:lookAt()
end
cu.crane_trigger = { name = "crane trigger" }
cu.crane_trigger.walkOut = function(arg1) -- line 192
    if ew.used_crane then
        cu.ew_door:walkOut()
    end
end
cu.bu_door1 = Object:create(cu, "/cutx011/ramp", -2.2880299, -12.625, 5.75, { range = 1 })
cu.bu_door1.use_pnt_x = -1.79335
cu.bu_door1.use_pnt_y = -12.9701
cu.bu_door1.use_pnt_z = 7.00879
cu.bu_door1.use_rot_x = 0
cu.bu_door1.use_rot_y = 180.314
cu.bu_door1.use_rot_z = 0
cu.bu_box1 = cu.bu_door1
cu.bu_door1.lookAt = function(arg1) -- line 209
    manny:say_line("/cuma012/")
end
cu.bu_door1.walkOut = function(arg1) -- line 213
    bu:come_out_door(bu.cu_door1)
end
cu.bu_door2 = Object:create(cu, "/cutx013/ramp", 2.2743299, -12.625, 5.75, { range = 1 })
cu.bu_door2.use_pnt_x = 2.2743299
cu.bu_door2.use_pnt_y = -12.625
cu.bu_door2.use_pnt_z = 5.75
cu.bu_door2.use_rot_x = 0
cu.bu_door2.use_rot_y = 176.785
cu.bu_door2.use_rot_z = 0
cu.bu_box2 = cu.bu_door2
cu.bu_door2.lookAt = cu.bu_door1.lookAt
cu.bu_door2.walkOut = function(arg1) -- line 229
    bu:come_out_door(bu.cu_door2)
end

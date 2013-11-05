CheckFirstTime("pi.lua")
pi = Set:create("pi.set", "police interior", { pi_jalws = 0, pi_ovrhd = 1 })
pi.shrinkable = 0.12
pi.talk_to_terry = function() -- line 13
    START_CUT_SCENE()
    start_script(pi.terry_stop_pace, pi)
    if not pi.talked_to_terry then
        pi.talked_to_terry = TRUE
        manny:say_line("/pima002/")
        wait_for_message()
        terry:say_line("/pite003/")
        wait_for_message()
        manny:say_line("/pima004/")
        wait_for_message()
        terry:say_line("/pite005/")
    else
        manny:say_line("/pima006/")
        wait_for_message()
        terry:say_line("/pite007/")
        wait_for_message()
        terry:say_line("/pite008/")
        wait_for_message()
        terry:say_line("/pite009/")
        wait_for_message()
        manny:say_line("/pima010/")
    end
    start_script(pi.terry_pace, pi, TRUE)
    END_CUT_SCENE()
end
pi.pace_point = { }
pi.pace_point[0] = { x = 0.191954, y = 1.80075, z = 0.21600001, pitch = 0, yaw = 120, roll = 0 }
pi.pace_point[1] = { x = -0.938546, y = 1.13415, z = 0.21600001, pitch = 0, yaw = 300, roll = 0 }
pi.terry_pace = function(arg1, arg2) -- line 44
    local local1, local2, local3, local4
    local1 = 1
    single_start_sfx("beewing.imu")
    if not arg2 then
        terry:default("pace")
        terry:put_in_set(pi)
        start_script(terry.start_pace, terry)
        terry:setpos(pi.pace_point[0].x, pi.pace_point[0].y, pi.pace_point[0].z)
        terry:setrot(pi.pace_point[0].pitch, pi.pace_point[0].yaw, pi.pace_point[0].roll)
        start_script(terry.fake_hover, terry)
    else
        local3 = proximity(terry.hActor, pi.pace_point[0].x, pi.pace_point[0].y, pi.pace_point[0].z)
        local4 = proximity(terry.hActor, pi.pace_point[1].x, pi.pace_point[1].y, pi.pace_point[1].z)
        if local3 > local4 then
            local1 = 0
        else
            local1 = 1
        end
        terry:stop_chore(tm_pace_pace_no_scratch, "tm_pace.cos")
        terry:run_chore(tm_pace_start_scratch, "tm_pace.cos")
        terry:play_chore_looping(tm_pace_pace, "tm_pace.cos")
        local3 = GetActorYawToPoint(terry.hActor, pi.pace_point[local1])
        terry:setrot(0, local3, 0, TRUE)
        terry:wait_for_actor()
        local2 = terry:getpos()
        while local2.x > pi.pace_point[0].x or local2.x < pi.pace_point[1].x do
            WalkActorForward(terry.hActor)
            break_here()
            local2 = terry:getpos()
        end
    end
    while TRUE do
        local2 = terry:getpos()
        while local2.x <= pi.pace_point[0].x and local2.x >= pi.pace_point[1].x do
            WalkActorForward(terry.hActor)
            break_here()
            local2 = terry:getpos()
            pi.terry_obj.interest_actor:setpos(local2.x, local2.y, local2.z + 0.30000001)
            if hot_object == pi.terry_obj then
                manny:head_look_at(pi.terry_obj)
            end
        end
        terry:setrot(0, pi.pace_point[local1].yaw, 0, TRUE)
        terry:wait_for_actor()
        local1 = 1 - local1
        while local2.x > pi.pace_point[0].x or local2.x < pi.pace_point[1].x do
            WalkActorForward(terry.hActor)
            break_here()
            local2 = terry:getpos()
            pi.terry_obj.interest_actor:setpos(local2.x, local2.y, local2.z + 0.30000001)
            if hot_object == pi.terry_obj then
                manny:head_look_at(pi.terry_obj)
            end
        end
    end
end
pi.terry_stop_pace = function(arg1) -- line 105
    local local1, local2, local3
    local1 = manny:getpos()
    local2 = terry:getpos()
    stop_script(pi.terry_pace)
    terry:wait_for_actor()
    local3 = GetActorYawToPoint(terry.hActor, local1)
    terry:setrot(0, local3, 0, TRUE)
    terry:wait_for_actor()
    terry:run_chore(tm_pace_stop_scratch, "tm_pace.cos")
    terry:play_chore_looping(tm_pace_pace_no_scratch, "tm_pace.cos")
    terry:stop_chore(tm_pace_pace, "tm_pace.cos")
end
pi.set_up_actors = function(arg1) -- line 122
    if dd.terry_arrested and not dd.strike_on then
        pi.cell:make_untouchable()
        pi.terry_obj:make_touchable()
        start_script(pi.terry_pace, pi)
    else
        pi.cell:make_touchable()
        pi.terry_obj:make_untouchable()
    end
end
pi.enter = function(arg1) -- line 139
    pi:set_up_actors()
    SetShadowColor(5, 5, 5)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.7, 0.7, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
pi.exit = function(arg1) -- line 151
    stop_sound("beewing.imu")
    if dd.terry_arrested and not dd.strike_on then
        stop_script(pi.terry_pace)
        terry:free()
    end
    KillActorShadows(manny.hActor)
end
pi.update_music_state = function(arg1) -- line 161
    if dd.terry_arrested and not dd.strike_on then
        return statePI_MALLOY
    else
        return statePI
    end
end
pi.posters = Object:create(pi, "/pitx011/posters", -0.93506902, 0.373602, 0.49000001, { range = 0.60000002 })
pi.posters.use_pnt_x = -0.775069
pi.posters.use_pnt_y = 0.443602
pi.posters.use_pnt_z = 0
pi.posters.use_rot_x = 0
pi.posters.use_rot_y = -221.761
pi.posters.use_rot_z = 0
pi.posters.lookAt = function(arg1) -- line 183
    soft_script()
    arg1.seen = TRUE
    manny:say_line("/pima012/")
    wait_for_message()
    manny:say_line("/pima013/")
end
pi.posters.pickUp = function(arg1) -- line 191
    if not arg1.seen then
        arg1:lookAt()
    end
    manny:say_line("/pima014/")
end
pi.posters.use = pi.posters.lookAt
pi.cell = Object:create(pi, "/pitx015/cell", -0.043852299, 0.87620598, 0.47, { range = 0.80000001 })
pi.cell.use_pnt_x = 0.236148
pi.cell.use_pnt_y = 0.67620599
pi.cell.use_pnt_z = 0
pi.cell.use_rot_x = 0
pi.cell.use_rot_y = -308.64001
pi.cell.use_rot_z = 0
pi.cell.lookAt = function(arg1) -- line 210
    manny:say_line("/pima016/")
    wait_for_message()
    manny:say_line("/pima017/")
end
pi.cell.use = function(arg1) -- line 216
    manny:say_line("/pima018/")
end
pi.terry_obj = Object:create(pi, "/pitx019/Terry", -0.043852299, 0.87620598, 0.47, { range = 1.5 })
pi.terry_obj.use_pnt_x = 0.236148
pi.terry_obj.use_pnt_y = 0.67620599
pi.terry_obj.use_pnt_z = 0
pi.terry_obj.use_rot_x = 0
pi.terry_obj.use_rot_y = -308.64001
pi.terry_obj.use_rot_z = 0
pi.terry_obj:make_untouchable()
pi.terry_obj.lookAt = function(arg1) -- line 230
    manny:say_line("/pima020/")
end
pi.terry_obj.use = function(arg1) -- line 234
    start_script(pi.talk_to_terry)
end
pi.pc_door = Object:create(pi, "/pitx001/door", 0.31192601, -0.41686001, 0.44, { range = 0.60000002 })
pi.pc_door.use_pnt_x = 0.181926
pi.pc_door.use_pnt_y = -0.13686
pi.pc_door.use_pnt_z = 0
pi.pc_door.use_rot_x = 0
pi.pc_door.use_rot_y = -153.373
pi.pc_door.use_rot_z = 0
pi.pc_door.out_pnt_x = 0.30958399
pi.pc_door.out_pnt_y = -0.39144701
pi.pc_door.out_pnt_z = 0
pi.pc_door.out_rot_x = 0
pi.pc_door.out_rot_y = -153.373
pi.pc_door.out_rot_z = 0
pi.pc_door.touchable = FALSE
pi.pc_box = pi.pc_door
pi.pc_door.walkOut = function(arg1) -- line 259
    pc:come_out_door(pc.pi_door)
end

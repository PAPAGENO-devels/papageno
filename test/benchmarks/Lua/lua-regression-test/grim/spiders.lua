CheckFirstTime("spiders.lua")
dofile("sp_fly_generic.lua")
dofile("sp_idles.lua")
spiders = { }
spider_actors = { }
SPIDER_FLY_SPEED = 0.2
spiders.init_spiders = function(arg1) -- line 27
    local local1 = 0
    local local2
    repeat
        local1 = local1 + 1
        if not spider_actors[local1] then
            spider_actors[local1] = Actor:create(nil, nil, nil, "spider" .. local1)
        end
        spider_actors[local1]:set_costume("sp_idles.cos")
        local2 = 1
        SetActorScale(spider_actors[local1].hActor, local2)
        spider_actors[local1]:set_walk_rate(SPIDER_FLY_SPEED * local2)
        spider_actors[local1]:set_turn_rate(45)
        spider_actors[local1]:follow_boxes()
        spider_actors[local1]:put_in_set(sp)
        spider_actors[local1]:follow_boxes()
        if local1 == 1 then
            spider_actors[1].home_point_x = 0.76620001
            spider_actors[1].home_point_y = -0.71600002
            spider_actors[1].home_point_z = 0.60000002
            spider_actors[1].range_point_x = 0.33950001
            spider_actors[1].range_point_y = -0.89529997
            spider_actors[1].range_point_z = 0.36000001
        elseif local1 == 2 then
            spider_actors[2].home_point_x = 0.59148598
            spider_actors[2].home_point_y = 0.23590399
            spider_actors[2].home_point_z = 0.93000001
            spider_actors[2].range_point_x = 0.33340001
            spider_actors[2].range_point_y = -0.90369999
            spider_actors[2].range_point_z = 0.36000001
        elseif local1 == 3 then
            spider_actors[3].home_point_x = 0.8427
            spider_actors[3].home_point_y = -0.23729999
            spider_actors[3].home_point_z = 0.94
            spider_actors[3].range_point_x = 0.60519999
            spider_actors[3].range_point_y = -0.85949999
            spider_actors[3].range_point_z = 0.64999998
        elseif local1 == 4 then
            spider_actors[4].home_point_x = -0.080814302
            spider_actors[4].home_point_y = -1.32417
            spider_actors[4].home_point_z = 0
            spider_actors[4].range_point_x = -1.16724
            spider_actors[4].range_point_y = -0.85349298
            spider_actors[4].range_point_z = 0
            spider_actors[4]:set_walk_rate(0.40000001)
        elseif local1 == 5 then
            spider_actors[5].home_point_x = -0.43773901
            spider_actors[5].home_point_y = 3.1407599
            spider_actors[5].home_point_z = 1.75
        elseif local1 == 6 then
            spider_actors[6].home_point_x = 1.0272599
            spider_actors[6].home_point_y = 2.52
            spider_actors[6].home_point_z = 1.602
        end
        if local1 > 4 then
            start_script(spiders.prop_spider_ganglia, spider_actors[local1])
        else
            ActorPuckOrient(spider_actors[local1].hActor, TRUE)
            start_script(spiders.spider_ganglia, spider_actors[local1])
        end
    until local1 == arg1
end
spiders.spider_ganglia = function(arg1) -- line 99
    local local1
    local local2
    SetActorReflection(arg1.hActor, 90)
    arg1:setpos(arg1.home_point_x, arg1.home_point_y, arg1.home_point_z)
    while 1 do
        if not find_script(sp.manny_hook_n_fling_web) then
            if arg1 == spider_actors[4] then
                local1 = 1
            else
                local1 = rndint(1, 3)
            end
            if local1 == 1 then
                local2 = start_script(sp.spider_walk, arg1)
                wait_for_script(local2)
            elseif local1 == 2 then
                local2 = start_script(sp.spider_wing, arg1)
                wait_for_script(local2)
            elseif local1 == 3 then
                local2 = start_script(sp.spider_leg, arg1)
                wait_for_script(local2)
            end
        end
        if arg1 == spider_actors[4] then
            sleep_for(1000)
        else
            local2 = rnd(2, 5)
            sleep_for(local2 * 1000)
        end
    end
end
sp.spider_walk = function(arg1) -- line 132
    local local1 = rnd(0.050000001, 0.1)
    local local2 = arg1:getpos()
    local local3 = { }
    local local4 = { }
    local local5 = GetActorWalkRate(arg1.hActor)
    local local6 = start_script(sleep_for, 1)
    local local7
    arg1:stop_chore(sp_idles_idle)
    arg1:play_chore(sp_idles_accelerate)
    while arg1:is_choring(sp_idles_accelerate) do
        if not find_script(local6) then
            local7 = pick_one_of({ "spSktr1.wav", "spSktr2.wav" })
            local6 = start_script(single_start_sfx, local7, IM_LOW_PRIORITY, 20)
        end
        arg1:walk_forward()
        break_here()
    end
    arg1:stop_chore(sp_idles_accelerate)
    local3 = local2
    arg1:play_chore_looping(sp_idles_walk_cycle)
    repeat
        if not find_script(local6) then
            local7 = pick_one_of({ "spSktr1.wav", "spSktr2.wav" })
            local6 = start_script(single_start_sfx, local7, IM_LOW_PRIORITY, 10)
        end
        arg1:walk_forward()
        break_here()
        local2 = arg1:getpos()
        if local2.x == local3.x and local2.y == local3.y and local2.z == local3.z then
            arg1:turn_left(180)
        else
            local3 = local2
        end
        local1 = local1 - PerSecond(local5)
    until local1 <= 0
    arg1:set_chore_looping(sp_idles_walk_cycle, FALSE)
    arg1:wait_for_chore(sp_idles_walk_cycle)
    arg1:stop_chore(sp_idles_walk_cycle)
    arg1:play_chore(sp_idles_decelerate)
    while arg1:is_choring(sp_idles_decelerate) do
        if not find_script(local6) then
            local7 = pick_one_of({ "spSktr1.wav", "spSktr2.wav" })
            local6 = start_script(single_start_sfx, local7, IM_LOW_PRIORITY, 20)
        end
        arg1:walk_forward()
        break_here()
    end
    arg1:stop_chore(sp_idles_decelerate)
    arg1:play_chore_looping(sp_idles_idle)
end
sp.spider_wing = function(arg1) -- line 185
    local local1 = start_script(sleep_for, 1)
    local local2
    local2 = pick_one_of({ "spFlap1.wav", "spFlap2.wav", "spFlap3.wav", "spFlap4.wav", "spFlap5.wav" })
    local1 = start_script(single_start_sfx, local2, IM_LOW_PRIORITY, 20)
    arg1:stop_chore(sp_idles_idle)
    arg1:play_chore(sp_idles_wing_enter)
    arg1:wait_for_chore(sp_idles_wing_enter)
    arg1:stop_chore(sp_idles_wing_enter)
    local local3 = rndint(1, 3)
    arg1:play_chore_looping(sp_idles_wing_cycle)
    arg1:wait_for_chore(sp_idles_wing_cycle)
    repeat
        if not find_script(local1) then
            local2 = pick_one_of({ "spFlap1.wav", "spFlap4.wav", "spFlap5.wav" })
            local1 = start_script(single_start_sfx, local2, IM_LOW_PRIORITY, 10)
        end
        sleep_for(500)
        local3 = local3 - 1
    until local3 <= 0
    arg1:set_chore_looping(sp_idles_wing_cycle, FALSE)
    arg1:wait_for_chore(sp_idles_wing_cycle)
    arg1:stop_chore(sp_idles_wing_cycle)
    arg1:play_chore(sp_idles_wing_exit)
    arg1:wait_for_chore(sp_idles_wing_exit)
    arg1:stop_chore(sp_idles_wing_exit)
    arg1:play_chore_looping(sp_idles_idle)
end
sp.spider_leg = function(arg1) -- line 218
    local local1 = start_script(sleep_for, 1)
    local local2
    arg1:stop_chore(sp_idles_idle)
    arg1:play_chore(sp_idles_leg_enter)
    arg1:wait_for_chore(sp_idles_leg_enter)
    arg1:stop_chore(sp_idles_leg_enter)
    local local3 = rndint(1, 6)
    arg1:play_chore_looping(sp_idles_leg_cycle)
    arg1:wait_for_chore(sp_idles_leg_cycle)
    repeat
        if not find_script(local1) then
            local2 = pick_one_of({ "spHop1.wav", "spHop2.wav", "spHop3.wav" })
            local1 = start_script(single_start_sfx, local2, IM_LOW_PRIORITY, 10)
        end
        sleep_for(1000)
        local3 = local3 - 1
    until local3 <= 0
    arg1:set_chore_looping(sp_idles_leg_cycle, FALSE)
    arg1:wait_for_chore(sp_idles_leg_cycle)
    arg1:stop_chore(sp_idles_leg_cycle)
    arg1:play_chore(sp_idles_leg_exit)
    arg1:wait_for_chore(sp_idles_leg_exit)
    arg1:stop_chore(sp_idles_leg_exit)
    arg1:play_chore_looping(sp_idles_idle)
end
spiders.prop_spider_ganglia = function(arg1) -- line 246
    local local1 = start_script(sleep_for, 1)
    local local2
    arg1:set_costume("sp_fly_generic.cos")
    arg1:ignore_boxes()
    arg1:setpos(arg1.home_point_x, arg1.home_point_y, arg1.home_point_z)
    arg1:setrot(0, rnd(0, 360), 0)
    arg1:set_turn_rate(rnd(45, 80))
    arg1:set_walk_rate(rnd(0.44999999, 0.69999999))
    arg1:play_chore_looping(sp_fly_generic_fly)
    while 1 do
        TurnActorTo(arg1.hActor, arg1.home_point_x, arg1.home_point_y, arg1.home_point_z)
        arg1:walk_forward()
        break_here()
    end
end
sp.uber_spider_sfx = function() -- line 272
    local local1
    while sp.uber_spider:is_choring(sp_fly_generic_fly) or sp.uber_spider:is_choring(sp_fly_generic_take_off) do
        local1 = pick_from_nonweighted_table({ "spUbFlp1.wav", "spUbFlp2.wav" })
        start_sfx(local1)
        wait_for_sound(local1)
    end
end
spiders.uber_spider = function() -- line 282
    local local1 = { }
    local local2
    local local3
    local local4
    local local5
    start_sfx("spVoxLp.imu", IM_HIGH_PRIORITY, 0)
    set_pan("spVoxLp.imu", 0)
    fade_sfx("spVoxLp.imu", 2000, 127)
    fade_pan_sfx("spVoxLp.imu", 2000, 64)
    if not sp.uber_spider then
        sp.uber_spider = Actor:create(nil, nil, nil, "uber spider")
    end
    sp.uber_spider:follow_boxes()
    sp.uber_spider:set_costume("sp_ub.cos")
    sp.uber_spider:set_walk_rate(0.30000001)
    sp.uber_spider:put_in_set(sp)
    sp.uber_spider:set_turn_rate(50)
    SetActorScale(sp.uber_spider.hActor, 2)
    sp.uber_spider:ignore_boxes()
    sp.uber_spider:setpos(-0.45925501, -2.1801701, 1.0112)
    sp.uber_spider:play_chore_looping(sp_fly_generic_fly)
    start_script(sp.uber_spider_sfx)
    sp.uber_spider.start_pnt = { }
    sp.uber_spider.start_pnt.x = -0.269539
    sp.uber_spider.start_pnt.y = -0.241943
    sp.uber_spider.start_pnt.z = 0.28
    local local6 = sp.uber_spider
    local1 = local6:getpos()
    repeat
        if not TurnActorTo(local6.hActor, local6.start_pnt.x, local6.start_pnt.y, local6.start_pnt.z) then
            PointActorAt(local6.hActor, local6.start_pnt.x, local6.start_pnt.y, local6.start_pnt.z)
        end
        local5 = sqrt((local1.x - local6.start_pnt.x) ^ 2 + (local1.y - local6.start_pnt.y) ^ 2)
        desired_z = tan(10) * local5
        desired_z = desired_z + local6.start_pnt.z
        if local5 <= 1.89 and not local3 then
            local3 = TRUE
            sp.uber_spider:stop_chore(sp_fly_generic_fly)
            sp.uber_spider:play_chore(sp_fly_generic_land)
        end
        if local5 <= 0.97500002 and not local2 then
            local2 = TRUE
            start_script(spiders.spider_rotate_up)
        end
        rate = GetActorWalkRate(local6.hActor)
        if PerSecond(rate) > local5 then
            local6:set_walk_rate(local5)
        end
        local6:walk_forward()
        local1 = local6:getpos()
        local6:setpos(local1.x, local1.y, desired_z)
        break_here()
        if local3 and not local6:is_choring(sp_fly_generic_land) then
            local6:setpos(local6.start_pnt.x, local6.start_pnt.y, local6.start_pnt.z)
        end
    until local5 < 0.0099999998
    local6:setpos(local6.start_pnt.x, local6.start_pnt.y, local6.start_pnt.z)
    local6:wait_for_chore(sp_fly_generic_land)
    stop_script(sp.uber_spider_sfx)
    local6:play_chore(sp_fly_generic_hop_loop2)
    start_sfx("spUbRepr.wav")
    local6:wait_for_chore()
    sp.web:complete_chore(sp_web_no_web)
    sp.web:play_chore(sp_web_web)
    ForceRefresh()
    local6:play_chore(sp_fly_generic_take_off)
    start_script(sp.uber_spider_sfx)
    local6:set_walk_rate(-0.22)
    start_script(spiders.spider_rotate_down)
    local6:set_time_scale(1.5)
    while local6:is_choring(sp_fly_generic_take_off) do
        local6:walk_forward()
        break_here()
    end
    local6:stop_chore(sp_fly_generic_take_off)
    local6:play_chore_looping(sp_fly_generic_fly)
    local6:set_walk_rate(0.40000001)
    fade_pan_sfx("spVoxLp.IMU", 3000, 0)
    fade_sfx("spVoxLp.IMU", 4000, 0)
    repeat
        if not TurnActorTo(local6.hActor, local6.start_pnt.x, local6.start_pnt.y, local6.start_pnt.z) then
            break_here()
        end
        local1 = local6:getpos()
        local6:walk_forward()
        local1.z = local1.z + 0.050000001
        local6:setpos(local1.x, local1.y, local1.z)
        break_here()
    until local1.z > 1.5
    sp.uber_spider:free()
    stop_script(sp.uber_spider_sfx)
end
spiders.spider_rotate_up = function() -- line 397
    local local1 = 0
    while local1 ~= 89 do
        local1 = local1 + PerSecond(28)
        if local1 > 89 then
            local1 = 89
        end
        SetActorPitch(sp.uber_spider.hActor, local1)
        break_here()
    end
end
spiders.spider_rotate_down = function() -- line 410
    local local1 = 89
    while local1 ~= 0 do
        local1 = local1 - PerSecond(30)
        if local1 < 0 then
            local1 = 0
        end
        SetActorPitch(sp.uber_spider.hActor, local1)
        break_here()
    end
end

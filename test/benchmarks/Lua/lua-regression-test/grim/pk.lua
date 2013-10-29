CheckFirstTime("pk.lua")
dofile("ma_squirt_chem.lua")
dofile("pk_left_pump.lua")
dofile("pk_puddle.lua")
dofile("manny_foam_fill.lua")
pk = Set:create("pk.set", "Packing Room", { pk_widha = 0, pk_ovrhd = 1 })
pk.shrinkable = 0.03
pk.chem_state = "no chem"
gb = function() -- line 22
    fe.balloons.balloon1:get()
    fe.balloons.balloon2:get()
    fe.balloons.balloon3:get()
    fe.balloons.balloon4:get()
    fe.balloons.balloon5:get()
end
pb = function() -- line 30
    print_table(pk.balloons.balloon1)
    print_table(pk.balloons.balloon2)
    print_table(pk.balloons.balloon3)
    print_table(pk.balloons.balloon4)
    print_table(pk.balloons.balloon5)
    PrintDebug(pk.balloons.balloon1.name .. " owner=" .. pk.balloons.balloon1.owner.name .. "\n")
    PrintDebug(pk.balloons.balloon2.name .. " owner=" .. pk.balloons.balloon2.owner.name .. "\n")
    PrintDebug(pk.balloons.balloon3.name .. " owner=" .. pk.balloons.balloon3.owner.name .. "\n")
    PrintDebug(pk.balloons.balloon4.name .. " owner=" .. pk.balloons.balloon4.owner.name .. "\n")
    PrintDebug(pk.balloons.balloon5.name .. " owner=" .. pk.balloons.balloon5.owner.name .. "\n")
end
pk.fill_balloon = function(arg1, arg2, arg3) -- line 45
    local local1 = alloc_object_from_table(pk.balloons)
    START_CUT_SCENE()
    if local1 then
        local1:get()
        local1.wav = "getBloon.wav"
        local1.source_balloon = arg2
        manny.is_holding = nil
        manny:stop_chore(manny.hold_chore, "ms.cos")
        manny:stop_chore(ms_hold, "ms.cos")
        manny.hold_chore = nil
        if arg3 == 1 then
            local1.chem = 2
            pk.nozzle_1.interest_actor:push_costume("pk_l_balloon.cos")
            local1.name = arg2.name .. " filled with a dark chemical"
            manny:walkto(0.75395, -1.18986, 0, 0, 119.264, 0)
            manny:wait_for_actor()
            manny:push_costume("manny_foam_fill.cos")
            manny:play_chore(manny_foam_fill_left_fill, "manny_foam_fill.cos")
            sleep_for(536)
            pk.nozzle_1.interest_actor:play_chore(0, "pk_l_balloon.cos")
            manny:wait_for_chore(manny_foam_fill_left_fill, "manny_foam_fill.cos")
            pk.nozzle_1.interest_actor:wait_for_chore(0, "pk_l_balloon.cos")
            pk.nozzle_1.interest_actor:pop_costume()
            arg2:free()
            arg2.owner = IN_LIMBO
            manny:pop_costume()
            manny:play_chore(ms_pb_filled_balloon, "ms.cos")
            manny:wait_for_chore()
            manny:stop_chore(ms_pb_filled_balloon, "ms.cos")
            manny:play_chore(ms_takeout_empty, "ms.cos")
            manny:wait_for_chore()
            manny:stop_chore(ms_takeout_empty, "ms.cos")
        elseif arg3 == 2 then
            local1.name = arg2.name .. " filled with a light chemical"
            local1.chem = 1
            manny:walkto(0.75475502, -1.20416, 0, 0, 172.573, 0)
            manny:wait_for_actor()
            manny:push_costume("manny_foam_fill.cos")
            manny:play_chore(manny_foam_fill_right_fill, "manny_foam_fill.cos")
            sleep_for(900)
            pk.nozzle_2.interest_actor:play_chore(1, "pk_r_pump.cos")
            pk.nozzle_2.interest_actor:wait_for_chore(1, "pk_r_pump.cos")
            manny:wait_for_chore(manny_foam_fill_right_fill, "manny_foam_fill.cos")
            arg2:free()
            arg2.owner = IN_LIMBO
            manny:pop_costume()
            manny:play_chore(ms_pb_filled_balloon2, "ms.cos")
            manny:wait_for_chore()
            manny:stop_chore(ms_pb_filled_balloon2, "ms.cos")
            manny:play_chore(ms_takeout_empty, "ms.cos")
            manny:wait_for_chore()
            manny:stop_chore(ms_takeout_empty, "ms.cos")
        end
    else
        PrintDebug("ERROR:  can't allocate full balloon!")
    end
    END_CUT_SCENE()
end
pk.spray_chemical = function(arg1, arg2) -- line 116
    local local1
    START_CUT_SCENE()
    if pk.chem_state == "both chem" then
        manny:walkto(0.73000002, -1.1950001, 0, 0, 172.5, 0)
        manny:wait_for_message()
        manny:push_costume("ma_swats_foam.cos")
        manny:play_chore(0)
        sleep_for(737)
        pk.puddle:play_chore(pk_puddle_swat)
        manny:wait_for_chore(0, "ma_swats_foam.cos")
        pk.puddle.interest_actor:wait_for_chore(pk_puddle_swat)
        pk.puddle:play_chore(pk_puddle_clear)
        manny:stop_chore(0, "ma_swats_foam.cos")
        manny:pop_costume()
        if arg2 == 1 then
            manny:walkto(0.72000003, -1.115, 0, 0, 119.2665, 0)
        else
            manny:walkto(0.730721, -1.17336, 0, 0, 172.569, 0)
        end
        manny:wait_for_actor()
    end
    if arg2 == "swat" then
        pk.chem_state = "no chem"
    else
        if pk.chem_state == "no chem" then
            if arg2 == 1 then
                pk.chem_state = "chem 1"
            else
                pk.chem_state = "chem 2"
            end
        elseif pk.chem_state == "chem 1" then
            if arg2 == 2 then
                pk.chem_state = "both chem"
            end
        elseif pk.chem_state == "chem 2" then
            if arg2 == 1 then
                pk.chem_state = "both chem"
            end
        elseif pk.chem_state == "both chem" then
            if arg2 == 1 then
                pk.chem_state = "chem 1"
            else
                pk.chem_state = "chem 2"
            end
        end
        if arg2 == 1 then
            manny:push_costume("ma_squirt_chem.cos")
            local1 = ma_squirt_chem_left_shoot
            manny:play_chore(ma_squirt_chem_left_shoot, "ma_squirt_chem.cos")
            sleep_for(804)
            pk.nozzle_1:play_chore(0)
        elseif arg2 == 2 then
            manny:push_costume("ma_squirt_chem.cos")
            local1 = ma_squirt_chem_right_shoot
            manny:play_chore(ma_squirt_chem_right_shoot, "ma_squirt_chem.cos")
            sleep_for(670)
            pk.nozzle_2:play_chore(0)
        end
        sleep_for(871)
        if pk.chem_state == "both chem" then
            pk.puddle:play_chore(pk_puddle_foam)
            manny:wait_for_chore(local1, "ma_squirt_chem.cos")
            manny:stop_chore(local1, "ma_squirt_chem.cos")
            manny:pop_costume()
            pk.puddle.interest_actor:wait_for_chore(pk_puddle_foam)
        else
            pk.puddle.interest_actor:put_in_set(pk)
            pk.puddle:play_chore(pk_puddle_puddle)
            manny:wait_for_chore(local1, "ma_squirt_chem.cos")
            manny:stop_chore(local1, "ma_squirt_chem.cos")
            manny:pop_costume()
            pk.puddle:wait_for_chore(pk_puddle_puddle)
        end
    end
    END_CUT_SCENE()
    pk:update_states()
    if pk.chem_state == "both chem" and not pk.smelled_chem then
        pk.smelled_chem = TRUE
        wait_for_message()
        manny:say_line("/pkma001/")
    end
end
pk.update_states = function(arg1) -- line 207
    if pk.chem_state == "both chem" then
        pk.puddle:play_chore(pk_puddle_instant_foam)
        pk.puddle:make_touchable()
    elseif pk.chem_state == "no chem" then
        pk.puddle:play_chore(pk_puddle_clear)
        pk.puddle:make_untouchable()
    else
        pk.puddle:play_chore(pk_puddle_instant_puddle)
        pk.puddle:make_touchable()
    end
end
pk.test = function() -- line 227
    manny:push_costume("manny_foam_fill.cos")
    pk.nozzle_1.interest_actor:push_costume("pk_l_balloon.cos")
    while 1 do
        manny:play_chore(0)
        sleep_for(536)
        pk.nozzle_1.interest_actor:play_chore(0)
        manny:wait_for_chore(0)
        pk.nozzle_1.interest_actor:wait_for_chore(0)
        break_here()
    end
end
pk.enter = function(arg1) -- line 241
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_foam_ball.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_left_pump.bm", "pk_left_pump.zbm", 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_lt_foam_stream.bm", nil, 1)
    puddle = NewObjectState(0, OBJSTATE_OVERLAY, "pk_puddle.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_puddle_fade.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_r_pump.bm", "pk_r_pump.zbm", 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_rt_foam_stream.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_r_balloon.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_l_balloon.bm", nil, 1)
    NewObjectState(0, OBJSTATE_OVERLAY, "pk_foam_ball_swat.bm", nil, 1)
    SendObjectToBack(puddle)
    pk.nozzle_1:set_object_state("pk_left_pump.cos")
    pk.nozzle_1.interest_actor:complete_chore(0)
    pk.nozzle_2:set_object_state("pk_r_pump.cos")
    pk.nozzle_2.interest_actor:complete_chore(0)
    LoadCostume("pk_left_pump.cos")
    LoadCostume("pk_r_pump.cos")
    LoadCostume("pk_puddle.cos")
    LoadCostume("manny_foam_fill.cos")
    pk.puddle:set_object_state("pk_puddle.cos")
    pk.puddle:play_chore(pk_puddle_clear)
    pk:update_states()
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 10)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
pk.exit = function(arg1) -- line 279
    pk.nozzle_1:free_object_state()
    pk.nozzle_2:free_object_state()
    pk.puddle:free_object_state()
    KillActorShadows(manny.hActor)
end
pk.nozzle_1 = Object:create(pk, "/pktx002/nozzle", 0.86838901, -1.46008, 0.551, { range = 0.80000001 })
pk.nozzle_1.use_pnt_x = 0.730721
pk.nozzle_1.use_pnt_y = -1.17336
pk.nozzle_1.use_pnt_z = 0
pk.nozzle_1.use_rot_x = 0
pk.nozzle_1.use_rot_y = 172.569
pk.nozzle_1.use_rot_z = 0
pk.nozzle_1.lookAt = function(arg1) -- line 300
    manny:say_line("/pkma003/")
end
pk.nozzle_1.pickUp = function(arg1) -- line 305
    system.default_response("portable")
end
pk.nozzle_1.use = function(arg1) -- line 309
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    pk:spray_chemical(2)
end
pk.nozzle_1.use_mt_balloon = function(arg1, arg2) -- line 317
    pk:fill_balloon(arg2, 2)
end
pk.nozzle_2 = Object:create(pk, "/pktx005/nozzle", 0.59614003, -1.3855799, 0.57999998, { range = 0.80000001 })
pk.nozzle_2.use_pnt_x = 0.72000003
pk.nozzle_2.use_pnt_y = -1.115
pk.nozzle_2.use_pnt_z = 0
pk.nozzle_2.use_rot_x = 0
pk.nozzle_2.use_rot_y = 119.2665
pk.nozzle_2.use_rot_z = 0
pk.nozzle_2.parent = pk.nozzle_1
pk.nozzle_2.use = function(arg1) -- line 332
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    pk:spray_chemical(1)
end
pk.nozzle_2.use_mt_balloon = function(arg1, arg2) -- line 339
    pk:fill_balloon(arg2, 1)
end
pk.puddle = Object:create(pk, "/pktx006/puddle", 0.67614001, -1.40558, 0.19, { range = 0.5 })
pk.puddle:make_untouchable()
pk.puddle.use_pnt_x = 0.67900002
pk.puddle.use_pnt_y = -1.166
pk.puddle.use_pnt_z = 0
pk.puddle.use_rot_x = 0
pk.puddle.use_rot_y = -185.895
pk.puddle.use_rot_z = 0
pk.puddle.lookAt = function(arg1) -- line 354
    if pk.chem_state == "both chem" then
        manny:say_line("/pkma007/")
    else
        manny:say_line("/pkma008/")
    end
end
pk.puddle.pickUp = function(arg1) -- line 362
    manny:say_line("/pkma009/")
end
pk.puddle.use = function(arg1) -- line 366
    if pk.chem_state == "both chem" then
        pk:spray_chemical("swat")
    else
        manny:say_line("/pkma010/")
    end
end
pk.balloons = { }
pk.balloons.balloon1 = Object:create(pk, "", 0, 0, 0, { range = 0 })
pk.balloons.balloon1.string_name = "full_balloon"
pk.balloons.balloon1.owner = pk
pk.balloons.balloon1.big = TRUE
pk.balloons.balloon1.wav = "getFlBln.wav"
pk.balloons.balloon1.chem = FALSE
pk.balloons.balloon1.lookAt = function(arg1) -- line 384
    if arg1.chem == 1 then
        manny:say_line("/pkma011/")
    else
        manny:say_line("/pkma012/")
    end
end
pk.balloons.balloon2 = Object:create(pk, "", 0, 0, 0, { range = 0 })
pk.balloons.balloon2.string_name = "full_balloon"
pk.balloons.balloon2.owner = pk
pk.balloons.balloon2.parent = pk.balloons.balloon1
pk.balloons.balloon2.big = TRUE
pk.balloons.balloon2.wav = "getFlBln.wav"
pk.balloons.balloon2.chem = FALSE
pk.balloons.balloon2.lookAt = function(arg1) -- line 400
    if arg1.chem == 1 then
        manny:say_line("/pkma011/")
    else
        manny:say_line("/pkma012/")
    end
end
pk.balloons.balloon3 = Object:create(pk, "", 0, 0, 0, { range = 0 })
pk.balloons.balloon3.string_name = "full_balloon"
pk.balloons.balloon3.owner = pk
pk.balloons.balloon3.parent = pk.balloons.balloon1
pk.balloons.balloon3.big = TRUE
pk.balloons.balloon3.wav = "getFlBln.wav"
pk.balloons.balloon3.chem = FALSE
pk.balloons.balloon3.lookAt = function(arg1) -- line 417
    if arg1.chem == 1 then
        manny:say_line("/pkma011/")
    else
        manny:say_line("/pkma012/")
    end
end
pk.balloons.balloon4 = Object:create(pk, "", 0, 0, 0, { range = 0 })
pk.balloons.balloon4.string_name = "full_balloon"
pk.balloons.balloon4.owner = pk
pk.balloons.balloon4.parent = pk.balloons.balloon1
pk.balloons.balloon4.big = TRUE
pk.balloons.balloon4.wav = "getFlBln.wav"
pk.balloons.balloon4.chem = FALSE
pk.balloons.balloon4.lookAt = function(arg1) -- line 433
    if arg1.chem == 1 then
        manny:say_line("/pkma011/")
    else
        manny:say_line("/pkma012/")
    end
end
pk.balloons.balloon5 = Object:create(pk, "", 0, 0, 0, { range = 0 })
pk.balloons.balloon5.string_name = "full_balloon"
pk.balloons.balloon5.owner = pk
pk.balloons.balloon5.parent = pk.balloons.balloon1
pk.balloons.balloon5.big = TRUE
pk.balloons.balloon5.wav = "getFlBln.wav"
pk.balloons.balloon5.chem = FALSE
pk.balloons.balloon5.lookAt = function(arg1) -- line 449
    if arg1.chem == 1 then
        manny:say_line("/pkma011/")
    else
        manny:say_line("/pkma012/")
    end
end
pk.coffin = Object:create(pk, "/pktx014/coffin", 0.116594, -1.16655, 0.41, { range = 0.60000002 })
pk.coffin.use_pnt_x = 0.356594
pk.coffin.use_pnt_y = -1.04655
pk.coffin.use_pnt_z = 0
pk.coffin.use_rot_x = 0
pk.coffin.use_rot_y = 124.473
pk.coffin.use_rot_z = 0
pk.coffin.lookAt = function(arg1) -- line 466
    manny:say_line("/pkma015/")
end
pk.coffin.pickUp = function(arg1) -- line 470
    system.default_response("hernia")
end
pk.coffin.use = function(arg1) -- line 474
    START_CUT_SCENE()
    manny:say_line("/pkma016/")
    wait_for_message()
    manny:say_line("/pkma017/")
    END_CUT_SCENE()
end
pk.lo_door = Object:create(pk, "/pktx013/door", -0.0138599, -0.475577, 0.5, { range = 0.54506099 })
pk.pk_lo_box = pk.lo_door
pk.lo_door.use_pnt_x = 0.193
pk.lo_door.use_pnt_y = -0.41
pk.lo_door.use_pnt_z = 0
pk.lo_door.use_rot_x = 0
pk.lo_door.use_rot_y = -993.59998
pk.lo_door.use_rot_z = 0
pk.lo_door.out_pnt_x = -0.127
pk.lo_door.out_pnt_y = -0.391
pk.lo_door.out_pnt_z = 0
pk.lo_door.out_rot_x = 0
pk.lo_door.out_rot_y = -993.59998
pk.lo_door.out_rot_z = 0
pk.lo_door.touchable = FALSE
pk.lo_door.walkOut = function(arg1) -- line 506
    lo:come_out_door(lo.pk_door)
end

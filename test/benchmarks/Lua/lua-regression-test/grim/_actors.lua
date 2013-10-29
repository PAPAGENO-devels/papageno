CheckFirstTime("_actors.lua")
system.actorCount = 0
system.actorTable = { }
system.actorTemplate = { name = "<unnamed>", hActor = nil }
Actor = system.actorTemplate
Actor.is_holding = nil
Actor.is_talking = nil
Actor.walk_chore = nil
Actor.default_look_rate = 200
Actor.last_chore = nil
Actor.last_play_chore = nil
CHORE_LOOP = TRUE
CHORE_NOLOOP = FALSE
MODE_BACKGROUND = TRUE
MODE_NORMAL = FALSE
Actor.hold_chore = nil
Actor.MARKER_LEFT_WALK = 10
Actor.MARKER_RIGHT_WALK = 15
Actor.MARKER_LEFT_RUN = 20
Actor.MARKER_RIGHT_RUN = 25
Actor.MARKER_LEFT_TURN = 30
Actor.MARKER_RIGHT_TURN = 35
Actor.idles_allowed = TRUE
Actor.last_chore_played = nil
Actor.last_cos_played = nil
Actor.base_costume = nil
Actor.create = function(arg1, arg2, arg3, arg4, arg5) -- line 73
    local local1 = { }
    local1.parent = arg1
    if arg5 then
        local1.name = arg5
    else
        local1.name = arg2
    end
    local1.hActor = LoadActor(arg5)
    local1.footsteps = nil
    local1.saylineTable = { }
    system.actorTable[local1.name] = local1
    system.actorCount = system.actorCount + 1
    system.actorTable[local1.hActor] = local1
    arg1.create_dialogStack(local1)
    return local1
end
Actor.getpos = function(arg1) -- line 103
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorPos(arg1.hActor)
    return local1
end
Actor.getrot = function(arg1) -- line 115
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorRot(arg1.hActor)
    return local1
end
Actor.get_positive_rot = function(arg1) -- line 126
    local local1 = { }
    local1.x, local1.y, local1.z = GetActorRot(arg1.hActor)
    while local1.y < 0 do
        local1.y = local1.y + 360
    end
    while local1.y > 360 do
        local1.y = local1.y - 360
    end
    while local1.x < 0 do
        local1.x = local1.x + 360
    end
    while local1.x > 360 do
        local1.x = local1.z - 360
    end
    while local1.z < 0 do
        local1.z = local1.z + 360
    end
    while local1.z > 360 do
        local1.z = local1.z - 360
    end
    return local1
end
Actor.get_positive_yaw_to_point = function(arg1, arg2) -- line 160
    local local1 = GetActorYawToPoint(arg1.hActor, { x = arg2.x, y = arg2.y, z = arg2.z })
    while local1 < 0 do
        local1 = local1 + 360
    end
    while local1 > 360 do
        local1 = local1 - 360
    end
    return local1
end
Actor.setpos = function(arg1, arg2, arg3, arg4) -- line 179
    if type(arg2) == "table" then
        arg1:moveto(arg2.x, arg2.y, arg2.z)
    else
        arg1:moveto(arg2, arg3, arg4)
    end
end
Actor.set_softimage_pos = function(arg1, arg2, arg3, arg4) -- line 191
    if type(arg2) == "table" then
        arg1:moveto(arg2.x / 10, -arg2.z / 10, arg2.y / 10)
    else
        arg1:moveto(arg2 / 10, -arg4 / 10, arg3 / 10)
    end
end
Actor.get_softimage_pos = function(arg1) -- line 204
    local local1 = arg1:getpos()
    local1.y, local1.z = local1.z, -local1.y
    local1.x, local1.y, local1.z = local1.x * 10, local1.y * 10, local1.z * 10
    return local1
end
convert_softimage_pos = function(arg1, arg2, arg3) -- line 218
    local local1 = arg1 / 10
    local local2 = 0 - arg3 / 10
    local local3 = arg2 / 10
    return local1, local2, local3
end
Actor.turn_toward_entity = function(arg1, arg2, arg3, arg4) -- line 232
    if arg3 then
        while TurnActorTo(arg1.hActor, arg2, arg3, arg4) do
            break_here()
        end
    elseif arg2.use_pnt_x ~= nil then
        while TurnActorTo(arg1.hActor, arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z) do
            break_here()
        end
    else
        arg2, arg3, arg4 = arg2:getpos()
        while TurnActorTo(arg1.hActor, arg2, arg3, arg4) do
            break_here()
        end
    end
end
Actor.face_entity = function(arg1, arg2, arg3, arg4) -- line 260
    local local1
    local local2
    if type(arg2) == "table" then
        if arg2.interest_actor then
            local1 = arg2.interest_actor:getpos()
        elseif arg2.getpos then
            local1 = arg2:getpos()
        elseif arg2.x then
            local1 = arg2
        else
            PrintDebug("Actor:face_entity() -- invalid argument\n")
        end
    else
        local1 = { }
        local1.x = arg2
        local1.y = arg3
        local1.z = arg4
    end
    if local1 then
        local2 = GetActorYawToPoint(arg1.hActor, local1)
        arg1:setrot(0, local2, 0, TRUE)
    end
end
Actor.set_colormap = function(arg1, arg2) -- line 292
    SetActorColormap(arg1.hActor, arg2)
end
Actor.setrot = function(arg1, arg2, arg3, arg4, arg5) -- line 302
    if type(arg2) == "table" then
        SetActorRot(arg1.hActor, arg2.x, arg2.y, arg2.z, arg3)
    else
        SetActorRot(arg1.hActor, arg2, arg3, arg4, arg5)
    end
end
Actor.walkto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 319
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg1 == system.currentActor then
        ResetMarioControls()
    end
    if type(arg2) == "table" then
        return arg1:walkto_object(arg2, arg3)
    else
        SetActorConstrain(arg1.hActor, FALSE)
        if arg1 == system.currentActor then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
        end
        WalkActorTo(arg1.hActor, arg2, arg3, arg4)
        if arg5 then
            while arg1:is_moving() do
                break_here()
            end
            arg1:setrot(arg5, arg6, arg7, TRUE)
        end
    end
end
Actor.runto = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 349
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg1 == system.currentActor then
        ResetMarioControls()
    end
    arg1:set_run(TRUE)
    if type(arg2) == "table" then
        arg1:walkto_object(arg2, arg3)
    else
        SetActorConstrain(arg1.hActor, FALSE)
        if arg1 == system.currentActor then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
        end
        WalkActorTo(arg1.hActor, arg2, arg3, arg4)
        if arg5 then
            while arg1:is_moving() do
                break_here()
            end
            arg1:setrot(arg5, arg6, arg7, TRUE)
        end
    end
    arg1:wait_for_actor()
    arg1:set_run(FALSE)
end
Actor.walk_and_face = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 386
    arg1:walkto(arg2, arg3, arg4)
    while arg1:is_moving() do
        break_here()
    end
    arg1:setrot(arg5, arg6, arg7, TRUE)
    arg1:wait_for_actor()
end
Actor.walk_forward = function(arg1) -- line 400
    WalkActorForward(arg1.hActor)
end
Actor.moveto = function(arg1, arg2, arg3, arg4) -- line 409
    if type(arg2) == "table" then
        PutActorAt(arg1.hActor, arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z)
    else
        PutActorAt(arg1.hActor, arg2, arg3, arg4)
    end
end
Actor.scale = function(arg1, arg2) -- line 421
    SetActorScale(arg1.hActor, arg2)
end
Actor.driveto = function(arg1, arg2, arg3, arg4) -- line 429
    DriveActorTo(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_run = function(arg1, arg2) -- line 433
end
Actor.force_auto_run = function(arg1, arg2) -- line 437
end
Actor.walkto_object = function(arg1, arg2, arg3) -- line 445
    local local1, local2, local3, local4, local5, local6, local7
    local local8, local9
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    if arg2.parent == Ladder then
        if arg3 then
            local9 = arg2.base.out_pnt_z
            local8 = arg2.top.out_pnt_z
        else
            local9 = arg2.base.use_pnt_z
            local8 = arg2.top.use_pnt_z
        end
        local1 = arg1:getpos()
        if abs(local9 - local1.z) < abs(local8 - local1.z) then
            arg2 = arg2.base
        else
            arg2 = arg2.top
        end
    end
    if arg3 then
        local2 = arg2.out_pnt_x
        local3 = arg2.out_pnt_y
        local4 = arg2.out_pnt_z
        local5 = arg2.out_rot_x
        local6 = arg2.out_rot_y
        local7 = arg2.out_rot_z
    else
        local2 = arg2.use_pnt_x
        local3 = arg2.use_pnt_y
        local4 = arg2.use_pnt_z
        local5 = arg2.use_rot_x
        local6 = arg2.use_rot_y
        local7 = arg2.use_rot_z
    end
    if local2 then
        PrintDebug("Walking " .. arg1.name .. " to " .. arg2.name .. "\t" .. local2 .. "\t" .. local3 .. "\t" .. local4 .. "\n")
        PrintDebug("IndexFB_disabled: " .. tostring(indexFB_disabled) .. "\n")
        if arg1 == system.currentActor then
            stop_movement_scripts()
        end
        SetActorConstrain(arg1.hActor, FALSE)
        arg1:walkto(local2, local3, local4, local5, local6, local7)
        while arg1:is_moving() or arg1:is_turning() do
            break_here()
        end
        if arg1 == system.currentActor and MarioControl then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
            single_start_script(WalkManny)
        end
        local1 = object_proximity(arg2, arg3)
        if local1 <= MAX_PROX then
            PrintDebug("made it to the use/out point of " .. arg2.name .. "!\n")
            return TRUE
        else
            PrintDebug("Didn't make it to the use/out point of " .. arg2.name .. "!\n")
            return FALSE
        end
    else
        PrintDebug("Object has no use/out point!\n")
    end
end
Actor.walk_closeto_object = function(arg1, arg2, arg3) -- line 527
    local local1, local2, local3, local4, local5, local6, local7
    local local8 = 0
    arg1:set_run(FALSE)
    if arg1.set_walk_backwards then
        arg1:set_walk_backwards(FALSE)
    end
    local2 = arg2.use_pnt_x
    local3 = arg2.use_pnt_y
    local4 = arg2.use_pnt_z
    local5 = arg2.use_rot_x
    local6 = arg2.use_rot_y
    local7 = arg2.use_rot_z
    if local2 then
        PrintDebug("Walking " .. arg1.name .. " to " .. arg2.name .. "\t" .. local2 .. "\t" .. local3 .. "\t" .. local4 .. " within " .. arg3 .. "\n")
        if arg1 == system.currentActor then
            stop_movement_scripts()
        end
        SetActorConstrain(arg1.hActor, FALSE)
        arg1:walkto(local2, local3, local4, local5, local6, local7)
        while arg1:is_moving() or arg1:is_turning() and local8 < 20000 do
            break_here()
            local8 = local8 + system.frameTime
        end
        if arg1 == system.currentActor and MarioControl then
            WalkVector.x = 0
            WalkVector.y = 0
            WalkVector.z = 0
            single_start_script(WalkManny)
        end
        local1 = proximity(manny.hActor, local2, local3, local4)
        if local1 <= arg3 then
            PrintDebug("made it close to the use point of " .. arg2.name .. "!\n")
            return TRUE
        else
            PrintDebug("Didn't make it to the use point of " .. arg2.name .. ", proximity = " .. local1 .. "!\n")
            return FALSE
        end
    else
        PrintDebug("Object has no use/out point!\n")
    end
end
COLLISION_OFF = 0
COLLISION_BOX = 1
COLLISION_SPHERE = 2
Actor.set_collision_mode = function(arg1, arg2, arg3) -- line 585
    SetActorCollisionMode(arg1.hActor, arg2)
    if arg3 ~= nil and arg2 ~= COLLISION_OFF then
        SetActorCollisionScale(arg1.hActor, arg3)
    end
end
Actor.set_time_scale = function(arg1, arg2) -- line 592
    SetActorTimeScale(arg1.hActor, arg2)
end
Actor.offsetBy = function(arg1, arg2, arg3, arg4) -- line 601
    local local1
    local1 = arg1:getpos()
    if arg2 then
        local1.x = local1.x + arg2
    end
    if arg3 then
        local1.y = local1.y + arg3
    end
    if arg4 then
        local1.z = local1.z + arg4
    end
    arg1:setpos(local1.x, local1.y, local1.z)
end
Actor.turn_right = function(arg1, arg2) -- line 617
    local local1 = arg1:getrot()
    arg1:setrot(local1.x, local1.y - arg2, local1.z, TRUE)
end
Actor.turn_left = function(arg1, arg2) -- line 622
    local local1 = arg1:getrot()
    arg1:setrot(local1.x, local1.y + arg2, local1.z, TRUE)
end
Actor.teleport_out_of_hot_box = function(arg1) -- line 636
    local local1, local2, local3
    local local4 = { }
    local local5, local6
    local1, local2, local3 = arg1:find_sector_type(HOT)
    if local1 then
        if arg1.is_backward then
            local6 = arg1:getrot()
            arg1:setrot(local6.x, local6.y + 180, local6.z)
        end
        local4.x, local4.y, local4.z = GetSectorOppositeEdge(arg1.hActor, local2)
        if local4.x then
            arg1:setpos(local4.x, local4.y, local4.z)
            system.currentSet:force_camerachange()
        end
        if arg1.is_backward then
            arg1:setrot(local6.x, local6.y, local6.z)
        end
    end
end
Actor.play_chore = function(arg1, arg2, arg3) -- line 662
    if arg1:get_costume() and arg2 ~= nil then
        arg1.last_chore_played = arg2
        arg1.last_cos_played = arg3
        PlayActorChore(arg1.hActor, arg2, arg3)
    elseif arg2 == nil then
        PrintDebug("(" .. tostring(arg1.name) .. ")  Actor:play_chore() trying to play nil chore.\n")
    end
end
Actor.fade_in_chore = function(arg1, arg2, arg3, arg4) -- line 678
    FadeInChore(arg1.hActor, arg3, arg2, arg4)
end
Actor.fade_out_chore = function(arg1, arg2, arg3, arg4) -- line 686
    FadeOutChore(arg1.hActor, arg3, arg2, arg4)
end
Actor.blend = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 695
    if not arg5 then
        arg5 = arg1:get_costume()
    end
    if not arg6 then
        arg6 = arg5
    end
    start_script(arg1.fade_in_chore, arg1, arg2, arg5, arg4)
    if arg3 ~= nil then
        start_script(arg1.fade_out_chore, arg1, arg3, arg6, arg4)
    end
    sleep_for(arg4)
end
Actor.loop_chore_for = function(arg1, arg2, arg3, arg4, arg5) -- line 715
    arg1:play_chore_looping(arg2, arg3)
    sleep_for(rndint(arg4, arg5))
    arg1:set_chore_looping(arg2, FALSE, arg3)
    arg1:wait_for_chore(arg2, arg3)
    arg1:stop_chore(arg2, arg3)
end
Actor.run_chore = function(arg1, arg2, arg3) -- line 727
    arg1:play_chore(arg2, arg3)
    arg1:wait_for_chore(arg2, arg3)
end
Actor.play_chore_looping = function(arg1, arg2, arg3) -- line 736
    if arg1:get_costume() and arg2 ~= nil then
        PlayActorChoreLooping(arg1.hActor, arg2, arg3)
    elseif arg2 == nil then
        PrintDebug("Actor:play_chore_looping() trying to play nil chore.\n")
    end
end
Actor.stop_chore = function(arg1, arg2, arg3) -- line 749
    if arg1:get_costume() then
        StopActorChore(arg1.hActor, arg2, arg3)
    end
end
Actor.stop_looping_chore = function(arg1, arg2, arg3, arg4) -- line 760
    if arg1:is_choring(arg2, FALSE, arg3) then
        arg1:set_chore_looping(arg2, FALSE, arg3)
        arg1:wait_for_chore(arg2, arg3)
        if arg4 then
            arg1:stop_chore(arg2, arg3)
        end
    end
end
Actor.complete_chore = function(arg1, arg2, arg3) -- line 774
    if arg1:get_costume() and arg2 ~= nil then
        CompleteActorChore(arg1.hActor, arg2, arg3)
    end
end
Actor.set_chore_looping = function(arg1, arg2, arg3, arg4) -- line 785
    if arg1:get_costume() then
        SetActorChoreLooping(arg1.hActor, arg2, arg3, arg4)
    end
end
Actor.stamp = function(arg1, arg2, arg3) -- line 799
    if not Is3DHardwareEnabled() then
        if arg2 then
            arg1:complete_chore(arg2, arg3)
            while arg1:is_choring(arg2, FALSE, arg3) do
                break_here()
            end
        end
        ActorToClean(arg1.hActor)
        if arg2 then
            arg1:stop_chore(arg2, arg3)
        end
    end
end
Actor.unstamp = function(arg1) -- line 818
    ForceRefresh()
end
Actor.stamp_test = function(arg1, arg2) -- line 822
    while 1 do
        if arg2 then
            sleep_for(arg2)
        else
            sleep_for(1000)
        end
        ActorToClean(arg1.hActor)
    end
end
Actor.freeze = function(arg1, arg2, arg3, arg4) -- line 843
    local local1 = { }
    if Is3DHardwareEnabled() then
        arg1:complete_chore(arg3, arg4)
        return
    end
    if GetActorCostume(arg1.hActor) then
        if system.currentSet == nil then
            PrintDebug("Actor:freeze() -- no current set!\n")
            return
        end
        if system.currentSet.frozen_actors == nil then
            system.currentSet.frozen_actors = { }
        end
        local1.actor = arg1
        local1.pos = arg1:getpos()
        local1.rot = arg1:getrot()
        local1.preFreezeChore = arg2
        local1.postFreezeChore = arg3
        local1.freezeCostume = arg4
        system.currentSet.frozen_actors[arg1.hActor] = local1
        arg1:stamp(arg2, arg4)
        if arg3 then
            arg1:complete_chore(arg3, arg4)
        else
            arg1:put_in_set(nil)
        end
        arg1.frozen = system.currentSet
    end
end
Actor.refreeze = function(arg1) -- line 883
    local local1
    if arg1.frozen and arg1.frozen == system.currentSet then
        local1 = arg1.frozen.frozen_actors[arg1.hActor]
        if Is3DHardwareEnabled() then
            if local1.postFreezeChore then
                arg1:complete_chore(local1.postFreezeChore, local1.freezeCostume)
            end
        else
            arg1:put_in_set(arg1.frozen)
            arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
            arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
            arg1:stamp(local1.preFreezeChore, local1.freezeCostume)
            if local1.postFreezeChore then
                arg1:complete_chore(local1.postFreezeChore, local1.freezeCostume)
            else
                arg1:put_in_set(nil)
            end
        end
    end
end
Actor.thaw = function(arg1, arg2, arg3) -- line 916
    local local1
    if Is3DHardwareEnabled() and not arg3 then
        return
    end
    if GetActorCostume(arg1.hActor) then
        if not arg1.frozen then
            PrintDebug("Actor:thaw() -- Actor " .. arg1.name .. " isn't frozen!\n")
            return
        end
        arg1:put_in_set(arg1.frozen)
        local1 = arg1.frozen.frozen_actors[arg1.hActor]
        if local1 then
            arg1:setpos(local1.pos.x, local1.pos.y, local1.pos.z)
            arg1:setrot(local1.rot.x, local1.rot.y, local1.rot.z)
        end
        arg1.frozen.frozen_actors[arg1.hActor] = nil
        arg1.frozen = nil
        if arg2 then
            arg1:unstamp()
            system.currentSet:redraw_frozen_actors()
        end
    end
end
Actor.run_idle = function(arg1, arg2, arg3) -- line 950
    local local1 = arg3
    local local2
    local local3 = system.currentSet
    while system.currentSet == local3 and local1 do
        PlayActorChore(arg1.hActor, local1)
        arg1.last_chore = chore
        wait_for_actor(arg1.hActor)
        local2 = pick_from_weighted_table(arg2[local1])
        if local2 then
            local1 = local2
        end
    end
end
Actor.new_run_idle = function(arg1, arg2, arg3, arg4, arg5) -- line 985
    local local1
    local local2
    local local3 = system.currentSet
    local local4
    arg1.stop_idle = FALSE
    arg1.last_play_chore = nil
    if arg3 then
        local4 = arg3
    else
        local4 = arg1.idle_table
    end
    local1 = local4.root_name .. "_" .. arg2
    if arg5 then
        arg1:print_costumes()
        PrintDebug("***\n")
        PrintDebug("Starting new_run_idle() with\n")
        PrintDebug("\ttable.root_name = " .. local4.root_name .. "\n")
        PrintDebug("\tstarting_chore = " .. arg2 .. "\n")
        PrintDebug("\tidle_table = " .. tostring(arg3) .. "\n")
        PrintDebug("\tcos = " .. arg4 .. "\n")
        PrintDebug("\tcurrent_chore = " .. local4.root_name .. "_" .. arg2 .. "\n")
        PrintDebug("***\n")
    end
    while system.currentSet == local3 and local1 and not arg1.stop_idle do
        if arg5 then
            PrintDebug(arg1.name .. " -- current chore:" .. getglobal(local1) .. "\n")
        end
        arg1:play_chore(getglobal(local1), arg4)
        arg1.last_chore = getglobal(local1)
        break_here()
        arg1:wait_for_chore(arg1.last_chore, arg4)
        if not arg1.stop_idle then
            if arg1.last_play_chore then
                if local4[arg1.last_play_chore] then
                    local2 = arg1.last_play_chore
                    arg1.stop_idle = TRUE
                    arg1:play_chore(getglobal(local1), arg4)
                    arg1.last_chore = local1
                    break_here()
                    arg1:wait_for_chore(arg1.last_chore, arg4)
                else
                    repeat
                        local1 = arg1.stop_table[arg1.last_chore]
                        arg1:play_chore(local1, arg4)
                        arg1.last_chore = local1
                        arg1:wait_for_chore(arg1.last_chore, arg4)
                    until local1 == arg1.last_play_chore
                    arg1.stop_idle = TRUE
                end
            else
                local2 = pick_from_weighted_table(local4[local1])
            end
        end
        if local2 then
            local1 = local2
        end
    end
end
Actor.kill_idle = function(arg1, arg2) -- line 1063
    local local1
    if find_script(arg1.new_run_idle) then
        arg1.last_play_chore = arg2
        while find_script(arg1.new_run_idle) do
            break_here()
        end
    end
end
Actor.wait_here = function(arg1, arg2) -- line 1078
    repeat
        if arg1.stop_idle or arg1.is_talking then
            arg2 = 0
        else
            arg2 = arg2 - 1
            sleep_for(1000)
        end
    until arg2 <= 0
end
Actor.talk_randomly_from_weighted_table = function(arg1, arg2, arg3, arg4) -- line 1101
    local local1, local2
    local local3 = system.currentSet
    if arg3 then
        local2 = arg3
    else
        local2 = 2000
    end
    if not arg4 then
        arg4 = { background = TRUE, skip_log = TRUE }
    end
    if type(arg2) == "table" then
        while system.currentSet == local3 do
            local1 = pick_from_weighted_table(arg2)
            if local1 then
                arg1:say_line(local1, arg4)
                arg1:wait_for_message()
            end
            sleep_for(local2 * random())
        end
    end
end
Actor.wait_for_actor = function(arg1) -- line 1132
    while arg1:is_moving() or arg1:is_turning() or arg1:is_choring(nil, TRUE) do
        break_here()
    end
end
Actor.wait_for_chore = function(arg1, arg2, arg3) -- line 1144
    if not arg2 and not arg3 then
        arg2 = arg1.last_chore_played
        arg3 = arg1.last_cos_played
    end
    while arg1:is_choring(arg2, TRUE, arg3) do
        break_here()
    end
end
Actor.is_moving = function(arg1) -- line 1159
    return IsActorMoving(arg1.hActor)
end
Actor.is_choring = function(arg1, arg2, arg3, arg4) -- line 1170
    return IsActorChoring(arg1.hActor, arg2, arg3, arg4)
end
Actor.is_resting = function(arg1) -- line 1178
    return IsActorResting(arg1.hActor)
end
Actor.is_turning = function(arg1) -- line 1186
    return IsActorTurning(arg1.hActor)
end
Actor.set_costume = function(arg1, arg2) -- line 1197
    local local1, local2
    SetActorCostume(arg1.hActor, nil)
    arg1.base_costume = arg2
    local1 = SetActorCostume(arg1.hActor, arg2)
    return local1
end
Actor.is_walking = function(arg1) -- line 1209
    if arg1:is_choring(arg1.walk_chore, TRUE, arg1.base_costume) then
        return TRUE
    else
        return FALSE
    end
end
Actor.get_costume = function(arg1, arg2) -- line 1221
    return GetActorCostume(arg1.hActor, arg2)
end
Actor.print_costumes = function(arg1) -- line 1229
    PrintActorCostumes(arg1.hActor)
end
Actor.push_costume = function(arg1, arg2) -- line 1242
    PushActorCostume(arg1.hActor, arg2)
end
Actor.pop_costume = function(arg1) -- line 1254
    if GetActorCostumeDepth(arg1.hActor) > 1 then
        return PopActorCostume(arg1.hActor)
    else
        PrintDebug("WARNING!! Trying to pop off last costume in stack!\n")
        return FALSE
    end
end
Actor.get_costume = function(arg1) -- line 1268
    return GetActorCostume(arg1.hActor)
end
Actor.multi_pop_costume = function(arg1, arg2) -- line 1277
    local local1
    if arg2 then
        local1 = arg2
    else
        local1 = 1
    end
    while GetActorCostumeDepth(arg1.hActor) > local1 do
        arg1:pop_costume()
    end
end
Actor.set_talk_color = function(arg1, arg2) -- line 1295
    SetActorTalkColor(arg1.hActor, arg2)
end
Actor.set_walk_chore = function(arg1, arg2, arg3) -- line 1303
    arg1.walk_chore = arg2
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorWalkChore(arg1.hActor, arg2, arg3)
end
Actor.set_turn_chores = function(arg1, arg2, arg3, arg4) -- line 1314
    if not arg4 then
        arg4 = arg1.base_costume
    end
    SetActorTurnChores(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_rest_chore = function(arg1, arg2, arg3) -- line 1324
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorRestChore(arg1.hActor, arg2, arg3)
end
Actor.set_mumble_chore = function(arg1, arg2, arg3) -- line 1334
    if not arg3 then
        arg3 = arg1.base_costume
    end
    SetActorMumblechore(arg1.hActor, arg2, arg3)
end
Actor.set_talk_chore = function(arg1, arg2, arg3, arg4) -- line 1345
    if not arg4 then
        arg4 = arg1.base_costume
    end
    SetActorTalkChore(arg1.hActor, arg2, arg3, arg4)
end
Actor.set_turn_rate = function(arg1, arg2) -- line 1355
    SetActorTurnRate(arg1.hActor, arg2)
end
Actor.set_walk_rate = function(arg1, arg2) -- line 1363
    SetActorWalkRate(arg1.hActor, arg2)
end
Actor.set_head = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 1372
    SetActorHead(arg1.hActor, arg2, arg3, arg4, arg5, arg6, arg7)
end
Actor.head_look_at = function(arg1, arg2, arg3) -- line 1381
    if type(arg2) == "table" then
        if arg2.interest_actor then
            ActorLookAt(arg1.hActor, arg2.interest_actor.hActor, arg3)
        else
            ActorLookAt(arg1.hActor, arg2.hActor, arg3)
        end
    else
        ActorLookAt(arg1.hActor, nil, arg3)
    end
end
Actor.head_look_at_point = function(arg1, arg2, arg3, arg4, arg5) -- line 1404
    if type(arg2) == "table" then
        ActorLookAt(arg1.hActor, arg2.x, arg2.y, arg2.z, arg3)
    else
        ActorLookAt(arg1.hActor, arg2, arg3, arg4, arg5)
    end
end
Actor.head_look_at_manny = function(arg1, arg2) -- line 1418
    local local1, local2, local3 = GetActorNodeLocation(manny.hActor, 6)
    arg1:head_look_at_point(local1, local2, local3, arg2)
end
Actor.head_follow_mesh = function(arg1, arg2, arg3, arg4) -- line 1427
    local local1, local2, local3
    repeat
        local1, local2, local3 = GetActorNodeLocation(arg2.hActor, arg3)
        if local1 then
            arg1:head_look_at_point(local1, local2, local3)
        end
        break_here()
    until arg4
end
Actor.kill_head_script = function(arg1) -- line 1442
    if arg1.head_script then
        if find_script(arg1.head_script) then
            stop_script(arg1.head_script)
        end
        arg1.head_script = nil
    end
end
Actor.set_look_rate = function(arg1, arg2) -- line 1456
    SetActorLookRate(arg1.hActor, arg2)
end
Actor.get_look_rate = function(arg1) -- line 1466
    return GetActorLookRate(arg1.hActor)
end
Actor.set_visibility = function(arg1, arg2) -- line 1475
    SetActorVisibility(arg1.hActor, arg2)
end
Actor.set_frustrum_culling = function(arg1, arg2) -- line 1489
    SetActorFrustrumCull(arg1.hActor, arg2)
end
Actor.set_selected = function(arg1) -- line 1498
    SetSelectedActor(arg1.hActor)
    system.currentActor = arg1
end
Actor.find_sector_name = function(arg1, arg2) -- line 1509
    return IsActorInSector(arg1.hActor, arg2)
end
Actor.find_sector_type = function(arg1, arg2) -- line 1519
    if arg2 == nil then
        return GetActorSector(arg1.hActor, WALK)
    else
        return GetActorSector(arg1.hActor, arg2)
    end
end
Actor.follow_boxes = function(arg1) -- line 1527
    SetActorFollowBoxes(arg1.hActor, TRUE)
    arg1.following_boxes = TRUE
end
Actor.ignore_boxes = function(arg1) -- line 1533
    SetActorFollowBoxes(arg1.hActor, FALSE)
    arg1.following_boxes = FALSE
end
Actor.put_in_set = function(arg1, arg2) -- line 1544
    if type(arg2) == "table" then
        doorman_in_hot_box = TRUE
        PutActorInSet(arg1.hActor, arg2.setFile)
    else
        PutActorInSet(arg1.hActor, nil)
    end
end
Actor.free = function(arg1) -- line 1557
    PrintDebug("Freed actor " .. arg1.name .. "!!\n")
    if arg1.frozen then
        arg1.frozen.frozen_actors[arg1.hActor] = nil
        arg1.frozen = nil
    end
    arg1:stop_chore(nil)
    arg1:set_costume(nil)
    arg1:put_in_set(nil)
end
Actor.stop_walk = function(arg1) -- line 1574
    local local1 = arg1:getpos()
    arg1:walkto(local1.x, local1.y, local1.z)
end
Actor.fake_walkto = function(arg1, arg2, arg3, arg4, arg5) -- line 1588
    local local1, local2, local3
    local local4 = GetActorWalkRate(arg1.hActor)
    local2 = { x = arg2, y = arg3, z = arg4 }
    local1 = GetActorYawToPoint(arg1.hActor, local2)
    arg1:setrot(0, local1, 0, TRUE)
    arg1:wait_for_actor()
    arg1.bob_script = start_script(arg1.fake_bob_walk, arg1, arg5)
    local3 = proximity(arg1.hActor, arg2, arg3, arg4)
    repeat
        local3 = proximity(arg1.hActor, arg2, arg3, arg4)
        if local3 <= PerSecond(GetActorWalkRate(arg1.hActor)) then
            arg1:set_walk_rate(local3 - 0.0099999998)
        end
        WalkActorForward(arg1.hActor)
        break_here()
    until local3 <= 0.050000001
    stop_script(arg1.bob_script)
    arg1:setpos(arg2, arg3, arg4)
    arg1:set_walk_rate(local4)
end
Actor.fake_bob_walk = function(arg1, arg2) -- line 1612
    local local1, local2, local3
    if not arg2 then
        arg2 = 40
    end
    local1 = arg1:getpos()
    local2 = local1.z
    local3 = 10
    while TRUE do
        local1.z = local2 + sin(local3) / arg2
        arg1:setpos(local1.x, local1.y, local1.z)
        local3 = local3 + rndint(10, 20) * (GetActorWalkRate(arg1.hActor) * 10)
        if local3 > 360 then
            local3 = local3 - 360
        end
        break_here()
        local1 = arg1:getpos()
    end
end
Actor.put_at_interest = function(arg1) -- line 1638
    PutActorAtInterest(arg1.hActor)
end
Actor.put_at_object = function(arg1, arg2) -- line 1647
    if type(arg2) == "table" then
        PrintDebug("Putting " .. arg1.name .. " at object " .. arg2.name .. " in set " .. arg2.obj_set.name .. "\n")
        arg1:setpos(arg2.use_pnt_x, arg2.use_pnt_y, arg2.use_pnt_z)
        arg1:setrot(arg2.use_rot_x, arg2.use_rot_y, arg2.use_rot_z)
        arg1:put_in_set(arg2.obj_set)
    else
        PrintDebug("put_at_object():  invalid object!\n")
    end
end
Actor.clear_hands = function(arg1) -- line 1659
    if arg1.is_holding then
        arg1.is_holding:put_away()
    end
end
Actor.set_speech_mode = function(arg1, arg2) -- line 1673
    if not arg1.saylineTable then
        arg1.saylineTable = { }
    end
    arg1.saylineTable.background = arg2
end
Actor.skip_log = function(arg1, arg2) -- line 1686
    if not arg1.saylineTable then
        arg1.saylineTable = { }
    end
    arg1.saylineTable.skip_log = arg2
end
Actor.normal_say_line = function(arg1, arg2, arg3) -- line 1698
    local local1
    local1 = union_table(arg1.saylineTable, arg3)
    if not local1.background then
        system.lastActorTalking = arg1
    end
    SayLine(arg1.hActor, arg2, local1)
    if not local1.skip_log then
        dialog_log:log_say_line(arg1, arg2)
    end
end
Actor.underwater_say_line = function(arg1, arg2, arg3) -- line 1718
    local local1
    local1 = start_sfx("bubvox.imu")
    Actor.normal_say_line(arg1, arg2, arg3)
    start_script(arg1.wait_for_underwater_message, arg1, local1)
end
Actor.wait_for_underwater_message = function(arg1, arg2) -- line 1726
    while IsMessageGoing(arg1.hActor) do
        break_here()
    end
    stop_sound(arg2)
end
Actor.say_line = Actor.normal_say_line
Actor.wait_for_message = function(arg1) -- line 1736
    while IsMessageGoing(arg1.hActor) do
        break_here()
    end
end
Actor.wait_and_say_line = function(arg1, arg2) -- line 1742
    break_here()
    wait_for_message()
    arg1:say_line(arg2)
end
Actor.is_speaking = function(arg1) -- line 1748
    if IsMessageGoing(arg1.hActor) then
        return TRUE
    else
        return FALSE
    end
end
Actor.shut_up = function(arg1) -- line 1760
    ShutUpActor(arg1.hActor)
end
shut_up_everybody = function() -- line 1768
    local local1, local2
    local1, local2 = next(system.actorTable, nil)
    while local1 do
        if IsMessageGoing(local2.hActor) then
            ShutUpActor(local2.hActor)
        end
        local1, local2 = next(system.actorTable, local1)
    end
end
Actor.angle_to_actor = function(arg1, arg2) -- line 1785
    return GetAngleBetweenActors(arg1.hActor, arg2.hActor)
end
Actor.angle_to_object = function(arg1, arg2) -- line 1793
    return GetAngleBetweenActors(arg1.hActor, arg2.interest_actor.hActor)
end
Actor.voice_line = function(arg1, arg2, arg3, arg4, arg5) -- line 1805
    if 1 then
        arg1:say_line(arg2.text, arg1.talk_in_background)
    else
        if not arg3 then
            arg3 = 3.5
        end
        if not arg4 then
            arg4 = 3.5
        end
        if not arg5 then
            arg5 = 1
        end
        if text_mode == "Text Only" or text_mode == "Text and Voice" or not arg2.hSound then
            arg1:say_line(arg2.text, arg1.talk_in_background)
        end
        if arg2.hSound and text_mode ~= "Text Only" then
            PlaySoundAt(arg2.hSound, arg1.hActor, arg3, arg4, arg5)
            while IsSoundPlaying(arg2.hSound) do
                break_here()
            end
        end
        wait_for_message()
    end
end
Actor.has_any = function(arg1, arg2) -- line 1840
    local local1, local2 = next(arg2, nil)
    while local1 do
        if type(local2) == "table" then
            if local2.owner == arg1 then
                return TRUE
            end
        end
        local1, local2 = next(arg2, local1)
    end
    return FALSE
end
print_actor_coordinates = function(arg1) -- line 1863
    local local1, local2, local3
    local local4, local5
    if not arg1 then
        local4 = InputDialog("Actor Coordinates", "Enter name of actor (manny is the default):")
        if local4 == nil or local4 == "" then
            local4 = "manny"
        end
        local5 = getglobal(local4)
    else
        local5 = arg1
    end
    if local5 ~= nil and type(local5) == "table" then
        local1 = local5:getpos()
        local2 = local5:get_positive_rot()
        local3 = local5:get_softimage_pos()
        if abs(local1.z) < 1e-06 then
            local1.z = 0
        end
        PrintDebug(local4 .. ":setpos(" .. local1.x .. ", " .. local1.y .. ", " .. local1.z .. ")\n")
        PrintDebug(local4 .. ":setrot(" .. local2.x .. ", " .. local2.y .. ", " .. local2.z .. ")\n")
        PrintDebug(local4 .. ":set_softimage_pos(" .. local3.x .. ", " .. local3.y .. ", " .. local3.z .. ")\n")
        PrintDebug("start_script(" .. local4 .. ".walk_and_face," .. local4 .. "," .. local1.x .. ", " .. local1.y .. ", " .. local1.z .. ", " .. local2.x .. ", " .. local2.y .. ", " .. local2.z .. ")\n")
    else
        PrintDebug("Actor \"" .. local4 .. "\" not recognized!\n")
    end
end
system.idleTemplate = { }
Idle = system.idleTemplate
Idle.create = function(arg1, arg2) -- line 1906
    local local1 = { }
    local1.parent = arg1
    local1.root_name = arg2
    return local1
end
Idle.add_state = function(arg1, arg2, arg3) -- line 1913
    local local1, local2
    local local3, local4
    if type(arg3) ~= "table" then
        PrintDebug("Not a valid branch_table for new state " .. arg2 .. "\n")
        return nil
    end
    local1 = arg1.root_name .. "_" .. arg2
    arg1[local1] = { }
    local3, local4 = next(arg3, nil)
    while local3 do
        local2 = arg1.root_name .. "_" .. local3
        arg1[local1][local2] = local4
        local3, local4 = next(arg3, local3)
    end
end
run_idle = function(arg1, arg2, arg3) -- line 1945
    local local1 = arg3
    local local2
    local local3 = system.currentSet
    while system.currentSet == local3 and local1 do
        PlayActorChore(arg1.hActor, local1)
        wait_for_actor(arg1.hActor)
        local2 = pick_from_weighted_table(arg2[local1])
        if local2 then
            local1 = local2
        end
    end
end
Actor.spin = function(arg1) -- line 1975
    local local1, local2, local3
    local local4 = 1
    local1 = 1
    local2 = 360
    local3 = 1
    while 1 do
        arg1:setrot(local1, local2, local3)
        local4 = local4 + 10
        local1 = local1 + 10
        local2 = local2 - 10
        local3 = local3 + 10
        if local4 == 361 then
            local1 = 1
            local2 = 360
            local3 = 1
        end
        break_here()
    end
end
Actor.create_dialogStack = function(arg1) -- line 2013
    arg1.dialogStack = { }
    arg1.dialogStack.parseFunction = nil
    arg1.dialogStack.head = 0
    arg1.dialogStack.tail = 0
end
Actor.push_chore = function(arg1, arg2, arg3, arg4, arg5) -- line 2028
    if not arg2 then
        arg2 = "wait"
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = arg2, isLooping = arg3, fade_in_time = arg4, fade_out_time = arg5 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if not find_script(arg1.execute_dialogStack) then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
    PrintDebug("pushing chore " .. arg2 .. "\n")
end
Actor.push_chore_times = function(arg1, arg2, arg3) -- line 2051
    local local1
    local1 = 0
    while local1 < arg3 do
        arg1:push_chore(arg2, CHORE_NOLOOP)
        arg1:push_chore()
        local1 = local1 + 1
    end
end
Actor.push_break = function(arg1, arg2) -- line 2066
    if not arg2 then
        arg2 = 1
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = "break_here", frames = arg2 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if arg1.dialogStack.parseFunction == nil then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
end
Actor.push_sleep = function(arg1, arg2) -- line 2083
    if not arg2 then
        arg2 = 1000
    end
    arg1.dialogStack[arg1.dialogStack.tail] = { chore = "sleep_for", msecs = arg2 }
    arg1.dialogStack.tail = arg1.dialogStack.tail + 1
    if arg1.dialogStack.parseFunction == nil then
        arg1.dialogStack.parseFunction = start_script(arg1.execute_dialogStack, arg1)
    end
end
Actor.execute_dialogStack = function(arg1) -- line 2107
    local local1, local2
    local local3 = arg1:get_costume(nil)
    local local4
    local1 = arg1.dialogStack[arg1.dialogStack.head]
    while local1 ~= nil do
        PrintDebug("dialogStack: " .. local1.chore .. "\n")
        if local1.chore == "wait" then
            arg1:wait_for_chore()
        elseif local1.chore == "break_here" then
            local2 = 0
            while local2 < local1.frames do
                break_here()
                local2 = local2 + 1
            end
        elseif local1.chore == "sleep_for" then
            sleep_for(local1.msecs)
        elseif local1.isLooping == CHORE_LOOP then
            arg1:play_chore_looping(local1.chore)
        elseif local1.fade_in_time then
            PrintDebug("Fading in chore " .. local1.chore .. "\n")
            if local4 then
                arg1:blend(local1.chore, local4.chore, local1.fade_in_time, local3)
            else
                FadeInChore(arg1.hActor, local3, local1.chore, local1.fade_in_time)
            end
        else
            PrintDebug("playing chore " .. local1.chore .. "\n")
            arg1:play_chore(local1.chore)
        end
        if local1.fade_out_time then
            arg1:wait_for_chore()
            PrintDebug("Fading out chore " .. local1.chore .. "\n")
            FadeOutChore(arg1.hActor, local3, local1.chore, local1.fade_in_time)
        end
        if local1.chore ~= "wait" and local1.chore ~= "break_here" and local1 ~= "sleep_for" then
            local4 = local1
        end
        arg1.dialogStack[arg1.dialogStack.head] = nil
        arg1.dialogStack.head = arg1.dialogStack.head + 1
        local1 = arg1.dialogStack[arg1.dialogStack.head]
    end
    arg1.dialogStack.head = 0
    arg1.dialogStack.tail = 0
    arg1.dialogStack.parseFunction = nil
end
Actor.play_sound_at = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 2176
    local local1
    if not arg5 then
        arg5 = IM_HIGH_PRIORITY
    end
    if not arg6 then
        arg6 = IM_GROUP_SFX
    end
    local1 = ImStartSound(arg2, arg5, arg6)
    SetSoundPosition(local1, arg1.hActor, arg3, arg4)
    return local1
end
Actor.move_sound_to = function(arg1, arg2, arg3, arg4) -- line 2196
    SetSoundPosition(arg2, arg1.hActor, arg3, arg4)
end
Actor.play_attached_sound = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 2211
    local local1
    if not arg5 then
        arg5 = IM_HIGH_PRIORITY
    end
    if not arg6 then
        arg6 = IM_GROUP_SFX
    end
    ImStartSound(arg2, arg5, arg6)
    local1 = start_script(arg1.attach_sound, arg1, arg2, arg3, arg4)
    wait_for_script(local1)
end
Actor.attach_sound = function(arg1, arg2, arg3, arg4) -- line 2233
    start_script(arg1.attach_sound_script, arg1, arg2, arg3, arg4)
end
Actor.attach_sound_script = function(arg1, arg2, arg3, arg4) -- line 2248
    while sound_playing(arg2) do
        SetSoundPosition(arg2, arg1.hActor, arg3, arg4)
    end
end
Actor.play_footstep_sfx = function(arg1, arg2, arg3, arg4) -- line 2263
    arg1:play_sound_at(arg2, arg3, arg4, IM_MED_PRIORITY)
end
Actor.costumeMarkerHandler = function(arg1, arg2, arg3) -- line 2274
    local local1 = system.actorTable[arg2]
    local local2 = FALSE
    if local1 ~= nil then
        if local1.costume_marker_handler then
            local2 = TRUE
            local1:costume_marker_handler(arg3)
        elseif local1.costume_marker_handler == bird_sound_monitor then
            local2 = TRUE
            local1:costume_marker_handler(arg3)
        end
    end
    if not local2 and local1 ~= nil and local1.footsteps ~= nil and not local1:is_resting() then
        local1:play_default_footstep(arg3)
    end
end
Actor.play_default_footstep = function(arg1, arg2, arg3) -- line 2298
    local local1
    local local2, local3
    local local4, local5
    if not arg3 then
        local1 = arg1.footsteps
    else
        local1 = arg3
    end
    local2 = local1.prefix
    local3 = nil
    local4 = 10
    local5 = 64
    if arg2 == Actor.MARKER_LEFT_WALK then
        local2 = local2 .. "wl"
        local3 = rndint(1, local1.left_walk)
    elseif arg2 == Actor.MARKER_RIGHT_WALK then
        local2 = local2 .. "wr"
        local3 = rndint(1, local1.right_walk)
    elseif arg2 == Actor.MARKER_LEFT_TURN then
        local2 = local2 .. "wl"
        local3 = rndint(1, local1.left_walk)
        local4 = 5
        local5 = 20
    elseif arg2 == Actor.MARKER_RIGHT_TURN then
        local2 = local2 .. "wr"
        local3 = rndint(1, local1.right_walk)
        local4 = 5
        local5 = 20
    elseif arg2 == Actor.MARKER_LEFT_RUN then
        if local1.left_run and local1.left_run > 0 then
            local2 = local2 .. "rl"
            local3 = rndint(1, local1.left_run)
        else
            local2 = local2 .. "wl"
            local3 = rndint(1, local1.left_walk)
        end
    elseif arg2 == Actor.MARKER_RIGHT_RUN then
        if local1.right_run and local1.right_run > 0 then
            local2 = local2 .. "rr"
            local3 = rndint(1, local1.right_run)
        else
            local2 = local2 .. "wr"
            local3 = rndint(1, local1.right_walk)
        end
    end
    if local3 then
        local2 = local2 .. local3 .. ".wav"
        arg1:play_footstep_sfx(local2, local4, local5)
    end
end
Actor.costumeOverrideHandler = function(arg1, arg2, arg3) -- line 2356
    if arg3 then
        arg1.idles_allowed = FALSE
    else
        arg1.idles_allowed = TRUE
    end
end
Actor.collisionHandler = function(arg1, arg2, arg3) -- line 2364
    local local1 = system.actorTable[arg2]
    local local2 = system.actorTable[arg3]
    if local1 ~= nil then
        if local1.collision_handler then
            PrintDebug(local1.name .. " has run into " .. local2.name)
            single_start_script(local1.collision_handler, local1, local2)
        end
    end
end
Actor.collision_handler = function(arg1, arg2) -- line 2376
end
system.costumeMarkerHandler = Actor
system.costumeOverrideHandler = Actor
system.collisionHandler = Actor
footsteps = { }
footsteps.concrete = { prefix = "fscon", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.dirt = { prefix = "fsdrt", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.gravel = { prefix = "fsgrv", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.creak = { prefix = "fscrk", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.marble = { prefix = "fsmar", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.metal = { prefix = "fsmet", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.pavement = { prefix = "fspav", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.rug = { prefix = "fsrug", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.sand = { prefix = "fssnd", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.snow = { prefix = "fssno", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.trapdoor = { prefix = "fstrp", left_walk = 1, right_walk = 1, left_run = 1, right_run = 1 }
footsteps.echo = { prefix = "fseko", left_walk = 4, right_walk = 4, left_run = 4, right_run = 4 }
footsteps.reverb = { prefix = "fsrvb", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.metal2 = { prefix = "fs3mt", left_walk = 4, right_walk = 4, left_run = 2, right_run = 2 }
footsteps.wet = { prefix = "fswet", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.flowers = { prefix = "fsflw", left_walk = 2, right_walk = 2, left_run = 2, right_run = 2 }
footsteps.glottis = { prefix = "fsglt", left_walk = 2, right_walk = 2 }
footsteps.jello = { prefix = "fsjll", left_walk = 2, right_walk = 2 }
footsteps.nick_virago = { prefix = "fsnic", left_walk = 2, right_walk = 2 }
footsteps.underwater = { prefix = "fswtr", left_walk = 3, right_walk = 3, left_run = 2, right_run = 2 }
footsteps.velasco = { prefix = "fsbcn", left_walk = 3, right_walk = 2 }
brennis = Actor:create(nil, nil, nil, "Tube-Switcher Guy")
brennis:set_talk_color(Red)
brennis.default = function(arg1) -- line 2441
    brennis:set_costume("brennis_fix_idle.cos")
    brennis:set_colormap("brennis.cmp")
    brennis:set_mumble_chore(brennis_fix_idle_mumble)
    brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
    brennis:set_talk_chore(2, brennis_fix_idle_a)
    brennis:set_talk_chore(3, brennis_fix_idle_c)
    brennis:set_talk_chore(4, brennis_fix_idle_e)
    brennis:set_talk_chore(5, brennis_fix_idle_f)
    brennis:set_talk_chore(6, brennis_fix_idle_l)
    brennis:set_talk_chore(7, brennis_fix_idle_m)
    brennis:set_talk_chore(8, brennis_fix_idle_o)
    brennis:set_talk_chore(9, brennis_fix_idle_t)
    brennis:set_talk_chore(10, brennis_fix_idle_u)
end
celso = Actor:create(nil, nil, nil, "Celso")
celso:set_talk_color(Yellow)
chepito = Actor:create(nil, nil, nil, "Chepito")
chepito.default = function(arg1) -- line 2463
    if not chepito.hCos then
        chepito.hCos = "chepito.cos"
    end
    chepito:set_visibility(TRUE)
    chepito:set_costume(chepito.hCos)
    chepito:set_talk_color(Green)
    chepito:set_walk_chore(chepito_walk)
    chepito:set_mumble_chore(chepito_mumble)
    chepito:set_talk_chore(1, chepito_m)
    chepito:set_talk_chore(2, chepito_a)
    chepito:set_talk_chore(3, chepito_c)
    chepito:set_talk_chore(4, chepito_e)
    chepito:set_talk_chore(5, chepito_f)
    chepito:set_talk_chore(6, chepito_l)
    chepito:set_talk_chore(7, chepito_m)
    chepito:set_talk_chore(8, chepito_o)
    chepito:set_talk_chore(9, chepito_t)
    chepito:set_talk_chore(10, chepito_u)
    chepito:set_head(3, 4, 5, 165, 28, 80)
end
domino = Actor:create(nil, nil, nil, "Domino")
domino:set_talk_color(Yellow)
domino.default = function(arg1) -- line 2490
    domino:set_colormap("domino.cmp")
    domino:set_talk_color(Yellow)
end
eva = Actor:create(nil, nil, nil, "/sytx088/")
eva:set_talk_color(Red)
eva.default = function(arg1, arg2) -- line 2497
    if arg2 == "sec" then
        eva:set_costume("eva_sec.cos")
        eva:set_mumble_chore(eva_sec_mumble, "eva_sec.cos")
        eva:set_talk_chore(1, eva_sec_mouth_m)
        eva:set_talk_chore(2, eva_sec_mouth_a)
        eva:set_talk_chore(3, eva_sec_mouth_c)
        eva:set_talk_chore(4, eva_sec_mouth_e)
        eva:set_talk_chore(5, eva_sec_mouth_f)
        eva:set_talk_chore(6, eva_sec_mouth_l)
        eva:set_talk_chore(7, eva_sec_mouth_m)
        eva:set_talk_chore(8, eva_sec_mouth_o)
        eva:set_talk_chore(9, eva_sec_mouth_t)
        eva:set_talk_chore(10, eva_sec_mouth_u)
    else
        eva:set_costume("ev_r_idles.cos")
    end
    eva:set_colormap("eva_sv.cmp")
    eva:set_talk_color(Red)
    eva:ignore_boxes()
end
manny = Actor:create(nil, nil, nil, "Manny")
manny.costume_state = "suit"
dofile("_manny.lua")
meche = Actor:create(nil, nil, nil, "Meche")
meche:set_talk_color(Green)
dofile("olivia_talks.lua")
olivia = Actor:create(nil, nil, nil, "Olivia")
olivia:set_talk_color(MakeColor(164, 18, 147))
olivia.default = function(arg1) -- line 2531
    olivia:set_costume(nil)
    olivia:set_costume("olivia_talks.cos")
    olivia:set_mumble_chore(olivia_talks_mumble, "olivia_talks.cos")
    olivia:set_talk_chore(1, olivia_talks_stop_talk)
    olivia:set_talk_chore(2, olivia_talks_a)
    olivia:set_talk_chore(3, olivia_talks_c)
    olivia:set_talk_chore(4, olivia_talks_e)
    olivia:set_talk_chore(5, olivia_talks_f)
    olivia:set_talk_chore(6, olivia_talks_l)
    olivia:set_talk_chore(7, olivia_talks_m)
    olivia:set_talk_chore(8, olivia_talks_o)
    olivia:set_talk_chore(9, olivia_talks_t)
    olivia:set_talk_chore(10, olivia_talks_u)
    olivia:push_costume("olivia_idles.cos")
    olivia:set_walk_chore(olivia_idles_walk, "olivia_idles.cos")
    olivia:set_head(5, 6, 7, 165, 28, 80)
    olivia:set_look_rate(110)
    olivia:set_collision_mode(COLLISION_SPHERE, 0.2)
end
salvador = Actor:create(nil, nil, nil, "/sytx198/")
salvador:set_talk_color(DarkGreen)
salvador.default = function(arg1) -- line 2556
    salvador:ignore_boxes()
    if not salvador.hCos then
        salvador.hCos = "sv_in_hq.cos"
    end
    salvador:set_costume(salvador.hCos)
    salvador:set_colormap("eva_sv.cmp")
    salvador:set_head(3, 4, 5, 165, 28, 80)
    salvador:set_look_rate(90)
end
toto = Actor:create(nil, nil, nil, "Toto")
toto.default = function(arg1) -- line 2568
    toto:set_colormap("toto.cmp")
    toto:set_talk_color(Yellow)
end
dofile("velasco.lua")
velasco = Actor:create(nil, nil, nil, "Velasco")
velasco.default = function(arg1) -- line 2575
    velasco:free()
    velasco:set_costume("velasco.cos")
    velasco:set_colormap("velasco.cmp")
    velasco:set_talk_color(Blue)
    velasco:set_head(3, 4, 5, 165, 28, 80)
    velasco:set_walk_rate(0.38)
    velasco:set_look_rate(180)
    velasco:set_mumble_chore(velasco_mumble)
    velasco:set_talk_chore(1, velasco_stop_talk)
    velasco:set_talk_chore(2, velasco_a)
    velasco:set_talk_chore(3, velasco_c)
    velasco:set_talk_chore(4, velasco_e)
    velasco:set_talk_chore(5, velasco_f)
    velasco:set_talk_chore(6, velasco_l)
    velasco:set_talk_chore(7, velasco_m)
    velasco:set_talk_chore(8, velasco_o)
    velasco:set_talk_chore(9, velasco_t)
    velasco:set_talk_chore(10, velasco_u)
    velasco:set_turn_rate(85)
    velasco:set_collision_mode(COLLISION_OFF)
    velasco:set_walk_chore(velasco_walk, "velasco.cos")
end
dofile("_actors1.lua")
dofile("_actors2.lua")
dofile("_actors3.lua")
dofile("_actors4.lua")

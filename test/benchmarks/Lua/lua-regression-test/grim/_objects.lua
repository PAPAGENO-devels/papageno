IN_THE_ROOM = nil
IN_LIMBO = 999
x_spot_cos = "x_spot.cos"
system.objectTemplate = { name = "<unnamed>", owner = nil, obj_x = nil, obj_y = nil, obj_z = nil, obj_set = nil, touchable = FALSE, owner = IN_THE_ROOM, shrink_radius = nil, interest_actor = nil, wav = nil }
Object = system.objectTemplate
Object.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 51
    arg7.parent = arg1
    arg7.name = arg3
    arg7.obj_x = arg4
    arg7.obj_y = arg5
    arg7.obj_z = arg6
    arg7.obj_set = arg2
    arg7.touchable = TRUE
    arg7.owner = IN_THE_ROOM
    arg7.wav = nil
    arg7.string_name = trim_header(arg3)
    arg7.big = FALSE
    arg7.can_put_away = TRUE
    arg7.shrink_radius = 0.015
    arg7.interest_actor = Actor:create(nil, nil, nil, arg3)
    arg7.interest_actor:moveto(arg4, arg5, arg6)
    arg7.interest_actor:put_in_set(arg2)
    arg7.interest_actor:set_visibility(FALSE)
    arg7.has_object_states = FALSE
    parent_object[arg7.interest_actor.hActor] = arg7
    return arg7
end
Object.update_look_point = function(arg1) -- line 85
    arg1.interest_actor:setpos(arg1.obj_x, arg1.obj_y, arg1.obj_z)
end
Object.lookAt = function(arg1) -- line 93
    manny:say_line("/syma159/")
end
Object.use = function(arg1) -- line 101
    system.currentActor:say_line("/syma160/")
end
Object.set_object_state = function(arg1, arg2) -- line 110
    PrintDebug("SETTING object state for " .. arg1.name .. " to " .. arg2 .. "\n")
    arg1.obj_set.object_states[arg1] = TRUE
    arg1.interest_actor:set_costume(arg2)
    arg1.interest_actor:set_visibility(TRUE)
    arg1.interest_actor:put_in_set(arg1.obj_set)
    arg1.has_object_states = TRUE
end
Object.free_object_state = function(arg1) -- line 123
    PrintDebug("FREEING object state for " .. arg1.name .. "\n")
    arg1.obj_set.object_states[arg1] = FALSE
    arg1.interest_actor:set_costume(nil)
    arg1.interest_actor:put_in_set(nil)
end
Object.set_type = function(arg1, arg2) -- line 138
    if arg1.hObjectState then
        SetObjectType(arg1.hObjectState, arg2)
    else
        PrintDebug("***\nError: cannot set object state type!\n\t(See Object:set_type()\n****")
    end
end
Object.play_chore = function(arg1, arg2, arg3) -- line 155
    arg1.interest_actor:play_chore(arg2, arg3)
end
Object.wait_for_chore = function(arg1, arg2, arg3) -- line 159
    arg1.interest_actor:wait_for_chore(arg2, arg3)
end
Object.play_chore_looping = function(arg1, arg2, arg3) -- line 163
    arg1.interest_actor:play_chore_looping(arg2, arg3)
end
Object.stop_chore = function(arg1, arg2, arg3) -- line 167
    arg1.interest_actor:stop_chore(arg2, arg3)
end
Object.complete_chore = function(arg1, arg2, arg3) -- line 171
    arg1.interest_actor:complete_chore(arg2, arg3)
end
Object.run_chore = function(arg1, arg2, arg3) -- line 175
    arg1.interest_actor:run_chore(arg2, arg3)
end
Object.stop_looping_chore = function(arg1, arg2, arg3) -- line 179
    arg1.interest_actor:stop_looping_chore(arg2, arg3)
end
Object.pickUp = function(arg1) -- line 193
    system.currentActor:say_line("/syma161/")
end
Object.get = function(arg1) -- line 197
    Inventory:add_item_to_inventory(arg1)
    if system.object_names_showing then
        start_script(system.currentSet.update_object_names, system.currentSet)
    end
end
Object.free = function(arg1) -- line 204
    if arg1.owner == system.currentActor then
        Inventory:remove_item_from_inventory(arg1)
    end
    arg1.owner = IN_THE_ROOM
end
Object.put_in_limbo = function(arg1) -- line 211
    Inventory:remove_item_from_inventory(arg1)
    arg1.owner = IN_LIMBO
end
Object.hold = function(arg1) -- line 216
    manny:generic_pickup(arg1)
end
Object.put_away = function(arg1) -- line 225
    put_away_held_item()
    return TRUE
end
Object.make_touchable = function(arg1) -- line 230
    arg1.touchable = TRUE
    arg1.obj_set:make_objects_visible()
    arg1.interest_actor:put_in_set(arg1.obj_set)
    arg1.interest_actor:setpos(arg1.obj_x, arg1.obj_y, arg1.obj_z)
    if system.object_names_showing then
        start_script(system.currentSet.update_object_names, system.currentSet)
    end
end
Object.make_untouchable = function(arg1) -- line 240
    arg1.touchable = FALSE
    if not arg1.has_object_states then
        arg1.interest_actor:put_in_set(nil)
    end
    if system.object_names_showing then
        start_script(system.currentSet.update_object_names, system.currentSet)
    end
end
Object.open = function(arg1) -- line 257
    local local1, local2
    if not arg1:is_locked() then
        arg1.opened = TRUE
        if arg1.passage then
            local1, local2 = next(arg1.passage, nil)
            while local2 do
                MakeSectorActive(local2, TRUE)
                local1, local2 = next(arg1.passage, local1)
            end
        end
        return TRUE
    else
        return nil
    end
end
Object.locked_out = function(arg1) -- line 283
    system.default_response("locked")
end
Object.close = function(arg1) -- line 291
    local local1, local2
    arg1.opened = FALSE
    if arg1.passage then
        local1, local2 = next(arg1.passage, nil)
        while local2 do
            MakeSectorActive(local2, FALSE)
            local1, local2 = next(arg1.passage, local1)
        end
    end
end
Object.is_open = function(arg1) -- line 310
    return arg1.opened
end
Object.lock = function(arg1) -- line 318
    arg1.locked = TRUE
end
Object.unlock = function(arg1) -- line 326
    arg1.locked = FALSE
end
Object.is_locked = function(arg1) -- line 334
    return arg1.locked
end
Object.come_out_door = function(arg1) -- line 343
    local local1 = { }
    local local2, local3, local4
    local local5
    if system.currentActor.is_backward then
        if arg1.use_pnt_x then
            system.currentActor:setpos(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
            if arg1.use_rot_x then
                system.currentActor:setrot(arg1.use_rot_x, arg1.use_rot_y, arg1.use_rot_z)
            end
        elseif arg1.out_pnt_x then
            system.currentActor:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
            if arg1.out_rot_x then
                system.currentActor:setrot(arg1.out_rot_x, arg1.out_rot_y, arg1.out_rot_z)
            end
        end
    elseif arg1.out_pnt_x then
        system.currentActor:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    elseif arg1.use_pnt_x then
        system.currentActor:setpos(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    end
    if arg1.obj_set then
        arg1.obj_set:force_camerachange()
    end
    if not system.currentActor.is_backward then
        if arg1.out_rot_x then
            system.currentActor:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
            if arg1.use_pnt_x then
                START_CUT_SCENE()
                if system.currentActor == manny then
                    manny:follow_boxes()
                end
                if system.currentActor.is_running then
                    system.currentActor:runto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
                else
                    system.currentActor:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
                end
                system.currentActor:wait_for_actor()
                if system.currentActor == manny then
                    manny:follow_boxes()
                end
                END_CUT_SCENE()
            end
        elseif arg1.use_rot_x then
            system.currentActor:setrot(arg1.use_rot_x, arg1.use_rot_y + 180, arg1.use_rot_z)
        end
    end
    if manny.is_holding == mo.scythe and in(system.currentSet.setFile, no_scythe_sets) then
        START_CUT_SCENE()
        put_away_held_item()
        END_CUT_SCENE()
    elseif shrinkBoxesEnabled and manny.is_holding then
        cameraman_disabled = FALSE
        START_CUT_SCENE()
        local1 = manny:getpos()
        if system.currentSet.shrinkable then
            local2, local3, local4 = GetShrinkPos(local1.x, local1.y, local1.z, manny.is_holding.shrink_radius)
            rot = manny:getrot()
            if manny.is_holding == mo.scythe and in(system.currentSet.setFile, need_scythe_sets) then
                manny:walkto(local2, local3, local4, rot.x, rot.y, rot.z)
                if system.currentSet.shrinkable < mo.scythe.shrink_radius and local2 ~= nil then
                    system.currentSet.boxes_shrunk = TRUE
                    ShrinkBoxes(system.currentSet.shrinkable)
                elseif local2 ~= nil then
                    system.currentSet.boxes_shrunk = TRUE
                    ShrinkBoxes(mo.scythe.shrink_radius)
                end
            elseif not local2 then
                put_away_held_item()
            else
                if local1.x ~= local2 or local1.y ~= local3 or local1.z ~= local4 then
                    manny:walkto(local2, local3, local4, rot.x, rot.y, rot.z)
                end
                if system.currentSet.shrinkable < manny.is_holding.shrink_radius then
                    ShrinkBoxes(system.currentSet.shrinkable)
                else
                    ShrinkBoxes(manny.is_holding.shrink_radius)
                end
                system.currentSet.boxes_shrunk = TRUE
            end
        end
        END_CUT_SCENE()
    end
end
system.ladderTemplate = { parent = system.objectTemplate, name = "<unnamed>", owner = nil, obj_x = nil, obj_y = nil, obj_z = nil, obj_set = nil, touchable = FALSE, owner = IN_THE_ROOM, interest_actor = nil, base = { }, top = { } }
Ladder = system.ladderTemplate
Ladder.create = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- line 466
    Object:create(arg2, arg3, arg4, arg5, arg6, arg7)
    arg7.parent = arg1
    arg7.base = { }
    arg7.top = { }
    arg7.base.name = arg3
    arg7.top.name = arg3
    return arg7
end
Ladder.climbOut = function(arg1, arg2) -- line 489
    local local1, local2
    PrintDebug("CLIMBING " .. arg2 .. "\n")
    if arg2 == arg1.base.box then
        local1 = arg1.base
    else
        local1 = arg1.top
    end
    if not system.currentActor.is_climbing then
        stop_script(move_actor)
        stop_script(rotate_actor_right)
        stop_script(rotate_actor_left)
        ResetMarioControls()
        manny:clear_hands()
        START_CUT_SCENE()
        system.currentActor:walkto(local1.use_pnt_x, local1.use_pnt_y, local1.use_pnt_z)
        system.currentActor:wait_for_actor()
        system.currentActor:setrot(local1.use_rot_x, local1.use_rot_y, local1.use_rot_z, TRUE)
        system.currentActor:wait_for_actor()
        system.currentActor:start_climb_ladder(arg1)
        while system.currentActor:find_sector_name(arg2) do
            if arg2 == arg1.base.box then
                local2 = start_script(system.currentActor.climb_up, system.currentActor)
                while find_script(local2) do
                    break_here()
                end
            else
                local2 = start_script(system.currentActor.climb_down, system.currentActor)
                while find_script(local2) do
                    break_here()
                end
            end
        end
        END_CUT_SCENE()
    else
        stop_script(climb_actor_up)
        stop_script(climb_actor_down)
        ResetMarioControls()
        START_CUT_SCENE()
        system.currentActor:setpos(local1.use_pnt_x, local1.use_pnt_y, local1.use_pnt_z)
        system.currentActor:stop_climb_ladder()
        if local1.out_pnt_x then
            system.currentActor:walkto(local1.out_pnt_x, local1.out_pnt_y, local1.out_pnt_z, local1.out_rot_x, local1.out_rot_y, local1.out_rot_z)
            system.currentActor:wait_for_actor()
        else
            system.currentActor:setrot(local1.use_rot_x, local1.use_rot_y + 180, local1.out_rot_z, TRUE)
        end
        END_CUT_SCENE()
        arg1:walkOut(arg2)
    end
end

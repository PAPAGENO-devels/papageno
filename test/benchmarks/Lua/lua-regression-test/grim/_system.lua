if __system_lua then
    return
end
dofile("setfallback.lua")
TRUE = 1
FALSE = nil
MAX_PROX = 0.08
MAX_GAZE_TIME = 2000
DOUBLE_TAP_DELAY = 100
initialized_objects = { }
parent_object = { }
cutSceneLevel = 1
GetSystemFonts = function() -- line 35
    talk_font = LockFont("treb13bs.laf")
    verb_font = talk_font
    pt_font = LockFont("ComicSans18.laf")
    special_font = LockFont("kino14s.laf")
    computer_font = LockFont("ocr10.laf")
    SetSayLineDefaults({ font = talk_font })
end
PL_MODE = FALSE
copy_table = function(table) -- line 64
    local new_table = { }
    local i, v
    i, v = next(table, nil)
    while i do
        new_table[i] = v
        i, v = next(table, i)
    end
    return new_table
end
union_table = function(table1, table2) -- line 82
    local new_table
    local i, v
    if table1 then
        new_table = copy_table(table1)
    else
        new_table = { }
    end
    if table2 then
        i, v = next(table2, nil)
        while i do
            new_table[i] = v
            i, v = next(table2, i)
        end
    end
    return new_table
end
in = function(item, table) -- line 107
    local i, v = next(table, nil)
    while i do
        if v == item then
            return TRUE
        else
            i, v = next(table, i)
        end
    end
    return FALSE
end
alloc_object_from_table = function(table) -- line 124
    local i, v = next(table, nil)
    while i do
        if v.owner ~= system.currentActor and v.owner ~= IN_LIMBO then
            return v
        else
            i, v = next(table, i)
        end
    end
    return nil
end
pick_from_weighted_table = function(table) -- line 146
    if type(table) ~= "table" then
        return nil
    end
    local weight_stack = 0
    local index, weight = next(table, nil)
    local pick = random()
    while index do
        weight_stack = weight_stack + weight
        if pick < weight_stack then
            return index
        end
        index, weight = next(table, index)
    end
    return nil
end
test_table = { "one", "two", "three", "four", "five" }
tt = function() -- line 186
    start_script(table_test, TRUE)
end
table_test = function() -- line 191
    local result, index
    while 1 do
        result, index = pick_from_nonweighted_table(test_table)
        PrintDebug("picked " .. result)
        PrintDebug("value of index in original table = " .. test_table[index])
        break_here()
    end
end
pick_from_nonweighted_table = function(table, bPickFeature) -- line 202
    local i, v
    local count = 0
    local all_picked = TRUE
    if bPickFeature then
        if not masterTable then
            masterTable = { }
        end
        if not masterTable[table] then
            masterTable[table] = { }
            i, v = next(table, nil)
            while i do
                masterTable[table][i] = { }
                masterTable[table][i].value = v
                PrintDebug(v)
                masterTable[table][i].marker = FALSE
                i, v = next(table, i)
            end
        else
            i, v = next(masterTable[table], nil)
            while i and all_picked do
                all_picked = masterTable[table][i].marker
                i, v = next(masterTable[table], i)
            end
            if all_picked then
                i, v = next(masterTable[table], nil)
                while i do
                    masterTable[table][i].marker = FALSE
                    i, v = next(masterTable[table], i)
                end
            end
        end
        i, v = next(masterTable[table], nil)
        while i do
            count = count + 1
            i, v = next(masterTable[table], i)
        end
        repeat
            i = rndint(1, count)
        until masterTable[table][i].marker == FALSE
        masterTable[table][i].marker = TRUE
        return masterTable[table][i].value, i
    else
        i, v = next(table, nil)
        if i then
            while i do
                count = count + 1
                i, v = next(table, i)
            end
            i = rndint(1, count)
            return table[i], i
        else
            return nil
        end
    end
end
pick_one_of = pick_from_nonweighted_table
pick_from_ordered_table = function(table) -- line 285
    local i
    local n, v
    if not table.pointer then
        table.pointer = 1
    end
    if not table.min then
        table.min = 1
    end
    if not table.max then
        table.max = 1
        n, v = next(table, nil)
        while n do
            if type(n) == "number" then
                if n > table.max then
                    table.max = n
                end
            end
            n, v = next(table, n)
        end
    end
    i = table.pointer
    table.pointer = table.pointer + 1
    if not table[table.pointer] then
        table.exhausted = TRUE
    end
    if table.exhausted then
        table.pointer = rndint(table.min, table.max)
    end
    return table[i]
end
proximity = function(hActor1, hActor2, y, z) -- line 319
    local x1, y1, z2
    local x2, y2, z2
    local prox
    if not y then
        if not hActor1 then
            PrintDebug("No valid actor in proximity calculation.\n")
            return nil
        end
        if type(hActor1) == "table" then
            hActor1 = hActor1.hActor
        end
        if type(hActor2) == "table" then
            hActor2 = hActor2.hActor
        end
        if not hActor2 then
            hActor2 = system.currentActor.hActor
        end
        x2, y2, z2 = GetActorPos(hActor2)
    else
        x2 = hActor2
        y2 = y
        z2 = z
    end
    x1, y1, z1 = GetActorPos(hActor1)
    prox = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    return prox
end
object_proximity = function(object, out_flag) -- line 357
    local x2, y2, z2
    local prox
    x2, y2, z2 = GetActorPos(system.currentActor.hActor)
    if out_flag then
        prox = sqrt((object.out_pnt_x - x2) ^ 2 + (object.out_pnt_y - y2) ^ 2 + (object.out_pnt_z - z2) ^ 2)
    else
        prox = sqrt((object.use_pnt_x - x2) ^ 2 + (object.use_pnt_y - y2) ^ 2 + (object.use_pnt_z - z2) ^ 2)
    end
    return prox
end
point_proximity = function(x, y, z) -- line 372
    local curpos = system.currentActor:getpos()
    local prox = sqrt((curpos.x - x) ^ 2 + (curpos.y - y) ^ 2 + (curpos.z - z) ^ 2)
    return prox
end
CheckFirstTime = function(uniqueId) -- line 384
    if type(uniqueId) ~= "string" then
        error("CheckFirstTime must be called with a unique string!\n")
    end
    if getglobal("  " .. uniqueId) then
        error("CheckFirstTime: Won't reload " .. uniqueId .. "!\n")
    else
        setglobal("  " .. uniqueId, 1)
    end
end
sleep_for = function(msecs) -- line 400
    local counter = 0
    while counter <= msecs do
        break_here()
        counter = counter + system.frameTime
    end
    return counter - msecs
end
stop_movement_scripts = function() -- line 416
    WalkVector.x = 0
    WalkVector.y = 0
    WalkVector.z = 0
    system.currentActor:force_auto_run(FALSE)
    stop_script(rotate_actor_left)
    stop_script(rotate_actor_right)
    stop_script(move_actor)
    stop_script(move_actor_backward)
    stop_script(climb_actor_up)
    stop_script(climb_actor_down)
end
move_actor = function(hActor) -- line 436
    local i, v
    system.currentActor:set_walk_backwards(FALSE)
    if cutSceneLevel <= 0 then
        while get_generic_control_state("MOVE_FORWARD") and cutSceneLevel <= 0 do
            WalkActorForward(hActor)
            break_here()
        end
        system.currentActor:force_auto_run(FALSE)
    end
end
move_actor_backward = function(hActor) -- line 455
    system.currentActor:set_walk_backwards(TRUE)
    system.currentActor:force_auto_run(FALSE)
    while get_generic_control_state("MOVE_BACKWARD") and cutSceneLevel <= 0 or system.currentActor.move_in_reverse do
        WalkActorForward(hActor)
        break_here()
    end
end
rotate_actor_left = function(hActor) -- line 469
    while get_generic_control_state("TURN_LEFT") and cutSceneLevel <= 0 do
        TurnActor(hActor, 1)
        break_here()
    end
end
rotate_actor_right = function(hActor) -- line 476
    while get_generic_control_state("TURN_RIGHT") and cutSceneLevel <= 0 do
        TurnActor(hActor, -1)
        break_here()
    end
end
strafe_actor_left = function() -- line 487
    while get_generic_control_state("TURN_LEFT") and altKeyDown and cutSceneLevel <= 0 do
        if not manny:is_choring(ms_swivel_lf, manny.base_costume) then
        end
        break_here()
    end
end
strafe_actor_right = function() -- line 496
    while get_generic_control_state("TURN_RIGHT") and altKeyDown and cutSceneLevel <= 0 do
        if not manny:is_choring(ms_swivel_rt, manny.base_costume) then
        end
        break_here()
    end
end
climb_actor_up = function(act) -- line 511
    local scr
    while get_generic_control_state("MOVE_FORWARD") and cutSceneLevel <= 0 do
        if not find_script(act.climb_up) then
            scr = start_script(act.climb_up, act)
            wait_for_script(scr)
        else
            break_here()
        end
    end
end
climb_actor_down = function(act) -- line 528
    local scr
    while get_generic_control_state("MOVE_BACKWARD") do
        if not find_script(act.climb_down) then
            scr = start_script(act.climb_down, act)
            wait_for_script(scr)
        else
            break_here()
        end
    end
end
monitor_run = function() -- line 546
    if system.currentActor.set_run then
        system.currentActor:set_run(TRUE)
        while get_generic_control_state("RUN") or system.currentActor.auto_run do
            break_here()
            if not system.currentActor.is_running and cutSceneLevel <= 0 then
                system.currentActor:set_run(TRUE)
            end
        end
        system.currentActor:set_run(FALSE)
    end
end
WalkActorToObject = function(hActor, dest_object, out_flag) -- line 566
    local prox, pnt_x, pnt_y, pnt_z, rot_x, rot_y, rot_z
    if out_flag then
        pnt_x = dest_object.out_pnt_x
        pnt_y = dest_object.out_pnt_y
        pnt_z = dest_object.out_pnt_z
        rot_x = dest_object.out_rot_x
        rot_y = dest_object.out_rot_y
        rot_z = dest_object.out_rot_z
    else
        pnt_x = dest_object.use_pnt_x
        pnt_y = dest_object.use_pnt_y
        pnt_z = dest_object.use_pnt_z
        rot_x = dest_object.use_rot_x
        rot_y = dest_object.use_rot_y
        rot_z = dest_object.use_rot_z
    end
    if pnt_x then
        PrintDebug("Walking Manny to " .. dest_object.name .. "\t" .. pnt_x .. "\t" .. pnt_y .. "\t" .. pnt_z .. "\n")
        WalkActorTo(hActor, pnt_x, pnt_y, pnt_z)
        while IsActorMoving(system.currentActor.hActor) do
            break_here()
        end
        prox = object_proximity(dest_object, out_flag)
        if prox <= MAX_PROX then
            PrintDebug("made it to the use/out point of " .. dest_object.name .. "!\n")
            SetActorRot(hActor, rot_x, rot_y, rot_z)
            return TRUE
        else
            PrintDebug("Didn't make it to the use/out point of " .. dest_object.name .. "!\n")
            return FALSE
        end
    else
        PrintDebug("Object has no use/out point!\n")
    end
end
set_vox_effect = function() -- line 611
    local setname
    setname = system.currentSet:short_name()
    if in(setname, Set.stereo_ring_sets) then
        Actor.say_line = Actor.underwater_say_line
    else
        Actor.say_line = Actor.normal_say_line
    end
    if in(setname, Set.stereo_ring_sets) then
        system_prefs:set_voice_effect("Stereo Ring Modulator")
    elseif in(setname, Set.short_reverb_sets) then
        system_prefs:set_voice_effect("Short Reverb")
    elseif in(setname, Set.basic_reverb_sets) then
        system_prefs:set_voice_effect("Basic Reverb")
    else
        system_prefs:set_voice_effect("OFF")
    end
end
PrintTemporary = function(line) -- line 640
    local time_est = strlen(line) * 50
    PrintLine("[" .. line .. "]", { x = 100, y = 30, fgcolor = Yellow, font = pt_font, duration = time_est })
end
print_temporary = PrintTemporary
system.lock_display = function(self) -- line 654
    if not system.lockDisplayLevel or system.lockDisplayLevel < 0 then
        system.lockDisplayLevel = 0
    end
    if system.lockDisplayLevel == 0 then
        EngineDisplay(FALSE)
    end
    system.lockDisplayLevel = system.lockDisplayLevel + 1
end
system.unlock_display = function(self) -- line 665
    if not system.lockDisplayLevel or system.lockDisplayLevel < 0 then
        system.lockDisplayLevel = 0
    end
    if system.lockDisplayLevel > 0 then
        system.lockDisplayLevel = system.lockDisplayLevel - 1
        if system.lockDisplayLevel == 0 then
            EngineDisplay(TRUE)
        end
    end
end
attach_camera_to_spotfinder = function() -- line 681
    local pos = { }
    local oldpos = { }
    pos.x, pos.y, pos.z = GetCameraPosition()
    spotfinder:setpos(pos)
    oldpos = pos
    while 1 do
        if pos.x ~= oldpos.x or pos.x ~= oldpos.x or pos.x ~= oldpos.x then
            SetCameraInterest(pos.x, pos.y, pos.z)
            oldpos = pos
        end
        pos = spotfinder:getpos()
        break_here()
    end
end
message_text = { }
message_text.object = nil
message_text.delay = 2000
message_text.set = function(self, string, textOptions, delay) -- line 719
    local opt = { fgcolor = White, x = 20, y = 30, font = special_font }
    local i, v
    if not game_pauser.is_paused then
        if textOptions then
            i, v = next(textOptions, nil)
            while i do
                opt[i] = v
                i, v = next(textOptions, nil)
            end
        end
        if delay then
            self.delay = delay
        else
            self.delay = 2000
        end
        if self.object then
            self:destroy()
        end
        self.object = MakeTextObject(string, opt)
        start_script(self.destroyTimer, self)
    end
end
message_text.destroy = function(self) -- line 752
    if find_script(self.destroyTimer) then
        stop_script(self.destroyTimer, self)
    end
    if self.object then
        KillTextObject(self.object)
        self.object = nil
    end
end
message_text.destroyTimer = function(self) -- line 766
    sleep_for(self.delay)
    if self.object then
        KillTextObject(self.object)
        self.object = nil
    end
end
sector_editor = { }
sector_editor.is_active = FALSE
sector_editor.sectors = { }
sector_editor.start = function(self) -- line 786
    if not self.is_active then
        self.last_button_handler = system.buttonHandler
        system.buttonHandler = self
        self.msg_text = MakeTextObject("Sector Editor Active", { fgcolor = White, x = 20, y = 20, font = special_font })
        self.sector_index = 1
        self.point_index = 0
        self.is_active = TRUE
    end
end
sector_editor.finish = function(self) -- line 798
    if self.is_active then
        self:write_sectors()
        system.buttonHandler = self.last_button_handler
        KillTextObject(self.msg_text)
        self.is_active = FALSE
    end
end
sector_editor.add_point = function(self) -- line 807
    local pos
    pos = manny:getpos()
    if self.sectors[self.sector_index] == nil then
        self.sectors[self.sector_index] = { }
        self.point_index = 0
    end
    self.sectors[self.sector_index][self.point_index] = pos
    ChangeTextObject(self.msg_text, "Sector Editor: Added point " .. self.point_index .. " to sector " .. self.sector_index)
    self.point_index = self.point_index + 1
end
sector_editor.end_sector = function(self) -- line 820
    local pos, pt
    if self.sectors[self.sector_index] ~= nil and self.point_index >= 3 then
        pos = manny:getpos()
        pt = self.sectors[self.sector_index][self.point_index - 1]
        if pt.x ~= pos.x or pt.y ~= pos.y or pt.z ~= pos.z then
            self:add_point()
        end
        ChangeTextObject(self.msg_text, "Sector Editor: Finished sector " .. self.sector_index)
        self.sector_index = self.sector_index + 1
        self.sectors[self.sector_index] = nil
        self.point_index = 0
    else
        ChangeTextObject(self.msg_text, "Sector Editor: Sector must have at least 3 points.")
    end
end
sector_editor.undo_sector = function(self) -- line 838
    if self.sector_index > 0 then
        self.sectors[self.sector_index] = nil
        self.sector_index = self.sector_index - 1
        ChangeTextObject(self.msg_text, "Sector Editor: Undid last sector.")
    end
end
ester = { }
sector_editor.undo_point = function(self) -- line 846
    if self.sector_index > 0 and self.point_index > 0 then
        self.sectors[self.sector_index][self.point_index] = nil
        self.point_index = self.point_index - 1
        ChangeTextObject(self.msg_text, "Sector Editor: Undid last point.")
    end
end
sector_editor.write_sectors = function(self) -- line 854
    local fname, sectori, sectorv, pointi, pointv
    local numvertices
    fname = InputDialog("Write Sectors", "Enter filename:")
    if fname and fname ~= "" then
        writeto(fname)
        sectori, sectorv = next(self.sectors, nil)
        while sectori do
            write("\tsector\tfloor_" .. sectori .. "\n")
            write("\tID\t" .. sectori .. "\n")
            write("\ttype\twalk\n")
            write("\tdefault visibility\tvisible\n")
            write("\theight\t0.10\n")
            numvertices = 0
            pointi, pointv = next(sectorv, nil)
            while pointi do
                numvertices = numvertices + 1
                pointi, pointv = next(sectorv, pointi)
            end
            write("\tnumvertices\t" .. numvertices .. "\n")
            pointi, pointv = next(sectorv, nil)
            write("\tvertices:\t" .. pointv.x .. "\t" .. pointv.y .. "\t" .. pointv.z .. "\n")
            pointi, pointv = next(sectorv, pointi)
            while pointi do
                write("\t\t\t" .. pointv.x .. "\t" .. pointv.y .. "\t" .. pointv.z .. "\n")
                pointi, pointv = next(sectorv, pointi)
            end
            write("\n\n")
            sectori, sectorv = next(self.sectors, sectori)
        end
        writeto()
    end
end
sector_editor.buttonHandler = function(self, id, bDown, numPresses) -- line 891
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if id == SPACEKEY and bDown and controlKeyDown then
        self:end_sector()
    elseif id == SPACEKEY and bDown then
        self:add_point()
    elseif id == ESCAPEKEY and bDown and controlKeyDown then
        self:undo_sector()
    elseif id == ESCAPEKEY then
        self:undo_point()
    else
        SampleButtonHandler(id, bDown, numPresses)
    end
end
find_stair_chore = function() -- line 914
    local x, y, z = GetActorPuckVector(system.currentActor.hActor)
    if system.currentActor.is_running and not system.currentActor.is_backward then
        return ms_run
    end
    if system.currentActor.is_backward then
        return ms_back_off
    elseif z == 0 then
        return ms_walk
    elseif z < 0 then
        return ms_walk_downstairs
    else
        return ms_walk_upstairs
    end
end
stairman = function() -- line 932
    local chore
    while 1 do
        if system.currentActor:find_sector_name("stair") then
            SetActorConstrain(system.currentActor.hActor, TRUE)
            while system.currentActor:find_sector_name("stair") do
                chore = find_stair_chore()
                system.currentActor:set_walk_chore(chore, system.currentActor.base_costume)
                while system.currentActor:is_choring(chore, FALSE, system.currentActor.base_costume) and system.currentActor:find_sector_name("stair") do
                    break_here()
                end
                while system.currentActor:is_resting() do
                    break_here()
                end
                break_here()
            end
        end
        if system.currentActor.is_running and not system.currentActor.is_backward then
            system.currentActor:set_walk_chore(ms_run, system.currentActor.base_costume)
        else
            if not system.currentActor.is_backward then
                system.currentActor:set_walk_chore(ms_walk, system.currentActor.base_costume)
            end
        end
        SetActorConstrain(system.currentActor.hActor, FALSE)
        while not system.currentActor:find_sector_name("stair") do
            break_here()
        end
        break_here()
    end
end
curbman = function() -- line 969
    while 1 do
        if system.currentActor:find_sector_name("curb") then
            SetActorConstrain(system.currentActor.hActor, TRUE)
            while system.currentActor:find_sector_name("curb") do
                system.currentActor:walk_forward()
                break_here()
            end
            SetActorConstrain(system.currentActor.hActor, FALSE)
        end
        break_here()
    end
end
TrackManny = function() -- line 991
    local box_id, box_type, new_setup
    doorman_in_hot_box = FALSE
    head_control_index = 1
    hot_object = nil
    hot_object_locked = FALSE
    time_to_look = TRUE
    previous_time_to_look = FALSE
    previous_spotfinder_active = FALSE
    box_id, cameraman_box_name, box_type = system.currentActor:find_sector_type(CAMERA)
    new_setup = system.currentSet.setups[tostring(cameraman_box_name)]
    if new_setup then
        system.currentSet:current_setup(new_setup)
    end
    cameraman_watching_set = system.currentSet
    start_script(stairman)
    start_script(curbman)
    while 1 do
        Doorman()
        system.currentSet:cameraman()
        Find_Visible_Objects()
        if not system.currentActor.no_idle_head then
            Head_Control()
        end
        if setup_name_showing then
            display_setup_name()
        end
        random()
        break_here()
    end
end
Find_Visible_Objects = function() -- line 1044
    local act, val, obj
    local vActors
    vActors = GetVisibleThings()
    vlist = { }
    act, val = next(vActors, nil)
    while act do
        obj = parent_object[act]
        if obj then
            if obj.touchable and proximity(act) <= obj.range then
                vlist[obj] = TRUE
            end
        end
        act, val = next(vActors, act)
    end
end
Build_Hotlist = function(start_object) -- line 1078
    local obj, val
    local bestAngle, thisAngle, bestObj
    hotlist = { }
    if start_object then
        hotlist[start_object] = TRUE
        bestObj = start_object
        bestAngle = GetAngleBetweenActors(system.currentActor.hActor, start_object.interest_actor.hActor)
    else
        bestAngle = 9999
        bestObj = nil
    end
    obj, val = next(vlist, nil)
    while obj do
        thisAngle = GetAngleBetweenActors(system.currentActor.hActor, obj.interest_actor.hActor)
        if bestObj == nil then
            bestAngle = thisAngle
            bestObj = obj
            hotlist[obj] = TRUE
        elseif abs(thisAngle - bestAngle) < 10 then
            hotlist[obj] = TRUE
        elseif thisAngle < bestAngle then
            if start_object == nil then
                hotlist[bestObj] = nil
                bestObj = obj
                bestAngle = thisAngle
                hotlist[obj] = TRUE
            end
        end
        obj, val = next(vlist, obj)
    end
end
Get_Next_Visible_Object = function(cur_hot_object) -- line 1120
    local new_hot_object
    if vlist ~= nil then
        new_hot_object = next(vlist, cur_hot_object)
        if new_hot_object == nil then
            new_hot_object = next(vlist, nil)
        end
    end
    return new_hot_object
end
Head_Control = function() -- line 1141
    local new_hot_object
    if spotfinder_active then
        previous_spotfinder_active = TRUE
        system.currentActor:head_look_at(spotfinder)
    else
        if previous_spotfinder_active then
            previous_spotfinder_active = FALSE
            system.currentActor:head_look_at(nil)
        end
        if not time_to_look then
            if previous_time_to_look then
                previous_time_to_look = FALSE
                if cutSceneLevel <= 0 then
                    system.currentActor:head_look_at(nil)
                end
                hot_object = nil
            end
        else
            previous_time_to_look = time_to_look
            if IsMessageGoing(system.currentActor.hActor) and hot_object ~= nil then
                if hot_object ~= nil then
                    if vlist[hot_object] then
                        system.currentActor:head_look_at(hot_object)
                    else
                        hot_object = nil
                        system.currentActor:head_look_at(nil)
                    end
                end
            elseif cutSceneLevel <= 0 and system.buttonHandler == SampleButtonHandler then
                new_hot_object = hot_object
                if hot_object == nil or (hot_object ~= nil and vlist[hot_object] == nil) then
                    Build_Hotlist()
                    new_hot_object = next(hotlist, nil)
                    hot_object_locked = FALSE
                else
                    if not hot_object_locked then
                        Build_Hotlist()
                        if hotlist[hot_object] == FALSE then
                            hot_object = nil
                            system.currentActor.been_gazin = MAX_GAZE_TIME
                        end
                        system.currentActor.been_gazin = system.currentActor.been_gazin + system.frameTime
                        if system.currentActor.been_gazin > MAX_GAZE_TIME then
                            new_hot_object = next(hotlist, hot_object)
                            if new_hot_object == nil then
                                new_hot_object = next(hotlist, nil)
                            end
                        end
                    end
                end
                if new_hot_object ~= hot_object then
                    hot_object = new_hot_object
                    if hot_object then
                        system.currentActor:head_look_at(hot_object)
                    else
                        system.currentActor:head_look_at(nil)
                    end
                    system.currentActor.been_gazin = 0
                end
            end
        end
    end
end
Change_Gaze = function() -- line 1224
    local new_hot_object
    if cutSceneLevel <= 0 then
        if hot_object then
            new_hot_object = next(hotlist, hot_object)
            if new_hot_object == nil or new_hot_object == hot_object then
                new_hot_object = Get_Next_Visible_Object(hot_object)
            end
            if new_hot_object then
                hot_object = new_hot_object
                Build_Hotlist(hot_object)
                system.currentActor:head_look_at(hot_object.interest_actor)
                system.currentActor.been_gazin = 0
                hot_object_locked = TRUE
            end
        end
    end
end
enable_head_control = function(bEnable) -- line 1250
    if bEnable then
        time_to_look = TRUE
    else
        time_to_look = FALSE
        system.currentActor:head_look_at(nil)
    end
    hot_object = nil
end
wait_for_script = function(hTask) -- line 1266
    while find_script(hTask) do
        break_here()
    end
end
wait_for_movie = function() -- line 1276
    while IsMoviePlaying() do
        break_here()
    end
end
newStartMovie = function(name, looping, x, y) -- line 1282
    if looping then
        play_movie_looping(name, x, y)
    else
        play_movie(name, x, y)
    end
end
oldStartMovie = StartMovie
StartMovie = newStartMovie
play_movie = function(movie, x, y) -- line 1298
    system.loopingMovie = nil
    oldStartMovie(movie, FALSE, x, y)
end
play_movie_looping = function(movie, x, y) -- line 1309
    system.loopingMovie = { }
    system.loopingMovie.name = movie
    system.loopingMovie.x = x
    system.loopingMovie.y = y
    oldStartMovie(movie, TRUE, x, y)
end
wait_for_message = function() -- line 1319
    local original_speaker = system.lastActorTalking
    while IsMessageGoing() and system.lastActorTalking == original_speaker do
        break_here()
    end
end
wait_for_actor = function(hActor) -- line 1326
    if not hActor then
        hActor = system.currentActor
    end
    while IsActorMoving(hActor) or IsActorChoring(hActor) do
        break_here()
    end
end
estr = { }
single_start_script = function(hScript, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- line 1340
    local result
    if not find_script(hScript) then
        result = start_script(hScript, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        return result
    end
end
print_scripts = function() -- line 1352
    local hTask = next_script(nil)
    local script_string, fb, fe
    PrintDebug("\n")
    PrintDebug("\n********** c u r r e n t   s c r i p t s **********\n")
    PrintDebug("\n")
    while hTask do
        script_string = FunctionName(identify_script(hTask))
        fb, fe = strfind(script_string, "function")
        if fb then
            script_string = strsub(script_string, fe + 1)
        end
        if not strfind(script_string, "user_command") then
            PrintDebug("\t" .. script_string)
        end
        hTask = next_script(hTask)
    end
    PrintDebug("\n")
    PrintDebug("***************************************************\n")
    PrintDebug("\n")
end
Doorman = function() -- line 1390
    local box_id, box_name, box_type
    local door_obj
    box_id, box_name, box_type = system.currentActor:find_sector_type(HOT)
    if box_name ~= nil and doorman_in_hot_box == FALSE then
        doorman_in_hot_box = TRUE
        if not cameraman_disabled then
            door_obj = system.currentSet[tostring(box_name)]
            if system.currentSet.cheat_boxes[tostring(box_name)] then
                system.currentActor:teleport_out_of_hot_box()
            elseif door_obj then
                stop_script(Sentence)
                if door_obj.climbOut then
                    door_obj:climbOut(tostring(box_name))
                else
                    start_script(Sentence, "walkOut", door_obj, nil, TRUE)
                end
            end
        end
    elseif box_name == nil then
        doorman_in_hot_box = FALSE
    end
end
Cameraman = function() -- line 1432
    local box_id, box_type
    local new_setup
    local still_in_box
    if cameraman_disabled == FALSE and system.currentSet:current_setup() ~= system.currentSet.setups.overhead then
        still_in_box = system.currentActor:find_sector_name(tostring(cameraman_box_name))
        if not still_in_box or system.currentSet ~= cameraman_watching_set then
            cameraman_watching_set = system.currentSet
            box_id, cameraman_box_name, box_type = system.currentActor:find_sector_type(CAMERA)
            new_setup = system.currentSet.setups[tostring(cameraman_box_name)]
            system.currentSet:current_setup(new_setup)
        end
    end
end
emergency_collision_override = function() -- line 1458
    local i, v
    i, v = next(system.actorTable, nil)
    while i do
        if v.set_collision_mode then
            v:set_collision_mode(COLLISION_OFF)
        end
        i, v = next(system.actorTable, i)
    end
end
trim_header = function(aLine) -- line 1478
    local aLine2, nSlash
    if strsub(aLine, 1, 1) == "/" then
        nSlash = strfind(aLine, "/", 2, TRUE)
        if nSlash then
            aLine2 = strsub(aLine, nSlash + 1)
        else
            aLine2 = strsub(aLine, 10, strlen(aLine))
        end
        aLine = aLine2
    end
    return aLine
end
Sentence = function(verb, noun1, noun2, immediate_flag) -- line 1494
    local result, verb_code, prox
    local box_id, box_name, box_type
    local valid_verb
    kill_soft_scripts()
    if noun2 and type(noun2) ~= "table" then
        PrintDebug("Invalid noun2 in sentence!!")
    else
        if type(noun1) == "table" then
            if noun2 then
                PrintDebug("Executing sentence: " .. verb .. " " .. noun1.name .. " with " .. noun2.name .. "\n")
            else
                PrintDebug("Executing sentence: " .. verb .. " " .. noun1.name .. "\n")
            end
            if noun2 and shrinkBoxesEnabled and (verb == "use" or verb == "pickUp") then
                PrintDebug("Checking for shrunk boxes!")
                valid_verb = trim_header(noun2.string_name)
                valid_verb = tostring(verb .. "_" .. valid_verb)
                if noun1[valid_verb] and system.currentSet.boxes_shrunk then
                    UnShrinkBoxes()
                    system.currentSet.boxes_shrunk = FALSE
                    shrinkBoxMannyWatch = TRUE
                end
            end
            if not immediate_flag and noun1.owner ~= system.currentActor and not noun1.immediate then
                if verb == "walkOut" then
                    if not noun1:is_open() then
                        result = system.currentActor:walkto_object(noun1, FALSE)
                        if result then
                            result = noun1:open()
                            if not result then
                                start_script(noun1.locked_out, noun1)
                                return nil
                            end
                        else
                            PrintDebug("Didn't make it to the door's use point.\n")
                            return nil
                        end
                    end
                    result = system.currentActor:walkto_object(noun1, TRUE)
                    box_id, box_name, box_type = system.currentActor:find_sector_type(HOT)
                    if system.currentSet[tostring(box_name)] ~= noun1 then
                        PrintDebug("Didn't make it to the door's box.\n")
                        return nil
                    end
                elseif verb == "use" or verb == "pickUp" and not noun1.walkOut == nil then
                    indexFB_disabled = TRUE
                    if noun1[verb] then
                        indexFB_disabled = FALSE
                        result = system.currentActor:walkto_object(noun1)
                        if not result then
                            return nil
                        end
                    end
                end
            end
            if noun2 then
                valid_verb = trim_header(noun2.string_name)
                valid_verb = tostring(verb .. "_" .. valid_verb)
                if noun1[valid_verb] then
                    verb_code = noun1[valid_verb]
                    result = single_start_script(verb_code, noun1, noun2)
                    if shrinkBoxesEnabled and shrinkBoxMannyWatch then
                        shrinkBoxMannyWatch = FALSE
                        single_start_script(wait_for_shrink_box_verb_code, result)
                    end
                elseif noun2["default_response"] then
                    verb_code = noun2["default_response"]
                    single_start_script(verb_code, noun2, noun1)
                else
                    system.currentActor:say_line("/syma162/")
                end
            else
                verb_code = noun1[verb]
                single_start_script(verb_code, noun1)
            end
        else
            PrintDebug("No valid noun1 in sentence!\n")
        end
    end
end
system.override = { }
system.override.is_active = FALSE
set_override = function(overrideFunc, overrideTable) -- line 1634
    if not system.override then
        system.override = { }
    end
    if overrideFunc then
        system.override.current_script = GetCurrentScript()
        system.override.override_func = overrideFunc
        system.override.override_table = overrideTable
        system.override.is_active = TRUE
    else
        system.override.is_active = FALSE
    end
end
kill_override = function(bNoStopMovie) -- line 1655
    shut_up_everybody()
    ExpireText()
    if not bNoStopMovie then
        StopMovie()
    end
    cutSceneLevel = 0
    cameraman_disabled = FALSE
    set_override(nil)
    time_to_look = TRUE
    ResetMarioControls()
    single_start_script(WalkManny)
    music_state:unpause()
end
call_override = function() -- line 1674
    if system.override.is_active then
        stop_script(system.override.current_script)
        if system.override.override_table then
            start_script(system.override.override_func, system.override.override_table, TRUE)
        else
            start_script(system.override.override_func, TRUE)
        end
    end
end
check_for_movement_keys = function() -- line 1692
    local keyId, keyValue
    local checkTable
    local i, v
    break_here()
    keyId = nil
    if not MarioControl then
        checkTable = { ["a"] = "MOVE_FORWARD", b = "MOVE_BACKWARD", c = "TURN_LEFT", ["d"] = "TURN_RIGHT", ["e"] = "RUN" }
    else
        checkTable = { ["a"] = "MOVE_NORTH", b = "MOVE_SOUTH", c = "MOVE_EAST", ["d"] = "MOVE_WEST", ["e"] = "MOVE_NORTHWEST", ["f"] = "MOVE_NORTHEAST", g = "MOVE_SOUTHWEST", h = "MOVE_SOUTHEAST", ["i"] = "RUN" }
    end
    i, v = next(checkTable, nil)
    while i do
        if get_generic_control_state(v) then
            if system.buttonHandler then
                keyId, keyValue = next(control_map[v], nil)
                if keyId then
                    call_button_handler(keyId, TRUE, 1)
                end
            end
        end
        i, v = next(checkTable, i)
    end
end
START_CUT_SCENE = function(type) -- line 1721
    if cutSceneLevel == 0 then
        cameraman_disabled = TRUE
    end
    cutSceneLevel = cutSceneLevel + 1
    stop_movement_scripts()
    if type == "no head" then
        enable_head_control(FALSE)
    end
end
END_CUT_SCENE = function() -- line 1736
    if cutSceneLevel > 0 then
        cutSceneLevel = cutSceneLevel - 1
        if cutSceneLevel == 0 then
            cutSceneLevel = 0
            cameraman_disabled = FALSE
            set_override(nil)
            ResetMarioControls()
            single_start_script(WalkManny)
            time_to_look = TRUE
            start_script(check_for_movement_keys)
        end
    end
end
system.default_response = function(situation) -- line 1753
    if situation == "nah" then
        manny:say_line("/syma206/")
    elseif situation == "think" then
        manny:say_line("/syma207/")
    elseif situation == "not portable" then
        manny:say_line("/syma163/")
    elseif situation == "frustrated" then
        manny:say_line("/syma164/")
    elseif situation == "reach" then
        manny:say_line("/syma165/")
    elseif situation == "empty" then
        manny:say_line("/syma166/")
    elseif situation == "locked" then
        manny:say_line("/syma167/")
    elseif situation == "budge" then
        manny:say_line("/syma168/")
    elseif situation == "with what" then
        manny:say_line("/syma169/")
    elseif situation == "shed light" then
        manny:say_line("/syma170/")
    elseif situation == "nobody" then
        manny:say_line("/syma171/")
    elseif situation == "right" then
        manny:say_line("/syma208/")
    elseif situation == "huge" then
        manny:say_line("/syma209/")
    elseif situation == "no" then
        manny:say_line("/syma210/")
    elseif situation == "nice" then
        manny:say_line("/syma211/")
    elseif situation == "code" then
        manny:say_line("/syma212/")
    elseif situation == "full" then
        manny:say_line("/syma213/")
    elseif situation == "hernia" then
        manny:say_line("/syma172/")
    elseif situation == "furniture" then
        manny:say_line("/syma173/")
    elseif situation == "not now" then
        manny:say_line("/syma191/")
    elseif situation == "hes watching" then
        manny:say_line("/syma174/")
    elseif situation == "rather" then
        manny:say_line("/syma214/")
    elseif situation == "martialed" then
        manny:say_line("/syma192/")
    elseif situation == "not how" then
        manny:say_line("/syma175/")
    elseif situation == "something" then
        manny:say_line("/syma176/")
    elseif situation == "no pocket" then
        manny:say_line("/syma177/")
    elseif situation == "tow" then
        manny:say_line("/syma215/")
    elseif situation == "dont need" then
        manny:say_line("/syma178/")
    elseif situation == "mittens" then
        manny:say_line("/syma216/")
    elseif situation == "already" then
        manny:say_line("/syma193/")
    elseif situation == "got some" then
        manny:say_line("/syma194/")
    elseif situation == "need" then
        manny:say_line("/syma217/")
    elseif situation == "reap" then
        manny:say_line("/syma195/")
    elseif situation == "demon reap" then
        manny:say_line("/syma196/")
    elseif situation == "attached" then
        manny:say_line("/syma179/")
    elseif situation == "as far" then
        manny:say_line("/syma180/")
    elseif situation == "bolted" then
        manny:say_line("/syma181/")
    elseif situation == "open" then
        manny:say_line("/syma182/")
    elseif situation == "closed" then
        manny:say_line("/syma183/")
    elseif situation == "ladder" then
        manny:say_line("/syma184/")
    elseif situation == "underwater" then
        manny:say_line("/syma185/")
    elseif situation == "way out" then
        manny:say_line("/syma186/")
    elseif situation == "here already" then
        manny:say_line("/syma197/")
    elseif situation == "no room" then
        manny:say_line("/gtcma14/")
    elseif situation == "no work" then
        manny:say_line("/gtcma15/")
    elseif situation == "not here" then
        manny:say_line("/gtcma16/")
    end
end
print_table = function(table, name) -- line 1903
    if type(table) ~= "table" then
        PrintDebug("Not a table!\n")
    else
        local i, v = next(table, nil)
        if name then
            PrintDebug("\nContents of table:\"" .. name .. "\"\n")
        else
            PrintDebug("\nContents of table:\n")
        end
        while i do
            PrintDebug("[" .. tostring(i) .. "]\t" .. tostring(v) .. "\n")
            i, v = next(table, i)
        end
        PrintDebug("\n")
    end
end
execute_user_command = function() -- line 1925
    local user_command
    local function_creation_string
    user_command = InputDialog("Execute Command", "Enter lua code:", last_user_command)
    if not user_command then
        return
    end
    PrintDebug("Executing string:\n")
    PrintDebug("\n\t" .. user_command .. "\n\n")
    function_creation_string = "function user_command_function() " .. user_command .. " end"
    if dostring(function_creation_string) then
        PrintDebug("Executing user command...\n")
        start_script(user_command_function)
    else
        PrintDebug("Could not execute command.\n")
    end
    last_user_command = user_command
end
start_user_script = function() -- line 1948
    local user_script
    user_script = InputDialog("Start Script", "Enter script to run:", last_user_script)
    if not user_script then
        return nil
    else
        dostring("start_script(" .. user_script .. ")")
        last_user_script = user_script
    end
end
radar_blip = function() -- line 1963
    local i = 1
    local obj, hAct, prox
    vlist[1], vlist[2], vlist[3], vlist[4], vlist[5], vlist[6], vlist[7], vlist[8] = GetVisibleThings()
    PrintDebug("\n")
    hAct = vlist[i]
    while hAct do
        SetActorVisibility(hAct, TRUE)
        SetActorCostume(hAct, "x_spot.cos")
        obj = parent_object[hAct]
        if obj then
            prox = proximity(hAct)
            PrintDebug("Distance to " .. obj.name .. ": " .. prox .. "\n")
        end
        i = i + 1
        hAct = vlist[i]
    end
    if i == 1 then
        PrintDebug("No visible objects!\n")
    end
end
toggle_spotfinder = function() -- line 1989
    local x, y, z = GetActorPos(system.currentActor.hActor)
    if spotfinder_active then
        spotfinder:put_in_set(nil)
        spotfinder_active = FALSE
        stop_script(spin_spotfinder)
        enable_cursor_keyboard_controls(TRUE)
    else
        if not spotfinder then
            spotfinder = Actor:create(nil, nil, nil, "Spotfinder")
        end
        spot_cos = "x_spot.cos"
        spotfinder:set_costume(spot_cos)
        spotfinder:put_in_set(system.currentSet)
        spotfinder:setpos(x, y, z)
        spotfinder.pos = spotfinder:getpos()
        spotfinder_active = TRUE
        start_script(spin_spotfinder)
        enable_cursor_keyboard_controls(FALSE)
    end
end
spin_spotfinder = function() -- line 2013
    local x, y, z
    local count = 1
    x = 1
    y = 360
    z = 1
    while 1 do
        spotfinder:setrot(x, y, z)
        count = count + 10
        x = x + 1
        y = y - 10
        z = z + 10
        if count == 361 then
            x = 1
            y = 360
            z = 1
        end
        break_here()
    end
end
move_spotfinder = function(id, step_z) -- line 2034
    local spot_step = 0.0099999998
    local loops = 1
    run_spotfinder = TRUE
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    while run_spotfinder and GetControlState(id) do
        if controlKeyDown then
            spot_step = 0.001
        end
        if step_z then
            if id == UPKEY then
                spotfinder.pos.z = spotfinder.pos.z + spot_step
            elseif id == DOWNKEY then
                spotfinder.pos.z = spotfinder.pos.z - spot_step
            elseif id == RIGHTKEY then
                spotfinder.pos.x = spotfinder.pos.x + spot_step
            elseif id == LEFTKEY then
                spotfinder.pos.x = spotfinder.pos.x - spot_step
            end
        else
            if id == UPKEY then
                spotfinder.pos.y = spotfinder.pos.y + spot_step
            elseif id == DOWNKEY then
                spotfinder.pos.y = spotfinder.pos.y - spot_step
            elseif id == RIGHTKEY then
                spotfinder.pos.x = spotfinder.pos.x + spot_step
            elseif id == LEFTKEY then
                spotfinder.pos.x = spotfinder.pos.x - spot_step
            end
        end
        spotfinder:moveto(spotfinder.pos.x, spotfinder.pos.y, spotfinder.pos.z)
        if spotfinder.attached_actor ~= nil and type(spotfinder.attached_actor) == "table" then
            spotfinder.attached_actor:setpos(spotfinder:getpos())
        end
        spot_step = spot_step + loops / 1000
        loops = loops + 1
        break_here()
    end
    PrintDebug("Spot = { x=" .. spotfinder.pos.x .. ", y=" .. spotfinder.pos.y .. ", z=" .. spotfinder.pos.z .. "}\n")
end
slow_rotate_manny = function(id) -- line 2080
    local rotx, roty, rotz
    rotx, roty, rotz = GetActorRot(system.currentActor.hActor)
    while GetControlState(id) do
        if id == NUMPAD6KEY then
            roty = roty - 0.5
        else
            roty = roty + 0.5
        end
        if roty < 0 then
            roty = roty + 360
        elseif roty > 360 then
            roty = roty - 360
        end
        SetActorRot(system.currentActor.hActor, rotx, roty, rotz)
        break_here()
    end
end
ss = function() -- line 2107
    local pos = spotfinder:getpos()
    local x, y = WorldToScreen(pos.x, pos.y, pos.z)
    PrintDebug("{x=" .. x .. ", y=" .. y .. "}\n")
end
input_boot_parameter = function() -- line 2122
    local jump_number
    jump_number = InputDialog("Boot Parameter", "Enter jump number:")
    start_script(jump_script, jump_number)
end
est_test = function() -- line 2129
    manny:push_costume("est.cos")
    start_sfx("brExplo.wav")
    manny:fade_in_chore(0, "est.cos", 400)
    sleep_for(1500)
    manny:fade_out_chore(0, "est.cos", 1500)
    sleep_for(1500)
    manny:pop_costume()
    manny:say_line("/hama054/")
end
input_variable_and_print = function() -- line 2145
    local name = InputDialog("Print Variable", "Type in variable name")
    if name then
        print_variable(name)
    end
end
print_variable = function(name) -- line 2156
    PrintDebug("\n\n")
    if type(getglobal(name)) == "table" then
        print_table(getglobal(name), name)
    else
        PrintDebug("Variable " .. name .. " = " .. getglobal(name) .. "\n")
    end
    PrintDebug("\n\n")
end
print_use_point = function() -- line 2174
    local temp, iName, iBigName, fName
    iName = InputDialog("Create Object:", "Enter internal name, minus set: (\"bun_2_obj\")")
    fName = InputDialog("Create Object:", "Enter friendly name: (\"Mr. Bun!\")")
    iBigName = strsub(system.currentSet.setFile, 1, 2) .. "." .. iName
    PrintDebug("\nUsepoint for new object:\n")
    PrintDebug("----------------------------------------------------------------\n\n")
    if spotfinder_active then
        PrintDebug(iBigName .. "\t\t= Object:create(" .. strsub(system.currentSet.setFile, 1, 2) .. ", \"" .. fName .. "\", " .. spotfinder.pos.x .. ", " .. spotfinder.pos.y .. ", " .. spotfinder.pos.z .. ", {range=0.6})\n\n")
    end
    temp = system.currentActor:getpos()
    if abs(temp.z) < 1e-06 then
        temp.z = 0
    end
    PrintDebug(iBigName .. ".use_pnt_x = " .. temp.x .. "\n")
    PrintDebug(iBigName .. ".use_pnt_y = " .. temp.y .. "\n")
    PrintDebug(iBigName .. ".use_pnt_z = " .. temp.z .. "\n")
    temp = system.currentActor:getrot()
    if abs(temp.z) < 1e-06 then
        temp.z = 0
    end
    PrintDebug(iBigName .. ".use_rot_x = " .. temp.x .. "\n")
    PrintDebug(iBigName .. ".use_rot_y = " .. temp.y .. "\n")
    PrintDebug(iBigName .. ".use_rot_z = " .. temp.z .. "\n")
    PrintDebug("\n")
    PrintDebug("" .. iBigName .. ".lookAt = function (self)")
    PrintDebug("end")
    PrintDebug("\n")
    PrintDebug("" .. iBigName .. ".pickUp = function (self)")
    PrintDebug("end")
    PrintDebug("\n")
    PrintDebug("" .. iBigName .. ".use = function (self)")
    PrintDebug("end")
    PrintDebug("\n")
    PrintDebug("\n\n----------------------------------------------------------------\n\n")
end
print_out_point = function() -- line 2219
    local temp, iName, iBigName, fName
    iName = InputDialog("Create Object:", "Enter door name, minus set: ('ha_door')")
    iBigName = strsub(system.currentSet.setFile, 1, 2) .. "." .. iName
    PrintDebug("\nOutpoint for door:\n")
    PrintDebug("\n\n----------------------------------------------------------------\n\n")
    temp = system.currentActor:getpos()
    if abs(temp.z) < 1e-06 then
        temp.z = 0
    end
    PrintDebug(iBigName .. ".out_pnt_x = " .. temp.x .. "\n")
    PrintDebug(iBigName .. ".out_pnt_y = " .. temp.y .. "\n")
    PrintDebug(iBigName .. ".out_pnt_z = " .. temp.z .. "\n")
    temp = system.currentActor:getrot()
    if abs(temp.z) < 1e-06 then
        temp.z = 0
    end
    PrintDebug(iBigName .. ".out_rot_x = " .. temp.x .. "\n")
    PrintDebug(iBigName .. ".out_rot_y = " .. temp.y .. "\n")
    PrintDebug(iBigName .. ".out_rot_z = " .. temp.z .. "\n")
    PrintDebug("\n")
    PrintDebug("" .. iBigName .. ".walkOut = function (self)")
    PrintDebug("end")
    PrintDebug("\n")
    PrintDebug("\n\n----------------------------------------------------------------\n\n")
end
PrintSystemMembers = function() -- line 2249
    local name, value
    PrintDebug("Things in system: \n")
    name, value = next(system, nil)
    while name do
        PrintDebug("Member " .. name .. " : " .. type(value) .. "\n")
        name, value = next(system, name)
    end
end
PrintSystemFunctionsToFile = function(filename) -- line 2265
    local name, value
    local output_handle
    output_handle = writeto(filename)
    writeto(output_handle)
    write("Current Functions: \n(" .. date() .. ")\n\n")
    name, value = nextvar(nil)
    while name do
        if type(value) == "function" then
            write("\t" .. name .. "()\n")
        end
        name, value = nextvar(name)
    end
    writeto()
end
system.IndexFB = function(table, field) -- line 2290
    if field == "parent" then
        return system.oldIndexFB(table, field)
    end
    if indexFB_disabled then
        indexFB_disabled = FALSE
        return system.oldIndexFB(table, field)
    end
    local p = table.parent
    if type(p) == "table" then
        return p[field]
    else
        return system.oldIndexFB(table, field)
    end
end
system.oldIndexFB = setfallback("index", system.IndexFB)
stopKeyDown = function(id, bDown) -- line 2311
    if bDown then
        if not estr[1] and id == BKEY then
            ester[1] = "b"
        elseif not estr[2] and id == LKEY and ester[1] == "b" then
            ester[2] = "l"
        elseif not ester[3] and id == AKEY and ester[1] == "b" and ester[2] == "l" then
            ester[3] = "a"
        elseif ester[1] == "b" and ester[2] == "l" and ester[3] == "a" and id == MKEY then
            start_script(est_test)
            ester = { }
        else
            ester = { }
        end
    end
end
system.GettableFB = function(table, field) -- line 2331
    PrintDebug("********************************\n")
    print_stack()
    PrintWarning("\nTried to index a non table!\n")
    PrintDebug("\"Table\" type: " .. type(table))
    PrintDebug("\t")
    PrintDebug("Field=" .. tostring(field))
    PrintDebug("********************************\n\n")
    return nil
end
system.oldGettableFB = setfallback("gettable", system.GettableFB)
system.ErrorFB = function(errorStr) -- line 2347
    local doSpew = ReadRegistryValue("SpewOnError")
    PrintDebug("********************************\n")
    PrintDebug("Error: " .. errorStr .. "\n")
    print_stack()
    if doSpew then
        SpewStartup()
    end
    return system.oldErrorFB(errorStr)
end
system.oldErrorFB = setfallback("error", system.ErrorFB)
system.DoFile = function(name) -- line 2368
    local result
    result = system.prevDoFile(name)
    if result == nil then
        result = system.prevDoFile("Scripts\\" .. name)
    end
    if result == nil then
        return system.prevDoFile("d:\\grimFandango\\Scripts\\" .. name)
    end
end
system.prevDoFile = dofile
dofile = system.DoFile
system.currentSet = nil
globalize = function(module) -- line 2396
    local name, value = next(module, nil)
    while name do
        if type(value) ~= "userdata" and type(value) ~= "function" and type(value) ~= "table" then
        end
        setglobal(name, value)
        name, value = next(module, name)
    end
end
unglobalize = function(module) -- line 2410
    local name, value = next(module, nil)
    while name do
        module[name] = getglobal(name)
        setglobal(name, nil)
        name, value = next(module, name)
    end
end
rnd = function(low, high) -- line 2424
    if not high then
        if not low then
            low = 5
        elseif low > 9 or low < 1 then
            PrintDebug("Call rnd with integers 1 - 9, please!")
        end
        i = random()
        if i >= low / 10 then
            return TRUE
        else
            return FALSE
        end
    else
        return low + (high - low) * random()
    end
end
rndint = function(low, high) -- line 2445
    if high then
        return low + floor((high - low + 0.9999) * random())
    else
        return floor((low + 0.99999) * random())
    end
end
normalize_vector = function(vec) -- line 2457
    local len, scale, newvec
    len = sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
    scale = 1 / len
    newvec = { }
    newvec.x = vec.x * scale
    newvec.y = vec.y * scale
    newvec.z = vec.z * scale
    return newvec
end
system.camChangeHandler = function(prevSetup, nextSetup) -- line 2473
    if system.currentSet then
        system.currentSet:CommonCameraChange(prevSetup, nextSetup)
    end
end
system.postCamChangeHandler = function(newSetup) -- line 2479
    if system.currentSet then
        system.currentSet:CommonPostCameraChange(newSetup)
    end
end
jump_script = function(jump_number) -- line 2485
    if jump_number then
        PrintDebug("Jumping to " .. jump_number .. "\n")
        if jump_number == "100" or jump_number == "rb" then
            reaped_bruno = TRUE
        elseif jump_number == "200" or jump_number == "rm" then
            reaped_bruno = TRUE
            reaped_meche = TRUE
        elseif jump_number == "gb" then
            pk:switch_to_set()
            gb()
        elseif jump_number == "tb" then
            mo:switch_to_set()
            tu.chem_state = "both chem"
        elseif jump_number == "tc" then
            tu.door_state = "open"
            mo.cards:get()
            tu:switch_to_set()
        elseif jump_number == "mm" then
            reaped_meche = TRUE
            mo:manny_meche_dialog()
        elseif jump_number == "sd" then
            gs.is_jail = TRUE
            gs:switch_to_set()
            manny:put_in_set(gs)
            salvador:put_in_set(gs)
            salvador:ignore_boxes()
            salvador:setpos(0.814534, 9.57068, 0)
            salvador:setrot(0, 6.2113, 0)
            salvador:play_chore(sv_helps_hidden)
            gs.ga_door:close()
            gs.ga_door:lock()
        elseif jump_number == "cr" then
            dom.coral:get()
            le:switch_to_set()
            manny:put_in_set(le)
        elseif jump_number == "pb" then
            fe.balloon_cat:get()
            fe.balloon_dingo:get()
            fe.balloon_frost:get()
            fe.bread:get()
            manny:put_in_set(rf)
            rf:switch_to_set()
        elseif jump_number == "rip" then
            manny:put_in_set(sg)
            sg:switch_to_set()
            sg:glottis_rip_heart()
            manny:default("action")
            manny:put_in_set(sm)
        elseif jump_number == "forest" then
            sp:switch_to_set()
            manny:setpos(-0.05, -0.406, 0)
            glottis.heartless = TRUE
            glottis.ripped_heart = TRUE
            sp.web.contains = sp.heart
        elseif jump_number == "gh" then
            glottis.ripped_heart = TRUE
            glottis.heartless = FALSE
            manny:default("action")
            sp:switch_to_set()
            manny:put_in_set(sp)
            manny:put_at_interest(sg)
            sg:enter()
        elseif jump_number == "tp" then
            tr.seen_pumps = TRUE
            tr:switch_to_set()
            tr:set_up_actors()
        elseif jump_number == "tf" then
            hk.turkey_baster:get()
            hk.turkey_baster.full = TRUE
            si:switch_to_set()
            manny:put_in_set(si)
        elseif jump_number == "dm" then
            sl.detector:get()
            si.dog_tags:get()
            mg:switch_to_set()
            manny:put_in_set(mg)
        elseif jump_number == "shanghai2" then
            ce:switch_to_set()
            meche.shanghaid = TRUE
            lm:switch_to_set()
            manny:put_in_set(lm)
            manny:setpos(-0.191064, -2.65641, 0.015)
            manny:setrot(0, 142.729, 0)
            lm:current_setup(lm_gngms)
            lm.talked_union = TRUE
            lm.talked_naranja = TRUE
            lm.talked_tools = TRUE
        elseif jump_number == "hrkitchen" then
            hl.glottis_gambling = TRUE
            ci.piano:make_touchable()
            lm.talked_union = TRUE
            dd.talked_charlie = TRUE
            ks.opener:get()
            hk.seen_swap = TRUE
            hk:switch_to_set()
            manny:put_in_set(hk)
            manny:setpos(-1.24469, 0.178395, 0)
            manny:setrot(0, 222.532, 0)
        elseif jump_number == "winecellar" then
            hl.glottis_gambling = TRUE
            ci.piano:make_touchable()
            lm.talked_union = TRUE
            dd.talked_charlie = TRUE
            ks.opener:put_in_limbo()
            hk.upper_cask:open()
            hk.pantry:unlock()
            hk.pantry:open()
            hk.cask_empty = TRUE
            hk.raoul_trapped = TRUE
            hk.seen_swap = TRUE
            he.aitor_downstairs = FALSE
            de.forklift_actor.currentSet = wc
            wc:switch_to_set()
            manny:put_in_set(wc)
            manny:setpos(-0.46517, -0.93618, 0.0210001)
            manny:setrot(0, 320, 0)
        elseif jump_number == "mf" then
            start_script(mf.setup_suffering)
        elseif jump_number == "ts" then
            start_script(me.test_shootout)
        else
            if cut_scene[jump_number] then
                start_script(cut_scene[jump_number])
            else
                PrintDebug("Invalid jump number!")
            end
        end
    else
        PrintDebug("No jump entered!")
    end
end
soft_script = function() -- line 2629
    local curScript
    if soft_script_table == nil then
        soft_script_table = { }
    end
    curScript = GetCurrentScript()
    if curScript then
        soft_script_table[curScript] = TRUE
    else
        PrintDebug("***********************************\n")
        PrintDebug("Can't mark that function as soft!\n")
        PrintDebug("     Maybe it's not a script!\n")
        PrintDebug("***********************************\n")
    end
end
kill_soft_scripts = function() -- line 2653
    local doomed_script, doomed_index
    if soft_script_table ~= nil then
        doomed_script = next(soft_script_table, nil)
        while doomed_script ~= nil do
            stop_script(doomed_script)
            doomed_index = next(soft_script_table, doomed_script)
            soft_script_table[doomed_script] = nil
            doomed_script = doomed_index
        end
    end
end
exit_the_game = function() -- line 2673
    saveload_menu:destroy()
    settings_menu:destroy()
    main_menu:destroy()
    exit()
    break_here()
end
dofile("_colors.lua")
dofile("_sfx.lua")
dofile("_actors.lua")
dofile("_controls.lua")
dofile("_objects.lua")
dofile("_dialog.lua")
dofile("_sets.lua")
dofile("_inventory.lua")
dofile("_cut_scenes.lua")
dofile("_music.lua")
dofile("_options.lua")
BundleResource = function(resourcename) -- line 2701
end
dofile("year_0.lua")
dofile("year_1.lua")
dofile("year_2.lua")
dofile("year_3.lua")
dofile("year_4.lua")
dofile("_local.lua")
specialload_menu = { name = "Special" }
specialload_menu.parent = saveload_menu
fooload_menu = { }
fooload_menu.caption = "/sytx547/"
fooload_menu.prompt = "/sytx548/"
specialload_menu.run = function(self, mode) -- line 2724
    PrintDebug("Running special load screen...\n")
    self.overlay_menu = nil
    self.parent.run(self, mode)
end
specialload_menu.build_menu = function(self) -- line 2731
    saveload_menu.build_menu(self)
    self.menu.items[self.exit_index].text = SAVELOAD_MENU_CONFIRM_CANCEL
end
specialload_menu.return_to_main = function(self) -- line 2736
    PrintDebug("Bailing out of special load screen...\n")
    self:cancel(FALSE)
    self:destroy()
end
handle_startup = function(bLoadLast, setfilename) -- line 2745
    local file_x, path
    local CD_ROM = ReadRegistryValue("GrimDataDir")
    local lastSaveFile, whichSave, i, j
    local diskpresent
    if not setfilename then
        setfilename = "mo.set"
    end
    if not developerMode then
        path = tostring(CD_ROM)
        file_x = writeto(path .. "\\bino.txt")
        writeto()
        if file_x then
            PrintDebug("You Lose!")
            remove(path .. "\\bino.txt")
            return nil
        end
    end
    if bLoadLast then
        PrintDebug("Attempting to resume last save game used!\n")
        lastSaveFile = ReadRegistryValue("LastSavedGame")
        saveTable = GetSaveGameData(lastSaveFile)
        if saveTable then
            diskpresent = CheckForCD(saveTable[2], nil)
            if diskpresent then
                i, j = strfind(lastSaveFile, "%d+")
                if i then
                    whichSave = strsub(lastSaveFile, i, j)
                    logname = "grimlog" .. whichSave .. ".htm"
                    dialog_log:copy_from(logname)
                end
                RenderModeUser(TRUE)
                Load(lastSaveFile)
                break_here()
                RenderModeUser(FALSE)
            end
        end
    end
    if not CheckForFile(setfilename) and CheckForFile("bi.set") then
        PrintDebug("Started from disk 2! Time to show the \"load game\" menu!\n")
        specialload_menu:run(SAVELOAD_MENU_LOAD_MODE)
        repeat
            break_here()
        until not specialload_menu.is_active
        PrintDebug("User chose not to load a saved game.\n")
    end
    if CheckForCD(setfilename, nil) then
        PrintDebug("Successful in getting a valid CD into the drive!")
        return TRUE
    end
    PrintDebug("Couldn't get a valid CD into the drive!")
    return nil
end
BOOT = function(resumeSave, bootParam) -- line 2843
    local defaultSet
    local last_setFile = ReadRegistryValue("GrimLastSet")
    local dev_ID = ReadRegistryValue("good_times")
    PrintDebug(" ")
    PrintDebug("\t\tlast_setFile = " .. tostring(last_setFile) .. "\n")
    PrintDebug(" ")
    if dev_ID ~= nil and strlower(dev_ID) == "pl" then
        PL_MODE = TRUE
    end
    GetSystemFonts()
    system_prefs:init()
    manny:set_selected()
    randomseed(5)
    if developerMode and last_setFile and CheckForFile(last_setFile) and not in(last_setFile, inv_sets) and last_setFile ~= "tp.set" then
        PrintDebug("TO BE REMOVED: Jumping to most recent room, " .. last_setFile .. "\n")
        defaultSet = last_setFile
    else
        dont_update_lastSet = TRUE
        defaultSet = "mo.set"
        PrintDebug("Booting with room mo.set...\n")
        time_to_run_intro = TRUE
    end
    system.currentSet = nil
    enable_default_keyboard_controls(TRUE)
    enable_cursor_keyboard_controls(TRUE)
    GlobalShrinkEnabled = TRUE
    shrinkBoxesEnabled = TRUE
    start_script(BOOTTWO, defaultSet, resumeSave)
end
BOOTTWO = function(defaultSet, resumeSave) -- line 2891
    if not handle_startup(resumeSave, defaultSet) then
        PrintDebug("Failed to handle startup conditions!  Exiting.")
        exit_the_game()
        return nil
    end
    source_all_set_files()
    if system.setTable[defaultSet] == nil then
        PrintDebug("No such set " .. defaultSet .. "available!\n")
        return nil
    end
    system.setTable[defaultSet]:switch_to_set()
    manny:default(look_up_correct_costume(system.currentSet))
    mo.scythe:get()
    system.currentActor:put_in_set(system.currentSet)
    system.currentActor:put_at_interest()
    start_script(TrackManny)
    start_script(WalkManny)
    cutSceneLevel = 0
end
wait_for_shrink_box_verb_code = function(verb_script) -- line 2928
    break_here()
    PrintDebug("WAITING FOR MANNY")
    manny:wait_for_actor()
    PrintDebug("WAITING FOR VERB CODE")
    wait_for_script(verb_script)
    PrintDebug("WAITING FOR CUT SCENE")
    while cutSceneLevel > 0 do
        break_here()
    end
    if system.currentSet.shrinkable and not system.currentSet.boxes_shrunk and manny.is_holding then
        shrink_box_toggle()
    end
end
shrink_box_toggle = function() -- line 2945
    local pos = { }
    local rot = { }
    local x, y, z
    START_CUT_SCENE()
    cameraman_disabled = FALSE
    pos = manny:getpos()
    if system.currentSet.shrinkable then
        x, y, z = GetShrinkPos(pos.x, pos.y, pos.z, manny.is_holding.shrink_radius)
        rot = manny:getrot()
        if manny.is_holding == mo.scythe and in(system.currentSet.setFile, need_scythe_sets) then
            manny:walkto(x, y, z, rot.x, rot.y, rot.z)
            if system.currentSet.shrinkable < mo.scythe.shrink_radius and x ~= nil then
                system.currentSet.boxes_shrunk = TRUE
                ShrinkBoxes(system.currentSet.shrinkable)
            elseif x ~= nil then
                system.currentSet.boxes_shrunk = TRUE
                ShrinkBoxes(mo.scythe.shrink_radius)
            end
        elseif not x then
            put_away_held_item()
        else
            if pos.x ~= x or pos.y ~= y or pos.z ~= z then
                manny:walkto(x, y, z, rot.x, rot.y, rot.z)
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
developerMode = ReadRegistryValue("good_times")
if developerMode then
    EnableDebugKeys()
end

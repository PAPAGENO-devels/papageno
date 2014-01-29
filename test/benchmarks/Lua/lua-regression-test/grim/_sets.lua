CheckFirstTime("_sets.lua")
system.setCount = 0
system.setTable = { }
system.currentSet = nil
system.ambientLight = 0
OBJSTATE_UNDERLAY = 1
OBJSTATE_OVERLAY = 2
OBJSTATE_STATE = 3
no_scythe_sets = { "co.set", "hq.set", "lo.set", "tu.set", "pk.set", "sm.set", "cf.set", "cc.set", "ci.set", "cn.set", "bk.set", "bi.set", "be.set", "ev.set", "sl.set", "pi.set", "do.set", "hh.set", "xb.set", "hp.set", "de.set", "il.set", "fo.set", "cy.set", "ew.set", "tg.set", "td.set", "mk.set", "nq.set", "th.set", "ly.set", "si.set" }
need_scythe_sets = { "tr.set", "ac.set", "dp.set", "fi.set", "gh.set", "gs.set", "ks.set", "lr.set", "lu.set", "mf.set", "mn.set", "mo.set", "my.set", "na.set", "op.set", "rf.set", "sg.set", "si.set", "sp.set", "vd.set", "vi.set", "vo.set", "hk.set" }
system.setTemplate = { name = "<unnamed>", setFile = nil, hSet = nil, setups = nil, cheat_boxes = nil, shrinkable = nil, boxes_shrunk = nil }
Set = system.setTemplate
Set.create = function(arg1, arg2, arg3, arg4, arg5) -- line 77
    local local1 = { }
    local1.parent = arg1
    if arg3 then
        local1.name = arg3
    else
        local1.name = arg2
    end
    local1.setFile = arg2
    local1.setups = arg4
    if arg4 then
        globalize(arg4)
    end
    local1.hSet = nil
    local1.number = system.setCount
    local1.doors = { }
    local1.cheat_boxes = { }
    local1.objects = { }
    local1.object_states = { }
    local1.camera_adjusts = { }
    local1.frozen_actors = nil
    local1.shrinkable = FALSE
    local1.boxes_shrunk = FALSE
    local1.cameraChange = FALSE
    if arg5 then
        local1.temporary = TRUE
    else
        local1.temporary = FALSE
    end
    system.setTable[arg2] = local1
    system.setTable[system.setCount] = local1
    system.setCount = system.setCount + 1
    PrintDebug("Adding room " .. system.setCount .. ": " .. arg2 .. "\n")
    return local1
end
Set.current_setup = function(arg1, arg2) -- line 130
    if arg2 == nil then
        return GetCurrentSetup(arg1.setFile)
    elseif arg2 ~= GetCurrentSetup(arg1.setFile) then
        MakeCurrentSetup(arg2)
        if system.ambientLight then
            SetAmbientLight(system.ambientLight)
        end
    end
end
Set.switch_to_set = function(arg1, arg2) -- line 151
    local local1
    local local2, local3
    local1 = FALSE
    if arg2 ~= nil and strfind(strlower(arg2), "noenter") ~= nil then
        local1 = TRUE
    end
    if system.currentSet ~= nil then
        if system.currentSet.boxes_shrunk then
            UnShrinkBoxes()
            system.currentSet.boxes_shrunk = FALSE
            PrintDebug("boxes unshrunk!")
        end
    end
    if system.currentSet and arg1.name == system.currentSet.name then
        PrintDebug("Already in " .. arg1.name .. "!\n")
    else
        PrintDebug("Switching to set: " .. arg1.name .. ".\n")
        system.lastSet = system.currentSet
        if system.currentSet ~= nil and not local1 then
            system.currentSet:CommonExit()
        end
        system.currentSet = arg1
        local2, local3 = CheckForCD(arg1.setFile, TRUE)
        if local3 then
            NukeResources()
            GetSystemFonts()
        end
        if not local1 then
            arg1:CommonEnter()
        end
        MakeCurrentSet(arg1.setFile)
        if not local1 then
            if Set.footsteps_table then
                Set.footsteps_table:update(arg1)
                set_vox_effect()
            end
        end
        if not local1 then
            arg1:enter()
        end
        print_scripts()
        if arg1.name ~= "Inventory" and developerMode then
            if dont_update_lastSet then
                dont_update_lastSet = FALSE
            else
                PrintDebug("Writing reg: GrimLastSet=" .. tostring(arg1.setFile) .. "\n")
                WriteRegistryValue("GrimLastSet", tostring(arg1.setFile))
            end
        end
        LightMgrSetChange()
        if system.ambientLight then
            SetAmbientLight(system.ambientLight)
        end
        if not local1 and (manny:get_costume() == nil or manny.costume_state ~= look_up_correct_costume(system.currentSet)) then
            manny:default(look_up_correct_costume(system.currentSet))
        end
        if not local1 then
            if music_state then
                music_state:update(arg1)
            end
        end
        if not local1 then
            if arg1.ambient_sfx then
                single_start_script(arg1.play_ambient_sfx, arg1)
            end
        end
    end
end
Set.come_out_door = function(arg1, arg2) -- line 254
    arg1:switch_to_set()
    if arg2 then
        system.currentActor:put_in_set(arg1)
        if arg2.comeOut then
            arg2:comeOut()
        else
            arg2:come_out_door()
        end
    else
        PrintDebug("\n* * * come_out_door: No valid door!\n")
    end
    arg1:cameraman()
end
Set.make_objects_visible = function(arg1) -- line 275
    local local1, local2 = next(arg1, nil)
    while local1 do
        if type(local2) == "table" then
            if local2.touchable or local2.has_object_states then
                PutActorInSet(local2.interest_actor.hActor, arg1.setFile)
                if arg1.temporary or system.object_names_showing then
                elseif local2.has_object_states then
                    local2.interest_actor:set_visibility(TRUE)
                else
                    local2.interest_actor:set_visibility(FALSE)
                end
            end
        end
        local1, local2 = next(arg1, local1)
    end
end
Set.update_object_names = function(arg1) -- line 302
    local local1, local2
    local local3
    local local4, local5
    system.object_names_showing = TRUE
    break_here()
    local1, local2 = next(arg1, nil)
    while local1 do
        if type(local2) == "table" then
            if local2.temp_text then
                KillTextObject(local2.temp_text)
                local2.temp_text = nil
            end
            if local2.touchable and local2.range > 0 then
                local3 = local2.interest_actor:getpos()
                local4, local5 = WorldToScreen(local3.x, local3.y, local3.z)
                if local4 and local5 then
                    local2.temp_text = MakeTextObject(local2.name, { fgcolor = White, x = local4, y = local5, font = special_font, center = TRUE })
                end
            end
        end
        local1, local2 = next(arg1, local1)
    end
end
Set.kill_object_names = function(arg1) -- line 336
    local local1, local2
    local1, local2 = next(arg1, nil)
    while local1 do
        if type(local2) == "table" then
            if local2.temp_text then
                KillTextObject(local2.temp_text)
                local2.temp_text = nil
            end
        end
        local1, local2 = next(arg1, local1)
    end
    system.object_names_showing = FALSE
end
Set.display_room_name = function(arg1) -- line 358
    arg1.room_text = MakeTextObject(arg1.name, { fgcolor = Aqua, x = 500, y = 460, font = pt_font })
end
Set.kill_room_name = function(arg1) -- line 366
    if arg1.room_text then
        KillTextObject(arg1.room_text)
    end
end
Set.CommonEnter = function(arg1) -- line 376
    arg1:make_objects_visible()
    if arg1.been_there then
        arg1.been_there = arg1.been_there + 1
    else
        arg1.been_there = 1
    end
    if arg1.temporary then
        system.object_names_showing = TRUE
        arg1:display_room_name()
        start_script(arg1.update_object_names, arg1)
    elseif system.object_names_showing then
        start_script(arg1.update_object_names, arg1)
    end
end
Set.CommonCameraChange = function(arg1, arg2, arg3) -- line 406
    local local1, local2
    local local3, local4, local5
    local local6
    current_setup = arg3
    if arg2 then
        last_setup = arg2
    else
        last_setup = current_setup
    end
    if arg1.camera_adjusts[arg3 + 1] then
        local4 = arg1.camera_adjusts[arg3 + 1]
    else
        local4 = 0
    end
    if MarioControl then
        local6 = TRUE
        if last_setup ~= nil and current_setup ~= nil then
            local1 = GetCameraLookVector(last_setup)
            local2 = GetCameraLookVector(current_setup)
            if type(local1) == "table" and type(local2) == "table" then
                local3 = GetAngleBetweenVectors(local1, local2)
                local5 = abs(system.camera_adjust_y - local4)
                if local3 + local5 < 80 then
                    local6 = FALSE
                end
            end
        end
        if local6 then
            ResetMarioControls()
        end
    end
    system.camera_adjust_y = local4
    if system.object_names_showing then
        start_script(arg1.update_object_names, arg1)
    end
    if arg1.camerachange then
        arg1:camerachange(arg2, arg3)
    end
end
Set.CommonPostCameraChange = function(arg1, arg2) -- line 461
    arg1:redraw_frozen_actors()
    if arg1.postcamerachange then
        arg1:postcamerachange(arg2)
    end
end
Set.CommonExit = function(arg1) -- line 475
    stop_script(arg1.play_ambient_sfx)
    if arg1.temporary then
        arg1:kill_room_name()
        arg1:kill_object_names()
    end
    if system.object_names_showing then
        arg1:kill_object_names()
        system.object_names_showing = TRUE
    end
    if arg1.exit then
        arg1:exit()
    end
    if MarioControl then
        ResetMarioControls()
    end
    arg1:free_object_states()
    hot_object = nil
    manny:head_look_at(nil)
end
Set.enter = function(arg1) -- line 510
end
Set.exit = function(arg1) -- line 519
end
Set.camerachange = function(arg1, arg2, arg3) -- line 528
end
Set.postcamerachange = function(arg1, arg2) -- line 536
end
Set.update_music_state = function(arg1) -- line 544
    return nil
end
Set.add_object_state = function(arg1, arg2, arg3, arg4, arg5, arg6) -- line 557
    if arg5 == nil then
        arg5 = OBJSTATE_STATE
    end
    return NewObjectState(arg2, arg5, arg3, arg4, arg6)
end
Set.free_object_states = function(arg1) -- line 571
    local local1, local2, local3
    local1 = next(arg1.object_states, nil)
    while local1 do
        local3 = next(arg1.object_states, local1)
        local1:free_object_state()
        local1 = local3
    end
end
Set.get_setup_name = function(arg1) -- line 589
    local local1, local2 = next(arg1.setups, nil)
    local local3
    while local1 do
        if arg1:current_setup() == local2 then
            if local3 then
                if strlen(local1) < strlen(local3) then
                    local3 = local1
                end
            else
                local3 = local1
            end
        end
        local1, local2 = next(arg1.setups, local1)
    end
    return local3
end
Set.cameraman = function(arg1) -- line 614
    local local1
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead then
        local1 = system.currentActor:find_sector_name(tostring(cameraman_box_name))
        if not local1 or arg1 ~= cameraman_watching_set then
            arg1:force_camerachange()
        else
            arg1.cameraChange = FALSE
        end
    end
end
Set.force_camerachange = function(arg1) -- line 639
    local local1, local2
    local local3
    arg1.cameraChange = TRUE
    cameraman_watching_set = arg1
    local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
    local3 = arg1.setups[tostring(cameraman_box_name)]
    arg1:current_setup(local3)
end
Set.next_set = function(arg1) -- line 654
    local local1 = system.setTable[arg1.number + 1]
    if not local1 then
        local1 = system.setTable[1]
    end
    local1:switch_to_set()
    manny:put_in_set(local1)
    manny:put_at_interest()
end
Set.prev_set = function(arg1) -- line 665
    local local1 = system.setTable[arg1.number - 1]
    if not local1 or local1 == testroom then
        local1 = system.setTable[system.setCount - 1]
    end
    local1:switch_to_set()
    manny:put_in_set(local1)
    manny:put_at_interest()
end
Set.redraw_frozen_actors = function(arg1) -- line 677
    local local1, local2
    if arg1.frozen_actors then
        local1, local2 = next(arg1.frozen_actors, nil)
        while local1 do
            local2.actor:refreeze()
            local1, local2 = next(arg1.frozen_actors, local1)
        end
    end
end
Set.short_name = function(arg1) -- line 690
    local local1 = arg1.setFile
    local local2
    local local3
    if local1 then
        local1 = strlower(local1)
        local3 = strfind(local1, ".set")
        if local3 then
            local2 = strsub(local1, 1, local3 - 1)
        end
    end
    return local2
end
Set.play_ambient_sfx = function(arg1) -- line 707
    local local1, local2
    local local3, local4
    local local5, local6, local7
    if type(arg1.ambient_sfx) == "table" then
        local2 = { min_delay = 4000, max_delay = 6000, min_volume = 50, max_volume = 100, min_pan = 0, max_pan = 127 }
        arg1.ambient_sfx = union_table(local2, arg1.ambient_sfx)
        if arg1.ambient_sfx.sfx then
            local1 = nil
            local5 = 0
            local6, local7 = next(arg1.ambient_sfx.sfx, nil)
            while local6 do
                local5 = local5 + 1
                local6, local7 = next(arg1.ambient_sfx.sfx, local6)
            end
            while TRUE do
                sleep_for(rndint(arg1.ambient_sfx.min_delay, arg1.ambient_sfx.max_delay))
                if cutSceneLevel <= 0 then
                    repeat
                        local3 = pick_one_of(arg1.ambient_sfx.sfx)
                    until local3 ~= local1 or local5 < 2
                    local4 = start_sfx(local3, IM_LOW_PRIORITY)
                    set_vol(local3, rndint(arg1.ambient_sfx.min_volume, arg1.ambient_sfx.max_volume))
                    set_pan(local3, rndint(arg1.ambient_sfx.min_pan, arg1.ambient_sfx.max_pan))
                    PrintDebug("Ambient stinger: " .. local3 .. "\n")
                    arg1.ambient_sfx.hCurSound = local4
                    arg1.ambient_sfx.curSound = local3
                    wait_for_sound(local4)
                    arg1.ambient_sfx.hCurSound = nil
                    local1 = local3
                end
                break_here()
            end
        end
    end
end
Set.add_ambient_sfx = function(arg1, arg2, arg3) -- line 752
    arg1.ambient_sfx = { }
    arg1.ambient_sfx.sfx = arg2
    if type(arg3) == "table" then
        arg1.ambient_sfx = union_table(arg1.ambient_sfx, arg3)
    end
end
Set.stop_ambient_sfx = function(arg1, arg2) -- line 760
    stop_script(arg1.play_ambient_sfx)
    if type(arg1.ambient_sfx) == "table" then
        if arg1.ambient_sfx.hCurSound and arg2 then
            fade_sfx(arg1.ambient_sfx.hCurSound, 500, 0)
        elseif arg1.ambient_sfx.hCurSound then
            stop_sound(arg1.ambient_sfx.hCurSound)
        end
        arg1.ambient_sfx.hCurSound = nil
        arg1.ambient_sfx.curSound = nil
    end
end
Set.unfreeze_all_actors = function(arg1) -- line 773
    local local1, local2, local3
    local3 = 0
    local1, local2 = next(system.actorTable, nil)
    while local1 do
        if local2.frozen == system.currentSet then
            local2:thaw(FALSE, TRUE)
            local3 = local3 + 1
        end
        if local2.body then
            if local2.body.frozen == system.currentSet then
                local2.body:thaw(FALSE, TRUE)
                local3 = local3 + 1
            end
        end
        local1, local2 = next(system.actorTable, local1)
    end
    if local3 > 0 then
        ForceRefresh()
    end
end
box_on = function(arg1) -- line 803
    MakeSectorActive(arg1, TRUE)
end
box_off = function(arg1) -- line 809
    MakeSectorActive(arg1, FALSE)
end
list_sets = function() -- line 817
    local local1 = 0
    local local2
    while system.setTable[local1] do
        local2 = system.setTable[local1]
        PrintDebug(local2.setFile .. "\t" .. local2.name .. "\n")
        local1 = local1 + 1
    end
end
display_setup_name = function() -- line 833
    if not system.setup_name_hText then
        system.setup_name_hText = MakeTextObject("", { fgcolor = Magenta, x = 10, y = 460, font = pt_font })
    end
    if not system.setup_name_shown or system.setup_name_shown ~= system.currentSet:get_setup_name() then
        system.setup_name_shown = system.currentSet:get_setup_name()
        if not system.setup_name_shown then
            ChangeTextObject(system.setup_name_hText, "[setup name not found]")
        else
            ChangeTextObject(system.setup_name_hText, system.setup_name_shown)
        end
    end
end
kill_setup_name = function() -- line 848
    setup_name_showing = FALSE
    KillTextObject(system.setup_name_hText)
    system.setup_name_shown = nil
    system.setup_name_hText = nil
end
slide_show = function(arg1) -- line 859
    local local1
    local local2 = system.currentSet.number
    local local3, local4
    local local5
    local local6
    local local7 = { }
    if InputDialog("Run Slide Show?", "(y OR n)") == "y" then
        if arg1 then
            local6 = arg1 * 1000
        else
            local6 = 4000
        end
        local1 = system.setTable[local2]
        while local1 do
            if not local1.temporary then
                local7[local1] = { }
                local1:switch_to_set()
                local3, local4 = next(local1.setups, nil)
                while local3 do
                    if not local7[local1][local4] and strsub(local3, 1, 2) ~= "ov" and strsub(local3, 4, 5) ~= "ov" and strsub(local3, 1, 3) ~= "top" and strsub(local3, 4, 6) ~= "top" then
                        local7[local1][local4] = TRUE
                        local1:current_setup(local4)
                        sleep_for(local6)
                    end
                    local3, local4 = next(local1.setups, local3)
                end
            end
            local2 = local2 + 1
            local1 = system.setTable[local2]
        end
    end
end
switch_to_set_from_user = function() -- line 904
    local local1
    local local2, local3
    PrintDebug("In switch_to_set_from_user()\n")
    local1 = InputDialog("Go to Set", "Enter set name (mo) or friendly name (Manny's Office):")
    if local1 ~= nil then
        local2, local3 = next(system.setTable, nil)
        while local2 do
            if strlower(local3.name) == strlower(local1) or strlower(local3.setFile) == strlower(local1 .. ".set") then
                local3:switch_to_set()
                system.currentActor:put_in_set(local3)
                system.currentActor:put_at_interest()
                return
            else
                local2, local3 = next(system.setTable, local2)
            end
        end
        PrintDebug("Set '" .. local1 .. "' not found.\n")
    end
end
load_room_code = function(arg1) -- line 935
    local local1
    local1 = dofile(arg1)
    if local1 ~= nil then
        PrintDebug("HELP! Couldn't source '" .. arg1 .. "'\n")
    else
        PrintDebug("Sourced '" .. arg1 .. "'\n")
    end
    return local1
end
source_all_set_files = function() -- line 953
    local local1
    local local2
    local local3
    local local4
    if DEMO then
        load_room_code("al.lua")
        load_room_code("do.lua")
        load_room_code("fe.lua")
        load_room_code("hq.lua")
        load_room_code("le.lua")
        load_room_code("mo.lua")
        load_room_code("os.lua")
        load_room_code("rf.lua")
        load_room_code("rp.lua")
        load_room_code("st.lua")
        load_room_code("suitset.lua")
    else
        load_room_code("ac.lua")
        load_room_code("al.lua")
        load_room_code("ar.lua")
        load_room_code("at.lua")
        load_room_code("bb.lua")
        load_room_code("bd.lua")
        load_room_code("be.lua")
        load_room_code("bi.lua")
        load_room_code("bk.lua")
        load_room_code("bl.lua")
        load_room_code("bp.lua")
        load_room_code("bs.lua")
        load_room_code("bu.lua")
        load_room_code("bv.lua")
        load_room_code("bw.lua")
        load_room_code("cc.lua")
        load_room_code("ce.lua")
        load_room_code("cf.lua")
        load_room_code("ci.lua")
        load_room_code("ck.lua")
        load_room_code("cl.lua")
        load_room_code("cn.lua")
        load_room_code("co.lua")
        load_room_code("cu.lua")
        load_room_code("cv.lua")
        load_room_code("cy.lua")
        load_room_code("dd.lua")
        load_room_code("de.lua")
        load_room_code("dh.lua")
        load_room_code("do.lua")
        load_room_code("dp.lua")
        load_room_code("dr.lua")
        load_room_code("ea.lua")
        load_room_code("ei.lua")
        load_room_code("ev.lua")
        load_room_code("ew.lua")
        load_room_code("fc.lua")
        load_room_code("fe.lua")
        load_room_code("fh.lua")
        load_room_code("fi.lua")
        load_room_code("fo.lua")
        load_room_code("fp.lua")
        load_room_code("ga.lua")
        load_room_code("gh.lua")
        load_room_code("gs.lua")
        load_room_code("gt.lua")
        load_room_code("ha.lua")
        load_room_code("hb.lua")
        load_room_code("he.lua")
        load_room_code("hf.lua")
        load_room_code("hh.lua")
        load_room_code("hk.lua")
        load_room_code("hl.lua")
        load_room_code("hp.lua")
        load_room_code("hq.lua")
        load_room_code("il.lua")
        load_room_code("kh.lua")
        load_room_code("jb.lua")
        load_room_code("lb.lua")
        load_room_code("ks.lua")
        load_room_code("lm.lua")
        load_room_code("le.lua")
        load_room_code("lr.lua")
        load_room_code("lo.lua")
        load_room_code("lw.lua")
        load_room_code("lu.lua")
        load_room_code("ly.lua")
        load_room_code("lx.lua")
        load_room_code("me.lua")
        load_room_code("lz.lua")
        load_room_code("mg.lua")
        load_room_code("mf.lua")
        load_room_code("mn.lua")
        load_room_code("mk.lua")
        load_room_code("mt.lua")
        load_room_code("mo.lua")
        load_room_code("my.lua")
        load_room_code("mx.lua")
        load_room_code("nl.lua")
        load_room_code("na.lua")
        load_room_code("op.lua")
        load_room_code("nq.lua")
        load_room_code("pc.lua")
        load_room_code("os.lua")
        load_room_code("pk.lua")
        load_room_code("pi.lua")
        load_room_code("re.lua")
        load_room_code("ps.lua")
        load_room_code("ri.lua")
        load_room_code("rf.lua")
        load_room_code("rp.lua")
        load_room_code("sg.lua")
        load_room_code("si.lua")
        load_room_code("se.lua")
        load_room_code("sm.lua")
        load_room_code("sh.lua")
        load_room_code("st.lua")
        load_room_code("sl.lua")
        load_room_code("td.lua")
        load_room_code("sp.lua")
        load_room_code("tg.lua")
        load_room_code("su.lua")
        load_room_code("tr.lua")
        load_room_code("tb.lua")
        load_room_code("tu.lua")
        load_room_code("te.lua")
        load_room_code("tx.lua")
        load_room_code("th.lua")
        load_room_code("vi.lua")
        load_room_code("ts.lua")
        load_room_code("wc.lua")
        load_room_code("tw.lua")
        load_room_code("zw.lua")
        load_room_code("vd.lua")
        load_room_code("tp.lua")
        load_room_code("vo.lua")
        load_room_code("cb.lua")
        load_room_code("xb.lua")
        load_room_code("pf.lua")
        load_room_code("ul.lua")
    end
    return
end
set_ambient_light = function(arg1) -- line 1076
    if not arg1 then
        arg1 = 0
    end
    system.ambientLight = arg1
    SetAmbientLight(arg1)
end
Set.footsteps_table = { }
Set.footsteps_table.ac = "underwater"
Set.footsteps_table.al = "concrete"
Set.footsteps_table.ar = "metal"
Set.footsteps_table.at = "echo"
Set.footsteps_table.bb = "concrete"
Set.footsteps_table.bd = "dirt"
Set.footsteps_table.be = "concrete"
Set.footsteps_table.bi = "marble"
Set.footsteps_table.bk = "marble"
Set.footsteps_table.bl = "sand"
Set.footsteps_table.bp = "concrete"
Set.footsteps_table.bs = "marble"
Set.footsteps_table.bu = "sand"
Set.footsteps_table.bv = "dirt"
Set.footsteps_table.bw = "concrete"
Set.footsteps_table.cb = "concrete"
Set.footsteps_table.cc = "rug"
Set.footsteps_table.ce = "concrete"
Set.footsteps_table.cf = "rug"
Set.footsteps_table.ci = "rug"
Set.footsteps_table.ck = "dirt"
Set.footsteps_table.cl = "concrete"
Set.footsteps_table.cn = "rug"
Set.footsteps_table.co = "rug"
Set.footsteps_table.cu = "marble"
Set.footsteps_table.cv = "concrete"
Set.footsteps_table.cy = "underwater"
Set.footsteps_table.dd = "concrete"
Set.footsteps_table.de = "metal"
Set.footsteps_table.dh = "concrete"
Set.footsteps_table["do"] = "rug"
Set.footsteps_table.dp = "metal"
Set.footsteps_table.dr = "metal"
Set.footsteps_table.ea = "underwater"
Set.footsteps_table.ei = "metal"
Set.footsteps_table.ev = "concrete"
Set.footsteps_table.ew = "sand"
Set.footsteps_table.fc = "dirt"
Set.footsteps_table.fe = "pavement"
Set.footsteps_table.fh = "metal2"
Set.footsteps_table.fi = "marble"
Set.footsteps_table.fo = "metal"
Set.footsteps_table.fp = "concrete"
Set.footsteps_table.ga = "echo"
Set.footsteps_table.ge = "concrete"
Set.footsteps_table.gh = "metal"
Set.footsteps_table.gs = "concrete"
Set.footsteps_table.gt = "marble"
Set.footsteps_table.ha = "rug"
Set.footsteps_table.hb = "concrete"
Set.footsteps_table.he = "marble"
Set.footsteps_table.hf = "marble"
Set.footsteps_table.hh = "rug"
Set.footsteps_table.hi = "rug"
Set.footsteps_table.hk = "marble"
Set.footsteps_table.hl = "rug"
Set.footsteps_table.hp = "marble"
Set.footsteps_table.hq = "concrete"
Set.footsteps_table.il = "metal2"
Set.footsteps_table.jb = "concrete"
Set.footsteps_table.kh = "echo"
Set.footsteps_table.ks = "concrete"
Set.footsteps_table.lb = "dirt"
Set.footsteps_table.le = "concrete"
Set.footsteps_table.lm = "creak"
Set.footsteps_table["lo"] = "marble"
Set.footsteps_table.lr = "marble"
Set.footsteps_table.lu = "metal2"
Set.footsteps_table.lw = "echo"
Set.footsteps_table.lx = "concrete"
Set.footsteps_table.ly = "rug"
Set.footsteps_table.lz = "concrete"
Set.footsteps_table.me = "flowers"
Set.footsteps_table.mf = "flowers"
Set.footsteps_table.mg = "reverb"
Set.footsteps_table.mk = "concrete"
Set.footsteps_table.mn = "underwater"
Set.footsteps_table.mo = "rug"
Set.footsteps_table.mt = "concrete"
Set.footsteps_table.mx = "rug"
Set.footsteps_table.my = "concrete"
Set.footsteps_table.na = "dirt"
Set.footsteps_table.nl = "concrete"
Set.footsteps_table.nq = "marble"
Set.footsteps_table.op = "metal2"
Set.footsteps_table.os = "pavement"
Set.footsteps_table.pc = "concrete"
Set.footsteps_table.pi = "marble"
Set.footsteps_table.pk = "marble"
Set.footsteps_table.ps = "underwater"
Set.footsteps_table["re"] = "concrete"
Set.footsteps_table.rf = "pavement"
Set.footsteps_table.ri = "marble"
Set.footsteps_table.rp = "pavement"
Set.footsteps_table.sd = "concrete"
Set.footsteps_table.se = "gravel"
Set.footsteps_table.sg = "dirt"
Set.footsteps_table.sh = "echo"
Set.footsteps_table.si = "metal"
Set.footsteps_table.sl = "marble"
Set.footsteps_table.sm = "dirt"
Set.footsteps_table.sp = "dirt"
Set.footsteps_table.st = "pavement"
Set.footsteps_table.su = "underwater"
Set.footsteps_table.tb = "marble"
Set.footsteps_table.td = "snow"
Set.footsteps_table.te = "metal2"
Set.footsteps_table.tg = "marble"
Set.footsteps_table["th"] = "concrete"
Set.footsteps_table.tr = "dirt"
Set.footsteps_table.ts = "marble"
Set.footsteps_table.tu = "concrete"
Set.footsteps_table.tw = "marble"
Set.footsteps_table.tx = "marble"
Set.footsteps_table.vd = "metal2"
Set.footsteps_table.vi = "reverb"
Set.footsteps_table.vo = "reverb"
Set.footsteps_table.wc = "reverb"
Set.footsteps_table.xb = "concrete"
Set.footsteps_table.zw = "echo"
Set.footsteps_table.update = function(arg1, arg2) -- line 1213
    local local1
    local local2
    if arg2 then
        local1 = arg2:short_name()
        if local1 and arg1[local1] then
            local2 = arg1[local1]
            if footsteps[local2] then
                system.currentActor.footsteps = footsteps[local2]
            else
                PrintDebug("Couldn't set default footsteps for " .. local1 .. "\n")
            end
        end
    end
end
Set.stereo_ring_sets = { "ac", "mn", "ps", "su", "ea" }
Set.short_reverb_sets = { "hb", "wc", "dp", "ei", "il", "op", "vd", "vi", "vo" }
Set.basic_reverb_sets = { "ga", "mg", "fh", "at", "lw", "sh", "te", "zw" }
if load_room_code("testroom.lua") ~= nil then
    return
end

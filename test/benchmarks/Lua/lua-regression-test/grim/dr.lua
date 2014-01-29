CheckFirstTime("dr.lua")
dr = Set:create("dr.set", "dominos room", { dr_winws = 0, dr_winws1 = 0, dr_dorrv = 1, dr_ovrhd = 2 })
dofile("dom_isle_idles.lua")
dr.gw = function() -- line 14
    mn.gun:get()
    mn.chisel:get()
    fo.hammer:get()
    mo.scythe:get()
end
dr.dp = function() -- line 21
    stop_script(dr.weapons_check)
    stop_script(dr.smoke_idles)
    dofile("patch")
    start_script(dr.weapons_check)
    start_script(dr.smoke_idles)
end
fs = function() -- line 29
    domino:play_chore(dom_isle_idles_idle_headphone, "dom_isle_idles.cos")
    domino:fade_out_chore(dom_isle_idles_smoke, "dom_isle_idles.cos", 1000)
end
dr.weapons_check = function() -- line 34
    local local1 = manny.is_holding
    while 1 do
        if system.currentSet == dr then
            if manny.is_holding == mn.gun or manny.is_holding == mn.chisel or (manny.is_holding == fo.hammer and not dr.laughed_at_hammer) or manny.is_holding == mo.scythe then
                set_override(nil)
                START_CUT_SCENE()
                stop_script(dr.smoke_idles)
                local1 = manny.is_holding
                if domino.smoking then
                    domino.smoking = FALSE
                    domino:play_chore(dom_isle_idles_idle_headphone, "dom_isle_idles.cos")
                    domino:fade_out_chore(dom_isle_idles_smoke, "dom_isle_idles.cos", 750)
                    sleep_for(750)
                end
                domino:run_chore(dom_isle_idles_gun_out, "dom_isle_idles.cos")
                wait_for_script(close_inventory)
                if local1 == fo.hammer then
                    dr.laughed_at_hammer = TRUE
                    domino:say_line("/drdo071/")
                    wait_for_message()
                    domino:say_line("/drdo072/")
                    wait_for_message()
                    domino:play_chore(dom_isle_idles_laugh, "dom_isle_idles.cos")
                    domino:say_line("/drdo073/")
                    wait_for_message()
                    domino:say_line("/drdo074/")
                    domino:wait_for_chore(dom_isle_idles_laugh, "dom_isle_idles.cos")
                else
                    if not dr.tried_weapon then
                        dr.tried_weapon = TRUE
                        domino:say_line("/drdo075/")
                    else
                        domino:say_line("/drdo076/")
                    end
                    domino:wait_for_message()
                    manny:clear_hands()
                    domino:say_line("/drdo077/")
                end
                domino:run_chore(dom_isle_idles_hide_gun, "dom_isle_idles.cos")
                domino:fade_out_chore(dom_isle_idles_hide_gun, "dom_isle_idles.cos")
                domino:complete_chore(dom_isle_idles_idle_headphone, "dom_isle_idles.cos")
                single_start_script(dr.smoke_idles)
                END_CUT_SCENE()
            end
        end
        break_here()
    end
end
test = function() -- line 87
    while 1 do
        PrintDebug(cutSceneLevel)
        break_here()
    end
end
dr.smoke_idles = function(arg1) -- line 94
    while 1 do
        domino.smoking = FALSE
        sleep_for(10000 + 5000 * random())
        domino.smoking = TRUE
        if arg1 then
            domino:run_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
            domino:stop_chore(dom_isle_idles_smoke_no_headphone, "dom_isle_idles.cos")
            domino:complete_chore(dom_isle_idles_idle, "dom_isle_idles.cos")
        else
            domino:run_chore(dom_isle_idles_smoke, "dom_isle_idles.cos")
            domino:stop_chore(dom_isle_idles_smoke, "dom_isle_idles.cos")
            domino:complete_chore(dom_isle_idles_idle_headphone, "dom_isle_idles.cos")
        end
    end
end
dr.phones_off = function() -- line 112
    domino.wearing_headphones = FALSE
    domino:play_chore(dom_isle_idles_takeoff_headphone, "dom_isle_idles.cos")
    sleep_for(1600)
    dr.phones:set_visibility(TRUE)
    start_sfx("TinHect.IMU", IM_HIGH_PRIORITY, 127)
    set_pan("TinHect.IMU", 80)
end
dr.phones_on = function() -- line 121
    domino.wearing_headphones = TRUE
    domino:play_chore(dom_isle_idles_put_on_headphone, "dom_isle_idles.cos")
    fade_sfx("TinHect.IMU", 500, 0)
    sleep_for(500)
    dr.phones:set_visibility(FALSE)
end
dr.set_up_actors = function(arg1) -- line 129
    domino:set_costume(nil)
    domino:default()
    domino:ignore_boxes()
    domino:put_in_set(dr)
    domino:set_costume("dom_isle_idles.cos")
    domino:setpos(-0.0463288, 0.999448, 0)
    domino:setrot(0, 108.041, 0)
    domino:set_mumble_chore(dom_isle_idles_mumble, "dom_isle_idles.cos")
    domino:set_talk_chore(1, dom_isle_idles_no_talk)
    domino:set_talk_chore(2, dom_isle_idles_a)
    domino:set_talk_chore(3, dom_isle_idles_c)
    domino:set_talk_chore(4, dom_isle_idles_e)
    domino:set_talk_chore(5, dom_isle_idles_f)
    domino:set_talk_chore(6, dom_isle_idles_l)
    domino:set_talk_chore(7, dom_isle_idles_m)
    domino:set_talk_chore(8, dom_isle_idles_o)
    domino:set_talk_chore(9, dom_isle_idles_t)
    domino:set_talk_chore(10, dom_isle_idles_u)
    domino:set_head(6, 7, 8, 165, 28, 80)
    domino:set_look_rate(130)
    if not dr.phones then
        dr.phones = Actor:create()
    end
    dr.phones:ignore_boxes()
    dr.phones:put_in_set(dr)
    dr.phones:set_costume("dom_isle_idles.cos")
    dr.phones:setpos(-0.0463288, 0.999448, 0)
    dr.phones:setrot(0, 108.041, 0)
    dr.phones:play_chore(dom_isle_idles_headphone_only, "dom_isle_idles.cos")
    dr.phones:set_visibility(FALSE)
    domino.wearing_headphones = TRUE
    domino:play_chore(dom_isle_idles_idle_headphone, "dom_isle_idles.cos")
    start_script(dr.smoke_idles)
    SetShadowColor(10, 10, 20)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 100, 40, 600)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
end
dr.enter = function(arg1) -- line 182
    dr:set_up_actors()
    start_script(dr.weapons_check)
end
dr.camerachange = function(arg1, arg2, arg3) -- line 187
    if arg3 == dr_winws then
        domino:setpos(-0.0463288, 0.999448, -0.06)
    else
        domino:setpos(-0.0463288, 0.999448, 0)
    end
end
dr.exit = function(arg1) -- line 195
    domino:free()
    dr.phones:free()
    stop_script(dr.smoke_idles)
    stop_script(dr.weapons_check)
    dr.tried_weapon = FALSE
    KillActorShadows(manny.hActor)
    if sound_playing("TinHect.IMU") then
        stop_sound("TinHect.IMU")
    end
end
dr.domino_obj = Object:create(dr, "/drtx078/Domino", 0.076994799, 0.99400002, 0.4465, { range = 1 })
dr.domino_obj.use_pnt_x = -0.25600499
dr.domino_obj.use_pnt_y = 0.34999999
dr.domino_obj.use_pnt_z = 0
dr.domino_obj.use_rot_x = 0
dr.domino_obj.use_rot_y = -33.384602
dr.domino_obj.use_rot_z = 0
dr.domino_obj.lookAt = function(arg1) -- line 223
    manny:say_line("/drma079/")
end
dr.domino_obj.use = function(arg1) -- line 227
    Dialog:run("do2", "dlg_dom2.lua")
end
dr.domino_obj.use_hammer = function(arg1) -- line 231
    manny:say_line("/drma080/")
end
dr.domino_obj.use_stockings = function(arg1) -- line 235
    manny:say_line("/drma081/")
end
dr.ar_door = Object:create(dr, "/drtx082/door", 0.0126288, -2.9293399, 0.31999999, { range = 0.60000002 })
dr.ar_door.use_pnt_x = 0.00262878
dr.ar_door.use_pnt_y = -2.7093401
dr.ar_door.use_pnt_z = -0.14
dr.ar_door.use_rot_x = 0
dr.ar_door.use_rot_y = -533.91199
dr.ar_door.use_rot_z = 0
dr.ar_door.out_pnt_x = 0.00262878
dr.ar_door.out_pnt_y = -2.7093401
dr.ar_door.out_pnt_z = -0.14
dr.ar_door.out_rot_x = 0
dr.ar_door.out_rot_y = -533.91199
dr.ar_door.out_rot_z = 0
dr.ar_box = dr.ar_door
dr.ar_door.walkOut = function(arg1) -- line 260
    ar:come_out_door(ar.dr_door)
end

CheckFirstTime("lx.lua")
lx = Set:create("lx.set", "lighthouse exterior", { lx_dokla = 0, lx_extoh = 1, lx_extoh1 = 1, lx_oh = 2 })
lx.cheat_boxes = { lite_tele_box = 0, cheat_box_1 = 1 }
foghorn_table = { "foghorn1.wav", "foghorn2.wav", "foghorn3.wav", "foghorn4.wav" }
foghorn_sfx = function() -- line 16
    local local1
    while 1 do
        sleep_for(rndint(15000, 30000))
        if cutSceneLevel <= 0 then
            local1 = pick_from_nonweighted_table(foghorn_table, TRUE)
            start_sfx(local1, IM_LOW_PRIORITY)
            if system.currentSet == lx then
                if lx:current_setup() == lx_extoh then
                    set_vol(local1, 127)
                else
                    set_vol(local1, 90)
                end
            elseif system.currentSet == dd then
                set_vol(local1, 45)
            elseif system.currentSet == hb then
                set_vol(local1, 40)
            elseif system.currentSet == xb then
                set_vol(local1, 30)
            elseif system.currentSet == se then
                set_vol(local1, 30)
            elseif system.currentSet == sd then
                set_vol(local1, 30)
            elseif system.currentSet == lm then
                set_vol(local1, 25)
            elseif system.currentSet == cb then
                set_vol(local1, 25)
            elseif system.currentSet == bp then
                set_vol(local1, 25)
            elseif system.currentSet == ev then
                set_vol(local1, 25)
            elseif system.currentSet == ce then
                set_vol(local1, 25)
            elseif system.currentSet == cl then
                set_vol(local1, 25)
            elseif system.currentSet == bb then
                set_vol(local1, 25)
            end
        end
    end
end
lx.lola_wispers = function(arg1) -- line 61
    lola:say_line("/lxlo001/")
    lola:say_line("/lxlo002/")
    lola:say_line("/lxlo003/")
end
lx.reunion = function() -- line 68
    lx.got_sign = TRUE
    START_CUT_SCENE()
    break_here()
    manny:walkto(0.24467, 1.068, 3.03)
    manny:wait_for_actor()
    manny:say_line("/lxma011/")
    manny:twist_head_gesture()
    END_CUT_SCENE()
end
lx.find_lola = function() -- line 81
    cut_scene.loladies()
end
lx.teleport = function(arg1) -- line 104
    while 1 do
        if manny:find_sector_name("teleport2") then
            system:lock_display()
            manny:setpos(0.00395541, -4.73361, 0)
            manny:setrot(0, 0, 0)
            break_here()
            system:unlock_display()
        elseif manny:find_sector_name("teleport1") then
            system:lock_display()
            manny:setpos(-5.35422, -12.5758, 0)
            manny:setrot(0, -226, 0)
            break_here()
            system:unlock_display()
        end
        break_here()
    end
end
lx.enter = function(arg1) -- line 129
    if in_year_four then
        lx.lighthouse_door.opened = TRUE
    end
    if lx.lighthouse_door:is_open() then
        MakeSectorActive("doorpass", TRUE)
        NewObjectState(lx_dokla, OBJSTATE_UNDERLAY, "lx_ws_door_open.bm", nil, TRUE)
        lx.lighthouse_door:set_object_state("lx_door.cos")
        lx.lighthouse_door:play_chore(2)
    else
        MakeSectorActive("doorpass", FALSE)
        NewObjectState(lx_extoh, OBJSTATE_UNDERLAY, "lx_door.bm")
        NewObjectState(lx_dokla, OBJSTATE_UNDERLAY, "lx_ws_door_closed.bm", nil, TRUE)
        lx.lighthouse_door:set_object_state("lx_door.cos")
        lx.lighthouse_door:play_chore(1)
    end
    start_script(foghorn_sfx)
    start_script(lx.teleport)
    lx:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 2000, 4000, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 0.1, 0, 5)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    lx:camerachange(nil, lx:current_setup())
end
lx.camerachange = function(arg1, arg2, arg3) -- line 167
    StopMovie()
    if arg3 == lx_dokla then
        StartMovie("lxws.snm", TRUE)
    elseif arg3 == lx_extoh then
        StartMovie("lxtop.snm", TRUE)
    end
end
lx.exit = function() -- line 176
    StopMovie()
    stop_sound("liteHse.imu")
    stop_script(foghorn_sfx)
    stop_script(lx.teleport)
    KillActorShadows(manny.hActor)
end
lx.update_music_state = function(arg1) -- line 186
    if not in_year_four then
        if bi.seen_kiss then
            return stateLX_LOLA
        else
            return stateLX
        end
    else
        return stateLX
    end
end
lx.lengua = Object:create(lx, "/lxtx004/card", 0, 0, 0, { range = 0 })
lx.lengua.string_name = "lengua"
lx.lengua.wav = "getcard.wav"
lx.lengua.lookAt = function(arg1) -- line 209
    manny:say_line("/lxma005/")
end
lx.lengua.use = function(arg1) -- line 213
    system.default_response("with what")
end
lx.dd_door = Object:create(lx, "/lxtx006/pier", -12.2134, -14.3022, 0.20999999, { range = 0.60000002 })
lx.dd_door.use_pnt_x = -11.1334
lx.dd_door.use_pnt_y = -14.7522
lx.dd_door.use_pnt_z = 0
lx.dd_door.use_rot_x = 0
lx.dd_door.use_rot_y = -282.90701
lx.dd_door.use_rot_z = 0
lx.dd_door.out_pnt_x = -11.72
lx.dd_door.out_pnt_y = -14.615
lx.dd_door.out_pnt_z = 0
lx.dd_door.out_rot_x = 0
lx.dd_door.out_rot_y = -296.54999
lx.dd_door.out_rot_z = 0
lx.dd_box = lx.dd_door
lx.dd_door.walkOut = function(arg1) -- line 240
    dd:come_out_door(dd.lx_door)
end
lx.li_door = Object:create(lx, "/lxtx007/door", 0.221931, -1.14171, 0, { range = 0 })
lx.li_door.use_pnt_x = 0.0332647
lx.li_door.use_pnt_y = -1.52806
lx.li_door.use_pnt_z = 0
lx.li_door.use_rot_x = 0
lx.li_door.use_rot_y = -1074.97
lx.li_door.use_rot_z = 0
lx.li_door.out_pnt_x = 0.0305064
lx.li_door.out_pnt_y = -0.97834802
lx.li_door.out_pnt_z = 0
lx.li_door.out_rot_x = 0
lx.li_door.out_rot_y = -1087.45
lx.li_door.out_rot_z = 0
lx.li_door:make_untouchable()
lx.lite_bottom_box = lx.li_door
lx.li_door.walkOut = function(arg1) -- line 263
    lx.lighthouse_door:walkOut()
end
lx.lighthouse_door = Object:create(lx, "/lxtx008/door", 0.0039862199, -1.12906, 0.484, { range = 0.89999998 })
lx.lighthouse_door.use_pnt_x = 0.019986199
lx.lighthouse_door.use_pnt_y = -1.37506
lx.lighthouse_door.use_pnt_z = 0.029999999
lx.lighthouse_door.use_rot_x = 0
lx.lighthouse_door.use_rot_y = 9.3845901
lx.lighthouse_door.use_rot_z = 0
lx.lighthouse_door.out_pnt_x = 0.049580399
lx.lighthouse_door.out_pnt_y = -1.0998
lx.lighthouse_door.out_pnt_z = 0
lx.lighthouse_door.out_rot_x = 0
lx.lighthouse_door.out_rot_y = 360.09601
lx.lighthouse_door.out_rot_z = 0
lx.lighthouse_door.walkOut = function(arg1) -- line 293
    START_CUT_SCENE()
    manny:clear_hands()
    manny:walkto(arg1, TRUE)
    sleep_for(2000)
    END_CUT_SCENE()
    if in_year_four then
        lx:come_out_door(lx.top)
        if not lx.got_sign then
            start_script(lx.reunion)
        end
    elseif not lx.seen_lola then
        lx.seen_lola = TRUE
        start_script(lx.find_lola)
    else
        lx:come_out_door(lx.top)
    end
end
lx.lighthouse_door:lock()
lx.lighthouse_door.passage = { "doorpass" }
lx.lighthouse_door.lookAt = function(arg1) -- line 319
    if lx.lighthouse_door:is_open() then
        manny:say_line("/lxma009/")
    else
        system.default_response("locked")
    end
end
lx.lighthouse_door.use = function(arg1) -- line 327
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
lx.lighthouse_door.use_key = function(arg1, arg2) -- line 335
    arg1:unlock()
    arg1:open()
    arg1:make_untouchable()
    arg1:play_chore(0)
    put_away_held_item()
    sl.key:free()
    MakeSectorActive("doorpass", TRUE)
    NewObjectState(lx_dokla, OBJSTATE_UNDERLAY, "lx_ws_door_open.bm", nil, TRUE)
    lx.lighthouse_door:set_object_state("lx_door.cos")
    lx.lighthouse_door:play_chore(2)
end
lx.top = Object:create(lx, "/lxtx010/door", -0.85957599, 0.55007499, 3.03, { range = 0 })
lx.top.use_pnt_x = -0.189576
lx.top.use_pnt_y = 1.16008
lx.top.use_pnt_z = 3.03
lx.top.use_rot_x = 0
lx.top.use_rot_y = -592.54401
lx.top.use_rot_z = 0
lx.top.out_pnt_x = -0.72061801
lx.top.out_pnt_y = 0.56794697
lx.top.out_pnt_z = 3.03
lx.top.out_rot_x = 0
lx.top.out_rot_y = -570.74597
lx.top.out_rot_z = 0
lx.light_top_box = lx.top
lx.top.walkOut = function(arg1) -- line 365
    START_CUT_SCENE()
    manny:walkto(arg1, TRUE)
    manny:set_visibility(FALSE)
    sleep_for(2000)
    END_CUT_SCENE()
    manny:set_visibility(TRUE)
    lx:come_out_door(lx.li_door)
end

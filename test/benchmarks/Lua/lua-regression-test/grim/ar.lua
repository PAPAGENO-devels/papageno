CheckFirstTime("ar.lua")
ar = Set:create("ar.set", "ashtray room", { ar_mecla = 0, ar_ovrhd = 1, ar_newws = 2 })
ar.shrinkable = 0.03
dofile("meche_island.lua")
ar.squeak_vol = 90
ar.talk_hector = function(arg1) -- line 18
    START_CUT_SCENE()
    meche:say_line("/armc001/")
    wait_for_message()
    manny:say_line("/arma002/")
    wait_for_message()
    meche:say_line("/armc003/")
    wait_for_message()
    meche:say_line("/armc004/")
    wait_for_message()
    meche:say_line("/armc005/")
    wait_for_message()
    manny:say_line("/arma006/")
    wait_for_message()
    END_CUT_SCENE()
end
ar.set_up_actors = function(arg1) -- line 35
    if not ashtray then
        ashtray = Actor:create(nil, nil, nil, "ashtray")
    end
    ashtray:put_in_set(ar)
    ashtray:follow_boxes()
    ashtray:set_costume("ashtray.cos")
    ashtray:ignore_boxes()
    ashtray:set_softimage_pos(-2.1789, 0, 0.5898)
    ashtray:setrot(0, 341.46, 0)
    ashtray:play_chore(0)
    ashtray:set_turn_rate(150)
    if ar.meche_here then
        meche:set_costume("meche_island.cos")
        meche:put_in_set(ar)
        meche:ignore_boxes()
        meche:setpos(-0.34239, -0.03539, 0)
        meche:setrot(0, 202.489, 0)
        meche:set_mumble_chore(meche_island_mumble)
        meche:set_talk_chore(1, meche_island_stop_talk)
        meche:set_talk_chore(2, meche_island_a)
        meche:set_talk_chore(3, meche_island_c)
        meche:set_talk_chore(4, meche_island_e)
        meche:set_talk_chore(5, meche_island_f)
        meche:set_talk_chore(6, meche_island_l)
        meche:set_talk_chore(7, meche_island_m)
        meche:set_talk_chore(8, meche_island_o)
        meche:set_talk_chore(9, meche_island_t)
        meche:set_talk_chore(10, meche_island_u)
        meche:set_head(5, 5, 5, 165, 28, 80)
        meche:set_look_rate(200)
        ar.meche_obj:make_touchable()
    else
        ar.meche_obj:make_untouchable()
    end
end
ar.meche_idle = function() -- line 75
    local local1
    ar.meche_idle_ok = TRUE
    meche_ash_idles = { meche_island_ash_gest1, meche_island_ash_drag, meche_island_ash_flick, meche_island_ash_file }
    while 1 do
        meche_is_distracted = FALSE
        if ar.meche_idle_ok then
            local1 = pick_one_of(meche_ash_idles, TRUE)
            if local1 == meche_island_ash_flick and ashtray.twisted and not ar.stockings_tossed then
                meche.burning = TRUE
                ar.stockings_tossed = TRUE
                START_CUT_SCENE()
                ar.stockings.owner = IN_THE_ROOM
                ar.wastebasket.has_hose = TRUE
                ar.ashtray_primed = TRUE
                meche:stop_chore(meche.last_chore)
                meche:play_chore(meche_island_ash_stckng)
                sleep_for(1000)
                manny:head_look_at(meche)
                meche:say_line("/armc040/")
                meche:wait_for_message()
                meche:wait_for_chore(meche_island_ash_stckng)
                meche:say_line("/armc041/")
                meche:wait_for_message()
                start_script(cut_scene.leg, cut_scene)
                ashtray:play_chore(0)
                wait_for_script(cut_scene.leg)
                ar:current_setup(ar_mecla)
                meche:say_line("/armc042/")
                meche:stop_chore(meche_island_ash_stocking)
                meche:play_chore(meche_island_toss_stckng)
                meche:wait_for_chore()
                meche:play_chore(meche_island_2talk)
                meche:wait_for_message()
                meche:say_line("/armc043/")
                meche:wait_for_message()
                meche:play_chore(meche_island_talk2base)
                meche:wait_for_chore()
                meche.burning = FALSE
                END_CUT_SCENE()
            elseif local1 == meche_island_ash_flick and ashtray.twisted then
                local1 = meche_island_ash_drag
            end
            meche:stop_chore(meche.last_chore)
            meche:play_chore(local1)
            meche.last_chore = local1
            meche:wait_for_chore()
        else
            break_here()
        end
    end
end
ar.greet_manny = function() -- line 130
    ar.greeted = TRUE
    soft_script()
    START_CUT_SCENE()
    meche:play_chore(meche_island_ash_flick)
    start_script(manny.head_follow_mesh, manny, meche, 7)
    manny:walkto(-0.109792, -0.184354, 0.01, 0, 63.2991, 0)
    meche:wait_for_chore()
    meche:play_chore(meche_island_2talk)
    meche:wait_for_chore()
    meche:play_chore(meche_island_talk_gest)
    meche:push_chore()
    meche:push_chore(meche_island_gest2talk)
    meche:push_chore()
    ar:current_setup(ar_mecla)
    meche:say_line("/armc007/")
    meche:wait_for_message()
    meche:push_chore(meche_island_talk2base)
    meche:say_line("/armc008/")
    meche:wait_for_message()
    meche:wait_for_chore(meche_island_talk2base)
    ar:current_setup(ar_newws)
    start_script(ar.meche_idle)
    stop_script(manny.head_follow_mesh)
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
ar.ashtray_fun = function(arg1) -- line 160
    local local1 = { "cigExM1.wav", "cigExM2.wav", "cigExM3.wav", "cigExM4.wav" }
    START_CUT_SCENE("no head")
    ar:current_setup(ar_mecla)
    manny:walkto(-0.12602399, -0.16829699, 0, 0, 63.278801, 0)
    manny:wait_for_actor()
    sleep_for(100)
    manny:play_chore(manny_idles_smoke1, "mn_wait_idles.cos")
    sleep_for(2814)
    start_sfx(pick_one_of(local1))
    manny:play_chore_looping(mn2_u, manny.base_costume)
    manny:wait_for_chore(manny_idles_smoke1)
    manny:stop_chore(mn2_u, manny.base_costume)
    manny:play_chore(mn2_stop_talk, manny.base_costume)
    manny:stop_chore(manny_idles_smoke1, "mn_wait_idles.cos")
    manny:play_chore(mn2_use_ashtray, "mn2.cos")
    sleep_for(469)
    ashtray.twisted = TRUE
    ashtray:play_chore(3)
    manny:wait_for_chore()
    sleep_for(500)
    ashtray.twisted = FALSE
    if meche.burning then
    elseif ar.meche_here then
        ar.meche_idle_ok = FALSE
        meche:wait_for_chore()
        meche:stop_chore(meche.last_chore)
        meche:play_chore(meche_island_ash_gest2)
        sleep_for(1800)
        ashtray:play_chore(1)
        meche:wait_for_chore()
        ar.meche_idle_ok = TRUE
        ar:current_setup(ar_newws)
    else
        manny:play_chore(mn2_reach_med, "mn2.cos")
        sleep_for(600)
        ashtray:play_chore(1)
        manny:wait_for_chore()
        manny:stop_chore(mn2_reach_med, "mn2.cos")
        ar:current_setup(ar_newws)
    end
    END_CUT_SCENE()
end
ar.update_music_state = function(arg1) -- line 215
    if meche.locked_up then
        return stateAR_PENSV
    elseif ar.meche_here then
        return stateAR
    else
        return stateAR_SCARY
    end
end
ar.enter = function(arg1) -- line 228
    if dr.reunited and not meche.locked_up then
        ar.meche_here = TRUE
    else
        ar.meche_here = FALSE
    end
    ar:set_up_actors()
    if ar.meche_here and not ar.greeted then
        start_script(ar.greet_manny)
    elseif ar.meche_here then
        start_script(ar.meche_idle)
    end
end
ar.exit = function(arg1) -- line 242
    ashtray:free()
    meche:free()
    stop_script(ar.meche_idle)
end
ar.stockings = Object:create(ar, "/artx009/pair of stockings", 0, 0, 0, { range = 0 })
ar.stockings.string_name = "stockings"
ar.stockings.owner = meche
ar.stockings.wav = "getRag.wav"
ar.stockings.lookAt = function(arg1) -- line 257
    manny:say_line("/arma010/")
end
ar.stockings.use = function(arg1) -- line 261
    soft_script()
    manny:say_line("/arma011/")
    wait_for_message()
    manny:say_line("/arma012/")
end
ar.stockings.default_response = function(arg1) -- line 268
    manny:say_line("/arma013/")
end
ar.books = Object:create(ar, "/artx014/books", 0.162431, 0.78079301, 0.43000001, { range = 0.69999999 })
ar.books.use_pnt_x = 0.0199003
ar.books.use_pnt_y = 0.40424699
ar.books.use_pnt_z = 0.0099999998
ar.books.use_rot_x = 0
ar.books.use_rot_y = 3.07318
ar.books.use_rot_z = 0
ar.books.lookAt = function(arg1) -- line 280
    manny:say_line("/arma015/")
    if ar.meche_here then
        START_CUT_SCENE()
        wait_for_message()
        meche:say_line("/armc016/")
        wait_for_message()
        meche:say_line("/armc017/")
        END_CUT_SCENE()
    end
end
ar.books.use = function(arg1) -- line 292
    if manny:walkto(arg1) then
        START_CUT_SCENE()
        manny:setrot(0, 3.05237, 0, TRUE)
        manny:wait_for_actor()
        manny:run_chore(mn2_reach_med, "mn2.cos")
        END_CUT_SCENE()
        system.default_response("locked")
        if fo.been_there then
            if system.locale == "EN_USA" then
                soft_script()
                wait_for_message()
                manny:say_line("/arma018/")
            end
        end
    end
end
ar.books.pickUp = ar.books.use
ar.meche_obj = Object:create(ar, "/artx019/Meche", -0.32756901, 0.110792, 0.31999999, { range = 0.60000002 })
ar.meche_obj.use_pnt_x = 0.0020753001
ar.meche_obj.use_pnt_y = 0.0132555
ar.meche_obj.use_pnt_z = 0
ar.meche_obj.use_rot_x = 0
ar.meche_obj.use_rot_y = -273.65701
ar.meche_obj.use_rot_z = 0
ar.meche_obj:make_untouchable()
ar.meche_obj.lookAt = function(arg1) -- line 323
    START_CUT_SCENE()
    manny:say_line("/arma020/")
    wait_for_message()
    meche:say_line("/armc021/")
    if not arg1.seen then
        arg1.seen = TRUE
        meche:wait_for_message()
        meche:say_line("/armc022/")
        meche:wait_for_message()
        meche:say_line("/armc023/")
        meche:wait_for_message()
        enable_head_control(FALSE)
        manny:head_look_at(nil)
        sleep_for(50)
        manny:say_line("/arma024/")
        manny:wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/arma025/")
    end
    END_CUT_SCENE()
end
ar.meche_obj.pickUp = function(arg1) -- line 346
    manny:say_line("/arma026/")
end
ar.meche_obj.use = function(arg1) -- line 350
    if mn.gun.owner == manny then
        arg1:use_gun()
    else
        Dialog:run("me2", "dlg_meche2.lua")
    end
end
ar.meche_obj.use_stockings = function(arg1) -- line 358
    soft_script()
    manny:say_line("/arma027/")
    wait_for_message()
    manny:say_line("/arma028/")
end
ar.meche_obj.use_hammer = function(arg1) -- line 365
    soft_script()
    if ar.talked_gun then
        manny:say_line("/arma029/")
        wait_for_message()
        manny:say_line("/arma030/")
    else
        manny:say_line("/arma031/")
        wait_for_message()
        manny:say_line("/arma032/")
    end
end
ar.meche_obj.use_chisel = function(arg1) -- line 378
    manny:say_line("/arma033/")
end
ar.meche_obj.use_gun = function(arg1) -- line 382
    START_CUT_SCENE()
    manny:walkto(-0.187047, -0.210992, 0, 0, 29.5186, 0)
    END_CUT_SCENE()
    start_script(cut_scene.hostage)
end
ar.meche_obj.use_scythe = function(arg1) -- line 389
    manny:say_line("/arma034/")
end
ar.ashtray = Object:create(ar, "/artx035/ash tray", -0.26756901, -0.109208, 0.15000001, { range = 0.60000002 })
ar.ashtray.use_pnt_x = -0.14907999
ar.ashtray.use_pnt_y = -0.22343799
ar.ashtray.use_pnt_z = 0.0099999998
ar.ashtray.use_rot_x = 0
ar.ashtray.use_rot_y = 336.112
ar.ashtray.use_rot_z = 0
ar.ashtray.lookAt = function(arg1) -- line 402
    soft_script()
    manny:say_line("/arma036/")
    if ar.meche_here then
        START_CUT_SCENE()
        wait_for_message()
        meche:say_line("/armc037/")
        END_CUT_SCENE()
    end
end
ar.ashtray.pickUp = function(arg1) -- line 413
    soft_script()
    manny:say_line("/arma038/")
end
ar.ashtray.use = function(arg1) -- line 418
    ar.ashtray_fun()
end
ar.wastebasket = Object:create(ar, "/artx044/wastebasket", 0.49836099, -0.109784, 0.1, { range = 0.60000002 })
ar.wastebasket.use_pnt_x = 0.170965
ar.wastebasket.use_pnt_y = -0.110754
ar.wastebasket.use_pnt_z = 0.0099999998
ar.wastebasket.use_rot_x = 0
ar.wastebasket.use_rot_y = -137.258
ar.wastebasket.use_rot_z = 0
ar.wastebasket.lookAt = function(arg1) -- line 432
    if arg1.has_hose then
        arg1.has_hose = FALSE
        ar.stockings:get()
        cur_puzzle_state[37] = TRUE
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        ar:current_setup(ar_newws)
        manny:wait_for_actor()
        manny:play_chore(mn2_reach_low, "mn2.cos")
        sleep_for(800)
        manny:play_chore_looping(mn2_activate_stockings, "mn2.cos")
        manny.is_holding = ar.stockings
        manny.hold_chore = mn2_activate_stockings
        manny:fade_in_chore(mn2_hold, "mn2.cos")
        manny:wait_for_chore(mn2_reach_low, "mn2.cos")
        manny:stop_chore(mn2_reach_low, "mn2.cos")
        manny:say_line("/arma045/")
        if ar.meche_here then
            wait_for_message()
            meche:say_line("/armc046/")
            wait_for_message()
            manny:say_line("/arma047/")
            put_away_held_item()
            wait_for_message()
            ar:current_setup(ar_mecla)
            manny:setrot(0, 81.1508, 0, TRUE)
            manny:say_line("/arma048/")
            wait_for_message()
            meche:say_line("/armc049/")
            wait_for_message()
            manny:say_line("/arma050/")
            ar:current_setup(ar_newws)
        end
        END_CUT_SCENE()
    else
        soft_script()
        system.default_response("empty")
        if ar.meche_here then
            wait_for_message()
            meche:say_line("/armc051/")
        end
    end
end
ar.wastebasket.pickUp = ar.wastebasket.lookAt
ar.wastebasket.use = ar.wastebasket.lookAt
ar.vd_door = Object:create(ar, "/artx138/door", -0.85174799, -1.1703, 0.0099999998, { range = 0 })
ar.vd_door.use_pnt_x = -0.535748
ar.vd_door.use_pnt_y = -0.55030102
ar.vd_door.use_pnt_z = 0.0099999998
ar.vd_door.use_rot_x = 0
ar.vd_door.use_rot_y = 154.71899
ar.vd_door.use_rot_z = 0
ar.vd_door.out_pnt_x = -0.74861699
ar.vd_door.out_pnt_y = -1.00138
ar.vd_door.out_pnt_z = 0.0099999998
ar.vd_door.out_rot_x = 0
ar.vd_door.out_rot_y = 154.71899
ar.vd_door.out_rot_z = 0
ar.vd_box = ar.vd_door
ar.vd_door.walkOut = function(arg1) -- line 503
    vd:come_out_door(vd.ar_door)
end
ar.dr_door = Object:create(ar, "/artx054/door", 0.56942999, 0.181225, 0.43000001, { range = 0.60000002 })
ar.dr_door.use_pnt_x = 0.329431
ar.dr_door.use_pnt_y = 0.181225
ar.dr_door.use_pnt_z = 0
ar.dr_door.use_rot_x = 0
ar.dr_door.use_rot_y = -74.444504
ar.dr_door.use_rot_z = 0
ar.dr_door.out_pnt_x = 0.52498901
ar.dr_door.out_pnt_y = 0.224981
ar.dr_door.out_pnt_z = 0
ar.dr_door.out_rot_x = 0
ar.dr_door.out_rot_y = -77.236099
ar.dr_door.out_rot_z = 0
ar.dr_box = ar.dr_door
ar.dr_door.lookAt = function(arg1) -- line 525
    if dr.reunited then
        manny:say_line("/arma055/")
    else
        manny:say_line("/arma056/")
    end
end
ar.dr_door.walkOut = function(arg1) -- line 533
    if dr.reunited then
        if not ar.talked_hector and ar.meche_obj.touchable then
            ar:talk_hector()
        end
        dr:come_out_door(dr.ar_door)
    else
        start_script(cut_scene.reunion)
    end
end

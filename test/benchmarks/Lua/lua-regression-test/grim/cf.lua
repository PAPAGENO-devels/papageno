CheckFirstTime("cf.lua")
dofile("cf_panel.lua")
cf = Set:create("cf.set", "cafe office", { cf_dorws = 0, cf_ofcha = 1, cf_ofcha1 = 1, cf_ovrhd = 2, cf_pnlcu = 3 })
cf.shrinkable = 0.012
cf.intercom_on = nil
cf.piss_off_bogen = function(arg1) -- line 18
    bogen.pissed = TRUE
    START_CUT_SCENE()
    bogen:say_line("/cfbo001/")
    wait_for_message()
    bogen:say_line("/cfbo002/")
    wait_for_message()
    croupier:say_line("/cfcr003/")
    wait_for_message()
    croupier:say_line("/cfcr004/")
    wait_for_message()
    bogen:say_line("/cfbo059/")
    wait_for_message()
    bogen:say_line("/cfbo007/")
    wait_for_message()
    croupier:say_line("/cfcr008/")
    wait_for_message()
    croupier:say_line("/cfcr009/")
    croupier:wait_for_message()
    bogen_table:demagnetize()
    pissing_off_bogen = FALSE
    END_CUT_SCENE()
end
cf.panel_closeup = function(arg1) -- line 44
    START_CUT_SCENE()
    manny:walkto_object(cf.panel)
    manny:wait_for_actor()
    manny:play_chore(mc_hand_on_obj, manny.base_costume)
    sleep_for(250)
    cf.panel:play_chore(1)
    cf.panel:wait_for_chore()
    cf:current_setup(cf_pnlcu)
    inventory_disabled = TRUE
    if not mannys_hands then
        mannys_hands = Actor:create(nil, nil, nil, "/sytx188/")
    end
    mannys_hands:set_costume("tp_interface.cos")
    mannys_hands:put_in_set(cf)
    mannys_hands:moveto(0.214657, -0.907566, -0.156501)
    mannys_hands:setrot(0, 0, 0)
    if not cf.panel.seen then
        cf.panel.seen = TRUE
        manny:say_line("/cfma010/")
        wait_for_message()
    end
    inventory_save_handler = system.buttonHandler
    system.buttonHandler = roulettePanelButtonHandler
    manny.idles_allowed = FALSE
    start_script(cf.panel_display)
    END_CUT_SCENE()
    ImSetVoiceEffect("Intercom Filter")
    cf.intercom_on = TRUE
    music_state:update(system.currentSet)
end
roulettePanelButtonHandler = function(arg1, arg2, arg3) -- line 80
    shiftKeyDown = GetControlState(LSHIFTKEY) or GetControlState(RSHIFTKEY)
    altKeyDown = GetControlState(LALTKEY) or GetControlState(RALTKEY)
    controlKeyDown = GetControlState(LCONTROLKEY) or GetControlState(RCONTROLKEY)
    if arg1 == EKEY and controlKeyDown and arg2 and developerMode then
        single_start_script(execute_user_command)
        bHandled = TRUE
    elseif control_map.OVERRIDE[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(cf.close_panel)
    elseif control_map.LOOK_AT[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(cf.panel.lookAt, cf.panel)
    elseif control_map.USE[arg1] and arg2 and cutSceneLevel <= 0 then
        single_start_script(cf.toggle_magnet)
    else
        CommonButtonHandler(arg1, arg2, arg3)
    end
end
cf.close_panel = function() -- line 100
    inventory_disabled = FALSE
    system.buttonHandler = inventory_save_handler
    mannys_hands:free()
    stop_sound("cfHum.IMU")
    ImSetVoiceEffect("OFF")
    cf:current_setup(cf_ofcha)
    START_CUT_SCENE()
    cf.panel:play_chore(0)
    manny:play_chore(mc_hand_off_obj, manny.base_costume)
    manny:wait_for_chore()
    END_CUT_SCENE()
    manny.idles_allowed = TRUE
    cf.intercom_on = nil
    music_state:update(system.currentSet)
end
cf.ha_ha_ha = function() -- line 118
    ImSetVoiceEffect("OFF")
    manny:say_line("/moma089/")
    manny:wait_for_message()
    ImSetVoiceEffect("Intercom Filter")
    bogen_table.rate = 0
end
cf.toggle_magnet = function() -- line 126
    START_CUT_SCENE()
    mannys_hands:play_chore(1)
    start_sfx("cfBtn.wav")
    mannys_hands:wait_for_chore()
    END_CUT_SCENE()
    if current_roulette_table.rate > 0 then
        if current_roulette_table.magnet ~= nil then
            current_roulette_table:demagnetize()
            if current_roulette_table == bogen_table and cn.bogens_in_the_house_again then
                stop_script(cn.roulette_game_simulator)
                rtable1:free()
                rtable2:free()
                rtable3:free()
                inventory_disabled = FALSE
                system.buttonHandler = inventory_save_handler
                mannys_hands:free()
                manny.idles_allowed = TRUE
                start_script(cut_scene.byeruba, cut_scene)
            elseif current_roulette_table == bogen_table and not bogen.pissed and bogen_in_cn then
                bogen_table:magnetize(9)
                START_CUT_SCENE()
                start_script(cf.ha_ha_ha)
                pissing_off_bogen = TRUE
                while not bogen.pissed do
                    break_here()
                end
                END_CUT_SCENE()
            end
        else
            current_roulette_table:magnetize(current_roulette_table.current_value)
        end
    else
        start_sfx("intrbuzz.wav")
    end
end
OFF_CHORE_OFFSET = 44
cf.panel_display = function() -- line 173
    local local1, local2
    local1 = current_roulette_table.current_value
    local2 = local1
    while cf:current_setup() == cf_pnlcu do
        if current_roulette_table.magnet and not pissing_off_bogen then
            single_start_sfx("cfHum.IMU")
            cf.panelcu:play_chore(cf_panel_magnet)
            cf.panelcu:play_chore(current_roulette_table.magnet)
        else
            cf.panelcu:play_chore(cf_panel_magnet_gone)
            stop_sound("cfHum.IMU")
        end
        if current_roulette_table == rtable1 then
            cf.panelcu:play_chore(cf_panel_table1)
        elseif current_roulette_table == rtable2 then
            cf.panelcu:play_chore(cf_panel_table2)
        else
            cf.panelcu:play_chore(cf_panel_table3)
        end
        local1 = current_roulette_table.current_value
        if local2 ~= local1 then
            if current_roulette_table.magnet ~= local2 then
                cf.panelcu:play_chore(local2 + OFF_CHORE_OFFSET)
            end
            start_sfx("cfRelay.wav")
            local2 = local1
        end
        cf.panelcu:play_chore(local1)
        break_here()
    end
end
system.rouletteTemplate = { name = "<unnamed>", current_value = nil, magnet = nil, actor = { }, sHandle = nil, doHandle = nil, rate = 0 }
Roulette = system.rouletteTemplate
Roulette.create = function(arg1, arg2) -- line 226
    local local1 = { }
    local1.parent = Roulette
    local1.name = arg2
    local1.current_value = 0
    local1.magnet = nil
    local1.sHandle = nil
    local1.doHandle = nil
    local1.rate = 0
    local1.actor = Actor:create(nil, nil, nil, "roulette table " .. arg2)
    return local1
end
Roulette.init_actor = function(arg1) -- line 241
    arg1.actor:set_costume("rwheel.cos")
    arg1.actor:put_in_set(system.currentSet)
    SetActorScale(arg1.actor.hActor, 1.1)
end
Roulette.spin = function(arg1) -- line 248
    arg1.doHandle = start_script(arg1.spin_up, arg1)
    arg1.sHandle = start_script(arg1.run, arg1)
end
Roulette.run = function(arg1) -- line 253
    local local1 = 0
    while cf.roulette_wheel[local1] ~= arg1.current_value do
        local1 = local1 + 1
    end
    while 1 do
        local1 = local1 + 1
        if local1 == 37 then
            local1 = 0
        end
        arg1.current_value = cf.roulette_wheel[local1]
        sleep_for(500 - arg1.rate * 5)
    end
end
Roulette.spin_up = function(arg1) -- line 269
    local local1 = { }
    arg1.rate = 0
    repeat
        if GetActorCostume(arg1.actor.hActor) then
            local1 = arg1.actor:get_positive_rot()
        end
        arg1.rate = arg1.rate + PerSecond(35)
        if arg1.rate > 65 then
            arg1.rate = 65
        end
        if GetActorCostume(arg1.actor.hActor) then
            arg1.actor:setrot(0, local1.y - arg1.rate, 0)
            local1 = arg1.actor:get_positive_rot()
        end
        break_here()
    until arg1.rate == 65
    repeat
        if system.currentSet == cn then
            arg1.rate = arg1.rate - PerSecond(1)
        elseif current_roulette_table == arg1 then
            arg1.rate = arg1.rate - PerSecond(5)
        end
        if arg1.rate < 0 then
            arg1.rate = 0
        end
        if GetActorCostume(arg1.actor.hActor) then
            local1 = arg1.actor:get_positive_rot()
            arg1.actor:setrot(0, local1.y - arg1.rate, 0)
            local1 = arg1.actor:get_positive_rot()
        end
        break_here()
    until arg1.rate == 0
    stop_sound("cnRoulet.imu")
    if system.currentSet == cn and cn:current_setup() ~= cn_cchms then
        start_sfx("cnRouStp.wav")
    end
    stop_script(arg1.sHandle)
end
Roulette.magnetize = function(arg1, arg2) -- line 311
    if arg2 then
        arg1.magnet = arg2
    else
        arg1.magnet = arg1.current_value
    end
end
Roulette.demagnetize = function(arg1) -- line 320
    cf.panelcu:play_chore(arg1.magnet + OFF_CHORE_OFFSET)
    arg1.magnet = nil
end
Roulette.stop = function(arg1) -- line 326
    if arg1.doHandle then
        while find_script(arg1.doHandle) do
            break_here()
        end
    end
    if arg1.magnet then
        arg1.current_value = arg1.magnet
    end
end
Roulette.free = function(arg1) -- line 338
    arg1.actor:free()
    stop_script(arg1.spin_up)
    stop_script(arg1.run)
    stop_script(arg1.stop)
end
cf.roulette_wheel = { }
cf.roulette_wheel[0] = 0
cf.roulette_wheel[1] = 26
cf.roulette_wheel[2] = 3
cf.roulette_wheel[3] = 35
cf.roulette_wheel[4] = 12
cf.roulette_wheel[5] = 28
cf.roulette_wheel[6] = 7
cf.roulette_wheel[7] = 29
cf.roulette_wheel[8] = 18
cf.roulette_wheel[9] = 34
cf.roulette_wheel[10] = 9
cf.roulette_wheel[11] = 31
cf.roulette_wheel[12] = 14
cf.roulette_wheel[13] = 20
cf.roulette_wheel[14] = 1
cf.roulette_wheel[15] = 33
cf.roulette_wheel[16] = 16
cf.roulette_wheel[17] = 24
cf.roulette_wheel[18] = 5
cf.roulette_wheel[19] = 10
cf.roulette_wheel[20] = 23
cf.roulette_wheel[21] = 8
cf.roulette_wheel[22] = 30
cf.roulette_wheel[23] = 11
cf.roulette_wheel[24] = 36
cf.roulette_wheel[25] = 13
cf.roulette_wheel[26] = 27
cf.roulette_wheel[27] = 6
cf.roulette_wheel[28] = 17
cf.roulette_wheel[29] = 25
cf.roulette_wheel[30] = 2
cf.roulette_wheel[31] = 21
cf.roulette_wheel[32] = 4
cf.roulette_wheel[33] = 19
cf.roulette_wheel[34] = 15
cf.roulette_wheel[35] = 32
cf.roulette_wheel[36] = 22
cf.update_music_state = function(arg1) -- line 391
    if cf.intercom_on then
        return stateCF_INTRCM
    else
        return stateCF
    end
end
cf.enter = function(arg1) -- line 400
    if not salnotes_actor then
        salnotes_actor = Actor:create(nil, nil, nil, "salnotes")
    end
    if cf.letters.owner ~= manny then
        salnotes_actor:put_in_set(cf)
        salnotes_actor:set_costume("salnotes.cos")
        salnotes_actor:setpos(-0.266018, 0.385542, 0.2946)
        salnotes_actor:setrot(90, 80, 0)
        salnotes_actor:scale(1.3)
        salnotes_actor:play_chore_looping(0)
    end
    if made_vacancy and hh.union_card.owner == manny and dd.strike_on then
        cn.bogens_in_the_house_again = TRUE
    end
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_0.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_1.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_2.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_3.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_4.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_5.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_6.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_7.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_8.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_9.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_10.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_11.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_12.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_13.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_14.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_15.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_16.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_17.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_18.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_19.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_20.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_21.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_22.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_23.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_24.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_25.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_26.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_27.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_28.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_29.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_30.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_31.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_32.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_33.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_34.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_35.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_36.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_left_red_light.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_top_red_dot.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_right_red_light.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_horse_shoe.bm")
    NewObjectState(cf_pnlcu, OBJSTATE_UNDERLAY, "cf_2_blue.bm")
    cf.panelcu:set_object_state("cf_panel.cos")
    NewObjectState(cf_ofcha, OBJSTATE_UNDERLAY, "cf_panelflip.bm")
    cf.panel:set_object_state("cf_flip_panel.cos")
    cf.panel:play_chore(2)
    if not find_script(cn.roulette_game_simulator) then
        bogen_in_cn = TRUE
        start_script(cn.roulette_game_simulator)
    end
end
cf.exit = function(arg1) -- line 475
    salnotes_actor:free()
    cf.intercom_on = nil
end
cf.panel = Object:create(cf, "panel", 0.025, -0.82999998, 0.28999999, { range = 0.60000002 })
cf.panel.use_pnt_x = 0.175
cf.panel.use_pnt_y = -1
cf.panel.use_pnt_z = 0
cf.panel.use_rot_x = 0
cf.panel.use_rot_y = 744.39801
cf.panel.use_rot_z = 0
cf.facing_up = FALSE
cf.panel.lookAt = function(arg1) -- line 495
    if not arg1.used then
        arg1:use()
    else
        manny:say_line("/cfma011/I've always meant to hide that better.")
    end
end
cf.panel.use = function(arg1) -- line 503
    arg1.used = TRUE
    cf:panel_closeup()
end
cf.panel.pickUp = cf.panel.use
cf.panelcu = Object:create(cf, "panel", 0, 0, 0, { range = 0 })
cf.panelcu.current_wheel = 1
cf.drawer = Object:create(cf, "drawer", 0.255, -0.92000002, 0.20999999, { range = 0 })
cf.drawer.use_pnt_x = 0.25599501
cf.drawer.use_pnt_y = -1.0324
cf.drawer.use_pnt_z = 0
cf.drawer.use_rot_x = 0
cf.drawer.use_rot_y = 1082.4399
cf.drawer.use_rot_z = 0
cf.drawer.lookAt = function(arg1) -- line 523
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if arg1:is_open() then
        system.default_response("empty")
    else
        manny:say_line("/cfma012/")
    end
end
cf.drawer.open = function(arg1) -- line 534
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if cf.letters.owner ~= manny then
        cf.letters:get()
        START_CUT_SCENE()
        wait_for_message()
        manny:say_line("/cfma013/")
        END_CUT_SCENE()
    end
    arg1.opened = TRUE
end
cf.drawer.close = function(arg1) -- line 548
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    arg1.opened = FALSE
end
cf.drawer.use = function(arg1) -- line 556
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
cf.drawer.pickUp = cf.drawer.use
cf.lounge = Object:create(cf, "lounge", -0.97826803, 0.144564, 0.1, { range = 0.60000002 })
cf.lounge.use_pnt_x = -0.61484802
cf.lounge.use_pnt_y = 0.0770026
cf.lounge.use_pnt_z = 0
cf.lounge.use_rot_x = 0
cf.lounge.use_rot_y = 1216.03
cf.lounge.use_rot_z = 0
cf.lounge.lookAt = function(arg1) -- line 579
    manny:say_line("/cfma014/")
    wait_for_message()
    manny:say_line("/cfma015/")
end
cf.lounge.pickUp = function(arg1) -- line 585
    manny:say_line("/cfma016/")
end
cf.lounge.use = function(arg1) -- line 589
    if not meche.shanghaid then
        manny:say_line("/cfma017/")
    else
        manny:say_line("/cfma060/")
    end
end
cf.letters = Object:create(cf, "/cftx018/letters", -0.287902, 0.45734, 0.2888, { range = 0.75 })
cf.letters.use_pnt_x = -0.19300801
cf.letters.use_pnt_y = 0.199907
cf.letters.use_pnt_z = 0
cf.letters.use_rot_x = 0
cf.letters.use_rot_y = 21.306601
cf.letters.use_rot_z = 0
cf.letters.wav = "ciGetLtr.wav"
cf.letters.read_count = nil
cf.letters.pickUp = function(arg1) -- line 610
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:play_chore(mc_reach_med, "mc.cos")
    sleep_for(500)
    manny:generic_pickup(cf.letters)
    salnotes_actor:free()
    start_sfx("ciGetLtr.wav", nil, 60)
    wait_for_sound("ciGetLtr.wav")
    manny:wait_for_chore()
    END_CUT_SCENE()
end
cf.letters.lookAt = function(arg1) -- line 629
    if cf.letters.owner ~= manny then
        arg1:pickUp()
    end
    START_CUT_SCENE()
    if not arg1.read_count then
        arg1.read_count = 0
        manny:say_line("/cfma019/")
        wait_for_message()
        manny:say_line("/cfma020/")
        wait_for_message()
    end
    arg1.read_count = arg1.read_count + 1
    if arg1.read_count == 1 then
        salvador:say_line("/cfsa021/")
        wait_for_message()
        salvador:say_line("/cfsa022/")
        wait_for_message()
        salvador:say_line("/cfsa023/")
        wait_for_message()
        salvador:say_line("/cfsa024/")
        wait_for_message()
        salvador:say_line("/cfsa025/")
        wait_for_message()
        salvador:say_line("/cfsa026/")
        wait_for_message()
        salvador:say_line("/cfsa027/")
        wait_for_message()
        if not cf.said_later then
            cf.said_later = TRUE
            manny:say_line("/rema066/")
            manny:wait_for_message()
            if not inInventorySet() then
                manny:say_line("/hama102/")
                manny:wait_for_message()
                manny:say_line("/moma032/")
                wait_for_message()
                manny:clear_hands()
            end
        end
    elseif arg1.read_count == 2 then
        salvador:say_line("/cfsa028/")
        wait_for_message()
        salvador:say_line("/cfsa029/")
        wait_for_message()
        salvador:say_line("/cfsa030/")
    elseif arg1.read_count == 3 then
        salvador:say_line("/cfsa031/")
        wait_for_message()
        salvador:say_line("/cfsa032/")
        wait_for_message()
        salvador:say_line("/cfsa033/")
        wait_for_message()
        manny:say_line("/cfma034/")
    elseif arg1.read_count == 3 then
        eva:say_line("/cfev035/")
        wait_for_message()
        eva:say_line("/cfev036/")
        wait_for_message()
        eva:say_line("/cfev037/")
    elseif arg1.read_count == 4 then
        salvador:say_line("/cfsa038/")
        wait_for_message()
        salvador:say_line("/cfsa039/")
        wait_for_message()
        salvador:say_line("/cfsa040/")
        wait_for_message()
        salvador:say_line("/cfsa041/")
        wait_for_message()
        salvador:say_line("/cfsa042/")
    elseif arg1.read_count == 5 then
        salvador:say_line("/cfsa043/")
        wait_for_message()
        salvador:say_line("/cfsa044/")
        wait_for_message()
        salvador:say_line("/cfsa045/")
        wait_for_message()
        salvador:say_line("/cfsa046/")
        wait_for_message()
        salvador:say_line("/cfsa047/")
        wait_for_message()
        salvador:say_line("/cfsa048/")
    elseif arg1.read_count == 6 then
        salvador:say_line("/cfsa061/")
        wait_for_message()
        salvador:say_line("/cfsa062/")
        wait_for_message()
        salvador:say_line("/cfsa063/")
        wait_for_message()
        salvador:say_line("/cfsa064/")
    elseif arg1.read_count == 7 then
        salvador:say_line("/cfsa049/")
        wait_for_message()
        salvador:say_line("/cfsa050/")
        wait_for_message()
        salvador:say_line("/cfsa051/")
    elseif arg1.read_count == 8 then
        arg1.read_count = 0
        manny:say_line("/cfma052/")
        wait_for_message()
        salvador:say_line("/cfsa053/")
        wait_for_message()
        salvador:say_line("/cfsa054/")
        wait_for_message()
        salvador:say_line("/cfsa055/")
        wait_for_message()
        salvador:say_line("/cfsa056/")
        wait_for_message()
        salvador:say_line("/cfsa057/")
        wait_for_message()
        manny:say_line("/cfma058/")
    end
    END_CUT_SCENE()
end
cf.letters.use = cf.letters.lookAt
cf.letters.default_response = cf.letters.lookAt
cf.cb_door = Object:create(cf, "door", 1.53111, -0.081692301, 0.51999998, { range = 0 })
cf.cb_door.use_pnt_x = 1.28111
cf.cb_door.use_pnt_y = -0.081692301
cf.cb_door.use_pnt_z = -6.8087701e-13
cf.cb_door.use_rot_x = 0
cf.cb_door.use_rot_y = -96.6632
cf.cb_door.use_rot_z = 0
cf.cb_door.out_pnt_x = 1.48778
cf.cb_door.out_pnt_y = -0.105835
cf.cb_door.out_pnt_z = -5.39199e-13
cf.cb_door.out_rot_x = 0
cf.cb_door.out_rot_y = -96.6632
cf.cb_door.out_rot_z = 0
cf.cb_box = cf.cb_door
cf.cb_door.walkOut = function(arg1) -- line 771
    cb:come_out_door(cb.cf_door)
end
cf.cc_door = Object:create(cf, "door", -0.074944697, 1.01977, 0.36899999, { range = 0 })
cf.cc_door.use_pnt_x = 0.245884
cf.cc_door.use_pnt_y = 0.946859
cf.cc_door.use_pnt_z = -0.090000004
cf.cc_door.use_rot_x = 0
cf.cc_door.use_rot_y = 444.008
cf.cc_door.use_rot_z = 0
cf.cc_door.out_pnt_x = 6.1790301e-10
cf.cc_door.out_pnt_y = 0.97502398
cf.cc_door.out_pnt_z = -0.090000004
cf.cc_door.out_rot_x = 0
cf.cc_door.out_rot_y = 437.17401
cf.cc_door.out_rot_z = 0
cf.cc_box = cf.cc_door
cf.cc_door.walkOut = function(arg1) -- line 792
    cc:come_out_door(cc.cf_door)
    if not cc.seen_ci then
        cc.seen_ci = TRUE
        START_CUT_SCENE()
        manny:runto(-0.638187, 0.700022, 0, 0, 93.6948, 0)
        manny:wait_for_actor()
        sleep_for(1000)
        manny:turn_left(180)
        manny:wait_for_actor()
        manny:twist_head_gesture()
        sleep_for(1000)
        start_script(manny.walkto, manny, cc.ci_door, TRUE)
        while not manny:find_sector_type(HOT) do
            break_here()
        end
        END_CUT_SCENE()
        ci:come_out_door(ci.cc_door)
    else
        START_CUT_SCENE()
        manny:runto(-0.948998, 1.16225, 0.245777)
        manny:wait_for_actor()
        END_CUT_SCENE()
    end
end

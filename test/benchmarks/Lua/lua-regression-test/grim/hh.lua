CheckFirstTime("hh.lua")
hh = Set:create("hh.set", "high roller hall", { hh_estla = 0, hh_ovrhd = 1, hh_gtc2 = 2, hh_gtc3 = 3, hh_gtc4 = 4, hh_gtc5 = 5 })
hh.shrinkable = 0.05
hh.roll_test = function() -- line 14
    local local1
    break_here()
    break_here()
    break_here()
    while 1 do
        local1 = manny:getpos()
        print_temporary("I'm on!:" .. tostring(local1.x))
        SetCameraRoll(200 * local1.x)
        break_here()
    end
end
cc_getcard_alright = 0
cc_getcard_case = 1
cc_getcard_muscle = 2
cc_getcard_goons = 3
cc_getcard_give_card = 4
hh.set_up_actors = function(arg1) -- line 42
    if not hh.showed_pass and not hl.glottis_gambling then
        raoul:default()
        raoul:put_in_set(hh)
        raoul:ignore_boxes()
        raoul:setpos(0.0375492, 1.04758, 0)
        raoul:setrot(0, -183.424, 0)
    end
end
hh.enter = function(arg1) -- line 52
    NewObjectState(hh_estla, OBJSTATE_STATE, "hh_elev.bm", "hh_elev.zbm")
    hh.hl_door:set_object_state("hh_elev.cos")
    hh:set_up_actors()
end
hh.exit = function(arg1) -- line 62
    raoul:free()
end
hh.union_card = Object:create(hh, "/hhtx001/union card", 0, 0, 0, { range = 0 })
hh.union_card.string_name = "union_card"
hh.union_card.wav = "getCard.wav"
hh.union_card.lookAt = function(arg1) -- line 76
    manny:say_line("/hhma002/")
end
hh.union_card.use = function(arg1) -- line 80
    manny:say_line("/hhma003/")
end
hh.union_card.default_response = hh.union_card.use
hh.tb_door = Object:create(hh, "/hhtx004/stairs", -0.063047998, -0.95240301, 0.0100001, { range = 0.60000002 })
hh.tb_door.use_pnt_x = -0.054778699
hh.tb_door.use_pnt_y = -0.79997802
hh.tb_door.use_pnt_z = 0
hh.tb_door.use_rot_x = 0
hh.tb_door.use_rot_y = -895.28601
hh.tb_door.use_rot_z = 0
hh.tb_door.out_pnt_x = -0.047213301
hh.tb_door.out_pnt_y = -1.15
hh.tb_door.out_pnt_z = -0.2
hh.tb_door.out_rot_x = 0
hh.tb_door.out_rot_y = -534.84998
hh.tb_door.out_rot_z = 0
hh.tb_box = hh.tb_door
hh.tb_door:make_untouchable()
hh.tb_door.walkOut = function(arg1) -- line 112
    if not tb.seen_intro then
        tb.needs_intro = TRUE
    end
    tb:come_out_door(tb.hh_door)
end
hh.hl_door = Object:create(hh, "/hhtx006/door", 0.0384355, 0.70923799, 0.49399999, { range = 0.69999999 })
hh.hl_door.use_pnt_x = -0.0271775
hh.hl_door.use_pnt_y = 0.96948802
hh.hl_door.use_pnt_z = 0
hh.hl_door.use_rot_x = 0
hh.hl_door.use_rot_y = 191.09801
hh.hl_door.use_rot_z = 0
hh.hl_door.out_pnt_x = -0.0271775
hh.hl_door.out_pnt_y = 0.96948802
hh.hl_door.out_pnt_z = 0
hh.hl_door.out_rot_x = 0
hh.hl_door.out_rot_y = 191.09801
hh.hl_door.out_rot_z = 0
hh.hl_box = hh.hl_door
hh.hl_door.passage = { "hl_door_psg1", "hl_door_psg2", "hl_door_psg3" }
hh.hl_door.lookAt = function(arg1) -- line 137
    manny:say_line("/hhma007/")
end
hh.hl_door.walkOut = function(arg1) -- line 141
    if hh.showed_pass or hl.glottis_gambling then
        if manny.is_holding then
            put_away_held_item()
        end
        hl.elev_open:comeOut()
    end
end
hh.hl_door.open = function(arg1) -- line 151
    if not arg1:is_open() then
        arg1:play_chore(0)
        Object.open(arg1)
    end
end
hh.hl_door.close = function(arg1) -- line 158
    if arg1:is_open() then
        arg1:play_chore(1)
        Object.close(arg1)
    end
end
hh.hl_door.use_pass = hh.hl_door.walkOut
hh.hl_door.comeOut = function(arg1) -- line 168
    START_CUT_SCENE()
    hh:switch_to_set()
    hh:current_setup(hh_estla)
    manny:put_in_set(hh)
    manny:setpos(-0.0271775, 0.969488, 0)
    manny:setrot(0, 191, 0)
    arg1:play_chore(0)
    arg1:wait_for_chore()
    manny:walkto(0.0254188, 0.396167, 0)
    manny:wait_for_actor()
    arg1:close()
    END_CUT_SCENE()
end
hh.hl_door_trigger = { }
hh.hl_door_trigger.walkOut = function(arg1) -- line 186
    hh.hl_door:open()
    if hh.showed_pass or hl.glottis_gambling then
        while manny:find_sector_name("hl_door_trigger") do
            break_here()
        end
        if manny:find_sector_name("hh_floor") then
            hh.hl_door:close()
        end
    elseif cn.pass.owner ~= manny then
        music_state:set_sequence(seqRaoulAppears)
        if not hh.tried_door then
            hh.tried_door = TRUE
            START_CUT_SCENE()
            manny:walkto(0.202223, 0.505423, 0, 0, 33.1976, 0)
            raoul:say_line("/hhra008/")
            raoul:wait_for_message()
            manny:nod_head_gesture()
            manny:say_line("/hhma009/")
            manny:wait_for_message()
            raoul:say_line("/hhra010/")
            raoul:wait_for_message()
            manny:point_gesture()
            manny:say_line("/hhma011/")
            manny:wait_for_message()
            raoul:say_line("/hhra012/")
            raoul:wait_for_message()
            raoul:say_line("/hhra013/")
            raoul:wait_for_message()
            END_CUT_SCENE()
        else
            START_CUT_SCENE()
            raoul:say_line("/hhra014/")
            raoul:wait_for_message()
            manny:say_line("/hhma015/")
            manny:wait_for_message()
            raoul:say_line("/hhra016/")
            raoul:wait_for_message()
            END_CUT_SCENE()
        end
        hh.hl_door:close()
    else
        hh.showed_pass = TRUE
        hh.raoul_in_elevator = TRUE
        if manny.is_holding ~= cn.pass then
            manny:pull_out_item(cn.pass)
        end
        START_CUT_SCENE()
        manny:walkto(0.202223, 0.505423, 0, 0, 33.1976, 0)
        raoul:say_line("/hhra017/")
        raoul:wait_for_message()
        manny:say_line("/hhma018/")
        manny:walkto_object(hh.hl_door)
        manny:wait_for_message()
        raoul:say_line("/hhra019/")
        raoul:wait_for_message()
        manny:wait_for_actor()
        manny:clear_hands()
        raoul:say_line("/hhra020/")
        raoul:wait_for_message()
        music_state:set_sequence(seqRaoulDissed)
        sleep_for(1500)
        hh.hl_door:play_chore(1)
        hh.hl_door:wait_for_chore()
        END_CUT_SCENE()
        hl.elev_open:comeOut()
    end
end

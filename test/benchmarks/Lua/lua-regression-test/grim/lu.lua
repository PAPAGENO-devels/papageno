CheckFirstTime("lu.lua")
lu = Set:create("lu.set", "lamancha sub", { lu_subla = 0, lu_ovrhd = 1 })
dofile("do_fight.lua")
manny.punches = { "/luma001/", "/luma002/", "/luma003/", "/luma004/", "/luma005/", "/luma006/", "/luma007/" }
manny.punched = { "/luma008/", "/luma009/", "/luma010/", "/luma011/", "/luma012/", "/luma013/", "/luma014/" }
domino.punches = { "/ludo015/", "/ludo016/", "/ludo017/", "/ludo018/", "/ludo019/", "/ludo020/", "/ludo021/" }
domino.punched = { "/ludo022/", "/ludo023/", "/ludo024/", "/ludo025/", "/ludo026/", "/ludo027/", "/ludo028/" }
lu.m_taunt_count = 1
lu.d_taunt_count = 1
lu.manny_taunts = function() -- line 53
    if lu.m_taunt_count == 1 then
        manny:say_line("/luma029/")
        wait_for_message()
        domino:say_line("/ludo030/")
        wait_for_message()
        domino:say_line("/ludo031/")
    elseif lu.m_taunt_count == 2 then
        manny:say_line("/luma032/")
    elseif lu.m_taunt_count == 3 then
        manny:say_line("/luma033/")
        wait_for_message()
        domino:say_line("/ludo034/")
    end
    lu.m_taunt_count = lu.m_taunt_count + 1
end
lu.domino_taunts = function() -- line 70
    if lu.d_taunt_count == 1 then
        domino:say_line("/ludo035/")
    elseif lu.d_taunt_count == 2 then
        domino:say_line("/ludo036/")
    elseif lu.d_taunt_count == 3 then
        domino:say_line("/ludo037/")
    elseif lu.d_taunt_count == 4 then
        domino:say_line("/ludo038/")
    elseif lu.d_taunt_count == 5 then
        domino:say_line("/ludo039/")
    elseif lu.d_taunt_count == 6 then
        domino:say_line("/ludo040/")
    elseif lu.d_taunt_count == 7 then
        domino:say_line("/ludo041/")
    elseif lu.d_taunt_count == 8 then
        domino:say_line("/ludo042/")
    elseif lu.d_taunt_count == 9 then
        domino:say_line("/ludo043/")
        wait_for_message()
        domino:say_line("/ludo044/")
    end
    lu.d_taunt_count = lu.d_taunt_count + 1
end
lu.scythe_fight_setup = function() -- line 96
    manny:put_in_set(lu)
    manny:setpos(-3.50621, 0.108134, 0.9)
    manny:setrot(0, -825.286, 0)
    domino:default()
    domino:put_in_set(lu)
    domino:set_costume("do_fight.cos")
    domino:set_mumble_chore(do_fight_mumble)
    domino:set_talk_chore(1, do_fight_stop_talk)
    domino:set_talk_chore(2, do_fight_a)
    domino:set_talk_chore(3, do_fight_c)
    domino:set_talk_chore(4, do_fight_e)
    domino:set_talk_chore(5, do_fight_f)
    domino:set_talk_chore(6, do_fight_l)
    domino:set_talk_chore(7, do_fight_m)
    domino:set_talk_chore(8, do_fight_o)
    domino:set_talk_chore(9, do_fight_t)
    domino:set_talk_chore(10, do_fight_u)
    domino:setpos(-2.19931, 0.096934, 0.44)
    domino:setrot(0, -622.289, 0)
    domino:set_head(8, 8, 8, 150, 28, 70)
    domino:set_speech_mode(MODE_BACKGROUND)
    start_script(lu.monitor_attack_box)
    start_script(lu.dom_look)
    domino:complete_chore(do_fight_rest)
    start_sfx("lu.imu", IM_HIGH_PRIORITY)
    set_vol("lu.imu", 5)
end
lu.dom_look = function() -- line 125
    while 1 do
        domino:head_look_at_manny()
        break_here()
    end
end
lu.monitor_attack_box = function() -- line 132
    local local1
    while 1 do
        if manny:find_sector_name("auto_attack") and manny.is_holding == mo.scythe and lu.manny_fighting == FALSE then
            local1 = start_script(lu.domino_obj.use_scythe, lu.domino_object)
            wait_for_script(local1)
        end
        break_here()
    end
end
lu.octoblink = function() -- line 146
    local local1
    while not hit_octoeye do
        lu.eye:stop_chore(2)
        lu.eye:play_chore(1)
        lu.eye:wait_for_chore()
        lu.eye:play_chore_looping(2)
        local1 = rndint(10, 20)
        repeat
            sleep_for(500)
            if hit_octoeye then
                local1 = 0
            else
                local1 = local1 - 1
            end
        until local1 <= 0
        break_here()
    end
end
lu.enter = function(arg1) -- line 174
    NewObjectState(lu_subla, OBJSTATE_UNDERLAY, "lu_octoeye.bm", nil, TRUE)
    lu.eye:set_object_state("lu_octoeye.cos")
    start_script(lu.octoblink)
    lu.scythe_fight_setup()
    play_movie_looping("lu.snm")
end
lu.exit = function(arg1) -- line 184
    domino:free()
    stop_script(lu.dom_look)
    stop_script(lu.monitor_attack_box)
    stop_sound("lu.imu")
end
lu.eye = Object:create(lu, "/lutx045/octopus", -4.6593499, -0.33352101, 1.1059, { range = 3 })
lu.eye.use_pnt_x = -3.8549399
lu.eye.use_pnt_y = -0.167321
lu.eye.use_pnt_z = 0.44
lu.eye.use_rot_x = 0
lu.eye.use_rot_y = -249.49001
lu.eye.use_rot_z = 0
lu.eye.lookAt = function(arg1) -- line 204
    manny:say_line("/luma046/")
end
lu.eye.pickUp = function(arg1) -- line 208
    manny:say_line("/luma047/")
end
lu.eye.use = function(arg1) -- line 212
    manny:say_line("/luma048/")
    wait_for_message()
    manny:say_line("/luma049/")
end
lu.eye.use_scythe = function(arg1) -- line 218
    START_CUT_SCENE()
    hit_octoeye = TRUE
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("mn_fight.cos")
    stop_script(lu.octoblink)
    manny:stop_chore(ms_hold_scythe, "mn2.cos")
    manny:play_chore(2)
    sleep_for(900)
    arg1:stop_chore(2)
    arg1:play_chore(0)
    sleep_for(804)
    END_CUT_SCENE()
    start_script(cut_scene.bloodeye)
end
lu.domino_obj = Object:create(lu, "/lutx050/Domino", -2.2876401, 0.117294, 0.98400003, { range = 2.5999999 })
lu.domino_obj.use_pnt_x = -2.7048099
lu.domino_obj.use_pnt_y = 0.195134
lu.domino_obj.use_pnt_z = 0.44
lu.domino_obj.use_rot_x = 0
lu.domino_obj.use_rot_y = -105.245
lu.domino_obj.use_rot_z = 0
lu.domino_obj.lookAt = function(arg1) -- line 243
    soft_script()
    manny:say_line("/luma051/")
    wait_for_message()
    manny:say_line("/luma052/")
end
lu.domino_obj.pickUp = function(arg1) -- line 250
    manny:say_line("/luma053/")
end
lu.domino_obj.use = function(arg1) -- line 254
    manny:say_line("/luma054/")
end
lu.domino_obj.use_scythe = function(arg1) -- line 258
    local local1 = { x = 0, y = -0.51190001, z = 0 }
    local local2 = { x = -0.090999998, y = -0.19599999, z = 0 }
    local local3 = { }
    local local4, local5
    lu.manny_fighting = TRUE
    START_CUT_SCENE()
    MakeSectorActive("auto_attack", FALSE)
    manny:walkto_object(lu.domino_obj)
    manny:wait_for_actor()
    manny:push_costume("mn_fight.cos")
    manny:stop_chore(ms_hold_scythe, "mn2.cos")
    if rnd() then
        domino:say_line(pick_one_of(domino.punches))
        manny:say_line(pick_one_of(manny.punched))
        domino:stop_chore(do_fight_rest)
        domino:play_chore(0)
        manny:play_chore(1)
        manny:wait_for_chore()
        local3 = manny:getrot()
        local5 = RotateVector(local1, local3)
        local4 = manny:getpos()
        local5.x = local5.x + local4.x
        local5.y = local5.y + local4.y
        local5.z = local5.z + local4.z
        manny:setpos(local5.x, local5.y, local5.z)
        manny:pop_costume()
        manny:play_chore_looping(ms_hold_scythe, "mn2.cos")
        domino:wait_for_chore()
        domino:complete_chore(do_fight_rest)
    else
        domino:stop_chore(do_fight_rest)
        domino:play_chore(1)
        manny:play_chore(0)
        sleep_for(400)
        manny:say_line(pick_one_of(manny.punches))
        sleep_for(737)
        domino:say_line(pick_one_of(domino.punches))
        sleep_for(150)
        manny:say_line(pick_one_of(manny.punched))
        sleep_for(650)
        manny:say_line(pick_one_of(manny.punched))
        manny:wait_for_chore()
        local3 = manny:getrot()
        local5 = RotateVector(local2, local3)
        local4 = manny:getpos()
        local5.x = local5.x + local4.x
        local5.y = local5.y + local4.y
        local5.z = local5.z + local4.z
        manny:setpos(local5.x, local5.y, local5.z)
        manny:setrot(local3.x, local3.y - 30, local3.z)
        manny:pop_costume()
        manny:play_chore_looping(ms_hold_scythe, "mn2.cos")
        domino:wait_for_chore()
        domino:complete_chore(do_fight_rest)
    end
    if lu.d_taunt_count < 15 then
        sleep_for(500)
        lu.domino_taunts()
        wait_for_message()
    end
    if lu.m_taunt_count < 4 then
        lu.manny_taunts()
        wait_for_message()
    end
    MakeSectorActive("auto_attack", TRUE)
    END_CUT_SCENE()
    lu.manny_fighting = FALSE
end

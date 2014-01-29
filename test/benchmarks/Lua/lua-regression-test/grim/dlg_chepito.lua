CheckFirstTime("dlg_chepito.lua")
cp1 = Dialog:create()
cp1.intro = function(arg1) -- line 12
    cp1.node = "first_chepito_node"
    stop_script(su.chepito_sing)
    local local1 = start_script(su.chepito_to_manny)
    manny:wait_for_message()
    if not chepito.met then
        chepito.met = TRUE
        manny:wait_for_message()
        chepito:say_line("/such001/")
        chepito:wait_for_message()
        chepito:say_line("/such002/")
        chepito:blend(chepito_exclaim, nil, 500)
        chepito:wait_for_message()
        chepito:say_line("/such003/")
        chepito:blend(chepito_2base, chepito_exclaim, 500)
        chepito:wait_for_message()
        chepito:say_line("/such004/")
    elseif chepito.knows_manny then
        chepito:say_line("/such005/")
    else
        chepito:say_line("/such006/")
        chepito:wait_for_message()
        chepito:say_line("/such007/")
    end
    wait_for_script(local1)
    chepito.knows_manny = TRUE
end
cp1[100] = { text = "/suma008/", first_chepito_node = TRUE }
cp1[100].response = function(arg1) -- line 43
    arg1.off = TRUE
    cp1[110].off = FALSE
    cp1[120].off = FALSE
    cp1[130].off = FALSE
    cp1[150].off = FALSE
    chepito:say_line("/such009/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_chore()
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
end
cp1[110] = { text = "/suma010/", first_chepito_node = TRUE }
cp1[110].off = TRUE
cp1[110].response = function(arg1) -- line 58
    arg1.off = TRUE
    chepito:say_line("/such011/")
    chepito:blend(chepito_exclaim, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such012/")
    chepito:blend(chepito_2base, chepito_exclaim, 500)
end
cp1[120] = { text = "/suma013/", first_chepito_node = TRUE }
cp1[120].off = TRUE
cp1[120].response = function(arg1) -- line 69
    arg1.off = TRUE
    chepito:blend(chepito_2conv, nil, 500)
    chepito:say_line("/such014/")
    chepito:wait_for_message()
    manny:say_line("/suma015/")
    manny:wait_for_message()
    chepito:say_line("/such016/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
    local local1 = start_script(chepito_leads)
    start_script(su.chepito_sing, su, TRUE)
    wait_for_script(local1)
    glottis:blend(glottis_sailor_home_pose, nil, 800, "glottis_sailor.cos")
    manny:say_line("/suma017/")
    manny:wait_for_message()
    chepito:say_line("/such018/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such019/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
    manny:say_line("/suma020/")
    manny:wait_for_message()
    chepito:say_line("/such021/")
    chepito:wait_for_message()
end
cp1[130] = { text = "/suma022/", first_chepito_node = TRUE }
cp1[130].off = TRUE
cp1[130].response = function(arg1) -- line 101
    arg1.off = TRUE
    cp1[140].off = FALSE
    chepito:say_line("/such023/")
    chepito:wait_for_message()
    chepito:say_line("/such024/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such025/")
    chepito:wait_for_message()
    chepito:say_line("/such026/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
    manny:say_line("/suma027/")
    manny:wait_for_message()
    chepito:say_line("/such028/")
    chepito:blend(chepito_exclaim, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such029/")
    chepito:blend(chepito_2base, chepito_exclaim, 500)
end
cp1[140] = { text = "/suma030/", first_chepito_node = TRUE }
cp1[140].off = TRUE
cp1[140].response = function(arg1) -- line 125
    arg1.off = TRUE
    chepito:say_line("/such031/")
    chepito:blend(chepito_exclaim, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such032/")
    chepito:blend(chepito_2base, chepito_exclaim, 500)
end
cp1[150] = { text = "/suma033/", first_chepito_node = TRUE }
cp1[150].off = TRUE
cp1[150].response = function(arg1) -- line 136
    arg1.off = TRUE
    chepito:say_line("/such034/")
    chepito:wait_for_message()
    chepito:say_line("/such035/")
end
cp1[160] = { text = "/suma036/", first_chepito_node = TRUE }
cp1[160].response = function(arg1) -- line 144
    arg1.off = TRUE
    cp1[170].off = FALSE
    chepito:say_line("/such037/")
end
cp1[170] = { text = "/suma038/", first_chepito_node = TRUE }
cp1[170].off = TRUE
cp1[170].response = function(arg1) -- line 152
    arg1.off = TRUE
    cp1[180].off = FALSE
    cp1[210].off = FALSE
    chepito:say_line("/such039/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such040/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
    manny:say_line("/suma041/")
end
cp1[180] = { text = "/suma042/", first_chepito_node = TRUE }
cp1[180].off = TRUE
cp1[180].response = function(arg1) -- line 167
    arg1.off = TRUE
    chepito:say_line("/such043/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such044/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
    chepito:wait_for_message()
    manny:say_line("/hama102/")
    manny:wait_for_message()
    chepito:say_line("/such045/")
end
cp1[190] = { text = "/suma046/", first_chepito_node = TRUE }
cp1[190].response = function(arg1) -- line 182
    arg1.off = TRUE
    chepito:say_line("/such047/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such048/")
    chepito:wait_for_message()
    chepito:say_line("/such049/")
    chepito:blend(chepito_exclaim, chepito_2conv, 500)
    chepito:wait_for_message()
    chepito:blend(chepito_2base, chepito_exclaim, 500)
    chepito:say_line("/such050/")
end
cp1[200] = { text = "/suma051/", first_chepito_node = TRUE }
cp1[200].response = function(arg1) -- line 197
    arg1.off = TRUE
    cp1[250].off = FALSE
    chepito:say_line("/such052/")
    chepito:wait_for_message()
    chepito:say_line("/such053/")
end
cp1[210] = { text = "/suma054/", first_chepito_node = TRUE }
cp1[210].off = TRUE
cp1[210].response = function(arg1) -- line 208
    arg1.off = TRUE
    cp1[220].off = FALSE
    chepito:say_line("/such055/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    manny:say_line("/suma056/")
    manny:wait_for_message()
    chepito:say_line("/such057/")
    chepito:blend(chepito_2base, chepito_2conv, 500)
end
cp1[220] = { text = "/suma058/", first_chepito_node = TRUE }
cp1[220].off = TRUE
cp1[220].response = function(arg1) -- line 222
    arg1.off = TRUE
    cp1[230].off = FALSE
    glottis:say_line("/sugl059/")
    glottis:wait_for_message()
    chepito:say_line("/such060/")
    chepito:wait_for_message()
    chepito:say_line("/such061/")
end
cp1[230] = { text = "/suma062/", first_chepito_node = TRUE }
cp1[230].off = TRUE
cp1[230].response = function(arg1) -- line 234
    arg1.off = TRUE
    cp1[240].off = FALSE
    cp1.just_talked_boats = TRUE
    chepito:say_line("/such063/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such064/")
    chepito:blend(chepito_exclaim, chepito_2conv, 500)
    chepito:wait_for_message()
    chepito:say_line("/such065/")
    chepito:blend(chepito_2base, chepito_exclaim, 500)
end
cp1[240] = { text = "/suma066/", first_chepito_node = TRUE }
cp1[240].off = TRUE
cp1[240].response = function(arg1) -- line 250
    arg1.off = TRUE
    if not cp1.just_talked_boats then
        chepito:say_line("/such067/")
        chepito:wait_for_message()
        manny:say_line("/suma068/")
        manny:wait_for_message()
        chepito:say_line("/such069/")
        chepito:wait_for_message()
        chepito:say_line("/such070/")
        chepito:wait_for_message()
    end
    chepito:say_line("/such071/")
    chepito:wait_for_message()
    chepito:say_line("/such072/")
    chepito:blend(chepito_2conv, nil, 500)
    chepito:wait_for_message()
    chepito:say_line("/such073/")
    chepito:blend(chepito_exclaim, chepito_2conv, 500)
    chepito:wait_for_message()
    chepito:say_line("/such074/")
    chepito:blend(chepito_2base, chepito_exclaim, 500)
end
cp1[250] = { text = "/suma075/", first_chepito_node = TRUE }
cp1[250].off = TRUE
cp1[250].response = function(arg1) -- line 277
    arg1.off = TRUE
    chepito:say_line("/such076/")
    chepito:wait_for_message()
    chepito:say_line("/such077/")
    chepito:wait_for_message()
    chepito:say_line("/such078/")
    chepito:wait_for_message()
    manny:say_line("/suma079/")
    manny:wait_for_message()
    chepito:say_line("/such080/")
end
cp1[260] = { text = "/suma081/", first_chepito_node = TRUE }
cp1[260].response = function(arg1) -- line 291
    arg1.off = TRUE
    chepito:say_line("/such082/")
    chepito:wait_for_message()
    chepito:say_line("/such083/")
end
cp1.exit_lines.first_chepito_node = { text = "/suma084/" }
cp1.exit_lines.first_chepito_node.response = function(arg1) -- line 300
    cp1.node = "exit_dialog"
    chepito:say_line("/such085/")
end
cp1.aborts.first_chepito_node = function(arg1) -- line 305
    cp1:clear()
    cp1:execute_line(cp1.exit_lines.first_chepito_node)
end
cp1.outro = function(arg1) -- line 310
    local local1 = chepito:getrot()
    cp1.just_talked_boats = FALSE
    chepito:head_look_at(nil)
    if not cp1.talked_monsters then
        cp1.talked_monsters = TRUE
        manny:say_line("/suma086/")
        chepito:stop_chore(chepito_2base)
        FadeOutChore(chepito.hActor, "chepito.cos", chepito_base, 250)
        manny:wait_for_message()
        chepito:say_line("/such087/")
        chepito:setrot(0, 107, 0, TRUE)
        chepito:wait_for_message()
        chepito:play_chore(chepito_shines)
        chepito:wait_for_chore()
        RunFullscreenMovie("sea_monsters.snm")
        stop_script(su.glottis_follow_manny)
        glottis:head_look_at(nil)
        manny:push_costume("mn_sea_scare.cos")
        glottis:push_costume("gs_sea_scare.cos")
        glottis:play_chore(0)
        manny:play_chore(0)
        chepito:stop_chore(chepito_shines)
        chepito:play_chore(chepito_shine2base)
        chepito:setrot(0, local1.y, 0, TRUE)
        chepito:wait_for_chore()
        chepito:stop_chore(chepito_shine2base)
        chepito:say_line("/such088/")
        chepito:wait_for_message()
        chepito:say_line("/such089/")
        single_start_script(su.glottis_follow_manny)
        manny:wait_for_chore()
        glottis:wait_for_chore()
        glottis:pop_costume()
        manny:pop_costume()
    end
    chepito.just_talked = TRUE
    single_start_script(su.dangle_bait)
end
chepito_leads = function() -- line 352
    local local1 = { }
    local local2 = { }
    local local3 = { }
    local local4 = { }
    cpos = chepito:getpos()
    crot = chepito:getrot()
    chepito:set_collision_mode(COLLISION_OFF)
    glottis:set_collision_mode(COLLISION_OFF)
    manny:set_collision_mode(COLLISION_OFF)
    mpos = manny:getpos()
    gpos = glottis:getpos()
    mrot = manny:getrot()
    grot = glottis:getrot()
    break_here()
    manny:set_run(FALSE)
    glottis:set_walk_rate(0.40000001)
    single_start_script(chepito_lead_walk)
    su.chepito_leading = TRUE
    glottis:ignore_boxes()
    manny:ignore_boxes()
    single_start_script(su.manny_follow_chepito)
    single_start_script(su.glottis_follow_chepito)
    while su.chepito_leading do
        break_here()
    end
    stop_script(su.manny_follow_chepito)
    stop_script(su.glottis_follow_chepito)
    MakeSectorActive("uber_sektor", TRUE)
    glottis:follow_boxes()
    manny:follow_boxes()
    start_script(chepito.walkto, chepito, cpos.x, cpos.y, cpos.z, crot.x, crot.y, crot.z)
    start_script(manny.walkto, manny, mpos.x, mpos.y, mpos.z, mrot.x, mrot.y, mrot.z)
    start_script(glottis.walkto, glottis, gpos.x, gpos.y, gpos.z, grot.x, grot.y, grot.z)
    chepito:set_collision_mode(COLLISION_SPHERE)
    glottis:set_collision_mode(COLLISION_SPHERE)
    manny:set_collision_mode(COLLISION_SPHERE)
    manny:wait_for_actor()
    chepito:wait_for_actor()
    glottis:wait_for_actor()
    MakeSectorActive("uber_sektor", FALSE)
    manny:set_walk_rate(MANNY_WALK_RATE)
    chepito:set_collision_mode(COLLISION_SPHERE)
    glottis:set_collision_mode(COLLISION_SPHERE)
    manny:set_collision_mode(COLLISION_SPHERE)
end
skip_orbiting_with_chepito = function() -- line 407
    kill_override()
    stop_script(su.manny_follow_chepito)
    stop_script(su.glottis_follow_chepito)
    glottis:follow_boxes()
    manny:follow_boxes()
    chepito:set_collision_mode(COLLISION_SPHERE)
    glottis:set_collision_mode(COLLISION_SPHERE)
    manny:set_collision_mode(COLLISION_SPHERE)
    chepito:setpos(cpos.x, cpos.y, cpos.z)
    chepito:setrot(crot.x, crot.y, crot.z)
    manny:setpos(mpos.x, mpos.y, mpos.z)
    manny:setrot(mrot.x, mrot.y, mrot.z)
    glottis:setpos(gpos.x, gpos.y, gpos.z)
    glottis:setrot(grot.x, grot.y, grot.z)
end
su.glottis_follow_chepito = function() -- line 427
    local local1 = glottis:getpos()
    local local2 = { }
    local local3, local4
    local local5 = { x = 0, y = -1, z = 0 }
    break_here()
    while 1 do
        glottis:head_look_at_manny()
        while proximity(glottis, chepito) > 1.5 do
            repeat
                glottis:head_look_at(chepito)
                glottis:stop_chore(glottis_home_pose, "glottis_sailor.cos")
                local2 = chepito:getrot()
                local4 = RotateVector(local5, local2)
                local3 = chepito:getpos()
                local4.x = local4.x + local3.x
                local4.y = local4.y + local3.y
                local4.z = local4.z + local3.z
                TurnActorTo(glottis.hActor, local4.x, local4.y, local4.z)
                glottis:walk_forward()
                break_here()
                local1 = glottis:getpos()
            until proximity(glottis, chepito) < 1.1
        end
        break_here()
        glottis:play_chore(glottis_home_pose, "glottis_sailor.cos")
    end
end
su.manny_follow_chepito = function() -- line 459
    local local1 = manny:getpos()
    local local2 = { }
    local local3, local4
    local local5 = { x = 0, y = -0.30000001, z = 0 }
    break_here()
    while 1 do
        manny:head_look_at(chepito)
        while proximity(chepito, manny) > 0.60000002 do
            repeat
                manny:head_look_at(chepito)
                local2 = chepito:getrot()
                local4 = RotateVector(local5, local2)
                local3 = chepito:getpos()
                local4.x = local4.x + local3.x
                local4.y = local4.y + local3.y
                local4.z = local4.z + local3.z
                TurnActorTo(manny.hActor, local4.x, local4.y, local4.z)
                manny:walk_forward()
                break_here()
                local1 = manny:getpos()
            until proximity(chepito, manny) < 0.34999999
        end
        break_here()
    end
end
chepito_lead_walk = function() -- line 490
    chepito:stop_chore()
    chepito:head_look_at(nil)
    chepito:walkto(3.7, -5.47906, 0)
    chepito:wait_for_actor()
    sleep_for(5000)
    chepito:setpos(7.87, 3.7, 0)
    manny:setpos(7.87, 3.7, 0)
    glottis:setpos(7.87, 3.7, 0)
    chepito:walkto(3.07, 9.35, 0)
    chepito:wait_for_actor()
    chepito:setpos(-9.8, 39, 3)
    manny:setpos(-9.8, 39, 3)
    glottis:setpos(-9.8, 39, 3)
    chepito:walkto(-26, 38, 3)
    chepito:wait_for_actor()
    manny:setpos({ x = -2.66886, y = -5.35335, z = 0 })
    glottis:setpos({ x = -2.66886, y = -5.35335, z = 0 })
    chepito:setpos({ x = -2.66886, y = -5.35335, z = 0 })
    chepito:setrot(0, 448.375, 0)
    su.chepito_leading = FALSE
end

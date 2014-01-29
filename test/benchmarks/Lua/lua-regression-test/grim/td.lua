CheckFirstTime("td.lua")
dofile("td_coffin.lua")
td = Set:create("td.set", "truck depot", { td_overhead = 0, td_tdiws = 1, td_tdiha = 2, td_mnycu = 3 })
td.cameraman = function(arg1) -- line 14
    local local1, local2
    cameraman_watching_set = arg1
    if cameraman_disabled == FALSE and arg1:current_setup() ~= arg1.setups.overhead and cutSceneLevel <= 0 then
        local1, cameraman_box_name, local2 = system.currentActor:find_sector_type(CAMERA)
        if cameraman_box_name == "td_tdiha" then
            if td:current_setup() ~= td_tdiha then
                td:current_setup(td_tdiha)
            end
        elseif td:current_setup() ~= "td_tdiws" then
            td:current_setup(td_tdiws)
        end
    end
end
td.footstep_monitor = function(arg1) -- line 40
    while TRUE do
        if manny:find_sector_name("stair1") or manny:find_sector_name("top_stair") then
            manny.footsteps = footsteps.marble
        else
            manny.footsteps = footsteps.snow
        end
        break_here()
    end
end
td.enter = function(arg1) -- line 51
    td:add_object_state(td_tdiha, "td_coffin_door.bm", "td_coffin_door.zbm", OBJSTATE_STATE)
    td:add_object_state(td_tdiws, "td_1_coffin.bm", "td_1_coffin.zbm", OBJSTATE_STATE)
    td.coffin:set_object_state("td_coffin.cos")
    if td.coffin:is_open() then
        td.coffin:play_chore(td_coffin_set_open)
    else
        td.coffin:play_chore(td_coffin_set_closed)
    end
    start_script(td.footstep_monitor, td)
end
td.exit = function(arg1) -- line 65
    stop_script(td.footstep_monitor)
end
td.sigh_box = { }
td.sigh_box.walkOut = function(arg1) -- line 74
    if not td.sighed then
        td.sighed = TRUE
        box_off("sigh_box")
        soft_script()
        manny:head_look_at(td.rtruck_door)
        manny:say_line("/tdma007/")
        manny:wait_for_message()
        manny:say_line("/tdma008/")
        manny:wait_for_message()
        if hot_object then
            manny:head_look_at(hot_object)
        else
            manny:head_look_at(nil)
        end
    end
end
td.mug = Object:create(td, "/tdtx001/mug", 0, 0, 0, { range = 0 })
td.mug.string_name = "mug"
td.mug.lookAt = function(arg1) -- line 101
    manny:say_line("/tdma002/")
end
td.mug.default_response = function(arg1) -- line 105
    manny:say_line("/tdma003/")
end
td.mug.use = function(arg1) -- line 109
    manny:say_line("/tdma004/")
end
td.rtruck_door = Object:create(td, "/tdtx005/truck door", 1.0027601, -1.40321, 0.25999999, { range = 0.60000002 })
td.rtruck_door.use_pnt_x = 0.76275802
td.rtruck_door.use_pnt_y = -1.24321
td.rtruck_door.use_pnt_z = -0.02
td.rtruck_door.use_rot_x = 0
td.rtruck_door.use_rot_y = -129.33099
td.rtruck_door.use_rot_z = 0
td.rtruck_door.lookAt = function(arg1) -- line 122
    manny:say_line("/tdma006/")
end
td.rtruck_door.pickUp = function(arg1) -- line 126
    manny:say_line("/tdma025/")
end
td.rtruck_door.use = function(arg1) -- line 131
    soft_script()
    manny:say_line("/tdma010/")
    wait_for_message()
    sleep_for(1000)
    manny:say_line("/tdma011/")
end
td.rtruck_cab = Object:create(td, "/tdtx012/truck", 1.44891, -1.78935, 0.34999999, { range = 0.89999998 })
td.rtruck_cab.use_pnt_x = 1.79891
td.rtruck_cab.use_pnt_y = -1.36935
td.rtruck_cab.use_pnt_z = -0.02
td.rtruck_cab.use_rot_x = 0
td.rtruck_cab.use_rot_y = -219.608
td.rtruck_cab.use_rot_z = 0
td.rtruck_cab.lookAt = function(arg1) -- line 149
    if not arg1.other.seen then
        arg1.seen = TRUE
        manny:say_line("/tdma013/")
    else
        manny:say_line("/tdma014/")
    end
end
td.rtruck_cab.use = function(arg1) -- line 158
    manny:say_line("/tdma015/")
end
td.ltruck_door = Object:create(td, "/tdtx016/truck_door", 0.80421299, -0.47146699, 0.28, { range = 0.60000002 })
td.ltruck_door.use_pnt_x = 0.604213
td.ltruck_door.use_pnt_y = -0.461467
td.ltruck_door.use_pnt_z = -0.02
td.ltruck_door.use_rot_x = 0
td.ltruck_door.use_rot_y = -98.4804
td.ltruck_door.use_rot_z = 0
td.ltruck_door.lookAt = function(arg1) -- line 170
    td.rtruck_door.lookAt(arg1)
end
td.ltruck_door.pickUp = function(arg1) -- line 174
    td.rtruck_door.pickUp(arg1)
end
td.ltruck_door.use = function(arg1) -- line 178
    td.rtruck_door.use(arg1)
end
td.ltruck_cab = Object:create(td, "/tdtx017/truck", 1.52797, -0.65471703, 0.31, { range = 0.89999998 })
td.ltruck_cab.use_pnt_x = 1.52797
td.ltruck_cab.use_pnt_y = -0.92471701
td.ltruck_cab.use_pnt_z = -0.02
td.ltruck_cab.use_rot_x = 0
td.ltruck_cab.use_rot_y = -377.65701
td.ltruck_cab.use_rot_z = 0
td.ltruck_cab.other = td.rtruck_cab
td.rtruck_cab.other = td.ltruck_cab
td.ltruck_cab.lookAt = function(arg1) -- line 195
    td.rtruck_cab.lookAt(arg1)
end
td.ltruck_cab.use = td.rtruck_cab.use
td.road = Object:create(td, "/tdtx018/road", -1.99989, -2.92063, 0.37, { range = 0.89999998 })
td.road.use_pnt_x = -1.71989
td.road.use_pnt_y = -2.4806299
td.road.use_pnt_z = -0.02
td.road.use_rot_x = 0
td.road.use_rot_y = -214.48199
td.road.use_rot_z = 0
td.road.walkOut = function(arg1) -- line 211
    soft_script()
    manny:say_line("/tdma019/")
    wait_for_message()
    manny:say_line("/tdma020/")
end
td.road.lookAt = td.road.walkOut
td.road.use = td.road.walkOut
td.coffin = Object:create(td, "/tdtx021/casket", 0.038148701, -1.23876, 0.050000001, { range = 0.60000002 })
td.coffin.use_pnt_x = 0.28397
td.coffin.use_pnt_y = -0.96091002
td.coffin.use_pnt_z = -0.02
td.coffin.use_rot_x = 0
td.coffin.use_rot_y = 107.238
td.coffin.use_rot_z = 0
td.coffin.lookAt = function(arg1) -- line 230
    if arg1:is_open() then
        manny:say_line("/tdma022/")
    else
        manny:say_line("/tdma023/")
    end
end
td.coffin.pickUp = function(arg1) -- line 238
    if arg1:is_open() then
        manny:say_line("/tdma024/")
    else
        manny:say_line("/tdma025/")
    end
end
td.coffin.open = function(arg1) -- line 246
    arg1.opened = TRUE
    START_CUT_SCENE()
    manny:clear_hands()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    start_script(cut_scene.brunoup)
end
td.coffin.use = function(arg1) -- line 255
    if arg1:is_open() then
        arg1:pickUp()
    else
        arg1:open()
    end
end
td.ravine = Object:create(td, "/tdtx028/ravine", -1.79318, 0.33208901, -0.02, { range = 1.6 })
td.ravine.use_pnt_x = -0.91318101
td.ravine.use_pnt_y = -0.81791103
td.ravine.use_pnt_z = -0.02
td.ravine.use_rot_x = 0
td.ravine.use_rot_y = -319.03699
td.ravine.use_rot_z = 0
td.ravine.use = function(arg1) -- line 272
    START_CUT_SCENE()
    manny:say_line("/tdma029/")
    wait_for_message()
    sleep_for(2000)
    manny:say_line("/tdma030/")
    wait_for_message()
    manny:say_line("/tdma031/")
    END_CUT_SCENE()
end
td.ravine.lookAt = td.ravine.use
td.bs_door = Object:create(td, "/tdtx026/stairs", 1.95588, -4.0633101, 1.2946399, { range = 0.60000002 })
td.bs_door.use_pnt_x = 1.26588
td.bs_door.use_pnt_y = -3.3733201
td.bs_door.use_pnt_z = 0.52464098
td.bs_door.use_rot_x = 0
td.bs_door.use_rot_y = -1219.27
td.bs_door.use_rot_z = 0
td.bs_door.out_pnt_x = 1.4984
td.bs_door.out_pnt_y = -3.65698
td.bs_door.out_pnt_z = 0.67000002
td.bs_door.out_rot_x = 0
td.bs_door.out_rot_y = -1220.1899
td.bs_door.out_rot_z = 0
td.bs_door.walkOut = function(arg1) -- line 304
    bs:come_out_door(bs.td_door)
    if not seen_hell_train then
        start_script(bs.force_hell_train)
    end
end
td.bs_door.comeOut = function(arg1) -- line 311
    td:current_setup(td_tdiws)
    Object.come_out_door(arg1)
end
td.bs_door.lookAt = function(arg1) -- line 316
    manny:say_line("/tdma027/")
end

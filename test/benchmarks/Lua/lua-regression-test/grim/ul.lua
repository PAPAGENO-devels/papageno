CheckFirstTime("ul.lua")
ul = Set:create("ul.set", "undernath the Lola", { ul_dock = 0, ul_ocean = 1 })
dofile("ul_port_anchor.lua")
dofile("ul_star_anchor.lua")
dofile("ul_prop.lua")
go_under_lola = function() -- line 30
    ul:switch_to_set()
    if ei.boat_state == "pier" then
        ul:current_setup(ul_dock)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_L_prop.bm")
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_R_prop.bm")
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_left_AWAY.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_left_down.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_right_AWAY.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_right_down.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_solution.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_ripped.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_P_tight.bm", nil, TRUE)
        NewObjectState(ul_dock, OBJSTATE_OVERLAY, "ul_O_right_AWAYx.bm", nil, TRUE)
        StartMovie("ul_p.snm")
    else
        ul:current_setup(ul_ocean)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_L_prop.bm")
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_R_prop.bm")
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_left_AWAY.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_left_down.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_right_AWAY.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_right_down.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_solution.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_tight.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_O_ripped.bm", nil, TRUE)
        NewObjectState(ul_ocean, OBJSTATE_OVERLAY, "ul_P_left_AWAYx.bm", nil, TRUE)
        StartMovie("ul_o.snm")
    end
    if ul.props_running then
        start_sfx("lolawatr.imu")
        ul.props:play_chore_looping(ul_prop_full_ahead)
    else
        ul.props:play_chore_looping(ul_prop_all_stop)
    end
    if ei.sa.state == "out" then
        ul.star_anchor:play_chore(ul_star_anchor_out)
    elseif ei.sa.state == "straight" then
        ul.star_anchor:play_chore(ul_star_anchor_down)
    elseif ei.sa.state == "under" then
        if ei.boat_state == "pier" then
            ul.star_anchor:play_chore(ul_star_anchor_out)
        else
            ul.star_anchor:play_chore(ul_star_anchor_under)
        end
    else
        ul.star_anchor:play_chore(ul_star_anchor_up)
    end
    if ei.pa.state == "out" then
        ul.port_anchor:play_chore(ul_port_anchor_out)
    elseif ei.pa.state == "straight" then
        ul.port_anchor:play_chore(ul_port_anchor_down)
    elseif ei.pa.state == "under" then
        PrintDebug(ei.pa.state)
        if ei.boat_state == "pier" then
            ul.port_anchor:play_chore(ul_port_anchor_under)
        else
            ul.port_anchor:play_chore(ul_port_anchor_out)
        end
    else
        ul.port_anchor:play_chore(ul_port_anchor_up)
    end
    if ei.sa.state == "drawn" or ei.sa.state == "portholed" then
        ul.port_anchor:play_chore(ul_port_anchor_hooked)
        ul.star_anchor:play_chore(ul_star_anchor_hooked)
    elseif ei.pa.state == "drawn" or ei.pa.state == "portholed" then
        ul.star_anchor:play_chore(ul_port_anchor_hooked)
        ul.port_anchor:play_chore(ul_star_anchor_hooked)
    end
    if ei.ship_ripped then
        ul.tear:play_chore(0)
    end
    wait_for_movie()
    ul.props_running = FALSE
    stop_sound("lolawatr.imu")
    ul:return_to_set()
end
ul.enter = function(arg1) -- line 124
    ul.props:set_object_state("ul_prop.cos")
    ul.star_anchor:set_object_state("ul_star_anchor.cos")
    ul.port_anchor:set_object_state("ul_port_anchor.cos")
    ul.tear:set_object_state("ul_tear.cos")
end
ul.exit = function(arg1) -- line 132
end
ul.switch_to_set = function(arg1) -- line 136
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    inventory_save_set = system.currentSet
    arg1:CommonEnter()
    MakeCurrentSet(arg1.setFile)
    arg1:enter()
    system.currentSet = ul
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    inventory_save_handler = system.buttonHandler
end
ul.return_to_set = function(arg1) -- line 151
    ul:exit()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    system.buttonHandler = inventory_save_handler
end
ul.props = Object:create(ul, "propellers", 0, 0, 0, { range = 0 })
ul.star_anchor = Object:create(ul, "anchor", 0, 0, 0, { range = 0 })
ul.port_anchor = Object:create(ul, "anchor", 0, 0, 0, { range = 0 })
ul.tear = Object:create(ul, "anchor", 0, 0, 0, { range = 0 })

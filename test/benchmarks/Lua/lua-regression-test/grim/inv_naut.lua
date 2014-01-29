CheckFirstTime("inv_naut.lua")
inv_naut = Set:create("inv_naut.set", "Inventory", { chest = 0 })
inv_naut.set_up_actors = function(arg1) -- line 13
    if not mannys_hands then
        mannys_hands = Actor:create("ma_naut_arms.3do", nil, "ma_naut_pp.key", "/sytx187/")
    end
    mannys_hands:put_in_set(arg1)
    mannys_hands:moveto(0, 0, 0)
    mannys_hands:setrot(0, 180, 0)
end
inv_naut.enter = function(arg1) -- line 25
    arg1:set_up_actors()
    PrintDebug("Inventory save set: " .. tostring(inventory_save_set) .. "\n")
    PrintDebug("Inventory save handler: " .. tostring(inventory_save_handler) .. "\n")
end
inv_naut.exit = function(arg1) -- line 32
end

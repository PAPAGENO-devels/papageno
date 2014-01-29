CheckFirstTime("_actors1.lua")
ledge_rope = Actor:create(nil, nil, nil, "Rope")
ledge_rope.default = function(arg1) -- line 15
    ledge_rope:ignore_boxes()
    ledge_rope:set_costume("ledge_rope.cos")
end
tie_rope = Actor:create(nil, nil, nil, "Rope")
tie_rope.default = function(arg1) -- line 21
    tie_rope:ignore_boxes()
    tie_rope:set_costume("rope_climb.cos")
end

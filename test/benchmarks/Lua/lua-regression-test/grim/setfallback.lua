local local1 = { gettable = function() -- line 9
    error("indexed expression not a table")
end, settable = function() -- line 10
    error("indexed expression not a table")
end, index = function() -- line 11
    return nil
end, getglobal = function() -- line 12
    return nil
end, arith = function() -- line 13
    error("number expected in arithmetic operation")
end, order = function() -- line 14
    error("incompatible types in comparison")
end, concat = function() -- line 15
    error("string expected in concatenation")
end, gc = function() -- line 16
    return nil
end, ["function"] = function() -- line 17
    error("called expression not a function")
end, error = function(arg1) -- line 18
    write(_STDERR, arg1, "\n")
end }
setfallback = function(arg1, arg2) -- line 22
    local local1 = function(arg1, arg2) -- line 26
        call(settagmethod, { 0, arg1, arg2 }, "x", nil)
        call(settagmethod, { tag(0), arg1, arg2 }, "x", nil)
        call(settagmethod, { tag(""), arg1, arg2 }, "x", nil)
        call(settagmethod, { tag({ }), arg1, arg2 }, "x", nil)
        call(settagmethod, { tag(function() -- line 31
        end), arg1, arg2 }, "x", nil)
        call(settagmethod, { tag(settagmethod), arg1, arg2 }, "x", nil)
        call(settagmethod, { tag(nil), arg1, arg2 }, "x", nil)
    end
    assert(type(arg2) == "function")
    local local2
    if arg1 == "error" then
        local2 = seterrormethod(arg2)
    elseif arg1 == "getglobal" then
        local2 = settagmethod(tag(nil), "getglobal", arg2)
    elseif arg1 == "arith" then
        local2 = gettagmethod(tag(0), "pow")
        foreach({ "add", "sub", "mul", "div", "unm", "pow" }, function(arg1, arg2) -- line 45
            %local1(arg2, %arg2)
        end)
    elseif arg1 == "order" then
        local2 = gettagmethod(tag(nil), "lt")
        foreach({ "lt", "gt", "le", "ge" }, function(arg1, arg2) -- line 49
            %local1(arg2, %arg2)
        end)
    else
        local2 = gettagmethod(tag(nil), arg1)
        local1(arg1, arg2)
    end
    return local2 or rawgettable(%local1, arg1)
end

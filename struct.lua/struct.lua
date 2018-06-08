
local M = {}

function M.type(val)
    local validtypes = {boolean=true, number=true, string=true, table=true, userdata=true, ["function"]=true}
    -- check for enum first because it's the only one that can error on __index.
    if type(val) == "table" and val.___def and val.___def.___enum_definition then
        return "enum"
    elseif type(val) == "table" and val.___enum_definition then
        return "enumdef"
    elseif type(val) == "table" and val.___def and val.___def.___struct_definition then
        return "struct"
    elseif type(val) == "table" and val.___struct_definition then
        return "structdef"
    elseif validtypes[type(val)] then
        return type(val)
    end
end

function M.ipairs(e)
    if M.type(e) ~= "enum" then
        error("error: called ipairs on non-enum", 2)
    end
    return ipairs(e.___def)
end

local enummt = {
    __index = function(t, k)
    	if not t.___def[k] then
    		error("error: " .. k .. " is not an enum member", 2)
    	end
        return {___def=t, value=t.___def[k], name=k}
    end,
    __newindex = function(t, k, v)
        error("error: cannot modify enum", 2)
    end,
    __ipairs = function(self)
        return M.ipairs(self)
    end
}

function M.enum(def)
    local vals = {___def={}}
    for i, v in ipairs(def) do
        vals.___def[v] = i
        vals.___def[i] = v
    end
    vals.___enum_definition = true
    return setmetatable(vals, enummt)
end

function M.definition(val)
    if M.type(val) ~= "struct" then
        error("error: cannot get definition from non-struct", 2)
    end
    return val.___def
end

function M.pairs(s)
    if M.type(s) ~= "struct" then
        error("error: called pairs on non-struct", 2)
    end
    return pairs(s.___guts)
end

local structmt = {
    __index = function(t, k)
        return t.___guts[k]
    end,
    __newindex = function(t, k, v)
        local vtype = M.type(v)
        if vtype == "struct" then
            if t.___def[k].___def == v.___def then
                t.___guts[k] = v
            else
                error("error: wrong struct assigned to " .. k, 2)
            end
        elseif vtype == "enum" then
        	t.___guts[k] = v
        elseif M.type(t.___def[k]) == vtype then
            t.___guts[k] = v
        else
            error("error: cannot assign type " .. vtype .. " to " .. k .. " (" ..M.type(t.___def[k]) .. ")" , 2)
        end
    end,
    __pairs = function(self)
        return M.pairs(self)
    end,
    __ipairs = function(self)
        return M.ipairs(self)
    end
}

return setmetatable(M, {
    __call = function(_, def)
        return setmetatable(def, {
            ___struct_definition = true,
            __call = function()
                local function deepcopy(orig)
                    if type(orig) == "table" then
                        local copy = {}
                        for k, v in next, orig, nil do
                            if k == "___def" then
                                copy[k] = v
                            else
                                copy[k] = deepcopy(v)
                            end
                        end
                        setmetatable(copy, getmetatable(orig))
                        return copy
                    else
                        return orig
                    end
                end
                return setmetatable({
                    ___def = def,
                    ___guts = deepcopy(def)
                }, structmt)
            end
        })
    end
})

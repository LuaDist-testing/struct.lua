local struct = require("struct")

local vector = struct {
    x = 0, y = 0
}

local rect = struct {
    -- both are restricted to only vector structs.
    pos = vector(), siz = vector()
}

local r = rect()
print(r)
print(r.pos, r.siz)
print(r.pos.x, r.pos.y, r.siz.x, r.siz.y)

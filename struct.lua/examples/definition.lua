
local struct = require("struct")

local vector = struct {
    x = 0,
    y = 0
}

-- still just a table.
print(vector)
-- only thing changed is an internal variable and a metatable.
print(vector.x, vector.y)

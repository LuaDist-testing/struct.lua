local struct = require("struct")

local vector = struct {
    x = 0, y = 0
}

local v = vector()
v.x = "string" -- error!

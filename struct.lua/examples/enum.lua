
local struct = require("struct")

local days = struct.enum {
    "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"
}

print(struct.type(days))
print(struct.type(days.monday))
print(days.monday)
--print(days.fryday)

local schedule = struct {
    day = days.monday
}

local s = schedule()

print(s.day.value, s.day.name)
--s.day = 5

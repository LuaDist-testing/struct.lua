# struct.lua

__struct.lua__ offers a type-checked table definition.

__struct.lua__ is compatible with [Lua 5.1](http://www.lua.org/versions.html#5.1), [Lua 5.2](http://www.lua.org/versions.html#5.2) and [Lua 5.3](http://www.lua.org/versions.html#5.3).

##Installation

Copy the file [struct.lua](https://github.com/mpatraw/struct.lua/blob/master/struct.lua) inside your project folder, call it using the [require](http://www.lua.org/manual/5.1/manual.html#pdf-require) function. It will return a single object.

##Quicktour (for v0.2)

###Definitions

####Basic Definition

Struct definitions are defined using a table as a prototype. The value assigned to a member restricts the type. The values assigned are also the defaults when instantiating a new table from the struct.

```lua
local struct = require("struct")

local vector = struct {
	x = 0, -- numbers only.
	y = 0 -- same here.
}
```

####Instantiating

To instantiate a struct from a struct definition just call it as a function.

```lua
local struct = require("struct")

local vector = struct {
	x = 0, y = 0
}

local v = vector()
```

####Embedded Definitions

Definitions can also contain other structs definitions, which restricts the member to only that struct.

```lua
local struct = require("struct")

local vector = struct {
	x = 0, y = 0
}

local rect = struct {
	-- both are restricted to only vector structs.
	pos = vector(), siz = vector()
}
```

###Type-checking

Types are checked at runtime. When an attempt to assign a member to the wrong type an error will occur.

```lua
local struct = require("struct")

local vector = struct {
	x = 0, y = 0
}

local v = vector()
v.x = "string" -- error!
```

###Utility Functions

####struct.type(val)

Return the type of a variable supported by __struct.lua__. Struct definitions will return "definition" and instantiated structs will return "struct".

####struct.definition(val)

Return the definition of an instantiated struct. You could do: `struct.definition(obj)()` to create a new struct.

####struct.pairs(val)

All of a struct's members are hidden, so if you want to iterate over the whole struct, you must use this.

####struct.enum {"enum1", "enum2"}

Create an enum definition that can be used inside structs.

####struct.ipairs(enum)

Same as struct.pairs but for enums.

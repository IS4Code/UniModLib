UniModLib
=========

Helper library for UniMod, a modification of NoX

## Installing
Create a directory named *lualib* in the NoX directory and download the lua files to it.
To make the require function working, add this to the top of your global script:
```lua
LUA_PATH = "lualib/?;lualib/?.lua;"..(LUA_PATH or package.path or "?;?.lua"); package.path = LUA_PATH
```

## Usage
To use a part of this library, simply put the following command to the top of a script or function where you want to use it, *game* libary used as an example:
```lua
local game = require("game")
```
```lua
game.flags = game.flags-0x80
```

### List of modules

### bit.lua
Bit module allows basic bit manipulation (i.e. bit AND, OR, and XOR) as well as binary conversion between primitive number types.

### game.lua
Game module contains functions for retrieving information about the game, e.g. game flags, mouse position or console reading events.

### map.lua
Map module provides ways to modify the map, being it simple new map loading or modifying the tiles and walls.

### memory.lua
Memory module is heavily used in places where standard UniMod functions can't do all. It can modify and read game's memory.

### unit.lua
Unit module encompasses manipulation with units (i.e. objects), as unit creation and deletion, changing position, etc.

### player.lua
Player module can find all players, get their basic info, and provide events of player joining, dieing, or chatting.

### team.lua
Team module is used to retrieve statistic about teams, or to modify it.

### timed.lua
Timed library is able to utilize functions and coroutines to run a function after a given time periodically or one-time. Also allows running a function with a sleep command included.

### utils.lua
Miscellaneous functions mostly used by the other modules.

### env.lua
Environment module is not for usage outside the other modules, it provides access to the top-level server and client functions.

### events.lua
Events module is used by the other modules to create event objects.
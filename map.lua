--Map manipulation by IllidanS4
local map = {}
local env = require("env")

function map.settile(x, y, tile, var, a, b)
  env.tileSet(x, y, {tile, var, a, b})
end

function map.gettile(x, y)
  return unpack(env.tileGet(x, y))
end

function map.tilename(tile)
  return env.tileGetName(tile)
end

function map.tilemaxvari(tile)
  return env.tileMaxVari(tile)
end

function map.tilenum(tile)
  return env.mapGetTileByName(tile)
end

function map.tilename(tile)
  return env.mapNameByTile(tile)
end

function map.getwall(x, y)
  return env.mapGet(x, y)
end

function map.setwall(tile, x, y, dir, flags, vari, unk3, hp)
  return env.mapSet(tile, x, y, dir, flags, vari, unk3, hp)
end

function map.wallinfo(wall)
  return env.mapInfo(wall)
end

function map.removewall(x, y)
  env.mapDel(x, y)
end

function map.cangetto(x1, y1, x2, y2)
  return env.mapTraceRay(x1, y1, x2, y2)
end

function map.getname()
  return env.mapGetName()
end

function map.change(name)
  env.formGame(name)
end

local function index(self, idx)
  if idx == "name" then
    return map.getname()
  else
    return rawget(self, idx)
  end
end
local function roerror(idx) error("Field '"..idx.."' is read-only.") end
local function newindex(self, idx, value)
  if idx == "name" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(map, {__index = index, __newindex = newindex})
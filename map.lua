--Map manipulation by IllidanS4
local map = {}
local env = require("env")
local err = require("errors")

function map.settile(x, y, tile, var, a, b)
  err.check("number", x, 1)
  err.check("number", y, 2)
  env.tileSet(x, y, {tile, var, a, b})
end

function map.gettile(x, y)
  err.check("number", x, 1)
  err.check("number", y, 2)
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
  err.check("number", x, 1)
  err.check("number", y, 2)
  return env.mapGet(x, y)
end

function map.setwall(tile, x, y, dir, flags, vari, unk3, hp)
  err.check("number", x, 1)
  err.check("number", y, 2)
  return env.mapSet(tile, x, y, dir, flags, vari, unk3, hp)
end

function map.wallinfo(wall)
  return env.mapInfo(wall)
end

function map.removewall(x, y)
  err.check("number", x, 1)
  err.check("number", y, 2)
  env.mapDel(x, y)
end

function map.cangetto(x1, y1, x2, y2)
  err.check("number", x1, 1)
  err.check("number", y1, 2)
  err.check("number", x2, 3)
  err.check("number", y2, 4)
  return env.mapTraceRay(x1, y1, x2, y2)
end

function map.getname()
  return env.mapGetName()
end

function map.change(name)
  err.check("string", name, 1)
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
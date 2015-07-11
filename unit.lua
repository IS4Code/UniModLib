--Unit manipulation library by IllidanS4
local unit = {}
local memory = require("memory")
local env = require("env")
local events = require("events")
local err = require("errors")

local unittables = {}

local function getunit(table)
  if type(table) == "table" then
    return table.data or table
  else
    return table
  end
end

local unitmt = {__index = unit, __tostring = function(self)return unit.gettype(self)end}
local function unittable(data)
  if type(data) == "userdata" then
    unittables[data] = unittables[data] or setmetatable({data = data}, unitmt)
    return unittables[data]
  else
    return data
  end
end


unit.getunit = unittable
unit.getdata = getunit

local function isunit(data)
  if type(data) == "userdata" then
    return true
  elseif type(data) == "table" then
    return getmetatable(data) == unitmt and isunit(data.data)
  end
  return false
end

local checker = err.checker(isunit, "unit")

unit.isunit = isunit
unit.checker = checker

function unit.create(name, x_or_unit, y)
  if type(x_or_unit) == "number" then
    return unittable(env.createObject(name, x_or_unit, y))
  elseif isunit(xorunit) then
    return unittable(env.createObjectIn(name, getunit(x_or_unit)))
  else
    return unittable(env.createObject(name, x_or_unit or 0/0, y or 0/0))
  end
end

function unit.getpos(data)
  err.check(checker, data, 1)
  return env.unitPos(getunit(data))
end

function unit.gethp(data)
  err.check(checker, data, 1)
  return env.bitAnd(env.unitHP(getunit(data)), 0xFFFF)
end

function unit.sethp(data, hp)
  err.check(checker, data, 1)
  err.check("number", hp, 2)
  env.unitHP(getunit(data), hp)
end

function unit.gettype(data)
  err.check(checker, data, 1)
  return env.getThingName(getunit(data))
end

function unit.freeze(data)
  err.check(checker, data, 1)
  env.unitFreeze(getunit(data))
end

function unit.unfreeze(data)
  err.check(checker, data, 1)
  env.unitUnFreeze(getunit(data))
end

function unit.getpos(data)
  err.check(checker, data, 1)
  return env.unitPos(getunit(data))
end

function unit.setpos(data, x, y)
  err.check(checker, data, 1)
  err.check("number", x, 2)
  err.check("number", y, 3)
  env.unitMove(getunit(data), x, y)
end

function unit.dropallitems(data)
  err.check(checker, data, 1)
  env.unitDropAll(getunit(data))
end

function unit.follow(data, data2)
  err.check(checker, data, 1)
  err.check(checker, data2, 2)
  env.unitSetFollow(getunit(data), getunit(data2))
end

function unit.setpet(data, data2)
  err.check(checker, data, 1)
  err.check(checker, data2, 2)
  env.unitBecomePet(getunit(data), getunit(data2))
end

function unit.sethunt(data)
  err.check(checker, data, 1)
  env.unitHunt(getunit(data))
end

function unit.delete(data)
  err.check(checker, data, 1)
  env.unitDelete(getunit(data))
end

function unit.getclass(data)
  err.check(checker, data, 1)
  return memory.getint(data, 0x08)
end

function unit.getsubclass(data)
  err.check(checker, data, 1)
  return memory.getint(data, 0x0C)
end

function unit.setclass(data, val)
  err.check(checker, data, 1)
  err.check("number", data, 2)
  return memory.setint(data, 0x08, val)
end

function unit.setsubclass(data, val)
  err.check(checker, data, 1)
  err.check("number", data, 2)
  return memory.setint(data, 0x0C, val)
end

function unit.getcontroller(data)
  err.check(checker, data, 1)
  return memory.getptr(data, 0x2EC)
end

function unit.asplayer(data)
  err.check(checker, data, 1)
  local player = require("player")
  return player.getplayer(getunit(data))
end

local createevents = events.newlist()
function unit.oncreate(callback)
  err.check("function", callback, 1)
  createevents:insert(callback)
end

function env.noxOnCreateAt(data, parent, x, y)
  events.invoke(createevents, unittable(data), unittable(parent), x, y)
end

--For events in form of (unit, callback(u1, u2, ...))
local function classicevent(data, callback, list, func)
  data = getunit(data)
  list[data] = list[data] or events.newlist()
  list[data]:insert(callback)
  
  local function fn(a, b, ...)func(data, fn) events.invoke(list[data], unittable(a), unittable(b), ...) end
  func(data, fn)
end

local useevents = {}
function unit.onuse(data, callback)
  err.check(checker, data, 1)
  err.check("function", callback, 2)
  classicevent(data, callback, useevents, env.unitOnUse)
end

local dieevents = {}
function unit.ondie(data, callback)
  err.check(checker, data, 1)
  err.check("function", callback, 2)
  classicevent(data, callback, dieevents, env.unitOnDie)
end

local collideevents = {}
function unit.oncollide(data, callback)
  err.check(checker, data, 1)
  err.check("function", callback, 2)
  classicevent(data, callback, collideevents, env.unitOnCollide)
end

local pickupevents = {}
function unit.onpickup(data, callback)
  err.check(checker, data, 1)
  err.check("function", callback, 2)
  classicevent(data, callback, pickupevents, env.unitOnPickup)
end

local dropevents = {}
function unit.ondrop(data, callback)
  err.check(checker, data, 1)
  err.check("function", callback, 2)
  classicevent(data, callback, dropevents, env.unitOnDrop)
end

return setmetatable(unit, {})
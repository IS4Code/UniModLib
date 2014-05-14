--Unit manipulation library by IllidanS4
local unit = {}
local memory = require("memory")
local env = require("env")
local events = require("events")

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
    return table.data
  end
  return false
end

function unit.create(name, xorunit, y)
  if type(xorunit) == "number" then
    return unittable(env.createObject(name, xorunit, y))
  elseif isunit(xorunit) then
    return unittable(env.createObjectIn(name, getunit(xorunit)))
  else
    return unittable(env.createObject(name, xorunit or 0/0, y or 0/0))
  end
end

function unit.getpos(data)
  return env.unitPos(getunit(data))
end

function unit.gethp(data)
  return env.bitAnd(env.unitHP(getunit(data)), 0xFFFF)
end

function unit.sethp(data, hp)
  env.unitHP(getunit(data), hp)
end

function unit.gettype(data)
  return env.getThingName(getunit(data))
end

function unit.freeze(data)
  env.unitFreeze(getunit(data))
end

function unit.unfreeze(data)
  env.unitUnFreeze(getunit(data))
end

function unit.getpos(data)
  return env.unitPos(getunit(data))
end

function unit.setpos(data, x, y)
  env.unitMove(getunit(data), x, y)
end

function unit.dropallitems(data)
  env.unitDropAll(getunit(data))
end

function unit.follow(data, data2)
  env.unitSetFollow(getunit(data), getunit(data2))
end

function unit.setpet(data, data2)
  env.unitBecomePet(getunit(data), getunit(data2))
end

function unit.sethunt(data)
  env.unitHunt(getunit(data))
end

function unit.delete(data)
  env.unitDelete(getunit(data))
end

function unit.asplayer(data)
  local player = require("player")
  return player.getplayer(getunit(data))
end

local createevents = events.newlist()
function unit.oncreate(callback)
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
  
  local function fn(a, b, ...)func(data, fn) events.invoke(useevents[data], unittable(a), unittable(b), ...) end
  func(data, fn)
end

local useevents = {}
function unit.onuse(data, callback)
  classicevent(data, callback, useevents, env.unitOnUse)
end

local dieevents = {}
function unit.ondie(data, callback)
  classicevent(data, callback, dieevents, env.unitOnDie)
end

local collideevents = {}
function unit.oncollide(data, callback)
  classicevent(data, callback, collideevents, env.unitOnCollide)
end

local pickupevents = {}
function unit.onpickup(data, callback)
  classicevent(data, callback, pickupevents, env.unitOnPickup)
end

local dropevents = {}
function unit.ondrop(data, callback)
  classicevent(data, callback, dropevents, env.unitOnDrop)
end

return setmetatable(unit, {})
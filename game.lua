--Global game functions by IllidanS4
local game = {}
local env = require("env")
local events = require("events")

function game.getflags()
  return env.gameFlags()
end

function game.getframes()
  return env.getFrameCounter()
end

function game.getmouse()
  return env.cliPlayerMouse()
end

function game.getscreenpos()
  return env.screenGetPos()
end

function game.getscreensize()
  return env.screenGetSize()
end

function game.setflags(flags)
  env.gameFlags(flags)
end

local printevents = events.newlist()
function game.onconsole(callback)
  printevents:insert(callback)
end

function env.onConPrint(...)
  events.invoke(printevents, ...)
end

local function index(self, idx)
  if idx == "flags" then
    return game.getflags()
  elseif idx == "frames" then
    return game.getframes()
  elseif idx == "mouse" then
    return {game.getmouse()}
  elseif idx == "screenpos" then
    return {game.getscreenpos()}
  elseif idx == "screensize" then
    return {game.getscreensize()}
  else
    return rawget(self, idx)
  end
end
local function roerror(idx) error("Field '"..idx.."' is read-only.") end
local function newindex(self, idx, value)
  if idx == "flags" then
    game.setflags(value)
  elseif idx == "frames" then
    roerror(idx)
  elseif idx == "mouse" then
    roerror(idx)
  elseif idx == "screenpos" then
    roerror(idx)
  elseif idx == "screensize" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(game, {__index = index, __newindex = newindex})
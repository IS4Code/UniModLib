--Global game functions by IllidanS4
local game = {}
local env = require("env")
local events = require("events")
local memory = require("memory")
local err = require("errors")

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
  return env.gameFlags(flags)
end

function game.exec(command)
  err.check("string", command, "exec", 1)
  return env.conExec(command)
end

function game.gethost()
  return memory.getptr(memory.call(0x417090, memory.storeint(31), memory.storeint(1)), 0x808)
end

local printevents = events.newlist()
function game.onconsole(callback)
  printevents:insert(callback)
end

function env.onConPrint(text, color)
  events.invoke(printevents, text:gsub("^(.-)\n*$", "%1"), color)
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
  elseif idx == "host" then
    return game.gethost()
  else
    return rawget(self, idx)
  end
end
local function roerror(idx) err.readonly(idx, "game") end
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
  elseif idx == "host" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(game, {__index = index, __newindex = newindex})
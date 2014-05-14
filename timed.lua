--Timing library by IllidanS4
local timed = {}
local env = require("env")
local utils = require("utils")

local st = env.setTimeout or env.cliSetTimeout
local timeouts = {}

--Runs a function after time in ticks.
function timed.settimeout(func, time, ...)
  local key = utils.genkey()
  local t = {...}
  local f = function(tim)if timeouts[key] then func(unpack(t)) end end
  timeouts[key] = true
  st(f, time)
  return key
end

--Runs a function periodically after time in ticks.
function timed.setinterval(func, time, ...)
  local key = utils.genkey()
  local t = {...}
  local f
  f = function(tim)if timeouts[key] then func(unpack(t)) st(f, time) end end
  timeouts[key] = true
  st(f, time)
  return key
end

--Stops a timeout from running.
function timed.cleartimeout(timeout)
  timeouts[timeout] = false
end

--Stops an interval from running.
timed.clearinterval = timed.cleartimeout

local function sleep(time)
  coroutine.yield(sleep, time)
end

local function coresume(co)
  if coroutine.status(co) == "suspended" then
    local running, type, arg = coroutine.resume(co)
    if running and type then
      if type == sleep then
        timed.settimeout(coresume, arg, co)
      end
    end
  end
end

--Runs task with sleep support as task(sleepfunc, ...)
function timed.runtask(task, ...)
  local t = {...}
  local co = coroutine.create(function()task(sleep, unpack(t))end)
  coresume(co)
  return co
end

return timed
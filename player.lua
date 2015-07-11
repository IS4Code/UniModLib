--Player library by IllidanS4
local player = {}
local memory = require("memory")
local env = require("env")
local events = require("events")
local unit = require("unit")
local game = require("game")
local err = require("errors")

local plrmt = {__index = function(self, idx) return rawget(player, idx) or rawget(unit, idx) end, __tostring = function(self)return player.getname(self)end}
local function plrtable(plr)
  if type(plr) == "userdata" then
    return setmetatable(unit.getunit(plr), plrmt)
  else
    return plr
  end
end

local function isplayer(plr)
  if type(data) == "userdata" then
    return unit.isunit(plr) and env.playerScore(plr) ~= nil
  elseif type(data) == "table" then
    return getmetatable(plr) == plrmt and isplayer(plr.data)
  end
  return false
end

local checker = err.checker(isplayer, "player")

player.isplayer = isplayer
player.checker = checker

player.getplayer = plrtable
player.getdata = unit.getdata

function player.getbyname(name)
  return plrtable(env.playerGetByName(name))
end

function player.getbyid(id)
  return plrtable(env.playerList()[id])
end

function player.getbywol(wol)
  return plrtable(env.playerGetByWOL(wol))
end

function player.getbylogin(login)
  return plrtable(env.playerGetByLogin(login))
end

function player.getscore(data)
  err.check(checker, data, 1)
  return env.playerScore(player.getdata(data))
end

function player.setscore(data, score)
  err.check(checker, data, 1)
  err.check("number", score, 2)
  env.playerScore(player.getdata(data), score)
end

function player.lookat(plr, obj)
  err.check(checker, plr, 1)
  err.check(unit.checker, obj, 2)
  env.playerLook(player.getdata(plr), unit.getdata(obj))
end

function player.setteam(plr, team)
  err.check(checker, plr, 1)
  local team = require("team")
  err.check(team.checker, team, 2)
  env.teamAssign({team=team.getdata(team), player = player.getdata(plr)})
end

local function plrinfo(plr, field)
  local info = env.playerInfo(player.getdata(plr))
  return info[field]
end

function player.getteam(plr)
  err.check(checker, plr, 1)
  local team = require("team")
  return team.getteam(plrinfo(plr, "teamId"))
end

function player.getping(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "ping")
end

function player.isobserver(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "isObserver")
end

function player.getname(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "name")
end

function player.getwol(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "wol")
end

function player.getid(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "idx")
end

function player.getip(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "ip")
end

function player.getclass(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "className")
end

function player.getnetcode(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "netcode")
end

function player.getlogin(plr)
  err.check(checker, plr, 1)
  return plrinfo(plr, "login")
end

function player.kick(plr)
  err.check(checker, plr, 1)
  playerKickUdata(player.getdata(plr))
end

function player.ban(plr)
  err.check(checker, plr, 1)
  local name = player.getname(plr)
  game.exec('ban "'..name..'"')
end

local function classicevent(callback, list, event, func)
  list:insert(callback)
  env[event] = func or function(player, ...)
    events.invoke(list, plrtable(player), ...)
  end
end

local joinevents = events.newlist()
function player.onjoin(callback)
  err.check("function", callback, 1)
  classicevent(callback, joinevents, "playerOnJoin")
end

local leaveobsevents = events.newlist()
function player.onleaveobserver(callback)
  err.check("function", callback, 1)
  classicevent(callback, leaveobsevents, "playerOnLeaveObs")
end

local goobsevents = events.newlist()
function player.ongoobserver(callback)
  err.check("function", callback, 1)
  classicevent(callback, goobsevents, "playerOnGoObs")
end

local dieevents = events.newlist()
function player.ondie(callback)
  err.check("function", callback, 1)
  classicevent(callback, dieevents, "playerOnDie")
end

local leaveevents = events.newlist()
function player.onleave(callback)
  err.check("function", callback, 1)
  classicevent(callback, leaveevents, "playerOnleave")
end

local inputevents = {}
function player.oninput(plr, callback)
  err.check(checker, plr, 1)
  err.check("function", callback, 2)
  plr = player.getdata(plr)
  inputevents[plr] = inputevents[plr] or events.newlist()
  inputevents[plr]:insert(callback)
  env.playerOnInput = env.playerOnInput or {}
  env.playerOnInput[plr] = function(plr2, code, target) events.invoke(inputevents[plr], plrtable(plr2), code, unit.getunit(target)) end
end

local chatevents = events.newlist()
local function onconsole(text, color)
  if color == 15 then --yellow
    for plr,msg in text:gmatch("(.-)>%s*(.*)") do
      print(plr, msg)
      events.invoke(chatevents, player.getbyname(name), msg)
    end
  end
end

function player.onchat(callback)
  err.check("function", callback, 1)
  local game = require("game")
  chatevents:insert(callback)
  if onconsole then
    game.onconsole(onconsole)
    onconsole = nil
  end
end

local spawnevents = events.newlist()
local function ondie(plr)
  local timed = require("timed")
  local int
  int = timed.setinterval(function()
    if plr:gethp() > 0 then
      timed.clearinterval(int)
      events.invoke(spawnevents, plr)
    end
  end, 10)
end
function player.onspawn(callback)
  err.check("function", callback, 1)
  spawnevents:insert(callback)
  if ondie then
    player.ondie(ondie)
    ondie = nil
  end
end

function player.getlist()
  local list = env.playerList()
  for i,v in ipairs(list) do
    list[i] = plrtable(v)
  end
  return list
end

local function index(self, idx)
  if idx == "list" then
    return player.getlist()
  else
    return rawget(self, idx) or unit[idx]
  end
end
local function roerror(idx) err.readonly(idx, "player") end
local function newindex(self, idx, value)
  if idx == "list" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(player, {__index = index, __newindex = newindex})
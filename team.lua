--Team functions by IllidanS4.
local team = {}
local memory = require("memory")
local env = require("env")
local err = require("errors")

local teamtables = {}

local function getteam(table)
  if type(table) == "table" then
    return table.data or table
  else
    return table
  end
end

local function teaminfo(team, field)
  local info = env.teamGet(getteam(team), true)
  return info[field]
end

local teammt = {__index = team, __tostring = function(self)return team.getname(self)end}
local function teamtable(data)
  print(data)
  if type(data) == "userdata" then
    teamtables[data] = teamtables[data] or setmetatable({data = data}, teammt)
    return teamtables[data]
  elseif type(data) == "number" then
    local tem = teaminfo(data, "teamPtr")
    return teamtable(tem)
  else
    return data
  end
end

local function isteam(data)
  if type(data) == "userdata" then
    return env.teamGet(data, true) ~= nil
  elseif type(data) == "table" then
    return getmetatable(data) == teammt and isteam(data.data)
  end
  return false
end

local checker = err.checker(isteam, "team")

team.isteam = isteam
team.checker = checker

team.getteam = teamtable
team.getdata = getteam
setmetatable(team, {__call=teamtable})

local function isteam(data)
  if type(data) == "userdata" then
    return true
  elseif type(data) == "table" then
    return table.data
  end
  return false
end

function team.autoassign()
  env.teamAutoAssign()
end

function team.createdefault()
  return teamtable(env.teamCreateDefault())
end

function team.create(id, name, color)
  err.check("number", id, 1)
  err.check("string", name, 2)
  err.check("number", color, 3)
  return teamtable(env.teamCreate({name=name, TeamId=id, color=color}))
end

function team.delete(team)
  err.check(checker, team, 1)
  env.teamDelete(getteam(team))
end

function team.getscore(team)
  err.check(checker, team, 1)
  return teaminfo(team, "score")
end

function team.getcolor(team)
  err.check(checker, team, 1)
  return teaminfo(team, "color")
end

function team.getname(team)
  err.check(checker, team, 1)
  return teaminfo(team, "name")
end

function team.getmemberscount(team)
  err.check(checker, team, 1)
  return teaminfo(team, "membersCount")
end

function team.getid(team)
  err.check(checker, team, 1)
  return teaminfo(team, "id")
end

function team.getflag(team)
  err.check(checker, team, 1)
  local unit = require("unit")
  return unit.getunit(teaminfo(team, "flagPtr"))
end

function team.getplayers(team)
  err.check(checker, team, 1)
  local plrs = {}
  local player = require("player")
  for i,plr in ipairs(player.list) do
    local tem = plr:getteam()
    if getteam(tem) == getteam(team) then
      table.insert(plrs, plr)
    end
  end
  return plrs
end

function team.getlist()
  local list = env.teamGet()
  for i,v in ipairs(list) do
    list[i] = teamtable(v.id)
  end
  return list
end

local function index(self, idx)
  if idx == "list" then
    return team.getlist()
  else
    return rawget(self, idx)
  end
end
local function roerror(idx) err.readonly(idx, "team") end
local function newindex(self, idx, value)
  if idx == "list" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(team, {__index = index, __newindex = newindex})
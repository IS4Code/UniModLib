--Team functions by IllidanS4.
local team = {}
local memory = require("memory")
local env = require("env")

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
  return teamtable(env.teamCreate({name=name, TeamId=id, color=color}))
end

function team.delete(team)
  env.teamDelete(getteam(team))
end

function team.getscore(team)
  return teaminfo(team, "score")
end

function team.getcolor(team)
  return teaminfo(team, "color")
end

function team.getname(team)
  return teaminfo(team, "name")
end

function team.getmemberscount(team)
  return teaminfo(team, "membersCount")
end

function team.getid(team)
  return teaminfo(team, "id")
end

function team.getflag(team)
  return teaminfo(team, "flagPtr")
end

function team.getplayers(team)
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
local function roerror(idx) error("Field '"..idx.."' is read-only.") end
local function newindex(self, idx, value)
  if idx == "list" then
    roerror(idx)
  else
    rawset(self, idx, value)
  end
end

return setmetatable(team, {__index = index, __newindex = newindex})
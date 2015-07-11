--NPC tools by IllidanS4
--Pointers by KirConjurer
local npc = {}
local unit = require("unit")
local memory = require("memory")
local game = require("game")
local err = require("errors")

local function isnpc(obj)
  return unit.isunit(obj) and unit.gettype(obj) == "NPC"
end

local checker = err.checker(isnpc, "npc")

function npc.create(...)
  return unit.create("NPC", ...)
end

--Creates an NPC and passes it to the 'func' initializator
function npc.init(func, ...)
  local obj = npc.create(...)
  if not obj then return end
  if not pcall(function()func(obj)end) then
    unit.delete(obj)
  else
    return obj
  end
end

local coloridcs = {hair = 0, skin = 5}

function npc.setcolor(obj, idx, r, g, b)
  err.check(checker, obj, 1)
  err.check("string", idx, 2)
  err.check("number", r, 3)
  err.check("number", g, 4)
  err.check("number", b, 5)
  local uc = unit.getcontroller(obj)
  idx = coloridcs[idx]
  local offset = 2 * (idx + 0x2B4) + idx + 0x2B4
  memory.setbyte(uc, offset, r)
  memory.setbyte(uc, offset+1, g)
  memory.setbyte(uc, offset+2, b)
end

function npc.getcolor(obj, idx)
  err.check(checker, obj, 1)
  err.check("string", idx, 2)
  local uc = unit.getcontroller(obj)
  idx = coloridcs[idx] or idx
  local offset = 2 * (idx + 0x2B4) + idx + 0x2B4
  return memory.getbyte(uc, offset, r), memory.getbyte(uc, offset+1, g), memory.getbyte(uc, offset+2, b)
end

function npc.setclass(obj, c1, c2)
  err.check(checker, obj, 1)
  err.check("number", c1, 2)
  err.check("number", c2, 3)
  local uc = unit.getcontroller(obj)
  memory.setbyte(uc, 0x534, c1)
  memory.setshort(uc, 0x5A0, c2)
end

function npc.getclass(obj)
  err.check(checker, obj, 1)
  local uc = unit.getcontroller(obj)
  return memory.getbyte(uc, 0x534), memory.getshort(uc, 0x5A0)
end

function npc.equipweapon(obj, item)
  err.check(checker, obj, 1)
  err.check(unit.checker, item, 2)
  return memory.call(0x53A2C0, unit.getdata(obj), unit.getdata(item))
end

function npc.equiparmor(obj, item)
  err.check(checker, obj, 1)
  err.check(unit.checker, item, 2)
  return memory.call(0x53E520, unit.getdata(obj), unit.getdata(item))
end

local voicecache = {}
function npc.setvoice(obj, voice)
  err.check(checker, obj, 1)
  err.check("string", voice, 2)
  local sp = voicecache[voice] or memory.storestring(voice)
  voicecache[voice] = sp
  local n = memory.call(0x424350, sp, sp)
  if n then
    return memory.call(0x424320, unit.getdata(obj), n)
  end
end

function npc.setstrength(obj, strength)
  err.check(checker, obj, 1)
  err.check("number", strength, 2)
  local uc = unit.getcontroller(obj)
  memory.setbyte(uc, 0x52C, strength)
  return
end

function npc.setmaxhp(obj, hp)
  err.check(checker, obj, 1)
  err.check("number", hp, 2)
  local hd = memory.getptr(unit.getdata(obj), 0x22C)
  memory.setshort(hd, 0, hp)
  memory.setshort(hd, 2, hp)
  memory.setshort(hd, 4, hp)
end

function npc.setrange(obj, range)
  err.check(checker, obj, 1)
  err.check("number", range, 2)
  local uc = unit.getcontroller(obj)
  memory.setfloat(uc, 0x520, val)
end

function npc.update(obj)
  err.check(checker, obj, 1)
  local host = game.gethost()
  if host then
    memory.call(0x4D93A0, host, unit.getdata(obj))
  end
end

return npc
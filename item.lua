--Item tools by IllidanS4
local item = {}
local unit = require("unit")
local memory = require("memory")
local err = require("errors")

function item.create(type, ...)
  return unit.create(type, ...)
end

function item.gold(amount, ...)
  local itm = item.create("Gold", ...)
  if not itm then return end
  local data = unit.getdata(itm)
  local p = memory.getptr(data, 0x2B4)
  memory.setint(p, 0, amount)
  return itm
end

function item.spellbook(spellN, ...)
  local itm = item.create("SpellBook", ...)
  if not itm then return end
  local data = unit.getdata(itm)
  local t = memory.getptr(data, 0x2E0)
  memory.setint(t, 0, memory.getint(t, 0)+spellN)
  return itm
end

return item
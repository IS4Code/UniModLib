--Events tools by IllidanS4
local events = {}
local table = require("table")

function events.invoke(eventlist, ...)
  if eventlist then
    for i,v in ipairs(eventlist) do
      v(...)
    end
  end
end

local evntmt = {
  __index = {insert = table.insert, remove = function(self, elem) for i,v in ipairs(self) do if v == elem then table.remove(self, i) end end end},
  __call = events.invoke
}

function events.newlist()
  return setmetatable({}, evntmt)
end

function events.control(list)
  return {add = function(callback) list:insert(callback) end, remove = function(callback) list:remove(callback) end}
end

return events
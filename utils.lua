--Basic utilities by IllidanS4
local utils = {}

local keymt = {__index = function()end, __newindex = function()end, __metatable = function()end}
function utils.genkey()
  --return setmetatable({}, keymt)
  return newproxy(false)
end

return utils
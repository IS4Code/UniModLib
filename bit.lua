--Bitwise operations by IllidanS4
local bit = {}
local env = require("env")
local memory = require("memory")

bit.And = env.bitAnd
bit.Or = env.bitOr
bit.Xor = env.bitXor
bit["and"] = bit.And
bit["or"] = bit.Or
bit["xor"] = bit.Xor

local function tobytes(type, ...)
  local ptr, size = memory["store"..type](...)
  local bytes = memory.getbytes(ptr, size)
  memory.free(ptr)
  return bytes
end

function bit.bytetobytes(...)
  return {...}
end

function bit.shorttobytes(...)
  return tobytes("short", ...)
end

function bit.inttobytes(...)
  return tobytes("int", ...)
end

function bit.floattobytes(...)
  return tobytes("float", ...)
end

function bit.ptrtobytes(...)
  return tobytes("ptr", ...)
end

function bit.stringtobytes(...)
  local bytes = {}
  for i,v in ipairs(arg) do
    for j = 1, #v do
      table.insert(bytes, v:byte(j))
    end
    table.insert(bytes, 0)
  end
  return bytes
end
  
return bit
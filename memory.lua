--Memory management by IllidanS4
local memory = {}
local env = require("env")

--Allocates a block of memory of size 'size'.
memory.alloc = env.memAlloc --function(size)
--Frees a block of memory on address of 'ptr'.
memory.free = function()end--env.memFree --function(ptr)
--Returns a byte value of an address specified by a pointer 'ptr' and an 'offset'.
memory.getbyte = env.getPtrByte --function(ptr, offset)
memory.setbyte = env.setPtrByte --function(ptr, offset, value)
memory.getshort = env.getPtrShort --function(ptr, offset)
memory.setshort = env.setPtrShort --function(ptr, offset, value)
memory.getint = env.getPtrInt --function(ptr, offset)
memory.setint = env.setPtrInt --function(ptr, offset, value)
memory.getfloat = env.getPtrFloat --function(ptr, offset)
memory.setfloat = env.setPtrFloat --function(ptr, offset, value)
memory.getptr = env.getPtrPtr --function(ptr, offset)
memory.setptr = env.setPtrPtr --function(ptr, offset, value)
memory.sizes = {byte=1,short=2,int=4,float=4,ptr=4}

--Returns a block of memory in a form of a table of bytes
function memory.getbytes(ptr, size)
  local bytes = {}
  for i = 1, size do
    bytes[i] = memory.getbyte(ptr, i-1)
  end
  return bytes
end

function memory.setbytes(ptr, bytes)
  for i = 1, #bytes do
    memory.setbyte(ptr, i-1, bytes[i])
  end
end

local function store(type, ...)
  local unitsize = memory.sizes[type]
  local size = unitsize*#arg
  local ptr = memory.alloc(size)
  for i,v in ipairs(arg) do
    memory["set"..type](ptr, unitsize*(i-1), arg[i])
  end
  return ptr, size
end

function memory.storebyte(...) --function(byte1, byte2, byte3, ...)
  return store("byte", ...)
end

function memory.storeshort(...)
  return store("short", ...)
end

function memory.storeint(...)
  return store("int", ...)
end

function memory.storefloat(...)
  return store("float", ...)
end

function memory.storeptr(...)
  return store("ptr", ...)
end

function memory.storestring(...)
  local size = 0
  for i,v in ipairs(arg) do
    size = size + #v + 1
  end
  local ptr = memory.alloc(size)
  local offset = 0
  for i,v in ipairs(arg) do
    for j = 1, #v do
      memory.setbyte(ptr, offset+j-1, v:byte(j))
    end
    offset = offset + #v + 1
    memory.setbyte(ptr, offset-1, 0)
  end
  return ptr, size
end

--Calls a specified function, passing a pointer as the first argument, stores the result, frees the pointer, and then returns the result
function memory.callandfree(func, ptr, ...)
  local res = func(ptr, ...)
  memory.free(ptr)
  return res
end

return memory
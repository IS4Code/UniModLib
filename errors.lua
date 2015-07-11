--Functions for automated error messages by IllidanS4
local err = {}
local debug = require("debug")

local function getname()
  for i = 3, math.huge do
    local info = debug.getinfo(i, "nf")
    if info.func ~= getname and info.func ~= err.type and info.func ~= err.typecheck and info.func ~= err.readonly then
      return info.name
    end
  end
end

function err.type(expected, got, func, index)
  if type(func) == "number" and not index then
    index = func
    func = getname()
  end
  error("bad argument #"..index.." to '"..func.."' ("..expected.." expected, got "..got..")")
end

function err.typecheck(check, arg, ...)
  if type(check) == "string" then
    local t = type(arg)
    if t ~= check then
      error(getname())
      return err.type(check, t, ...)
    end
  elseif type(check) == "function" then
    local ok, expected, got = check(arg)
    if not ok then
      return err.type(expected, got, ...)
    end
  else
    return err.type("string or function", type(check), "typecheck", 1)
  end
end

function err.checker(test, typename, namefunc)
  namefunc = namefunc or type
  return function(data)
    if test(data) then
      return true, typename, typename
    else
      return false, typename, namefunc(data)
    end
  end
end

err.check = err.typecheck

function err.readonly(field, table)
  error("field '"..field.."' of '"..table.."' is read-only")
end

return err
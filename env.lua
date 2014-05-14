--Global environment library by IllidanS4.
--Used to retrieve externally global functions in the require(...) scope.
--env.unitHP should return a function, as _G.unitHP doesn't.
local env = {}
local debug = require("debug")

local reg = debug.getregistry() or {}
local server = reg.server or {}
local client = reg.client or {}

local function trace(idx)
  local i = 1
  while true do
    local ex, env = pcall(getfenv, i)
    if ex then
      if env[idx] then
        self[idx] = env[idx]
        return env[idx]
      end
    else
      return
    end
    i = i+1
  end
end

setmetatable(env, {
  __index = function(self, idx)
    local value = _G[idx] or server[idx] or client[idx] or trace(idx)
    --rawset(self, idx, value)
    return value
  end,
  __newindex = function(self, idx, value)
    --rawset(self, idx, value)
    _G[idx] = value
  end
})
return env
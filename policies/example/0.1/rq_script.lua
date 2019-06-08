local setmetatable = setmetatable

local _M = require('apicast.policy').new('Gen UUID', '0.1')
local mt = { __index = _M }

function _M.new()
  return setmetatable({}, mt)
end

function _M:rewrite()
  -- change the request before it reaches upstream
  local config = configuration or {}
  local set_header = config.set_header or {}
  
  local random = math.random
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local rq_uuid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v) end)
  
  ngx.req.set_header('x-request-id', rq_uuid)
end


return _M

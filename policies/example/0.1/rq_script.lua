local setmetatable = setmetatable

local _M = require('apicast.policy').new('Gen UUID', '0.1')
local mt = { __index = _M }

function _M.new()
  local config = configuration or {}
  local set_header = config.set_header or {}
  ngx.log(ngx.NOTICE, 'Gen UUID');
  local random = math.random
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local rq_uuid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v) end)
  
  ngx.log(ngx.NOTICE, 'setting header: x-request-id : ', rq_uuid)
  ngx.log(0, ngx.req.raw_header())
  -- ngx.log(0, resp)
  --ngx.log(ngx.NOTICE, 'req_body: ', ngx.var.request_body, ' rq_uuid : ', rq_uuid)
  ngx.req.set_header('x-request-uid', rq_uuid)
  return setmetatable({}, mt)
end

return _M

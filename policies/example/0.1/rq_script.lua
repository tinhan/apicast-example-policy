local setmetatable = setmetatable

local _M = require('apicast.policy').new('Gen UUID', '0.1')
local mt = { __index = _M }

function _M.new()
  local config = configuration or {}
  local set_header = config.set_header or {}
  local random = math.random
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local rq_uuid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v) end)
  
  ngx.req.set_header('x-request-uid', rq_uuid)
  ngx.log(0, 'setting header: x-request-id : ', rq_uuid)
  ngx.log(0, ngx.req.get_headers(), 'req_body: ', ngx.var.request_body)
  --ngx.log(0, 'req_body: ', ngx.var.request_body, ' rq_uuid : ', rq_uuid)
  return setmetatable({}, mt)
end

function _M:post_action()
  -- do something after the response was sent to the client
  ngx.log(0, ngx.resp.get_headers(), 'res_body: ', ngx.var.response_body)
  -- ngx.log(0, 'req_body: ', ngx.var.response_body)
end

return _M

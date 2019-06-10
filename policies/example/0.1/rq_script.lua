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
  
  ngx.req.set_header('x-request-id', rq_uuid)
  ngx.log(0, 'setting header: x-request-id : ', rq_uuid)
  ngx.log(0, req.raw_header())
  ngx.log(0, 'req_body: ', ngx.var.request_body, 'x-request-id : ', rq_uuid)
  return setmetatable({}, mt)
end

function _M:body_filter()
    local resp = ""
    ngx.ctx.buffered = (ngx.ctx.buffered or "") .. string.sub(ngx.arg[1], 1, 1000)
    if ngx.arg[2] then
      resp = ngx.ctx.buffered
    end

    ngx.log(0, ngx.req.raw_header())
    ngx.log(0, resp)
  
end



return _M

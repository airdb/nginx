local uuid = require "resty.lib.jit-uuid"

request_id = uuid.generate_v4()

ngx.say("request_id", request_id)
--[[
local redis = require "resty.redis"
local red = redis:new()
red:set_timeouts(1000, 1000, 1000)


local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end


ok, err = red:set("dog", "an animal")
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end
--]]

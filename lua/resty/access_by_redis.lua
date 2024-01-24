# Lua
local function close_redis(red)
    if not red then
        return
    end
    --释放连接(连接池实现)
    local pool_max_idle_time = 10000 --毫秒
    local pool_size = 100 --连接池大小
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)

    if not ok then
        ngx_log(ngx_ERR, "set redis keepalive error : ", err)
    end
end

-- 连接redis
local redis = require('resty.redis')
local red = redis.new()
red:set_timeout(1000)

local ip = "127.0.0.1"  ---修改变量
local port = "6379" ---修改变量
local ok, err = red:connect(ip,port)
if not ok then
    return close_redis(red)
end
red:auth('passwd')
--resp = redis_init:set('funet', '888888')
--resp = redis_init:get('funet')




local clientIP = ngx.req.get_headers()["X-Real-IP"]
if clientIP == nil then
   clientIP = ngx.req.get_headers()["x_forwarded_for"]
end
if clientIP == nil then
   clientIP = ngx.var.remote_addr
end

--ngx.say(clientIP)

--if clientIP == "101.231.137.70" then
--    ngx.exit(ngx.HTTP_FORBIDDEN)
--       return close_redis(red)
--    end

local incrKey = "user:"..clientIP..":freq"
local blockKey = "user:"..clientIP..":block"

local is_block,err = red:get(blockKey) -- check if ip is blocked
--ngx.say(tonumber(is_block))
if tonumber(is_block) == 1 then
    --ngx.say(3)
    ngx.exit(403)
    --ngx.exit(ngx.HTTP_FORBIDDEN)
    close_redis(red)
end

inc  = red:incr(incrKey)


ngx.say(inc)

if inc < 2 then
   inc = red:expire(incrKey,1)
end

if inc > 2 then --每秒2次以上访问即视为非法，会阻止1分钟的访问
    red:set(blockKey,1) --设置block 为 True 为1
    red:expire(blockKey,60)
end

close_redis(red)

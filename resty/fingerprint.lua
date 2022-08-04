resp = {}

resp.http_ssl_ja3 = ngx.var.http_ssl_ja3
resp.http_ssl_ja3_hash = ngx.var.http_ssl_ja3_hash
resp.http_ssl_greased = ngx.var.http_ssl_greased
resp.user_agent = ngx.var.http_user_agent
resp.remote_addr = ngx.var.remote_addr
resp.http2_fingerprint = ngx.var.http2_fingerprint
resp.http2_fingerprint =  "http2_fingerprint"
resp.request_id = request_id

local loc = ipdb:find(ngx.var.remote_addr, "EN");
resp.ipip = loc


--[[
 local loc = ipdb:find("8.8.8.8", "EN");
ngx.say(loc.idc);
ngx.say(cjson.encode(loc));
--]]

ngx.say(cjson.encode(resp));
--[[
--]]
--
--
--
--
-- ngx.say(conf['database']['user'])

-- Init mysql client
local mysql = require "resty.lib.mysql"
db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end

db:set_timeout(5000) -- 1 sec

local ok, err, errcode, sqlstate = db:connect{
    host = conf['database']['host'],
    port = conf['database']['port'],
    database = conf['database']['db_name'],
    user = conf['database']['user'],
    password = conf['database']['password'],
    charset = "utf8",
    max_packet_size = 1024 * 1024,
}

if not ok then
    ngx.say("failed to connect database: ", err, ": ", errcode, " ", sqlstate)
    return
end



-- local res, err, errno, sqlstate = db:connect(props)


-- insert
local insert_sql = "insert into tab_ssl_fingerprint (created_at, updated_at, client_ip, fp_http2, fp_ja3, fp_ja3_hash, user_agent) values(now(), now(),'"..resp.remote_addr.."', '"..resp.http2_fingerprint.."', '"..resp.http_ssl_ja3.."', '"..resp.http_ssl_ja3_hash.."', '"..resp.user_agent.."')"

res, err, errno, sqlstate = db:query(insert_sql)
-- ngx.say(insert_sql)
-- ngx.say(err)




-- inifile = require 'resty.lib.ini'
-- 
-- conf, err = inifile.parse_file('resty/resty.ini')
-- if not conf then
--   ngx.say("failed to parse file resty.ini: ", err)
--   return
-- end
-- 
-- ngx.say(conf['database']['user'])
--



-- local redis = require "resty.redis"
-- local red = redis:new()
-- red:set_timeouts(1000, 1000, 1000)
-- 
-- 
-- local ok, err = red:connect("127.0.0.1", 6379)
-- if not ok then
--     ngx.say("failed to connect: ", err)
--     return
-- end
-- 
-- 
-- ok, err = red:set(ngx.var.remote_addr, cjson.encode(resp))
-- if not ok then
--     ngx.say("failed to set dog: ", err)
--     return
-- end

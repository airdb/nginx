print("log from init_by_lua_file")

-- local city = require("resty.ipdb.city")
-- ipdb = city:new("/srv/nginx/ipv4_en.ipdb")
-- cjson = require("cjson")
-- 
-- 
-- -- Init config.
-- inifile = require 'resty.lib.ini'
-- 
-- conf, err = inifile.parse_file('resty/resty.ini')
-- if not conf then
--   ngx.say("failed to parse file resty.ini: ", err)
--   return
-- end

-- ngx.say(conf['database']['user'])

-- Init mysql client
-- local mysql = require "resty.lib.mysql"
-- db, err = mysql:new()
-- if not db then
--     ngx.say("failed to instantiate mysql: ", err)
--     return
-- end
-- 
-- db:set_timeout(5000) -- 1 sec
-- 
-- local ok, err, errcode, sqlstate = db:connect{
--     host = conf['database']['host'],
--     port = conf['database']['port'],
--     database = conf['database']['database'],
--     user = conf['database']['user'],
--     password = conf['database']['password'],
--     charset = "utf8",
--     max_packet_size = 1024 * 1024,
-- }
-- 
-- if not ok then
--     ngx.say("failed to connect database: ", err, ": ", errcode, " ", sqlstate)
--     return
-- end



--[[
local redis = require 'redis'
local redisClient = redis.connect('127.0.0.1', 6379)
local response = client:ping()


local city = require("resty.ipdb.city")
ipdb = city:new("/home/frk/city.free.ipdb")
cjson = require("cjson")
--]]

print("log from init_by_lua_file")

-- local uuid = require "lib.jit-uuid"

-- request_id = uuid.generate_v4()



local city = require("resty.ipdb.city")
ipdb = city:new("/srv/nginx/ipv4_en.ipdb")
cjson = require("cjson")

--[[
local redis = require 'redis'
local redisClient = redis.connect('127.0.0.1', 6379)
local response = client:ping()


local city = require("resty.ipdb.city")
ipdb = city:new("/home/frk/city.free.ipdb")
cjson = require("cjson")
--]]

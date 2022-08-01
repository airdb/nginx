print("log from init_by_lua_file")

--[[
local redis = require 'redis'
local redisClient = redis.connect('127.0.0.1', 6379)
local response = client:ping()


local city = require("resty.ipdb.city")
ipdb = city:new("/home/frk/city.free.ipdb")
cjson = require("cjson")
--]]

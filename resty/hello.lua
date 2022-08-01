ngx.say(ngx.var.http_user_agent)
ngx.say(ngx.var.http_ssl_ja3)
ngx.say(ngx.var.http_ssl_ja3_hash)
ngx.say(ngx.var.http_ssl_greased)


local city = require("resty.ipdb.city")
ipdb = city:new("/srv/nginx/ipv4_en.ipdb")
cjson = require("cjson")


cip = ngx.var.remote_addr
ngx.say(cip)
local loc = ipdb:find(cip, "EN");

--[[
 local loc = ipdb:find("8.8.8.8", "EN");
--]]

ngx.say(loc.idc);
ngx.say(cjson.encode(loc));
--[[
--]]

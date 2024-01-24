local http = require "resty.http"
local encode_json = require "cjson.safe" .encode
local decode_json = require "cjson.safe" .decode


local ngx_log            = ngx.log
local ngx_exit           = ngx.exit
local ngx_var            = ngx.var
local ngx_crc32          = ngx.crc32_short
local INFO               = ngx.INFO
local ERR                = ngx.ERR


local new_tab            = require "table.new"

print("log from init_by_lua_file")



-- ngx.req.get_headers()["X-Forwarded-For"] client_ip

-- local req_header = ngx.req.get_headers()


local url = ngx_var.scheme .. "://" .. ngx_var.host .. ngx_var.request_uri

local req_headers = new_tab(0, 20)

for k, v in pairs(ngx.req.get_headers()) do
  req_headers[k] = v
end

ngx.say("start", encode_json(req_headers));

local req_header_json = encode_json(req_headers) or ""


local body = {
  user_agent = "xx", 
  client_ip = ngx.var.remote_addr,
  -- ja3 fingerprint
  -- tls_fingerprint = "tls fp", 
  tls_fingerprint = ngx_var.http_ssl_ja3, 
  -- http2 fingerprint
  akamai_fingerprint = ngx_var.http2_fingerprint,
  tls_greased = ngx_var.http_ssl_greased,
  device_fingerprint = "device id",
  method = ngx.var.request_method,
  url = url, 
  req_headers = req_header_json,
  protocol = ngx.var.server_protocol
}

ngx.say("start", encode_json(body));

local httpc = http.new()
httpc:set_timeout(50)
-- 
-- 
-- 
local start_time = ngx.now() * 1000

-- must setup global dns resover.
-- nginx config: resolver 8.8.8.8 valid=10s;
local ok, err = httpc:connect("sg.airdb.host", 8080)
--     local ok, err = httpc:connect("129.226.148.218", 3000)
if not ok then
     ngx_var.crawler_e = 1
     ngx_log(ERR, "connect failed")
     return
end
 
 
 
local res, err = httpc:request({
    path = "/api/v1/sgw/waf/check",
    method = "POST",
    headers = { ["Content-Type"] = "application/json" },
    body = encode_json(body),
})
if not res then
    ngx_var.crawler_e = 1
    httpc:close()
    ngx_log(ERR, "request failed: ", err)
    if err == "timeout" then
        ngx_var.crawler_timeout = 1
    end
    return
end
 
    httpc:set_keepalive()

    local body, err = res:read_body()
    if err then
	 ngx_log(ERR, "decode ", body, " failed: ")
	 return
    end

    -- ngx.say("done last", body);

    local ret, err = decode_json(body)
    if err then
	 ngx_log(ERR, "decode ", body, " failed: ")
	 return
    end



ngx.say("done last", body);
 
local duration = ngx.now() * 1000 - start_time

ngx.say("done, time cost ",duration );

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


local req_header_json = encode_json(req_headers) or ""

local body = {
  user_agent = "xx", 
  client_ip = ngx.var.remote_addr,
  -- ja3 fingerprint
  -- tls_fingerprint = "tls fp", 
  fingerprint_ja3 = ngx_var.http_ssl_ja3, 
  -- http2 fingerprint
  fingerprint_h2 = ngx_var.http2_fingerprint,
  tls_greased = ngx_var.http_ssl_greased,
  device_fingerprint = "device id",
  method = ngx.var.request_method,
  url = url, 
  req_headers = req_header_json,
  req_body = req_body,
  protocol = ngx.var.server_protocol
}

if body["method"] == "POST" then
  ngx.req.read_body()
  local req_body = ngx.req.get_body_data()

  body["req_body"] = req_body
end

ngx.say("start", encode_json(body));

local httpc = http.new()
httpc:set_timeout(50)
-- 
-- 
-- 
local start_time = ngx.now() * 1000

-- must setup global dns resover.
-- nginx config: resolver 8.8.8.8 valid=10s;
-- local server_host = "bumu.fly.dev"
-- local server_port = 443
local server_host = "sg.airdb.host"
local server_port = 8080
-- 
local ok, err = httpc:connect(server_host, server_port)
if not ok then
     ngx_var.check_err = 1
     ngx_log(ERR, "connect failed")
     return
end
--  
--  
local res, err = httpc:request({
    path = "/apis/v1/sgw/sec/check",
    method = "POST",
    headers = { ["Content-Type"] = "application/json" },
    body = encode_json(body),
})


-- local url = "https://bumu.fly.dev/apis/v1/sgw/sec/check"
-- 
-- local res, err = httpc:request_uri(url, {
--     method = "POST",
--     headers = { ["Content-Type"] = "application/json" },
--     body = encode_json(body),
--     ssl_verify = false
-- })
if not res then
    ngx_var.check_err = 1
    httpc:close()
    ngx_log(ERR, "request failed: ", err)
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

                local sock = ngx.socket.tcp()
                -- assume "192.168.1.10" is the local ip address
                -- local ok, err = sock:bind("192.168.1.10")
                -- if not ok then
                --     ngx.say("failed to bind")
                --     return
                -- end
                -- local ok, err = sock:connect("sg.airdb.host", 3000)
                local ok, err = sock:connect("129.226.148.218", 3000)
                if not ok then
                    ngx.say("failed to connect server: ", err)
                    return
                end
                ngx.say("successfully connected!")
                sock:close()

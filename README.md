# Nginx


https://openresty-reference.readthedocs.io/en/latest/Directives/




## http_sub_module 字符串替换
用途：该模块用于实现响应内容固定字符串替换。
内置模块：是。
默认启用：否。如果需要启用，编译Nginx时使用--with-http_sub_module。
作用域：http, server, location

```nginx
location / {
    sub_filter '<a href="http://127.0.0.1:8080/'  '<a href="https://$host/';
    sub_filter 'nginx.com' 'baidu.com';
    # 是否仅替换一次，如果为off，则全局替换
    sub_filter_once on;
    # 替换的响应类型，*表示替换所有类型
    sub_filter_types text/html;
    # 是否保留原始的Last-Modified。默认是on
    sub_filter_last_modified on;
}
```
该模块不支持正则替换，灵活性不够。支持正则匹配替换的第三方模块：
1、ngx_http_substitutions_filter_module：https://github.com/yaoweibin/ngx_http_substitutions_filter_module
2、replace-filter-nginx-module：https://github.com/agentzh/replace-filter-nginx-module


## http_addition_module 追加内容
用途：用于在响应之前或者之后追加文本内容，比如想在站点底部追加一个js或者css，可以使用这个模块来实现。
内置模块：是。
默认启用：否。如果需要启用，编译Nginx时使用--with-http_addition_module。

```nginx
location / {
        addition_types text/html;
        add_before_body /2013/10/header.html;
        add_after_body  /2013/10/footer.html;
    }
```

## Lua modules

https://github.com/openresty/lua-resty-dns

https://github.com/ledgetech/lua-resty-http

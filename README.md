# Install

 * tap the keg:
 
 ```brew tap nathantsoi/openresty```

 * install:
 
 ```brew install open-resty --with-postgres```

 * start the server:

 ```openresty [-c openresty.conf]```


if you see an error when starting up, you probably need to create a log directory:

```mkdir -p /usr/local/Cellar/open-resty/1.7.7.2/nginx/log```

no, you don't need to install postgres, but if you want to take full advantage of the [Lapis](http://goo.gl/BEO3MO) framework, you really should

also, checkout [moonscript](http://goo.gl/5cvvFO)


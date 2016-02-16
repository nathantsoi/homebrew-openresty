# Install

 * tap the keg:
 
 ```brew tap nathantsoi/openresty```

 * install (optionally, with postgres support):
 
 ```brew install openresty --with-postgres```

 * start the server:

 ```openresty [-c openresty.conf]```

if you see an error when starting up, you probably need to create a log directory as described in `brew info openresty`

no, you don't need to install postgres, but if you want to take full advantage of the [Lapis](http://goo.gl/BEO3MO) framework, you really should

also, checkout [moonscript](http://goo.gl/5cvvFO)


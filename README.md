# Install

  * tap the keg
```brew tap nathantsoi/homebrew-resty```

  * install the devel version, per agentzh's suggestion: [Mainline releases contain the latest bug fixes and new features. Mainline releases are considered production-ready.](http://goo.gl/OiNb3z)
```brew install --devel open-resty --with-postgres```

  * or play it ultra safe w/ the stable version: [Stable releases are for really conservative users and they may contain known bugs that have already been fixed in the mainline versions.](http://goo.gl/OiNb3z)
```brew install open-resty --with-postgres```

  * no, you don't need to install postgres, but if you want to take full advantage of the [Lapis](http://goo.gl/BEO3MO) framework, you really should

  * also, checkout [moonscript](http://goo.gl/5cvvFO)

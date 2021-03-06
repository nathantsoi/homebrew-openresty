require 'formula'

class Openresty < Formula
  homepage 'http://openresty.org/'
  url 'https://openresty.org/download/openresty-1.9.7.3.tar.gz'
  sha256 '3e4422576d11773a03264021ff7985cd2eeac3382b511ae3052e835210a9a69a'

  depends_on 'openssl'
  depends_on 'pcre'
  depends_on 'luajit' => :recommended
  depends_on 'libdrizzle' if build.include? 'with-drizzle'
  depends_on 'postgresql' if build.include? 'with-postgres'

  skip_clean 'logs'
  skip_clean 'bin'

  option 'without-luajit', 'Remove support for Lua Just-In-Time Compiler'
  option 'with-drizzle',  'Compile with support for upstream communication with MySQL and/or Drizzle database servers'
  option 'with-postgres', 'Compile with support for direct communication with PostgreSQL database servers'
  option 'with-iconv', 'Compile with support for converting character encodings'
  option 'with-passenger', 'Compile the included nginx with Phusion Passenger'
  option 'with-webdav', 'Compile the included nginx with WebDAV support'

  def passenger_config_args
      passenger_root = `passenger-config --root`.chomp

      if File.directory?(passenger_root)
        return "--add-module=#{passenger_root}/ext/nginx"
      end

      puts "Unable to install nginx with passenger support. The passenger"
      puts "gem must be installed and passenger-config must be in your path"
      puts "in order to continue."
      exit
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--with-cc-opt='-I#{HOMEBREW_PREFIX}/include'",
            "--with-ld-opt='-L#{HOMEBREW_PREFIX}/lib'",
            "--sbin-path=#{sbin}/openresty",
            "--conf-path=#{etc}/openresty/nginx.conf",
            "--pid-path=#{var}/run/openresty.pid",
            "--lock-path=#{var}/openresty/nginx.lock"]

    # nginx passthrough
    args << passenger_config_args if build.include? 'with-passenger'
    args << "--with-http_dav_module" if build.include? 'with-webdav'

    # default on
    args << "--with-luajit" unless build.include? 'without-luajit'
    # default off
    args << "--with-http_drizzle_module" if build.include? 'with-drizzle'
    args << "--with-http_postgres_module" if build.include? 'with-postgres'
    args << "--with-http_iconv_module" if build.include? 'with-iconv'

    system "./configure", *args
    system "make"
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644

    system "mkdir -p #{prefix}/nginx/log"
  end

  def caveats; <<-EOS.undent
    OpenResty is a beefed up version of nginx, but in order to play nice with
    the standard `nginx` formula, this installer will rename the executable
    `openresty`, and place configuration files in separate directories. This
    allows you to have both nginx and OpenResty nginx installed at the same
    time.

    In the interest of allowing you to run `openresty` without `sudo`, the
    default port is set to localhost:8080.

    If you want to host pages on your local machine to the public, you should
    change that to localhost:80, and run `sudo openresty`. You'll need to turn
    off any other web servers running port 80, of course.

    You can start openresty automatically on login running as your user with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Caution: when running as your user (not root) the launch agent will fail
    if you try to use a port below 1024 (such as http's default of 80).

    You may need to creat e log directory with `mkdir -p #{prefix}/nginx/log`

    create a config and run:
      openresty -c `pwd`/openresty.conf
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/sbin/openresty</string>
        <string>-g</string>
        <string>daemon off;</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end
end

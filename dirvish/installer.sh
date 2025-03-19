#!/usr/bin/expect -f
set timeout 30
spawn sh -c "cd /tmp/dirvish && sh install.sh"
expect -glob "perl to use*" { send "\r" }
expect -glob "What installation prefix should be used?*" { send "\r" }
expect -glob "Directory to install executables?*" { send "\r" }
expect -glob "Directory to install MANPAGES?*" { send "\r" }
expect -glob "Configuration directory*" { send "\r" }
expect -glob "Is this correct?*" { send "yes\r" }
expect -glob "Install executables and manpages?*" { send "yes\r" }
expect -glob "Clean installation directory?*" { send "yes\r" }
expect eof

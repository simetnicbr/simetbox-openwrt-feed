#!/usr/bin/lua
local luci = {}
luci.sys = require("luci.sys")

local mac_address

f = io.popen("/usr/bin/get_mac_address.sh")
for line in f:lines() do
	mac_address = line
end
f:close()

if (luci.sys.user.checkpasswd("root","") or
    mac_address and
      (luci.sys.user.checkpasswd("root",mac_address) or
       luci.sys.user.checkpasswd("root",string.upper(mac_address))
    )) then
	print("Using a default password")
	os.exit(0)
end

print "Using a non-default password"
os.exit(1)

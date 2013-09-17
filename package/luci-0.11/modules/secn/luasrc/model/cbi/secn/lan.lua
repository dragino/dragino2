--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: lan.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()
local lanip = uci:get("network","lan","ipaddr")
local lan_prex = string.match(lanip,"(%d+%p%d+%p%d+%p)%d+")

m = Map("secn", translate("Small Enterprise-Campus Network"))
s = m:section(NamedSection, "dhcp", "secn", translate("LAN and DHCP"))
s.addremove = false
m:chain("network")

local ip = s:option(Value, "ipaddr", "IP Address")
ip.datatype = "ipaddr"
function ip.cfgvalue(self,section)
 return m.uci:get("network","lan","ipaddr")
end
function ip.write(self,section,value)
	m.uci:set("network","lan","ipaddr",value)
	m.uci:set("secn","dhcp","router",value)
end

local de = s:option(Flag, "enable", "Enable DHCP","Enable DHCP Server")
de.enabled  = "checked"
de.disabled = "unchecked"
de.default  = de.disable
de.rmempty  = false

local au = s:option(Flag, "dhcp_auth", "Authoritative", "Enable DHCP Authoritative")
au:depends("enable","checked")
au.enabled  = "checked"
au.disabled = "unchecked"
au.default  = au.disable
au.rmempty  = false

local nm = s:option(Value, "subnet", "Subnet Mask")
nm:depends("enable","checked")
nm:value("255.255.255.0")
nm:value("255.255.0.0")
nm:value("255.0.0.0")
nm.rmempty  = false
nm.datatype = "ipaddr"
function nm.write(self,section,value)
	m.uci:set("network","lan","netmask",value)
end

local si = s:option(Value, "startip", "DHCP Start IP")
si:depends("enable","checked")
si.rmempty  = false
si.datatype = "ipaddr"

local ei = s:option(Value, "endip", "DHCP End IP")
ei:depends("enable","checked")
ei.rmempty  = false
ei.datatype = "ipaddr"



local dns = s:option(Value, "dns", "DNS Server 1")
dns:depends("enable","checked")
dns.rmempty  = false
dns.datatype = "host"
function dns.write(self,section,value)
	m.uci:set("network","lan","dns",value)
end

local dns2 = s:option(Value, "dns2", "DNS Server 2")
dns2:depends("enable","checked")
dns2.rmempty  = false
dns2.datatype = "host"

local lt = s:option(Value, "leaseterm", "Lease Term (secs)")
lt:depends("enable","checked")
lt.rmempty  = false
lt.datatype =  "uinteger"

local ml = s:option(Value, "maxleases", "Max Leases")
ml:depends("enable","checked")
ml.rmempty  = false
ml.datatype =  "uinteger"

local dm = s:option(Value, "domain", "Domain")
dm:depends("enable","checked")
dm.rmempty  = false

local fip = s:option(Flag, "FallbackIP", "Enable Fallback IP","Fallback IP is permanent IP in LAN interface")
fip.rmempty  = false
fip.enabled  = "enable"
fip.disabled = "disable"


return m
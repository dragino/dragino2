--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: mesh.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()

m = Map("secn", translate("Small Enterprise-Campus Network"))

m:chain("network")
m:chain("wireless")

s = m:section(NamedSection, "mesh", "secn", translate("Mesh Setting"), "Mesh devices should have the same WiFi Channel, SSID and BSSID to communicate with others")
local me = s:option(Flag, "mesh_enable", translate("<abbr title=\"This option will be set Disable if select WiFi as WAN interface\">Enable Mesh</abbr>"),"Enable Mesh Network")
me.enabled  = "1"
me.disabled = "0"
me.default  = me.disable
me.rmempty  = false

local mip = s:option(Value, "_mesh_ip", "Mesh IP Address")
mip.datatype = "ipaddr"
function mip.cfgvalue(self,section)
 return m.uci:get("network","mesh_0","ipaddr")
end
function mip.write(self,section,value)
	m.uci:set("network","mesh_0","ipaddr",value)
end

local mnm = s:option(Value, "_mesh_netmask", "Mesh Netmask")
mnm:value("255.255.255.0")
mnm:value("255.255.0.0")
mnm:value("255.0.0.0")
mnm.datatype = "ipaddr"
function mnm.cfgvalue(self,section)
 return m.uci:get("network","mesh_0","netmask")
end
function mnm.write(self,section,value)
	m.uci:set("network","mesh_0","netmask",value)
end

local mssid = s:option(Value, "_mesh_ssid", "<abbr title=\"Mesh Network ID\">SSID</abbr>")
mssid.default = luci.sys.hostname() .. "-mesh"
mssid.placeholder = "Default:" .. luci.sys.hostname().. "-mesh"
function mssid.cfgvalue(self,section)
 return m.uci:get("wireless","ah_0","ssid")
end
function mssid.write(self,section,value)
	m.uci:set("wireless","ah_0","ssid",value)
end

local mbssid = s:option(Value, "_mesh_bssid", "<abbr title=\"Mesh Network Group ID\">BSSID</abbr>")
function mbssid.cfgvalue(self,section)
 return m.uci:get("wireless","ah_0","bssid")
end
function mbssid.write(self,section,value)
	m.uci:set("wireless","ah_0","bssid",value)
end

s = m:section(NamedSection, "mpgw", "secn", translate("Mesh Gateway"))
local gwmode= s:option(ListValue, "mode", "Gateway Mode")
gwmode:value("OFF","OFF")
gwmode:value("CLIENT","CLIENT")
gwmode:value("SERVER","SERVER")
gwmode:value("SERVER-1Mb","SERVER-1Mb")
gwmode:value("SERVER-2Mb","SERVER-2Mb")
gwmode:value("SERVER-5Mb","SERVER-5Mb")
gwmode:value("SERVER-10Mb","SERVER-10Mb")


return m
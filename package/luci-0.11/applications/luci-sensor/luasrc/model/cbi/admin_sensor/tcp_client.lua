--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2014 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: tcp_client.lua 5948 2010-03-27 14:54:06Z jow $
]]--


local dragino_utility = require('dragino.utility')
local uci = luci.model.uci.cursor()

local uart_channels = {}
uci:foreach("sensor","channels",
	function (section)
		table.insert(uart_channels,section[".name"])
	end
)


m = Map("tcp_client", translate("TCP Client"), translate("Communicate with IoT Server through a TCP Client socket"))
s = m:section(NamedSection, "general", "settings", translate("General Settings"))

local serverip = s:option(Value, "server_address", translate("Server Address"))
serverip.placeholder = translate("IP address or Host Name") 
serverip.datatype = "host"

local serverport = s:option(Value, "server_port", translate("Server Port"))
serverport.datatype = "uinteger"

local ui = s:option(Value, "update_interval", translate("Update Interval"),translate("unit:seconds. Set to 0 to disable periodically update"))
ui.placeholder = translate("how often update data to server") 
ui.default = '60'
ui.datatype = "uinteger"

local uo = s:option(Flag, "update_onchange", translate("Update on Change"),translate("Send to server when a new value arrive"))
uo.enabled  = "1"
uo.disabled = "0"
uo.default  = uo.enabled
uo.rmempty  = false

s = m:section(TypedSection, "channels", translate("Channels"),translate("Channels to be monitored or controlled"))
s.addremove = true

local cc = s:option(ListValue, "class", translate("Channel Class"))
cc.placeholder = translate("Choose Channel Class")
cc:value("upload",translate("Send Local Data to Remote Channel"))
cc:value("download",translate("Get Remote Data and Save to Local Channel"))

local ci = s:option(Value, "id", translate("Local Channel ID"))
ci.placeholder = translate("Local physical or virtual port")
for k,v in ipairs (uart_channels) do
	ci:value(v,v)
end

local ustring = s:option(Value, "upload_string", translate("Upload String"),translate("Construct and send a string use the local value"))
ustring.placeholder = translate("Example: Temperature:[VALUE]")
ustring:depends('class','upload')

local mp = s:option(Value, "pattern", translate("Match Pattern"),translate("Fetch a value from arriving strings"))
mp:depends('class','download')

return m
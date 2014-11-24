--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: xively.lua 5948 2010-03-27 14:54:06Z jow $
]]--


local dragino_utility = require('dragino.utility')
local uci = luci.model.uci.cursor()

local uart_channels = {}
uci:foreach("sensor","channels",
	function (section)
		table.insert(uart_channels,section[".name"])
	end
)


m = Map("xively", translate("Xively Service"), translate("Here you can configure how to communicate with Xively IoT server"))
s = m:section(NamedSection, "general", "settings", translate("General Settings"))

s:option(Value, "feed", translate("Feed ID"))
s:option(Value, "apikey", translate("API Key"))

local ui = s:option(Value, "update_interval", translate("Update Interval"),translate("unit:seconds"))
ui.placeholder = translate("how often update data to xively") 
ui.default = '60'

s = m:section(TypedSection, "channels", translate("Channels"),translate("Channels to be monitored or controlled"))
s.addremove = true

local rid = s:option(Value, "remoteID", translate("Remote Channel ID"))
rid.placeholder = translate("Corresponding ID in xively server")

local ci = s:option(Value, "id", translate("Local Channel ID"))
ci.placeholder = translate("Local physical or virtual port")
for k,v in ipairs (uart_channels) do
	ci:value(v,v)
end

local cc = s:option(ListValue, "class", translate("Channel Class"))
cc.placeholder = translate("Choose Channel Class")
cc:value("upload",translate("Send Local Data to Remote Channel"))
cc:value("download",translate("Get Remote Data and Save to Local Channel"))

return m
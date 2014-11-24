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
local IOT_SERVICE = {}

m = Map("iot-services", translate("Internet of Things"), translate("IoT Services Overview"))

s = m:section(NamedSection, "general", "settings", translate("General Settings"))
local de = s:option(ListValue, "debug", translate("Enable Debug"),translate("Debug info can be viewed by logread"))
de:value("0",translate("Disable"))
de:value("1",translate("Level 1"))
de:value("2",translate("Level 2"))

s = m:section(TypedSection, "server")
s:depends("display","1")
s:option(Flag, "enable", translate("Enable Service"),translate("Service detail can be found at the top of this page"))
--s:option(DummyValue, "config_file", translate("Config File"))
s:option(Value, "routine_script", translate("Routine Script"))
--s:option(Value, "download_script", translate("Download Script"))


return m
--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008-2011 Jo-Philipp Wich <xm@subsignal.org>
Copyright 2014 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.admin.sensor", package.seeall)

function index()
	local uci = luci.model.uci.cursor()
	local string =string
	entry({"admin", "sensor"}, alias("admin", "sensor", "service"), _("Sensor"), 30).index = true
	entry({"admin", "sensor", "poweruart"}, cbi("admin_sensor/poweruart"), _("PowerUART"), 2)
	entry({"admin", "sensor", "mcu"}, cbi("admin_sensor/mcu"), _("MicroController"), 3)
	entry({"admin", "sensor", "rfgateway"}, cbi("admin_sensor/rfgateway"), _("RF Radio Gateway"), 4)
	entry({"admin", "sensor", "service"}, cbi("admin_sensor/service"), _("IoT Service"), 1)
	uci:foreach("iot-services","server",
	function (section)
		if section["display"] == '1' then
			entry({"admin", "sensor", "service",section[".name"]}, cbi("admin_sensor/"..section[".name"]), _(string.upper(section[".name"])), 2)
		end
	end
	)
	
end
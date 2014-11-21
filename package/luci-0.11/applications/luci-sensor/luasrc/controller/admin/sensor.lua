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
	entry({"admin", "sensor"}, alias("admin", "sensor", "service"), _("Sensor"), 30).index = true
	entry({"admin", "sensor", "poweruart"}, cbi("admin_sensor/poweruart"), _("PowerUART"), 1)
	entry({"admin", "sensor", "mcu"}, cbi("admin_sensor/mcu"), _("MicroController"), 1)
	entry({"admin", "sensor", "service"}, cbi("admin_sensor/service"), _("IoT Service"), 2)
	entry({"admin", "sensor", "service","xively"}, cbi("admin_sensor/xively"), _("Xively Server"), 2)
end
--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: poweruart.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()
local baud_rate ={'600','1200','2400','4800','9600','19200','38400','57600','115200','230400'}
local uartmodestring='Linux Console: User can access system via UART\n' ..
				'Arduino Bridge: Support Arduino Bridge Class in 115200 Baud Rate\n' ..
				'UART Routing: Get and dispatch UART data to /var/iot/channels/ base on pre-set pattern'

m = Map("sensor", translate("PowerUART"), translate("PowerUART is a set of UI/Scripts to determine how the UART interface should work"))

s = m:section(NamedSection, "poweruart", "sensor")
local um= s:option(ListValue, "uartmode", translate('UART <abbr title=\"'..uartmodestring..'\">Operation Mode</abbr>'),translate("Determine how the UART works. Require a reboot to take affect"))
um:value("bridge","Linux Console / Arduino Bridge")
um:value("routing","UART Routing")
um:value("noconsole","Disable Linux Console")

local br= s:option(ListValue, "baudrate", translate('Baud Rate'))
br.default='115200'
for k,v in pairs(baud_rate) do
	br:value(v,v)
end

br:depends("uartmode","routing")

s = m:section(TypedSection, "channels", translate("Channels"),translate("UART data are stored in /var/iot/channels/"))
--s.anonymous = true
s.addremove = true
--s:option(Value, "[.name]", translate("Name"))
s:option(Value, "pattern", translate("Match Pattern"),translate("Reference Pattern <a href=http://www.lua.org/manual/5.1/manual.html#5.4.1 target=_blank>Manual</a>"))

return m
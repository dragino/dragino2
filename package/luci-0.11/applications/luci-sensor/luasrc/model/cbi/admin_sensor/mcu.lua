--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: mcu.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()

m = Map("sensor", translate("Micro-Controller settings"), translate("Configure correct Arduino profile will let you to able upload avr program via Arduino IDE and WiFi"))

s = m:section(NamedSection, "mcu", "sensor", translate("MCU Upload Profile"))
local bp= s:option(ListValue, "MCUProfile", translate("MCU Profile"),translate("Determine the MCU model, bootloader and fuse settings"))
bp:value("leonardo","Leonardo, M32 or M32W")
bp:value("uno","Arduino Uno w/ATmega328P")
bp:value("duemilanove328","Arduino Duemilanove or Diecimila w/ATmega328") 
bp:value("duemilanove168","Arduino Duemilanove or Diecimila w/ATmega168,MRFM12B") 
bp:value("mega2560","Arduino Mega2560") 

return m
--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: rfgateway.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()

m = Map("rfgateway", translate("RF Radio Gateway settings"), translate("Radio Setting Page for RFM12B and RFM68 series wireless module. <a href=www.dragino.com target=_blank>Reference Manual</a>"))

s = m:section(NamedSection, "rfgateway", "rfgateway", translate("RF Radio Gateway"))
local fre= s:option(ListValue, "frequency", translate("RF Frequency"))
fre:value("0","315Mhz")
fre:value("1","433Mhz")
fre:value("2","868Mhz") 
fre:value("3","915Mhz")  

local rf_module= s:option(ListValue, "module", translate("RF Module Type"))
rf_module.default="2"
rf_module:value("1","RFM12B")
rf_module:value("2","RFM69CW")

local rf_baud= s:option(Value, "speed", translate("RF Baud Rate"), translate("(1 ~ 65535) bps"))
rf_baud.datatype = "range(1,65535)"

local groupid= s:option(Value, "groupid", translate("Network Group ID"), translate("ID: 1 ~ 255"))
groupid.datatype = "range(1,255)"

local nodeid= s:option(Value, "nodeid", translate("Gateway ID"), translate("ID: 1 ~ 255"))
nodeid.datatype = "range(1,255)"
  
return m
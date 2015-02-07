--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: feature_code.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()

m = Map("voip", translate("Voice Over IP "))

s = m:section(NamedSection, "featurecode", "voip", translate("Feature Codes"))

local dialout = s:option(Value, "dialout", translate("Dial Out Code"), translate("Outbound call prefix"))

local ivr_pin = s:option(Value, "ivr_pin", translate("IVR PIN"))
ivr_pin.datatype = "uinteger"




return m
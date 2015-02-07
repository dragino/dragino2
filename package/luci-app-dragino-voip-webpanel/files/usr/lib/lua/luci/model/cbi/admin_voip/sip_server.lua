--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: sip_server.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()

m = Map("voip", translate("Voice Over IP "))

s = m:section(NamedSection, "sip_server", "voip", translate("SIP Server Settings"))

local e_sipacc = s:option(Flag, "enablesip", translate("Enable SIP Account"),translate("Enable SIP Account"))
e_sipacc.enabled  = "1"
e_sipacc.disabled = "0"
e_sipacc.rmempty  = false

local e_reg = s:option(Flag, "register", translate("Enable Register"),translate("Enable Register to SIP Server"))
e_reg.enabled  = "1"
e_reg.disabled = "0"
e_reg.rmempty  = false

local sip_host = s:option(Value, "host", translate("SIP Host"))
sip_host.datatype = "host"

local sip_port = s:option(Value, "sip_port", translate("SIP Port"))
sip_port.datatype = "uinteger"
sip_port.default = "5060"

local fromdomain = s:option(Value, "fromdomain", translate("From Domain"))
fromdomain.datatype = "host"

local username = s:option(Value, "username", translate("User Name"))

local password = s:option(Value, "secret", translate("Password"))
password.password = true
password.rmempty  = false

local fromusername = s:option(Value, "fromusername", translate("From User Name"))

return m
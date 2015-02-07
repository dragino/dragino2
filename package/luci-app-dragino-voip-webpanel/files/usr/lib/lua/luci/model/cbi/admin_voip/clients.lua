--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: clients.lua 2015-02-03 Dragino Tech $
]]--

local uci = luci.model.uci.cursor()

m = Map("voip", translate("Voice Over IP"))

clients = m:section(TypedSection, "clients", translate("VoIP Clients"),translate("Configure SIP / IAX2 / Analog Clients"))
clients.anonymous = true
clients.addremove=true
clients.template = "cbi/tblsection"
clients.extedit  = luci.dispatcher.build_url("admin/voip/clients/client/%s")

clients.create = function(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(clients.extedit % sid)
		return
	end
end

local username = clients:option(DummyValue, "User", translate("User"))
username.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "username")
end

--local pass = s:option(Value, "password", translate("Password"))
local number = clients:option(DummyValue, "Number", translate("Phone Number"))
number.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "number")
end

local ext_type = clients:option(DummyValue, "Type", translate("Type"))
ext_type.cfgvalue = function(self, section)
	local t 
	if m.uci:get("voip", section, "ext_type") == "softphone" then 
		return translate("Soft Phone")
	else if m.uci:get("voip", section, "ext_type") == "analog" then
			return translate("Analog Phone")
		end
	end
		
	return m.uci:get("voip", section, "ext_type")
end


return m
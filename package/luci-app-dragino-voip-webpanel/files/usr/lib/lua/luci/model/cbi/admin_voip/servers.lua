--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: severs.lua 2015-02-03 Dragino Tech $
]]--

local uci = luci.model.uci.cursor()

m = Map("voip", translate("SIP / IAX2 servers overview"))

servers = m:section(TypedSection, "server", translate("Servers"),translate("Configure SIP / IAX2 Servers"))
servers.anonymous = true
servers.addremove=true
servers.template = "cbi/tblsection"
servers.extedit  = luci.dispatcher.build_url("admin/voip/servers/server/%s")

servers.create = function(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(servers.extedit % sid)
		return
	end
end

local name = servers:option(DummyValue, "name", translate("Server"))
name.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "name")
end

local en_reg = servers:option(DummyValue, "register", translate("Register to Server"))
en_reg.cfgvalue = function(self, section)
	local r = m.uci:get("voip", section, "register")
	if r == "1" then 
		return "Enabled"
	else 
		return "Disabled"
	end
end

local host = servers:option(DummyValue, "Host", translate("Host"))
host.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "host")
end

local user = servers:option(DummyValue, "User", translate("User Name"))
user.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "username")
end

local pro = servers:option(DummyValue, "Protocol", translate("Protocol"))
pro.cfgvalue = function(self, section)
	return m.uci:get("voip", section, "protocol")
end


return m
--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: dial_rule.lua 5948 2015-02-03 Dragino Tech $
]]--

local uci = luci.model.uci.cursor()
local tonumber=tonumber

m = Map("dial-rules", translate("Dial Rule Entry"))
m.redirect = luci.dispatcher.build_url("admin/voip/dial_rules")

if not arg[1] or m.uci:get("dial-rules", arg[1]) ~= "rule" then
	luci.http.redirect(m.redirect)
	return
end

cc = m:section(NamedSection, arg[1], "rules", translate("Configure Dial Rule"))
cc.anonymous = true
cc.addremove = false

local pattern = cc:option(Value, "pattern", translate("Match Pattern"))

local prefix = cc:option(Value, "prefix", translate("Add Prefix"),translate("Add a prefix to the dial string"))

local offset = cc:option(Value, "offset", translate("Sub-number Offset"),translate("position start from 0"))

local length = cc:option(Value, "length", translate("Sub-number Length"))

local suffix = cc:option(Value, "suffix", translate("Add Suffix"),translate("Add a suffix to the dial string"))

local trunk = cc:option(Value, "trunk", translate("Use Trunk"))
uci:foreach("voip", "server",
	function(s)
		trunk:value(s.name,s.name)		
	end)
--trunk:value(_,custom)

local pro = cc:option(ListValue, "protocol", translate("VoIP Protocol"))
pro:value('SIP','SIP')
pro:value('IAX2','IAX2')

	
return m
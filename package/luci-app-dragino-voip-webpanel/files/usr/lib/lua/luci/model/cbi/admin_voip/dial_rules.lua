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

m = Map("dial-rules", translate("Dial Plan"))

rules = m:section(TypedSection, "rule", translate("Dial Rules"),translate("Modify outgoing number before sending to trunk"))
rules.anonymous = true
rules.addremove=true
rules.template = "cbi/tblsection"
rules.extedit  = luci.dispatcher.build_url("admin/voip/dial_rules/dial_rule/%s")

rules.create = function(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(rules.extedit % sid)
		return
	end
end

local pattern = rules:option(DummyValue, "pattern", translate("Pattern"))
pattern.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "pattern")
end

local prefix = rules:option(DummyValue, "prefix", translate("Prefix"))
prefix.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "prefix")
end

local offset = rules:option(DummyValue, "offset", translate("Sub-num Offset"))
offset.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "offset")
end

local length = rules:option(DummyValue, "length", translate("Sub-num Length"))
length.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "length")
end

local suffix = rules:option(DummyValue, "suffix", translate("Suffix"))
suffix.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "suffix")
end

local trunk = rules:option(DummyValue, "trunk", translate("Use Trunk"))
trunk.cfgvalue = function(self, section)
	return m.uci:get("dial-rules", section, "trunk")
end

return m
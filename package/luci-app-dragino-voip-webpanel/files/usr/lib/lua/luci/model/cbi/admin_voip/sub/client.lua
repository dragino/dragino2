--[[
LuCI - Lua Configuration Interface
Copyright 2015 Edwin Chen <edwin@dragino.com>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
$Id: client.lua 5948 2015-02-03 Dragino Tech $
]]--

local uci = luci.model.uci.cursor()
local tonumber=tonumber

m = Map("voip", translate("Voice Over IP"))
m.redirect = luci.dispatcher.build_url("admin/voip/clients")

if not arg[1] or m.uci:get("voip", arg[1]) ~= "clients" then
	luci.http.redirect(m.redirect)
	return
end

local num_prefix = uci:get("voip","asterisk","extension_prefix")
local num_digit = uci:get("voip","asterisk","extension_digits")
local max_num = num_prefix
local min_num = num_prefix
for i=1, num_digit-1 do 
  max_num = max_num .. '9'
  min_num = min_num .. '0'
end

min_num = tonumber(min_num)
max_num = tonumber(max_num)

local valid_num = min_num
local is_valid = false 

while(is_valid ~= true )
do
	is_valid = true
	uci:foreach("voip", "clients",
		function(s)
			if  tonumber(s.number) == valid_num then
				valid_num = valid_num + 1
				is_valid = false
			end
		end)
end

cc = m:section(NamedSection, arg[1], "clients", translate("Configure Clients"))
cc.anonymous = true
cc.addremove = false

local username = cc:option(Value, "username", translate("User Name"))
username.default = valid_num
local pass = cc:option(Value, "password", translate("Password"))
pass.default = valid_num
local number = cc:option(Value, "number", translate("Phone Number"))
number.datatype = "range("..min_num..","..max_num..")"
number.placeholder = "range:"..min_num.." ~ "..max_num
number.default = valid_num

local ext_type = cc:option(ListValue, "ext_type", translate("Extension Type"))
ext_type:value("softphone",translate("Soft Phone / IP Phone"))
ext_type:value("analog",translate("Analog Phone"))

return m
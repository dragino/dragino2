#! /usr/bin/env lua
--[[

    utility.lua - Useful lua utility collection 

    Copyright (C) 2014 Dragino Technology Co., Limited

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

]]--

local modname = ...
local M = {}
_G[modname] = M



local type,assert,print,pairs,string,io,os = type,assert,print,pairs,string,io,os

local uci = require("luci.model.uci")


setfenv(1,M)

uci = uci.cursor()
local uartmode = uci:get("iot","general","uartmode")

--dump a lua table
function tabledump(t,indent)
	-- if nil==t then return end
	assert(type(t)=='table', "Wrong input type. Expected table, got "..type(t))
	local indent = indent or 0
	for k,v in pairs(t) do
		if type(v)=="table" then
			print(string.rep(" ",indent)..k.."=>")
			tabledump(v, indent+4)
		else
			print(string.rep(" ",indent) .. k  .. "=>", v)
		end
	end
end

--Get Firmware Version
--@return f_version firmware version
--@return b_time build time
function getVersion()
	for line in io.lines('/etc/banner') do 
		if string.match(line,'Version:[%s]+(.+)') then 
			f_version = string.match(line,'Version:[%s]+(.+)')  
		end
		if string.match(line,'Build[%s]+(.+)') then 
			b_time = string.match(line,'Build[%s]+(.+)')  
		end
	end
	return f_version,b_time
end

--log data to device
function logger(msg)
	if uartmode == "bridge" then
		print(msg)
	else 
		os.execute("logger ".. msg)
	end 
end

return M

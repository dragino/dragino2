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
local util = require("luci.util")


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

--Get USB Modem
--@return USB Manufacture, Vendor ID and Product ID
function getUSBInfo()
	local USB_INFO=util.exec('cat /proc/bus/usb/devices | grep -A 1 "P:  Vendor"')
	local start = string.find(USB_INFO,"%-%-")
	if start == nil then return nil end
	u_man=string.match(USB_INFO,"Manufacturer=([%w%s%.%_]+[%w])",start)
	u_vid=string.match(USB_INFO,"Vendor=([%w]+)",start)
	u_pid=string.match(USB_INFO,"ProdID=([%w]+)",start)
	return u_man,u_vid,u_pid
end

return M

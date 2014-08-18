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



local type,assert,print,pairs,string,io,os,table = type,assert,print,pairs,string,io,os,table

local uci = require("luci.model.uci")
local util = require("luci.util")
local fs = require("luci.fs")

setfenv(1,M)

uci = uci.cursor()
local uartmode = uci:get("iot","general","uartmode")
local SENSOR_DIR = '/var/iot/channels/'

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

--Retreive Sensor Values
--@return a sensor table, Vendor ID and Product ID
function get_sensor_data()
  local valuetable = {}
  uci:foreach("sensor","channels",
    function (section)
	if section.class == 'sensor' and section.id and section.type and section.remoteID then
	  if fs.isfile(SENSOR_DIR .. section[".name"]) then 
	    local value = util.trim(util.exec("tail -n 1 " .. SENSOR_DIR .. section[".name"]))
	    if value ~= nil and value ~= "" then
		section.value = value
		table.insert(valuetable,section)
	    end	
	  end
	end  
    end
  )
  return valuetable
end

return M

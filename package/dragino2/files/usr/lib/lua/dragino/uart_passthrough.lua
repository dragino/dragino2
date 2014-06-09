#! /usr/bin/env lua
--[[

    UART Pass Through Script for IoT server 

    Copyright (C) 2014 Dragino Technology Co., Limited

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

]]--


local utility = require ("dragino.utility")
local logger = utility.logger
local uci = require("luci.model.uci")
uci = uci.cursor()

local logName = 'UartPassThrough'

local sv = uci:get_all("iot","general")
local service = require ("dragino.iot."..sv.server)
local ApiKey = sv.ApiKey
local deviceID = sv.deviceid
local passThroughSensor = {}
local baudrate = sv.uartbaud
local debug = sv.debug
debug = tonumber(debug)

--list All Patterns
uci:foreach ("iot", "sensor", 
	function (s)
		if s.pattern then 
			table.insert(passThroughSensor,s)
		end
	end			
)

os.execute('stty -F /dev/ttyATH0 ' .. baudrate .. ' clocal cread cs8 -cstopb -parenb')
serialin=io.open("/dev/ttyATH0","rb")   --open serial port and prepare to read data from UART



function process_data(raw)
	if raw == nil then return end
	if debug >=1 then logger(logName ..": Raw data is: " .. raw) end
	for k,v in pairs(passThroughSensor) do
		local mat1,mat2,mat3 = string.match(raw,v.pattern) -- match valid data pattern for each passThroughSensor
		if v.uploadtype == 'numerical' and mat1 ~= nil then
			local data = {{ id = v.remoteid, current_value = mat1 }}
			if debug >=1 then logger(logName ..": Match data is: " .. mat1) end
			service.post_data(ApiKey,deviceID,data)
		elseif v.uploadtype == 'gps' then
			--service.insert_gps_data(ApiKey,v.remoteid,data1,data2,data3)
		elseif v.uploadtype == 'generic' and mat1 ~= nil then
			local data = {{ id = v.remoteid, current_value = mat1 }}
			if debug >=1 then logger(logName ..": Match data is: " .. mat1) end
			service.post_data(ApiKey,deviceID,data)
		end
	end
end


while true do
	while raw_data == nill do 
		serialin:flush()
		raw_data = serialin:read()
	end
	process_data(raw_data)	
	raw_data=nil	
end
serialin:close()
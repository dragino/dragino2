#! /usr/bin/env lua
--[[

    asterisk_ami.lua - Lua Script to communicate with Asterisk AMI
	ver:0.1

    Copyright (C) 2015 Dragino Technology Co., Limited

    Package required: luci-lib-json,luasocket

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

]]--

local modname = ...
local M = {}
_G[modname] = M

local socket = require('socket')
local ipairs,string = ipairs,string
local uci = require("luci.model.uci")
local utility = require 'dragino.utility'
setfenv(1,M)

uci = uci.cursor()

server="127.0.0.1"
port="5038"
admin="dragino"
secret="dragino"

local client = socket.connect(server, port)

if client == nil then
	return 1
end

function SIPshowregistry(value)
	local registry_number = 0
	local entry = ''
	local entry_lines,cur_entry_line = 9,100
	local t = {}
	for line in string.gmatch(value,"(.-\r\n)") do 
		if string.match(line,"Event: RegistryEntry") then
			registry_number = registry_number + 1
			t[registry_number] = {}
			cur_entry_line = 1 
		end
		
		if cur_entry_line <= entry_lines then
			entry = entry .. line
		end
		
		if cur_entry_line == 9 then
			t[registry_number]["host"] = string.match(entry, "Host: ([%w%.]+)\r\n")
			t[registry_number]["port"] = string.match(entry, "Port: (%d+)\r\n")
			t[registry_number]["username"] = string.match(entry, "Username: (.-)\r\n")
			t[registry_number]["domain"] = string.match(entry, "Domain: (.-)\r\n")
			t[registry_number]["regflag"] = 'Enable'
			t[registry_number]["domainport"] = string.match(entry, "DomainPort: (.-)\r\n")
			t[registry_number]["refresh"] = string.match(entry, "Refresh: (.-)\r\n")
			t[registry_number]["state"] = string.match(entry, "State: (.-)\r\n")
			t[registry_number]["regtime"] = string.match(entry, "RegistrationTime: (.-)\r\n")
			entry = ''
		end
		cur_entry_line = cur_entry_line + 1
	end
	t.length = registry_number
	--dragino_utility.tabledump(t)
	return t
end


local AMI_COMMAND =	{ 
						login = { cmd = {'Action: login','Username: '..admin,'Secret: '..secret,'Events: off'}, par = nil},
						SIPshowregistry = {cmd = {'Action: SIPshowregistry'}, par = SIPshowregistry },
						SIPpeers = {cmd = {'Action: SIPpeers'} , par = nil}
					}
				
				
--send message to AMI server
function SendAMIMessage(msg_table)

	-- send command to Asterisk AMI
	for k,v in ipairs(msg_table.cmd) do 
		client:send(v..'\r\n')
	end
	client:send('\r\n')
	
	-- get response from Asterisk AMI
	local res=""
	local code=nil
	local recvt, sendt, status
	recvt, sendt, status = socket.select({client}, nil, 1)
	while #recvt > 0 do
		local data, receive_status = client:receive()
		if receive_status ~= "closed" then
			if data then
				res = res .. data ..'\r\n'
				--get the return code from Asterisk AMI
				if code == nil then
					code = string.match(data,"Response: (%w+)")
				end
				recvt, sendt, status = socket.select({client}, nil, 1)
			end
		else
			break
		end
	end
	
	--Fail to get data, return nil. 
	if code ~= 'Success' then 
		return
	end
	
	--parse the return value
	if msg_table.par ~= nil then
		return msg_table.par(res)
	end
	
	return res,code
end

function get_status_all()
	if SendAMIMessage(AMI_COMMAND["login"]) == nil then 
		return 1
	end
	local sta = {}
	sta.ssr = SendAMIMessage(AMI_COMMAND["SIPshowregistry"])
	sta.sp = SendAMIMessage(AMI_COMMAND["SIPpeers"])
	client:close()
	return sta
end


return M

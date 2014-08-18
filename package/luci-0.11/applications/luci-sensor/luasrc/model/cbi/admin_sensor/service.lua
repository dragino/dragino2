--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: mesh.lua 5948 2010-03-27 14:54:06Z jow $
]]--

local uci = luci.model.uci.cursor()
local IOT_SERVICE = {}

--total physical ports
local dragino_ports = 
	{{id= "Port 1+",sc="1+"},
	 {id= "Port 1-",sc="1-"},
	 {id= "Port 2+",sc="2+"},
	 {id= "Port 2-",sc="2-"},
	 {id= "Port 3+",sc="3+"},
	 {id= "Port 3-",sc="3-"},
	 {id= "Port 4+",sc="4+"},
	 {id= "Port 4-",sc="4-"},
	 {id= "Port 5+",sc="5+"},
	 {id= "Port 5-",sc="5-"},
	 {id= "Port 6+",sc="6+"},
	 {id= "Port 6-",sc="6-"},
	 {id= "Port 7+",sc="7+"},
	 {id= "Port 7-",sc="7-"}
	}

-- check what ports are being used
local port_used = {}
uci:foreach("sensor","channels",
  function (section)
	table.insert(port_used,section.id)
  end
)

-- available port table
local port_available = {}
for k,v in ipairs(dragino_ports) do
  local used = 0
  for i,j in pairs(port_used) do
  	if v.id == j then used = 1 end
  end
  if used == 0 then  table.insert(port_available,v) end
end

uci:foreach("IoT-Service","server", 
	function (section)
		table.insert(IOT_SERVICE,section)
	end
)

m = Map("sensor", translate("Internet of Things"), translate("Here you can configure how to send or get data from IoT Server"))

m:chain("IoT-Service")
local current_service = uci.get("sensor","service","server")
s = m:section(NamedSection, "service", "sensor", translate("Service Settings"))
local service= s:option(ListValue, "server", "IoT Server")
table.foreach(IOT_SERVICE,
	function (i,v)
		service:value(v[".name"],v[".name"]) 
	end
)
--function service.write(self,section,value)
--	current_service = value
--end


for k,v in pairs (IOT_SERVICE) do 
	if (v[".name"] == current_service) then
	  for i,j in pairs(v) do
		if string.find(i,"^%.") == nil then
		   local tmp = s:option(Value, i, i)
		   function tmp.cfgvalue(self,section)
			return uci:get("IoT-Service",current_service,i)
   		   end

		   function tmp.write(self,section,value)
			m.uci:set("IoT-Service",current_service,i,value)
		   	function tmp.cfgvalue(self,section)
				return value
   		   	end
		   end
		end
	   end
	end
end

local ui = s:option(Value, "update_interval", translate("Update Interval(s)"))
ui.placeholder = translate("how often update data to server") 
ui.default = '60'

local de = s:option(ListValue, "debug", translate("Enable Debug"))
de:value("0",translate("Disable"))
de:value("1",translate("Level 1"))
de:value("2",translate("Level 2"))


s = m:section(TypedSection, "channels", translate("Channels"),translate("Channels to be monitored or controlled"))
s.addremove = true

local ci = s:option(Value, "id", translate("Channel ID"))
ci.placeholder = translate("Local physical or virtual port")
for k,v in ipairs (port_available) do
  ci:value(v.id,translate("Port ") .. v.sc)
end

local cc = s:option(ListValue, "class", translate("Channel Class"))
cc.placeholder = translate("Choose Channel Class")
cc:value("sensor",translate("Sensor"))
cc:value("actuator",translate("Actuator"))


local ct = s:option(Value, "type", translate("Channel Type"))
ct.placeholder = translate("Choose Channel Type")
ct:value("DI",translate("Digital Input"))
ct:value("DO",translate("Digital Output"))
ct:value("AI",translate("Analog Input"))

local rid = s:option(Value, "remoteID", translate("Remote ID"))
rid.placeholder = translate("Corresponding ID in remote server")
rid.default = s.map:get(section,".name")

return m
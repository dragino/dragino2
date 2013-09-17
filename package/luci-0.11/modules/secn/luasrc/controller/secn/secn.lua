--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008-2011 Jo-Philipp Wich <xm@subsignal.org>
Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.secn.secn", package.seeall)

function index()
	local root = node()
	if not root.target then
		root.target = alias("secn")
		root.index = true
	end
	page          = node("secn")
	--page.lock     = true
	page.target   = firstchild() 
	--page.subindex = true
	page.sysauth = "root"
	page.sysauth_authenticator = "htmlauth"
	page.index    = true
	page.ucidata = true

	entry({"secn"}, alias("secn", "network"), "SECN", 5)
	entry({"secn", "network"}, alias("secn", "network","network"), "Network", 5)
	entry({"secn", "network","network"}, cbi("secn/network"), "Internet", 10)
	entry({"secn", "network","lan"}, cbi("secn/lan"), "LAN and DHCP", 11)
	entry({"secn", "network","ap"}, cbi("secn/ap"), "Access Point", 30)
	entry({"secn", "network","mesh"}, cbi("secn/mesh"), "Mesh Network", 40)
end

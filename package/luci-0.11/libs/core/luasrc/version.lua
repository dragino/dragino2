local pcall, dofile, _G = pcall, dofile, _G

module "luci.version"

if pcall(dofile, "/etc/openwrt_release") and _G.DISTRIB_DESCRIPTION then
	distname    = ""
	distversion = _G.DISTRIB_DESCRIPTION
	vendordist   = _G.VENDOR_DISTRIBUTION
else
	distname    = "OpenWrt Firmware"
	distversion = "Barrier Breaker (r33887)"
end

luciname    = "LuCI 0.11 Branch"
luciversion = "0.11+svn"
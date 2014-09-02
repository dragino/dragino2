#!/usr/bin/lua

local uci = require("luci.model.uci")
uci = uci.cursor()

local bootloader_dir='/etc/arduino/'
local bootloader
local board = uci:get("sensor","mcu","MCUProfile")

if board == 'leonardo' then
 bootloader = 'Caterina-Yun.hex' 
elseif board == 'uno' then
  bootloader = 'optiboot/optiboot_atmega328.hex'
elseif board == 'duemilanove328' then
  bootloader = 'ATmegaBoot/ATmegaBOOT_168_atmega328.hex'
elseif board == 'duemilanove168' then
  bootloader = 'ATmegaBoot/ATmegaBOOT_168_diecimila.hex'
elseif board == 'mega2560' then
  bootloader = 'stk500v2/stk500boot_v2_mega2560.hex'
end

if #arg ~= 1 then
  print("Missing sketch file name")
  return 1
end

local uploaded_name = arg[1]

local io = require("io")
local uploaded_sketch = io.open(uploaded_name)
if not uploaded_sketch then
  print("Unable to open file " .. uploaded_name .. " for reading")
  return 1
end

local sketch = {}
for line in uploaded_sketch:lines(uploaded_name) do
  table.insert(sketch, line)
end
uploaded_sketch:close()

--removes last line
table.remove(sketch)

for line in io.lines(bootloader_dir..bootloader) do
  table.insert(sketch, line)
end

local final_sketch = io.open(uploaded_name, "w+")
if not final_sketch then
  print("Unable to open file " .. uploaded_name .. " for writing")
  return 1
end

for idx, line in ipairs(sketch) do
  line = string.gsub(line, "\n", "")
  line = string.gsub(line, "\r", "")
  line = string.gsub(line, " ", "")
  if line ~= "" then
    final_sketch:write(line)
    final_sketch:write("\n")
  end
end

final_sketch:flush()
final_sketch:close()

return 0

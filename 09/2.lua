#!/usr/local/bin/lua

args = {...}

bc = require'bc'

local debug = tonumber(args[2] or 0)

local line = io.open(args[1]):read("*a")
local file = 0

local space = 0
local used = 0
local disk = {}

line = line:gsub("%D", "")
for f,s in line:gmatch("(%d)(%d)") do
   local fn = tonumber(f)
   local sn = tonumber(s)
   table.insert(disk, {data=file, len=fn, pos=used+space})
   used = used + fn
   table.insert(disk, {len=sn, pos=used+space})
   space = space + sn
   file = file + 1
end

if (#line % 2) == 1 then
   local fn = tonumber(line:sub(-1))
   table.insert(disk, {data=file, len=fn, pos=used+space})
--   print(file, fn, used+space)
   used = used + fn
   file = file + 1
end

file = file - 1
   
if debug > 1 then
   for i,j in ipairs(disk) do
      print(string.rep(j.data or ".", j.len))
   end
end

-- Insert entire files, starting from tail in leftmost space that is big enough
local tail = #disk
local i = 1
local data

repeat
   if disk[tail].data then
      -- find first space big enough
      i = 1
      while i < tail do
	 if (not disk[i].data) and (disk[i].len >= disk[tail].len) then
--	    print("move file", disk[tail].data, "to pos", disk[i].pos)
	    disk[i].len = disk[i].len - disk[tail].len
	    disk[tail].pos = disk[i].pos
	    disk[i].pos = disk[i].pos + disk[tail].len
	    i = #tail -- break
	 end
	 i = i + 1
      end
   end
   tail = tail - 1
until tail == 0

local pos = 0
local sum = bc.new(0)

for i=1,#disk do
   if disk[i].data then
--      print("data", disk[i].data, disk[i].pos, disk[i].len)
      pos = disk[i].pos
      for n=1,disk[i].len do
	 sum = sum + bc.new(disk[i].data) * bc.new(pos)
	 if debug > 0 then print("data, pos", disk[i].data,  pos) end
	 pos = pos + 1
      end
   else
--      print(disk[i].pos, disk[i].len)
   end
   
end

print(sum)

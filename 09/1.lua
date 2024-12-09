#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local line = io.open(args[1]):read("*a")
local file = 0

local space = 0
local data = 0
local disk = {}

line = line:gsub("%D", "")
for f,s in line:gmatch("(%d)(%d)") do
   data = data + tonumber(f)
   space = space + tonumber(s)
   if f == "0" then print("whoops!") end
   table.insert(disk, {data=file, len=tonumber(f)})
   table.insert(disk, {len=tonumber(s)})
   file = file + 1
end

if (#line % 2) == 1 then
   data = data + tonumber(line:sub(-1))
   table.insert(disk, {data=file, len=tonumber(line:sub(-1))})
end

if debug > 1 then
   for i,j in ipairs(disk) do
      print(string.rep(j.data or ".", j.len))
   end
end

-- Insert from last data into first blanks, moving towards eachother.
local dd = {} -- "defragged" disk

local tail = #disk
local pos = 0
local sum = 0
local i = 1

repeat
   if disk[i].data then
      -- file, get data from start
      for n=1,disk[i].len do
	 sum = sum + disk[i].data * pos
	 if debug > 0 then print(1, disk[i].data,  pos) end
	 pos = pos + 1
      end
      i = i + 1
   else
      -- space, get data from tail
      while not disk[tail].data do tail = tail - 1 end
      if disk[i].len > disk[tail].len then
	 for n=1,disk[tail].len do
	    sum = sum + disk[tail].data * pos
	    if debug > 0 then print(2, disk[tail].data,  pos) end
	    pos = pos + 1
	 end
	 disk[i].len = disk[i].len - disk[tail].len
	 tail = tail - 2
      else
	 for n=1,disk[i].len do
	    sum = sum + disk[tail].data * pos
	    if debug > 0 then print(3, disk[tail].data,  pos) end
	    pos = pos + 1
	 end
	 disk[tail].len = disk[tail].len - disk[i].len
	 i = i + 1
      end
   end
until pos >= data

print(sum)

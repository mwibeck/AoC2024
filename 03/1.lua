#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local sum = 0

local data = io.open(args[1]):read("*a")

for x,y in data:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
   if debug > 1 then print(x,y) end
   sum = sum + x * y
end

print(sum)

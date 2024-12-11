#!/usr/local/bin/lua

args = {...}

bc = require'bc'
dofile("../utils.lua")

local debug = tonumber(args[3] or 0)

local line = io.open(args[1]):read("*a")
local stones = {}

for n in line:gmatch("(%d+)") do
   table.insert(stones, bc.new(n))
end

local function blink()
   local n = #stones
   for i=1,n do
      local str = tostring(stones[i])
      if bc.new(0) == stones[i] then
	 stones[i] = bc.new(1)
      elseif #str % 2 == 0 then
	 stones[i] = bc.new(str:sub(1,#str/2))
	 stones[#stones+1] = bc.new(str:sub(#str/2+1))
      else
	 stones[i] = bc.new(2024) * stones[i]
      end
   end
end

for i=1,args[2] do
   blink()
   print(#stones)
end

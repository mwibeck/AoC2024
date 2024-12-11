#!/usr/local/bin/lua

args = {...}

bc = require'bc'
dofile("../utils.lua")

local debug = tonumber(args[3] or 0)

local line = io.open(args[1]):read("*a")
local stones = {}
local number = {}

for n in line:gmatch("(%d+)") do
   stones[bc.new(n)] = (stones[bc.new(n)] or 0) + 1
   number[bc.new(n)] = {}
end

local zero = bc.new(0)
local one = bc.new(1)

local function calc(x, blinks)

   local str = tostring(x)
   if number[str] and number[str][blinks] then
      if debug > 1 then print("cached", str, blinks) end
      return number[str][blinks]
   end

   if debug > 1 then print("new", str, blinks) end
   
   if type(x) ~= "userdata" or type(blinks) ~= "number" then
      print(x, blink, type(x), type(blinks))
   end

   number[str] = number[str] or {}

   if blinks == 0 then
      number[str][blinks] = bc.new(1)
      return number[str][blinks]
   end
   if zero == x then
      -- 0 -> 1
      number[str][blinks] = calc(one, blinks-1)
      return number[str][blinks]
   end
   
   if #str % 2 == 0 then
      -- Split stone
      local left = bc.new(str:sub(1,#str/2))
      local right = bc.new(str:sub(#str/2+1))
      number[str][blinks] = calc(left, blinks-1) + calc(right, blinks-1)
      return number[str][blinks]
   end

   local new = bc.mul(x, 2024)
   number[str][blinks] = calc(new, blinks-1)
   return number[str][blinks]
end

local sum = bc.new(0)

for i,j in pairs(stones) do
   sum = sum + bc.mul(j, calc(bc.new(i), tonumber(args[2])))
end

print(sum)

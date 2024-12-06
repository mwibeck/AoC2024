#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local left, right = {}, {}

for line in io.lines(args[1]) do
   if debug > 1 then print(line) end
   local l,r = line:match("^(%d*)%s*(%d*)$")
   if debug > 0 then print(l,r) end

   l = tonumber(l)
   r = tonumber(r)
   
   right[r] = (right[r] or 0) + 1
   table.insert(left, l)
end

local sum = 0

for i,_ in ipairs(left) do
   sum = sum + left[i] * (right[left[i]] or 0)
end

print(sum)

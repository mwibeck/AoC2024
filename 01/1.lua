#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local left, right = {}, {}

for line in io.lines(args[1]) do
   if debug > 1 then print(line) end
   local l,r = line:match("^(%d*)%s*(%d*)$")
   if debug > 0 then print(l,r) end

   table.insert(left, l)
   table.insert(right, r)
end

table.sort(left)
table.sort(right)

local diff = 0

for i,_ in ipairs(left) do
   diff = diff + math.abs(left[i] - right[i])
end

print(diff)

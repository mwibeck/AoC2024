#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local sum = 0

local function isSafe(t)
   local first = t[1]-t[2]
   local ok
   
   if first <= -1 and first >= -3 then
      ok = function(v) return (v <= -1 and v >= -3) end
   elseif first >= 1 and first <= 3 then
      ok = function(v) return (v >= 1 and v <= 3) end
   else
      return 0
   end

   for i = 2,#t-1 do
      local d = t[i] - t[i+1]
      if not ok(d) then return 0 end
   end
   return 1 -- safe
end

for line in io.lines(args[1]) do
   if debug > 1 then print(line) end

   local l={}
   line:gsub("(%d*)", function(s) table.insert(l,tonumber(s)) return s end)

   sum = sum + isSafe(l)
end

print(sum)

#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local reports = {}
local rules = {}

for line in io.lines(args[1]) do
   if debug > 2 then print(line) end

   local lt,gt = line:match("(%d+)|(%d+)")
   if debug > 1 then print(lt, gt) end
   if lt and gt then
      lt = tonumber(lt)
      gt = tonumber(gt)
      rules[lt] = rules[lt] or {}
      rules[gt] = rules[gt] or {}
      rules[lt][gt] = true
      rules[gt][lt] = false
   elseif line ~= "" then
      reports[#reports+1] = loadstring("return { " .. line .. "}")()
   end
end

local function test(rep, n)
   for i=n+1,#rep do
      if rules[rep[n]][rep[i]] == false then
         return false
      end
   end
   return true
end

local sum = 0

for i,rep in ipairs(reports) do
   local pass = true
   local j = 1
   repeat
      if test(rep,j) == false then
         pass = false
      end
      j = j + 1
   until (j==#rep) or (not pass)
   if pass then
      sum = sum + rep[#rep/2+0.5]
   end
end
   
print(sum)

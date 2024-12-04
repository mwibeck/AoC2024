#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local sum = 0

local vert = {} -- down
local dr = {} -- down, right
local dl = {} -- down, left

local min_dr = 1 -- minimum diagonal index
local min_dl = 1 -- minimum diagonal index

local curLine = 0

local _, count

for line in io.lines(args[1]) do

   curLine = curLine + 1
   
   -- Might as well count horizontal here
   _, count = line:gsub("XMAS", "")
   sum = sum + count
   _, count = line:gsub("SAMX", "")
   sum = sum + count

   for i=1,#line do
      local c = line:sub(i,i)

      -- Insert in vertical
      vert[i] = vert[i] or {}
      vert[i][curLine] = c

      -- Insert in dr
      local x = i - curLine + 1
      min_dr = math.min(min_dr, x)
      dr[x] = dr[x] or {}
      local y = (x > 0) and (curLine) or (curLine + x - 1)
      dr[x][y] = c

      -- Insert in dl
      x = #line - i - curLine + 2
      min_dl = math.min(min_dl, x)
      dl[x] = dl[x] or {}
      y = (x > 0) and (curLine) or (curLine + x - 1)
      dl[x][y] = c
   end
end

-- Flatten+count vertical
for i=1,#vert do
   vert[i] = table.concat(vert[i], "")
   _, count = vert[i]:gsub("XMAS", "")
   sum = sum + count
   _, count = vert[i]:gsub("SAMX", "")
   sum = sum + count
end
-- Flatten+count dr
for i=min_dr,#dr do
   dr[i] = table.concat(dr[i], "")
   _, count = dr[i]:gsub("XMAS", "")
   sum = sum + count
   _, count = dr[i]:gsub("SAMX", "")
   sum = sum + count
end
-- Flatten+count dl
for i=min_dl,#dl do
   dl[i] = table.concat(dl[i], "")
   _, count = dl[i]:gsub("XMAS", "")
   sum = sum + count
   _, count = dl[i]:gsub("SAMX", "")
   sum = sum + count
end

print(sum)

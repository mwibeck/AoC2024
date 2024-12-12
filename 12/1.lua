#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local map = {}
local curLine = 0

local maxY
local maxX

for line in io.lines(args[1]) do
   curLine = curLine + 1

   for i=1,#line do
      c = line:sub(i,i)
      map[i] = map[i] or {}
      map[i][curLine] = c
   end
   maxY = curLine
   maxX = #line
end

-- Pad map
for x=0,maxX+1 do
   map[x] = map[x] or {}
   map[x][0] = " "
   map[x][maxY+1] = " "   
end

for y=0,maxY+1 do
   map[0][y] = " "
   map[maxX+1][y] = " "
end

if debug > 1 then
   for x=0,#map do
      for y=0,#map[x] do
         io.stdout:write(map[x][y])
      end
      io.stdout:write("\n")
   end
end

local mapped = {}

function collect(x, y, c, tbl)

   if mapped[x] and mapped[x][y] then return end
   if debug > 0 then print('collect', x, y, c) end

   mapped[x] = mapped[x] or {}
   mapped[x][y] = true
   table.insert(tbl, {x=x, y=y})
   tbl.plant = c
   
   -- area = area + 1
   tbl.area = (tbl.area or 0) + 1
   
   if map[x-1][y] == c then
      collect(x-1, y, c, tbl)
   else
      tbl.border = (tbl.border or 0) + 1
   end
   if map[x+1][y] == c then
      collect(x+1, y, c, tbl)
   else
      tbl.border = (tbl.border or 0) + 1
   end
   if map[x][y-1] == c then
      collect(x, y-1, c, tbl)
   else
      tbl.border = (tbl.border or 0) + 1
   end
   if map[x][y+1] == c then
      collect(x, y+1, c, tbl)
   else
      tbl.border = (tbl.border or 0) + 1
   end
end

local tbl = {}
local cP -- current plant

local plantCnt = {}

local x = 1

while x <= maxX do
   local y = 1
   while y <= maxY do
      if not (mapped[x] and mapped[x][y]) then
	 tbl[y*1000+x] = {}
	 collect(x, y, map[x][y], tbl[y*1000+x])
      end
      y = y + 1
   end
   x = x + 1
end

local sum = 0
local area = 0
for i,j in pairs(tbl) do
   if j.plant then
      sum = sum + j.border * j.area
      area = area + j.area
      if debug > 0 then
	 print(j[1].x, j[1].y, j.plant, j.border, j.area, j.border * j.area)
      end
   end
end

print(sum)

#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local ants = {} -- antennas
local an = {} -- antinodes

local curLine = 0

local maxX

-- Find antennas
for line in io.lines(args[1]) do

   curLine = curLine + 1
   maxX = #line
   for i=1,maxX do
      local c = line:sub(i,i)
      if c ~= "." then
	 ants[c] = ants[c] or {}
	 table.insert(ants[c], {x=i, y=curLine})
      end
   end
   an[curLine]={}
end

local maxY = curLine

local sum = 0

-- Go through all antenna pairs, marking antinodes, counting unique ones
for f,pos in pairs(ants) do

   for a=1,#pos-1 do
      for b=a+1,#pos do
	 dx = pos[a].x - pos[b].x
	 dy = pos[a].y - pos[b].y
	 an1x = pos[b].x - dx
	 an1y = pos[b].y - dy
	 an2x = pos[a].x + dx
	 an2y = pos[a].y + dy

	 if 0 < an1x and an1x <= maxX and 0 < an1y and an1y <= maxY then
	    if not an[an1y][an1x] then
	       sum = sum + 1
	       an[an1y][an1x] = true
	    end
	 end
	 if 0 < an2x and an2x <= maxX and 0 < an2y and an2y <= maxY then
	    if not an[an2y][an2x] then
	       sum = sum + 1
	       an[an2y][an2x] = true
	    end
	 end
      end
   end
end

print(sum)

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

	 cX = pos[a].x
	 cY = pos[a].y
	 -- forwards
	 while 0 < cX and cX <= maxX and 0 < cY and cY <= maxY do
	    if not an[cY][cX] then
	       sum = sum + 1
	       an[cY][cX] = true
	    end
	    cY = cY + dy
	    cX = cX + dx
	 end
	 cX = pos[a].x
	 cY = pos[a].y
	 -- backwards
	 while 0 < cX and cX <= maxX and 0 < cY and cY <= maxY do
	    if not an[cY][cX] then
	       sum = sum + 1
	       an[cY][cX] = true
	    end
	    cY = cY - dy
	    cX = cX - dx
	 end
      end
   end
end

print(sum)

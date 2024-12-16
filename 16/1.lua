#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local map = {}
local cost = {}
local curLine = 0
local START, END

local maxY
local maxX

for line in io.lines(args[1]) do
   curLine = curLine + 1
   for i=1,#line do
      c = line:sub(i,i)
      map[i] = map[i] or {}
      map[i][curLine] = c
      cost[i] = cost[i] or {}
      if c == "S" then
         START = {x=i, y=curLine}
      elseif c == "E" then
         END = {x=i, y=curLine}
      end
	 end
   maxY = curLine
   maxX = #line
end

if debug > 1 then
   for y=1,maxY do
      for x=1,maxX do
         io.stdout:write(map[x][y])
      end
      io.stdout:write("\n")
   end
end

local function move(x, y, dir, cc)
   
   print(x, y, dir, cc, cost[x][y])

   if cost[x][y] and (cc >= cost[x][y]) then
      -- no point in continuing
      return
   end
   cost[x][y] = cc
   
   if debug > 1 then
      for y=1,maxY do
	 for x=1,maxX do
	    io.stdout:write(string.format(" %3d ", cost[x][y] or 0))
	 end
	 io.stdout:write("\n")
      end
   end

   if map[x][y] == "E" then print("END", cc) return end -- we have arrived
   
   if dir == ">" then
      if map[x+1][y] ~= '#' then move(x+1, y, dir, cc+1) end
      if map[x][y-1] ~= "#" then move(x, y-1, "^", cc+1001) end
      if map[x][y+1] ~= "#" then move(x, y+1, "v", cc+1001) end
   elseif dir == "<" then
      if map[x-1][y] ~= '#' then move(x-1, y, dir, cc+1) end
      if map[x][y-1] ~= "#" then move(x, y-1, "^", cc+1001) end
      if map[x][y+1] ~= "#" then move(x, y+1, "v", cc+1001) end
   elseif dir == "^" then
      if map[x][y-1] ~= '#' then move(x, y-1, dir, cc+1) end
      if map[x-1][y] ~= "#" then move(x-1, y, "<", cc+1001) end
      if map[x+1][y] ~= "#" then move(x+1, y, ">", cc+1001) end
   else
      if map[x][y+1] ~= '#' then move(x, y+1, dir, cc+1) end
      if map[x-1][y] ~= "#" then move(x-1, y, "<", cc+1001) end
      if map[x+1][y] ~= "#" then move(x+1, y, ">", cc+1001) end
   end
end

move(START.x, START.y, ">", 0)
print(cost[END.x][END.y])

if debug > 1 then
   for y=1,maxY do
      for x=1,maxX do
	 io.stdout:write(map[x][y])
      end
      io.stdout:write("\n")
   end
end


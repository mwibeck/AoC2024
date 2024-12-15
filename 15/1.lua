#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local map = {}
local robot
local curLine = 0
local moves = ""

local maxY
local maxX

local part = 1

for line in io.lines(args[1]) do

   if #line == 0 then
      part = 2
   elseif part == 1 then
      curLine = curLine + 1

      for i=1,#line do
	 c = line:sub(i,i)
	 map[i] = map[i] or {}
	 map[i][curLine] = c
	 if c == "@" then
	    robot = {x=i, y=curLine}
	 end
      end
      maxY = curLine
      maxX = #line
   else
      moves = moves .. line
   end
end

if debug > 1 then
   for y=1,maxY do
      for x=1,maxX do
         io.stdout:write(map[x][y])
      end
      io.stdout:write("\n")
   end
end

local function move(x, y, dir)
   if dir == ">" then
      if map[x+1][y] == '#' then
	 -- wall, nothing happens
      elseif map[x+1][y] == '.' then
	 -- space, just move
	 if map[x][y] == "@" then
	    robot.x = x+1
	 end
	 map[x+1][y] = map[x][y]
	 map[x][y] = "."
      else
	 -- box, move it
	 move(x+1,y,dir)
	 if map[x+1][y] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.x = x+1
	    end
	    map[x+1][y] = map[x][y]
	    map[x][y] = "."
	 end
      end
   elseif dir == "<" then
      if map[x-1][y] == '#' then
	 -- wall, nothing happens
      elseif map[x-1][y] == '.' then
	 -- space, just move
	 if map[x][y] == "@" then
	    robot.x = x-1
	 end
	 map[x-1][y] = map[x][y]
	 map[x][y] = "."
      else
	 -- box, move it
	 move(x-1,y,dir)
	 if map[x-1][y] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.x = x-1
	    end
	    map[x-1][y] = map[x][y]
	    map[x][y] = "."
	 end
      end
   elseif dir == "^" then
      if map[x][y-1] == '#' then
	 -- wall, nothing happens
      elseif map[x][y-1] == '.' then
	 -- space, just move
	 if map[x][y] == "@" then
	    robot.y = y-1
	 end
	 map[x][y-1] = map[x][y]
	 map[x][y] = "."
      else
	 -- box, move it
	 move(x,y-1,dir)
	 if map[x][y-1] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.y = y-1
	    end
	    map[x][y-1] = map[x][y]
	    map[x][y] = "."
	 end
      end
   else
      if map[x][y+1] == '#' then
	 -- wall, nothing happens
      elseif map[x][y+1] == '.' then
	 -- space, just move
	 if map[x][y] == "@" then
	    robot.y = y+1
	 end
	 map[x][y+1] = map[x][y]
	 map[x][y] = "."
      else
	 -- box, move it
	 move(x,y+1,dir)
	 if map[x][y+1] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.y = y+1
	    end
	    map[x][y+1] = map[x][y]
	    map[x][y] = "."
	 end
      end
   end
end

for i=1,#moves do
   move(robot.x, robot.y, moves:sub(i,i))
end

local sum = 0

for y=1,maxY do
   for x=1,maxX do
      if debug > 1 then io.stdout:write(map[x][y]) end
      if map[x][y] == "O" then
	 sum = sum + (x-1) + (y-1) * 100
      end
   end
   if debug > 1 then io.stdout:write("\n") end
end

print(sum)

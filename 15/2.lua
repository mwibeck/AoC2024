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
	 map[i*2-1] = map[i*2-1] or {}
	 map[i*2] = map[i*2] or {}
	 map[i*2-1][curLine] = c == "O" and "[" or c
	 map[i*2][curLine] = c == "O" and "]" or c
	 if c == "@" then
	    robot = {x=i*2-1, y=curLine}
	    map[i*2][curLine] = "."
	 end
      end
      maxY = curLine
      maxX = #line*2
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

local function canmove(x, y, dir)
   if map[x][y] == "#" then return false end
   if dir == ">" then
      if map[x+1][y] == '#' then
	 -- wall, cannot
	 return false
      elseif map[x+1][y] == '.' then
	 return true
      else
	 -- box, ok if can move right part
	 return canmove(x+1,y,dir)
      end
   elseif dir == "<" then
      if map[x-1][y] == '#' then
	 -- wall, cannot
	 return false
      elseif map[x-1][y] == '.' then
	 return true
      else
	 -- box, ok if can move left part
	 return canmove(x-1,y,dir)
      end
   elseif dir == "^" then
      if map[x][y-1] == '#' then
	 -- wall, nothing happens
	 return false
      elseif map[x][y-1] == '.' then
	 -- space. can move unless this is a box part and the other is blocked
	 if map[x][y] == "[" then
	    return map[x+1][y-1] == "." or canmove(x+1, y-1, dir)
	 elseif map[x][y] == "]" then
	    return map[x-1][y-1] == "." or canmove(x-1, y-1, dir)
	 else
	    return true
	 end
      else
	 -- box, can move if it and we can move
	 if canmove(x, y-1, dir) then
	    if map[x][y] == "[" then
	       return map[x+1][y-1] == "." or canmove(x+1, y-1, dir)
	    elseif map[x][y] == "]" then
	       return map[x-1][y-1] == "." or canmove(x-1, y-1, dir)    
	    else
	       return true
	    end
	 else
	    return false
	 end
      end
   else
      if map[x][y+1] == '#' then
	 -- wall, nothing happens
	 return false
      elseif map[x][y+1] == '.' then
	 -- space. can move unless this is a box part and the other is blocked
	 if map[x][y] == "[" then
	    return map[x+1][y+1] == "." or canmove(x+1, y+1, dir)
	 elseif map[x][y] == "]" then
	    return map[x-1][y+1] == "." or canmove(x-1, y+1, dir)
	 else
	    return true
	 end
      else
	 -- box, can move if it and we can move
	 if canmove(x, y+1, dir) then
	    if map[x][y] == "[" then
	       return map[x+1][y+1] == "." or canmove(x+1, y+1, dir)
	    elseif map[x][y] == "]" then
	       return map[x-1][y+1] == "." or canmove(x-1, y+1, dir)    
	    else
	       return true
	    end
	 else
	    return false
	 end
      end
   end
end

local function move(x, y, dir)
   if canmove(x, y, dir) then
      if dir == ">" then
	 if map[x+1][y] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.x = x+1
	    end
	    map[x+1][y] = map[x][y]
	    map[x][y] = "."
	 else
	    -- box, move it
	    move(x+1,y,dir)
	    if map[x][y] == "@" then
	       robot.x = x+1
	    end
	    map[x+1][y] = map[x][y]
	    map[x][y] = "."
	 end
      elseif dir == "<" then
	 if map[x-1][y] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.x = x-1
	    end
	    map[x-1][y] = map[x][y]
	    map[x][y] = "."
	 else
	    -- box, move it
	    move(x-1,y,dir)
	    if map[x][y] == "@" then
	       robot.x = x-1
	    end
	    map[x-1][y] = map[x][y]
	    map[x][y] = "."
	 end
      elseif dir == "^" then
	 local obj = map[x][y]
	 if map[x][y-1] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.y = y-1
	    end
	    map[x][y-1] = map[x][y]
	    map[x][y] = "."
	 else
	    -- box, move it
	    move(x,y-1,dir)
	    if map[x][y] == "@" then
	       robot.y = y-1
	    end
	    map[x][y-1] = map[x][y]
	    map[x][y] = "."
	 end
	 if obj == "[" then
	    if map[x+1][y-1] ~= "." then
	       move(x+1,y-1,dir)
	    end
	    map[x+1][y-1] = map[x+1][y]
	    map[x+1][y] = "."
	 elseif obj == "]" then
	    if map[x-1][y-1] ~= "." then
	       move(x-1,y-1,dir)
	    end
	    map[x-1][y-1] = map[x-1][y]
	    map[x-1][y] = "."
	 end
      else
	 local obj = map[x][y]
	 if map[x][y+1] == '.' then
	    -- space, just move
	    if map[x][y] == "@" then
	       robot.y = y+1
	    end
	    map[x][y+1] = map[x][y]
	    map[x][y] = "."
	 else
	    -- box, move it
	    move(x,y+1,dir)
	    if map[x][y] == "@" then
	       robot.y = y+1
	    end
	    map[x][y+1] = map[x][y]
	    map[x][y] = "."
	 end
	 if obj == "[" then
	    if map[x+1][y+1] ~= "." then
	       move(x+1,y+1,dir)
	    end
	    map[x+1][y+1] = map[x+1][y]
	    map[x+1][y] = "."
	 elseif obj == "]" then
	    if map[x-1][y+1] ~= "." then
	       move(x-1,y+1,dir)
	    end
	    map[x-1][y+1] = map[x-1][y]
	    map[x-1][y] = "."
	 end
      end
   end
end


for i=1,#moves do
   move(robot.x, robot.y, moves:sub(i,i))

   for y=1,maxY do
      for x=1,maxX do
	 if debug > 1 then io.stdout:write(map[x][y]) end
      end
      if debug > 1 then io.stdout:write("\n") end
   end

end

local sum = 0

for y=1,maxY do
   for x=1,maxX do
      if debug > 1 then io.stdout:write(map[x][y]) end
      if map[x][y] == "[" then
	 sum = sum + (x-1) + (y-1) * 100
      end
   end
   if debug > 1 then io.stdout:write("\n") end
end

print(sum)

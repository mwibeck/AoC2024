#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local field = {}

local dir = 90
local spX, spY -- Guard start position
local pX, pY -- Guard position

local curLine = 0
for line in io.lines(args[1]) do
   curLine = curLine + 1

   for i=1,#line do
      local c = line:sub(i,i)
      if not spX and c == "^" then
	 spX = i
	 spY = curLine
	 c = "."
      end
      field[i] = field[i] or {}
      field[i][curLine] = c
   end
end

local maxX = #field
local maxY = #field[1]

field[0] = {}
field[maxX+1] = {}

for y=1,maxY do
   field[0][y]="."
   field[maxX+1][y]="."
end
for x=1,maxX do
   field[x][0]="."
   field[x][maxY+1]="."
end

function walk()
   local visited = {}
   for x=0,maxX+1 do
      visited[x] = {}
   end

   -- Walk the walk and check for loops
   repeat
      if visited[pX][pY] == dir then
	 -- loop!
	 return 1
      end
      if dir == 0 then
	 if field[pX+1][pY] == "." then
	    visited[pX][pY] = dir
	    pX = pX+1 -- step
	 else
	    dir = 270 -- turn
	 end
      elseif dir == 90 then
	 if field[pX][pY-1] == "." then
	    visited[pX][pY] = dir
	    pY = pY-1 -- step
	 else
	    dir = 0 -- turn
	 end      
      elseif dir == 180 then
	 if field[pX-1][pY] == "." then
	    visited[pX][pY] = dir
	    pX = pX-1 -- step
	 else
	    dir = 90 -- turn
	 end
      else
	 if field[pX][pY+1] == "." then
	    visited[pX][pY] = dir
	    pY = pY+1 -- step
	 else
	    dir = 180 -- turn
	 end
      end
   until pX < 1 or pX > maxX or pY < 1 or pY > maxY
   return 0
end

local sum = 0
for x=1,maxX do
   for y=1,maxY do
      pX = spX
      pY = spY
      dir = 90

      if (not (x == pX and y == pY)) and field[x][y] == "." then
	 field[x][y] = "#" -- place obstacle
	 local ok = walk()
	 sum = sum + ok
	 field[x][y] = "." -- restore field
      end
   end
end

print(sum)

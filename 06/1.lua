#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local field = {}
local curLine = 0

local _, count
local dir = 90

local pX, pY -- Guard position

for line in io.lines(args[1]) do
   curLine = curLine + 1

   for i=1,#line do
      c = line:sub(i,i)
      if not pX and c == "^" then
	 pX = i
	 pY = curLine
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

local visited = {}
for x=0,maxX+1 do
   visited[x] = {}
end

-- Walk the walk and count

local sum = 0

repeat
   if not visited[pX][pY] then
      sum = sum + 1
   end
   visited[pX][pY] = true
   if dir == 0 then
      if field[pX+1][pY] == "." then
	 pX = pX+1 -- step
      else
	 dir = 270 -- turn
      end
   elseif dir == 90 then
      if field[pX][pY-1] == "." then
	 pY = pY-1 -- step
      else
	 dir = 0 -- turn
      end      
   elseif dir == 180 then
      if field[pX-1][pY] == "." then
	 pX = pX-1 -- step
      else
	 dir = 90 -- turn
      end
   else
      if field[pX][pY+1] == "." then
	 pY = pY+1 -- step
      else
	 dir = 180 -- turn
      end
   end
until pX < 1 or pX > maxX or pY < 1 or pY > maxY

if debug > 1 then
   for y=1,maxY do
      local str = ""
      for x=1,maxX do
	 str = str .. (visited[x][y] and "X" or ".")
      end
      print(str)
   end
end

print(sum)

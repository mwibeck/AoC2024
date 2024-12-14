#!/usr/local/bin/lua

-- Ran this script, and grep-ed output for ########

args = {...}

local sizeX = tonumber(args[2] or 0)
local sizeY = tonumber(args[3] or 0)
local printS
local debug = tonumber(args[5] or 0)

if args[4] and args[4]:sub(1,1) == 'p' then
   printS = tonumber(args[4]:sub(2))
end

local robots = {} -- robots
local curRobot = 0

local sum = 0

-- Find robots and calculate end position
for line in io.lines(args[1]) do

   local x,y,vx,vy = line:match("p=(%-?%d+),(%-?%d+) v=(%-?%d+),(%-?%d+)")
   x = tonumber(x)
   y = tonumber(y)
   vx = tonumber(vx)
   vy = tonumber(vy)

   table.insert(robots, {x=x, y=y, vx=vx, vy=vy})
end

function printgrid(s)
   map = {}
   for x=0,sizeX-1 do
      map[x] = {}
      for y=0,sizeY-1 do
	 map[x][y] = " "
      end
   end

   for _,r in ipairs(robots) do
      local px = (r.x + s * r.vx) % sizeX
      local py = (r.y + s * r.vy) % sizeY
      
      map[px][py] = "#" --(tonumber(map[px][py]) or 0) + 1
   end
   for y=0,sizeY-1 do
      for x=0,sizeX-1 do
	 io.write(map[x][y])
      end
      io.write(" " .. s .. "\n")
   end
end

if not printS then
   local maxmaxX, maxmaxY = 0,0
   for s=0,10000 do
      printgrid(s)
   end
else
   printgrid(printS)
end

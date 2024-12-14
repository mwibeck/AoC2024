#!/usr/local/bin/lua

args = {...}

local sizeX = tonumber(args[2] or 0)
local sizeY = tonumber(args[3] or 0)
local secs = tonumber(args[4] or 0)
local debug = tonumber(args[5] or 0)

local robots = {{}, {}, {}, {}} -- robots in each quadrant
local curRobot = 0

local sum = 0

-- Find robots and calculate end position
for line in io.lines(args[1]) do

   local x,y,vx,vy = line:match("p=(%-?%d+),(%-?%d+) v=(%-?%d+),(%-?%d+)")
   x = tonumber(x)
   y = tonumber(y)
   vx = tonumber(vx)
   vy = tonumber(vy)

   local px = (x + secs * vx) % sizeX
   local py = (y + secs * vy) % sizeY

   local quad
   if px < (sizeX-1)/2 and py < (sizeY-1)/2 then
      quad = 1
   elseif px > (sizeX-1)/2 and py < (sizeY-1)/2 then
      quad = 2
   elseif px < (sizeX-1)/2 and py > (sizeY-1)/2 then
      quad = 3
   elseif px > (sizeX-1)/2 and py > (sizeY-1)/2 then
      quad = 4
   end
   if quad then
      table.insert(robots[quad], {x=px, y=py})
   end
end

print(#robots[1]*#robots[2]*#robots[3]*#robots[4])

#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

bc = require'bc'
bc.digits(10)

local machs = {}
local idx = 1
local sum = 0

for l in io.lines(args[1]) do

   local ax, ay = l:match("Button A: X%+(%d+), Y%+(%d+)")
   local bx, by = l:match("Button B: X%+(%d+), Y%+(%d+)")
   local px, py = l:match("Prize: X=(%d+), Y=(%d+)")

   if debug > 3 then print(l, idx, ax, ay, bx, by, px, py) end
   
   if ax and ay then
      machs[idx] = {ax=bc.new(ax), ay=bc.new(ay)}
   elseif bx and by then
      machs[idx].bx = bc.new(bx)
      machs[idx].by = bc.new(by)
   elseif px and py then
      machs[idx].px = bc.new(px)
      machs[idx].py = bc.new(py)
      local m=machs[idx]
      local mBY = bc.mul("10000000000000", m.by)
      local mBX = bc.mul("10000000000000", m.bx)
      local A = (m.px*m.by + mBY - m.py*m.bx - mBX)  / (m.ax*m.by - m.ay*m.bx)
      local B = (bc.add("10000000000000", m.py) - A * m.ay) / m.by

      -- Check integerness
      if tostring(A):match("%.0+$") and tostring(B):match("%.0+$") then
	 local cost = A*3 + B
	 if debug > 2 then print("OK A,B:", A, B, "cost:", cost) end
	 machs[idx].cost = cost
	 machs[idx].A = A
	 machs[idx].B = B
	 idx = idx + 1
	 sum = sum + cost
      else
	 if debug > 2 then print("Not int A,B:", A, B) end
      end
   end
end

print(bc.trunc(sum))

--[[
A * ax + B * bx = px
A * ay + B * by = py

A = (px - B * bx) / ax
B = (py - A * ay) / by

A = (px - py*bx/by) / (ax - ay*bx/by)
--]]

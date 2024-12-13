#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local machs = {}
local idx = 1
local sum = 0

for l in io.lines(args[1]) do

   local ax, ay = l:match("Button A: X%+(%d+), Y%+(%d+)")
   local bx, by = l:match("Button B: X%+(%d+), Y%+(%d+)")
   local px, py = l:match("Prize: X=(%d+), Y=(%d+)")

   if debug > 3 then print(l, idx, ax, ay, bx, by, px, py) end
   
   if ax and ay then
      machs[idx] = {ax=tonumber(ax), ay=tonumber(ay)}
   elseif bx and by then
      machs[idx].bx = tonumber(bx)
      machs[idx].by = tonumber(by)
   elseif px and py then
      machs[idx].px = tonumber(px)
      machs[idx].py = tonumber(py)
      local m=machs[idx]
      local A = (m.px - m.py*m.bx/m.by) / (m.ax - m.ay*m.bx/m.by)
      local B = (m.py - A * m.ay) / m.by

      if A >= 0 and A <= tonumber(100) and B >= 0 and B <= tonumber(100) then
	 if not (tostring(A):find("%.") and tostring(B):find("%.")) then
	    local cost = A*3 + B
	    if debug > 2 then print("OK A,B:", A, B, "cost:", cost) end
	    machs[idx].cost = cost
	    machs[idx].A = A
	    machs[idx].B = B
	    idx = idx + 1
	    sum = sum + cost
	 else
	    if debug > 1 then print("Not int A,B:", A, B, "cost:", cost) end
	 end
      else
	 if debug > 1 then print("not in rng A,B:", A, B, "cost:", cost) end
      end
   end
end

print(sum)

--[[
A * ax + B * bx = px
A * ay + B * by = py

A = (px - B * bx) / ax
B = (py - A * ay) / by

A = (px - py*bx/by) / (ax - ay*bx/by)
--]]

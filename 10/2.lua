#!/usr/local/bin/lua

args = {...}

local debug = tonumber(args[2] or 0)

local map = {}
local curLine = 0

local heads = {}
local tails = {}

for line in io.lines(args[1]) do
   curLine = curLine + 1

   map[0] = map[0] or {}
   map[#line+1] = map[#line+1] or {}
   for i=1,#line do
      c = tonumber(line:sub(i,i))
      map[i] = map[i] or {}
      map[i][curLine] = c

      if c == 0 then
	 table.insert(heads, {x=i, y=curLine})
      end
      if c == 9 then
	 tails[i] = tails[i] or {}
	 table.insert(tails, {x=i, y=curLine, visits={}})
	 tails[i][curLine] = {idx=#tails}
      end
   end
end

local reaches = {}

local sum = 0

local function walk(h, i, x, y)
   if h == 9 then
      -- Reached a top
      print(i, "reached", x, y)
      sum = sum + 1
--      tails[tails[x][y].idx].visits[i] =
--	  (tails[tails[x][y].idx].visits[i] or 0) + 1
      return
   end
   
   if map[x-1][y] == h+1 then
      walk(h+1, i, x-1, y)
   end
   if map[x+1][y] == h+1 then
      walk(h+1, i, x+1, y)
   end
   if map[x][y-1] == h+1 then
      walk(h+1, i, x, y-1)
   end
   if map[x][y+1] == h+1 then
      walk(h+1, i, x, y+1)
   end
end

for i,j in pairs(heads) do
   walk(0, i, j.x, j.y)
end

for i,j in ipairs(tails) do
--   sum = sum + j.visits
end

print(sum)

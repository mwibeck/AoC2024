#!/usr/local/bin/lua-5.1

args = {...}

local debug = tonumber(args[2] or 0)

local sum = 0

local dr = {} -- down, right
local dl = {} -- down, left

local min_dr = 1 -- minimum diagonal index
local min_dl = 1 -- minimum diagonal index

local A_idx = {} -- Index in dl and dr of all A's

local curLine = 0

local _, count

for line in io.lines(args[1]) do

   curLine = curLine + 1
   
   for i=1,#line do
      local c = line:sub(i,i)
      local idx
      
      -- Insert in dr
      local x = i - curLine + 1
      min_dr = math.min(min_dr, x)
      dr[x] = dr[x] or {}
      local y = (x > 0) and (curLine) or (curLine + x - 1)
      dr[x][y] = c
      if c == "A" then
	 idx = {}
	 idx.dr = {x=x, y=y}
      end
      
      -- Insert in dl
      x = #line - i - curLine + 2
      min_dl = math.min(min_dl, x)
      dl[x] = dl[x] or {}
      y = (x > 0) and (curLine) or (curLine + x - 1)
      dl[x][y] = c
      if c == "A" then
	 idx.dl = {x=x, y=y}
	 table.insert(A_idx, idx)
      end
   end
end

-- Go through all A's, check them
for i,c in pairs(A_idx) do
   
   if ((dl[c.dl.x][c.dl.y-1] == 'M' and dl[c.dl.x][c.dl.y+1] == 'S') or
      (dl[c.dl.x][c.dl.y-1] == 'S' and dl[c.dl.x][c.dl.y+1] == 'M')) and
      ((dr[c.dr.x][c.dr.y-1] == 'M' and dr[c.dr.x][c.dr.y+1] == 'S') or
	 (dr[c.dr.x][c.dr.y-1] == 'S' and dr[c.dr.x][c.dr.y+1] == 'M'))
   then
      sum = sum + 1
   end
end

print(sum)

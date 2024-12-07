#!/usr/local/bin/lua

bc = require'bc'
args = {...}

local debug = tonumber(args[2] or 0)

function table.map(t, f)
   local tbl = {}
   for i,j in pairs(t) do
      tbl[i] = f(j)
   end
   return tbl
end

function table.zip(t1, t2)
   local tbl = {}
   local i=1
   repeat
      table.insert(tbl, t1[i])
      table.insert(tbl, t2[i])
      i = i + 1
   until i <= #t1 and i <= #t2
   return tbl
end

function table.zipmap(t1, t2, f1, f2)
   local tbl = {}
   local i=1
   repeat
      table.insert(tbl, f1(t1[i]))
      table.insert(tbl, f2(t2[i]))
      i = i + 1
   until (i > #t1) and (i > #t2)
   return tbl
end

local maxn = 0

local data = {}
for line in io.lines(args[1]) do
   local res, inp = line:match("(%d+): (.*)$")
   local input = {}
   inp:gsub("(%d+)", function(d) table.insert(input, bc.new(d)) end)
   res = bc.new(res)

   if #input > maxn then maxn = #input end
  
   table.insert(data, {res=res, inp=input})
end

print(maxn)

local function eval(res, inp, op)
   local curr = inp[1]
   
   local i = 1
   repeat
      curr = (op[i] == "+") and (curr + inp[i+1]) or (curr * inp[i+1])
      i = i + 1
   until (curr > res) or (i > #op)

   return curr == res
end

local function genops(n, len)
   local ops = {}
   local p = n

   for i=1,len do
      local x
      n, x = bc.quotrem(n, 2)
      x = bc.tonumber(x)
      if x == 0 then
	 table.insert(ops, "*")
      elseif x == 1 then
	 table.insert(ops, "+")
      end
   end
   if debug > 0 then print(p, len, table.concat(ops, " ")) end
   return ops
end

local sum = bc.new(0)
local pI = 1

repeat
   problem = data[pI]
   local n = #problem.inp-1
   local i = 0
   repeat
      local ops = genops(i, n)
      if eval(problem.res, problem.inp, ops) then
	 sum = sum + problem.res
	 print(problem.res, "==", table.concat(table.zipmap(problem.inp, ops, tostring, tostring), " "))
	 -- go to next problem
	 i = 2^n
      else
	 i = i+1
      end
   until i > (2^n)-1
   pI = pI + 1
until pI > #data

print(sum)

#!/usr/local/bin/lua

local args = {...}
local debug = tonumber(args[2] or 0)

--bc = require'bc'
local mem = {}
local output = {}
local A, B, C = 0,0,0
local pc

local function bxor(a,b)--Bitwise xor
   local p,c=1,0
   while a>0 and b>0 do
      local ra,rb=a%2,b%2
      if ra~=rb then c=c+p end
      a,b,p=(a-ra)/2,(b-rb)/2,p*2
   end
   if a<b then a=b end
   while a>0 do
      local ra=a%2
      if ra>0 then c=c+p end
      a,p=(a-ra)/2,p*2
   end
   return c
end

local function getCombo(x)
   if x >=0 and x <=3 then return x end
   if x == 4 then return A end
   if x == 5 then return B end
   if x == 6 then return C end
end

local ops = {
   [0] = function(arg)
            local x = getCombo(arg)
            A = math.floor(A / math.pow(2, x))
            pc = pc + 2
         end,
   [1] = function(arg)
            B = bxor(B, arg)
            pc = pc + 2
         end,
   [2] = function(arg)
            local x = getCombo(arg)
            B = x % 8
            pc = pc + 2
         end,
   [3] = function(arg)
            if A == 0 then pc = pc + 2 return end
            pc = arg+1
         end,
   [4] = function(arg)
            B = bxor(B, C)
            pc = pc + 2
         end,
   [5] = function(arg)
            local x = getCombo(arg) % 8
            table.insert(output, x)
            pc = pc + 2
         end,
   [6] = function(arg)
            local x = getCombo(arg)
            B = math.floor(A / math.pow(2, x))
            pc = pc + 2
         end,
   [7] = function(arg)
            local x = getCombo(arg)
            C = math.floor(A / math.pow(2, x))
            pc = pc + 2
         end
}

for l in io.lines(args[1]) do
   local a = l:match("Register A: (%d+)")
   local b = l:match("Register B: (%d+)")
   local c = l:match("Register C: (%d+)")
   local prog = l:match("Program: ([%d,]+)")
   
   if a then A = tonumber(a) end
   if b then B = tonumber(b) end
   if c then C = tonumber(c) end
   if prog then mem = loadstring("return {" .. prog .. "}")() end
end

print(bxor(0, 2))

pc = 1
repeat
   if debug > 0 then print(mem[pc], mem[pc+1], A, B, C) end
   ops[mem[pc]](mem[pc+1])
until not mem[pc]

print(table.concat(output, ","))

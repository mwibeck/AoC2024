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

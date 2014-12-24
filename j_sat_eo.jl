
f = open("frb30-15-cnf/frb30-15-1.cnf")
for i in readlines(f)
  for j in split(i)
    println(j)
  end
end

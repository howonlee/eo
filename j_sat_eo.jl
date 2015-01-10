
f = open("frb30-15-cnf/frb30-15-1.cnf")
for i in readlines(f)
  for j in split(i)
    #add to the proper formatting
    println(j)
  end
end

for i in 1:10000
  #take a local step
end

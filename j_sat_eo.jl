using PyPlot
using Distributions

function read_file(filename):
  pos_constraints = (String => Any)[]
  neg_constraints = (String => Any)[]
  num_vars = -1
  num_clauses = -1
  f = open("frb30-15-cnf/frb30-15-1.cnf")
  for line in f:
    if line[0] == "c":
      continue
    end
    if line[0] == "p":
      p, cnf, _vars, _clauses = line.split()
      num_vars = int(_vars)
      num_clauses = int(_clauses)
      continue
    end
    clause = map(int, line.split())
    for var in clause:
      if var > 0:
        pos_constraints[var].update(set(clause))
      end
      if var < 0:
        neg_constraints[var].update(set(clause))
      end
    end
  end
  for key, val in pos_constraints.iteritems():
    if key in val:
      val.remove(key)
    end
    if 0 in val:
      val.remove(0)
    end
  end
  for key, val in neg_constraints.iteritems():
    if key in val:
      val.remove(key)
    end
    if 0 in val:
      val.remove(0)
    end
  end
  close(f)
  return pos_constraints, neg_constraints, num_vars, num_clauses
end

for i in readlines(f)
  for j in split(i)
    #add to the proper formatting
    println(j)
  end
end

for i in 1:10000
  #take a local step
end

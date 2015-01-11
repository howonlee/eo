using PyPlot
using Distributions

function parse_cnf(filename):
  pos_constraints = (Int => Int)[]
  neg_constraints = (Int => Int)[]
  num_vars = -1
  num_clauses = -1
  f = open(filename)
  for line in eachline(f)
    if line[1] == "c"
      continue
    end
    if line[1] == "p":
      split_line = split(line)
      p, cnf, _vars, _clauses = split_line[1], split_line[2], split_line[3], split_line[4]
      num_vars = parseint(_vars)
      num_clauses = parseint(_clauses)
      continue
    end
    clause = map(parseint, line.split())
    set_clause = Set(clause)
    for var in clause
      if var > 0
        pos_constraints[var].update(set(clause)) ####
      end
      if var < 0
        neg_constraints[var].update(set(clause)) #####
      end
    end
  end
  for key in keys(pos_constraints)
    val = get(pos_constraints, key)
    if haskey(val, key)
      delete!(val, key)
    end
    if haskey(val, 0)
      delete!(val, 0)
    end
  end
  for key in neg_constraints
    val = get(pos_constraints, key)
    if haskey(val, key)
      delete!(val, key)
    end
    if haskey(val, 0)
      delete!(val, 0)
    end
  end
  close(f)
  return pos_constraints, neg_constraints, num_vars, num_clauses
end

### main program begins

pos_constraints, neg_constraints, num_vars, num_clauses = parse_cnf("frb30-15-cnf/frb30-15-1.cnf")
print(pos_constraints)
print(neg_constraints)
print(num_vars)
print(num_clauses)

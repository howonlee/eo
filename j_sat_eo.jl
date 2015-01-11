using PyPlot
using Distributions

function parse_cnf(filename)
  pos_constraints = (Int => Set)[]
  neg_constraints = (Int => Set)[]
  num_vars = -1
  num_clauses = -1
  f = open(filename)
  for line in eachline(f)
    if line[1] == 'c'
      continue
    end
    if line[1] == 'p'
      split_line = split(line)
      p, cnf, _vars, _clauses = split_line
      num_vars = parseint(_vars)
      num_clauses = parseint(_clauses)
      continue
    end
    clause = map(parseint, split(line))
    clause_set = Set(clause)
    for var in clause
      if var > 0
        pos_constraints[var] = clause_set
      end
      if var < 0
        neg_constraints[var] = clause_set
      end
    end
  end
  for key in keys(pos_constraints)
    val = get(pos_constraints, key, Set)
    if haskey(pos_constraints, key)
      delete!(val, key)
    end
    if haskey(pos_constraints, 0)
      delete!(val, 0)
    end
  end
  for key in neg_constraints
    val = get(pos_constraints, key, Set)
    if haskey(pos_constraints, key)
      delete!(val, key)
    end
    if haskey(pos_constraints, 0)
      delete!(val, 0)
    end
  end
  close(f)
  return pos_constraints, neg_constraints, num_vars, num_clauses
end

function flip_eo(fitness, soln, tau=1.4)
    k = length(soln)
    while k > length(soln)-1:
      k = int(np.random.pareto(tau)) ####
    end
    worst = fitness.argsort()[k] ####
    new_soln = soln.copy() #### do a deep copy
    new_soln[worst] = !new_soln[worst] ####
    new_soln
end

### main program begins

pos_constraints, neg_constraints, num_vars, num_clauses = parse_cnf("frb30-15-cnf/frb30-15-1.cnf")
print(pos_constraints)
print(neg_constraints)
print(num_vars)
print(num_clauses)

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

function random_init(num_vars)
  return npr.random(num_vars) > 0.5
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

function calc_hypothetical_fitness(hypothetical, pos_constraints, neg_constraints)
  #####################
  fitness = 0
  for x in xrange(hypothetical.size):
    for y in pos_constraints[x]:
      if hypothetical[x-1] != hypothetical[y-1]:
        fitness -= 1
      end
    end
    for y in neg_constraints[x]:
      if hypothetical[x-1] == hypothetical[y-1]:
        fitness -= 1
      end
    end
  end
  return fitness
end

function calc_local_fitness(assignment, pos_constraints, neg_constraints)
  #####################
  fitness = np.zeros_like(assignment, dtype=np.int32)
  for x in (the damn thing):
    stuff
  end
  fitness
end

### main program begins

pos_constraints, neg_constraints, num_vars, num_clauses = parse_cnf("frb30-15-cnf/frb30-15-1.cnf")
print(pos_constraints)
print(neg_constraints)
print(num_vars)
print(num_clauses)

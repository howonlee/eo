using PyPlot
using Distributions

function parse_cnf(filename):
  pos_constraints = (String => Any)[]
  neg_constraints = (String => Any)[]
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
    for var in clause
      if var > 0
        pos_constraints[var].update(set(clause)) ####
      end
      if var < 0
        neg_constraints[var].update(set(clause)) #####
      end
    end
  end
  for key, val in pos_constraints.iteritems() ####
    if key in val ###
      val.remove(key) ###
    end
    if 0 in val ###
      val.remove(0) ####
    end
  end
  for key, val in neg_constraints.iteritems() ####
    if key in val ###
      val.remove(key) ####
    end
    if 0 in val ####
      val.remove(0) ####
    end
  end
  close(f)
  return pos_constraints, neg_constraints, num_vars, num_clauses
end

### main program begins

pos_constraints, neg_constraints, num_vars, num_clauses = parse_cnf("frb30-15-cnf/frb30-15-1.cnf")

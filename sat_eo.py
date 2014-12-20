import collections
import numpy as np
import numpy.random as npr

def read_file(filename):
    pos_constraints = collections.defaultdict(set)
    neg_constraints = collections.defaultdict(set)
    num_vars = -1
    num_clauses = -1
    with open(filename, "r") as f:
        for line in f:
            if line[0] == "c":
                continue
            if line[0] == "p":
                p, cnf, _vars, _clauses = line.split()
                num_vars = int(_vars)
                num_clauses = int(_clauses)
                continue
            clause = map(int, line.split())
            for var in clause:
                if var > 0:
                    pos_constraints[var].update(set(clause))
                if var < 0:
                    neg_constraints[var].update(set(clause))
        for key, val in pos_constraints.iteritems():
            if key in val:
                val.remove(key)
            if 0 in val:
                val.remove(0)
        for key, val in neg_constraints.iteritems():
            if key in val:
                val.remove(key)
            if 0 in val:
                val.remove(0)
    return pos_constraints, neg_constraints, num_vars, num_clauses

def random_init(num_vars):
    return npr.random(num_vars) > 0.5

def calc_local_fitness(assignment, pos_constraints, neg_constraints):
    fitness = np.zeros_like(assignment)
    for x in xrange(assignment.size):
        for y in pos_constraints[x]:
            pass
        for y in neg_constraints[x]:
            pass
    return fitness

if __name__ == "__main__":
    pos_constraints, neg_constraints, num_vars, num_clauses = read_file("frb30-15-cnf/frb30-15-1.cnf")
    #print "file read..."
    print random_init(num_vars)

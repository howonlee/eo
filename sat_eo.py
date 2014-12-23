import collections
import operator
import numpy as np
import numpy.random as npr
import random

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
    fitness = np.zeros_like(assignment, dtype=np.int32)
    for x in xrange(assignment.size):
        for y in pos_constraints[x]:
            if assignment[x-1] == assignment[y-1]:
                fitness[x] += 1
        for y in neg_constraints[x]:
            if assignment[x-1] != assignment[y-1]:
                fitness[x] += 1
    return fitness

def get_kth_highest_arg(ls, k):
    return sorted(enumerate(ls), key=operator.itemgetter(1), reverse=True)[k][0]

def flip_eo(fitness, soln, tau=1.5):
    k = len(soln)
    while k > len(soln)-1:
        k = int(np.random.pareto(tau))
    worst_city = get_kth_highest_arg(fitness, k)
    new_soln = soln.copy() #deep copy
    new_soln[worst_city] = not new_soln[worst_city]
    return new_soln

if __name__ == "__main__":
    npr.seed(1337)
    random.seed(1337)
    pos_constraints, neg_constraints, num_vars, num_clauses = read_file("frb30-15-cnf/frb30-15-1.cnf")
    #print "file read..."
    init_soln = random_init(num_vars)
    soln = init_soln
    fitness = np.zeros_like(soln)
    for i in xrange(100):
        fitness = calc_local_fitness(soln, pos_constraints, neg_constraints)
        soln = flip_eo(fitness, soln)
    print "soln: ", soln
    print "fitness: ", fitness

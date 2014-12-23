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

def calc_hypothetical_fitness(hypothetical, pos_constraints, neg_constraints):
    fitness = 0
    for x in xrange(hypothetical.size):
        for y in pos_constraints[x]:
            if hypothetical[x-1] != hypothetical[y-1]:
                fitness -= 1
        for y in neg_constraints[x]:
            if hypothetical[x-1] == hypothetical[y-1]:
                fitness -= 1
    return fitness

def calc_local_fitness(assignment, pos_constraints, neg_constraints):
    fitness = np.zeros_like(assignment, dtype=np.int32)
    for x in xrange(assignment.size):
        assignment[x] = not assignment[x]
        fitness[x] = calc_hypothetical_fitness(assignment, pos_constraints, neg_constraints)
        assignment[x] = not assignment[x]
    return fitness

def flip_eo(fitness, soln, tau=1.5):
    k = len(soln)
    while k > len(soln)-1:
        k = int(np.random.pareto(tau))
    worst = fitness.argsort()[k]
    new_soln = soln.copy() #deep copy
    new_soln[worst] = not new_soln[worst]
    return new_soln

if __name__ == "__main__":
    npr.seed(1337)
    random.seed(1337)
    pos_constraints, neg_constraints, num_vars, num_clauses = read_file("frb30-15-cnf/frb30-15-1.cnf")
    #print "file read..."
    init_soln = random_init(num_vars)
    soln = init_soln
    best_soln = init_soln
    fitness = np.zeros_like(soln, dtype=np.int32)
    best_fitness = float("inf")
    dim = 20
    for i in xrange(dim):
        if i % (dim // 10) == 0:
            print "i / dim: ", i, " / ", dim
        fitness = calc_local_fitness(soln, pos_constraints, neg_constraints)
        soln = flip_eo(fitness, soln)
        if fitness.sum() < best_fitness:
            best_fitness = fitness.sum()
            best_soln = soln
    print "soln: ", best_soln
    print "fitness: ", best_fitness
    print "local fitness: ", calc_local_fitness(best_soln, pos_constraints, neg_constraints)

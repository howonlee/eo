
if __name__ == "__main__":
    with open("frb30-15-cnf/frb30-15-1.cnf", "r") as f:
        for line in f:
            if line[0] == "c":
                continue
            if line[0] == "p":
                p, cnf, num_vars, num_clauses = line.split()
                num_vars = int(num_vars)
                num_clauses = int(num_clauses)
            clause = line.split()
            print clause

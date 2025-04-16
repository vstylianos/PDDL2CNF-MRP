from time import time
from pysat.formula import IDPool, CNF, WCNF

from pysat.examples.musx import MUSX
from utils import *
from algorithms import *
from pysat.solvers import Solver
from supports import *
from arguments import *
import time







V_h = set()
KB1 = CNF(from_file='./general_SAT/BN-1/KBa.cnf')
V_a = get_vars(KB1)
# KB2 = CNF(from_file='./general_SAT/BN-2/KBh.cnf')
# q = CNF(from_file='./general_SAT/BN-1/query.cnf')

q = CNF()
for i in [154, 172, 173, -188, 189, 240, 256]:
    q.append([i])
    V_h.add(abs(i))

# print(V_h)



print(skeptical_entailment(KB1.clauses, [], q))
print(sat(KB1.clauses, []))

# print(explanation(KB1, q))
# exit()
# print()
# print()
# print()
# print()
# print(V_a)
# print(len(V_h))


def scenarios(perc):
    # Build vocabulary:
 
    r = random.sample(list(V_a), int(perc*len(V_a)))
    for v in r:
        V_h.add(v)

    st = time.time()
    e = abstracted_explanation_generation(KB1, q, V_h)
    print(skeptical_entailment(e, [], q))
    # print(sat(e, []))

    en = time.time()
    print("Time elapsed: ", en -st, "|M_a|: ", len(KB1.clauses), "|V_h|", len(V_h), "|e|", len(e))


scenarios(0.3)




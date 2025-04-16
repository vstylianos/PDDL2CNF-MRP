import itertools
import random
import time
import unified_planning
from unified_planning.shortcuts import *
from unified_planning.io.pddl_reader import PDDLReader
from unified_planning.engines import CompilationKind
from planning_utils.CNF_Encoder import Encoder
from planning_utils.CNF_Encoder_KBh import Encoder_KBh
up.shortcuts.get_env().credits_stream = None


from pysat.formula import CNF, WCNF
from pysat.examples.lbx import LBX
from algorithms import *



reader = PDDLReader()
pddl_agent = reader.parse_problem('./instances/blocks/default/original_domain.pddl', './instances/blocks/default/prob1.pddl')
pddl_human = reader.parse_problem('./instances/blocks/Vary_Kbh/human8.pddl', './instances/blocks/default/prob1.pddl')




with OneshotPlanner(problem_kind=pddl_agent.kind) as planner:
    result = planner.solve(pddl_agent)
    plan = result.plan
with Compiler(problem_kind=pddl_agent.kind, compilation_kind=CompilationKind.GROUNDING) as grounder:
    grounding_result_agent = grounder.compile(pddl_agent, CompilationKind.GROUNDING)
    grounding_result_human = grounder.compile(pddl_human, CompilationKind.GROUNDING)
    ground_problem_agent = grounding_result_agent.problem
    ground_problem_human = grounding_result_human.problem



horizon = len(plan.actions)

print(plan)
print(horizon)

KBa, kba_vars = Encoder(ground_problem_agent, horizon).encode()
KBh, kbh_vars = Encoder_KBh(ground_problem_human, horizon, kba_vars).encode()


q_prob1 = CNF(from_clauses=[[kba_vars["pickup_B_0"]], [kba_vars["stack_B_A_1"]], [kba_vars["pickup_C_2"]], [kba_vars["stack_C_B_3"]]])





q = q_prob1




# Create query:
# filter = []
# for i in KBa.get_model():
#     if i>0 and KBa.get_name_from_id(i) in KBa.fluents_all_steps:
#         if int(KBa.get_name_from_id(i)[-1])>2:
#             filter.append([i])
        # print(KBa.get_name_from_id(i))




def make_query(r):
    while True:
        for l in range(r, len(filter)+1):
            for sub in itertools.combinations(list(filter), l):
                query = CNF(from_clauses=sub)
                if skeptical_entailment(KBa.all_formulae(),[], query):
                    return query


def translate_clauses_to_english(clauses, kb_vars):
    """
    Translate CNF clauses to English by mapping variable IDs to their names.
    Args:
        clauses: List of CNF clauses (each clause is a list of literals)
        kb_vars: Dictionary mapping variable names to their CNF IDs
    
    Returns:
        List of English translations of each clause
    """
    # Create reverse mapping (ID → name)
    id_to_name = {v: k for k, v in kb_vars.items()}
    
    translations = []
    for clause in clauses:
        clause_terms = []
        for literal in clause:
            var_id = abs(literal)
            negation = "NOT " if literal < 0 else ""
            
            if var_id in id_to_name:
                var_name = id_to_name[var_id]
                # All PDDL variables have format: predicate_or_action_name(_args)*_timestep
                parts = var_name.split('_')
                
                # Last part is always the timestep in our encoding
                if parts and parts[-1].isdigit():
                    time_step = parts[-1]
                    # Join all parts except the time step to get the predicate/action name and args
                    name_with_args = '_'.join(parts[:-1])
                    
                    # Try to separate predicate/action name from its arguments
                    # Most common format is predicate_arg1_arg2_..._argN
                    name_parts = name_with_args.split('_')
                    if len(name_parts) > 1:
                        predicate = name_parts[0]
                        args = name_parts[1:]
                        args_str = ' '.join(args)
                        
                        # Format: [NOT] predicate(args) at timestep
                        description = f"{negation}{predicate}({args_str}) at step {time_step}"
                    else:
                        # No arguments, just the predicate/action name
                        description = f"{negation}{name_with_args} at step {time_step}"
                else:
                    # No timestep found or irregular format
                    description = f"{negation}{var_name}"
            else:
                description = f"{negation}Unknown variable (ID: {var_id})"
            
            clause_terms.append(description)
        
        # Combine terms in the clause with OR (since CNF clauses are disjunctions)
        if len(clause_terms) > 1:
            translation = "EITHER " + " OR ".join(clause_terms)
        else:
            translation = clause_terms[0] if clause_terms else "Empty clause"
        
        translations.append(translation)
    
    return translations


# n_query = make_query(5)

# n_query = CNF()
# kba = CNF(from_file='./benchmarks/rover1/KBa.cnf')
# for i in [-9, -486, -500, -514]:
#     n_query.append([i])


print("KBa entails query:", skeptical_entailment(KBa.all_formulae(),[], q))
print("KBh entails query:", skeptical_entailment(KBh.all_formulae(),[], q))

print(len(KBa.all_formulae()))

def identify_formula_type(clause, kb):
    """
    Identify the type of formula (precondition, effect, frame axiom, etc.)
    
    Args:
        clause: The clause to identify
        kb: The knowledge base object containing categorized clauses
        
    Returns:
        String description of the formula type
    """
    # Convert to tuple for comparison since lists aren't hashable
    clause_tuple = tuple(sorted(clause))
    
    # Check initial state clauses
    for init_clause in kb.inits:
        if tuple(sorted(init_clause)) == clause_tuple:
            return "Initial State"
    
    # Check goal state clauses
    for goal_clause in kb.goals:
        if tuple(sorted(goal_clause)) == clause_tuple:
            return "Goal State"
    
    # Check precondition clauses
    for pre_clause in kb.preconditions:
        if tuple(sorted(pre_clause)) == clause_tuple:
            return "Precondition"
    
    # Check add effect clauses
    for add_clause in kb.add_effects:
        if tuple(sorted(add_clause)) == clause_tuple:
            return "Add Effect"
    
    # Check delete effect clauses
    for del_clause in kb.del_effects:
        if tuple(sorted(del_clause)) == clause_tuple:
            return "Delete Effect"
    
    # Check frame axiom clauses
    for frame_clause in kb.frame_axioms:
        if tuple(sorted(frame_clause)) == clause_tuple:
            return "Explanatory Frame Axiom"
    
    # Check execution semantics clauses if they exist
    if hasattr(kb, 'excls'):
        for excl_clause in kb.excls:
            if tuple(sorted(excl_clause)) == clause_tuple:
                return "Action Exclusion"
    
    return "Unknown Type"

# explanation_clauses = explanation(KBa.all_formulae(), q)
# print("Explanation:", explanation_clauses)
# print("\nTranslated explanation:")
# for i, clause in enumerate(explanation_clauses):
#     translation = translate_clauses_to_english([clause], kba_vars)[0]
#     formula_type = identify_formula_type(clause, KBa)
#     print(f"{i+1}. Formula: {clause}")
#     print(f"   Type: {formula_type}")
#     print(f"   Translation: {translation}")

mr_clauses = model_reconciliation(KBa.all_formulae(), KBh.all_formulae(), q)
print("\nModel Reconciliation:", mr_clauses)
print("\nTranslated model reconciliation:")
for i, clause in enumerate(mr_clauses):
    translation = translate_clauses_to_english([clause], kba_vars)[0]
    formula_type = identify_formula_type(clause, KBa)
    print(f"{i+1}. Formula: {clause}")
    print(f"   Type: {formula_type}")
    print(f"   Translation: {translation}")





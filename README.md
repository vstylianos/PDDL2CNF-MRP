# PDDL2CNF-MRP: Model Reconciliation in Planning

This repository contains implementation of Model Reconciliation in planning using knowledge bases compiled from PDDL to CNF.

## Requirements

- Python 3.8 or higher
- Dependencies listed in `requirements.txt`

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/PDDL2CNF-MRP.git
cd PDDL2CNF-MRP
```

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

3. (Optional) If you're using Anaconda, you can create a new environment:
```bash
conda create -n planning python=3.9
conda activate planning
pip install -r requirements.txt
```

## Usage

The main entry point is `main.py`. It demonstrates model reconciliation for a blocks world planning problem:

```bash
python main.py
```

The script performs the following operations:
1. Reads PDDL domain and problem files
2. Encodes planning problems to CNF
3. Creates a query 
4. Computes explanations and model reconciliation

## File Structure

- `main.py`: Main script demonstrating model reconciliation
- `algorithms.py`: Implementation of core algorithms (skeptical entailment, explanation, model reconciliation)
- `planning_utils/`: Utilities for planning and encoding
  - `CNF_Encoder.py`: Encoder for agent's knowledge base
  - `CNF_Encoder_KBh.py`: Encoder for human's knowledge base
  - `util.py`: Utility functions
- `instances/`: PDDL domain and problem files

## How It Works

The system works by:
1. Encoding PDDL planning problems to CNF formulas
2. Computing skeptical entailment to check if a query is entailed
3. Finding minimal explanations when query entailment differs between agent and human
4. Translating CNF clauses to readable English explanations

## License

[Your License] 
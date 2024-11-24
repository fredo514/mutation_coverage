import json
import argparse
import sqlite3
import json

def detect_equivalent_mutants(mull_report_path, output_path):
    """Iterates through Mull's surviving mutants and checks equivalence with KLEE."""
    with open(mull_report_path, 'r') as file:
        mutation_report = json.load(file)

    equivalent_mutants = []
    
    for file in mutation_report['files']:
        print('Testing {file}')
        
        # Find surviving mutants
        surviving_mutants = []
        for mutant in mutation_report['files'][file]['mutants']:
            if mutant['status'] == 'Survived':
                surviving_mutants.append(mutant)

        for mutant in surviving_mutants:
            print('Testing {mutant}')

            # Run test executable to confirm survival
            # Run KLEE on the mutated program
            # Save equivalent mutants to output file

    # apply patch

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Prune Equivalent Mutants")

    parser.add_argument('--mull-report', required=True, help="Path to Mull mutations.json report")
    parser.add_argument('--output', required=True, help="Output file for non-equivalent mutants")

    args = parser.parse_args()

    # con = sqlite3.connect("1732410135.sqlite")
    # cur = con.cursor()
    # for row in cur.execute('SELECT * FROM mutant;'):
    #     print(row)

    # with open('1732409981.json') as f:
    #     d = json.load(f)
    #     print(d)

    detect_equivalent_mutants(args.mull_report, args.output)
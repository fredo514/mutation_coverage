import json
import argparse

def detect_equivalent_mutants(mull_report_path, test_executable, output_path):
    """Iterates through Mull's surviving mutants and checks equivalence with KLEE."""

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Prune Equivalent Mutants")

    parser.add_argument('--mull-report', required=True, help="Path to Mull mutations.json report")
    parser.add_argument('--output', required=True, help="Output file for non-equivalent mutants")

    args = parser.parse_args()

    detect_equivalent_mutants(args.mull_report, args.test_executable, args.output)